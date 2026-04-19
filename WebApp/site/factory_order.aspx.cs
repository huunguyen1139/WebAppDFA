using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using System.Web.UI.HtmlControls;
using System.Drawing;
using DevExpress.Web.Internal.XmlProcessor;
using DevExpress.Web;
using DevExpress.RichEdit.Export;
using WebApp.site;

namespace WebApplication2
{
    public partial class factory_order : System.Web.UI.Page
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";            
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            cbLastUpdateInfo.InputAttributes["class"] = "form-check-input ";
            cbOrderedAmount.InputAttributes["class"] = "form-check-input";
            cbProjectAmount.InputAttributes["class"] = "form-check-input";
            cbRemark.InputAttributes["class"] = "form-check-input";
            cbShowAllRecord.InputAttributes["class"] = "form-check-input";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            } 

            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở Factory Order List");
                
            }
            LoadFactoryOrderListToControl();            
            gridFactoryOrder.DataBind();
            ShowOrHideColumns();
        }

        private void LoadFactoryOrderListToControl()
        {
            try
            {                
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL($"EXEC [ALL_FactoryAndSiteOrder] 1, '', '{Session["userid"]?.ToString() ?? ""}', 0");
                gridFactoryOrder.DataSource = dt;
                
                gridFactoryOrder.DataBind();
                gridFactoryOrder.DataColumns["Customer"].Visible = false;
                gridFactoryOrder.DataColumns["Amount"].Visible = false;
                gridFactoryOrder.DataColumns["Currency"].Visible = false;
                gridFactoryOrder.DataColumns["AllocationFor"].Visible = false;
                gridFactoryOrder.DataColumns["ExternalNo"].Visible = false;


                gridFactoryOrder.DataColumns["TotalAmount"].PropertiesEdit.DisplayFormatString = "#,##0";
                foreach (GridViewDataColumn cl in gridFactoryOrder.DataColumns)
                {
                    cl.CellStyle.Wrap = DevExpress.Utils.DefaultBoolean.False;
                    cl.Width = GetColumnWidth(cl.FieldName);
                }
              

            }
            catch { }
        }

        private Unit GetColumnWidth(string columnName)
        {
            switch (columnName)
            {
                case "ProjectCode":
                    return Unit.Pixel(140);
                case "OrderNo":
                    return Unit.Pixel(180);
                case "ExternalNo":
                    return Unit.Pixel(180);

                case "Customer":
                    return Unit.Pixel(120);

                case "CustomerName":
                    return Unit.Pixel(550);

                case "Site Remark":
                case "Remark":
                    return Unit.Pixel(550);

                case "Amount":
                case "TotalAmount":
                    return Unit.Pixel(150);

                case "Status":
                case "AllocationFor":
                    return Unit.Pixel(120);

                case "LastUpdatedUser":
                    return Unit.Pixel(230);

                case "LastUpdatedDate":
                    return Unit.Pixel(200);

                default:
                    return Unit.Pixel(120);
            }
        }

        protected void gridFactoryOrder_CustomColumnDisplayText(object sender, DevExpress.Web.ASPxGridViewColumnDisplayTextEventArgs e)
        {
            try
            {   
                
                e.Column.PropertiesEdit.EncodeHtml = false;
                if (e.Column.FieldName == "OrderNo")
                {                    
                    e.DisplayText = ($"<a href='factory_order_detail?no={e.Value}'>{e.Value.ToString()}</a>");
                }
            }
            catch { }
        }

        private void ShowOrHideColumns()
        {
            try
            {
                gridFactoryOrder.DataBind();
                //gridFactoryOrder.DataColumns["Amount"].Visible = cbProjectAmount.Checked;
                // gridFactoryOrder.DataColumns["Currency"].Visible = cbProjectAmount.Checked;
                gridFactoryOrder.DataColumns["TotalAmount"].Visible = cbProjectAmount.Checked;
                gridFactoryOrder.DataColumns["Remark"].Visible = cbRemark.Checked;
                gridFactoryOrder.DataColumns["LastUpdatedUser"].Visible = cbLastUpdateInfo.Checked;
                gridFactoryOrder.DataColumns["LastUpdatedDate"].Visible = cbLastUpdateInfo.Checked;

                gridFactoryOrder.SettingsPager.Mode = cbShowAllRecord.Checked ? GridViewPagerMode.ShowAllRecords : GridViewPagerMode.ShowPager;
                gridFactoryOrder.DataBind();

                foreach (GridViewDataColumn cl in gridFactoryOrder.DataColumns)
                {
                    cl.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
                }

            }
            catch { }
        }

        protected void cbProjectAmount_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbOrderedAmount_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbRemark_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbLastUpdateInfo_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void gridFactoryOrder_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            //if (e.DataColumn.FieldName != "OrderNo") return;
            if (e.DataColumn.FieldName == "OrderNo")
            {
                string val = e.CellValue as string ?? "";
                e.Cell.Controls.Clear();

                if (val.Length == 18)
                {
                    var link = new DevExpress.Web.ASPxHyperLink
                    {
                        Text = val,
                        NavigateUrl = $"factory_order_detail?no={Server.UrlEncode(val)}"
                    };
                    e.Cell.Controls.Add(link);
                }
                else
                {
                    e.Cell.Controls.Add(new Literal { Text = Server.HtmlEncode(val) });
                }
            }

            if (e.DataColumn.FieldName == "Status")
            {
                string status = e.CellValue?.ToString();

                switch (status)
                {
                    case "Open":
                        e.Cell.BackColor = System.Drawing.Color.LightGray;
                        e.Cell.ForeColor = System.Drawing.Color.Black;
                        break;

                    case "Released":
                        e.Cell.BackColor = System.Drawing.Color.LightBlue;
                        e.Cell.ForeColor = System.Drawing.Color.Black;
                        break;

                    case "Pending":
                        e.Cell.BackColor = System.Drawing.Color.Khaki;
                        e.Cell.ForeColor = System.Drawing.Color.Black;
                        break;

                    case "Processing":
                        e.Cell.BackColor = System.Drawing.Color.Orange;
                        e.Cell.ForeColor = System.Drawing.Color.White;
                        break;

                    case "Completed":
                        e.Cell.BackColor = System.Drawing.Color.LightGreen;
                        e.Cell.ForeColor = System.Drawing.Color.Black;
                        break;
                }
            }
        }
    }
}
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
    public partial class factory_order_completed : System.Web.UI.Page
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
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL($"EXEC [ALL_FactoryAndSiteOrder] 1, '', '{Session["userid"]?.ToString() ?? ""}', 1");
                gridFactoryOrder.DataSource = dt;
                
                gridFactoryOrder.DataBind();
                gridFactoryOrder.DataColumns["Customer"].Visible = false;
                gridFactoryOrder.DataColumns["Amount"].Visible = false;
                gridFactoryOrder.DataColumns["Currency"].Visible = false;

                gridFactoryOrder.DataColumns["TotalAmount"].PropertiesEdit.DisplayFormatString = "#,##0";
                foreach (GridViewDataColumn cl in gridFactoryOrder.DataColumns)
                {
                    cl.CellStyle.Wrap = DevExpress.Utils.DefaultBoolean.False;
                }
              

            }
            catch { }
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
            if (e.DataColumn.FieldName != "OrderNo") return;

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
    }
}
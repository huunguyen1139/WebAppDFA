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

namespace WebApp.site
{
    public partial class blanket_factory_order : System.Web.UI.Page
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
            
            HtmlContainerControl huu = (HtmlContainerControl)Master.FindControl("MasterBody");
            huu.Attributes.Add("style", "background-color:#F1F1F1;");
            //CreateDynamicTableRow();
           

            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở Blanket Factory Order List");
                
            }
            LoadFactoryBlanketOrderListToControl();
            
            gridFactoryOrder.DataBind();
            ShowOrHideColumns();
        }

        private void LoadFactoryBlanketOrderListToControl()
        {
            try
            {
               

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL($"[ALL_BlanketFactoryAndSiteOrder] 1, '{Session["userid"]?.ToString() ?? ""}'");
                gridFactoryOrder.DataSource = dt;
                
                gridFactoryOrder.DataBind();
                gridFactoryOrder.DataColumns["Customer"].Visible = false;
                gridFactoryOrder.DataColumns["Amount"].Visible = false;
                gridFactoryOrder.DataColumns["Currency"].Visible = false;
                gridFactoryOrder.DataColumns["ExternalNo"].Visible = false;
                gridFactoryOrder.DataColumns["AllocationFor"].Visible = false;
                gridFactoryOrder.DataColumns["ProjectAmount"].PropertiesEdit.DisplayFormatString = "#,##0";
                gridFactoryOrder.DataColumns["OrderedAmount"].PropertiesEdit.DisplayFormatString = "#,##0";
                foreach (GridViewDataColumn cl in gridFactoryOrder.DataColumns)
                {
                    cl.CellStyle.Wrap = DevExpress.Utils.DefaultBoolean.False;
                    cl.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
                }
              

            }
            catch { }
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                
                           
            }
            catch
            { }
        }

        private void CreateDynamicTableRow()
        {            

        } 

        private Color PaintColortoPICell(string Month)
        {
            switch (Month)
            {
                case "01": return Color.Gold;                    
                case "02": return Color.PaleGreen;                   
                case "03": return Color.LightBlue;                    
                case "04": return Color.LightSalmon;                   
                case "05": return Color.SpringGreen;                   
                case "06": return Color.Turquoise;                    
                case "07": return Color.Orange;                   
                case "08": return Color.Gainsboro;
                case "09": return Color.NavajoWhite;                   
                case "10": return Color.LawnGreen;                   
                case "11": return Color.MediumTurquoise;                  
                case "12": return Color.AliceBlue;
            }
            return Color.Transparent;
        }

        private void btn_Click(object sender, EventArgs e)
        {
            try
            {
                
            }
            catch { }
        }
        private string ReturnCssForTop10Target(List<double> listcontrolvalue, double controlvalue)
        {
            int position = listcontrolvalue.Count(x => x > controlvalue) + 1;
            if (position <= 3) return "label label-success";
            if (position <= 6) return "label label-info";
            if (position <= 8) return "label label-warning"; 
            return "label label-danger";
        }
        private string GetActualTarget(string Department, DataTable data)
        {
            try
            {
                for (int i = 0; i < data.Rows.Count; i++)
                {
                    if (data.Rows[i][0].ToString().Equals(Department))
                    {
                        return data.Rows[i][1].ToString();                       
                    }
                }
                return "0";
            }
            catch { return "0"; }
        }

        protected void gridFactoryOrder_CustomColumnDisplayText(object sender, DevExpress.Web.ASPxGridViewColumnDisplayTextEventArgs e)
        {
            try
            {   
                
                e.Column.PropertiesEdit.EncodeHtml = false;
                if (e.Column.FieldName == "OrderNo")
                {                    
                    e.DisplayText = ($"<a href='blanket_factory_order_detail?no={e.Value}'>{e.Value.ToString()}</a>");
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
                //gridFactoryOrder.DataColumns["Currency"].Visible = cbProjectAmount.Checked;
                gridFactoryOrder.DataColumns["ProjectAmount"].Visible = cbProjectAmount.Checked;
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

            if (val.Length == 13)
            {
                var link = new DevExpress.Web.ASPxHyperLink
                {
                    Text = val,
                    NavigateUrl = $"blanket_factory_order_detail?no={Server.UrlEncode(val)}"
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
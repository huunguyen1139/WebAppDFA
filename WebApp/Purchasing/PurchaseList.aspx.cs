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

namespace WebApp.Purchase
{
    public partial class PurchaseList : SecurePage
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
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở Purchase Order List");
                
            }
            LoadTenderOrderListToControl();            
            gridTenderOrder.DataBind();
            ShowOrHideColumns();
        }

        private void LoadTenderOrderListToControl()
        {
            try
            { 
                string Prefix = Request["region"]?.ToString()?? "";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL($"EXEC ALL_PO_GET_PURCHASE_HEADER @PONo"
                    , new List<string>() { "@PONo"}
                    , new List<object>() { Prefix});
                gridTenderOrder.DataSource = dt;
                
                gridTenderOrder.DataBind();

                //gridTenderOrder.DataColumns["Customer"].Visible = false;
                //gridTenderOrder.DataColumns["Amount"].Visible = false;
                //gridTenderOrder.DataColumns["Currency"].Visible = false;
                gridTenderOrder.DataColumns["TotalAmount"].PropertiesEdit.DisplayFormatString = "#,##0";
                gridTenderOrder.DataColumns["TotalVAT"].PropertiesEdit.DisplayFormatString = "#,##0";
                gridTenderOrder.DataColumns["TotalAmountInclVAT"].PropertiesEdit.DisplayFormatString = "#,##0";
                foreach (GridViewDataColumn cl in gridTenderOrder.DataColumns)
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

        

      

    

        private void ShowOrHideColumns()
        {
            try
            {
                gridTenderOrder.DataBind();
                //gridTenderOrder.DataColumns["Amount"].Visible = cbProjectAmount.Checked;
                //gridTenderOrder.DataColumns["Currency"].Visible = cbProjectAmount.Checked;
                //gridTenderOrder.DataColumns["ProjectAmount"].Visible = cbProjectAmount.Checked;
                //gridTenderOrder.DataColumns["Remark"].Visible = cbRemark.Checked;
                //gridTenderOrder.DataColumns["LastUpdatedUser"].Visible = cbLastUpdateInfo.Checked;
                //gridTenderOrder.DataColumns["LastUpdatedDate"].Visible = cbLastUpdateInfo.Checked;              
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

        protected void gridTenderOrder_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName != "No_") return;

            string val = e.CellValue as string ?? "";
            e.Cell.Controls.Clear();

            if (val.Length <= 16)
            {
                var link = new DevExpress.Web.ASPxHyperLink
                {
                    Text = val,
                    NavigateUrl = $"PurchaseHeader?OrderNo={Server.UrlEncode(val)}", 
                    Target= "_blank"
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
using DevExpress.Web;
using Library;
using Newtonsoft.Json.Linq;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.production
{
    public partial class ReceiptGoods : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            if (!IsPostBack)
            {
                
            }
            LoadGridData();
        }

        private void LoadGridData()
        {
            string toDepartment = Session["userid"]?.ToString();

            string sql = @"
                SELECT RowIndex, ProdOrderNo, po.[Source No_] ItemCode, ci.FullName, Department, ToDepartment, cp.Quantity,
                RemainQuantity, ProdOrderDate, cp.isReceipt, cp.UpdatedUser
                FROM Custom_ProductionOutputDetail cp
                LEFT JOIN [LIVE_ALLIANCE_90$Production Order] po ON po.No_ = cp.ProdOrderNo
                LEFT JOIN Custom_ItemInformation ci ON ci.ItemCode = po.[Source No_]
                WHERE isReceipt = 0 AND ToDepartment = @ToDepartment";

            List<string> users = new List<string>() { "20276", "XM71532", "20075" };
            if (users.IndexOf(toDepartment) >= 0) sql = @"
                SELECT RowIndex, ProdOrderNo, po.[Source No_] ItemCode, ci.FullName, Department, ToDepartment, cp.Quantity,
                RemainQuantity, ProdOrderDate, cp.isReceipt, cp.UpdatedUser
                FROM Custom_ProductionOutputDetail cp
                LEFT JOIN [LIVE_ALLIANCE_90$Production Order] po ON po.No_ = cp.ProdOrderNo
                LEFT JOIN Custom_ItemInformation ci ON ci.ItemCode = po.[Source No_]
                WHERE isReceipt = 0";

            var parameters = new System.Collections.Generic.List<string> { "@ToDepartment" };
            var values = new System.Collections.Generic.List<object> { toDepartment };

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, parameters, values);
            gridReceiptGoods.DataSource = dt;
            gridReceiptGoods.DataBind();
        }
        protected void gridReceiptGoods_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parameters = e.Parameters.Split('|');
            bool success = true;
            string message = "";

            try
            {
                if (parameters[0] == "receipt" && int.TryParse(parameters[1], out int rowIndex))
                {
                    ProcessReceipt(rowIndex);
                    message = "Row receipted successfully.";
                }
                else if (parameters[0] == "batchReceipt")
                {
                    var selectedKeys = gridReceiptGoods.GetSelectedFieldValues("RowIndex");

                    // Parallel batch processing
                    System.Threading.Tasks.Parallel.ForEach(selectedKeys, key =>
                    {
                        int selectedRowIndex = Convert.ToInt32(key);
                        ProcessReceipt(selectedRowIndex);
                    });
                    message = $"{selectedKeys.Count} rows processed successfully.";
                }
            }
            catch (Exception ex)
            {
                success = false;
                message = "Error: " + ex.Message;
            }

            // Send result back to client
            gridReceiptGoods.JSProperties["cpResult"] = success ? "success|" + message : "error|" + message;

            // Refresh grid
            LoadGridData();
        }

        private void ProcessReceipt(int rowIndex)
        {
            string sql = "EXEC ALL_ReceiptGoodsDetailByRowIndex @RowIndex";
            var paramNames = new System.Collections.Generic.List<string> { "@RowIndex" };
            var paramValues = new System.Collections.Generic.List<object> { rowIndex };

            SQRLibrary.ExecuteSQL(sql, paramNames, paramValues);
        }

    }
}
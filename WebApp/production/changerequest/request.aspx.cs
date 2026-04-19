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
using Library;
using System.IO;
using System.Windows.Forms;

namespace WebApp.production
{
    public partial class request : System.Web.UI.Page
    {
        private string ItemCode = "";
        protected void Page_Init(object sender, EventArgs e)
        {
            
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
                txtRegisterDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtRequiredDate.Text = DateTime.Now.ToString("yyyy-MM-dd");                
                LoadPIListtoControl();
            }
            
           
        }

        private void LoadPIListtoControl()
        {
            try
            {
                slPI.Items.Clear();
                slPI.Items.Add(new ListItem(" - Chọn PI - ", "0"));
                string sql = "select distinct [Description 2] as [PI] from [LIVE_ALLIANCE_90$Production Order] where [Description 2]<>'' AND [Status] in ('3') AND LEN([Description 2])<=20 ORDER BY [Description 2] desc";
                System.Data.DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql);
                Session["PIList"] = dt;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    slPI.Items.Add(new ListItem(dt.Rows[i][0].ToString(), dt.Rows[i][0].ToString()));
                }
            }
            catch { }
        } 
          
        private bool DataIsValid()
        {
            bool result = true;
            divMessage.Visible = false;
            try
            {  

                if (slPI.SelectedValue.Equals("0") || ddProductName.SelectedValue.Equals("0"))
                {
                    lbErrorDescription.Text = "Vui lòng chọn đơn hàng và tên sản phẩm!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }

                if (SQRLibrary.ConvertToInt(txtChangeDescription.Text.Trim().Length) <= 0)
                {
                    lbErrorDescription.Text = "Vui lòng nhập diễn giải!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }

                if (SQRLibrary.ConvertToDecimal(txtTotalQuantity.Text) <= 0)
                {
                    lbErrorDescription.Text = "Vui lòng nhập tổng số lượng!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }               
            }
            catch { }
            return result;
        }
        protected void btnSubmit_Click(object sender, EventArgs e)           
        {
            try
            {
                if (!DataIsValid()) return;

                DataTable NoSeries = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT FORMAT(ISNULL(MAX(RIGHT(RequestID, 5))+1, 1),'0000#')  FROM [PRODUCTION_ChangeRequest] where LEFT(RequestID,4)='CR" + DateTime.Now.Year.ToString().Substring(2) + "'");
                string DocumentNo = "CR" + DateTime.Now.Year.ToString().Substring(2) + "_" + NoSeries.Rows[0][0].ToString();

                InsertProductionChangeRequest(DocumentNo, txtRegisterDate.Text, slPI.SelectedValue, ViewState["Description"]?.ToString() ?? "", ddProductName.SelectedValue
                    , ViewState["ItemCode"]?.ToString()?? "", SQRLibrary.ConvertToDecimal(txtTotalQuantity.Text), SQRLibrary.ConvertToInt(txtPrice.Text)
                    , txtChangeDescription.Text, 1, Session["userid"]?.ToString(), txtRequiredDate.Text, SQRLibrary.ConvertToInt(ddPriority.SelectedValue));

                lbErrorDescription.Text = "Đã cập nhật yêu cầu thay đổi <a href='requestview?id=" + DocumentNo + "' target='_blank'>" + DocumentNo + "</a> lên hệ thống!";
                divMessage.Attributes["class"] = "alert alert-success";
                divMessage.Visible = true;

            }
            catch { }
           
        }

        public void InsertProductionChangeRequest(
                string requestID,
                string requestDate,
                string piNo,
                string productName,
                string prodOrderNo,
                string productCode,
                decimal totalQuantity,
                decimal price,
                string changeDescription,
                int status,
                string submitBy,   
                string requiredDate,
                int? priority // nullable
                )
     {
            string sql = @"
                    INSERT INTO PRODUCTION_ChangeRequest (
                        RequestID, RequestDate, PINo, ProductName, ProdOrderNo, ProductCode,
                        TotalQuantity, Price, ChangeDescription, Status,
                        SubmitBy, SubmitDate, RequiredDate, Priority
                    )
                    VALUES (
                        @RequestID, @RequestDate, @PINo, @ProductName, @ProdOrderNo, @ProductCode,
                        @TotalQuantity, @Price, @ChangeDescription, @Status,
                        @SubmitBy, GETDATE(),@RequiredDate, @Priority
                    )";

            var paramNames = new List<string>
                    {
                        "@RequestID", "@RequestDate", "@PINo", "@ProductName", "@ProdOrderNo", "@ProductCode",
                        "@TotalQuantity", "@Price", "@ChangeDescription", "@Status",
                        "@SubmitBy", "@RequiredDate", "@Priority"
                    };

            var paramValues = new List<object>
                    {
                        requestID, requestDate, piNo, productName, prodOrderNo, productCode,
                        totalQuantity, price, changeDescription, status,
                        submitBy, requiredDate, (object?)priority ?? DBNull.Value
                    };

            SQRLibrary.ExecuteSQL_mrp(sql, paramNames, paramValues);
        }

        protected void slPI_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sql = "select No_, Description, [Source No_], format(Quantity, '#0.#') as Quantity from [LIVE_ALLIANCE_90$Production Order] where [Description 2]=@PI";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@PI" }, new List<object>() { slPI.SelectedValue });
                ViewState["ProductionOrderListbyPI"] = dt;
                ddProductName.Items.Clear(); ddProductName.Items.Add(new ListItem("- Select Item", "0"));

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    ddProductName.Items.Add(new ListItem(dt.Rows[i]["Source No_"].ToString() + " - " + dt.Rows[i]["Description"].ToString() + " (" + dt.Rows[i]["No_"].ToString() + ")", dt.Rows[i]["No_"].ToString()));
                }

                //ddItemCode_SelectedIndexChanged(ddItemCode, e);
            }
            catch { }
        }

        protected void ddProductName_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = (DataTable)ViewState["ProductionOrderListbyPI"];
                DropDownList dd = sender as DropDownList;

                foreach (DataRow r in dt.Rows)
                {
                    if (r["No_"].ToString().Equals(dd.SelectedValue))
                    {
                        txtTotalQuantity.Text = r["Quantity"].ToString();
                        ViewState["ItemCode"] = r["Source No_"].ToString();
                        ViewState["Description"] = r["Description"].ToString();
                        break;
                    }
                }
            }
            catch { }
        }
      
        private DataTable ConvertTabletoDataTable(Table tb)
        {
            DataTable result = new DataTable();
            try 
            {
                TableRow tbheaderrow = tb.Rows[0];
                foreach (TableCell tc in tbheaderrow.Cells)
                {
                    result.Columns.Add(tc.Text);
                }

                for (int i = 1; i < tb.Rows.Count; i++)
                {
                    result.Rows.Add();
                     for (int j=0; j < tb.Rows[i].Cells.Count; j++)
                     {
                         result.Rows[i - 1][j] = tb.Rows[i].Cells[j].Text;
                     }                  

                }
            }
            catch {}
            return result;
        }
    }
}
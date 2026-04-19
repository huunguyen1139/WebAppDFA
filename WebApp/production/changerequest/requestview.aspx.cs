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

namespace WebApp.production
{
    public partial class requestview : System.Web.UI.Page
    {
     
        protected void Page_Init(object sender, EventArgs e)
        {
            
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
           
            if (!IsPostBack)
            {   
                if (Request["id"] != null)
                {
                    FillDataToControls(Request["id"]?.ToString() ?? "");
                    LoadOutputHistoryToRepeater(Request["id"]?.ToString() ?? "");
                    LoadOutputDetailToTable(Request["id"]?.ToString() ?? "");
                    //ViewState["DefectView_Responsive"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_DefectiveList] where ReportID=@ReportID"
                    //, new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                    //LoadResponsiveToTable();

                    //ViewState["DefectView_ApprovalEntry"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_ApprovalEntry] where DocumentNo=@ReportID"
                    //, new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                    //LoadDefectApprovalEntry();
                }
            }
            else
            {
                //LoadResponsiveToTable();
                //LoadDefectApprovalEntry();
            }
           
        }       
       

        private void FillDataToControls(string RequestID)
        {
            try
            {
                DataTable ChangRequestHeader = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC [ALL_PRODUCTION_ChangeRequest] @RequestID = @RequestID"
                    , new List<string>() { "@RequestID" }, new List<object>() { Request["id"]?.ToString()??"" });
                if (ChangRequestHeader.Rows.Count > 0)
                {
                    DataRow r = ChangRequestHeader.Rows[0];
                    txtRegisterDate.Text = r["RequestDate"].ToString();
                    txtPI.Text = r["PINo"].ToString();
                    txtProductName.Text = r["ProductName"].ToString();
                    txtProductName.ToolTip = r["ProdOrderNo"].ToString();
                    txtTotalQuantity.Text = SQRLibrary.ConvertToInt(r["TotalQuantity"]).ToString("#,##0.##");                   
                    txtChangeDescription.Text = r["ChangeDescription"].ToString();                    
                    txtRequiredDate.Text = r["RequiredDate"].ToString();
                    txtPrice.Text = SQRLibrary.ConvertToInt(r["Price"]).ToString("#,##0.##");
                    
                    string status = "";
                    switch (r["Priority"].ToString())
                    {
                        case "0": txtPriority.Text = "Normal"; break;
                        case "1": txtPriority.Text = "High Priority"; break;
                        case "2": txtPriority.Text = "Urgent"; break;                       
                    }

                    switch (r["Status"].ToString())
                    {
                        case "0": status = "Open"; break;
                        case "1": status = "Approved"; break;
                        case "2": status = "Pending"; break;
                        case "3": status = "Rejected"; break;
                        case "4": status = "Completed"; break;
                        case "99": status = "Cancelled"; break;
                    }
                    lbStatus.Text = status;
                    
                }
            }
            catch { }
        }

        private void LoadOutputHistoryToRepeater(string RequestID)
        {
            try
            {
                DataTable dt = OutputHistoryByRequestID(RequestID);
                rptDepartmentOutput.DataSource = dt;
                rptDepartmentOutput.DataBind();
            }
            catch { }
        }

        private void LoadOutputDetailToTable(string RequestID)
        {
            try
            {
                string sql = @"
                SELECT a.*, b.ShowIndex FROM PRODUCTION_ChangeRequestOutput a
                INNER JOIN [POR_ManHourUnitCost] b ON a.Department = b.Department
                WHERE RequestID = @RequestID
                ORDER BY b.ShowIndex ";

                gvOutputDetail.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp(sql
                    , new List<string>() { "@RequestID"}
                    , new List<object> () { RequestID});

                gvOutputDetail.DataBind();
            }
            catch { }
        }
        private DataTable OutputHistoryByRequestID(string RequestID)
        {
            try
            {
                string sql = @"
                WITH OutputHistory AS
                    (
                        SELECT o.RequestID, o.Department,            
                            SUM(o.Quantity) AS TotalQuantity			
                        FROM
                            PRODUCTION_ChangeRequestOutput o
		                INNER JOIN
				                (SELECT DISTINCT
					                 RequestID					
				                 FROM PRODUCTION_ChangeRequest
				                 WHERE
					                 RequestID = @RequestID					
				                ) p
				                ON o.RequestID = p.RequestID
				
                        GROUP BY o.RequestID, o.Department
                    )
                SELECT	a.[Department]
		                , FORMAT(ISNULL(b.TotalQuantity, 0), '#0.##') FinishedQty
		                , FORMAT(ISNULL(r.TotalQuantity, 0), '#0.##') TotalQuantity
		                , FORMAT(ISNULL(100 * ISNULL(b.TotalQuantity, 0) / NULLIF(r.TotalQuantity, 0), 0), '#0') CompletedPercent
		                ,[ShowIndex]

                FROM [POR_ManHourUnitCost] a
                LEFT JOIN OutputHistory b ON a.Department = b.Department
                LEFT JOIN PRODUCTION_ChangeRequest r ON r.RequestID = @RequestID
                WHERE a.Department <> 'WO'
                ORDER BY a.ShowIndex ";

                return SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@RequestID" }, new List<object> { RequestID });
            }
            catch { return null; }
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


        private void ShowInformationLabel(string Message, bool IsWarning = false)
        {
            lbErrorDescription.Text = Message;
            divMessage.Attributes["class"] = IsWarning ? "alert alert-danger" : "alert alert-success";
            divMessage.Visible = true;
        }

        protected void gvOutputDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    //DateTime orderDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "PostingDate"));
                    //e.Row.Cells[3].Text = orderDate.ToString("dd-MM-yyyy");

                    //decimal quantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity"));
                    //e.Row.Cells[4].Text = quantity.ToString("#,##0.##");

                    //decimal price = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "SalesPrice"));
                    //e.Row.Cells[5].Text = price.ToString("#,##0");

                    //decimal Percent = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "PC"));
                    //e.Row.Cells[6].Text = Percent.ToString("P0");

                    //decimal Revenue = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Revenue"));
                    //e.Row.Cells[7].Text = Revenue.ToString("#,##0");
                }
            }
            catch { }
        }
    }
}
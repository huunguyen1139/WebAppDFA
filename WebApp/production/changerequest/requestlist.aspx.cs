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
using System.Globalization;

namespace WebApp.production
{
    public partial class requestlist : System.Web.UI.Page
    {
     
        protected void Page_Init(object sender, EventArgs e)
        {
            
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                //string url = HttpContext.Current.Request.Url.AbsolutePath;
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
            
            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang Production Change Request");
                DateTime firstdayofmonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                txtFromDate.Text = firstdayofmonth.ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                
               
            }
            CreateDynamicTableRow();               
           
        }
        void btn_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string RowIndex = btn.ID.Substring(9);
                SQRLibrary.ExecuteSQL("delete Custom_ProductionOutputDetail where RefMes=@RequestID", new List<string>() { "@RequestID" }, new List<object>() { RowIndex });
                SQRLibrary.ExecuteSQL_mrp("delete [PRODUCTION_ChangeRequestOutput] where RequestID=@RequestID delete [PRODUCTION_ChangeRequest] where RequestID=@RequestID and Status in (0,1,2)", new List<string>() { "@RequestID" }, new List<object>() { RowIndex });
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Đã xóa thành công!');", true);

                CreateDynamicTableRow();
            }
            catch { }
        }

        void btnComplete_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string RowIndex = btn.ID.Substring(11);
                SQRLibrary.ExecuteSQL_mrp("update [PRODUCTION_ChangeRequest] SET [Status]=4 where RequestID=@RequestID", new List<string>() { "@RequestID" }, new List<object>() { RowIndex });
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Cập nhật thành công!');", true);

                CreateDynamicTableRow();
            }
            catch { }
        }


        private DataTable LoadChangeRequestList()
        {
            DataTable result = new DataTable();
            try
            {
                string sql = "EXEC [ALL_PRODUCTION_ChangeRequest] @RequestID, @ProdOrderNo, @FromDate, @ToDate, @Status, @PINo";                                
                List<string> list = new List<string>() {"@RequestID", "@ProdOrderNo", "@FromDate", "@ToDate", "@Status", "@PINo" };
                
                if (Request["prod"] != null)
                {             
                    result = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC [ALL_PRODUCTION_ChangeRequest] @ProdOrderNo = @ProdOrderNo"
                        , new List<string>() { "@ProdOrderNo" }
                        , new List<object>() { Request["prod"].ToString() });
                    lbProductionChangeRequest.Text = "Production Change Request: " + Request["prod"].ToString();
                }
                else if (Request["des"] != null)
                {
                    result = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC [ALL_PRODUCTION_ChangeRequest] @ProdOrderNo = @ProdOrderNo"
                        , new List<string>() { "@ProdOrderNo" }
                        , new List<object>() { Request["des"].ToString() });
                    lbProductionChangeRequest.Text = "Production Change Request: " + Request["prod"].ToString();
                }
                else if ((Request["type"] != null)&&((Request["dept"] != null)))
                {
                    sql = SQLString_GetIssueListByDepartment(Request["dept"].ToString());
                    result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                    lbProductionChangeRequest.Text = "BBCL: pending at " + Request["dept"].ToString();
                }
                else result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql
                    , list, new List<object>() { "", "", txtFromDate.Text, txtToDate.Text, ddStatus.SelectedValue, "" });
            }
            catch { }
            return result;
        }

        private string SQLString_GetIssueListByDepartment(string department)
        {
            string result = string.Empty;

            switch (department)
            {
                case "WO": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and WO='1'"; break;
                case "RM": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and RM='1' and (WO<>'1')"; break;
                case "FM": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and FM='1' and (RM<>'1')"; break;
                case "AS": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and [AS]='1' and (FM<>'1')"; break;
                case "SA": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and SA='1' and ([AS]<>'1')"; break;
                case "FIN": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and FIN='1' and (SA<>'1')"; break;
                case "IRON": result = "SELECT * FROM [QC_QualityReportHeader] where Status=1 and IRON='1'"; break;
                case "UPH": result = "SELECT * FROM [QC_QualityReportHeader] where Status = 1 and UPH = '1' and((WO <> '1') AND(RM <> '1') AND(FM <> '1') AND([AS] <> '1') AND(SA <> '1') AND(FIN <> '1') AND(IRON <> '1'))"; break;
                case "FIT": result = "SELECT * FROM [QC_QualityReportHeader] where Status = 1 and FIT = '1' and((WO <> '1') AND(RM <> '1') AND(FM <> '1') AND([AS] <> '1') AND(SA <> '1') AND(FIN <> '1') AND(IRON <> '1') AND(UPH <> '1'))"; break;
                case "PAC": result = "SELECT * FROM [QC_QualityReportHeader] where Status = 1 and PAC = '1' and((WO <> '1') AND(RM <> '1') AND(FM <> '1') AND([AS] <> '1') AND(SA <> '1') AND(FIN <> '1') AND(IRON <> '1') AND(UPH <> '1') AND(FIT <> '1'))"; break;

            }

            return result;
        }
        private void CreateDynamicTableRow(bool LoadFromDatabase = false)
        {           
            DataTable dt = LoadChangeRequestList();

            List<string> HideColumnList = new List<string>() {  "SubmitBy" };

            LibraryFunction.LoadDataTableToGridView2(gvChangeRequest, dt, HideColumnList, new List<string>() { "DefectiveDate", "RequiredDate" });
            
            
            
            if (gvChangeRequest.Rows.Count > 0)
            {
                gvChangeRequest.HeaderRow.Cells.Add(new TableCell() { Text = "Action" });
                foreach (GridViewRow row in gvChangeRequest.Rows)
                {
                    //cell number 6 is "Department" , cell 0 is ID or RowIndex
                    TableCell tc = new TableCell();
                    tc.Attributes["style"] = "text-align: center;";
                    LinkButton btn = new LinkButton();
                    btn.Text = "<img src=\"/images/delete_24.png\" title=\"Delete this Request\" alt=\"Delete this Request\">";
                    btn.ID = "btnDelete" + row.Cells[0].Text;
                    btn.Visible = true;
                    btn.OnClientClick = "return confirm('Bạn có chắc chắn muốn xóa request: " + row.Cells[0].Text + "?')";

                    btn.Click += btn_Click;

                    LinkButton btnComplete = new LinkButton();
                    btnComplete.Text = "<img src=\"/images/complete_24.png\" title=\"Completed this Request\" alt=\"Completed this Request\">";
                    btnComplete.ID = "btnComplete" + row.Cells[0].Text;
                    btnComplete.Visible = true;
                    btnComplete.OnClientClick = "return confirm('Bạn có chắc chắn muốn chuyển status sang Completed: " + row.Cells[0].Text + "?')";

                    btnComplete.Click += btnComplete_Click;

                    tc.Controls.Add(btn); tc.Controls.Add(btnComplete);
                    row.Cells.Add(tc);
                }
            }

            FillColorToGridView();
        }

        private void FillColorToGridView()
        {
            try
            {
                if (gvChangeRequest.Rows.Count > 0)
                {
                    List<string> department = new List<string>() { "WO","RM","FM","AS","SA", "SP","FIN","IRON","UPH","FIT", "TU","PAC"};
                    for (int i=0; i< gvChangeRequest.Columns.Count;i++)
                    {
                        DataControlField dtcf = gvChangeRequest.Columns[i];

                        if (dtcf.HeaderText.Equals("RequestID"))
                        {
                            foreach (GridViewRow r in gvChangeRequest.Rows)
                            {
                                r.Cells[i].Text = "<a href='requestview?id=" + r.Cells[i].Text + "' target='_blank'>" + r.Cells[i].Text + "</a>";
                            }
                        }

                        if (dtcf.HeaderText.Equals("RequiredDate"))
                        {
                            DateTime now = DateTime.Today;
                            foreach (GridViewRow r in gvChangeRequest.Rows)
                            {
                                try
                                {
                                    DateTime required_date;
                                    DateTime.TryParseExact(r.Cells[i].Text, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out required_date);
                                    if ((now > required_date) && (r.Cells[i - 2].Text.Equals("Approved")))
                                    {
                                        r.Cells[i].CssClass = "bg-danger text-white";
                                    }
                                }
                                catch { }
                               
                            }
                        }

                        if (dtcf.HeaderText.Equals("Status"))
                        {
                            foreach (GridViewRow r in gvChangeRequest.Rows)
                            {
                                switch (r.Cells[i].Text.ToString())
                                {
                                    case "0":
                                        r.Cells[i].Text = "Open";
                                        break;
                                    case "1":
                                        r.Cells[i].Text = "Approved";                                       
                                        break;
                                    case "2":
                                        r.Cells[i].Text = "Pending";
                                        break;
                                    case "3":
                                        r.Cells[i].Text = "Rejected";
                                        break;
                                    case "4":
                                        r.Cells[i].Text = "Completed";
                                        break;
                                    case "99":
                                        r.Cells[i].Text = "Cancelled";
                                        break;
                                }
                            }
                        }


                        if (dtcf.HeaderText.Equals("Priority"))
                        {
                            foreach (GridViewRow r in gvChangeRequest.Rows)
                            {
                                switch (r.Cells[i].Text.ToString())
                                {
                                    case "0":
                                        r.Cells[i].Text = "Normal";

                                        break;
                                    case "1":
                                        r.Cells[i].Text = "High Priority";
                                        for (int k = 2; k < 8; k++)
                                        {
                                            r.Cells[k].BackColor = Color.Yellow;
                                        }
                                        break;
                                    case "2":
                                        r.Cells[i].Text = "Urgent";
                                        for (int k = 2; k < 8; k++)
                                        {
                                            r.Cells[k].BackColor = Color.Crimson;
                                            r.Cells[k].ForeColor = Color.White;
                                        }
                                        break;
                                   
                                }
                            }
                        }

                        if (department.IndexOf(dtcf.HeaderText) >= 0)
                        {
                            foreach (GridViewRow r in gvChangeRequest.Rows)
                            {
                                if (SQRLibrary.ConvertToDecimal(r.Cells[i].Text) >= SQRLibrary.ConvertToDecimal(r.Cells[6].Text))
                                {
                                    r.Cells[i].CssClass = "text-bg-success text-center";
                                } else r.Cells[i].CssClass = "text-bg-warning text-center";                                
                            }
                        }
                    }
                }
            }
            catch { }
        }

        protected void txtFromDate_TextChanged(object sender, EventArgs e)
        {
            //CreateDynamicTableRow();
        }

        protected void txtToDate_TextChanged(object sender, EventArgs e)
        {
            //CreateDynamicTableRow();
        }

        protected void ddMonthYear_SelectedIndexChanged(object sender, EventArgs e)
        {

        }        

        protected void txtProductDes_TextChanged(object sender, EventArgs e)
        {
            CreateDynamicTableRow();
        }

        protected void gvChangeRequest_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    DateTime orderDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "RequestDate"));
                    e.Row.Cells[1].Text = orderDate.ToString("dd-MM-yyyy");

                    decimal quantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "TotalQuantity"));
                    e.Row.Cells[6].Text = quantity.ToString("#,##0.##");
                   
                    decimal price = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Price"));
                    e.Row.Cells[7].Text = price.ToString("#,##0");

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
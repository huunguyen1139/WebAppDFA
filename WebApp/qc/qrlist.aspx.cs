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

namespace WebApplication2
{
    public partial class qrlist : System.Web.UI.Page
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
            HtmlContainerControl huu = (HtmlContainerControl)Master.FindControl("MasterBody");
            huu.Attributes.Add("style", "background-color: rgb(234, 234, 234);");

            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang Quality Defective");
                DateTime firstdayofmonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                txtFromDate.Text = firstdayofmonth.ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                LoadDepartmentListToDropDown();
               
            }
            CreateDynamicTableRow();
                //List<string> UserDeleteDefect = Library.LibraryFunction.GetUserDeleteDefectList();
                //if (gvDetailDefect.Rows.Count > 0 && UserDeleteDefect.IndexOf(Session["userid"].ToString()) >= 0)
                //{
                //    gvDetailDefect.HeaderRow.Cells.Add(new TableCell() { Text = "Delete?" });
                //    foreach (GridViewRow row in gvDetailDefect.Rows)
                //    {
                //        //cell number 6 is "Department" , cell 0 is ID or RowIndex
                //        TableCell tc = new TableCell();
                //        Button btn = new Button();
                //        btn.Text = "Delete";
                //        btn.ID = "btnDelete" + row.Cells[0].Text;
                //        btn.Visible = true;
                //        btn.CssClass = "btn btn-danger";
                //        btn.OnClientClick = "return confirm('Bạn có chắc chắn muốn xóa lỗi số: " + row.Cells[0].Text + "?')";

                //        btn.Click += btn_Click;

                //        tc.Controls.Add(btn);
                //        row.Cells.Add(tc);
                //    }                    
                //}         
            
            //lbCollapse_Click(sender, e);
           
        }
        void btn_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string RowIndex = btn.ID.Substring(9);
                SQRLibrary.ExecuteSQL_mrp("delete QC_DefectiveList where ReportID=@ReportID delete [QC_QualityReportHeader] where ReportID=@ReportID and Status in (0,2)", new List<string>() { "@ReportID" }, new List<object>() { RowIndex });
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Đã xóa thành công!');", true);

                CreateDynamicTableRow();
            }
            catch { }
        }
        private void LoadDepartmentListToDropDown()
        {

            DataTable dt = Library.LibraryFunction.ReturnDatatablefromSQL("SELECT [Index],[Name] FROM [HR_Department] d order by Name", "hr");

            foreach (DataRow row in dt.Rows)
            {                
                ddDefectOfDepartment.Items.Add(new ListItem(row["Name"].ToString(), row["Index"].ToString()));
                ddDefectAtDepartment.Items.Add(new ListItem(row["Name"].ToString(), row["Index"].ToString()));
            } 
            
        }

       

        private DataTable LoadDefectList()
        {
            DataTable result = new DataTable();
            try
            {
                string sql = "SELECT [ReportID],[PINo],[ProductName],[TotalQuantity] Qty,[DefectQuantity] D_Qty,[DefectDescription],[DefectReason],[DefectAction] ,[DefectAtDepartmentName] DefectAt ,[WO],[RM],[FM],[AS],[SA],[FIN],[IRON],[UPH],[FIT],[PAC],[Status], [Priority] ,[DefectiveDate],RequiredDate, SubmitDate FROM [QC_QualityReportHeader] ";               
                sql += " WHERE 1=1 ";                
                sql += " and DefectiveDate between '" + txtFromDate.Text + " 00:00:00' and '" + txtToDate.Text + " 23:59:59'";
                               

                if (!ddDefectOfDepartment.SelectedValue.Equals("0"))
                {
                    sql += " and DefectOfDepartment = '" + ddDefectOfDepartment.SelectedValue + "'";
                }

                if (!ddDefectOfEmployee.SelectedValue.Equals("0"))
                {
                    sql += " and DefectOfEmployee = '" + ddDefectOfEmployee.SelectedValue + "'";
                }

                if (!ddDefectOfTeam.SelectedValue.Equals("0"))
                {
                    sql += " and DefectOfTeam= '" + ddDefectOfTeam.SelectedValue + "'";
                }

                if (!ddDefectAtDepartment.SelectedValue.Equals("0"))
                {
                    sql += " and DefectAtDepartment= '" + ddDefectAtDepartment.SelectedValue +"'";
                }

                if (txtProductDes.Text.Length > 0)
                {
                    sql += " and  ProductName like  '%" + txtProductDes.Text + "%'";
                }

                if (ddStatus.SelectedValue.Equals("0"))
                {
                    sql += " and Status in (0,1,2)";
                }
                else if (ddStatus.SelectedValue.Equals("99"))
                {
                    sql += " and Status in (0,1,2,4)";
                }
                else
                {
                    sql += " and Status = " + ddStatus.SelectedValue;
                }

                if (Request["prod"] != null)
                {
                    sql = "SELECT [ReportID],[PINo],[ProductName],[TotalQuantity] Qty,[DefectQuantity] D_Qty,[DefectDescription],[DefectReason],[DefectAction] ,[DefectAtDepartmentName] DefectAt ,[WO],[RM],[FM],[AS],[SA],[FIN],[IRON],[UPH],[FIT],[PAC],[Status], [Priority] ,[DefectiveDate],RequiredDate FROM [QC_QualityReportHeader] where ProdOrderNo=@ProdOrder";
                    result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@ProdOrder" }, new List<object>() { Request["prod"].ToString() });
                    lbBBCL.Text = "BBCL: " + Request["prod"].ToString();
                }
                else if (Request["des"] != null)
                {
                    sql = "SELECT [ReportID],[PINo],[ProductName],[TotalQuantity] Qty,[DefectQuantity] D_Qty,[DefectDescription],[DefectReason],[DefectAction] ,[DefectAtDepartmentName] DefectAt ,[WO],[RM],[FM],[AS],[SA],[FIN],[IRON],[UPH],[FIT],[PAC],[Status], [Priority] ,[DefectiveDate],RequiredDate FROM [QC_QualityReportHeader] where ProductCode=@ProductCode";
                    result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@ProductCode" }, new List<object>() { Request["des"].ToString() });
                    lbBBCL.Text = "BBCL: " + Request["des"].ToString();
                }
                else if ((Request["type"] != null)&&((Request["dept"] != null)))
                {
                    sql = SQLString_GetIssueListByDepartment(Request["dept"].ToString());
                    result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                    lbBBCL.Text = "BBCL: pending at " + Request["dept"].ToString();
                }
                else result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
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
        private void CreateDynamicTableRow()
        {           
            DataTable dt = LoadDefectList();

            List<string> HideColumnList = new List<string>() { "DefectAtDepartment", "ProdOrderNo", "SubmitBy" };

            LibraryFunction.LoadDataTableToGridView2(gvDetailDefect, dt, HideColumnList, new List<string>() { "DefectiveDate", "RequiredDate" });
                          
                        
            if (gvDetailDefect.Rows.Count > 0)
            {
                gvDetailDefect.HeaderRow.Cells.Add(new TableCell() { Text = "Action" });
                foreach (GridViewRow row in gvDetailDefect.Rows)
                {
                    //cell number 6 is "Department" , cell 0 is ID or RowIndex
                    TableCell tc = new TableCell();
                    tc.Attributes["style"] = "text-align: center;";
                    LinkButton btn = new LinkButton();
                    btn.Text = "<i class='fa fa-trash text-info' aria-hidden='true'></i>";
                    btn.ID = "btnDelete" + row.Cells[0].Text;
                    btn.Visible = true;
                    btn.OnClientClick = "return confirm('Bạn có chắc chắn muốn xóa lỗi số: " + row.Cells[0].Text + "?')";

                    btn.Click += btn_Click;

                    tc.Controls.Add(btn);
                    row.Cells.Add(tc);
                }
            }

            FillColorToGridView();
        }

        private void FillColorToGridView()
        {
            try
            {
                if (gvDetailDefect.Rows.Count > 0)
                {
                    List<string> department = new List<string>() { "WO","RM","FM","AS","SA","FIN","IRON","UPH","FIT","PAC"};
                    for (int i=0; i< gvDetailDefect.Columns.Count;i++)
                    {
                        DataControlField dtcf = gvDetailDefect.Columns[i];

                        if (dtcf.HeaderText.Equals("ReportID"))
                        {
                            foreach (GridViewRow r in gvDetailDefect.Rows)
                            {
                                r.Cells[i].Text = "<a href='defectview?id=" + r.Cells[i].Text + "' target='_blank'>" + r.Cells[i].Text + "</a>";
                            }
                        }

                        if (dtcf.HeaderText.Equals("RequiredDate"))
                        {
                            DateTime now = DateTime.Today;
                            foreach (GridViewRow r in gvDetailDefect.Rows)
                            {
                                try
                                {
                                    DateTime required_date;
                                    DateTime.TryParseExact(r.Cells[i].Text, "dd-MM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out required_date);
                                    if ((now > required_date) && (r.Cells[i - 3].Text.Equals("Approved")))
                                    {
                                        r.Cells[i].CssClass = "btn-danger";
                                    }
                                }
                                catch { }
                               
                            }
                        }

                        if (dtcf.HeaderText.Equals("Status"))
                        {
                            foreach (GridViewRow r in gvDetailDefect.Rows)
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
                            foreach (GridViewRow r in gvDetailDefect.Rows)
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
                            foreach (GridViewRow r in gvDetailDefect.Rows)
                            {
                                if (r.Cells[i].Text.Equals("1"))
                                {
                                    r.Cells[i].BackColor = Color.Orange;
                                    r.Cells[i].Text = "";
                                }
                                if (r.Cells[i].Text.Length >= 8)
                                {
                                    r.Cells[i].BackColor = Color.ForestGreen;
                                    r.Cells[i].ForeColor = Color.White;
                                    r.Cells[i].ToolTip = r.Cells[i].Text;
                                    r.Cells[i].Text = "done";
                                }
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

        protected void ddDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string Department = ddDefectOfDepartment.SelectedValue;
                string sql = "";
                sql += "select * from ( ";
                sql += " SELECT EmployeeATID, EmployeeCode, (e.LastName + ' ' + e.MidName + ' ' + e.FirstName) EmployeeName ";
                sql += ",(select COUNT(*) from [HR_EmployeeStoppedWorkingInfo] s where e.EmployeeATID = s.EmployeeATID) Resign ";
                sql += ",(select top 1 DepartmentIndex from HR_WorkingInfo w where e.EmployeeATID = w.EmployeeATID order by w.[Index] desc) DepartmentIndex ";
                sql += " FROM [HR_Employee] e) huu ";
                sql += " where huu.Resign = 0 and huu.DepartmentIndex = @Department";

                DataTable dtTeam = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from Team where DepartmentCode=@Department", new List<string>() { "@Department" }, new List<object>() { Department });

                DataTable dt = Library.LibraryFunction.ReturnDatatablefromSQL(sql, "hr", new List<string>() { "@Department" }, new List<object>() { Department });
                ddDefectOfEmployee.Items.Clear();
                ddDefectOfEmployee.Items.Add(new ListItem("-Chọn-", "0"));
                foreach (DataRow row in dt.Rows)
                {
                    ddDefectOfEmployee.Items.Add(new ListItem(row["EmployeeCode"].ToString() + " - " + row["EmployeeName"].ToString(), row["EmployeeCode"].ToString()));
                }

                ddDefectOfTeam.Items.Clear();
                ddDefectOfTeam.Items.Add(new ListItem("-Chọn-", "0"));
                foreach (DataRow row in dtTeam.Rows)
                {
                    ddDefectOfTeam.Items.Add(new ListItem(row["Desctiption"].ToString(), row["Code"].ToString()));
                }
                CreateDynamicTableRow();
            }
            catch { }
        }

        protected void ddEmployee_SelectedIndexChanged(object sender, EventArgs e)
        {
            CreateDynamicTableRow();
        }

        protected void txtAppliedDate_TextChanged(object sender, EventArgs e)
        {

        }

        protected void ddEmployee_SelectedIndexChanged1(object sender, EventArgs e)
        {

        }

        protected void ddLevel_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void lbCollapse_Click(object sender, EventArgs e)
        {
            if ((hfShow != null) && hfShow.Value == "true")
            {
                header.Attributes["class"] = "card-body collapse";
                hfShow.Value = "false";
            }
            else
            {
                header.Attributes["class"] = "card-body";
                hfShow.Value = "true";
            }
        }

        protected void ddDefectAtDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            CreateDynamicTableRow();
        }

        protected void ddDefectOfTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            CreateDynamicTableRow();
        }

        protected void txtProductDes_TextChanged(object sender, EventArgs e)
        {
            CreateDynamicTableRow();
        }
    }
}
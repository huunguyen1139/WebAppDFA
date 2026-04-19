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
using static WebApp.KPIReportData;

namespace WebApplication2
{
    public partial class defectlist : System.Web.UI.Page
    {
     
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
            HtmlContainerControl huu = (HtmlContainerControl)Master.FindControl("MasterBody");
            huu.Attributes.Add("style", "background-color: rgb(234, 234, 234);");

            if (!IsPostBack)
            {
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
                Button btn = (Button)sender;
                string RowIndex = btn.ID.Substring(9);
                SQRLibrary.ExecuteSQL_mrp("delete QC_DefectiveList where RowIndex=@RowIndex", new List<string>() { "@RowIndex" }, new List<object>() { RowIndex });
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Đã xóa thành công!');", true);
              
                Page_Load(sender, e);
            }
            catch { }
        }
        private void LoadDepartmentListToDropDown()
        {

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [Department] d  where HOD <> '' order by RowIndex");

            foreach (DataRow row in dt.Rows)
            {                
                ddDefectOfDepartment.Items.Add(new ListItem(row["Code"].ToString(), row["DCodeHR"].ToString()));
                ddDefectAtDepartment.Items.Add(new ListItem(row["Code"].ToString(), row["DCodeHR"].ToString()));
            } 
            
        }

       

        private DataTable LoadDefectList()
        {
            DataTable result = new DataTable();
            try
            {  
                string sql = "SELECT * FROM [QC_DefectiveList] ";               
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
                
                result = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
            }
            catch { }
            return result;
        }

        private void CreateDynamicTableRow()
        {           
            DataTable dt = LoadDefectList();

            List<string> HideColumnList = new List<string>() { "KaizenID", "Description", "Level", "Status"};
                       
            LibraryFunction.LoadDataTableToGridView(gvDetailDefect, dt);
           
            if (gvDetailDefect.Rows.Count > 0)
            {
                gvDetailDefect.HeaderRow.Cells.Add(new TableCell() { Text = "Delete?" });
                foreach (GridViewRow row in gvDetailDefect.Rows)
                {
                    //cell number 6 is "Department" , cell 0 is ID or RowIndex
                    TableCell tc = new TableCell();
                    Button btn = new Button();
                    btn.Text = "Delete";
                    btn.ID = "btnDelete" + row.Cells[0].Text;
                    btn.Visible = true;
                    btn.CssClass = "btn btn-danger";
                    btn.OnClientClick = "return confirm('Bạn có chắc chắn muốn xóa lỗi số: " + row.Cells[0].Text + "?')";

                    btn.Click += btn_Click;

                    tc.Controls.Add(btn);
                    row.Cells.Add(tc);
                }
            }          
                
            
            
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

    }
}
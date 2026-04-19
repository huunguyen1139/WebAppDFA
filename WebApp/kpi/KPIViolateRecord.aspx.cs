using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;

namespace WebApplication2.kpi
{
    public partial class KPIViolateRecord : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDepartmentListToDropDown();
                
                CreateDynamicControls();
            }          

            
        }

        private void CreateDynamicControls()
        {
            try
            {
                DataTable data = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [KPI_ViolateRecord] order by RowIndex desc");

                gvViolationRecord.Columns[gvViolationRecord.Columns.Count - 1].Visible = true;
                gvViolationRecord.DataSource = data;
                gvViolationRecord.DataBind();

                gvViolationRecord.Columns[gvViolationRecord.Columns.Count - 1].Visible = false;
                //List<string> ColumnsShow = new List<string>() { "Date", "DepartmentName", "EmployeeName", "TeamName", "ViolateDescription", "Type", "isSuperviorKPI", "isLeaderKPI" };
                //List<string> ColumnsShowName = new List<string>() { "Date", "Department", "EmployeeName", "TeamName", "Description", "Type", "isSuperviorKPI", "isLeaderKPI" };

                //if (data != null && data.Rows.Count > 0)
                //{
                //    TableHeaderRow tbheaderrow = new TableHeaderRow();
                //    TableHeaderCell tbheadercell = new TableHeaderCell();
                //    tbheaderrow.CssClass = "footable-filtering";
                //    foreach (string cl in ColumnsShow)
                //    {
                //        tbheadercell = new TableHeaderCell();
                //        tbheadercell.Text = ColumnsShowName[ColumnsShow.IndexOf(cl)];
                //        tbheaderrow.Cells.Add(tbheadercell);
                //    }
                //    tbheaderrow.TableSection = TableRowSection.TableHeader;
                //    tbViolationRecord.Rows.Add(tbheaderrow);

                //    TableRow tbrow = new TableRow();
                //    TableCell tbrowcell = new TableCell();
                //    int rowindex = 0;
                //    foreach (DataRow row in data.Rows)
                //    {
                //        tbrow = new TableRow();
                //        foreach (string cl in ColumnsShow)
                //        {
                //            tbrowcell = new TableCell();
                //            tbrowcell.ID = "td" + rowindex.ToString() + "_" + ColumnsShow.IndexOf(cl).ToString();
                //            tbrowcell.Text = row[cl].ToString();
                //            tbrow.Cells.Add(tbrowcell);
                //        }
                //        tbViolationRecord.Rows.Add(tbrow);
                //        rowindex += 1;
                //    }
                //}
            }
            catch { }
        }

        protected void btnSave_ServerClick(object sender, EventArgs e)
        {
            try
            {
                
                if (ddViolateType.SelectedValue.Equals("0"))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chưa chọn loại lỗi vi phạm!');ShowPopup()", true);
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup1", "ShowPopup();", true);
                    return;
                }

                if (txtViolateDateTime.Text.Length < 16)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chưa chọn ngày giờ!');ShowPopup()", true);
                    return;
                }

                if (ddEmployee.SelectedValue.Equals("0"))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chưa chọn nhân viên!');ShowPopup()", true);
                    return;
                }

                if (ddisLeaderKPI.SelectedValue.Equals("-1"))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chưa chọn lỗi này có tính KPI cho Leader hay không!');ShowPopup()", true);
                    return;
                }
                if (ddisSupervisorKPI.SelectedValue.Equals("-1"))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chưa chọn lỗi này có tính KPI cho Supervisor hay không!');ShowPopup()", true);
                    return;
                }
                if (txtViolateDes.Text.Length < 1)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Chưa nhập mô tả lỗi vi phạm!');ShowPopup()", true);
                    
                    return;
                }

                DateTime date;
                date = DateTime.ParseExact(txtViolateDateTime.Text, "yyyy-MM-ddTHH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None);

                string sqlupdate = string.Empty;
                sqlupdate += "IF EXISTS (Select * from POR_GeneralSetup where UserAddAndDeleteViolation like '%" + Session["userid"].ToString() + "%') ";
                sqlupdate += " INSERT INTO [KPI_ViolateRecord] ";
                sqlupdate += "([EmployeeCode], [EmployeeName],[TeamCode],[TeamName],[DepartmentCode],[DepartmentName]";
                sqlupdate += ",[Date],[Type],[isSuperviorKPI],[isLeaderKPI],[isEmployeeKPI],[ViolateDescription])";
                sqlupdate += " VALUES (@EmployeeCode, @EmployeeName,@TeamCode,@TeamName,@DepartmentCode,@DepartmentName";
                sqlupdate += ",@Date,@Type,@isSuperviorKPI,@isLeaderKPI,@isEmployeeKPI,@ViolateDescription)";

                SQRLibrary.ExecuteSQL_mrp(sqlupdate, new List<string>() {"@EmployeeCode", "@EmployeeName","@TeamCode","@TeamName","@DepartmentCode","@DepartmentName"
                    ,"@Date","@Type","@isSuperviorKPI","@isLeaderKPI","@isEmployeeKPI","@ViolateDescription"}
                    , new List<object>() {ddEmployee.SelectedValue, ddEmployee.SelectedItem.Text.Substring(ddEmployee.SelectedValue.Length + 3) , "", "", ddDepartment.SelectedValue, ddDepartment.SelectedItem.Text
                    , date.ToString("yyyy-MM-dd HH:mm:ss"), ddViolateType.SelectedValue, ddisSupervisorKPI.SelectedValue, ddisLeaderKPI.SelectedValue, 1, txtViolateDes.Text });

                ddEmployee.SelectedValue = "0";
                //ddTeam.SelectedValue = "0";
                txtViolateDes.Text = "";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [KPI_ViolateRecord] order by RowIndex desc");
                Session["TableViolation"] = dt;
                CreateDynamicControls();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Đã thêm thông tin!');HidePopup()", true);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup01", "HidePopup();", true);
            }
            catch { }
        }
        private void LoadDepartmentListToDropDown()
        {
            //DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [Department]");
            DataTable dt = Library.LibraryFunction.ReturnDatatablefromSQL("SELECT [Index],[Name] FROM [HR_Department] d order by Name", "hr");

            foreach (DataRow row in dt.Rows)
            {
                ddDepartment.Items.Add(new ListItem(row["Name"].ToString(), row["Index"].ToString()));
            }

           
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup0", "HidePopup();", false);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup1", "ShowPopup();", false);
        }

        protected void ddDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string Department = ddDepartment.SelectedValue;
                string sql = "";
                sql += "select * from ( ";
                sql += " SELECT EmployeeATID, EmployeeCode, (e.LastName + ' ' + e.MidName + ' ' + e.FirstName) EmployeeName ";
                sql += ",(select COUNT(*) from [HR_EmployeeStoppedWorkingInfo] s where e.EmployeeATID = s.EmployeeATID) Resign ";
                sql += ",(select top 1 DepartmentIndex from HR_WorkingInfo w where e.EmployeeATID = w.EmployeeATID order by w.[Index] desc) DepartmentIndex ";
                sql += " FROM [HR_Employee] e) huu ";
                sql += " where huu.Resign = 0 and huu.DepartmentIndex = @Department";

                //DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from Employee where Department=@Department", new List<string>() { "@Department" }, new List<object>() { Department });

                DataTable dt = Library.LibraryFunction.ReturnDatatablefromSQL(sql, "hr", new List<string>() { "@Department" }, new List<object>() { Department });
                ddEmployee.Items.Clear();
                ddEmployee.Items.Add(new ListItem("-Chọn nhân viên...", "0"));
                foreach (DataRow row in dt.Rows)
                {
                    ddEmployee.Items.Add(new ListItem(row["EmployeeCode"].ToString() + " - " + row["EmployeeName"].ToString(), row["EmployeeCode"].ToString()));
                }

                //DataTable dtTeam = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from Team where DepartmentCode=@Department", new List<string>() { "@Department" }, new List<object>() { Department });
                //ddTeam.Items.Clear();
                //ddTeam.Items.Add(new ListItem("-Chọn nhóm...", "0"));
                //foreach (DataRow row in dtTeam.Rows)
                //{
                //    ddTeam.Items.Add(new ListItem(row["Desctiption"].ToString(), row["Code"].ToString()));
                //}

                if (!ddDepartment.SelectedValue.Equals("0"))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup1", "ShowPopup();", true);
                }

            }
            catch { }
        }

        protected void btnAddNewRecord_ServerClick(object sender, EventArgs e)
        {
           
        }

        protected void lbtnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;

                GridViewRow r = lbtn.NamingContainer as GridViewRow;

                string RowIndex = r.Cells[gvViolationRecord.Columns.Count - 1].Text;
                if (RowIndex == "") return;
                string sql = "IF EXISTS (Select * from POR_GeneralSetup where UserDeleteViolation like '%" + Session["userid"].ToString() + "%') ";
                sql += " delete KPI_ViolateRecord where RowIndex= @RowIndex";

                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@RowIndex" }, new List<object>() { RowIndex });
                CreateDynamicControls();                
                ScriptManager.RegisterStartupScript(this, this.GetType(), "success", "ShowPopupSuccess('Successfully deleted...!')", true);
            }
            catch { }
        }
    }
}
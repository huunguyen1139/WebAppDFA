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

namespace WebApplication2
{
    public partial class defect : System.Web.UI.Page
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
                txtRegisterDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtRequiredDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                LoadDepartmentListToDropDown();
                LoadPIListtoControl();
            }
            else
            {
                LoadDefectOfEmployee();
            }
           
        }
        private string ItemCode = "";
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
        private void LoadDepartmentListToDropDown()
        {
            //DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [Department]");
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [Department] d  where HOD <> '' order by RowIndex");
            ViewState["DepartmentList"] = dt;
            foreach (DataRow row in dt.Rows)
            {
                ddDefectOfDepartment.Items.Add(new ListItem(row["Code"].ToString(), row["DCodeHR"].ToString()));
                ddDefectAtDepartment.Items.Add(new ListItem(row["Code"].ToString(), row["DCodeHR"].ToString()));
            }
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

                if (txtDefectReason.Text.Length <= 0 || txtDefectDescription.Text.Length <= 5 || txtDefectAction.Text.Length <= 5)
                {
                    lbErrorDescription.Text = "Vui lòng nhập mô tả lỗi, nguyên nhân và cách khắc phục!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }

                if (SQRLibrary.ConvertToInt(txtTotalQuantity.Text) <= 0 || SQRLibrary.ConvertToInt(txtDefectQuantity.Text) <= 0)
                {
                    lbErrorDescription.Text = "Vui lòng nhập tổng số lượng và số lượng bị lỗi!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }

                if (ddDefectAtDepartment.SelectedValue.Equals("0"))
                {
                    lbErrorDescription.Text = "Vui lòng chọn lỗi xảy ra tại Bộ phận nào!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }
                if (!(cbWO.Checked || cbRM.Checked || cbFM.Checked || cbAS.Checked ||cbSA.Checked ||cbFIN.Checked ||cbIRON.Checked ||cbUPH.Checked ||cbFIT.Checked ||cbPAC.Checked))
                {
                    lbErrorDescription.Text = "Vui lòng chọn ít nhất một bộ phận sửa lỗi !";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return false;
                }

                List<string> dept = new List<string>() { "WO", "RM", "FM", "AS", "SA", "FIN", "IRON", "UPH", "FIT", "PAC" };
                List<HtmlInputCheckBox> deptcb = new List<HtmlInputCheckBox>() { cbWO, cbRM, cbFM, cbAS, cbSA, cbFIN, cbIRON, cbUPH, cbFIT, cbPAC };
                
                

                foreach (string str in dept)
                {
                    if (ddDefectAtDepartment.SelectedItem.Text.Equals(str))
                    {
                        int index = dept.IndexOf(str);
                        HtmlInputCheckBox temp = deptcb[index];

                        if (!temp.Checked)
                        {
                            lbErrorDescription.Text = "Bạn chưa đánh dấu bộ phận sửa lỗi cho " + str + "!";
                            divMessage.Attributes["class"] = "alert alert-danger";
                            divMessage.Visible = true;
                            return false;
                        }
                    }                    
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

                DataTable NoSeries = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT FORMAT(ISNULL(MAX(RIGHT(ReportID, 4))+1, 1),'000#')  FROM [QC_QualityReportHeader] where LEFT(ReportID,4)='QR" + DateTime.Now.Year.ToString().Substring(2) + "'");
                string DocumentNo = "QR" + DateTime.Now.Year.ToString().Substring(2) + "_" + NoSeries.Rows[0][0].ToString();

                if (InsertQualityApproval(DocumentNo) && InsertQualityResponsible(DocumentNo))
                {
                    string sql = "POR_QC_InsertQualityReportHeader @ReportID, @DefectiveDate, @PINo, @ProductName, @ProdOrderNo "
                        + ",@TotalQuantity, @DefectQuantity, @DefectDescription, @DefectReason "
                        + ",@DefectAction, @DefectAtDepartment, @DefectAtDepartmentName, @SubmitBy, @RequiredDate, @Priority";

                    SQRLibrary.ExecuteSQL_mrp(sql,
                        new List<string>() { "@ReportID", "@DefectiveDate", "@PINo", "@ProductName", "@ProdOrderNo"
                    ,"@TotalQuantity", "@DefectQuantity", "@DefectDescription", "@DefectReason"
                    ,"@DefectAction", "@DefectAtDepartment", "@DefectAtDepartmentName", "@SubmitBy", "@RequiredDate", "@Priority"}
                        , new List<object>() {DocumentNo, txtRegisterDate.Text, slPI.SelectedValue, ddProductName.SelectedItem.Text, ddProductName.SelectedValue
                    ,SQRLibrary.ConvertToInt(txtTotalQuantity.Text), SQRLibrary.ConvertToInt(txtDefectQuantity.Text), txtDefectDescription.Text, txtDefectReason.Text
                    , txtDefectAction.Text, ddDefectAtDepartment.SelectedValue == "0" ? "":ddDefectAtDepartment.SelectedValue, ddDefectAtDepartment.SelectedValue == "0" ? "" : ddDefectAtDepartment.SelectedItem.Text, Session["userid"] == null ? "HUUNGUYEN" : Session["userid"].ToString(), txtRequiredDate.Text, ddPriority.SelectedValue});

                    UpdateQualityReport_Department(DocumentNo);
                    UploadFile(DocumentNo);
                    lbErrorDescription.Text = "Đã cập nhật biên bản <a href='defectview?id=" + DocumentNo +"' target='_blank'>" + DocumentNo + "</a> lên hệ thống!";
                    divMessage.Attributes["class"] = "alert alert-success";
                    divMessage.Visible = true;
                }
            }
            catch { }
           
        }

        private void UpdateQualityReport_Department(string ReportID)
        {
            try
            {
                string hu1u = cbWO.Checked ? "1" : "";
                string sql = "POR_QC_UpdateQualityReportHeader_department @ReportID, @WO, @RM, @FM, @AS, @SA, @FIN, @IRON, @UPH, @FIT, @PAC";
                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@ReportID", "@WO", "@RM", "@FM", "@AS", "@SA", "@FIN", "@IRON", "@UPH", "@FIT", "@PAC" }
                    , new List<object>() {
                        ReportID,
                        cbWO.Checked ? "1": "" ,
                        cbRM.Checked ? "1": "" ,
                        cbFM.Checked ? "1": "" ,
                        cbAS.Checked ? "1": "" ,
                        cbSA.Checked ? "1": "" ,
                        cbFIN.Checked ? "1": "" ,
                        cbIRON.Checked ? "1": "" ,
                        cbUPH.Checked ? "1": "" ,
                        cbFIT.Checked ? "1": "" ,
                        cbPAC.Checked ? "1": "" ,
                    });

            }
            catch { }
        }

        private bool InsertQualityApproval(string ReportID)
        {
            bool result = true;
            try
            {
                string sql = default(string);                
                string EmployeeCode = default(string);
                string EmployeeName = default(string);               

                for (int i=1; i< tbApproverList.Rows.Count; i++)
                { 
                    HtmlTableRow r = tbApproverList.Rows[i];
                    EmployeeCode = r.Cells[0].InnerText.Length > 0 ? (r.Cells[0].InnerText.Split('-'))[0].Trim() : "";
                    EmployeeName = r.Cells[0].InnerText.Length > 0 ? (r.Cells[0].InnerText.Split('-'))[1].Trim() : "";

                    sql = "POR_QC_InsertApprovalEntry @DocumentNo, @Approver, @Name, @Date, @Status, @Priority, @isFinalApproval";
                    SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@DocumentNo", "@Approver", "@Name", "@Date", "@Status", "@Priority", "@isFinalApproval" }
                        , new List<object>() { ReportID, EmployeeCode, EmployeeName, DateTime.Now, 2, i + 1, i == tbApproverList.Rows.Count - 1 ? 1 : 0 });
                    
                }
            }
            catch { result = false; }
            return result;
        }

        private bool InsertQualityResponsible(string ReportID)
        {
            bool result = true;
            try
            {
                string sql = default(string);
                string DepartmentCode = default(string);
                string DepartmentName = default(string);
                string TeamCode = default(string);
                string TeamName = default(string);
                string EmployeeCode = default(string);
                string EmployeeName = default(string);

                foreach (TableRow r in tbDefectOfEmployee.Rows)
                {
                    if (!(r is TableHeaderRow))
                    {

                        DepartmentCode = r.Cells[0].Text.Length > 0 ? (r.Cells[0].Text.Split('-'))[0].Trim() : "";
                        DepartmentName = r.Cells[0].Text.Length > 0 ? (r.Cells[0].Text.Split('-'))[1].Trim() : "";
                        TeamCode = r.Cells[1].Text.Length > 0 ? (r.Cells[1].Text.Split('-'))[0].Trim() : "";
                        TeamName = r.Cells[1].Text.Length > 0 ? (r.Cells[1].Text.Split('-'))[1].Trim() : "";
                        EmployeeCode = r.Cells[2].Text.Length > 0 ? (r.Cells[2].Text.Split('-'))[0].Trim() : "";
                        EmployeeName = r.Cells[2].Text.Length > 0 ? (r.Cells[2].Text.Split('-'))[1].Trim() : "";

                        sql = "INSERT INTO [QC_DefectiveList] ([DefectiveDate] ,[PI] ,[ProductName],[TotalQuantity],[DefectQuantity],[DefectDescription]"
                        + ",[DefectOfDepartment],[DefectOfTeam],[DefectOfEmployee],[DefectOfDeparmentName],[DefectOfTeamName],[DefectOfEmployeeName],[DefectReason],[DefectAction],[DefectAtDepartment],[DefectAtDepartmentName],[SubmitBy],[SubmitDate], ReportID)"
                        + " VALUES (@DefectiveDate ,@PI ,@ProductName,@TotalQuantity,@DefectQuantity,@DefectDescription,@DefectOfDepartment,@DefectOfTeam,"
                        + " @DefectOfEmployee,@DefectOfDeparmentName,@DefectOfTeamName,@DefectOfEmployeeName,@DefectReason,@DefectAction,@DefectAtDepartment,@DefectAtDepartmentName,@SubmitBy,GETDATE(), @ReportID)";

                        SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@DefectiveDate", "@PI", "@ProductName", "@TotalQuantity", "@DefectQuantity", "@DefectDescription", "@DefectOfDepartment", "@DefectOfTeam", "@DefectOfEmployee", "@DefectOfDeparmentName", "@DefectOfTeamName", "@DefectOfEmployeeName", "@DefectReason", "@DefectAction", "@DefectAtDepartment", "@DefectAtDepartmentName", "@SubmitBy", "@ReportID" }
                            , new List<object>() { txtRegisterDate.Text, slPI.SelectedValue, ddProductName.SelectedItem.Text, SQRLibrary.ConvertToInt(txtTotalQuantity.Text), SQRLibrary.ConvertToInt(txtDefectQuantity.Text), txtDefectDescription.Text, DepartmentCode, TeamCode, EmployeeCode, DepartmentName, TeamName
                        , EmployeeName, txtDefectReason.Text, txtDefectAction.Text, ddDefectAtDepartment.SelectedValue, ddDefectAtDepartment.SelectedValue == "0" ? "" : ddDefectAtDepartment.SelectedItem.Text, Session["userid"] == null ? "HUUNGUYEN" : Session["userid"].ToString(), ReportID});
                    }
                }
            }
            catch { result = false; }
            return result;
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
            }
            catch { }
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
                        ItemCode = r["Source No_"].ToString();
                        break;
                    }
                }
            }
            catch { }
        }

        private void LoadDefectOfEmployee()
        {
            try
            {
                if (ViewState["tbEmployeeIncharge"] != null)
                {
                    DataTable huu = (DataTable)ViewState["tbEmployeeIncharge"];
                    TableHeaderRow tbheaderrow1 = new TableHeaderRow();
                    foreach (DataColumn cl in huu.Columns)
                    {
                        tbheaderrow1.Cells.Add(new TableHeaderCell { Text = cl.ColumnName });
                    }
                    tbheaderrow1.TableSection = TableRowSection.TableHeader;
                    tbDefectOfEmployee.Rows.Add(tbheaderrow1);


                    foreach (DataRow r in huu.Rows)
                    {
                        TableRow tbrow1 = new TableRow();
                        foreach (DataColumn cl in huu.Columns)
                        {
                            tbrow1.Cells.Add(new TableCell() { Text = r[cl.ColumnName].ToString() });
                        }
                        tbDefectOfEmployee.Rows.Add(tbrow1);
                    }

                }
            }
            catch { }
        }
        protected void btnAddEmployeeIncharge_Click(object sender, EventArgs e)
        {
            try
            {
                

                if (ddDefectOfDepartment.SelectedValue.Equals("0"))
                {
                    lbErrorDescription.Text = "Vui lòng chọn bộ phận gây lỗi!";
                    divMessage.Attributes["class"] = "alert alert-danger";
                    divMessage.Visible = true;
                    return;
                }

                if (tbDefectOfEmployee.Rows.Count < 1)
                {
                    TableHeaderRow tbheaderrow = new TableHeaderRow();
                    tbheaderrow.Cells.Add(new TableHeaderCell { Text = "Bộ phận" });
                    tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Nhóm" });
                    tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Nhân viên" });
                    tbheaderrow.TableSection = TableRowSection.TableHeader;
                    tbDefectOfEmployee.Rows.Add(tbheaderrow);
                }
                TableRow tbrow = new TableRow();
                tbrow.Cells.Add(new TableCell() { Text = ddDefectOfDepartment.SelectedValue.Equals("0") ? "" : ddDefectOfDepartment.SelectedValue + " - " + ddDefectOfDepartment.SelectedItem.Text});
                tbrow.Cells.Add(new TableCell() { Text = ddDefectOfTeam.SelectedValue.Equals("0") ? "" : ddDefectOfTeam.SelectedValue + " - " + ddDefectOfTeam.SelectedItem.Text });
                tbrow.Cells.Add(new TableCell() { Text = ddDefectOfEmployee.SelectedValue.Equals("0") ? "" : ddDefectOfEmployee.SelectedItem.Text });
                tbDefectOfEmployee.Rows.Add(tbrow);

                ViewState["tbEmployeeIncharge"] = ConvertTabletoDataTable(tbDefectOfEmployee);
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

        protected void ddDefectAtDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                DataTable department = (DataTable)ViewState["DepartmentList"];
                foreach (DataRow row in department.Rows)
                {
                    if (row["DCodeHR"].ToString().Equals(ddDefectAtDepartment.SelectedValue))
                    {
                        tbApproverList.Rows[1].Cells[0].InnerText = string.Format("{0} - {1}", Session["userid"].ToString(), Session["username"].ToString());
                        tbApproverList.Rows[2].Cells[0].InnerText = string.Format("{0} - {1}", row["HOD"].ToString(), row["Description"].ToString());
                        break;
                    }
                }
            }
            catch { }
        }
        protected string UploadFile(string DocumentNo)
        {
            if ((FileUpload1.PostedFile != null) && (FileUpload1.PostedFile.ContentLength > 0))
            {
                string fn = System.IO.Path.GetFileName(FileUpload1.PostedFile.FileName);

                if (!LibraryFunction.CheckFileType(fn, new List<string>() { ".gif", ".png", ".jpg", ".jpge", ".bmp" }))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "ShowPopup('','Chỉ được upload file hình ảnh!')", true);
                    return "";
                }

                string SaveLocation = Server.MapPath("fileupload") + "\\" + DocumentNo + Path.GetExtension(fn);
                string sql11 = "UPDATE QC_QualityReportHeader SET ImagePath=N'fileupload/" + DocumentNo + Path.GetExtension(fn) + "' where ReportID = @ReportID";
                try
                {
                    if (!System.IO.File.Exists(SaveLocation))
                    {
                        FileUpload1.SaveAs(SaveLocation);
                        SQRLibrary.ExecuteSQL_mrp(sql11, new List<string>() { "@ReportID" }, new List<object>() { DocumentNo });
                    }
                    else
                    {
                        File.Delete(SaveLocation);
                        FileUpload1.SaveAs(SaveLocation);
                        SQRLibrary.ExecuteSQL_mrp(sql11, new List<string>() { "@ReportID" }, new List<object>() { DocumentNo });
                    }

                }
                catch
                {
                }
                return "fileupload/" + DocumentNo + Path.GetExtension(fn);
            }
            else return "";


        }
    }
}
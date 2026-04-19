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
    public partial class defectview : System.Web.UI.Page
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
            HtmlContainerControl huu = (HtmlContainerControl)Master.FindControl("MasterBody");
            huu.Attributes.Add("style", "background-color: rgb(234, 234, 234);");

            if (!IsPostBack)
            {
                HideImageUpload_n_AddUserfuntion();
                //load DefectHeader by ID and save to ViewState DefectView_Header, then fill them to controls
                //load DefectResponsive by ID and sace to ViewState DefectView_Responsive, call Procedure "CreateDynamic control"
                //load DefectApprovalEntry by ID and save to ViewState DefectView_ApprovalEntry
                if (Request["id"] != null)
                {
                    FillDataToControls(Request["id"].ToString());
                    
                    ViewState["DefectView_Responsive"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_DefectiveList] where ReportID=@ReportID"
                    , new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                    LoadResponsiveToTable();

                    ViewState["DefectView_ApprovalEntry"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_ApprovalEntry] where DocumentNo=@ReportID"
                    , new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                    LoadDefectApprovalEntry();
                }
            }
            else
            {
                LoadResponsiveToTable();
                LoadDefectApprovalEntry();
            }
           
        }

        private void HideImageUpload_n_AddUserfuntion()
        {
            try
            {

                LoadDepartmentListToDropDown();

            }
            catch { }
        }

        private void LoadResponsiveToTable()
        {
            try
            {
                tbDefectOfEmployee.Rows.Clear();
                DataTable dt = (DataTable)ViewState["DefectView_Responsive"];
                if (dt == null || dt.Rows.Count == 0) return;

                TableHeaderRow tbheaderrow = new TableHeaderRow();
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Bộ phận" });
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Nhóm" });
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Nhân viên" });

                tbheaderrow.TableSection = TableRowSection.TableHeader;
                tbDefectOfEmployee.Rows.Add(tbheaderrow);

                TableRow tbrow = new TableRow();
                TableCell tbcell = new TableCell();
                foreach (DataRow r in dt.Rows)
                {
                    tbrow = new TableRow();

                    tbrow.Cells.Add(new TableCell() { Text = string.Format("{0} - {1}", r["DefectOfDepartment"].ToString(), r["DefectOfDeparmentName"].ToString()) });
                    tbrow.Cells.Add(new TableCell() { Text = string.Format("{0} - {1}", r["DefectOfTeam"].ToString(), r["DefectOfTeamName"].ToString()) });
                    tbrow.Cells.Add(new TableCell() { Text = string.Format("{0} - {1}", r["DefectOfEmployee"].ToString(), r["DefectOfEmployeeName"].ToString()) });

                    tbDefectOfEmployee.Rows.Add(tbrow);
                }
            }
            catch { }
        }

        private void FillDataToControls(string ReportID)
        {
            try
            {
                DataTable DefectHeader = SQRLibrary.ReturnDatatablefromSQL_mrp("select *, format(DefectiveDate,'yyyy-MM-dd') [Date], format(RequiredDate,'dd-MM-yyyy') [RequiredDate1] from [QC_QualityReportHeader] where ReportID=@ReportID"
                    , new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                if (DefectHeader.Rows.Count > 0)
                {
                    DataRow r = DefectHeader.Rows[0];
                    txtRegisterDate.Text = r["Date"].ToString();
                    txtPI.Text = r["PINo"].ToString();
                    txtProductName.Text = r["ProductName"].ToString();
                    txtProductName.ToolTip = r["ProdOrderNo"].ToString();
                    txtTotalQuantity.Text = r["TotalQuantity"].ToString();
                    txtDefectQuantity.Text = r["DefectQuantity"].ToString();
                    txtDefectDescription.Text = r["DefectDescription"].ToString();
                    txtDefectReason.Text = r["DefectReason"].ToString();
                    txtDefectAction.Text = r["DefectAction"].ToString();
                    txtDefectAtDepartment.Text = r["DefectAtDepartmentName"].ToString();
                    txtRequiredDate.Text = r["RequiredDate1"].ToString();
                    Image1.ImageUrl = r["ImagePath"].ToString().Equals("") ? "" : r["ImagePath"].ToString();
                    string status = "";
                    divUpdateProgress.Visible = false;
                    switch (r["Status"].ToString())
                    {
                        case "0": status = "Open"; break;
                        case "1": status = "Approved"; divUpdateProgress.Visible = true; break;
                        case "2": status = "Pending"; break;
                        case "3": status = "Rejected"; break;
                        case "4": status = "Completed"; break;
                        case "99": status = "Cancelled"; break;
                    }
                    lbStatus.Text = status;
                    //update value to check box control
                    ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                    UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                    Control huu1 = huu.FindControl("ctl00");

                    ddDepartmentReponsive.Items.Clear();
                    foreach (HtmlInputCheckBox cb in huu1.Controls.OfType<HtmlInputCheckBox>())
                    {
                        if (cb.ID.Substring(0,2).Equals("cb"))
                        {
                            if (r[cb.ID.Substring(2)].ToString().Equals("1") || r[cb.ID.Substring(2)].ToString().Length > 1)
                            {
                                cb.Checked = true;
                                ddDepartmentReponsive.Items.Add(new ListItem(cb.ID.Substring(2), cb.ID.Substring(2)));
                            }
                            else
                            {
                                cb.Checked = false;
                            }

                            
                                
                        }
                    } 
                }
            }
            catch { }
        }

        private void LoadDefectApprovalEntry()
        {
            try
            {
                tbApproverList.Rows.Clear();

                DataTable ApprovalEntry = (DataTable)ViewState["DefectView_ApprovalEntry"];
                if (ApprovalEntry == null || ApprovalEntry.Rows.Count == 0) return;

                TableHeaderRow tbheaderrow = new TableHeaderRow();
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Tên" });
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Trạng thái" });
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "Ngày giờ" });
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "#" });
                tbheaderrow.Cells.Add(new TableHeaderCell() { Text = "#" });

                tbheaderrow.TableSection = TableRowSection.TableHeader;
                tbApproverList.Rows.Add(tbheaderrow);

                int RowIndex = 1;
                TableRow tbrow = new TableRow();
                TableCell tbcell = new TableCell();
                foreach (DataRow r in ApprovalEntry.Rows)
                {
                    tbrow = new TableRow();
                    string status = "";
                    switch (r["Status"].ToString())
                    {
                        case "0":
                            status = "Open";
                            break;
                        case "1":
                            status = "Approved";
                            break;
                        case "2":
                            status = "Pending";
                            break;
                        case "3":
                            status = "Rejected";
                            break;
                        case "99":
                            status = "Cancelled";
                            break;
                    }
                    tbrow.Cells.Add(new TableCell() { Text = string.Format("{0} - {1}", r["Approver"].ToString(), r["Name"].ToString())});
                    tbrow.Cells.Add(new TableCell() { Text = status });
                    tbrow.Cells.Add(new TableCell() { Text = r["Date"].ToString() });

                    LinkButton lbtnApprove = new LinkButton();
                    lbtnApprove.Text = "Approve"  ;
                    lbtnApprove.ID = "lbtnApprove" + RowIndex.ToString();
                    lbtnApprove.Click += (sender, e) =>
                    {
                        SQRLibrary.ExecuteSQL_mrp("POR_QC_ApprovalProcessing @ReportID, @Approver, @Status"
                            , new List<string>() { "@ReportID", "@Approver", "@Status" }
                            , new List<object>() { Request["id"].ToString(), Session["userid"].ToString(), 1 });
                        
                        ViewState["DefectView_ApprovalEntry"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_ApprovalEntry] where DocumentNo=@ReportID"
                        , new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                        LoadDefectApprovalEntry();
                    };

                    LinkButton lbtnReject = new LinkButton();
                    lbtnReject.Text = "Reject";
                    lbtnReject.ID = "lbtnReject" + RowIndex.ToString();
                    lbtnReject.Click += (sender, e) => 
                    {
                        SQRLibrary.ExecuteSQL_mrp("POR_QC_ApprovalProcessing @ReportID, @Approver, @Status"
                            , new List<string>() { "@ReportID", "@Approver", "@Status" }
                            , new List<object>() { Request["id"].ToString(), Session["userid"].ToString(), 3 });
                        
                        ViewState["DefectView_ApprovalEntry"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_ApprovalEntry] where DocumentNo=@ReportID"
                        , new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                        LoadDefectApprovalEntry();
                    };
                    TableCell Approve = new TableCell();
                    Approve.Controls.Add(lbtnApprove);
                    tbrow.Cells.Add(Approve);

                    TableCell Reject = new TableCell();
                    Reject.Controls.Add(lbtnReject);
                    tbrow.Cells.Add(Reject);

                    tbApproverList.Rows.Add(tbrow);
                    RowIndex += 1;
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
        private bool InsertQualityResponsible(string ReportID, string DepartmentCode, string DepartmentName, string TeamCode, string TeamName, string EmployeeCode, string EmployeeName)
        {
            bool result = true;
            try
            {
                string sql = default(string);                

                sql = "INSERT INTO [QC_DefectiveList] ([DefectiveDate] ,[PI] ,[ProductName],[TotalQuantity],[DefectQuantity],[DefectDescription]"
                + ",[DefectOfDepartment],[DefectOfTeam],[DefectOfEmployee],[DefectOfDeparmentName],[DefectOfTeamName],[DefectOfEmployeeName],[DefectReason],[DefectAction],[DefectAtDepartment],[DefectAtDepartmentName],[SubmitBy],[SubmitDate], ReportID)"
                + " VALUES (@DefectiveDate ,@PI ,@ProductName,@TotalQuantity,@DefectQuantity,@DefectDescription,@DefectOfDepartment,@DefectOfTeam,"
                + " @DefectOfEmployee,@DefectOfDeparmentName,@DefectOfTeamName,@DefectOfEmployeeName,@DefectReason,@DefectAction,@DefectAtDepartment,@DefectAtDepartmentName,@SubmitBy,GETDATE(), @ReportID)";

                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@DefectiveDate", "@PI", "@ProductName", "@TotalQuantity", "@DefectQuantity", "@DefectDescription", "@DefectOfDepartment", "@DefectOfTeam", "@DefectOfEmployee", "@DefectOfDeparmentName", "@DefectOfTeamName", "@DefectOfEmployeeName", "@DefectReason", "@DefectAction", "@DefectAtDepartment", "@DefectAtDepartmentName", "@SubmitBy", "@ReportID" }
                    , new List<object>() { txtRegisterDate.Text, txtPI.Text, txtProductName.Text, SQRLibrary.ConvertToInt(txtTotalQuantity.Text), SQRLibrary.ConvertToInt(txtDefectQuantity.Text), txtDefectDescription.Text, DepartmentCode, TeamCode, EmployeeCode, DepartmentName, TeamName
                        , EmployeeName, txtDefectReason.Text, txtDefectAction.Text, txtDefectAtDepartment.Text, txtDefectAtDepartment.Text == "0" ? "" : txtDefectAtDepartment.Text, Session["userid"] == null ? "HUUNGUYEN" : Session["userid"].ToString(), ReportID});

            }
            catch { result = false; }
            return result;
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

                //insert responsible user into database
                string DepartmentCode = ddDefectOfDepartment.SelectedValue.Equals("0") ? "" : ddDefectOfDepartment.SelectedValue;
                string DepartmentName = ddDefectOfDepartment.SelectedValue.Equals("0") ? "" : ddDefectOfDepartment.SelectedItem.Text;
                string TeamCode = ddDefectOfTeam.SelectedValue.Equals("0") ? "" : ddDefectOfTeam.SelectedValue;
                string TeamName = ddDefectOfTeam.SelectedValue.Equals("0") ? "" : ddDefectOfTeam.SelectedItem.Text;
                string EmployeeCode = ddDefectOfEmployee.SelectedValue.Equals("0") ? "" : (ddDefectOfEmployee.SelectedItem.Text.Split('-'))[0].Trim();
                string EmployeeName = ddDefectOfEmployee.SelectedValue.Equals("0") ? "" : (ddDefectOfEmployee.SelectedItem.Text.Split('-'))[1].Trim();
                if (Request["id"]!=null) InsertQualityResponsible(Request["id"].ToString(), DepartmentCode, DepartmentName, TeamCode, TeamName, EmployeeCode, EmployeeName);
                //
                ViewState["DefectView_Responsive"] = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_DefectiveList] where ReportID=@ReportID"
                    , new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                //ViewState["tbEmployeeIncharge"] = ConvertTabletoDataTable(tbDefectOfEmployee);
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

        private void ShowInformationLabel(string Message, bool IsWarning = false)
        {
            lbErrorDescription.Text = Message;
            divMessage.Attributes["class"] = IsWarning ? "alert alert-danger" : "alert alert-success";
            divMessage.Visible = true;
        }
        private void ShowInformationLabel_ProgressPart(string Message, bool IsWarning = false)
        {
            lbNoticeUpdateStatus.Text = Message;
            divNotice.Attributes["class"] = IsWarning ? "alert alert-danger" : "alert alert-success";
            divNotice.Visible = true;
        }
        protected void btnUpdateProgress_Click(object sender, EventArgs e)
        {
            try
            {
                string DefectAtDepartment = txtDefectAtDepartment.Text;
                List<string> InchargeDept = LibraryFunction.GetInChargeDepartment(Session["userid"].ToString());
                List<string> para = new List<string>() { "@ReportID" };
                List<object> para_ob = new List<object>() { Request["id"].ToString() };


                if (InchargeDept.IndexOf(ddDepartmentReponsive.SelectedValue) < 0)
                {
                    ShowInformationLabel_ProgressPart("Bạn không có quyền cập nhật tiến độ cho bộ phận " + ddDepartmentReponsive.SelectedValue + "!", true);                                      
                    return;
                }
                string sql = "Update [QC_QualityReportHeader] set [" + ddDepartmentReponsive.SelectedValue + "]='" + DateTime.Now.ToString("dd-MM-yyyy HH:mm") + "' where ReportID=@ReportID";

                if (DefectAtDepartment.Equals(ddDepartmentReponsive.SelectedValue))
                {
                    sql += " Update [QC_QualityReportHeader] set Status = 4, CompletedDate = @CompletedDate where ReportID=@ReportID";
                    para.Add("@CompletedDate");
                    para_ob.Add(DateTime.Now);
                }

                SQRLibrary.ExecuteSQL_mrp(sql, para,  para_ob);
                ShowInformationLabel_ProgressPart("Đã cập nhật!");

                //FillDataToControls(Request["id"].ToString());
            }
            catch { }
        }

        
        protected void UploadFile(object sender, EventArgs e)
        {
            string DocumentNo = default(string);
            if ((FileUpload1.PostedFile != null) && (FileUpload1.PostedFile.ContentLength > 0))
            {
                string fn = System.IO.Path.GetFileName(FileUpload1.PostedFile.FileName);

                if (!LibraryFunction.CheckFileType(fn, new List<string>() { ".gif",".png",".jpg",".jpge", ".bmp"}))
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "ShowPopup('','Chỉ được upload file hình ảnh!')", true);
                    ShowInformationLabel("Chỉ được upload file hình ảnh!", true);
                    return;
                }

                DocumentNo = Request["id"] != null ? Request["id"].ToString() : DocumentNo;
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
                    Image1.ImageUrl = "fileupload/" + DocumentNo + Path.GetExtension(fn);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "ShowPopup('','Upload thành công!')", true);
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "ShowPopup('','Có lỗi xảy ra khi upload!')", true);
                    ShowInformationLabel("Có lỗi xảy ra khi upload!", true);
                }
            }
           
            
        }
        private void LoadDepartmentListToDropDown()
        {
            //DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [Department]");
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [Department] d  where HOD<>'' order by RowIndex");
            ViewState["DepartmentList"] = dt;
            foreach (DataRow row in dt.Rows)
            {
                ddDefectOfDepartment.Items.Add(new ListItem(row["Code"].ToString(), row["DCodeHR"].ToString()));               
            }
        }


        protected void btnUpdateDepartment_Click(object sender, EventArgs e)
        {
            try
            {              

                string sql = "POR_QC_UpdateQualityReportHeader_department @ReportID, @WO, @RM, @FM, @AS, @SA, @FIN, @IRON, @UPH, @FIT, @PAC";
                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@ReportID", "@WO", "@RM", "@FM", "@AS", "@SA", "@FIN", "@IRON", "@UPH", "@FIT", "@PAC" }
                    , new List<object>() {
                        Request["id"]?.ToString() ?? "",
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

                lbErrorDescription.Text = "Cập nhật Bộ phận sửa lỗi thành công!";
                divMessage.Attributes["class"] = "alert alert-success";
                divMessage.Visible = true;

            }
            catch { }
        }
    }
}
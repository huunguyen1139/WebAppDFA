using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using Library;
using System.Web.UI.HtmlControls;


namespace WebApplication2.kpi
{
    public partial class KPITeamMember : System.Web.UI.Page
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
                //Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang KPI Result " + Request.Browser.Type + " " + Request.Browser.IsMobileDevice.ToString());
                txtKPIMonth.Text = DateTime.Now.Year.ToString("0###") + "-" + DateTime.Now.Month.ToString("0#");
                ddDepartment_SelectedIndexChanged(ddDepartment, e);
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT [InchargeDepartment] FROM [Employee] where EmployeeID='" + Session["userid"].ToString() + "'");
                if (dt != null && dt.Rows.Count > 0)
                {
                    List<string> huu = dt.Rows[0][0].ToString().Split(';').ToList<string>();
                    Session["KPIInchargeDepartment"] = huu;
                }
            }
           
        }

        protected void btnLoad_ServerClick(object sender, EventArgs e)
        {
            try
            {
                lbt1.Text = "huu";
            }
            catch { }         
            
        }

        private void CreateDynamicControls()
        {
            try
            {
                //tbKPIResult.Rows.Clear();
                //txtPeriod.Text = txtKPIMonth.Text;
                List<string> ShowColumns = new List<string>() { "DCodePOR", "EmployeeName", "EmployeeCode", "TotalPoint", "TotalBonus" };
                DataTable data = (DataTable)Session["KPIResultSupervisor"];
                DataTable KPICriterionLine = (DataTable)Session["KPICriterionLineSupervisor"];

                List<string> BreakPointColumnXS = new List<string>() { "DCodePOR", "TotalBonus" };
                List<string> BreakPointColumnXSSM = new List<string>() {"ID","EmployeeCode" };

                if (data != null && data.Rows.Count > 0)
                {
                    
                    TableHeaderRow tbheaderrow = new TableHeaderRow();
                    TableHeaderCell tbheadercell = new TableHeaderCell();
                    //tbheadercell.Text = "ID";
                    //tbheadercell.Attributes["style"] = "text-align: center;";
                    //tbheadercell.Attributes["data-breakpoints"] = "xs sm";
                    //tbheaderrow.Cells.Add(tbheadercell);
                    //insert header

                    foreach (string cl in ShowColumns)
                    {
                        tbheadercell = new TableHeaderCell();
                        tbheadercell.Text = cl;
                        //tbheadercell.Attributes["style"] = "text-align: center; ";

                        if (BreakPointColumnXS.IndexOf(cl) >= 0) tbheadercell.Attributes["data-breakpoints"] = "xs";
                        if (BreakPointColumnXSSM.IndexOf(cl) >= 0) tbheadercell.Attributes["data-breakpoints"] = "xs sm";
                        tbheaderrow.Cells.Add(tbheadercell);
                    }

                    if (KPICriterionLine != null && KPICriterionLine.Rows.Count > 0)
                    {
                        foreach (DataRow row in KPICriterionLine.Rows)
                        {
                            tbheadercell = new TableHeaderCell();
                            tbheadercell.Text = row["Description"].ToString() + " (" + SQRLibrary.ConvertToDouble(row["PercentRate"]).ToString("#0.##") + "%)";
                            //tbheadercell.Attributes["style"] = "text-align: center;";
                            tbheadercell.Attributes["data-breakpoints"] = "all";
                            tbheaderrow.Cells.Add(tbheadercell);
                        }
                    }

                    tbheaderrow.TableSection = TableRowSection.TableHeader;
                    //tbKPIResult.Rows.Add(tbheaderrow);

                    //insert body
                    TableRow tbrow = new TableRow();
                    TableCell tbrowcell = new TableCell();
                    int rowindex = 0;
                    foreach (DataRow row in data.Rows)
                    {
                        tbrow = new TableRow();
                        //tbrowcell.ID = "tdID" + rowindex.ToString();
                        //tbrowcell.Text = (rowindex + 1).ToString();
                        //tbrow.Cells.Add(tbrowcell);

                        //for (int i = 0; i < data.Columns.Count; i++)
                        foreach (string str in ShowColumns)
                        {
                            tbrowcell = new TableCell();
                            tbrowcell.ID = "td" + rowindex.ToString() + "_" + ShowColumns.IndexOf(str).ToString();
                            tbrowcell.Text = row[str].ToString();
                            

                            if (str.Equals("EmployeeName"))
                            {
                                tbrowcell.Text = "<img src='src/assets/images/users/" + row["EmployeeCode"].ToString() + ".jpg' alt='user' width=40 class='rounded-circle' /> " + row[str].ToString();
                            }
                            if (str.Equals("TotalPoint"))
                            {
                                double k = 100 * SQRLibrary.ConvertToDouble(row[str]);
                                Label lb = new Label();
                                lb.Text = k.ToString("#0.##") + "%";
                                lb.Width = 44;
                                lb.CssClass = k >= 100 ? "badge py-1 badge-success" : k >= 95 ? "badge py-1 badge-info" : k >= 90 ? "badge py-1 badge-warning" : "badge badge-danger";
                               
                                tbrowcell.Controls.Add(lb);
                            }
                            tbrow.Cells.Add(tbrowcell);
                        }

                        
                        if (KPICriterionLine != null && KPICriterionLine.Rows.Count > 0)
                        {
                            string htmlstar;
                            int maxpoint = 0;
                            int standardpoint = 5;
                            int point = 0;
                            
                            for (int i=0; i< KPICriterionLine.Rows.Count; i++)
                            {
                                tbrowcell = new TableCell();
                                tbrowcell.ID = "tdCriterion" + rowindex + "_" + i.ToString();
                                tbrowcell.Text = (100 * SQRLibrary.ConvertToDouble(row["Achievement" + (i + 1).ToString()])).ToString("#0.##") + "% - " + SQRLibrary.ConvertToDouble(row["Point" + (i + 1).ToString()]).ToString("#0.##"); ; 
                                //draw star rating 
                                maxpoint = SQRLibrary.ConvertToInt(KPICriterionLine.Rows[i]["MaxPoint"]);
                                point = SQRLibrary.ConvertToInt(SQRLibrary.ConvertToDouble(row["Point" + (i + 1).ToString()]));
                                                             

                                htmlstar = "<div style='cursor: pointer;'>";
                                try
                                {
                                    for (int j = 1; j <= maxpoint; j++)
                                    {
                                        if (j <= point)
                                        {
                                            if (j <= standardpoint)
                                            {
                                                htmlstar += "<img src='src/assets/images/rating/star-on.png'>";
                                            }
                                            else
                                            {
                                                htmlstar += "<img src='src/assets/images/rating/star-on-ok.png'>";
                                            }
                                        }
                                        else
                                        {
                                            htmlstar += "<img src='src/assets/images/rating/star-off.png'>";
                                        }
                                    }
                                }
                                catch { }
                                htmlstar += "<input name='score' type='hidden'></div>";
                                tbrowcell.Text += htmlstar;
                                tbrow.Cells.Add(tbrowcell);
                            }
                        }

                        //tbKPIResult.Rows.Add(tbrow);
                        rowindex += 1;
                    }
                }

                
            }
            catch { }

        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                lbt1.Text = "huu";
            }
            catch { }   
        }

        private void LoadEmployeeAndTeam(string Department, int Year, int Month)
        {
            try
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("KPIContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                HtmlControl html;
                CheckBox cb;
                LinkButton lbt;

                DateTime startdate = new DateTime(Year, Month, 1);
                DateTime enddate = startdate.AddMonths(1);
                enddate = enddate.AddDays(-1);
                string sql = "SELECT *  FROM [KPI_Employee] WHERE DCodeHR=@Department and ((Active = 1 and StartDate <= @todate) or (Active=0 and FinishDate>=@fromdate and StartDate<=@todate))";
                sql += " and EmployeeCode not in (select EmployeeCode from KPI_TeamMember where [Year]=@Year AND [Month]=@Month)";

                DataTable dtEmployee = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@fromdate","@todate", "@Department", "@Year", "@Month" }, new List<object>() { startdate, enddate,Department, Year, Month });
                if (dtEmployee != null && dtEmployee.Rows.Count > 0)
                {
                    for (int i = 0; i < dtEmployee.Rows.Count; i++)
                    {
                        html = (HtmlControl)huu1.FindControl("divcheckbox" + (i+1).ToString());
                        html.Visible = true;
                        cb = (CheckBox)html.FindControl("checkbox" + (i+1).ToString());
                        if (i % 4 == 1) cb.Text = "<i class='fa fa-circle text-info me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        if (i % 4 == 2) cb.Text = "<i class='fa fa-circle text-success me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        if (i % 4 == 3) cb.Text = "<i class='fa fa-circle text-danger me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        if (i % 4 == 0) cb.Text = "<i class='fa fa-circle text-warning me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        cb.ToolTip = dtEmployee.Rows[i]["EmployeeCode"].ToString();
                    }
                    
                }

                try
                {
                    for (int i = dtEmployee.Rows.Count; i < 69; i++)
                    {
                        html = (HtmlControl)huu1.FindControl("divcheckbox" + (i + 1).ToString());
                        html.Visible = false;
                    }
                }
                catch { }
                //load Team to dropdownlist and linkbutton
                
                sql = "SELECT * FROM [Team] where DepartmentCode=@Department";
                sql += " and ((Status=1 and StartDate <= @startdate) or (Status=0 and FinishDate >= @enddate and StartDate >=@startdate))";

                DataTable dtTeam = SQRLibrary.ReturnDatatablefromSQL_mrp(sql , new List<string>() {"@Department","@startdate","@enddate"}
                    , new List<object>() {Department, startdate.ToString("yyyy-MM-dd"), enddate.ToString("yyyy-MM-dd")});

                if (dtTeam != null && dtTeam.Rows.Count > 0)
                {
                    DropDownList1.Items.Clear();
                    for (int i = 0; i < dtTeam.Rows.Count; i++)
                    {                        
                        lbt = (LinkButton)huu1.FindControl("lbt" + (i + 1).ToString());
                        lbt.Visible = true;

                        if (i % 5 == 1) lbt.Text = "<i class='icon-layers mr-1'></i><span class='d-none d-md-block'>" + dtTeam.Rows[i]["Desctiption"].ToString() + "</span>";
                        if (i % 5 == 2) lbt.Text = "<i class='icon-briefcase mr-1'></i><span class='d-none d-md-block'>" + dtTeam.Rows[i]["Desctiption"].ToString() + "</span>";
                        if (i % 5 == 3) lbt.Text = "<i class='icon-share-alt mr-1'></i><span class='d-none d-md-block'>" + dtTeam.Rows[i]["Desctiption"].ToString() + "</span>";
                        if (i % 5 == 4) lbt.Text = "<i class='icon-tag mr-1'></i><span class='d-none d-md-block'>" + dtTeam.Rows[i]["Desctiption"].ToString() + "</span>";
                        if (i % 5 == 0) lbt.Text = "<i class='icon-note mr-1'></i><span class='d-none d-md-block'>" + dtTeam.Rows[i]["Desctiption"].ToString() + "</span>";

                        lbt.ToolTip = dtTeam.Rows[i]["Code"].ToString();                        
                        DropDownList1.Items.Add(new ListItem(dtTeam.Rows[i]["Desctiption"].ToString(), lbt.ToolTip));
                    }                    
                }
                try
                {
                    for (int i = dtTeam.Rows.Count; i < 5; i++)
                    {
                        lbt = (LinkButton)huu1.FindControl("lbt" + (i + 1).ToString());
                        lbt.Visible = false;
                    }
                }
                catch { }
            }
            catch { }
        }
        protected void ddDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList huu = sender as DropDownList;
            LoadEmployeeAndTeam(huu.SelectedValue, SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)));
            try
            {                
                TeamLinkButtonClick(lbt1);
            }
            catch { }
        }

        private void TeamLinkButtonClick(LinkButton lbtn)
        {
            ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("KPIContent");
            UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
            Control huu1 = huu.FindControl("ctl00");

            HtmlControl html;
            CheckBox cb;
            if (lbtn.Visible)
            {
                foreach (LinkButton temp in huu1.Controls.OfType<LinkButton>())
                {
                    temp.CssClass = temp.CssClass.Replace("active", "");
                }
                lbtn.CssClass = lbtn.CssClass.Contains("active") ? lbtn.CssClass : lbtn.CssClass + " active";
                string sql = "SELECT *, (SELECT top 1 EmployeeName FROM KPI_Employee e where e.EmployeeCode=k.EmployeeCode) EmployeeName FROM [KPI_TeamMember] k where TeamCode=@TeamCode and [Year]=@Year and [Month]=@Month";
                DataTable dtEmployee = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@TeamCode", "@Year", "@Month" }
                    , new List<object>() { lbtn.ToolTip, SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)) });
                                
                if (dtEmployee != null && dtEmployee.Rows.Count > 0)
                {
                    for (int i = 0; i < dtEmployee.Rows.Count; i++)
                    {
                        html = (HtmlControl)huu1.FindControl("lisemcheckbox" + (i + 1).ToString());
                        html.Visible = true;
                        cb = (CheckBox)html.FindControl("emcheckbox" + (i + 1).ToString());
                        if (i % 4 == 1) cb.Text = "<i class='fa fa-circle text-info me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        if (i % 4 == 2) cb.Text = "<i class='fa fa-circle text-success me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        if (i % 4 == 3) cb.Text = "<i class='fa fa-circle text-danger me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        if (i % 4 == 0) cb.Text = "<i class='fa fa-circle text-warning me-2'></i>" + dtEmployee.Rows[i]["EmployeeName"].ToString();
                        cb.ToolTip = dtEmployee.Rows[i]["EmployeeCode"].ToString();
                    }
                    
                }
                try
                {
                    for (int i = dtEmployee.Rows.Count; i < 49; i++)
                    {
                        html = (HtmlControl)huu1.FindControl("lisemcheckbox" + (i + 1).ToString());
                        html.Visible = false;
                    }
                }
                catch { }
            }
        }
        protected void lbt1_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;
                TeamLinkButtonClick(lbtn);                
            }
            catch { }
        }

        protected void lbt2_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;
                TeamLinkButtonClick(lbtn);
            }
            catch { }
        }

        protected void lbt3_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;
                TeamLinkButtonClick(lbtn);
            }
            catch { }
        }

        protected void lbt4_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;
                TeamLinkButtonClick(lbtn);
            }
            catch { }
        }

        protected void lbt5_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbtn = sender as LinkButton;
                TeamLinkButtonClick(lbtn);
            }
            catch { }
        }

        protected void btnAddEmployee_ServerClick(object sender, EventArgs e)
        {
            try
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("KPIContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                                
                CheckBox cb;
                string sql = "";

                foreach (HtmlControl htmlct in huu1.Controls.OfType<HtmlControl>())
                {
                    if (htmlct.ID.Substring(0, 3).Equals("div"))
                    {
                        cb = (CheckBox)htmlct.FindControl(htmlct.ID.Substring(3));
                        if (cb.Checked)
                        {
                            sql += " INSERT INTO [KPI_TeamMember] ([Year],[Month],[EmployeeCode],[TeamCode],[DepartmentCode])";
                            sql += " VALUES (" + SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)).ToString() + ", " + SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)).ToString() 
                                + ", '" + cb.ToolTip + "', '" + DropDownList1.SelectedValue + "', '" + ddDepartment.SelectedValue + "')";

                            cb.Checked = false;
                        }
                    }
                }

                sql = sql + " ";
                if (sql.Length > 0) SQRLibrary.ExecuteSQL_mrp(sql);

                LinkButton lbtn_reload = null;
                foreach (LinkButton temp in huu1.Controls.OfType<LinkButton>())
                {
                    if (temp.CssClass.Contains("active"))
                    {
                        lbtn_reload = temp;
                        break;
                    }
                }
                
                LoadEmployeeAndTeam(ddDepartment.SelectedValue, SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)));

                if (lbtn_reload != null) TeamLinkButtonClick(lbtn_reload);
            
            }
            catch { }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            try
            {
                List<string> InchargeDepartment = (List<string>)Session["KPIInchargeDepartment"];

                if (InchargeDepartment.IndexOf(ddDepartment.SelectedItem.Text) < 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Bạn không có quyền chỉnh sửa cho bộ phận " + ddDepartment.SelectedItem.Text + "!');", true);
                    return;
                }

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("KPIContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                CheckBox cb;
                string sql = "";

                foreach (HtmlControl htmlct in huu1.Controls.OfType<HtmlControl>())
                {
                    if (htmlct.ID.Substring(0, 3).Equals("div"))
                    {
                        cb = (CheckBox)htmlct.FindControl(htmlct.ID.Substring(3));
                        if (cb.Checked)
                        {
                            sql += " INSERT INTO [KPI_TeamMember] ([Year],[Month],[EmployeeCode],[TeamCode],[DepartmentCode])";
                            sql += " VALUES (" + SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)).ToString() + ", " + SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)).ToString()
                                + ", '" + cb.ToolTip + "', '" + DropDownList1.SelectedValue + "', '" + ddDepartment.SelectedValue + "')";

                            cb.Checked = false;
                        }
                    }
                }

                sql = sql + " ";
                if (sql.Length > 0) SQRLibrary.ExecuteSQL_mrp(sql);

                LinkButton lbtn_reload = null;
                foreach (LinkButton temp in huu1.Controls.OfType<LinkButton>())
                {
                    if (temp.CssClass.Contains("active"))
                    {
                        lbtn_reload = temp;
                        break;
                    }
                }

                LoadEmployeeAndTeam(ddDepartment.SelectedValue, SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)));

                if (lbtn_reload != null) TeamLinkButtonClick(lbtn_reload);

            }
            catch { }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                List<string> InchargeDepartment = (List<string>)Session["KPIInchargeDepartment"];

                if (InchargeDepartment.IndexOf(ddDepartment.SelectedItem.Text) < 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Bạn không có quyền chỉnh sửa cho bộ phận " + ddDepartment.SelectedItem.Text + "!');", true);
                    return;
                }
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("KPIContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                CheckBox cb;
                string sql = "";

                foreach (HtmlControl htmlct in huu1.Controls.OfType<HtmlControl>())
                {
                    if (htmlct.ID.Substring(0, 3).Equals("lis"))
                    {
                        cb = (CheckBox)htmlct.FindControl(htmlct.ID.Substring(3));
                        if (cb.Checked)
                        {
                            sql += " DELETE [KPI_TeamMember] WHERE [Year]=" + SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)).ToString() + " and [Month]=" + SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)).ToString() + " and [EmployeeCode]='" + cb.ToolTip + "'";
                            
                            cb.Checked = false;
                        }
                    }
                }
               
                if (sql.Length > 0) SQRLibrary.ExecuteSQL_mrp(sql);

                LinkButton lbtn_reload = null;
                foreach (LinkButton temp in huu1.Controls.OfType<LinkButton>())
                {
                    if (temp.CssClass.Contains("active"))
                    {
                        lbtn_reload = temp;
                        break;
                    }
                }

                LoadEmployeeAndTeam(ddDepartment.SelectedValue, SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)));

                if (lbtn_reload != null) TeamLinkButtonClick(lbtn_reload);

            }
            catch { }
        }

        protected void txtKPIMonth_TextChanged(object sender, EventArgs e)
        {
            ddDepartment_SelectedIndexChanged(ddDepartment, e);
        }

       
    }
}
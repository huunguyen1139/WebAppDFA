using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using System.Web.UI.HtmlControls;
using Library;
using System.Text.RegularExpressions;
using System.Globalization;

namespace WebApp.production
{
    public partial class ProductionTargetSetUp : System.Web.UI.Page
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

            if (!IsPostBack)
            {                
                txtFromDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                ViewState["Generated"] = null;
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang daily target setup");
            }            
            
                ViewState["HasPermission"] = "true"; 
                ViewState["PermissionOnUnitCost"] = "true";
            

            if (ViewState["Generated"] != null && ViewState["Generated"].ToString().Equals("true"))
            {
                CreateDynamicTableRow(ViewState["HasPermission"] != null && ViewState["HasPermission"].ToString().Equals("true"), ViewState["PermissionOnUnitCost"].ToString().Equals("true"));
            }
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                tbTargetSetup.Rows.Clear();
                CreateDynamicTableRow(ViewState["HasPermission"] != null && ViewState["HasPermission"].ToString().Equals("true"), ViewState["PermissionOnUnitCost"].ToString().Equals("true"));
                ViewState["Generated"] = "true";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully load!');", true);
            }
            catch
            { }
        }

        private void LoadData()
        {
            try
            {
                tbTargetSetup.Rows.Clear();
                CreateDynamicTableRow(ViewState["HasPermission"] != null && ViewState["HasPermission"].ToString().Equals("true"), ViewState["PermissionOnUnitCost"].ToString().Equals("true"));
                ViewState["Generated"] = "true";
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully load!');", true);
            }
            catch
            { }
        }
        private void CreateDynamicTableRow(bool HasPermission, bool PermissionOnUnitCost)
        {
            try
            {
               
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("POR_DailyTargetSetUp @date, @user",
                        new List<string>() { "@date", "@user" }, new List<object>() { txtFromDate.Text, Session["username"].ToString() });

                List<string> ViewColumnList = new List<string>() { "#", "Dept.", "Manpower", "E.NorWHs"
                    , "A.NorWHs", "Non-WHs", "Add-WHs", "TotalWHs", "Target", "In.Target", "W. Salary", "MH.UCost", "WHsPerday" };

                if (Request["showRemark"] != null) ViewColumnList = new List<string>() { "#", "Dept.", "Manpower", "E.NorWHs"
                    , "A.NorWHs", "Non-WHs", "Note","Add-WHs", "TotalWHs", "Target", "In.Target", "W. Salary", "MH.UCost", "WHsPerday" };

                if (dt != null && dt.Rows.Count > 0)
                {
                    TableHeaderRow tbheaderrow = new TableHeaderRow();
                    TableHeaderCell tbheadercell = new TableHeaderCell();
                    TableFooterRow tbfooterrow = new TableFooterRow();

                    TableRow tbrow = new TableRow();
                    TableCell[] tbrowcell = new TableCell[ViewColumnList.Count];
                    TableCell tbfootercell = new TableCell();
                    

                    foreach (string str in ViewColumnList)
                    {
                        tbheadercell = new TableHeaderCell();
                        tbheadercell.Text = str;
                        tbheaderrow.Cells.Add(tbheadercell);

                        
                        tbfootercell = new TableCell();
                        switch (str)
                        {
                            case "A.NorWHs":                              
                                TextBox tb = new TextBox();                                
                                tb.ID = "tbPaste0";
                                tb.CssClass = "form-control";
                                tb.AutoPostBack = true;
                                tb.Visible = HasPermission;
                                tb.TextChanged += tb_TextChanged;
                                //tb.Attributes["onpaste"] = "multiFieldPasteHandler(event)";
                                tbfootercell.Controls.Add(tb);
                                break;
                            case "Non-WHs":
                                TextBox tb1 = new TextBox();                              
                                tb1.ID = "tbPaste1";
                                tb1.CssClass = "form-control";
                                tb1.Visible = HasPermission;
                                tb1.AutoPostBack = true;
                                tb1.TextChanged += tb1_TextChanged;
                                tbfootercell.Controls.Add(tb1);                               
                                break;
                            case "Add-WHs":
                                TextBox tb2 = new TextBox();
                                tb2.ID = "tbPaste2";
                                tb2.CssClass = "form-control";
                                tb2.Visible = HasPermission;
                                tb2.AutoPostBack = true;
                                tb2.TextChanged += tb2_TextChanged;
                                tbfootercell.Controls.Add(tb2);                               
                                break;

                            case "W. Salary":
                                TextBox tb3 = new TextBox();
                                tb3.ID = "tbPaste3";
                                tb3.CssClass = "form-control";
                                tb3.Visible = HasPermission;
                                tb3.AutoPostBack = true;
                                tb3.TextChanged += tb3_TextChanged;
                                tbfootercell.Controls.Add(tb3);
                                break;

                            case "Manpower":
                                TextBox tb4 = new TextBox();
                                tb4.ID = "tbPaste4";
                                tb4.CssClass = "form-control";
                                tb4.Visible = HasPermission;
                                tb4.AutoPostBack = true;
                                tb4.TextChanged += tb4_TextChanged;
                                tbfootercell.Controls.Add(tb4);
                                break;
                        }
                        tbfooterrow.Cells.Add(tbfootercell);
                    }
                    tbheaderrow.TableSection = TableRowSection.TableHeader;
                    tbTargetSetup.Rows.Add(tbheaderrow);

                    List<string> InchargeDepartment = LibraryFunction.GetInChargeDepartment(Session["userid"].ToString());
                    foreach (DataRow row in dt.Rows)
                    {
                        int t = 2;
                        tbrow = new TableRow();
                        tbrowcell = new TableCell[ViewColumnList.Count]; for (int i = 0; i < tbrowcell.Length; i++) { tbrowcell[i] = new TableCell(); }
                        tbrowcell[0].Text = row["ShowIndex"].ToString();
                        tbrowcell[1].Text = row["Department"].ToString();
                        tbrowcell[0].Attributes["style"] = "vertical-align: middle;";
                        tbrowcell[1].Attributes["style"] = "vertical-align: middle;";

                        TextBox manpower = new TextBox();
                        manpower.ID = "man" + row["Department"].ToString();
                        manpower.CssClass = "form-control";
                        manpower.TextMode = TextBoxMode.Number;
                        manpower.Text = row["ManPower"].ToString();
                        manpower.Attributes["runat"] = "server";
                        manpower.AutoPostBack = true;
                        manpower.Enabled = InchargeDepartment.IndexOf(row["Department"].ToString()) >=0;
                        manpower.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(manpower);
                        t += 1;

                        Label normalworkinghours = new Label();
                        normalworkinghours.ID = "nor" + row["Department"].ToString();
                        normalworkinghours.Text = row["NormalWorkingHours"].ToString();
                        normalworkinghours.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle; text-align:center;";
                        tbrowcell[t].Controls.Add(normalworkinghours);
                        t += 1;

                        TextBox actualworkinghours = new TextBox();
                        actualworkinghours.ID = "awh" + row["Department"].ToString();
                        actualworkinghours.CssClass = "form-control";
                        actualworkinghours.TextMode = TextBoxMode.Number;
                        actualworkinghours.Text = row["ANormalWorkingHours"].ToString();
                        actualworkinghours.Attributes["runat"] = "server";
                        actualworkinghours.AutoPostBack = true;
                        actualworkinghours.Enabled = HasPermission;
                        actualworkinghours.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(actualworkinghours);
                        t += 1;

                        TextBox nonworkinghours = new TextBox();
                        nonworkinghours.ID = "non" + row["Department"].ToString();
                        nonworkinghours.CssClass = "form-control";
                        nonworkinghours.TextMode = TextBoxMode.Number;
                        nonworkinghours.Text = row["Non-WorkingHours"].ToString();
                        nonworkinghours.Attributes["runat"] = "server";
                        nonworkinghours.AutoPostBack = true;
                        nonworkinghours.Enabled = HasPermission;
                        nonworkinghours.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(nonworkinghours);
                        t += 1;

                        if (Request["showRemark"] != null)
                        {
                            TextBox remark = new TextBox();
                            remark.ID = "rem" + row["Department"].ToString();
                            remark.CssClass = "form-control";                           
                            remark.Text = row["Remark"].ToString();
                            remark.Attributes["runat"] = "server";
                            remark.AutoPostBack = true;
                            remark.Enabled = HasPermission;
                            remark.TextChanged += txtRemark_TextChanged;
                            tbrowcell[t].Controls.Add(remark);
                            t += 1;
                        }


                        TextBox addworkinghours = new TextBox();
                        addworkinghours.ID = "add" + row["Department"].ToString();
                        addworkinghours.CssClass = "form-control";
                        addworkinghours.TextMode = TextBoxMode.Number;
                        addworkinghours.Text = row["Add-WorkingHours"].ToString();
                        addworkinghours.Attributes["runat"] = "server";
                        addworkinghours.AutoPostBack = true;
                        addworkinghours.Enabled = HasPermission;
                        addworkinghours.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(addworkinghours);
                        t += 1;

                        Label totalworkinghour = new Label();
                        totalworkinghour.ID = "tol" + row["Department"].ToString();
                        totalworkinghour.Text = row["TotalWorkingHours"].ToString();
                        totalworkinghour.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle;";
                        tbrowcell[t].Controls.Add(totalworkinghour);
                        t += 1;

                        Label target = new Label();
                        target.ID = "tar" + row["Department"].ToString();
                        target.Text = SQRLibrary.ConvertToDouble(row["Target"]).ToString("#,##0");
                        target.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle; horizontal-align = center;color: forestgreen;font-weight: bold;";
                        tbrowcell[t].Controls.Add(target);
                        t += 1;


                        Label indirect_target = new Label();
                        indirect_target.ID = "idt" + row["Department"].ToString();
                        indirect_target.Text = SQRLibrary.ConvertToDouble(row["IndirectTarget"]).ToString("#,##0");
                        indirect_target.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle; horizontal-align = center;color: blue;font-weight: bold;";
                        tbrowcell[t].Controls.Add(indirect_target);
                        t += 1;


                        TextBox wsalary = new TextBox();
                        wsalary.ID = "slr" + row["Department"].ToString();
                        wsalary.CssClass = "form-control";
                        wsalary.TextMode = TextBoxMode.Number;
                        wsalary.Text = SQRLibrary.ConvertToDouble(row["WSalary"]).ToString("##0");
                        wsalary.Attributes["runat"] = "server";
                        wsalary.AutoPostBack = true;
                        wsalary.Enabled = HasPermission;
                        wsalary.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(wsalary);
                        t += 1;

                        TextBox mhunitcost = new TextBox();
                        mhunitcost.ID = "uni" + row["Department"].ToString();
                        mhunitcost.CssClass = "form-control";
                        mhunitcost.TextMode = TextBoxMode.Number;
                        mhunitcost.Text = SQRLibrary.ConvertToDouble(row["ManhourUnitCost"]).ToString("##0");
                        mhunitcost.Attributes["runat"] = "server";
                        mhunitcost.AutoPostBack = true;
                        mhunitcost.Enabled = PermissionOnUnitCost;
                        mhunitcost.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(mhunitcost);
                        t += 1;

                        TextBox whperday = new TextBox();
                        whperday.ID = "whp" + row["Department"].ToString();
                        whperday.CssClass = "form-control";
                        whperday.TextMode = TextBoxMode.Number;
                        whperday.Text = row["NormalWorkingHourPerday"].ToString();
                        whperday.Attributes["runat"] = "server";
                        whperday.AutoPostBack = true;
                        whperday.Enabled = false;
                        whperday.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(whperday);
                        t += 1;

                        //TextBox perform = new TextBox();
                        //perform.ID = "per" + row["Department"].ToString();
                        //perform.CssClass = "form-control";
                        //perform.TextMode = TextBoxMode.Number;
                        //perform.Text = row["Performance%"].ToString();
                        //perform.Attributes["runat"] = "server";
                        //perform.AutoPostBack = true;
                        //perform.Enabled = false;
                        //perform.TextChanged += TextChangedOnTextBox;
                        //tbrowcell[12].Controls.Add(perform);

                        for (int i = 0; i < tbrowcell.Length; i++) { tbrow.Cells.Add(tbrowcell[i]); }
                        tbTargetSetup.Rows.Add(tbrow);
                    }
                    tbTargetSetup.Rows.Add(tbfooterrow);
                }
            }
            catch { }
        }

        private void CreateDynamicTableRow_old(bool HasPermission)
        {
            try
            {

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("POR_DailyTargetSetUp @date, @user",
                        new List<string>() { "@date", "@user" }, new List<object>() { txtFromDate.Text, Session["username"].ToString() });

                List<string> ViewColumnList = new List<string>() { "#", "Dept.", "Manpower", "E.NorWHs"
                    , "A.NorWHs", "Non-WHs", "Add-WHs", "TotalWHs", "Target", "Out. Target", "MH.UCost", "WHsPerday" };

                if (Request["showRemark"] != null) ViewColumnList = new List<string>() { "#", "Dept.", "Manpower", "E.NorWHs"
                    , "A.NorWHs", "Non-WHs", "Note","Add-WHs", "TotalWHs", "Target", "Out. Target", "MH.UCost", "WHsPerday" };

                if (dt != null && dt.Rows.Count > 0)
                {
                    TableHeaderRow tbheaderrow = new TableHeaderRow();
                    TableHeaderCell tbheadercell = new TableHeaderCell();
                    TableFooterRow tbfooterrow = new TableFooterRow();

                    TableRow tbrow = new TableRow();
                    TableCell[] tbrowcell = new TableCell[ViewColumnList.Count];
                    TableCell tbfootercell = new TableCell();


                    foreach (string str in ViewColumnList)
                    {
                        tbheadercell = new TableHeaderCell();
                        tbheadercell.Text = str;
                        tbheaderrow.Cells.Add(tbheadercell);


                        tbfootercell = new TableCell();
                        switch (str)
                        {
                            case "A.NorWHs":
                                TextBox tb = new TextBox();
                                tb.ID = "tbPaste0";
                                tb.CssClass = "form-control";
                                tb.AutoPostBack = true;
                                tb.Visible = HasPermission;
                                tb.TextChanged += tb_TextChanged;
                                //tb.Attributes["onpaste"] = "multiFieldPasteHandler(event)";
                                tbfootercell.Controls.Add(tb);
                                break;
                            case "Non-WHs":
                                TextBox tb1 = new TextBox();
                                tb1.ID = "tbPaste1";
                                tb1.CssClass = "form-control";
                                tb1.Visible = HasPermission;
                                tb1.AutoPostBack = true;
                                tb1.TextChanged += tb1_TextChanged;
                                tbfootercell.Controls.Add(tb1);
                                break;
                            case "Add-WHs":
                                TextBox tb2 = new TextBox();
                                tb2.ID = "tbPaste2";
                                tb2.CssClass = "form-control";
                                tb2.Visible = HasPermission;
                                tb2.AutoPostBack = true;
                                tb2.TextChanged += tb2_TextChanged;
                                tbfootercell.Controls.Add(tb2);
                                break;
                            case "W. Salary":
                                TextBox tb3 = new TextBox();
                                tb3.ID = "tbPaste3";
                                tb3.CssClass = "form-control";
                                tb3.Visible = HasPermission;
                                tb3.AutoPostBack = true;
                                tb3.TextChanged += tb3_TextChanged;
                                tbfootercell.Controls.Add(tb3);
                                break;
                        }
                        tbfooterrow.Cells.Add(tbfootercell);
                    }
                    tbheaderrow.TableSection = TableRowSection.TableHeader;
                    tbTargetSetup.Rows.Add(tbheaderrow);

                    List<string> InchargeDepartment = LibraryFunction.GetInChargeDepartment(Session["userid"].ToString());
                    foreach (DataRow row in dt.Rows)
                    {
                        int t = 2;
                        tbrow = new TableRow();
                        tbrowcell = new TableCell[ViewColumnList.Count]; for (int i = 0; i < tbrowcell.Length; i++) { tbrowcell[i] = new TableCell(); }
                        tbrowcell[0].Text = row["ShowIndex"].ToString();
                        tbrowcell[1].Text = row["Department"].ToString();
                        tbrowcell[0].Attributes["style"] = "vertical-align: middle;";
                        tbrowcell[1].Attributes["style"] = "vertical-align: middle;";

                        TextBox manpower = new TextBox();
                        manpower.ID = "man" + row["Department"].ToString();
                        manpower.CssClass = "form-control";
                        manpower.TextMode = TextBoxMode.Number;
                        manpower.Text = row["ManPower"].ToString();
                        manpower.Attributes["runat"] = "server";
                        manpower.AutoPostBack = true;
                        manpower.Enabled = InchargeDepartment.IndexOf(row["Department"].ToString()) >= 0;
                        manpower.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(manpower);
                        t += 1;

                        Label normalworkinghours = new Label();
                        normalworkinghours.ID = "nor" + row["Department"].ToString();
                        normalworkinghours.Text = row["NormalWorkingHours"].ToString();
                        normalworkinghours.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle; text-align:center;";
                        tbrowcell[t].Controls.Add(normalworkinghours);
                        t += 1;

                        TextBox actualworkinghours = new TextBox();
                        actualworkinghours.ID = "awh" + row["Department"].ToString();
                        actualworkinghours.CssClass = "form-control";
                        actualworkinghours.TextMode = TextBoxMode.Number;
                        actualworkinghours.Text = row["ANormalWorkingHours"].ToString();
                        actualworkinghours.Attributes["runat"] = "server";
                        actualworkinghours.AutoPostBack = true;
                        actualworkinghours.Enabled = HasPermission;
                        actualworkinghours.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(actualworkinghours);
                        t += 1;

                        TextBox nonworkinghours = new TextBox();
                        nonworkinghours.ID = "non" + row["Department"].ToString();
                        nonworkinghours.CssClass = "form-control";
                        nonworkinghours.TextMode = TextBoxMode.Number;
                        nonworkinghours.Text = row["Non-WorkingHours"].ToString();
                        nonworkinghours.Attributes["runat"] = "server";
                        nonworkinghours.AutoPostBack = true;
                        nonworkinghours.Enabled = HasPermission;
                        nonworkinghours.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(nonworkinghours);
                        t += 1;

                        if (Request["showRemark"] != null)
                        {
                            TextBox remark = new TextBox();
                            remark.ID = "rem" + row["Department"].ToString();
                            remark.CssClass = "form-control";
                            remark.Text = row["Remark"].ToString();
                            remark.Attributes["runat"] = "server";
                            remark.AutoPostBack = true;
                            remark.Enabled = HasPermission;
                            remark.TextChanged += txtRemark_TextChanged;
                            tbrowcell[t].Controls.Add(remark);
                            t += 1;
                        }


                        TextBox addworkinghours = new TextBox();
                        addworkinghours.ID = "add" + row["Department"].ToString();
                        addworkinghours.CssClass = "form-control";
                        addworkinghours.TextMode = TextBoxMode.Number;
                        addworkinghours.Text = row["Add-WorkingHours"].ToString();
                        addworkinghours.Attributes["runat"] = "server";
                        addworkinghours.AutoPostBack = true;
                        addworkinghours.Enabled = HasPermission;
                        addworkinghours.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(addworkinghours);
                        t += 1;

                        Label totalworkinghour = new Label();
                        totalworkinghour.ID = "tol" + row["Department"].ToString();
                        totalworkinghour.Text = row["TotalWorkingHours"].ToString();
                        totalworkinghour.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle;";
                        tbrowcell[t].Controls.Add(totalworkinghour);
                        t += 1;

                        Label target = new Label();
                        target.ID = "tar" + row["Department"].ToString();
                        target.Text = row["Target"].ToString();
                        target.Attributes["runat"] = "server";
                        tbrowcell[t].Attributes["style"] = "vertical-align: middle; horizontal-align = center;color: forestgreen;font-weight: bold;";
                        tbrowcell[t].Controls.Add(target);
                        t += 1;

                        TextBox outputtarget = new TextBox();
                        outputtarget.ID = "out" + row["Department"].ToString();
                        outputtarget.CssClass = "form-control";
                        outputtarget.TextMode = TextBoxMode.Number;
                        outputtarget.Text = row["CompanyTarget"].ToString();
                        outputtarget.Attributes["runat"] = "server";
                        outputtarget.AutoPostBack = true;
                        outputtarget.Enabled = true;
                        outputtarget.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(outputtarget);
                        t += 1;

                        TextBox mhunitcost = new TextBox();
                        mhunitcost.ID = "uni" + row["Department"].ToString();
                        mhunitcost.CssClass = "form-control";
                        mhunitcost.TextMode = TextBoxMode.Number;
                        mhunitcost.Text = row["ManhourUnitCost"].ToString();
                        mhunitcost.Attributes["runat"] = "server";
                        mhunitcost.AutoPostBack = true;
                        mhunitcost.Enabled = false;
                        mhunitcost.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(mhunitcost);
                        t += 1;

                        TextBox whperday = new TextBox();
                        whperday.ID = "whp" + row["Department"].ToString();
                        whperday.CssClass = "form-control";
                        whperday.TextMode = TextBoxMode.Number;
                        whperday.Text = row["NormalWorkingHourPerday"].ToString();
                        whperday.Attributes["runat"] = "server";
                        whperday.AutoPostBack = true;
                        whperday.Enabled = false;
                        whperday.TextChanged += TextChangedOnTextBox;
                        tbrowcell[t].Controls.Add(whperday);
                        t += 1;

                        //TextBox perform = new TextBox();
                        //perform.ID = "per" + row["Department"].ToString();
                        //perform.CssClass = "form-control";
                        //perform.TextMode = TextBoxMode.Number;
                        //perform.Text = row["Performance%"].ToString();
                        //perform.Attributes["runat"] = "server";
                        //perform.AutoPostBack = true;
                        //perform.Enabled = false;
                        //perform.TextChanged += TextChangedOnTextBox;
                        //tbrowcell[12].Controls.Add(perform);

                        for (int i = 0; i < tbrowcell.Length; i++) { tbrow.Cells.Add(tbrowcell[i]); }
                        tbTargetSetup.Rows.Add(tbrow);
                    }
                    tbTargetSetup.Rows.Add(tbfooterrow);
                }
            }
            catch { }
        }
        private void txtRemark_TextChanged(object sender, EventArgs e)
        {
            try
            {
                TextBox temp = sender as TextBox;
                string dept = temp.ID.Substring(3);
                string sql = "update POR_DailyTarget set Remark = @Remark where ProductionDate=@date and Department = @Department";
                List<string> para = new List<string>() { "@Remark", "@date", "@Department" };
                List<object> paravalue = new List<object>() { temp.Text, txtFromDate.Text, dept };
                SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);
            }
            catch { }
        }

        void tb4_TextChanged(object sender, EventArgs e)
        {

            TextBox txtManpower = (sender as TextBox);
            string copy = Regex.Replace(txtManpower.Text.Trim(), @"\s+", " ");
            List<string> splitPasted = copy.Split(' ').ToList();

            if (splitPasted.Count >= 15)
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                Table tb = (Table)huu1.FindControl("tbTargetSetup");
                List<string> Department = new List<string>() { "WO", "RM", "RM-BOARD", "RM-TIMBER", "FM", "FM-BOARD", "FM-TIMBER", "AS", "SA", "FIN", "IRON", "UPH", "FIT", "TU", "PAC" };
                for (int i = 0; i < tb.Rows.Count; i++)
                {
                    if (Department.IndexOf(tb.Rows[i].Cells[1].Text) >= 0)
                    {
                        string temp = tb.Rows[i].Cells[1].Text;
                        //TextBox manpower = (TextBox)tb.Rows[i].Cells[2].FindControl("man" + temp);
                        Label normalworkinghours = (Label)tb.Rows[i].Cells[3].FindControl("nor" + temp);
                        TextBox anormalworkinghours = (TextBox)tb.Rows[i].Cells[4].FindControl("awh" + temp);
                        TextBox nonworkinghours = (TextBox)tb.Rows[i].Cells[5].FindControl("non" + temp);
                        TextBox addworkinghours = (TextBox)tb.Rows[i].Cells[6].FindControl("add" + temp);
                        Label totalworkinghour = (Label)tb.Rows[i].Cells[7].FindControl("tol" + temp);
                        Label target = (Label)tb.Rows[i].Cells[8].FindControl("tar" + temp);
                        Label idt_target = (Label)tb.Rows[i].Cells[9].FindControl("idt" + temp);
                        //TextBox outputtarget = (TextBox)tb.Rows[i].Cells[9].FindControl("out" + temp);
                        TextBox mhunitcost = (TextBox)tb.Rows[i].Cells[11].FindControl("uni" + temp);
                        TextBox whperday = (TextBox)tb.Rows[i].Cells[12].FindControl("whp" + temp);

                        TextBox wsalary = (TextBox)tb.Rows[i].Cells[10].FindControl("slr" + temp);
                        //TextBox perform = (TextBox)row.Cells[12].FindControl("per" + temp);

                        double man_power = SQRLibrary.ConvertToDouble(splitPasted[Department.IndexOf(temp)].Trim().Replace(",", ""));
                        double normalWHs = man_power * SQRLibrary.ConvertToDouble(whperday.Text); //* SQRLibrary.ConvertToDouble(perform.Text) / 100;
                        double AnormalWHs = SQRLibrary.ConvertToDouble(anormalworkinghours.Text);

                        double totalWHs = AnormalWHs > 0 ? AnormalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text)
                                                         : normalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text);

                        double DIRECT_TARGET = totalWHs * SQRLibrary.ConvertToDouble(mhunitcost.Text);
                        double INDIRECT_TARGET = SQRLibrary.ConvertToDouble(idt_target.Text);

                        normalworkinghours.Text = Math.Round(normalWHs, 2).ToString();
                        totalworkinghour.Text = Math.Round(totalWHs, 2).ToString();
                        target.Text = Math.Round(DIRECT_TARGET + INDIRECT_TARGET, 2).ToString("#,##0.##");

                        double salary = SQRLibrary.ConvertToDouble(wsalary.Text); 

                        string sql = "POR_UpdateDailyTargetSetup @date, @dept, @Manpower, @normalWHs, @anormalWHs, @nonWHs, @addWHs, @totalWHs, @target, @user, @manhourunitcost, @normalWHsperday, @companytarget, @wsalary";
                        List<string> para = new List<string>() { "@date", "@dept", "@Manpower", "@normalWHs", "@anormalWHs", "@nonWHs", "@addWHs", "@totalWHs", "@target", "@user", "@manhourunitcost", "@normalWHsperday", "@companytarget", "wsalary" };
                        List<object> paravalue = new List<object>() { txtFromDate.Text, temp, man_power, normalWHs, AnormalWHs, nonworkinghours.Text, addworkinghours.Text, totalWHs, DIRECT_TARGET, Session["username"].ToString(), mhunitcost.Text, whperday.Text, 0, salary };
                        SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Đã copy xong!','bg-success')", true);
                btnLoad_Click(sender, e);
            }
        }

        void tb3_TextChanged(object sender, EventArgs e)
        {
            
            TextBox txtPasteWSalary = (sender as TextBox);
            string copy = Regex.Replace(txtPasteWSalary.Text.Trim(), @"\s+", " ");
            List<string> splitPasted = copy.Split(' ').ToList();

            if (splitPasted.Count >= 15)
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                Table tb = (Table)huu1.FindControl("tbTargetSetup");
                List<string> Department = new List<string>() { "WO", "RM", "RM-BOARD", "RM-TIMBER", "FM", "FM-BOARD", "FM-TIMBER", "AS", "SA",  "FIN", "IRON", "UPH", "FIT", "TU", "PAC" };
                for (int i = 0; i < tb.Rows.Count; i++)
                {
                    if (Department.IndexOf(tb.Rows[i].Cells[1].Text) >= 0)
                    {
                        string temp = tb.Rows[i].Cells[1].Text;
                        TextBox manpower = (TextBox)tb.Rows[i].Cells[2].FindControl("man" + temp);
                        Label normalworkinghours = (Label)tb.Rows[i].Cells[3].FindControl("nor" + temp);
                        TextBox anormalworkinghours = (TextBox)tb.Rows[i].Cells[4].FindControl("awh" + temp);
                        TextBox nonworkinghours = (TextBox)tb.Rows[i].Cells[5].FindControl("non" + temp);
                        TextBox addworkinghours = (TextBox)tb.Rows[i].Cells[6].FindControl("add" + temp);
                        Label totalworkinghour = (Label)tb.Rows[i].Cells[7].FindControl("tol" + temp);
                        Label target = (Label)tb.Rows[i].Cells[8].FindControl("tar" + temp);
                        Label idt_target = (Label)tb.Rows[i].Cells[9].FindControl("idt" + temp);
                        //TextBox outputtarget = (TextBox)tb.Rows[i].Cells[9].FindControl("out" + temp);
                        TextBox mhunitcost = (TextBox)tb.Rows[i].Cells[11].FindControl("uni" + temp);
                        TextBox whperday = (TextBox)tb.Rows[i].Cells[12].FindControl("whp" + temp);

                        TextBox wsalary = (TextBox)tb.Rows[i].Cells[10].FindControl("slr" + temp);
                        //TextBox perform = (TextBox)row.Cells[12].FindControl("per" + temp);


                        double normalWHs = SQRLibrary.ConvertToDouble(manpower.Text) * SQRLibrary.ConvertToDouble(whperday.Text); //* SQRLibrary.ConvertToDouble(perform.Text) / 100;
                        double AnormalWHs = SQRLibrary.ConvertToDouble(anormalworkinghours.Text);

                        double totalWHs = AnormalWHs > 0 ? AnormalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text)
                                                         : normalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text);

                        double DIRECT_TARGET = totalWHs * SQRLibrary.ConvertToDouble(mhunitcost.Text);
                        double INDIRECT_TARGET = SQRLibrary.ConvertToDouble(idt_target.Text);

                        normalworkinghours.Text = Math.Round(normalWHs, 2).ToString();
                        totalworkinghour.Text = Math.Round(totalWHs, 2).ToString();
                        target.Text = Math.Round(DIRECT_TARGET + INDIRECT_TARGET, 2).ToString("#,##0.##");

                        double salary = SQRLibrary.ConvertToDouble(splitPasted[Department.IndexOf(temp)].Trim().Replace(",", ""));

                        string sql = "POR_UpdateDailyTargetSetup @date, @dept, @Manpower, @normalWHs, @anormalWHs, @nonWHs, @addWHs, @totalWHs, @target, @user, @manhourunitcost, @normalWHsperday, @companytarget, @wsalary";
                        List<string> para = new List<string>() { "@date", "@dept", "@Manpower", "@normalWHs", "@anormalWHs", "@nonWHs", "@addWHs", "@totalWHs", "@target", "@user", "@manhourunitcost", "@normalWHsperday", "@companytarget", "wsalary" };
                        List<object> paravalue = new List<object>() { txtFromDate.Text, temp, manpower.Text, normalWHs, AnormalWHs, nonworkinghours.Text, addworkinghours.Text, totalWHs, DIRECT_TARGET, Session["username"].ToString(), mhunitcost.Text, whperday.Text, 0, salary };
                        SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Đã copy xong!','bg-success')", true);
                btnLoad_Click(sender, e);
            }
        }
        void tb2_TextChanged(object sender, EventArgs e)
        {
            TextBox txtPasteAddWHs = (sender as TextBox);
            string copy = Regex.Replace(txtPasteAddWHs.Text.Trim(), @"\s+", " ");
            List<string> splitPasted = copy.Split(' ').ToList();
            

            if (splitPasted.Count >= 15)
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                Table tb = (Table)huu1.FindControl("tbTargetSetup");
                List<string> Department = new List<string>() { "WO", "RM", "RM-BOARD", "RM-TIMBER", "FM", "FM-BOARD", "FM-TIMBER", "AS", "SA", "FIN", "IRON", "UPH", "FIT", "TU", "PAC" };
                for (int i = 0; i < tb.Rows.Count; i++)
                {
                    if (Department.IndexOf(tb.Rows[i].Cells[1].Text) >= 0)
                    {
                        string temp = tb.Rows[i].Cells[1].Text;
                        TextBox manpower = (TextBox)tb.Rows[i].Cells[2].FindControl("man" + temp);
                        Label normalworkinghours = (Label)tb.Rows[i].Cells[3].FindControl("nor" + temp);
                        TextBox anormalworkinghours = (TextBox)tb.Rows[i].Cells[4].FindControl("awh" + temp);
                        TextBox nonworkinghours = (TextBox)tb.Rows[i].Cells[5].FindControl("non" + temp);
                        //TextBox addworkinghours = (TextBox)tb.Rows[i].Cells[6].FindControl("add" + temp);
                        Label totalworkinghour = (Label)tb.Rows[i].Cells[7].FindControl("tol" + temp);
                        Label target = (Label)tb.Rows[i].Cells[8].FindControl("tar" + temp);
                        Label idt_target = (Label)tb.Rows[i].Cells[9].FindControl("idt" + temp);
                        //TextBox outputtarget = (TextBox)tb.Rows[i].Cells[9].FindControl("out" + temp);
                        TextBox mhunitcost = (TextBox)tb.Rows[i].Cells[11].FindControl("uni" + temp);
                        TextBox whperday = (TextBox)tb.Rows[i].Cells[12].FindControl("whp" + temp);

                        TextBox wsalary = (TextBox)tb.Rows[i].Cells[10].FindControl("slr" + temp);
                        //TextBox perform = (TextBox)row.Cells[12].FindControl("per" + temp);


                        double normalWHs = SQRLibrary.ConvertToDouble(manpower.Text) * SQRLibrary.ConvertToDouble(whperday.Text); //* SQRLibrary.ConvertToDouble(perform.Text) / 100;
                        double AnormalWHs = SQRLibrary.ConvertToDouble(anormalworkinghours.Text);
                        double add_workinghours = SQRLibrary.ConvertToDouble(splitPasted[Department.IndexOf(temp)].Trim().Replace(",", ""));


                        double totalWHs = AnormalWHs > 0 ? AnormalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + add_workinghours
                                                         : normalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + add_workinghours;

                        double DIRECT_TARGET = totalWHs * SQRLibrary.ConvertToDouble(mhunitcost.Text);
                        double INDIRECT_TARGET = SQRLibrary.ConvertToDouble(idt_target.Text);

                        normalworkinghours.Text = Math.Round(normalWHs, 2).ToString();
                        totalworkinghour.Text = Math.Round(totalWHs, 2).ToString();
                        target.Text = Math.Round(DIRECT_TARGET + INDIRECT_TARGET, 2).ToString("#,##0.##");

                        string sql = "POR_UpdateDailyTargetSetup @date, @dept, @Manpower, @normalWHs, @anormalWHs, @nonWHs, @addWHs, @totalWHs, @target, @user, @manhourunitcost, @normalWHsperday, @companytarget, @wsalary";
                        List<string> para = new List<string>() { "@date", "@dept", "@Manpower", "@normalWHs", "@anormalWHs", "@nonWHs", "@addWHs", "@totalWHs", "@target", "@user", "@manhourunitcost", "@normalWHsperday", "@companytarget", "wsalary" };
                        List<object> paravalue = new List<object>() { txtFromDate.Text, temp, manpower.Text, normalWHs, AnormalWHs, nonworkinghours.Text, add_workinghours, totalWHs, DIRECT_TARGET, Session["username"].ToString(), mhunitcost.Text, whperday.Text, "40000000", wsalary.Text };
                        SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Đã copy xong!','bg-success')", true);
                btnLoad_Click(sender, e);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Vui lòng copy ít nhất 16 dòng!','bg-danger')", true);
            }
        }
        void tb1_TextChanged(object sender, EventArgs e)
        {
            TextBox txtPasteNonWHs = (sender as TextBox);
            string copy = Regex.Replace(txtPasteNonWHs.Text.Trim(), @"\s+", " ");
            List<string> splitPasted = copy.Split(' ').ToList();
           
            if (splitPasted.Count >= 15)
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                Table tb = (Table)huu1.FindControl("tbTargetSetup");
                List<string> Department = new List<string>() { "WO", "RM", "RM-BOARD", "RM-TIMBER", "FM", "FM-BOARD", "FM-TIMBER", "AS", "SA", "FIN", "IRON", "UPH", "FIT", "TU", "PAC" };
                for (int i = 0; i < tb.Rows.Count; i++)
                {
                    if (Department.IndexOf(tb.Rows[i].Cells[1].Text) >= 0)
                    {
                        string temp = tb.Rows[i].Cells[1].Text;
                        TextBox manpower = (TextBox)tb.Rows[i].Cells[2].FindControl("man" + temp);
                        Label normalworkinghours = (Label)tb.Rows[i].Cells[3].FindControl("nor" + temp);
                        TextBox anormalworkinghours = (TextBox)tb.Rows[i].Cells[4].FindControl("awh" + temp);
                        //TextBox nonworkinghours = (TextBox)tb.Rows[i].Cells[5].FindControl("non" + temp);
                        TextBox addworkinghours = (TextBox)tb.Rows[i].Cells[6].FindControl("add" + temp);
                        Label totalworkinghour = (Label)tb.Rows[i].Cells[7].FindControl("tol" + temp);
                        Label target = (Label)tb.Rows[i].Cells[8].FindControl("tar" + temp); 
                        Label idt_target = (Label)tb.Rows[i].Cells[9].FindControl("idt" + temp);
                        //TextBox outputtarget = (TextBox)tb.Rows[i].Cells[9].FindControl("out" + temp);
                        TextBox mhunitcost = (TextBox)tb.Rows[i].Cells[11].FindControl("uni" + temp);
                        TextBox whperday = (TextBox)tb.Rows[i].Cells[12].FindControl("whp" + temp);
                        TextBox wsalary = (TextBox)tb.Rows[i].Cells[10].FindControl("slr" + temp);
                        //TextBox perform = (TextBox)row.Cells[12].FindControl("per" + temp);

                        double non_workinghour = SQRLibrary.ConvertToDouble(splitPasted[Department.IndexOf(temp)].Trim().Replace(",", ""));
                        double normalWHs = SQRLibrary.ConvertToDouble(manpower.Text) * SQRLibrary.ConvertToDouble(whperday.Text); //* SQRLibrary.ConvertToDouble(perform.Text) / 100;
                        double AnormalWHs = SQRLibrary.ConvertToDouble(anormalworkinghours.Text);

                        double totalWHs = AnormalWHs > 0 ? AnormalWHs - non_workinghour + SQRLibrary.ConvertToDouble(addworkinghours.Text)
                                                         : normalWHs - non_workinghour + SQRLibrary.ConvertToDouble(addworkinghours.Text);

                        double DIRECT_TARGET = totalWHs * SQRLibrary.ConvertToDouble(mhunitcost.Text);
                        double INDIRECT_TARGET = SQRLibrary.ConvertToDouble(idt_target.Text);

                        normalworkinghours.Text = Math.Round(normalWHs, 2).ToString();
                        totalworkinghour.Text = Math.Round(totalWHs, 2).ToString();
                        target.Text = Math.Round(DIRECT_TARGET + INDIRECT_TARGET, 2).ToString("#,##0.##");

                        

                        string sql = "POR_UpdateDailyTargetSetup @date, @dept, @Manpower, @normalWHs, @anormalWHs, @nonWHs, @addWHs, @totalWHs, @target, @user, @manhourunitcost, @normalWHsperday, @companytarget, @wsalary";
                        List<string> para = new List<string>() { "@date", "@dept", "@Manpower", "@normalWHs", "@anormalWHs", "@nonWHs", "@addWHs", "@totalWHs", "@target", "@user", "@manhourunitcost", "@normalWHsperday", "@companytarget", "wsalary" };
                        List<object> paravalue = new List<object>() { txtFromDate.Text, temp, manpower.Text, normalWHs, AnormalWHs, non_workinghour, addworkinghours.Text, totalWHs, DIRECT_TARGET, Session["username"].ToString(), mhunitcost.Text, whperday.Text, "40000000", wsalary.Text};
                        SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Đã copy xong!','bg-success')", true);
                btnLoad_Click(sender, e);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Vui lòng copy ít nhất 16 dòng!','bg-danger')", true);
            }
        }

        void tb_TextChanged(object sender, EventArgs e)
        {
            TextBox txtPasteActualWHs = (sender as TextBox);
            string copy = Regex.Replace(txtPasteActualWHs.Text.Trim(), @"\s+", " ");
            List<string> splitPasted = copy.Split(' ').ToList();
            
            if (splitPasted.Count >= 15)
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                Table tb = (Table)huu1.FindControl("tbTargetSetup");
                List<string> Department = new List<string>() { "WO", "RM", "RM-BOARD", "RM-TIMBER", "FM", "FM-BOARD", "FM-TIMBER", "AS", "SA", "FIN", "IRON", "UPH", "FIT", "TU", "PAC" };
                for (int i = 0; i < tb.Rows.Count; i++ )
                {
                    if (Department.IndexOf(tb.Rows[i].Cells[1].Text)>=0)
                    {
                        string temp = tb.Rows[i].Cells[1].Text;
                        TextBox manpower = (TextBox)tb.Rows[i].Cells[2].FindControl("man" + temp);
                        Label normalworkinghours = (Label)tb.Rows[i].Cells[3].FindControl("nor" + temp);
                        //TextBox anormalworkinghours = (TextBox)tb.Rows[i].Cells[4].FindControl("awh" + temp);
                        TextBox nonworkinghours = (TextBox)tb.Rows[i].Cells[5].FindControl("non" + temp);
                        TextBox addworkinghours = (TextBox)tb.Rows[i].Cells[6].FindControl("add" + temp);
                        Label totalworkinghour = (Label)tb.Rows[i].Cells[7].FindControl("tol" + temp);
                        Label target = (Label)tb.Rows[i].Cells[8].FindControl("tar" + temp);
                        Label idt_target = (Label)tb.Rows[i].Cells[9].FindControl("idt" + temp);
                        //TextBox outputtarget = (TextBox)tb.Rows[i].Cells[9].FindControl("out" + temp);
                        TextBox mhunitcost = (TextBox)tb.Rows[i].Cells[11].FindControl("uni" + temp);
                        TextBox whperday = (TextBox)tb.Rows[i].Cells[12].FindControl("whp" + temp);

                        TextBox wsalary = (TextBox)tb.Rows[i].Cells[10].FindControl("slr" + temp);
                        //TextBox perform = (TextBox)row.Cells[12].FindControl("per" + temp);


                        double normalWHs = SQRLibrary.ConvertToDouble(manpower.Text) * SQRLibrary.ConvertToDouble(whperday.Text); //* SQRLibrary.ConvertToDouble(perform.Text) / 100;
                        double AnormalWHs = SQRLibrary.ConvertToDouble(splitPasted[Department.IndexOf(temp)].Trim().Replace(",", ""));

                        double totalWHs = AnormalWHs > 0 ? AnormalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text)
                                                         : normalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text);

                        
                        double DIRECT_TARGET = totalWHs * SQRLibrary.ConvertToDouble(mhunitcost.Text);
                        double INDIRECT_TARGET = SQRLibrary.ConvertToDouble(idt_target.Text);

                        normalworkinghours.Text = Math.Round(normalWHs, 2).ToString();
                        totalworkinghour.Text = Math.Round(totalWHs, 2).ToString();
                        target.Text = Math.Round(DIRECT_TARGET + INDIRECT_TARGET, 2).ToString("#,##0.##");


                        string sql = "POR_UpdateDailyTargetSetup @date, @dept, @Manpower, @normalWHs, @anormalWHs, @nonWHs, @addWHs, @totalWHs, @target, @user, @manhourunitcost, @normalWHsperday, @companytarget, @wsalary";
                        List<string> para = new List<string>() { "@date", "@dept", "@Manpower", "@normalWHs", "@anormalWHs", "@nonWHs", "@addWHs", "@totalWHs", "@target", "@user", "@manhourunitcost", "@normalWHsperday", "@companytarget", "wsalary" };
                        List<object> paravalue = new List<object>() { txtFromDate.Text, temp, manpower.Text, normalWHs, AnormalWHs, nonworkinghours.Text, addworkinghours.Text, totalWHs, DIRECT_TARGET, Session["username"].ToString(), mhunitcost.Text, whperday.Text, "40000000", wsalary.Text };
                        SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);                       
                    }
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Đã copy xong!','bg-success')", true);
                btnLoad_Click(sender, e);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System','Vui lòng copy ít nhất 16 dòng!','bg-danger')", true);
            }
            
        }

        private void btn2_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        private void btn1_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        private void btn_Click(object sender, EventArgs e)
        {
            DataTable dt = Library.LibraryFunction.GetDataFromClipboard();
            if (dt != null && dt.Rows.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Đã copy thành công! " + dt.Rows.Count + "', 'bg-success');", true);
               
            }
        }

        private void TextChangedOnTextBox(object sender, EventArgs e)
        {
            try
            {
                string temp = ((TextBox)sender).ID.Substring(3);               
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                Table tb = (Table)huu1.FindControl("tbTargetSetup");

                foreach (TableRow row in tb.Rows)
                {
                    if (row.Cells[1].Text.Equals(temp))
                    {
                        TextBox manpower = (TextBox)row.Cells[2].FindControl("man" + temp);
                        Label normalworkinghours = (Label)row.Cells[3].FindControl("nor" + temp);
                        TextBox anormalworkinghours = (TextBox)row.Cells[4].FindControl("awh" + temp); 
                        TextBox nonworkinghours = (TextBox)row.Cells[5].FindControl("non" + temp);
                        TextBox addworkinghours = (TextBox)row.Cells[6].FindControl("add" + temp);
                        Label totalworkinghour = (Label)row.Cells[7].FindControl("tol" + temp);
                        Label target = (Label)row.Cells[8].FindControl("tar" + temp);
                        Label idt_target = (Label)row.Cells[9].FindControl("idt" + temp);
                        TextBox wsalary = (TextBox)row.Cells[10].FindControl("slr" + temp);
                        TextBox mhunitcost = (TextBox)row.Cells[11].FindControl("uni" + temp);
                        TextBox whperday = (TextBox)row.Cells[12].FindControl("whp" + temp);
                        //TextBox perform = (TextBox)row.Cells[12].FindControl("per" + temp);
                          
                                              
                        double normalWHs = SQRLibrary.ConvertToDouble(manpower.Text) * SQRLibrary.ConvertToDouble(whperday.Text); //* SQRLibrary.ConvertToDouble(perform.Text) / 100;
                        double AnormalWHs = SQRLibrary.ConvertToDouble(anormalworkinghours.Text);

                        double totalWHs = AnormalWHs > 0 ? AnormalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text)
                                                         : normalWHs - SQRLibrary.ConvertToDouble(nonworkinghours.Text) + SQRLibrary.ConvertToDouble(addworkinghours.Text);
                        
                        double DIRECT_TARGET = totalWHs * SQRLibrary.ConvertToDouble(mhunitcost.Text);
                        double INDIRECT_TARGET = SQRLibrary.ConvertToDouble(idt_target.Text);

                        normalworkinghours.Text = Math.Round(normalWHs,2).ToString();
                        totalworkinghour.Text = Math.Round(totalWHs, 2).ToString();
                        target.Text = Math.Round(DIRECT_TARGET + INDIRECT_TARGET, 2).ToString("#,##0.##");

                        string sql = "POR_UpdateDailyTargetSetup @date, @dept, @Manpower, @normalWHs, @anormalWHs, @nonWHs, @addWHs, @totalWHs, @target, @user, @manhourunitcost, @normalWHsperday, @companytarget, @wsalary";
                        List<string> para = new List<string>() { "@date", "@dept", "@Manpower", "@normalWHs", "@anormalWHs", "@nonWHs", "@addWHs", "@totalWHs", "@target", "@user", "@manhourunitcost", "@normalWHsperday", "@companytarget", "@wsalary" };
                        List<object> paravalue = new List<object>() {txtFromDate.Text, temp, manpower.Text, normalWHs, AnormalWHs, nonworkinghours.Text, addworkinghours.Text, totalWHs, DIRECT_TARGET, Session["username"].ToString(), mhunitcost.Text, whperday.Text, 0, wsalary.Text };
                        SQRLibrary.ExecuteSQL_mrp(sql, para, paravalue);
                        break;
                    }
                }                 
            }
            catch { }
        }
        
        private string GetActualTarget(string Department, DataTable data)
        {
            try
            {
                for (int i = 0; i < data.Rows.Count; i++)
                {
                    if (data.Rows[i][0].ToString().Equals(Department))
                    {
                        return data.Rows[i][1].ToString();                       
                    }
                }
                return "0";
            }
            catch { return "0"; }
        }

       

        protected void txtFromDate_TextChanged(object sender, EventArgs e)
        {
            tbTargetSetup.Rows.Clear();
            btnLoad_Click(sender, e);
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            try
            {
                string sql = "update [POR_DailyTarget] set CompanyTarget = 0 where ProductionDate = '" + txtFromDate.Text + "'";
                SQRLibrary.ExecuteSQL_mrp(sql);
                btnLoad_Click(sender, e);
            }
            catch { }
        }

        protected void btnUpdateMHUnitCost_ServerClick(object sender, EventArgs e)
        {
            try
            {
                
                string sql = "EXEC [ALL_Update_ManhourUnitCost_DailyTarget_ByDate] @ProdOrderDate";
                SQRLibrary.ExecuteSQL_mrp(sql
                    , new List<string>() { "@ProdOrderDate" }
                    , new List<object>() { txtFromDate.Text});
                
                btnLoad_Click(sender, e);

                ScriptManager.RegisterStartupScript(this, GetType(), "toast", "ShowToast('Updated MH Unit Cost successfully!','success')", true);
            }
            catch (Exception ex) { ScriptManager.RegisterStartupScript(this, GetType(), "toast", $"ShowToast('Error. {ex.Message}','error')", true); }
        }

        protected void btnUpdateCompanyTarget_ServerClick(object sender, EventArgs e)
        {
            try
            {                
                string sql = "EXEC [ALL_Update_CompanyTarget_DailyTarget_ByDate] @ProdOrderDate";
                SQRLibrary.ExecuteSQL_mrp(sql
                    , new List<string>() { "@ProdOrderDate" }
                    , new List<object>() { txtFromDate.Text });

                btnLoad_Click(sender, e);
                ScriptManager.RegisterStartupScript(this, GetType(), "toast", "ShowToast('Updated output target successfully!','success')", true);
            }
            catch (Exception ex) { ScriptManager.RegisterStartupScript(this, GetType(), "toast", $"ShowToast('Error. {ex.Message}','error')", true); }
        }

        protected void btnClearCompanyTarget_ServerClick(object sender, EventArgs e)
        {
            try
            {
                string sql = "update [POR_DailyTarget] set CompanyTarget = 0 where ProductionDate = '" + txtFromDate.Text + "'";
                SQRLibrary.ExecuteSQL_mrp(sql);
                btnLoad_Click(sender, e);
                ScriptManager.RegisterStartupScript(this, GetType(), "toast", "ShowToast('Clear output target successfully!','success')", true);
            }
            catch { }
        }


        protected void btnCalculateIndirectTarget_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime productionDate;
                decimal totalIndirectManpower;

                if (!DateTime.TryParse(txtFromDate.Text.Trim(), out productionDate))
                {
                    ShowMessage("Invalid Production Date.", "error");
                    return;
                }

                if (!decimal.TryParse(hfTotalIndirectManpower.Value.Trim(), NumberStyles.Any, CultureInfo.InvariantCulture, out totalIndirectManpower))
                {
                    ShowMessage("Invalid Total Indirect Manpower.", "error");
                    return;
                }

                string sql = @"EXEC dbo.ALL_POR_DailyTarget_CalculateIndirectTarget
                        @ProductionDate = @ProductionDate,
                        @TotalIndirectManpower = @TotalIndirectManpower,
                        @UpdateUser = @UpdateUser";

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
                    sql,
                    new List<string>() { "@ProductionDate", "@TotalIndirectManpower", "@UpdateUser" },
                    new List<object>() { productionDate.Date, totalIndirectManpower, Session["userid"] == null ? "" : Session["userid"].ToString() }
                );

                if (dt != null && dt.Rows.Count > 0)
                {
                    int status = Convert.ToInt32(dt.Rows[0]["Status"]);
                    string message = dt.Rows[0]["Message"].ToString();

                    if (status == 1)
                    {
                        ShowMessage(message, "success");
                        LoadData();
                    }
                    else
                    {
                        ShowMessage(message, "error");
                    }
                }
                else
                {
                    ShowMessage("No response from server.", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, "error");
            }
        }

        private void ShowMessage(string message, string icon)
        {
            string script = $@"Swal.fire({{
                icon: '{icon}',
                text: '{message.Replace("'", "\\'")}'
            }});";

            ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script, true);
        }
    }
}
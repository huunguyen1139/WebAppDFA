using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using System.Drawing;
using DevExpress.XtraRichEdit.Fields;
using DevExpress.Web.Internal.XmlProcessor;
using System.Data.SqlClient;
using System.Text;
using Library;
using WebApp.functions.SendEmail;
using System.Threading.Tasks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;

namespace WebApp.production
{
    public partial class ProductionTarget : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            cbAutoRefresh.InputAttributes["class"] = "form-check-input";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session["userid"] == null)
                {
                    string url = HttpContext.Current.Request.Url.AbsolutePath;
                    Response.Redirect("~/Account/Login?Returnurl=" + url);
                }
                if (!IsPostBack)
                {
                    string h = Request.Browser.Browser;
                    h = Request.Browser.Type;
                    h = Request.Browser.Version;
                    h = Request.Browser.Platform;
                    h = Request.Browser.IsMobileDevice.ToString();

                   

                    Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang Production Target " + Request.Browser.Type + " " + Request.Browser.IsMobileDevice.ToString());
                    //HtmlContainerControl masterpage = (HtmlContainerControl)Master.FindControl("MasterBody");
                    //masterpage.Attributes.Add("style", "background-color:#F1F1F1;");

                    if (Request["autorefresh"] != null && Request["autorefresh"] == "true")
                    {
                        HtmlMeta meta = new HtmlMeta();
                        HtmlHead head = (HtmlHead)Page.Header;
                        meta.HttpEquiv = "refresh";
                        meta.Content = "10";
                        meta.Name = "RefreshTimeTag";
                        head.Controls.Add(meta);

                        cbAutoRefresh.Checked = true;
                    }

                    if (Session["fromdate"] != null && Session["todate"] != null)
                    {
                        txtFromDate.Text = Session["fromdate"].ToString();
                        txtToDate.Text = Session["todate"].ToString();
                    }
                    else
                    {
                        txtFromDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                        txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                    }
                    ScriptManager.RegisterStartupScript(this, GetType(), "popup", $"ShowPopup('Updated','POR System2','bg-success')", true);
                    ViewState["Generated"] = "false";

                    DateTime now = DateTime.Now.Date;
                    DateTime firstdayofmonth = new DateTime(now.Year, now.Month, 1);
                    DataTable dtMonth = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC ALL_POR_CalculatePlannedTarget @fromdate, @todate",
                            new List<string>() { "@fromdate", "@todate" }, new List<object>() { firstdayofmonth, now });
                    Session["productiontargetMTD"] = dtMonth;

                    LoadYearToDropdownControlDynamic();
                    btnLoad_Click(sender, e);

                    //ddYear.SelectedValue = DateTime.Now.Year.ToString();
                    //ddMonth.SelectedValue = DateTime.Now.Month.ToString();
                    //ddYear_SelectedIndexChanged(sender, e);
                    ScriptManager.RegisterStartupScript(this, GetType(), "popup", $"ShowPopup('Updated','POR System3','bg-success')", true);
                }
                else
                {
                    if (ViewState["Generated"] != null && ViewState["Generated"].ToString() == "true")
                    {

                        CreateDynamicTableRow();
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "popup", $"ShowPopup('Updated','{ex.ToString()}','bg-success')", true);
            }

            }

        private void LoadYearToDropdownControlDynamic()
        {
            try
            {
                int year_now = DateTime.Now.Year;
                ddYear.Items.Clear();

                for (int i = 2025; i <= year_now + 1; i++)
                {
                    ddYear.Items.Add(i.ToString());
                }

                ddYear.SelectedValue = year_now.ToString();
                ddMonth.SelectedValue = DateTime.Now.Month.ToString();
                ddYear_SelectedIndexChanged(null, null);
            }
            catch { }
        }
        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                tbTarget.Rows.Clear();

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC ALL_POR_CalculatePlannedTarget @fromdate, @todate",
                    new List<string>() { "@fromdate", "@todate" }, new List<object>() { txtFromDate.Text, txtToDate.Text });
                Session["productiontarget"] = dt;
                CreateDynamicTableRow();
                txtDesciptionHeader.InnerText = "Output target from " + txtFromDate.Text + " to " + txtToDate.Text;
                
                ViewState["Generated"] = "true";
                Session["fromdate"] = txtFromDate.Text;
                Session["todate"] = txtToDate.Text;               

            }
            catch
            { }
        }


        private void CreateDynamicTableRow()
        {
            DataTable dt = (DataTable)Session["productiontarget"];

            List<string> ViewColumnList = new List<string>() { "#", "Dept.", "Manpower","In.MP", "E.NormalWHs", "A.NormalWHs"
                    , "TotalWHs", "Salary", "%SLR_MTD", "%SLR.", "Target", "Actual", "F.Actual", "%EffMTD", "%Efficiency" };

            List<string> ViewColumnListName = new List<string>() { "#", "<b>Dept.</b><br>Bộ phận"
                    , "<b>Manpower</b><br>Số lượng<br>công nhân<br>thực tế"
                    , "<b>In.MP</b><br>Số lượng<br>CN gián tiếp"
                    , "<b>E.NorWHs</b><br>Số giờ <br>làm việc <br> ước tính"
                    , "<b>A.NorWHs</b> <br> Số giờ <br>làm việc <br> thực tế"
                    , "<b>TotalWHs</b><br>Tổng giờ <br> làm việc<br>gồm tăng ca"
                    , "<b>Salary</b> <br>Tổng lương <br> công nhân<br> thực tế"
                    , "<b>%SLR_MTD</b><br>Tỷ lệ lương <br>/doanh thu<br> theo tháng"
                    , "<b>%SLR.</b><br>Tỷ lệ <br>lương CN<br>/doanh thu"
                    , "<b>Target</b><br>Doanh thu<br>chỉ tiêu"
                    , "<b>Actual</b><br>Doanh thu<br>thực tế"
                    , "<b>F.Actual</b><br>Doanh thu<br>LSX"
                    , "<b>%EffMTD</b><br>Hiệu quả<br>bộ phận<br>theo tháng"
                    , "<b>%Efficiency</b><br>Hiệu quả<br>bộ phận" };

            DataTable dtMonth = (DataTable)Session["productiontargetMTD"];

            if (dt != null && dt.Rows.Count > 0)
            {
                TableHeaderRow tbheaderrow = new TableHeaderRow();
                TableHeaderCell tbheadercell = new TableHeaderCell();
                TableFooterRow tbfootertow = new TableFooterRow();

                //footerrow and headerrow
                double TotalTarget = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["Target"]));
                double TotalActualTarget = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"]));
                double TotalActualTarget_MTD = dtMonth != null ? dtMonth.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"])) : 0;

                double TotalRate;
                double TotalWSalary = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["WSalary"]));
                double TotalWSalaryRate;

                double TotalWSalary_MTD = dtMonth != null ? dtMonth.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["WSalary"])) : 0;
                double TotalWSalaryRate_MTD;

                double NonWorkingHours = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["Non-WorkingHours"]));

                double ATotalWHours = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["ANormalWorkingHours"]));
                double TotalManhours = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["TotalWorkingHours"]));
                double TotalManpower = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["ManPower"]));
                double TotalInManpower = dt.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["IndirectManPower"]));

                //double PackingOutput = dt.AsEnumerable().Where(x => x["Department"].ToString().Equals("PAC"))
                //.Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"]));
                double OTefficency = ATotalWHours > 0 ? (TotalManhours - ATotalWHours + NonWorkingHours) * 783 / (ATotalWHours * 1.5) : 0;
                double AverageOutputPerManHour;


                TotalRate = TotalTarget > 0 ? 100 * TotalActualTarget / TotalTarget : 0;
                TotalWSalaryRate = TotalActualTarget > 0 ? 100 * TotalWSalary / TotalActualTarget : 0;
                TotalWSalaryRate_MTD = TotalActualTarget_MTD > 0 ? 100 * TotalWSalary_MTD / TotalActualTarget_MTD : 0;

                AverageOutputPerManHour = TotalManhours > 0 ? TotalActualTarget / TotalManhours : 0;
                for (int i=0; i < ViewColumnList.Count; i++)
                {
                    string str = ViewColumnList[i];
                //}    
                //foreach (string str in ViewColumnList)
                //{
                    tbheadercell = new TableHeaderCell();
                    tbheadercell.Text = ViewColumnListName[i];
                    tbheadercell.Attributes["style"] = "text-align: center;";
                    tbheaderrow.Cells.Add(tbheadercell);
                    TableCell tbfootercell = new TableCell();
                    tbfootercell.Attributes["style"] = "text-align: center;";
                    switch (str)
                    {
                        case "Target":
                            tbfootercell.Text = TotalTarget.ToString("#,##0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "Actual":
                            tbfootercell.Text = TotalActualTarget.ToString("#,##0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "%Efficiency":
                            tbfootercell.Text = TotalRate.ToString("#0") + "%";
                            tbfootercell.ForeColor = Color.Yellow;
                            //tbfootercell.CssClass = TotalRate >= 100 ? "btn-success" : TotalRate >= 80 ? "btn-warning" : "btn-danger";
                            break;

                        case "Salary":
                            tbfootercell.Text = TotalWSalary.ToString("#,##0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;

                        case "%SLR.":
                            tbfootercell.Text = TotalWSalaryRate.ToString("#0") + "%";
                            tbfootercell.ForeColor = Color.Yellow;
                            break;

                        case "%SLR_MTD":
                            tbfootercell.Text = TotalWSalaryRate_MTD.ToString("#0") + "%";
                            tbfootercell.ForeColor = Color.Yellow;
                            break;

                        case "Manpower":
                            tbfootercell.Text = TotalManpower.ToString("#0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break; 
                         case "In.MP":
                            tbfootercell.Text = TotalInManpower.ToString("#0.##");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;

                        case "TotalWHs":
                            tbfootercell.Text = TotalManhours.ToString("#0") + "|" + (TotalManhours + NonWorkingHours).ToString("#0");
                            tbfootercell.ToolTip = "Total production time|Total working time";
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "%EffMTD":
                            tbfootercell.Text = AverageOutputPerManHour.ToString("#0.0") + " $/MH";
                            tbfootercell.Font.Bold = true;
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "A.NormalWHs":
                            tbfootercell.Text = ATotalWHours.ToString("#0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "E.NormalWHs":
                            tbfootercell.Text = OTefficency.ToString("#0") + "% OT.Eff";
                            tbfootercell.Font.Bold = true;
                            tbfootercell.ForeColor = Color.Yellow;
                            break;

                    }
                    tbfootertow.Cells.Add(tbfootercell);
                }
                tbheaderrow.TableSection = TableRowSection.TableHeader;
                tbheaderrow.CssClass = "table-primary";
                tbfootertow.TableSection = TableRowSection.TableFooter;

                tbTarget.Rows.Add(tbheaderrow);

                //footerrow and headerrow
                List<string> hide_department = new List<string>() { "WO" };
                TableRow tbrow = new TableRow();
                TableCell[] tbrowcell = new TableCell[ViewColumnList.Count];

                int col = 0;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    col = 0;
                    string current_dept = dt.Rows[i]["Department"].ToString();
                    string isSubDept = dt.Rows[i]["isSubDept"].ToString();
                    string ShowIndex = dt.Rows[i]["ShowIndex"].ToString();
                    if (hide_department.Contains(dt.Rows[i]["Department"].ToString())) continue;

                    tbrow = new TableRow();
                    tbrow.CssClass += isSubDept == "0" ? "parent-row" : $"child-row group{ShowIndex}";
                    tbrow.Attributes["data-group"] = isSubDept == "0" ? $"group{ShowIndex}" : "";

                    tbrowcell = new TableCell[ViewColumnList.Count]; 
                    for (int j = 0; j < tbrowcell.Length; j++) 
                    { 
                        tbrowcell[j] = new TableCell();
                        tbrowcell[j].Attributes["style"] = j == 1 ? isSubDept == "1" ? "" : "" : "text-align: center;";
                        tbrowcell[j].CssClass = j == 1 ? isSubDept == "1" ? "bg-muted" : "bg-secondary" : "";
                    }
                    //tbrowcell[0].Text = dt.Rows[i]["ShowIndex"].ToString();
                    tbrowcell[col].Text = i.ToString();
                    col += 1;

                    LinkButton department = new LinkButton();
                    department.ID = "dep" + dt.Rows[i]["Department"].ToString();
                    //department.Text = dt.Rows[i]["Department"].ToString();
                    department.Text = dt.Rows[i]["DepartmentName_VN"].ToString();
                    department.Attributes["runat"] = "server";
                    department.Click += btn_Click;
                    tbrowcell[col].Controls.Add(department);
                    col += 1;

                    tbrowcell[col].ID = "man" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = SQRLibrary.ConvertToDecimal(dt.Rows[i]["ManPower"]).ToString("#0.##");
                    col += 1;

                    tbrowcell[col].ID = "imp" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = SQRLibrary.ConvertToDecimal(dt.Rows[i]["IndirectManPower"]).ToString("#0.##"); 
                    col += 1;

                    tbrowcell[col].ID = "nor" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = dt.Rows[i]["NormalWorkingHours"].ToString();
                    col += 1;

                    tbrowcell[col].ID = "awh" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = dt.Rows[i]["ANormalWorkingHours"].ToString();
                    col += 1;


                    tbrowcell[col].ID = "tol" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = dt.Rows[i]["TotalWorkingHours"].ToString();
                    col += 1;

                    //WORKER SALARY
                    tbrowcell[col].ID = "slr" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = SQRLibrary.ConvertToDouble(dt.Rows[i]["WSalary"]).ToString("#,##0");
                    col += 1;

                    //MONTH TO DATE WORKER SALARY PERCENT
                    Label lb_MTD_Salary = new Label();
                    double k = 0;
                    double mtd_salary = 0;
                    double mtd_actual_target = 0;

                    //if (i < dtMonth.Rows.Count && SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["ActualTarget"]) > 0)
                    //{
                        mtd_salary = dtMonth.AsEnumerable().Where(x => x["Department"].ToString().Equals(current_dept))
                                                      .Sum(x => SQRLibrary.ConvertToDouble(x["WSalary"]));
                        mtd_actual_target = dtMonth.AsEnumerable().Where(x => x["Department"].ToString().Equals(current_dept))
                                                      .Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"]));
                        k = mtd_actual_target == 0 ? 0 : Math.Round(mtd_salary * 100 / mtd_actual_target, 0);
                    //}
                    
                    lb_MTD_Salary.ID = "mts" + dt.Rows[i]["Department"].ToString();
                    lb_MTD_Salary.Text = k.ToString("#0") + "%";
                    lb_MTD_Salary.Width = 44;
                    lb_MTD_Salary.CssClass = k <= 20 ? "badge text-bg-success" : k <= 25 ? "badge text-bg-info" : k <= 30 ? "badge text-bg-warning" : "badge text-bg-danger";
                    tbrowcell[col].Controls.Add(lb_MTD_Salary);
                    col += 1;


                    //WORKER SALARY PERCENT
                    //Label lb1 = new Label();
                    double k1 = 0;
                    
                    if (SQRLibrary.ConvertToDouble(dt.Rows[i]["ActualTarget"]) > 0)
                    {
                        k1 = Math.Round(SQRLibrary.ConvertToDouble(dt.Rows[i]["WSalary"]) * 100 / SQRLibrary.ConvertToDouble(dt.Rows[i]["ActualTarget"]), 2);
                    } else k1 = 0;
                    //lb1.ID = "rsl" + dt.Rows[i]["Department"].ToString();
                    //lb1.Text = $"{k1.ToString("#0")}%";
                    //lb1.Width = 44;
                    //lb1.CssClass = k1 <=10 ? "badge text-bg-success" : k1 <= 15 ? "badge text-bg-warning" : k1 <= 25 ? "badge text-bg-info" : "badge text-bg-danger";
                    //tbrowcell[8].Controls.Add(lb1);

                    tbrowcell[col].ID = "rsl" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = $"{k1.ToString("#0")}%";
                    tbrowcell[col].CssClass = k1 <= 20 ? "btn-success" : k1 <= 25 ? "btn-info" : k1 <= 30 ? "btn-warning" : "btn-danger";
                    tbrowcell[col].Attributes["style"] = "text-align: center; background-color: var(--bs-btn-bg); color: var(--bs-btn-color)";
                    col += 1;

                    //PLANNED TARGET
                    tbrowcell[col].ID = "tar" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = SQRLibrary.ConvertToDouble(dt.Rows[i]["Target"]).ToString("#,##0");
                    col += 1;

                    //ACTUAL REVENUE
                    tbrowcell[col].ID = "act" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = SQRLibrary.ConvertToLong(dt.Rows[i]["ActualTarget"]).ToString("#,##0");
                    tbrowcell[col].Attributes["style"] = "text-align: center; font-weight: bold; color: blue";
                    col += 1;

                    // FULL ACTUAL REVENUE
                    tbrowcell[col].ID = "fat" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = SQRLibrary.ConvertToLong(dt.Rows[i]["FullActualTarget"]).ToString("#,##0");
                    tbrowcell[col].Attributes["style"] = "text-align: center; font-weight: bold; color: green";
                    col += 1;

                    //MTD efficiency
                    Label MTD_efficiency = new Label();
                    double mtd_eff = 0;
                    double mtd_target = 0;
                    mtd_target = dtMonth.AsEnumerable().Where(x => x["Department"].ToString().Equals(current_dept))
                                                     .Sum(x => SQRLibrary.ConvertToDouble(x["Target"]));
                                
                    mtd_eff = mtd_target == 0 ? 0 : Math.Round(mtd_actual_target * 100 / mtd_target, 0);
                    
                    MTD_efficiency.ID = "mte" + dt.Rows[i]["Department"].ToString();
                    MTD_efficiency.Text = mtd_eff.ToString("#0") + "%";
                    MTD_efficiency.Width = 44;
                    MTD_efficiency.CssClass = mtd_eff >= 100 ? "badge text-bg-success" : mtd_eff >= 90 ? "badge text-bg-info" : mtd_eff >= 80 ? "badge text-bg-warning" : "badge text-bg-danger";
                    tbrowcell[col].Controls.Add(MTD_efficiency);
                    col += 1;

                    //EFFICIENCY
                    double rate = 0;
                    if (SQRLibrary.ConvertToDouble(dt.Rows[i]["Target"]) > 0)
                    {
                        rate = Math.Round(SQRLibrary.ConvertToDouble(dt.Rows[i]["ActualTarget"]) * 100 / SQRLibrary.ConvertToDouble(dt.Rows[i]["Target"]), 0);
                    }
                    tbrowcell[col].ID = "rat" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[col].Text = rate.ToString() + "%";
                    tbrowcell[col].CssClass = rate >= 100 ? "btn-success" : rate >= 90 ? "btn-info" : rate >= 80 ? "btn-warning" : "btn-danger";
                    tbrowcell[col].Attributes["style"] = "text-align: center; background-color: var(--bs-btn-bg); color: var(--bs-btn-color)";
                    col += 1;

                    for (int j = 0; j < tbrowcell.Length; j++) { tbrow.Cells.Add(tbrowcell[j]); }
                    if (i % 2 == 0) tbrow.CssClass += " bg-light";
                    tbTarget.Rows.Add(tbrow);
                }
                tbfootertow.BackColor = System.Drawing.Color.Black;
                tbfootertow.ForeColor = System.Drawing.Color.Yellow;
                tbTarget.Rows.Add(tbfootertow);

                
                //CreateChartScriptString(dt);
            }
        }


        private void CreateDynamicTableRow_OLD()
        {
            DataTable dt = (DataTable)Session["productiontarget"];

            List<string> ViewColumnList = new List<string>() { "#", "Dept.", "Manpower", "E.NormalWHs", "A.NormalWHs"
                    , "TotalWHs", "%Out.MTD", "%EffMTD", "O.Target", "%Output", "Target", "Actual", "%Efficiency" };
          
            DataTable dtMonth = (DataTable)Session["productiontargetMTD"];

            if (dt != null && dt.Rows.Count > 0)
            {
                TableHeaderRow tbheaderrow = new TableHeaderRow();
                TableHeaderCell tbheadercell = new TableHeaderCell();
                TableFooterRow tbfootertow = new TableFooterRow();

                //footerrow and headerrow
                double TotalTarget = dt.AsEnumerable().Sum(x=> SQRLibrary.ConvertToDouble(x["Target"]));
                double TotalActualTarget = dt.AsEnumerable().Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"]));
                double TotalRate;
                double TotalCompanyTarget = dt.AsEnumerable().Sum(x => SQRLibrary.ConvertToDouble(x["CompanyTarget"]));
                double TotalCompanyRate;
                double NonWorkingHours = dt.AsEnumerable().Sum(x => SQRLibrary.ConvertToDouble(x["Non-WorkingHours"]));

                double ATotalWHours = dt.AsEnumerable().Sum(x => SQRLibrary.ConvertToDouble(x["ANormalWorkingHours"]));
                double TotalManhours = dt.AsEnumerable().Sum(x => SQRLibrary.ConvertToDouble(x["TotalWorkingHours"]));
                double TotalManpower = dt.AsEnumerable().Sum(x => SQRLibrary.ConvertToDouble(x["ManPower"]));
                double PackingOutput = dt.AsEnumerable().Where(x => x["Department"].ToString().Equals("PAC"))
                                                      .Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"]));
                double OTefficency = ATotalWHours > 0 ? (TotalManhours - ATotalWHours + NonWorkingHours) * 767 / (ATotalWHours * 1.5) : 0;
                double AverageOutputPerManHour;
               

                TotalRate = TotalTarget > 0 ? 100 * TotalActualTarget /TotalTarget : 0;
                TotalCompanyRate = TotalCompanyTarget > 0 ? 100* TotalActualTarget / TotalCompanyTarget : 0;
               
                AverageOutputPerManHour = TotalManhours > 0 ? PackingOutput / TotalManhours : 0;

                foreach (string str in ViewColumnList)
                {
                    tbheadercell = new TableHeaderCell();
                    tbheadercell.Text = str;
                    tbheadercell.Attributes["style"] = "text-align: center;";
                    tbheaderrow.Cells.Add(tbheadercell);
                    TableCell tbfootercell = new TableCell();
                    tbfootercell.Attributes["style"] = "text-align: center;";
                    switch (str)
                    {
                        case "Target":
                            //tbfootercell.Text = TotalTarget.ToString("#0");                            
                            break;
                        case "Actual":
                            //tbfootercell.Text = TotalActualTarget.ToString("#0");
                            break;
                        case "%Efficiency":
                            tbfootercell.Text = TotalRate.ToString("#0") + "%";
                            tbfootercell.ForeColor = Color.Yellow;
                            //tbfootercell.CssClass = TotalRate >= 100 ? "btn-success" : TotalRate >= 80 ? "btn-warning" : "btn-danger";
                            break;
                        case "O.Target":
                            //tbfootercell.Text = TotalCompanyTarget.ToString();
                            break;

                        case "%Output":
                            tbfootercell.Text = TotalCompanyRate.ToString("#0") + "%";
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "Manpower":
                            tbfootercell.Text = TotalManpower.ToString("#0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "TotalWHs":
                            tbfootercell.Text = TotalManhours.ToString("#0") + "|" + (TotalManhours + NonWorkingHours).ToString("#0");
                            tbfootercell.ToolTip = "Total production time|Total working time";
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "%Out.MTD":
                            tbfootercell.Text = AverageOutputPerManHour.ToString("#0.0") + " $/MH";
                            tbfootercell.Font.Bold = true;
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "A.NormalWHs":
                            tbfootercell.Text = ATotalWHours.ToString("#0");
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                        case "E.NormalWHs":
                            tbfootercell.Text = OTefficency.ToString("#0") + "% OT.Eff";
                            tbfootercell.Font.Bold = true;
                            tbfootercell.ForeColor = Color.Yellow;
                            break;
                                                   
                    }
                    tbfootertow.Cells.Add(tbfootercell);
                }
                tbheaderrow.TableSection = TableRowSection.TableHeader;
                tbfootertow.TableSection = TableRowSection.TableFooter;

                tbTarget.Rows.Add(tbheaderrow);

                //footerrow and headerrow
                List<string> hide_department = new List<string>() { "WO" };
                TableRow tbrow = new TableRow();
                TableCell[] tbrowcell = new TableCell[ViewColumnList.Count];
                for (int i=0; i <dt.Rows.Count; i++)
                {
                    if (hide_department.Contains(dt.Rows[i]["Department"].ToString())) continue;
                    tbrow = new TableRow();
                    tbrowcell = new TableCell[ViewColumnList.Count]; for (int j = 0; j < tbrowcell.Length; j++) { tbrowcell[j] = new TableCell(); tbrowcell[j].Attributes["style"] = "text-align: center;"; }
                    //tbrowcell[0].Text = dt.Rows[i]["ShowIndex"].ToString();
                    tbrowcell[0].Text = i.ToString();
                    LinkButton department = new LinkButton();
                    department.ID = "dep" + dt.Rows[i]["Department"].ToString();
                    department.Text = dt.Rows[i]["Department"].ToString();
                    department.Attributes["runat"] = "server";
                    department.Click += btn_Click;
                    tbrowcell[1].Controls.Add(department);

                    tbrowcell[2].ID = "man" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[2].Text = dt.Rows[i]["ManPower"].ToString();                    

                    tbrowcell[3].ID = "nor" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[3].Text = dt.Rows[i]["NormalWorkingHours"].ToString();

                    tbrowcell[4].ID = "awh" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[4].Text = dt.Rows[i]["ANormalWorkingHours"].ToString();
                   
                    tbrowcell[5].ID = "tol" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[5].Text = dt.Rows[i]["TotalWorkingHours"].ToString();
                   

                    //tbrowcell[6].ID = "uni" + dt.Rows[i]["Department"].ToString();
                    //tbrowcell[6].Text = dt.Rows[i]["ManhourUnitCost"].ToString();
                    Label lb1 = new Label();
                    double k1 = 0;
                    if (SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["CompanyTarget"]) > 0)
                    {
                        k1 = Math.Round(SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["ActualTarget"]) * 100 / SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["CompanyTarget"]), 0);
                    }
                    lb1.ID = "mtp" + dt.Rows[i]["Department"].ToString();
                    lb1.Text = k1.ToString("#0") + "%";
                    lb1.Width = 44;
                    lb1.CssClass = k1 >= 100 ? "badge text-bg-success" : k1 >= 80 ? "badge text-bg-warning" : k1 >= 50 ? "badge text-bg-info" : "badge text-bg-danger";
                    tbrowcell[6].Controls.Add(lb1);


                    Label lb = new Label();
                    double k = 0;
                    if (SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["Target"]) > 0)
                    {
                        k = Math.Round(SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["ActualTarget"]) * 100 / SQRLibrary.ConvertToDouble(dtMonth.Rows[i]["Target"]), 0);
                    }
                    lb.ID = "mte" + dt.Rows[i]["Department"].ToString();
                    lb.Text = k.ToString("#0") + "%";
                    lb.Width = 44;
                    lb.CssClass = k >= 100 ? "badge text-bg-success" : k >= 80 ? "badge text-bg-warning" : k >= 50 ? "badge text-bg-info" : "badge text-bg-danger";
                    tbrowcell[7].Controls.Add(lb);

                    tbrowcell[8].ID = "cst" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[8].Text = SQRLibrary.ConvertToLong(dt.Rows[i]["CompanyTarget"]).ToString("#,##0");

                    double companyrate = 0;
                    if (SQRLibrary.ConvertToDouble(dt.Rows[i]["CompanyTarget"]) > 0)
                    {
                        companyrate = Math.Round(SQRLibrary.ConvertToDouble(dt.Rows[i]["ActualTarget"]) * 100 / SQRLibrary.ConvertToDouble(dt.Rows[i]["CompanyTarget"]), 0);
                    }
                    tbrowcell[9].ID = "cpt" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[9].Text = companyrate.ToString() + "%";
                    tbrowcell[9].CssClass = companyrate >= 100 ? "btn-success" : companyrate >= 80 ? "btn-warning" : "btn-danger";
                    tbrowcell[9].Attributes["style"] = "text-align: center; background-color: var(--bs-btn-bg); color: var(--bs-btn-color)";

                    tbrowcell[10].ID = "tar" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[10].Text = SQRLibrary.ConvertToDouble(dt.Rows[i]["Target"]).ToString("#,##0");

                    tbrowcell[11].ID = "act" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[11].Text = SQRLibrary.ConvertToLong(dt.Rows[i]["ActualTarget"]).ToString("#,##0");
                    tbrowcell[11].Attributes["style"] = "text-align: center; font-weight: bold; color: blue";

                    double rate = 0;
                    if (SQRLibrary.ConvertToDouble(dt.Rows[i]["Target"]) > 0)
                    {
                        rate = Math.Round(SQRLibrary.ConvertToDouble(dt.Rows[i]["ActualTarget"]) * 100/ SQRLibrary.ConvertToDouble(dt.Rows[i]["Target"]),0);
                    }
                    tbrowcell[12].ID = "rat" + dt.Rows[i]["Department"].ToString();
                    tbrowcell[12].Text = rate.ToString() + "%";
                    tbrowcell[12].CssClass = rate >= 100 ? "btn-success" : rate >= 80 ? "btn-warning" : "btn-danger";
                    tbrowcell[12].Attributes["style"] = "text-align: center; background-color: var(--bs-btn-bg); color: var(--bs-btn-color)";

                    for (int j = 0; j < tbrowcell.Length; j++) { tbrow.Cells.Add(tbrowcell[j]); }
                    if (i % 2 == 0) tbrow.CssClass = "bg-light";
                    tbTarget.Rows.Add(tbrow);
                }
                tbfootertow.BackColor = System.Drawing.Color.Black;
                tbfootertow.ForeColor = System.Drawing.Color.Yellow;
                tbTarget.Rows.Add(tbfootertow);

                //CreateChartScriptString(dt);
            }
        }

        private void CreateChartScriptString(DataTable dt)
        {
            try
            {
                string Legend = "";
                string Actual = "";
                string Target = "";
                string Company = "";

                //ScriptManager.RegisterStartupScript(this, this.GetType(), "removejs", "RemovePreviousChart();", true); 
                
                foreach (DataRow row in dt.Rows)
                {
                    Legend += row["Department"].ToString() + "','";
                    Actual += row["ActualTarget"].ToString() + ",";
                    Target += row["Target"].ToString() + ",";
                    Company += row["CompanyTarget"].ToString() + ",";
                }
                if (Legend.Length > 3) Legend = Legend.Substring(0, Legend.Length - 3);
                if (Actual.Length > 1) Actual = Actual.Substring(0, Actual.Length - 1);
                if (Target.Length > 1) Target = Target.Substring(0, Target.Length - 1);
                if (Company.Length > 1) Company = Company.Substring(0, Company.Length - 1);

                string hh = "<script id='huujs'> function CreateChart() {";
                hh += " var n = c3.generate({bindto: '#column-oriented', size: { height: 488 },";

                hh += " data: {";
                hh += "  x: 'x',";
                hh += "  columns: [";
                hh += "  ['x', '" + Legend + "'],";
                hh += "  ['Actual', " + Actual + "],";
                hh += "  ['Target', " + Target + "],";
                hh += "  ['Company Output', " + Company + "],";

                hh += " ],";
                hh += " labels: false,";
                hh += " type: 'spline',";
                hh += " types: { Actual: 'bar' }";
                hh += " },";
                hh += " axis: {";
                hh += " x: { type: 'category', label: { text: 'Department', position: 'outer-center' } },";
                hh += " y: { label: { text: '$ value', position: 'outer-middle' } }";
                hh += " },";
                hh += " grid: { y: { show: !0 } }";
                hh += " });";
                hh += " }; ";

                hh += "$(document).ready(function () { CreateChart(); });";

                hh += " var prm = Sys.WebForms.PageRequestManager.getInstance();";
                hh += " prm.add_endRequest(function () {";
                hh += " CreateChart();";
                hh += " });";
                hh += "</script>";

                 
                Page.ClientScript.RegisterStartupScript(this.GetType(), DateTime.Now.Ticks.ToString(), hh);
                
            }
            catch { }            
        }
        private void btn_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbn = (LinkButton)sender;
                ViewState["Generated"] = "true";
                btnSendDaily.Visible = true;
                ViewState["Department"] = lbn.Text;

                ClickOnDepartmentLabel((LinkButton)sender);
                BuildKpiPivotTable((LinkButton)sender);
            }
            catch { }
        }

        private void BuildKpiPivotTable(LinkButton lb)
        {
            DateTime ToDate = DateTime.ParseExact(txtToDate.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture);
            DateTime begin_week; DateTime end_week;

            LibraryFunction.GetWeekRange(ToDate, out begin_week, out end_week);

            // 1. Get data from SQL (your existing query that returns the "first Excel" layout)
            string filterDept = lb.ID.Substring(3);
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC [ALL_POR_CalculatePlannedTarget_ByDepartmentAndDate] @fromdate, @todate, 1, @dept",
                            new List<string>() { "@fromdate", "@todate", "@dept" }, new List<object>() { begin_week, ToDate, filterDept });

            if (dt == null || dt.Rows.Count == 0)
            {
                litKpiTable.Text = "<div class='alert alert-warning'>No data.</div>";
                return;
            }

            // OPTIONAL: filter by one Department (like your second Excel sheet)
            // If your SQL already filters by department, you can skip this.
            // change or pass as parameter
            var filteredRows = dt.AsEnumerable()
                                 .Where(r => r.Field<string>("Department") == filterDept)
                                 .ToList();

            if (!filteredRows.Any())
            {
                litKpiTable.Text = "<div class='alert alert-warning'>No data for department " + filterDept + ".</div>";
                return;
            }

            // 2. Get distinct ProductionDate as column headers
            var dates = filteredRows
                .Select(r => r.Field<DateTime>("ProductionDate"))
                .Distinct()
                .OrderBy(d => d)
                .ToList();

            // 3. Define metrics in the order you want them to appear (rows)
            //    LEFT = Row label (what user sees)
            //    RIGHT = Column name in DataTable
            var metrics = new (string RowTitle, string Style, string ColumnName)[]
            {
                ("<b>(1) Department - Bộ phận</b>", " color: darkblue",                                   "DepartmentName_VN"),
                ("<b>(2A) ManPower - Số lượng công nhân trực tiếp</b>", " color: darkblue",                  "ManPower"),
                ("<b>(2B) ManPower - Số lượng công nhân gián tiếp</b>", " color: darkblue",                  "IndirectManPower"),
                ("<b>(3) E.NorWHs - Số giờ làm việc ước tính (2A)*7.83</b>", " color: gray" ,                   "NormalWorkingHours"),
                ("<b>(4) A.NorWHs - Số giờ làm việc thực tế</b>", " color: gray",                     "ANormalWorkingHours"),
                
                ("<b>(5) TotalWorkingHours - Tổng giờ làm việc thực tế gồm tăng ca</b>", " color: crimson",       "TotalWorkingHours"),
                ("<b>(6) Target - Doanh thu chỉ tiêu 6.1 + 6.2</b>", " color: crimson",                            "Target"),
                ("(6.1) Direct Target - Doanh thu chỉ tiêu trực tiếp (5)*(12)", " color: crimson",                            "DirectTarget"),
                ("(6.2) Indirect Target - Doanh thu chỉ tiêu gián tiếp 2B * 2.130.000", " color: crimson",                            "IndirectTarget"),
                ("<b>(7) ActualTarget - Doanh thu thực tế</b>", " color: blue",                       "ActualTarget"),
                ("<b>(8) TargetPer - Hiệu quả bộ phận (7):(6)</b>", " color: gray",                           "TargetPer"),


                ("<b>(9) Wsalary - Tổng lương công nhân thực tế</b>", " color: green",                 "Wsalary"),
                ("<b>(10) SalaryPer - Tỷ lệ lương CN /doanh thu (9):(7)</b>", " color: gray",                 "SalaryPer"),


                ("<b>(11) FullActualTarget - Doanh thu LSX</b>", " color: darkviolet",                      "FullActualTarget"),
                ("<b>(12) ManhourUnitCost -Chỉ tiêu doanh thu /giờ</b>", " color: gray",              "ManhourUnitCost"),
                ("<b>(13) SalaryPerMan - Doanh thu trung bình thực tế /ngày 7.83*(7):(5)</b>", " color: gray",           "SalaryPerMan"),
                ("<b>(14) Non-WorkingHours - Số giờ không tham gia sản xuất</b>", " color: gray",                                      "Non-WorkingHours"),
                ("<b>(15) Add-WorkingHours - Số giờ tăng ca</b>", " color: gray",                                      "Add-WorkingHours"),
            };

            // 4. Build HTML table
            var sb = new StringBuilder();

            sb.AppendLine("<table class='table table-striped table-bordered table-sm'>");

            // 4.1 Header row
            sb.AppendLine("  <thead>");
            sb.Append("    <tr>");
            sb.Append("<th>Metric</th>");
            foreach (var d in dates)
            {
                // format date as you like: yyyy-MM-dd or dd/MM/yyyy
                sb.AppendFormat("<th style='text-align:right'>{0}<br>{1}</th>", d.ToString("yyyy-MM-dd"), d.ToString("dddd"));
            }
            sb.AppendLine("</tr>");
            sb.AppendLine("  </thead>");

            // 4.2 Body rows
            sb.AppendLine("  <tbody>");

            

            foreach (var metric in metrics)
            {
                sb.Append("    <tr>");

                // First column = metric name
                sb.AppendFormat("<th style='{0}'>{1}</th>", metric.Style, metric.RowTitle);

                foreach (var d in dates)
                {
                    var row = filteredRows
                        .FirstOrDefault(r => r.Field<DateTime>("ProductionDate") == d);

                    string cellValue = string.Empty;

                    if (row != null && dt.Columns.Contains(metric.ColumnName))
                    {
                        object val = row[metric.ColumnName];
                        if (val != DBNull.Value)
                        {
                            if (val is decimal || val is double || val is float || val is int || val is long || SQRLibrary.ConvertToDecimal(val) > 0)
                            {
                                cellValue = Convert.ToDecimal(val).ToString("#,##0");
                            }
                            else
                            {
                                cellValue = val.ToString();
                            }
                        }
                    }

                    // 🔹 Decide if we should show this value as a badge
                    string cellHtml;

                    // Example 1: badge for Performance%
                    if (metric.ColumnName == "TargetPer" && !string.IsNullOrEmpty(cellValue))
                    {
                        decimal perf;
                        if (decimal.TryParse(cellValue, out perf))
                        {
                            string badgeClass;

                            if (perf >= 100)
                                badgeClass = "badge bg-success";        // green
                            else if (perf >= 90)
                                badgeClass = "badge bg-info text-dark"; // yellow
                            else if (perf >= 80)
                                badgeClass = "badge bg-warning text-dark";
                            else
                                badgeClass = "badge bg-danger";         // red

                            cellHtml = $"<span class=\"{badgeClass}\">{cellValue}%</span>";
                        }
                        else
                        {
                            cellHtml = cellValue; // fallback
                        }
                    }
                    // Example 2: badge for CompanyTarget (just to show how to add another rule)
                    else if (metric.ColumnName == "SalaryPer" && !string.IsNullOrEmpty(cellValue))
                    {
                        decimal perf;
                        if (decimal.TryParse(cellValue, out perf))
                        {
                            string badgeClass;

                            if (perf <= 20)
                                badgeClass = "badge bg-success";        // green
                            else if (perf <= 25)
                                badgeClass = "badge bg-info"; // yellow
                            else if (perf <= 30)
                                badgeClass = "badge bg-warning text-dark";
                            else
                                badgeClass = "badge bg-danger";         // red

                            cellHtml = $"<span class=\"{badgeClass}\">{cellValue}%</span>";
                        }
                        else
                        {
                            cellHtml = cellValue; // fallback
                        }
                    }
                    // Example 3: badge for Department (just as a label)
                    else if (metric.ColumnName == "ActualTarget" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: blue\">{cellValue}</span>";
                    }
                    else if (metric.ColumnName == "Wsalary" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: green\">{cellValue}</span>";
                    }
                    else if (metric.ColumnName == "FullActualTarget" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: darkviolet\">{cellValue}</span>";
                    }
                    else if (metric.ColumnName == "TotalWorkingHours" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: crimson\">{cellValue}</span>";
                    }
                    else if (metric.ColumnName == "Target" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: crimson\">{cellValue}</span>";
                    }
                    else if (metric.ColumnName == "DepartmentName_VN" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: darkblue\">{cellValue}</span>";
                    }
                    else if (metric.ColumnName == "ManPower" && !string.IsNullOrEmpty(cellValue))
                    {
                        cellHtml = $"<span style=\"font-weight: bold; color: darkblue\">{cellValue}</span>";
                    }
                    else 
                    {
                        // normal cell, no badge
                        cellHtml = cellValue;
                    }

                    sb.AppendFormat("<td style='text-align:right'>{0}</td>", cellHtml);
                }

                sb.AppendLine("</tr>");
            }


            sb.AppendLine("  </tbody>");
            sb.AppendLine("</table>");

            // 5. Render to page
            litKpiTable.Text = sb.ToString();
        }
               

        private string ReturnCssForTop10Target(List<double> listcontrolvalue, double controlvalue)
        {
            int position = listcontrolvalue.Count(x => x > controlvalue) + 1;
            if (position <= 3) return "label label-success";
            if (position <= 6) return "label label-info";
            if (position <= 8) return "label label-warning"; 
            return "label label-danger";
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

        protected void cbAutoRefresh_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbAutoRefresh.Checked)
                {
                    Response.Redirect("ProductionTarget.aspx?autorefresh=true");
                }
                else
                {
                    Response.Redirect("ProductionTarget.aspx");
                }
                
            }
            catch { }
        }

        protected void txtFromDate_TextChanged(object sender, EventArgs e)
        {
            Session["fromdate"] = txtFromDate.Text;
            string fromDate = txtFromDate.Text.Trim();
            string toDate = txtToDate.Text.Trim();
            string url = $"PlannedTargetReport.aspx?fromDate={fromDate}&toDate={toDate}";           
            
            txtDesciptionHeader.InnerHtml = $"<a href='{url}' target='_blank'>Output target from " + txtFromDate.Text + " to " + txtToDate.Text + "</a>";
            btnLoad_Click(sender, e);
        }

        protected void txtToDate_TextChanged(object sender, EventArgs e)
        {
            Session["todate"] = txtToDate.Text;
            //txtDesciptionHeader.InnerText = "Output target from " + txtFromDate.Text + " to " + txtToDate.Text;
            string fromDate = txtFromDate.Text.Trim();
            string toDate = txtToDate.Text.Trim();
            string url = $"PlannedTargetReport.aspx?fromDate={fromDate}&toDate={toDate}";

            txtDesciptionHeader.InnerHtml = $"<a href='{url}' target='_blank'>Output target from " + txtFromDate.Text + " to " + txtToDate.Text + "</a>";
            btnLoad_Click(sender, e);
        }

        private void ClickOnDepartmentLabel(LinkButton lb)
        {
            string department = lb.ID.Substring(3);
            List<string> huu = new List<string>() { "RM-BOARD", "RM-TIMBER", "FM-BOARD", "FM-TIMBER" };
            if (huu.Contains(department))
            {
                string Department = department.Split('-')[0];
                string SubDepartment = department;

                string sqlSubDepartment = "EXEC [ALL_OUTPUT_GetProductionSUBOutputDetailWithRevenue] '" + txtFromDate.Text + "','" + txtToDate.Text + "', '" + Department + "'";

                DataTable dtSubDepartment = SQRLibrary.ReturnDatatablefromSQL(sqlSubDepartment);
                gvDetailOutput.Columns.Clear();
                gvDetailOutput.Caption = "Output and Revenue Detail: " + SubDepartment + " from " + txtFromDate.Text + " to " + txtToDate.Text;

                List<string> hidecl = new List<string>() { "RowIndex" };
                foreach (DataColumn cl in dtSubDepartment.Columns)
                {
                    if (!hidecl.Contains(cl.ColumnName)) gvDetailOutput.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                }
                //department need views revenue detail by user, not by sub department ("AS")
                List<string> dept = new List<string>() { "AS" };
                gvDetailOutput.Visible = true;
                gvDetailOutput.AutoGenerateColumns = false;
                gvDetailOutput.DataSource = dtSubDepartment.Select(dept.Contains(Department) ? $"UpdatedUserID = '{SubDepartment}'" : $"SubGroup = '{SubDepartment}'").CopyToDataTable();
                gvDetailOutput.DataBind();
                gvDetailOutput.Columns[13].HeaderStyle.Width = Unit.Pixel(400);
                gvDetailOutput.Columns[13].ItemStyle.Width = Unit.Pixel(400);
            }
            else
            {
                string sql = "EXEC ALL_OUTPUT_GetProductionOutputDetailWithRevenue '" + txtFromDate.Text + "','" + txtToDate.Text + "', '" + department + "'";
                string sqlSubDepartment = "EXEC [ALL_REVENUE_CalculateRevenueByGroupAndSubGroup] '" + txtFromDate.Text + "','" + txtToDate.Text + "', '" + department + "'";

                if (department == "AS") sqlSubDepartment = "EXEC [ALL_REVENUE_CalculateRevenueByGroupAndUser] '" + txtFromDate.Text + "','" + txtToDate.Text + "', '" + department + "'";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql);
                DataTable dtSubDepartment = SQRLibrary.ReturnDatatablefromSQL(sqlSubDepartment);
                gvDetailOutput.Columns.Clear();
                gvDetailOutput.Caption = "Production Output Detail: " + lb.Text + " from " + txtFromDate.Text + " to " + txtToDate.Text;

                rptSubDepartmentRevenue.DataSource = dtSubDepartment;
                rptSubDepartmentRevenue.DataBind();
                rptSubDepartmentRevenue.Visible = true;



                List<string> hidecl = new List<string>() { "RowIndex", "AllowTimeDelete", "isAdjust" };
                foreach (DataColumn cl in dt.Columns)
                {
                    if (!hidecl.Contains(cl.ColumnName)) gvDetailOutput.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                }

                gvDetailOutput.Visible = true;
                gvDetailOutput.AutoGenerateColumns = false;
                gvDetailOutput.DataSource = dt;
                
                gvDetailOutput.DataBind();
                gvDetailOutput.Columns[17].HeaderStyle.Width = Unit.Pixel(400);
                gvDetailOutput.Columns[17].ItemStyle.Width = Unit.Pixel(400);
            }
        }

        protected void ddYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sql = "select [Target] from POR_MonthlyTarget where [Year]=" + ddYear.SelectedValue + " and [Month]=" + ddMonth.SelectedValue;
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                long MonthTarget = dt.Rows.Count > 0 ? SQRLibrary.ConvertToLong(dt.Rows[0][0]) : 0;

                DateTime startdate = new DateTime(SQRLibrary.ConvertToInt(ddYear.SelectedValue), SQRLibrary.ConvertToInt(ddMonth.SelectedValue), 1);
                DateTime enddate = startdate.AddMonths(1);
                enddate = enddate.AddDays(-1);
                //DataTable dtTarget = SQRLibrary.ReturnDatatablefromSQL_mrp("[POR_CalculateOutputKPI] '" + startdate.ToString("yyyy-MM-dd") + "','" + enddate.ToString("yyyy-MM-dd") + "', 1");
                DataTable dtTarget = (DataTable)Session["productiontargetMTD"];
                //SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_POR_CalCompanyOutput] '" + startdate.ToString("yyyy-MM-dd") + "','" + enddate.ToString("yyyy-MM-dd") + "'");
               
                double ActualTarget = dtTarget.Rows.Count > 0 ? dtTarget.AsEnumerable().Where(x => x["isSubDept"].ToString() == "0").Sum(x => SQRLibrary.ConvertToDouble(x["ActualTarget"])) : 0;
                    
                double PercentTarget = MonthTarget > 0 ? 100 * ActualTarget / MonthTarget : 0;

                txtTargetPercent.InnerText = PercentTarget.ToString("#0") + "%";
                txtTargetData.InnerText = "P.L: " + MonthTarget.ToString("#,##0") + " | " + "A.S: " + ActualTarget.ToString("#,##0");
                divTargetBar.Attributes["style"] = PercentTarget <=100 ? "width:" + PercentTarget.ToString("#0") + "%" : "width: 100%";
                divTargetBar.Attributes["class"] = PercentTarget >= 100 ? "progress-bar progress-bar-striped progress-bar-animated text-bg-success" : PercentTarget >= 80 ? "progress-bar progress-bar-striped progress-bar-animated text-bg-warning" : PercentTarget >= 50 ? "progress-bar progress-bar-striped progress-bar-animated text-bg-info" : "progress-bar progress-bar-striped progress-bar-animated text-bg-danger";
                ScriptManager.RegisterStartupScript(this, GetType(), "popup", $"ShowPopup('Updated','POR System','bg-success')", true);
            }
            catch (Exception ex) { ScriptManager.RegisterStartupScript(this, GetType(), "popup", $"ShowPopup('{ex.Message}','POR System','bg-danger')", true); }
        }

        protected void btnCloseModal_ServerClick(object sender, EventArgs e)
        {
            divModalForFullPostBack.Attributes["class"] = "modal fade";
            divModalForFullPostBack.Attributes["style"] = "";
        }

        protected void gvDetailOutput_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    // Format date
                    DateTime orderDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "ProdOrderDate"));
                    e.Row.Cells[5].Text = orderDate.ToString("dd-MM-yyyy");

                    // Format number
                    decimal quantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity"));
                    e.Row.Cells[3].Text = quantity.ToString("#,##0.##"); // e.g., 1,234.56

                    decimal RemainQuantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "RemainQuantity"));
                    e.Row.Cells[7].Text = RemainQuantity.ToString("#,##0.##"); // e.g., 1,234.56

                    decimal price = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Price"));
                    e.Row.Cells[9].Text = price.ToString("#,##0"); // e.g., 1,234.56

                    decimal Percent = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Percent"))/100;
                    e.Row.Cells[13].Text = Percent.ToString("P2"); // e.g., 1,234.56

                    decimal Revenue = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Revenue"));
                    e.Row.Cells[14].Text = Revenue.ToString("#,##0"); // e.g., 1,234.56

                    decimal FullRevenue = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "FullRevenue"));
                    e.Row.Cells[15].Text = FullRevenue.ToString("#,##0");

                    decimal ValueQuantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "ValueQuantity"));
                    e.Row.Cells[4].Text = ValueQuantity.ToString("#,##0.##");
                }
            }
            catch { }
        }

        protected void rptSubDepartmentRevenue_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "viewDetail")
                {
                    string Department = e.CommandArgument.ToString().Split('|')[1];
                    string SubDepartment = e.CommandArgument.ToString().Split('|')[0];

                    string sqlSubDepartment = "EXEC [ALL_REVENUE_CalculateRevenueByDocumentAndGroupAndSubGroup] '" + txtFromDate.Text + "','" + txtToDate.Text + "', '" + Department + "'";
                    
                    DataTable dtSubDepartment = SQRLibrary.ReturnDatatablefromSQL(sqlSubDepartment);
                    gvSubDepartmentDetail.Columns.Clear();
                    gvSubDepartmentDetail.Caption = "Output and Revenue Detail: " + SubDepartment + " from " + txtFromDate.Text + " to " + txtToDate.Text;

                    List<string> hidecl = new List<string>() { "RowIndex" };
                    foreach (DataColumn cl in dtSubDepartment.Columns)
                    {
                        if (!hidecl.Contains(cl.ColumnName)) gvSubDepartmentDetail.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                    }
                    //department need views revenue detail by user, not by sub department ("AS")
                    List<string> dept = new List<string>() { "AS"};
                    gvSubDepartmentDetail.Visible = true;
                    gvSubDepartmentDetail.AutoGenerateColumns = false;
                    gvSubDepartmentDetail.DataSource = dtSubDepartment.Select(dept.Contains(Department) ? $"UpdatedUserID = '{SubDepartment}'" : $"SubGroup = '{SubDepartment}'").CopyToDataTable();
                    gvSubDepartmentDetail.DataBind();
                }
            }
            catch { }
        }

        protected void gvSubDepartmentDetail_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {                   
                    DateTime orderDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "PostingDate"));
                    e.Row.Cells[3].Text = orderDate.ToString("dd-MM-yyyy");
                    
                    decimal quantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity"));
                    e.Row.Cells[4].Text = quantity.ToString("#,##0.##"); 
                                       
                    decimal price = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "SalesPrice"));
                    e.Row.Cells[5].Text = price.ToString("#,##0"); 

                    decimal Percent = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "PC"))/100;
                    e.Row.Cells[6].Text = Percent.ToString("P0"); 

                    decimal Revenue = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Revenue"));
                    e.Row.Cells[7].Text = Revenue.ToString("#,##0");                    
                }
            }
            catch { }
        }

        protected void gvDetailOutput_RowCreated(object sender, GridViewRowEventArgs e)
        {
            // Safety: make sure the row has enough cells
            if (e.Row.Cells.Count > 16 &&
                (e.Row.RowType == DataControlRowType.Header ||
                 e.Row.RowType == DataControlRowType.DataRow))
            {
                e.Row.Cells[16].Style["width"] = "400px";
                e.Row.Cells[16].Style["max-width"] = "400px";
                e.Row.Cells[16].Style["min-width"] = "400px";
                //e.Row.Cells[16].Style["white-space"] = "nowrap";

                e.Row.Cells[16].Style["white-space"] = "normal";
                e.Row.Cells[16].Style["word-wrap"] = "break-word";
                e.Row.Cells[16].Style["overflow-wrap"] = "break-word";
            }
        }

        protected void btnSendDailyServer_Click(object sender, EventArgs e)
        {
            try
            {
                // 1) Get HTML + comment posted from client
                string htmlBlock = hfDailyHtml.Value ?? string.Empty;
                string comment = hfDailyComment.Value ?? string.Empty;

                htmlBlock = LibraryFunction.ConvertBadgeToInline(htmlBlock);
                htmlBlock = LibraryFunction.ConvertTableToInline(htmlBlock);

                if (string.IsNullOrWhiteSpace(htmlBlock))
                    throw new Exception("No HTML content captured from the page.");

                // 2) Build model for template (Scriban model object)
                var model = new
                {
                    Department = ViewState["Department"]?.ToString() ?? "",
                    Date = txtToDate.Text,
                    UserName = $"{(string)Session["Username"]} - {(string)Session["UserRole"]}",
                    Comment = comment,
                    HtmlBlock = htmlBlock
                };

                // 3) Render email from template code DAILY_PROD_STATUS
                //var rendered = EmailTemplateEngine.Render("DAILY_PROD_STATUS", model);
                //string subject = rendered.Subject;
                //string body = rendered.Body;
                //bool isHtml = rendered.IsHtml;

                // 4) Get recipients from DB
                DataTable dtRecipients = SQRLibrary.ReturnDatatablefromSQL_mrp(
                    $@"SELECT e.Email FROM Employee e  
                          INNER JOIN [APPROVAL_NotifyGroupMembers] m ON e.EmployeeID = m.UserId 
                          INNER JOIN [APPROVAL_NotifyGroups] h ON m.GroupId = h.GroupId AND h.GroupCode=@Group
                      UNION
                      SELECT Email FROM Employee WHERE EmployeeID = '{(string)Session["userid"]}'",
                    new List<string> { "@Group" },
                    new List<object> { "PROD_STATUS" });

                if (dtRecipients.Rows.Count == 0)
                    throw new Exception("No recipients configured for DAILY_PROD_STATUS group.");

                string toList = string.Join(";",
                    dtRecipients.AsEnumerable()
                                .Select(r => r["Email"].ToString())
                                .Where(x => !string.IsNullOrWhiteSpace(x)));

                // 5) Send email
                //EmailHelper.Send(toList, subject, body, isHtml);
                Task.Run(async () => await EmailHelper.SendAsyncByTemplate("DAILY_PROD_STATUS", model, toList));
                // 6) Show success message to user
                ScriptManager.RegisterStartupScript(this, GetType(), "daily-ok",
                    "Swal.fire('Sent','Daily production status email has been sent.','success');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "daily-err",
                    "Swal.fire('Error','" + Js(ex.Message) + "','error');", true);
            }
        }

        // Escape string for JavaScript
        private static string Js(string s)
        {
            return System.Web.HttpUtility.JavaScriptStringEncode(s ?? string.Empty);
        }

        

    }
}
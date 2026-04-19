using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using Library;

namespace WebApplication2.kpi
{
    public partial class KPIResult : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang KPI Result " + Request.Browser.Type + " " + Request.Browser.IsMobileDevice.ToString());
                txtKPIMonth.Text = Session["txtKPIMonth"] != null ? Session["txtKPIMonth"].ToString() : DateTime.Now.Year.ToString("0###") + "-" + DateTime.Now.Month.ToString("0#");
            }
            else
            {                
                CreateDynamicControls();
            }
            //txtKPIMonth.Text = Session["txtKPIMonth"] != null ? Session["txtKPIMonth"].ToString() : DateTime.Now.Year.ToString("0###") + "-" + DateTime.Now.Month.ToString("0#");
        }

        protected void btnLoad_ServerClick(object sender, EventArgs e)
        {
            try
            {
                DateTime today = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                DateTime startdate = new DateTime(SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)), 1);
                DateTime enddate = startdate.AddMonths(1);
                enddate = enddate.AddDays(-1);

                enddate = today > enddate ? enddate : today;

                string typeofemployee = Request["type"].ToString() ?? "Supervisor";
                Session["txtKPIMonth"] = txtKPIMonth.Text;
                //get KPIEmployee list
                DataTable KPIEmployee = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT *, (select top 1 Code from Team t where t.TeamLeader=e.EmployeeCode) TeamCode FROM KPI_Employee e WHERE Type=@Type and ((Active = 1 and StartDate <= @todate) or (Active=0 and FinishDate>=@fromdate and StartDate<=@todate)) ORDER BY DCodePOR asc"
                    , new List<string>() { "@Type", "@fromdate", "@todate" }, new List<object>() { typeofemployee, startdate.ToString("yyyy-MM-dd"), enddate.ToString("yyyy-MM-dd") });
                
                //get KPICriterion Header
                DataTable KPICriterion = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM KPI_CriterionHeader where Type=@Type and AppliedDate <= @startdate order by AppliedDate desc"
                    , new List<string>() { "@Type", "@startdate" }, new List<object>() { typeofemployee, startdate.ToString("yyyy-MM-dd") });

                DataRow KPICriterionRow = KPICriterion.Rows[0] ?? null;

                DataTable KPICriterionLine = KPICriterionRow != null ? SQRLibrary.ReturnDatatablefromSQL_mrp("select *, (SELECT max(Point) from KPI_CriterionPoint e WHERE e.Code= c.Code and e.CriterionCode=c.CriterionCode) MaxPoint from KPI_CriterionLine c where CriterionCode=@CriterionCode"
                    , new List<string>() { "@CriterionCode" }, new List<object>() { KPICriterionRow["Code"].ToString()}) : null;

                DataTable KPICriterionPoint = KPICriterionRow != null ? SQRLibrary.ReturnDatatablefromSQL_mrp("select * from KPI_CriterionPoint where CriterionCode=@CriterionCode"
                    , new List<string>() { "@CriterionCode" }, new List<object>() { KPICriterionRow["Code"].ToString() }) : null;

                DataTable KPIBonusAmount = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM KPI_BonusAmount WHERE Type=@Type", new List<string>() { "@Type" }, new List<object>() { Request["type"].ToString() });
                

                DataTable KPICalculateResult = CopyDataTableFrom(KPIEmployee);

                foreach (DataRow row in KPICriterionLine.Rows)
                {
                    KPICalculateResult.Columns.Add("Achievement" + row["Code"].ToString());
                    KPICalculateResult.Columns.Add("Point" + row["Code"].ToString());
                }
                KPICalculateResult.Columns.Add("TotalPoint");
                KPICalculateResult.Columns.Add("TotalBonus");

                DataTable[] AchievementTable = GetAchievementTables(KPICriterionLine, startdate, enddate);
                
                //lookup achievement and calculate point
                decimal tempachievementresult = 0;
                decimal temppointresult = 0;
                decimal totalpoint = 0;
                decimal additionalbonus = 0;
                decimal totalbonus = 0;
                foreach (DataRow row in KPICalculateResult.Rows)
                {
                    totalpoint = 0;
                    additionalbonus = 0;
                    totalbonus = 0;
                    for (int i = 0; i < KPICriterionLine.Rows.Count; i++ )
                    {
                        tempachievementresult = SQRLibrary.ConvertToDecimal(LookupAchievement(row, AchievementTable[i], KPICriterionLine.Rows[i]["JoinColumn"].ToString(), KPICriterionLine.Rows[i]["ReturnColumn"].ToString()));
                        row["Achievement" + KPICriterionLine.Rows[i]["Code"].ToString()] = tempachievementresult;

                        temppointresult = SQRLibrary.ConvertToDecimal(CalculatePoint(tempachievementresult, KPICriterionPoint, KPICriterionLine.Rows[i]["CriterionCode"].ToString(), KPICriterionLine.Rows[i]["Code"].ToString()));
                        row["Point" + KPICriterionLine.Rows[i]["Code"].ToString()] = temppointresult;

                        totalpoint += temppointresult * SQRLibrary.ConvertToDecimal(KPICriterionLine.Rows[i]["PercentRate"]) / 100;
                    }

                    row["TotalPoint"] = SQRLibrary.ConvertToDecimal(KPICriterionRow["MaximumStandardPoint"]) != 0 ?
                        Math.Round(totalpoint / SQRLibrary.ConvertToDecimal(KPICriterionRow["MaximumStandardPoint"]), 2)
                        : 0;

                    //try
                    //{
                    //    if (Request["type"].ToString().Equals("Worker") && (SQRLibrary.ConvertToDecimal(row["Achievement" + KPICriterionLine.Rows[0]["Code"].ToString()]) >= (decimal)1.1))
                    //    {
                    //        additionalbonus = (int)100000;
                    //    }
                    //}
                    //catch { }

                    totalbonus = SQRLibrary.ConvertToDecimal(CalculateBonus(SQRLibrary.ConvertToDecimal(row["TotalPoint"]), KPIBonusAmount));
                     totalbonus = totalbonus > 0 ? totalbonus + additionalbonus : 0;
                     row["TotalBonus"] = totalbonus;
                }

                //LibraryFunction.LoadDataTableToGridView(huu1, KPICalculateResult);
                Session["KPIResultSupervisor"] = KPICalculateResult;
                Session["KPICriterionLineSupervisor"] = KPICriterionLine;

                Session["KPI" + Request["type"].ToString()] = KPICalculateResult;
                Session["Month_" + Request["type"].ToString()] = "Type: " + Request["type"].ToString() + " - Period: " + txtKPIMonth.Text;
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "ALERT", "alert('" + huu.ToString() + " " + KPICalculateResult.Rows.Count.ToString() + "')", true);
                CreateDynamicControls();
            }
            catch { }         
            
        }

        private void CreateDynamicControls()
        {
            try
            {
                tbKPIResult.Rows.Clear();
                txtPeriod.Text = "Type: " + Request["type"].ToString() + " - Period: " +  txtKPIMonth.Text;
                List<string> ShowColumns = new List<string>() { "DCodePOR", "EmployeeName", "EmployeeCode", "TotalPoint", "TotalBonus" };
                DataTable data = (DataTable)Session["KPIResultSupervisor"];
                DataTable KPICriterionLine = (DataTable)Session["KPICriterionLineSupervisor"];

                List<string> BreakPointColumnXS = new List<string>() { "DCodePOR", "TotalBonus" };
                List<string> BreakPointColumnXSSM = new List<string>() {"ID","EmployeeCode" };
                string link_to_check_detail = default(string);

                DateTime today = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                DateTime startdate = new DateTime(SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4)), SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5)), 1);
                DateTime enddate = startdate.AddMonths(1);
                enddate = enddate.AddDays(-1);

                enddate = today > enddate ? enddate : today;

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
                            if (row["DescriptionVN"].ToString().Length > 0) tbheadercell.Text = tbheadercell.Text + "<br><font color='orange'><i>" + row["DescriptionVN"].ToString() + "</i></font>";
                            //tbheadercell.Attributes["style"] = "text-align: center;";
                            tbheadercell.Attributes["data-breakpoints"] = "all";
                            tbheaderrow.Cells.Add(tbheadercell);
                        }
                    }

                    tbheaderrow.TableSection = TableRowSection.TableHeader;
                    tbKPIResult.Rows.Add(tbheaderrow);

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
                                tbrowcell.Text = "<img src='src/assets/images/users/" + row["EmployeeCode"].ToString() + ".png' alt='user' width=40 class='rounded-circle' onerror=\"this.onerror=null; this.src='src/assets/images/users/erroruser.png'\"/> " + row[str].ToString();
                            }
                            if (str.Equals("TotalPoint"))
                            {
                                double k = 100 * SQRLibrary.ConvertToDouble(row[str]);
                                Label lb = new Label();
                                lb.Text = k.ToString("#0.##") + "%";
                                lb.Width = 44;
                                lb.CssClass = k >= 100 ? "badge bg-success" : k >= 95 ? "badge bg-info" : k >= 90 ? "badge bg-warning" : "badge bg-danger";
                               
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
                            string objectcode = "";
                            for (int i=0; i< KPICriterionLine.Rows.Count; i++)
                            {
                                tbrowcell = new TableCell();
                                
                                tbrowcell.ID = "tdCriterion" + rowindex + "_" + i.ToString();
                                objectcode = Request["type"].ToString().Equals("Supervisor") ? row["DCodeHR"].ToString() : Request["type"].ToString().Equals("Leader") ? row["TeamCode"].ToString() : row["EmployeeCode"].ToString();

                                link_to_check_detail = string.Format("kpidetail?type={0}&criterion={1}&from={2}&to={3}&object={4}&connection={5}", Request["type"].ToString()
                                    , KPICriterionLine.Rows[i]["Code"].ToString(), startdate.ToString("yyyy-MM-dd"), enddate.ToString("yyyy-MM-dd")
                                    , objectcode, KPICriterionLine.Rows[i]["Connection"].ToString());

                                tbrowcell.Text = @"<a href=""#"" target=""_blank"" onclick=""OpenLink('" + link_to_check_detail + @"')"">"
                                    + (100 * SQRLibrary.ConvertToDouble(row["Achievement" + (i + 1).ToString()])).ToString("#0.##") + "% - " + SQRLibrary.ConvertToDouble(row["Point" + (i + 1).ToString()]).ToString("#0.##")
                                    + "</a>";
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

                        tbKPIResult.Rows.Add(tbrow);
                        rowindex += 1;
                    }
                }

                
            }
            catch { }

        }

        private object CalculateBonus(decimal p, DataTable KPIBonusAmount)
        {
            decimal result = 0;
            try
            {
                foreach (DataRow row in KPIBonusAmount.Rows)
                {
                    if (IsNumberAdaptCondition(p, row["BonusCondition"].ToString()))
                        {
                            result = SQRLibrary.ConvertToDecimal(row["Amount"]);
                            break;
                        }
                    
                }
            }
            catch { }
            return result;
        }

        private object CalculatePoint(decimal tempresult, DataTable KPICriterionPoint, string CriterionCode, string Code)
        {
            decimal result = 0;
            try
            {
                foreach (DataRow row in KPICriterionPoint.Rows)
                {
                    if (row["CriterionCode"].ToString().Equals(CriterionCode) && row["Code"].ToString().Equals(Code))
                    {
                        if (IsNumberAdaptCondition(tempresult, row["Condition"].ToString()))
                        {
                            result = SQRLibrary.ConvertToDecimal(row["Point"]);
                            break;
                        }
                    }
                }
            }
            catch { }
            return result;
        }

        private object LookupAchievement(DataRow row, DataTable data, string JoinColumn, string ReturnColumn)
        {
            //Department='PAC'|Department={DCodePOR} 5:14 6, 8
            object result = null;
            
            while (JoinColumn.IndexOf("{") > 0)
            {
                int start = JoinColumn.IndexOf("{");
                int end = JoinColumn.IndexOf("}");
                string clName = end > start + 1 ? JoinColumn.Substring(start + 1, end - start - 1) : "";
                string tempresult = "'" + row[clName].ToString() + "'";

                JoinColumn = JoinColumn.Replace("{" + clName + "}", tempresult);
            }
            JoinColumn = JoinColumn.Replace("|", " or ");
            JoinColumn = JoinColumn.Replace("&", " and ");

            try
            {
                DataView huu = new DataView(data);
                huu.RowFilter = JoinColumn;

                result = (huu.ToTable()).Rows[0][ReturnColumn].ToString();
            }
            catch { }
            return result;
        }

        private bool IsNumberAdaptCondition(decimal d, string condition)
        {
            //'<'0.96&'>='0.91;
            bool result = false;
            try
            {
                string[] andcondition = condition.Split('&');

                foreach (string lv1 in andcondition)
                {
                    foreach (string lv2 in lv1.Split('|'))
                    {
                        if (lv2.StartsWith("'<'"))
                        {
                            bool ihh = d < SQRLibrary.ConvertToDecimal(lv2.Substring(3));
                            condition = condition.Replace(lv2, ihh ? "True" : "False");
                        }

                        if (lv2.StartsWith("'<='"))
                        {
                            bool ihh = d <= SQRLibrary.ConvertToDecimal(lv2.Substring(4));
                            condition = condition.Replace(lv2, ihh ? "True" : "False");
                        }

                        if (lv2.StartsWith("'>'"))
                        {
                            bool ihh = d > SQRLibrary.ConvertToDecimal(lv2.Substring(3));
                            condition = condition.Replace(lv2, ihh ? "True" : "False");
                        }

                        if (lv2.StartsWith("'>='"))
                        {
                            bool ihh = d >= SQRLibrary.ConvertToDecimal(lv2.Substring(4));
                            condition = condition.Replace(lv2, ihh ? "True" : "False");
                        }

                        if (lv2.StartsWith("'='"))
                        {
                            bool ihh = d == SQRLibrary.ConvertToDecimal(lv2.Substring(3));
                            condition = condition.Replace(lv2, ihh ? "True" : "False");
                        }

                        if (lv2.StartsWith("'!='"))
                        {
                            bool ihh = d != SQRLibrary.ConvertToDecimal(lv2.Substring(4));
                            condition = condition.Replace(lv2, ihh ? "True" : "False");
                        }
                    }
                }

                
                condition = condition.Replace("|", " or ");
                condition = condition.Replace("&", " and ");
                condition = condition.Trim();
                result = ConvertStringToBool(condition);
            }
            catch { }
            return result;
        }

        private bool ConvertStringToBool(string s)
        {
            bool result = false;
            try
            {
                s = s.Trim();
                s = s.Replace("Not True", "False");
                s = s.Replace("Not False", "True");
                s = s.Replace("True and True", "True");
                s = s.Replace("True and False", "False");
                s = s.Replace("False and True", "False");
                s = s.Replace("False and False", "False");
                s = s.Replace("True or True", "True");
                s = s.Replace("True or False", "True");
                s = s.Replace("False or True", "True");
                s = s.Replace("False or False", "False");

                result = s == "True";
            }
            catch { }
            return result;
        }

        private DataTable[] GetAchievementTables(DataTable KPICriterionLine, DateTime fromdate, DateTime todate)
        {
            DataTable[] result = new DataTable[KPICriterionLine.Rows.Count];
            try
            {
                List<string> temp = new List<string>() { };
                for (int i = 0; i < KPICriterionLine.Rows.Count; i++)
                {
                    if (temp.IndexOf(KPICriterionLine.Rows[i]["DataStoreProcedure"].ToString()) < 0)
                    {
                        //return datatable from SQL1200
                        switch (KPICriterionLine.Rows[i]["Connection"].ToString())
                        {
                            case "erp":
                                result[i] = SQRLibrary.ReturnDatatablefromSQL(KPICriterionLine.Rows[i]["DataStoreProcedure"].ToString(), new List<string>() { "@fromdate", "@todate" }
                                    , new List<object>() { fromdate.ToString("yyyy-MM-dd"), todate.ToString("yyyy-MM-dd") });
                                break;

                            case "mrp":
                                result[i] = SQRLibrary.ReturnDatatablefromSQL_mrp(KPICriterionLine.Rows[i]["DataStoreProcedure"].ToString(), new List<string>() { "@fromdate", "@todate" }
                                    , new List<object>() { fromdate.ToString("yyyy-MM-dd"), todate.ToString("yyyy-MM-dd") });
                                break;

                            case "hr":
                                result[i] = SQRLibrary.ReturnDatatablefromSQL_hr(KPICriterionLine.Rows[i]["DataStoreProcedure"].ToString(), new List<string>() { "@fromdate", "@todate" }
                                    , new List<object>() { fromdate.ToString("yyyy-MM-dd"), todate.ToString("yyyy-MM-dd") });
                                break;
                        }
                        
                    }
                    else
                    {
                        //getdata from result[]
                        result[i] = result[temp.IndexOf(KPICriterionLine.Rows[i]["DataStoreProcedure"].ToString())];
                    }
                    temp.Add(KPICriterionLine.Rows[i]["DataStoreProcedure"].ToString());
                }
            }
            catch { }
            return result;
        }

        private DataTable CopyDataTableFrom(DataTable from)
        {
            DataTable result = new DataTable();
            try
            {
                result.Columns.Clear();
                
                foreach (DataColumn column in from.Columns)
                {
                    DataColumn huu = new DataColumn(column.ColumnName);
                    result.Columns.Add(huu);
                }
                foreach (DataRow row in from.Rows)
                {
                    result.Rows.Add(row.ItemArray);
                }
            }
            catch { }
            return result;
        }

        protected void txtKPIMonth_TextChanged(object sender, EventArgs e)
        {
            
            
        }
    }
}
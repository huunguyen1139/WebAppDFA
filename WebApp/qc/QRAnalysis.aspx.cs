using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;
using System.Globalization;
using System.Web.UI.HtmlControls;

namespace WebApplication2.qc
{
    public partial class QRAnalysis : System.Web.UI.Page
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
                DateTime now = DateTime.Now;
                txtFromDate.Text = new DateTime(now.Year, now.Month, 1).ToString("yyyy-MM-dd");
                txtToDate.Text = now.ToString("yyyy-MM-dd"); 
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở trang Quality Analysis");
            }       
            
            LoadChart(DateTime.Today);
            btnLoad_Click(sender, e);
            CalculatePendingIssueAtDepartment();
        }

        private void CalculatePendingIssueAtDepartment()
        {
            int pending = 0;
            try
            {
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("CalculatePendingIssueAtDepartment");

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("WO")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkWO.InnerHtml = "Pending at dept. " + pending.ToString();               
                if (pending >= 1) divWO.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divWO.Attributes["style"] = "background-color: gold;";

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("RM")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkRM.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divRM.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divRM.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("FM")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkFM.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divFM.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divFM.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("AS")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkAS.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divAS.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divAS.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("SA")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkSA.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divSA.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divSA.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("FIN")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkFIN.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divFIN.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divFIN.Attributes["style"] = "background-color: gold;";
               

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("IRON")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkIRON.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divIRON.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divIRON.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("UPH")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkUPH.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divUPH.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divUPH.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("FIT")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkFIT.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divFIT.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divFIT.Attributes["style"] = "background-color: gold;";
                

                pending = dt.AsEnumerable().Where(x => x["department"].ToString().Equals("PAC")).Sum(x => SQRLibrary.ConvertToInt(x["total_issue"]));
                linkPAC.InnerHtml = "Pending at dept. " + pending.ToString();
                if (pending >= 1) divPAC.Attributes["style"] = "background-color: lightgrey;";
                if (pending >= 5) divPAC.Attributes["style"] = "background-color: gold;";
                

            }
            catch { }
        }

        private void LoadChart(DateTime endate)
        {
            DateTime fromdate = endate.AddDays(-10);
            DataTable dt1 = dtNewIssue(fromdate, endate);
            DataTable dt2 = dtSolvedIssue(fromdate, endate);
            DataTable dt3 = TotalPendingByDate(fromdate, endate);
            CreateChartScriptString(dt1, dt2, dt3, fromdate, endate);
            
        }
        
        private void LoadDataToControl(DateTime fromdate, DateTime todate)
        {
            try
            {
                string sql = "select * from QC_QualityReportHeader where Status in (1,4) and DefectiveDate between @fromdate and @todate";
                DataTable totalNewIssue = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@fromdate", "@todate" }, new List<object>() { fromdate, todate});

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");

                foreach (HtmlGenericControl ctr in cph.Controls.OfType<HtmlGenericControl>())
                {
                    if (ctr.ID.Contains("div"))
                    {
                        foreach (Label lb in ctr.Controls.OfType<Label>())
                        {
                            if (lb.ID.Substring(0, 4).Equals("lbso"))
                            {
                                lb.Text = TotalSolvedIssuebyDepartment(lb.ID.Substring(4, lb.ID.Length - 4), fromdate, todate).ToString();
                            }
                            if (lb.ID.Substring(0, 4).Equals("lbne"))
                            {
                                lb.Text = TotalNewIssueByDepartment(totalNewIssue, lb.ID.Substring(4, lb.ID.Length - 4)).ToString();
                            }
                        }
                    }
                }


                //foreach (Label lb in cph.Controls.OfType<Label>())
                //{
                //    if (lb.ID.Substring(0, 4).Equals("lbso"))
                //    {
                //        lb.Text = TotalSolvedIssuebyDepartment(lb.ID.Substring(4, lb.ID.Length - 4), fromdate, todate).ToString();
                //    }
                //    if (lb.ID.Substring(0, 4).Equals("lbne"))
                //    {
                //        lb.Text = TotalNewIssueByDepartment(totalNewIssue, lb.ID.Substring(4, lb.ID.Length - 4)).ToString();
                //    }
                //}
                
            }
            catch { }
        }

        private DataTable TotalPendingByDate(DateTime fromdate, DateTime todate)
        {
            DataTable result = new DataTable();
            DataTable dt = new DataTable();
            result.Columns.Add("date"); result.Columns.Add("pending"); 
            string sql = string.Empty;
            DateTime huu = new DateTime();
            try
            {
                while (fromdate.Ticks <= todate.Ticks)
                {
                    sql = "select * from QC_QualityReportHeader where DefectiveDate <=@date";
                    sql += " and((CompletedDate > @dateafter and Status = 4) or(CompletedDate IS NULL and Status = 1))";

                    huu = fromdate.AddDays(1);
                    dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@date", "@dateafter" }, new List<object>() { fromdate, huu });
                    result.Rows.Add(fromdate.ToString("yyyy-MM-dd"), dt.Rows.Count.ToString());
                    fromdate = fromdate.AddDays(1);
                }
            }
            catch { }
            return result;
        }
        private void CreateChartScriptString(DataTable dtNewIssue, DataTable dtSolvedIssue, DataTable pendingIssue, DateTime fromdate, DateTime todate)
        {
            try
            {
                string Legend = string.Empty;
                string NewIssue = string.Empty;
                string SolvedIssue = string.Empty;
                string PendingIssue = string.Empty;
                int temp = 0;

                //create x-legend for chart
                while (fromdate.Ticks <= todate.Ticks)
                {
                    Legend += fromdate.ToString("yyyy-MM-dd") + "','";
                    temp = dtNewIssue.AsEnumerable().Where(x => x["DefectiveDate"].ToString().Equals(fromdate.ToString("yyyy-MM-dd"))).Sum(x => SQRLibrary.ConvertToInt(x["TotalNewIssue"]));
                    NewIssue += temp.ToString() + ",";
                    temp = dtSolvedIssue.AsEnumerable().Where(x => x["CompletedDate"].ToString().Equals(fromdate.ToString("yyyy-MM-dd"))).Sum(x => SQRLibrary.ConvertToInt(x["TotalSolvedIssue"]));
                    SolvedIssue += temp.ToString() + ",";
                    temp = pendingIssue.AsEnumerable().Where(x => x["date"].ToString().Equals(fromdate.ToString("yyyy-MM-dd"))).Sum(x => SQRLibrary.ConvertToInt(x["pending"]));
                    PendingIssue += temp.ToString() + ",";

                    fromdate = fromdate.AddDays(1);
                }
                                
                if (Legend.Length > 3) Legend = Legend.Substring(0, Legend.Length - 3);
                if (NewIssue.Length > 1) NewIssue = NewIssue.Substring(0, NewIssue.Length - 1);
                if (SolvedIssue.Length > 1) SolvedIssue = SolvedIssue.Substring(0, SolvedIssue.Length - 1);
                if (PendingIssue.Length > 1) PendingIssue = PendingIssue.Substring(0, PendingIssue.Length - 1);

                string hh = "<script id='huujs'> function CreateChart() {";
                hh += " var n = c3.generate({bindto: '#column-oriented', size: { height: 400 },";

                hh += " data: {";
                hh += "  x: 'x',";
                hh += "  columns: [";
                hh += "  ['x', '" + Legend + "'],";
               
                hh += "  ['New Issue', " + NewIssue + "],";
                hh += "  ['Solved Issue', " + SolvedIssue + "],";
                hh += "  ['Pending Issue', " + PendingIssue + "],";

                hh += " ],";
                hh += " labels: false,";
                hh += " type: 'bar',";
                hh += " types: { 'Pending Issue': 'line' }";
                hh += " },";
                
                hh += " color: {pattern: ['#ff7f0e', '#2ca02c', '#9467bd', '#2ca02c', '#98df8a', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']},";

                hh += " axis: {";
                hh += " x: { type: 'category', label: { text: 'Date', position: 'outer-center' } },";
                hh += " y: { label: { text: 'times', position: 'outer-middle' } }";
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

        private DataTable dtNewIssue(DateTime fromdate, DateTime todate)
        {
            DataTable result = new DataTable();
            try
            {
                string sql = "select format(DefectiveDate, 'yyyy-MM-dd') DefectiveDate, count(*) TotalNewIssue from QC_QualityReportHeader where DefectiveDate between @fromdate and @todate and Status in (1,4)";
                sql += " group by DefectiveDate order by DefectiveDate asc";

                result = SQRFunctionLibrary.SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@fromdate", "@todate" }, new List<object>() { fromdate, todate });
            }
            catch { }
            return result;
        }


        private DataTable dtSolvedIssue(DateTime fromdate, DateTime todate)
        {
            DataTable result = new DataTable();
            try
            {
                string sql = "select format(CompletedDate,'yyyy-MM-dd') CompletedDate, count(*) TotalSolvedIssue from QC_QualityReportHeader where CompletedDate between @fromdate and @todate and Status in (4)";
                sql += " group by CompletedDate order by CompletedDate asc";

                result = SQRFunctionLibrary.SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@fromdate", "@todate" }, new List<object>() { fromdate, todate });
            }
            catch { }
            return result;
        }

        private int TotalSolvedIssuebyDepartment(string department, DateTime fromdate, DateTime todate)
        {
            int result = 0;
            try
            {
                string sql = "select count(*) TotalSolved from QC_QualityReportHeader where Status in (1,4) and LEN([" + department + "]) > 2 and convert(datetime, [" + department + "], 105) between @fromdate and @todate";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@fromdate", "@todate" }, new List<object>() { fromdate, todate });

                result = SQRLibrary.ConvertToInt(dt.Rows[0][0]);
            }
            catch { }
            return result;
        }

        private int TotalNewIssueByDepartment(DataTable dtReportHeader, string department)
        {
            int result = 0;
            try
            {
                result = dtReportHeader.AsEnumerable().Where(x => x[department].ToString().Length >= 1).Count();
            }
            catch { }
            return result;
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime fromdate = DateTime.ParseExact(txtFromDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                DateTime todate = DateTime.ParseExact(txtToDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);

                LoadDataToControl(fromdate, todate);
            }
            catch { }
            
        }
    }
}
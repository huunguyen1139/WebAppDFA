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

namespace WebApp.sampling
{
    public partial class SampleMasterPlan : System.Web.UI.Page
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
            huu.Attributes.Add("style", "background-color:#F1F1F1;");
            CreateDynamicTableRow();
           

            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở master plan");
                DateTime start = DateTime.Now.AddMonths(-1);
                start = new DateTime(start.Year, start.Month, 1);
                DateTime end = start.AddMonths(6);
                ShowUpProductionInfor(start, end);
            }
        }

        private void ShowUpProductionInfor(DateTime fromdate, DateTime todate)
        {
            try
            {
                DataTable ShippedPIs = SQRLibrary.ReturnDatatablefromSQL("POR_CalShippedAmount @fromdate, @todate", new List<string>() { "@fromdate", "@todate" }, new List<object>() { fromdate, todate});
                DataTable UnshippedPIs = SQRLibrary.ReturnDatatablefromSQL("POR_CalUnshippedAmount");
                DataTable UnpackingAmount = SQRLibrary.ReturnDatatablefromSQL("POR_CalUnpackingAmount");
                DataTable ProductionOutputAmount = SQRLibrary.ReturnDatatablefromSQL_mrp("POR_CalCompanyOutput @fromdate, @todate", new List<string>() { "@fromdate", "@todate" }, new List<object>() { fromdate, todate });

                double[] UnpackingAmountbyPeriod = new double[6];
                double[] ShippedPIsbyPeriod = new double[6];
                double[] UnshippedPIsbyPeriod = new double[6];
                double[] ProductionOutputAmountbyPeriod = new double[6];

                string[] MonthPeriodLabel = new string[6];
                for (int i = 0; i < MonthPeriodLabel.Length; i++)
                {
                    MonthPeriodLabel[i] = (fromdate.AddMonths(i)).Year.ToString("000#") + "-" + (fromdate.AddMonths(i)).Month.ToString("0#");
                    UnpackingAmountbyPeriod[i] = UnpackingAmount.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Equals(MonthPeriodLabel[i])).Sum(x => SQRLibrary.ConvertToDouble(x["TotalUnpackingAmount"]));
                    ShippedPIsbyPeriod[i] = ShippedPIs.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Equals(MonthPeriodLabel[i])).Sum(x => SQRLibrary.ConvertToDouble(x["Amount"]));
                    UnshippedPIsbyPeriod[i] = UnshippedPIs.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Equals(MonthPeriodLabel[i])).Sum(x => SQRLibrary.ConvertToDouble(x["TotalAmount"]));
                    ProductionOutputAmountbyPeriod[i] = ProductionOutputAmount.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Equals(MonthPeriodLabel[i])).Sum(x => SQRLibrary.ConvertToDouble(x["TotalValue"]));
                }
                txtRemainTotal01.InnerText = "$" + (UnpackingAmountbyPeriod[0] / 1000).ToString("##0") + "k | $" + ((ShippedPIsbyPeriod[0] + UnshippedPIsbyPeriod[0]) / 1000).ToString("##0") + "k";
                txtRemainTotal02.InnerText = "$" + (UnpackingAmountbyPeriod[1] / 1000).ToString("##0") + "k | $" + ((ShippedPIsbyPeriod[1] + UnshippedPIsbyPeriod[1]) / 1000).ToString("##0") + "k";
                txtRemainTotal03.InnerText = "$" + (UnpackingAmountbyPeriod[2] / 1000).ToString("##0") + "k | $" + ((ShippedPIsbyPeriod[2] + UnshippedPIsbyPeriod[2]) / 1000).ToString("##0") + "k";
                txtRemainTotal04.InnerText = "$" + (UnpackingAmountbyPeriod[3] / 1000).ToString("##0") + "k | $" + ((ShippedPIsbyPeriod[3] + UnshippedPIsbyPeriod[3]) / 1000).ToString("##0") + "k";
                txtRemainTotal05.InnerText = "$" + (UnpackingAmountbyPeriod[4] / 1000).ToString("##0") + "k | $" + ((ShippedPIsbyPeriod[4] + UnshippedPIsbyPeriod[4]) / 1000).ToString("##0") + "k";
                txtRemainTotal06.InnerText = "$" + (UnpackingAmountbyPeriod[5] / 1000).ToString("##0") + "k | $" + ((ShippedPIsbyPeriod[5] + UnshippedPIsbyPeriod[5]) / 1000).ToString("##0") + "k";

                lbUnpackingPercen01.Text = (ShippedPIsbyPeriod[0] + UnshippedPIsbyPeriod[0]) > 0 ? (UnpackingAmountbyPeriod[0] * 100 / (ShippedPIsbyPeriod[0] + UnshippedPIsbyPeriod[0])).ToString("#0") + "%" : "100%";
                lbUnpackingPercen02.Text = (ShippedPIsbyPeriod[1] + UnshippedPIsbyPeriod[1]) > 0 ? (UnpackingAmountbyPeriod[1] * 100 / (ShippedPIsbyPeriod[1] + UnshippedPIsbyPeriod[1])).ToString("#0") + "%" : "100%";
                lbUnpackingPercen03.Text = (ShippedPIsbyPeriod[2] + UnshippedPIsbyPeriod[2]) > 0 ? (UnpackingAmountbyPeriod[2] * 100 / (ShippedPIsbyPeriod[2] + UnshippedPIsbyPeriod[2])).ToString("#0") + "%" : "100%";
                lbUnpackingPercen04.Text = (ShippedPIsbyPeriod[3] + UnshippedPIsbyPeriod[3]) > 0 ? (UnpackingAmountbyPeriod[3] * 100 / (ShippedPIsbyPeriod[3] + UnshippedPIsbyPeriod[3])).ToString("#0") + "%" : "100%";
                lbUnpackingPercen05.Text = (ShippedPIsbyPeriod[4] + UnshippedPIsbyPeriod[4]) > 0 ? (UnpackingAmountbyPeriod[4] * 100 / (ShippedPIsbyPeriod[4] + UnshippedPIsbyPeriod[4])).ToString("#0") + "%" : "100%";
                lbUnpackingPercen06.Text = (ShippedPIsbyPeriod[5] + UnshippedPIsbyPeriod[5]) > 0 ? (UnpackingAmountbyPeriod[5] * 100 / (ShippedPIsbyPeriod[5] + UnshippedPIsbyPeriod[5])).ToString("#0") + "%" : "100%";

                divBarPercent01.Attributes["style"] = "width: " + (100 - SQRLibrary.ConvertToInt(lbUnpackingPercen01.Text.Substring(0, lbUnpackingPercen01.Text.Length - 1))).ToString() +"%;";
                divBarPercent02.Attributes["style"] = "width: " + (100 - SQRLibrary.ConvertToInt(lbUnpackingPercen02.Text.Substring(0, lbUnpackingPercen02.Text.Length - 1))).ToString() + "%;";
                divBarPercent03.Attributes["style"] = "width: " + (100 - SQRLibrary.ConvertToInt(lbUnpackingPercen03.Text.Substring(0, lbUnpackingPercen03.Text.Length - 1))).ToString() + "%;";
                divBarPercent04.Attributes["style"] = "width: " + (100 - SQRLibrary.ConvertToInt(lbUnpackingPercen04.Text.Substring(0, lbUnpackingPercen04.Text.Length - 1))).ToString() + "%;";
                divBarPercent05.Attributes["style"] = "width: " + (100 - SQRLibrary.ConvertToInt(lbUnpackingPercen05.Text.Substring(0, lbUnpackingPercen05.Text.Length - 1))).ToString() + "%;";
                divBarPercent06.Attributes["style"] = "width: " + (100 - SQRLibrary.ConvertToInt(lbUnpackingPercen06.Text.Substring(0, lbUnpackingPercen06.Text.Length - 1))).ToString() + "%;";

                divMonthPeriod01.InnerText = MonthPeriodLabel[0];
                divMonthPeriod02.InnerText = MonthPeriodLabel[1];
                divMonthPeriod03.InnerText = MonthPeriodLabel[2];
                divMonthPeriod04.InnerText = MonthPeriodLabel[3];
                divMonthPeriod05.InnerText = MonthPeriodLabel[4];
                divMonthPeriod06.InnerText = MonthPeriodLabel[5];

                spanShippedAmount01.InnerHtml = "$" + ShippedPIsbyPeriod[0].ToString("##0");
                spanShippedAmount02.InnerHtml = "$" + ShippedPIsbyPeriod[1].ToString("##0") + (ShippedPIsbyPeriod[1] > ShippedPIsbyPeriod[0] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanShippedAmount03.InnerHtml = "$" + ShippedPIsbyPeriod[2].ToString("##0") + (ShippedPIsbyPeriod[2] > ShippedPIsbyPeriod[1] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanShippedAmount04.InnerHtml = "$" + ShippedPIsbyPeriod[3].ToString("##0") + (ShippedPIsbyPeriod[3] > ShippedPIsbyPeriod[2] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanShippedAmount05.InnerHtml = "$" + ShippedPIsbyPeriod[4].ToString("##0") + (ShippedPIsbyPeriod[4] > ShippedPIsbyPeriod[3] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanShippedAmount06.InnerHtml = "$" + ShippedPIsbyPeriod[5].ToString("##0") + (ShippedPIsbyPeriod[5] > ShippedPIsbyPeriod[4] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");

                spanOutputAmount01.InnerHtml = "$" + ProductionOutputAmountbyPeriod[0].ToString("##0");
                spanOutputAmount02.InnerHtml = "$" + ProductionOutputAmountbyPeriod[1].ToString("##0") + (ProductionOutputAmountbyPeriod[1] > ProductionOutputAmountbyPeriod[0]? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanOutputAmount03.InnerHtml = "$" + ProductionOutputAmountbyPeriod[2].ToString("##0") + (ProductionOutputAmountbyPeriod[2] > ProductionOutputAmountbyPeriod[1] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanOutputAmount04.InnerHtml = "$" + ProductionOutputAmountbyPeriod[3].ToString("##0") + (ProductionOutputAmountbyPeriod[3] > ProductionOutputAmountbyPeriod[2] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanOutputAmount05.InnerHtml = "$" + ProductionOutputAmountbyPeriod[4].ToString("##0") + (ProductionOutputAmountbyPeriod[4] > ProductionOutputAmountbyPeriod[3] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");
                spanOutputAmount06.InnerHtml = "$" + ProductionOutputAmountbyPeriod[5].ToString("##0") + (ProductionOutputAmountbyPeriod[5] > ProductionOutputAmountbyPeriod[4] ? "<img src='/images/arrowgreen.png'>" : "<img src='/images/arrowdown.png'>");

            }
            catch { }          
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                
                           
            }
            catch
            { }
        }

        private void CreateDynamicTableRow()
        {           

            DataTable dt = (Request["showPIpc"] != null && Request["showPIpc"].ToString().Equals("true")) ? SQRLibrary.ReturnDatatablefromSQL("exec [MasterPlan] 1, 'SO-S'") : SQRLibrary.ReturnDatatablefromSQL("exec [MasterPlanNoPC] 1, 'SO-S'");
            
            if (Request["showHistory"] != null) dt = SQRLibrary.ReturnDatatablefromSQL("exec [MasterPlanHistory]");

            List<string> ColumnsNotShow = new List<string>() { "ShowIndex"};
            if (dt != null && dt.Rows.Count > 0)
            {
                try
                {
                    //lb09.Text = "$" + dt.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Substring(x["MonthPeriod"].ToString().Length - 2) == "09" & x["Currency"].ToString().Equals("USD"))
                    //                        .Sum(x => SQRLibrary.ConvertToDouble(x["Amount"])).ToString();
                    //lb08.Text = "$" + dt.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Substring(x["MonthPeriod"].ToString().Length - 2) == "08" & x["Currency"].ToString().Equals("USD"))
                    //                                .Sum(x => SQRLibrary.ConvertToDouble(x["Amount"])).ToString();
                    //lb07.Text = "$" + dt.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Substring(x["MonthPeriod"].ToString().Length - 2) == "07" & x["Currency"].ToString().Equals("USD"))
                    //                                .Sum(x => SQRLibrary.ConvertToDouble(x["Amount"])).ToString();
                    //lb04.Text = "$" + dt.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Substring(x["MonthPeriod"].ToString().Length - 2) == "04" & x["Currency"].ToString().Equals("USD"))
                    //                                .Sum(x => SQRLibrary.ConvertToDouble(x["Amount"])).ToString();
                    //lb05.Text = "$" + dt.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Substring(x["MonthPeriod"].ToString().Length - 2) == "05" & x["Currency"].ToString().Equals("USD"))
                    //                                .Sum(x => SQRLibrary.ConvertToDouble(x["Amount"])).ToString();
                    //lb06.Text = "$" + dt.AsEnumerable().Where(x => x["MonthPeriod"].ToString().Substring(x["MonthPeriod"].ToString().Length - 2) == "06" & x["Currency"].ToString().Equals("USD"))
                    //                                .Sum(x => SQRLibrary.ConvertToDouble(x["Amount"])).ToString();
                }
                catch { }
                TableHeaderRow tbheaderrow = new TableHeaderRow();
                TableHeaderCell tbheadercell = new TableHeaderCell();
               
                foreach (DataColumn cl in dt.Columns)
                {
                    tbheadercell = new TableHeaderCell();
                    tbheadercell.Text = cl.ColumnName;
                    tbheadercell.Attributes["style"] = "text-align: center; ";
                    tbheadercell.CssClass = "fixedheader";
                    if (cl.ColumnName.Equals("PI")) tbheadercell.Attributes["style"] = "text-align: center; min-width: 80px;";
                    if (cl.ColumnName.Equals("Remark")) tbheadercell.Attributes["style"] = "text-align: center; min-width: 200px;";
                    if (ColumnsNotShow.IndexOf(cl.ColumnName) < 0) tbheaderrow.Cells.Add(tbheadercell);                  
                }
                tbheaderrow.TableSection = TableRowSection.TableHeader;
                tbheaderrow.CssClass = "bg-dark text-white";
                
                tbMasterPlan.Rows.Add(tbheaderrow);
                
                //footerrow and headerrow

                TableRow tbrow = new TableRow();
                TableCell tbrowcell = new TableCell();
                int rowindex = 0;
                foreach (DataRow row in dt.Rows)
                {
                    tbrow = new TableRow();
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        tbrowcell = new TableCell();
                        tbrowcell.ID = "td" + rowindex.ToString() + "_" +  i.ToString();
                        tbrowcell.Attributes["style"] = "text-align: center;";                        
                        tbrowcell.Text = dt.Columns[i].ColumnName.Equals("PI") ? "<a href='/production/ProductionStatus?PI=" + row[i].ToString() + "' target='_blank'>" + row[i].ToString() + "</a>" : row[i].ToString();
                        if (i == 0) tbrowcell.BackColor = PaintColortoPICell(row[i].ToString().Substring(row[i].ToString().Length - 2));
                        if (dt.Columns[i].ColumnName.Equals("PC"))
                        {
                            double k = SQRLibrary.ConvertToDouble(row[i]);
                            Label lb = new Label();
                            lb.Text = row[i].ToString() + "%";
                            lb.Width = 44;
                            lb.CssClass = k == 100 ? "badge text-bg-success" : k >= 80 ? "badge text-bg-warning" : k >= 50 ? "badge text-bg-info" : "badge text-bg-danger";
                            //tbrowcell.CssClass = k == 100 ? "badge badge-success" : k >= 80 ? "badge badge-warning" : k >= 50 ? "badge badge-info" : "badge badge-danger";
                            //tbrowcell.Text = row[i].ToString() + "%";
                            tbrowcell.Controls.Add(lb);
                        }
                        if (ColumnsNotShow.IndexOf(dt.Columns[i].ColumnName) < 0) tbrow.Cells.Add(tbrowcell);
                    }
                    tbMasterPlan.Rows.Add(tbrow);
                    rowindex += 1;
                }
               
            }
        } 

        private Color PaintColortoPICell(string Month)
        {
            switch (Month)
            {
                case "01": return Color.Gold;                    
                case "02": return Color.PaleGreen;                   
                case "03": return Color.LightBlue;                    
                case "04": return Color.LightSalmon;                   
                case "05": return Color.SpringGreen;                   
                case "06": return Color.Turquoise;                    
                case "07": return Color.Orange;                   
                case "08": return Color.Gainsboro;
                case "09": return Color.NavajoWhite;                   
                case "10": return Color.LawnGreen;                   
                case "11": return Color.MediumTurquoise;                  
                case "12": return Color.AliceBlue;
            }
            return Color.Transparent;
        }

        private void btn_Click(object sender, EventArgs e)
        {
            try
            {
                
            }
            catch { }
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

     
    }
}
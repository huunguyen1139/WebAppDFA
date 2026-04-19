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

namespace WebApp.production
{
    public partial class DailyTargetView : System.Web.UI.Page
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
                txtFromDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
                       
        }
                     
        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                string sql = string.Empty;
                List<string> hidecolumn = null;
                sql = "SELECT [ProductionDate], [Department], [ManPower], [NormalWorkingHours] ENormalWHs,[ANormalWorkingHours] ANormalWHs, [Non-WorkingHours] NonWHrs, [Add-WorkingHours] [Add-WHrs], [TotalWorkingHours] TotalWHs, [Target], CompanyTarget,[NormalWorkingHourPerday] NorWHsPerDay, Remark";
                sql += " FROM [POR_DailyTarget] where [ProductionDate] between @fromdate and @todate ORDER BY ProductionDate asc, ShowIndex asc";

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@fromdate", "@todate" }
                    , new List<object>() { txtFromDate.Text, txtToDate.Text });

                LibraryFunction.LoadDataTableToGridView(gvDailyTarget, dt);
                
            }
            catch
            { }
        }

        protected void gvDailyTarget_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {                
                //string decodedText = HttpUtility.HtmlDecode(e.Row.Cells[10].Text.Replace(";", "<br>"));
                e.Row.Cells[10].Text = e.Row.Cells[10].Text.Replace("|", "<br>");
            }
            
        }        
    }
       
}
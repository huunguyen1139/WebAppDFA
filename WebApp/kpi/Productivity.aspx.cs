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
    public partial class Productivity : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }

            //txtKPIMonth.Text = Session["txtKPIMonth"] != null ? Session["txtKPIMonth"].ToString() : DateTime.Now.Year.ToString("0###") + "-" + DateTime.Now.Month.ToString("0#");
        }

        private void CreateDynamicControls(int year, int month)
        {
            try
            {

                DataTable data = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM [HR_ProductivityBonus] Where [Year]=@Year and [Month] = @Month"
                    , new List<string>() { "@Year", "@Month" }, new List<object>() { year, month });

                gvProductivity.DataSource = data;
                gvProductivity.DataBind();
            }
            catch { }
        }
        protected void btnLoad_ServerClick(object sender, EventArgs e)
        {
            try
            {

                int year = SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(0, 4));
                int month = SQRLibrary.ConvertToInt(txtKPIMonth.Text.Substring(5));

                CreateDynamicControls(year, month);
            }
            catch { }

        }





    }
}
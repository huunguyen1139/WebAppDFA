using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using Library;
namespace WebApplication2.Account
{
    public partial class SetupParameter : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
            UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
            Control huu1 = huu.FindControl("ctl00");
            foreach (TextBox tb in huu1.Controls.OfType<TextBox>())
            {
                string type = tb.ID.Substring(0, 2);
                if (type.Equals("ot") || type.Equals("mh"))
                {
                    tb.TextChanged += TextboxChanged;
                    tb.AutoPostBack = true;
                }
            }
            
        }
        private void TextboxChanged(object sender, EventArgs e)
        {
            try
            {
                TextBox tb = (TextBox)sender;
                string type = tb.ID.Substring(0, 2);
                string dept = tb.ID.Substring(2);
                switch (type)
                {
                    case "ot":
                        string sql = "update POR_ManHourUnitCost set CompanyTarget = " + tb.Text + " where Department = '" + dept + "'";
                        SQRLibrary.ExecuteSQL_mrp(sql);
                        break;
                    case "mh":
                        SQRLibrary.ExecuteSQL_mrp("update POR_ManhourUnitCost set ManhourUnitCost = " + tb.Text + " where Department = '" + dept + "'");
                        break;
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully updated!');", true);
            }
            catch { }
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
                
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                foreach (TextBox tb in huu1.Controls.OfType<TextBox>())
                {
                    switch (tb.ID.Substring(0, 2))
                    {
                        case "ot":
                            tb.Enabled = true;
                            break;
                        case "mh":
                            tb.Enabled = true;
                            break;
                    }
                }
                HtmlContainerControl masterpage = (HtmlContainerControl)Master.FindControl("MasterBody");
                masterpage.Attributes.Add("style", "background-color:#F1F1F1;");

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from POR_ManHourUnitCost");
                                
                foreach (TextBox tb in huu1.Controls.OfType<TextBox>())
                {
                    tb.Text = GetValue(dt, tb.ID.Substring(2), tb.ID.Substring(0, 2));
                }
            }
        }

        private string GetValue(DataTable dt, string Department, string type)
        {
            string result = default(string);

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i]["Department"].ToString().Equals(Department))
                {
                    if (type.Equals("ot"))
                    {
                        result = dt.Rows[i]["CompanyTarget"].ToString();
                    }
                    else if (type.Equals("mh"))
                    {
                        result = SQRLibrary.ConvertToDouble(dt.Rows[i]["ManhourUnitCost"]).ToString("#0");
                    }
                    break;
                }
            }
            return result;
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {

            string sql =  " if exists (select * from POR_MonthlyTarget where [Year]=" + ddYear.SelectedValue + " and [Month]=" + ddMonth.SelectedValue + ") ";
	               sql += "     BEGIN ";
                   sql += "     update POR_MonthlyTarget set [Target]=" + SQRLibrary.ConvertToInt(txtTarget.Text).ToString() + " where [Year]=" + ddYear.SelectedValue + " and [Month]=" + ddMonth.SelectedValue;
	               sql += "     END";
                   sql += " else ";
                   sql += "     insert POR_MonthlyTarget ([Year], [Month], [Target]) values (" + ddYear.SelectedValue + ", " + ddMonth.SelectedValue + ", " + SQRLibrary.ConvertToInt(txtTarget.Text).ToString() + ")";
                   SQRLibrary.ExecuteSQL_mrp(sql);
                   ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully updated!');", true);
                   ddYear_SelectedIndexChanged(sender, e);
        }

        protected void ddYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sql = "select [Target] from POR_MonthlyTarget where [Year]=" + ddYear.SelectedValue + " and [Month]=" + ddMonth.SelectedValue;
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
            txtTarget.Text = dt.Rows.Count > 0 ? dt.Rows[0][0].ToString() : "0";
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class default_mpro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            //#f8fafd
            if (!IsPostBack)
            {
                //HtmlContainerControl masterpage = (HtmlContainerControl)Master.FindControl("MasterBody");
                //masterpage.Attributes.Add("style", "background-color:#f8fafd;");
            }
        }
    }
}
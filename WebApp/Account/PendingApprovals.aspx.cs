using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.functions.approval;

namespace WebApp.Account
{
    public partial class PendingApprovals : System.Web.UI.Page
    {
        public string CurrentUserId => (string)Session["UserId"];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
            if (!IsPostBack)
                BindInbox();
        }

        private void BindInbox()
        {
            DataTable dt = ApprovalService.GetPendingResolved(CurrentUserId);

            rpt.DataSource = dt;
            rpt.DataBind();

            lblEmpty.Visible = dt.Rows.Count == 0;
        }
    }
}
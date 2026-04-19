using DevExpress.Web;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class Notifications : System.Web.UI.Page
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
                
            }
            LoadNotifications(cboFilter.SelectedItem.Value.ToString());
        }
        //filter = all || filter = unread
        private void LoadNotifications(string filter)
        {
            try
            {
                string CurrentUserID = Session["userid"]?.ToString();
                string sql = "EXEC GetNotifications @UserID, @Filter";

                var paramNames = new List<string> { "@UserID", "@Filter" };
                var paramValues = new List<object> { CurrentUserID, filter };
                
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, paramNames, paramValues);

                dt.Columns.Add("TimeAgo", typeof(string));

                foreach (DataRow row in dt.Rows)
                {
                    DateTime createdAt = Convert.ToDateTime(row["CreatedAt"]);
                    row["TimeAgo"] = FormatRelativeDate(createdAt);
                }

                gridNotifications.DataSource = dt;
                gridNotifications.DataBind();
            } catch { }
        }

        protected void gridNotifications_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {           
            if (e.DataColumn.FieldName == "Message")
            {
                bool isRead = Convert.ToBoolean(e.GetValue("IsRead"));

                if (!isRead) // IsRead = 0 means unread
                {
                    e.Cell.Font.Bold = true;
                }
            }
        }

        private string FormatRelativeDate(DateTime date)
        {
            TimeSpan timeSpan = DateTime.Now - date;

            if (timeSpan.TotalSeconds < 60)
                return "just now";
            if (timeSpan.TotalMinutes < 60)
                return $"{(int)timeSpan.TotalMinutes} minute(s) ago";
            if (timeSpan.TotalHours < 24)
                return $"{(int)timeSpan.TotalHours} hour(s) ago";
            if (timeSpan.TotalDays < 30)
                return $"{(int)timeSpan.TotalDays} day(s) ago";

            return date.ToString("dd-MMM-yyyy HH:mm:ss");
        }
        protected void cboFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedFilter = cboFilter.SelectedItem.Value.ToString();
            LoadNotifications(selectedFilter);
        }

       
        private void MarkNotificationAsRead(int notificationId)
        {
            string sql = "EXEC MarkNotificationAsRead @NotificationID";
            var paramNames = new System.Collections.Generic.List<string> { "@NotificationID" };
            var paramValues = new System.Collections.Generic.List<object> { notificationId };

            SQRLibrary.ExecuteSQL_mrp(sql, paramNames, paramValues);
        }

        protected void gridNotifications_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            try
            {
                if (e.ButtonID == "btnMarkRead")
                {
                    int notificationId = Convert.ToInt32(gridNotifications.GetRowValues(e.VisibleIndex, "NotificationID"));
                    SQRLibrary.ExecuteSQL_mrp(
                                "EXEC MarkNotificationAsRead @NotificationID",
                                new List<string> { "@NotificationID" },
                                new List<object> { notificationId }
                            );
                }

                LoadNotifications(cboFilter.SelectedItem.Value.ToString());
            }
            catch { }
        }
    }
}
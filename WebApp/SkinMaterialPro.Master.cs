using Microsoft.Ajax.Utilities;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.Optimization;
using Microsoft.ReportingServices.Interfaces;

namespace WebApp
{
    public partial class SkinMaterialPro : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["theme"] == null) Session["theme"] = "light";
                if (Session["colortheme"] == null) Session["colortheme"] = "Green_Theme";
                LoadNotifications();
            }
           
           
        }

        public int NotificationCount = 0;

        private void LoadNotifications()
        {
            string userId = Session["userid"]?.ToString();
            if (string.IsNullOrEmpty(userId)) return;

            DataTable dt = new DataTable();           
            dt = SQRLibrary.ReturnDatatablefromSQL_mrp("GetNotificationsForUser @UserID"
                , new List<string>() { "@UserID" }
                , new List<object>() { userId });
            
            rptNotifications.DataSource = dt;
            rptNotifications.DataBind();

            DataTable dtUnread = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC GetNotifications @UserID, @Filter"
                , new List<string>() { "@UserID", "@Filter" }
                , new List<object>() { userId, "unread" });
            NotificationCount = dtUnread.Rows.Count;
            //Page.DataBind();
            upNotifications.DataBind();


        }

        protected string FormatRelativeDate(DateTime date)
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

        protected void lightlayout_ServerChange()
        {
            Session["ff"] = "";
        }

        [System.Web.Services.WebMethod]
        public static object GetNotificationDetails(int notificationId)
        {
            try
            {
                // Mark as read
                SQRLibrary.ExecuteSQL_mrp(
                    "MarkNotificationAsRead",
                    new List<string>() { "@NotificationID" },
                    new List<object>() { notificationId }
                );

                // Get details
                var dt = SQRLibrary.ReturnDatatablefromSQL(
                    "SELECT Title, Message, Link FROM Notifications WHERE NotificationID = @NotificationID",
                    new List<string>() { "@NotificationID" },
                    new List<object>() { notificationId }
                );

                if (dt.Rows.Count > 0)
                {
                    var row = dt.Rows[0];
                    return new
                    {
                        success = true,
                        title = row["Title"].ToString(),
                        message = row["Message"].ToString(),
                        link = row["Link"] == DBNull.Value ? "" : row["Link"].ToString()
                    };
                }
                return new { success = false, message = "Notification not found" };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error: " + ex.Message };
            }
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static void UpdateUserTheme(string type, string value)
        {
            try
            {
                HttpContext.Current.Session[type] = value;
                HttpContext.Current.Session.Timeout = 10000;
                SQRLibrary.ConvertToDecimal(value);


            }
            catch { }
        }

        protected void btnSaveTheme_Click(object sender, EventArgs e)
        {
            try
            {
                HtmlInputRadioButton lightlayout = (HtmlInputRadioButton)this.FindControl("lightlayout");
                HtmlInputRadioButton darklayout = (HtmlInputRadioButton)this.FindControl("darklayout");

                Session["theme"] = lightlayout.Checked ? "light" : "dark";
                

            }
            catch { }
        }

       
        private void InsertNotification(string userId, string title, string message, string link)
        {
            try
            {
                SQRLibrary.ExecuteSQL_mrp(
                    "InsertNotification",
                    new List<string>() { "@UserID", "@Title", "@Message", "@Link" },
                    new List<object>() { userId, title, message, link }
                );
            }
            catch (Exception ex)
            {                
            }
        }

        private (string Title, string Message, string Link) GetNotificationById(int notifId)
        {
            try
            {
                var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
                    "SELECT Title, Message, Link FROM Notifications WHERE NotificationID = @NotificationID",
                    new List<string>() { "@NotificationID" },
                    new List<object>() { notifId }
                );

                if (dt.Rows.Count > 0)
                {
                    var row = dt.Rows[0];
                    return (
                        row["Title"].ToString(),
                        row["Message"].ToString(),
                        row["Link"] == DBNull.Value ? "" : row["Link"].ToString()
                    );
                }
            }
            catch (Exception ex)
            {                
            }
            return ("", "", "");
        }


        private void MarkNotificationAsRead(int notifId)
        {
            try
            {
                SQRLibrary.ExecuteSQL_mrp("MarkNotificationAsRead",
                    new List<string>() { "@NotificationID" },
                    new List<object>() { notifId });
            }
            catch { }
        }

    }
}
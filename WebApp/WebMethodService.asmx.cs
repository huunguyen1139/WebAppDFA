using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebApp.CustomControl;

namespace WebApp
{
    /// <summary>
    /// Summary description for WebMethodService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WebMethodService : System.Web.Services.WebService
    {       

        [WebMethod]
        public object GetNotificationDetails(int notificationId)
        {
            try
            {
                // Mark as read
                SQRLibrary.ExecuteSQL_mrp(
                    "EXEC MarkNotificationAsRead @NotificationID",
                    new List<string>() { "@NotificationID" },
                    new List<object>() { notificationId }
                );

                // Get details
                var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
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
                        link = row["Link"]?.ToString()
                    };
                }
                return new { success = false, message = "Notification not found" };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        public static string GetNextItemNoAjax(string prefix)
        {
            string sql = @"
                SELECT ISNULL(MAX(CAST(SUBSTRING([No_], LEN(@Prefix) + 1, 10) AS INT)), 0)
                FROM [LIVE_ALLIANCE_90$Item] 
                WHERE [No_] LIKE @Prefix + '%'
            ";

            var maxNo = (int)SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Prefix" },
                new List<object> { prefix }
            ).Rows[0][0];

            // You may want to format the number, e.g., as 5 digits:
            int nextNo = maxNo + 1;
            return prefix + nextNo.ToString("D5");
        }
    }
}

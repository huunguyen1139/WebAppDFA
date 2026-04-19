using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using WebApp.Models;

namespace WebApp.Controls
{
    /// <summary>
    /// Summary description for MentionEditorHandler
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class MentionEditorNewHandler : System.Web.Services.WebService
    {

        [WebMethod]
        public List<object> GetUserSuggestionsNew(string term)
        {
            //Library.LibraryFunction.InsertActivitiesLog("", $"LOG {term}");
            List<User> allUsers;
            allUsers = GetAllUsers(); // Cached
            
            string normalizedTerm = RemoveDiacritics(term).ToLower();

            return allUsers
                .Where(u => RemoveDiacritics(u.UserName).ToLower().Contains(normalizedTerm))
                .Select(u => new
                {
                    label = u.UserName + " - " + u.UserID,  // dropdown shows: Name - ID
                    value = u.UserName,                     // Text inserted
                    userid = u.UserID,                      // Hidden UserID
                    avatar = $"/images/users/{u.UserID}.png"
                })
                .Take(10)
                .ToList<object>();
        }

        public string RemoveDiacritics(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;
            var normalized = text.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();
            foreach (var c in normalized)
            {
                var unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != UnicodeCategory.NonSpacingMark)
                    sb.Append(c);
            }
            return sb.ToString().Normalize(NormalizationForm.FormC);
        }

        public List<User> GetAllUsers()
        {
            // Try to get from cache
            var cachedUsers = HttpRuntime.Cache["AllUsers"] as List<User>;
            if (cachedUsers != null && cachedUsers.Count > 0)
            {
                return cachedUsers;
            }

            // Not cached → Load from DB
            DataTable dtUsers = SQRLibrary.ReturnDatatablefromSQL_hr("ALL_GetEmployeeList");

            var userList = new List<User>();
            userList = dtUsers.AsEnumerable()
            .Select(row => new User
            {
                UserID = row["EmployeeID"].ToString(),
                UserName = row["EmployeeName"].ToString()
            })
            .ToList();

            // Cache for 100 minutes
            HttpRuntime.Cache.Insert(
                "AllUsers",            // Cache key
                userList,              // Data to cache
                null,                  // No file dependencies
                DateTime.Now.AddMinutes(100), // Absolute expiration
                System.Web.Caching.Cache.NoSlidingExpiration
            );

            return userList;
        }
    }

  
}

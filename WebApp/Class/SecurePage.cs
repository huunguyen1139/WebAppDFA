using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Caching;

namespace WebApp
{

    public class SecurePage : System.Web.UI.Page
    {
        
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }

            string userId = Session["UserID"]?.ToString()?? "guest";            
            string rawUrl = Request.AppRelativeCurrentExecutionFilePath;            

            // Load permissions from cache
            //var permissions = GetCachedPermissions(userId);

            // Check if user has access to this page
            if (!UserHasAccess(userId, rawUrl))
            {
                Response.Redirect("~/AccessDenied.aspx");
                return;
            }
        }


        #region Get And Load Permission
        private string NormalizePageUrl(string pageUrl)
        {
            // Lowercase for consistent matching
            pageUrl = pageUrl.ToLower();

            // Remove query string if present
            int queryIndex = pageUrl.IndexOf('?');
            if (queryIndex >= 0)
                pageUrl = pageUrl.Substring(0, queryIndex);

            // Ensure starts with "~" for AppRelative paths
            if (!pageUrl.StartsWith("~"))
                pageUrl = "~" + pageUrl;

            // Check if .aspx extension is missing
            if (!pageUrl.EndsWith(".aspx"))
            {
                // If physical file exists, append .aspx
                pageUrl += ".aspx";
            }

            return pageUrl;
        }

        private static string NormalizePageUrl_Static(string pageUrl)
        {
            // Lowercase for consistent matching
            pageUrl = pageUrl.ToLower();

            // Remove query string if present
            int queryIndex = pageUrl.IndexOf('?');
            if (queryIndex >= 0)
                pageUrl = pageUrl.Substring(0, queryIndex);

            // Ensure starts with "~" for AppRelative paths
            if (!pageUrl.StartsWith("~"))
                pageUrl = "~" + pageUrl;

            // Check if .aspx extension is missing
            if (!pageUrl.EndsWith(".aspx"))
            {
                // If physical file exists, append .aspx
                pageUrl += ".aspx";
            }

            return pageUrl;
        }
        private bool UserHasAccess(string userId, string pageUrl)
        {            
            return true;
        }

        public static bool IsUserInRole(string userId, string roleName)
        {
            return true;
        }
        public static bool IsUserInAnyRole(string userId, IEnumerable<string> roleNames)
        {            

            return true;
        }



        #endregion


        public static void InvalidateUserPermissionCache(string userId)
        {
            string cacheKey = $"UserPermissions_{userId}";
            HttpRuntime.Cache.Remove(cacheKey);
        }
        public static void ClearAllPermissionCaches()
        {
            var cacheEnum = HttpRuntime.Cache.GetEnumerator();
            List<string> keysToRemove = new List<string>();

            while (cacheEnum.MoveNext())
            {
                string key = cacheEnum.Key.ToString();
                if (key.StartsWith("PagePermissions_"))
                {
                    keysToRemove.Add(key);
                }
            }

            foreach (var key in keysToRemove)
            {
                HttpRuntime.Cache.Remove(key);
            }
        }

    }

    public class PermissionCache
    {
        public bool CanAccessAllPages { get; set; } = false;
        public HashSet<string> AllowedPages { get; set; } = new HashSet<string>();
        public HashSet<string> Roles { get; set; } = new HashSet<string>();
    }
}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace WebApp
{
    /// <summary>
    /// Summary description for DownloadFolderZip
    /// </summary>
    public class DownloadFolderZip : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            string token = context.Request["t"];
            if (string.IsNullOrWhiteSpace(token)) { context.Response.StatusCode = 400; return; }

            string key = "FM_ZIP_" + token;
            string zipPath = context.Session[key] as string;

            if (string.IsNullOrWhiteSpace(zipPath) || !File.Exists(zipPath))
            {
                context.Response.StatusCode = 404;
                return;
            }

            context.Session.Remove(key);

            context.Response.Clear();
            context.Response.ContentType = "application/zip";
            context.Response.AddHeader("Content-Disposition", "attachment; filename=Folder.zip");
            context.Response.TransmitFile(zipPath);
            context.Response.Flush();

            try { File.Delete(zipPath); } catch { }
            context.ApplicationInstance.CompleteRequest();
        }

        public bool IsReusable => false;
    }
}
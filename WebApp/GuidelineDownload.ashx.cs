using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Data;
using System.Web.SessionState;
using SQRFunctionLibrary;
using System.IO;
namespace WebApplication2
{
    /// <summary>
    /// Summary description for GetPIList
    /// </summary>
    public class GuidelineDownload : IHttpHandler, IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);
                string mode = (context.Request["mode"] ?? "download").ToLowerInvariant();


                // Read file meta from DB
                var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
                "SELECT Title, FilePath, FileExt FROM dbo.SYSTEM_GuidelineItem WHERE GuidelineId=@Id",
                new List<string> { "@Id" }, new List<object> { id });


                if (dt.Rows.Count == 0) { context.Response.StatusCode = 404; return; }
                string title = Convert.ToString(dt.Rows[0]["Title"]);
                string vpath = Convert.ToString(dt.Rows[0]["FilePath"]);
                string ext = Convert.ToString(dt.Rows[0]["FileExt"]).ToLowerInvariant();


                var phys = context.Server.MapPath(vpath);
                if (!File.Exists(phys)) { context.Response.StatusCode = 404; return; }


                string mime = GetMime(ext);
                context.Response.Clear();
                context.Response.ContentType = mime;


                string disposition = (mode == "inline") ? "inline" : "attachment";
                string fileName = (title ?? "file").Replace(' ', '_') + "." + ext;
                context.Response.AddHeader("Content-Disposition", $"{disposition}; filename=\"{fileName}\"");


                // Stream efficiently
                context.Response.TransmitFile(phys);
                context.Response.Flush();
            }
            catch
            {
                context.Response.StatusCode = 500;
            }
            finally
            {
                context.Response.End();
            }
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
        private static string GetMime(string ext)
        {
            switch (ext)
            {
                case "pdf": return "application/pdf";
                case "doc": return "application/msword";
                case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                case "pptx": return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                case "xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                default: return "application/octet-stream";
            }
        }
    }
}
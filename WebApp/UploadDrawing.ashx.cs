using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace WebApp
{
    /// <summary>
    /// Summary description for UploadDrawing
    /// </summary>
    public class UploadDrawing : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                if (!"POST".Equals(context.Request.HttpMethod, StringComparison.OrdinalIgnoreCase))
                {
                    context.Response.StatusCode = 405; // Method Not Allowed
                    return;
                }

                // --- SECURITY: DB-gated with SYSTEM_Users ---
                string user = (context.Request.Form["user"] ?? "").Trim();
                
                //if (!ValidateUserCanUpload_SQR(user, apiKey))
                //{
                //    context.Response.Write("{\"ok\":false,\"message\":\"" + "Forbidden: invalid user or key, or no upload permission." + "\"}");

                //    return;
                //}
                

                // ====== CONFIG: base folder to save uploads ======
                string baseRoot = @"D:\ALLIANCE_NEW\ERP\DRAWING";
                if (!Directory.Exists(baseRoot))
                {
                    Directory.CreateDirectory(baseRoot);
                }
                //Directory.CreateDirectory(baseRoot);

                // ====== Read form fields ======
                string desiredName = TrimToNull(context.Request.Form["desiredName"]);

                if (!string.IsNullOrWhiteSpace(desiredName)) desiredName = MakeSafeFileName(desiredName);

                string remotePath = TrimToNull(context.Request.Form["remotePath"]);
                string safeRelative = MakeSafeRelativePath(remotePath);                 // A/B/C only
                string finalFolder = SafeCombineUnderRoot(baseRoot, safeRelative);      // stays under baseRoot
                Directory.CreateDirectory(finalFolder);

                string clientPath = TrimToNull(context.Request.Form["clientPath"]);     // for echo/logging only

                // ====== Save files ======
                var results = new List<object>();
                for (int i = 0; i < context.Request.Files.Count; i++)
                {
                    HttpPostedFile file = context.Request.Files[i];
                    if (file == null || file.ContentLength <= 0) continue;

                    string original = Path.GetFileName(file.FileName);
                    string baseName = !string.IsNullOrWhiteSpace(desiredName)
                                        ? desiredName
                                        : MakeSafeFileName(original);

                    string targetPath = Path.Combine(finalFolder, baseName);
                    if (File.Exists(targetPath))
                    {
                        targetPath = Path.Combine(
                            finalFolder,
                            $"{Path.GetFileNameWithoutExtension(baseName)}_{DateTime.Now:yyyyMMdd_HHmmssfff}{Path.GetExtension(baseName)}");
                    }

                    file.SaveAs(targetPath);

                    string relToBase = GetRelativePath(baseRoot, targetPath).Replace('\\', '/');
                    string folderRel = GetRelativePath(baseRoot, finalFolder).Replace('\\', '/');
                    string webRel = @"D:\ALLIANCE_NEW\ERP\DRAWING" + relToBase;
                    DateTime lastModified = File.GetLastWriteTime(targetPath);

                    var fi = new FileInfo(targetPath);
                    results.Add(new
                    {
                        originalName = original,
                        savedAs = Path.GetFileName(targetPath),
                        size = fi.Length,
                        folder = folderRel,
                        serverFullPath = targetPath,
                        serverRelative = webRel,
                        clientPath = clientPath,
                        networkpath = targetPath.Replace(@"D:\ALLIANCE_NEW", @"\\192.168.1.244\alliance_new"),
                        lastmodified = lastModified.ToString("yyyy-MM-dd HH:mm:ss")
                    });
                }

                //context.Response.ContentType = "application/json";
                //context.Response.Write("{\"ok\":true,\"message\":\"handler alive\"}");
                //return;

                // ====== Response ======
                context.Response.ContentType = "application/json";
                string json = Newtonsoft.Json.JsonConvert.SerializeObject(new { ok = true, files = results });
                context.Response.Write(json);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.ContentType = "application/json";
                context.Response.Write("{\"ok\":false,\"message\":\"" + HttpUtility.JavaScriptStringEncode(ex.Message) + "\"}");
            }
        }

        public bool IsReusable => false;

        // ---------- helpers ----------
        static string TrimToNull(string s) => string.IsNullOrWhiteSpace(s) ? null : s.Trim();

        static string MakeSafeFileName(string name)
        {
            foreach (var c in Path.GetInvalidFileNameChars()) name = name.Replace(c, '_');
            return name.Trim();
        }

        // keep only a safe *relative* path: "A/B/C"
        static string MakeSafeRelativePath(string remotePath)
        {
            if (string.IsNullOrWhiteSpace(remotePath)) return "";
            string sanitized = remotePath.Replace('\\', '/').Trim().TrimStart('/');
            var parts = sanitized.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries)
                                 .Where(seg => seg != "." && seg != "..")
                                 .Select(seg =>
                                 {
                                     foreach (var c in Path.GetInvalidFileNameChars()) seg = seg.Replace(c, '_');
                                     return seg;
                                 });
            return string.Join(Path.DirectorySeparatorChar.ToString(), parts);
        }

        static string SafeCombineUnderRoot(string baseRoot, string relative)
        {
            string target = Path.GetFullPath(Path.Combine(baseRoot, relative ?? ""));
            string fullBase = Path.GetFullPath(baseRoot).TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar;
            if (!target.StartsWith(fullBase, StringComparison.OrdinalIgnoreCase))
                throw new HttpException(403, "Forbidden");
            return target;
        }

        static string GetRelativePath(string root, string fullPath)
        {
            string rootFull = Path.GetFullPath(root).TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar;
            string pathFull = Path.GetFullPath(fullPath);
            if (pathFull.StartsWith(rootFull, StringComparison.OrdinalIgnoreCase))
                return pathFull.Substring(rootFull.Length);
            return Path.GetFileName(pathFull);
        }
    }
}
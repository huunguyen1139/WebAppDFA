using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using SQRFunctionLibrary;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.IO;
using System.Text.RegularExpressions;
using WebApp;

namespace WebApplication2.Account
{
    public partial class Guidelines : Page
    {
        // == Config ==
        private const int PageSize = 12;
        private static readonly string[] AllowedExts = { ".pdf", ".docx", ".doc", ".pptx", ".xlsx" };

        
        protected bool CanManage => SecurePage.IsUserInAnyRole(Session["userid"]?.ToString() ?? "", new string[] {"System Owner", "Admin"});
        protected void Page_Load()
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }

            if (!IsPostBack)
            {
                pnlUpload.Visible = CanManage;
                ltAdminBadge.Text = CanManage ? "<span class='badge bg-primary'>Admin Mode</span>" : "";
                BindCategories();
                BindFilters();
                BindList(1);
            }
        }

        // == UI Setup ==
        private void BindCategories()
        {
            var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
            @"SELECT CategoryId, Name FROM dbo.SYSTEM_GuidelineCategory WHERE IsActive = 1 ORDER BY SortOrder DESC, Name",
            new List<string>(), new List<object>());


            ddlCategory.DataSource = dt; ddlCategory.DataTextField = "Name"; ddlCategory.DataValueField = "CategoryId"; ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("(None)", ""));
        }


        private void BindFilters()
        {
            var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
            @"SELECT CategoryId, Name FROM dbo.SYSTEM_GuidelineCategory WHERE IsActive = 1 ORDER BY SortOrder DESC, Name",
            new List<string>(), new List<object>());


            ddlCategoryFilter.DataSource = dt; ddlCategoryFilter.DataTextField = "Name"; ddlCategoryFilter.DataValueField = "CategoryId"; ddlCategoryFilter.DataBind();
            ddlCategoryFilter.Items.Insert(0, new ListItem("All", ""));
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindList(1);
        }

        // == Data Binding ==
        private void BindList(int pageIndex)
        {
            string sql = "EXEC dbo.SYSTEM_Guideline_Search @Keyword, @CategoryId, @MediaType, @IncludeInactive, @PageIndex, @PageSize";


            var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql,
            new List<string> { "@Keyword", "@CategoryId", "@MediaType", "@IncludeInactive", "@PageIndex", "@PageSize" },
            new List<object> {
            string.IsNullOrWhiteSpace(tbKeyword.Text) ? (object)DBNull.Value : tbKeyword.Text.Trim(),
            string.IsNullOrWhiteSpace(ddlCategoryFilter.SelectedValue) ? (object)DBNull.Value : Convert.ToInt32(ddlCategoryFilter.SelectedValue),
            string.IsNullOrWhiteSpace(ddlTypeFilter.SelectedValue) ? (object)DBNull.Value : ddlTypeFilter.SelectedValue,
            CanManage ? 1 : 0, // admins see inactive
            pageIndex,
            PageSize
            });


            rptItems.DataSource = dt; rptItems.DataBind();


            // Pagination UI
            int total = 0;
            if (dt.Rows.Count > 0 && dt.Columns.Contains("TotalRows"))
                total = Convert.ToInt32(dt.Rows[0]["TotalRows"]);


            ltResultInfo.Text = total == 0 ? "No results" : $"Showing page {pageIndex} / {Math.Max(1, (int)Math.Ceiling(total / (double)PageSize))} — {total} items";
            BuildPager(pageIndex, total);
        }

        private void BuildPager(int pageIndex, int total)
        {
            phPager.Controls.Clear();
            int totalPages = Math.Max(1, (int)Math.Ceiling(total / (double)PageSize));
            int start = Math.Max(1, pageIndex - 2);
            int end = Math.Min(totalPages, pageIndex + 2);


            phPager.Controls.Add(MakePageLi("«", Math.Max(1, pageIndex - 1), pageIndex == 1));
            for (int i = start; i <= end; i++)
                phPager.Controls.Add(MakePageLi(i.ToString(), i, i == pageIndex));
            phPager.Controls.Add(MakePageLi("»", Math.Min(totalPages, pageIndex + 1), pageIndex == totalPages));
        }

        private Control MakePageLi(string text, int pageValue, bool disabledOrActive)
        {
            var li = new Literal();
            if (text == "«" || text == "»")
            {
                // prev/next
                li.Text = $"<li class='page-item {(disabledOrActive ? "disabled" : "")}'><a class='page-link' href='javascript:__doPostBack(\"{btnSearch.UniqueID}\", \"page:{pageValue}\")'>{HttpUtility.HtmlEncode(text)}</a></li>";
            }
            else
            {
                // numbered
                li.Text = $"<li class='page-item {(disabledOrActive ? "active" : "")}'><a class='page-link' href='javascript:__doPostBack(\"{btnSearch.UniqueID}\", \"page:{pageValue}\")'>{HttpUtility.HtmlEncode(text)}</a></li>";
            }
            return li;
        }


        // Capture __doPostBack from pager
        //protected override void RaisePostBackEvent(IPostBackEventHandler sourceControl, string eventArgument)
        //{
        //    if (sourceControl == btnSearch && !string.IsNullOrEmpty(eventArgument) && eventArgument.StartsWith("page:"))
        //    {
        //        int page = int.Parse(eventArgument.Split(':')[1]);
        //        BindList(page);
        //        return;
        //    }
        //    base.RaisePostBackEvent(sourceControl, eventArgument);
        //}

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            try
            {
                string mediaType = ddlMediaTypeUpload.SelectedValue;
                string title = tbTitle.Text.Trim();
                if (string.IsNullOrWhiteSpace(title)) throw new Exception("Title is required.");


                int? categoryId = string.IsNullOrWhiteSpace(ddlCategory.SelectedValue) ? (int?)null : Convert.ToInt32(ddlCategory.SelectedValue);
                string desc = string.IsNullOrWhiteSpace(tbDescription.Text) ? null : tbDescription.Text.Trim();
                string tags = string.IsNullOrWhiteSpace(tbTags.Text) ? null : tbTags.Text.Trim();


                if (mediaType == "File")
                {
                    if (!fuFiles.HasFiles) throw new Exception("Please choose at least one file.");


                    // Support multi-files upload – one DB row per file
                    foreach (string key in Request.Files.AllKeys)
                    {
                        var posted = Request.Files[key];
                        if (posted == null || posted.ContentLength == 0) continue;


                        string ext = Path.GetExtension(posted.FileName).ToLowerInvariant();
                        if (!AllowedExts.Contains(ext)) throw new Exception($"File type not allowed: {ext}");


                        string folder = $"~/Uploads/Guidelines/{DateTime.Now:yyyy/MM}/";
                        EnsureFolder(Server.MapPath(folder));


                        string safeName = MakeSlug(Path.GetFileNameWithoutExtension(posted.FileName));
                        string unique = Guid.NewGuid().ToString("N").Substring(0, 8);
                        string finalName = $"{safeName}-{unique}{ext}";
                        string virtualPath = folder + finalName;
                        string phys = Server.MapPath(virtualPath);
                        posted.SaveAs(phys);


                        // Insert DB row via SQRLibrary
                        string sql = "EXEC dbo.SYSTEM_Guideline_Insert @Title,@Description,@CategoryId,@MediaType,@FileExt,@FilePath,@FileSize,@Url,@Tags,@CreatedBy";
                        var newIdDt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql,
                        new List<string> { "@Title", "@Description", "@CategoryId", "@MediaType", "@FileExt", "@FilePath", "@FileSize", "@Url", "@Tags", "@CreatedBy" },
                        new List<object> { title, (object)desc ?? DBNull.Value, (object)categoryId ?? DBNull.Value, "File", ext.Trim('.'), virtualPath, posted.ContentLength, DBNull.Value, (object)tags ?? DBNull.Value, Context.User?.Identity?.Name ?? "system" });
                    }
                }
                else // YouTube
                {
                    string url = tbYouTubeUrl.Text.Trim();
                    if (string.IsNullOrWhiteSpace(url)) throw new Exception("YouTube URL is required.");
                    // Validate YouTube ID quickly
                    string vid = ParseYouTubeId(url);
                    if (string.IsNullOrEmpty(vid)) throw new Exception("Invalid YouTube URL.");


                    string sql = "EXEC dbo.SYSTEM_Guideline_Insert @Title,@Description,@CategoryId,@MediaType,@FileExt,@FilePath,@FileSize,@Url,@Tags,@CreatedBy";
                    var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql,
                    new List<string> { "@Title", "@Description", "@CategoryId", "@MediaType", "@FileExt", "@FilePath", "@FileSize", "@Url", "@Tags", "@CreatedBy" },
                    new List<object> { title, (object)desc ?? DBNull.Value, (object)categoryId ?? DBNull.Value, "YouTube", DBNull.Value, DBNull.Value, DBNull.Value, url, (object)tags ?? DBNull.Value, Context.User?.Identity?.Name ?? "system" });
                }

                // Refresh & toast
                BindList(1);
                ScriptManager.RegisterStartupScript(this, GetType(), "ok", "Swal.fire('Saved','Guideline added successfully','success');", true);
                tbTitle.Text = tbDescription.Text = tbTags.Text = tbYouTubeUrl.Text = string.Empty;
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "err", $"Swal.fire('Error', '{HttpUtility.JavaScriptStringEncode(ex.Message)}', 'error');", true);
            }
        }

        protected void rptItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument.ToString().Split('|')[0]);
            if (e.CommandName == "view")
            {
                // Load item meta
                var dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM dbo.SYSTEM_GuidelineItem WHERE GuidelineId=@Id",
                new List<string> { "@Id" }, new List<object> { id });
                if (dt.Rows.Count == 0) return;
                var row = dt.Rows[0];
                string mediaType = row["MediaType"].ToString();


                string url;
                if (string.Equals(mediaType, "YouTube", StringComparison.OrdinalIgnoreCase))
                {
                    string yt = Convert.ToString(row["Url"]);
                    string vid = ParseYouTubeId(yt);
                    url = $"https://www.youtube.com/embed/{vid}?autoplay=1&rel=0";
                }
                else // File
                {
                    string ext = Convert.ToString(row["FileExt"]).ToLowerInvariant();
                    string vpath = Convert.ToString(row["FilePath"]);


                    if (ext == "pdf")
                    {
                        // Stream inline via handler
                        url = $"{ResolveUrl("~/GuidelineDownload.ashx")}?id={id}&mode=inline";
                    }
                    else if (ext == "docx" || ext == "doc" || ext == "pptx" || ext == "xlsx")
                    {
                        // Office Online viewer requires absolute public URL
                        string absolute = GetAbsoluteUrl(vpath);
                        url = "https://view.officeapps.live.com/op/embed.aspx?src=" + HttpUtility.UrlEncode(absolute);
                    }
                    else
                    {
                        // Fallback: open raw file via handler
                        url = $"{ResolveUrl("~/GuidelineDownload.ashx")}?id={id}&mode=inline";
                    }
                }

                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.SYSTEM_Guideline_IncView @Id", new List<string> { "@Id" }, new List<object> { id });


                // Open modal on client
                ScriptManager.RegisterStartupScript(this, GetType(), "pv", $"openPreview('{HttpUtility.JavaScriptStringEncode(url)}');", true);
            }
            else if (e.CommandName == "download")
            {
                Response.Redirect($"{ResolveUrl("~/GuidelineDownload.ashx")}?id={id}&mode=download", false);
            }
            else if (e.CommandName == "toggle")
            {
                if (!CanManage) return;
                var parts = e.CommandArgument.ToString().Split('|');
                int gid = Convert.ToInt32(parts[0]);
                bool current = Convert.ToBoolean(parts[1]);
                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.SYSTEM_Guideline_SetActive @GuidelineId,@IsActive",
                new List<string> { "@GuidelineId", "@IsActive" }, new List<object> { gid, current ? 0 : 1 });
                BindList(1);
            }
        }


        protected void btnDeleteServer_Click(object sender, EventArgs e)
        {
            if (!CanManage) return;
            string arg = Request["__EVENTARGUMENT"]; // guideline id
            if (!int.TryParse(arg, out int id)) return;


            // Delete: remove DB row; optionally delete physical file if File type
            var dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT MediaType, FilePath FROM dbo.SYSTEM_GuidelineItem WHERE GuidelineId=@Id",
            new List<string> { "@Id" }, new List<object> { id });


            if (dt.Rows.Count > 0)
            {
                string mediaType = dt.Rows[0]["MediaType"].ToString();
                string vpath = Convert.ToString(dt.Rows[0]["FilePath"]);


                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.SYSTEM_Guideline_Delete @GuidelineId",
                new List<string> { "@GuidelineId" }, new List<object> { id });


                if (string.Equals(mediaType, "File", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrEmpty(vpath))
                {
                    var phys = Server.MapPath(vpath);
                    if (File.Exists(phys))
                    {
                        try { File.Delete(phys); } catch { /* ignore IO errors */ }
                    }
                }
            }


            BindList(1);
            ScriptManager.RegisterStartupScript(this, GetType(), "delok", "Swal.fire('Deleted','The item was deleted.','success');", true);
        }

        protected bool IsFileMedia(object mediaTypeObj)
        {
            if (mediaTypeObj == null || mediaTypeObj == DBNull.Value) return false;
            return string.Equals(mediaTypeObj.ToString(), "File", StringComparison.OrdinalIgnoreCase);
        }
        // == Helpers ==
        protected string GetIconCss(object mediaTypeObj, object extObj)
        {
            
            string mediaType = Convert.ToString(mediaTypeObj);
            string ext = Convert.ToString(extObj).ToLowerInvariant();
            if (string.Equals(mediaType, "YouTube", StringComparison.OrdinalIgnoreCase)) return "bi-youtube text-danger";
            switch (ext)
            {
                case "pdf": return "bi-filetype-pdf text-danger";
                case "doc":
                case "docx": return "bi-filetype-docx text-primary";
                case "pptx": return "bi-filetype-pptx text-warning";
                case "xlsx": return "bi-filetype-xlsx text-success";
                default: return "bi-file-earmark-text";
            }
        }
        protected string RenderTags(object tags)
        {
            var t = Convert.ToString(tags);
            if (string.IsNullOrWhiteSpace(t)) return string.Empty;
            var list = t.Split(',').Select(x => x.Trim()).Where(x => x.Length > 0).Take(6).ToArray();
            return string.Join(" ", list.Select(x => $"<span class='badge rounded-pill text-bg-light tag'>{HttpUtility.HtmlEncode(x)}</span>"));
        }

        private static void EnsureFolder(string phys)
        {
            var dir = Path.GetDirectoryName(phys);
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
        }

        private static string MakeSlug(string input)
        {
            input = (input ?? "").ToLowerInvariant();
            input = Regex.Replace(input, @"[^a-z0-9\-\s]", "");
            input = Regex.Replace(input, @"\s+", "-").Trim('-');
            if (string.IsNullOrEmpty(input)) input = "file";
            return input.Length > 60 ? input.Substring(0, 60) : input;
        }

        private string GetAbsoluteUrl(string virtualPath)
        {
            var uri = Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl(virtualPath);
            return uri;
        }

        private static string ParseYouTubeId(string url)
        {
            if (string.IsNullOrWhiteSpace(url)) return null;
            // Supports https://youtu.be/ID, https://www.youtube.com/watch?v=ID, /embed/ID
            var m = Regex.Match(url,
            @"(?:youtu\.be/|youtube\.com/(?:watch\?v=|embed/|shorts/))([A-Za-z0-9_-]{6,})",
            RegexOptions.IgnoreCase);
            return m.Success ? m.Groups[1].Value : null;
        }
    }
}
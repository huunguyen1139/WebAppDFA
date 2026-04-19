using Microsoft.Ajax.Utilities;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ganss.Xss;
using DevExpress.XtraRichEdit.Import.Html;
using WebApp.Controls;
namespace WebApp.CustomControl
{
    public partial class CommentControl : System.Web.UI.UserControl
    {
        public string DocumentID { get; set; }
        protected string CurrentUserID => Session["userid"]?.ToString() ?? "guest";

        
        protected void Page_Load(object sender, EventArgs e)
        {
            
            //txtComment.Attributes["onkeydown"] = $"submitOnEnter(event, '{btnAddComment.ClientID}')";
            if (!IsPostBack)
            {
                BindComments();
            }
        }
        private void BindComments()
        {
            try
            {
                //string documentId = Request["no"]?.ToString(); 
                string sql = $"SELECT * FROM Comments WHERE DocumentID = @documentId AND ParentCommentID IS NULL ORDER BY CommentDate DESC";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@documentId" }
                , new List<object>() { DocumentID });
                rptComments.DataSource = dt;
                rptComments.DataBind();
            }
            catch { }
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

        protected void rptComments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                System.Web.UI.WebControls.TextBox txtReply = (System.Web.UI.WebControls.TextBox)e.Item.FindControl("txtReply");
                System.Web.UI.WebControls.Button btnReply = (System.Web.UI.WebControls.Button)e.Item.FindControl("btnReply");

                if (txtReply != null && btnReply != null)
                {
                    string js = $"submitOnEnter(event, '{btnReply.ClientID}')";
                    txtReply.Attributes["onkeydown"] = js;
                }              
                
            }
        }

        protected DataTable GetReplies(object parentId)
        {
            return SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM Comments WHERE ParentCommentID = @pid ORDER BY CommentDate ASC",
                           new List<string>() { "@pid" }, new List<object>() { parentId });
        }

        public string FormatCommentText(string content)
        {
            if (string.IsNullOrEmpty(content))
                return string.Empty;

            // Optional: decode HTML if needed
            // content = HttpUtility.HtmlDecode(content);

            // Replace <span class="mention" data-userid="123">@Name</span> with link
            var doc = new HtmlAgilityPack.HtmlDocument();
            doc.LoadHtml(content);

            foreach (var span in doc.DocumentNode.SelectNodes("//span[@class='mention-new']") ?? Enumerable.Empty<HtmlAgilityPack.HtmlNode>())
            {
                var userId = span.GetAttributeValue("data-userid", "");
                var userName = span.InnerText;
                var link = $"<a href='/Account/user.aspx?id={userId}' class='mention-new' target='_blank'>{userName}</a>";
                span.ParentNode.ReplaceChild(HtmlAgilityPack.HtmlNode.CreateNode(link), span);
            }

            return doc.DocumentNode.InnerHtml;
        }


        protected void btnAddComment_Click(object sender, EventArgs e)
        {
            string documentId = Request["no"]?.ToString();
            //string comment = txtComment.Text;
            string userId = Session["userid"]?.ToString() ?? "";
            string user = Session["username"].ToString() + " - " + userId;
            string rich_comment = mentionBoxNew.Value;
            //var sanitizer = new HtmlSanitizer();
            //string safeHtml = sanitizer.Sanitize(rich_comment);validateRequest="false"
            SQRLibrary.ExecuteSQL_mrp("InsertComment @DocumentID,@ParentCommentID, @UserName, @CommentText"
                , new List<string>() { "@DocumentID", "@ParentCommentID", "@UserName", "@CommentText" }
                , new List<object>() { documentId, DBNull.Value, user, rich_comment });

            //Extract mentioned user IDs from span tags
            List<string> mentionedUserIds = ExtractMentionedUserIds(rich_comment);

            //Notify each mentioned user
            string currentUrl = HttpContext.Current.Request.Url.PathAndQuery;
            foreach (string mentionedId in mentionedUserIds.Distinct())
            {
                //if (mentionedId != userId) // Don't notify self
                {
                    SQRLibrary.ExecuteSQL_mrp("InsertNotification @UserID, @Title, @Message, @Link",
                        new List<string> { "@Title", "@Message", "@UserID", "@Link" },
                        new List<object> {
                                            $"You've been mentioned by {user}",
                                            $"{user} mentioned you in a comment.",
                                            mentionedId,
                                            currentUrl
                                         }
                    );
                }
            }

            mentionBoxNew.Value = "";
            BindComments();
        }


        protected void btnReply_Click(object sender, EventArgs e)
        {
            var btn = (System.Web.UI.WebControls.Button)sender;
            RepeaterItem item = (RepeaterItem)btn.NamingContainer;
            int parentCommentID = Convert.ToInt32(btn.CommandArgument);
            //string reply = ((System.Web.UI.WebControls.TextBox)item.FindControl("txtReply")).Text;
            string rich_reply = ((MentionEditorNew)item.FindControl("mentionBoxReply")).Value;
            //string user = Session["username"].ToString() + " - " + Session["userid"].ToString();
            string documentId = Request["no"]?.ToString();

            string userId = Session["userid"]?.ToString() ?? "";
            string user = Session["username"].ToString() + " - " + userId;
           

            SQRLibrary.ExecuteSQL_mrp("InsertComment @DocumentID,@ParentCommentID, @UserName, @CommentText"
                , new List<string>() { "@DocumentID", "@ParentCommentID", "@UserName", "@CommentText" }
                , new List<object>() { documentId, parentCommentID, user, rich_reply });

            //Extract mentioned user IDs from span tags
            List<string> mentionedUserIds = ExtractMentionedUserIds(rich_reply);

            //Notify each mentioned user
            string currentUrl = HttpContext.Current.Request.Url.PathAndQuery;
            foreach (string mentionedId in mentionedUserIds.Distinct())
            {
                //if (mentionedId != userId) // Don't notify self
                {
                    SQRLibrary.ExecuteSQL_mrp("InsertNotification @UserID, @Title, @Message, @Link",
                        new List<string> { "@Title", "@Message", "@UserID", "@Link" },
                        new List<object> {
                                            $"You've been mentioned by {user}",
                                            $"{user} mentioned you in a comment.",
                                            mentionedId,
                                            currentUrl
                                         }
                    );
                }
            }

            BindComments();
        }

        private List<string> ExtractMentionedUserIds(string html)
        {
            var mentionedIds = new List<string>();
            var doc = new HtmlAgilityPack.HtmlDocument();
            doc.LoadHtml(html);

            var spans = doc.DocumentNode.SelectNodes("//span[@class='mention-new']");
            if (spans != null)
            {
                foreach (var span in spans)
                {
                    string uid = span.GetAttributeValue("data-userid", "");
                    if (!string.IsNullOrWhiteSpace(uid))
                        mentionedIds.Add(uid);
                }
            }

            return mentionedIds;
        }


        protected void lnkDeleteComment_Click(object sender, EventArgs e)
        {
            try
            {
                var link = (LinkButton)sender;
                int commentId = int.Parse(link.CommandArgument);



                var owner = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT UserName FROM Comments WHERE CommentID = @id"
                   , new List<string>() { "@id" }
                   , new List<object>() { commentId });

                if (owner.Rows[0][0].ToString().Contains(CurrentUserID))
                {
                    SQRLibrary.ExecuteSQL_mrp("EXEC DeleteComment @CommentID"
                       , new List<string>() { "@CommentID" }
                       , new List<object>() { commentId });
                }
                BindComments(); // Refresh the list
            }
            catch { }
        }
    }
}

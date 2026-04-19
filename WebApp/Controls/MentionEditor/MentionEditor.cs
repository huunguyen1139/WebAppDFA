using CkEditor;
using System;
using System.ComponentModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebApp.Controls
{
    
    [ToolboxData("<{0}:MentionEditor runat=server></{0}:MentionEditor>")]
    public class MentionEditor : CompositeControl
    {
        private HtmlGenericControl editorDiv;
        private HiddenField hiddenValue;

        // Placeholder text property
        [Category("Appearance")]
        [DefaultValue("Write a comment...")]
        public string Placeholder
        {
            get { return ViewState["Placeholder"] as string ?? "Write a comment..."; }
            set { ViewState["Placeholder"] = value; }
        }

        // Text property for getting/setting HTML
        public string Value
        {
            get
            {
                EnsureChildControls();
                return hiddenValue.Value;
            }
            set
            {
                EnsureChildControls();
                hiddenValue.Value = value;
                editorDiv.InnerHtml = HttpUtility.HtmlEncode(value);
            }
        }

        protected override void CreateChildControls()
        {
            Controls.Clear();

            // Visible rich editor
            editorDiv = new HtmlGenericControl("div");
            editorDiv.ID = "editorDiv";
            editorDiv.Attributes["contenteditable"] = "true";
            editorDiv.Attributes["class"] = "form-control mention-editor";
            editorDiv.Attributes["data-placeholder"] = Placeholder;

            // Hidden field for storing the cleaned HTML
            hiddenValue = new HiddenField { ID = "hiddenValue" };

            Controls.Add(editorDiv);
            Controls.Add(hiddenValue);
        }

        /*––––––––  Register CSS, JS, instance init  ––––––––*/
        //protected override void OnPreRender(EventArgs e)
        //{
        //    base.OnPreRender(e);

        //    /* 1) CSS (only once) */
        //    string cssUrl = Page.ResolveUrl("~/Controls/MentionEditor/MentionEditor.css");
        //    if (Page.Header.FindControl("MentionEditorCSS") == null)
        //    {
        //        Page.Header.Controls.Add(
        //            new LiteralControl($"<link id='MentionEditorCSS' rel='stylesheet' href='{cssUrl}' />"));
        //    }

        //    /* 2) JS (only once) */
        //    string jsUrl = Page.ResolveUrl("~/Controls/MentionEditor/MentionEditor.js");
        //    if (!Page.ClientScript.IsClientScriptIncludeRegistered("MentionEditorJS"))
        //    {
        //        ScriptManager.RegisterClientScriptInclude(this, GetType(),
        //                                                  "MentionEditorJS", jsUrl);
        //    }

        //    /* 3) Instance-specific init (runs on every load / async reload) */
        //    string init =
        //    $@"if (typeof initMentionEditor==='function') {{
        //            initMentionEditor('#{editorDiv.ClientID}', '#{hiddenValue.ClientID}');
        //        }}";
        //    ScriptManager.RegisterStartupScript(this, GetType(),
        //        "InitMention_" + ClientID, init, true);
        //}


        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // CSS
            string cssUrl = Page.ResolveUrl("~/Controls/MentionEditor/MentionEditor.css");
            Page.Header.Controls.Add(new LiteralControl($"<link rel='stylesheet' href='{cssUrl}' />"));

            // JS
            string jsUrl = Page.ResolveUrl("~/Controls/MentionEditor/MentionEditor.js");
            ScriptManager.RegisterClientScriptInclude(this, GetType(), "MentionEditorJS", jsUrl);

            // Initialize JS
            ScriptManager.RegisterStartupScript(this, GetType(), "InitMentionEditor_" + ClientID, InitScript(), true);
        }

        private string InitScript()
        {
            return $@"
                $(document).ready(function () {{
                    initMentionEditor('#{ClientID}_editorDiv', '#{hiddenValue.ClientID}');
                }});
            ";
        }
    }
}
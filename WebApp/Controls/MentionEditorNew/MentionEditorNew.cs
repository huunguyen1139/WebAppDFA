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

    [ToolboxData("<{0}:MentionEditorNew runat=server></{0}:MentionEditorNew>")]
    public class MentionEditorNew : CompositeControl
    {
        /*―――― PUBLIC ――――*/
        public string Placeholder
        {
            get => (string)(ViewState["Placeholder"] ?? "Write a comment …");
            set => ViewState["Placeholder"] = value;
        }
        public string Value
        {
            get { EnsureChildControls(); return _hidden.Value; }
            set { EnsureChildControls(); _hidden.Value = value; _editor.InnerHtml = HttpUtility.HtmlEncode(value); }
        }

        /*―――― PRIVATE ――――*/
        private HtmlGenericControl _editor;
        private HiddenField _hidden;

        protected override void CreateChildControls()
        {
            Controls.Clear();

            _editor = new HtmlGenericControl("div");
            _editor.ID = "ed";
            _editor.Attributes["contenteditable"] = "true";
            _editor.Attributes["class"] = "form-control mention-editor-new empty";
            _editor.Attributes["data-placeholder"] = Placeholder;

            _hidden = new HiddenField { ID = "hiddenValue" };

            Controls.Add(_editor);
            Controls.Add(_hidden);
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            /* 1️⃣ CSS only once */
            string cssUrl = Page.ResolveUrl("~/Controls/MentionEditorNew/MentionEditorNew.css");
            if (Page.Header.FindControl("MentionEditorNewCSS") == null)
            {
                Page.Header.Controls.Add(
                    new LiteralControl($"<link id='MentionEditorNewCSS' rel='stylesheet' href='{cssUrl}' />"));
            }

            /* 2️⃣ JS only once */
            string jsUrl = Page.ResolveUrl("~/Controls/MentionEditorNew/MentionEditorNew.js");
            if (!Page.ClientScript.IsClientScriptIncludeRegistered("MentionEditorNewJS"))
            {
                ScriptManager.RegisterClientScriptInclude(this, GetType(), "MentionEditorNewJS", jsUrl);
            }

            /* 3️⃣ instance-specific init */
            string init = $@"
                if (typeof initMentionEditorNew==='function') {{
                    initMentionEditorNew('#{_editor.ClientID}','#{_hidden.ClientID}');
                }}";
            ScriptManager.RegisterStartupScript(
                this, GetType(), "InitMentionEditorNew_" + ClientID, init, true);
        }

        //protected override void OnPreRender(EventArgs e)
        //{
        //    base.OnPreRender(e);

        //    // CSS
        //    string cssUrl = Page.ResolveUrl("~/Controls/MentionEditor.css");
        //    Page.Header.Controls.Add(new LiteralControl($"<link rel='stylesheet' href='{cssUrl}' />"));

        //    // JS
        //    string jsUrl = Page.ResolveUrl("~/Controls/MentionEditor.js");
        //    ScriptManager.RegisterClientScriptInclude(this, GetType(), "MentionEditorJS", jsUrl);

        //    // Initialize JS
        //    ScriptManager.RegisterStartupScript(this, GetType(), "InitMentionEditor_" + ClientID, InitScript(), true);
        //}

        //private string InitScript()
        //{
        //    return $@"
        //        $(document).ready(function () {{
        //            initMentionEditor('#{ClientID}_editorDiv', '#{hiddenValue.ClientID}');
        //        }});
        //    ";
        //}
    }
}
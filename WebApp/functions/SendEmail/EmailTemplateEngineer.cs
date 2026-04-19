using System;
using System.Collections.Generic;
using System.Data;
using Newtonsoft.Json;          // you already use this in several places
using Scriban;                  // light-weight template engine
using Scriban.Runtime;
using SQRFunctionLibrary;

public static class EmailTemplateEngine
{
    /// <summary>
    /// Renders a template stored in SYSTEM_EmailTemplate.
    /// Merge object can be an anonymous object, Dictionary&lt;string,object&gt; or POCO.
    /// </summary>
    public static (string Subject, string Body, bool IsHtml) Render(
        string templateCode, object model)
    {
        // 1. grab template row
        DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
            "SELECT SubjectTemplate, BodyTemplate, IsHtml " +
            "FROM dbo.SYSTEM_EmailTemplate WHERE TemplateCode = @Code",
            new List<string> { "@Code" }, new List<object> { templateCode });

        if (dt.Rows.Count == 0)
            throw new InvalidOperationException(
                $"Email template '{templateCode}' not found.");

        var row = dt.Rows[0];
        string subj = row["SubjectTemplate"].ToString();
        string body = row["BodyTemplate"].ToString();
        bool html = (bool)row["IsHtml"];

        // 2. build Scriban context so {{UserName}} etc. resolve
        var scriptObj = new ScriptObject();
        scriptObj.Import(model, renamer: m => m.Name);       // anonymous object
        var ctx = new TemplateContext
        {
            MemberRenamer = member => member.Name,           // keep case
            StrictVariables = true
        };
        ctx.PushGlobal(scriptObj);

        // 3. parse & render
        subj = Template.Parse(subj, lexerOptions: Scriban.Parsing.LexerOptions.Default)
                       .Render(ctx);
        body = Template.Parse(body).Render(ctx);

        return (subj, body, html);
    }

    /// <summary>
    /// Helper to convert JSON (from SampleJson) to an Expando-like dictionary.
    /// </summary>
    public static object ModelFromJson(string json)
        => JsonConvert.DeserializeObject<Dictionary<string, object>>(json);
}

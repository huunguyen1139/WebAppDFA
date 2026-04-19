using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.functions.SendEmail
{
    public static class EmailOutbox
    {
        /// <summary>
        /// Queue an email; returns immediately. Commented for clarity.
        /// </summary>
        public static void Enqueue(string to, string subject, string body, bool isHtml = true,
                                   string cc = null, string bcc = null, string attachmentsJson = null)
        {
            SQRLibrary.ExecuteSQL_mrp(
                "EXEC dbo.SYSTEM_EmailQueue_Enqueue @To,@Sub,@Body,@Html,@Cc,@Bcc,@Att",
                new List<string> { "@To", "@Sub", "@Body", "@Html", "@Cc", "@Bcc", "@Att" },
                new List<object> { to, subject, body, isHtml, cc, bcc, attachmentsJson });
        }

        /// <summary>
        /// Convenience: render by template then enqueue.
        /// </summary>
        public static void EnqueueByTemplate(string templateCode, object model, string to)
        {
            var (subject, body, isHtml) = EmailTemplateEngine.Render(templateCode, model);
            Enqueue(to, subject, body, isHtml);
        }
    }

}
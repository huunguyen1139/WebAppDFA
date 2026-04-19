using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Web;
using System.Security.Cryptography;
using System.Web.Mail;
using WebApp.site;
using static DevExpress.XtraPrinting.Native.ExportOptionsPropertiesNames;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Tab;
using System.Threading.Tasks;

namespace WebApp.functions.SendEmail
{
    public static class EmailHelper
    {
        // Cached settings (thread-safe, 10-minute sliding)
        private static Lazy<EmailConfig> _config =
            new Lazy<EmailConfig>(LoadConfig, true);

        private static EmailConfig LoadConfig()
        {
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
                "EXEC dbo.SYSTEM_EmailSettings_Get");
            if (dt.Rows.Count == 0) throw new InvalidOperationException(
                "Email settings not configured.");

            var r = dt.Rows[0];
            return new EmailConfig
            {
                SmtpServer = r["SmtpServer"].ToString(),
                Port = Convert.ToInt32(r["SmtpPort"]),
                EnableSSL = Convert.ToBoolean(r["EnableSSL"]),
                UserName = r["UserName"].ToString(),
                Password = r["PasswordPlain"]?.ToString(),
                UseDefault = Convert.ToBoolean(r["UseDefaultCreds"]),
                FromEmail = r["FromEmail"].ToString(),
                FromName = r["FromDisplayName"].ToString()
            };
        }
                

        /// <summary>Send immediately (synchronous). Throw on error.</summary>
        public static void Send(string to, string subject, string body,
                                bool isHtml = true,
                                IEnumerable<string> cc = null,
                                IEnumerable<string> bcc = null,
                                IEnumerable<string> attachments = null)
        {
            var cfg = _config.Value;

            using (var msg = new System.Net.Mail.MailMessage())
            {
                // MailAddress sender = new MailAddress("nhf.reminder@gmail.com", "NHF Reminder");
                msg.From = new MailAddress(cfg.FromEmail, cfg.FromName);

                foreach (var addr in to.Split(';', ',', ' '))
                    if (!string.IsNullOrWhiteSpace(addr))
                        msg.To.Add(addr.Trim());

                AddList(cc, msg.CC);
                AddList(bcc, msg.Bcc);

                msg.Subject = subject;
                msg.Body = body;
                msg.IsBodyHtml = isHtml;

                if (attachments != null)
                    foreach (var path in attachments)
                        msg.Attachments.Add(new Attachment(path));

                using (var client = new SmtpClient(cfg.SmtpServer, cfg.Port))
                {
                    client.EnableSsl = cfg.EnableSSL;
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.UseDefaultCredentials = false;
                    if (cfg.UseDefault)
                    {
                        client.Credentials = CredentialCache.DefaultNetworkCredentials;
                    }
                    else if (!string.IsNullOrEmpty(cfg.UserName))
                    {
                        client.Credentials = new NetworkCredential(cfg.UserName, cfg.Password);
                    }

                    client.Send(msg);
                }


                //SmtpClient smtpClient = new SmtpClient
                //{
                //    Host = "smtp.gmail.com",
                //    //"smtp.gmail.com" nhf.reminder@gmail.com
                //    Port = 587,
                //    EnableSsl = true,
                //    DeliveryMethod = SmtpDeliveryMethod.Network,
                //    UseDefaultCredentials = false,
                //    Credentials = new NetworkCredential("alliancevn.company@gmail.com", "ppxr cint zrpu gqyi")
                //};
                //try { smtpClient.Send(msg); }
                //catch (SmtpFailedRecipientException ex)
                //{
                //    throw new Exception("Recipient rejected: " + ex.FailedRecipient + " — " + ex.Message, ex);
                //}
                //catch (SmtpException ex)
                //{
                //    // surfaces 5.x.x responses
                //    throw new Exception("SMTP error (" + ex.StatusCode + "): " + (ex.InnerException?.Message ?? ex.Message), ex);
                //}
                //smtpClient.Send(msg);
            }

            // Log success
            SQRLibrary.ExecuteSQL_mrp("INSERT dbo.SYSTEM_EmailLog " +
                "(ToList,Subject,IsSuccess) VALUES (@To,@Sub,1)",
                new List<string> { "@To", "@Sub" },
                new List<object> { to, subject });
        }

        public static void SendByTemplate(string templateCode,
                                  object model,
                                  string to,
                                  IEnumerable<string> cc = null,
                                  IEnumerable<string> bcc = null,
                                  IEnumerable<string> attachments = null)
        {
            var (subject, body, isHtml) = EmailTemplateEngine.Render(templateCode, model);
            Send(to, subject, body, isHtml, cc, bcc, attachments);
        }


        public static async Task SendAsync(string to, string subject, string body,
                                bool isHtml = true,
                                IEnumerable<string> cc = null,
                                IEnumerable<string> bcc = null,
                                IEnumerable<string> attachments = null)
        {
            var cfg = _config.Value;

            using (var msg = new System.Net.Mail.MailMessage())
            {                
                msg.From = new MailAddress(cfg.FromEmail, cfg.FromName);

                foreach (var addr in to.Split(';', ',', ' '))
                    if (!string.IsNullOrWhiteSpace(addr))
                        msg.To.Add(addr.Trim());

                AddList(cc, msg.CC); AddList(bcc, msg.Bcc);

                msg.Subject = subject;
                msg.Body = body;
                msg.IsBodyHtml = isHtml;

                if (attachments != null)
                    foreach (var path in attachments)
                        msg.Attachments.Add(new Attachment(path));

                using (var client = new SmtpClient(cfg.SmtpServer, cfg.Port))
                {
                    client.EnableSsl = cfg.EnableSSL;
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.UseDefaultCredentials = false;
                    if (cfg.UseDefault)
                    {
                        client.Credentials = CredentialCache.DefaultNetworkCredentials;
                    }
                    else if (!string.IsNullOrEmpty(cfg.UserName))
                    {
                        client.Credentials = new NetworkCredential(cfg.UserName, cfg.Password);
                    }

                    //client.Send(msg);                    
                }                
            }

            // Log success
            SQRLibrary.ExecuteSQL_mrp("INSERT dbo.SYSTEM_EmailLog " +
                "(ToList,Subject,IsSuccess) VALUES (@To,@Sub,1)",
                new List<string> { "@To", "@Sub" },
                new List<object> { to, subject });
        }


        public static async Task SendAsyncByTemplate(string templateCode,
                                  object model,
                                  string to,
                                  IEnumerable<string> cc = null,
                                  IEnumerable<string> bcc = null,
                                  IEnumerable<string> attachments = null)
        {
            var (subject, body, isHtml) = EmailTemplateEngine.Render(templateCode, model);
            await SendAsync(to, subject, body, isHtml, cc, bcc, attachments);
        }
        private static void AddList(IEnumerable<string> list,
                                    MailAddressCollection col)
        {
            if (list == null) return;
            foreach (var addr in list)
                if (!string.IsNullOrWhiteSpace(addr))
                    col.Add(addr.Trim());
        }

        public static void Refresh()
        {
            // Force the Lazy<> to rebuild next time somebody calls EmailHelper.Send(...)
            _config = new Lazy<EmailConfig>(LoadConfig, true);
        }

        private class EmailConfig
        {
            public string SmtpServer; public int Port; public bool EnableSSL;
            public string UserName; public string Password; public bool UseDefault;
            public string FromEmail; public string FromName;
        }
    }
}
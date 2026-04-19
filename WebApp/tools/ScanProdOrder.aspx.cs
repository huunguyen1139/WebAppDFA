using DevExpress.Web.Internal.Dialogs;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using DevExpress.XtraRichEdit.Model;

using DevExpress.RichEdit.Export;

namespace WebApp.tools
{
    public partial class ScanProdOrder : SecurePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            if (!IsPostBack)
            {
                
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            try
            {
                var prodOrderNo = (hfProdOrderNo.Value ?? string.Empty).Trim();
                if (string.IsNullOrEmpty(prodOrderNo))
                {
                    Toast("ProdOrderNo is empty.", "error");
                    return;
                }
                if (prodOrderNo.Length > 20)
                {
                    Toast("ProdOrderNo too long (max 20).", "warning");
                    return;
                }

                if (!(prodOrderNo.Substring(0,2) == "RP" || prodOrderNo.Substring(0, 2) == "CR"))
                {
                    Toast("ProdOrderNo invalid format", "error");
                    return;
                }
                // Parameterized UPSERT with SQRLibrary.ExecuteSQL
                string sql = @"
                            DECLARE @now DATETIME2 = SYSDATETIME();
                            IF EXISTS (SELECT 1 FROM dbo.Custom_ScanProdOrder WHERE ProdOrderNo = @no)
                            BEGIN
                                UPDATE dbo.Custom_ScanProdOrder
                                   SET UpdatedDate = @now
                                 WHERE ProdOrderNo = @no;
                            END
                            ELSE
                            BEGIN
                                INSERT INTO dbo.Custom_ScanProdOrder
                                    (ProdOrderNo, CreatedDate, UpdatedDate, TransferDate, ReceiptDate, Remark, [Type])
                                VALUES
                                    (@no, @now, @now, NULL, NULL, NULL, NULL);
                            END";

                
                SQRLibrary.ExecuteSQL(
                    sql,
                    new List<string> { "@no" },
                    new List<object> { prodOrderNo }
                );

                Toast($"Saved {prodOrderNo}", "success");
            }
            catch (Exception ex)
            {
                Toast(ex.Message, "error");
            }
        }

        private void Toast(string message, string icon /* success | error | warning | info | question */)
        {
            // Emit a SweetAlert2 toast after the async postback
            var script = $@"
                Swal.fire({{
                    toast: true, position: 'top-end', timer: 1500, showConfirmButton: false,
                    icon: '{icon}', title: {ToJsString(message)}
                }});";
            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString("N"), script, true);
        }

        private static string ToJsString(string s)
        {
            if (s == null) s = "";
            // Basic JS string encoding for safety
            s = s.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\r", "").Replace("\n", "\\n");
            return $"'{s}'";
        }

    }
}


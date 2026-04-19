using DevExpress.Web.Internal.XmlProcessor;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace WebApp.functions.approval
{
    public partial class FlowAjax : System.Web.UI.Page
    {
        private readonly JavaScriptSerializer _js = new JavaScriptSerializer
        {
            MaxJsonLength = int.MaxValue
        };

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            Response.ContentType = "application/json";

            try
            {
                string action = Request["action"] ?? "";
                switch (action)
                {
                    case "template":
                        SendTemplate();
                        break;
                    case "entry":
                        SendEntry();
                        break;
                    default:
                        Throw404();
                        break;
                }
            }
            catch (Exception ex)
            {
                Response.StatusCode = 500;
                WriteJson(new { ok = false, message = ex.Message });
            }

            Response.End();
        }

        // Returns runtime instance steps for ?action=entry&doc=123
        private void SendEntry()
        {
            //if (!int.TryParse(Request["doc"], out int docId))
            //    Throw404();

            //DataTable dt = ApprovalService.GetInstanceStepsResolved(docId);
            DataTable dt = ApprovalService.GetInstanceStepsResolved(Request["doc"].ToString());
            WriteJson(TableToList(dt));
        }

        // Returns template steps for ?action=template&docType=1&project=XYZ&createdBy=U001
        private void SendTemplate()
        {
            if (!int.TryParse(Request["docType"], out int docTypeId))
                Throw404();
            string project = Request["project"] ?? "";
            string createdBy = Request["createdBy"] ?? "";

            DataTable dt = ApprovalService.GetTemplateSteps(
                docTypeId,
                string.IsNullOrEmpty(project) ? null : project,
                createdBy);

            WriteJson(TableToList(dt));
        }

        private void Throw404()
        {
            Response.StatusCode = 404;
            WriteJson(new { ok = false, message = "Unknown action." });
            Response.End();
        }

        private void WriteJson(object o)
        {
            Response.Write(_js.Serialize(o));
        }

        private static List<Dictionary<string, object>> TableToList(DataTable table)
        {
            var cols = table.Columns.Cast<DataColumn>().Select(c => c.ColumnName).ToArray();
            var list = new List<Dictionary<string, object>>(table.Rows.Count);
            foreach (DataRow row in table.Rows)
            {
                var dict = new Dictionary<string, object>(cols.Length);
                foreach (var c in cols)
                    dict[c] = row[c] is DBNull ? null : row[c];
                list.Add(dict);
            }
            return list;
        }

    }

}

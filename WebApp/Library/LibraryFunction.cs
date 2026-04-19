using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using Microsoft.AspNet.Identity.Owin;
using System.Web.UI.WebControls;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using SQRFunctionLibrary;
using System.Net.Mail;
using System.Net;
using System.Threading.Tasks;
using System.Web.Providers.Entities;

namespace Library
{
    public class LibraryFunction
    {
        
        public static string erp_connection = "";
        public static string mrp_connection = "";
        private static List<string> u = new List<string>() { "20276", "10529", "20076", "10617" } ;

        public DataTable ConvertTabletoDataTable(Table tb)
        {
            DataTable result = new DataTable();
            try
            {
                TableRow tbheaderrow = tb.Rows[0];
                foreach (TableCell tc in tbheaderrow.Cells)
                {
                    result.Columns.Add(tc.Text);
                }

                for (int i = 1; i < tb.Rows.Count; i++)
                {
                    result.Rows.Add();
                    for (int j = 0; j < tb.Rows[i].Cells.Count; j++)
                    {
                        result.Rows[i - 1][j] = tb.Rows[i].Cells[j].Text;
                    }

                }
            }
            catch { }
            return result;
        }
        public static System.Data.DataTable ReturnDatatablefromSQL(string sql, string connection)
        {

            System.Data.DataTable _result = new System.Data.DataTable();

            try
            {
                string ConnectionString = default(string);
                switch (connection)
                {
                    case "erp":
                        ConnectionString = erp_connection;
                        break;
                    case "mrp":
                        ConnectionString = mrp_connection;
                        break;
                    case "hr":
                        ConnectionString = "";
                        break;
                }
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand sqlcom = new SqlCommand(sql, con))
                    {
                        con.Open();                       
                        SqlDataReader reader = sqlcom.ExecuteReader();
                        _result.Load(reader);
                    }
                }
            }
            catch { }
            return _result;
        }

        public static System.Data.DataTable ReturnDatatablefromSQL(string sql, string connection, List<string> paraname, List<object> paravalue)
        {

            System.Data.DataTable _result = new System.Data.DataTable();

            try
            {
                string ConnectionString = default(string);
                switch (connection)
                {
                    case "erp":
                        ConnectionString = erp_connection;
                        break;
                    case "mrp":
                        ConnectionString = mrp_connection;
                        break;
                    case "hr":
                        ConnectionString = "";
                        break;
                }
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand sqlcom = new SqlCommand(sql, con);
                con.Open();
                if (paraname != null && paraname.Count > 0)
                {
                    for (int i = 0; i < paraname.Count; i++)
                    {
                        sqlcom.Parameters.AddWithValue(paraname[i], paravalue[i]);
                    }
                }
                _result.Load(sqlcom.ExecuteReader());
                con.Close();                
            }
            catch { }
            return _result;
        }
       
        public static void ShowMessage(string message, Page pg)
        {
            Type cstype = pg.GetType();
            

            ClientScriptManager cs = pg.Page.ClientScript;

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, "PopupScript"))
            {
                String cstext = "alert('" + message + "');";
                cs.RegisterStartupScript(cstype, "PopupScript", cstext, true);
            }
        }

        public static DataTable ValidateLogin(string UserName)
        {
            string sql = "select * from Employee where EmployeeID = @EmployeeID and Status = 1 ";
            DataTable dt = SQRFunctionLibrary.SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@EmployeeID" }, new List<object>() { UserName });

            return dt;
        }

        public static DataTable GetEmployeeList_NH(string UserName = "")
        {           
            try
            {
                if (UserName == "") return SQRLibrary.ReturnDatatablefromSQL_NH("SELECT * FROM vB20Employee");
                else return SQRLibrary.ReturnDatatablefromSQL_NH("SELECT * FROM vB20Employee WHERE Code = @Code"
                    , new List<string>() { "@Code"}
                    , new List<object>() { UserName});
            }
            catch { return null; }            
        }

        public static DataTable GetEmployeeList_HRIS(string UserName = "")
        {
            try
            {
                string sql = @"EXEC [ALL_GetEmployeeList] @Code";
                
                return SQRLibrary.ReturnDatatablefromSQL_hr(sql
                    , new List<string>() { "@Code" }
                    , new List<object>() { UserName });
            }
            catch { return null; }
        }

        public static List<string> GetInChargeDepartment(string userid)
        {
            List<string> result = new List<string>();
            if (userid == null) return result;
            DataTable dt = SQRFunctionLibrary.SQRLibrary.ReturnDatatablefromSQL_mrp("select * from POR_InputDataPermission WHERE EmployeeID = @EmployeeID", new List<string>() { "@EmployeeID" }, new List<object>() { userid});
            if (dt != null && dt.Rows.Count > 0)
            {
                string InchargeDepartment = dt.Rows[0]["InChargeForDept"].ToString();
                string[] temp =  InchargeDepartment.Split(';');
                result = temp.ToList();                
            }
            return result;
        }

        public static List<string> GetUserSetpTarget()
        {
            List<string> result = u;            
            return result;            
        }

        public static List<string> GetUserSubmitQualityReport()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserUpdateReworkDeptOnQualityReport()
        {
            List<string> result = u;
            return result;

        }
        

        public static List<string> GetUserSubmitProductionChangeRequest()
        {
            List<string> result = u;
            return result;
        }

        public static List<string> GetUserDeleteProductionOutput()
        {
            List<string> result = u;
            return result;

        }
        public static List<string> GetUserSetpUnitCost()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserCreateMaterialRequest()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserCreateForeignOrder()
        {
            List<string> result = u;
            return result;
        }


        public static List<string> GetUserCreateDomesticOrder()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserInchargeOfProject(string projectcode)
        {
            List<string> result = u;
            return result;
        }

        public static List<string> GetUserChangeKaizen()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserChangeGanttChart()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserUpdatePromisedDateOnFactoryOrder()
        {
            List<string> result = u;
            return result;           

        }

        public static List<string> GetUserDeleteDefectList()
        {
            List<string> result = u;
            return result;

        }

        public static List<string> GetUserLoadHealthDeclaration()
        {
            List<string> result = u;
            return result;

        }
        
        public static List<string> GetUserSetpCompanyTarget()
        {
            List<string> result = u;
            return result;
        }

        public static List<string> GetUserChangeStatusOfFactoryOrder()
        {
            List<string> result = u;
            return result;
        }

        public static List<string> GetUserChangeStatusOfSiteOrder()
        {
            List<string> result = u;
            return result;
        }

        public static List<string> GetUserReturnFactoryOrder()
        {
            List<string> result = u;
            return result;
        }

        public static List<string> GetUserReturnSiteOrder()
        {
            List<string> result = u;
            return result;
        }

        public static void LoadDataTableToGridView(GridView gv, DataTable dt, List<string> hidecolumn = default(List<string>))
        {
            try
            {
                if (gv != null) gv.Columns.Clear();
                if (hidecolumn == null) hidecolumn = new List<string>() { };
                foreach (DataColumn cl in dt.Columns)
                {
                    if (hidecolumn.IndexOf(cl.ColumnName)<0)
                        gv.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                }

                gv.Visible = true;
                gv.AutoGenerateColumns = false;
                gv.DataSource = dt;
                gv.DataBind();
            }
            catch { }
        }

        public static DataTable GetEmployeeList(bool nghiviec = false)
        {           
            try
            {                
                if (nghiviec) return SQRLibrary.ReturnDatatablefromSQL_NH("select Id, Code, [Name]  FROM B20Dept");
                else return SQRLibrary.ReturnDatatablefromSQL_NH("select Id, Code, [Name]  FROM B20Dept WHERE IsActive = 1");

            }
            catch { return null; }
            
        }
        public static void LoadDataTableToGridView2(GridView gv, DataTable dt, List<string> hidecolumn = default(List<string>), List<string> DateColumn = default(List<string>))
        {
            try
            {
                gv.Columns.Clear();
                if (hidecolumn == null) hidecolumn = new List<string>() { };
                if (DateColumn == null) DateColumn = new List<string>() { };
                foreach (DataColumn cl in dt.Columns)
                {
                    if (hidecolumn.IndexOf(cl.ColumnName) < 0)
                    {
                        if (DateColumn.IndexOf(cl.ColumnName) >= 0)
                        {
                            gv.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName, DataFormatString = "{0:dd-MM-yyyy}" });
                        }
                        else
                        {
                            gv.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                        }
                    }
                }

                gv.Visible = true;
                gv.AutoGenerateColumns = false;
                gv.DataSource = dt;
                gv.DataBind();
            }
            catch { }
        }
        public static string[] GetFile(string code, string version)
        {
            string[] _temp = new string[2];
            try
            {
                //string sql = "select URL1, [Description] from [Record Link] where URL1 like '%" + code + "%" + version + "%'";
                string sql = "select URL1, [Description] from [Record Link] where URL1 like '%" + code + " -%" + version + "%' OR  URL1 like '%" + code + "-%" + version + "%' ORDER BY [Link ID] desc";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql);

                if (dt.Rows.Count > 0 & code.Length > 0)
                {
                    _temp[0] = dt.Rows[0][0].ToString();
                    _temp[1] = dt.Rows[0][1].ToString();
                }                
            }
            catch
            { }

            return _temp;
        }

        public static System.Data.DataTable GetBOMLine(string BOMCode, string Department = "")
        {
            string sql = "";
            sql += "select ";
            sql += "case when Type = 1 then 'Item' when Type=2 then 'BOM' end as [Type], No_, Description, [Unit of Measure Code] as UOM";
            sql += ", format([Quantity per], '#0.####') as Quantity, [BOM Comments] as Comments, format([Qty_ Component],'#.####') as Qty_Com";
            sql += ", case when [Wood Selection Quantity] = 0 then '' else format([Wood Selection Quantity], '#0.####') end as [WO]";
            sql += ", FORMAT([Fine Mill Quantity],'#.####') AS [FineMill], format([Assembly Quantity], '##.####') as [Assembly]";
            sql += ", case when [Finishing Quantity] = 0 then '' else format([Finishing Quantity], '#0.####') end as Finishing";
            sql += ", format([Ironing Quantity], '#.####') as Ironing, format([Fitting Quantity], '#.####') as Fitting";
            sql += ", case when [Upholstery Quantity]=0 then '' else format([Upholstery Quantity], '#0.####') end as UPH, format([Packing Quantity], '#.####') as Packing";
            sql += ", format(Length, '#.##') as [Length], format(Width, '#.##') as Width, format(Depth, '#.##') as Depth, format([Scrap _], '#.####') as Scrap";
            sql += " from [LIVE_ALLIANCE_90$Production BOM Line] ";
            sql += " WHERE [Production BOM No_] = '" + BOMCode + "'";
            switch (Department)
            {
                case "WO": sql += " and [Wood Selection Quantity] > 0 "; break;
                case "FM": sql += "  and [Fine Mill Quantity] > 0 "; break;
                case "AS": sql += " and [Assembly Quantity] > 0 "; break;
                case "FIN": sql += " and [Finishing Quantity] > 0 "; break;
                case "IRON": sql += " and [Ironing Quantity] > 0 "; break;
                case "FIT": sql += "  and [Fitting Quantity] > 0 "; break;
                case "UPH": sql += " and [Upholstery Quantity] > 0 "; break;
                case "PAC": sql += " and [Packing Quantity] > 0 "; break;
            }
            return SQRFunctionLibrary.SQRLibrary.ReturnDatatablefromSQL(sql);
        }

        public static System.Data.DataTable GetBOMLine(string BOMCode, bool isDetail, string Department = "")
        {
            string sql = "";
            sql += "select ";
            sql += " [Production BOM No_] as ProductionBOMNo, No_, Description, [Unit of Measure Code] as UOM";
            sql += ", format([Quantity per], '#0.####') as Quantity";
            sql += ", case when [Assembly Quantity] = 0 then '' else format([Assembly Quantity], '#0.####') end as [Assembly]";
            sql += ", CASE when [Ironing Quantity]=0 then '' else format([Ironing Quantity], '#0.####') end as [Ironing]";
            sql += ", format(Length, '#.##') as [Length], format(Width, '#.##') as Width, format(Depth, '#.##') as Depth";
            sql += " from [LIVE_ALLIANCE_90$Production BOM Line] ";
            sql += " where [Production BOM No_] in ";
            sql += " (select No_ from [LIVE_ALLIANCE_90$Production BOM Line] ";
            sql += " where [Production BOM No_] = '" + BOMCode + "' and ";
            sql += " Type= 2)";

            switch (Department)
            {
                case "WO": sql += " and [Wood Selection Quantity] > 0 "; break;
                case "FM": sql += "  and [Fine Mill Quantity] > 0 "; break;
                case "AS": sql += " and [Assembly Quantity] > 0 "; break;
                case "FIN": sql += " and [Finishing Quantity] > 0 "; break;
                case "IRON": sql += " and [Ironing Quantity] > 0 "; break;
                case "FIT": sql += "  and [Fitting Quantity] > 0 "; break;
                case "UPH": sql += " and [Upholstery Quantity] > 0 "; break;
                case "PAC": sql += " and [Packing Quantity] > 0 "; break;
            }
             
            return SQRFunctionLibrary.SQRLibrary.ReturnDatatablefromSQL(sql);
        }

        public static DataTable GetDataFromClipboard()
        {
            DataTable result = null;
            try
            {               
                DataObject o = (DataObject)Clipboard.GetDataObject();
                if (o.GetDataPresent(DataFormats.Text))
                {
                    string[] pastedRows = Regex.Split(o.GetData(DataFormats.Text).ToString().TrimEnd("\r\n".ToCharArray()), "\r\n");
                    string[] firstrow = pastedRows[0].Split(new char[] { '\t' });

                    foreach (string str in firstrow)
                    {
                        result.Columns.Add();
                    }

                    for (int i = 0; i < pastedRows.Length; i++)
                    {
                        string[] DetailRow = pastedRows[i].Split(new char[] { '\t' });
                        result.Rows.Add();
                        for (int j = 0; j < DetailRow.Length; j++)
                        {
                            result.Rows[i][j] = DetailRow[i];
                        }
                    }
                }
            }
            catch { }
            return result;
        }

        public static void InsertActivitiesLog(string UserID, string Description)
        {
            try
            {
                string sql = "INSERT INTO [POR_ActivitiesLog] ([UserID],[LogOnDate],[Description]) VALUES (@UserID, getdate(), @Description) ";
                SQRFunctionLibrary.SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@UserID", "@Description" }, new List<object>() { UserID, Description });
            }
            catch { }
        }

        public static bool CheckFileType(string fileName, List<string> ExtensionList)
        {

            string ext = System.IO.Path.GetExtension(fileName);

            if (ExtensionList.IndexOf(ext) >= 0)
            {
                return true;
            }
            else { return false; }            
        }

        public static async Task SendEmail(List<string> to_email, List<string> to_Name, List<string> cc_email, List<string> cc_Name, string subject, string body)
        {
            MailAddress sender = new MailAddress("nhf.reminder@gmail.com", "NHF Reminder");                    

            MailAddress receipt = new MailAddress(to_email[0], to_Name[0]);
            SmtpClient smtpClient = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(sender.Address, "vvnm dxeg qosg mynx")
            };

            using MailMessage mailMessage = new MailMessage(sender, receipt)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            };
            if (to_Name.Count > 1)
            {
                for (int k = 1; k < to_Name.Count; k++)
                {
                    mailMessage.To.Add(new MailAddress(to_email[k], to_Name[k]));
                }
            }

            if (cc_email!= null && cc_email.Count > 0)
            {
                for (int l = 0; l < cc_email.Count; l++)
                {
                    mailMessage.CC.Add(new MailAddress(cc_email[l], cc_Name[l]));
                }
            }

            smtpClient.Send(mailMessage);
        }

        public static void MakeAllColumnEditable(DataTable dt)
        {
            try
            {
                foreach (DataColumn col in dt.Columns)
                {
                    col.ReadOnly = false;
                }
            }
            catch { }
        }

        public static bool AllowToViewAllProject(string userid)
        {
            try
            {
                string sql = @"SELECT UserID FROM UserRoles ur
                            JOIN Roles r ON ur.RoleID = r.RoleID AND r.RoleName in ('Allow View All Projects','Admin')
                            WHERE ur.UserID = @userid";

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql
                    , new List<string>() { "@userid" }
                    , new List<object>() { userid });

                return dt.Rows.Count > 0;
            }
            catch { return false; }
        }


        //if postoutput = 1 for project or user in group BOD-SITE, Admin, Office Admin
        public static bool AllowToViewTenderPrice(string DocumentNo, string userid)
        {
            try
            {
                string sql = @"EXEC [ALL_TENDER_CheckUserHasPermissionOnProject] @DocumentNo, @userid
                            ";

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql
                    , new List<string>() { "@DocumentNo", "@userid" }
                    , new List<object>() { DocumentNo, userid });
                if (dt.Rows.Count > 0)
                {
                    return dt.Rows[0][0].ToString() == "1";
                }
                else return false;
            }
            catch { return false; }
        }

        public static void GetWeekRange(DateTime date, out DateTime fromDate, out DateTime toDate)
        {
            int diff = (7 + (date.DayOfWeek - DayOfWeek.Monday)) % 7;
            fromDate = date.Date.AddDays(-diff);
            toDate = fromDate.AddDays(6);
        }

        public static string ConvertBadgeToInline(string html)
        {
            // Dictionary of badge background colors
            var bgColors = new Dictionary<string, string>()
            {
                { "bg-danger", "#dc3545" },
                { "bg-warning", "#ffc107" },
                { "bg-success", "#198754" },
                { "bg-info", "#0dcaf0" },
                { "bg-primary", "#0d6efd" },
                { "bg-secondary", "#6c757d" },
                { "bg-dark", "#343a40" },
                { "bg-light", "#f8f9fa" }
            };

            // Replace badge spans
            foreach (var kv in bgColors)
            {
                string className = $"badge {kv.Key}";
                string pattern = $@"<span[^>]*class=""{className}[^""]*""[^>]*>(.*?)</span>";

                html = Regex.Replace(html, pattern, match =>
                {
                    string text = match.Groups[1].Value;

                    // Check if text-dark exists
                    bool isDarkText = match.Value.Contains("text-dark");

                    string color = isDarkText ? "#000000" : "#ffffff";

                    // Yellow badge with white text would look bad -> black text
                    if (kv.Key == "bg-warning")
                        color = "#000000";

                    return $"<span style=\"background:{kv.Value};color:{color};padding:3px 8px;border-radius:4px;\">{text}</span>";
                }, RegexOptions.IgnoreCase);
            }

            return html;
        }

        public static string ConvertTableToInline(string html)
        {
            if (string.IsNullOrEmpty(html))
                return html;

            // 1. Replace <table class="table table-striped table-bordered table-sm">
            string tablePattern = @"<table([^>]*)class=""table table-striped table-bordered table-sm""([^>]*)>";
            string tableStyle =
                "width:90%; " +
                "border-collapse:collapse; " +
                "font-family:Segoe UI, Arial, sans-serif; " +
                "font-size:15px; " +
                "border:1px solid #dee2e6; ";

            html = Regex.Replace(
                html,
                tablePattern,
                m =>
                {
                    string before = m.Groups[1].Value;
                    string after = m.Groups[2].Value;
                    return $"<table{before} style=\"{tableStyle}\"{after}>";
                },
                RegexOptions.IgnoreCase
            );

            // Helper: inject extra style into existing style="" or add new style=""
            string AddOrAppendStyle(string tagAttrs, string extraStyle)
            {
                if (string.IsNullOrEmpty(extraStyle))
                    return tagAttrs;

                // Has style already?
                var styleMatch = Regex.Match(tagAttrs, "style\\s*=\\s*\"([^\"]*)\"", RegexOptions.IgnoreCase);
                if (styleMatch.Success)
                {
                    string oldStyle = styleMatch.Groups[1].Value;
                    string newStyle = oldStyle.TrimEnd();

                    if (!newStyle.EndsWith(";") && newStyle.Length > 0)
                        newStyle += "; ";

                    newStyle += extraStyle;

                    // Replace old style="..."
                    return Regex.Replace(
                        tagAttrs,
                        "style\\s*=\\s*\"([^\"]*)\"",
                        $"style=\"{newStyle}\"",
                        RegexOptions.IgnoreCase
                    );
                }
                else
                {
                    // No style attribute yet
                    if (!tagAttrs.EndsWith(" "))
                        tagAttrs += " ";
                    tagAttrs += $"style=\"{extraStyle}\"";
                    return tagAttrs;
                }
            }

            // 2. Add border + padding to all <th>
            html = Regex.Replace(
                html,
                @"<th([^>]*)>",
                m =>
                {
                    string attrs = m.Groups[1].Value;
                    string extra = "border:1px solid #dee2e6; padding:6px; background:#f8f9fa;";
                    string newAttrs = AddOrAppendStyle(attrs, extra);
                    return $"<th{newAttrs}>";
                },
                RegexOptions.IgnoreCase
            );

            // 3. Add border + padding to all <td>
            html = Regex.Replace(
                html,
                @"<td([^>]*)>",
                m =>
                {
                    string attrs = m.Groups[1].Value;
                    string extra = "border:1px solid #dee2e6; padding:6px;";
                    string newAttrs = AddOrAppendStyle(attrs, extra);
                    return $"<td{newAttrs}>";
                },
                RegexOptions.IgnoreCase
            );

            // 4. Add striped background to even rows inside <tbody>
            html = Regex.Replace(
                html,
                @"<tbody>(.*?)</tbody>",
                tbodyMatch =>
                {
                    string body = tbodyMatch.Groups[1].Value;
                    int rowIndex = 0;

                    string newBody = Regex.Replace(
                        body,
                        @"<tr([^>]*)>",
                        trMatch =>
                        {
                            string attrs = trMatch.Groups[1].Value;

                            // Even rows (index 1,3,5...) get background
                            string extraStyle = (rowIndex % 2 == 1) ? "background:#f9f9f9;" : "";
                            rowIndex++;

                            if (string.IsNullOrEmpty(extraStyle))
                                return trMatch.Value; // no change

                            string newAttrs = AddOrAppendStyle(attrs, extraStyle);
                            return $"<tr{newAttrs}>";
                        },
                        RegexOptions.IgnoreCase
                    );

                    return "<tbody>" + newBody + "</tbody>";
                },
                RegexOptions.Singleline | RegexOptions.IgnoreCase
            );

            return html;
        }

    }
}
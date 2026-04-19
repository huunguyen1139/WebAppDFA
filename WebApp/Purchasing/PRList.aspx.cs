using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using System.Web.UI.HtmlControls;
using System.Drawing;
using DevExpress.Web.Internal.XmlProcessor;
using DevExpress.Web;
using DevExpress.RichEdit.Export;
using AngleSharp.Io;

namespace WebApp.Purchase
{
    public partial class PRList : Page
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";            
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            cbPurpose.InputAttributes["class"] = "form-check-input";
            cbDepartment.InputAttributes["class"] = "form-check-input";
            cbRequester.InputAttributes["class"] = "form-check-input";
            cbType.InputAttributes["class"] = "form-check-input";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }           
           

            if (!IsPostBack)
            {
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở Purchase Requisition List");
                
            }
            LoadPRListToControl();
            gridPR.DataBind();
            ShowOrHideColumns();
        }

        private void LoadPRListToControl()
        {
            try
            {
                string userId = Session["userid"].ToString();

                bool fullview = SecurePage.IsUserInAnyRole(
                    userId,
                    new[]
                    {
                        "System Owner",
                        "PURCHASE Staff Cost Control",
                        "PURCHASE Staff Office",
                        "PURCHASE Staff Factory",
                        "PR View All Request"
                    });

                string sql = @"
                SELECT
                    [Name]                                   AS RequisitionNo,
                    --[Requester ID]                           AS Requester,
                    e.[EmployeeName]                         AS RequesterName,
                    [Purch Req_ Date]                        AS PurchReqDate,
                    [Purch Req_ Purpose]                     AS Purpose,
                    [Purch Req_ Due Date]                    AS DueDate,
                    --[Department]                             AS Department,

                    [Purch Req_ Status]                      AS StatusCode,
                    CASE [Purch Req_ Status]
                        WHEN 0 THEN N'Open'
                        WHEN 1 THEN N'Released'
                        WHEN 2 THEN N'Pending'
                        WHEN 3 THEN N'Completed'
                        WHEN 4 THEN N'Canceled'
                        ELSE N'Unknown'
                    END                                      AS StatusText,

                    [Purch Req_ Type]                        AS PurchReqTypeCode,
                    CASE [Purch Req_ Type]
                        WHEN 0 THEN N'Production Item (Export)'
                        WHEN 1 THEN N'Production Item (Domestic)'
                        WHEN 2 THEN N'Non-Production Item (Maintenance)'
                        WHEN 3 THEN N'Non-Production Item (Tools)'
                        
                        ELSE N'Unknown'
                    END                                      AS PurchReqTypeText
                FROM [dbo].[LIVE_ALLIANCE_90$Requisition Wksh_ Name] whs
                LEFT JOIN DEV_MRP_ALL.dbo.Employee e
                    ON whs.[Requester ID] = e.EmployeeID COLLATE SQL_Latin1_General_CP1_CI_AS
                WHERE [Worksheet Template Name] = 'REQ.'
                ";

                //Row-level filter for non-fullview users
                if (!fullview)
                {
                    sql += " AND [Requester ID] = @RequesterID ";
                }

                sql += " ORDER BY [Name] DESC;";

                DataTable dt;

                if (fullview)
                {
                    // No parameter needed
                    dt = SQRLibrary.ReturnDatatablefromSQL(sql);
                }
                else
                {
                    dt = SQRLibrary.ReturnDatatablefromSQL(
                        sql,
                        new List<string> { "@RequesterID" },
                        new List<object> { userId }
                    );
                }

                gridPR.DataSource = dt;
                gridPR.DataBind();

                SetColumnFormatsAndFilters();
            }
            catch
            {
                // keep silent
            }
        }


        private void SetColumnFormatsAndFilters()
        {
            // Defensive: column might not exist if SQL changes
            if (gridPR.DataColumns["PurchReqDate"] is GridViewDataColumn cDate)
            {
                cDate.PropertiesEdit.DisplayFormatString = "yyyy-MM-dd";
                cDate.Caption = "Req Date";
            }

            if (gridPR.DataColumns["DueDate"] is GridViewDataColumn cDue)
            {
                cDue.PropertiesEdit.DisplayFormatString = "yyyy-MM-dd";
                cDue.Caption = "Due Date";
            }

            if (gridPR.DataColumns["RequisitionNo"] is GridViewDataColumn cNo)
                cNo.Caption = "Requisition No";

            if (gridPR.DataColumns["PurchReqTypeText"] is GridViewDataColumn cTypeText)
                cTypeText.Caption = "Req Type";

            if (gridPR.DataColumns["StatusText"] is GridViewDataColumn cStatusText)
                cStatusText.Caption = "Status";

            // Apply header filter + nowrap to all data columns (same pattern as your template)
            foreach (GridViewDataColumn col in gridPR.DataColumns)
            {
                col.CellStyle.Wrap = DevExpress.Utils.DefaultBoolean.False;
                col.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
            }

            // Hide technical code columns by default (you can show later if needed)
            if (gridPR.DataColumns["StatusCode"] != null) gridPR.DataColumns["StatusCode"].Visible = false;
            if (gridPR.DataColumns["PurchReqTypeCode"] != null) gridPR.DataColumns["PurchReqTypeCode"].Visible = false;
        }

        private void ShowOrHideColumns()
        {
            try
            {
                // Rebind before toggling (same habit as template)
                gridPR.DataBind();

                if (gridPR.DataColumns["Purpose"] != null)
                    gridPR.DataColumns["Purpose"].Visible = cbPurpose.Checked;

                if (gridPR.DataColumns["Department"] != null)
                    gridPR.DataColumns["Department"].Visible = cbDepartment.Checked;

                if (gridPR.DataColumns["Requester"] != null)
                    gridPR.DataColumns["Requester"].Visible = cbRequester.Checked;

                if (gridPR.DataColumns["PurchReqTypeText"] != null)
                    gridPR.DataColumns["PurchReqTypeText"].Visible = cbType.Checked;
            }
            catch { }
        }

        protected void cbPurpose_CheckedChanged(object sender, EventArgs e) => ShowOrHideColumns();
        protected void cbDepartment_CheckedChanged(object sender, EventArgs e) => ShowOrHideColumns();
        protected void cbRequester_CheckedChanged(object sender, EventArgs e) => ShowOrHideColumns();
        protected void cbType_CheckedChanged(object sender, EventArgs e) => ShowOrHideColumns();

        protected void gridPR_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            // 1) Make RequisitionNo a hyperlink (open PR Card in new tab)
            if (e.DataColumn.FieldName == "RequisitionNo")
            {
                string val = e.CellValue as string ?? "";
                e.Cell.Controls.Clear();

                var link = new ASPxHyperLink
                {
                    Text = val,
                    // Adjust target page name to your real PR card page
                    NavigateUrl = $"PurchaseRequisition?OrderNo={Server.UrlEncode(val)}",
                    Target = "_blank"
                };
                e.Cell.Controls.Add(link);
                return;
            }

            // 2) Render StatusText as a Bootstrap badge for quick scanning
            if (e.DataColumn.FieldName == "StatusText")
            {
                string status = e.CellValue as string ?? "";
                string cls = "badge bg-secondary";

                // Map to Bootstrap-like colors
                switch (status)
                {
                    case "Open": cls = "badge bg-primary"; break;
                    case "Released": cls = "badge bg-success"; break;
                    case "Pending": cls = "badge bg-warning text-dark"; break;
                    case "Completed": cls = "badge bg-info text-dark"; break;
                    case "Canceled": cls = "badge bg-danger"; break;
                }

                e.Cell.Controls.Clear();
                e.Cell.Controls.Add(new Literal
                {
                    Text = $"<span class='{cls}'>{HttpUtility.HtmlEncode(status)}</span>"
                });
                return;
            }
        }

        public static string GetNextRequisitionNo(string region)
        {
            if (string.IsNullOrWhiteSpace(region))
                throw new ArgumentException("Region is required.", nameof(region));


            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                "EXEC dbo.ALL_PR_GetNextRequisitionNo @Region",
                new List<string>() { "@Region" },
                new List<object>() { region }
            );

            if (dt == null || dt.Rows.Count == 0)
                return null;

            return Convert.ToString(dt.Rows[0]["NextName"]);
        }

        protected void btnCreatePRHidden_Click(object sender, EventArgs e)
        {
            try
            {
                string userId = Session["userid"]?.ToString();
                if (string.IsNullOrWhiteSpace(userId))
                {
                    ShowCreatePRError("Session expired. Please login again.");
                    return;
                }

                // 1) Get region
                string region = "F"; //F: factory, S: Site

                // 2) Get next PR No
                string prNo = GetNextRequisitionNo(region);
                if (string.IsNullOrWhiteSpace(prNo) || prNo.Trim().Length > 10)
                {
                    int len = string.IsNullOrWhiteSpace(prNo) ? 0 : prNo.Trim().Length;
                    ShowCreatePRError(
                        $"Length of PR No must not empty and <= 10 characters. Current is {len}");
                    return;
                }

                // 3) Execute SQL Procedure
                string sql = @"
                    EXEC dbo.ALL_PR_RequisitionWkshHeader_Insert
                        @WorksheetTemplateName = 'REQ.',
                        @Name                  = @Name,
                        @RequesterID           = @RequesterID;
                ";

                SQRLibrary.ExecuteSQL(
                    sql,
                    new List<string>() { "@Name", "@RequesterID" },
                    new List<object>() { prNo, userId }
                );

                // 4) Reload grid
                LoadPRListToControl();
                gridPR.DataBind();

                // 5) Show SweetAlert success + link
                ShowCreatePRSuccess(prNo);
            }
            catch (Exception ex)
            {
                ShowCreatePRError(ex.Message);
            }
        }

        private void ShowCreatePRSuccess(string prNo)
        {
            string script = $"showCreatePRSuccess('{prNo.Replace("'", "\\'")}');";
            ScriptManager.RegisterStartupScript(
                this, GetType(), "PR_CREATE_OK", script, true);
        }

        private void ShowCreatePRError(string message)
        {
            string msg = message?.Replace("'", "\\'") ?? "";
            string script = $"showCreatePRError('{msg}');";
            ScriptManager.RegisterStartupScript(
                this, GetType(), "PR_CREATE_ERR", script, true);
        }



        


    }
}
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
using System.IO;
using System.Text.RegularExpressions;
using System.IO.Compression;
using static WebApp.Models.Enum.ApprovalEnum;
using WebApp.functions.approval;
using System.Windows.Media;
using DevExpress.Web.Data;
using System.Globalization;

namespace WebApp.purchase
{
    public partial class PurchaseRequisition : Page
    {
        private readonly List<string> link_columns = new List<string>() { "PurchaseOrderNo", "PRLineStatus" };
        private bool UpdateDIMENSION = false;
        protected void Page_PreInit(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            cbPRStatus.InputAttributes["class"] = "form-check-input ";
            cbPOInfo.InputAttributes["class"] = "form-check-input";
            ////cbProjectAmount.InputAttributes["class"] = "form-check-input";
            //cbRemark.InputAttributes["class"] = "form-check-input";
            
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }

            if (!IsPostBack)
            {
                string docNo = Request.QueryString["OrderNo"]?.ToString() ?? "";
                CheckAndLoadInfo(docNo.Trim());
                hfDocNo.Value = docNo;

                //set parameter for comment control
                commentSection.DocumentID = docNo;
            }
            else
            {
                //DataTable dt = ViewState["POLines"] == null ? new DataTable() : (DataTable)ViewState["POLines"];
                //gvLines.DataSource = dt;
                //gvLines.DataBind();
            }
            InitApprovalControl();
            gvLines.DataBind();
            BindItemGrid();
            BindGLGrid();
        }

        private void InitApprovalControl()
        {
            ApprovalDocumentType approvalDocumentType = new ApprovalDocumentType();
            string CurrentUser = Session["userid"].ToString();
            bool BigAmount = ViewState["BigAmount"] == null ? false : (bool)ViewState["BigAmount"]; ;

            switch (cboPurchReqType.Value?.ToString() ?? "")
            {
                case "0":
                    approvalDocumentType = ApprovalDocumentType.Factory_PR_Export_Production_Item;
                    break;
                case "1":
                    approvalDocumentType = ApprovalDocumentType.Factory_PR_Domestic_Production_Item;
                    break;
                case "2":
                    approvalDocumentType = ApprovalDocumentType.Factory_PR_Non_Production_Item_Maintenance;
                    break;
                case "3":
                    approvalDocumentType = ApprovalDocumentType.Factory_PR_Non_Production_Item_Tools;
                    break;
            }


            ApprovalService.SetInfoToApprovalControl(
            control: ApprovalFlow1,
            approvalDocumentType,
            Request["OrderNo"]?.ToString() ?? "",
            $"{approvalDocumentType.ToString()}: {Request["no"]?.ToString() ?? ""}",
            "",
            ViewState["DocDes"]?.ToString() ?? ""
            );
        }

        private void CheckAndLoadInfo(string docNo)
        {
            try
            {
                //check if user is in view all PR group, others will see their PR
                bool fullview = SecurePage.IsUserInAnyRole(Session["userid"].ToString(),
                    new[] {
                        "System Owner",
                        "PURCHASE Staff Cost Control",
                        "PURCHASE Staff Office",
                        "PURCHASE Staff Factory",
                        "PR View All Request"
                     });
                ViewState["fullview"] = fullview;
                
                
                LoadHeader(docNo, (bool)ViewState["fullview"]);
                BindGridLines(docNo, (bool)ViewState["fullview"]);
                InitDocumentFolder();

                cb_CheckedChanged(null, null);
            }
            catch { }

        }

        private void BindGridLines(string docNo, bool fullview = false)
        {
            string batchName = docNo;

            DataTable dt = LoadLines(batchName, fullview);
            gvLines.DataSource = dt;
            gvLines.DataBind();
        }

        private void LoadHeader(string docNo, bool fullview = false)
        {
            string sqlHeader = $@"
            SELECT
                [Worksheet Template Name]  AS WorksheetTemplateName,
                [Name]                     AS DocumentNo,
                [Description]              AS Description,
                [Requester ID]             AS RequesterID,
                e.[EmployeeName]           AS RequesterName,
                [Purch Req_ Date]          AS PurchReqDate,
                [Purch Req_ Purpose]       AS PurchReqPurpose,
                [Purch Req_ Due Date]      AS PurchReqDueDate,
                [Purch Req_ Type]          AS PurchReqType,
                [Purch Req_ Status]        AS PurchReqStatus,
                whs.[Department]           AS Department,
                [Last Date Modified]       AS LastDateModified,
                [Approver 1]               AS Approver1,
                [Approver 2]               AS Approver2,
                [Multi Approver]           AS MultiApprover,
                [Next Approver]            AS NextApprover,
                [ApprovalDate1]            AS ApprovalDate1,
                [ApprovalDate2]            AS ApprovalDate2,
                ProjectCode                AS ProjectCode,
                CostElement                AS CostElement
            FROM [dbo].[LIVE_ALLIANCE_90$Requisition Wksh_ Name] whs
            LEFT JOIN MRP_ALL.dbo.Employee e
                ON whs.[Requester ID] = e.EmployeeID COLLATE SQL_Latin1_General_CP1_CI_AS
            WHERE [Worksheet Template Name] = 'REQ.'            
              AND [Name] = @Name";

            if (!fullview) sqlHeader += $" AND [Requester ID] = '{Session["userid"]?.ToString() ?? ""}'";
            DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(
                sqlHeader,
                new List<string> { "@Name" },
                new List<object> { docNo }
            );



            if (dtHeader.Rows.Count == 0)
            {
                lblTitle.InnerHtml = docNo;
                lblHeaderInfo.Text = "Document not found in Requisition Wksh_ Name or out of your range.";
                ClearHeaderControls_PR();
                return;
            }
            DataRow row = dtHeader.Rows[0];

            int status = SafeToInt(row["PurchReqStatus"]);
            string statusText = GetPurchReqStatusCaption(status);
            string statusColor = GetPurchReqStatusColor(status);

            lblTitle.InnerHtml = string.Format(
                "{0} &middot; {1} &middot; <span style='color:{2}; font-weight:600;'>{3}</span>",
                HtmlEncode(row["DocumentNo"]?.ToString()),
                HtmlEncode(row["RequesterID"]?.ToString()),
                statusColor,
                HtmlEncode(statusText)
            );

            ViewState["PRStatus"] = status;
            ViewState["PRCreatedUser"] = row["RequesterID"]?.ToString();

            // ===== LEFT =====
            txtDocumentNo.Text = row["DocumentNo"]?.ToString();
            txtRequesterID.Text = $"{row["RequesterID"]?.ToString()} - {row["RequesterName"]?.ToString()}";
            SetDateEdit(dePurchReqDate, row["PurchReqDate"]);
            txtPurpose.Text = row["PurchReqPurpose"]?.ToString();
            SetDateEdit(deDueDate, row["PurchReqDueDate"]);
            cboHeaderProjectCode.Value = row["ProjectCode"]?.ToString();
            cboHeaderCostElement.Value = row["CostElement"]?.ToString();

            // ===== RIGHT =====
            BindPurchReqTypeComboIfNeeded();
            BindPurchReqStatusComboIfNeeded();

            cboPurchReqType.Value = SafeToInt(row["PurchReqType"]);
            cboPurchReqStatus.Value = status;

            txtDepartment.Text = row["Department"]?.ToString();
            SetDateEdit(deLastModified, row["LastDateModified"]);
        }

        private int SafeToInt(object v)
        {
            if (v == null || v == DBNull.Value) return 0;
            int x;
            return int.TryParse(v.ToString(), out x) ? x : 0;
        }

        private string GetPurchReqStatusCaption(int status)
        {
            switch (status)
            {
                case 0: return "Open";
                case 1: return "Released";
                case 2: return "Pending Approval";
                case 3: return "Completed";
                case 4: return "Canceled";
                default: return status.ToString();
            }
        }

        private string GetPurchReqStatusColor(int status)
        {
            switch (status)
            {
                case 0: return "#6c757d"; // gray
                case 1: return "#198754"; // green
                case 2: return "#fd7e14"; // orange
                case 3: return "#0d6efd"; // blue
                case 4: return "#dc3545"; // red
                default: return "#6c757d";
            }
        }

        private void ClearHeaderControls_PR()
        {
            txtDocumentNo.Text = "";
            txtRequesterID.Text = "";
            dePurchReqDate.Value = null;
            txtPurpose.Text = "";
            deDueDate.Value = null;

            cboPurchReqType.Value = null;
            cboPurchReqStatus.Value = null;

            txtDepartment.Text = "";
            deLastModified.Value = null;
        }

        private void BindPurchReqTypeComboIfNeeded()
        {
            if (cboPurchReqType.Items.Count > 0) return;

            cboPurchReqType.Items.Add("Production Item (Export)", 0);
            cboPurchReqType.Items.Add("Production Item (Domestic)", 1);
            cboPurchReqType.Items.Add("Non-Production Item (Maintenance)", 2);
            cboPurchReqType.Items.Add("Non-Production Item (Tools)", 3);
            
        }


        private void BindPurchReqStatusComboIfNeeded()
        {
            if (cboPurchReqStatus.Items.Count > 0) return;

            cboPurchReqStatus.ValueField = "ID";
            cboPurchReqStatus.TextField = "Text";
            cboPurchReqStatus.Items.Add("Open", 0);
            cboPurchReqStatus.Items.Add("Released", 1);
            cboPurchReqStatus.Items.Add("Pending Approval", 2);
            cboPurchReqStatus.Items.Add("Completed", 3);
            cboPurchReqStatus.Items.Add("Canceled", 4);
        }

       
        private void SetDateEdit(DevExpress.Web.ASPxDateEdit control, object value)
        {
            if (value == null || value == DBNull.Value)
                control.Value = null;
            else
                control.Value = Convert.ToDateTime(value);
        }

        private string GetStatusCaption(object statusValue)
        {
            if (statusValue == null || statusValue == DBNull.Value)
                return string.Empty;

            int statusInt;
            if (!int.TryParse(statusValue.ToString(), out statusInt))
                return statusValue.ToString();

            // NAV Purchase Status: 0=Open,1=Released,2=Pending Approval,3=Pending Prepayment
            switch (statusInt)
            {
                case 0: return "Open";
                case 1: return "Released";
                case 2: return "Pending Approval";
                case 3: return "Pending Prepayment";
                default: return statusInt.ToString();
            }
        }

        private string GetStatusColor(int status)
        {
            switch (status)
            {
                case 0: // Open
                    return "#6c757d";   // gray
                case 1: // Released
                    return "#198754";   // green (Bootstrap success)
                case 2: // Pending Approval
                    return "#fd7e14";   // orange
                case 3: // Pending Prepayment
                    return "#0d6efd";   // blue
                default:
                    return "#6c757d";
            }
        }



        // ========================= LINES =========================

        private DataTable LoadLines(string batchName, bool fullview = false)
        {
            string sql = @"
             ;WITH POAgg AS
            (
                SELECT
                    pl.[Purch_ Req_ No]      AS PurchReqNo,
                    pl.[Purch_ Req_ Line No] AS PurchReqLineNo,

                    -- Concatenate distinct PO numbers into one cell
                    PurchaseOrderNo =
                        STUFF((
                            SELECT DISTINCT
                                ', ' + pl2.[Document No_]
                            FROM dbo.[LIVE_ALLIANCE_90$Purchase Line] pl2
                            WHERE pl2.[Purch_ Req_ No]      = pl.[Purch_ Req_ No]
                              AND pl2.[Purch_ Req_ Line No] = pl.[Purch_ Req_ Line No]
                              AND pl2.[Document Type]      = pl.[Document Type]
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''),

                    POQuantity     = SUM(ISNULL(pl.[Quantity], 0)),
                    PORemainQty    = SUM(ISNULL(pl.[Outstanding Quantity], 0)),
                    POReceiptQty   = SUM(ISNULL(pl.[Quantity Received], 0)),
                    POPromisedDate = MIN(TRY_CONVERT(date, pl.[Promised Receipt Date]))
                FROM dbo.[LIVE_ALLIANCE_90$Purchase Line] pl
                WHERE ISNULL(pl.[Purch_ Req_ No], '') <> ''
                  AND ISNULL(pl.[Purch_ Req_ Line No], 0) <> 0
                  AND pl.[Purch_ Req_ No] = @BatchName
                GROUP BY
                    pl.[Purch_ Req_ No],
                    pl.[Purch_ Req_ Line No],
                    pl.[Document Type]
            )

            SELECT
                -- ===== PR LINE =====
                [Line No_]                    AS [LineNo],
                [Type]                        AS [Type],
                [No_]                         AS [No],
                [Description]                 AS [Description],
                [Quantity]                    AS Quantity,
                [Unit of Measure Code]        AS UOM,
                [Purch Req_ Purpose]          AS PurchReqPurpose,
                [Shortcut Dimension 1 Code]   AS ProjectCode ,
                [Shortcut Dimension 2 Code]   AS CostElement,
                
                CASE ISNULL([Purch Req_ Status], 0)
                    WHEN 0 THEN N'Open'
                    WHEN 1 THEN N'Released'
                    WHEN 2 THEN N'Pending Approval'
                    WHEN 3 THEN N'Completed'
                    WHEN 4 THEN N'Canceled'
                    ELSE CONVERT(NVARCHAR(30), [Purch Req_ Status])
                END                            AS PRLineStatus,
                
                PurchaseOrderNo = ISNULL(p.PurchaseOrderNo, N''),
                [PO Quantity]   = ISNULL(p.POQuantity, 0),
                [PO Remain Qty] = ISNULL(p.PORemainQty, 0),
                [PO Receip Qty] = ISNULL(p.POReceiptQty, 0),
                [PO Promised Date] = p.POPromisedDate
            FROM [dbo].[LIVE_ALLIANCE_90$Requisition Line] l
            LEFT JOIN POAgg p
               ON p.PurchReqNo      = l.[Journal Batch Name]
               AND p.PurchReqLineNo  = l.[Line No_]
            WHERE [Worksheet Template Name] = 'REQ.'
              AND [Journal Batch Name] = @BatchName
            ORDER BY [Line No_];";

            if (!fullview)
            {
                sql = $@"
                SELECT
                    [Line No_]                    AS [LineNo],
                    [Type]                        AS [Type],
                    [No_]                         AS [No],
                    line.[Description]            AS [Description],
                    [Quantity]                    AS Quantity,
                    [Unit of Measure Code]        AS UOM,
                    line.[Purch Req_ Purpose]     AS PurchReqPurpose,
                    [Shortcut Dimension 1 Code]   AS CostElement,
                    [Shortcut Dimension 2 Code]   AS ProjectCode
                FROM [dbo].[LIVE_ALLIANCE_90$Requisition Line] line
                INNER JOIN [dbo].[LIVE_ALLIANCE_90$Requisition Wksh_ Name] h 
                    ON h.Name = line.[Journal Batch Name] AND h.[Requester ID] = '{Session["userid"]?.ToString() ?? ""}'
                WHERE line.[Worksheet Template Name] = 'REQ.'
                  AND [Journal Batch Name] = @BatchName
                ORDER BY [Line No_];";
            }

            return SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@BatchName" },
                new List<object> { batchName }
            );
        }



        // ========================= HELPER =========================
        private string GetStatusTooltip(int status)
        {
            switch (status)
            {
                case 0:
                    return "Open: Document is editable and not yet released.";
                case 1:
                    return "Released: Document is released for posting. Editing is restricted.";
                case 2:
                    return "Pending Approval: Document is waiting for approval before it can be released.";
                case 3:
                    return "Pending Prepayment: Document requires prepayment handling before posting.";
                default:
                    return "Unknown status.";
            }
        }
        private string HtmlEncode(string s) =>
            System.Web.HttpUtility.HtmlEncode(s ?? string.Empty);

        private string HtmlAttributeEncode(string s) =>
            System.Web.HttpUtility.HtmlAttributeEncode(s ?? string.Empty);

        protected void gvLines_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e)
        {
            if (e.Column.FieldName == "Type" && e.Value != null)
            {
                switch (Convert.ToInt32(e.Value))
                {
                    case 1: e.DisplayText = "G/L"; break;
                    case 2: e.DisplayText = "Item"; break;
                    case 3: e.DisplayText = "Fixed Asset"; break;
                    case 4: e.DisplayText = "Charge (Item)"; break;
                }
            }
        }

        protected void ApprovalFlow1_StatusChanged(object sender, EventArgs e)
        {
            string docNo = Request.QueryString["OrderNo"];
            LoadHeader(docNo, (bool)ViewState["fullview"]);
        }
        public static string GetPurchaseOrderFolder(string poNumber)
        {
            // Example: "ALC-FA.PO25-0009"

            if (string.IsNullOrWhiteSpace(poNumber))
                return string.Empty;

            // --- Extract Year from PO number ---
            // PO25 → means 2025
            // Extract "25" from "PO25"
            string yearPart = poNumber.Substring(poNumber.IndexOf("PO") + 2, 2);
            string fullYear = "20" + yearPart;  // → 2025

            // --- Extract PO prefix before the dash ---
            // Example: ALC-FA.PO25-0009 → ALC-FA.PO25
            string prefix = poNumber.Split('-')[0];

            // Final folder structure:
            // 2025\ALC-FA.PO25\ALC-FA.PO25-0009
            string folderPath = $"{fullYear}\\{prefix}\\{poNumber}";

            return folderPath;
        }

        //protected void ASPxFileManager1_CustomCallback(object sender, CallbackEventArgsBase e)
        //{
        //    // e.Parameter = "zip|<encoded fullName>"
        //    var p = (e.Parameter ?? "").Split(new[] { '|' }, 2);
        //    if (p.Length != 2 || p[0] != "zip")
        //        return;

        //    string fullName = Uri.UnescapeDataString(p[1]); // provider-relative path
        //    //fullName = Regex.Replace(fullName.Trim(), @"[^\w\.-]", "_");  

        //    string OrderNo = Request["OrderNo"]?.ToString() ?? "";
        //    if (string.IsNullOrWhiteSpace(OrderNo)) return;

        //    var no = Regex.Replace(OrderNo.Trim(), @"[^\w\.-]", "_");
        //    const string basePhysical = @"D:\ALLIANCE_NEW\ERP\DOCUMENTS\PURCHASEORDERS";

        //    string POFolder = GetPurchaseOrderFolder(no);

        //    var folderPhysical = Path.Combine(basePhysical, POFolder, fullName);


        //    if (!Directory.Exists(folderPhysical))
        //        throw new Exception("Folder not found on server.");

        //    string token = Guid.NewGuid().ToString("N");
        //    string zipPath = Path.Combine(Path.GetTempPath(), "fm_" + token + ".zip");

        //    ZipFile.CreateFromDirectory(folderPhysical, zipPath, CompressionLevel.Fastest, includeBaseDirectory: true);

        //    // store for handler
        //    Session["FM_ZIP_" + token] = zipPath;

        //    // pass token back to client in a custom property
        //    ASPxFileManager1.JSProperties["cpZipToken"] = token;
        //}

        protected void gvLines_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {

            if (!link_columns.Contains(e.DataColumn.FieldName)) return;

            string val = e.CellValue as string ?? "";
            switch (e.DataColumn.FieldName)
            {
                case "PurchaseOrderNo":
                    e.Cell.Controls.Clear();

                    if (val.Length == 16)
                    {
                        var link = new DevExpress.Web.ASPxHyperLink
                        {
                            Text = val,
                            NavigateUrl = $"/Purchasing/PurchaseHeader?OrderNo={Server.UrlEncode(val)}",
                            Target = "_blank"
                        };
                        e.Cell.Controls.Add(link);
                    }
                    else
                    {
                        e.Cell.Controls.Add(new Literal { Text = Server.HtmlEncode(val) });
                    }
                    break;

                case "PRLineStatus":
                    string status = e.CellValue as string ?? "";
                    string cls = "badge bg-secondary";

                    // Map to Bootstrap-like colors
                    switch (status)
                    {
                        case "Open": cls = "badge bg-primary"; break;
                        case "Released": cls = "badge bg-success"; break;
                        case "Pending Approval": cls = "badge bg-warning text-dark"; break;
                        case "Completed": cls = "badge bg-info text-dark"; break;
                        case "Canceled": cls = "badge bg-danger"; break;
                    }

                    e.Cell.Controls.Clear();
                    e.Cell.Controls.Add(new Literal
                    {
                        Text = $"<span class='{cls}'>{HttpUtility.HtmlEncode(status)}</span>"
                    });
                    break;
            }


        }

        protected void cb_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                gvLines.DataBind();

                gvLines.DataColumns["PRLineStatus"].Visible = cbPRStatus.Checked;

                gvLines.DataColumns["PurchaseOrderNo"].Visible = cbPOInfo.Checked;
                gvLines.DataColumns["PO Quantity"].Visible = cbPOInfo.Checked;
                gvLines.DataColumns["PO Receip Qty"].Visible = cbPOInfo.Checked;
                gvLines.DataColumns["PO Remain Qty"].Visible = cbPOInfo.Checked;

            }
            catch { }
        }

        private void ShowSwal(string title, string text, string icon)
        {
            string script = $@"
            Swal.fire({{
                title: {ToJs(title)},
                text: {ToJs(text)},
                type: '{icon}',
                confirmButtonText: 'OK'
            }});";

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                Guid.NewGuid().ToString(),
                script,
                true
            );
        }

        private string ToJs(string s)
        {
            return s == null
                ? "''"
                : "'" + s.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\r", "").Replace("\n", "") + "'";
        }


        protected void btnSaveHeader_Click(object sender, EventArgs e)
        {
            try
            {
                string docNo = txtDocumentNo.Text?.Trim();
                if (string.IsNullOrEmpty(docNo))
                { ShowSwal("Save failed", "Document No is empty.", "error"); return; }


                string templateName = "REQ.";
                string purpose = (txtPurpose.Text ?? "").Trim();
                string headerProjectCode = Convert.ToString(cboHeaderProjectCode.Value ?? "").Trim(); 
                string headerCostElement = Convert.ToString(cboHeaderCostElement.Value ?? "").Trim();

                DateTime? dueDate = null;
                if (deDueDate.Value != null) dueDate = Convert.ToDateTime(deDueDate.Value);

                int? reqType = null;
                if (cboPurchReqType.Value != null) reqType = Convert.ToInt32(cboPurchReqType.Value);

                // prevent saving if status != Open
                int status = Convert.ToInt32(cboPurchReqStatus.Value ?? 0);
                if (!(status == 0 || UpdateDIMENSION)) { ShowSwal("Save failed", "Only Open documents can be edited.", "error"); return; }

                string sql = @"
                EXEC dbo.ALL_PR_RequisitionHeader_UpdateFields
                    @WorksheetTemplateName = @WorksheetTemplateName,
                    @Name = @Name,
                    @PurchReqPurpose = @PurchReqPurpose,
                    @PurchReqDueDate = @PurchReqDueDate,
                    @PurchReqType = @PurchReqType,
                    @ProjectCode = @ProjectCode,
                    @CostElement = @CostElement,
                    @UserID = @UserID;";

                // Use DBNull.Value for nulls
                object dueDateObj = (object)dueDate ?? DBNull.Value;
                object reqTypeObj = (object)reqType ?? DBNull.Value;

                SQRLibrary.ExecuteSQL(
                    sql,
                    new List<string> { "@WorksheetTemplateName", "@Name", "@PurchReqPurpose", "@PurchReqDueDate", "@PurchReqType", "@ProjectCode", "@CostElement", "@UserID" },
                    new List<object> { templateName, docNo, purpose, dueDateObj, reqTypeObj, headerProjectCode, headerCostElement, CurrentUserID() }
                );

                // Reload header + lines to reflect changes
                LoadHeader(docNo, (bool)ViewState["fullview"]);
                BindGridLines(docNo, (bool)ViewState["fullview"]);

                //ShowSwal(
                //    "Saved successfully",
                //    "Purchase Requisition header and lines were updated.",
                //    "success"
                //);
            }
            catch (Exception ex)
            {
                ShowSwal("Save failed", ex.Message, "error");
            }
        }

        private string CurrentUserID()
        {
            return (Session["userid"] ?? "").ToString();
        }

        protected void gvLines_DataBinding(object sender, EventArgs e)
        {
            string docNo = (hfDocNo.Value ?? "").Trim();
            if (string.IsNullOrEmpty(docNo))
            {
                gvLines.DataSource = null;
                return;
            }

            string batchName = docNo;

            gvLines.DataSource = LoadLines(batchName, (bool)ViewState["fullview"]);
        }

        protected void cboItemNo_ItemsRequestedByFilterCondition(object source, DevExpress.Web.ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            var cbo = (DevExpress.Web.ASPxComboBox)source;

            string sql = @"
            SELECT TOP 50
                [No_] AS No_,
                [Description] AS [Description],
                [Base Unit of Measure] AS BaseUnit
            FROM [dbo].[LIVE_ALLIANCE_90$Item]
            WHERE ([No_] LIKE @Filter OR [Description] LIKE @Filter)
            AND [Item Category Code]='RM'
            ORDER BY [No_];";

            string filter = "%" + (e.Filter ?? "") + "%";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Filter" },
                new List<object> { filter }
            );

            cbo.DataSource = dt;
            cbo.ValueField = "No_";
            cbo.TextField = "No_";
            cbo.DataBind();
        }

        protected void cboItemNo_ItemRequestedByValue(object source, DevExpress.Web.ListEditItemRequestedByValueEventArgs e)
        {
            if (e.Value == null) return;
            var cbo = (DevExpress.Web.ASPxComboBox)source;

            string sql = @"
        SELECT TOP 1
            [No_] AS No_,
            [Description] AS [Description],
            [Base Unit of Measure] AS BaseUnit
        FROM [dbo].[LIVE_ALLIANCE_90$Item]
        AND [Item Category Code]='RM'
        WHERE [No_] = @No;";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@No" },
                new List<object> { e.Value.ToString() }
            );

            cbo.DataSource = dt;
            cbo.ValueField = "No_";
            cbo.TextField = "No_";
            cbo.DataBind();
        }

        protected void cboGLNo_ItemsRequestedByFilterCondition(object source, DevExpress.Web.ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            var cbo = (DevExpress.Web.ASPxComboBox)source;

            string sql = @"
        SELECT TOP 50
            [No_] AS No_,
            [Name] AS [Name]
        FROM [dbo].[LIVE_ALLIANCE_90$G_L Account]
        WHERE [Account Type] = 0
          AND ([No_] LIKE @Filter OR [Name] LIKE @Filter)
        ORDER BY [No_];";

            string filter = "%" + (e.Filter ?? "") + "%";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Filter" },
                new List<object> { filter }
            );

            cbo.DataSource = dt;
            cbo.ValueField = "No_";
            cbo.TextField = "No_";
            cbo.DataBind();
        }

        protected void cboGLNo_ItemRequestedByValue(object source, DevExpress.Web.ListEditItemRequestedByValueEventArgs e)
        {
            if (e.Value == null) return;
            var cbo = (DevExpress.Web.ASPxComboBox)source;

            string sql = @"
        SELECT TOP 1
            [No_] AS No_,
            [Name] AS [Name]
        FROM [dbo].[LIVE_ALLIANCE_90$G_L Account]
        WHERE [Account Type] = 0
          AND [No_] = @No;";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@No" },
                new List<object> { e.Value.ToString() }
            );

            cbo.DataSource = dt;
            cbo.ValueField = "No_";
            cbo.TextField = "No_";
            cbo.DataBind();
        }

        protected void cboUOM_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            var cbo = (DevExpress.Web.ASPxComboBox)sender;
            cbo.Items.Clear();

            string itemNo = (e.Parameter ?? "").Trim();
            if (string.IsNullOrEmpty(itemNo)) return;

            string sql = @"
        SELECT
            [Code] AS UOM
        FROM [dbo].[LIVE_ALLIANCE_90$Item Unit of Measure]
        WHERE [Item No_] = @ItemNo
        ORDER BY [Code];";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@ItemNo" },
                new List<object> { itemNo }
            );

            cbo.ValueField = "UOM";
            cbo.TextField = "UOM";
            cbo.DataSource = dt;
            cbo.DataBind();
        }

        private int GetNextLineNo(string batchName)
        {
            string sql = @"
            SELECT ISNULL(MAX([Line No_]), 0) + 10000
            FROM [dbo].[LIVE_ALLIANCE_90$Requisition Line]
            WHERE [Worksheet Template Name] = 'REQ.'
              AND [Journal Batch Name] = @BatchName;";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@BatchName" },
                new List<object> { batchName }
            );

            return Convert.ToInt32(dt.Rows[0][0]);
        }

        private (int type, string no, string desc, decimal qty, string uom, string costElement, string projectCode) ReadEditFormValues()
        {
            var cboType = gvLines.FindEditFormTemplateControl("cboType") as DevExpress.Web.ASPxComboBox;
            var cboItemNo = gvLines.FindEditFormTemplateControl("cboItemNo") as DevExpress.Web.ASPxComboBox;
            var cboGLNo = gvLines.FindEditFormTemplateControl("cboGLNo") as DevExpress.Web.ASPxComboBox;
            var txtDesc = gvLines.FindEditFormTemplateControl("txtDesc") as DevExpress.Web.ASPxTextBox;
            var spQty = gvLines.FindEditFormTemplateControl("spQty") as DevExpress.Web.ASPxSpinEdit;
            var cboUOM = gvLines.FindEditFormTemplateControl("cboUOM") as DevExpress.Web.ASPxComboBox;
            var txtCost = gvLines.FindEditFormTemplateControl("txtCostElement") as DevExpress.Web.ASPxTextBox;
            var txtProj = gvLines.FindEditFormTemplateControl("txtProjectCode") as DevExpress.Web.ASPxTextBox;

            int type = Convert.ToInt32(cboType.Value ?? 0);

            string no = "";
            if (type == 0) no = (cboItemNo.Value ?? "").ToString().Trim();
            else no = (cboGLNo.Value ?? "").ToString().Trim();

            string desc = (txtDesc.Text ?? "").Trim();
            decimal qty = Convert.ToDecimal(spQty.Value ?? 0m);
            string uom = type == 0 ? (cboUOM.Value ?? "").ToString().Trim() : ""; // no uom for GL
            string cost = (txtCost.Text ?? "").Trim();
            string proj = (txtProj.Text ?? "").Trim();

            return (type, no, desc, qty, uom, cost, proj);
        }

        private string GetEditText(string controlId)
        {
            var tb = gvLines.FindEditFormTemplateControl(controlId) as DevExpress.Web.ASPxTextBox;
            return tb?.Text?.Trim() ?? "";
        }

        protected void gvLines_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            // prevent saving if status != Open
            int status = Convert.ToInt32(cboPurchReqStatus.Value ?? 0);
            if (status != 0) { throw new Exception("Only Open documents can be inserted new lines."); }

            e.Cancel = true;

            string docNo = (hfDocNo.Value ?? "").Trim();   // Journal Batch Name + PR No
            string template = "REQ.";                      // Worksheet Template Name

            if (string.IsNullOrEmpty(docNo))
            {
                gvLines.CancelEdit();
                return;
            }

            // ===== Read values from e.NewValues by FieldName =====
            int type = SafeToInt(e.NewValues["Type"], 0); // 0 blank, 1 GL, 2 Item
            string no = SafeToString(e.NewValues["No"]);
            string desc = SafeToString(e.NewValues["Description"]);
            string uom = SafeToString(e.NewValues["UOM"]);
            decimal qty = SafeToDecimal(e.NewValues["Quantity"], 0m);

            string linePurpose = SafeToString(e.NewValues["PurchReqPurpose"]);
            string dim1 = SafeToString(e.NewValues["CostElement"]);   // Shortcut Dim 1
            string dim2 = SafeToString(e.NewValues["ProjectCode"]);   // Shortcut Dim 2

            ValidateGLDimensions(type, dim1, dim2);

            // Basic validations 
            if (type == 0)
                throw new Exception("Type is required.");
            if (string.IsNullOrWhiteSpace(no))
                throw new Exception("Item No is required.");

            // NAV-style Line No
            int lineNo = GetNextLineNo(docNo);


            string headerPurpose = (txtPurpose.Text ?? "").Trim();
            object headerDueDate = deDueDate.Value ?? DBNull.Value;
            object headerReqType = cboPurchReqType.Value ?? DBNull.Value;
            int headerStatus = SafeToInt(cboPurchReqStatus.Value, 0);


            //if (type == 1) uom = "";

            string sql = @"
            EXEC dbo.ALL_PR_Line_Insert
                 @WorksheetTemplateName = @WorksheetTemplateName,
                 @JournalBatchName      = @JournalBatchName,
                 @LineNo                = @LineNo,
                 @Type                  = @Type,
                 @No                    = @No,
                 @Description           = @Description,
                 @Quantity              = @Quantity,
                 @UnitOfMeasureCode     = @UnitOfMeasureCode,
                 @PurchReqNo            = @PurchReqNo,
                 @PurchReqPurpose       = @PurchReqPurpose,
                 @PurchReqDueDate       = @PurchReqDueDate,
                 @PurchReqType          = @PurchReqType,
                 @PurchReqStatus        = @PurchReqStatus,
                 @ShortcutDim1Code      = @ShortcutDim1Code,
                 @ShortcutDim2Code      = @ShortcutDim2Code;";

            SQRLibrary.ExecuteSQL(
                sql,
                new List<string>
                {
                    "@WorksheetTemplateName",
                    "@JournalBatchName",
                    "@LineNo",
                    "@Type",
                    "@No",
                    "@Description",
                    "@Quantity",
                    "@UnitOfMeasureCode",
                    "@PurchReqNo",
                    "@PurchReqPurpose",
                    "@PurchReqDueDate",
                    "@PurchReqType",
                    "@PurchReqStatus",
                    "@ShortcutDim1Code",
                    "@ShortcutDim2Code"
                },
                new List<object>
                {
                    template,
                    docNo,
                    lineNo,
                    type,
                    no,
                    desc,
                    qty,
                    uom,
                    docNo,

                    (string.IsNullOrWhiteSpace(linePurpose) ? headerPurpose : linePurpose),
                    headerDueDate,
                    headerReqType,
                    headerStatus,
                    string.IsNullOrWhiteSpace(dim1) ? (object)DBNull.Value : dim1,
                    string.IsNullOrWhiteSpace(dim2) ? (object)DBNull.Value : dim2
                }
            );

            gvLines.CancelEdit();
            BindGridLines(docNo, (bool)ViewState["fullview"]);
        }

        private static string SafeToString(object v)
        {
            return v == null ? "" : Convert.ToString(v)?.Trim() ?? "";
        }

        private static int SafeToInt(object v, int def = 0)
        {
            if (v == null) return def;
            int x;
            return int.TryParse(Convert.ToString(v), out x) ? x : def;
        }

        private static decimal SafeToDecimal(object v, decimal def = 0m)
        {
            if (v == null) return def;
            decimal x;
            return decimal.TryParse(Convert.ToString(v), out x) ? x : def;
        }

        protected void gvLines_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            // prevent saving if status != Open
            int status = Convert.ToInt32(cboPurchReqStatus.Value ?? 0);
            if (status != 0) { throw new Exception("Only Open documents can be edited."); }

            e.Cancel = true;

            string docNo = (hfDocNo.Value ?? "").Trim();   // Journal Batch Name + PR No
            string template = "REQ.";                      // Worksheet Template Name

            if (string.IsNullOrWhiteSpace(docNo))
            {
                gvLines.CancelEdit();
                return;
            }

            // ===== Primary key =====
            int lineNo = SafeToInt(e.Keys["LineNo"], 0);
            if (lineNo <= 0)
                throw new Exception("Invalid Line No.");

            // ===== Read updated values from grid =====
            int type = SafeToInt(e.NewValues["Type"], 0);   // 1=GL, 2=Item
            string no = SafeToString(e.NewValues["No"]);
            string desc = SafeToString(e.NewValues["Description"]);
            string uom = SafeToString(e.NewValues["UOM"]);
            decimal qty = SafeToDecimal(e.NewValues["Quantity"], 0m);

            string linePurpose = SafeToString(e.NewValues["PurchReqPurpose"]);
            string dim2 = SafeToString(e.NewValues["CostElement"]);   // Shortcut Dim 1
            string dim1 = SafeToString(e.NewValues["ProjectCode"]);   // Shortcut Dim 2

            // ===== Basic validations =====
            if (type == 0)
                throw new Exception("Type is required.");
            if (string.IsNullOrWhiteSpace(no))
                throw new Exception("Item / G/L No is required.");

            ValidateGLDimensions(type, dim1, dim2);

            // Business rule: GL → no UOM
            //if (type == 1)
            //    uom = "";

            // ===== Header values (sync rule) =====
            string headerPurpose = (txtPurpose.Text ?? "").Trim();
            object headerDueDate = deDueDate.Value ?? DBNull.Value;
            object headerReqType = cboPurchReqType.Value ?? DBNull.Value;
            int headerStatus = SafeToInt(cboPurchReqStatus.Value, 0);

            // Decide purpose source:
            // 1) line editable → use line value if exists
            // 2) otherwise inherit header
            string finalPurpose =
                string.IsNullOrWhiteSpace(linePurpose) ? headerPurpose : linePurpose;

            // ===== Call UPDATE procedure =====
            string sql = @"
        EXEC dbo.ALL_PR_Line_Update
             @WorksheetTemplateName = @WorksheetTemplateName,
             @JournalBatchName      = @JournalBatchName,
             @LineNo                = @LineNo,
             @Type                  = @Type,
             @No                    = @No,
             @Description           = @Description,
             @Quantity              = @Quantity,
             @UnitOfMeasureCode     = @UnitOfMeasureCode,
             @PurchReqPurpose       = @PurchReqPurpose,
             @PurchReqDueDate       = @PurchReqDueDate,
             @PurchReqType          = @PurchReqType,
             @PurchReqStatus        = @PurchReqStatus,
             @ShortcutDim1Code      = @ShortcutDim1Code,
             @ShortcutDim2Code      = @ShortcutDim2Code;";

            SQRLibrary.ExecuteSQL(
                sql,
                new List<string>
                {
            "@WorksheetTemplateName",
            "@JournalBatchName",
            "@LineNo",
            "@Type",
            "@No",
            "@Description",
            "@Quantity",
            "@UnitOfMeasureCode",
            "@PurchReqPurpose",
            "@PurchReqDueDate",
            "@PurchReqType",
            "@PurchReqStatus",
            "@ShortcutDim1Code",
            "@ShortcutDim2Code"
                },
                new List<object>
                {
            template,
            docNo,
            lineNo,
            type,
            no,
            desc,
            qty,
            uom,
            finalPurpose,
            headerDueDate,
            headerReqType,
            headerStatus,
            string.IsNullOrWhiteSpace(dim1) ? (object)DBNull.Value : dim1,
            string.IsNullOrWhiteSpace(dim2) ? (object)DBNull.Value : dim2
                }
            );

            gvLines.CancelEdit();
            BindGridLines(docNo, (bool)ViewState["fullview"]);
        }

        protected void gvLines_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            e.NewValues["Type"] = 0;        // Item
            e.NewValues["Quantity"] = 1;
        }

        protected void gvLines_HtmlEditFormCreated(object sender, ASPxGridViewEditFormEventArgs e)
        {
            var grid = (ASPxGridView)sender;

            var cboLineType = grid.FindEditFormTemplateControl("cboLineType") as ASPxComboBox;
            var cboItemNo = grid.FindEditFormTemplateControl("cboItemNo") as ASPxComboBox;
            var cboGLNo = grid.FindEditFormTemplateControl("cboGLNo") as ASPxComboBox;

            if (cboLineType == null) return;

            // Determine Type reliably
            int lineType = 2; // default Item
            if (cboLineType.Value != null)
            {
                int.TryParse(cboLineType.Value.ToString(), out lineType);
            }
            else if (grid.IsEditing && grid.EditingRowVisibleIndex >= 0)
            {
                object v = grid.GetRowValues(grid.EditingRowVisibleIndex, "Type");
                if (v != null) int.TryParse(v.ToString(), out lineType);
            }

            bool isItem = (lineType == 2); // 2=Item, 1=G/L

            // Toggle visibility of editors
            if (cboItemNo != null) cboItemNo.Visible = isItem;
            if (cboGLNo != null) cboGLNo.Visible = !isItem;

            // Bind lookups (bind every time to avoid wiped items on callbacks)
            if (cboItemNo != null) BindItemLookup(cboItemNo);
            if (cboGLNo != null) BindGLLookup(cboGLNo);

            // Optional: if GL, clear item selection to avoid wrong save
            if (!isItem && cboItemNo != null) cboItemNo.Value = null;
            if (isItem && cboGLNo != null) cboGLNo.Value = null;
        }

        private void BindItemLookup(ASPxComboBox cbo)
        {
            string sql = @"
        SELECT TOP 200
            [No_] AS No_,
            [Description] AS [Description]
        FROM [dbo].[LIVE_ALLIANCE_90$Item]
        ORDER BY [No_];";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql,
                new List<string>(), new List<object>());

            cbo.ValueField = "No_";
            cbo.TextField = "No_";
            cbo.DataSource = dt;
            cbo.DataBind();
        }

        private void BindGLLookup(ASPxComboBox cbo)
        {
            string sql = @"
        SELECT TOP 200
            [No_] AS No_,
            [Name] AS [Name]
        FROM [dbo].[LIVE_ALLIANCE_90$G_L Account]
        WHERE [Account Type] = 0
        ORDER BY [No_];";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql,
                new List<string>(), new List<object>());

            cbo.ValueField = "No_";
            cbo.TextField = "No_";
            cbo.DataSource = dt;
            cbo.DataBind();
        }
        protected void cboType_SelectedIndexChanged(object sender, EventArgs e)
        {
            // keep edit mode
            int rowIndex = gvLines.EditingRowVisibleIndex;
            gvLines.UpdateEdit(); // optional: if you want to persist temp values
            gvLines.StartEdit(rowIndex);
        }

        protected void gvLines_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            // prevent delete if status != Open
            int status = Convert.ToInt32(cboPurchReqStatus.Value ?? 0);
            if (status != 0) { throw new Exception("Only Open documents can be deleted."); }

            e.Cancel = true;

            try
            {
                string docNo = (hfDocNo.Value ?? "").Trim();
                if (string.IsNullOrEmpty(docNo))
                    throw new Exception("Document No is empty.");

                // only allow delete when Header Status = Open (0)
                int headerStatus = Convert.ToInt32(cboPurchReqStatus.Value ?? 0);
                if (headerStatus != 0)
                    throw new Exception("Cannot delete lines when document status is not Open.");

                string templateName = "REQ.";
                string batchName = docNo;

                int lineNo = Convert.ToInt32(e.Keys["LineNo"]);

                string sql = @"
                DELETE FROM [dbo].[LIVE_ALLIANCE_90$Requisition Line]
                WHERE [Worksheet Template Name] = @TemplateName
                  AND [Journal Batch Name] = @BatchName
                  AND [Line No_] = @LineNo;";

                SQRLibrary.ExecuteSQL(
                    sql,
                    new List<string> { "@TemplateName", "@BatchName", "@LineNo" },
                    new List<object> { templateName, batchName, lineNo }
                );

                gvLines.CancelEdit();
                gvLines.DataBind();

                ShowSwal("Deleted", "Line deleted successfully.", "success");
            }
            catch (Exception ex)
            {
                ShowSwal("Delete failed", ex.Message, "error");
            }
        }


        protected void gvItemLookup_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            BindItemGrid();
        }

        private void BindItemGrid()
        {
            string sql = @"
            SELECT 
                [No_] AS No_,
                [Description] AS [Description],
                [Base Unit of Measure] AS BaseUOM
            FROM [dbo].[LIVE_ALLIANCE_90$Item]
             WHERE [Item Category Code]='RM'
            ORDER BY [No_];";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>(), new List<object>());

            gvItemLookup.DataSource = dt;
            gvItemLookup.DataBind();
        }

        private void BindGLGrid()
        {
            string sql = @"
            SELECT 
                [No_] AS No_,
                [Name] AS [Name]
            FROM [dbo].[LIVE_ALLIANCE_90$G_L Account]
            WHERE [Account Type] = 0
            ORDER BY [No_];";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>(), new List<object>());

            gvGLLookup.DataSource = dt;
            gvGLLookup.DataBind();
        }
        protected void gvGLLookup_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            BindGLGrid();
        }

        protected void cboProjectCode_ItemsRequested(object sender, DevExpress.Web.ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            string sql = @"
            SELECT TOP (@Take)
                [Code], [Name], [Consolidation Code]
            FROM [dbo].[LIVE_ALLIANCE_90$Dimension Value]
            WHERE [Dimension Code] = 'DEPARTMENT'
              AND ([Code] LIKE @Filter OR [Name] LIKE @Filter)
            ORDER BY [Code]";

            var dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Take", "@Filter" },
                new List<object>
                {
            e.EndIndex - e.BeginIndex + 1,
            "%" + e.Filter + "%"
                });

            ((DevExpress.Web.ASPxComboBox)sender).DataSource = dt;
            ((DevExpress.Web.ASPxComboBox)sender).DataBind();
        }

        protected void cboProjectCode_ItemRequested(object sender, DevExpress.Web.ListEditItemRequestedByValueEventArgs e)
        {
            if (e.Value == null) return;

            string sql = @"
            SELECT [Code], [Name], [Consolidation Code]
            FROM [dbo].[LIVE_ALLIANCE_90$Dimension Value]
            WHERE [Dimension Code] = 'DEPARTMENT'
              AND [Code] = @Code";

            var dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Code" },
                new List<object> { e.Value });

            ((DevExpress.Web.ASPxComboBox)sender).DataSource = dt;
            ((DevExpress.Web.ASPxComboBox)sender).DataBind();
        }

        protected void cboCostElement_ItemsRequested(object sender, DevExpress.Web.ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            string sql = @"
            SELECT TOP (@Take)
                [Code], [Name], [Consolidation Code]
            FROM [dbo].[LIVE_ALLIANCE_90$Dimension Value]
            WHERE [Dimension Code] = 'COSTELEMENT'
              AND ([Code] LIKE @Filter OR [Name] LIKE @Filter)
            ORDER BY [Code]";

            var dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Take", "@Filter" },
                new List<object>
                {
            e.EndIndex - e.BeginIndex + 1,
            "%" + e.Filter + "%"
                });

            ((DevExpress.Web.ASPxComboBox)sender).DataSource = dt;
            ((DevExpress.Web.ASPxComboBox)sender).DataBind();
        }

        protected void cboCostElement_ItemRequested(object sender, DevExpress.Web.ListEditItemRequestedByValueEventArgs e)
        {
            if (e.Value == null) return;

            string sql = @"
            SELECT [Code], [Name], [Consolidation Code]
            FROM [dbo].[LIVE_ALLIANCE_90$Dimension Value]
            WHERE [Dimension Code] = 'COSTELEMENT'
              AND [Code] = @Code";

            var dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Code" },
                new List<object> { e.Value });

            ((DevExpress.Web.ASPxComboBox)sender).DataSource = dt;
            ((DevExpress.Web.ASPxComboBox)sender).DataBind();
        }

        private void ValidateGLDimensions(int type, string costElement, string projectCode)
        {
            if (type == 1) // G/L
            {
                if (string.IsNullOrWhiteSpace(costElement))
                    throw new Exception("Cost Element is required for G/L line.");

                if (string.IsNullOrWhiteSpace(projectCode))
                    throw new Exception("Project Code is required for G/L line.");
            }
        }


        #region import from excel
        protected void cbPasteExcel_Callback(object source, CallbackEventArgs e)
        {
            var cb = (ASPxCallback)source;

            string docNo = (hfDocNo.Value ?? "").Trim();
            string template = "REQ.";

            if (string.IsNullOrWhiteSpace(docNo))
            {
                cb.JSProperties["cpOK"] = false;
                cb.JSProperties["cpMessage"] = "Missing document No.";
                return;
            }

            string raw = e.Parameter ?? "";
            raw = raw.Replace("\r\n", "\n").Replace("\r", "\n").Trim();

            if (string.IsNullOrWhiteSpace(raw))
            {
                cb.JSProperties["cpOK"] = false;
                cb.JSProperties["cpMessage"] = "Clipboard is empty.";
                return;
            }

            // Header values to sync into lines
            string headerPurpose = (txtPurpose.Text ?? "").Trim();
            object headerDueDate = deDueDate.Value ?? DBNull.Value;
            object headerReqType = cboPurchReqType.Value ?? DBNull.Value;
            int headerStatus = SafeToInt(cboPurchReqStatus.Value, 0);

            // Parse lines
            string[] lines = raw.Split('\n').Where(x => !string.IsNullOrWhiteSpace(x)).ToArray();

            int inserted = 0;
            var errors = new List<string>();

            // Compute lineNo in-memory to avoid re-query each row
            int nextLineNo = GetNextLineNo(docNo); // your NAV +10000 logic. Must return next available.
            int step = 10000;

            foreach (var (lineText, idx) in lines.Select((v, i) => (v.TrimEnd('\t'), i)))
            {
                try
                {
                    string[] cols = lineText.Split('\t');

                    // Accept 4 or 5 columns
                    if (cols.Length < 4)
                        throw new Exception("Expected 4 or 5 columns: Type, ItemNo, Description, Quantity, (optional) UOM.");

                    string typeText = (cols[0] ?? "").Trim();
                    string no = (cols[1] ?? "").Trim();
                    string desc = (cols[2] ?? "").Trim();

                    string qtyText = (cols[3] ?? "").Trim();
                    decimal qty = ParseDecimal(qtyText);

                    string uom = (cols.Length >= 5 ? (cols[4] ?? "").Trim() : "");


                    int type = ParseType(typeText); // 1=G/L,2=Item
                    if (type != 1 && type != 2)
                        throw new Exception("Type must be 1(G/L) or 2(Item) or text 'G/L'/'Item'.");

                    if (string.IsNullOrWhiteSpace(no))
                        throw new Exception("ItemNo is empty.");


                    if (qty <= 0)
                        throw new Exception("Quantity must be > 0.");

                    if (type == 2)  // Item
                    {
                        if (!ExistsItem(no))
                            throw new Exception($"Item '{no}' not found in [LIVE_ALLIANCE_90$Item].");

                        // Auto-fill UOM if missing
                        if (string.IsNullOrWhiteSpace(uom))
                            uom = GetItemBaseUOM(no);

                        if (string.IsNullOrWhiteSpace(uom))
                            throw new Exception($"Cannot determine Base UOM for Item '{no}'.");

                        // Validate UOM exists in Item Unit of Measure
                        if (!ExistsItemUOM(no, uom))
                            throw new Exception($"UOM '{uom}' is not defined for Item '{no}' (Item Unit of Measure).");
                    }
                    else
                    {
                        if (!ExistsGL(no))
                            throw new Exception($"G/L '{no}' not found (Account Type must be 0).");


                    }


                    // Insert using stored procedure
                    ExecInsertPRLine(
                        template: template,
                        batch: docNo,
                        lineNo: nextLineNo,
                        type: type,
                        no: no,
                        desc: desc,
                        qty: qty,
                        uom: uom,
                        prNo: docNo,
                        purpose: headerPurpose,       // sync from header
                        dueDate: headerDueDate,
                        prType: headerReqType,
                        prStatus: headerStatus,
                        dim1: "",                     // no dimensions in Excel columns; keep empty
                        dim2: ""
                    );

                    inserted++;
                    nextLineNo += step;
                }
                catch (Exception ex)
                {
                    // Excel row number = idx + 1
                    errors.Add($"Row {idx + 1}: {ex.Message}");
                }
            }

            // Build result message
            string msg = $"<div>Inserted: <b>{inserted}</b> / {lines.Length}</div>";
            if (errors.Count > 0)
            {
                msg += "<div style='margin-top:8px; color:#b00020;'><b>Errors:</b><br/>"
                     + string.Join("<br/>", errors.Take(20).Select(Server.HtmlEncode))
                     + (errors.Count > 20 ? "<br/>...more" : "")
                     + "</div>";
            }

            cb.JSProperties["cpOK"] = (inserted > 0 && errors.Count == 0);
            cb.JSProperties["cpMessage"] = msg;
        }

        protected void btnImportPaste_Click(object sender, EventArgs e)
        {
            string docNo = (hfDocNo.Value ?? "").Trim();
            string template = "REQ.";

            if (string.IsNullOrWhiteSpace(docNo))
            {
                ShowSwal("Error", "Missing document No.", "error");
                return;
            }

            string raw = (memoPasteExcel.Text ?? "").Replace("\r\n", "\n").Replace("\r", "\n").Trim();

            if (string.IsNullOrWhiteSpace(raw))
            {
                ShowSwal("Error", "Clipboard is empty.", "error");
                return;
            }

            // Header-sync values
            string headerPurpose = (txtPurpose.Text ?? "").Trim();
            object headerDueDate = deDueDate.Value ?? DBNull.Value;
            object headerReqType = cboPurchReqType.Value ?? DBNull.Value;
            int headerStatus = SafeToInt(cboPurchReqStatus.Value, 0);

            var lines = raw.Split('\n').Where(x => !string.IsNullOrWhiteSpace(x)).ToList();

            int inserted = 0;
            var errors = new List<string>();

            int nextLineNo = GetNextLineNo(docNo);
            int step = 10000;

            for (int i = 0; i < lines.Count; i++)
            {
                string lineText = lines[i].TrimEnd('\t');

                try
                {
                    // New Excel order: Type, ItemNo, Description, Quantity, (optional) UOM
                    string[] cols = lineText.Split('\t');
                    if (cols.Length < 4)
                        throw new Exception("Expected 4 or 5 columns: Type, ItemNo, Description, Quantity, (optional) UOM.");

                    string typeText = (cols[0] ?? "").Trim();
                    string no = (cols[1] ?? "").Trim();
                    string desc = (cols[2] ?? "").Trim();

                    decimal qty = ParseDecimal((cols[3] ?? "").Trim());
                    string uom = (cols.Length >= 5 ? (cols[4] ?? "").Trim() : "");

                    int type = ParseType(typeText); // 1=G/L, 2=Item
                    if (type != 1 && type != 2) throw new Exception("Type must be 1(G/L) or 2(Item) or text 'G/L'/'Item'.");
                    if (string.IsNullOrWhiteSpace(no)) throw new Exception("ItemNo is empty.");
                    if (qty <= 0) throw new Exception("Quantity must be > 0.");

                    if (type == 2)
                    {
                        if (!ExistsItem(no))
                            throw new Exception($"Item '{no}' not found.");

                        // Auto-fill UOM from Item if missing (4 columns)
                        if (string.IsNullOrWhiteSpace(uom))
                            uom = GetItemBaseUOM(no);

                        if (string.IsNullOrWhiteSpace(uom))
                            throw new Exception($"Cannot determine Base UOM for Item '{no}'.");

                        if (!ExistsItemUOM(no, uom))
                            throw new Exception($"UOM '{uom}' is not defined for Item '{no}'.");
                    }
                    else
                    {
                        if (!ExistsGL(no))
                            throw new Exception($"G/L '{no}' not found or Account Type <> 0.");

                        uom = ""; // ignore UOM for GL
                    }

                    ExecInsertPRLine(
                        template: template,
                        batch: docNo,
                        lineNo: nextLineNo,
                        type: type,
                        no: no,
                        desc: desc,
                        qty: qty,
                        uom: uom,
                        prNo: docNo,
                        purpose: headerPurpose,
                        dueDate: headerDueDate,
                        prType: headerReqType,
                        prStatus: headerStatus,
                        dim1: "",
                        dim2: ""
                    );

                    inserted++;
                    nextLineNo += step;
                }
                catch (Exception ex)
                {
                    errors.Add($"Row {i + 1}: {ex.Message}");
                }
            }

            // Reload grid
            BindGridLines(docNo);

            // Close popup + show result
            string msg = $"Inserted: <b>{inserted}</b> / {lines.Count}";
            if (errors.Count > 0)
                msg += "<br/><br/><b>Errors:</b><br/>" + string.Join("<br/>", errors.Take(30).Select(Server.HtmlEncode));

            // Clear memo if success (optional)
            if (inserted > 0) memoPasteExcel.Text = "";

            // Hide popup on client and show swal
            // (pcPasteExcel is client instance)
            string js = $"pcPasteExcel.Hide();";
            ScriptManager.RegisterStartupScript(this, GetType(), "HidePastePopup", js, true);

            ShowSwal("Import completed", msg, errors.Count == 0 ? "success" : (inserted > 0 ? "warning" : "error"));
        }





        private string GetItemBaseUOM(string itemNo)
        {
            itemNo = (itemNo ?? "").Trim();
            if (string.IsNullOrWhiteSpace(itemNo)) return "";

            try
            {
                string sql1 = @"
                SELECT TOP 1 [Base Unit of Measure] AS BaseUOM
                FROM [dbo].[LIVE_ALLIANCE_90$Item]
                WHERE [No_] = @No;";

                DataTable dt1 = SQRLibrary.ReturnDatatablefromSQL(
                    sql1,
                    new List<string> { "@No" },
                    new List<object> { itemNo }
                );

                if (dt1 != null && dt1.Rows.Count > 0)
                    return Convert.ToString(dt1.Rows[0]["BaseUOM"])?.Trim() ?? "";
            }
            catch
            {

            }

            return "";
        }


        private int ParseType(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return 0;

            // numeric
            if (int.TryParse(s, out int n)) return n;

            // text
            string t = s.Trim().ToUpperInvariant();
            if (t == "GL" || t == "G/L" || t.Contains("G/L")) return 1;
            if (t == "ITEM" || t.Contains("ITEM")) return 2;

            return 0;
        }

        private decimal ParseDecimal(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return 0m;

            // Excel may use comma or dot depending on locale
            // Try invariant first, then current culture
            if (decimal.TryParse(s, NumberStyles.Any, CultureInfo.InvariantCulture, out var v))
                return v;

            if (decimal.TryParse(s, NumberStyles.Any, CultureInfo.CurrentCulture, out v))
                return v;

            // Try swap commas
            s = s.Replace(",", ".");
            if (decimal.TryParse(s, NumberStyles.Any, CultureInfo.InvariantCulture, out v))
                return v;

            return 0m;
        }

        private bool ExistsItem(string itemNo)
        {
            string sql = @"SELECT TOP 1 1 FROM [dbo].[LIVE_ALLIANCE_90$Item] WHERE [No_] = @No";
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql,
                new List<string> { "@No" },
                new List<object> { itemNo });
            return dt != null && dt.Rows.Count > 0;
        }

        private bool ExistsItemUOM(string itemNo, string uomCode)
        {
            if (string.IsNullOrWhiteSpace(itemNo) || string.IsNullOrWhiteSpace(uomCode))
                return false;

            string sql = @"
            SELECT TOP 1 1
            FROM [dbo].[LIVE_ALLIANCE_90$Item Unit of Measure]
            WHERE [Item No_] = @ItemNo
              AND [Code] = @UOM;";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@ItemNo", "@UOM" },
                new List<object> { itemNo.Trim(), uomCode.Trim() }
            );

            return dt != null && dt.Rows.Count > 0;
        }


        private bool ExistsGL(string glNo)
        {
            string sql = @"
            SELECT TOP 1 1
            FROM [dbo].[LIVE_ALLIANCE_90$G_L Account]
            WHERE [No_] = @No AND [Account Type] = 0";
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql,
                new List<string> { "@No" },
                new List<object> { glNo });
            return dt != null && dt.Rows.Count > 0;
        }

        private void ExecInsertPRLine(
            string template, string batch, int lineNo,
            int type, string no, string desc, decimal qty, string uom,
            string prNo, string purpose, object dueDate, object prType, int prStatus,
            string dim1, string dim2)
        {
            string sql = @"
            EXEC dbo.ALL_PR_Line_Insert
                 @WorksheetTemplateName = @WorksheetTemplateName,
                 @JournalBatchName      = @JournalBatchName,
                 @LineNo                = @LineNo,
                 @Type                  = @Type,
                 @No                    = @No,
                 @Description           = @Description,
                 @Quantity              = @Quantity,
                 @UnitOfMeasureCode     = @UnitOfMeasureCode,
                 @PurchReqNo            = @PurchReqNo,
                 @PurchReqPurpose       = @PurchReqPurpose,
                 @PurchReqDueDate       = @PurchReqDueDate,
                 @PurchReqType          = @PurchReqType,
                 @PurchReqStatus        = @PurchReqStatus,
                 @ShortcutDim1Code      = @ShortcutDim1Code,
                 @ShortcutDim2Code      = @ShortcutDim2Code;";

            SQRLibrary.ExecuteSQL(
                sql,
                new List<string>
                {
                    "@WorksheetTemplateName","@JournalBatchName","@LineNo",
                    "@Type","@No","@Description","@Quantity","@UnitOfMeasureCode",
                    "@PurchReqNo","@PurchReqPurpose","@PurchReqDueDate","@PurchReqType","@PurchReqStatus",
                    "@ShortcutDim1Code","@ShortcutDim2Code"
                },
                new List<object>
                {
            template, batch, lineNo,
            type, no, desc ?? "", qty, uom ?? "",
            prNo, purpose ?? "", dueDate ?? DBNull.Value, prType ?? DBNull.Value, prStatus,
            dim1 ?? "", dim2 ?? ""
                }
            );
        }

        #endregion

        protected void txtPurpose_TextChanged(object sender, EventArgs e)
        {
            btnSaveHeader_Click(sender, e);
        }

        protected void deDueDate_DateChanged(object sender, EventArgs e)
        {
            btnSaveHeader_Click(sender, e);
        }

        protected void cboPurchReqType_SelectedIndexChanged(object sender, EventArgs e)
        {
            btnSaveHeader_Click(sender, e);
        }



        private void InitDocumentFolder(string navigateTosubFolder = "")
        {
            try
            {
                ASPxFileManager1.Visible = true;
                string OrderNo = Request["OrderNo"]?.ToString() ?? "";
                if (string.IsNullOrWhiteSpace(OrderNo)) return;

                var no = Regex.Replace(OrderNo.Trim(), @"[^\w\.-]", "_");
                const string basePhysical = @"D:\ALLIANCE_NEW\ERP\DOCUMENTS\PURCHASEREQUEST";

                string PRFolder = no.Substring(0, 4) + @"\" + no;

                var folderPhysical = Path.Combine(basePhysical, PRFolder);
                if (!Directory.Exists(folderPhysical)) Directory.CreateDirectory(folderPhysical);
                //CreateDefaultFolder(folderPhysical);

                if (!string.IsNullOrWhiteSpace(navigateTosubFolder)) folderPhysical = Path.Combine(folderPhysical, navigateTosubFolder);
                ASPxFileManager1.Settings.RootFolder = folderPhysical;

                bool haspermission = false;

                haspermission =
                SecurePage.IsUserInAnyRole(Session["userid"].ToString(), new[]
                            {
                                    "System Owner",
                                    "Admin",
                                    
                                })
                || (new List<int>() {0, 2 }.Contains((int)ViewState["PRStatus"]) && ViewState["PRCreatedUser"].ToString() == Session["userid"]?.ToString());

                ASPxFileManager1.SettingsUpload.Enabled = haspermission;
                ASPxFileManager1.SettingsEditing.AllowRename = haspermission;
                ASPxFileManager1.SettingsEditing.AllowCreate = haspermission;
                ASPxFileManager1.SettingsEditing.AllowCopy = haspermission;
                ASPxFileManager1.SettingsEditing.AllowDelete = haspermission;
                ASPxFileManager1.SettingsEditing.AllowMove = haspermission;
            }
            catch { }
        }

        private void CreateDefaultFolder(string origin_path)
        {
            try
            {
                List<string> folders = new List<string>() { "Sample", "Drawings", "Invoices", "Documents" };
                foreach (string folder in folders)
                {
                    if (!Directory.Exists(Path.Combine(origin_path, folder))) Directory.CreateDirectory(Path.Combine(origin_path, folder));
                }
            }
            catch { }
        }
        protected void ASPxFileManager1_CustomCallback(object sender, CallbackEventArgsBase e)
        {
            // e.Parameter = "zip|<encoded fullName>"
            var p = (e.Parameter ?? "").Split(new[] { '|' }, 2);
            if (p.Length != 2 || p[0] != "zip")
                return;

            string fullName = Uri.UnescapeDataString(p[1]); // provider-relative path
            //fullName = Regex.Replace(fullName.Trim(), @"[^\w\.-]", "_");  

            string OrderNo = Request["OrderNo"]?.ToString() ?? "";
            if (string.IsNullOrWhiteSpace(OrderNo)) return;

            var no = Regex.Replace(OrderNo.Trim(), @"[^\w\.-]", "_");
            const string basePhysical = @"D:\ALLIANCE_NEW\ERP\DOCUMENTS\PURCHASEREQUEST";

            string PRFolder = no.Substring(0, 4) + @"\" + no;

            var folderPhysical = Path.Combine(basePhysical, PRFolder, fullName);


            if (!Directory.Exists(folderPhysical))
                throw new Exception("Folder not found on server.");

            string token = Guid.NewGuid().ToString("N");
            string zipPath = Path.Combine(Path.GetTempPath(), "fm_" + token + ".zip");

            ZipFile.CreateFromDirectory(folderPhysical, zipPath, CompressionLevel.Fastest, includeBaseDirectory: true);

            // store for handler
            Session["FM_ZIP_" + token] = zipPath;

            // pass token back to client in a custom property
            ASPxFileManager1.JSProperties["cpZipToken"] = token;
        }

        protected void cboHeaderProjectCode_ItemsRequestedByFilterCondition(object sender, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            BindDimensionValueLookup((ASPxComboBox)sender, "DEPARTMENT", e.Filter);
        }

        protected void cboHeaderProjectCode_ItemRequestedByValue(object sender, ListEditItemRequestedByValueEventArgs e)
        {
            BindDimensionValueByCode((ASPxComboBox)sender, "DEPARTMENT", e.Value);
        }

        protected void cboHeaderCostElement_ItemsRequestedByFilterCondition(object sender, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            BindDimensionValueLookup((ASPxComboBox)sender, "COSTELEMENT", e.Filter);
        }

        protected void cboHeaderCostElement_ItemRequestedByValue(object sender, ListEditItemRequestedByValueEventArgs e)
        {
            BindDimensionValueByCode((ASPxComboBox)sender, "COSTELEMENT", e.Value);
        }

        private void BindDimensionValueLookup(ASPxComboBox cbo, string dimensionCode, string filter)
        {
            // Callback mode: only return filtered rows
            string sql = @"
            SELECT TOP (50)
                [Code], [Name], [Consolidation Code]
            FROM [dbo].[LIVE_ALLIANCE_90$Dimension Value]
            WHERE [Dimension Code] = @Dim
              AND (
                    [Code] LIKE @Filter
                 OR [Name] LIKE @Filter
              )
            ORDER BY [Code];";

            string f = "%" + (filter ?? "").Trim() + "%";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Dim", "@Filter" },
                new List<object> { dimensionCode, f }
            );

            cbo.DataSource = dt;
            cbo.DataBind();
        }

        private void BindDimensionValueByCode(ASPxComboBox cbo, string dimensionCode, object value)
        {
            cbo.DataSource = null;
            cbo.DataBind();

            if (value == null) return;

            string code = Convert.ToString(value)?.Trim();
            if (string.IsNullOrWhiteSpace(code)) return;

            string sql = @"
            SELECT
                [Code], [Name], [Consolidation Code]
            FROM [dbo].[LIVE_ALLIANCE_90$Dimension Value]
            WHERE [Dimension Code] = @Dim
              AND [Code] = @Code;";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Dim", "@Code" },
                new List<object> { dimensionCode, code }
            );

            cbo.DataSource = dt;
            cbo.DataBind();
        }

        protected void cboHeaderCostElement_TextChanged(object sender, EventArgs e)
        {
            UpdateDIMENSION = true;
            btnSaveHeader_Click(sender, e);
        }

        protected void cboHeaderProjectCode_TextChanged(object sender, EventArgs e)
        {
            UpdateDIMENSION = true;
            btnSaveHeader_Click(sender, e);
        }
    }
}
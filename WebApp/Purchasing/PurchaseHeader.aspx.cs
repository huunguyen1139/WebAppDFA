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

namespace WebApp.purchase
{
    public partial class PurchaseHeader : SecurePage
    {
        private readonly List<string> link_columns = new List<string>() { "SubRequestNo", "PRNo" };
        protected void Page_PreInit(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";            
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            cbCost.InputAttributes["class"] = "form-check-input ";
            cbRequestRef.InputAttributes["class"] = "form-check-input";
            //cbProjectAmount.InputAttributes["class"] = "form-check-input";
            cbRemark.InputAttributes["class"] = "form-check-input";
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
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), $"Mở Purchase Order {docNo}");

                //set parameter for comment control
                commentSection.DocumentID = docNo;

                if (string.IsNullOrWhiteSpace(docNo))
                {
                    lblTitle.Text = "Purchase Order";
                    lblHeaderInfo.Text = "Missing parameter ?OrderNo=";
                    return;
                }
                ViewState["BigAmount"] = false;
                CheckAndLoadInfo(docNo.Trim());

                InitApprovalControl();
            }
            else
            {
                DataTable dt = ViewState["POLines"] == null ? new DataTable() : (DataTable)ViewState["POLines"];
                gvLines.DataSource = dt;
                gvLines.DataBind();
            }
        }

        private void InitApprovalControl()
        {
            ApprovalDocumentType approvalDocumentType = new ApprovalDocumentType();
            string CurrentUser = Session["userid"].ToString();
            bool BigAmount = ViewState["BigAmount"] == null ? false : (bool)ViewState["BigAmount"]; ;

            if (SecurePage.IsUserInRole(CurrentUser, "PURCHASE Staff Factory"))
            {                
                approvalDocumentType = BigAmount ? ApprovalDocumentType.Factory_PO_BigAmount : ApprovalDocumentType.Factory_PO;
            }
            else if (SecurePage.IsUserInRole(CurrentUser, "PURCHASE Staff Office"))
            {
                approvalDocumentType = BigAmount ? ApprovalDocumentType.Office_PO_BigAmount : ApprovalDocumentType.Office_PO;
            }
            else approvalDocumentType = ApprovalDocumentType.Factory_PO;
                        

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
                //check if user is in domestic tender group, if not return
                bool fullview = SecurePage.IsUserInAnyRole(Session["userid"].ToString(),
                    new[] { 
                        "System Owner",
                        "PURCHASE Staff Cost Control",
                        "PURCHASE Staff Office",
                        "PURCHASE Staff Factory",
                        "PURCHASE User View PO"
                     });

                bool quantityview = SecurePage.IsUserInAnyRole(Session["userid"].ToString(),
                    new[] { "View Tender Order - Drawing" });

                bool boq_view = SecurePage.IsUserInAnyRole(Session["userid"].ToString(),
                    new[] { "View Tender Order - BOQ" });


                if (!(fullview || quantityview || boq_view)) return;

                InitDocumentFolder();
                LoadHeader(docNo);
                LoadLines(docNo);

                cb_CheckedChanged(null, null);
            }
            catch { }

        }

        private void LoadHeader(string docNo)
        {
            string sqlHeader = @"
                            SELECT
                                [No_],
                                [Buy-from Vendor No_]          AS VendorNo,
                                [Buy-from Vendor Name]         AS VendorName,
                                [Buy-from Contact]             AS VendorContact,
                                [Posting Date]                 AS PostingDate,
                                [Order Date]                   AS OrderDate,
                                [Document Date]                AS DocumentDate,
                                [Posting Description]          AS PostingDescription,
                                [Your Reference]               AS YourReference,
                                [Currency Code]                AS CurrencyCode,
                                [Ma HD]                        AS MaHD,
                                [Ky hieu mau HD]               AS KyHieuMauHD,
                                [Vendor Invoice No_]           AS VendorInvoiceNo,
                                [VAT Description]              AS VATDescription,
                                [Purchaser Code]               AS PurchaserCode,
                                [Shortcut Dimension 1 Code]    AS ShortcutDim1,
                                [Shortcut Dimension 2 Code]    AS ShortcutDim2,
                                [Status]                       AS Status
                            FROM [dbo].[LIVE_ALLIANCE_90$Purchase Header]
                            WHERE [Document Type] = 1 AND [No_] = @No;";

            DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(
                sqlHeader,
                new List<string> { "@No" },
                new List<object> { docNo }
            );

            if (dtHeader.Rows.Count == 0)
            {
                lblTitle.Text = docNo;
                lblHeaderInfo.Text = "Document not found in Purchase Header.";
                ClearHeaderControls();
                return;
            }

            DataRow row = dtHeader.Rows[0];

            // Title: "SQ/24-0016 · CÔNG TY TNHH THẾ PHONG RENTAL"
            SetHeaderTextAndStyle(row);
                       

            // LEFT COLUMN
            txtVendorNo.Text = row["VendorNo"].ToString();
            txtVendorName.Text = row["VendorName"].ToString();
            txtContact.Text = row["VendorContact"].ToString();

            //SetDateEdit(dePostingDate, row["PostingDate"]);
            SetDateEdit(deOrderDate, row["OrderDate"]);
            //SetDateEdit(deDocumentDate, row["DocumentDate"]);

            txtPostingDescription.Text = row["PostingDescription"].ToString();   // Ghi chu
            txtYourReference.Text = row["YourReference"].ToString();             // Thoa thuan khac
            ViewState["DocDes"] = row["PostingDescription"].ToString();
            // RIGHT COLUMN
            //txtContractNo.Text = row["MaHD"].ToString();              // Ma HD
            //txtDocumentSymbol.Text = row["KyHieuMauHD"].ToString();   // Ky hieu mau HD
            txtVendorInvoiceNo.Text = row["VendorInvoiceNo"].ToString();
            txtVATDescription.Text = row["VATDescription"].ToString();
            txtPurchaserCode.Text = row["PurchaserCode"].ToString();
            txtProjectCode.Text = row["ShortcutDim1"].ToString();     // Project Code
            txtCostElement.Text = row["ShortcutDim2"].ToString();     // Cost Element

            txtStatus.Text = GetStatusCaption(row["Status"]);

            string currency = row["CurrencyCode"].ToString();
            if (string.IsNullOrWhiteSpace(currency))
                currency = "VND";

            lblCurrency1.Text = currency;
            lblCurrency2.Text = currency;
            lblCurrency3.Text = currency;
        }

        private void SetHeaderTextAndStyle(DataRow row)
        {
            string no = row["No_"].ToString();
            string vendorNo = row["VendorNo"].ToString();
            string vendorName = row["VendorName"].ToString();

            int statusInt = row["Status"] == DBNull.Value ? -1 : Convert.ToInt32(row["Status"]);
            string statusText = GetStatusCaption(statusInt);
            string statusColor = GetStatusColor(statusInt);
            string statusTooltip = GetStatusTooltip(statusInt);

            // Title format:
            // SQ/24-0016 · PHONGREN · CÔNG TY TNHH THẾ PHONG RENTAL · <Status>
            lblTitle.Text = string.Format(
                "{0} &middot; {1} &middot; {2} &middot; " +
                "<span style='color:{3}; font-weight:600; cursor:help;' " +
                "data-bs-toggle='tooltip' data-bs-placement='bottom' title='{4}'>{5}</span>",
                HtmlEncode(no),
                HtmlEncode(vendorNo),
                HtmlEncode(vendorName),
                statusColor,
                HtmlAttributeEncode(statusTooltip),
                HtmlEncode(statusText)
            );

            this.Title = $"Purchase Order: {no}";

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

        private void ClearHeaderControls()
        {
            txtVendorNo.Text = "";
            txtVendorName.Text = "";
            txtContact.Text = "";
            //dePostingDate.Value = null;
            deOrderDate.Value = null;
            //deDocumentDate.Value = null;
            txtPostingDescription.Text = "";
            txtYourReference.Text = "";
            //txtContractNo.Text = "";
            //txtDocumentSymbol.Text = "";
            txtVendorInvoiceNo.Text = "";
            txtVATDescription.Text = "";
            txtPurchaserCode.Text = "";
            txtProjectCode.Text = "";
            txtCostElement.Text = "";
            txtStatus.Text = "";
        }

        // ========================= LINES =========================

        private void LoadLines(string docNo)
        {
            string sqlLines = @"
                    SELECT
                    [Line No_]                        AS [LineNo],
                    [Type],
                    pl.[No_],
                    pl.[Description],
                    pl.[Description 2]                AS Note,
                    pl.[Quantity],
                    [Outstanding Qty_ (Base)]         AS OutstandingQtyBase,
                    pl.[Shortcut Dimension 1 Code]    AS ProjectCode,
                    pl.[Shortcut Dimension 2 Code]    AS CostElement,
                    [Indirect Cost _]                 AS IndirectCostPercent,
                    [Unit of Measure Code]            AS UnitOfMeasureCode,
                    [Direct Unit Cost]                AS DirectUnitCost,
                    [Amount]                          AS Amount,
                    [Amount Including VAT]            AS AmountInclVAT,
                    [Work Center No_]                 AS WorkCenterNo,
	                prod.SubRequestNo			      AS SubRequestNo,
                    pl.[Purch_ Req_ No] 			  AS PRNo,
	                pl.[Purch_ Req_ Line No]          AS PRLineNo,
                    [VAT Prod_ Posting Group]         AS VAT

                FROM [dbo].[LIVE_ALLIANCE_90$Purchase Line] pl
                LEFT JOIN [LIVE_ALLIANCE_90$Production Order] prod ON pl.[Prod_ Order No_] = prod.No_
                WHERE [Document Type] = 1 AND [Document No_] = @No
                ORDER BY [Line No_]";

            DataTable dtLines = SQRLibrary.ReturnDatatablefromSQL(
                sqlLines,
                new List<string> { "@No" },
                new List<object> { docNo }
            );

            ViewState["POLines"] = dtLines;
            gvLines.DataSource = dtLines;
            gvLines.DataBind();

            // ==== CALCULATE TOTALS FROM LINE TABLE ====

            decimal totalExclVat = 0;
            decimal totalInclVat = 0;

            foreach (DataRow r in dtLines.Rows)
            {
                if (r["Amount"] != DBNull.Value)
                    totalExclVat += Convert.ToDecimal(r["Amount"]);

                if (r["AmountInclVAT"] != DBNull.Value)
                    totalInclVat += Convert.ToDecimal(r["AmountInclVAT"]);
            }

            decimal vatAmount = totalInclVat - totalExclVat;

            lblTotalExclVat.Text = totalExclVat.ToString("#,0");
            lblTotalInclVat.Text = totalInclVat.ToString("#,0");
            lblTotalVat.Text = vatAmount.ToString("#,0");

            ViewState["BigAmount"] = totalInclVat >= 100000000;
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
            LoadHeader(docNo);
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


        private void InitDocumentFolder(string navigateTosubFolder = "")
        {
            try
            {
                ASPxFileManager1.Visible = true;
                string OrderNo = Request["OrderNo"]?.ToString() ?? "";
                if (string.IsNullOrWhiteSpace(OrderNo)) return;

                var no = Regex.Replace(OrderNo.Trim(), @"[^\w\.-]", "_");
                const string basePhysical = @"D:\ALLIANCE_NEW\ERP\DOCUMENTS\PURCHASEORDERS";

                string POFolder = GetPurchaseOrderFolder(no);

                var folderPhysical = Path.Combine(basePhysical, POFolder);
                if (!Directory.Exists(folderPhysical)) Directory.CreateDirectory(folderPhysical);
                CreateDefaultFolder(folderPhysical);

                if (!string.IsNullOrWhiteSpace(navigateTosubFolder)) folderPhysical = Path.Combine(folderPhysical, navigateTosubFolder);
                ASPxFileManager1.Settings.RootFolder = folderPhysical;

                bool haspermission = false;
                
                haspermission = SecurePage.IsUserInAnyRole(Session["userid"].ToString(), new[] 
                                { 
                                    "System Owner", 
                                    "Domestic Tender Staff", 
                                    "Office Purchasing Staff",
                                    "Factory Purchasing Staff",
                                    "Cost Control Purchasing Staff"
                                });
                
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
                List<string> folders = new List<string>() { "Quotation", "Drawings", "Invoices", "Documents" };
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
            const string basePhysical = @"D:\ALLIANCE_NEW\ERP\DOCUMENTS\PURCHASEORDERS";

            string POFolder = GetPurchaseOrderFolder(no);

            var folderPhysical = Path.Combine(basePhysical, POFolder, fullName);
                       

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

        protected void gvLines_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            
            if (!link_columns.Contains(e.DataColumn.FieldName)) return;

            string val = e.CellValue as string ?? "";
            switch (e.DataColumn.FieldName)
            {
                case "SubRequestNo":
                    e.Cell.Controls.Clear();

                    if (val.Length <= 15)
                    {
                        var link = new DevExpress.Web.ASPxHyperLink
                        {
                            Text = val,
                            NavigateUrl = $"/production/subcontract/subcontractingrequest?RequestID={Server.UrlEncode(val)}",
                            Target = "_blank"
                        };
                        e.Cell.Controls.Add(link);
                    }
                    else
                    {
                        e.Cell.Controls.Add(new Literal { Text = Server.HtmlEncode(val) });
                    }
                    break;

                case "PRNo":
                    e.Cell.Controls.Clear();

                    if (val.Length <= 15)
                    {
                        var link = new DevExpress.Web.ASPxHyperLink
                        {
                            Text = val,
                            NavigateUrl = $"tender_order_detail?no={Server.UrlEncode(val)}"
                        };
                        e.Cell.Controls.Add(link);
                    }
                    else
                    {
                        e.Cell.Controls.Add(new Literal { Text = Server.HtmlEncode(val) });
                    }
                    break;
            }
            
            
        }

        protected void cb_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                gvLines.DataBind();

                gvLines.DataColumns["Note"].Visible = cbRemark.Checked;
                gvLines.DataColumns["ProjectCode"].Visible = cbCost.Checked;
                gvLines.DataColumns["CostElement"].Visible = cbCost.Checked;

                gvLines.DataColumns["SubRequestNo"].Visible = cbRequestRef.Checked;
                gvLines.DataColumns["PRNo"].Visible = cbRequestRef.Checked;
                
            }
            catch { }
        }
    }
}
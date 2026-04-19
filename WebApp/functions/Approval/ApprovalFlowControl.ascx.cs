using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.functions.SendEmail;
using WebApp.site;
using static WebApp.Models.Enum.ApprovalEnum;

namespace WebApp.functions.approval
{
    public partial class ApprovalFlowControl : UserControl, IPostBackEventHandler
    {
        /*--- public API ------------------------------------------------*/
        public int DocId
        {
            get
            {
                if (ViewState["DocId"] != null)
                    return (int)ViewState["DocId"];
                // Try to get from lookup if not set yet
                int id = LookupDocId() ?? 0;
                ViewState["DocId"] = id;
                return id;
            }
            set
            {
                ViewState["DocId"] = value;
            }
        }

        /// <summary>
        /// Gets the user ID of the next approver for this document, or null if none.
        /// </summary>
        //public string NextApproverId
        //{
        //    get
        //    {
        //        if (ViewState["NextApproverId"] != null)
        //            return ViewState["NextApproverId"].ToString();
        //        // Try to get from lookup if not set yet
        //        string id = LookupNextApproverID() ?? "";
        //        ViewState["NextApproverId"] = id;
        //        return id;
        //    }
        //}

        /// <summary>
        /// Gets the display name of the next approver, or empty if none.
        /// </summary>
        //public string NextApproverName
        //{
        //    get
        //    {
        //        if (ViewState["NextApproverName"] != null)
        //            return (string)ViewState["NextApproverName"];

        //        var nextId = NextApproverId;
        //        if (string.IsNullOrEmpty(nextId))
        //            return String.Empty;

        //        const string sqlUser = @"
        //        SELECT EmployeeName
        //        FROM   dbo.Employee
        //        WHERE  EmployeeID = @UserId";

        //        var dtUser = SQRLibrary.ReturnDatatablefromSQL_mrp(
        //            sqlUser,
        //            new List<string> { "@UserId" },
        //            new List<object> { nextId }
        //        );
        //        if (dtUser.Rows.Count == 0)
        //            return String.Empty;
        //        ViewState["NextApproverName"] = dtUser.Rows[0]["EmployeeName"].ToString();
        //        return dtUser.Rows[0]["EmployeeName"].ToString();
        //    }
        //}
        
        
        [Browsable(true)][Category("Data")][DefaultValue(0)]
        [Description("Document Type ID from ApprovalDocumentType enum")]
        public ApprovalDocumentType DocTypeId
        {
            get => (ApprovalDocumentType)(ViewState["DocTypeId"] ?? 0);
            set => ViewState["DocTypeId"] = value;
        }
        public string ExternalRef
        {
            get { return (string)(ViewState["ExternalRef"] ?? string.Empty); }
            set { ViewState["ExternalRef"] = value; }
        }

        public string EmailTemplate
        {
            get { return (string)(ViewState["EmailTemplate"] ?? string.Empty); }
            set { ViewState["EmailTemplate"] = value; }
        }

        public string ProjectId
        {
            get { return (string)(ViewState["ProjectId"] ?? string.Empty); }
            set { ViewState["ProjectId"] = value; }
        }
        public string Title
        {
            get { return (string)(ViewState["Title"] ?? string.Empty); }
            set { ViewState["Title"] = value; }
        }

        public string DocumentDescription
        {
            get { return (string)(ViewState["DocumentDescription"] ?? string.Empty); }
            set { ViewState["DocumentDescription"] = value; }
        }
        public string CurrentUser => (string)Session["UserId"];     
        public string CurrentUserName => (string)Session["Username"];
        public string CurrentUserTitle => (string)Session["UserRole"];
        public bool ShowInstanceStepTable
        {
            get { return (bool)(ViewState["ShowInstanceStepTable"] ?? false); }
            set { ViewState["ShowInstanceStepTable"] = value; }
        }

        public event EventHandler StatusChanged;

        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //ApprovalService.BuildInstance(DocId, CurrentUser);
                //ShowInstanceStepTable = true;
                divShowFlowInstanceSteps.Visible = ShowInstanceStepTable;
                if (string.IsNullOrEmpty(ExternalRef)) { return; }
                RenderFlowTable();
                ToggleButtons();
            }
            
            // turn every SqlDataSource (if you add one) onto SQRLibrary.mrp_connection
            //ApplyMrpConnection(this);
        }

        static void ApplyMrpConnection(Control root)
        {
            foreach (Control c in root.Controls)
            {
                if (c is SqlDataSource sds) sds.ConnectionString = SQRLibrary.mrp_connection;
                if (c.HasControls()) ApplyMrpConnection(c);
            }
        }

        private void RaiseStatusChanged()
        {
            StatusChanged?.Invoke(this, EventArgs.Empty);
        }


        /*--- helpers ---------------------------------------------------*/

        private int? LookupDocId()
        {
            return ApprovalService.FindDocId((int)DocTypeId, ExternalRef);
        }
        private string LookupNextApproverID()
        {
            return ApprovalService.NextApproverID(DocId);
        }
        void ToggleButtons(bool RefreshData = false)
        {
            if (RefreshData) ViewState["NextApproverId"] = null;
            bool showApproval = false;

            var NextApprover = ApprovalService.GetNextApprover(DocId);
            if (NextApprover == null || NextApprover.Count <= 0) showApproval = false;
            else showApproval = NextApprover[0].ApproverId == CurrentUser;
            
            btnApprove.Attributes["class"] = "btn btn-success" + (showApproval ? "" : " d-none");
            btnReject.Attributes["class"] = "btn btn-danger" + (showApproval ? "" : " d-none");
        }
        void RenderFlowTable()
        {
            if (!ShowInstanceStepTable) return;

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
            "SELECT Seq, ApproverId, ApproverName, StatusName [Status], Comment, ActionOn " +
                "FROM dbo.VW_APPROVAL_InstanceSteps_Resolved " +
                "WHERE InstanceId IN (SELECT InstanceId FROM dbo.APPROVAL_Instances WHERE DocId=@doc) " +
                "ORDER BY Seq",
                new List<string>() { "@doc" }, new List<object>() { DocId });

            var sb = new StringBuilder();
            foreach (DataRow r in dt.Rows)
            {
                string st = r["Status"].ToString();
                string badge = st == "A" ? "success"
                             : st == "R" ? "danger"
                             : "secondary";

                sb.Append($@"
                <tr data-level='{r["Seq"]}'>
                  <td>{r["Seq"]}</td>
                  <td>{r["ApproverId"]}</td>
                  <td><span class='badge bg-{badge}'>{st}</span></td>
                  <td>{r["Comment"]}</td>
                  <td class='text-nowrap'>
                     <button class='btn btn-sm btn-outline-secondary me-1' data-cmd='up'>↑</button>
                     <button class='btn btn-sm btn-outline-secondary me-1' data-cmd='down'>↓</button>
                     <button class='btn btn-sm btn-outline-danger' data-cmd='del'>✕</button>
                  </td>
                </tr>");
            }
            flowBody.InnerHtml = sb.ToString();   // <tbody runat="server" id="flowBody">
        }
        private void SwalInfo(string msg, string type = "info", string title = "Info") => ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), $"Swal.fire('{title}','{msg}','{type}');", true);
                
        public void RaisePostBackEvent(string arg)
        {
            switch (arg)
            {
                case "send":
                    //ApprovalService.Submit(DocId, CurrentUser, 'A', hfComment.Value); // sends first step
                    SendApproval();
                    break;
                case "cancel":
                    // set every step to Cancelled, document status to Cancelled for real header and APPROVAL document header
                    CancelApproval();
                    break;
                case "approve":
                    ApprovalService.Submit(DocId, CurrentUser, 'A', hfComment.Value);
                    break;
                case "reject":
                    ApprovalService.Submit(DocId, CurrentUser, 'R', hfComment.Value);
                    break;
            }
            RenderFlowTable();
        }
        private bool SendApproval()
        {
            var (docId, already) =
                ApprovalService.BuildInstance((int)DocTypeId, ExternalRef, ProjectId ?? string.Empty, Title, CurrentUser);

            if (already)
            {                
                SwalInfo("This document was already sent for approval.", "warning", "Warning!");
                return false;
            }
            
            DocId = docId;               // store for later grid refresh etc.
            RenderFlowTable();
            ToggleButtons(true);
            SwalInfo("Approval request created.", "success", "Done");
            return true;
        }
        private void CancelApproval()
        {
            if (DocId <= 0)
            {
                SwalInfo("This document hasn’t been sent for approval yet.", "warning", "Warning!");
                return;
            }
            var approval_sender = ApprovalService.GetCreator(DocId);
            bool isInAdminRole = SecurePage.IsUserInAnyRole(CurrentUser, new[] { "Admin" });
            if (!(approval_sender.SenderId == CurrentUser || isInAdminRole))
            {
                SwalInfo("You do not have permission to cancel approval.", "warning", "Warning!");
                return;
            } 

            bool bl = ApprovalService.CancelApproval(DocId, CurrentUser);

            // refresh view
            RenderFlowTable();
            if (bl)
            {
                //reset DocID
                ViewState["DocId"] = null;
                ToggleButtons(true);
                SwalInfo("Approval cancelled. Document status reset to Open.", "success", "Success!");
            }                
            else SwalInfo("Approval cancel failed. Only pending document can be cancelled", "warning", "Warning!");
        }        

        private void SendEmailToNextApprover()
        {
            try
            {
                //queue or send email
                var NextApprover = ApprovalService.GetNextApprover(DocId);

                //approval completed, send email to creator and all action person list
                if (NextApprover.Count <= 0)
                {
                    if (!ApprovalService.IsReleased(DocId)) return;

                    //send email to sender
                    var Sender = ApprovalService.GetCreator(DocId);
                    if (string.IsNullOrWhiteSpace(Sender.Email)) return;

                    object modelCompletedApproval = new
                    {
                        DocDes = DocumentDescription,
                        DocumentNo = $"{DocTypeId.ToString()}: {ExternalRef}",
                        ApprovalLink = HttpContext.Current.Request.Url.AbsoluteUri,
                        ApproverName = CurrentUserName + " - " + CurrentUserTitle,
                        UserName = Sender.SenderName,
                        CompletedDate = DateTime.Now.ToString()
                    };
                    Task.Run(async () => await EmailHelper.SendAsyncByTemplate("APPROVAL_COMPLETED", modelCompletedApproval, Sender.Email));


                    //send email to notify group
                    var recips = ApprovalService.GetReleaseRecipients(DocId, ProjectId);
                    if (recips.Rows.Count == 0) return;
                    string to_emails = "";
                    foreach (DataRow r in recips.Rows)
                    {
                        to_emails += r["Email"] + ";";
                    }
                    object modelNotify = new
                    {
                        DocDes = DocumentDescription,
                        RecipientName = "Recipients",
                        DocumentNo = $"{DocTypeId.ToString()}: {ExternalRef}",
                        DocumentType = DocTypeId.ToString(),
                        ApprovalLink = HttpContext.Current.Request.Url.AbsoluteUri,
                        FinalApprover = CurrentUserName + " - " + CurrentUserTitle,
                        UserName = Sender.SenderName,
                        ApprovedDate = DateTime.Now.ToString(),
                        ActionRequired = "Process the related action if needed"
                    };
                    Task.Run(async () => await EmailHelper.SendAsyncByTemplate("APPROVAL_FOLLOWUP_ACTION", modelNotify, to_emails));

                    return;

                }

                    if (string.IsNullOrWhiteSpace(NextApprover[0].Email)) return;

                    object model = new
                    {
                        DocDes = DocumentDescription,
                        DocumentNo = $"{DocTypeId.ToString()}: {ExternalRef}",
                        ApprovalLink = HttpContext.Current.Request.Url.AbsoluteUri,
                        Creator = CurrentUserName + " - " + CurrentUserTitle,
                        UserName = NextApprover[0].ApproverName,
                        CreatedDate = DateTime.Now.ToString()
                    };

                    Task.Run(async () => await EmailHelper.SendAsyncByTemplate("APPROVAL_REQUEST", model, NextApprover[0].Email));
                
            }
            catch { }
        }

        private void SendEmailToSender_Rejected()
        {
            try
            {
                var Sender = ApprovalService.GetCreator(DocId);
                if (string.IsNullOrWhiteSpace(Sender.Email)) return;

                object modelRejectedApproval = new
                {
                    DocumentNo = $"{DocTypeId.ToString()}: {ExternalRef}",
                    RejectReason = hfComment.Value,
                    ApproverName = CurrentUserName + " - " + CurrentUserTitle,
                    UserName = Sender.SenderName,
                    RejectedDate = DateTime.Now.ToString()
                };                

                Task.Run(async () => await EmailHelper.SendAsyncByTemplate("APPROVAL_REJECTED", modelRejectedApproval, Sender.Email));
                return;
            }
            catch { }
        }

        protected void linkSendApproval_Click(object sender, EventArgs e)
        {
            //pre-check before send approval
            var h = CheckBeforeSendApproval();
            if (!h.status)
            {
                SwalInfo(h.message, "warning", "Warning");
                return;
            }

            bool success = SendApproval();
            if (success)
            {
                RaiseStatusChanged(); //trigger event in parent pages
                SendEmailToNextApprover();
            }
        }

        private (bool status, string message) CheckBeforeSendApproval()
        {
            try
            {
                string docname = DocTypeId.ToString();
                string sql = $"EXEC APPROVAL_Pre_SEND_Approval @DocTypeId, @RefNo";
                string er_message = "Approval conditions for this document do not meet";
                DataTable dt = new DataTable();
                try
                {
                    dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql
                        , new List<string>() { "@DocTypeId", "@RefNo" }
                        , new List<object>() { (int)DocTypeId, ExternalRef });

                }
                catch (Exception ex) { er_message = ex.Message; }

                if (dt == null ||  dt.Rows.Count == 0) return (false, er_message);

                if (dt.Rows[0][0].ToString() == "1") return (true, dt.Rows[0][1].ToString());
                else return (false, dt.Rows[0][1].ToString());
            }
            catch (Exception ex) { return (false, ex.Message); }
        }
        protected void linkCancelApproval_Click(object sender, EventArgs e)
        {
            
            CancelApproval();
            RaiseStatusChanged();
        }
        protected void btnActionDocument_Click(object sender, EventArgs e)
        {
            try
            {
                string action = hfAction.Value;
                switch (action)
                {
                    case "approve":
                        ApprovalService.Submit(DocId, CurrentUser, 'A', hfComment.Value);
                        ToggleButtons(true); //refresh approve and reject button                        
                        RaiseStatusChanged(); //notify to parent page trigger postback event to update header
                        SendEmailToNextApprover();
                        break;
                    case "reject":
                        ApprovalService.Submit(DocId, CurrentUser, 'R', hfComment.Value);
                        ToggleButtons(true);                      
                        RaiseStatusChanged();
                        SendEmailToSender_Rejected();
                        break;
                }
            }
            catch { }
        }
    }
}


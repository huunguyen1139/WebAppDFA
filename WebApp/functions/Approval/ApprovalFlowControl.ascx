<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ApprovalFlowControl.ascx.cs" Inherits="WebApp.functions.approval.ApprovalFlowControl" %>
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<%--<div class="card shadow-sm">
  <div class="card-body">--%>

    <!-- ACTION BAR ---------------------------------------------------->
    <%--<div class="d-flex flex-wrap gap-2 mb-3"> wrap to put it inside parent page button group--%>

<asp:UpdatePanel ID="updParent" runat="server" UpdateMode="Always" ChildrenAsTriggers="true">
    <ContentTemplate>
        <!-- Split button -->
        <div class="btn-group">
            <button id="btnAction" runat="server" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown"
                aria-expanded="false">
                Action</button>
            <ul class="dropdown-menu">
                <li>
                    <asp:LinkButton runat="server" ID="linkSendApproval" 
                        OnClick="linkSendApproval_Click" 
                        OnClientClick="return confirmSendNew();" 
                        CssClass="dropdown-item text-primary"
                        >
                        <i class="ti ti-send me-2"></i>
                        Send Approval Request

                    </asp:LinkButton>
                </li>
                <li>
                    <asp:LinkButton runat="server" ID="linkCancelApproval" 
                        OnClick="linkCancelApproval_Click"
                        OnClientClick="return confirmCancelNew();" 
                        CssClass="dropdown-item text-danger"
                        >
                        <i class="ti ti-x me-2"></i>
                        Cancel Approval Request

                    </asp:LinkButton>
                </li>                
                <li>
                    <hr class="dropdown-divider">
                </li>
                <li><a class="dropdown-item" href="javascript:;" data-cmd="template">View Template Step</a></li>
                <li><a class="dropdown-item" href="javascript:;" data-cmd="entry">View Approval History</a></li>
            </ul>
        </div>

        <!-- Approver-only buttons -->
        <button id="btnApprove" runat="server" class="btn btn-success d-none"><i class="ti ti-check me-2"></i>Approve</button>
        <button id="btnReject" runat="server" class="btn btn-danger  d-none"><i class="ti ti-x me-2"></i>Reject</button>
        <asp:Button runat="server" ID="btnActionDocument" CssClass="btn btn-success d-none" Text='Temp' OnClick="btnActionDocument_Click"/>
       
        <%--</div>--%>

        <!-- FLOW TABLE ---------------------------------------------------->
        <div runat="server" id="divShowFlowInstanceSteps" class="table-responsive mt-3">
            <table id="tblFlow" class="table table-bordered table-sm align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width: 40px">#</th>
                        <th>Approver</th>
                        <th>Status</th>
                        <th>Comment</th>
                        <th style="width: 110px">Actions</th>
                    </tr>
                </thead>
                <tbody runat="server" id="flowBody">
                    <%-- rows injected from server – see code-behind --%>
                </tbody>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<%--  </div>
</div>--%>

<!---------------------------------------------------------- MODALS -->
<!-- Template wizard -->
<div class="modal fade" id="mdlTemplate" tabindex="-1" aria-hidden="true">
 <div class="modal-dialog modal-lg modal-dialog-scrollable">
  <div class="modal-content">
   <div class="modal-header">
     <h5 class="modal-title">Approval Template</h5>
     <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
   </div>
   <div class="modal-body">
     <div id="tplList" class="list-group">
       <!-- template steps rendered here -->
     </div>
     <small class="text-muted">Drag rows to re-order, or use the buttons on the right.</small>
   </div>
   <div class="modal-footer">
     <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
   </div>
  </div>
 </div>
</div>

<!-- Instance history -->
<div class="modal fade" id="mdlEntry" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Approval Entry</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <table class="table table-striped table-sm mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Batch</th>
                            <th>#</th>
                            <th>Approver ID</th>
                            <th>Name</th>
                            <th>Status</th>
                            <th>Comment</th>
                            <th>Time</th>
                        </tr>
                    </thead>

                    <tbody id="entryBody"></tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- ========= Template preview (read-only) ====================== -->
<div class="modal fade" id="mdlTemplateView" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Template Steps</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-3">
                <table class="table table-striped table-sm mb-0">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 60px">Seq</th>
                            <th style="width: 120px">Approver ID</th>
                            <th>Name</th>
                            <th>Title</th>
                            <th style="width: 120px">Role</th>
                        </tr>
                    </thead>
                    <tbody id="tmplBody"></tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>



<!-- hidden helpers -->
<asp:HiddenField ID="hfAction"  runat="server" />
<asp:HiddenField ID="hfComment" runat="server" />
<input type="hidden" id="hfDocType"  value="<%= (int)DocTypeId   %>" />
<input type="hidden" id="hfProject"  value="<%= ProjectId   ?? "" %>" />
<input type="hidden" id="hfCreatedBy" value="<%= CurrentUser %>" />

<script>
    // On page load
    document.addEventListener('DOMContentLoaded', attachDropdownMenuHandlers);
    document.addEventListener('DOMContentLoaded', LoadApproveAndRejectButtonEvent);

    // On every ASP.NET UpdatePanel update (partial postback)
    if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            attachDropdownMenuHandlers();
            LoadApproveAndRejectButtonEvent();
        });
    }

    function attachDropdownMenuHandlers() {
        document.querySelectorAll('ul.dropdown-menu a[data-cmd]').forEach(a => {
            // First remove existing click (avoid stacking up handlers)
            a.removeEventListener('click', dropdownMenuHandler, false);
            a.addEventListener('click', dropdownMenuHandler, false);
        });
    }

    function dropdownMenuHandler(e) {
        e.preventDefault();
        const cmd = this.dataset.cmd;
        switch (cmd) {
            case 'send': confirmSend(); break;
            case 'cancel': confirmCancel(); break;
            case 'template': showApproverTemplate(); break;
            case 'entry': showEntry(); break;
        }
    }
       
    /* ---------- Send / Cancel -------------------------------------- */    
    function confirmSendNew() {
        Swal.fire({ title: 'Send for approval?', type: 'question', showCancelButton: true })
            .then(r => {
                if (r.value) {                    
                    __doPostBack('<%= linkSendApproval.UniqueID %>', '');
            }
            });
        return false;
    }  

    function confirmCancelNew() {
        Swal.fire({ title: 'Cancel this approval?', type: 'warning', showCancelButton: true })
            .then(r => {
                if (r.value) {
                    __doPostBack('<%= linkCancelApproval.UniqueID %>', '');
            }
            });
        return false;
    }

    /* ---------- Approve / Reject buttons --------------------------- */
    function LoadApproveAndRejectButtonEvent() {
        const btnApprove = document.getElementById('<%= btnApprove.ClientID %>');
        const btnReject = document.getElementById('<%= btnReject .ClientID %>');

        btnApprove.addEventListener('click', () => askComment('Approve', 'approve'));
        btnReject.addEventListener('click', () => askComment('Reject', 'reject'));
    }

    function askComment(title, cmd) {
        Swal.fire({ title: title + '?' , input: 'textarea', showCancelButton: true, confirmButtonText: title })
            .then(r => {
                debugger;
                if (r.value || r.value == '') {                    
                    document.getElementById('<%= hfComment.ClientID %>').value = r.value || '';
                    document.getElementById('<%= hfAction.ClientID %>').value = cmd;

                    document.getElementById('<%= btnActionDocument.ClientID %>').click();                   
                }

            });
    }    

   
    function showApproverTemplate() {
        debugger;
        const dt = document.getElementById('hfDocType').value;
        const pr = document.getElementById('hfProject').value;
        const cb = document.getElementById('hfCreatedBy').value;

        fetch(`/functions/approval/FlowAjax.aspx?action=template`
            + `&docType=${dt}`
            + `&project=${encodeURIComponent(pr)}`
            + `&createdBy=${encodeURIComponent(cb)}`)
            .then(r => r.json())
            .then(rows => {
                if (!rows.length) {
                    Swal.fire('Info', 'No template found.', 'info');
                    return;
                }
                document.getElementById('tmplBody').innerHTML = rows.map(r => `
                        <tr>
                          <td>${r.Seq}</td>
                          <td>${r.ApproverId || ''}</td>
                          <td>${r.ApproverFullName || ''}</td>
                          <td>${r.ApproverTitle || ''}</td>
                          <td>${r.ApproverRole}</td>
                        </tr>`).join('');

                new bootstrap.Modal('#mdlTemplateView').show();
            })
            .catch(() => {
                Swal.fire('Error', 'Could not load template', 'error');
            });



    }

    /* ---------- Instance entry ------------------------------------- */
    function showEntry() {
        fetch('/functions/approval/FlowAjax.aspx?action=entry&doc=<%= ExternalRef %>')      // tiny handler returns JSON rows
        //fetch(`/functions/approval/FlowAjax.aspx?action=entry&doc=${DocId}`)
            .then(r => r.json())
            .then(data => {
                const body = document.getElementById('entryBody');
                body.innerHTML = data.map((r, i) => `
                    <tr>
                    <td>${r.InstanceId}</td>
                    <td>${r.Seq}</td>
                    <td>${r.ApproverId}</td>
                    <td>${r.ApproverName}</td>
                    <td>${r.StatusName}</td>
                    <td>${r.Comment || ''}</td>
                    <td>${r.ActionOn || ''}</td>
                  </tr>`).join('');

                new bootstrap.Modal('#mdlEntry').show();
            });
    }

    /* ---------- per-row actions (up / down / delete) --------------- */
    document.getElementById('<%= flowBody.ClientID %>').addEventListener('click', e => {
        const btn = e.target.closest('button[data-cmd]');
        if (!btn) return;
        const tr = btn.closest('tr');
        const cmd = btn.dataset.cmd;
        if (cmd === 'del') tr.remove();
        if (cmd === 'up' && tr.previousElementSibling) tr.parentNode.insertBefore(tr, tr.previousElementSibling);
        if (cmd === 'down' && tr.nextElementSibling) tr.parentNode.insertBefore(tr.nextElementSibling, tr);
    });
</script>


<%--function confirmSend() {
    Swal.fire({ title: 'Send for approval?', type: 'question', showCancelButton: true })
        .then(r => {
            if (r.value) {
                __doPostBack('<%= UniqueID %>', 'send');
            }
        });
}
function confirmCancel() {
    Swal.fire({ title: 'Cancel this approval?', type: 'warning', showCancelButton: true })
        .then(r => {
            if (r.value) {
                __doPostBack('<%= UniqueID %>', 'cancel');
          }
      });
  }--%>
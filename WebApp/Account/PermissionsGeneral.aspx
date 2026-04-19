<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="PermissionsGeneral.aspx.cs" Inherits="WebApp.Account.PermissionsGeneral" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.111.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
    <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/dashboards/dashboard4.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
    <!-- Skin Material P -->
    <!-- load sweet alert -->
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>
    <style>
        .mono { font-family: Consolas, Menlo, monospace; }
        .table td, .table th { vertical-align: middle; }
        .w-120 { width: 120px; }
        .nowrap { white-space: nowrap; }

        .users-col {
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Make the GridView's table respect column widths */
.table.table-fixed {
    table-layout: fixed;   /* crucial */
    width: 100%;
}

/* Users column cell */
.users-col-cell {
    width: 400px;          /* enforce max width at the cell level */
    max-width: 400px;
    white-space: normal;   /* allow wrapping */
    word-break: break-word;
    overflow-wrap: anywhere;
}

/* Inner text block (optional, for padding/mono font) */
.users-col-text {
    display: block;
    max-width: 400px;
    font-family: Consolas, Menlo, monospace;
}

    </style>
    
    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>
    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
        <div class="container-fluid">
            <h4 class="mb-3">Permissions Manager</h4>

            <div class="d-flex gap-2 mb-3">
                <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add Permission" OnClick="btnAdd_Click" />
                <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-secondary" Text="Refresh" OnClick="btnRefresh_Click" />
            </div>

            <asp:UpdatePanel ID="upGrid" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="gv" runat="server"
                        AutoGenerateColumns="False"
                        DataKeyNames="PermissionName"
                        CssClass="table table-bordered table-hover table-sm table-striped table-fixed1"
                        OnRowDeleting="gv_RowDeleting" OnRowCommand="gv_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="#" ItemStyle-Width="50px">
                                <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="PermissionName" HeaderText="Permission" />


                            <asp:TemplateField HeaderText="Members (names)">
                                <ItemStyle CssClass="users-col-cell" />
                                <ItemTemplate>
                                    <div class="mono"><%# HttpUtility.HtmlEncode(Eval("MemberNames") as string ?? "") %></div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="MemberCount" HeaderText="Count" ItemStyle-CssClass="text-center nowrap" ItemStyle-Width="70px" />
                            <%--<asp:BoundField DataField="ModifiedAt" HeaderText="Modified" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" ItemStyle-CssClass="nowrap" />
                            <asp:BoundField DataField="ModifiedBy" HeaderText="By" ItemStyle-CssClass="nowrap" />--%>

                            <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="nowrap" ItemStyle-Width="240px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkManage" runat="server" CssClass="btn btn-sm btn-outline-primary me-1"
                                        CommandName="Manage" CommandArgument='<%# Eval("PermissionName") %>'>Manage members</asp:LinkButton>
                                    <asp:LinkButton ID="lnkEdit" runat="server" CssClass="btn btn-sm btn-outline-secondary me-1"
                                        CommandName="EditPerm" CommandArgument='<%# Eval("PermissionName") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton ID="lnkDelete" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                        CommandName="Delete" OnClientClick="return confirm('Delete this permission?');">Delete</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="alert alert-info m-0">No permissions yet. Click <strong>Add Permission</strong> to create one.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:HiddenField ID="hfMode" runat="server" />
            <asp:HiddenField ID="hfPermissionName_Orig" runat="server" />
            <asp:HiddenField ID="hfPermForMembers" runat="server" />
            <!-- Modal -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTitle">Edit Permission</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Permission Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtPermissionName" runat="server" CssClass="form-control" MaxLength="128" />
                            </div>
                            <div class="mb-1">
                                <label class="form-label">Users (EmployeeID;EmployeeID;...)</label>
                                <asp:TextBox ID="txtUsers" runat="server" CssClass="form-control mono" TextMode="MultiLine" Rows="4" />
                                <div class="form-text">Example: <code>1001;1002;1003</code>. (This raw list is optional now—use Manage Members below.)</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSave_Click" />
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Manage Members modal -->
            <div class="modal fade" id="membersModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-xl modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Manage members:
                                <asp:Literal ID="litPermTitle" Text="perm" runat="server" /></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-lg-5">
                                  <label class="form-label">Add employee</label>

                                  <asp:UpdatePanel ID="upAdd" runat="server">
                                    <ContentTemplate>
                                      <div class="input-group mb-2">
                                        <asp:DropDownList ID="ddlEmployees" runat="server" CssClass="form-select select3"
                                            DataTextField="EmployeeName" DataValueField="EmployeeID" AppendDataBoundItems="true">
                                            <asp:ListItem Text="-- Select employee --" Value="" />
                                        </asp:DropDownList>
                                        <asp:Button ID="btnAddSelected" runat="server" CssClass="btn btn-primary"
                                            Text="Add" OnClick="btnAddSelected_Click" />
                                      </div>

                                      <div class="form-check mb-3">
                                        <asp:CheckBox ID="chkShowAll" runat="server" CssClass="form-check-input" AutoPostBack="true"
                                            OnCheckedChanged="chkShowAll_CheckedChanged" />
                                        <label class="form-check-label" for="<%= chkShowAll.ClientID %>">Show all employees (include existing)</label>
                                      </div>
                                    </ContentTemplate>
                                  </asp:UpdatePanel>

                                  <div class="text-muted small">By default, the list excludes employees already in this permission.</div>
                                </div>

                                <div class="col-lg-7">
                                    <label class="form-label">Current members</label>
                                    <asp:UpdatePanel ID="upMembers" runat="server">
                                        <ContentTemplate>
                                            <asp:GridView ID="gvMembers" runat="server" AutoGenerateColumns="False" CssClass="table table-sm table-hover table-bordered h-420"
                                                OnRowCommand="gvMembers_RowCommand">
                                                <Columns>
                                                    <asp:BoundField DataField="EmployeeID" HeaderText="ID" ItemStyle-Width="80px" />
                                                    <asp:BoundField DataField="EmployeeName" HeaderText="Name" />
                                                    <asp:TemplateField ItemStyle-Width="90px" HeaderText="">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnkRemoveEmp" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                                                CommandName="RemoveEmp" CommandArgument='<%# Eval("EmployeeID") %>'
                                                                OnClientClick="return confirm('Remove this member?');">Remove</asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <div class="text-muted">No members yet.</div>
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>
        <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
    <script>
        function openEditModal(mode) { document.getElementById('modalTitle').textContent = (mode === 'add' ? 'Add Permission' : 'Edit Permission'); new bootstrap.Modal(document.getElementById('editModal')).show(); }
        function openMembersModal() { new bootstrap.Modal(document.getElementById('membersModal')).show(); }
    </script>
    <script>
        function showPanel(panelId) {

            var panels = document.querySelectorAll(".panel");
            panels.forEach(function (panel) {
                panel.style.display = "none";
            });
            document.getElementById(panelId).style.display = "block";

            var links = document.querySelectorAll(".sidebar a");
            links.forEach(function (link) {
                link.classList.remove("active");
            });
            event.target.classList.add("active");
        };

        function initializeSelect2(modalid) {
            $('.select3').select2({
                dropdownParent: $(modalid) // Attach dropdown to modal
            });
        }

        // Call it when modal opens
        $('#membersModal').on('shown.bs.modal', function () {
            initializeSelect2('#membersModal');
        });

        $('#assignRoleModalFull').on('shown.bs.modal', function () {
            initializeSelect2('#assignRoleModalFull');
        });

        
    </script>
 
</asp:Content>

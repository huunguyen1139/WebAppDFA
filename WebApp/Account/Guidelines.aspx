<%@ Page EnableEventValidation="false" Title="System Guideline library" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="Guidelines.aspx.cs" Inherits="WebApplication2.Account.Guidelines" %>

    <asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />

    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
   
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>

    <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
 <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
 <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

    <%-- select 2 --%>
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>


    <%-- load sweet alert --%>
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />
    <style>
        /* Keep iframes responsive in the preview modal */
        .viewer-iframe {
            width: 100%;
            height: 70vh;
            border: 0;
        }

        .card-icon {
            font-size: 2rem;
        }

        .tag {
            font-size: .75rem;
            margin-right: .25rem;
        }

        .truncate-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>

    <script>
        // Stop whatever is in the iframe when the modal closes
        function StopYoutubeInBacground () {
            const modalEl = document.getElementById('viewerModal');
            modalEl.addEventListener('hidden.bs.modal', function () {
                const f = document.getElementById('viewerFrame');
                if (!f) return;
                // kill playback
                f.src = 'about:blank';
            });
        };

        // Toggle upload inputs based on media type selection
        function AddEventToDDLMediaType() {
            const ddl = document.getElementById('<%= ddlMediaTypeUpload.ClientID %>');
            const fileRow = document.getElementById('fileRow');
            const ytRow = document.getElementById('ytRow');
            function apply() {
                if (ddl.value === 'YouTube') { fileRow.classList.add('d-none'); ytRow.classList.remove('d-none'); }
                else { fileRow.classList.remove('d-none'); ytRow.classList.add('d-none'); }
            }
            ddl.addEventListener('change', apply); apply();
        };


        // Delete with SweetAlert2 confirm then postback to hidden button
        function bindDeleteButtons() {
            document.querySelectorAll(".del-btn").forEach(function (btn) {
                btn.addEventListener("click", function (e) {
                    debugger;          
                    const id1 = btn.getAttribute('commandargument');
                    const id = btn.dataset.gid || btn.getAttribute('data-gid');
                Swal.fire({
                    title: 'Delete this item?' + id,
                    text: 'This action cannot be undone.',
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, delete it',
                    cancelButtonText: 'Cancel'
                }).then(res => {
                    if (res.value) {
                        __doPostBack('<%= btnDeleteServer.UniqueID %>', id);
                    }
                });
                });
            });
        }

        // Show preview in modal (called from server via RegisterStartupScript)
        function openPreview(url) {
            document.getElementById('viewerFrame').src = url;
            const m = new bootstrap.Modal(document.getElementById('viewerModal'));
            m.show();
        }


        function clearUploadForm() {
            document.getElementById('<%= tbTitle.ClientID %>').value = '';
            document.getElementById('<%= tbDescription.ClientID %>').value = '';
            document.getElementById('<%= tbTags.ClientID %>').value = '';
            document.getElementById('<%= tbYouTubeUrl.ClientID %>').value = '';
        }

        document.addEventListener("DOMContentLoaded", function () {            
            bindDeleteButtons();
            AddEventToDDLMediaType();
            StopYoutubeInBacground();
        });
    </script>

    <%--<asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>--%>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="mb-0">System Guideline Library</h2>
                        <asp:Literal runat="server" ID="ltAdminBadge"></asp:Literal>
                    </div>
                    <!-- Upload (admins only) -->
                    <asp:Panel runat="server" ID="pnlUpload" Visible="false" CssClass="card shadow-sm mb-4">
                        <div class="card-body">
                            <h5 class="card-title mb-3"><i class="bi bi-cloud-upload"></i>Upload / Add Guideline</h5>


                            <div class="row g-3">
                                <!-- Title -->
                                <div class="col-md-6">
                                    <label class="form-label">Title <span class="text-danger">*</span></label>
                                    <asp:TextBox runat="server" ID="tbTitle" CssClass="form-control" MaxLength="200" />
                                </div>


                                <!-- Category -->
                                <div class="col-md-3">
                                    <label class="form-label">Category</label>
                                    <asp:DropDownList runat="server" ID="ddlCategory" CssClass="form-select"></asp:DropDownList>
                                </div>


                                <!-- Media Type -->
                                <div class="col-md-3">
                                    <label class="form-label">Media Type</label>
                                    <asp:DropDownList runat="server" ID="ddlMediaTypeUpload" CssClass="form-select">
                                        <asp:ListItem Text="File" Value="File" Selected="True" />
                                        <asp:ListItem Text="YouTube" Value="YouTube" />
                                    </asp:DropDownList>
                                </div>


                                <!-- Description -->
                                <div class="col-12">
                                    <label class="form-label">Description</label>
                                    <asp:TextBox runat="server" ID="tbDescription" TextMode="MultiLine" Rows="2" CssClass="form-control" />
                                </div>


                                <!-- File Upload (allows multiple) -->
                                <div class="col-md-6" id="fileRow">
                                    <label class="form-label">Upload File (PDF/DOCX/PPTX/XLSX) <span class="text-muted">Max 50MB</span></label>
                                    <asp:FileUpload runat="server" ID="fuFiles" CssClass="form-control" AllowMultiple="true" />
                                </div>


                                <!-- YouTube URL -->
                                <div class="col-md-6 d-none" id="ytRow">
                                    <label class="form-label">YouTube URL</label>
                                    <asp:TextBox runat="server" ID="tbYouTubeUrl" CssClass="form-control" Placeholder="https://www.youtube.com/watch?v=..." />
                                </div>


                                <!-- Tags -->
                                <div class="col-md-6">
                                    <label class="form-label">Tags (comma separated)</label>
                                    <asp:TextBox runat="server" ID="tbTags" CssClass="form-control" />
                                </div>


                                <!-- Actions -->
                                <div class="col-12 d-flex gap-2">
                                    <asp:Button runat="server" ID="btnUpload" CssClass="btn btn-primary" Text="Save" OnClick="btnUpload_Click" />
                                    <button type="button" class="btn btn-outline-secondary" onclick="clearUploadForm()">Clear</button>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- Filters -->
                    <div class="card shadow-sm mb-3">
                        <div class="card-body">
                            <div class="row g-2 align-items-end">
                                <div class="col-md-4">
                                    <label class="form-label">Keyword</label>
                                    <asp:TextBox runat="server" ID="tbKeyword" CssClass="form-control" Placeholder="Search title, description, tags..." />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Category</label>
                                    <asp:DropDownList runat="server" ID="ddlCategoryFilter" CssClass="form-select"></asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Type</label>
                                    <asp:DropDownList runat="server" ID="ddlTypeFilter" CssClass="form-select">
                                        <asp:ListItem Text="All" Value="" Selected="True" />
                                        <asp:ListItem Text="File" Value="File" />
                                        <asp:ListItem Text="YouTube" Value="YouTube" />
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2 d-grid">
                                    <asp:Button runat="server" ID="btnSearch" CssClass="btn btn-dark" Text="Search" OnClick="btnSearch_Click" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Library Grid (Card layout) -->
                    <asp:Repeater runat="server" ID="rptItems" OnItemCommand="rptItems_ItemCommand">
                        <HeaderTemplate>
                            <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-3">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="col">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-body d-flex flex-column">
                                        <!-- Icon + Title -->
                                        <div class="d-flex align-items-start gap-2 mb-2">
                                            <i class="bi <%# GetIconCss(Eval("MediaType"), Eval("FileExt")) %> card-icon"></i>
                                            <div class="flex-grow-1">
                                                <h6 class="mb-0"><%# HttpUtility.HtmlEncode(Eval("Title")) %></h6>
                                                <small class="text-muted"><%# Eval("CategoryName") %></small>
                                            </div>
                                            <asp:Label runat="server" Visible='<%# CanManage %>' CssClass="badge bg-secondary" Text='<%# (Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Hidden") %>'></asp:Label>
                                        </div>


                                        <!-- Description -->
                                        <p class="text-secondary small truncate-2"><%# HttpUtility.HtmlEncode(Eval("Description")) %></p>


                                        <!-- Tags -->
                                        <div class="mb-3">
                                            <%# RenderTags(Eval("Tags")) %>
                                        </div>


                                        <div class="mt-auto d-flex gap-2">
                                            <!-- View button opens modal or new tab based on type -->
                                            <asp:LinkButton runat="server" ID="btnView" CssClass="btn btn-outline-primary btn-sm" CommandName="view" CommandArgument='<%# Eval("GuidelineId") %>'>
                                            <i class="bi bi-eye"></i> View
                                            </asp:LinkButton>


                                            <!-- Download only for files -->
                                            <asp:LinkButton runat="server" ID="btnDownload" CssClass="btn btn-outline-secondary btn-sm" CommandName="download" CommandArgument='<%# Eval("GuidelineId") %>' Visible='<%# IsFileMedia(Eval("MediaType")) %>'>
                                            <i class="bi bi-download"></i> Download
                                            </asp:LinkButton>


                                            <!-- Admin actions -->
                                            <asp:LinkButton runat="server" ID="btnToggle" Visible='<%# CanManage %>' CssClass="btn btn-outline-warning btn-sm" CommandName="toggle" CommandArgument='<%# Eval("GuidelineId") + "|" + Eval("IsActive") %>'>
                                            <i class="bi bi-toggle2-on"></i> Show/Hide
                                            </asp:LinkButton>
                                            <asp:LinkButton runat="server" ID="btnDelete" Visible='<%# CanManage %>' CssClass="btn btn-outline-danger btn-sm del-btn" OnClientClick="return false;" CommandArgument='<%# Eval("GuidelineId") %>' data-gid='<%# Eval("GuidelineId") %>'>
                                                <i class="bi bi-trash"></i> Delete
                                                </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                    <!-- Pagination -->
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <asp:Literal runat="server" ID="ltResultInfo" />
                        <nav>
                            <ul class="pagination pagination-sm mb-0">
                                <asp:PlaceHolder runat="server" ID="phPager"></asp:PlaceHolder>
                            </ul>
                        </nav>
                    </div>

                    <!-- Hidden server buttons for JS-triggered actions -->
                    <asp:Button runat="server" ID="btnDeleteServer" CssClass="d-none" OnClick="btnDeleteServer_Click" />


                    <!-- Preview Modal -->
                    <div class="modal fade" id="viewerModal" tabindex="-1">
                        <div class="modal-dialog modal-xl modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Preview</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body p-0">
                                    <iframe id="viewerFrame" class="viewer-iframe" allowfullscreen></iframe>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
       <%-- </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

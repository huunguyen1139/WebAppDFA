<%@ Page Title="Purchase Requisition List" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="PRList.aspx.cs" Inherits="WebApp.Purchase.PRList" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
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


    <!-- select 2 -->
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>

    <!-- Export to Excel -->
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/jszip.min.js"></script>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/FileSaver.min.js"></script>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/excel-gen.js"></script>

    <!-- load sweet alert -->
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <!-- Bootstrap -->
    <!-- Modal Popup -->
    <div id="divModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="ModalHeader" class="modal-header modal-colored-header text-white">
                    <h4 class="modal-title" id="warning-header-modalLabel">Modal Heading
                    </h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="modal-message">
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ShowPopup(title, body, class_style) {

            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").classList.add(class_style);
        }
    </script>
    <!-- Modal Popup -->

    <asp:Button ID="btnCreatePRHidden"
        runat="server"
        Text="Create PR"
        OnClick="btnCreatePRHidden_Click"
        Style="display: none;" />


    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body">
                            <h4 id="txtDesciptionHeader" runat="server" class="card-title mb-0 text-dark">Purchase Requisition</h4>
                        </div>
                        <div class="card-body shadow-sm table-responsive ">
                            <div class="d-flex justify-content-end mb-2">
                                <button type="button" class="btn btn-primary" onclick="triggerCreatePR();">
                                    Create New PR
                                </button>
                            </div>

                            <div class="row mx-0 mb-2">
                                <div class="col-md-12 px-0">
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline"
                                        ID="cbPurpose" Checked="true" Text="Purpose"
                                        AutoPostBack="True" OnCheckedChanged="cbPurpose_CheckedChanged" />

                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline"
                                        ID="cbDepartment" Checked="true" Text="Department"
                                        AutoPostBack="True" OnCheckedChanged="cbDepartment_CheckedChanged" />

                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline"
                                        ID="cbRequester" Checked="true" Text="Requester"
                                        AutoPostBack="True" OnCheckedChanged="cbRequester_CheckedChanged" />

                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline"
                                        ID="cbType" Checked="true" Text="Req Type"
                                        AutoPostBack="True" OnCheckedChanged="cbType_CheckedChanged" />

                                </div>
                            </div>
                            <dx:ASPxGridView ID="gridPR" CssClass="" EnablePagingGestures="False" runat="server" Width="100%" AutoGenerateColumns="True"
                                OnHtmlDataCellPrepared="gridPR_HtmlDataCellPrepared">
                                <%--<Settings HorizontalScrollBarMode="Auto" />--%>
                                <Toolbars>
                                    <dx:GridViewToolbar>
                                        <Items>
                                            <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to Excel" />
                                            <dx:GridViewToolbarItem Command="ExportToCsv" Text="Export to CSV" />
                                            <dx:GridViewToolbarItem Command="ExportToPdf" Text="Export to PDF" />
                                            <dx:GridViewToolbarItem Command="Refresh" Text="Refresh" />
                                        </Items>
                                    </dx:GridViewToolbar>
                                </Toolbars>
                                <Settings ShowFooter="true" ShowHeaderFilterButton="true" />
                                <SettingsExport EnableClientSideExportAPI="true" />
                                <Settings ShowFooter="true" ShowGroupPanel="true" />
                                <SettingsContextMenu Enabled="false">
                                    <RowMenuItemVisibility ExportMenu-Visible="false" />
                                </SettingsContextMenu>
                                <SettingsDataSecurity AllowDelete="False" AllowInsert="False"></SettingsDataSecurity>

                                <SettingsSearchPanel Visible="True"></SettingsSearchPanel>
                                <Styles>
                                    <AlternatingRow Enabled="true" />
                                </Styles>
                                <SettingsBehavior AllowFocusedRow="false" />
                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="RequisitionNo" SummaryType="Count" />
                                </TotalSummary>
                            </dx:ASPxGridView>

                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>

    </asp:UpdatePanel>
    <script type="text/javascript">
        function triggerCreatePR() {
            // Trigger server-side click of hidden ASP.NET button
            document.getElementById('<%= btnCreatePRHidden.ClientID %>').click();
        }

        function showCreatePRSuccess(prNo) {
            var url = "PurchaseRequisition?OrderNo=" + encodeURIComponent(prNo);

            Swal.fire({
                icon: 'success',
                title: 'Created successfully',
                html:
                    "PR No: <b>" + prNo + "</b><br/>" +
                    "<a href='" + url + "' target='_blank' rel='noopener'>Open PR card in new tab</a>",
                confirmButtonText: 'Close'
            });
        }

        function showCreatePRError(msg) {
            Swal.fire({
                icon: 'error',
                title: 'Add New PR',
                text: msg || 'Cannot create new PR.'
            });
        }
    </script>

    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>
            <div class="modal1">
                <div class="center1">
                    <img alt="" src="images/loader4.gif" />
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

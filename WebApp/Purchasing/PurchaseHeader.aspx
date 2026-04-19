<%@ Page Title="Purchase Order" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="PurchaseHeader.aspx.cs" Inherits="WebApp.purchase.PurchaseHeader" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%-- Skin Maretial P --%>
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <%-- Import Js Files --%>
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
    <%-- solar icons --%>
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
    <%-- Skin Material P --%>


    <%-- select 2 --%>
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>


    <%-- load sweet alert --%>
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <%-- Bootstrap --%>
    <%-- Modal Popup --%>
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
    <%-- Modal Popup --%>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Bootstrap 5 tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (el) {
                new bootstrap.Tooltip(el);
            });
        });
    </script>

    <style>
        /* ===============================
           DEVEXPRESS READ-ONLY HEADER FIX
           =============================== */

        .header-readonly .dxeTextBox,
        .header-readonly .dxeTextBoxSys,
        .header-readonly .dxeButtonEdit,
        .header-readonly .dxeButtonEditSys,
        .header-readonly .dxeDateEdit,
        .header-readonly .dxeMemo {
            background-color: #f5f5f5 !important;
            border-color: #dcdcdc !important;
        }

        /* IMPORTANT: actual input/textarea area */
        .header-readonly .dxeEditArea,
        .header-readonly .dxeEditAreaSys,
        .header-readonly .dxeMemoEditArea,
        .header-readonly input[type="text"],
        .header-readonly textarea {
            background-color: #f5f5f5 !important;
            border: none !important;
            color: #212529;
        }

        /* Ensure full height fill */
        .header-readonly .dxeEditArea,
        .header-readonly input[type="text"] {
            height: 100% !important;
        }

            /* Remove focus/hover glow */
            .header-readonly .dxeEditArea:focus,
            .header-readonly .dxeEditArea:hover,
            .header-readonly input:focus,
            .header-readonly textarea:focus {
                box-shadow: none !important;
                outline: none !important;
            }

        /* Calendar / dropdown button (DateEdit) */
        .header-readonly .dxeButtonEditButton,
        .header-readonly .dxeCalendarButton {
            background-color: #f5f5f5 !important;
            border-left: 1px solid #dcdcdc !important;
            pointer-events: none;
        }

        /* Cursor behavior */
        .header-readonly input,
        .header-readonly textarea {
            cursor: default;
        }
    </style>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">

                    <div class="mb-3">
                        <h3 class="mb-1">
                            <asp:Literal ID="lblTitle" runat="server" Text=""></asp:Literal>
                        </h3>
                        <asp:Label ID="Label1" runat="server"
                            CssClass="text-muted small"></asp:Label>
                    </div>

                    <asp:Label ID="lblHeaderInfo" runat="server" CssClass="text-muted"></asp:Label>

                    <%-- HEADER --%>
                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body">
                            <a href="javascript:;" data-bs-toggle="collapse" data-bs-target="#collapseHeader">
                                <h4 id="txtDesciptionHeader" runat="server" class="card-title mb-0 text-dark">Thông tin chung</h4>
                            </a>
                        </div>                        
                        <div id="collapseHeader" class="collapse show">
                            <div class="shadow-sm table-responsive header-readonly">
                                
                                <dx:ASPxFormLayout ID="flHeader" runat="server" Width="100%">
                                    <Items>
                                        <%-- ===================== LEFT SIDE ===================== --%>
                                        <dx:LayoutGroup Caption="" ColCount="2" GroupBoxDecoration="None">
                                            <Items>

                                                <%--  LEFT COLUMN --%>
                                                <dx:LayoutGroup Caption="" GroupBoxDecoration="None">
                                                    <Items>

                                                        <%-- Buy-from Vendor No. --%>
                                                        <dx:LayoutItem Caption="Buy-from Vendor No.">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtVendorNo" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Buy-from Vendor Name --%>
                                                        <dx:LayoutItem Caption="Buy-from Vendor Name">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtVendorName" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Buy-from Contact --%>
                                                        <dx:LayoutItem Caption="Buy-from Contact">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtContact" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Posting Date --%>
                                                        <%--<dx:LayoutItem Caption="Posting Date">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxDateEdit ID="dePostingDate" runat="server" Width="100%" ReadOnly="true"
                                                                        DisplayFormatString="dd/MM/yyyy" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>--%>

                                                        <%-- Order Date --%>
                                                        <dx:LayoutItem Caption="Order Date">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxDateEdit ID="deOrderDate" runat="server" Width="100%" ReadOnly="true"
                                                                        DisplayFormatString="dd/MM/yyyy" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Document Date --%>
                                                        <%--<dx:LayoutItem Caption="Document Date">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxDateEdit ID="deDocumentDate" runat="server" Width="100%" ReadOnly="true"
                                                                        DisplayFormatString="dd/MM/yyyy" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>--%>

                                                        <%-- Ghi chú = Posting Description --%>
                                                        <dx:LayoutItem Caption="Ghi chu">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtPostingDescription" runat="server"
                                                                        Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Thỏa thuận khác = Your Reference --%>
                                                        <dx:LayoutItem Caption="Thoa thuan khac">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxMemo ID="txtYourReference" runat="server"
                                                                        Width="100%" Height="65px" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                    </Items>
                                                </dx:LayoutGroup>

                                                <%-- ===================== RIGHT COLUMN ===================== --%>
                                                <dx:LayoutGroup Caption="" GroupBoxDecoration="None">
                                                    <Items>

                                                        <%-- Ma HD --%>
                                                        <%--<dx:LayoutItem Caption="Ma HD">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtContractNo" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>--%>

                                                        <%-- Ky hieu mau HD --%>
                                                        <%--<dx:LayoutItem Caption="Ky hieu mau HD">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtDocumentSymbol" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>--%>

                                                        <%-- Vendor Invoice No. --%>
                                                        <dx:LayoutItem Caption="Vendor Invoice No.">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtVendorInvoiceNo" runat="server" Width="100%" ReadOnly="false" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- VAT Description --%>
                                                        <dx:LayoutItem Caption="VAT Description">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtVATDescription" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Purchaser Code --%>
                                                        <dx:LayoutItem Caption="Purchaser Code">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtPurchaserCode" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Project Code = Shortcut Dimension 1 Code --%>
                                                        <dx:LayoutItem Caption="Project Code">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtProjectCode" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Cost Element = Shortcut Dimension 2 Code --%>
                                                        <dx:LayoutItem Caption="Cost Element">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtCostElement" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <%-- Status --%>
                                                        <dx:LayoutItem Caption="Status">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtStatus" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                    </Items>
                                                </dx:LayoutGroup>

                                            </Items>
                                        </dx:LayoutGroup>

                                    </Items>
                                </dx:ASPxFormLayout>


                            </div>
                        </div>
                    </div>
                    
                    <%--Button group--%>
                    <div class="button-group mb-1">
                        <button type="button" runat="server" id="btnDeleteFocusRow" class="mx-0 btn btn-danger"                            
                            style="border-radius: 5px; float: right;">
                            <i class="ti ti-trash fs-4 me-2"></i>Delete Order
                        </button>                       
                                               

                        <button type="button" runat="server" id="btnExportToExel" class="btn btn-dark" onclick="grid.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px; float: right;">
                            <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                        </button>

                        <!--------- APPROVAL CUSTOM CONTROL --------------------------->
                        <uc:ApprovalFlow ID="ApprovalFlow1" runat="server" OnStatusChanged="ApprovalFlow1_StatusChanged" />
                    </div>

                    <%-- LINES --%>
                    <div class="card">                        
                        <div class="border-bottom title-part-padding bg-body">
                            <a href="javascript:;" data-bs-toggle="collapse" data-bs-target="#collapseLines">
                                <h4 id="H2" runat="server" class="card-title mb-0 text-dark">Thông tin chi tiết</h4>
                            </a>
                        </div>  
                        <div id="collapseLines" class="collapse show">
                            <div class="card-body shadow-sm table-responsive">                               
                               <div class="row mx-0 mb-2">
                                    <div class="col-md-12 px-0">
                                        <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbCost" Checked="false" Text="Khoản mục CP" OnCheckedChanged="cb_CheckedChanged" AutoPostBack="True" />
                                        <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbRequestRef" Text="Phiếu yêu cầu" OnCheckedChanged="cb_CheckedChanged" AutoPostBack="True" />
                                        <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbRemark" Checked="false" Text="Ghi chú" OnCheckedChanged="cb_CheckedChanged" AutoPostBack="True" />
                                        <%--<asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbLastUpdateInfo" Checked="false" Text="Last updated user and datetime" OnCheckedChanged="" AutoPostBack="True" />--%>

                                    </div>
                                </div>
                                <dx:ASPxGridView ID="gvLines" runat="server" KeyFieldName="LineNo" AutoGenerateColumns="False"
                                     OnCustomColumnDisplayText="gvLines_CustomColumnDisplayText" OnHtmlDataCellPrepared="gvLines_HtmlDataCellPrepared">
                                    <SettingsPager PageSize="20" />
                                     <SettingsDataSecurity AllowDelete="False" AllowInsert="False"></SettingsDataSecurity>

                                     <SettingsSearchPanel Visible="True"></SettingsSearchPanel>
                                     <Styles>
                                         <AlternatingRow Enabled="true" />
                                     </Styles>
                                     <SettingsBehavior AllowFocusedRow="false" />
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="Type" Caption="Loại" Width="80px" />

                                        <dx:GridViewDataTextColumn FieldName="No_" Caption="Mã" Width="140px" />

                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Diễn giải" Width="300px" />

                                        <dx:GridViewDataTextColumn FieldName="Note" Caption="Ghi chú" Width="260px" />

                                        <dx:GridViewDataTextColumn FieldName="Quantity"
                                            Caption="Số lượng" Width="90px">
                                            <PropertiesTextEdit DisplayFormatString="#,0.###" />
                                            <CellStyle HorizontalAlign="Right" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="UnitOfMeasureCode" Caption="Đơn vị" Width="100px" />

                                        <dx:GridViewDataTextColumn FieldName="DirectUnitCost"
                                            Caption="Đơn giá" Width="120px">
                                            <PropertiesTextEdit DisplayFormatString="#,0.###" />
                                            <CellStyle HorizontalAlign="Right" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="Amount" Caption="Thành tiền" Width="120px">
                                            <PropertiesTextEdit DisplayFormatString="#,0" />
                                            <CellStyle HorizontalAlign="Right" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="AmountInclVAT"
                                            Caption="Thành tiền (gồm VAT)" Width="160px">
                                            <PropertiesTextEdit DisplayFormatString="#,0" />
                                            <CellStyle HorizontalAlign="Right" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="VAT" Caption="VAT%" Width="80px" />
                                        <dx:GridViewDataTextColumn FieldName="ProjectCode" Caption="Mã dự án" Width="120px" />
                                        <dx:GridViewDataTextColumn FieldName="CostElement" Caption="Khoản mục" Width="120px" />
                                        <dx:GridViewDataTextColumn FieldName="SubRequestNo" Caption="Số YCTP" Width="150px" />
                                        <dx:GridViewDataTextColumn FieldName="PRNo" Caption="Số YCMH" Width="150px" />
                                    </Columns>
                                </dx:ASPxGridView>

                                <div class="card-footer">

                                    <div class="row justify-content-end">
                                        <div class="col-auto text-end">
                                            <div class="fw-semibold">Total Excl. VAT (<asp:Label ID="lblCurrency1" runat="server" Text="VND" />)</div>
                                            <div class="fw-semibold">Total VAT (<asp:Label ID="lblCurrency2" runat="server" Text="VND" />)</div>
                                            <div class="fw-bold mt-1">Total Incl. VAT (<asp:Label ID="lblCurrency3" runat="server" Text="VND" />)</div>
                                        </div>

                                        <div class="col-2 text-end">
                                            <asp:Label ID="lblTotalExclVat" runat="server" CssClass="fw-semibold d-block"></asp:Label>
                                            <asp:Label ID="lblTotalVat" runat="server" CssClass="fw-semibold d-block"></asp:Label>
                                            <asp:Label ID="lblTotalInclVat" runat="server" CssClass="fw-bold d-block mt-1"></asp:Label>
                                        </div>
                                    </div>

                                </div>


                            </div>
                        </div>
                    </div>

                    <script type="text/javascript">
                        function fm_CustomCommand(s, e) {
                            if (e.commandName !== "DownloadFolderZip") return;
                            debugger;
                            var items = s.GetSelectedItems(); // selected items in file area
                            if (!items || items.length !== 1 || !items[0].isFolder) {
                                alert("Please select exactly one folder.");
                                return;
                            }

                            // Send folder key/name to server
                            s.PerformCallback("zip|" + encodeURIComponent(items[0].id));
                        }

                        function fm_EndCallback(s, e) {
                            // Server returns token in cpZipToken, then we download via handler
                            if (s.cpZipToken) {
                                var t = s.cpZipToken;
                                s.cpZipToken = null;
                                window.location = "/DownloadFolderZip.ashx?t=" + encodeURIComponent(t);
                            }
                        }
                    </script>
                    <%--file explore--%>
                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body">
                            <h4 id="H1" runat="server" class="card-title mb-0 text-dark">Order Files Explorer</h4>
                        </div>
                        <div class="card-body">
                            <dx:ASPxFileManager ID="ASPxFileManager1" runat="server" Width="100%" OnCustomCallback="ASPxFileManager1_CustomCallback">
                                <Settings RootFolder="" ThumbnailFolder="~/Thumb/" />
                                <SettingsEditing AllowCopy="False" AllowCreate="False" AllowDelete="False" AllowDownload="True" AllowMove="False" AllowRename="False" />
                                <SettingsFolders EnableCallBacks="True" />
                                <SettingsUpload Enabled="true">
                                    <AdvancedModeSettings EnableMultiSelect="true" EnableDragAndDrop="true">
                                    </AdvancedModeSettings>
                                    <ValidationSettings MaxFileSize="1048576000" MaxFileSizeErrorText="File too large. It must be < 1GB"></ValidationSettings>
                                </SettingsUpload>
                                <SettingsFileList ShowFolders="true" ShowParentFolder="true" View="Details">
                                    <DetailsViewSettings>
                                        <Columns>
                                            <dx:FileManagerDetailsColumn FileInfoType="Thumbnail" />
                                            <dx:FileManagerDetailsColumn FileInfoType="FileName" />
                                            <dx:FileManagerDetailsColumn FileInfoType="Size" />
                                            <dx:FileManagerDetailsColumn FileInfoType="LastWriteTime" />
                                        </Columns>
                                    </DetailsViewSettings>
                                </SettingsFileList>
                                
                                <SettingsContextMenu Enabled="true">
                                    <Items>
                                        <dx:FileManagerToolbarCreateButton></dx:FileManagerToolbarCreateButton>
                                        <dx:FileManagerToolbarRenameButton></dx:FileManagerToolbarRenameButton>
                                        <dx:FileManagerToolbarMoveButton></dx:FileManagerToolbarMoveButton>
                                        <dx:FileManagerToolbarCopyButton></dx:FileManagerToolbarCopyButton>
                                        <dx:FileManagerToolbarDeleteButton></dx:FileManagerToolbarDeleteButton>
                                        <dx:FileManagerToolbarRefreshButton></dx:FileManagerToolbarRefreshButton>
                                        <dx:FileManagerToolbarDownloadButton></dx:FileManagerToolbarDownloadButton>
                                        
                                        <dx:FileManagerToolbarCustomButton CommandName="DownloadFolderZip" Text="Download Folder Zip"></dx:FileManagerToolbarCustomButton>
                                                                                
                                    </Items>
                                </SettingsContextMenu>
                                <ClientSideEvents CustomCommand="fm_CustomCommand" EndCallback="fm_EndCallback" />

                            </dx:ASPxFileManager>

                            
                        </div>
                    </div>

                    <%--COMMENT--%>
                    <uc:Comment runat="server" ID="commentSection" DocumentID="" /> 
                </div>
            </div>
        </ContentTemplate>

    </asp:UpdatePanel>
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

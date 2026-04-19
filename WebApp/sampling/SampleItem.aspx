<%@ Page Title="Sample Item List" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="SampleItem.aspx.cs" Inherits="WebApp.sampling.SampleItem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>

    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.css" />
    <!-- Import Js Files -->
    <script src="/masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <%--<script src="/masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

    <%-- select 2 --%>
    <link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="/masterskin/monster/dist/select2/select2.min.js"></script>

     <!-- script call server-side for popup detail -->
     <script type="text/javascript">

         function showDetailPopup(link, key) {
             debugger;
             popRemark.ShowAtElement(link);
             callbackPanel.PerformCallback(key);
         }

         function showLightbox(src) {           
             document.getElementById("lightboxImage").src = src;
             var modal = new bootstrap.Modal(document.getElementById('lightboxModal'));
             modal.show();
         }

         function gvItemsEndCallBack(s, e) {
                         
             if (s.cpError) {
                 Swal.fire({
                     type: 'error',
                     title: 'Update Failed',
                     text: s.cpError
                 });
                 s.cpError = null; // clear so not shown again
             }
             if (s.cpSuccess) {
                 Swal.fire({
                     type: 'success',
                     title: 'Updated Succesfully',
                     text: s.cpError
                 });
                 s.cpSuccess = null; // clear so not shown again
             }
         }
     </script>
 
    <%-- load sweet alert --%>
    <script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h3>Create Sample and Special Order</h3>
                    <!-- ======================================================= -->
                    <div class="mb-4">
                        <!-- ==================== BUTTON GROUP ========================= -->
                        <div class="button-group">
                            <dx:ASPxButton ID="btnAddNewItem" runat="server" Text="Add New Item"
                                AutoPostBack="false" Style="border-radius: 5px; float: right;"
                                ClientSideEvents-Click="function(){ pcItemAdd.Show(); }"
                                CssClass="btn btn-sm btn-success mb-2" />

                            <button id="MainContent_btnExportToExel" type="button" class="btn btn-dark" onclick="gvItems.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px; float: right;">
                                <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                            </button>
                        </div>

                        <!-- ==================== GRID ITEM========================= -->
                        <dx:ASPxGridView ID="gvItems" runat="server" Width="100%" ClientInstanceName="gvItems" AutoGenerateColumns="False"
                            KeyFieldName="No_" OnInitNewRow="gvItems_InitNewRow"
                            OnCellEditorInitialize="gvItems_CellEditorInitialize"
                            OnRowUpdating="gvItems_RowUpdating"
                            OnCustomJSProperties="gvItems_CustomJSProperties"
                            >

                            <SettingsExport EnableClientSideExportAPI="true"></SettingsExport>
                            <SettingsBehavior ConfirmDelete="True" AllowFocusedRow="True" />
                            <SettingsPager PageSize="20" />
                            <SettingsPopup EditForm-Modal="True" />
                            <SettingsEditing Mode="EditFormAndDisplayRow" EditFormColumnCount="2" UseFormLayout="True" PopupEditFormWidth="700" />
                            <Styles Table-CssClass="text-nowrap" FocusedRow-CssClass="bg-secondary"></Styles>
                            <Columns>
                                <dx:GridViewCommandColumn ShowEditButton="true"></dx:GridViewCommandColumn>

                                <dx:GridViewDataTextColumn FieldName="No_" Caption="Item No." Width="130" ReadOnly="true" />
                                <dx:GridViewDataTextColumn Visible="false" EditFormSettings-Visible="True" EditFormSettings-VisibleIndex="2" FieldName="ItemNo2" Caption="Item No. 2" Width="130" />
                                <dx:GridViewDataColumn Caption="Image" VisibleIndex="2">
                                    <EditFormSettings Visible="False" />
                                    <DataItemTemplate>
                                        <img src='<%# Eval("ImageUrl") %>'
                                            width="100" height="60"
                                            onclick='showLightbox("<%#  Eval("ImageUrl") %>")'
                                            onerror="this.onerror=null;this.src='/images/noproduct1.png';" />
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>

                                <dx:GridViewDataMemoColumn FieldName="FullName" Caption="Full Name" Width="230" PropertiesMemoEdit-Rows="6" />
                                <dx:GridViewDataMemoColumn EditFormSettings-Visible="True" EditFormSettings-VisibleIndex="4" FieldName="FullRemark" Caption="Full Remark" Visible="False" PropertiesMemoEdit-Rows="6" />

                                <dx:GridViewDataTextColumn EditFormSettings-Visible="False" Caption="Remark" Width="180" UnboundType="String">
                                    <DataItemTemplate>
                                        <a href="javascript:void(0);" class="btn btn-link"
                                            onclick="showDetailPopup(this, '<%# Eval("No_") %>')">Show detail...</a>
                                    </DataItemTemplate>
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataComboBoxColumn FieldName="UOM" Caption="UOM" Width="70">
                                    <PropertiesComboBox></PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>

                                <dx:GridViewDataSpinEditColumn FieldName="Length" Caption="Length (mm)" Width="100">
                                    <PropertiesSpinEdit NumberType="Float" NumberFormat="Number"
                                        DisplayFormatString="#,##0.###"
                                        DisplayFormatInEditMode="true"
                                        DecimalPlaces="2"
                                        NullDisplayText="0">
                                    </PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>

                                <dx:GridViewDataSpinEditColumn FieldName="Width" Caption="Width (mm)" Width="100">
                                    <PropertiesSpinEdit NumberType="Float" DecimalPlaces="2" DisplayFormatString="#,##0.###" DisplayFormatInEditMode="True" />
                                </dx:GridViewDataSpinEditColumn>

                                <dx:GridViewDataSpinEditColumn FieldName="Height" Caption="Height (mm)" Width="100">
                                    <PropertiesSpinEdit NumberType="Float" DecimalPlaces="2" DisplayFormatString="#,##0.###" DisplayFormatInEditMode="True" />
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataTextColumn EditFormSettings-Visible="False" FieldName="DrawingCode" Caption="Drawing" Width="140" />
                                <dx:GridViewDataTextColumn EditFormSettings-Visible="False" FieldName="DrawingVersionCode" Caption="Revision" Width="90" />
                                <dx:GridViewDataTextColumn FieldName="Packing Description" Caption="Packing" Width="150" EditFormSettings-Visible="False" />

                            </Columns>
                            <ClientSideEvents EndCallback="gvItemsEndCallBack" />
                        </dx:ASPxGridView>
                    </div>
                </div>
            </div>

            <!--  Full‑remark POPUP viewer  -->
            <dx:ASPxPopupControl ID="popRemark" runat="server"
                ClientInstanceName="popRemark"
                PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter"
                CloseAction="CloseButton"
                Width="500"
                AllowResize="True"
                HeaderText="Item Remark">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxCallbackPanel ID="callbackPanel" runat="server"
                            ClientInstanceName="callbackPanel"
                            OnCallback="callbackPanel_Callback">

                            <PanelCollection>
                                <dx:PanelContent ID="panelContent" runat="server">
                                    <div id="popupContent" runat="server">
                                        Loading...
                                    </div>
                                </dx:PanelContent>
                            </PanelCollection>

                        </dx:ASPxCallbackPanel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>

            <!-- Popup for add new item PerformCallback('')-->
            <dx:ASPxPopupControl ID="pcItemAdd" runat="server"
                ClientInstanceName="pcItemAdd"
                PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter"
                Modal="true" Width="1200" HeaderText="Add New Item" OnWindowCallback="pcItemAdd_WindowCallback">

                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">

                        <dx:ASPxFormLayout ID="flItemAdd" runat="server" ColCount="4" Width="100%">
                            <Items>
                                <%--Row 0 Item type: Sample Item or Special Item--%>
                                <dx:LayoutItem Caption="Item No:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxComboBox ID="cbNewItemCategory" runat="server" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="cbNewItemCategory_SelectedIndexChanged">
                                                <Items>
                                                    <dx:ListEditItem Text="Sample" Value="SMP" Selected="true" />
                                                    <dx:ListEditItem Text="Special" Value="SPC" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                                <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                                <dx:EmptyLayoutItem></dx:EmptyLayoutItem>

                                <%--<-- Row 1: Item No, No_2, UOM, Item Type -->--%>
                                <dx:LayoutItem Caption="Item No:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxTextBox ID="txtNewItemNo" Enabled="false" runat="server" Width="100%" CssClass="disabled" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="No_ 2:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxTextBox ID="txtNewItemNo2" runat="server" Width="100%" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="UOM:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxComboBox ID="cbNewUOM" runat="server" Width="100%" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Item Type">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxComboBox ID="cbNewItemType" runat="server" Width="100%">
                                                <Items>
                                                    <dx:ListEditItem Text="Domestic" Value="1" Selected="true" />
                                                    <dx:ListEditItem Text="Foreign" Value="2" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <%--<-- Row 2: Description (span 2 cols), Full Description (span 2 cols) -->--%>
                                <dx:LayoutItem Caption="Description:" ColSpan="2">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxMemo ID="memoNewDescription" runat="server" Width="100%" Rows="4">
                                            </dx:ASPxMemo>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Full Description:" ColSpan="2">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxMemo ID="memoNewFullDescription" runat="server" Width="100%" Rows="4" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <%--Length, Width, Height--%>
                                <dx:LayoutItem Caption="Length:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxSpinEdit ID="spnNewLength" runat="server" Width="100%" NumberType="Float" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Width:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxSpinEdit ID="spnNewWidth" runat="server" Width="100%" NumberType="Float" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Caption="Height:">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxSpinEdit ID="spnNewHeight" runat="server" Width="100%" NumberType="Float" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:ASPxFormLayout>

                        <div class="text-end mt-2">
                            <dx:ASPxButton ID="btnSaveNewItem" runat="server" Text="Save"
                                CssClass="btn btn-primary" OnClick="btnSaveNewItem_Click" />
                            <dx:ASPxButton ID="btnCancelNewItem" runat="server" Text="Cancel"
                                AutoPostBack="false"
                                ClientSideEvents-Click="function(){ pcItemAdd.Hide(); }"
                                CssClass="btn btn-secondary" />
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>

            </dx:ASPxPopupControl>

            <!-- Lightbox Modal using show full image -->
            <div class="modal fade" id="lightboxModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content bg-dark text-white text-center">
                        <div class="modal-body p-0">
                            <img id="lightboxImage" src="" class="img-fluid" />
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

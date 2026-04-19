<%@ Page Title="Special Order" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="sample_order.aspx.cs" Inherits="WebApp.requisition.sample_order" %>
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


    <%-- load sweet alert --%>
    <script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <script>
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            lpSave.Hide();
        });

    </script>

    <script type="text/javascript">
        function onSaveOrderClick(s, e) {
            e.processOnServer = false;
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to save this order?',
                type: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, save it!',
                cancelButtonText: 'Cancel'
            }).then(function (result) {
                if (result.value) {
                    //show loading.....
                    lpSave.Show();
                    // Trigger postback                    
                    __doPostBack('<%= btnSaveOrder.UniqueID %>', '')
                }
            });

        }

        function OnCustomerSelected(s, e) {
            var customerNo = s.GetRowKey(e.visibleIndex);

            s.GetRowValues(e.visibleIndex, "Name;Address", function (values) {
                var name = values[0];
                var address = values[1];

                // Set value to the controls
                if (typeof beCustomer !== "undefined") beCustomer.SetText(customerNo);
                if (typeof tbCustName !== "undefined") tbCustName.SetText(name);
                if (typeof memoAddress !== "undefined") memoAddress.SetText(address);
                if (typeof hfCustomerNo !== "undefined") hfCustomerNo.Set("CustomerNo", customerNo);
                pcCustomerLookup.Hide();
            });
        }

        //set selected item to editor
        function OnItemSelected(s, e) {
            var key = s.GetRowKey(e.visibleIndex);
            s.GetRowValues(e.visibleIndex, "Description;UOM", function (values) {
                var desc = values[0];
                var uom = values[1];
                if (typeof beItemNo !== "undefined") beItemNo.SetText(key);
                if (typeof tbLineDescription !== "undefined") tbLineDescription.SetText(desc);
                if (typeof tbUOM !== "undefined") tbUOM.SetText(uom);

                pcItemLookup.Hide();
            });
        }

        function OnAddNewItemButtonClicked(s, e) {
            setTimeout(function () {
                pcItemLookup.Hide();
                pcItemAdd.PerformCallback(); // Or pcItemAdd.Show()/PerformCallback as you use
            }, 200); // 200ms is enough for button event to finish
        }


        function OnItemAddPopupEndCallback(s, e) {
            pcItemAdd.Show(); // Show the popup after callback is done
        }

        function onExportLinesClick() {
            // 🔹 All rows, current sort/filter, WYSIWYG layout
            gvLines.ExportToXlsx({
                fileName: 'SalesLines',         // name of the download file
                protectWorkbook: false,         // other options available
                selectedRowsOnly: false
            });
        }
        function RefreshGridAfterImport(s, e) {

            if (e.callbackData === 'OK') {
                // Use ASPxCallback to hit server, rebind Session→Grid
                cbRebindLines.PerformCallback('rebind');
            } else {
                Swal && Swal.fire('Import failed', 'Please check your file.', 'error');
            }


        }

    </script>

    <dx:ASPxCallback ID="cbRebindLines" runat="server"
        ClientInstanceName="cbRebindLines"
        OnCallback="cbRebindLines_Callback">
        <ClientSideEvents CallbackComplete="function(s,e){ 
            // Ask the grid to repaint with the latest Session data
            if (typeof gvLines !== 'undefined') gvLines.PerformCallback(); 
        }" />
    </dx:ASPxCallback>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h3>Create Sample and Special Order</h3>
                    <!-- ======== Header Type chooser (before anything else) ========= -->
                    <div class="mb-3">
                        <dx:ASPxComboBox runat="server" ID="cbHeaderType" Width="250" Caption="Header Type:"
                            ValueType="System.String" ClientInstanceName="cbHeaderType"
                            OnSelectedIndexChanged="cbHeaderType_SelectedIndexChanged" AutoPostBack="true">
                            <Items>
                                <dx:ListEditItem Text="Sample Order" Value="SMP" />
                                <dx:ListEditItem Text="Special Order" Value="SPC" />
                            </Items>
                        </dx:ASPxComboBox>
                    </div>

                    <!-- ========== Header Section ========== -->
                    <div class="card shadow-sm">                       
                        <dx:ASPxHiddenField runat="server" ID="hfCustomerNo" ClientInstanceName="hfCustomerNo"></dx:ASPxHiddenField>
                        <dx:ASPxFormLayout runat="server" ID="flHeader" ColCount="1"
                            CssClass="aspx-reset border rounded p-3 bg-white">
                            <SettingsAdaptivity SwitchToSingleColumnAtWindowInnerWidth="576" />
                            <Items>

                                <dx:LayoutGroup CssClass="mt-1" Caption="Order Info" Name="lgOrderInfo" GroupBoxStyle-CssClass="mb-3"
                                    GroupBoxDecoration="HeadingLine" ColCount="3">
                                    <Items>
                                        
                                        <dx:LayoutItem Caption="Order No">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="tbOrderNo" runat="server"
                                                        ReadOnly="True" Width="100%" />
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Order Date">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxDateEdit ID="deOrderDate" runat="server"
                                                        Width="100%" />
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Allocate For">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxComboBox ID="cbAllocate" runat="server" Width="100%" ReadOnly="true">
                                                        <Items>
                                                            <dx:ListEditItem Text="Factory" Value="1" Selected="true"/>
                                                            <dx:ListEditItem Text="Site" Value="2" />                                                            
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Note" ColumnSpan="3">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="tbNote" runat="server"
                                                         Width="100%" />
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>

                                <dx:LayoutGroup Caption="Customer Info" Name="lgCusInfo" CssClass="mt-1" GroupBoxStyle-CssClass="mb-0"
                                    GroupBoxDecoration="HeadingLine" ColCount="3">
                                    <Items>
                                        <dx:LayoutItem Caption="Customer No" ColumnSpan="1">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxButtonEdit ID="beCustomer" ReadOnly="true" ClientInstanceName="beCustomer" runat="server" Width="100%"
                                                        ButtonStyle-Width="28px">
                                                        <Buttons>
                                                            <dx:EditButton Position="Right" Image-IconID="find_find_16x16" />
                                                        </Buttons>
                                                        <ClientSideEvents ButtonClick="function(s,e){ pcCustomerLookup.Show(); }" />
                                                    </dx:ASPxButtonEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Customer Name">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="tbCustName" ClientInstanceName="tbCustName" runat="server"
                                                       Width="100%" />
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                         <dx:LayoutItem Caption="Project Type">
                                             <LayoutItemNestedControlCollection>
                                                 <dx:LayoutItemNestedControlContainer runat="server">
                                                     <dx:ASPxComboBox ID="cbProjectType" runat="server" Width="100%">
                                                         <Items>
                                                             <dx:ListEditItem Text="Domestic" Value="Domestic" Selected="true"/>
                                                             <dx:ListEditItem Text="Foreign" Value="Foreign" />                                                            
                                                         </Items>
                                                     </dx:ASPxComboBox>
                                                 </dx:LayoutItemNestedControlContainer>
                                             </LayoutItemNestedControlCollection>
                                         </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Address" ColumnSpan="3">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxTextBox ID="memoAddress" ClientInstanceName="memoAddress" runat="server"
                                                        Width="100%" />
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>
                            </Items>
                        </dx:ASPxFormLayout>
                    </div>

                    <!-- ========== Lines Grid ========== -->
                    <div class="button-group">
                        <dx:ASPxButton ID="btnAddNewItem" runat="server" Text="Add New Item"
                            AutoPostBack="false" Style="border-radius: 5px; float: right;"
                            ClientSideEvents-Click="function(){ pcItemLookup.Hide(); pcItemAdd.PerformCallback(''); }"
                            CssClass="btn btn-sm btn-success mb-2" />
                        <dx:ASPxButton ID="btnAddLine" runat="server"
                            Text="Add New Line" CssClass="btn btn-sm btn-primary" Style="border-radius: 5px; float: right;"
                            AutoPostBack="false"
                            ClientSideEvents-Click="function() {
                                       gvLines.AddNewRow(); 
                                   }"                           
                            />
                        
                        <button id="MainContent_btnExportToExel" type="button" class="btn btn-dark" onclick="gvLines.ExportTo(ASPxClientGridViewExportFormat.Xlsx)" style="border-radius: 5px; float: right;">
                            <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                        </button>
                    </div>
                    <dx:ASPxUploadControl ID="ucImportExcel" runat="server"
                        ClientInstanceName="ucImportExcel"
                        ShowUploadButton="true"
                        ShowProgressPanel="true"
                        FileUploadMode="OnPageLoad"
                        OnFileUploadComplete="ucImportExcel_FileUploadComplete"
                        UploadMode="Auto"
                        BrowseButton-Text="Browse Excel">
                        
                        <ClientSideEvents 
                            FileUploadComplete="RefreshGridAfterImport" />
                    </dx:ASPxUploadControl>

                    <dx:ASPxButton ID="btnImportExcel" runat="server"
                        Text="Import to Grid"
                        AutoPostBack="false"
                        ClientSideEvents-Click="function(){ ucImportExcel.Upload(); }" />

                    <asp:Label ID="lblImportResult" runat="server" ForeColor="Red" />

                    <dx:ASPxGridView runat="server" ID="gvLines" KeyFieldName="LineID"
                        Width="100%" CssClass="aspx-reset" ClientInstanceName="gvLines"
                         OnCellEditorInitialize="gvLines_CellEditorInitialize" OnInitNewRow="gvLines_InitNewRow"
                        OnRowInserting="gvLines_RowInserting"
                        OnRowUpdating="gvLines_RowUpdating"
                        OnRowDeleting="gvLines_RowDeleting"
                         OnCustomCallback="gvLines_CustomCallback" OnRowValidating="gvLines_RowValidating" 
                         >

                        <Columns>
                            <dx:GridViewCommandColumn Caption="Action" Width="90" ShowNewButton="true" ShowEditButton="true" ShowDeleteButton="true"></dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="LineID" Caption="ID" Width="70" EditFormSettings-Visible="False"/>
                            <dx:GridViewDataComboBoxColumn FieldName="Type" Caption="Type" Width="100">
                                <PropertiesComboBox ValueType="System.String" IncrementalFilteringMode="Contains" Width="120">
                                    <ClientSideEvents SelectedIndexChanged ="onObjectTypeChanged" />
                                    <Items>
                                        <dx:ListEditItem Text="Item"  Value="Item" Selected="true" />
                                        <dx:ListEditItem Text="Service" Value="Service" />
                                        <dx:ListEditItem Text="Charge"  Value="Charge"  />
                                    </Items>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                           
                            <dx:GridViewDataColumn FieldName="ItemNo" Caption="Item No" Width="150" Name="colItemNo">                                                              
                                <EditItemTemplate>
                                    <dx:ASPxButtonEdit ID="beItemNo" runat="server" ClientInstanceName="beItemNo" Width="100%" Text='<%# Bind("ItemNo") %>'>
                                        <Buttons>
                                            <dx:EditButton Position="Right" Image-IconID="find_find_16x16" />
                                        </Buttons>
                                        <ClientSideEvents ButtonClick="function(s,e){ pcItemLookup.Show(); }" />
                                        <ValidationSettings ValidationGroup="NewOrderLine">
                                            <RequiredField IsRequired="true" ErrorText="Item No must have a value." />
                                        </ValidationSettings>
                                    </dx:ASPxButtonEdit>
                                </EditItemTemplate>
                            </dx:GridViewDataColumn>

                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Width="240">
                                <EditItemTemplate>
                                    <dx:ASPxTextBox ID="tbLineDescription" runat="server" Text='<%# Bind("Description") %>'
                                                    ClientInstanceName="tbLineDescription"
                                                    Width="100%">
                                        <ValidationSettings ValidationGroup="NewOrderLine">
                                            <RequiredField IsRequired="true" ErrorText="Description is required." />
                                            <RegularExpression ValidationExpression="^.{0,50}$" ErrorText="Description must be less than 50 characters." />
                                        </ValidationSettings>
                                    </dx:ASPxTextBox>
                                </EditItemTemplate>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataSpinEditColumn FieldName="Quantity" Caption="Qty" Width="80">
                                <PropertiesSpinEdit MinValue="0.0001" MaxValue="100000" ValidationSettings-ErrorText =" Quantity must be > 0"
                                                    ValidationSettings-RequiredField-IsRequired="true"
                                                    ValidationSettings-RequiredField-ErrorText="Quantity is required."  
                                                     ValidationSettings-ValidationGroup="NewOrderLine"
                                                    >
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Price" Caption="Price" Width="80" PropertiesSpinEdit-DisplayFormatString="#,##0">
                                
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataColumn FieldName="UOM" Caption="U/M" Width="80" > 
                                 <EditItemTemplate>
                                     <dx:ASPxComboBox  ID="tbUOM" runat="server" Text='<%# Bind("UOM") %>' ClientInstanceName="tbUOM" Width="100%">
                                         <ValidationSettings ValidationGroup="NewOrderLine" RequiredField-IsRequired="true" ErrorText="UOM is required"></ValidationSettings>
                                     </dx:ASPxComboBox>
                                 </EditItemTemplate>                                
                            </dx:GridViewDataColumn>

                            <dx:GridViewDataDateColumn FieldName="PromisedDate" Caption="Promised Date" Width="120" />
                            <dx:GridViewDataDateColumn FieldName="RequestDate" Caption="Request Delivery" Width="130" />
                                                       

                        </Columns>
                        <SettingsDataSecurity AllowInsert="true" AllowEdit="true" AllowDelete="true" />
                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG"></SettingsExport>
                        <SettingsEditing Mode="EditForm">
                           
                        </SettingsEditing>
                        
                        <SettingsPopup CustomizationWindow-HorizontalAlign="WindowCenter" CustomizationWindow-VerticalAlign="WindowCenter" />
                        <SettingsPager PageSize="10" />
                        <ClientSideEvents CustomButtonClick="function(s, e) {
                                                    if(e.buttonID === 'btnEdit')
                                                        gvLines.StartEditRow(e.visibleIndex);  // opens built-in popup
                                                    else if(e.buttonID === 'btnDelete' && confirm('Delete this line?'))
                                                        gvLines.DeleteRow(e.visibleIndex);
                                                }" />
                        <ClientSideEvents EndCallback="function(s, e) {                            
                                                        var objectName = s.cpObjectName;
                                                        if (objectName) {
                                                            var rowIndex = s.GetFocusedRowIndex();
                                                            s.GetEditor('Description').SetValue(objectName);
                                                        }
                        }" />
                    </dx:ASPxGridView>
                    
                    <div class=" mt-4 mb-4" style="text-align:center;">
                        <dx:ASPxButton ID="btnSaveOrder" runat="server" Text="Save Order" CssClass="btn btn-primary"
                            OnClick="btnSaveOrder_Click" 
                            ClientSideEvents-Click="onSaveOrderClick"/>
                    </div>
                </div>
            </div>
              
            <!-- ========== Add / Edit Line Modal (Bootstrap + DevExpress) ========== -->
            <dx:ASPxPopupControl ID="lineModal" runat="server" ClientInstanceName="lineModal"
                Modal="True" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                Width="600" HeaderText="Sales Line" CloseAction="CloseButton">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxFormLayout runat="server" ID="flLine" ColCount="2">
                            <Items>
                                <dx:LayoutItem Caption="Type">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxComboBox ID="cbLineType" runat="server" Width="100%">
                                                <Items>
                                                    <dx:ListEditItem Text="Normal" />
                                                    <dx:ListEditItem Text="Service" />
                                                    <dx:ListEditItem Text="Charge" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <dx:LayoutItem Caption="Item No">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxButtonEdit ID="beItemNo" runat="server" Width="100%">
                                                <Buttons>
                                                    <dx:EditButton Position="Right" Image-IconID="find_find_16x16" />
                                                </Buttons>
                                            </dx:ASPxButtonEdit>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <dx:LayoutItem Caption="Description" ColSpan="2">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxMemo ID="memoDesc" runat="server"
                                                Width="100%" Height="60" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <dx:LayoutItem Caption="Quantity">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxSpinEdit ID="seQty" runat="server"
                                                Width="100%" DecimalPlaces="2" MinValue="0" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <dx:LayoutItem Caption="U/M">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxComboBox ID="cbUOM" runat="server" Width="100%" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <dx:LayoutItem Caption="Promised Date">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxDateEdit ID="dePromised" runat="server" Width="100%" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                                <dx:LayoutItem Caption="Request Delivery">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxDateEdit ID="deRequest" runat="server" Width="100%" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>

                            </Items>
                        </dx:ASPxFormLayout>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
            
            <!-- Popup for Customer Lookup -->
            <dx:ASPxPopupControl ID="pcCustomerLookup" runat="server"
                ClientInstanceName="pcCustomerLookup"
                PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter"
                Modal="true" Width="600px" HeaderText="Select Customer">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxGridView ID="gvCustomerLookup" runat="server"
                            Width="100%" KeyFieldName="CustomerNo"
                            AutoGenerateColumns="False"
                            OnCustomCallback="gvCustomerLookup_CustomCallback"
                            OnRowCommand="gvCustomerLookup_RowCommand">
                            <Columns>                                
                                <dx:GridViewDataTextColumn FieldName="CustomerNo" Caption="Customer No" />
                                <dx:GridViewDataTextColumn FieldName="Name" Caption="Customer Name" />
                                <dx:GridViewDataTextColumn FieldName="Address" Caption="Address" />
                            </Columns>
                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                            <SettingsPager PageSize="10" />
                            <Settings ShowFilterRow="True" />
                            <Settings ShowHeaderFilterButton="True" />
                            <ClientSideEvents RowClick="OnCustomerSelected" />
                        </dx:ASPxGridView>
                    </dx:PopupControlContentControl>
                </ContentCollection>

            </dx:ASPxPopupControl>

            <!-- Popup for Item Lookup -->
            <dx:ASPxPopupControl ID="pcItemLookup" runat="server"
                ClientInstanceName="pcItemLookup"
                PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter"
                Modal="true" Width="800px" HeaderText="Select Item: Click on the row to select">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">                        
                        <dx:ASPxGridView ID="gvItemLookup" runat="server" KeyFieldName="ItemNo" Width="100%"
                            AutoGenerateColumns="False"
                            OnCustomCallback="gvItemLookup_CustomCallback">
                            <Columns>                                
                                <dx:GridViewDataTextColumn FieldName="ItemNo" Caption="Item No" />
                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" />
                                <dx:GridViewDataTextColumn FieldName="UOM" Caption="U/M" />
                                <%--hh--%>
                            </Columns>
                            <SettingsSearchPanel Visible="true" />
                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                            <SettingsPager PageSize="10" />
                            <ClientSideEvents RowClick="OnItemSelected" />
                        </dx:ASPxGridView>
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
                                 <%--<-- Row 1: Item No, No_2, UOM, Item Type -->--%>
                                 <dx:LayoutItem Caption="Item No:">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxTextBox ID="txtNewItemNo" Enabled="false" runat="server" Width="100%"  CssClass="disabled"/>
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
                                             <dx:ASPxMemo ID="memoNewDescription" runat="server" Width="100%" Rows="3">                                                 
                                             </dx:ASPxMemo>
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Full Description:" ColSpan="2">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxMemo ID="memoNewFullDescription" runat="server" Width="100%" Rows="3" />
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
                                 CssClass="btn btn-primary" OnClick="btnSaveNewItem_Click"
                                 />
                             <dx:ASPxButton ID="btnCancelNewItem" runat="server" Text="Cancel"
                                 AutoPostBack="false"
                                 ClientSideEvents-Click="function(){ pcItemAdd.Hide(); }"
                                 CssClass="btn btn-secondary" />
                         </div>
                     </dx:PopupControlContentControl>
                     </ContentCollection>
                <ClientSideEvents EndCallback="OnItemAddPopupEndCallback" />
            </dx:ASPxPopupControl>

                    </ContentTemplate>
</asp:UpdatePanel>

    <!-- Loading panel: waiting-->
    <dx:ASPxLoadingPanel ID="lpSave" runat="server"
    ClientInstanceName="lpSave"
    Modal="true"
    Text="Saving… please wait..."
    EnableHtmlForText="false"  
    HorizontalAlign="Center"
    VerticalAlign = "Middle"
    CssClass="px-4 py-3 fs-5"  />


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
            document.getElementById("ModalHeader").className = "modal-header modal-colored-header text-white " + class_style;
        }
    </script>
    <!-- Modal Popup -->
    <script type="text/javascript">
        // open edit modal from grid command button
        function OnCustomButtonClick(s, e) {
            if (e.buttonID === "btnEdit") {
                gvLines.StartEditRow(e.visibleIndex);
            } else if (e.buttonID === "btnDelete") {
                var ok = confirm("Delete this line?");
                if (ok)
                    gvLines.DeleteRow(e.visibleIndex);
            }
        }
    </script>

    <script>
        function showLineModal(lineId) {
            // load data if lineId exists
            var modal = new bootstrap.Modal(document.getElementById('lineModal'));
            modal.show();
        }


        function onLineCommand(s, e) {
            var key = s.GetRowKey(e.visibleIndex);
            if (e.buttonID === "Edit") {
                showLineModal(key);
            } else if (e.buttonID === "Delete") {
                s.PerformCallback("Delete|" + key);
            }
        }
    </script>

    <script type="text/javascript">
        function onObjectTypeChanged(s, e) {
            // Refresh Object No column after Object Type changes
            debugger;
            //var grid = ASPxClientControl.GetControlCollection().GetByName("gvLines");
            var visibleIndex = gvLines.GetFocusedRowIndex();
            gvLines.GetEditor("ItemNo").PerformCallback(s.GetValue());
        }

        function onObjectNoChanged(s, e) {
            debugger;
            var selectedValue = s.GetValue(); // ObjectNo ID            
            var rowIndex = gvLines.GetFocusedRowIndex();

            if (!selectedValue) return;

            // Call a page method or callback to get the object name
            // Option 1: Use hidden JSON data if it's small
            // Option 2: Use a DevExpress callback
            // Here's Option 2: DevExpress callback

            // Call server-side to get the name
            gvLines.PerformCallback("GetObjectName|" + selectedValue);
        }

        function gvLinesEndCallback(s, e) {
            var objectName = s.cpObjectName;

            if (objectName) {
                var rowIndex = s.GetFocusedRowIndex();
                s.GetEditor("Description").SetValue(objectName);
            }
        }
    </script>   

</asp:Content>


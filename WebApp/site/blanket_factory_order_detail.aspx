<%@ Page Title="Blanket Order Detail" ValidateRequest="false" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="blanket_factory_order_detail.aspx.cs" Inherits="WebApp.site.blanket_factory_order_detail" %>

<%--<%@ Register Src="~/CustomControl/CommentControl.ascx" TagPrefix="uc" TagName="Comment" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Skin Maretial P -->
  <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
  <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
   <!-- Import Js Files -->
 
  <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>

  <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>

  <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
  <!-- solar icons -->
 <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
  <!-- Skin Material P -->

<!-- select 2 -->
<link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
<script src="../masterskin/monster/dist/select2/select2.min.js"></script>


<!-- load sweet alert -->
<script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />
    <script type="text/javascript">      

        function sweetAlertConfirm(clientid, text) {
            var huu = false;
            Swal.fire({
                title: 'Are you sure?',
                text: text,
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes!'
            }).then(function (result) {

                if (result.value) {
                    __doPostBack(clientid, '');
                }
            })
            return huu;
        }
    </script>
    <script type="text/javascript">
        var currentRowIndex = null;
        var cachedOriginalValues = {};

        function OnGridRowValidating(s, e) {
            var rowIndex = e.visibleIndex;

            // Helper: get current (edited) value of a field in this row
            function getVal(field) {
                var col = s.GetColumnByField(field);
                if (!col) return null;
                var info = e.validationInfo[col.index];
                return (info ? info.value : s.batchEditApi.GetCellValue(rowIndex, field));
            }

            // Helper: mark a field invalid with a message
            function invalidate(field, msg) {
                var col = s.GetColumnByField(field);
                if (!col) return;
                // ensure an entry exists in validationInfo for this column
                if (!e.validationInfo[col.index])
                    e.validationInfo[col.index] = { value: getVal(field), isValid: true, errorText: "" };

                e.validationInfo[col.index].isValid = false;
                e.validationInfo[col.index].errorText = msg;
            }

            
            // 1) OrderQty <= RemainQty
            var orderQty = parseFloat(getVal("OrderQty")) || 0;
            var remainQty = parseFloat(getVal("RemainQty")) || 0;
            if (orderQty > remainQty) {
                invalidate("OrderQty", "OrderQty cannot exceed RemainQty (" + remainQty + ")");
            }

            // 2) Required fields
            var requiredFields = [
                { field: "SiteOrderDescription", label: "Site Order Description" },
                { field: "DrawingNote", label: "Drawing Note" }                
            ];

            requiredFields.forEach(function (r) {
                var v = getVal(r.field);
                var isEmpty = (v === null || v === undefined || (typeof v === "string" && v.trim() === ""));
                if (isEmpty) invalidate(r.field, r.label + " must not be empty");
            });
        }

        //function OnGridRowValidating(s, e) {
        //    debugger;
           
        //    var rowIndex = e.visibleIndex;

        //    var orderQty = 0;
        //    if (e.validationInfo[13])  orderQty = parseFloat(e.validationInfo[13].value) || 0;
        //    var remainQty = parseFloat(s.batchEditApi.GetCellValue(rowIndex, "RemainQty")) || 0;

        //    if (orderQty > remainQty) {
                
        //        e.validationInfo[13].isValid = false;
        //        e.validationInfo[13].errorText = "OrderQty cannot exceed RemainQty (" + remainQty + ")";
        //    } 

        //    //var order_des = "";
        //    //if (e.validationInfo[15] = null) {
        //    //    e.validationInfo[15].isValid = false;
        //    //    e.validationInfo[15].errorText = "Site Order Description must be not empty!";
        //    //}
        //}

        function OnGridEndCallback(s, e) {
            debugger;
            if (s.cpHasError) {
                if (s.cpErrorMessage) {
                    //ShowPopup('Save failed', s.cpErrorMessage, 'bg-danger');
                    Swal.fire({
                        type: 'error',
                        title: 'Save failed',
                        text: s.cpErrorMessage
                    });
                }
               
                // avoid showing again on next callbacks
                s.cpErrorMessage = null;
                s.cpHasError = null;
            }

            if (s.cpSuccessMessage) {

                Swal.fire({
                    type: 'success',
                    title: 'Saved!',
                    text: 'All changes have been saved successfully.',
                    timer: 2500,
                    showConfirmButton: false
                });
                //ShowPopup('Saved!', s.cpSuccessMessage, 'bg-success');
                
                s.cpSuccessMessage = null;
                s.cpHasError = null;
            }
            
        }
    </script>
    <script type="text/javascript">
        function ShowPopup(title, body, class_style) {

            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").className = "modal-header modal-colored-header text-white " + class_style;

        }
    </script>
    <!-- Bootstrap -->
    <!-- Modal Popup -->
    <div runat="server" id="divModalForFullPostBack" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div runat="server" id="divModalHeader" class="modal-header modal-colored-header text-white">
                    <h4 class="modal-title">NHF System
                    </h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div runat="server" id="divModalMessage" class="modal-body">
                    <asp:Label runat="server" ID="lbModalMessage" Text="dđ">d</asp:Label>
                </div>
                <div class="modal-footer">
                    <button runat="server" id="btnCloseModal" onserverclick="btnCloseModal_ServerClick" type="button" class="btn btn-light" data-bs-dismiss="modal">
                        OK
                    </button>
                </div>
            </div>
        </div>
    </div>


<div id="divModal" class="modal fade">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div id="ModalHeader" class="modal-header modal-colored-header text-white">
                <h4 class="modal-title text-white" id="warning-header-modalLabel">Modal Heading
                </h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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

<!-- Modal Popup -->
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    
                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body">
                            <h4 id="txtDesciptionHeader" runat="server" class="card-title mb-0 text-dark">Blanket Factory Order</h4>
                        </div>
                        
                        <div class="card-body shadow-sm">
                            <div class="row mx-0 mb-2">
                                <div class="col-md-12 px-0 mb-2">
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbPrice" Checked="false" Text="Price" OnCheckedChanged="cbSiteDescription_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbOrderedInfo" Text="Ordered Info." OnCheckedChanged="cbOrderedInfo_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbParentRemark" Text="Remark" OnCheckedChanged="cbParentRemark_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbGroup" Checked="true" Text="Group" OnCheckedChanged="cbGroup_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbSubGroup" Checked="true" Text="Sub Group" OnCheckedChanged="cbSubGroup_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbSiteDescription" Checked="true" Text="Site Order Description" OnCheckedChanged="cbSiteDescription_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDimension" Checked="true" Text="Dimension" OnCheckedChanged="cbGroup_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbFinish" Checked="false" Text="Finishing" OnCheckedChanged="cbSubGroup_CheckedChanged" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbApply" Checked="false" Text="Apply Info" OnCheckedChanged="cbSiteDescription_CheckedChanged" AutoPostBack="True" />
                                    
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbSearchPanel" Checked="true" Text="Search Panel" OnCheckedChanged="cbSearchPanel_CheckedChanged" AutoPostBack="True" />
                                </div>
                            </div>

                            <div class="button-group">                            
                            <button type="button" runat="server" id="btnClearOrderQty" class="mx-0 btn btn-primary" 
                                onclick="javascript: return sweetAlertConfirm('ctl00$MainContent$btnClearOrderQty','You want to clear data in the ORDER QTY column?');" 
                                onserverclick="btnClearOrderQty_Click" style="border-radius: 5px; float: right;">
                                <i class="ti ti-trash fs-4 me-2"></i> Clear Order Quantity
                            </button>
                            <button type="button" runat="server" id="btnMakeOrder" class="btn btn-success"  
                                onclick="javascript: return sweetAlertConfirm('ctl00$MainContent$btnMakeOrder','You want to make order?');"
                                onserverclick="btnMakeOrder_Click" style="border-radius: 5px;float: right;">
                                <i class="ti ti-plus fs-4 me-2"></i> Create Order
                            </button>
                            <button type="button" runat="server" ID="btnGeAllRelatedOrder" class="btn btn-danger" onserverclick="btnGeAllRelatedOrder_Click" style="border-radius: 5px;float: right;">
                                 <i class="ti ti-direction-sign fs-4 me-2"></i> Get All Related Order
                            </button>
                            <button type="button" runat="server" id="btnExportToExel" class="btn btn-dark" onclick="grid.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px;float: right;">
                                <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                            </button> 
                            
                            <uc:ApprovalFlow ID="ApprovalFlow1" runat="server" OnStatusChanged="ApprovalFlow1_StatusChanged"/> 
                            <%--<div class="btn-group">
                                <button class="btn btn-danger dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                    Action
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton" style="">
                                    <li><a class="dropdown-item" href="javascript:void(0)">Action</a></li>
                                    <li>
                                        <a class="dropdown-item" href="javascript:void(0)">Another action</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="javascript:void(0)">Something else here</a>
                                    </li>
                                </ul>
                            </div>--%>
                        </div>
                            <dx:ASPxGridView ID="gridBlanketFactoryOrderDetail" ClientInstanceName="grid" KeyFieldName="LineNo" runat="server" Width="100%" AutoGenerateColumns="False"
                                OnCustomColumnDisplayText="gridFactoryOrder_CustomColumnDisplayText"
                                OnHtmlRowPrepared="gridBlanketFactoryOrderDetail_HtmlRowPrepared" OnCustomCellMerge="gridBlanketFactoryOrderDetail_CustomCellMerge"
                                OnBeforeGetCallbackResult="gridBlanketFactoryOrderDetail_BeforeGetCallbackResult"
                                OnBatchUpdate="gridBlanketFactoryOrderDetail_BatchUpdate" OnHtmlDataCellPrepared="gridBlanketFactoryOrderDetail_HtmlDataCellPrepared">
                                <Styles Table-CssClass="" Header-CssClass="gridViewHeader" Row-CssClass="gridViewRow" FocusedRow-CssClass="gridViewRowFocused"
                                RowHotTrack-CssClass="gridViewRow" FilterRow-CssClass="gridViewFilterRow" />
                                <SettingsExport EnableClientSideExportAPI="true"/>  
                                <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
                                <Settings ShowHeaderFilterButton="true" HorizontalScrollBarMode="Auto" VerticalScrollBarMode="Visible" VerticalScrollableHeight="400" />
                                
                                <Settings ShowFooter="true" ShowHeaderFilterButton="true" />
                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                <SettingsBehavior AllowGroup="false" AllowSort="True"></SettingsBehavior>   
                                
                                <SettingsFilterControl ViewMode="VisualAndText" AllowHierarchicalColumns="true" ShowAllDataSourceColumns="true" MaxHierarchyDepth="1" />
                                <SettingsDataSecurity AllowDelete="false" AllowInsert="False" AllowEdit="true"></SettingsDataSecurity>
                                <SettingsSearchPanel Visible="True"></SettingsSearchPanel>
                                <Settings ShowFilterBar="Visible" />
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="ParentNo" ReadOnly="True" Name="ParentNo" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Group" ReadOnly="True" Name="Group" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ParentDescription" ReadOnly="True" Name="ParentDescription" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="No_" ReadOnly="True" Name="No_" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                    
                                    <dx:GridViewDataTextColumn FieldName="SubGroup" ReadOnly="True" Name="SubGroup" VisibleIndex="4">
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" Name="Description" VisibleIndex="5"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UOM" ReadOnly="True" Name="UOM" VisibleIndex="6">
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Unit Price" ReadOnly="True" Name="Unit Price" VisibleIndex="7">
                                        <Settings AllowCellMerge="False"></Settings>
                                        <PropertiesTextEdit DisplayFormatString="#,##0"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Amount" ReadOnly="True" Name="Amount" VisibleIndex="8">
                                        <Settings AllowCellMerge="False"></Settings>
                                        <PropertiesTextEdit DisplayFormatString="#,##0"></PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Quantity" Name="Quantity" VisibleIndex="9">
                                        <PropertiesTextEdit DisplayFormatString="##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="OrderedQty" ReadOnly="True" Name="OrderedQty" VisibleIndex="10">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AdjustedQty" ReadOnly="True" Name="AdjustedQty" VisibleIndex="11">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RemainQty" ReadOnly="True" Name="RemainQty" VisibleIndex="12">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="OrderQty" ReadOnly="false" Name="OrderQty" VisibleIndex="13" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="NeedOnDate" Name="NeedOnDate" VisibleIndex="14" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataMemoColumn FieldName="SiteOrderDescription" Name="SiteOrderDescription" VisibleIndex="15" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesMemoEdit EncodeHtml="False" Height="100"></PropertiesMemoEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataMemoColumn>
                                    <dx:GridViewDataMemoColumn FieldName="DrawingNote" Name="DrawingNote" VisibleIndex="16" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesMemoEdit EncodeHtml="False" Height="100"></PropertiesMemoEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataMemoColumn>
                                    <dx:GridViewDataTextColumn FieldName="Length" Name="Length" VisibleIndex="17" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Width" Name="Width" VisibleIndex="18" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Height" Name="Height" VisibleIndex="19" HeaderStyle-CssClass="bg-secondary">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="DocumentType" ReadOnly="True" Name="DocumentType" VisibleIndex="20"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="DocumentNo" ReadOnly="True" Name="DocumentNo" VisibleIndex="21"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="LineNo" ReadOnly="True" Name="LineNo" VisibleIndex="22"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataMemoColumn FieldName="ParentRemark" Name="ParentRemark" VisibleIndex="23">
                                        <PropertiesMemoEdit EncodeHtml="False" Height="100"></PropertiesMemoEdit>
                                    </dx:GridViewDataMemoColumn>


                                </Columns>

                                
                                <Styles>
                                    <AlternatingRow Enabled="true" />
                                </Styles>
                                <SettingsBehavior AllowFocusedRow="true" />
                                <SettingsDataSecurity AllowReadUnlistedFieldsFromClientApi="True" />

                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="No_" SummaryType="Count" />
                                    <dx:ASPxSummaryItem FieldName="OrderQty" SummaryType="Sum" />
                                    <dx:ASPxSummaryItem FieldName="Amount" SummaryType="Sum" />
                                </TotalSummary>  

                                <ClientSideEvents BatchEditRowValidating="OnGridRowValidating" />
                                <ClientSideEvents EndCallback="OnGridEndCallback" />
                            </dx:ASPxGridView>

                        </div>
                    </div>
                    
                   <uc:Comment runat="server" ID="commentSection" DocumentID="dd"></uc:Comment>
                </div>
            </div>

            <%--POPUP SHOW ALL ORDER OF EACH ITEMNO--%>
            <script type="text/javascript">
                function ShowOrderQtyDetail(itemNo) {
                    cpOrderQtyDetail.PerformCallback(itemNo);
                    pcOrderQtyDetail.Show();
                }

                function OpenFactoryOrderDetail(docNo) {
                    var url = 'factory_order_detail?no=' + encodeURIComponent(docNo);
                    window.open(url, '_blank');
                    
                }

                function OpenProdOrderTracing(prodOrderNo) {
                    window.open('/production/trace/ProdOrderTracing?No=' + encodeURIComponent(prodOrderNo), '_blank');
                }
            </script>
            <asp:HiddenField ID="hfPopupItemNo" runat="server" />
            <asp:HiddenField ID="hfPopupRequestNo" runat="server" />
            <dx:ASPxPopupControl ID="pcOrderQtyDetail" runat="server"
                ClientInstanceName="pcOrderQtyDetail"
                Width="900px"
                Modal="true"
                PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter"
                HeaderText="Order Quantity Detail"
                CloseAction="CloseButton"
                AllowDragging="true"
                PopupAnimationType="Fade"
                EnableViewState="true">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxCallbackPanel ID="cpOrderQtyDetail" runat="server" ClientInstanceName="cpOrderQtyDetail"
                            OnCallback="cpOrderQtyDetail_Callback">
                            <PanelCollection>
                                <dx:PanelContent runat="server">

                                    <div class="mb-2">
                                        <b>Document No:</b>
                                        <asp:Literal ID="litPopupRequestNo" runat="server"></asp:Literal>
                                        &nbsp; | &nbsp;
                                        <b>Item No:</b>
                                        <asp:Literal ID="litPopupItemNo" runat="server"></asp:Literal>
                                    </div>

                                    <dx:ASPxGridView ID="gridOrderQtyDetail" runat="server"
                                        Width="100%"
                                        AutoGenerateColumns="False"
                                        KeyFieldName="RowKey" OnCustomColumnDisplayText="gridOrderQtyDetail_CustomColumnDisplayText"
                                         OnHtmlDataCellPrepared="gridOrderQtyDetail_HtmlDataCellPrepared" 
                                       
                                         >
                                        <SettingsPager PageSize="15" />
                                        <Settings VerticalScrollBarMode="Visible" VerticalScrollableHeight="350" />
                                        <SettingsBehavior AllowFocusedRow="true" AllowSort="true" />
                                        <SettingsSearchPanel Visible="true" />
                                        <Styles>
                                            <AlternatingRow Enabled="true" />
                                        </Styles>
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="Document No_" Caption="Document No" VisibleIndex="0">
                                                <DataItemTemplate>
                                                    <a href='javascript:void(0);'
                                                       onclick='OpenFactoryOrderDetail("<%# Eval("Document No_").ToString().Replace("\"", "&quot;") %>");'>
                                                        <%# Eval("Document No_") %>
                                                    </a>
                                                </DataItemTemplate>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="Quantity" VisibleIndex="1">
                                                <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="UOM" VisibleIndex="2" Caption="UOM" />
                                            <dx:GridViewDataDateColumn FieldName="Requested Delivery Date" Caption="Requested Delivery Date" VisibleIndex="3">
                                                <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>

                                            <dx:GridViewDataDateColumn FieldName="Promised Delivery Date" Caption="Promised Delivery Date" VisibleIndex="4">
                                                <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="Production Order No" Caption="Production Order No" VisibleIndex="5" />
                                        </Columns>

                                        <TotalSummary>
                                            <dx:ASPxSummaryItem FieldName="Quantity" SummaryType="Sum" DisplayFormat="Total: {0:#,##0.####}" />
                                            <dx:ASPxSummaryItem FieldName="Document No_" SummaryType="Count" DisplayFormat="Count: {0}" />
                                        </TotalSummary>
                                        <Settings ShowFooter="true" />
                                    </dx:ASPxGridView>

                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
       
            </ContentTemplate>
        
    </asp:UpdatePanel>
       <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="/images/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

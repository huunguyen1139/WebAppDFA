<%@ Page Title="Purchase Requisition" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="PurchaseRequisition.aspx.cs" Inherits="WebApp.purchase.PurchaseRequisition" %>

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


        /* Opt-out: make selected controls look editable again */
        .header-readonly .header-editable .dxeEditArea,
        .header-readonly .header-editable input,
        .header-readonly .header-editable textarea {
            background-color: #fff !important;
            color: #212529 !important;
            cursor: text !important;
            opacity: 1 !important;
        }

        /* DevExpress border/background wrapper */
        .header-readonly .header-editable .dxeTextBoxSys,
        .header-readonly .header-editable .dxeButtonEditSys,
        .header-readonly .header-editable .dxeMemoSys,
        .header-readonly .header-editable .dxeSpinEditSys,
        .header-readonly .header-editable .dxeComboBoxSys {
            background-color: #fff !important;
        }

        /* Optional: highlight editable fields slightly */
        .header-readonly .header-editable .dxeTextBoxSys,
        .header-readonly .header-editable .dxeButtonEditSys,
        .header-readonly .header-editable .dxeComboBoxSys,
        .header-readonly .header-editable .dxeMemoSys {
            border: 1px solid #ced4da !important;
            box-shadow: none !important;
        }
    </style>

    <asp:HiddenField ID="hfDocNo" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>


            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">

                    <div class="mb-3">
                        <h3 class="mb-1" runat="server" id="lblTitle">
                            <%--<asp:Literal ID="lblTitle" runat="server" Text=""></asp:Literal>--%>
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
                                <dx:ASPxFormLayout ID="flHeader" runat="server" Width="100%" CssClass="header-readonly">
                                    <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="768" />
                                    <Items>
                                        <dx:LayoutGroup GroupBoxDecoration="None" ColCount="2">
                                            <Items>

                                                <dx:LayoutGroup GroupBoxDecoration="None">
                                                    <Items>
                                                        <dx:LayoutItem Caption="Document No.">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtDocumentNo" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem Caption="Requester ID">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtRequesterID" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem Caption="Purch Req. Date">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxDateEdit ID="dePurchReqDate" runat="server" Width="100%"
                                                                        ReadOnly="true" DisplayFormatString="dd-MM-yyyy" EditFormat="Custom" EditFormatString="dd-MM-yyyy" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>


                                                        <dx:LayoutItem Caption="Purch Req. Purpose" CssClass="header-editable">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxMemo ID="txtPurpose" runat="server" Width="100%" Height="70px" AutoPostBack="true" OnTextChanged="txtPurpose_TextChanged" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem Caption="Project Code" CssClass="header-editable">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxComboBox ID="cboHeaderProjectCode" runat="server" Width="100%"
                                                                        ClientInstanceName="cboHeaderProjectCode"
                                                                        ValueType="System.String"
                                                                        DropDownStyle="DropDownList"
                                                                        ValueField="Code"
                                                                        TextField="Code"
                                                                         AutoPostBack="true" OnTextChanged="cboHeaderProjectCode_TextChanged"
                                                                        EnableCallbackMode="true"
                                                                        CallbackPageSize="30"
                                                                        IncrementalFilteringMode="Contains"
                                                                        OnItemsRequestedByFilterCondition="cboHeaderProjectCode_ItemsRequestedByFilterCondition"
                                                                        OnItemRequestedByValue="cboHeaderProjectCode_ItemRequestedByValue">
                                                                        <Columns>
                                                                            <dx:ListBoxColumn FieldName="Code" Caption="Code" Width="90" />
                                                                            <dx:ListBoxColumn FieldName="Name" Caption="Name" Width="240" />
                                                                        </Columns>
                                                                    </dx:ASPxComboBox>
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>
                                                    </Items>
                                                </dx:LayoutGroup>


                                                <dx:LayoutGroup GroupBoxDecoration="None">
                                                    <Items>

                                                        <dx:LayoutItem Caption="Purch Req. Due Date" CssClass="header-editable">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxDateEdit ID="deDueDate" runat="server" Width="100%" AutoPostBack="true" OnDateChanged="deDueDate_DateChanged"
                                                                        DisplayFormatString="dd-MM-yyyy" EditFormat="Custom" EditFormatString="dd-MM-yyyy" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>


                                                        <dx:LayoutItem Caption="Purch Req. Type" CssClass="header-editable">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxComboBox ID="cboPurchReqType" runat="server" Width="100%" DropDownStyle="DropDownList" AutoPostBack="true" OnSelectedIndexChanged="cboPurchReqType_SelectedIndexChanged"
                                                                        ValueType="System.Int32" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>


                                                        <dx:LayoutItem Caption="Purch Req. Status">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxComboBox ID="cboPurchReqStatus" runat="server" Width="100%" DropDownStyle="DropDownList"
                                                                        ValueType="System.Int32" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem Caption="Department">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxTextBox ID="txtDepartment" runat="server" Width="100%" ReadOnly="true" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem Caption="Last Modified">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxDateEdit ID="deLastModified" runat="server" Width="100%" ReadOnly="true"
                                                                        DisplayFormatString="dd-MM-yyyy HH:mm" EditFormat="Custom" EditFormatString="dd-MM-yyyy HH:mm" />
                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem Caption="Cost Element" CssClass="header-editable">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxComboBox ID="cboHeaderCostElement" runat="server" Width="100%"
                                                                        ClientInstanceName="cboHeaderCostElement"
                                                                        ValueType="System.String"
                                                                        DropDownStyle="DropDownList"
                                                                        ValueField="Code"
                                                                        TextField="Code"
                                                                        EnableCallbackMode="true"
                                                                        CallbackPageSize="30"
                                                                         AutoPostBack="true" OnTextChanged="cboHeaderCostElement_TextChanged"
                                                                        IncrementalFilteringMode="Contains"
                                                                        OnItemsRequestedByFilterCondition="cboHeaderCostElement_ItemsRequestedByFilterCondition"
                                                                        OnItemRequestedByValue="cboHeaderCostElement_ItemRequestedByValue">
                                                                        <Columns>
                                                                            <dx:ListBoxColumn FieldName="Code" Caption="Code" Width="90" />
                                                                            <dx:ListBoxColumn FieldName="Name" Caption="Name" Width="240" />
                                                                        </Columns>
                                                                    </dx:ASPxComboBox>
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

                    <%--<asp:HiddenField ID="hfPasteExcel" runat="server" />
            <asp:Button ID="btnImportPasteHidden" runat="server"
                Style="display:none"
                OnClick="btnImportPaste_Click" />--%>

                    <%--<script type="text/javascript">
                function PR_ImportPaste_Click() {
                    var memo = ASPxClientMemo.Cast('<%= memoPasteExcel.ClientID %>');
                    if (!memo) {
                        alert('Paste box not found');
                        return;
                    }

                    // Put value into hidden field
                    document.getElementById('<%= hfPasteExcel.ClientID %>').value = memo.value;

                    // Trigger server import
                    __doPostBack('<%= btnImportPasteHidden.UniqueID %>', '');
                }
            </script>--%>
                    <script type="text/javascript">
                        function PR_OpenPasteExcel() {
                            if (typeof pcPasteExcel === "undefined") {
                                alert("Paste popup not found");
                                return;
                            }

                            pcPasteExcel.Show();

                            // focus memo after popup animation
                            setTimeout(function () {
                                var memo = ASPxClientMemo.Cast('<%= memoPasteExcel.ClientID %>');
                                if (memo) memo.Focus();
                            }, 150);
                        }
                    </script>

                    <%--Button group--%>
                    <div class="button-group mb-1">
                        <button type="button" runat="server" id="btnDeleteFocusRow" class="mx-0 btn btn-danger"
                            style="border-radius: 5px; float: right;">
                            <i class="ti ti-trash fs-4 me-2"></i>Delete Order
                        </button>


                        <button type="button" runat="server" id="btnExportToExel" class="btn btn-dark" onclick="grid.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px; float: right;">
                            <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                        </button>



                        <button type="button" runat="server" id="Button1" class="btn btn-primary"
                            onclick="PR_OpenPasteExcel();" style="border-radius: 5px; float: right;">
                            <i class="ti ti-cloud-download fs-4 me-2"></i>Paste from Excel
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
                                       <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbPRStatus" Checked="false" Text="PR Line Status" OnCheckedChanged="cb_CheckedChanged" AutoPostBack="True" />
                                        <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbPOInfo" Text="PO Information" OnCheckedChanged="cb_CheckedChanged" AutoPostBack="True" />
                                        
                                        
                                    </div>
                                </div>
                                <dx:ASPxGridView ID="gvLines" runat="server" KeyFieldName="LineNo" AutoGenerateColumns="False" ClientInstanceName="gvLines"
                                    OnCustomColumnDisplayText="gvLines_CustomColumnDisplayText"
                                    OnRowInserting="gvLines_RowInserting"
                                    OnRowUpdating="gvLines_RowUpdating"
                                    OnRowDeleting="gvLines_RowDeleting"
                                    OnInitNewRow="gvLines_InitNewRow"
                                    OnDataBinding="gvLines_DataBinding"
                                     OnHtmlDataCellPrepared="gvLines_HtmlDataCellPrepared">
                                    <SettingsPager PageSize="20" />
                                    <SettingsBehavior ConfirmDelete="true" />
                                    <SettingsEditing Mode="EditForm" PopupEditFormWidth="780" />
                                    <SettingsDataSecurity AllowEdit="True" AllowInsert="True" AllowDelete="True" />

                                    <Columns>
                                        <dx:GridViewCommandColumn ShowEditButton="true" ShowNewButtonInHeader="true" ShowDeleteButton="true" Width="110" />

                                        <dx:GridViewDataComboBoxColumn FieldName="Type" Caption="Type" Width="90" Name="colType">
                                            <PropertiesComboBox ValueType="System.Int32" DropDownStyle="DropDownList">
                                                <Items>
                                                    <dx:ListEditItem Text=" " Value="0" />
                                                    <dx:ListEditItem Text="G/L" Value="1" />
                                                    <dx:ListEditItem Text="Item" Value="2" />
                                                </Items>
                                                <%-- <ClientSideEvents ValueChanged="PR_TypeChanged" />--%>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataTextColumn FieldName="No" Caption="Item No" Width="150" Name="colItemNo">
                                            <EditItemTemplate>
                                                <dx:ASPxButtonEdit ID="beItemNo" runat="server" Width="100%"
                                                    Text='<%# Bind("No") %>'>
                                                    <Buttons>
                                                        <dx:EditButton Position="Right" Image-IconID="find_find_16x16" />
                                                    </Buttons>
                                                    <%-- <ClientSideEvents ButtonClick="PR_ItemNo_ButtonClick" />--%>
                                                    <ClientSideEvents ButtonClick="function(s,e){ PR_ItemNo_ButtonClick(s,e); }" />

                                                    <ValidationSettings ValidationGroup="NewOrderLine">
                                                        <RequiredField IsRequired="true" ErrorText="Item No must have a value." />
                                                    </ValidationSettings>
                                                </dx:ASPxButtonEdit>
                                            </EditItemTemplate>
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Width="260" />
                                        <dx:GridViewDataTextColumn FieldName="UOM" Caption="UOM" Width="80" />
                                        <%--<dx:GridViewDataTextColumn FieldName="Quantity" Caption="Qty" Width="90">

                                            <PropertiesTextEdit DisplayFormatString="#,0.####" />
                                        </dx:GridViewDataTextColumn>--%>
                                        <dx:GridViewDataSpinEditColumn
                                            FieldName="Quantity"
                                            Caption="Qty"
                                            Width="90">

                                            <PropertiesSpinEdit
                                                NumberType="Float"
                                                DecimalPlaces="4"
                                                DisplayFormatString="#,0.####"
                                                AllowMouseWheel="false" />
                                        </dx:GridViewDataSpinEditColumn>


                                        <dx:GridViewDataTextColumn FieldName="PurchReqPurpose" Caption="Purch Req. Purpose" Width="260">
                                            <Settings AllowAutoFilter="True" />
                                        </dx:GridViewDataTextColumn>

                                        <%--<dx:GridViewDataTextColumn FieldName="CostElement" Caption="Cost Element" Width="120" />
                                        <dx:GridViewDataTextColumn FieldName="ProjectCode" Caption="Project Code" Width="120" />--%>
                                        <dx:GridViewDataComboBoxColumn
                                            FieldName="ProjectCode"
                                            Caption="Project Code"
                                            Width="140"
                                            Name="colProjectCode">

                                            <PropertiesComboBox
                                                ClientInstanceName="cboProjectCode"
                                                ValueField="Code"
                                                TextField="Code"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="true"
                                                CallbackPageSize="30"
                                                IncrementalFilteringMode="Contains"
                                                ValueType="System.String"
                                                OnItemsRequestedByFilterCondition="cboProjectCode_ItemsRequested"
                                                OnItemRequestedByValue="cboProjectCode_ItemRequested">

                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Code" Caption="Code" Width="100" />
                                                    <dx:ListBoxColumn FieldName="Name" Caption="Name" Width="220" />
                                                </Columns>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn
                                            FieldName="CostElement"
                                            Caption="Cost Element"
                                            Width="140"
                                            Name="colCostElement">

                                            <PropertiesComboBox
                                                ClientInstanceName="cboCostElement"
                                                ValueField="Code"
                                                TextField="Code"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="true"
                                                CallbackPageSize="30"
                                                IncrementalFilteringMode="Contains"
                                                ValueType="System.String"
                                                OnItemsRequestedByFilterCondition="cboCostElement_ItemsRequested"
                                                OnItemRequestedByValue="cboCostElement_ItemRequested">

                                                <Columns>
                                                    <dx:ListBoxColumn FieldName="Code" Caption="Code" Width="100" />
                                                    <dx:ListBoxColumn FieldName="Name" Caption="Name" Width="220" />
                                                </Columns>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataTextColumn FieldName="PRLineStatus" Caption="PR Status" Width="110" EditFormSettings-Visible="False" ></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="PurchaseOrderNo" Caption="PO No" Width="130" />

                                        <dx:GridViewDataTextColumn FieldName="PO Quantity" Caption="PO Qty" Width="90" EditFormSettings-Visible="False">
                                            <PropertiesTextEdit DisplayFormatString="#,0.####" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="PO Receip Qty" Caption="Received" Width="90" EditFormSettings-Visible="False">
                                            <PropertiesTextEdit DisplayFormatString="#,0.####" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="PO Remain Qty" Caption="Remain" Width="90" EditFormSettings-Visible="False">
                                            <PropertiesTextEdit DisplayFormatString="#,0.####" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn FieldName="LineNo" Caption="LineNo" Width="120" Visible="false" />
                                    </Columns>



                                </dx:ASPxGridView>


                            </div>
                        </div>
                    </div>

                    <div class=" mt-4 mb-4" style="text-align: center;">
                        <dx:ASPxButton ID="btnSaveHeader" runat="server" Text="Save" Visible="false"
                            AutoPostBack="true" OnClick="btnSaveHeader_Click" />
                    </div>


                    <script type="text/javascript">
                        var PR_activeItemNoEditor = null;

                        function PR_ItemNo_ButtonClick(s, e) {
                            PR_activeItemNoEditor = s;

                            // Read current Type editor from the main grid in edit mode
                            // IMPORTANT: gvLines must have ClientInstanceName="gvLines"
                            var typeEditor = gvLines.GetEditor("Type");
                            var typeVal = typeEditor ? typeEditor.GetValue() : null; // 1=G/L, 2=Item

                            if (typeVal == 2) {
                                
                                pcItemLookup.Show();
                                gvItemLookup.PerformCallback("LOAD");

                            } else {
                                
                                pcGLLookup.Show();
                                gvGLLookup.PerformCallback("LOAD");
                            }
                        }

                        function PR_ItemLookup_RowDblClick(s, e) {
                            var idx = s.GetFocusedRowIndex();
                            if (idx < 0) return;

                            s.GetRowValues(idx, "No_;Description;BaseUOM", function (vals) {
                                var no = vals[0], desc = vals[1], baseUom = vals[2];

                                if (PR_activeItemNoEditor) {
                                    PR_activeItemNoEditor.SetText(no);
                                }

                                // Optional: fill description + UOM editors in main grid edit row
                                var edDesc = gvLines.GetEditor("Description");
                                if (edDesc) edDesc.SetValue(desc);

                                var edUom = gvLines.GetEditor("UOM");
                                if (edUom) edUom.SetValue(baseUom);

                                pcItemLookup.Hide();
                            });
                        }

                        function PR_GLLookup_RowDblClick(s, e) {
                            var idx = s.GetFocusedRowIndex();
                            if (idx < 0) return;

                            s.GetRowValues(idx, "No_;Name", function (vals) {
                                var no = vals[0], name = vals[1];

                                if (PR_activeItemNoEditor) {
                                    PR_activeItemNoEditor.SetText(no);
                                }

                                // Optional: put Name into Description
                                var edDesc = gvLines.GetEditor("Description");
                                if (edDesc) edDesc.SetValue(name);

                                // Optional: clear UOM for GL
                                var edUom = gvLines.GetEditor("UOM");
                                if (edUom) edUom.SetValue("");

                                pcGLLookup.Hide();
                            });
                        }
                    </script>


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
    <dx:ASPxPopupControl ID="pcItemLookup" runat="server" ClientInstanceName="pcItemLookup"
        Modal="True" CloseAction="CloseButton" HeaderText="Item Lookup"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="800px">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxGridView ID="gvItemLookup" runat="server" ClientInstanceName="gvItemLookup"
                    KeyFieldName="No_" AutoGenerateColumns="False"
                    OnCustomCallback="gvItemLookup_CustomCallback">
                    <SettingsBehavior AllowFocusedRow="true" />
                    <SettingsSearchPanel Visible="true" />
                    <SettingsPager PageSize="10" />
                    <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="No_" Caption="No." Width="140" />
                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Width="360" />
                        <dx:GridViewDataTextColumn FieldName="BaseUOM" Caption="Base UOM" Width="100" />
                    </Columns>
                    <ClientSideEvents RowDblClick="PR_ItemLookup_RowDblClick" />
                </dx:ASPxGridView>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxPopupControl ID="pcGLLookup" runat="server" ClientInstanceName="pcGLLookup"
        Modal="True" CloseAction="CloseButton" HeaderText="G/L Account Lookup"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="900">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxGridView ID="gvGLLookup" runat="server" ClientInstanceName="gvGLLookup"
                    KeyFieldName="No_" AutoGenerateColumns="False"
                    OnCustomCallback="gvGLLookup_CustomCallback">
                    <SettingsBehavior AllowFocusedRow="true" />
                    <SettingsSearchPanel Visible="true" />
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="No_" Caption="No." Width="140" />
                        <dx:GridViewDataTextColumn FieldName="Name" Caption="Name" Width="420" />
                    </Columns>
                    <ClientSideEvents RowDblClick="PR_GLLookup_RowDblClick" />
                </dx:ASPxGridView>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxCallback ID="cbPasteExcel" runat="server"
        ClientInstanceName="cbPasteExcel"
        EnableClientSideAPI="true"
        OnCallback="cbPasteExcel_Callback">
        <%--<ClientSideEvents CallbackComplete="cbPasteExcel_Complete" />--%>
    </dx:ASPxCallback>

    <%--<dx:ASPxPopupControl ID="pcPasteExcel" runat="server" ClientInstanceName="pcPasteExcel"
        HeaderText="Paste PR Lines (Excel)" Modal="True" CloseAction="CloseButton"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="900">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxMemo ID="memoPasteExcel" runat="server"
                    ClientInstanceName="memoPasteExcel"
                    Width="100%" Height="260" />

                <div style="margin-top: 10px; text-align: right;">
                    <dx:ASPxButton ID="btnImportPaste" runat="server" Text="Import"
                        AutoPostBack="true"
                        UseSubmitBehavior="false"
                        CausesValidation="false"
                        OnClick="btnImportPaste_Click" />

                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>--%>

    <dx:ASPxPopupControl ID="pcPasteExcel" runat="server" ClientInstanceName="pcPasteExcel"
    HeaderText="Paste PR Lines (Excel)" Modal="True" CloseAction="CloseButton"
    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Width="900">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            
            <div style="margin-bottom:8px;">
                Columns order: <b>Type</b>, <b>ItemNo</b>, <b>Description</b>, <b>Quantity</b>, <b>(optional) UOM</b>
            </div>

            <dx:ASPxMemo ID="memoPasteExcel" runat="server" ClientInstanceName="memoPasteExcel"
                Width="100%" Height="260" />

            <div style="margin-top:10px; text-align:right;">
               
                <dx:ASPxButton ID="btnImportPaste" runat="server" Text="Import"
                AutoPostBack="true"
                UseSubmitBehavior="false"
                CausesValidation="false"
                OnClick="btnImportPaste_Click" />


                <dx:ASPxButton ID="btnClosePaste" runat="server" Text="Close" AutoPostBack="false">
                    <ClientSideEvents Click="function(){ pcPasteExcel.Hide(); }" />
                </dx:ASPxButton>
            </div>

            

        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>


    <script type="text/javascript">
        function cbPasteExcel_Complete(s, e) {
            var ok = s.cpOK === true || s.cpOK === "true";
            var title = ok ? "Import completed" : "Import failed";
            var html = s.cpMessage || "";

            Swal.fire({
                icon: ok ? "success" : "error",
                title: title,
                html: html
            }).then(function () {
                if (ok) {
                    memoPasteExcel.SetText("");
                    pcPasteExcel.Hide();
                    // reload grid
                    gvLines.PerformCallback(); // or gvLines.Refresh();
                }
            });

            // cleanup
            s.cpOK = null;
            s.cpMessage = null;
        }
    </script>

</asp:Content>

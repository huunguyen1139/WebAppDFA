<%@ Page Title="Change Request Output Register" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="SubcontractingRequest.aspx.cs" Inherits="WebApp.production.SubcontractingRequest" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
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
   

    <div id="divModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="ModalHeader" class="modal-header rounded-top modal-colored-header text-white">
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
    <script type="text/javascript">
    function ShowPopup(title, body, class_style) {

        $("#divModal .modal-title").html(title);
        $("#divModal .modal-message").html(body);
        $("#divModal").modal("show");
        document.getElementById("ModalHeader").className = "modal-header modal-colored-header rounded-top text-white " + class_style;
    }
    </script>
    <!-- Modal Popup -->
   
  
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <!-- PAGE TITLE + ACTIONS -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="d-flex align-items-center">
                            <h4 class="mb-0 me-3">Subcontracting Request:
                                <asp:Literal ID="lblHeaderRequestID" runat="server" />
                            </h4>

                            <span id="spanStatus" runat="server" class="badge fs-6"></span>
                        </div>
                        <%--<div class="btn-group">
                            <asp:Button ID="btnNew"     runat="server" CssClass="btn btn-sm btn-success" Text="New" OnClick="btnNew_Click" />
                            <asp:Button ID="btnSave"    runat="server" CssClass="btn btn-sm btn-primary" Text="Save" OnClick="btnSave_Click" />
                            <asp:Button ID="btnRefresh" runat="server" CssClass="btn btn-sm btn-secondary" Text="Refresh" OnClick="btnRefresh_Click" />
                        </div>--%>
                    </div>
                   

                    <!-- HEADER CARD -->
                    <div class="card mb-3">
                        <div class="card-header py-2">
                            <strong>Request Header</strong>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <!-- Left column -->
                                <div class="col-md-6">
                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Request ID</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtRequestID" runat="server" CssClass="form-control form-control-sm" ReadOnly="true"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Requestor</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtRequestor" runat="server" CssClass="form-control form-control-sm" ReadOnly="true"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Request Date</label>
                                        <div class="col-sm-4">
                                            <asp:TextBox ID="txtRequestDate" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right column -->
                                <div class="col-md-6">
                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Description</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control form-control-sm" />
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Need Date</label>
                                        <div class="col-sm-4">
                                            <asp:TextBox ID="txtNeedDate" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Status</label>
                                        <div class="col-sm-4">
                                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm">
                                                <asp:ListItem Text="Open" Value="Open"></asp:ListItem>
                                                <asp:ListItem Text="Released" Value="Released"></asp:ListItem>
                                                <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                                                <asp:ListItem Text="Canceled" Value="Canceled"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div class="mb-2 row">
                                        <label class="col-sm-4 col-form-label col-form-label-sm">Remark</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtRemark" runat="server" CssClass="form-control form-control-sm" TextMode="MultiLine" Rows="2" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="button-group mb-1">
                        <button type="button" runat="server" id="btnDeleteRequest" class="mx-0 btn btn-danger"
                            onclick="javascript: return sweetAlertConfirm('ctl00$MainContent$btnDeleteRequest','You want to delete this order?');"
                            onserverclick="btnDeleteRequest_Click" style="border-radius: 5px; float: right;">
                            <i class="ti ti-trash fs-4 me-2"></i>Delete Order
                        </button>                       
                       
                        <div class="btn-group" style="border-radius: 5px; float: right;">
                            <button class="btn btn-warning dropdown-toggle" type="button" runat="server" id="btnChangeStatus" data-bs-toggle="dropdown" aria-expanded="false" style="border-radius: 5px;">
                                <i class="ti ti-ear fs-4 me-2"></i>Change Status
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton" style="">
                                <li>
                                    <asp:LinkButton runat="server" class="dropdown-item" ID="linkChangeStatusOpen" OnClick="linkChangeStatusOpen_Click" Text="Open"></asp:LinkButton></li>
                                <li>
                                    <asp:LinkButton runat="server" class="dropdown-item" ID="linkChangeStatusReleased" OnClick="linkChangeStatusReleased_Click" Text="Released"></asp:LinkButton>
                                </li> 
                               
                            </ul>
                        </div>

                        <button type="button" runat="server" id="btnExportToExel" class="btn btn-dark" onclick="gvLines.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px; float: right;">
                            <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                        </button>

                        <!--------- APPROVAL CUSTOM CONTROL --------------------------->                                
                        <uc:ApprovalFlow ID="ApprovalFlow1" runat="server" OnStatusChanged="ApprovalFlow1_StatusChanged"/> 
                    </div>

                    <!-- LINES CARD -->
                    <div class="card">
                        <div class="card-header py-2 d-flex justify-content-between align-items-center">
                            <strong>Request Lines</strong>

                            <div class="btn-group btn-group-sm">
                                <asp:Button ID="btnAddLine" runat="server" CssClass="btn btn-outline-success" Text="Add" OnClick="btnAddLine_Click" />
                                <asp:Button ID="btnDeleteLine" runat="server" CssClass="btn btn-outline-danger" Text="Delete" OnClick="btnDeleteLine_Click" />
                                <asp:Button ID="btnBestFit" runat="server" CssClass="btn btn-outline-secondary" Text="Best fit line" OnClick="btnBestFit_Click" />
                                <asp:Button ID="btnExport" runat="server" CssClass="btn btn-outline-warning" Text="Export" OnClick="btnExport_Click" />
                            </div>
                        </div>

                        <div class="card-body p-2">
                            <dx:ASPxGridView ID="gvLines" runat="server"
                                Width="100%"
                                ClientInstanceName="gvLines"
                                KeyFieldName="No_"
                                AutoGenerateColumns="False"
                                OnDataBinding="gvLines_DataBinding">
                                <Settings ShowGroupPanel="False" ShowFilterRow="True" ShowFooter="True" />
                                <SettingsPager PageSize="20" />
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                <SettingsExport EnableClientSideExportAPI="true" />

                                <Columns>
                                    <dx:GridViewCommandColumn ShowSelectCheckbox="true" VisibleIndex="0" Width="40px">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <CellStyle HorizontalAlign="Center" />
                                    </dx:GridViewCommandColumn>

                                    <dx:GridViewDataTextColumn FieldName="Routing" Caption="Routing" VisibleIndex="1" Width="100px">
                                        <CellStyle Wrap="False" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="PI No." Caption="PI No." VisibleIndex="2" Width="150px">
                                        <CellStyle Wrap="False" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="No_" Caption="PI Line No." VisibleIndex="3" Width="120px">
                                        <CellStyle Wrap="False" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Source No_" Caption="Source No." VisibleIndex="4" Width="150px">
                                        <CellStyle Wrap="False" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" VisibleIndex="5" Width="260px">
                                        <CellStyle Wrap="True" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataSpinEditColumn FieldName="Quantity" Caption="Quantity" VisibleIndex="6" Width="80px">
                                        <PropertiesSpinEdit DisplayFormatString="#,##0.####" />
                                        <CellStyle HorizontalAlign="Right" />
                                    </dx:GridViewDataSpinEditColumn>

                                    <dx:GridViewDataTextColumn FieldName="UOM" Caption="UOM" VisibleIndex="7" Width="70px">
                                        <CellStyle HorizontalAlign="Center" />
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataSpinEditColumn FieldName="Price" Caption="Price" VisibleIndex="8" Width="120px">
                                        <PropertiesSpinEdit DisplayFormatString="#,##0" />
                                        <CellStyle HorizontalAlign="Right" />
                                    </dx:GridViewDataSpinEditColumn>

                                    <dx:GridViewDataSpinEditColumn FieldName="Amount" Caption="Amount" VisibleIndex="9" Width="140px">
                                        <PropertiesSpinEdit DisplayFormatString="#,##0" />
                                        <CellStyle HorizontalAlign="Right" />
                                        <FooterCellStyle Font-Bold="true" />

                                    </dx:GridViewDataSpinEditColumn>

                                    <dx:GridViewDataTextColumn FieldName="Drawing Code" Caption="Drawing Code" VisibleIndex="10" Width="130px">
                                        <CellStyle Wrap="False" />
                                    </dx:GridViewDataTextColumn>
                                   

                                    <dx:GridViewDataTextColumn FieldName="Remark" Caption="Remark" VisibleIndex="13" Width="200px">
                                        <CellStyle Wrap="True" />
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                            </dx:ASPxGridView>
                        </div>
                    </div>
                </div>
            </div>
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

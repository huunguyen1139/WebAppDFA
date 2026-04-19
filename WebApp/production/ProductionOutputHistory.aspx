<%@ Page Title="Production Output History" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ProductionOutputHistory.aspx.cs" Inherits="WebApp.production.ProductionOutputHistory" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>

    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.css" />
    <!-- Import Js Files -->
    <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>

    <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <%--<script src="../masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

    <%-- select 2 --%>
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>

    <%-- Export to Excel --%>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/jszip.min.js"></script>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/FileSaver.min.js"></script>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/excel-gen.js"></script>

    <%-- load sweet alert --%>
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <!-- Loading Spinner -->
    <style>
        #loadingSpinner {
            display: none;
            position: fixed;
            z-index: 9999;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

            #loadingSpinner .spinner {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                font-size: 2rem;
                color: white;
            }
    </style>
    <div id="loadingSpinner">
        <div class="spinner">
            <i class="fa fa-spinner fa-spin"></i>Processing...
        </div>
    </div>

    <script type="text/javascript">
        function onDeleteButtonClick(s, e) {
            if (e.buttonID === "btnDelete") {
                var visibleIndex = e.visibleIndex;
                var rowKey = s.GetRowKey(visibleIndex); // RowIndex

                Swal.fire({
                    title: 'Are you sure?',
                    text: "Do you want to delete this record?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.value) {
                        showSpinner();
                        // Call server-side deletion through Grid callback
                        gridProductionOutput.PerformCallback('delete|' + rowKey);
                    }
                });
            }
        }



        // Spinner control
        function showSpinner() {
            document.getElementById("loadingSpinner").style.display = "block";
        }
        function hideSpinner() {
            document.getElementById("loadingSpinner").style.display = "none";
        }

        // Toast Notification after callback
        function onGridEndCallback(s, e) {
            debugger;
            hideSpinner();
            if (s.cpDeleteMessage) {
                let result = s.cpDeleteMessage;

                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    type: result.success ? 'success' : 'error',
                    title: result.message,
                    showConfirmButton: false,
                    timer: 3000
                });

                // Clear the custom property
                delete s.cpDeleteMessage;
            }
        }
    </script>



    <div id="divModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="ModalHeader" class="modal-header modal-colored-header rounded-top text-white">
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


    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card">
                        <div class="border-bottom title-part-padding rounded-top bg-body">
                            <h3 id="MainContent_txtDesciptionHeader" class="card-title mb-0 text-dark">Data Filter</h3>
                        </div>
                        <div class="card-body table-responsive">

                            <!-- Filter Panel -->
                            <div class="row">
                                <div class="col-md-3">
                                    <label for="fromDate" class="form-label">From Date</label>
                                    <asp:TextBox ID="fromDate" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                                <div class="col-md-3">
                                    <label for="toDate" class="form-label">To Date</label>
                                    <asp:TextBox ID="toDate" runat="server" CssClass="form-control" TextMode="Date" />
                                </div>
                                <div class="col-md-3">
                                    <label for="ddDepartment" class="form-label">Department</label>
                                    <asp:DropDownList ID="ddDepartment" runat="server" CssClass="form-control" Width="100%" Style="margin-bottom: 10px" AutoPostBack="True">
                                        <asp:ListItem Value="">-- All Departments --</asp:ListItem>                                       
                                        <asp:ListItem>WO</asp:ListItem>
                                        <asp:ListItem>RM</asp:ListItem>
                                        <asp:ListItem>FM</asp:ListItem>
                                        <asp:ListItem>AS</asp:ListItem>
                                        <asp:ListItem>SA</asp:ListItem>
                                        <asp:ListItem>SP</asp:ListItem>
                                        <asp:ListItem>FIN</asp:ListItem>
                                        <asp:ListItem>FIT</asp:ListItem>
                                        <asp:ListItem>IRON</asp:ListItem>
                                        <asp:ListItem>IRON_DM</asp:ListItem>
                                        <asp:ListItem>UPH</asp:ListItem>
                                        <asp:ListItem>TU</asp:ListItem>
                                        <asp:ListItem>PAC</asp:ListItem>
                                        <asp:ListItem>OT</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label for="ddToDepartment" class="form-label">To Department</label>
                                    <asp:DropDownList ID="ddToDepartment" runat="server" CssClass="form-control" Width="100%" Style="margin-bottom: 10px" AutoPostBack="True">
                                        <asp:ListItem Value="">-- All Departments --</asp:ListItem>
                                        <asp:ListItem>WO</asp:ListItem>
                                        <asp:ListItem>RM</asp:ListItem>
                                        <asp:ListItem>FM</asp:ListItem>
                                        <asp:ListItem>AS</asp:ListItem>
                                        <asp:ListItem>SA</asp:ListItem>
                                        <asp:ListItem>SP</asp:ListItem>
                                        <asp:ListItem>FIN</asp:ListItem>
                                        <asp:ListItem>FIT</asp:ListItem>
                                        <asp:ListItem>IRON</asp:ListItem>
                                        <asp:ListItem>IRON_DM</asp:ListItem>
                                        <asp:ListItem>UPH</asp:ListItem>
                                        <asp:ListItem>TU</asp:ListItem>
                                        <asp:ListItem>PAC</asp:ListItem>
                                        <asp:ListItem>OT</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div> 
                            <div class="row mx-0 mb-2">
                                <div class="col-md-12 px-0">
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbFullRevenue" Checked="false" Text="Full Revenue" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbProductName" Checked="false" Text="Product Name" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbProjectCode" Checked="false" Text="Project Code" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbProjectName" Checked="false" Text="Project Name" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbUpdatedDate" Checked="false" Text="Updated Date" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="border-bottom rounded-top title-part-padding bg-body">
                            <h3 class="card-title mb-0 text-dark">Production Output History</h3>
                        </div>
                        <div class="card-body pt-3 table-responsive">
                            <div class="button-group">
                                <button type="button" runat="server" id="btnApplyFilter" class="mx-0 btn btn-danger"                                    
                                    onserverclick="btnLoadData_Click" style="border-radius: 5px; float: right;">
                                    <i class="ti ti-loader fs-4 me-2"></i>Apply Filter
                                </button>
                                <button type="button" runat="server" id="btnExportToExel" class="btn btn-dark" onclick="gridProductionOutput.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px; float: right;">
                                    <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                                </button>
                            </div>
                            <dx:ASPxGridView ID="gridProductionOutput" EnablePagingGestures="False" runat="server" Width="100%" AutoGenerateColumns="False"
                                KeyFieldName="RowIndex" ClientInstanceName="gridProductionOutput"
                                OnCustomCallback="gridProductionOutput_CustomCallback" OnCustomButtonInitialize="gridProductionOutput_CustomButtonInitialize">
                                <Columns>
                                    <dx:GridViewCommandColumn Width="50px" ButtonRenderMode="Image" Caption=" ">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnDelete" Text="Delete">
                                                <Image ToolTip="Delete Row" Url="../images/delete_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>

                                    <dx:GridViewDataTextColumn FieldName="RowIndex" Caption="Row #" Width="50px" Visible="false"/>
                                    <dx:GridViewDataTextColumn FieldName="ProdOrderNo" Caption="Prod Order No" Width="110px" />
                                    <dx:GridViewDataTextColumn FieldName="Department" Caption="Dept." Width="60px" />
                                    <dx:GridViewDataTextColumn FieldName="ToDepartment" Caption="To Dept." Width="70px" />
                                    <dx:GridViewDataTextColumn FieldName="Quantity" Caption="Quantity" Width="85px" PropertiesTextEdit-DisplayFormatString="#,##0.##" />
                                    <dx:GridViewDataTextColumn FieldName="UOM" Caption="UOM" Width="45px" />
                                    <dx:GridViewDataTextColumn FieldName="ValueQuantity" Caption="Value Qty" Width="75px" PropertiesTextEdit-DisplayFormatString="#,##0.##" />
                                    <dx:GridViewDataTextColumn FieldName="RemainQuantity" Caption="Remain Qty" Width="85px" PropertiesTextEdit-DisplayFormatString="#,##0.##" />
                                    <dx:GridViewDataTextColumn FieldName="Price" Caption="Price" Width="90px" PropertiesTextEdit-DisplayFormatString="#,##0" />
                                    <dx:GridViewDataTextColumn FieldName="Percent" Caption="PC (%)" Width="60px" PropertiesTextEdit-DisplayFormatString="##0.##" />
                                    <dx:GridViewDataTextColumn FieldName="Revenue" Caption="Revenue" Width="120px" PropertiesTextEdit-DisplayFormatString="#,##0" />
                                    <dx:GridViewDataTextColumn FieldName="FullRevenue" Caption="Full Revenue" Width="120px" PropertiesTextEdit-DisplayFormatString="#,##0" />
                                    <dx:GridViewDataDateColumn FieldName="ProdOrderDate" Caption="Prod. Date" Width="140px" PropertiesDateEdit-DisplayFormatString="dd-MM-yy HH:mm" />
                                    <dx:GridViewDataDateColumn FieldName="UpdatedDate" Caption="Updated Date" Width="140px" PropertiesDateEdit-DisplayFormatString="dd-MM-yy HH:mm" />
                                    <dx:GridViewDataTextColumn FieldName="UpdatedUserID" Caption="U.Ref" Width="90px" />
                                    <dx:GridViewDataCheckColumn FieldName="isReceipt" Caption="Receipt?" Width="90px"></dx:GridViewDataCheckColumn>
                                    <dx:GridViewDataTextColumn FieldName="ProjectCode" Width="100px" />
                                    <dx:GridViewDataTextColumn FieldName="ProjectName" Width="400px" />
                                    <dx:GridViewDataTextColumn FieldName="FullName" Caption="Product Name" Width="500px" MaxWidth="500" />
                                </Columns>
                                <SettingsSearchPanel Visible="True"></SettingsSearchPanel>  
                                <SettingsExport EnableClientSideExportAPI="true" />
                                 <Settings ShowGroupFooter="VisibleIfExpanded" ShowFooter="true" ShowHeaderFilterButton="false" HorizontalScrollBarMode="Auto"/>
                                 <Settings ShowHeaderFilterButton="true" ShowFilterBar="Visible" ShowGroupPanel="true"/>
                                
                                 <SettingsFilterControl ViewMode="VisualAndText" AllowHierarchicalColumns="true" ShowAllDataSourceColumns="true" MaxHierarchyDepth="1" />
                                 <SettingsPopup>
                                     <HeaderFilter Height="200">
                                         <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                                     </HeaderFilter>
                                     <FilterControl>
                                         <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="768" />
                                     </FilterControl>
                                 </SettingsPopup>
                                <Styles>
                                    <AlternatingRow Enabled="true" />
                                    <Cell Wrap="False"></Cell>
                                </Styles>

                                <GroupSummary>
                                    <dx:ASPxSummaryItem FieldName="Revenue" SummaryType="Sum"  DisplayFormat="Sum: {0:n0}" />
                                </GroupSummary>
                                <TotalSummary>
                                     <dx:ASPxSummaryItem FieldName="ProdOrderNo" SummaryType="Count" />
                                    
                                     <dx:ASPxSummaryItem FieldName="Revenue" SummaryType="Sum" />
                                </TotalSummary> 

                                <ClientSideEvents CustomButtonClick="onDeleteButtonClick" />
                                <ClientSideEvents EndCallback="onGridEndCallback" />
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
                    <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

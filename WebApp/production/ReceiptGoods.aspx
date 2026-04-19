<%@ Page Title="Receipt Goods" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ReceiptGoods.aspx.cs" Inherits="WebApp.production.ReceiptGoods" %>
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
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        #loadingSpinner .spinner {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            font-size: 2rem;
            color: white;
        }
    </style>
    <div id="loadingSpinner">
        <div class="spinner">
            <i class="fa fa-spinner fa-spin"></i> Processing...
        </div>
    </div>

    <script type="text/javascript">
        // Single-row Receipt Confirmation
        function grid_CustomButtonClick(s, e) {
            var rowIndex = s.GetRowKey(e.visibleIndex);
            Swal.fire({
                title: 'Are you sure?',
                text: "You are about to receipt this row.",
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, receipt it!'
            }).then((result) => {
                if (result.value) {
                    showSpinner();
                    grid.PerformCallback("receipt|" + rowIndex);
                }
            });
        }

        // Batch Receipt Confirmation
        function processSelectedRows() {
            var selectedCount = grid.GetSelectedRowCount();
            if (selectedCount === 0) {
                Swal.fire('No rows selected', 'Please select at least one row to process.', 'info');
                return;
            }

            Swal.fire({
                title: 'Process all selected rows?',
                text: "This will receipt all selected rows.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, process them!',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33'
            }).then((result) => {
                if (result.isConfirmed) {
                    showSpinner();
                    grid.PerformCallback("batchReceipt");
                }
            });
        }

        // Spinner control
        function showSpinner() {
            document.getElementById("loadingSpinner").style.display = "block";
        }
        function hideSpinner() {
            document.getElementById("loadingSpinner").style.display = "none";
        }

        // Toast Notification after callback
        function grid_Endcallback(s, e) {
            debugger;
            hideSpinner();
            if (grid.cpResult) {
                var resultParts = grid.cpResult.split('|');
                var type = resultParts[0]; // success or error
                var msg = resultParts[1];

                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    type: type,
                    title: msg
                });
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
                       <div class="card-body table-responsive">
                           <div class="button-group">
                                <button type="button" runat="server" id="btnDeleteFocusRow" class="mx-0 btn btn-danger"
                                    onclick=" processSelectedRows();"
                                    style="border-radius: 5px; float: right;">
                                    <i class="ti ti-access-point fs-4 me-2"></i>Receipt Selected Rows
                                </button>                                
                           </div>

                           <dx:ASPxGridView ID="gridReceiptGoods" runat="server" AutoGenerateColumns="False"
                               KeyFieldName="RowIndex" Width="100%" ClientInstanceName="grid" 
                               OnCustomCallback="gridReceiptGoods_CustomCallback" EnablePagingGestures="False">

                               <SettingsBehavior AllowSelectByRowClick="true"/>
                               <Settings ShowFilterRow="True" ShowGroupPanel="True" HorizontalScrollBarMode="Hidden"/>                               
                               
                               <Columns>
                                   <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" />
                                   <dx:GridViewDataTextColumn FieldName="ProdOrderDate" Caption="Prod. Date" PropertiesTextEdit-DisplayFormatString="dd-MM-yy" CellStyle-Wrap="False" />
                                   <dx:GridViewDataTextColumn FieldName="ProdOrderNo" Caption="Order No" CellStyle-Wrap="False" />
                                   <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="Item Code" CellStyle-Wrap="False"  />
                                   <dx:GridViewDataTextColumn FieldName="FullName" Caption="Item Name" CellStyle-Wrap="False"  />
                                   <dx:GridViewDataTextColumn FieldName="Department" Caption="Department" CellStyle-Wrap="False"  />
                                   <dx:GridViewDataTextColumn FieldName="ToDepartment" Caption="ToDepartment" CellStyle-Wrap="False"  />
                                   <dx:GridViewDataTextColumn FieldName="UpdatedUser" Caption="UpdatedUser" CellStyle-Wrap="False"  />
                                   <dx:GridViewDataTextColumn FieldName="Quantity" Caption="Quantity" PropertiesTextEdit-DisplayFormatString="#0.####" />
                                   <dx:GridViewDataTextColumn FieldName="RemainQuantity" Caption="Remain Qty" PropertiesTextEdit-DisplayFormatString="#0.####"  />
                                   <dx:GridViewCommandColumn Caption="Action" ButtonType="Button" Width="150px">
                                       <CustomButtons>
                                           <dx:GridViewCommandColumnCustomButton ID="btnReceipt" Text="Receipt" />
                                       </CustomButtons>
                                   </dx:GridViewCommandColumn>
                               </Columns>

                               <ClientSideEvents CustomButtonClick="grid_CustomButtonClick" />
                               <ClientSideEvents EndCallback="grid_Endcallback" />
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

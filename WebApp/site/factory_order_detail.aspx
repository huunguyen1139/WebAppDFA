<%@ Page Title="Factory Order Detail" ValidateRequest="false" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="factory_order_detail.aspx.cs" Inherits="WebApplication2.factory_order_detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
    <%--    <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>--%>
    <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <%--<script src="../masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <!--<script src="../masterskin/MaterialPro/dist/assets/js/dashboards/dashboard4.js"></script>-->
    <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    
    <!-- Skin Material P -->

    <!-- select 2 -->
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>

    <!-- load sweet alert -->
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />
        
    <!-- Call hiden upload button click to trigger server side -->
    <script>
        window.addEventListener('load', function () {
            const fileUploader = document.getElementById('<%=fileUploader.ClientID%>');
            if (fileUploader) {
                fileUploader.addEventListener('change', function () {
                    const file = this.files[0];
                    if (!file) return;
                    debugger;
                    const allowedTypes = [
                        'image/jpeg',         // .jpg
                        'image/png',          // .png
                        'application/pdf',    // .pdf
                        'application/zip',    // .zip
                        'application/x-zip-compressed', // alternate zip
                        'application/x-compressed',
                        'application/x-rar-compressed',
                        'application/acad',   // .dwg (not always accurate)
                        'application/octet-stream' // fallback (for .dwg)
                    ];
                    const maxSize = 8 * 1024 * 1024;

                    if (!allowedTypes.includes(file.type)) {
                        alert('❌ Invalid file type. Only JPG, PNG, PDF, ZIP, RAR, or DWG files are allowed.');
                        this.value = '';
                        return;
                    }

                    if (file.size > maxSize) {
                        alert('❌ File too large. File Size < 8MB');
                        this.value = '';
                        return;
                    }
                 
                    document.getElementById('<%= btnRealUpload.ClientID %>').click();
                    //__doPostBack('UploadFile', '');
                });
            }
        });
    </script>

    <!-- call sweet alert -->
    <script type="text/javascript">
        function sweetAlertConfirm(clientid, text) {
            debugger;            
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

    

    <!-- Show popup and grid custom button click -->
    <script type="text/javascript">
        function ShowPopup(title, body, class_style) {
            debugger;
            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").className = "modal-header modal-colored-header rounded-top text-white " + class_style;

        }

        function ShowDrawingUploadPopup() {
            $("#divModalUploadDrawing").modal("show");

        }

        function ShowDrawingUploadPopupByItem() {
            $("#divModalUploadDrawingByItem").modal("show");

        }
        
        function OnEndCallback(s, e) {
            debugger;
            if (s.cpSuccessMessage) {

                Swal.fire({
                    type: 'success',
                    title: 'Saved!',
                    text: 'All changes have been saved successfully.',
                    timer: 2500,
                    showConfirmButton: false
                });
                s.cpSuccessMessage = null;
            }
        }

        function onBeginCallBack(s, e) {
            if (e.command === "DELETEROW") {
                if (!confirm("Are you sure you want to delete this row?")) {
                    e.cancel = true;
                }
            }
        }

        function onCustomButtonClick(s, e) {
            // Check if the clicked button is our custom delete button           
            if (e.buttonID === "btnCustomDelete") {
                Swal.fire({
                    title: 'Confirmation',
                    text: 'Are you sure you want to delete this row?',
                    type: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes!'
                }).then(function (result) {

                    if (result.value) {
                       
                        s.DeleteRow(e.visibleIndex); // Delete the row if confirmed
                    }
                })
                // Do not process on server, we handle it here
                e.processOnServer = false;
            }

            if (e.buttonID === 'btnViewDrawing') {
                debugger;
                var baseUrl = window.location.origin;
                var grid = s;
                var rowIndex = e.visibleIndex;
                grid.GetRowValues(rowIndex, 'FilePath', function (filePath) {
                    if (filePath) {
                        debugger;
                        // Replace the UNC path prefix with base domain
                        var replacedPath = filePath.replace('\\\\192.168.1.244\\\\alliance_new\\\\ERP', '');
                        replacedPath = replacedPath.replace('\\\\192.168.1.244\\alliance_new\\ERP', '');
                        // Replace backslashes with forward slashes for browser URLs
                        replacedPath = replacedPath.replace(/\\\\/g, '/').replace(/\\/g, '/');

                        var fullUrl = baseUrl + replacedPath;
                        window.open(fullUrl, '_blank');
                    }
                });
            }
            
            if (e.buttonID === 'btnCustomViewDrawingByItem') {
                debugger;
                var baseUrl = window.location.origin;
                var grid = s;
                var rowIndex = e.visibleIndex;
                grid.GetRowValues(rowIndex, 'SDFilePath', function (filePath) {
                    if (filePath) {
                        debugger;
                        // Replace the UNC path prefix with base domain
                        var replacedPath = filePath.replace('\\\\192.168.1.244\\alliance_new\\ERP', '');
                        replacedPath = replacedPath.replace('\\\\192.168.1.244\\\\alliance_new\\\\ERP', '');
                        // Replace backslashes with forward slashes for browser URLs
                        replacedPath = replacedPath.replace(/\\\\/g, '/').replace(/\\/g, '/');

                        var fullUrl = baseUrl + replacedPath;
                        window.open(fullUrl, '_blank');
                    }
                });
            }

            if (e.buttonID === 'btnViewDrawingGridUploadDrawingByItem') {
                debugger;
                var baseUrl = window.location.origin;
                var grid = s;
                var rowIndex = e.visibleIndex;
                grid.GetRowValues(rowIndex, 'FilePath', function (filePath) {
                    if (filePath) {
                        debugger;
                        // Replace the UNC path prefix with base domain
                        var replacedPath = filePath.replace('\\\\192.168.1.244\\\\alliance_new\\\\ERP', '');
                        // Replace backslashes with forward slashes for browser URLs
                        replacedPath = replacedPath.replace(/\\\\/g, '/').replace(/\\/g, '/');

                        var fullUrl = baseUrl + replacedPath;
                        window.open(fullUrl, '_blank');
                    }
                });
            }
            

            //show upload drawing by item popup
            if (e.buttonID === 'btnCustomUploadDrawingByItem') {
                debugger;
                var grid = s;
                var rowIndex = e.visibleIndex;
                var hiddenField = document.getElementById('<%= hdnStatus.ClientID %>');

                if (hiddenField.value == '1' || hiddenField.value == '4') {
                    Swal.fire({
                        type: "error",
                        title: "Oops...",
                        text: "The system does not allow upload drawing for Released Order!"                        
                    });
                    return;
                }

                grid.GetRowValues(rowIndex, 'No_', function (itemNo) {
                    if (itemNo) {
                        debugger;
                        document.getElementById('<%= hdnItemCode.ClientID %>').value = itemNo;
                        ShowDrawingUploadPopupByItem();
                    }
                });
            }

            //show pick file to select file    
            if (e.buttonID === 'btnUploadDrawingGridUploadDrawingByItem') {
                var rowKey = s.GetRowKey(e.visibleIndex);
                document.getElementById('<%= hdnRowKey.ClientID %>').value = rowKey;
                document.getElementById('<%=fileUploader.ClientID%>').click();
            }

            //show pick file to select file    
            if (e.buttonID === 'btnUploadDrawingGridUploadDrawingByItem_New') {
                debugger;
                alert('fff');
                var rowKey = s.GetRowKey(e.visibleIndex);
                document.getElementById('<%= hdnRowKey.ClientID %>').value = rowKey;
                
                let input = uploadControl.GetBrowseButtonInput();

                if (input) {
                    input.click(); // 🟢 This is now a real user-initiated click
                } else {
                    alert("Upload control not ready.");
                }
                //dsds
                
                }

            if (e.buttonID === 'btnDownload') {
                var baseUrl = window.location.origin;
                var grid = s;
                var rowIndex = e.visibleIndex;
                grid.GetRowValues(rowIndex, 'FilePath', function (filePath) {
                    if (filePath) {
                        var virtualPath = filePath.replace('\\\\192.168.1.244\\\\alliance_new\\\\ERP', '');
                        virtualPath = virtualPath.replace(/\\\\/g, '/').replace(/\\/g, '/');
                        var fullUrl = baseUrl + virtualPath;

                        // Force download using an invisible link
                        var link = document.createElement('a');
                        link.href = fullUrl;
                        link.download = virtualPath.split('/').pop(); // Optional: extract filename
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);
                    }
                });
            }
        }
    </script>
    


    <!-- script call server-side for dropdown button in grid -->
    <script type="text/javascript">
        function deleteRow(id) {
            if (confirm("Delete row ID " + id + "?")) {
                cbAction.PerformCallback("delete|" + id);
            }
        }


        function UpdateRoutingForItemAndProdOrder(item_no, documentno, lineno, routing) {
            //if (confirm("Change ROUTING of " + item_no + " to " + routing + "?")) {
                cbAction.PerformCallback("updaterouting|" + item_no + "|" + documentno + "|" + lineno + "|" + routing);
            //}
        }

        function editRow(id) {
            alert("Client-side edit for ID: " + id);
            // You can also call cbAction.PerformCallback("edit|" + id);
        }

        function OnCallbackComplete() {           
            grid.PerformCallback();   // rebind grid after SQL update
        }
    </script>
    <script type="text/javascript">
        function ShowSplitLinePopup(documentNo, lineNo, qty) {
        // block if Released/Completed
        <%--var status = document.getElementById('<%= hdnStatus.ClientID %>')?.value || "0";
        if (status !== "0") {
            ShowPopup('POR System', 'Status must be Open! You cannot split line when Released/Completed.', 'bg-danger');
            return;
        }--%>

            document.getElementById('<%= hdnSplitDocumentNo.ClientID %>').value = documentNo;
            document.getElementById('<%= hdnSplitLineNo.ClientID %>').value = lineNo;
            document.getElementById('<%= hdnSplitOriginalQty.ClientID %>').value = qty;

            document.getElementById('lblSplitOriginalQty').innerText = qty;
            document.getElementById('txtSplitQty').value = '';

            var modal = new bootstrap.Modal(document.getElementById('divModalSplitLine'));
            modal.show();
        }

        function ConfirmSplitLine() {
            var doc = document.getElementById('<%= hdnSplitDocumentNo.ClientID %>').value;
                   var line = document.getElementById('<%= hdnSplitLineNo.ClientID %>').value;
                   var origQty = parseFloat(document.getElementById('<%= hdnSplitOriginalQty.ClientID %>').value || "0");

            var splitQty = parseFloat(document.getElementById('txtSplitQty').value || "0");
            if (!splitQty || splitQty <= 0) {
                Swal.fire({ type: 'error', title: 'Invalid qty', text: 'Split qty must be > 0.' });
                return;
            }
            if (splitQty >= origQty) {
                Swal.fire({ type: 'error', title: 'Invalid qty', text: 'Split qty must be LESS than original qty.' });
                return;
            }

            // close modal
            var modalEl = document.getElementById('divModalSplitLine');
            var instance = bootstrap.Modal.getInstance(modalEl);
            if (instance) instance.hide();

            cbAction.PerformCallback("splitline|" + doc + "|" + line + "|" + splitQty);
        }


        function OnCallbackComplete(s, e) {
            //alert('init function after call back');
            //alert('message: ' + s.cpMessage)
            if (s.cpMessage) {
                //alert('enter in core cb');
                var type = s.cpMessageType || "success";
                Swal.fire({
                    type: type,
                    title: (type === "success" ? "Success" : "Error"),
                    text: s.cpMessage
                });
                s.cpMessage = null;
                s.cpMessageType = null;
            }
            grid.PerformCallback();
        }
    </script>
    <dx:ASPxCallback ID="cbAction" runat="server" ClientInstanceName="cbAction" OnCallback="cbAction_Callback" >
       <ClientSideEvents CallbackComplete="OnCallbackComplete" />
    </dx:ASPxCallback>
    

    <!-- script call server-side for popup detail -->
    <script type="text/javascript">
        function onDetailButtonClick(el) {   
            debugger;
            var grid1 = grid;
            var lineno = el.getAttribute("data-key");           

            showDetailPopup(el, lineno);
            return false;           
            
        }


        function showDetailPopup(link, key) {
            debugger;
            popup.ShowAtElement(link);  
            callbackPanel.PerformCallback(key);            
        }       

        function showLightbox(src) {
            document.getElementById("lightboxImage").src = src;
            var modal = new bootstrap.Modal(document.getElementById('lightboxModal'));
            modal.show();
        }
    </script>
  
    <script type="text/javascript">
        // ▸ Show SweetAlert2 with a textarea for comment, require user input
        function onReturnOrderClick() {
            Swal.fire({
                title: 'Return Order',
                text: 'Provide a reason / instructions for the creator:',
                input: 'textarea',
                inputLabel: 'Return comment',
                inputPlaceholder: 'Why is this order being returned? What needs to change?',
                inputAttributes: { 'aria-label': 'Return comment', rows: 6 },
                showCancelButton: true,
                confirmButtonText: 'Confirm Return',
                cancelButtonText: 'Cancel',
                focusConfirm: false,
                preConfirm: (value) => {
                    if (!value || value.trim().length === 0) {
                        Swal.showValidationMessage('Please enter a comment to proceed');
                        return false;
                    }
                    return value.trim();
                }
            }).then(function (result) {
                if (result.value) {
                    // ▸ Set hidden fields, then trigger postback to LinkButton
                    document.getElementById('<%= hfReturnComment.ClientID %>').value = result.value;
                    document.getElementById('<%= hfReturnConfirmed.ClientID %>').value = '1';
                    // ▸ Force postback of the Return Order LinkButton
                    __doPostBack('<%= linkReturnOrder.UniqueID %>', '');
            }
        });

            // ▸ Cancel the default LinkButton click; we’ll manually postback after confirm
            return false;
        }
    </script>        
    <!-- Bootstrap -->

    <!-- Modal Popup -->
    <div runat="server" id="divModalForFullPostBack" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div runat="server" id="divModalHeader" class="modal-header modal-colored-header text-white">
                    <h4 class="modal-title">POR System
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

    <%--modal message template--%>
    <div id="divModal" class="modal fade" data-bs-backdrop="static">
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

    <%--modal upload drawing by order --%>
    <div id="divModalUploadDrawing" class="modal fade" data-bs-backdrop="static">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header modal-colored-header text-white bg-primary">
                    <h4 class="modal-title text-white">Upload Drawing
                    </h4>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="card-body">
                        <div class="mb-4">
                            <label for="ddDrawingType" class="form-label">Drawing Type</label>
                            <asp:DropDownList runat="server" ID="ddDrawingType" CssClass="form-control">
                                <asp:ListItem Text="--Choose drawing type--" Value=""></asp:ListItem>
                                <asp:ListItem Text="Shop Drawing" Value="3"></asp:ListItem>
                                <asp:ListItem Text="Construction Drawing" Value="4"></asp:ListItem>
                            </asp:DropDownList>

                            <asp:RequiredFieldValidator ID="rfvDrawingType" runat="server"
                                ControlToValidate="ddDrawingType"
                                InitialValue=""
                                ErrorMessage="Please select drawing type"
                                CssClass="text-danger"
                                Display="Dynamic" ValidationGroup="UploadDrawingByOrder"/>
                        </div>
                        <div class="mb-4">
                            <label for="fileUpload" class="form-label">File Import</label>
                            <asp:FileUpload ID="fileUpload" CssClass="form-control" AllowMultiple="false" runat="server" />
                            <asp:CustomValidator ID="cvFileUpload" runat="server"
                                ControlToValidate="fileUpload"
                                OnServerValidate="cvFileUpload_ServerValidate"
                                ErrorMessage="Please select a file to upload"
                                CssClass="text-danger"
                                Display="Dynamic"
                                ValidateEmptyText="true" ValidationGroup="UploadDrawingByOrder" />
                            <div class="row mt-3">
                                <asp:Label runat="server" ID="lbFileUploadDescription" Style="padding: 0px 20px;" CssClass="help-block" Text="(Accept file *.dwg, *.zip, *.xls, *.xlsx, *.doc, *.docx, *.pdf, *.png, *.jpg. File size <= 15MB)"></asp:Label>
                            </div>
                        </div>
                        <div class="table-responsive mb-4">
                            <label for="fileUpload" class="form-label">File History</label>
                            <dx:ASPxGridView runat="server" OnCustomColumnDisplayText="gridDrawingHistory_CustomColumnDisplayText" ID="gridDrawingHistory" Width="100%" AutoGenerateColumns="false">
                                <Columns>
                                    <dx:GridViewCommandColumn ButtonRenderMode="Image" Caption=" " VisibleIndex="0">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnViewDrawing" Text="View File">
                                                <Image ToolTip="View File" Url="../images/view_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataTextColumn FieldName="Drawing Code" ReadOnly="True" Name="OrderNo" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Type" ReadOnly="True" Name="Type" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" Name="Description" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UploadDate" ReadOnly="True" Name="UploadDate" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy HH:mm"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UploadUser" ReadOnly="True" Name="UploadUser" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="FilePath" ReadOnly="True" Name="FilePath" VisibleIndex="-1" Visible="false"></dx:GridViewDataTextColumn>
                                </Columns>

                                <Styles>
                                    <AlternatingRow Enabled="true" />
                                </Styles>

                                <ClientSideEvents CustomButtonClick="onCustomButtonClick" />
                            </dx:ASPxGridView>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                        <i class="ti ti-clear-all fs-4 me-2"></i>Close
                    </button>
                    <button runat="server" id="btnUploadDrawingByOrder" onserverclick="btnUploadDrawingByOrder_ServerClick" type="button" class="btn btn-danger" 
                        causesvalidation="true" validationgroup="UploadDrawingByOrder" >
                        <i class="ti ti-cloud-upload fs-4 me-2"></i>Upload
                    </button>

                </div>
            </div>
        </div>
    </div>

    <%--modal upload drawing by item --%>       
    <div id="divModalUploadDrawingByItem" class="modal fade" data-bs-backdrop="static">
         <asp:Button ID="btnRealUpload" runat="server" Text="Upload" 
         OnClick="btnRealUpload_Click" style="display:none;" />
         <input type="file" id="fileUploader" runat="server" style="display:none;" />    
         <asp:HiddenField ID="hdnRowKey" runat="server" />
         <asp:HiddenField ID="hdnItemCode" runat="server" />
         <asp:HiddenField ID="hdnStatus" runat="server" />
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header modal-colored-header text-white bg-primary">
                    <h4 class="modal-title text-white">Upload Drawing By Item
                    </h4>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-4">
                                <label for="ddDrawingTypeGridItem" class="form-label">Drawing Type</label>
                                <asp:DropDownList runat="server" ID="ddDrawingTypeGridItem" CssClass="form-control">
                                    <asp:ListItem Text="--Choose drawing type--" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Shop Drawing" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="Construction Drawing" Value="4"></asp:ListItem>
                                </asp:DropDownList>

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                    ControlToValidate="ddDrawingTypeGridItem"
                                    InitialValue=""
                                    ErrorMessage="Please select drawing type"
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="UploadDrawingByItem" />
                            </div>
                            <div class="col-4">
                                <label for="txtDrawingCode" class="form-label">Drawing Code</label>
                                <asp:TextBox runat="server" ID="txtDrawingCode" CssClass="form-control"></asp:TextBox>
                                <asp:CustomValidator ID="cvDrawingCode" runat="server"
                                    ControlToValidate="txtDrawingCode"
                                    OnServerValidate="cvDrawingCode_ServerValidate"
                                    ErrorMessage="Please input drawing code"
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidateEmptyText="true" ValidationGroup="UploadDrawingByItem" />
                               
                            </div>
                            <div class="col-2"> 
                                <button runat="server" id="btnAddDrawingCode" onserverclick="btnAddDrawingCode_ServerClick" type="button"
                                    class="mt-7 btn btn-primary" causesvalidation="true" validationgroup="UploadDrawingByItem">
                                    <i class="ti ti-plus fs-4 me-2"></i>Add New
                                </button>
                            </div>
                        </div>
                       <dx:ASPxUploadControl ID="uploadControl" runat="server" Visible="false"
                            ClientInstanceName="uploadControl"
                            UploadMode="Auto"
                            ShowProgressPanel="true"
                            OnFileUploadComplete="uploadControl_FileUploadComplete"
                            ValidationSettings-AllowedFileExtensions=".jpg,.png,.pdf,.zip,.dwg"
                            ValidationSettings-MaxFileSize="5242880"
                            BrowseButton-Text="Select File"
                            style="display:none;" />
                        <div class="table-responsive mb-4">
                            <label for="fileUpload" class="form-label">File History</label>
                            <dx:ASPxGridView runat="server" OnCustomColumnDisplayText="gridDrawingHistory_CustomColumnDisplayText" 
                                ID="gridUploadDrawingByItem" Width="100%" AutoGenerateColumns="false" KeyFieldName="KeyField">
                                <Columns>
                                    <dx:GridViewCommandColumn ButtonRenderMode="Image" Caption=" " VisibleIndex="0">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnViewDrawingGridUploadDrawingByItem" Text="View File">
                                                <Image ToolTip="View File" Url="../images/view_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnUploadDrawingGridUploadDrawingByItem" Text="View File">
                                                <Image ToolTip="Upload Drawing File (Accept file *.dwg, *.zip, *.pdf, *.png, *.jpg. File size <= 15MB)" Url="../images/upload1_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                        <%--<CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnUploadDrawingGridUploadDrawingByItem_New" Text="View File">
                                                <Image ToolTip="Upload Drawing File (Accept file *.dwg, *.zip, *.pdf, *.png, *.jpg. File size <= 15MB)" Url="../images/upload1_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>--%>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataTextColumn FieldName="Drawing Code" ReadOnly="True" Name="DrawingCode" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Type" ReadOnly="True" Name="Type" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" Name="Description" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UploadDate" ReadOnly="True" Name="UploadDate" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy HH:mm"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UploadUser" ReadOnly="True" Name="UploadUser" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="FilePath" ReadOnly="True" Name="FilePath" VisibleIndex="-1" Visible="false"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Version Code" ReadOnly="True" Name="VersionCode" VisibleIndex="-1" Visible="false"></dx:GridViewDataTextColumn>
                                </Columns>
                                
                                <Styles>
                                    <AlternatingRow Enabled="true" />
                                </Styles>
                                <SettingsBehavior AllowFocusedRow="true" />
                                <SettingsPager Mode="ShowPager" PageSize="4"></SettingsPager>
                                <SettingsSearchPanel Visible="True"></SettingsSearchPanel>
                                <ClientSideEvents CustomButtonClick="onCustomButtonClick" />
                            </dx:ASPxGridView>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-dark" data-bs-dismiss="modal">
                        <i class="ti ti-clear-all fs-4 me-2"></i>Close
                    </button>
                    
                    <button runat="server" id="btnSelectAndApplyDrawingCodeToItem" onserverclick="btnSelectAndApplyDrawingCodeToItem_ServerClick" type="button" class="btn btn-danger">
                        <i class="ti ti-cloud-upload fs-4 me-2"></i>Select Drawing
                    </button>

                </div>
            </div>
        </div>
    </div>        
    
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
       
    <!-- Popup show detail info -->    
    <dx:ASPxPopupControl ID="popupDetail" runat="server" ClientInstanceName="popup" Modal="true"
        PopupAction="None" CloseAction="CloseButton" AllowResize="false"
        Width="800px" HeaderText="Detail Information" OnCallback="popupDetail_Callback" EnableCallbackMode="true">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel ID="callbackPanel" runat="server"
                ClientInstanceName="callbackPanel"
                OnCallback="callbackPanel_Callback">
                
                <PanelCollection>
                    <dx:PanelContent id="panelContent" runat="server">
                        <div id="popupContent" runat="server">
                            Loading...
                        </div>
                    </dx:PanelContent>
                </PanelCollection>

            </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <HeaderStyle CssClass="border-bottom title-part-padding bg-pr1imary rounded-top"  Font-Bold="true" />
        <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="800" />
      
    </dx:ASPxPopupControl>
    <!-- Modal Popup -->

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card">
                        <div class="border-bottom rounded-top title-part-padding bg-body">
                            <h4 id="txtDesciptionHeader" runat="server" class="card-title mb-0 text-dark">Blanket Factory Order</h4>
                        </div>

                        <div class="card-body table-responsive">
                            <div class="row mx-0 mb-2">
                                <div class="col-md-12 px-0">
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbPrice" Text="Price" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbParentRemark" Text="Remark" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbGroup" Checked="true" Text="Group" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbSubGroup" Checked="false" Text="Sub Group" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDrawing" Checked="false" Text="Drawing" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDimension" Checked="false" Text="Dimension" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbFinish" Checked="false" Text="Finishing" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbSiteDescription" Checked="false" Text="Site Description" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDate" Text="Date" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />
                                    <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbSearchPanel" Text="Search Panel" OnCheckedChanged="ShowOrHideColumns" AutoPostBack="True" />

                                </div>
                            </div>

                            <div class="input-group mb-3 mt-3" bis_skin_checked="1">
                                <asp:TextBox runat="server" ID="txtSiteRemark" placeholder="Input Order Remark and press Enter to save" CssClass="form-control" Enabled="true" AutoPostBack="false"></asp:TextBox>
                                <asp:Button ID="btnSaveSiteRemark" runat="server" Style="display: none;" OnClick="btnSaveSiteRemark_Click" />
                            </div>
                            <div class="button-group mb-1">
                                <button type="button" runat="server" id="btnDeleteFocusRow" class="mx-0 btn btn-danger"
                                    onclick="javascript: return sweetAlertConfirm('ctl00$MainContent$btnDeleteFocusRow','You want to delete this order?');"
                                    onserverclick="btnDeleteFocusRow_Click" style="border-radius: 5px; float: right;">
                                    <i class="ti ti-trash fs-4 me-2"></i>Delete Order
                                </button>
                                <button type="button" runat="server" visible="false" id="btnUploadDrawing" class="btn btn-success" onclick="ShowDrawingUploadPopup();"
                                    style="border-radius: 5px; float: right;">
                                    <i class="ti ti-cloud-upload fs-4 me-2"></i>Upload Drawing
                                </button>
                                <button type="button" runat="server" id="btnViewRelatedProductionOrder" class="btn btn-primary" onserverclick="btnViewRelatedProductionOrder_ServerClick" style="border-radius: 5px; float: right;">
                                    <i class="ti ti-direction-sign fs-4 me-2"></i>Production Status
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
                                        <li>
                                            <asp:LinkButton runat="server" class="dropdown-item" ID="linkChangeStatusCompleted" OnClientClick="return confirm('Are you sure you want to Change status to COMPLETED?')" OnClick="linkChangeStatusCompleted_Click" Text="Completed"></asp:LinkButton>
                                        </li>

                                        <!-- ▸ NEW: Return Order (SweetAlert2 confirm + comment) -->
                                        <li>
                                            <asp:LinkButton runat="server" CssClass="dropdown-item text-danger fw-semibold"
                                                ID="linkReturnOrder" Text="Return Order"
                                                OnClientClick="return onReturnOrderClick();" OnClick="linkReturnOrder_Click" />
                                        </li>
                                    </ul>
                                </div>

                                <div class="btn-group" style="border-radius: 5px; float: right;">
                                    <button class="btn btn-info dropdown-toggle" type="button" runat="server" id="Button1" data-bs-toggle="dropdown" aria-expanded="false" style="border-radius: 5px;">
                                        <i class="ti ti-down fs-4 me-2"></i>Mode
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton" style="">
                                        <li>
                                            <asp:LinkButton runat="server" class="dropdown-item" ID="lbnEditDate" OnClick="lbnEditDate_Click" Text="Edit Date Mode"></asp:LinkButton></li>
                                        <li>
                                            <asp:LinkButton runat="server" class="dropdown-item" ID="lbnEditRouting" OnClick="lbnEditRouting_Click" Text="Edit Routing Mode"></asp:LinkButton>
                                        </li>

                                    </ul>
                                </div>
                                <!-- ▸ Hidden fields to shuttle SweetAlert2 data back to server on postback -->
                                <asp:HiddenField runat="server" ID="hfReturnComment" />
                                <asp:HiddenField runat="server" ID="hfReturnConfirmed" />

                                <button type="button" runat="server" id="btnExportToExel" class="btn btn-dark" onclick="grid.ExportTo(ASPxClientGridViewExportFormat.Xlsx);" style="border-radius: 5px; float: right;">
                                    <i class="ti ti-cloud-download fs-4 me-2"></i>Export to Excel
                                </button>

                                <!--------- APPROVAL CUSTOM CONTROL --------------------------->
                                <uc:ApprovalFlow ID="ApprovalFlow1" runat="server" OnStatusChanged="ApprovalFlow1_StatusChanged" />
                            </div>

                            <dx:ASPxGridView ID="gridFactoryOrderDetail" ClientInstanceName="grid" KeyFieldName="LineNo" runat="server" Width="100%" AutoGenerateColumns="False"
                                OnCustomColumnDisplayText="gridFactoryOrderDetai_CustomColumnDisplayText"
                                OnHtmlRowPrepared="gridFactoryOrderDetail_HtmlRowPrepared" OnCustomCellMerge="gridFactoryOrderDetail_CustomCellMerge"
                                OnBeforeGetCallbackResult="gridFactoryOrderDetail_BeforeGetCallbackResult"
                                OnRowDeleting="gridFactoryOrderDetail_RowDeleting" OnCustomButtonInitialize="gridFactoryOrderDetail_CustomButtonInitialize"
                                OnBatchUpdate="gridFactoryOrderDetail_BatchUpdate"
                                OnCellEditorInitialize="gridFactoryOrderDetail_CellEditorInitialize" OnCustomCallback="gridFactoryOrderDetail_CustomCallback">

                                <Columns>
                                    <dx:GridViewCommandColumn ShowEditButton="true" ButtonRenderMode="Image" Caption=" " VisibleIndex="0">

                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnCustomDelete" Text="Delete">
                                                <Image ToolTip="Delete Row" Url="../images/delete_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnCustomUploadDrawingByItem" Text="Upload Drawing">
                                                <Image ToolTip="Upload Drawing" Url="../images/upload_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnCustomViewDrawingByItem" Text="View Drawing">
                                                <Image ToolTip="View Drawing" Url="../images/view_24.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataTextColumn FieldName="ParentNo" ReadOnly="True" Name="ParentNo" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Group" ReadOnly="True" Name="Group" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ParentDescription" ReadOnly="True" Name="ParentDescription" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="No_" ReadOnly="True" Name="No_" VisibleIndex="3">
                                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="SubGroup" ReadOnly="True" Name="SubGroup" VisibleIndex="4">
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" Name="Description" VisibleIndex="5"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="UOM" ReadOnly="True" Name="UOM" VisibleIndex="6">
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Quantity" Name="Quantity" VisibleIndex="7">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="Routing" Name="Routing" VisibleIndex="8">
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataDateColumn FieldName="RequestedDate" Name="RequestedDate" VisibleIndex="9">
                                        <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataDateColumn>

                                    <dx:GridViewDataDateColumn FieldName="PromisedDate" Name="PromisedDate" VisibleIndex="10">
                                        <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="Unit Price" Name="Unit Price" VisibleIndex="11">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Amount" Name="Amount" VisibleIndex="12">
                                        <PropertiesTextEdit DisplayFormatString="#,##0"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="BOQPrice" Name="BOQPrice" VisibleIndex="13">
                                        <PropertiesTextEdit DisplayFormatString="#,##0.####"></PropertiesTextEdit>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn FieldName="DocumentType" ReadOnly="True" Name="DocumentType" VisibleIndex="15"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="DocumentNo" ReadOnly="True" Name="DocumentNo" VisibleIndex="16"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="LineNo" ReadOnly="True" Name="LineNo" VisibleIndex="17"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataMemoColumn FieldName="ParentRemark" Name="ParentRemark" VisibleIndex="18">
                                        <PropertiesMemoEdit EncodeHtml="False" Height="100"></PropertiesMemoEdit>
                                    </dx:GridViewDataMemoColumn>
                                    <dx:GridViewDataTextColumn FieldName="DrawingCode" ReadOnly="True" Name="DrawingCode" VisibleIndex="19"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="DrawingVersionCode" ReadOnly="True" Name="DrawingVersionCode" Caption="Version" VisibleIndex="20"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataMemoColumn FieldName="DrawingNote" Name="DrawingNote" VisibleIndex="21">
                                        <PropertiesMemoEdit EncodeHtml="False" Height="100"></PropertiesMemoEdit>
                                    </dx:GridViewDataMemoColumn>
                                    <dx:GridViewDataMemoColumn FieldName="SiteOrderDescription" Name="SiteOrderDescription" VisibleIndex="22">
                                        <PropertiesMemoEdit EncodeHtml="False" Height="100"></PropertiesMemoEdit>
                                    </dx:GridViewDataMemoColumn>

                                    <dx:GridViewDataTextColumn FieldName="SDFilePath" ReadOnly="True" Name="SDFilePath" VisibleIndex="-1" Visible="false"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Actions" VisibleIndex="99" Visible="true" CellStyle-CssClass="text-center" HeaderStyle-CssClass="text-center">
                                        <DataItemTemplate>
                                            <div class="btn-group">
                                                <button type="button" class="btn btn-sm btn-d1anger dropdown-toggle text-info" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                    <img title="View Drawing" class="dx-vam" src="../images/menu1_24.png" alt="View Drawing">
                                                </button>
                                                <div class="dropdown-menu animated flipInX">
                                                    <h6 class="dropdown-header">Routing</h6>
                                                    <a class="dropdown-item" href="javascript:void(0)" onclick="UpdateRoutingForItemAndProdOrder('<%# Eval("No_") %>', '<%# Eval("DocumentNo") %>', '<%# Eval("LineNo") %>', 'IN-HOUSE')">IN-HOUSE</a>
                                                    <a class="dropdown-item" href="javascript:void(0)" onclick="UpdateRoutingForItemAndProdOrder('<%# Eval("No_") %>', '<%# Eval("DocumentNo") %>', '<%# Eval("LineNo") %>', 'OUTSOURCING')">OUTSOURCING</a>
                                                    <hr class="dropdown-divider">
                                                    <a class="dropdown-item text-primary" href="javascript:void(0)"
                                                        onclick="ShowSplitLinePopup('<%# Eval("DocumentNo") %>', '<%# Eval("LineNo") %>', '<%# Eval("Quantity", "{0:0.####}") %>')">Split Line
                                                    </a>
                                                </div>
                                            </div>
                                        </DataItemTemplate>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>

                                    <dx:GridViewDataTextColumn Caption="Detail" VisibleIndex="100">
                                        <DataItemTemplate>
                                            <%--<a href="javascript:void(0);" class="btn btn-sm btn-primary"
                                               onclick="showDetailPopup(this, '<%# Eval("LineNo") %>')">Detail</a>--%>
                                            <a href="javascript:void(0);"
                                                class="btn btn-sm btn-primary"
                                                data-key='<%# Container.KeyValue %>'
                                                onclick="return onDetailButtonClick(this);">Detail</a>
                                        </DataItemTemplate>
                                        <Settings AllowCellMerge="False"></Settings>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsCommandButton>
                                    <DeleteButton>
                                        <Image ToolTip="Delete" Url="../images/delete_24.png" />
                                    </DeleteButton>
                                </SettingsCommandButton>

                                <%-- <SettingsEditing Mode="Batch"></SettingsEditing>--%>

                                <SettingsSearchPanel Visible="True"></SettingsSearchPanel>
                                <SettingsExport EnableClientSideExportAPI="true" />
                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                <SettingsBehavior AllowGroup="false" AllowSort="True" AllowFocusedRow="true"></SettingsBehavior>
                                <SettingsDataSecurity AllowDelete="true" AllowInsert="False" AllowEdit="true"></SettingsDataSecurity>
                                <Settings ShowFooter="true" ShowHeaderFilterButton="true" />
                                <Settings ShowFilterBar="Visible" />
                                <SettingsFilterControl ViewMode="VisualAndText" AllowHierarchicalColumns="true" ShowAllDataSourceColumns="true" MaxHierarchyDepth="1" />
                                <SettingsPopup>
                                    <EditForm Modal="True" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter"
                                        Width="520px" />
                                    <HeaderFilter Height="200">
                                        <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                                    </HeaderFilter>
                                    <FilterControl>
                                        <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="768" />
                                    </FilterControl>
                                </SettingsPopup>

                                <Styles Table-CssClass="dxgvTableOverflow" Header-CssClass="bg-1dark text-w1hite" Row-CssClass="gridViewRow" FocusedRow-CssClass="gridViewRowFocused"
                                    RowHotTrack-CssClass="gridViewRow" FilterRow-CssClass="gridViewFilterRow">
                                    <AlternatingRow Enabled="true" />
                                </Styles>

                                <TotalSummary>
                                    <dx:ASPxSummaryItem FieldName="No_" SummaryType="Count" />
                                    <dx:ASPxSummaryItem FieldName="Quantity" SummaryType="Sum" />
                                    <dx:ASPxSummaryItem FieldName="Amount" SummaryType="Sum" />
                                </TotalSummary>

                                <ClientSideEvents EndCallback="OnEndCallback" />
                                <ClientSideEvents CustomButtonClick="onCustomButtonClick" />

                            </dx:ASPxGridView>




                        </div>
                    </div>
                    <%--split line quantity--%>
                    <asp:HiddenField ID="hdnSplitDocumentNo" runat="server" />
                    <asp:HiddenField ID="hdnSplitLineNo" runat="server" />
                    <asp:HiddenField ID="hdnSplitOriginalQty" runat="server" />

                    <div class="modal fade" id="divModalSplitLine" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-sm modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header rounded-top bg-primary ">
                                    <h5 class="modal-title text-white">Split Sale Line</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <div class="modal-body">
                                    <div class="mb-2">
                                        <div class="small text-muted">Original Qty</div>
                                        <div class="fw-semibold" id="lblSplitOriginalQty">0</div>
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label">New Split Qty</label>
                                        <input type="number" step="0.0001" min="0" class="form-control" id="txtSplitQty" />
                                        <div class="form-text">This qty will be moved to a NEW line.</div>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-primary" onclick="ConfirmSplitLine()">Split</button>
                                </div>
                            </div>
                        </div>
                    </div>
                   
                    <uc:Comment runat="server" ID="commentSection" DocumentID="" />

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

<%@ Page Title="" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="TenderImageUpload.aspx.cs" Inherits="WebApp.tools.TenderImageUpload" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.111.min.js"></script>
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

        function Alert2(title, type)
        {
            Swal.fire({
                position: "top-end",
                type: type,
                title: title,
                showConfirmButton: false,
                timer: 2000
            });
        }
    </script>
    <script type="text/javascript">
        function onFilesUploadComplete(s, e) {
            debugger;
            
            if (e.callbackData) {
                var callbackdata = e.callbackData.split('|');                    
                var type = callbackdata[0],
                    message = callbackdata[1],
                    title = "Upload " + callbackdata[0];
                Swal.fire({
                    title: title,
                    text: message,
                    type: type
                });    

                if (type = "success") {
                    __doPostBack('ctl00$MainContent$ddlTenderOrder', '');
                    gridUploadedFile.DataBind();
                }

            }
        }
    </script>
    <script>
        function onFilesUploadStart(s, e) {
            // Get Tender Order No from dropdown
            var tenderOrderNo = document.getElementById('<%= ddlTenderOrder.ClientID %>').value;
            // Pass it to the server as a custom parameter
            s.UploadControl.SetUploadCustomData({ TenderOrderNo: tenderOrderNo });
        }
    </script>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>

        
    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
        <div class="container-fluid">
            <div class="container mt-5">
                <asp:HiddenField ID="hfTenderOrderNo" runat="server" />
                <h3 class="mb-4">Tender Image Upload</h3>
                <label for="ddlTenderOrder" class="form-label">Tender Order No</label>
                <div class="mb-3">                    
                    <asp:DropDownList ID="ddlTenderOrder" runat="server" CssClass="form-select select2" AutoPostBack="true" OnSelectedIndexChanged="ddlTenderOrder_SelectedIndexChanged"></asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label">Select Images</label>
                    <dx:ASPxUploadControl ID="uploadControl" runat="server" Width="50%"
                        ShowUploadButton="True"
                        ShowProgressPanel="True"
                        ClientInstanceName="uploadControl"
                        AllowedFileExtensions=".jpg,.jpeg,.png,.gif"
                        MaxFileSize="5242880"
                        NullText="Drop files here or click to select"
                        OnFilesUploadComplete="uploadControl_FilesUploadComplete"                   
                        UploadMode="Advanced">
                        <AdvancedModeSettings EnableMultiSelect="True" EnableFileList="True" EnableDragAndDrop="True"></AdvancedModeSettings>
                        <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg,.gif,.png"></ValidationSettings>
                        <ClientSideEvents FilesUploadComplete ="onFilesUploadComplete" />
                        

                    </dx:ASPxUploadControl>
                    
                    <br />
                    <p class="note">
                        <dx:ASPxLabel ID="AllowedFileExtensionsLabel" runat="server" Text="Allowed file extensions: .jpg, .jpeg, .gif, .png." Font-Size="8pt">
                        </dx:ASPxLabel>
                        <br />
                        <dx:ASPxLabel ID="MaxFileSizeLabel" runat="server" Text="Maximum file size: 4 MB." Font-Size="8pt">
                        </dx:ASPxLabel>
                    </p>
                    <dx:ASPxGridView runat="server" CssClass="fs-2" Visible="false" ID="gridUploadedFile" ClientInstanceName="gridUploadedFile" Caption="Uploaded File" AutoGenerateColumns="false">
                        <Columns>
                            <dx:GridViewDataColumn FieldName="DocumentNo" ></dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="FileName"></dx:GridViewDataColumn>
                        </Columns>
                    </dx:ASPxGridView>
                </div>
    
                </div>

                
            </div>
        </div>
        </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

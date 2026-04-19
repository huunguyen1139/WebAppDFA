<%@ Page Title="Defect Register Application" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="defect.aspx.cs" Inherits="WebApplication2.defect" %>
<%--<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>--%>


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
         document.getElementById("ModalHeader").className = "modal-header modal-colored-header text-white " + class_style;
     }
 </script>
    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
     
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h2 class="title1">Biên bản chất lượng</h2>
                    <div class="card shadow-sm">
                        
                        <div class="grids widget-shadow" style="padding: 10px; font-size: 16px">

                            <div runat="server" id="divMessage" class="alert alert-danger" role="alert" visible="false">
                                <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                            </div>

                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Thông tin chung</b>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Ngày phát sinh lỗi <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtRegisterDate" TextMode="Date" CssClass="form-control" ReadOnly="false"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <label>Đơn hàng <em class="text-danger">(*)</em></label>
                                    <div class="form-group">                                        
                                        <asp:DropDownList runat="server" ID="slPI" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="slPI_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label>Tên sản phẩm <em class="text-danger">(*)</em></label>
                                    <div class="form-group">
                                        <asp:DropDownList runat="server" ID="ddProductName" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddProductName_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Tổng số lượng <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtTotalQuantity" TextMode="Number" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Số lượng bị lỗi <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtDefectQuantity" TextMode="Number" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Diễn giải lỗi <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtDefectDescription" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Nguyên nhân <em class="text-danger">(*)</em></label>
                                        <asp:TextBox ID="txtDefectReason" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Cách khắc phục <em class="text-danger">(*)</em></label>
                                        <asp:TextBox ID="txtDefectAction" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-2 grid_box1">
                                    <div class="form-group">
                                        <label>Lỗi xảy ra ở BP <em class="text-danger">(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddDefectAtDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDefectAtDepartment_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>

                                        </asp:DropDownList>

                                    </div>
                                </div>
                                <div class="col-md-2 grid_box1">
                                    <div class="form-group">
                                        <label>Ngày cần <em class="text-danger">(*)</em></label>
                                        <asp:TextBox ID="txtRequiredDate" TextMode="Date" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-2 grid_box1">
                                    <div class="form-group">
                                        <label>Độ ưu tiên <em class="text-danger">(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddPriority" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="Normal"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="High Priority"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Urgent"></asp:ListItem>

                                        </asp:DropDownList>

                                    </div>
                                </div>

                                <div class="clearfix"></div>
                            </div>
                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Thông tin người, bộ phận gây ra lỗi</b>
                            </div>

                            <asp:Table runat="server" ID="tbDefectOfEmployee" CssClass=" table table-condensed"></asp:Table>
                            <div class="row">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Bộ phận gây lỗi<em class="text-danger">(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddDefectOfDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Team gây lỗi</label>
                                        <asp:DropDownList runat="server" ID="ddDefectOfTeam" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Người gây lỗi </label>
                                        <asp:DropDownList runat="server" ID="ddDefectOfEmployee" CssClass="form-control">
                                            <asp:ListItem Value="0" Text=" - Chọn - "></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <div class="form-group">
                                        <asp:Button runat="server" ID="btnAddEmployeeIncharge" CssClass="btn btn-info" Text="Add" Style="margin-top: 22px;" OnClick="btnAddEmployeeIncharge_Click" />

                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <hr />
                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Thông tin bộ phận sửa hàng lỗi</b>
                            </div>
                            <div class="row">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbWO" value="" class="form-check-input"> WO</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbRM" value="" class="form-check-input"> RM</label>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbFM" value="" class="form-check-input" > FM</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">

                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbAS" value="" class="form-check-input"> AS</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbSA" value="" class="form-check-input"> SA</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbFIN" value="" class="form-check-input"> FIN</label>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">

                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbIRON" value="" class="form-check-input"> IRON</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">

                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbUPH" value="" class="form-check-input"> UPH</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbFIT" value="" class="form-check-input"> FIT</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" runat="server" id="cbPAC" value="" class="form-check-input"> PAC</label>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">

                                        <div class="checkbox">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-group">

                                        <div class="checkbox">
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <hr />
                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Hình ảnh</b>
                            </div>
                            <div class="row">
                                <div class="col-md-6 grid_box1" runat="server" id="divFileupload">
                                    <asp:FileUpload ID="FileUpload1" runat="server" accept=".jpg, .png, .jpge, .gif" />
                                </div>

                                <div class="clearfix"></div>
                            </div>

                            <hr />
                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Thông tin duyệt BBCL</b>
                            </div>
                            <table class="table table-condensed" runat="server" id="tbApproverList">
                                <thead>
                                    <tr>
                                        <th>Tên</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày giờ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>20241 - Đặng Văn Tiến</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>20287 - Phạm Hoàng Thế Nguyên</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                            <hr />
                            <div style="text-align: center">
                                <asp:Button runat="server" ID="btnSubmit" Text="SUBMIT" Style="border-radius: 20px; padding: 10px 68px; font-size: 16px; margin-bottom: 10px;" CssClass="btn btn-warning" OnClick="btnSubmit_Click"></asp:Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="btnSubmit" />
        </Triggers>
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

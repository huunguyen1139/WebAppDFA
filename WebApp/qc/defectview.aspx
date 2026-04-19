<%@ Page Title="Defect Register Application" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="defectview.aspx.cs" Inherits="WebApplication2.defectview" %>



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
 <!-- Modal Popup -->
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h2 class="title1"><a href="../ReportViewer.aspx?type=bbcl&id=<%: Request["id"].ToString() %>" target="_blank">Biên bản chất lượng</a></h2>

                    <div class="card shadow-sm">
                        <div class="grids widget-shadow" style="padding: 10px; font-size: 16px">
                        <div runat="server" id="divMessage" class="alert alert-danger" role="alert" visible="false">
                            <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                        </div>

                        <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                            <b>Thông tin chung:
                                <asp:Label runat="server" ID="lbStatus"></asp:Label></b>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <label>Ngày phát sinh lỗi </label>
                                    <asp:TextBox runat="server" ID="txtRegisterDate" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <label>Đơn hàng </label>
                                    <asp:TextBox runat="server" ID="txtPI" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    <%--<asp:DropDownList runat="server" id="slPI" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="slPI_SelectedIndexChanged"></asp:DropDownList>--%>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Tên sản phẩm </label>
                                    <asp:TextBox runat="server" ID="txtProductName" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    <%--<asp:DropDownList runat="server" ID="ddProductName" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddProductName_SelectedIndexChanged"></asp:DropDownList>--%>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <label>Tổng số lượng </label>
                                    <asp:TextBox runat="server" ID="txtTotalQuantity" TextMode="Number" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Số lượng bị lỗi </label>
                                    <asp:TextBox runat="server" ID="txtDefectQuantity" TextMode="Number" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Diễn giải lỗi </label>
                                    <asp:TextBox runat="server" ID="txtDefectDescription" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4 grid_box1">
                                <div class="form-group">
                                    <label>Nguyên nhân </label>
                                    <asp:TextBox ID="txtDefectReason" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 grid_box1">
                                <div class="form-group">
                                    <label>Cách khắc phục </label>
                                    <asp:TextBox ID="txtDefectAction" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-2 grid_box1">
                                <div class="form-group">
                                    <label>Lỗi xảy ra ở BP </label>
                                    <asp:TextBox runat="server" ID="txtDefectAtDepartment" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    <%--<asp:DropDownList runat="server" ID="ddDefectAtDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDefectAtDepartment_SelectedIndexChanged">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                
                            </asp:DropDownList>--%>
                                </div>
                            </div>
                            <div class="col-md-2 grid_box1">
                                <div class="form-group">
                                    <label>Ngày cần </label>
                                    <asp:TextBox ID="txtRequiredDate" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                            <b>Thông tin người, bộ phận gây ra lỗi</b>
                        </div>

                        <asp:Table runat="server" ID="tbDefectOfEmployee" CssClass=" table table-condensed"></asp:Table>
                        <div class="row" runat="server" id="divAddResponsibleUser">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <label>Bộ phận gây lỗi </label>
                                    <asp:DropDownList runat="server" ID="ddDefectOfDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="true">
                                        <%----%>
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
                        <div class="row mb-3">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbWO" value="" class="form-check-input"  disabled1> WO</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbRM" value="" class="form-check-input"  disabled1> RM</label>
                                    </div>

                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbFM" value="" class="form-check-input"  disabled1> FM</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">

                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbAS" value="" class="form-check-input"  disabled1> AS</label>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbSA" value="" class="form-check-input"  disabled1> SA</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbFIN" value="" class="form-check-input"  disabled1> FIN</label>
                                    </div>

                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">

                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbIRON" value="" class="form-check-input"  disabled1> IRON</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">

                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbUPH" value="" class="form-check-input"  disabled1> UPH</label>
                                    </div>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbFIT" value="" class="form-check-input"  disabled1> FIT</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" runat="server" id="cbPAC" value="" class="form-check-input"  disabled1> PAC</label>
                                    </div>

                                </div>
                            </div>

                            <div class="clearfix"></div>
                        </div>
                            <div class="row mb-3">
                                <div class="col-md-3">
                                    <asp:Button ID="btnUpdateDepartment" runat="server" CssClass="btn btn-success" Text="Lưu BP sửa lỗi" OnClick="btnUpdateDepartment_Click" />
                                </div>
                            </div>
                        <div class="row" runat="server" id="divUpdateProgress">
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <label>Cập nhật kết quả sửa lỗi:</label>
                                </div>
                            </div>
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <asp:DropDownList runat="server" ID="ddDepartmentReponsive" CssClass="form-control"></asp:DropDownList>
                                </div>
                            </div>
                            <%--<div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <asp:TextBox runat="server" ID="txtCompletedDate" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>--%>
                            <div class="col-md-3 grid_box1">
                                <div class="form-group">
                                    <asp:Button runat="server" ID="btnUpdateProgress" CssClass="btn btn-success" Text="Update" OnClientClick="return confirm('Bạn có chắc chắn cập nhật trạng thái Đã hoàn thành cho BBCL này?');" OnClick="btnUpdateProgress_Click" />

                                </div>
                            </div>

                            <div class="clearfix"></div>
                            <div runat="server" id="divNotice" class="alert alert-danger" role="alert" visible="false">
                                <asp:Label runat="server" ID="lbNoticeUpdateStatus" Text="Error Text"></asp:Label>
                            </div>
                        </div>
                        <hr />
                        <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                            <b>Hình ảnh</b>
                        </div>
                        <div class="row">
                            <div class="col-md-6 grid_box1" runat="server" id="divFileupload">
                                <asp:FileUpload ID="FileUpload1" runat="server" accept=".jpg, .png, .jpge, .gif" />
                            </div>
                            <div class="col-md-6 grid_box1" runat="server" id="divbtnUpload">
                                <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="UploadFile" />
                            </div>
                            <hr runat="server" id="hrimage" />
                            <asp:Image ID="Image1" runat="server" Style="height: 300px; width: 450px; margin-left: 20px;" />
                            <div class="clearfix"></div>
                        </div>
                        <hr />
                        <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                            <b>Thông tin duyệt BBCL</b>
                        </div>
                        <asp:Table CssClass="table table-condensed" runat="server" ID="tbApproverList">
                        </asp:Table>
                        <hr />

                    </div>
                    </div>
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="btnUpload" />       
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

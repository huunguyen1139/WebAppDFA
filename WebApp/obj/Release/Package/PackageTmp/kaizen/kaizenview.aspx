<%@ Page Title="Kaizen View Application" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="kaizenview.aspx.cs" Inherits="WebApplication2.kaizenview" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   <style>
       .table-small>:not(caption)>*>* {
         padding: 3px 10px !important;
         font-size: 0.75rem !important;
        }
   </style>
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

<%--   <!-- Bootstrap tether Core JavaScript -->
   <script src="../masterskin/monster/src/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
   <!-- apps -->
   <script src="../masterskin/monster/dist/js/app.min.js"></script>
   <script src="../masterskin/monster/dist/js/app.init.horizontal.js"></script>
   <script src="../masterskin/monster/dist/js/app-style-switcher.horizontal.js"></script>
   <script src="../masterskin/monster/dist/js/sidebarmenu.js"></script>
   <!-- slimscrollbar scrollbar JavaScript -->
   <script src="../masterskin/monster/src/assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
   <script src="../masterskin/monster/src/assets/libs/jquery-sparkline/jquery.sparkline.min.js"></script>
   <!--Wave Effects -->
   <script src="../masterskin/monster/dist/js/waves.js"></script>
   <!--Menu sidebar -->
     <!-- Bootstra-->
 <link href="../masterskin/monster/dist/css/style.min.css" rel="stylesheet" />
 <script src="../masterskin/monster/src/assets/libs/jquery/dist/jquery.min.js"></script>

 <link href="Content/font-awesome.css" rel="stylesheet" />
   <!--Custom JavaScript -->
   <script src="../masterskin/monster/dist/js/feather.min.js"></script>
   <script src="../masterskin/monster/dist/js/custom.min.js"></script>--%>
   <%--<script src="../masterskin/monster/dist/js/pages/dashboards/dashboard1.js"></script>--%>

   <!-- Bootstrap -->
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
            <!-- /.modal-content -->
        </div>
    </div>
    <script type="text/javascript">
        function ShowPopup(title, body, class_style) {

            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").classList.remove("bg-success")
            document.getElementById("ModalHeader").classList.remove("bg-danger")
            document.getElementById("ModalHeader").classList.add(class_style);
        }
    </script>
    <!-- Modal Popup -->
   <script type="text/javascript">
       $(function () {
           CKEDITOR.replace('cke_MainContent_ckeditor1', {
               extraPlugins: 'imageuploader'
           });
       });
   </script>
    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

    </script>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
               

                <div class="container-fluid">
                    <div class="page-breadcrumb mb-3">
                        <div class="row">
                            <div class="col-md-5 align-self-center">
                                <h3 class="page-title">Kaizen System</h3>
                                <div class="d-flex align-items-center">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="../default.aspx">Home</a></li>
                                            <li class="breadcrumb-item"><a href="default.aspx">Kaizen System</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Register
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="col-md-7 justify-content-end align-self-center d-flex">
                                <div class="d-flex">
                                    <asp:Button runat="server" ID="btnEdit" Style="float: right; padding: 5px 12px; margin-right: 10px;" class="btn btn-success" Text="EDIT" OnClick="btnEdit_Click" OnClientClick="return confirm('Bạn có chắc chắn muốn sửa cải tiến này?');"></asp:Button>
                                    <asp:Button runat="server" ID="btnCancel" Style="float: right; padding: 5px 12px;" class="btn btn-danger" Text="Cancel" OnClick="btnCancel_Click" OnClientClick="return confirm('Bạn có chắc chắn muốn hủy cải tiến này?');"></asp:Button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Error message show -->
                    <div runat="server" id="divMessage" class="alert alert-danger alert-dismissible bg-danger text-white border-0 fade show" role="alert" visible="false">
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                        <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                    </div>

                    <!-- Thông tin chung -->
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">Thông tin chung </h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Ngày đăng ký: </label>
                                        <asp:Label runat="server" ID="txtRegisterDate" Text=""></asp:Label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Cải tiến tháng: </label>
                                        <asp:Label runat="server" ID="ddMonth" Text=""></asp:Label>

                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Năm: </label>
                                        <asp:Label runat="server" ID="ddYear">                                                              
                                        </asp:Label>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Bộ phận: </label>
                                        <asp:Label runat="server" ID="ddDepartment">                                                                                          
                                        </asp:Label>
                                    </div>
                                </div>

                                <div class="col-md-8">
                                    <div class="form-group">
                                        <label>Nhân viên: </label>
                                        <asp:Label runat="server" ID="ddEmployee">                                                                                        
                                        </asp:Label>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Tiêu đề ý tưởng: </label>
                                        <asp:Label ID="txtGenDescription" runat="server"></asp:Label>
                                    </div>
                                </div>

                                <div class="clearfix"></div>
                            </div>

                        </div>
                    </div>

                    <!-- Thông tin đánh giá -->
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">Thông tin đánh giá </h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Ngày áp dụng</label>
                                        <asp:TextBox runat="server" ID="txtAppliedDate" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtAppliedDate_TextChanged"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Xếp loại <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddLevel" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddLevel_SelectedIndexChanged" Enabled="false" disabled>
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Cấp 1: Thưởng ý tưởng : 19.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Cấp 2: Có hiệu quả nội bộ : 299.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Cấp 3: Có hiệu quả nhân rộng : 499.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Cấp 4: Tiết kiệm chi phí ≥ 20tr/năm : 1.000.000 VND"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Trạng thái </label>
                                        <asp:DropDownList runat="server" ID="ddStatus" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddStatus_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Mới tạo"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đã gửi"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đã duyệt"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chờ xác nhận"></asp:ListItem>
                                            <asp:ListItem Value="99" Text="Đã hủy"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3" runat="server" id="divConsent" visible="false">
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <label>Người duyệt sàng lọc</label>
                                        <asp:TextBox runat="server" ID="txtConsentUser" CssClass="form-control" disabled></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <asp:Button runat="server" ID="btnConsent" class="btn me-1 btn-rounded btn-outline-success" Text="Duyệt" OnClick="btnConsent_Click" Style="margin-top: 20px; width: 100px;" />
                                    <asp:Button runat="server" ID="btnReject" class="btn me-1 btn-rounded btn-outline-danger" Text="Từ chối" OnClick="btnReject_Click" Style="margin-top: 20px; width: 100px;" />
                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-8">
                                    <div class="form-group">
                                        <label>Note</label>
                                        <asp:TextBox runat="server" ID="txtNote" CssClass="form-control" placeholder="Nhập ghi chú và nhấn nút Save Note để lưu..."></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <asp:Button runat="server" ID="btnAddNote" class="btn btn-primary" Text="Save Note" OnClick="btnAddNote_Click" Style="margin-top: 20px; width: 100px" />

                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <div class="table-responsive">
                                <asp:GridView runat="server" ID="gvNoteList" Visible="True" Caption="" CssClass="table table-small table-stripe1d" EmptyDataText="No records found" Style="width: auto; border-width: 0px;">
                                    <HeaderStyle CssClass="bg-secondary text-white" />
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin chi tiết -->
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white" style="padding: 10px 20px;">
                            <h4 class="card-title mb-0 text-white">Nội dung chi tiết cải tiến</h4>
                        </div>

                        <div class="card-body">
                            <div class="row1" style="padding: 0px" runat="server" id="divDetailContent">
                            </div>
                        </div>

                    </div>


                    <!-- Tài liệu đính kèm -->
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white" style="padding: 10px 20px;">
                            <h4 class="card-title mb-0 text-white">Files đính kèm </h4>
                        </div>

                        <div class="card-body">
                            <div class="table-responsive">
                                <asp:GridView runat="server" ID="gvAttachment" Visible="True" Caption="" CssClass="table table-small table-stripe1d" EmptyDataText="No attached files found" Style="width: auto; border-width: 0px;">
                                    <HeaderStyle CssClass="bg-secondary text-white" />
                                </asp:GridView>
                            </div>


                        </div>

                    </div>
                </div>
            </div>
      
                
            
        </ContentTemplate>
        
    </asp:UpdatePanel>
       
</asp:Content>

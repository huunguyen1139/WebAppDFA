<%@ Page Title="Kaizen Register Application" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="kaizenlist.aspx.cs" Inherits="WebApplication2.kaizenlist" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


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

   <%-- <!-- Bootstrap tether Core JavaScript -->
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
        <link href="../masterskin/monster/dist/css/style.min.css" rel="stylesheet" />
 <script src="../masterskin/monster/src/assets/libs/jquery/dist/jquery.min.js"></script>

    <!--Custom JavaScript -->
    <script src="../masterskin/monster/dist/js/feather.min.js"></script>
    <script src="../masterskin/monster/dist/js/custom.min.js"></script>--%>
    <%--<script src="../masterskin/monster/dist/js/pages/dashboards/dashboard1.js"></script>--%>

	<%--<link href="../Content/font-awesome.css" rel="stylesheet" />--%>
    
    
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
                                            <li class="breadcrumb-item"><a href="../kaizen/default.aspx">Idea Network</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Kaizen List
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <div class="col-md-7 justify-content-end align-self-center d-flex">
                                <div class="d-flex">
                                    <asp:Button runat="server" ID="Button1" Style="float: right; padding: 5px 12px; margin-right: 10px;" class="btn btn-warning" OnClientClick="window.open('../ReportViewer.aspx?type=kaizen', '_blank');" Text="Print List"></asp:Button>
                                    <asp:Button runat="server" ID="btnCancel" Style="float: right; padding: 5px 12px;" class="btn btn-info" OnClientClick="window.open('kaizencard.aspx', '_blank');" Text="Đăng ký"></asp:Button>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">
                                <asp:LinkButton runat="server" CssClass="text-white" ID="lbCollapse" Text="Data Filter" OnClick="lbCollapse_Click"></asp:LinkButton></h4>
                            <asp:HiddenField runat="server" ID="hfShow" Value="true" />
                        </div>

                        <div runat="server" class="card-body" id="header">

                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Từ ngày</label>
                                        <asp:TextBox runat="server" ID="txtFromDate" AutoPostBack="true" OnTextChanged="txtFromDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Đến ngày</label>
                                        <asp:TextBox runat="server" ID="txtToDate" AutoPostBack="true" OnTextChanged="txtToDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Tháng - Năm</label>
                                        <asp:DropDownList runat="server" ID="ddMonthYear" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddMonthYear_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4 grid_box1">
                                    <div class="form-group">
                                        <label>Bộ phận</label>
                                        <asp:DropDownList runat="server" ID="ddDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="-Tất cả-"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Nhân viên</label>
                                        <asp:DropDownList runat="server" ID="ddEmployee" AutoPostBack="true" OnSelectedIndexChanged="ddEmployee_SelectedIndexChanged1" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="-Tất cả-"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Xếp loại</label>
                                        <asp:DropDownList runat="server" ID="ddLevel" CssClass="form-control" Enabled="true" AutoPostBack="true" OnSelectedIndexChanged="ddLevel_SelectedIndexChanged" disabled>
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Cấp 1: Thưởng ý tưởng : 19.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Cấp 2: Có hiệu quả nội bộ : 299.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Cấp 3: Có hiệu quả nhân rộng : 499.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Cấp 4: Tiết kiệm chi phí ≥ 20tr/năm : 1.000.000 NVD"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6 grid_box1">
                                    <div class="form-group">
                                        <label>Kaizen ID hoặc tiêu đề ý tưởng</label>
                                        <asp:TextBox runat="server" ID="txtDescription" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtAppliedDate_TextChanged"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-2 grid_box1">
                                    <div class="form-group">
                                        <label>Thanh toán</label>
                                        <asp:DropDownList runat="server" ID="ddPaid" CssClass="form-control" Enabled="true" AutoPostBack="true">
                                            <asp:ListItem Value="all" Text="-Tất cả-"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="Not yet"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Paid"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Trạng thái </label>
                                        <asp:DropDownList runat="server" ID="ddStatus" CssClass="form-control" Enabled="true" AutoPostBack="true">
                                            <asp:ListItem Value="0" Text="-Tất cả-"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đã gửi"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đã duyệt"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chờ xác nhận"></asp:ListItem>
                                            <asp:ListItem Value="99" Text="Đã hủy"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                        </div>

                    </div>


                    <div class="row">
                        <div class="col-lg-8 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body p-0">

                                    <div class="table-responsive mt-0">
                                        <asp:Table runat="server" ID="tbKaizenList" CssClass="table table-bordered-green">
                                        </asp:Table>
                                        <asp:Label runat="server" ID="lbNoRecordFound" Style="margin: 10px 10px;" Text="No records found"></asp:Label>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Leaderboard -->
                        <div class="col-lg-4 d-flex align-items-stretch">
                            <div class="card w-100">
                                <div class="card-body p-0">
                                    <div class="border-bottom title-part-padding bg-secondary text-white">
                                        <h4 class="card-title mb-0 text-white">
                                           Leaderboard (Personal)
                                        </h4>
                                    </div>
                                    <div class="message-box scrollable ps-container ps-theme-default ps-active-y" style="height: 476px" data-ps-id="c5b31455-a4ec-a064-fdac-6752ea18d71b">
                                        <div class="message-widget message-scroll">
                                            <!-- Gold medal -->
                                            <div class="d-flex align-items-center border-bottom p-3">
                                                <div class="user-img position-relative d-inline-block me-0 me-md-3">
                                                    <img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52727-1st-place-medal-icon.png" alt="">                                                   
                                                    <span class="profile-status rounded-circle online"></span>
                                                </div>
                                                <div class="w-85 d-md-flex align-items-center v-middle ps-3">
                                                    <div class="w-85">
                                                        <h5 class="mb-0 mt-1 font-weight-medium" id="per1" runat="server">Nguyễn Văn Hữu</h5>
                                                        <span id="dper1" runat="server" class="fs-3 text-nowrap d-block text-truncate mail-desc text-muted fw-normal">ERP </span>
                                                    </div>                                                   
                                                </div>
                                            </div>
                                            <!-- Silver medal -->
                                            <div class="d-flex align-items-center border-bottom p-3">
                                                <div class="user-img position-relative d-inline-block me-0 me-md-3">
                                                    <img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52728-2nd-place-medal-icon.png" alt="">
                                                    <span class="profile-status rounded-circle online"></span>
                                                </div>
                                                <div class="w-85 d-md-flex align-items-center v-middle ps-3">
                                                    <div class="w-85">
                                                        <h5 class="mb-0 mt-1 font-weight-medium" id="per2" runat="server">Nobody here</h5>
                                                        <span id="dper2" runat="server" class="fs-3 text-nowrap d-block text-truncate mail-desc text-muted fw-normal">Department </span>
                                                    </div>
                                                    <span class="fs-2 text-nowrap ms-auto time fw-normal"> </span>
                                                </div>
                                            </div>

                                            <!-- Bronze medal -->
                                            <div class="d-flex align-items-center border-bottom p-3">
                                                <div class="user-img position-relative d-inline-block me-0 me-md-3">
                                                    <img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52729-3rd-place-medal-icon.png" alt="">
                                                    <span class="profile-status rounded-circle online"></span>
                                                </div>
                                                <div class="w-85 d-md-flex align-items-center v-middle ps-3">
                                                    <div class="w-85">
                                                        <h5 class="mb-0 mt-1 font-weight-medium" id="per3" runat="server">Nobody here</h5>
                                                        <span id="dper3" runat="server" class="fs-3 text-nowrap d-block text-truncate mail-desc text-muted fw-normal">Department</span>
                                                    </div>
                                                    <span class="fs-2 text-nowrap ms-auto time fw-normal"> </span>
                                                </div>
                                            </div>
                                            <!-- Message -->
                                            <div class="d-flex align-items-center border-bottom p-3">
                                                <div class="user-img position-relative d-inline-block me-0 me-md-3">
                                                    <img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52729-3rd-place-medal-icon.png" alt="">
                                                    <span class="profile-status rounded-circle online"></span>
                                                </div>
                                                <div class="w-85 d-md-flex align-items-center v-middle ps-3">
                                                    <div class="w-85">
                                                        <h5 class="mb-0 mt-1 font-weight-medium" id="per4" runat="server">Nobody here</h5>
                                                        <span id="dper4" runat="server" class="fs-3 text-nowrap d-block text-truncate mail-desc text-muted fw-normal">Department</span>
                                                    </div>
                                                    <span class="fs-2 text-nowrap ms-auto time fw-normal"></span>
                                                </div>
                                            </div>


                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>


                </div>
            </div>


            
        </ContentTemplate>
        
    </asp:UpdatePanel>
       
</asp:Content>

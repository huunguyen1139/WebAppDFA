<%@ Page Title="Kaizen Home Page" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebApp.kaizen._default" %>
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

    <%--<link href="../masterskin/monster/dist/css/style.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/src/assets/libs/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap tether Core JavaScript -->
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

    <!--Custom JavaScript -->
    <script src="../masterskin/monster/dist/js/feather.min.js"></script>
    <script src="../masterskin/monster/dist/js/custom.min.js"></script>
    <script src="../masterskin/monster/dist/js/pages/dashboards/dashboard1.js"></script>

    <link href="../Content/font-awesome.css" rel="stylesheet" />--%>


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

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                  
                    <div class="card-group">
                        <!-- Column -->
                        <div class="card">
                            <div class="card-body text-center">
                                <h4 class="text-center">Total Ideas</h4>
                                <div class="d-flex justify-content-center">
                                    <div id="unique-visit" class="w-120"></div>                                    
                                </div>
                            </div>
                            <div class="p-2 rounded border-top text-center">
                                <h4 class=" mb-0" runat="server" id="txtTotalIdeas">
                                    <i class="ti-angle-up text-success"></i>12456
                </h4>
                            </div>
                        </div>
                        <!-- Column -->
                        <!-- Column -->
                        <div class="card">
                            <div class="card-body text-center">
                                <h4 class="text-center">Last Month Ideas</h4>
                                <div class="d-flex justify-content-center mt-3">
                                    <div id="total-visit" class="w-120"></div>
                                </div>
                            </div>
                            <div class="p-2 rounded border-top text-center">
                                <h4 class=" mb-0" runat="server" id="txtLastMonthIdeas">
                                    <i class="ti-angle-down text-danger"></i>456
                </h4>
                            </div>
                        </div>
                        <!-- Column -->
                        <!-- Column -->
                        <div class="card">
                            <div class="card-body text-center">
                                <h4 class="text-center">This Month Ideas</h4>
                                <div class="d-flex justify-content-center mt-3">
                                    <div id="bounce-rate" class="w-120"></div>
                                </div>
                            </div>
                            <div class="p-2 rounded border-top text-center">
                                <h4 class=" mb-0" runat="server" id="txtThisMonthIdeas">
                                    <i class="ti-angle-up text-success"></i>12456
                </h4>
                            </div>
                        </div>
                        <!-- Column -->
                        <!-- Column -->
                        <div class="card">
                            <div class="card-body text-center">
                                <h4 class="text-center">Total Successed Ideas</h4>
                                <div class="d-flex justify-content-center mt-3">
                                    <div id="page-views" class="w-120"></div>
                                </div>
                            </div>
                            <div class="p-2 rounded border-top text-center">
                                <h4 class=" mb-0" runat="server" id="txtTotalSuccessIdeas">
                                    <i class="ti-angle-down text-danger"></i>456
                </h4>
                            </div>
                        </div>
                        <!-- Column -->
                    </div>

                    <div class="row">
                        <!-- Column -->
                        <div class="col-lg-4">
                            <div class="card align-items-center" style="border-radius: 35px;">

                                <img class="card-img-top img-responsive px-0" src="images/welcome<%: DateTime.Now.Day.ToString() %>.png" style="width: 100%; border-radius: 35px;" alt="Card">
                            </div>
                        </div>
                        <!-- Column -->
                        <div class="col-lg-4">
                            <div class="card w-100 overflow-hidden">
                                <div class="card-body bg-purple">
                                    <div class="hstack gap-6 mb-7">
                                        <div class="bg-black bg-opacity-10 round-48 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:server-square-linear" class="fs-7 icon-center text-white"></iconify-icon>
                                        </div>
                                        <div>
                                            <h4 class="card-title text-white">Contribute your idea</h4>
                                            <p class="card-subtitle text-white opacity-70">Do the best you can!</p>
                                        </div>
                                    </div>
                                    <div class="row align-items-center">
                                        <div class="col-12">
                                            <h2 class="mb-0 text-white text-nowrap"><a href="kaizencard.aspx" class="text-white">ĐÓNG GÓP Ý TƯỞNG</a></h2>
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <div class="card  w-100 overflow-hidden">
                                <div class="card-body bg-info">
                                    <div class="hstack gap-6 mb-7">
                                        <div class="bg-white bg-opacity-20 round-48 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:chart-2-linear" class="fs-7 icon-center text-white"></iconify-icon>
                                        </div>
                                        <div>
                                            <h3 class="card-title text-white">All your ideas and status</h3>
                                            <h6 class="card-subtitle text-white opacity-70">Click to view detail all your ideas</h6>
                                        </div>
                                    </div>
                                    <div class="row align-items-center">
                                        <div class="col-12">
                                            <h2 class="mb-0 text-white text-nowrap p-2"><a href="mykaizen.aspx" class="text-white">Ý TƯỞNG CỦA TÔI</a></h2>
                                        </div>
                                    
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Column -->
                        <div class="col-lg-4">
                            <div class="card w-100 overflow-hidden">
                                <div class="card-body bg-primary ">
                                    <div class="hstack gap-6 mb-7">
                                        <div class="bg-black bg-opacity-10 round-48 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:server-square-linear" class="fs-7 icon-center text-white"></iconify-icon>
                                        </div>
                                        <div>
                                            <h4 class="card-title text-white">Ideas of all your employees</h4>
                                            <p class="card-subtitle text-white opacity-70">Click to review, approve or reject</p>
                                        </div>
                                    </div>
                                    <div class="row align-items-center">
                                        <div class="col-6">
                                            <h2 class="mb-0 text-white text-nowrap"><a href="consent.aspx" class="text-white">SÀNG LỌC CẤP 1</a></h2>
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <div class="card  w-100 overflow-hidden">
                                <div class="card-body bg-warning">
                                    <div class="hstack gap-6 mb-7">
                                        <div class="bg-white bg-opacity-20 round-48 rounded-circle d-flex align-items-center justify-content-center">
                                            <iconify-icon icon="solar:chart-2-linear" class="fs-7 icon-center text-white"></iconify-icon>
                                        </div>
                                        <div>
                                            <h3 class="card-title text-white">Ideas waiting final review</h3>
                                            <h6 class="card-subtitle text-white opacity-70">Approve or Reject ideas </h6>
                                        </div>
                                    </div>
                                    <div class="row align-items-center">
                                        <div class="col-12">
                                            <h2 class="mb-0 text-white text-nowrap p-2"><a href="kaizenlist.aspx" class="text-white">SÀNG LỌC CẤP 2</a></h2>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>
                        </div>

<%--                        <div class="col-lg-4">
                            <div class="row">
                                <div class="col-12">
                                    <div class="card" style="background-color: transparent!important;">
                                        <a href="kaizencard.aspx" class="btn btn-light-primary rounded-pill text-primary d-block fw-bold p-3" style="font-size: 2.5rem;">Đóng góp ý tưởng</a>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="card" style="background-color: transparent!important;">

                                        <a href="mykaizen.aspx" class="btn btn-light-info rounded-pill text-info d-block fw-bold p-3" style="font-size: 2.5rem;">Ý tưởng của tôi</a>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="card" style="background-color: transparent!important;">

                                        <a href="consent.aspx" class="btn btn-light-success rounded-pill text-success d-block fw-bold p-3" style="font-size: 2.5rem;">Sàng lọc cấp 1</a>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="card" style="background-color: transparent!important;">

                                        <a href="kaizenlist.aspx" class="btn btn-light-danger rounded-pill text-danger d-block fw-bold p-3" style="font-size: 2.5rem;">Sàng lọc cấp 2</a>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                        <!-- Column -->
                        <%--<div class="col-lg-3">
                            <div class="row">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="box p-2 rounded bg-info text-center">
                                            <h1 runat="server" id="txtTotalIdeas" class="fw-light text-white">2,064</h1>
                                            <h6 class="text-white">Total ideas</h6>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="card">
                                        <div class="box p-2 rounded bg-primary text-center">
                                            <h1 runat="server" id="txtLastMonthIdeas" class="fw-light text-white">2,064</h1>
                                            <h6 class="text-white">Ideas last month</h6>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="card">
                                        <div class="box p-2 rounded bg-warning text-center">
                                            <h1 runat="server" id="txtThisMonthIdeas" class="fw-light text-white">2,064</h1>
                                            <h6 class="text-white">Ideas this month</h6>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="card">
                                        <div class="box p-2 rounded bg-success text-center">
                                            <h1 runat="server" id="txtTotalSuccessIdeas" class="fw-light text-white">2,064</h1>
                                            <h6 class="text-white">Total success ideas</h6>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                </div>


                            </div>
                        </div>--%>

                        <!-- Column -->
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

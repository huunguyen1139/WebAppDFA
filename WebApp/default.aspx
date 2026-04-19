<%@ Page Title="Home" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebApp.default_mpro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
    <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
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
        
    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px)">
        <div class="container-fluid"> 
            <div class="row mt-3">
                <div class="col-lg-6 d-flex align-items-center" style="">
                    <div class="co11l">
                        <div class="heading-text">
                            <h1 class="heading-type heading-color font-size-0 text-primary">Welcome to ALLIANCE application
                            </h1>
                        </div>

                        <div class="mb-40 text-primary">
                            <p data-w-id="625f7db1-5f8f-0dc1-ec74-e70632a80e52">This web application is used for internal operations of ALLIANCE construction & fine furniture. To continue, scroll down and click an icon to enter the sub application.</p>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <img src="hs/images/path-6567149_1280.jpg" alt="path-6567149_1280" loading="lazy" width="1461" height="1920" style="max-width: 100%; height: auto; float: right; border-radius: 30px;">
                </div>


            </div>
            <div class="row mt-5">
                <!-- Kaizen app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="/production/MasterPlan">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/kaizen.png" data-src="../hs/images/appicon/kaizen.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0">Master Plan</h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
                
                 <!-- 2 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/sale.png" data-src="../hs/images/appicon/sale.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>

                        </div>
                    </div>
                </div>

                 <!-- 3 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/purchase.png" data-src="../hs/images/appicon/purchase.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                                

                        </div>
                    </div>
                </div>

                 <!-- 4 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/warehouse.png" data-src="../hs/images/appicon/warehouse.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
                    
            <div class="row mt-1">
                <!-- 5 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/production.png" data-src="../hs/images/appicon/production.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
                
                 <!-- 6 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/quality.png" data-src="../hs/images/appicon/quality.png" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>

                        </div>
                    </div>
                </div>

                 <!-- 3 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/finance.png" data-src="../hs/images/appicon/finance.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                                

                        </div>
                    </div>
                </div>

                 <!-- 4 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/hr.png" data-src="../hs/images/appicon/hr.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        
        </div>
    </div>



</asp:Content>

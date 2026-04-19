<%@ Page Title="" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="WebApp.AccessDenied" %>
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
    <div class="position-relative overflow-hidden min-v1h-100 w-100 d-flex align-items-center justify-content-center" bis_skin_checked="1" style="display: block; min-height: calc(100vh - 53px)">
        <div class="d-flex align-items-center justify-content-center w-100" bis_skin_checked="1">
            <div class="row justify-content-center w-100" bis_skin_checked="1">
                <div class="col-lg-4" bis_skin_checked="1">
                    <div class="text-center" bis_skin_checked="1">
                        <img src="/images/access_denied.png" alt="" class="img-fluid" width="500">
                        <h1 class="fw-semibold my-7 fs-9 text-danger">Access Denied</h1>
                        <h4 class="fw-semibold mb-7 text-primary">You don't have permission to view this page</h4>
                        <h4 class="fw-semibold mb-7">🚫🚫🚫🚫</h4><a class="btn btn-primary" href="/default" role="button">Go Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

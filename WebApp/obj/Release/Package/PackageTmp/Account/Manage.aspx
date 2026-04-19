<%@ Page Title="Manage Account" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="WebApplication2.Account.Manage" %>



<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
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

   <%-- <!-- Bootstrap tether Core JavaScript -->
    <link href="../masterskin/monster/dist/css/style.min_2021.css" rel="stylesheet" />
    <script src="../masterskin/monster/src/assets/libs/jquery/dist/jquery.min.js"></script>
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
    <script src="../masterskin/monster/dist/js/pages/dashboards/dashboard1.js"></script>--%>

    <link href="../Content/font-awesome.css" rel="stylesheet" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">Change password
                            </h4>
                        </div>
                        <div class="card-body">
                            <div class="mb-3 row" style="overflow: auto">
                                <label class="col-md-3 control-label">Old Password</label>
                                <div class="col-md-9">
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </span>
                                        <asp:TextBox runat="server" TextMode="Password" CssClass="form-control" ID="txtOldPassword" placeholder="Old Password"></asp:TextBox>
                                        <%--<input runat="server" type="password" class="form-control1" id="txtOldPassword" placeholder="Old Password">--%>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3 row" style="overflow: auto">
                                <label class="col-md-3 control-label">New Password</label>
                                <div class="col-md-9">
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </span>
                                        <input runat="server" type="password" class="form-control" id="txtNewPassword" placeholder="New Password">
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3 row" style="overflow: auto">
                                <label class="col-md-3 control-label">Confirm Password</label>
                                <div class="col-md-9">
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa fa-key"></i>
                                        </span>
                                        <input runat="server" type="password" class="form-control" id="txtConfirmPassword" placeholder="Confirm Password">
                                    </div>
                                </div>
                            </div>


                            <asp:Label runat="server" Style="margin-left: 17.85%" ID="lbPasswordValidation" Text="lbPasswordValidation lbPasswordValidation" Visible="false" ForeColor="#00cc00" />

                            <hr class="widget-separator" runat="server" id="separator10" visible="true" />
                            <div class="form-group" style="overflow: auto">
                                <label class="col-md-2 control-label"></label>
                                <div class="col-md-8">
                                    <asp:Button runat="server" ID="btnChangePassword" Style="float: left" CssClass="btn btn-warning" Text="Change" OnClick="btnChangePassword_Click" />

                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

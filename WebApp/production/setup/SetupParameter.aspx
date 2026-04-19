<%@ Page Title="Parameters Setup" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="SetupParameter.aspx.cs" Inherits="WebApp.production.SetupParameter" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.111.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
    <script src="/masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/dashboards/dashboard4.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

    <!-- Skin Material P -->


    <!-- select 2 -->
    <link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="/masterskin/monster/dist/select2/select2.min.js"></script>

    <!-- Export to Excel -->
    <script type="text/javascript" src="/masterskin/monster/dist/export2excel/jszip.min.js"></script>
    <script type="text/javascript" src="/masterskin/monster/dist/export2excel/FileSaver.min.js"></script>
    <script type="text/javascript" src="/masterskin/monster/dist/export2excel/excel-gen.js"></script>

    <!-- load sweet alert -->
    <script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />


    <div id="divModal" class="modal fade">
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

    <script type="text/javascript">
        function ShowPopup(title, body, class_style) {

            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").className = "modal-header rounded-top modal-colored-header text-white " + class_style;
        }
    </script>
    <!-- Modal Popup -->
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body rounded-top">
                            <h4 id="txtDesciptionHeader" runat="server" class="card-title mb-0 text-dark">Monthly Target Setup</h4>
                        </div>
                        <div class="card-body">                           
                            <div class="mb-3 row align-items-center">
                                <label for="ddYear" class="form-label col-sm-2 col-form-label text-end">Year</label>
                                <div class="col-sm-8">
                                    <div class="input-group border rounded-1">
                                        <span class="input-group-text bg-transparent px-6 border-0">
                                            <i class="ti ti-key fs-6"></i>
                                        </span>
                                        <asp:DropDownList runat="server" ID="ddYear" CssClass="form-control border-0 ps-2" AutoPostBack="true" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
                                            <asp:ListItem>2020</asp:ListItem>
                                            <asp:ListItem>2021</asp:ListItem>
                                            <asp:ListItem>2022</asp:ListItem>
                                            <asp:ListItem>2023</asp:ListItem>
                                        </asp:DropDownList>                                        
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="ddMonth" class="form-label col-sm-2 col-form-label text-end">Month</label>
                                <div class="col-sm-8">
                                    <div class="input-group border rounded-1">
                                        <span class="input-group-text bg-transparent px-6 border-0">
                                            <i class="ti ti-key fs-6"></i>
                                        </span>
                                        <asp:DropDownList runat="server" ID="ddMonth" CssClass="form-control border-0 ps-2" AutoPostBack="true" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
                                            <asp:ListItem>1</asp:ListItem>
                                            <asp:ListItem>2</asp:ListItem>
                                            <asp:ListItem>3</asp:ListItem>
                                            <asp:ListItem>4</asp:ListItem>
                                            <asp:ListItem>5</asp:ListItem>
                                            <asp:ListItem>6</asp:ListItem>
                                            <asp:ListItem>7</asp:ListItem>
                                            <asp:ListItem>8</asp:ListItem>
                                            <asp:ListItem>9</asp:ListItem>
                                            <asp:ListItem>10</asp:ListItem>
                                            <asp:ListItem>11</asp:ListItem>
                                            <asp:ListItem>12</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>                                                     

                            <div class="mb-3 row align-items-center">
                                <label for="txtTarget" class="form-label col-sm-2 col-form-label text-end">Target</label>
                                <div class="col-sm-8">
                                    <div class="input-group border rounded-1">
                                        <span class="input-group-text bg-transparent px-6 border-0">
                                            <i class="ti ti-key fs-6"></i>
                                        </span>
                                        <asp:TextBox runat="server" TextMode="Number" ID="txtTarget" CssClass="form-control border-0 ps-2"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <asp:Label runat="server" Style="margin-left: 17.85%" ID="lbValidation" Text="" Visible="false" ForeColor="#00cc00" />
                            <div class="row">
                                <div class="col-sm-2"></div>
                                <div class="col-sm-8">                                   
                                    <asp:Button runat="server" ID="btnChange" CssClass="btn btn-warning" Text="Change" OnClick="btnChange_Click" />
                                </div>
                            </div> 

                            <div class="table-responsive">
                                <asp:Table runat="server" ID="tbMasterPlan" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body rounded-top">
                            <h4 class="card-title mb-0 text-dark">Setup Parameters:
                            <asp:Label runat="server" ID="permission" Text="" ForeColor="Red"></asp:Label></h4>
                        </div>
                        <div class="card-body">
                            <table class="tablerowsmall table-bordered table-hover-old table-striped-old"">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Department</th>
                                        <th>Daily Output Target</th>
                                        <th>MH Unit Cost</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th scope="row">1</th>
                                        <td>WO</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otWO" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhWO" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">2</th>
                                        <td>RM</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otRM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhRM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">3</th>
                                        <td>FM</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otFM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhFM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">4</th>
                                        <td>AS</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otAS" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhAS" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">5</th>
                                        <td>SA</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otSA" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhSA" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>

                                    <tr>
                                        <th scope="row">6</th>
                                        <td>SP</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otSP" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhSP" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">7</th>
                                        <td>FIN</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otFIN" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhFIN" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">8</th>
                                        <td>IRON</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otIRON" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhIRON" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">9</th>
                                        <td>UPH</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otUPH" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhUPH" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">10</th>
                                        <td>FIT</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otFIT" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhFIT" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">11</th>
                                        <td>TU</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otTU" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhTU" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">12</th>
                                        <td>PAC</td>
                                        <td>
                                            <asp:TextBox runat="server" ID="otPAC" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                        <td>
                                            <asp:TextBox runat="server" ID="mhPAC" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

<%@ Page Title="Quality Report" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="QRAnalysis.aspx.cs" Inherits="WebApplication2.qc.QRAnalysis" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<link rel="stylesheet" id="themify-icons-css" href="themify-icons.css" type="text/css" media="all">

<link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
<script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
<script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
  <!-- Import Js Files -->
  <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
<%--  <script src="../masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
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

<link rel="stylesheet" type="text/css" href="../chart-lib/c3.min.css">

    <!-- Bootstrap tether Core JavaScript -->

<link rel="stylesheet" href="por_wrapstyle.css">
    <!-- This Page Plugins -->
    <script src="../chart-lib/d3.min.js"></script>
    <script src="../chart-lib/c3.min1.js"></script>
    
	

    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
        <div class="container-fluid">
            <div class="rowpr">
                <div class="col-12">
                    <div class="cardpr">
                        <div class="border-bottom title-part-padding">
                            <h4 class="card-title mb-0">Số biên bản phát sinh và xử lý hàng ngày</h4>
                        </div>

                        <div class="card-body">
                            <div id="column-oriented"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="rowpr">

                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divWO">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">WO: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoWO" Text="WO"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneWO" Text="WO"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=WO" runat="server" target="_blank" id="linkWO" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-successpr" title="Defective Rate">85.34%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-successpr" role="progressbar" style="width: 85.34%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>


                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divRM">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">RM: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoRM" Text="RM"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneRM" Text="RM"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=RM" runat="server" target="_blank" id="linkRM" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-infopr">30%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-infopr" role="progressbar" style="width: 30%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divFM">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">FM: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoFM" Text="FM"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneFM" Text="FM"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=FM" runat="server" target="_blank" id="linkFM" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-purplepr">60%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-purplepr" role="progressbar" style="width: 60%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divAS">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">AS: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoAS" Text="AS"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneAS" Text="AS"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=AS" runat="server" target="_blank" id="linkAS" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-dangerpr">80%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-dangerpr" role="progressbar" style="width: 80%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->
            </div>

            <div class="rowpr">

                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divSA">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">SA: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoSA" Text="SA"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneSA" Text="SA"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=SA" runat="server" target="_blank" id="linkSA" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-successpr" title="Defective Rate">85.34%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-successpr" role="progressbar" style="width: 85.34%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>


                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divFIN">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">FIN: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoFIN" Text="FIN"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneFIN" Text="FIN"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=FIN" runat="server" target="_blank" id="linkFIN" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-infopr">30%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-infopr" role="progressbar" style="width: 30%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divIRON">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">IRON: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoIRON" Text="IRON"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneIRON" Text="IRON"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=IRON" runat="server" target="_blank" id="linkIRON" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-purplepr">60%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-purplepr" role="progressbar" style="width: 60%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divUPH">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">UPH: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoUPH" Text="UPH"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneUPH" Text="UPH"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=UPH" runat="server" target="_blank" id="linkUPH" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-dangerpr">80%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-dangerpr" role="progressbar" style="width: 80%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->
            </div>

            <div class="rowpr">

                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divFIT">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">FIT: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoFIT" Text="FIT"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbneFIT" Text="FIT"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=FIT" runat="server" target="_blank" id="linkFIT" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-successpr" title="Defective Rate">85.34%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-successpr" role="progressbar" style="width: 85.34%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>


                        </div>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr" runat="server" id="divPAC">
                        <div class="card-bodypr">
                            <h4 class="card-titlepr">PAC: This month</h4>
                            <div class="text-endpr">
                                <h2 class="fw-lightpr mb-0">
                                    <i class="ti ti-arrow-down text-successpr"></i>
                                    <asp:Label runat="server" title="Số BB bộ phận xử lý được" ID="lbsoPAC" Text="PAC"></asp:Label>
                                    -
                      <i class="ti ti-arrow-up text-dangerpr"></i>
                                    <asp:Label runat="server" title="Số BB phát sinh cần được xử lý tại BP" ID="lbnePAC" Text="PAC"></asp:Label>
                                </h2>
                                <span class="text-mutedpr"><a href="qrlist?type=pending&dept=PAC" runat="server" target="_blank" id="linkPAC" style="text-decoration: none">Pending at dept. 39</a></span>
                            </div>
                            <span class="text-infopr">30%</span>
                            <div class="progresspr">
                                <div class="progress-barpr bg-infopr" role="progressbar" style="width: 30%; height: 6px" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Column -->


                <!-- Column -->
            </div>

            <div class="rowpr">

                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr">
                        <asp:TextBox runat="server" ID="txtFromDate" TextMode="Date" CssClass="form-control" placeholder="Name"></asp:TextBox>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr">
                        <asp:TextBox runat="server" ID="txtToDate" TextMode="Date" CssClass="form-control" placeholder="Name"></asp:TextBox>
                    </div>
                </div>
                <!-- Column -->
                <!-- Column -->
                <div class="col-lg-3pr col-md-6pr">
                    <div class="cardpr">
                        <asp:Button runat="server" ID="btnLoad" Text="Load" CssClass="btn btn-success" OnClick="btnLoad_Click" /></div>
                </div>

                <div class="col-lg-3pr col-md-6pr">
                </div>
                <!-- Column -->
            </div>
        </div>
    </div>
</asp:Content>

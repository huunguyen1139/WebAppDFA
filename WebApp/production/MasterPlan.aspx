<%@ Page Title="Master Plan" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="MasterPlan.aspx.cs" Inherits="WebApp.production.MasterPlan" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        #txtPIName {
            background-image: url('/Content/searchicon.png'); /* Add a search icon to input */
            background-position: 10px 12px; /* Position the search icon */
            background-repeat: no-repeat; /* Do not repeat the icon image */
            width: 100%; /* Full-width */
            font-size: 16px; /* Increase font-size */
            padding: 12px 20px 12px 40px; /* Add some padding */
            border: 1px solid #ddd; /* Add a grey border */
            margin-bottom: 12px; /* Add some space below the input */
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

    <script>
        function searchPI() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("txtPIName");
            filter = input.value.toUpperCase();
            table = document.getElementById("MainContent_tbMasterPlan");
            tr = table.getElementsByTagName("tr");

            // Loop through all table rows, and hide those who don't match the search query
            for (i = 0; i < tr.length; i++) {
                tdl = tr[i].getElementsByTagName("td");
                for (j = 0; j < tdl.length; j++) {
                    td = tdl[j];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                        else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        }
    </script>
    <!-- Bootstrap -->
    <!-- Modal Popup -->
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
        document.getElementById("ModalHeader").className = "modal-header modal-colored-header text-white " + class_style;
    }
</script>
<!-- Modal Popup -->
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-2">
                            <div class="card mb-2">
                                <div class="card-body p-2">
                                    <div class="task-info">
                                        <span runat="server" id="txtRemainTotal01" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span>
                                        <asp:Label runat="server" ID="lbUnpackingPercen01" title="Total percent of unpacking amount" CssClass="percentage" Style="float: right;" Text="$"></asp:Label>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-cyan" runat="server" id="divBarPercent01" style="width: 60%;"></div>
                                    </div>

                                    <hr style="margin: 5px;">
                                    <span runat="server" id="spanShippedAmount01" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                                    <span runat="server" id="spanOutputAmount01" style="float: right" title="Total of production output amount" class="pull-left"></span>
                                    <div class="clearfix"></div>
                                    <div runat="server" id="divMonthPeriod01" class="bg-cyan pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2020</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="card mb-2">
                                <div class="card-body p-2">
                                    <div class="task-info">
                                        <span runat="server" id="txtRemainTotal02" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span>
                                        <asp:Label runat="server" ID="lbUnpackingPercen02" title="Total percent of unpacking amount" CssClass="percentage" Style="float: right;" Text="$"></asp:Label>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-danger" runat="server" id="divBarPercent02" style="width: 60%;"></div>
                                    </div>

                                    <hr style="margin: 5px;">
                                    <span runat="server" id="spanShippedAmount02" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                                    <span runat="server" id="spanOutputAmount02" style="float: right" title="Total of production output amount" class="pull-left"></span>
                                    <div class="clearfix"></div>
                                    <div runat="server" id="divMonthPeriod02" class="bg-danger pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2020</div>
                                </div>
                            </div>
                        </div>


                        <div class="col-md-2">
                            <div class="card mb-2">
                                <div class="card-body p-2">
                                    <div class="task-info">
                                        <span runat="server" id="txtRemainTotal03" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span>
                                        <asp:Label runat="server" ID="lbUnpackingPercen03" title="Total percent of unpacking amount" CssClass="percentage" Style="float: right;" Text="$"></asp:Label>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-primary" runat="server" id="divBarPercent03" style="width: 60%;"></div>
                                    </div>

                                    <hr style="margin: 5px;">
                                    <span runat="server" id="spanShippedAmount03" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                                    <span runat="server" id="spanOutputAmount03" style="float: right" title="Total of production output amount" class="pull-left"></span>
                                    <div class="clearfix"></div>
                                    <div runat="server" id="divMonthPeriod03" class="bg-primary pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2030</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card mb-2">
                                <div class="card-body p-2">
                                    <div class="task-info">
                                        <span runat="server" id="txtRemainTotal04" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span>
                                        <asp:Label runat="server" ID="lbUnpackingPercen04" title="Total percent of unpacking amount" CssClass="percentage" Style="float: right;" Text="$"></asp:Label>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-indigo" runat="server" id="divBarPercent04" style="width: 60%;"></div>
                                    </div>

                                    <hr style="margin: 5px;">
                                    <span runat="server" id="spanShippedAmount04" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                                    <span runat="server" id="spanOutputAmount04" style="float: right" title="Total of production output amount" class="pull-left"></span>
                                    <div class="clearfix"></div>
                                    <div runat="server" id="divMonthPeriod04" class="bg-indigo pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2030</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card mb-2">
                                <div class="card-body p-2">
                                    <div class="task-info">
                                        <span runat="server" id="txtRemainTotal05" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span>
                                        <asp:Label runat="server" ID="lbUnpackingPercen05" title="Total percent of unpacking amount" CssClass="percentage" Style="float: right;" Text="$"></asp:Label>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-info" runat="server" id="divBarPercent05" style="width: 60%;"></div>
                                    </div>

                                    <hr style="margin: 5px;">
                                    <span runat="server" id="spanShippedAmount05" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                                    <span runat="server" id="spanOutputAmount05" style="float: right" title="Total of production output amount" class="pull-left"></span>
                                    <div class="clearfix"></div>
                                    <div runat="server" id="divMonthPeriod05" class="bg-info pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2030</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="card mb-2">
                                <div class="card-body p-2">
                                    <div class="task-info">
                                        <span runat="server" id="txtRemainTotal06" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span>
                                        <asp:Label runat="server" ID="lbUnpackingPercen06" title="Total percent of unpacking amount" CssClass="percentage" Style="float: right;" Text="$"></asp:Label>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-warning" runat="server" id="divBarPercent06" style="width: 60%;"></div>
                                    </div>

                                    <hr style="margin: 5px;">
                                    <span runat="server" id="spanShippedAmount06" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                                    <span runat="server" id="spanOutputAmount06" style="float: right" title="Total of production output amount" class="pull-left"></span>
                                    <div class="clearfix"></div>
                                    <div runat="server" id="divMonthPeriod06" class="bg-warning pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2030</div>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                    <br />                 

                    <div class="">
                        <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75); background-color: white; padding: 10px;">
                            <header class="widget-header">
                                <h4 id="txtDesciptionHeader" style="padding-bottom: 12px; margin-bottom: 0px; margin-top: 0px; padding-top: 4px;" runat="server" class="widget-title"><a href="/ReportViewer.aspx?type=masterplan" target="_blank">Online Master Plan</a> <a href="MasterPlan?showPIpc=true">- Show PI Status </a>
                                    <img src="/images/live.gif" width="60" height="25">
                                    <button style="float: right; padding: 4px 12px;" class="btn btn-info" onclick="document.location = 'MasterPlan?showHistory=true'">Shipped PIs</button>
                                    <button style="float: right; padding: 4px 12px; margin-right: 4px" class="btn btn-danger" onclick="window.open('http://sqrsystem.com:8080/QueryTool/OrderBookSearch', '_blank')">Order Book</button>

                                </h4>
                            </header>

                            <input type="text" id="txtPIName" onkeyup="searchPI()" placeholder="Search for PI names..">
                            <div class="table-master">
                                <asp:Table runat="server" ID="tbMasterPlan" CssClass="tablerowsmall-noboder table-hover1 table-striped1" ></asp:Table>
                            </div>
                        </div>

                        <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                        <div class="table-responsive">
                            <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Production Output Detail" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                                <HeaderStyle BackColor="Aqua" BorderColor="#E3E6E3" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
       <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="images/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

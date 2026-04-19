<%@ Page Title="Production Live Target" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ProductionTarget.aspx.cs" Inherits="WebApplication2.ProductionTarget" %>

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

        <div runat="server" id="divModalForFullPostBack" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div runat="server" id="divModalHeader" class="modal-header modal-colored-header text-white">
                    <h4 class="modal-title">NHF System
                    </h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div runat="server" id="divModalMessage" class="modal-body">
                    <asp:Label runat="server" ID="lbModalMessage" Text="dđ">d</asp:Label>
                </div>
                <div class="modal-footer">
                    <button runat="server" id="btnCloseModal" onserverclick="btnCloseModal_ServerClick" type="button" class="btn btn-light" data-bs-dismiss="modal">
                        OK
                    </button>
                </div>
            </div>
        </div>
    </div>

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
            document.getElementById("ModalHeader").classList.add(class_style);
        }
    </script>
    <script type="text/javascript">
        function RemovePreviousChart() {
            location.reload();
       }
    </script>
        <script type="text/javascript">

            Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
            function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

        </script>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card" style="padding-top: 0px" visible="false">
                        <div class="card-body shadow-sm">
                            <h2>&nbsp;<span style="color: #FF0000">R</span><span style="color: #FFFF00">e</span><span style="color: #33CC33">a</span><span style="color: #0000FF">l</span><span style="color: #FF0066">t</span><span style="color: #0066FF">i</span><span style="color: #FF9900">m</span><span style="color: #339933">e</span> <span style="color: #6600FF;">TARGET</span></h2>
                            <div class="row">
                                <div style="width: 33%; float: left">
                                    <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="100%" CssClass="form-control" OnTextChanged="txtFromDate_TextChanged" AutoPostBack="True"></asp:TextBox>
                                </div>
                                <div style="width: 33%; float: left">
                                    <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtToDate" TextMode="Date" Width="100%" CssClass="form-control" OnTextChanged="txtToDate_TextChanged" AutoPostBack="True"></asp:TextBox>
                                </div>
                                <div style="width: 34%; float: right">
                                    <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text="Load" OnClick="btnLoad_Click" />
                                </div>
                            </div>                            
                            
                            <asp:CheckBox CssClass="form-check" runat="server" ID="cbAutoRefresh" Text="Auto refresh data every 10 seconds" OnCheckedChanged="cbAutoRefresh_CheckedChanged" AutoPostBack="true"/>
                        </div>                       
                       

                    </div>

                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body">
                            <h4 class="card-title mb-0 text-dark">Company Output Target</h4>
                        </div>
                        <div class="card-body shadow-sm" >
                            <div class="row">
                                <div class="col-md-3">
                                    <asp:DropDownList runat="server" ID="ddYear" CssClass="form-control" AutoPostBack="true" Width="100%" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
                                        <asp:ListItem>2020</asp:ListItem>
                                        <asp:ListItem>2021</asp:ListItem>
                                        <asp:ListItem>2022</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <asp:DropDownList runat="server" ID="ddMonth" CssClass="form-control" AutoPostBack="true" Width="100%" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
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
                                <div class="col-md-6">

                                    <div class="task-info">
                                        <span runat="server" id="txtTargetData" class="task-desc">Database update</span>
                                        <span runat="server" id="txtTargetPercent" class="percentage" style="float: right">40%</span>
                                        <div class="clearfix"></div>
                                    </div>
                                    <div class="progress" style="height: 15px">
                                        <div runat="server" id="divTargetBar" class="progress-bar progress-bar-striped progress-bar-animated text-bg-primary" style="width: 40%;" role="progressbar"></div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div></div>
                      
                    </div>

                    <div class="card">
                        <div class="border-bottom title-part-padding bg-body">
                            <h4 id="txtDesciptionHeader" runat="server" class="card-title mb-0 text-dark">Output target from</h4>
                        </div>
                        <div class="shadow-sm">
                            <div class="table-responsive" runat="server" id="divTable">
                                <asp:Table runat="server" ID="tbTarget" CssClass="table table-hover1 table-striped1"></asp:Table>
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
            </div>
        </ContentTemplate>
        
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

<%@ Page Title="Production Status" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ProductionStatus.aspx.cs" Inherits="WebApp.production.ProductionStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>

    <!-- auto complete PI -->
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.css" />

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
    <script type="text/javascript">
        function SearchPI() {

            $("#<%=txtPI.ClientID%>").autocomplete({
                 source: '/GetPIList.ashx',
                 select: function (event, ui) {
                     if (ui.item.label == '') {
                         return false;
                     }

                     $('#<%=ddPI.ClientID%>').val(ui.item.label);
                 __doPostBack("<%# ddPI.ClientID %>", "");
                 }
             });
        };

        $(document).ready(function () { SearchPI(); });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            SearchPI();
        });
    </script>

    <script>
        function searchPI() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("txtPIName");
            filter = input.value.toUpperCase();
            table = document.getElementById("MainContent_gvDetailOutput");
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
    <!-- Modal Popup -->

    <script type="text/javascript">        
        function showLightbox(src) {
            document.getElementById("lightboxImage").src = src;
            var modal = new bootstrap.Modal(document.getElementById('lightboxModal'));
            modal.show();
        }
    </script>
    <!-- Lightbox Modal using show full image -->
    <div class="modal fade" id="lightboxModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content bg-dark text-white text-center">
                <div class="modal-body p-0">
                    <img id="lightboxImage" src="" class="img-fluid" />
                </div>
            </div>
        </div>
    </div>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h2><a href="ReportViewer?type=prodorder&PI=<% if (ViewState["PI"] != null)
                                    { %> <%: ViewState["PI"].ToString() %> <%} %>"
                                target="_blank">Production Status</a> </h2>
                            <div class="row">
                                <div style="width: 30%; float: left">
                                    <asp:HiddenField ID="hfPI" runat="server" />
                                    <asp:TextBox runat="server" ID="txtPI" CssClass="form-control" Width="100%" Style="margin-bottom: 10px" Placeholder="Search PI"></asp:TextBox>
                                </div>
                                <div style="width: 40%; float: left">
                                    <asp:DropDownList ID="ddPI" runat="server" CssClass="form-control select2" Width="100%" Style="margin-bottom: 10px" AutoPostBack="True" OnSelectedIndexChanged="ddPI_SelectedIndexChanged">
                                        <asp:ListItem Value="0">- Select PI</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div style="width: 30%; float: right">
                                    <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text="Load" OnClick="btnLoad_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDrawing" Text="Drawing" OnCheckedChanged="cbDrawing_CheckedChanged" AutoPostBack="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbProductionBOM" Text="Production BOM" OnCheckedChanged="cbProductionBOM_CheckedChanged" AutoPostBack="True" />

                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbTimberFinish" Text="Timber Finish" OnCheckedChanged="cbTimberFinish_CheckedChanged" AutoPostBack="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbMetalFinish" Text="Metal Finish" OnCheckedChanged="cbMetalFinish_CheckedChanged" AutoPostBack="True" />

                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbProductInfo" Text="Product Info." OnCheckedChanged="cbProductInfo_CheckedChanged" AutoPostBack="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbChangeRequest" Text="Change History" OnCheckedChanged="cbDefectHistory_CheckedChanged" AutoPostBack="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDefectHistory" Text="Defect History" OnCheckedChanged="cbDefectHistory_CheckedChanged" AutoPostBack="True" />

                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbProgress" Text="Progress" OnCheckedChanged="cbProgress_CheckedChanged" AutoPostBack="True" Checked="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbImage" Text="Product Image" Checked="true" OnCheckedChanged="cbImage_CheckedChanged" AutoPostBack="True" />

                        </div>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-12">
                             <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbDimension" Text="Dimensiom" OnCheckedChanged="cbDrawing_CheckedChanged" AutoPostBack="True" />
                             <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbRemark" Checked="true" Text="Remark" OnCheckedChanged="cbProductionBOM_CheckedChanged" AutoPostBack="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbFullName" Text="Full Name" OnCheckedChanged="cbProductionBOM_CheckedChanged" AutoPostBack="True" />
                            <asp:CheckBox runat="server" CssClass="form-check form-check-inline" ID="cbParentCode" Text="Parent Code" OnCheckedChanged="cbProductionBOM_CheckedChanged" AutoPostBack="True" />
                           
                        </div>
                    </div>

                    <div runat="server" id="divMessage" class="alert alert-danger text-danger" role="alert" visible="false">                   
                        Production Order for SO-SMP25-0001 has not yet been created
                    </div>
                    <input type="text" id="txtPIName" onkeyup="searchPI()" placeholder="Search for all columns..">
                    <div class="card">

                        <hr class="widget-separator" runat="server" id="separator10" visible="false" />
                        
                        <div id="huudiv" runat="server" class="table-master table-responsive">
                            
                            <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" Visible="False" BorderColor="#E3E6E3" Font-Size="12px" Caption="Production Output Detail" CssClass="table table-bordered table-hover-old table-striped-old" EmptyDataText="No records found" OnDataBound="gvDetailOutput_DataBound">
                                <HeaderStyle BackColor="Aqua" BorderColor="#E3E6E3" />
                                <RowStyle VerticalAlign="Middle" />

                            </asp:GridView>
                        </div>
                        <hr class="widget-separator" runat="server" id="Hr1" visible="false" />

                    </div>
                    <div class="table">
                        <asp:GridView runat="server" ID="gvPINote" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="PI Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                            <HeaderStyle BackColor="#ff9900" BorderColor="#E3E6E3" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </ContentTemplate>

    </asp:UpdatePanel>

   
</asp:Content>

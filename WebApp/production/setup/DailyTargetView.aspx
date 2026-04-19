<%@ Page Title="Daily Target View" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="DailyTargetView.aspx.cs" Inherits="WebApp.production.DailyTargetView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
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
    <!-- Modal Popup -->
    <div id="MyPopup" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function ShowPopup(title, body) {
            $("#MyPopup .modal-title").html(title);
            $("#MyPopup .modal-body").html(body);
            $("#MyPopup").modal("show");
        }
    </script>
    <!-- Modal Popup -->
    <script type="text/javascript">
        function selectAndCopyElementContents(el) {
            var body = document.body,
                range, sel;
            if (document.createRange && window.getSelection) {
                range = document.createRange();
                sel = window.getSelection();
                sel.removeAllRanges();
                try {
                    range.selectNodeContents(el);
                    sel.addRange(range);
                } catch (e) {
                    range.selectNode(el);
                    sel.addRange(range);
                }
            } else if (body.createTextRange) {
                range = body.createTextRange();
                range.moveToElementText(el);
                range.select();
            }
            document.execCommand("Copy");
            ShowPopup('POR System', 'Copied to Clipboard');
        }
    </script>

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
             <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                 <div class="container-fluid">
                     <div class="card">
                         <div class="card-body">
                             
                                 <h2>Daily Target View</h2>

                                 <div style="width: 40%; float: left">
                                     <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control" PlaceHolder="From Date"></asp:TextBox>
                                 </div>
                                 <div style="width: 40%; float: left">
                                     <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtToDate" TextMode="Date" Width="95%" CssClass="form-control" PlaceHolder="To Date"></asp:TextBox>
                                 </div>

                                 <div style="width: 20%; float: right">
                                     <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text="View" OnClick="btnLoad_Click" />
                                 </div>
                             </div>
                                                    
                     </div>

                     <div class="">
                         <asp:Button CssClass="btn btn-warning" Style="margin-bottom: 10px" runat="server" ID="btnCopy" Text="Copy to Clipboard" OnClientClick="selectAndCopyElementContents(document.getElementById('MainContent_gvDailyTarget'));" />
                         <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                         <div class="table-responsive">
                             <asp:GridView runat="server" ID="gvDailyTarget" Width="100%" Visible="False" BorderColor="#333333" Caption="Daily Target Information" CssClass="tablerowsmall table-hover table-striped-old" EmptyDataText="No records found" AutoGenerateColumns="False" OnRowDataBound="gvDailyTarget_RowDataBound">
                                 <HeaderStyle BackColor="#cccccc" BorderColor="#333333" />
                             </asp:GridView>
                         </div>
                     </div>
                 </div>
            </div>
        </ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>

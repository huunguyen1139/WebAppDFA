<%@ Page Title="Defect Logs" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="defectlist.aspx.cs" Inherits="WebApplication2.defectlist" %>
<%--<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>--%>


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
         document.getElementById("ModalHeader").className = "modal-header modal-colored-header text-white " + class_style;
     }
 </script>
 <!-- Modal Popup -->
    <!-- Modal Popup -->

    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
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
                    <h2 class="title1">Defect Logs Summary
                        <asp:Button runat="server" ID="btnCancel" Style="float: right; padding: 5px 12px;" class="btn btn-success" OnClientClick="window.open('defect.aspx', '_blank');" Text="THÊM MỚI"></asp:Button></h2>



                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding rounded bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">
                                <asp:LinkButton runat="server" ID="lbCollapse" Text="Data Filter" OnClick="lbCollapse_Click"></asp:LinkButton></h4>
                            <asp:HiddenField runat="server" ID="hfShow" />
                        </div>
                        <div runat="server" class="card-body collapse" data-example-id="simple-form-inline" id="header">

                            <div class="row mb-2">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Từ ngày</label>
                                        <asp:TextBox runat="server" ID="txtFromDate" AutoPostBack="true" OnTextChanged="txtFromDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Đến ngày</label>
                                        <asp:TextBox runat="server" ID="txtToDate" AutoPostBack="true" OnTextChanged="txtToDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Lỗi xảy ra ở BP</label>
                                        <asp:DropDownList runat="server" ID="ddDefectAtDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDefectAtDepartment_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-4 grid_box1">
                                    <div class="form-group">
                                        <label>Bộ phận gây lỗi</label>
                                        <asp:DropDownList runat="server" ID="ddDefectOfDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4 grid_box1">
                                    <div class="form-group">
                                        <label>Team gây lỗi <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddDefectOfTeam" CssClass="form-control" OnSelectedIndexChanged="ddDefectOfTeam_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Người gây lỗi </label>
                                        <asp:DropDownList runat="server" ID="ddDefectOfEmployee" CssClass="form-control">
                                            <asp:ListItem Value="0" Text=" - Chọn - "></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                        </div>
                    </div>


                    <div class="card shadow-sm" style="margin: 20px 0px; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.5);">
                        <div class="card-body">
                            <div class="table-responsive">
                                <asp:GridView runat="server" ID="gvDetailDefect" Width="100%" Visible="true" BorderColor="#E3E6E3" Caption="Defect List" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False">
                                    <HeaderStyle BackColor="Orange" BorderColor="#E3E6E3" />
                                    <RowStyle Height="20px" />
                                </asp:GridView>
                            </div>
                        </div>
                        <asp:Label runat="server" ID="lbNoRecordFound" Style="margin: 10px 10px;" Text=""></asp:Label>
                    </div>

                    <asp:Button CssClass="btn btn-warning" Style="margin-bottom: 10px" runat="server" ID="btnCopy" Text="Copy to Clipboard" OnClientClick="selectAndCopyElementContents(document.getElementById('MainContent_gvDetailDefect'));" />



                    <div class="clearfix"></div>
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
       
</asp:Content>

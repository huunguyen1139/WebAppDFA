<%@ Page Title="Change Request" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="request.aspx.cs" Inherits="WebApp.production.request" %>

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
  <!-- solar icons -->
 <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
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
    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
     
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h2 class="title1">Production change request</h2>
                    <div class="card shadow-sm">                        
                        <div class="grids widget-shadow" style="padding: 10px; font-size: 16px">

                            <div runat="server" id="divMessage" class="alert alert-danger" role="alert" visible="false">
                                <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                            </div>

                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Thông tin chung</b>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Ngày phát sinh <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtRegisterDate" TextMode="Date" CssClass="form-control" ReadOnly="false"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <label>Đơn hàng <em class="text-danger">(*)</em></label>
                                    <div class="form-group">                                        
                                        <asp:DropDownList runat="server" ID="slPI" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="slPI_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label>Tên sản phẩm <em class="text-danger">(*)</em></label>
                                    <div class="form-group">
                                        <asp:DropDownList runat="server" ID="ddProductName" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddProductName_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Tổng số lượng <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtTotalQuantity" TextMode="Number" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                
                                <div class="col-md-9">
                                    <div class="form-group">
                                        <label>Diễn giải <em class="text-danger">(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtChangeDescription" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <div class="row mb-3">                                 
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Ngày cần <em class="text-danger">(*)</em></label>
                                        <asp:TextBox ID="txtRequiredDate" TextMode="Date" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Độ ưu tiên <em class="text-danger">(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddPriority" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="Normal"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="High Priority"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Urgent"></asp:ListItem>

                                        </asp:DropDownList>

                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Price (Doanh số) <em class="text-danger">(*)</em></label>
                                        <asp:TextBox ID="txtPrice" TextMode="Number" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                          
                            <hr />
                            <div style="text-align: center">
                                <asp:Button runat="server" ID="btnSubmit" Text="SUBMIT" Style="border-radius: 20px; padding: 10px 68px; font-size: 16px; margin-bottom: 10px;" CssClass="btn btn-warning" OnClick="btnSubmit_Click"></asp:Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="btnSubmit" />
        </Triggers>
    </asp:UpdatePanel>
       <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
           <ProgressTemplate>
               <div class="modal1">
                   <div class="center1">
                       <img alt="" src="/images/loader4.gif" />
                   </div>
               </div>
           </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

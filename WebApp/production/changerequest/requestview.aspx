<%@ Page Title="Production Change Request" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="requestview.aspx.cs" Inherits="WebApp.production.requestview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
          <!-- Skin Maretial P -->
  <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
  <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
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
 <!-- Modal Popup -->
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h2 class="title1"><a href="../ReportViewer.aspx?type=bbcl&id=<%: Request["id"].ToString() %>" target="_blank">Production Change Request</a></h2>

                    <div class="card shadow-sm">
                        <div class="grids widget-shadow" style="padding: 10px; font-size: 16px">
                            <div runat="server" id="divMessage" class="alert alert-danger" role="alert" visible="false">
                                <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                            </div>

                            <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                                <b>Thông tin chung:
                                <asp:Label runat="server" ID="lbStatus"></asp:Label></b>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Ngày phát sinh </label>
                                        <asp:TextBox runat="server" ID="txtRegisterDate" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Đơn hàng </label>
                                        <asp:TextBox runat="server" ID="txtPI" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                        <%--<asp:DropDownList runat="server" id="slPI" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="slPI_SelectedIndexChanged"></asp:DropDownList>--%>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Tên sản phẩm </label>
                                        <asp:TextBox runat="server" ID="txtProductName" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                        <%--<asp:DropDownList runat="server" ID="ddProductName" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddProductName_SelectedIndexChanged"></asp:DropDownList>--%>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Tổng số lượng </label>
                                        <asp:TextBox runat="server" ID="txtTotalQuantity" TextMode="Number" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-9">
                                    <div class="form-group">
                                        <label>Diễn giải lỗi </label>
                                        <asp:TextBox runat="server" ID="txtChangeDescription" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                            <div class="row mb-3">

                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Ngày cần </label>
                                        <asp:TextBox ID="txtRequiredDate" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Độ ưu tiên </label>
                                        <asp:TextBox ID="txtPriority" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-3 grid_box1">
                                    <div class="form-group">
                                        <label>Price </label>
                                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" Style="background-color: gainsboro; cursor: default;"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>

                        </div>
                    </div>

                    <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                        <b>Tiến độ hoàn thành theo bộ phận</b>
                    </div>
                    <asp:Repeater ID="rptDepartmentOutput" runat="server" Visible="true">
                        <HeaderTemplate>
                            <div class="row">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="col-lg-4 col-md-6">
                                <div class="card">
                                    <div class='<%# SQRFunctionLibrary.SQRLibrary.ConvertToInt(Eval("CompletedPercent")) >= 100 ? "card-header text-bg-success" : "card-header text-bg-warning" %>' bis_skin_checked="1">
                                        <h4 class="mb-0 text-white card-title">Summary</h4>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-2" bis_skin_checked="1">
                                            <a href="JavaScript: void(0);">
                                                <i class="ti ti-currency-ripple display-6 text-primary" title=""></i>
                                            </a>
                                            <div class="ms-3">
                                                <h1 class=" mb-0 fs-10 text-primary"><%# Eval("Department") %></h1>
                                            </div>
                                            <div class="ms-3">
                                                <h1 class=" mb-0 fs-10 text-primary"><%# Eval("FinishedQty") + "|" + Eval("TotalQuantity") %></h1>

                                            </div>
                                            <div class="ms-3">
                                                <h4 class="card-title mb-0 text-white"></h4>
                                                <p class="text-white fs-4 mb-0 opacity-75"></p>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="progress text-bg-light" style="height: 15px">
                                                <div class="progress-bar progress-bar-striped progress-bar-animated text-bg-success" role="progressbar"
                                                    style='<%# "width: " + Eval("CompletedPercent").ToString() + "%; height: 15px;" %>' aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate></div></FooterTemplate>
                    </asp:Repeater>


                    <div style="margin-bottom: 10px; margin-top: 10px; background-color: beige; padding: 10px 5px;">
                        <b>Lịch sử nhập</b>
                    </div>
                    <div class="table-responsive border rounded-1 mb-3 mt-3">
                        <asp:GridView runat="server" ID="gvOutputDetail" Width="100%" Visible="True" OnRowDataBound="gvOutputDetail_RowDataBound"
                            CssClass="table mb-0 fs-2 table-h1over table-striped text-nowrap" EmptyDataText="No records found">
                            <HeaderStyle CssClass="table-success" />
                        </asp:GridView>
                    </div>



                </div>
        </ContentTemplate>
        <Triggers>
          
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

<%@ Page Title="Kaizen Register Application" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="kaizencard.aspx.cs" Inherits="WebApplication2.kaizencard" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


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
    <!-- Modal Popup -->
    <script type="text/javascript">
        $(function () {
            CKEDITOR.replace('cke_MainContent_ckeditor1', {
                extraPlugins: 'imageuploader'
            });
        });
    </script>
    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

    </script>
 

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);"> 
                <div class="container-fluid">
                    <div class="page-breadcrumb mb-3">
                        <div class="row">
                            <div class="col-md-5 align-self-center">
                                <h3 class="page-title">Kaizen System</h3>
                                <div class="d-flex align-items-center">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="../default.aspx">Home</a></li>
                                            <li class="breadcrumb-item"><a href="../kaizen/default.aspx">Idea Network</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Register
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                            </div>
                            <%--<div class="col-md-7 justify-content-end align-self-center d-none d-md-flex">
            <div class="d-flex">
                <asp:Button runat="server" ID="Button1" Style="float: right; padding: 5px 12px; margin-right: 10px;" class="btn btn-warning" OnClientClick="window.open('../ReportViewer.aspx?type=kaizen', '_blank');" Text="Print List"></asp:Button>
                <asp:Button runat="server" ID="btnCancel" Style="float: right; padding: 5px 12px;" class="btn btn-info" OnClientClick="window.open('kaizencard.aspx', '_blank');" Text="Đăng ký"></asp:Button>

            </div>
        </div>--%>
                        </div>
                    </div>
                    <!-- Error message show -->
                    <div runat="server" id="divMessage" class="alert alert-danger alert-dismissible bg-danger text-white border-0 fade show" role="alert" visible="false">
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                        <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                    </div>

                    <!-- Thông tin chung -->
                    <div class="card shadow-sm">
                        <div class="border-bottom title-part-padding bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">Thông tin chung </h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Ngày đăng ký <em>(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtRegisterDate" TextMode="Date" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Cải tiến tháng <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddMonth" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Tháng 1"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Tháng 2"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Tháng 3"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Tháng 4"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Tháng 5"></asp:ListItem>
                                            <asp:ListItem Value="6" Text="Tháng 6"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Tháng 7"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="Tháng 8"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="Tháng 9"></asp:ListItem>
                                            <asp:ListItem Value="10" Text="Tháng 10"></asp:ListItem>
                                            <asp:ListItem Value="11" Text="Tháng 11"></asp:ListItem>
                                            <asp:ListItem Value="12" Text="Tháng 12"></asp:ListItem>
                                        </asp:DropDownList>

                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Năm <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddYear" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                            <asp:ListItem Value="2020" Text="2020"></asp:ListItem>
                                            <asp:ListItem Value="2021" Text="2021"></asp:ListItem>
                                            <asp:ListItem Value="2022" Text="2022"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Bộ phận <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Nhân viên <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddEmployee" CssClass="form-control">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Người duyệt sàng lọc <em>(*)</em></label>
                                        <asp:TextBox runat="server" ID="txtConsentUser" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label>Tiêu đề ý tưởng <em>(*)</em></label>
                                        <asp:TextBox ID="txtGenDescription" runat="server" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="clearfix"></div>
                            </div>

                        </div>
                    </div>

                    <!-- Thông tin đánh giá -->
                    <div class="card shadow-sm" runat="server" visible="false">
                        <div class="border-bottom title-part-padding bg-primary text-white">
                            <h4 class="card-title mb-0 text-white">Thông tin đánh giá </h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Ngày áp dụng</label>
                                        <asp:TextBox runat="server" ReadOnly="true" ID="txtAppliedDate" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Xếp loại <em>(*)</em></label>
                                        <asp:DropDownList runat="server" ID="ddLevel" CssClass="form-control" Enabled="false">
                                            <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Cấp 1: Thưởng ý tưởng : 19.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Cấp 2: Có hiệu quả nội bộ : 299.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Cấp 3: Có hiệu quả nhân rộng : 499.000 VND"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Cấp 4: Tiết kiệm chi phí ≥ 20tr/năm : 1.000.000 NVD"></asp:ListItem>

                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Trạng thái </label>
                                        <asp:DropDownList runat="server" ID="ddStatus" CssClass="form-control" Enabled="false">
                                            <asp:ListItem Value="0" Text="Mới tạo"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Đã gửi"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đã duyệt"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Chờ xác nhận"></asp:ListItem>
                                            <asp:ListItem Value="99" Text="Đã hủy"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </div>

                    </div>

                    <!-- Thông tin chi tiết -->
                    <div class="card shadow-sm">

                        <div class="border-bottom title-part-padding bg-primary text-white" style="padding: 10px 20px;">
                            <div class="row">
                                <div class="col-md-5 align-self-center">
                                    <h4 class="card-title mb-0 text-white">Nội dung chi tiết cải tiến </h4>
                                </div>
                                <%--<div class="col-md-7 justify-content-end align-self-center d-none d-md-flex">
                                    <div class="d-flex">
                                        <asp:Button runat="server" ID="btnGetDefaultTemplate" Style="float: right; padding: 2px 12px;" class="btn btn-info" Text="Lấy mẫu cải tiến" OnClick="btnGetDefaultTemplate_Click" />
                                    </div>
                                </div>--%>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="row1" style="padding: 0px">
                                <CKEditor:CKEditorControl runat="server" ID="ckeditor1" BasePath="~/ckeditor/"></CKEditor:CKEditorControl>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-2 align-self-center">
                                    Đính kèm file trước cải tiến:
                                </div>
                                <div class="col-md-10 align-self-center">
                                    <asp:FileUpload ID="fileUpload" AllowMultiple="true" runat="server" />
                                </div>
                            </div>

                            <div class="row mt-3">
                                <div class="col-md-2 align-self-center">
                                    Đính kèm file sau cải tiến:
                                </div>
                                <div class="col-md-10 align-self-center">
                                    <asp:FileUpload ID="fileUpload1" AllowMultiple="true" runat="server" />
                                </div>
                            </div>

                            <div class="row mt-3">
                                <asp:Label runat="server" ID="lbFileUploadDescription" Style="padding: 0px 20px;" CssClass="help-block" Text="(Accept file *.xls, *.xlsx, *.doc, *.docx, *.pdf, *.png, *.jpg. File size <= 6MB)"></asp:Label>
                            </div>
                            <hr />
                            <div style="text-align: center">
                                <asp:Button runat="server" ID="btnSubmit" Text="SUBMIT" Style="border-radius: 20px; padding: 10px 68px; font-size: 16px; margin-bottom: 10px;" CssClass="btn btn-success" OnClick="btnSubmit_Click"></asp:Button>
                            </div>
                        </div>


                    </div>

             
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <%--co post back de btnSubmit fileupload k bi reset--%>
            <asp:PostBackTrigger ControlID="btnSubmit"/>
            <asp:AsyncPostBackTrigger ControlID="ddDepartment" />
        </Triggers>
    </asp:UpdatePanel>
    <div class="page-wrapper" style="display: block">
        <div class="container-fluid" style="min-height:100px">
            
        </div>
    </div>
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

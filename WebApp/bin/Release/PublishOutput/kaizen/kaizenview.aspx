<%@ Page Title="Kaizen View Application" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="kaizenview.aspx.cs" Inherits="WebApplication2.kaizenview" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Bootstra-->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    
    <link href="Content/font-awesome.css" rel="stylesheet" />
    <!-- Bootstrap -->
    <!-- Modal Popup -->
    <div id="MyPopup" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">
                    </h4>
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

            <h2 class="title1">Kaizen Application Form <asp:Button runat="server" ID="btnCancel" style="float:right;padding: 5px 12px;" class="btn btn-danger" Text="Cancel" OnClick="btnCancel_Click" OnClientClick="return confirm('Bạn có chắc chắn muốn hủy cải tiến này?');"></asp:Button>
                <asp:Button runat="server" ID="btnEdit" style="float:right;padding: 5px 12px;margin-right: 10px;" class="btn btn-success" Text="EDIT" OnClick="btnEdit_Click" OnClientClick="return confirm('Bạn có chắc chắn muốn sửa cải tiến này?');"></asp:Button>
            </h2>
            <div class="grids widget-shadow" style="padding: 10px; font-size: 16px">
                
                <div runat="server" id="divMessage" class="alert alert-danger" role="alert" Visible="false">
                    <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                </div>
                
                <div style="margin-bottom: 10px; margin-top: 10px; background-color: cadetblue;padding: 10px 5px; color: white;">
                    <b>Thông tin chung</b>
                </div>
                <div class="row">
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Ngày đăng ký: </label>
                            <asp:Label runat="server" ID="txtRegisterDate" Text=""></asp:Label>                            
                        </div>
                    </div>
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Cải tiến tháng: </label>
                            <asp:Label runat="server" ID="ddMonth" Text=""></asp:Label>                           
                           
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Năm: </label>
                            <asp:Label runat="server" ID="ddYear">                                                              
                            </asp:Label>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                 <div class="row">
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Bộ phận: </label>
                            <asp:Label runat="server" ID="ddDepartment">                                                                                          
                            </asp:Label>
                        </div>
                    </div>
                    
                    <div class="col-md-8">
                        <div class="form-group">
                            <label>Nhân viên: </label>
                           <asp:Label runat="server" ID="ddEmployee">                                                                                        
                            </asp:Label>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>

                 <div class="row">
                    <div class="col-md-12 grid_box1">
                        <div class="form-group">
                            <label>Mô tả chung: </label>
                            <asp:Label ID ="txtGenDescription" runat="server"></asp:Label>                          
                        </div>
                    </div>
                    
                    <div class="clearfix"></div>
                </div>
                <hr />
                 <div style="margin-bottom: 10px; margin-top: 10px; background-color: cadetblue;padding: 10px 5px; color: white;">
                    <b>Thông tin đánh giá</b>
                </div>
                 <div class="row">
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Ngày áp dụng</label>
                             <asp:TextBox runat="server" ID="txtAppliedDate" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtAppliedDate_TextChanged"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Xếp loại <em>(*)</em></label>
                             <asp:DropDownList runat="server" ID="ddLevel" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddLevel_SelectedIndexChanged">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Cấp 1: Thưởng ý tưởng : 19.000 VND"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Cấp 2: Có hiệu quả nội bộ : 299.000 VND"></asp:ListItem>
                                <asp:ListItem Value="3" Text="Cấp 3: Có hiệu quả nhân rộng : 499.000 VND"></asp:ListItem>
                                <asp:ListItem Value="4" Text="Cấp 4: Tiết kiệm chi phí ≥ 20tr/năm : 1.000.000 VND"></asp:ListItem>
                                
                            </asp:DropDownList>     
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label>Trạng thái </label>
                            <asp:DropDownList runat="server" ID="ddStatus" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddStatus_SelectedIndexChanged">
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
                <div class="row">
                    <div class="col-md-12 grid_box1">
                        <div class="form-group">
                            <label>Note</label>
                             <asp:TextBox runat="server" ID="txtNote" CssClass="form-control" placeholder="Nhập ghi chú và nhấn Enter để lưu..." AutoPostBack="true" OnTextChanged="txtNote_TextChanged"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <hr />
                <div style="margin-top: 10px; background-color: cadetblue;padding: 10px 5px; color: white;">
                    <b>Thông tin chi tiết</b>
                    <%--<asp:Button runat="server" ID="btnGetDefaultTemplate" style="float: right;padding: 2px 12px;" class="btn btn-info" Text="Lấy mẫu cải tiến" OnClick="btnGetDefaultTemplate_Click"/>                    --%>
                </div>
                <div class="row" style="padding: 10px" runat="server" id="divDetailContent">                   
                </div>
                <div class="row">                    
                    <asp:Label runat="server" ID="lbFileUploadDescription" Style="padding: 0px 20px;" CssClass="help-block" Text=""></asp:Label>
                </div>
                                                
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
       
</asp:Content>

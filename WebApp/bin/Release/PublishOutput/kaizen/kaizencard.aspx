<%@ Page Title="Kaizen Register Application" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="kaizencard.aspx.cs" Inherits="WebApplication2.kaizencard" %>
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

            <h2 class="title1">Kaizen Application Form</h2>
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
                            <label>Ngày đăng ký <em>(*)</em></label>
                            <asp:TextBox runat="server" ID="txtRegisterDate" TextMode="Date" CssClass="form-control" ReadOnly="true"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="col-md-4 grid_box1">
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
                 <div class="row">
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Bộ phận <em>(*)</em></label>
                            <asp:DropDownList runat="server" ID="ddDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                                                
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                    <div class="col-md-8">
                        <div class="form-group">
                            <label>Nhân viên <em>(*)</em></label>
                           <asp:DropDownList runat="server" ID="ddEmployee" CssClass="form-control">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                                                
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>

                 <div class="row">
                    <div class="col-md-12 grid_box1">
                        <div class="form-group">
                            <label>Mô tả chung <em>(*)</em></label>
                            <asp:TextBox ID ="txtGenDescription" runat="server" CssClass="form-control"></asp:TextBox>                          
                        </div>
                    </div>
                    
                    <div class="clearfix"></div>
                </div>
                 <div style="margin-bottom: 10px; margin-top: 10px; background-color: cadetblue;padding: 10px 5px; color: white;">
                    <b>Thông tin đánh giá</b>
                </div>
                 <div class="row">
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Ngày áp dụng</label>
                             <asp:TextBox runat="server" ReadOnly="true" ID="txtAppliedDate" TextMode="Date" CssClass="form-control"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="col-md-4 grid_box1">
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
                <div style="margin-top: 10px;background-color: cadetblue;padding: 10px 5px; color: white;">
                    <b>Thông tin chi tiết</b>
                    <asp:Button runat="server" ID="btnGetDefaultTemplate" style="float: right;padding: 2px 12px;" class="btn btn-info" Text="Lấy mẫu cải tiến" OnClick="btnGetDefaultTemplate_Click"/>                    
                </div>
                <div class="row" style="padding: 10px">
                    <CKEditor:CKEditorControl runat="server" ID ="ckeditor1" BasePath="~/ckeditor/"></CKEditor:CKEditorControl>
                </div>
                <div class="row">
                    <%--<input type="file" id="fileUpload" runat="server" style="padding: 10px 20px;">--%>
                    <asp:FileUpload ID="fileUpload" runat="server" Style="padding: 10px 20px;" />
                    <asp:Label runat="server" ID="lbFileUploadDescription" Style="padding: 0px 20px;" CssClass="help-block" Text="(Accept file *.xls, *.xlsx, *.doc, *.docx, *.pdf, *.png, *.jpg. File size <= 4MB)"></asp:Label>
                </div>
                
                <hr />
                <div style="text-align: center">                    
                    <asp:Button runat="server" ID="btnSubmit" Text ="SUBMIT" style="border-radius:20px; padding:10px 68px; font-size:16px;margin-bottom: 10px;" CssClass="btn btn-success" OnClick="btnSubmit_Click">
                   
                    </asp:Button>
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
            <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

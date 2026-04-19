<%@ Page Title="Defect Register Application" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="defectview.aspx.cs" Inherits="WebApplication2.defectview" %>
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
    
    <%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <link href="../dist/css/select2.min.css" rel="stylesheet" />
    <script src="../dist/js/select2.min.js"></script>--%>
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            
            <h2 class="title1"><a href="../ReportViewer.aspx?type=bbcl&id=<%: Request["id"].ToString() %>" target="_blank"> Biên bản chất lượng</a></h2>
            <div class="grids widget-shadow" style="padding: 10px; font-size: 16px">
                
                <div runat="server" id="divMessage" class="alert alert-danger" role="alert" Visible="false">
                    <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                </div>
                
                <div style="margin-bottom: 10px;margin-top: 10px;background-color: beige;padding: 10px 5px;">
                    <b>Thông tin chung: <asp:Label runat="server" ID="lbStatus"></asp:Label></b>
                </div>
                <div class="row">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Ngày phát sinh lỗi </label>
                            <asp:TextBox runat="server" ID="txtRegisterDate" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Đơn hàng </label>
                            <asp:TextBox runat="server" ID="txtPI" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>                          
                            <%--<asp:DropDownList runat="server" id="slPI" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="slPI_SelectedIndexChanged"></asp:DropDownList>--%>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Tên sản phẩm </label>
                            <asp:TextBox runat="server" ID="txtProductName" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>
                            <%--<asp:DropDownList runat="server" ID="ddProductName" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddProductName_SelectedIndexChanged"></asp:DropDownList>--%>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                 <div class="row">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Tổng số lượng </label>
                            <asp:TextBox runat="server" ID="txtTotalQuantity" TextMode="Number" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Số lượng bị lỗi </label>
                           <asp:TextBox runat="server" ID="txtDefectQuantity" TextMode="Number" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>
                        </div>
                    </div>
                     <div class="col-md-6">
                        <div class="form-group">
                            <label>Diễn giải lỗi </label>
                           <asp:TextBox runat="server" ID="txtDefectDescription" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>

                 <div class="row">
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Nguyên nhân </label>
                            <asp:TextBox ID ="txtDefectReason" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>                          
                        </div>
                    </div>
                    <div class="col-md-4 grid_box1">
                        <div class="form-group">
                            <label>Cách khắc phục </label>
                            <asp:TextBox ID ="txtDefectAction" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>                          
                        </div>
                    </div>
                     <div class="col-md-2 grid_box1">
                        <div class="form-group">
                            <label>Lỗi xảy ra ở BP </label>
                            <asp:TextBox runat="server" ID="txtDefectAtDepartment" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>
                            <%--<asp:DropDownList runat="server" ID="ddDefectAtDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDefectAtDepartment_SelectedIndexChanged">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                
                            </asp:DropDownList>--%>
                                        
                        </div>
                    </div>
                      <div class="col-md-2 grid_box1">
                        <div class="form-group">
                            <label>Ngày cần </label>
                            <asp:TextBox ID ="txtRequiredDate" runat="server" CssClass="form-control" Enabled="False" ReadOnly="True" style="background-color: gainsboro;cursor: default;"></asp:TextBox>                                        
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                 <div style="margin-bottom: 10px;margin-top: 10px;background-color: beige;padding: 10px 5px;">
                    <b>Thông tin người, bộ phận gây ra lỗi</b>
                </div>
               
                <asp:Table runat="server" ID="tbDefectOfEmployee" CssClass=" table table-condensed"></asp:Table>
                <div class="row" runat="server" id="divAddResponsibleUser">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Bộ phận gây lỗi </label>
                             <asp:DropDownList runat="server" ID="ddDefectOfDepartment" CssClass="form-control" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="true"><%----%>
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                
                                
                            </asp:DropDownList> 
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Team gây lỗi</label>
                             <asp:DropDownList runat="server" ID="ddDefectOfTeam" CssClass="form-control">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                               
                                
                            </asp:DropDownList>     
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Người gây lỗi </label>
                            <asp:DropDownList runat="server" ID="ddDefectOfEmployee" CssClass="form-control">
                                <asp:ListItem Value="0" Text=" - Chọn - "></asp:ListItem>                                                                                            
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <asp:Button runat="server" ID="btnAddEmployeeIncharge" CssClass="btn btn-info" Text="Add" style="margin-top: 22px;" OnClick="btnAddEmployeeIncharge_Click"/>                      

                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
        
                <hr />
                <div style="margin-bottom: 10px;margin-top: 10px;background-color: beige;padding: 10px 5px;">
                    <b>Thông tin bộ phận sửa hàng lỗi</b>
                </div>
                <div class="row">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <div class="checkbox">
                                <label><input type="checkbox" runat="server" id="cbWO" value="" disabled>WO</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <div class="checkbox">
                                <label><input type="checkbox" runat="server" id="cbRM" value="" disabled>RM</label>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <div class="checkbox">                               
                                    <label><input type="checkbox" runat="server" id="cbFM" value="" disabled>FM</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">

                            <div class="checkbox">
                                <label><input type="checkbox" runat="server" id="cbAS" value="" disabled>AS</label>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="row">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <div class="checkbox">
                                 <label><input type="checkbox" runat="server" id="cbSA" value="" disabled>SA</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <div class="checkbox">
                                 <label><input type="checkbox" runat="server" id="cbFIN" value="" disabled>FIN</label>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">

                            <div class="checkbox">
                                 <label><input type="checkbox" runat="server" id="cbIRON" value="" disabled>IRON</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">

                            <div class="checkbox">
                                 <label><input type="checkbox" runat="server" id="cbUPH" value="" disabled>UPH</label>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="row">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <div class="checkbox">
                                <label><input type="checkbox" runat="server" id="cbFIT" value="" disabled>FIT</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <div class="checkbox">
                                 <label><input type="checkbox" runat="server" id="cbPAC" value="" disabled>PAC</label>
                            </div>

                        </div>
                    </div>
                    
                    <div class="clearfix"></div>
                </div>

                <div class="row" runat="server" id="divUpdateProgress">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Cập nhật kết quả sửa lỗi:</label>
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <asp:DropDownList runat="server" ID="ddDepartmentReponsive" CssClass="form-control"></asp:DropDownList>
                        </div>
                    </div>
                    <%--<div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <asp:TextBox runat="server" ID="txtCompletedDate" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>--%>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <asp:Button runat="server" ID="btnUpdateProgress" CssClass="btn btn-success" Text="Update" OnClientClick="return confirm('Bạn có chắc chắn cập nhật trạng thái Đã hoàn thành cho BBCL này?');" OnClick="btnUpdateProgress_Click" />

                        </div>
                    </div>
                    
                    <div class="clearfix"></div>
                    <div runat="server" id="divNotice" class="alert alert-danger" role="alert" Visible="false">
                    <asp:Label runat="server" ID="lbNoticeUpdateStatus" Text="Error Text"></asp:Label>
                </div>
                </div>
                <hr />
                <div style="margin-bottom: 10px;margin-top: 10px;background-color: beige;padding: 10px 5px;">
                    <b>Hình ảnh</b>
                </div>
                 <div class="row">
                    <div class="col-md-6 grid_box1" runat="server" id="divFileupload">
                        <asp:FileUpload ID="FileUpload1" runat="server" accept=".jpg, .png, .jpge, .gif"/>
                    </div>
                    <div class="col-md-6 grid_box1" runat="server" id="divbtnUpload">
                        <asp:Button ID="btnUpload" Text="Upload" runat="server" OnClick="UploadFile" />
                    </div>
                   <hr runat="server" id="hrimage"/>
                        <asp:Image ID="Image1" runat="server" style="height: 300px; width: 450px ;margin-left: 20px;"/>
                    <div class="clearfix"></div>
                </div>
                <hr />
                   <div style="margin-bottom: 10px;margin-top: 10px;background-color: beige;padding: 10px 5px;">
                    <b>Thông tin duyệt BBCL</b>
                </div>
                <asp:Table CssClass="table table-condensed" runat="server" id="tbApproverList">
                   
                </asp:Table>
                <hr />
                
            </div>
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="btnUpload" />       
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

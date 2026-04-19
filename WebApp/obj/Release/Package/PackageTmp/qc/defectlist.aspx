<%@ Page Title="Defect Logs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="defectlist.aspx.cs" Inherits="WebApplication2.defectlist" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Bootstra-->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    <link href="../Content/font-awesome.css" rel="stylesheet" />
    
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

            <div class="main-page">
				<h2 class="title1">Defect Logs Summary <asp:Button runat="server" ID="btnCancel" style="float:right;padding: 5px 12px;" class="btn btn-success" OnClientClick="window.open('defect.aspx', '_blank');" Text="THÊM MỚI"></asp:Button></h2>
			
				<div class="col-md-12" style="padding: 0px">
                    <div class="panel-default">
                        <div class="form-two widget-shadow" style="box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.5);">
                            <div class="form-title" style="background-color: orange;">
                                <h4 style="color:white"><asp:LinkButton runat="server" ID="lbCollapse" Text="Data Filter" OnClick="lbCollapse_Click"></asp:LinkButton></h4>
                                <asp:HiddenField runat="server" ID="hfShow" />
                                <%--<h4 style="color:white"><a href="#header" data-toggle="collapse" style="color: white;">Data Filter</a> </h4>--%>
                            </div>                            
                            <div runat="server" class="form-body collapse" data-example-id="simple-form-inline" id="header">

                                <div class="row">
                                    <div class="col-md-4 grid_box1">
                                        <div class="form-group">
                                            <label>Từ ngày</label>
                                            <asp:TextBox runat="server" ID="txtFromDate" AutoPostBack="true" OnTextChanged="txtFromDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4 grid_box1">
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
                                 <div class="row">
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
                            <asp:DropDownList runat="server" ID="ddDefectOfEmployee" CssClass="form-control" >
                                <asp:ListItem Value="0" Text=" - Chọn - "></asp:ListItem>                                                                                            
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                             


                            </div>
                        </div>
                        

                        <div class="widget-shadow" style="margin: 20px 0px;box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.5);">
                            <%--<asp:Table runat="server" ID ="tbKaizenList" CssClass="table table-bordered-green">
                            
                            </asp:Table>--%>
                           
                            <div class="table-responsive">
                                <asp:GridView runat="server" ID="gvDetailDefect" Width="100%" Visible="true" BorderColor="#E3E6E3" Caption="Defect List" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False">
                                    <HeaderStyle BackColor="Orange" BorderColor="#E3E6E3" />
                                    <RowStyle Height="20px" />
                                </asp:GridView>
                            </div>
                            <asp:Label runat="server" ID="lbNoRecordFound" style="margin: 10px 10px;" Text=""></asp:Label>
                       </div>
                        
                        <asp:Button CssClass="btn btn-warning" Style="margin-bottom: 10px" runat="server" ID="btnCopy" Text ="Copy to Clipboard" OnClientClick="selectAndCopyElementContents(document.getElementById('MainContent_gvDetailDefect'));"/>      
				</div>
                </div>
              
				<div class="clearfix"> </div>	
			</div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
       
</asp:Content>

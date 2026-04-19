<%@ Page Title="BOM & Drawing by Item" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BOM_Drawing.aspx.cs" Inherits="WebApplication2.BOM_Drawing" %>
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
                        
            <div class="grids widget-shadow" style="padding: 10px; font-size: 16px; margin-top: 20px;">
                
                <div runat="server" id="divMessage" class="alert alert-danger" role="alert" Visible="false">
                    <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                </div>
                
                               

                
                 <div style="margin-bottom: 10px;margin-top: 10px;background-color: beige;padding: 10px 5px;">
                    <b>Item Info</b>
                </div>
               
                
                <div class="row" runat="server" id="divAddResponsibleUser">
                    <div class="col-md-9 grid_box1">
                        <div class="form-group">
                            <label>Input Product Name or Item Code or BOM to search</label>                             
                            <asp:TextBox runat="server" ID="txtDescription" CssClass="form-control" ></asp:TextBox>
                        </div>
                    </div>
                    
                    

                    <div class="col-md-3">
                        <div class="form-group">
                            <asp:Button runat="server" ID="btnSearch" CssClass="btn btn-danger" Text="SEARCH" style="margin-top: 22px; width:100%" OnClick="btnSearch_Click"/>                      

                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                 <asp:Table runat="server" ID="tbDefectOfEmployee" CssClass=" table table-condensed"></asp:Table>     
                
            </div>
        </ContentTemplate>
      
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

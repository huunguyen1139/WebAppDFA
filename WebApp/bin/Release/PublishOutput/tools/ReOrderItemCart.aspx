<%@ Page Title="ReOrder Item Card" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReOrderItemCart.aspx.cs" Inherits="WebApplication2.ReOrderItemCart" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
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
   
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
                    
            <div class="">
                <div class="panel panel-success">
                    <div class="panel-heading"  runat="server" id="divItem"></div>
                    <div class="panel-body" runat="server" id="divInventory"></div>
                    <div class="panel-body" runat="server" id="divReOrder"></div>
                </div>
                <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75);background-color: white;padding: 10px;">
                    <header class="widget-header">
                        <h3 id="txtDesciptionHeader" style="padding-bottom: 12px; margin-bottom: 0px;margin-top: 0px; padding-top: 4px;" runat="server" class="widget-title">
                           Danh sách đang đặt
                        </h3>
                        <p>Những PR đang đặt và chờ lên PO</p>
                    </header>                                
                    
                    <div class="table-master">                        
                        <asp:Table runat="server" ID="tbPR" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
                    </div>

                    <hr />
                    <header class="widget-header">
                        <h3 id="H1" style="padding-bottom: 12px; margin-bottom: 0px;margin-top: 0px; padding-top: 4px;" runat="server" class="widget-title">
                           Danh sách đang mua
                        </h3>
                        <p>Những PO đang mua và chờ nhập kho</p>
                    </header> 
                    <div class="table-master">                        
                        <asp:Table runat="server" ID="tbPO" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
                    </div>
                </div>

                <hr class="widget-separator" runat="server" id="separator10" visible="false" />
                
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

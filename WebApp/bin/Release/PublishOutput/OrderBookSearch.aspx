<%@ Page Title="Order Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderBookSearch.aspx.cs" Inherits="WebApplication2.OrderBookSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    

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
           
            <div style="padding-top: 20px" visible="false">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:160px">
                    <h2>Order Book</h2>
                    <div style="width: 100%">
                        <div style="width: 33%; float: left">
                            <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div style="width: 33%; float: left">
                            <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtToDate" TextMode="Date" Width="95%" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div style="width: 34%; float: right">
                            <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text="SEARCH" OnClick="btnLoad_Click" />
                        </div>
                    </div>  
                    <div style="width: 100%">
                    <div style="width: 66%; float: left">
                            <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtDescription" Width="97.5%" CssClass="form-control" placeholder="Type description or product code to search..."></asp:TextBox>
                        </div>
                        <div style="width: 34%; float: right">
                            <asp:Button CssClass="btn btn-warning" Style="margin-bottom: 10px" runat="server" ID="btnCopy" Text="COPY TO CLIPBOARD" OnClientClick="selectAndCopyElementContents(document.getElementById('MainContent_tbOrderBookResult'));"/>
                        </div>

                </div>
                    </div>
                <br />                          
                      
            </div>
         
            <div class="">
                <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75);background-color: white;">
                    <header class="widget-header"  style="padding-top: 10px; padding-left: 10px;">
                        <h4 id="txtDesciptionHeader" runat="server" class="widget-title">Search result for '' from... to ...</h4>
                    </header>
                    <hr class="widget-separator">                  

                    <div class="table-responsive">
                        <asp:Table runat="server" ID="tbOrderBookResult" CssClass="table table-hover table-striped"></asp:Table>
                    </div>
                </div>                
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

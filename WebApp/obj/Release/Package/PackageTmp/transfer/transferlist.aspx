<%@ Page Title="Transfer List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="transferlist.aspx.cs" Inherits="WebApplication2.transferlist" %>

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
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>

    <link href="../dist/css/select2.min.css" rel="stylesheet" />
    <script src="../dist/js/select2.min.js"></script>
    <script>
        function pageLoad(sender, args) { $("#<%= ddPI.ClientID %>").select2(); };        
            </script>
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div style="padding-top: 20px" visible="false">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:140px">
                    <h2>Transfer List</h2>
                    
                    <div style="width: 40%; float: left">
                        <asp:DropDownList ID="ddPI" runat="server" CssClass="form-control" Width="95%" Style="margin-bottom: 10px" AutoPostBack="True" OnSelectedIndexChanged="ddPI_SelectedIndexChanged">
                            <asp:ListItem Value="0">- Select PI</asp:ListItem>
                        </asp:DropDownList>
                    </div>                      
                    <div style="width: 60%; float: right">
                        <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text ="Load" OnClick="btnLoad_Click" />
                    </div>                      
                </div>
                <br />                      
            </div>

            
            <div class="">             

                <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div class="table-responsive">
                    <asp:GridView runat="server" ID ="gvDetailOutput" Width="100%" Visible="False" BorderColor="aliceblue" Caption="Production Output Detail" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" OnRowDataBound="gvDetailOutput_RowDataBound">
                        <HeaderStyle BackColor="black" ForeColor="White" BorderColor="Black"/>                     
                    </asp:GridView>
                </div>
                <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
                <div class="table">
                    <asp:GridView runat="server" ID ="gvPINote" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="PI Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                        <HeaderStyle BackColor="#ff9900" BorderColor="#E3E6E3" />                       
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
</asp:Content>

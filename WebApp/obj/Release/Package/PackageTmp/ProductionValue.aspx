<%@ Page Title="Production Value" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductionValue.aspx.cs" Inherits="WebApplication2.ProductionValue" %>

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
   
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div style="padding-top: 20px" visible="false">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:140px">
                    <h2>Production Detail Value $</h2>
                    
                    <div style="width: 28%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control" PlaceHolder="From Date"></asp:TextBox>
                    </div>
                    <div style="width: 28%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtToDate" TextMode="Date" Width="95%" CssClass="form-control" PlaceHolder="To Date"></asp:TextBox>
                    </div>
                    <div style="width: 28%; float: left">
                        <asp:DropDownList ID="ddDepartment" runat="server" CssClass="form-control" Width="95%" Style="margin-bottom: 10px" AutoPostBack="True">
                            <asp:ListItem Value="">- Select Dept</asp:ListItem>
                            <asp:ListItem>WO</asp:ListItem>
                            <asp:ListItem>RM</asp:ListItem>
                            <asp:ListItem>FM</asp:ListItem>
                            <asp:ListItem>AS</asp:ListItem>
                            <asp:ListItem>SA</asp:ListItem>
                            <asp:ListItem>FIN</asp:ListItem>
                            <asp:ListItem>FIT</asp:ListItem>
                            <asp:ListItem>IRON</asp:ListItem>
                            <asp:ListItem>UPH</asp:ListItem>
                            <asp:ListItem>PAC</asp:ListItem>
                        </asp:DropDownList>
                    </div>                      
                    <div style="width: 16%; float: right">
                        <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text ="View" OnClick="btnLoad_Click" />
                    </div>                      
                </div>
                <br />                         
                      
            </div>
           
            <div class="">             

                <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div class="table-responsive">
                    <asp:GridView runat="server" ID ="gvDetailOutput" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Production Output Detail Value" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" ShowFooter="True" AutoGenerateColumns="False" OnRowDataBound="gvDetailOutput_RowDataBound" OnRowDeleting="gvDetailOutput_RowDeleting">
                        <HeaderStyle BackColor="Aqua" BorderColor="#E3E6E3" />                       
                    </asp:GridView>
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

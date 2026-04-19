<%@ Page Title="Marerial Request List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="mrlist.aspx.cs" Inherits="WebApplication2.mrlist" %>

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
          
            <div id="myPopupGV" class="modal fade" role="dialog">
                <div class="modal-dialog">
                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header" >
                            <button type="button" class="close" data-dismiss="modal">
                                &times;</button>
                            <asp:Label runat="server" ID="lbStatus" Text="Đã gửi yêu cầu" CssClass="label label-warning" style="float:right; margin-right:10px;margin-top:5px; font-size:100%"></asp:Label>
                            <a href="mrcard.aspx?id=<% if (ViewState["MRID"]!=null) { %> <%: ViewState["MRID"].ToString() %> <%} %>" target="_blank"><h4 class="modal-title"></h4></a>
                        </div>
                        <div class="modal-body">
                            <div class="table-responsive" style="max-height: 300px;">
                                <asp:GridView runat="server" ID="gvTransferRequestDetail" Width="100%" BorderColor="aliceblue" CssClass="tablerowsmall table-hover" EmptyDataText="No records found">
                                     <HeaderStyle BackColor="black" ForeColor="White" BorderColor="Black"/>
                                </asp:GridView>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                function ShowGVPopup(title, body) {
                    $("#myPopupGV .modal-title").html(title);
                    //$("#myPopupGV .modal-body").html(body);
                    $("#myPopupGV").modal("show");
                }
            </script>    
                                   
            <div class="">
                
                <div class="form-two widget-shadow" style="box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.5); margin-top: 15px;">
                    <div class="form-title" style="background-color: black;">
                        <h4 style="color: white">Data Filter</h4>
                    </div>                    
                                          
                    <div class="form-body" data-example-id="simple-form-inline">
                        <div class="row">
                            <div class="col-md-4 grid_box1">
                                <div class="form-group">
                                    <label>Request No</label>
                                    <asp:TextBox runat="server" ID="txtRequestHeaderNo" AutoPostBack="true" CssClass="form-control" OnTextChanged="txtRequestHeaderNo_TextChanged"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 grid_box1">
                                <div class="form-group">
                                    <label>Transfer No</label>
                                    <asp:TextBox runat="server" ID="txtTransferNo" AutoPostBack="true" CssClass="form-control" OnTextChanged="txtTransferNo_TextChanged"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Status</label>
                                    <asp:DropDownList runat="server" ID="ddStatus" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddStatus_SelectedIndexChanged">
                                        <asp:ListItem Value="all" Text="- Chọn -"></asp:ListItem>
                                        <asp:ListItem Value="in" Selected="True" Text="Chưa hoàn tất"></asp:ListItem>
                                        <asp:ListItem Value="0" Text="Đã gửi yêu cầu"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Đang xử lý"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Đã soạn hàng"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="Đã giao hàng"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 grid_box1">
                                <div class="form-group">
                                    <label>Description</label>
                                    <asp:TextBox runat="server" ID="txtDescription" AutoPostBack="true" CssClass="form-control" OnTextChanged="txtDescription_TextChanged"></asp:TextBox>
                                </div>
                            </div>                         
                            <div class="clearfix"></div>
                        </div>
                    </div>
                        </div>
                <hr />
                <div class="table">
                    <asp:GridView runat="server" ID ="gvRequestHeader" Width="100%" Visible="False" BorderColor="aliceblue" Caption="PI Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                        <HeaderStyle BackColor="black" ForeColor="White" BorderColor="Black"/>                    
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

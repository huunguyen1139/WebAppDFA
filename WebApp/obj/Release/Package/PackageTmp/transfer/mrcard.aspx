<%@ Page Title="Marerial Request Card" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="mrcard.aspx.cs" Inherits="WebApplication2.mrcard" %>

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
        function pageLoad(sender, args) { $("#<%= ddApproverList.ClientID %>").select2(); };        
            </script>

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
                            <h4 class="modal-title"></h4>
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
                                   
            <div class="relative"> 
                <div data-example-id="simple-form-inline" style="margin-top: 15px;font-size: medium;color: dodgerblue;background-color: floralwhite; padding: 10px 10px; margin-bottom: 10px; border: 1px solid lavenderblush;">
                     <div class="row">
                            <div class="col-md-4 grid_box1">
                                <div class="form-group" style="border-bottom: 1px dotted lavender;">
                                    <asp:Label runat="server" ID="lbRequestNo">Request No</asp:Label>                                 
                                </div>
                            </div>
                            <div class="col-md-4 grid_box1">
                                <div class="form-group" style="border-bottom: 1px dotted lavender;">
                                   <asp:Label runat="server" ID="lbTransferNo">Transfer No</asp:Label>                               
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group" style="border-bottom: 1px dotted lavender;">
                                    <asp:Label runat="server" ID="lbRequestStatus">Status</asp:Label>                                   
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                     <div class="row">
                         <div class="col-md-12 grid_box1">
                             <div class="form-group" style="border-bottom: 1px dotted lavender;">
                                 <asp:Label runat="server" ID="lbDescription">Description</asp:Label>
                             </div>
                         </div>
                         <div class="clearfix"></div>
                     </div>                
                </div>

                <div class="relative">
                         <div class="dropdown" style="float:right">
                             <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
                                 Change Status
                             <span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><asp:LinkButton ID="lbtnSent" runat="server" Text="Đã gửi yêu cầu" OnClick="lbtnSent_Click"></asp:LinkButton></li>
                                 <li><asp:LinkButton ID="lbtnProcessing" runat="server" Text="Đang xử lý" OnClick="lbtnProcessing_Click"></asp:LinkButton></li>
                                 <li><asp:LinkButton ID="lbtnReady" runat="server" Text="Đã soạn hàng" OnClick="lbtnReady_Click"></asp:LinkButton></li>
                                 <li class="divider"></li>
                                 <li><asp:LinkButton ID="lbtnCompleted" runat="server" Text="Đã giao hàng" OnClick="lbtnCompleted_Click"></asp:LinkButton></li>
                             </ul>
                         </div>
                         <div class="dropdown" style="float:right; margin-right:10px">
                             <button class="btn btn-success dropdown-toggle" type="button" data-toggle="dropdown">Print<span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><a href="../ReportViewer.aspx?type=mr&id=<% if (Request["id"]!=null) { %> <%: Request["id"].ToString() %> <%} %>" target="_blank">A4 Format</a></li>
                                 <li><a href="#">A5 Format</a></li>                               
                             </ul>
                         </div>
                        <asp:TextBox runat="server" ID="txtWHShipmentNo" CssClass="form-control" placeholder="Warehouse Shipment No" style="float:right;margin-right:10px;width: 200px;height: 36px;"></asp:TextBox>
                </div>

                <div class="table">
                    <asp:GridView runat="server" ID ="gvRequestLine" Width="100%" Visible="False" BorderColor="aliceblue" Caption="Danh sách vật tư yêu cầu" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" OnRowDataBound="gvRequestLine_RowDataBound">
                        <HeaderStyle BackColor="black" ForeColor="White" BorderColor="Black"/>                    
                    </asp:GridView>
                </div>
                <hr />
                <div class="table">
                    <asp:GridView runat="server" ID ="gvApprover" Width="100%" Visible="False" BorderColor="aliceblue" Caption="Danh sách người duyệt" CssClass="tablerowsmall" AutoGenerateDeleteButton="true" OnRowDeleting="gvApprover_RowDeleting" EmptyDataText="No records found" OnRowDataBound="gvApprover_RowDataBound">
                        <HeaderStyle BackColor="beige" ForeColor="black" BorderColor="beige"/>                    
                    </asp:GridView>
                </div>
                <div class="row" runat="server" id="divAddApprover">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Chọn người duyệt</label>
                             <asp:DropDownList runat="server" ID="ddApproverList" CssClass="form-control" AutoPostBack="true">
                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                
                                
                            </asp:DropDownList> 
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="form-group">
                            <asp:Button runat="server" ID="btnAddApprover" CssClass="btn btn-info" Text="Add" style="margin-top: 22px;" OnClick="btnAddApprover_Click"/>                      

                        </div>
                    </div>
                    <div class="clearfix"></div>
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

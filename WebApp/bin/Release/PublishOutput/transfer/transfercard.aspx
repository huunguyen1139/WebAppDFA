<%@ Page Title="Transfer Card" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="transfercard.aspx.cs" Inherits="WebApplication2.transfercard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        #txtSearchText {
            background-image: url('/Content/searchicon.png'); /* Add a search icon to input */
            background-position: 10px 12px; /* Position the search icon */
            background-repeat: no-repeat; /* Do not repeat the icon image */
            width: 100%; /* Full-width */
            font-size: 16px; /* Increase font-size */
            padding: 4px 20px 4px 40px; /* Add some padding */
            border: 1px solid #ddd; /* Add a grey border */
            margin-bottom: 12px; /* Add some space below the input */
            margin-top: 10px;
        }
    </style>
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
    <script>
        function searchText() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("txtSearchText");
            filter = input.value.toUpperCase();
            table = document.getElementById("MainContent_gvDetailMaterial");
            tr = table.getElementsByTagName("tr");

            // Loop through all table rows, and hide those who don't match the search query
            for (i = 0; i < tr.length; i++) {
                tdl = tr[i].getElementsByTagName("td");
                for (j = 0; j < tdl.length; j++) {
                    td = tdl[j];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                        else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
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
                                   
            <div class="">
                <input type="text" id="txtSearchText" onkeyup="searchText()" placeholder="Nhập thông tin để tìm kiếm...">
                <asp:LinkButton runat="server" ID="lbtnViewRemainItem" Text="View Remain Items" OnClick="lbtnViewRemainItem_Click"></asp:LinkButton>
                <div class="table-responsive">
                    <asp:GridView runat="server" ID ="gvDetailMaterial" Width="100%" Visible="False" BorderColor="aliceblue" Caption="Production Output Detail" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                        <HeaderStyle BackColor="black" ForeColor="White" BorderColor="Black"/>                       
                    </asp:GridView>
                </div>
                
                <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
                <div class="table">
                    <asp:GridView runat="server" ID ="gvSelectedMaterial" Width="100%" Visible="False" BorderColor="aliceblue" Caption="PI Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateDeleteButton="true" OnRowDeleting="gvSelectedMaterial_RowDeleting">
                        <HeaderStyle BackColor="black" ForeColor="White" BorderColor="Black"/>                      
                    </asp:GridView>
                </div>
                <asp:Button runat="server" ID="btnCreateRequest" style="padding: 5px 12px;" class="btn btn-danger" Text="TẠO YÊU CẦU XUẤT KHO" OnClick="btnCreateRequest_Click"></asp:Button>
                <hr class="widget-separator" runat="server" id="Hr2" visible="true" />

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

<%@ Page Title="ReOrder Item List" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MappingGL.aspx.cs" Inherits="WebApplication2.MappingGL" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        #txtSearch {
            background-image: url('/Content/searchicon.png'); /* Add a search icon to input */
            background-position: 10px 12px; /* Position the search icon */
            background-repeat: no-repeat; /* Do not repeat the icon image */
            width: 100%; /* Full-width */
            font-size: 16px; /* Increase font-size */
            padding: 12px 20px 12px 40px; /* Add some padding */
            border: 1px solid #ddd; /* Add a grey border */
            margin-bottom: 12px; /* Add some space below the input */
        }
    </style>
    <!-- Bootstra-->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    
    <link href="Content/font-awesome.css" rel="stylesheet" />

    <script>
        function searchPI() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("txtSearch");
            filter = input.value.toUpperCase();
            table = document.getElementById("MainContent_tbMasterPlan");
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
                <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75);background-color: white;padding: 10px;">
                    <header class="widget-header">
                        <h4 id="txtDesciptionHeader" style="padding-bottom: 12px; margin-bottom: 0px;margin-top: 0px; padding-top: 4px;" runat="server" class="widget-title">
                           <a href="ReOrderItems.aspx?type=all">Re-Order Items List</a> 
                        </h4>
                    </header>
                     
                   
                
                <div runat="server" id="divMessage" class="alert alert-danger" role="alert" Visible="false">
                    <asp:Label runat="server" ID="lbErrorDescription" Text="Error Text"></asp:Label>
                </div>
                
                <div style="margin-bottom: 10px; margin-top: 10px; background-color: cadetblue;padding: 10px 5px; color: white;">
                    <b>Thông tin chung</b>
                </div>
                <div class="row">
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Từ ngày <em>(*)</em></label>
                            <asp:TextBox runat="server" ID="txtFromDate" TextMode="Date" CssClass="form-control" ReadOnly="false"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>Đến ngày <em>(*)</em></label>
                            <asp:TextBox runat="server" ID="txtToDate" TextMode="Date" CssClass="form-control" ReadOnly="false"></asp:TextBox>                            
                        </div>
                    </div>
                    <div class="col-md-3 grid_box1">
                        <div class="form-group">
                            <label>G/L Account <em>(*)</em></label>
                            <asp:TextBox runat="server" ID="txtGLAccount" CssClass="form-control" ReadOnly="false"></asp:TextBox>                            
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <asp:Button runat="server" ID="btnLoad" CssClass="btn btn-success" Text="LOAD" OnClick="btnLoad_Click1" />
                    </div>
                    <div class="clearfix"></div>
                </div>

                    <input type="text" id="txtSearch" onkeyup="searchPI()" placeholder="Search for item code or names..">
                    <div class="table-master">
                        
                        <asp:Table runat="server" ID="tbMasterPlan" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
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

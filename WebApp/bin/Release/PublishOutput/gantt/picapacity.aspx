<%@ Page Title="PI's Capacity" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="picapacity.aspx.cs" Inherits="WebApplication2.gantt.picapacity" %>

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

    <!-- Form dang ky PI Capacity -->
    
    <div id="AddNewPICapacity" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Add new</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-4 m-b-20" ID="lbScenario" Text="Scenario Code" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-8 m-b-20">
                            <asp:DropDownList runat="server" ID="ddScenarioCode" CssClass="form-control" ></asp:DropDownList> 
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-4 m-b-20" ID="Label6" Text="PI" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-8 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtPI" ></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group">                       
                        <asp:Label runat="server" class="col-md-4 m-b-20" ID="Label1" Text="Capacity ($)" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-8 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtCapacity" TextMode="Number"></asp:TextBox>
                        </div>
                    </div>
                       
                </div>

                <div class="modal-footer">                    
                <asp:Button runat="server" type="submit" ID="btnAdd" OnClick="btnAdd_Click" Text="Add" CssClass="btn btn-success"/>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>                                                
                </div>
            </div>
         
        </div>
    </div>       
    <script type="text/javascript">
        function ShowAddNewPICapacityForm() {
            $("#AddNewPICapacity").modal("show");
        }

        function HideScenarioRegisterForm() {
            $("#AddNewPICapacity").modal("hide");
            $("#AddNewPICapacity").css("display", "none");
            $("#AddNewPICapacity").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("AddNewPICapacity");
            var i;
            for (i = 0; i < x.length; i++) {
                x[i].className = "";
            }
            y.className = "modal fade";
            y.css("display", "none");

        }
    </script>
   
    <!-- end-->
    
    
   
   

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
                       
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="gantt.aspx">SQR Gantt</a>
                    </div>
                    <ul class="nav navbar-nav">
                        <li><a href="holiday.aspx">Holiday</a></li>
                        <li><a href="unconfirmedPI.aspx">Unconfirmed PI</a></li>
                        <li><a href="plannedcapacity.aspx">Planned Capacity</a></li>
                         <li class="active"><a href="picapacity.aspx">PI Capacity</a></li>
                        <li><a href="scenario.aspx">Scenario</a></li>
                        <li><a href="simulationdata.aspx">Simulation Data</a></li>
                    </ul>
                </div>
            </nav>
                        
            <h3>PI Capacity</h3>
            <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
            <div class="relative">
                         <div class="dropdown" style="float:right">
                             <button class="btn btn-success dropdown-toggle" type="button" data-toggle="dropdown">
                                 Action
                             <span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><asp:LinkButton ID="lbtnAdd" runat="server" Text="Add new" OnClientClick="ShowAddNewPICapacityForm()"></asp:LinkButton></li>
                                 
                             </ul>
                         </div> 
                        
                </div>
             <div class="clearfix"></div>
            <hr class="widget-separator" runat="server" id="Hr2" visible="true" />
            
            <div class="table-responsive">
                <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" BorderColor="#E3E6E3" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False" AllowSorting="True" AutoGenerateDeleteButton="true" OnRowDeleted="gvDetailOutput_RowDeleted" OnRowDeleting="gvDetailOutput_RowDeleting">
                    <HeaderStyle BackColor="White" BorderColor="#E3E6E3" />
                </asp:GridView>
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

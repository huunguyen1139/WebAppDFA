<%@ Page Title="Simulation Data" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="simulationdata.aspx.cs" Inherits="WebApplication2.gantt.simulationdata" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    <style type="text/css">
               .selected
        {
            background-color: #666;
            color: #fff;
        }
    </style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.24/themes/smoothness/jquery-ui.css" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.24/jquery-ui.min.js"></script>
  
  
    <script type="text/javascript">
        $(function AllowDragAndDrop() {
            $("#MainContent_gvDetailOutput").sortable({
                items: 'tr:not(tr:first-child)',
                cursor: 'pointer',
                axis: 'y',
                dropOnEmpty: false,
                start: function (e, ui) {
                    ui.item.addClass("selected");
                },
                stop: function (e, ui) {
                    ui.item.removeClass("selected");
                },
                receive: function (e, ui) {
                    $(this).find("tbody").append(ui.item);
                }
            });
        });

        $(document).ready(function () { AllowDragAndDrop(); });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            AllowDragAndDrop();
        });
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

    <!-- Form them moi order -->
    
    <div id="NewOrderRegister" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Add new order</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-3 m-b-20" ID="lbTemplateCode" Text="Scenario Code" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-9 m-b-20">
                            <asp:DropDownList runat="server" ID="ddScenarioCode" CssClass="form-control"></asp:DropDownList>
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-3 m-b-20" ID="Label6" Text="PI" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtPI" placeholder="Input PI"></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                       
                        <asp:Label runat="server" class="col-md-3 m-b-20" ID="Label1" Text="Amount ($)" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtAmount" placeholder="Input total amount of PI" TextMode="Number"></asp:TextBox> 
                        </div>
                    </div>
                    
                    <div class="form-group">                       
                        <asp:Label runat="server" class="col-md-3 m-b-20" ID="Label2" Text="Promised Date" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtPromisedDate"  TextMode="Date"></asp:TextBox> 
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
        function ShowNewOrderRegisterForm() {
            $("#NewOrderRegister").modal("show");
        }

        function HideNewOrderRegisterForm() {
            $("#NewOrderRegister").modal("hide");
            $("#NewOrderRegister").css("display", "none");
            $("#NewOrderRegister").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("NewOrderRegister");
            var i;
            for (i = 0; i < x.length; i++) {
                x[i].className = "";
            }
            y.className = "modal fade";
            y.css("display", "none");

        }
    </script>
   
    <!-- end-->
       

<%--    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>   --%>       
                
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="gantt.aspx">SQR Gantt</a>
                    </div>
                    <ul class="nav navbar-nav">
                        <li><a href="holiday.aspx">Holiday</a></li>
                        <li><a href="unconfirmedPI.aspx">Unconfirmed PI</a></li>
                        <li><a href="plannedcapacity.aspx">Planned Capacity</a></li>
                        <li><a href="picapacity.aspx">PI Capacity</a></li>
                        <li><a href="scenario.aspx">Scenario</a></li>
                        <li class="active"><a href="simulationdata.aspx">Simulation Data</a></li>
                    </ul>
                </div>
            </nav>
                        
            <h3>Simulation Data</h3>
            <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
            <div class="relative">
                         <div class="dropdown" style="float:right">
                             <button class="btn btn-danger dropdown-toggle" type="button" data-toggle="dropdown">
                                 Simulation DATA
                             <span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><asp:LinkButton ID="lbtnCopyMasterPlan" runat="server" Text="Copy from Master Plan" OnClientClick="return confirm('All data in the selected scenario will be deleted and replaced. Do you want to continue?')" OnClick="lbtnCopyMasterPlan_Click"></asp:LinkButton></li>
                                 <%--<li><asp:LinkButton ID="lbtnAddNewData" runat="server" Text="Add New Order" OnClientClick="ShowNewOrderRegisterForm()"></asp:LinkButton></li>--%>
                                 <li><a data-toggle="modal" href="#NewOrderRegister" >Add New Order</a></li>
                                 <li class="divider"></li>
                                 <li><asp:LinkButton ID="lbtnRefresh" runat="server" Text="Reset Capacity" OnClick="lbtnRefresh_Click"></asp:LinkButton></li>
                             </ul>
                         </div>
                         <div class="dropdown" style="float:right; margin-right:10px">
                             <button class="btn btn-success dropdown-toggle" type="button" data-toggle="dropdown">Action <span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><asp:LinkButton ID="lbtnCalculate" runat="server" Text="Calculate" OnClick="lbtnCalculate_Click"></asp:LinkButton></li> 
                                 <li><asp:LinkButton ID="lbtnUpdatePriority" runat="server" Text="Update Priority" OnClick="lbtnUpdatePriority_Click"></asp:LinkButton></li>
                                                             
                             </ul>
                         </div>
                <asp:DropDownList runat="server" ID="ddScenario" CssClass="form-control" style="float:right;margin-right:10px;width: 200px;height: 36px;" AutoPostBack ="true" OnSelectedIndexChanged="ddScenario_SelectedIndexChanged">
                    <asp:ListItem Value="0" Text="- Scenario Code"></asp:ListItem>
                </asp:DropDownList>
                        
                </div>
             <div class="clearfix"></div>
            <hr class="widget-separator" runat="server" id="Hr2" visible="true" />
            <%--<div CLASS="form-horizontal" style="width: 100%">
                <div class="col-sm-6"><asp:TextBox runat="server" style="margin-bottom:8px" ID="txtNewHoliday" CssClass="form-control" Width="100%" TextMode="Date"></asp:TextBox></div>
                <div class="col-sm-6"><asp:TextBox runat="server" style="margin-bottom:8px" ID="txtDescription" CssClass="form-control" Width="100%" placeholder="Description..."></asp:TextBox></div>
                <div class="clearfix"></div>
                <div class="col-sm-12"><asp:Button runat="server" ID="btnAdd" Text="ADD" OnClick="btnAdd_Click"/></div>
                <div class="clearfix"></div>
            </div>--%>
             
            
           <%-- <hr class="widget-separator" runat="server" id="Hr2" visible="true" />--%>
    <div class="table-responsive">
        <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" BorderColor="#E3E6E3" CssClass="tablerowsmall" EmptyDataText="No records found" AutoGenerateColumns="False" AutoGenerateDeleteButton="True" OnRowDeleting="gvDetailOutput_RowDeleting">
            <HeaderStyle BackColor="White" BorderColor="#E3E6E3" />
        </asp:GridView>       

    </div>

            <div class="table-responsive">
                <asp:GridView runat="server" ID="GridView1" Width="100%" BorderColor="#E3E6E3" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False">
                    <HeaderStyle BackColor="White" BorderColor="#E3E6E3" />
                </asp:GridView>
            </div>

            <div class="table-responsive">
                <div>
	
</div>
            </div>
    <%--         
        </ContentTemplate>
        
    </asp:UpdatePanel>--%>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

<%@ Page Title="Planned Capacity" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="plannedcapacity.aspx.cs" Inherits="WebApplication2.gantt.plannedcapacity" %>

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

    <!-- Form dang ky Capacity Template -->
    
    <div id="CapacityTemplateRegister" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Add new capacity template</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-3 m-b-20" ID="lbTemplateCode" Text="Template Code" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtNewCapacityTemplate" ></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group">                       
                        <asp:Label runat="server" class="col-md-3 m-b-20" ID="Label1" Text="Description" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtDescription"></asp:TextBox> 
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
        function ShowCapacityRegisterForm() {           
            $("#CapacityTemplateRegister").modal("show");
        }

        function HideCapacityRegisterForm() {
            $("#CapacityTemplateRegister").modal("hide");
            $("#CapacityTemplateRegister").css("display", "none");
            $("#CapacityTemplateRegister").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("CapacityTemplateRegister");
            var i;
            for (i = 0; i < x.length; i++) {
                x[i].className = "";
            }
            y.className = "modal fade";
            y.css("display", "none");

        }
    </script>
   
    <!-- end-->
    
    <!-- Form Allocate Capacity -->
    <div id="CapacityAllocate" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->            
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Capacity Allocation</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-3 m-b-20" ID="Label2" Text="Template Code" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-9 m-b-20">                           
                            <asp:DropDownList runat="server" ID="ddCapacityTemplatePopup" CssClass="form-control"></asp:DropDownList>
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-3 m-b-20" ID="Label4" Text="Start Date" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtStartDate" TextMode="Date"></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-3 m-b-20" ID="Label5" Text="Finish Date" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtFinishDate" TextMode="Date" ></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group">                       
                        <asp:Label runat="server" class="col-md-3 m-b-20" ID="Label3" Text="Capacity ($)" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-9 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtCapacity" TextMode="Number" placeholder="i.e 45000" ></asp:TextBox> 
                        </div>
                    </div>
                       
                </div>

                <div class="modal-footer">                    
                <asp:Button runat="server" ID="btnAllocate" OnClick="btnAllocate_Click" Text="Start Allocate" CssClass="btn btn-success"/>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>                                                
                </div>
            </div>              
        </div>
    </div>
    <script type="text/javascript">
        function ShowCapacityAllocateForm() {
            $("#CapacityAllocate").modal("show");
        }

        function HideCapacityAllocateForm() {
            $("#CapacityAllocate").modal("hide");
            $("#CapacityAllocate").css("display", "none");
            $("#CapacityAllocate").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("CapacityAllocate");
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
                        <li class="active"><a href="plannedcapacity.aspx">Planned Capacity</a></li>
                        <li><a href="picapacity.aspx">PI Capacity</a></li>
                        <li><a href="scenario.aspx">Scenario</a></li>
                        <li><a href="simulationdata.aspx">Simulation Data</a></li>
                    </ul>
                </div>
            </nav>
                        
            <h3>Planned Capacity</h3>
            <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
            <div class="relative">
                         <div class="dropdown" style="float:right">
                             <button class="btn btn-primary dropdown-toggle" type="button" data-toggle="dropdown">
                                 Action
                             <span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><asp:LinkButton ID="lbtnSent" runat="server" Text="Add new template" OnClientClick="ShowCapacityRegisterForm()"></asp:LinkButton></li>
                                 <li><asp:LinkButton ID="lbtnProcessing" runat="server" Text="Allocate Capacity" OnClientClick="ShowCapacityAllocateForm()"></asp:LinkButton></li>
                               
                                 <li class="divider"></li>
                                 <li><asp:LinkButton ID="lbtnReset" runat="server" Text="Reset Capacity" OnClick="lbtnReset_Click"></asp:LinkButton></li>
                             </ul>
                         </div>
                         <%--<div class="dropdown" style="float:right; margin-right:10px">
                             <button class="btn btn-success dropdown-toggle" type="button" data-toggle="dropdown">Print<span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><a href="~/ReportViewer.aspx?type=mr&id=<% if (Request["id"]!=null) { %> <%: Request["id"].ToString() %> <%} %>" target="_blank">A4 Format</a></li>
                                 <li><a href="#">A5 Format</a></li>                               
                             </ul>
                         </div>--%>
                <asp:DropDownList runat="server" ID="ddCapacityTemplate" CssClass="form-control" style="float:right;margin-right:10px;width: 200px;height: 36px;" AutoPostBack ="true" OnSelectedIndexChanged="ddCapacityTemplate_SelectedIndexChanged">
                    <asp:ListItem Value="0" Text="- Planned Capacity"></asp:ListItem>
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
                <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" BorderColor="#E3E6E3" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False">
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

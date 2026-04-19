<%@ Page Title="Scenario" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="scenario.aspx.cs" Inherits="WebApplication2.gantt.scenario" %>

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

    <!-- Form dang ky Scenerio -->
    
    <div id="ScenarioRegister" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Add new scenario</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-4 m-b-20" ID="lbScenario" Text="Scenario Code" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-8 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtScenarioCode" ></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-4 m-b-20" ID="Label6" Text="Description" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-8 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtDescription" ></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group">                       
                        <asp:Label runat="server" class="col-md-4 m-b-20" ID="Label1" Text="Capacity Template" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-8 m-b-20">
                            <asp:DropDownList runat="server" ID="ddCapacityTemplate" CssClass="form-control" ></asp:DropDownList>
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
        function ShowScenarioRegisterForm() {
            $("#ScenarioRegister").modal("show");
        }

        function HideScenarioRegisterForm() {
            $("#ScenarioRegister").modal("hide");
            $("#ScenarioRegister").css("display", "none");
            $("#ScenarioRegister").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("ScenarioRegister");
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

            <!-- Form Allocate Capacity -->
    <div id="ScenarioEdit" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->            
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Scenario - Edit</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-4 m-b-20" ID="Label2" Text="Scenario Code" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-8 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtScenarioCodeEdit"></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group" style="overflow-x:auto">                        
                        <asp:Label runat="server" CssClass="col-md-4 m-b-20" ID="Label3" Text="Description" style="padding-top: 7px"></asp:Label>                        
                        <div class="col-md-8 m-b-20">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtDescriptionEdit" ></asp:TextBox> 
                        </div> 
                    </div>

                    <div class="form-group">                       
                        <asp:Label runat="server" class="col-md-4 m-b-20" ID="Label4" Text="Capacity Template" style="padding-top: 7px"></asp:Label>                       
                        <div class="col-md-8 m-b-20">
                            <asp:DropDownList runat="server" ID="ddCapacityTemplateEdit" CssClass="form-control" ></asp:DropDownList>
                        </div>
                    </div>
                       
                </div>

                <div class="modal-footer">                    
                <asp:Button runat="server" ID="btnSave" OnClick="btnSave_Click" Text="SAVE" CssClass="btn btn-success"/>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>                                                
                </div>
            </div>              
        </div>
    </div>
    <script type="text/javascript">
        function ShowScenarioEditForm() {
            $("#ScenarioEdit").modal("show");
        }

        function HideScenarioEditForm() {
            $("#ScenarioEdit").modal("hide");
            $("#ScenarioEdit").css("display", "none");
            $("#ScenarioEdit").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade in");
            var y = document.getElementById("ScenarioEdit");
            var i;
            for (i = 0; i < x.length; i++) {
                x[i].className = "";
            }
            y.className = "modal fade";
            y.css("display", "none");

        }
    </script>
             <!-- end-->
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
                        <li class="active"><a href="scenario.aspx">Scenario</a></li>
                        <li><a href="simulationdata.aspx">Simulation Data</a></li>
                    </ul>
                </div>
            </nav>
                        
            <h3>Scenario</h3>
            <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
            <div class="relative">
                         <div class="dropdown" style="float:right">
                             <button class="btn btn-success dropdown-toggle" type="button" data-toggle="dropdown">
                                 Action
                             <span class="caret"></span>
                             </button>
                             <ul class="dropdown-menu">
                                 <li><asp:LinkButton ID="lbtnAdd" runat="server" Text="Add new template" OnClientClick="ShowScenarioRegisterForm()"></asp:LinkButton></li>
                                 
                             </ul>
                         </div> 
                        
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
                <%--<asp:GridView runat="server" ID="gvDetailOutput" Width="100%" BorderColor="#E3E6E3" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False" AllowSorting="True" AutoGenerateEditButton="True" OnRowEditing="gvDetailOutput_RowEditing">
                    <HeaderStyle BackColor="White" BorderColor="#E3E6E3" />
                </asp:GridView>--%>
                <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" BorderColor="#E3E6E3" CssClass="tablerowsmall" EmptyDataText="No records found" AutoGenerateColumns="False">
            <HeaderStyle BackColor="White" BorderColor="#E3E6E3" />
            <Columns>
                <asp:BoundField DataField="Code" HeaderText="Code" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <asp:BoundField DataField="CreatedUser" HeaderText="Created User" />
                <asp:BoundField DataField="PlannedCapacityTemplate" HeaderText="PlannedCapacityTemplate" />
                <asp:BoundField DataField="LastUpdateOn" HeaderText="Last Updated On" />
                <asp:BoundField DataField="LastUpdateBy" HeaderText="Last Updated By" />
                <asp:BoundField DataField="Disabled" HeaderText="Disabled" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" ID="lbtnEdit" OnClick="lbtnEdit_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Edit"><i class="text-info fa fa-edit"></i></asp:LinkButton>
                        <asp:LinkButton Style="color: #E34724;" runat="server" ID="lbtnDelete" OnClick="lbtnDelete_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Disable"><i class="fa fa-unlock-alt"></i></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
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

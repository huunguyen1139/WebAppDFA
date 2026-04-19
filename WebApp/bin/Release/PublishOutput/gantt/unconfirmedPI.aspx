<%@ Page Title="Holiday" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="unconfirmedPI.aspx.cs" Inherits="WebApplication2.gantt.unconfirmedPI" %>

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

    <!-- Form dang ky ngay Holiday -->
    <div id="HolidayRegister" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">Add new</h4>
                </div>
                <div class="modal-body" style="overflow-x:auto">
                    
                    <div class="col-md-12 m-b-20 form-group">
                       <asp:TextBox runat="server" CssClass="form-control" ID="txtPINo" placeholder="Input PINo"></asp:TextBox> 
                                                        </div>                    
                       
                </div>
                <div class="modal-footer">
                    
                    <%--<button type="button" runat="server" id="btnSave" onserverclick="btnSave_ServerClick" class="btn btn-info waves-effect"
                                                     >Save</button>--%>
                    <asp:Button runat="server" ID="btnAdd" OnClick="btnAdd_Click" Text="Add" CssClass="btn btn-success"/>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>
                                                
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ShowHolidayRegisterForm() {           
            $("#HolidayRegister").modal("show");
        }

        function HideHolidayRegisterForm() {
            $("#HolidayRegister").modal("hide");
            $("#HolidayRegister").css("display", "none");
            $("#HolidayRegister").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("HolidayRegister");
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
                        <li class="active"><a href="unconfirmedPI.aspx">Unconfirmed PI</a></li>
                        <li><a href="plannedcapacity.aspx">Planned Capacity</a></li>
                        <li><a href="picapacity.aspx">PI Capacity</a></li>
                        <li><a href="scenario.aspx">Scenario</a></li>
                        <li><a href="simulationdata.aspx">Simulation Data</a></li>
                    </ul>
                </div>
            </nav>

            <hr class="widget-separator" runat="server" id="separator10" visible="false" />
            <button type="button" style="margin-bottom: 10px; float: right" class="btn btn-info" data-toggle="modal" onclick="ShowHolidayRegisterForm()">Add New</button>
            <h3>Unconfirmed PI</h3>
             <div class="clearfix"></div>
            <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
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

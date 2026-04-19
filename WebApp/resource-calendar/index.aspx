<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApplication2.resource_calendar.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Resource Calendar</title>
    <link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet"/>
        
  
    <link href="../kpi/src/assets/libs/fullcalendar/dist/main.css" rel="stylesheet" />
	<script src="../kpi/src/assets/libs/fullcalendar/dist/main.js"></script>
  
	
    <link rel="stylesheet" href="https://bootswatch.com/4/lux/bootstrap.min.css"/>
	<script src="../kpi/src/assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../kpi/src/assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
	<script src="../kpi/src/assets/extra-libs/taskboard/js/jquery-ui.min.js"></script>


<style>
  body {
    margin: 0;
    padding: 0;
    font-size: 14px;
  }

  #top,
  #calendar.fc-theme-standard {
    font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
  }

  #calendar.fc-theme-bootstrap {
    font-size: 14px;
  }

  #top {
    background: #eee;
    border-bottom: 1px solid #ddd;
    padding: 0 10px;
    line-height: 40px;
    font-size: 12px;
    color: #000;
  }

  #top .selector {
    display: inline-block;
    margin-right: 10px;
  }

  #top select {
    font: inherit; /* mock what Boostrap does, don't compete  */
  }

  .left { float: left }
  .right { float: right }
  .clear { clear: both }

  #calendar {
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 10px;
  }

</style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- BEGIN MODAL -->
                <div class="modal none-border" id="my-event">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header d-flex align-items-center">
                                <h4 class="modal-title"><strong>Add Event</strong></h4>
                                <button type="button" class="close ml-auto" data-dismiss="modal" aria-hidden="true">&times;</button>
                            </div>
                            <div class="modal-body"></div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary waves-effect" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-success save-event waves-effect waves-light">Create event</button>
                                <button type="button" class="btn btn-danger delete-event waves-effect waves-light" data-dismiss="modal">Delete</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal Add Category -->
                <div class="modal fade none-border" id="add-new-event">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header d-flex align-items-center">
                                <h4 class="modal-title"><strong>Add</strong> new event</h4>
                                <button type="button" class="close ml-auto" data-dismiss="modal" aria-hidden="true">&times;</button>
                            </div>
                            <div class="modal-body">
                                
									<div class="row mb-3">
										<div class="col-md-6">
                                            <label class="control-label">Title</label>
                                            <asp:TextBox runat="server" id="txtTitle" class="form-control form-white" placeholder="Enter name" />
                                        </div>
										<div class="col-md-6">
                                            <label class="control-label">Location</label>
                                            
                                            <asp:DropDownList ID="ddResource" runat="server" class="form-control form-white">
                                                <asp:ListItem Value="0" Text="Location"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
									</div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="control-label">From date</label>
                                            <asp:TextBox runat="server" id="txtFromDate" class="form-control form-white" TextMode="Date" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="control-label">Hour</label>
                                            <select runat="server" id="ddFromHours" class="form-control form-white" data-placeholder="Choose a color..." name="category-color">
                                                <option value="7">7</option>
                                                <option value="8">8</option>
                                                <option value="9">9</option>
                                                <option value="10">10</option>
                                                <option value="11">11</option>
                                                <option value="12">12</option>
                                                <option value="13">13</option>
                                                <option value="14">14</option>
                                                <option value="15">15</option>
                                                <option value="16">16</option>
                                               
                                            </select>
                                        </div>
										
										<div class="col-md-3">
                                            <label class="control-label">Minute</label>
                                            <select runat="server" id="ddFromMinute" class="form-control form-white" data-placeholder="Choose a color..." name="category-color">
                                                <option value="0">0</option>                                               
                                                <option value="10">10</option>
                                                <option value="15">15</option>
                                                <option value="20">20</option>
                                                <option value="30">30</option>
                                                <option value="40">40</option>
                                                <option value="45">45</option>
                                                <option value="50">50</option>
                                               
                                            </select>
                                        </div>
                                    </div>
									
									
									<div class="row mb-3">
                                        <div class="col-md-6">
                                            <%--<label class="control-label">To date</label>
                                            <asp:TextBox runat="server" id="txtToDate" class="form-control form-white" TextMode="Date" />--%>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="control-label">Hour</label>
                                           <select runat="server" id="ddToHours" class="form-control form-white" data-placeholder="Choose a color..." name="category-color">
                                                <option value="7">7</option>
                                                <option value="8">8</option>
                                                <option value="9">9</option>
                                                <option value="10">10</option>
                                                <option value="11">11</option>
                                                <option value="12">12</option>
                                                <option value="13">13</option>
                                                <option value="14">14</option>
                                                <option value="15">15</option>
                                                <option value="16">16</option>
                                               
                                            </select>
                                        </div>
										
										<div class="col-md-3">
                                            <label class="control-label">Minute</label>
                                           <select runat="server" id="ddToMinutes" class="form-control form-white" data-placeholder="Choose a color..." name="category-color">
                                                <option value="0">0</option>                                               
                                                <option value="10">10</option>
                                                <option value="15">15</option>
                                                <option value="20">20</option>
                                                <option value="30">30</option>
                                                <option value="40">40</option>
                                                <option value="45">45</option>
                                                <option value="50">50</option>
                                               
                                            </select>
                                        </div>
                                    </div>
									
									<div class="row mb-3">
										<div class="col-md-12">                                           
                                            <div class="form-check">
                                                        <input type="checkbox" runat="server" class="form-check-input" id="cbRecurringEvent" />
                                                        <label class="form-check-label" for="drop-remove">Recurring Event</label>
                                                    </div>
                                        </div>
									</div>
									<div class="row" runat="server" id="divRecurring" visible="false">
										<div class="col-md-12 mb-3">
                                            
                                            <input class="form-control" placeholder="Enter name" type="text" name="category-name" />
                                        </div>
									</div>
                                
                            </div>
                            <div class="modal-footer">
                                <asp:Button runat="server" id="btnSAVE" class="btn btn-danger waves-effect waves-light save-category" OnClick="btnSAVE_Click" Text="Save"/>
                        <%--        <button type="button" runat="server" id="btnSAVE1" class="btn btn-danger waves-effect waves-light save-category" data-dismiss="modal" onclick="">Save</button>--%>
                                <button type="button" class="btn btn-secondary waves-effect" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END MODAL -->			
    <div id="main-wrapper">
        <!-- ============================================================== -->
     
        <!-- ============================================================== -->
        <div class="mt-3">
            
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            
                                <div class="row">
                                    <div class="col-lg-3 border-end pe-0" style = "border-right: 1px solid #e9ecef!important; padding-right: 0!important;">
                                        <div class="card-body border-bottom">
                                            <h4 class="card-title mt-2">RESOURCE LIST</h4>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div runat="server" id="divResources" class="">
                                                        <%--<div class="calendar-events mb-3" data-class="bg-info"><i
                                                                class="fa fa-circle text-info me-2"></i><a href="index?id=1"> Phòng họp lớn - X6</a></div>
                                                        <div class="calendar-events mb-3" data-class="bg-success"><i
                                                                class="fa fa-circle text-success me-2"></i> <a href="index?id=2"> Phòng họp nhỏ - X6</a>
                                                        </div>
                                                        <div class="calendar-events mb-3" data-class="bg-danger"><i
                                                                class="fa fa-circle text-danger me-2"></i><a href="index?id=3"> Phòng họp lớn - X7</a>
                                                        </div>--%>
                                                        <%--<div class="calendar-events mb-3" data-class="bg-warning"><i
                                                                class="fa fa-circle text-warning me-2"></i> Show Room 2
                                                        </div>--%>
                                                    </div>
                                                    <!-- checkbox -->
                                                    
                                                    <a href="#" data-toggle="modal" data-target="#add-new-event" class="btn mt-3 btn-info btn-block waves-effect waves-light">
                                                            <i class="ti-plus"></i> Add New Event
                                                        </a>

                                                    <asp:Button runat="server" ID="btnMyEvent" Text="My Events" CssClass="btn btn-danger mt-3 btn-block" OnClick="btnMyEvent_Click"/>

                                                    <asp:Button runat="server" ID="btnAllEvent" Text="ALL Events" CssClass="btn btn-warning mt-3 btn-block" OnClick="btnAllEvent_Click"/>
													

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-9">
                                        <div runat="server" id="divResourceName" class="alert alert-info mt-2" role="alert">
                                           
                                        </div>
                                        <div runat="server" id="divMessage" class="alert alert-success mt-2" role="alert">
                                            <strong>Success - </strong> A simple success alert
                                        </div>
                                       <div id='calendar'></div> 

                                        <div class="table-responsive">
                                            <asp:GridView runat="server" ID="gvMyEvents" Visible="false" border="0" CssClass="table table-sm  mb-0 v-middle" style="font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                <HeaderStyle CssClass="table-dark" />
                                                <RowStyle VerticalAlign="Middle" />
                                                <Columns>                                                    
                                                    
                                                    <asp:BoundField DataField="Title" HeaderText="Title" /> 
                                                    <asp:BoundField DataField="FromTime" HeaderText="From Time" />
                                                    <asp:BoundField DataField="ToTime" HeaderText="To Time" />                                                   
                                                    <asp:BoundField DataField="ResourceName" HeaderText="Location" />     
                                                    <asp:BoundField DataField="SubmitByName" HeaderText="Submit By" /> 
                                                    <asp:BoundField DataField="SubmitDate" HeaderText="Submit Date" />
                                                                         
                                                    <asp:TemplateField HeaderText="Status">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbStatus" Text='<%# Eval("Status").ToString().Equals("1") ? "Released":"Cancelled"  %>' CssClass='<%# Eval("Status").ToString().Equals("1") ? "badge badge-success":"badge badge-danger"%>'>'></asp:Label>
                                                            
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                                                                        

                                                    <asp:TemplateField HeaderText="">
                                                        <ItemTemplate>                                                            
                                                            <asp:LinkButton runat="server" ID="lbtnDelete" OnClick="lbtnDelete_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Cancel this event"><i class="text-danger far fa-edit"></i></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                     <asp:BoundField DataField="RowIndex" HeaderText="RowIndex" />     
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                            
                        </div>
                    </div>
                </div>
                
            </div>
           
    </form>
</body>
</html>

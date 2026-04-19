<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="resouce.aspx.cs" Inherits="WebApplication2.tools.resouce" %>

<!DOCTYPE html>
<html dir="ltr" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet">
    <title>Monster Template by WrapPixel</title>
    
    <!-- Favicon icon -->
    <link rel="icon" type="image/png" sizes="16x16" href="src/assets/images/favicon.png">
    <!-- Custom CSS -->
    <link href="../kpi/src/assets/libs/fullcalendar/dist/main.css" rel="stylesheet" />
	<script src="../kpi/src/assets/libs/fullcalendar/dist/main.js"></script>
  
	
    <link rel="stylesheet" href="https://bootswatch.com/4/lux/bootstrap.min.css">
	<script src="../kpi/src/assets/libs/jquery/dist/jquery.min.js"></script>
	<script src="../kpi/src/assets/libs/bootstrap/dist/js/bootstrap.min.js"></script>
	 <script src="../kpi/src/assets/extra-libs/taskboard/js/jquery-ui.min.js"></script>
<script>

  document.addEventListener('DOMContentLoaded', function() {    

    /* initialize the calendar
    -----------------------------------------------------------------*/

    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
      },
      editable: false,
	  dayMaxEvents: true,
	  initialDate: '2020-09-12',
      droppable: false, // this allows things to be dropped onto the calendar
      
	  
	  events: [
        {
          title: 'All Day Event',
          start: '2020-09-01',
        },        
        
        {
          title: 'Conference',
          start: '2020-09-11',
          end: '2020-09-13'
        },
        {
          title: 'Meeting',
          start: '2020-09-12T10:30:00',
          end: '2020-09-12T12:30:00'
        },
        {
          title: 'Lunch',
          start: '2020-09-12T12:00:00'
        },
        {
          title: 'Meeting',
          start: '2020-09-12T14:30:00'
        },
        {
          title: 'Happy Hour',
          start: '2020-09-12T17:30:00'
        },
        {
          title: 'Dinner',
          start: '2020-09-12T20:00:00'
        },
        {
          title: 'TECHNICAL: Birthday Party',
          start: '2020-09-13T07:00:00'
        },
        {
          title: 'Click for Google',
          url: 'http://google.com/',
          start: '2020-09-28'
        }
      ]
	  
    });
    calendar.render();

  });

</script>

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
    <form runat="server">
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
                                            <asp:TextBox runat="server" ID="txtTitle" CssClass="form-control form-white" placeholder="Title of event"></asp:TextBox>                                            
                                        </div>
										<div class="col-md-6">
                                            <label class="control-label">Location</label>
                                            <asp:DropDownList runat="server" ID="ddResource" CssClass="form-control form-white">
                                                <asp:ListItem Value="" Text="d"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
									</div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="control-label">Starting Date Time</label>
                                            <asp:TextBox runat="server" ID="txtStartDate" CssClass="form-control form-white" TextMode="Date"></asp:TextBox>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="control-label">Hour</label>
                                            <asp:DropDownList runat="server" ID="ddStartHour" CssClass="form-control form-white">
                                                <asp:ListItem Value="7" Text="7"></asp:ListItem>
                                                <asp:ListItem Value="8" Text="8"></asp:ListItem>
                                                <asp:ListItem Value="9" Text="9"></asp:ListItem>
                                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                <asp:ListItem Value="11" Text="11"></asp:ListItem>
                                                <asp:ListItem Value="12" Text="12"></asp:ListItem>
                                                <asp:ListItem Value="13" Text="13"></asp:ListItem>
                                                <asp:ListItem Value="14" Text="14"></asp:ListItem>
                                                <asp:ListItem Value="15" Text="15"></asp:ListItem>
                                                <asp:ListItem Value="16" Text="16"></asp:ListItem>
                                                <asp:ListItem Value="17" Text="17"></asp:ListItem>
                                                <asp:ListItem Value="18" Text="18"></asp:ListItem>
                                                <asp:ListItem Value="19" Text="19"></asp:ListItem>
                                            </asp:DropDownList>
                                            
                                        </div>
										
										<div class="col-md-3">
                                            <label class="control-label">Minute</label>
                                            <asp:DropDownList runat="server" ID="ddStartMinute" CssClass="form-control form-white">
                                                <asp:ListItem Value="0" Text="0"></asp:ListItem>
                                                <asp:ListItem Value="15" Text="15"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                <asp:ListItem Value="45" Text="45"></asp:ListItem>
                                                
                                            </asp:DropDownList>
                                        </div>
                                    </div>
									
									
									<div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="control-label">Duration (minute)</label>
                                            <asp:DropDownList runat="server" ID="ddDuration" CssClass="form-control form-white">                                                
                                                <asp:ListItem Value="15" Text="15 mins"></asp:ListItem>
                                                <asp:ListItem Value="30" Text="30 mins"></asp:ListItem>
                                                <asp:ListItem Value="45" Text="45 mins"></asp:ListItem>
                                                <asp:ListItem Value="60" Text="1 hr"></asp:ListItem>
                                                <asp:ListItem Value="75" Text="1 hr 15m"></asp:ListItem>
                                                <asp:ListItem Value="90" Text="1 hr 30m"></asp:ListItem>
                                                <asp:ListItem Value="105" Text="1 hr 45m"></asp:ListItem>
                                                <asp:ListItem Value="120" Text="2 hrs"></asp:ListItem>
                                                <asp:ListItem Value="150" Text="2.5 hrs"></asp:ListItem>
                                                <asp:ListItem Value="180" Text="3 hrs"></asp:ListItem>
                                                <asp:ListItem Value="210" Text="3.5 hrs"></asp:ListItem>
                                                <asp:ListItem Value="240" Text="4 hrs"></asp:ListItem>
                                                <asp:ListItem Value="All" Text="All day"></asp:ListItem>
                                                
                                            </asp:DropDownList>
                                        </div>
                                        
                                    </div>
									
									<div class="row mb-3">
										<div class="col-md-12">                                           
                                            <div class="form-check">
                                                        <input type="checkbox" class="form-check-input"
                                                            id="drop-remove">
                                                        <label class="form-check-label" for="drop-remove">Remove
                                                            after drop</label>
                                                    </div>
                                        </div>
									</div>
									<div class="row">
										<div class="col-md-12 mb-3">
                                            
                                            <input class="form-control" placeholder="Enter name" type="text" name="category-name" />
                                        </div>
									</div>
                                
                            </div>
                            <div class="modal-footer">
                                <asp:Button runat="server" ID="btnSave" CssClass="btn btn-danger waves-effect waves-light save-category" data-dismiss="modal" OnClick="btnSave_Click" Text="SAVE"/>
                                
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
                                                                class="fa fa-circle text-info me-2"></i> Phòng họp X1</div>
                                                        <div class="calendar-events mb-3" data-class="bg-success"><i
                                                                class="fa fa-circle text-success me-2"></i> Phòng họp X2
                                                        </div>
                                                        <div class="calendar-events mb-3" data-class="bg-danger"><i
                                                                class="fa fa-circle text-danger me-2"></i> Show Room 1
                                                        </div>
                                                        <div class="calendar-events mb-3" data-class="bg-warning"><i
                                                                class="fa fa-circle text-warning me-2"></i> Show Room 2
                                                        </div>--%>
                                                    </div>
                                                    <!-- checkbox -->
                                                    
                                                    <a href="#" data-toggle="modal" data-target="#add-new-event" class="btn mt-3 btn-info btn-block waves-effect waves-light">
                                                            <i class="ti-plus"></i> Add New Event                                                        </a>
													

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-9">
                                        <div runat="server" id="divMessage" class="alert alert-success mt-2" role="alert">
                                            <strong>Success - </strong> A simple success alert
                                        </div>
                                       <div id='calendar'></div> 
                                    </div>
                                </div>
                            
                        </div>
                    </div>
                </div>
                
            </div>
           
            <footer class="footer">
                   All right reserved by Monster Admin.
            </footer>
            
        </div>
        <!-- ============================================================== -->
        <!-- End Page wrapper  -->
        <!-- ============================================================== -->
    </div>
    
</form>
</body>

</html>

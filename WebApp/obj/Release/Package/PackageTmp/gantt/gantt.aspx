<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="gantt.aspx.cs" Inherits="WebApplication2.gantt.gantt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SQR Ganttchart</title>
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script> 

    <!-- Bootstrap -->
    <script src="codebase/dhtmlxgantt.js?v=7.0.9"></script>
		<link href="../Content/bootstrap.css" rel="stylesheet" />
    <link rel="stylesheet" href="codebase/controls_styles.css?v=7.0.9" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css?v=7.0.9" />
    <style>
        .gantt_task_cell.week_end, .gantt_task_cell.no_work_hour {
            background-color: #F5F5F5;
        }

        .gantt_task_row.gantt_selected .gantt_task_cell.week_end {
            background-color: #F8EC9C;
        }

        .gantt-fullscreen {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 30px;
            height: 30px;
            padding: 2px;
            font-size: 32px;
            background: transparent;
            cursor: pointer;
            opacity: 0.5;
            text-align: center;
            -webkit-transition: background-color 0.5s, opacity 0.5s;
            transition: background-color 0.5s, opacity 0.5s;
        }

            .gantt-fullscreen:hover {
                background: rgba(150, 150, 150, 0.5);
                opacity: 1;
            }

        .important {
			border: 2px solid red !important;
			color: red;
			background: red !important;
		}

		.important .gantt_task_progress {
			background: #ff5956;
		}

		.normal {
			border: 2px solid green;
		}

		.low {
			border: 2px solid yellow;
		}

		.custom_row {
			background: rgb(245, 248, 245);
		}

        .xanhla_task {
			border: 2px solid #268c03;
			color: #9ae381;
			background: #9ae381;
		}

		.xanhla_task .gantt_task_progress {
			background: #2ea307;
		}
		
		.xanhla_task .gantt_task_content {
			color: #ffffff;
		}
		
		.vang_task {
			border: 2px solid #dbc902;
			color: #f7f68d;
			background: #f7f68d;
		}

		.vang_task .gantt_task_progress {
			background: #f7f425;
		}
		.vang_task .gantt_task_content {
			color: #333301;
		}
		
		.cam_task {
			border: 2px solid #e8b015;
			color: #f2b60f;
			background: #f2b60f;
		}

		.cam_task .gantt_task_progress {
			background: #f2cb3f;
		}
		
		.do_task {
			border: 2px solid #e01004;
			color: #fa6a61;
			background: #fa6a61;
		}

		.do_task .gantt_task_progress {
			background: #e80e02;=-
		}
		.do_task .gantt_task_content {
			color: #ffffff;
		}
    </style>  
    
    <link runat="server" id="skin" rel="stylesheet" href="codebase/dhtmlxgantt_skyblue.css?v=7.0.9" />
    <script>
        function changeSkin(name) {
            $("#skin").attr("href", "codebase/dhtmlxgantt_" + name + ".css?v=7.0.9");

        }
	</script>
</head>
<body>
    <form id="form1" runat="server">
       <!-- Bootstrap -->
    

    <%--<nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand active" href="gantt.aspx">SQR Gantt</a>
            </div>
            <ul class="nav navbar-nav">
                <li><a href="holiday.aspx">Holiday</a></li>
                <li><a href="unconfirmedPI.aspx">Unconfirmed PI</a></li>
                <li><a href="plannedcapacity.aspx">Planned Capacity</a></li>
                <li><a href="picapacity.aspx">PI Capacity</a></li>
                <li><a href="scenario.aspx">Scenario</a></li>
                <li><a href="simulationdata.aspx">Simulation Data</a></li>
            </ul>
        </div>
    </nav>--%>
                        
            <%--<h3>Simulation Data</h3>--%>
            <%--<hr class="widget-separator" runat="server" id="Hr1" visible="true" />--%>
    <div class="table-responsive">
                
                <div id="gantt_here" style='width: 100%; height: calc(100vh - 52px);'></div>

                <script src="codebase/<%: ddScenario.SelectedValue %>.js"></script>
            </div>        
    <div class="relative" style="margin-top: 6px">
        <asp:DropDownList runat="server" ID="ddScenario" CssClass="form-control" Style="float: right; margin-right: 10px; width: 200px; height: 36px;" AutoPostBack="true" OnSelectedIndexChanged="ddScenario_SelectedIndexChanged">
            <asp:ListItem Value="0" Text="- Scenario Code"></asp:ListItem>
        </asp:DropDownList>
<a href="simulationdata.aspx"><button class="btn btn-primary" type="button" style="float: right; margin-right: 10px;" onlick="location.href='capacity.apsx';">GANTT SETUP
    </button></a>
        <div class="dropdown" style="float: right; margin-right: 10px;">
            <button class="btn btn-danger dropdown-toggle" type="button" data-toggle="dropdown">
                SKIN
                             <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li>
                    <asp:LinkButton ID="terrace" runat="server" Text="Terrace" OnClick="skin_Click"></asp:LinkButton></li>
                <li>
                    <asp:LinkButton ID="skyblue" runat="server" Text="Skyblue" OnClick="skin_Click"></asp:LinkButton></li>
                <li>
                    <asp:LinkButton ID="meadow" runat="server" Text="Meadow" OnClick="skin_Click"></asp:LinkButton></li>
                <li>
                    <asp:LinkButton ID="broadway" runat="server" Text="Broadway" OnClick="skin_Click"></asp:LinkButton></li>
                <li>
                    <asp:LinkButton ID="material" runat="server" Text="Material" OnClick="skin_Click"></asp:LinkButton></li>
                <li>
                    <asp:LinkButton ID="contrast_white" runat="server" Text="High contrast light" OnClick="skin_Click"></asp:LinkButton></li>
                <li>
                    <asp:LinkButton ID="contrast_black" runat="server" Text="High contrast dark" OnClick="skin_Click"></asp:LinkButton></li>

            </ul>
        </div>
        
        <div style="float: left">
            <asp:Label runat="server" ID="lbLastUpdateOn" Text="" style="margin-left: 10px;"></asp:Label>
            </div>

    </div>
             <div class="clearfix"></div>
            <%--<hr class="widget-separator" runat="server" id="Hr2" visible="true" style="margin-bottom: 0px; margin-top: 1px"/> --%>

            
    </form>
</body>
</html>

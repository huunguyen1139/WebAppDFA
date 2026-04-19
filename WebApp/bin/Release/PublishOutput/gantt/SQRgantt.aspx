<%@ Page Title="Gantt" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SQRgantt.aspx.cs" Inherits="WebApplication2.gantt.SQRgantt" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script> 

    <!-- Bootstrap -->
    <script src="codebase/dhtmlxgantt.js?v=7.0.9"></script>
		
    <link rel="stylesheet" href="codebase/controls_styles.css?v=7.0.9">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css?v=7.0.9">
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
    </style>  
    
    <link runat="server" id="skin" rel="stylesheet" href="codebase/dhtmlxgantt_skyblue.css?v=7.0.9" />
    <script>
        function changeSkin(name) {
            $("#skin").attr("href", "codebase/dhtmlxgantt_" + name + ".css?v=7.0.9");

        }
	</script>

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand active" href="SQRGantt.aspx">SQR Gantt</a>
            </div>
            <ul class="nav navbar-nav">
                <li><a href="holiday.aspx">Holiday</a></li>
                <li><a href="plannedcapacity.aspx">Planned Capacity</a></li>
                <li><a href="scenario.aspx">Scenario</a></li>
                <li><a href="simulationdata.aspx">Simulation Data</a></li>
            </ul>
        </div>
    </nav>
                        
            <%--<h3>Simulation Data</h3>--%>
            <%--<hr class="widget-separator" runat="server" id="Hr1" visible="true" />--%>
            
    <div class="relative">
        <div class="dropdown" style="float: right">
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
        <asp:DropDownList runat="server" ID="ddScenario" CssClass="form-control" Style="float: right; margin-right: 10px; width: 200px; height: 36px;" AutoPostBack="true" OnSelectedIndexChanged="ddScenario_SelectedIndexChanged">
            <asp:ListItem Value="0" Text="- Scenario Code"></asp:ListItem>
        </asp:DropDownList>
        <div style="float: left">
            <asp:Label runat="server" ID="lbLastUpdateOn" Text=""></asp:Label>
            </div>

    </div>
             <div class="clearfix"></div>
            <hr class="widget-separator" runat="server" id="Hr2" visible="true" /> 

            <div class="table-responsive">
                
                <div id="gantt_here" style='width: 100%; height: calc(100vh - 52px);'></div>

                <script src="codebase/<%: ddScenario.SelectedValue %>.js"></script>
            </div>

                                     
                              
</asp:Content>

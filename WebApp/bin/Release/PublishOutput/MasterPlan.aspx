<%@ Page Title="Master Plan" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MasterPlan.aspx.cs" Inherits="WebApplication2.MasterPlan" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        #txtPIName {
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
            input = document.getElementById("txtPIName");
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
           
            <div style="padding-top: 20px">
                <div class="col_3">
        	<div class="col-md-3 widget widget1">        		
                <div class="r3_counter_box">
                    <div class="task-info"> 
                        <span runat="server" id="txtRemainTotal01" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span><asp:Label runat="server" ID="lbUnpackingPercen01" title="Total percent of unpacking amount" CssClass="percentage" Text="$"></asp:Label>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div class="bar light-blue" runat="server" id="divBarPercent01" style="width: 60%;"></div>
                    </div>

                    <hr style="margin: 5px;">
                    <span runat="server" id="spanShippedAmount01" class="pull-right" title="Total of shipped amount">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                    <span runat="server" id="spanOutputAmount01" title="Total of production output amount" class="pull-left"></span>
                    <div class="clearfix"></div>
                    <div runat="server" id="divMonthPeriod01" class="bg-system pv20 text-white fw600 text-center" style="margin-top: 4px;">04-2020</div>
                </div>
        	</div>
        	<div class="col-md-3 widget widget1">
        		<div class="r3_counter_box">
                    <div class="task-info">
                        <span runat="server" id="txtRemainTotal02" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span><asp:Label runat="server" ID="lbUnpackingPercen02" title="Total percent of unpacking amount" CssClass="percentage" Text="$"></asp:Label>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div class="bar red" runat="server" id="divBarPercent02" style="width: 60%;"></div>
                    </div>

                    <hr style="margin: 5px;">
                    <span runat="server" id="spanShippedAmount02" title="Total of shipped amount" class="pull-right">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                    <span runat="server" id="spanOutputAmount02" title="Total of production output amount" class="pull-left">$123654<img src="http://sqrsystem.com:8080/QueryTool/images/arrowgreen.png"></span>
                    <div class="clearfix"></div>
                    <div runat="server" id="divMonthPeriod02" class="bg-danger dark pv20 text-white fw600 text-center" style="margin-top: 4px;">05-2020</div>
                </div>
        	</div>
        	<div class="col-md-3 widget widget1">
        		<div class="r3_counter_box">
                    <div class="task-info">
                        <span runat="server" id="txtRemainTotal03" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span><asp:Label runat="server" ID="lbUnpackingPercen03" title="Total percent of unpacking amount" CssClass="percentage" Text="$"></asp:Label>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div class="bar blue" runat="server" id="divBarPercent03" style="width: 60%;" title="ffff"></div>
                    </div>

                    <hr style="margin: 5px;">
                    <span runat="server" id="spanShippedAmount03" title="Total of shipped amount" class="pull-right">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                    <span runat="server" id="spanOutputAmount03" title="Total of production output amount" class="pull-left">$123654<img src="http://sqrsystem.com:8080/QueryTool/images/arrowgreen.png"></span>
                    <div class="clearfix"></div>
                    <div runat="server" id="divMonthPeriod03" class="bg-primary dark pv20 text-white fw600 text-center" style="margin-top: 4px;">06-2020</div>
                </div>
        	</div>
        	<div class="col-md-3 widget widget1">
        		<div class="r3_counter_box">
                    <div class="task-info">
                        <span runat="server" id="txtRemainTotal04" class="task-desc" title="Remain of packing / total packing value" style="">$427k / $733k</span><asp:Label runat="server" ID="lbUnpackingPercen04" title="Total percent of unpacking amount" CssClass="percentage" Text="$"></asp:Label>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div class="bar yellow" runat="server" id="divBarPercent04" style="width: 60%;" title="ffff"></div>
                    </div>

                    <hr style="margin: 5px;">
                    <span runat="server" id="spanShippedAmount04" title="Total of shipped amount" class="pull-right">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                    <span runat="server" id="spanOutputAmount04" title="Total of production output amount" class="pull-left">$123654<img src="http://sqrsystem.com:8080/QueryTool/images/arrowgreen.png"></span>
                    <div class="clearfix"></div>
                    <div runat="server" id="divMonthPeriod04" class="bg-alert pv20 text-white fw600 text-center" style="margin-top: 4px;">07-2020</div>
                </div>
        	 </div>
             <div class="col-md-3 widget widget1">
        		<div class="r3_counter_box">
                    <div class="task-info">
                        <span runat="server" id="txtRemainTotal05" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span><asp:Label runat="server" ID="lbUnpackingPercen05" CssClass="percentage" title="Total percent of unpacking amount" Text="$"></asp:Label>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div class="bar green" runat="server" id="divBarPercent05" style="width: 60%;" title="ffff"></div>
                    </div>

                    <hr style="margin: 5px;">
                    <span runat="server" id="spanShippedAmount05" title="Total of shipped amount" class="pull-right">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                    <span runat="server" id="spanOutputAmount05" title="Total of production output amount" class="pull-left">$123654<img src="http://sqrsystem.com:8080/QueryTool/images/arrowgreen.png"></span>
                    <div class="clearfix"></div>
                    <div runat="server" id="divMonthPeriod05" class="bg-info dark pv20 text-white fw600 text-center" style="margin-top: 4px;">08-2020</div>
                </div>
        	 </div>
        	<div class="col-md-3 widget">
        		<div class="r3_counter_box">
                    <div class="task-info">
                        <span runat="server" id="txtRemainTotal06" class="task-desc" title="Remain of packing / total of packing value" style="">$427k / $733k</span><asp:Label runat="server" ID="lbUnpackingPercen06" CssClass="percentage" title="Total percent of unpacking amount" Text="$"></asp:Label>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div class="bar orange" runat="server" id="divBarPercent06" style="width: 60%;" title="ffff"></div>
                    </div>

                    <hr style="margin: 5px;">
                    <span runat="server" id="spanShippedAmount06" title="Total of shipped amount" class="pull-right">$753456<img src="http://sqrsystem.com:8080/QueryTool/images/arrowdown.png"></span>
                    <span runat="server" id="spanOutputAmount06" title="Total of production output amount" class="pull-left">$123654<img src="http://sqrsystem.com:8080/QueryTool/images/arrowgreen.png"></span>
                    <div class="clearfix"></div>
                    <div runat="server" id="divMonthPeriod06" class="bg-warning dark pv20 text-white fw600 text-center" style="margin-top: 4px;">09-2020</div>
                </div>
        	 </div>
        	<div class="clearfix"> </div>
		</div>
                <br />                          
                      
            </div>
           
            <div class="">
                <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75);background-color: white;padding: 10px;">
                    <header class="widget-header">
                        <h4 id="txtDesciptionHeader" style="padding-bottom: 12px; margin-bottom: 0px;margin-top: 0px; padding-top: 4px;" runat="server" class="widget-title"><a href="ReportViewer.aspx?type=masterplan" target="_blank">Online Master Plan</a> <a href="MasterPlan?showPIpc=true"> - Show PI Status </a> <img src="images/livegreen.gif" width="60" height="25"> 
                            <button style="float:right;padding: 4px 12px;" class="btn btn-info" onclick="document.location = 'MasterPlan?showHistory=true'">Shipped PIs</button>
                            <button style="float:right;padding: 4px 12px; margin-right:4px" class="btn btn-danger" onclick="window.open('http://sqrsystem.com:8080/QueryTool/OrderBookSearch', '_blank')">Order Book</button>

                        </h4>
                    </header>
                                
                    <input type="text" id="txtPIName" onkeyup="searchPI()" placeholder="Search for PI names..">
                    <div class="table-master">
                        
                        <asp:Table runat="server" ID="tbMasterPlan" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
                    </div>
                </div>

                <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div class="table-responsive">
                    <asp:GridView runat="server" ID ="gvDetailOutput" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Production Output Detail" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                        <HeaderStyle BackColor="Aqua" BorderColor="#E3E6E3" />                       
                    </asp:GridView>
                </div>
            </div>
              
        </ContentTemplate>
        
    </asp:UpdatePanel>
       <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="images/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

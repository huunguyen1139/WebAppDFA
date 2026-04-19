<%@ Page Title="Production Live Target" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductionTarget.aspx.cs" Inherits="WebApplication2.ProductionTarget" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    
    <%--<script src="chart-lib/jquery.min.js"></script>--%>
    <%--<script type="text/javascript" src="chart-lib/jquery-1.8.3.min.js"></script>--%>
    
    <link rel="stylesheet" type="text/css" href="chart-lib/c3.min.css">

    <!-- slimscrollbar scrollbar JavaScript -->
    <script src="chart-lib/perfect-scrollbar.jquery.min.js"></script>
    <script src="chart-lib/jquery.sparkline.min.js"></script>
    
    <!--Custom JavaScript -->
    <script src="chart-lib/feather.min.js"></script>
    <script src="chart-lib/custom.min.js"></script>
    <!-- This Page Plugins -->
    <script src="chart-lib/d3.min.js"></script>
    <script src="chart-lib/c3.min1.js"></script>

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
    <script type="text/javascript">
        function RemovePreviousChart() {
            location.reload();
       }
    </script>
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div style="padding-top: 20px" visible="false">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:140px">
                    <h2>&nbsp;<span style="color: #FF0000">R</span><span style="color: #FFFF00">e</span><span style="color: #33CC33">a</span><span style="color: #0000FF">l</span><span style="color: #FF0066">t</span><span style="color: #0066FF">i</span><span style="color: #FF9900">m</span><span style="color: #339933">e</span> <span style="color: #6600FF;">TARGET</span></h2>
                    
                    <div style="width: 33%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control" OnTextChanged="txtFromDate_TextChanged" AutoPostBack="True"></asp:TextBox>
                    </div>
                    <div style="width: 33%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtToDate" TextMode="Date" Width="95%" CssClass="form-control" OnTextChanged="txtToDate_TextChanged" AutoPostBack="True"></asp:TextBox>
                    </div>  
                    <div style="width: 34%; float: right">
                        <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text ="Load" OnClick="btnLoad_Click" />
                    </div>  
                    <asp:CheckBox runat="server" CssClass="checkbox-inline" Style="margin-bottom: 10px; color: #0000FF;" ID ="cbAutoRefresh" Text="Auto refresh data every 10 seconds" OnCheckedChanged="cbAutoRefresh_CheckedChanged" AutoPostBack="True"/>
                </div>
                <br />                          
                      
            </div>
           
            <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75); background-color: white; padding: 10px; overflow: auto; margin-bottom:20px">
                <div style="background-color: #FAFAFA; border-bottom: 1px solid rgba(0, 0, 0, 0.05); margin-bottom: 8px;">
                    <header class="widget-header">
                        <h4 id="MainContent_txtDesciptionHeader" class="widget-title">Company Output Target</h4>
                    </header>
                </div>
                <div style="width: 25%; float: left;margin-top: 10px; margin-bottom:12px">
                    <asp:DropDownList runat="server" ID="ddYear" CssClass ="form-control" AutoPostBack="true" Width="95%" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
                                <asp:ListItem>2020</asp:ListItem>
                                <asp:ListItem>2021</asp:ListItem>
                                <asp:ListItem>2022</asp:ListItem>                                
                            </asp:DropDownList>
                </div>
                <div style="width: 25%; float: left;margin-top: 10px;margin-bottom:12px">
                    <asp:DropDownList runat="server" ID="ddMonth" CssClass ="form-control" AutoPostBack="true" Width="95%" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                            </asp:DropDownList>
                </div>
                <div style="width: 50%; float: right;padding-left:1%;padding-right:1%">

                    <div class="task-info">
                        <span runat="server" id="txtTargetData" class="task-desc">Database update</span><span runat="server" id="txtTargetPercent" class="percentage">40%</span>
                        <div class="clearfix"></div>
                    </div>
                    <div class="progress progress-striped active">
                        <div runat="server" id="divTargetBar" class="bar orange" style="width: 40%;"></div>
                    </div>

                </div>
            </div>

            <div class="">
                <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75);background-color: white;">
                    <header class="widget-header"  style="padding-top: 10px; padding-left: 10px;">
                        <h4 id="txtDesciptionHeader" runat="server" class="widget-title">Output target from</h4>
                    </header>
                    <hr class="widget-separator">                  

                    <div class="table-responsive" runat="server" id="divTable">
                        <asp:Table runat="server" ID="tbTarget" CssClass="table table-hover table-striped"></asp:Table>
                    </div>
                    <%--<div class="card-body">
                                <div id="column-oriented"></div>
                    </div>
                    <input type="button" value="fsfd"  onclick="RemovePreviousChart();"/>--%>
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
            <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
   
    
</asp:Content>

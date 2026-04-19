<%@ Page Title="Production Status" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductionStatus.aspx.cs" Inherits="WebApplication2.ProductionStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    <script src="Scripts/jquery-1.10.2.js" type="text/javascript"></script>
        <script src="Scripts/jquery-ui.js" type="text/javascript"></script>        
       <link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.2/themes/blitzer/jquery-ui.css"
        rel="Stylesheet" type="text/css" />
    <script type="text/javascript">
        function SearchPI() {
            $("#<%=txtPI.ClientID%>").autocomplete({
                source: 'GetPIList.ashx',
                select: function (event, ui) {
                    if (ui.item.label == '') {
                        return false;
                    }
                    $('#<%=ddPI.ClientID%>').val(ui.item.label);
                    __doPostBack("<%# ddPI.ClientID %>", "");
                }
            });
        };

        $(document).ready(function () { SearchPI(); });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            SearchPI();
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
   
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div style="padding-top: 20px" visible="false">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:140px">
                    <h2><a href="ReportViewer?type=prodorder&PI=<% if (ViewState["PI"]!=null) { %> <%: ViewState["PI"].ToString() %> <%} %>" target="_blank">Production Status</a> </h2>
                    <div style="width: 30%; float: left">
                        <asp:HiddenField ID="hfPI" runat="server"/>
                        <asp:TextBox runat ="server" ID="txtPI"  CssClass="form-control" Width="95%" Style="margin-bottom: 10px" Placeholder="Search PI"></asp:TextBox>      
                    </div>
                    <div style="width: 40%; float: left">
                        <asp:DropDownList ID="ddPI" runat="server" CssClass="form-control" Width="95%" Style="margin-bottom: 10px" AutoPostBack="True" OnSelectedIndexChanged="ddPI_SelectedIndexChanged">
                            <asp:ListItem Value="0">- Select PI</asp:ListItem>
                        </asp:DropDownList>
                    </div>                      
                    <div style="width: 30%; float: right">
                        <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text ="Load" OnClick="btnLoad_Click" />
                    </div>                      
                </div>
                <br />                      
            </div>

            <div class="form-group">
                <label for="checkbox">Show following info : </label>
                <div class="checkbox-inline"><asp:CheckBox runat="server" ID="cbDrawing" Text="Drawing" OnCheckedChanged="cbDrawing_CheckedChanged" AutoPostBack="True" /></div>
                <div class="checkbox-inline"><asp:CheckBox runat="server" ID="cbProductionBOM" Text="Production BOM" OnCheckedChanged="cbProductionBOM_CheckedChanged" AutoPostBack="True" /></div>
                <div class="checkbox-inline"><asp:CheckBox runat="server" ID="cbTimberFinish" Text="Timber Finish" OnCheckedChanged="cbTimberFinish_CheckedChanged" AutoPostBack="True" /></div>
                <div class="checkbox-inline"><asp:CheckBox runat="server" ID="cbMetalFinish" Text="Metal Finish" OnCheckedChanged="cbMetalFinish_CheckedChanged" AutoPostBack="True" /></div>
                <div class="checkbox-inline"><asp:CheckBox runat="server" ID="cbProgress" Text="Progress" OnCheckedChanged="cbProgress_CheckedChanged" AutoPostBack="True" Checked="True" /></div>
                <div class="checkbox-inline"><asp:CheckBox runat="server" ID="cbImage" Text="Product Image" Checked="true" OnCheckedChanged="cbImage_CheckedChanged" AutoPostBack="True" /></div>
            </div>
            <div class="">             

                <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div id="huudiv" runat="server" class="table-master">
                    <asp:GridView runat="server" ID ="gvDetailOutput" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Production Output Detail" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" OnRowDataBound="gvDetailOutput_RowDataBound">
                        <HeaderStyle BackColor="Aqua" BorderColor="#E3E6E3" />                       
                    </asp:GridView>
                </div>
                <hr class="widget-separator" runat="server" id="Hr1" visible="true" />
                <div class="table">
                    <asp:GridView runat="server" ID ="gvPINote" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="PI Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                        <HeaderStyle BackColor="#ff9900" BorderColor="#E3E6E3" />                       
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

<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication2._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
     <!-- Autocomplete textbox -->    
      <script src="Scripts/jquery-1.10.2.js" type="text/javascript"></script>
        <script src="Scripts/jquery-ui.js" type="text/javascript"></script>        
       <link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.2/themes/blitzer/jquery-ui.css"
        rel="Stylesheet" type="text/css" />
     <script type="text/javascript">
         function disableBtn(btnID, newText) {

             var btn = document.getElementById(btnID);
             setTimeout("setImage('" + btnID + "')", 1);
             btn.disabled = true;
             btn.value = newText;            
         }

         

         function setImage(btnID) {
             var btn = document.getElementById(btnID);
             btn.style.background = 'url(images/loading.gif)';
             btn.style.backgroundColor = 'yellow';
             btn.style.backgroundRepeat = 'no-repeat';
             btn.style.backgroundPosition = 'center';
             btn.style.color = 'blue';
         }
     </script>
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
    <!-- Autocomplete textbox -->

    <!-- Bootstrap -->
    <%--script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>--%>
    <script type="text/javascript" src='chart-lib/bootstrap.min.js'></script>
    <%--<script src="Scripts/jquery-ui.js"></script>--%>
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
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px">
                    <h1>POR System</h1>
                   <%-- <p class="lead">Production Output Register System</p>--%>

                    <div style="width: 30%; float: left">
                        <asp:HiddenField ID="hfPI" runat="server"/>
                        <asp:TextBox runat ="server" ID="txtPI"  CssClass="form-control" Width="95%" Style="margin-bottom: 10px" Placeholder="Search PI"></asp:TextBox>      
                    </div>
                    <div style="width: 36%; float: left">
                        <asp:DropDownList ID="ddPI" runat="server" CssClass="form-control" Width="95%" Style="margin-bottom: 10px" OnSelectedIndexChanged="ddPI_SelectedIndexChanged" AutoPostBack="True">
                            <asp:ListItem Value="0">- Select PI</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    

                    <div style="width: 34%; float: right">
                        <asp:TextBox runat="server" ID="txtInputDate" TextMode="Date" Width="100%" CssClass="form-control"></asp:TextBox>
                    </div>

                    <asp:DropDownList ID="ddItemCode" runat="server" CssClass="form-control" Width="100%" Style="margin-bottom: 10px" OnSelectedIndexChanged="ddItemCode_SelectedIndexChanged" AutoPostBack="True">
                        <asp:ListItem Value="0">- Select Item</asp:ListItem>
                    </asp:DropDownList>

                    <asp:Label runat="server" ID="lbItemCode" Text="Item Code: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                    <asp:Label runat="server" ID="lbQuantity" Text="Quantity: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                    <asp:Label runat="server" ID="lbTimberFinish" Text="Timber Finish: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                    <asp:Label runat="server" ID="lbMetalFinish" Text="Metal Finish: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                    
                </div>
                <br />
                <%--Wood Selection--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtWO" Width="95%" Text="WO" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtWOQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddWO" runat="server" CssClass="form-control" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--Rough Mill--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtRM" Width="95%" Text="RM" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtRMQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddRM" runat="server" CssClass="form-control" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--Fine Mill--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtFM" Width="95%" Text="FM" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtFMQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddFM" runat="server" CssClass="form-control" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--Assembly--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtAS" Width="95%" Text="AS" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtASQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddAS" runat="server" CssClass="form-control" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--Sanding--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtSA" Width="95%" Text="SA" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtSAQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddSA" runat="server" CssClass="form-control" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--Finishing--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtFIN" Width="95%" Text="FIN" Enabled="False" BackColor="aqua"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtFINQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddFIN" runat="server" CssClass="form-control" Width="100%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--IRONNING--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtIRON" Width="95%" Text="IRON" Enabled="False" BackColor="aqua"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtIRONQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddIRON" runat="server" CssClass="form-control" Width="100%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                    </div>
                </div>
                                
                <%--UPH--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtUPH" Width="95%" Text="UPH" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtUPHQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddUPH" runat="server" CssClass="form-control" Width="100%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--Fitting--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtFIT" Width="95%" Text="FIT" Enabled="False" BackColor="sandybrown"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtFITQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddFIT" runat="server" CssClass="form-control" Width="100%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                    </div>
                </div>

                <%--PACKING--%>
                <div class="form-inline" style="padding: 0px 20px 10px 20px; height: 40px">
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" CssClass="form-control" ID="txtPAC" Width="95%" Text="PAC" Enabled="False" BackColor="sandybrown"></asp:TextBox>
                    </div>
                    <div style="width: 25%; float: left">
                        <asp:TextBox runat="server" ID="txtPACQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:DropDownList ID="ddPAC" runat="server" CssClass="form-control" Width="100%" AutoPostBack="True" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" >
                        </asp:DropDownList>
                    </div>
                </div>
                 <br />
                <p id="lbEstimateTotalValue" runat="server" style="color: crimson; padding: 10px 10px; background-color:blanchedalmond; width:100%"></p>
                   
                <%--<asp:Label runat="server" ID ="lbEstimateTotalValue" ForeColor="Crimson" Style="color: crimson; padding: 10px 10px; background-color:blanchedalmond; width:100%"></asp:Label>--%>
                <asp:HiddenField runat="server" ID ="hfSalePrice" Value="0" />
                
                <asp:Button runat="server" ID="bt1" Text="Submit" CssClass="btn btn-success" OnClick="bt1_Click" CausesValidation="False" OnClientClick="disableBtn(this.id, '....      ....')" UseSubmitBehavior="false"/>           
                <hr class="widget-separator" runat="server" id="separator10"/>

                <div>
                    <asp:LinkButton runat="server" ID ="linkAddNewNote" Text ="Click here to add new note" OnClick="linkAddNewNote_Click" Visible="False"></asp:LinkButton>
                    <asp:TextBox runat="server" ID="txtNewNote" CssClass ="form-control" style="Width:100%; margin-bottom: 10px" PlaceHolder="Add new note here" Visible="False"></asp:TextBox>
                    <asp:Button runat ="server" ID ="btnAddNewNote" CssClass ="btn btn-warning" CausesValidation="false" Text="Add new note" Visible="False" OnClick="btnAddNewNote_Click" />
                    <br />
                    <hr class="widget-separator" runat="server" id="Hr1" visible="false"/>
                    <asp:GridView runat="server" ID ="gvNoteList" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
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

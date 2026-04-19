<%@ Page Title="Parameters Setup" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SetupParameter.aspx.cs" Inherits="WebApplication2.Account.SetupParameter" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <!-- Bootstra-->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    
    <link href="Content/font-awesome.css" rel="stylesheet" />
    <!-- Bootstrap -->
    
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
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75); background-color: white; padding: 10px; overflow: auto; margin-top: 18px;">
                <header class="widget-header">
                    <h4 id="txtDesciptionHeader" runat="server" class="widget-title">Monthly Target Setup</h4>
                </header>
                <hr class="widget-separator" runat="server" id="Hr1" visible="true" />

                <div class="form-group" style="overflow: auto">
                    <label class="col-md-2 control-label">Year</label>
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <i class="fa fa-key"></i>
                            </span>
                            <asp:DropDownList runat="server" ID="ddYear" CssClass="form-control1" AutoPostBack="true" OnSelectedIndexChanged="ddYear_SelectedIndexChanged" >
                                <asp:ListItem>2020</asp:ListItem>
                                <asp:ListItem>2021</asp:ListItem>
                                <asp:ListItem>2022</asp:ListItem>
                                <asp:ListItem>2023</asp:ListItem>
                            </asp:DropDownList>
                      
                        </div>
                    </div>
                </div>

                <div class="form-group" style="overflow: auto">
                    <label class="col-md-2 control-label">Month</label>
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <i class="fa fa-key"></i>
                            </span>
                            <asp:DropDownList runat="server" ID="ddMonth" CssClass ="form-control1" AutoPostBack="true" OnSelectedIndexChanged="ddYear_SelectedIndexChanged">
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
                            <%--<input runat="server" type="password" class="form-control1" id="txtNewPassword" placeholder="New Password">--%>
                        </div>
                    </div>
                </div>

                <div class="form-group" style="overflow: auto">
                    <label class="col-md-2 control-label">Target</label>
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <i class="fa fa-key"></i>
                            </span>
                            <asp:TextBox runat="server" TextMode="Number" ID="txtTarget" CssClass="form-control1"></asp:TextBox>
                        </div>
                    </div>
                </div>
                               
                <asp:Label runat="server" Style="margin-left: 17.85%" ID="lbValidation" Text="" Visible="false" ForeColor="#00cc00" />

                <hr class="widget-separator" runat="server" id="separator10" visible="true" />
                <div class="form-group" style="overflow: auto">
                    <label class="col-md-2 control-label"></label>
                    <div class="col-md-8">
                        <asp:Button runat="server" ID="btnChange" Style="float: left" CssClass="btn btn-warning" Text="Change" OnClick="btnChange_Click" />

                    </div>
                </div>

                <div class="table-responsive">
                    <asp:Table runat="server" ID="tbMasterPlan" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
                </div>
            </div>

            <div class="bs-example widget-shadow" data-example-id="bordered-table">
            <h4>Setup Parameters: <asp:Label runat="server" ID="permission" Text="" ForeColor="Red"></asp:Label></h4>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Department</th>
                        <th>Output Target</th>
                        <th>MH Unit Cost</th>
                       
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">1</th>
                        <td>WO</td>
                        <td><asp:TextBox runat="server" ID="otWO" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhWO" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th scope="row">2</th>
                        <td>RM</td>
                        <td><asp:TextBox runat="server" ID="otRM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhRM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">3</th>
                        <td>FM</td>
                        <td><asp:TextBox runat="server" ID="otFM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhFM" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">4</th>
                        <td>AS</td>
                        <td><asp:TextBox runat="server" ID="otAS" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhAS" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">5</th>
                        <td>SA</td>
                        <td><asp:TextBox runat="server" ID="otSA" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhSA" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">6</th>
                        <td>FIN</td>
                        <td><asp:TextBox runat="server" ID="otFIN" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhFIN" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">7</th>
                        <td>IRON</td>
                        <td><asp:TextBox runat="server" ID="otIRON" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhIRON" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">8</th>
                        <td>UPH</td>
                        <td><asp:TextBox runat="server" ID="otUPH" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhUPH" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">9</th>
                        <td>FIT</td>
                        <td><asp:TextBox runat="server" ID="otFIT" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhFIT" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                    <tr>
                       <th scope="row">10</th>
                        <td>PAC</td>
                        <td><asp:TextBox runat="server" ID="otPAC" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                        <td><asp:TextBox runat="server" ID="mhPAC" TextMode="Number" CssClass="form-control" Width="100%"></asp:TextBox></td>
                    </tr>
                   
                </tbody>
            </table>
        </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

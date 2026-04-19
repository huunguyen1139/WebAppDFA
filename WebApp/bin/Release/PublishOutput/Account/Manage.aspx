<%@ Page Title="Manage Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="WebApplication2.Account.Manage" %>



<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    <link href="../Content/font-awesome.css" rel="stylesheet" />
     <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
    <div class="work-progres" style="box-shadow: 0px 0px 5px -2px rgba(0,0,0,0.75); background-color: white; padding: 10px; overflow: auto; margin-top: 18px;">
        <header class="widget-header">
            <h4 id="txtDesciptionHeader" runat="server" class="widget-title">Change account password</h4>
        </header>
         <hr class="widget-separator" runat="server" id="Hr1" visible="true" />

        <div class="form-group" style="overflow:auto">
            <label class="col-md-2 control-label">Old Password</label>
            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-key"></i>
                    </span>
                    <asp:TextBox runat="server" TextMode="Password" CssClass="form-control1" ID="txtOldPassword" placeholder="Old Password"></asp:TextBox>
                    <%--<input runat="server" type="password" class="form-control1" id="txtOldPassword" placeholder="Old Password">--%>
                </div>
            </div>
        </div>

        <div class="form-group" style="overflow:auto">
            <label class="col-md-2 control-label">New Password</label>
            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-key"></i>
                    </span>
                    <input runat="server" type="password" class="form-control1" id="txtNewPassword" placeholder="New Password">
                </div>
            </div>
        </div>

        <div class="form-group" style="overflow:auto">
            <label class="col-md-2 control-label">Confirm Password</label>
            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-key"></i>
                    </span>
                    <input runat="server" type="password" class="form-control1" id="txtConfirmPassword" placeholder="Confirm Password">
                </div>
            </div>
        </div>

        <%--<div class="form-group" style="overflow: auto">
            <label class="col-md-2 control-label"></label>
            <div class="col-md-8">
                <asp:Label runat="server" ID="lbPasswordValidation" Text="dd" Visible="false" CssClass="label label-success"></asp:Label>
            </div>
        </div>--%>
        <asp:Label runat="server" style="margin-left: 17.85%" ID="lbPasswordValidation" Text="lbPasswordValidation lbPasswordValidation" Visible="false" ForeColor="#00cc00" />

        <hr class="widget-separator" runat="server" id="separator10" visible="true" />
        <div class="form-group" style="overflow: auto">
            <label class="col-md-2 control-label"></label>
            <div class="col-md-8">
                <asp:Button runat="server" ID="btnChangePassword" style="float:left" CssClass="btn btn-warning" Text ="Change" OnClick="btnChangePassword_Click" />
                
            </div>
        </div>

        <div class="table-responsive">
            <asp:Table runat="server" ID="tbMasterPlan" CssClass="tablerowsmall table-hover table-striped"></asp:Table>
        </div>
    </div>
    </ContentTemplate>
         </asp:UpdatePanel>
</asp:Content>

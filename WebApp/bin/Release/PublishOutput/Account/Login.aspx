<%@ Page Title="Log in" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication2.Account.Login" Async="true" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<%--<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">--%>
 <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />   
    <link href="../Content/style.css" rel="stylesheet" />
    <link href="../Content/font-awesome.css" rel="stylesheet" />
<title>Login - POR System</title>
<form runat="server">
    <div class="main-page login-page ">
				<h2 class="title1">Login</h2>
				<div class="widget-shadow">
					<div class="login-body">						
							<input runat="server" id="txtUserName" type="text" class="user" placeholder="Enter Your User" required="">
							<input runat="server" id="txtPassword" type="password" name="password" class="lock" placeholder="Password" required="">
							<div class="forgot-grid">
								<label  class="checkbox"><input runat="server" id="cbRememberMe" type="checkbox" name="checkbox" checked="checked"><i></i>Remember me</label>
								<div class="forgot">
									<a href="#">forgot password?</a>
								</div>
								<div class="clearfix"> </div>
							</div>
                        <asp:Button runat="server" id="btnSignIn" Text="Sign In" OnClick="LogIn" />
							<%--<input runat="server" id="btnSignIn" type="submit" name="Sign In" value="Sign In">--%>
							<div class="registration">
								Don't have an account ?
								<a class="" href="signup.html">
									Create an account
								</a>
							</div>						
					</div>
				</div>
				
			</div></form>
<%--</asp:Content>--%>

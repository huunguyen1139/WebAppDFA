<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication2.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>
    <h3>Your application description page.</h3>
    <p>Use this area to provide additional information.</p>
    <p><asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="TextBox1" runat="server" Width="276px"></asp:TextBox>
    &nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="DropDownList1" runat="server" Height="27px" Width="94px">
            <asp:ListItem>HUU</asp:ListItem>
            <asp:ListItem>JJJJ</asp:ListItem>
            <asp:ListItem>TTHTH</asp:ListItem>
        </asp:DropDownList>
    </p>
    <p>
        <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="TextBox2" runat="server" Width="276px"></asp:TextBox>
&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" Width="96px" />
    </p>
    <p>
        <asp:TextBox ID="TextBox3" runat="server" TextMode="Date"></asp:TextBox>
    </p>
    <div style ="width:100%; height: 210px; float:left">
        <div style ="width:45%; height: 194px; float:left">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:Calendar ID="Calendar5" runat="server"></asp:Calendar>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div style ="width:45%; height:189px; float:right">
            <asp:Calendar ID="Calendar4" runat="server"></asp:Calendar>
        </div>
    </div>
    <p>
        &nbsp;</p>
            <hr />
            <asp:GridView ID="GridView1" runat="server">
    </asp:GridView>
    <div>
        <br />
    </div>
    <br />
    </asp:Content>

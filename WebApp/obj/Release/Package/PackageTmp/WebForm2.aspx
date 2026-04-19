<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="WebApp.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../masterskin/MaterialPro/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
        function ShowCurrentTime(tt) {
            h = PageMethods.GetCurrentTime('fffgf');
            alert("<%:Session["dd"].ToString() %>");
        }
        function OnSuccess(response, userContext, methodName) {
            alert(response);
        };

        function CallMethod(type, value) {
            $.ajax({
                type: "POST",
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                url: "WebForm2.aspx/GetCurrentTime",
                data: "{type='" + type + "', value='" + value + "'}", // parameters for method
                success: function (dt) { alert(dt); }, //all Ok
                error: function () { alert('error'); } // some error
            });
        }
    </script>
</head>
<body style="font-family: Arial; font-size: 10pt">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </asp:ScriptManager>
        <div>
            Your Name : 
            <asp:TextBox ID="txtUserName" runat="server"></asp:TextBox>
            <input id="btnGetTime" type="button" value="Show Current Time" onclick="CallMethod('11','222');" />
        </div>
    </form>
</body>
</html>


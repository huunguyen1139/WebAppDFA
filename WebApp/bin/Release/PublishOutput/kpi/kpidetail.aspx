<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="kpidetail.aspx.cs" Inherits="WebApplication2.kpi.kpidetail" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>KPI Result detail</title>
    <link href="../Content/bootstrap.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div class="table-responsive">
                    <asp:GridView runat="server" ID ="gvDetailKPIResult" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                        <HeaderStyle BackColor="#cccccc" BorderColor="#E3E6E3"/>                       
                    </asp:GridView>                   
                </div>
    </form>
</body>
</html>

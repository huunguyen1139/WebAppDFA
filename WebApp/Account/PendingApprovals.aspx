<%@ Page Title="" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="PendingApprovals.aspx.cs" Inherits="WebApp.Account.PendingApprovals" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <!-- Skin Maretial P -->
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
<%--    <script src="/masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>--%>
    <script src="/masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <%--<script src="/masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <!--<script src="/masterskin/MaterialPro/dist/assets/js/dashboards/dashboard4.js"></script>-->
    <script src="/masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    
    <!-- Skin Material P -->

    <!-- select 2 -->
    <link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="/masterskin/monster/dist/select2/select2.min.js"></script>

    <!-- load sweet alert -->
    <script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <asp:UpdatePanel ID="upInbox" runat="server">
 <ContentTemplate>
     <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
    <div class="container-fluid">
       
  <div class="card shadow-sm">
    <div class="card-header">
      <h5 class="mb-0">My Pending Approvals</h5>
    </div>

    <div class="card-body p-3">
      <asp:Repeater ID="rpt" runat="server">
        <HeaderTemplate>
          <table class="table table-hover table-bordered table-sm text-nowrap fs-3 mb-0">
            <thead class="table-light">
              <tr>
                <th style="width:80px">Doc&nbsp;No</th>
                <th style="width:120px">Type</th>
                <th>Title</th>
                <th style="width:60px">Step</th>
                <th style="width:100px">Status</th>
                <th style="width:150px">Sender</th>   <!-- new -->
                <th style="width:130px">Created</th>
                <th style="width:80px">Open</th>
              </tr>
            </thead>
            <tbody>
        </HeaderTemplate>

        <ItemTemplate>
          <tr>
            <td><%# Eval("DocId") %></td>
            <td><%# Eval("DocType") %></td>
            <td><%# Eval("Title") %></td>
            <td class="text-center"><%# Eval("Seq") %></td>
            <td><span class="badge bg-secondary"><%# Eval("StatusName") %></span></td>
            
            <td><span title="<%# Eval("SenderId") %>"><%# Eval("SenderName") %></span></td>

            <td><%# ((DateTime)Eval("CreatedOn")).ToString("yyyy-MM-dd HH:mm") %></td>
            <td>
              <a class="btn btn-link btn-sm p-0" target="_blank"
                 href='<%# Eval("DocLink") %>'>View </a>
            </td>
          </tr>
        </ItemTemplate>


        <FooterTemplate>
            </tbody></table>
        </FooterTemplate>
      </asp:Repeater>

      <asp:Label ID="lblEmpty" runat="server" CssClass="text-muted p-3 d-block" Visible="false"
                 Text="No approvals pending."></asp:Label>
    </div>
  </div>
        </div>
         </div>
 </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

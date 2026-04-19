<%@ Page Title="Notification" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="WebApp.Notifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
    <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <%--<script src="../masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>    

    <%-- select 2 --%>
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>

    <%-- load sweet alert --%>
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />   
        
    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px)">
        <div class="container-fluid"> 
          <div class="container mt-4">
            <h3>Notifications</h3>
              <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                  <ContentTemplate>
                      <dx:ASPxComboBox ID="cboFilter" runat="server" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="cboFilter_SelectedIndexChanged">
                          <Items>
                              <dx:ListEditItem Text="All" Value="all" Selected="True" />
                              <dx:ListEditItem Text="Unread" Value="unread" />
                          </Items>
                      </dx:ASPxComboBox>
                      <dx:ASPxGridView ID="gridNotifications" runat="server" AutoGenerateColumns="False" KeyFieldName="NotificationID"
                          CssClass="mt-3" Width="100%" OnCustomButtonCallback = "gridNotifications_CustomButtonCallback" OnHtmlDataCellPrepared="gridNotifications_HtmlDataCellPrepared">
                          <SettingsBehavior AllowFocusedRow="True" />
                          <Columns>
                              <dx:GridViewDataColumn FieldName="Message" Caption="Message" Width="60%">
                                  <CellStyle Wrap="True" />
                              </dx:GridViewDataColumn>
                              <dx:GridViewDataTextColumn FieldName="TimeAgo" Caption="Time">
                                  <DataItemTemplate>
                                      <span title='<%# Eval("CreatedAt", "{0:dd-MM-yyyy HH:mm}") %>'>
                                          <%# Eval("TimeAgo") %>
                                      </span>
                                  </DataItemTemplate>
                              </dx:GridViewDataTextColumn>
                              <dx:GridViewDataCheckColumn FieldName="IsRead" Caption="Read" Visible="false"></dx:GridViewDataCheckColumn>
                                <dx:GridViewDataHyperLinkColumn FieldName="Link" Caption="Action">
                                    <PropertiesHyperLinkEdit Target="_blank" Text="Open Document"></PropertiesHyperLinkEdit>
                                    
                                </dx:GridViewDataHyperLinkColumn>
                              <dx:GridViewCommandColumn ButtonRenderMode="Image" ShowSelectCheckbox="false" ShowClearFilterButton="true">
                                  <CustomButtons>
                                      <dx:GridViewCommandColumnCustomButton ID="btnMarkRead" Text="Mark as read">
                                          <Image ToolTip="Mark as read" Url="../images/book_24.png" />
                                      </dx:GridViewCommandColumnCustomButton>
                                  </CustomButtons>
                              </dx:GridViewCommandColumn>
                          </Columns>
                          <Styles>
                              <Row CssClass="p-2"></Row>
                              <FocusedRow BackColor="#eaf6ff" ForeColor="Black" />
                          </Styles>
                      </dx:ASPxGridView>
                  </ContentTemplate>
                  <Triggers>
                      <%--<asp:AsyncPostBackTrigger ControlID="cboFilter" EventName="cboFilter_SelectedIndexChanged" />--%>
                  </Triggers>
              </asp:UpdatePanel>
                </div>        
        </div>
    </div>



</asp:Content>

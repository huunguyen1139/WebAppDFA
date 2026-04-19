<%@ Page Title="Production Output Setup" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ProductionOutputSetup.aspx.cs" Inherits="WebApp.production.ProductionOutputSetup" %>

<%--<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Skin Maretial P -->
  <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
  <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.111.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
  <!-- Import Js Files -->
  <script src="/masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/dashboards/dashboard4.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
  <script src="/masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
  <!-- solar icons -->
 <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
  <!-- Skin Material P -->


<!-- select 2 -->
<link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
<script src="/masterskin/monster/dist/select2/select2.min.js"></script>

<!-- Export to Excel -->
<script type="text/javascript" src="/masterskin/monster/dist/export2excel/jszip.min.js"></script>
<script type="text/javascript" src="/masterskin/monster/dist/export2excel/FileSaver.min.js"></script>
<script type="text/javascript" src="/masterskin/monster/dist/export2excel/excel-gen.js"></script>

<!-- load sweet alert -->
<script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
<link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <!-- Bootstrap -->
    <!-- Modal Popup -->
<div id="divModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div id="ModalHeader" class="modal-header modal-colored-header text-white">
                <h4 class="modal-title" id="warning-header-modalLabel">Modal Heading
                </h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="modal-message">
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                    Close
                </button>
            </div>
        </div>           
    </div>
</div>
<script type="text/javascript">
    function ShowPopup(title, body, class_style) {

        $("#divModal .modal-title").html(title);
        $("#divModal .modal-message").html(body);
        $("#divModal").modal("show");
        document.getElementById("ModalHeader").classList.add(class_style);
    }
</script>
<!-- Modal Popup -->
    <style>
        .post-setup-page .hero-card {
            background: linear-gradient(135deg, #163d7a 0%, #2754a6 100%);
            color: #fff;
            border-radius: 20px;
            padding: 24px 28px;
            margin-bottom: 20px;
            box-shadow: 0 10px 28px rgba(22,61,122,.18);
        }

        .post-setup-page .soft-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 8px 24px rgba(28,44,64,.08);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .post-setup-page .soft-card .card-header {
            background: #fff;
            border-bottom: 1px solid #eef2f7;
            font-weight: 700;
            padding: 14px 18px;
        }

        .post-setup-page .soft-card .card-body {
            padding: 18px;
        }

        .post-setup-page .summary-tile {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(28,44,64,.06);
            padding: 18px 20px;
            height: 100%;
        }

        .post-setup-page .summary-title {
            color: #7b8794;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .post-setup-page .summary-value {
            font-size: 28px;
            font-weight: 700;
            color: #1e293b;
            line-height: 1.1;
        }

        .post-setup-page .summary-sub {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 6px;
        }

        .post-setup-page .window-banner {
            background: #eef6ff;
            color: #184b8a;
            border: 1px solid #d6e8ff;
            border-radius: 14px;
            padding: 12px 16px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-pill {
            display: inline-block;
            border-radius: 999px;
            padding: 5px 10px;
            font-size: 12px;
            font-weight: 700;
        }

        .status-pill.active {
            background: #dcfce7;
            color: #166534;
        }

        .status-pill.inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .audit-box {
            background: #fafbfc;
            border: 1px solid #eef2f7;
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 13px;
            color: #475569;
        }

        .form-note {
            font-size: 12px;
            color: #64748b;
            margin-top: 5px;
        }
    </style>
    <script type="text/javascript">
        function OnGridCustomButtonClick(s, e) {
            if (e.buttonID === "btnToggle") {
                if (!confirm("Are you sure you want to change active status of this posting window?")) {
                    e.processOnServer = false;
                }
                else {
                    var key = s.GetRowKey(e.visibleIndex);                   
                    cpEdit.PerformCallback("ACTIVE|" + key);
                }
            }
            if (e.buttonID === "btnEdit") {
                // allow server
                pcEdit.Show();
                e.processOnServer = false;

                var key = s.GetRowKey(e.visibleIndex);
                cpEdit.PerformCallback("EDIT|" + key);
            }
        }

        function OnEditEndCallback(s, e) {
            if (s.cpShowPopup === "1") {
                pcEdit.Show();
                s.cpShowPopup = null;
            }

            if (s.cpMessage) {
                alert(s.cpMessage);
                s.cpMessage = null;
            }
        }
    </script>

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid post-setup-page">
                    <div class="hero-card">
                        <div class="d-flex flex-wrap justify-content-between align-items-center">
                            <div>
                                <h2 class="mb-1 text-white">Production Output Setup</h2>
                                <div class="opacity-75">
                                    Control allowed datetime window for posting Production Output
                   
                                </div>
                            </div>
                            <div class="mt-3 mt-md-0">
                                <asp:Button ID="btnAddNew" runat="server" Text="+ Add New Window"
                                    CssClass="btn btn-light"
                                    OnClick="btnAddNew_Click" />
                            </div>
                        </div>
                    </div>

                    <div class="window-banner mb-3">
                        Window Name: <strong>PostProductionOutput</strong>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-12 col-md-4">
                            <div class="summary-tile">
                                <div class="summary-title">Total Setup Rows</div>
                                <asp:Label ID="lblTotalRows" runat="server" CssClass="summary-value" Text="0"></asp:Label>
                                <div class="summary-sub">All records for PostSiteOutput</div>
                            </div>
                        </div>
                        <div class="col-12 col-md-4">
                            <div class="summary-tile">
                                <div class="summary-title">Active Rows</div>
                                <asp:Label ID="lblActiveRows" runat="server" CssClass="summary-value" Text="0"></asp:Label>
                                <div class="summary-sub">Rows currently enabled</div>
                            </div>
                        </div>
                        <div class="col-12 col-md-4">
                            <div class="summary-tile">
                                <div class="summary-title">Current Active Window</div>
                                <asp:Label ID="lblCurrentWindow" runat="server" CssClass="summary-value" Text="-"></asp:Label>
                                <div class="summary-sub">Based on current server datetime</div>
                            </div>
                        </div>
                    </div>

                    <div class="card soft-card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span>Posting Window List</span>
                            <div>
                                <asp:Button ID="btnRefresh" runat="server" Text="Refresh"
                                    CssClass="btn btn-sm btn-outline-primary"
                                    OnClick="btnRefresh_Click" />
                            </div>
                        </div>
                        <div class="card-body">
                            <dx:ASPxGridView ID="gvSetup" runat="server"
                                Width="100%"
                                KeyFieldName="WindowID"
                                AutoGenerateColumns="False"
                                OnCustomButtonCallback="gvSetup_CustomButtonCallback"
                                OnHtmlDataCellPrepared="gvSetup_HtmlDataCellPrepared">
                                <ClientSideEvents CustomButtonClick="OnGridCustomButtonClick" />
                                <SettingsPager PageSize="20" />
                                <SettingsBehavior AllowFocusedRow="true" />
                                <Settings ShowVerticalScrollBar="true" VerticalScrollableHeight="450" HorizontalScrollBarMode="Auto" />
                                <Styles>
                                    <Header Font-Bold="true"></Header>
                                </Styles>

                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="WindowID" Caption="ID" Width="70" Visible="false"/>
                                    <dx:GridViewDataDateColumn FieldName="AllowFrom" Caption="Allow From" Width="170">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd HH:mm" />
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataDateColumn FieldName="AllowTo" Caption="Allow To" Width="170">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd HH:mm" />
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="StatusText" Caption="Status" Width="120" UnboundType="String" />
                                    <dx:GridViewDataTextColumn FieldName="Remark" Caption="Remark" Width="260" />
                                    <dx:GridViewDataTextColumn FieldName="CreatedBy" Caption="Created By" Width="120" />
                                    <dx:GridViewDataDateColumn FieldName="CreatedAt" Caption="Created At" Width="150">
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd HH:mm" />
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="ModifiedBy" Caption="Modified By" Width="120" Visible="false" />
                                    <dx:GridViewDataDateColumn FieldName="ModifiedAt" Caption="Modified At" Width="150" Visible="false" >
                                        <PropertiesDateEdit DisplayFormatString="yyyy-MM-dd HH:mm" />
                                    </dx:GridViewDataDateColumn>

                                    <dx:GridViewCommandColumn Caption="Action" Width="180" VisibleIndex="99">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="btnEdit" Text="Edit" />
                                            <dx:GridViewCommandColumnCustomButton ID="btnToggle" Text="Toggle Active" />
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                </Columns>
                            </dx:ASPxGridView>
                        </div>
                    </div>

                    <dx:ASPxPopupControl ID="pcEdit" runat="server"
                        ClientInstanceName="pcEdit"
                        Modal="True"
                        HeaderText="Post Site Output Setup"
                        Width="720px"
                        PopupHorizontalAlign="WindowCenter"
                        PopupVerticalAlign="WindowCenter"
                        CloseAction="CloseButton"
                        AllowDragging="true">
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxCallbackPanel ID="cpEdit" runat="server"
                                    ClientInstanceName="cpEdit"
                                    Width="100%"
                                    OnCallback="cpEdit_Callback">
                                    <ClientSideEvents EndCallback="OnEditEndCallback" />
                                    <PanelCollection>
                                        <dx:PanelContent runat="server">
                                        <div class="p-2">
                                    <asp:HiddenField ID="hfWindowID" runat="server" />

                                    <div class="row g-3">
                                        <div class="col-12">
                                            <div class="audit-box">
                                                Posting control key: <strong>PostSiteOutput</strong>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <label class="form-label">Allow From <span class="text-danger">*</span></label>
                                            <dx:ASPxDateEdit ID="deAllowFrom" runat="server"
                                                Width="100%"
                                                EditFormat="DateTime"
                                                EditFormatString="yyyy-MM-dd HH:mm"
                                                DisplayFormatString="yyyy-MM-dd HH:mm"
                                                UseMaskBehavior="True">
                                                <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                            </dx:ASPxDateEdit>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <label class="form-label">Allow To <span class="text-danger">*</span></label>
                                            <dx:ASPxDateEdit ID="deAllowTo" runat="server"
                                                Width="100%"
                                                EditFormat="DateTime"
                                                EditFormatString="yyyy-MM-dd HH:mm"
                                                DisplayFormatString="yyyy-MM-dd HH:mm"
                                                UseMaskBehavior="True">
                                                <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                            </dx:ASPxDateEdit>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <label class="form-label">Status</label>
                                            <dx:ASPxComboBox ID="cboIsActive" runat="server" Width="100%">
                                                <Items>
                                                    <dx:ListEditItem Text="Active" Value="1" Selected="True" />
                                                    <dx:ListEditItem Text="Inactive" Value="0" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <label class="form-label">Current Server Time</label>
                                            <asp:TextBox ID="txtServerTime" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                                            <div class="form-note">Used to compare current active window.</div>
                                        </div>

                                        <div class="col-12">
                                            <label class="form-label">Remark</label>
                                            <dx:ASPxMemo ID="memoRemark" runat="server" Width="100%" Height="90px"></dx:ASPxMemo>
                                        </div>

                                        <div class="col-12">
                                            <div class="alert alert-info mb-0">
                                                Example: Allow posting from first day of month until month end closing.
                               
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mt-4 text-end">
                                        <asp:Button ID="btnSave" runat="server" Text="Save"
                                            CssClass="btn btn-primary me-2"
                                            OnClick="btnSave_Click" />
                                        <button type="button" class="btn btn-outline-secondary" onclick="pcEdit.Hide();">Close</button>
                                    </div>
                                </div>
                                        </dx:PanelContent>
                                    </PanelCollection>
                            </dx:ASPxCallbackPanel>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
       <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="images/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

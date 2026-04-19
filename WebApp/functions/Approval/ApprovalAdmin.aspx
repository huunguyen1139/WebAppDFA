<%@ Page Title="Approval – Admin Console" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ApprovalAdmin.aspx.cs" Inherits="WebApp.functions.approval.ApprovalAdmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
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
   
    <!-- select 2 -->
    <link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="/masterskin/monster/dist/select2/select2.min.js"></script>      

    <!-- load sweet alert -->
    <script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />
    
    <script>
        function onRowDeleting(s, e) {
            e.cancel = true; // Cancel the default delete action

            Swal.fire({
                title: 'Are you sure?',
                text: 'Delete the record?',
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.value) {
                    // Trigger actual delete
                    s.DeleteRow(e.visibleIndex);
                }
            });

        }
    </script>

    <!-- SweetAlert delete confirmation -->
    <script>
    document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll(".dxgvCommandColumnItem_MaterialCompact a[onclick*='Delete']").forEach(btn => {
            alert('1');
         btn.onclick = (e)=>{
            e.preventDefault();
            Swal.fire({title:"Delete record?",icon:"warning",showCancelButton:true})
               .then(r=>{ if(r.isConfirmed) window.location = btn.href; });
            return false;
         };
      });
    });
    </script>
    
   <%-- <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>--%>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <h2>Approval Admin Console</h2>
                    <div class="card mt-3">
                        <dx:ASPxPageControl ID="pc" runat="server" Width="100%" CssClass="shadow rounded-3">
                            <TabPages>

                                <%--<!- ===== Document Types ===== -->--%>
                                <dx:TabPage Text="Document Types">
                                    <ContentCollection>
                                        <dx:ContentControl>
                                            <dx:ASPxGridView ID="gvDocTypes" runat="server" Width="100%" DataSourceID="dsDocTypes"
                                                             KeyFieldName="DocTypeId" AutoGenerateColumns="False"
                                                             CssClass="table table-sm">
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" 
                                                                              ShowNewButtonInHeader="true" Width="60" />
                                                    <dx:GridViewDataTextColumn FieldName="DocTypeId" Caption="DocTypeId" EditFormSettings-Visible="False"/>
                                                    <dx:GridViewDataTextColumn FieldName="Name"          Caption="Name" />
                                                    <dx:GridViewDataTextColumn FieldName="HeaderTableName" Caption="Header table" />
                                                    <dx:GridViewDataTextColumn FieldName="StatusColumnName" Caption="Status column" />
                                                    <dx:GridViewDataTextColumn FieldName="ExternalRefColumnName" Caption="Ex.Ref Column" />
                                                    <dx:GridViewDataTextColumn FieldName="AdditionalFilterString" Caption="Filter Query" />
                                                    <dx:GridViewDataTextColumn FieldName="DocViewLink" Caption="DocViewLink" />
                                                </Columns>
                                                <SettingsDataSecurity AllowDelete="true" AllowEdit="true" AllowInsert="true" />                                                
                                                <SettingsBehavior ConfirmDelete="true" />    
                                                <Settings ShowHeaderFilterButton="True" ShowFilterRowMenu="True" />
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource ID="dsDocTypes" runat="server"
                                                SelectCommand="SELECT * FROM APPROVAL_DocumentTypes"
                                                InsertCommand="INSERT INTO APPROVAL_DocumentTypes (Name,HeaderTableName,StatusColumnName,ExternalRefColumnName,AdditionalFilterString, DocViewLink)
                                                VALUES (@Name,@HeaderTableName,@StatusColumnName,@ExternalRefColumnName,@AdditionalFilterString, @DocViewLink)"
                                                UpdateCommand="UPDATE APPROVAL_DocumentTypes
                                                SET Name=@Name, HeaderTableName=@HeaderTableName, StatusColumnName=@StatusColumnName,
                                                ExternalRefColumnName = @ExternalRefColumnName, AdditionalFilterString = @AdditionalFilterString,
                                                DocViewLink = @DocViewLink
                                                WHERE DocTypeId=@DocTypeId"
                                                DeleteCommand="DELETE FROM APPROVAL_DocumentTypes WHERE DocTypeId=@DocTypeId">
                                                <InsertParameters>
                                                    <asp:Parameter Name="Name" Type="String" />
                                                    <asp:Parameter Name="HeaderTableName" Type="String" />
                                                    <asp:Parameter Name="StatusColumnName" Type="String" />
                                                    <asp:Parameter Name="ExternalRefColumnName" Type="String" />
                                                    <asp:Parameter Name="AdditionalFilterString" Type="String" />
                                                    <asp:Parameter Name="DocViewLink" Type="String" />
                                                </InsertParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="Name" Type="String" />
                                                    <asp:Parameter Name="HeaderTableName" Type="String" />
                                                    <asp:Parameter Name="StatusColumnName" Type="String" />
                                                    <asp:Parameter Name="DocTypeId" Type="Int32" />
                                                    <asp:Parameter Name="ExternalRefColumnName" Type="String" />
                                                    <asp:Parameter Name="AdditionalFilterString" Type="String" />
                                                    <asp:Parameter Name="DocViewLink" Type="String" />
                                                </UpdateParameters>
                                                <DeleteParameters>
                                                    <asp:Parameter Name="DocTypeId" Type="Int32" />
                                                </DeleteParameters>
                                            </asp:SqlDataSource>

                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <%-- <-- ===== Status Map ===== -->--%>
                                <dx:TabPage Text="Status Codes">
                                    <ContentCollection>
                                        <dx:ContentControl>
                                            <dx:ASPxGridView ID="gvStatus" runat="server" Width="100%" DataSourceID="dsStatus"
                                                             KeyFieldName="DocTypeId;StatusCode" AutoGenerateColumns="False">
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true"
                                                                              ShowNewButtonInHeader="true" Width="60" />
                                                    <dx:GridViewDataComboBoxColumn FieldName="DocTypeId" Caption="Doc Type"
                                                            PropertiesComboBox-DataSourceID="dsDocTypeLookup"
                                                            PropertiesComboBox-ValueField="DocTypeId"
                                                            PropertiesComboBox-TextField="Name" />
                                                    <dx:GridViewDataTextColumn FieldName="StatusCode" Caption="Code" />
                                                    <dx:GridViewDataComboBoxColumn FieldName="StatusName" Caption="Name">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="Open" Value="Open" />
                                                                <dx:ListEditItem Text="Approved" Value="Approved" />
                                                                <dx:ListEditItem Text="Pending" Value="Pending"/>
                                                                <dx:ListEditItem Text="Rejected" Value="Rejected" />
                                                                <dx:ListEditItem Text="Cancelled" Value="Cancelled" />
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    
                                                </Columns>
                                                <SettingsBehavior ConfirmDelete="true" /> 
                                                <Settings ShowHeaderFilterButton="True" ShowFilterRowMenu="True" />
                                            </dx:ASPxGridView>

                                            <asp:SqlDataSource ID="dsStatus" runat="server"
                                                 ConnectionString=""
                                                 SelectCommand="SELECT * FROM APPROVAL_DocumentStatusMap"
                                                 InsertCommand="INSERT INTO APPROVAL_DocumentStatusMap (DocTypeId,StatusCode,StatusName) VALUES (@DocTypeId,@StatusCode,@StatusName)"
                                                 UpdateCommand="UPDATE APPROVAL_DocumentStatusMap SET StatusName=@StatusName WHERE DocTypeId=@DocTypeId AND StatusCode=@StatusCode"
                                                 DeleteCommand="DELETE FROM APPROVAL_DocumentStatusMap WHERE DocTypeId=@DocTypeId AND StatusCode=@StatusCode">
                                                 <InsertParameters>
                                                    <asp:Parameter Name="DocTypeId"   Type="Int32" />
                                                    <asp:Parameter Name="StatusCode"  Type="Int32" />
                                                    <asp:Parameter Name="StatusName"  Type="String" />
                                                </InsertParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="DocTypeId"   Type="Int32" />
                                                    <asp:Parameter Name="StatusCode"  Type="Int32" />
                                                    <asp:Parameter Name="StatusName"  Type="String" />
                                                </UpdateParameters>
                                                <DeleteParameters>
                                                    <asp:Parameter Name="DocTypeId"   Type="Int32" />
                                                    <asp:Parameter Name="StatusCode"  Type="Int32" />
                                                </DeleteParameters>
                                            </asp:SqlDataSource>

                                            <!-- lookup datasource -->
                                            <asp:SqlDataSource ID="dsDocTypeLookup" runat="server"
                                                 ConnectionString=""
                                                 SelectCommand="SELECT DocTypeId,Name FROM APPROVAL_DocumentTypes ORDER BY Name" />
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <%--<-- ===== Flow Templates & Steps  (Master-Detail) ===== -->--%>
                                <dx:TabPage Text="Flow Templates">
                                    <ContentCollection>
                                        <dx:ContentControl>
                                            <dx:ASPxGridView ID="gvFlow" runat="server" Width="100%" DataSourceID="dsFlow"
                                                             KeyFieldName="FlowId" AutoGenerateColumns="False"                                                             
                                                             SettingsDetail-DetailMode="Detail" SettingsDetail-ShowDetailRow="true">
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true"
                                                                              ShowNewButtonInHeader="true" Width="60" />
                                                    <dx:GridViewDataTextColumn FieldName="ApprovalFlowID" Caption="ApprovalFlowID" EditFormSettings-Visible="False"/>
                                                    <dx:GridViewDataTextColumn FieldName="FlowName" Caption="Name" />
                                                    <dx:GridViewDataComboBoxColumn FieldName="DocTypeId" Caption="Doc Type"
                                                            PropertiesComboBox-DataSourceID="dsDocTypeLookup"
                                                            PropertiesComboBox-ValueField="DocTypeId"
                                                            PropertiesComboBox-TextField="Name" />
                                                    <dx:GridViewDataComboBoxColumn FieldName="ProjectId" Caption="Project"
                                                            PropertiesComboBox-DataSourceID="dsProjectLookup"
                                                            PropertiesComboBox-ValueField="ProjectCode"
                                                            PropertiesComboBox-TextField="ProjectName" />
                                                    <dx:GridViewDataCheckColumn FieldName="IsDynamic" Caption="Dynamic?" />
                                                </Columns>
                                                <SettingsBehavior ConfirmDelete="true" /> 
                                                <SettingsDetail AllowOnlyOneMasterRowExpanded="true" />
                                                <Settings ShowHeaderFilterButton="True" ShowFilterRowMenu="True" />
                                               <%--  Detail Grid for Steps --%>
                                                <Templates>
                                                    <DetailRow>
                                                        Detail approval work flow: USER - CREATOR - DEPT_MANAGER - DIRECTOR
                                                        <dx:ASPxGridView ID="gvSteps" CssClass="mt-3" runat="server" Width="100%" DataSourceID="dsFlowDetail"
                                                                         KeyFieldName="StepId" AutoGenerateColumns="False"
                                                                          OnBeforePerformDataSelect="gvSteps_BeforePerformDataSelect">
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true"
                                                                                          ShowNewButtonInHeader="true" Width="55" />
                                                                <dx:GridViewDataTextColumn FieldName="Seq" Caption="#" Width="40" />
                                                                <dx:GridViewDataTextColumn FieldName="ApproverRole" Caption="Role" />                                                                
                                                                <dx:GridViewDataComboBoxColumn FieldName="ApproverId" Caption="Approver Id"
                                                                    PropertiesComboBox-DataSourceID="dsUserLookup"
                                                                    PropertiesComboBox-ValueField="EmployeeID"
                                                                    PropertiesComboBox-TextField="EmployeeName" />
                                                            </Columns>
                                                            <SettingsBehavior ConfirmDelete="true" /> 
                                                        </dx:ASPxGridView>
                                                    </DetailRow>
                                                </Templates>
                                            </dx:ASPxGridView>

                                            <%-- DataSources --%>
                                            <asp:SqlDataSource ID="dsFlow" runat="server"
                                                 ConnectionString=""
                                                 SelectCommand="SELECT *, FlowId as ApprovalFlowID  FROM APPROVAL_FlowDef"
                                                 InsertCommand="INSERT INTO APPROVAL_FlowDef (DocTypeId,ProjectId,IsDynamic,FlowName) VALUES (@DocTypeId,@ProjectId,@IsDynamic,@FlowName)"
                                                 UpdateCommand="UPDATE APPROVAL_FlowDef SET DocTypeId=@DocTypeId, ProjectId=@ProjectId, IsDynamic=@IsDynamic, FlowName=@FlowName WHERE FlowId=@FlowId"
                                                 DeleteCommand="DELETE FROM APPROVAL_FlowDef WHERE FlowId=@FlowId">
                                                
                                                 <InsertParameters>
                                                    <asp:Parameter Name="DocTypeId" Type="Int32"  />
                                                    <asp:Parameter Name="ProjectId" Type="String" />
                                                    <asp:Parameter Name="IsDynamic" Type="Boolean" />
                                                    <asp:Parameter Name="FlowName"  Type="String" />
                                                 </InsertParameters>
                                                 <UpdateParameters>
                                                    <asp:Parameter Name="FlowId"     Type="Int32" />
                                                    <asp:Parameter Name="DocTypeId"  Type="Int32" />
                                                    <asp:Parameter Name="ProjectId"  Type="String" />
                                                    <asp:Parameter Name="IsDynamic"  Type="Boolean" />
                                                    <asp:Parameter Name="FlowName"   Type="String" />
                                                 </UpdateParameters>
                                                 <DeleteParameters>
                                                    <asp:Parameter Name="FlowId" Type="Int32" />
                                                 </DeleteParameters>
                                            </asp:SqlDataSource>

                                            <asp:SqlDataSource ID="dsFlowDetail" runat="server"
                                               ConnectionString="" 
                                               SelectCommand="SELECT * FROM APPROVAL_FlowSteps WHERE FlowId = @FlowId"
                                               InsertCommand="INSERT INTO APPROVAL_FlowSteps (FlowId,Seq,ApproverRole,ApproverId) VALUES (@FlowId,@Seq,@ApproverRole,@ApproverId)"
                                               UpdateCommand="UPDATE APPROVAL_FlowSteps SET Seq=@Seq, ApproverRole=@ApproverRole, ApproverId=@ApproverId WHERE StepId=@StepId"
                                               DeleteCommand="DELETE FROM APPROVAL_FlowSteps WHERE StepId=@StepId">
                                               <SelectParameters>
                                                   <asp:SessionParameter Name="FlowId" SessionField="FlowId" />
                                               </SelectParameters>
                                               <InsertParameters>
                                                    <asp:SessionParameter Name="FlowId" SessionField="FlowId" />
                                                    <asp:Parameter Name="Seq"  Type="Int32" />
                                                    <asp:Parameter Name="ApproverRole"  Type="String" />
                                                    <asp:Parameter Name="ApproverId"  Type="String" />                                                    
                                               </InsertParameters>
                                               <UpdateParameters>                                                   
                                                   <asp:SessionParameter Name="FlowId" SessionField="FlowId" />
                                                   <asp:Parameter Name="Seq"  Type="Int32" />
                                                   <asp:Parameter Name="ApproverRole"  Type="String" />
                                                   <asp:Parameter Name="ApproverId"  Type="String" />
                                                   <asp:Parameter Name="StepId"   Type="Int32" />
                                               </UpdateParameters>
                                               <DeleteParameters>
                                                   <asp:Parameter Name="StepId"   Type="Int32" />
                                               </DeleteParameters>
                                           </asp:SqlDataSource>

                                            <asp:SqlDataSource ID="dsProjectLookup" runat="server"
                                                 ConnectionString=""
                                                 SelectCommand="SELECT No_ ProjectCode, No_ + ' - ' + [Bill-to Name] ProjectName FROM ALL_NAV_90.dbo.[LIVE_ALLIANCE_90$Job]
                                                                WHERE No_ NOT IN ('JOB_TEMPLATE') ORDER BY No_ DESC"></asp:SqlDataSource>

                                            <asp:SqlDataSource runat="server" ID="dsUserLookup" 
                                                SelectCommand="SELECT EmployeeID, (EmployeeID + ' - ' + EmployeeName) EmployeeName, [Role] FROM Employee where [Status] = 1 and isEmployeeCode = 1" 
                                                CacheDuration="100">
                                            </asp:SqlDataSource>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>

                                <dx:TabPage Text="Notify Groups">
                                    <ContentCollection>
                                        <dx:ContentControl>
                                            <div class="row g-3">
                                                <%-- Groups list --%>
                                                <div class="col-lg-4">
                                                    <div class="card">
                                                        <div class="card-header d-flex justify-content-between">
                                                            <span>Groups</span>
                                                            <button runat="server" id="btnNewGroup" class="btn btn-sm btn-primary" onserverclick="btnNewGroup_ServerClick">New</button>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <asp:GridView ID="gvGroups" runat="server" AutoGenerateColumns="false" CssClass="table table-sm table-hover mb-0"
                                                                DataKeyNames="GroupId" OnSelectedIndexChanged="gvGroups_SelectedIndexChanged">
                                                                <Columns>
                                                                    <asp:CommandField ShowSelectButton="true" SelectText="Select" />
                                                                    <asp:BoundField DataField="GroupCode" HeaderText="Code" />
                                                                    <asp:BoundField DataField="GroupName" HeaderText="Name" />
                                                                    <asp:CheckBoxField DataField="IsActive" HeaderText="Active" />
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="row g-2">
                                                                <div class="col-4">
                                                                    <asp:TextBox ID="txtGroupCode" runat="server" CssClass="form-control" placeholder="Code" />
                                                                </div>
                                                                <div class="col-5">
                                                                    <asp:TextBox ID="txtGroupName" runat="server" CssClass="form-control" placeholder="Name" />
                                                                </div>
                                                                <div class="col-2 form-check pt-2">
                                                                    <asp:CheckBox ID="chkGroupActive" runat="server" Text="Active" Checked="true" />
                                                                </div>
                                                                <div class="col-12 d-flex gap-2">
                                                                    <asp:Button ID="btnSaveGroup" runat="server" CssClass="btn btn-success btn-sm" Text="Save" OnClick="btnSaveGroup_Click" />
                                                                    <asp:Button ID="btnDeleteGroup" runat="server" CssClass="btn btn-outline-danger btn-sm" Text="Delete" OnClick="btnDeleteGroup_Click" />
                                                                </div>
                                                                <asp:HiddenField ID="hfGroupId" runat="server" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <%--  Members of selected group --%>
                                                <div class="col-lg-4">
                                                    <div class="card">
                                                        <div class="card-header">Members</div>
                                                        <div class="card-body p-0">
                                                            <asp:GridView ID="gvMembers" OnRowDeleting="gvMembers_RowDeleting" runat="server" AutoGenerateColumns="false" CssClass="table table-sm table-hover mb-0">
                                                                <Columns>
                                                                    <asp:BoundField DataField="UserId" HeaderText="UserId" />
                                                                    <asp:BoundField DataField="EmployeeName" HeaderText="Name" />
                                                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                                                    <asp:CommandField ShowDeleteButton="true" ItemStyle-CssClass="text-danger" DeleteText="Remove" />
                                                                    <%--<asp:TemplateField HeaderText="">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton runat="server" CommandName="RemoveMember" CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-link btn-sm text-danger">Remove</asp:LinkButton>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>--%>
                                                                </Columns>
                                                            </asp:GridView>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="input-group input-group-sm">
                                                               <%-- <asp:TextBox ID="txtAddUserId" runat="server" CssClass="form-control" placeholder="UserId (NVARCHAR(20))" />--%>
                                                                <asp:DropDownList ID="ddlAddUser" runat="server" CssClass="form-control form-control-sm select2" Width="80%" />
                                                                <asp:Button ID="btnAddMember" runat="server" CssClass="btn btn-outline-primary" Text="Add" OnClick="btnAddMember_Click" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <%-- Map groups to DocType --%>
                                                <div class="col-lg-4">
                                                    <div class="card">
                                                        <div class="card-header">DocType → Notify Groups</div>
                                                        <div class="card-body">
                                                            <div class="mb-2">
                                                                <asp:DropDownList ID="ddlDocType" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlDocType_SelectedIndexChanged" />
                                                            </div>
                                                            <asp:Repeater ID="rpDocTypeGroups" runat="server" OnItemCommand="rpDocTypeGroups_ItemCommand">
                                                                <HeaderTemplate>
                                                                    <ul class="list-group list-group-flush mb-2">
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                                        <span><%# Eval("GroupCode") %> — <%# Eval("GroupName") %></span>
                                                                        <asp:LinkButton runat="server" CommandName="Unmap" CommandArgument='<%# Eval("GroupId") %>' CssClass="btn btn-sm btn-outline-danger">Remove</asp:LinkButton>
                                                                    </li>
                                                                </ItemTemplate>
                                                                <FooterTemplate></ul></FooterTemplate>
                                                            </asp:Repeater>

                                                            <div class="input-group input-group-sm">
                                                                <asp:DropDownList ID="ddlAllGroups" runat="server" CssClass="form-select form-select-sm" />
                                                                <asp:Button ID="btnMapGroup" runat="server" CssClass="btn btn-outline-success" Text="Add Group" OnClick="btnMapGroup_Click" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </dx:ContentControl>
                                    </ContentCollection>
                                </dx:TabPage>
                            </TabPages>
                        </dx:ASPxPageControl>
                    </div>
                </div>
                </div>
 <%--       </ContentTemplate>
    </asp:UpdatePanel>--%>

</asp:Content>

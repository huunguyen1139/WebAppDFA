using DevExpress.Web;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.functions.approval
{
    public partial class ApprovalAdmin : Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // set SQRLibrary connection for every <asp:SqlDataSource> on the page
            ApplyMrpConnection(this);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }

            if (!IsPostBack)
            {
               
                BindDocTypes();

                BindAvailableUsers();
                BindAllGroups();
            }
            BindGroups();
            BindDocTypeGroups();
            
            
            LoadUserByGroup(SQRLibrary.ConvertToInt(hfGroupId.Value));
        }

        protected void gvFlow_DetailRowExpandedChanged(object sender, ASPxGridViewDetailRowEventArgs e)
        {
            var gvParent = (ASPxGridView)sender;
            var gvSteps = (ASPxGridView)gvParent.FindDetailRowTemplateControl(e.VisibleIndex, "gvSteps");

            int flowId = (int)gvParent.GetRowValues(e.VisibleIndex, "FlowId");
            if (gvSteps == null) return;
            gvSteps.DataSourceID = null;                  
            gvSteps.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp(
                 "SELECT * FROM APPROVAL_FlowSteps WHERE FlowId=@Flow",
                 new List<string>() { "@Flow" }, new List<object>() { flowId });
            gvSteps.DataBind();
        }
        private static void ApplyMrpConnection(Control root)
        {
            foreach (Control ctl in root.Controls)
            {
                if (ctl is SqlDataSource sds)
                {
                    
                    sds.ConnectionString = SQRLibrary.mrp_connection;
                }
                    
                if (ctl.HasControls())
                    ApplyMrpConnection(ctl);      
            }
        }

        protected void gvSteps_BeforePerformDataSelect(object sender, EventArgs e)
        {
            Session["FlowID"] = (sender as ASPxGridView).GetMasterRowKeyValue();
        }

        void BindAvailableUsers()
        {
            var dt = SQRLibrary.ReturnDatatablefromSQL_hr(
                "EXEC ALL_GetEmployeeList"
               );

            ddlAddUser.DataSource = dt;
            ddlAddUser.DataTextField = "EmployeeName";
            ddlAddUser.DataValueField = "EmployeeID";
            ddlAddUser.DataBind();
            ddlAddUser.Items.Insert(0, new ListItem("-- select user --", ""));
        }

        void BindGroups()
        {
            gvGroups.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroups_List", null, null);
            gvGroups.DataBind();
            //hfGroupId.Value = "";
            gvMembers.DataSource = null; gvMembers.DataBind();
        }

        void BindDocTypes()
        {
            ddlDocType.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT DocTypeId, Name FROM dbo.APPROVAL_DocumentTypes ORDER BY Name", null, null);
            ddlDocType.DataTextField = "Name";
            ddlDocType.DataValueField = "DocTypeId";
            ddlDocType.DataBind();
            if (ddlDocType.Items.Count > 0) BindDocTypeGroups();
        }

        void BindDocTypeGroups()
        {
            var dt = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_DocTypeNotifyGroup_List @dt",
                        new List<string>() { "@dt" }, new List<object>() { int.Parse(ddlDocType.SelectedValue) });
            rpDocTypeGroups.DataSource = dt;
            rpDocTypeGroups.DataBind();
        }

        void BindAllGroups()
        {
            ddlAllGroups.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroups_List", null, null);
            ddlAllGroups.DataTextField = "GroupCode";
            ddlAllGroups.DataValueField = "GroupId";
            ddlAllGroups.DataBind();
        }

        protected void gvGroups_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int groupId = (int)gvGroups.DataKeys[gvGroups.SelectedIndex].Value;
                hfGroupId.Value = groupId.ToString();

                // load to editor
                var row = ((DataRowView)gvGroups.SelectedRow.DataItem)?.Row; // may be null on postback; safe reload:
                var dt = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT * FROM dbo.APPROVAL_NotifyGroups WHERE GroupId=@g",
                            new List<string>() { "@g" }, new List<object>() { groupId });
                if (dt.Rows.Count > 0)
                {
                    txtGroupCode.Text = dt.Rows[0]["GroupCode"].ToString();
                    txtGroupName.Text = dt.Rows[0]["GroupName"].ToString();
                    chkGroupActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                }

                LoadUserByGroup(groupId);
            }
            catch { }
        }

        private void LoadUserByGroup(int groupId)
        {
            // members
            gvMembers.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroupMembers_List @g",
                        new List<string>() { "@g" }, new List<object>() { groupId });
            gvMembers.DataBind();
        }

        protected void btnNewGroup_ServerClick(object sender, EventArgs e)
        {
            hfGroupId.Value = "";
            txtGroupCode.Text = "";
            txtGroupName.Text = "";
            chkGroupActive.Checked = true;
        }

        protected void btnSaveGroup_Click(object sender, EventArgs e)
        {
            int? id = string.IsNullOrEmpty(hfGroupId.Value) ? (int?)null : int.Parse(hfGroupId.Value);
            SQRLibrary.ReturnDatatablefromSQL_mrp(
                "EXEC dbo.APPROVAL_NotifyGroups_Save @id,@code,@name,@active",
                new List<string>() { "@id", "@code", "@name", "@active" },
                new List<object>() { (object)id ?? DBNull.Value, txtGroupCode.Text.Trim(), txtGroupName.Text.Trim(), chkGroupActive.Checked });
            BindGroups(); BindAllGroups(); BindDocTypeGroups();
        }

        protected void btnDeleteGroup_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfGroupId.Value, out var id))
                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroups_Delete @g", new List<string>() { "@g" }, new List<object>() { id });
            BindGroups(); BindAllGroups(); BindDocTypeGroups();
        }

        protected void btnAddMember_Click(object sender, EventArgs e)
        {
            if (int.TryParse(hfGroupId.Value, out var id) && !string.IsNullOrWhiteSpace(ddlAddUser.SelectedValue))
            {
                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroupMembers_Add @g,@u",
                    new List<string>() { "@g", "@u" }, new List<object>() { id, ddlAddUser.SelectedValue.Trim() });
                gvGroups_SelectedIndexChanged(null, null);
                LoadUserByGroup(id);
            }
        }

        protected void gvMembers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveMember" && int.TryParse(hfGroupId.Value, out var id))
            {
                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroupMembers_Remove @g,@u",
                    new List<string>() { "@g", "@u" }, new List<object>() { id, e.CommandArgument.ToString() });
                gvGroups_SelectedIndexChanged(null, null);
            }
        }

        protected void ddlDocType_SelectedIndexChanged(object sender, EventArgs e) => BindDocTypeGroups();

        protected void btnMapGroup_Click(object sender, EventArgs e)
        {
            if (ddlDocType.Items.Count == 0 || ddlAllGroups.Items.Count == 0) return;
            SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_DocTypeNotifyGroup_Add @dt,@g",
                new List<string>() { "@dt", "@g" }, new List<object>() { int.Parse(ddlDocType.SelectedValue), int.Parse(ddlAllGroups.SelectedValue) });
            BindDocTypeGroups();
        }

        protected void rpDocTypeGroups_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Unmap")
            {
                SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_DocTypeNotifyGroup_Remove @dt,@g",
                    new List<string>() { "@dt", "@g" }, new List<object>() { int.Parse(ddlDocType.SelectedValue), int.Parse((string)e.CommandArgument) });
                BindDocTypeGroups();
            }
        }

        protected void gvMembers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            var row = gvMembers.Rows[e.RowIndex];
            

            int id = SQRLibrary.ConvertToInt(hfGroupId.Value);
            SQRLibrary.ReturnDatatablefromSQL_mrp("EXEC dbo.APPROVAL_NotifyGroupMembers_Remove @g,@u",
                    new List<string>() { "@g", "@u" }, new List<object>() { id, row.Cells[0].Text });
            LoadUserByGroup(id);
        }
    }
}
using Library;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WebApp.Account
{
    public partial class PermissionsGeneral : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
            if (!IsPostBack)
            {
                BindGrid();
            }
            //gvRoles.DataBind();

        }


        private void BindGrid()
        {
            // use the proc that returns MemberNames + MemberCount
            string sql = "EXEC dbo.POR_GeneralSetup_GetAll_WithNames";
            gv.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
            gv.DataBind();
        }

        protected void btnRefresh_Click(object sender, EventArgs e) => BindGrid();

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            hfMode.Value = "add";
            hfPermissionName_Orig.Value = "";
            txtPermissionName.Text = "";
            txtUsers.Text = "";
            ScriptManager.RegisterStartupScript(this, GetType(), "openModal", "openEditModal('add');", true);
        }

        protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditPerm")
            {
                string perm = e.CommandArgument as string ?? "";
                hfMode.Value = "edit";
                hfPermissionName_Orig.Value = perm;

                var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
                    "EXEC dbo.POR_GeneralSetup_Get @PermissionName",
                    new List<string> { "@PermissionName" },
                    new List<object> { perm });

                if (dt.Rows.Count > 0)
                {
                    txtPermissionName.Text = dt.Rows[0]["PermissionName"].ToString();
                    txtUsers.Text = dt.Rows[0]["PermissionUsers"].ToString();
                }
                else { txtPermissionName.Text = perm; txtUsers.Text = ""; }

                ScriptManager.RegisterStartupScript(this, GetType(), "openModal", "openEditModal('edit');", true);
            }
            else if (e.CommandName == "Manage")
            {
                string perm = e.CommandArgument as string ?? "";
                hfPermForMembers.Value = perm;
                ViewState["perm"] = perm;
                litPermTitle.Text = HttpUtility.HtmlEncode(perm);

                BindMembers();
                ClearSearch();
                ScriptManager.RegisterStartupScript(this, GetType(), "openMembers", "setTimeout(function() { openMembersModal();}, 1000)", true);
            }
        }

        protected void gv_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                string perm = gv.DataKeys[e.RowIndex]?.Value?.ToString() ?? "";
                if (!string.IsNullOrEmpty(perm))
                    SQRLibrary.ExecuteSQL_mrp("EXEC dbo.POR_GeneralSetup_Delete @PermissionName",
                        new List<string> { "@PermissionName" }, new List<object> { perm });
            }
            catch { }
            finally { e.Cancel = true; BindGrid(); }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string mode = hfMode.Value;
            string newName = (txtPermissionName.Text ?? "").Trim();
            string usersRaw = txtUsers.Text ?? "";

            if (string.IsNullOrWhiteSpace(newName))
            {
                ClientScript.RegisterStartupScript(GetType(), "msg", "alert('Permission Name is required.');", true);
                ScriptManager.RegisterStartupScript(this, GetType(), "reopen", $"openEditModal('{(mode == "add" ? "add" : "edit")}');", true);
                return;
            }

            string cleanUsers = CleanUsers(usersRaw);
            SQRLibrary.ExecuteSQL_mrp("EXEC dbo.POR_GeneralSetup_Upsert @PermissionName, @PermissionUsers, @Actor",
                new List<string> { "@PermissionName", "@PermissionUsers", "@Actor" },
                new List<object> { newName, cleanUsers, GetActor() });

            // handle rename
            if (mode == "edit")
            {
                string orig = (hfPermissionName_Orig.Value ?? "").Trim();
                if (!string.IsNullOrEmpty(orig) && !orig.Equals(newName, StringComparison.OrdinalIgnoreCase))
                    SQRLibrary.ExecuteSQL_mrp("EXEC dbo.POR_GeneralSetup_Delete @PermissionName",
                        new List<string> { "@PermissionName" }, new List<object> { orig });
            }

            BindGrid();
        }

        // ===== Manage members =====

        private void BindMembers()
        {
            string perm = ViewState["perm"]?.ToString() ?? "";
            gvMembers.DataSource = SQRLibrary.ReturnDatatablefromSQL_mrp(
                "EXEC dbo.POR_GeneralSetup_GetMembers @PermissionName",
                new List<string> { "@PermissionName" }, new List<object> { perm });
            gvMembers.DataBind();
        }

        private void BindSearch()
        {
            BindEmployeeDropdown();
        }

        private void ClearSearch()
        {
            BindEmployeeDropdown();
        }

        protected void btnSearchEmp_Click(object sender, EventArgs e) => BindSearch();

        protected void gvEmpSearch_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "AddEmp")
            {
                string perm = hfPermForMembers.Value;
                int empId = Convert.ToInt32(e.CommandArgument);
                SQRLibrary.ExecuteSQL_mrp("EXEC dbo.POR_GeneralSetup_AddEmployee @PermissionName, @EmployeeID, @Actor",
                    new List<string> { "@PermissionName", "@EmployeeID", "@Actor" },
                    new List<object> { perm, empId, GetActor() });

                BindMembers();
                BindSearch();       // refresh search to exclude added
                BindGrid();         // refresh main grid count/names
                ScriptManager.RegisterStartupScript(this, GetType(), "openMembers", "openMembersModal();", true);
            }
        }

        protected void gvMembers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RemoveEmp")
            {
                string perm = hfPermForMembers.Value;
                perm = ViewState["perm"]?.ToString() ?? "";
                string empId = e.CommandArgument.ToString();
                SQRLibrary.ExecuteSQL_mrp("EXEC dbo.POR_GeneralSetup_RemoveEmployee @PermissionName, @EmployeeID, @Actor",
                    new List<string> { "@PermissionName", "@EmployeeID", "@Actor" },
                    new List<object> { perm, empId, GetActor() });

                BindMembers();
                BindEmployeeDropdown();                
                BindGrid();
                ScriptManager.RegisterStartupScript(this, GetType(), "openMembers", "openMembersModal();", true);
            }
        }

        private void BindEmployeeDropdown()
        {
            string perm = hfPermForMembers.Value;
            bool includeExisting = chkShowAll.Checked;

            var dt = SQRLibrary.ReturnDatatablefromSQL_mrp(
                "EXEC dbo.POR_GeneralSetup_GetEmployeesForDropdown @PermissionName, @IncludeExisting",
                new List<string> { "@PermissionName", "@IncludeExisting" },
                new List<object> { perm, includeExisting ? 1 : 0 });

            ddlEmployees.Items.Clear();
            ddlEmployees.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select employee --", ""));
            ddlEmployees.DataSource = dt;
            ddlEmployees.DataBind();
        }

        protected void chkShowAll_CheckedChanged(object sender, EventArgs e)
        {
            BindEmployeeDropdown();
            // keep the modal open
            ScriptManager.RegisterStartupScript(this, GetType(), "openMembers", "openMembersModal();", true);
        }

        protected void btnAddSelected_Click(object sender, EventArgs e)
        {
            string perm = ViewState["perm"]?.ToString()?? "";
            if (string.IsNullOrWhiteSpace(perm))
            {
                // safety: modal was not initialized
                return;
            }

            if (string.IsNullOrWhiteSpace(ddlEmployees.SelectedValue))
            {
                ClientScript.RegisterStartupScript(GetType(), "msg", "alert('Please select an employee.');", true);
                ScriptManager.RegisterStartupScript(this, GetType(), "openMembers", "openMembersModal();", true);
                return;
            }

            string empId = ddlEmployees.SelectedValue;

            // Add (proc handles duplicates safely)
            SQRLibrary.ExecuteSQL_mrp(
                "EXEC dbo.POR_GeneralSetup_AddEmployee @PermissionName, @EmployeeID, @Actor",
                new List<string> { "@PermissionName", "@EmployeeID", "@Actor" },
                new List<object> { perm, empId, GetActor() });

            // Refresh members list, dropdown (to exclude newly added), and main grid count/names
            BindMembers();
            BindEmployeeDropdown();
            BindGrid();

            // keep modal open
            ScriptManager.RegisterStartupScript(this, GetType(), "openMembers", "openMembersModal();", true);
        }

        // ===== helpers =====

        private string CleanUsers(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return "";
            var parts = (input ?? "")
                .Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(s => (s ?? "").Trim())
                .Where(s => s.Length > 0)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(s => s, StringComparer.OrdinalIgnoreCase)
                .ToList();
            return string.Join(";", parts);
        }


        private string GetActor()
        {
            try
            {
                return Session["username"]?.ToString() ?? "";
            }
            catch { return "SYSTEM"; }
        }


    }
}

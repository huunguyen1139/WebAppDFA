using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using System.Web.UI.HtmlControls;
using System.Drawing;
using DevExpress.Web.Internal.XmlProcessor;
using DevExpress.Web;
using DevExpress.RichEdit.Export;

namespace WebApp.production
{
    public partial class ProductionOutputSetup : SecurePage
    {
        private const string WINDOW_NAME = "PostProductionOutput";
        private bool canAccess()
        {
            return SecurePage.IsUserInAnyRole(Session["userid"].ToString(),
                    new string[] { "Admin", "SYSTEM ADMIN", "DEPARTMENT - Factory Admin" });
         }

                
        protected void Page_PreInit(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";            
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            //cbLastUpdateInfo.InputAttributes["class"] = "form-check-input ";
            //cbOrderedAmount.InputAttributes["class"] = "form-check-input";
            //cbProjectAmount.InputAttributes["class"] = "form-check-input";
            //cbRemark.InputAttributes["class"] = "form-check-input";
            //cbShowAllRecord.InputAttributes["class"] = "form-check-input";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }

            LoadGrid();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            ClearPopup();
            pcEdit.HeaderText = "Add Post Production Output Window";
            pcEdit.ShowOnPageLoad = true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (deAllowFrom.Value == null || deAllowTo.Value == null)
                {
                    ShowMessage("Allow From and Allow To are required.");
                    pcEdit.ShowOnPageLoad = true;
                    return;
                }

                DateTime allowFrom = Convert.ToDateTime(deAllowFrom.Value);
                DateTime allowTo = Convert.ToDateTime(deAllowTo.Value);

                if (allowFrom > allowTo)
                {
                    ShowMessage("Allow From cannot be greater than Allow To.");
                    pcEdit.ShowOnPageLoad = true;
                    return;
                }

                int? windowId = null;
                if (!string.IsNullOrWhiteSpace(hfWindowID.Value))
                    windowId = Convert.ToInt32(hfWindowID.Value);

                if (HasOverlap(windowId, allowFrom, allowTo))
                {
                    ShowMessage("This datetime range overlaps with another existing PostSiteOutput window.");
                    pcEdit.ShowOnPageLoad = true;
                    return;
                }

                string sql = @"
                EXEC dbo.ALL_SYS_PostSiteOutputWindow_Save
                    @WindowID,
                    @AllowFrom,
                    @AllowTo,
                    @IsActive,
                    @Remark,
                    @UserID,
                    @WindowName";

                SQRLibrary.ExecuteSQL(
                    sql,
                    new List<string> {
                        "@WindowID",
                        "@AllowFrom",
                        "@AllowTo",
                        "@IsActive",
                        "@Remark",
                        "@UserID",
                        "@WindowName"
                    },
                    new List<object> {
                        (object)windowId ?? DBNull.Value,
                        allowFrom,
                        allowTo,
                        cboIsActive.Value != null && cboIsActive.Value.ToString() == "1",
                        string.IsNullOrWhiteSpace(memoRemark.Text) ? (object)DBNull.Value : memoRemark.Text.Trim(),
                        Session["userid"].ToString(),
                        WINDOW_NAME
                    }
                );

                LoadGrid();
                ShowMessage("Saved successfully.");
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message.Replace("'", ""));
                pcEdit.ShowOnPageLoad = true;
            }
        }


        protected void cpEdit_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            try
            {
                string param = e.Parameter ?? "";

                if (param.StartsWith("EDIT|"))
                {
                    string idText = param.Substring("EDIT|".Length);
                    int windowId = Convert.ToInt32(idText);

                    ClearPopup();
                    LoadRow(windowId);

                    cpEdit.JSProperties["cpShowPopup"] = "1";
                }
                else if (param == "ADD")
                {
                    ClearPopup();
                    cpEdit.JSProperties["cpShowPopup"] = "1";
                }
                else if (param.StartsWith("ACTIVE|"))
                {
                    string idText = param.Substring("ACTIVE|".Length);
                    int windowId = Convert.ToInt32(idText);
                                                          

                    string sql = @"
                    UPDATE dbo.Custom_DateAllowPost
                    SET
                        IsActive = CASE 
                                      WHEN IsActive = 1 THEN 0 
                                      ELSE 1 
                                   END,
                        ModifiedBy = @UserID,
                        ModifiedAt = SYSDATETIME()
                    WHERE 
                        WindowID = @WindowID
                        AND WindowName = @WindowName;";

                    SQRLibrary.ExecuteSQL(
                        sql,
                        new List<string> { "@UserID", "@WindowID", "@WindowName" },
                        new List<object> {
                            Session["userid"].ToString(),
                            windowId,
                            WINDOW_NAME
                        }
                    );

                    LoadGrid();
                    cpEdit.JSProperties["cpShowPopup"] = "0";
                    cpEdit.JSProperties["cpMessage"] = "OK";
                }
            }
            catch (Exception ex)
            {
                cpEdit.JSProperties["cpMessage"] = ex.Message.Replace("'", "").Replace("\r", " ").Replace("\n", " ");
            }
        }

        protected void gvSetup_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            try
            {
                int windowId = Convert.ToInt32(gvSetup.GetRowValues(e.VisibleIndex, "WindowID"));

                if (e.ButtonID == "btnEdit")
                {
                    LoadRow(windowId);
                    pcEdit.HeaderText = "Edit Post Site Output Window";
                    pcEdit.ShowOnPageLoad = true;
                }
                else if (e.ButtonID == "btnToggle")
                {
                    object currentObj = gvSetup.GetRowValues(e.VisibleIndex, "IsActive");
                    bool currentIsActive = currentObj != DBNull.Value && Convert.ToBoolean(currentObj);
                    bool newIsActive = !currentIsActive;

                    string sql = @"
                    UPDATE dbo.Custom_DateAllowPost
                    SET
                        IsActive = CASE 
                                      WHEN IsActive = 1 THEN 0 
                                      ELSE 1 
                                   END,
                        ModifiedBy = @UserID,
                        ModifiedAt = SYSDATETIME()
                    WHERE 
                        WindowID = @WindowID
                        AND WindowName = @WindowName;";

                    SQRLibrary.ExecuteSQL(
                        sql,
                        new List<string> { "@UserID", "@WindowID", "@WindowName" },
                        new List<object> {                           
                            Session["userid"].ToString(),
                            windowId,
                            WINDOW_NAME
                        }
                    );

                    LoadGrid();
                    ShowMessage("Status updated successfully.");
                }
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message.Replace("'", ""));
            }
        }

        protected void gvSetup_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "StatusText")
            {
                string text = Convert.ToString(e.CellValue);
                if (text == "Active")
                    e.Cell.Text = "<span class='status-pill active'>Active</span>";
                else
                    e.Cell.Text = "<span class='status-pill inactive'>Inactive</span>";
            }
        }

        private void LoadGrid()
        {
            string sql = @"
            SELECT
                WindowID,
                AllowFrom,
                AllowTo,
                IsActive,
                Remark,
                CreatedBy,
                CreatedAt,
                ModifiedBy,
                ModifiedAt
            FROM dbo.Custom_DateAllowPost
            WHERE WindowName = @WindowName
            ORDER BY AllowFrom DESC, WindowID DESC";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@WindowName" },
                new List<object> { WINDOW_NAME }
            );

            if (!dt.Columns.Contains("StatusText"))
                dt.Columns.Add("StatusText", typeof(string));

            foreach (DataRow row in dt.Rows)
            {
                bool isActive = row["IsActive"] != DBNull.Value && Convert.ToBoolean(row["IsActive"]);
                row["StatusText"] = isActive ? "Active" : "Inactive";
            }

            gvSetup.DataSource = dt;
            gvSetup.DataBind();

            BindSummary(dt);

            pcEdit.ShowOnPageLoad = false;
        }

        private void BindSummary(DataTable dt)
        {
            lblTotalRows.Text = dt.Rows.Count.ToString();
            lblActiveRows.Text = dt.AsEnumerable().Count(r => r["IsActive"] != DBNull.Value && Convert.ToBoolean(r["IsActive"])).ToString();

            DateTime now = DateTime.Now;
            txtServerTime.Text = now.ToString("yyyy-MM-dd HH:mm");

            DataRow activeNow = dt.AsEnumerable()
                .FirstOrDefault(r =>
                    r["IsActive"] != DBNull.Value &&
                    Convert.ToBoolean(r["IsActive"]) &&
                    r["AllowFrom"] != DBNull.Value &&
                    r["AllowTo"] != DBNull.Value &&
                    now >= Convert.ToDateTime(r["AllowFrom"]) &&
                    now <= Convert.ToDateTime(r["AllowTo"])
                );

            if (activeNow != null)
            {
                lblCurrentWindow.Text =
                    Convert.ToDateTime(activeNow["AllowFrom"]).ToString("MM-dd HH:mm")
                    + " → " +
                    Convert.ToDateTime(activeNow["AllowTo"]).ToString("MM-dd HH:mm");
            }
            else
            {
                lblCurrentWindow.Text = "Locked";
            }
        }

        private void LoadRow(int windowId)
        {
            string sql = @"
            SELECT TOP 1
                WindowID,
                AllowFrom,
                AllowTo,
                IsActive,
                Remark
            FROM dbo.Custom_DateAllowPost
            WHERE WindowID = @WindowID
              AND WindowName = @WindowName";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@WindowID", "@WindowName" },
                new List<object> { windowId, WINDOW_NAME }
            );

            if (dt.Rows.Count == 0)
            {
                ShowMessage("Record not found.");
                return;
            }

            DataRow r = dt.Rows[0];

            hfWindowID.Value = r["WindowID"].ToString();
            deAllowFrom.Value = r["AllowFrom"] == DBNull.Value ? null : (object)Convert.ToDateTime(r["AllowFrom"]);
            deAllowTo.Value = r["AllowTo"] == DBNull.Value ? null : (object)Convert.ToDateTime(r["AllowTo"]);
            cboIsActive.Value = r["IsActive"] != DBNull.Value && Convert.ToBoolean(r["IsActive"]) ? "1" : "0";
            memoRemark.Text = r["Remark"] == DBNull.Value ? "" : Convert.ToString(r["Remark"]);
            txtServerTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm");
        }

        private void ClearPopup()
        {
            hfWindowID.Value = "";
            deAllowFrom.Value = DateTime.Now;
            deAllowTo.Value = DateTime.Now.AddDays(1);
            cboIsActive.Value = "1";
            memoRemark.Text = "";
            txtServerTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm");
        }

        private bool HasOverlap(int? currentWindowId, DateTime allowFrom, DateTime allowTo)
        {
            string sql = @"
            SELECT TOP 1 1
            FROM dbo.Custom_DateAllowPost
            WHERE WindowName = @WindowName
              AND WindowID <> @WindowID
              AND AllowFrom <= @AllowTo
              AND AllowTo >= @AllowFrom";

            object currentId = currentWindowId.HasValue ? (object)currentWindowId.Value : 0;

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@WindowName", "@WindowID", "@AllowTo", "@AllowFrom" },
                new List<object> { WINDOW_NAME, currentId, allowTo, allowFrom }
            );

            return dt.Rows.Count > 0;
        }

        private void ShowMessage(string message)
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                Guid.NewGuid().ToString(),
                "alert('" + message.Replace("'", "").Replace("\r", " ").Replace("\n", " ") + "');",
                true
            );
        }
    }
}
using DevExpress.Utils.Filtering.Internal;
using DevExpress.Web;
using Library;
using Newtonsoft.Json.Linq;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApp.functions.approval;

namespace WebApp.production
{
    public partial class SubcontractingRequest : System.Web.UI.Page
    {
        private string RequestId
        {
            get
            {
                if (ViewState["RequestId"] == null)
                    ViewState["RequestId"] = (Request.QueryString["RequestID"] ?? ".").Trim();
                return (string)ViewState["RequestId"];
            }
            set { ViewState["RequestId"] = value; }
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
                LoadHeader();
                gvLines.DataBind();

                ApprovalService.SetInfoToApprovalControl(
                    control: ApprovalFlow1,
                    WebApp.Models.Enum.ApprovalEnum.ApprovalDocumentType.Factory_Subcontracting_Request,
                    Request["RequestID"]?.ToString() ?? "",
                    $"Factory Subcontracting Request {Request["RequestID"]?.ToString() ?? ""}",
                    "",
                    ViewState["DocDes"]?.ToString() ?? ""
                    );
            }
            
        }
        private void SetHeaderTitle(string requestId, string status)
        {
            lblHeaderRequestID.Text = string.IsNullOrWhiteSpace(requestId) ? "(New)" : requestId;

            string badgeClass = status switch
            {
                "Open" => "bg-primary",
                "Released" => "bg-info text-dark",
                "Completed" => "bg-success",
                "Canceled" => "bg-secondary",
                _ => "bg-dark"
            };

            spanStatus.Attributes["class"] = $"badge fs-6 {badgeClass}";
            spanStatus.InnerHtml = status;
        }


        #region Data load

        private void LoadHeader()
        {
            if (string.IsNullOrEmpty(RequestId))
            {
                SetHeaderTitle("", "Open");
                return;
            }

            string sql = $@"SELECT [RequestID]
                              ,[Requestor]
                              ,[RequestDate]
                              ,[NeedDate]
                              ,[Description]
                              ,(CASE 		
			                        WHEN [Status] = 0 THEN 'Open'
			                        WHEN [Status] = 1 THEN 'Released'
			                        WHEN [Status] = 2 THEN 'Pending'										                        
			                        ELSE 'Undefined'			   
		                        END) [Status]
                              ,[Remark]
                          FROM [ALL_NAV_90].[dbo].[Custom_SubcontracingRequest]

                        WITH (NOLOCK)
                        WHERE RequestID = @RequestID
                        ORDER BY RequestID desc;";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
               new List<string> { "@RequestID" },
                new List<object> { RequestId });

            if (dt.Rows.Count == 0)
                return;

            DataRow r = dt.Rows[0];

            txtRequestID.Text = r["RequestID"].ToString();
            txtRequestor.Text = r["Requestor"].ToString();
            txtDescription.Text = r["Description"].ToString();
            txtRemark.Text = r["Remark"].ToString();

            ViewState["DocDes"] = $"{r["RequestID"].ToString()} - {r["Description"].ToString()}";

            if (DateTime.TryParse(r["RequestDate"].ToString(), out DateTime rd))
                txtRequestDate.Text = rd.ToString("yyyy-MM-dd");

            if (DateTime.TryParse(r["NeedDate"].ToString(), out DateTime nd))
                txtNeedDate.Text = nd.ToString("yyyy-MM-dd");

            string status = r["Status"].ToString();
            if (ddlStatus.Items.FindByValue(status) != null)
                ddlStatus.SelectedValue = status;

            // Update header UI
            SetHeaderTitle(txtRequestID.Text, status);
        }



        private DataTable LoadLines()
        {
            if (string.IsNullOrEmpty(RequestId))
                return new DataTable();

            string sql = $@"EXEC [ALL_PRODUCTION_GetSubcontractingRequestList] @RequestID;";

            DataTable dt =  SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@RequestID" },
                new List<object> { RequestId });

            return dt;
        }

        protected void gvLines_DataBinding(object sender, EventArgs e)
        {
            gvLines.DataSource = LoadLines();
        }

        #endregion

        #region Buttons

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadHeader();
            gvLines.DataBind();
        }

        protected void btnNew_Click(object sender, EventArgs e)
        {
            // Clear header fields for new document
            RequestId = string.Empty;
            txtRequestID.Text = string.Empty;
            txtRequestor.Text = User.Identity.Name;  // or your own logic
            txtRequestDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtNeedDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtDescription.Text = string.Empty;
            txtRemark.Text = string.Empty;
            ddlStatus.SelectedValue = "Open";

            gvLines.DataSource = null;
            gvLines.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Here you call your stored procedures using SQRLibrary
            // 1. Save header
            // 2. Save lines (from another page/grid editing or separate popup)
            // For now this is just a placeholder.

            // Example header save (pseudo):
            /*
            SQRLibrary.ExecuteNonQuery("EXEC SUB_RequestHeader_Save @RequestID, @Requestor, ...",
                new SqlParameter("@RequestID", txtRequestID.Text.Trim()),
                new SqlParameter("@Requestor", txtRequestor.Text.Trim()),
                ...
            );
            */

            // After save: reload to show latest
            LoadHeader();
            gvLines.DataBind();
        }

        protected void btnAddLine_Click(object sender, EventArgs e)
        {
            // Open popup or redirect to line-edit page
            // This is only a placeholder hook.
        }

        protected void btnDeleteLine_Click(object sender, EventArgs e)
        {
            // Loop selected rows and call delete SP for each line
            // (pseudo code)
            /*
            var selectedKeys = gvLines.GetSelectedFieldValues("No_");
            foreach (object key in selectedKeys)
            {
                SQRLibrary.ExecuteNonQuery("EXEC SUB_RequestLine_Delete @RequestID, @No_",
                    new SqlParameter("@RequestID", RequestId),
                    new SqlParameter("@No_", key.ToString()));
            }
            gvLines.DataBind();
            */
        }

        protected void btnBestFit_Click(object sender, EventArgs e)
        {
            
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            // Usually use ASPxGridViewExporter here.
            // e.g. ASPxGridViewExporter1.WriteXlsxToResponse("SubRequestLines");
        }

        #endregion

        #region Control Even
        protected void btnDeleteRequest_Click(object sender, EventArgs e)
        {
            try
            {
                //string DocumentNo = Request["no"]?.ToString() ?? "";
                //string sql1 = "select No_, LastUpdatedUser, [Status] from [LIVE_ALLIANCE_90$Sales Header] where No_ = @FactoryOrder";
                //DataTable dt1 = SQRLibrary.ReturnDatatablefromSQL(sql1, new List<string>() { "@FactoryOrder" }, new List<object>() { DocumentNo });
                //if (dt1 == null || dt1.Rows.Count == 0) return;

                //if (!(dt1.Rows[0]["LastUpdatedUser"].ToString().Split(':')[0] == Session["userid"].ToString() || Session["userid"].ToString() == "20276"))
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup"
                //        , $"ShowPopup('POR System', 'You do not have permission to delete this order!', 'bg-danger');", true);
                //    return;
                //}

                //if (dt1.Rows[0]["Status"].ToString() != "0")
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup1", $"ShowPopup('POR System', 'Status must be Open! You can not delete Released Order', 'bg-danger');", true);
                //    return;
                //}

                //string sql = $"EXEC ALL_FactoryAndSiteOrderLine_Delete @OrderNo, 0, 1";
                //DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@OrderNo" }, new List<object>() { DocumentNo });

                //if (dt.Rows.Count > 0 && dt.Rows[0][0].ToString() == "0")
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup"
                //        , $"ShowPopup('POR System', 'At least one production order is linked with this line! You can not delete it, please cancel the related production order first!', 'bg-danger');", true);
                //    return;
                //}
                //else
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup"
                //        , $"ShowPopup('POR System', '{dt.Rows[0][1].ToString()}', 'bg-success');", true);
                    
                //}

            }
            catch (Exception ex) { ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{ex.Message}', 'bg-danger');", true); }
        }

        protected void ApprovalFlow1_StatusChanged(object sender, EventArgs e)
        {
            LoadHeader();
        }

        protected void linkChangeStatusReleased_Click(object sender, EventArgs e)
        {
            //try
            //{
            //    if (Session["userid"].ToString() != "20276")
            //    {
            //        ScriptManager.RegisterStartupScript(this, this.GetType()
            //            , "Popup", $"ShowPopup('POR System', 'Can not change status to Released. Please send approval', 'bg-danger');", true);

            //        return;
            //    }

            //    string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";
            //    string sql1 = "select No_, LastUpdatedUser, [Status] from [LIVE_ALLIANCE_90$Sales Header] where No_ = @FactoryOrder";
            //    DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql1, new List<string>() { "@FactoryOrder" }, new List<object>() { FactoryOrder });

            //    //if (dt.Rows[0]["LastUpdatedUser"].ToString().Split(':')[0] != Session["userid"].ToString())
            //    //{
            //    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to change order status for project {ViewState["ProjectCode"].ToString()}!', 'bg-danger');", true);

            //    //    return;
            //    //}                

            //    if (dt.Rows[0]["Status"].ToString() != "0")
            //    {
            //        ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Open!', 'bg-danger');", true);
            //        return;
            //    }
            //    string sql = "UPDATE [LIVE_ALLIANCE_90$Sales Header] SET Status = 1 WHERE [Document Type] = 7 and No_ = @No_";
            //    SQRLibrary.ExecuteSQL(sql
            //        , new List<string>() { "@No_" }
            //        , new List<object> { FactoryOrder });

            //    ViewState["Status"] = "1";
            //    hdnStatus.Value = "1";
            //    UpdateHeaderText(FactoryOrder);
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Successfully updated!', 'bg-success');", true);
            //}
            //catch { }
        }


        protected void linkChangeStatusOpen_Click(object sender, EventArgs e)
        {
            try
            {
                //string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";

                //string sql1 = "select No_, LastUpdatedUser, [Status] from [LIVE_ALLIANCE_90$Sales Header] where No_ = @FactoryOrder";
                //DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql1, new List<string>() { "@FactoryOrder" }, new List<object>() { FactoryOrder });
                //if (dt == null || dt.Rows.Count == 0) return;

                //if (!(dt.Rows[0]["LastUpdatedUser"].ToString().Split(':')[0] == Session["userid"].ToString() || Session["userid"].ToString() == "20276"))
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to change order status for project {ViewState["ProjectCode"].ToString()}!', 'bg-danger');", true);

                //    return;
                //}
                ////if (!isHasPermissionOnProject())
                ////{
                ////    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to change order status for project {ViewState["ProjectCode"].ToString()}!', 'bg-danger');", true);
                ////    return;
                ////}

                //if (dt.Rows[0]["Status"].ToString() != "1")
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Released!', 'bg-danger');", true);
                //    return;
                //}
                //string sql = "UPDATE [LIVE_ALLIANCE_90$Sales Header] SET Status = 0 WHERE [Document Type] = 7 and No_ = @No_";
                //SQRLibrary.ExecuteSQL(sql
                //    , new List<string>() { "@No_" }
                //    , new List<object> { FactoryOrder });

                //ViewState["Status"] = "0";
                //hdnStatus.Value = "0";
                //UpdateHeaderText(FactoryOrder);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Successfully updated!', 'bg-success');", true);
            }
            catch { }
        }
        #endregion
    }
}
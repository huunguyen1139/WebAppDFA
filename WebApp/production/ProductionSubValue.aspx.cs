using DevExpress.Web;
using Library;
using Newtonsoft.Json.Linq;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.production
{
    public partial class ProductionSubValue : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            cbFullRevenue.InputAttributes["class"] = "form-check-input ";
            cbProductName.InputAttributes["class"] = "form-check-input";
            cbProjectCode.InputAttributes["class"] = "form-check-input";
            cbProjectName.InputAttributes["class"] = "form-check-input";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            if (!IsPostBack)
            {
                fromDate.Text = DateTime.Now.Date.ToString("yyyy-MM-dd");
                toDate.Text = DateTime.Now.Date.ToString("yyyy-MM-dd");               
            }
            LoadGridData();
        }

        private void LoadGridData()
        {
            try
            {               
                string department = ddDepartment.SelectedValue;              

                department = department == null ? "" : department;
               

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                "EXEC [ALL_OUTPUT_GetProductionSUBOutputDetailWithRevenue] @FromDate, @ToDate, @Department",
                new List<string> { "@FromDate", "@ToDate", "@Department" },
                new List<object> { fromDate.Text, toDate.Text, department }
                );

                gridProductionOutput.DataSource = dt;
                gridProductionOutput.DataBind();

                //gridProductionOutput.Columns["FullRevenue"].Visible = cbFullRevenue.Checked;
                //gridProductionOutput.Columns["FullName"].Visible = cbProductName.Checked;
                //gridProductionOutput.Columns["ProjectCode"].Visible = cbProjectCode.Checked;
                //gridProductionOutput.Columns["ProjectName"].Visible = cbProjectName.Checked;
            }
            catch (Exception ex)
            {                
                throw new Exception("Error loading grid data: " + ex.Message);
            }
        }

        protected void btnLoadData_Click(object sender, EventArgs e)
        {
            LoadGridData();
        }
        protected void gridProductionOutput_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            var grid = sender as ASPxGridView;
            var h = e.Parameters.Split('|');
            string CommandName = h[0];
            string CommandValue = h[1];
            
            if (CommandName == "delete1")
            {
                try
                {
                    int rowIndex = SQRLibrary.ConvertToInt(CommandValue);
                    
                    DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_DeleteProductionOutputDetailByRowIndex] @RowIndex",
                        new List<string> { "@RowIndex" },
                        new List<object> { rowIndex }
                    );
                    if (dt.Rows.Count <= 0) return;

                    if (dt.Rows[0]["Status"].ToString().Equals("1"))
                    {
                        // Set success message for client-side
                        grid.JSProperties["cpDeleteMessage"] = new
                        {
                            success = true,
                            message = dt.Rows[0]["Message"].ToString()
                        };
                    }
                    else
                    {
                        grid.JSProperties["cpDeleteMessage"] = new
                        {
                            success = false,
                            message = dt.Rows[0]["Message"].ToString()
                        };
                    }
                }
                catch (Exception ex)
                {
                    // Set error message for client-side
                    grid.JSProperties["cpDeleteMessage"] = new
                    {
                        success = false,
                        message = "Error: " + ex.Message
                    };
                }                
                LoadGridData();
            }
        }

        protected void gridProductionOutput_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.Visible >= 0 && e.ButtonID == "btnDelete1")
            {                
                bool AllowTimeDelete = gridProductionOutput.GetRowValues(e.VisibleIndex, "AllowTimeDelete").ToString().Equals("1");
                string Department = gridProductionOutput.GetRowValues(e.VisibleIndex, "Department").ToString();
                
                if (AllowTimeDelete)
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.True;
                }
                else e.Visible = DevExpress.Utils.DefaultBoolean.False;
            }
        }
    }

}

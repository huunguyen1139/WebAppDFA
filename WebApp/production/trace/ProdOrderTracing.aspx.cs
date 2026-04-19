using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace WebApp.production
{
    public partial class ProdOrderTracing : System.Web.UI.Page
    {
        private const string ERP_ROOT_PHYSICAL = @"D:\alliance_new\ERP\";
        private const string ERP_ROOT_HTTPS = "https://alliancevn.company/";
        private string userId => Session["userid"]?.ToString() ?? "";
        public bool CanUpload => SecurePage.IsUserInAnyRole(userId
            , new[] { 
                "DEPARTMENT - Factory Production SUP",
                "DEPARTMENT - Factory Planning",
                "DEPARTMENT - Factory Admin",
                "Admin"
            });
        public bool CanDelete => SecurePage.IsUserInAnyRole(userId
            , new[] {               
                "DEPARTMENT - Factory Planning",
                "DEPARTMENT - Factory Admin",
                "Admin1"
            });
        public bool CanReorder => SecurePage.IsUserInAnyRole(userId
            , new[] {                
                "DEPARTMENT - Factory Planning",
                "DEPARTMENT - Factory Admin"
            });

        private static readonly string[] Route = new[]
        {
            "WO","RM","FM","AS","SA","IRON","FIN","UPH","FIT","PAC"
        };
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
            ApplyImagePermissionUI();
            ApplySubOutputPermissionUI();
            ApplyOutputViewUI();

            if (!IsPostBack)
            {
                hfOutputView.Value = "GROUP";
                txtInputDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                
                LoadOutputHistory();

                LoadSubDeliveryToControl();
                LoadProdOrderImages();

            }
            


        }

        private void LoadSubDeliveryToControl()
        {
            try
            {
                string ProdOrderNo = Request["No"]?.ToString()?? "";

                string sql = " select No_, po.Description, [Source No_], format(Quantity, '#0.#') as Quantity, po.SalePrice"
                            + ", tf.Description [TimberFinish], lf.Description [MetalFinish], ISNULL(co.RoundingInterval, 1) RoundingInterval from [LIVE_ALLIANCE_90$Production Order] po "
                            + " left join [LIVE_ALLIANCE_90$Timber Finish] tf ON tf.Code= po.[Timber Finish]"
                            + " left join [LIVE_ALLIANCE_90$Leg Finish] lf on lf.Code = po.[Metal_Fab Finish]"
                            + " LEFT JOIN Custom_OutputRoundingPrecision co on co.ProdOrderNo = po.No_"
                            + " where No_ =@ProdOrderNo";

                DataTable ProdOrderList = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@ProdOrderNo" }, new List<object>() { ProdOrderNo });

                if (ProdOrderList == null || ProdOrderList.Rows.Count <= 0) return;
                DataRow r = ProdOrderList.Rows[0];
                decimal RoundingInterval = SQRLibrary.ConvertToDecimal(r["RoundingInterval"]);
                decimal Quantity = SQRLibrary.ConvertToDecimal(r["Quantity"]);
                //lbItemCode.Text = "Item Code: " + r["Source No_"].ToString();
                //lbQuantity.Text = "Quantity: " + r["Quantity"].ToString();
                //lbTimberFinish.Text = "Timber Finish: " + r["TimberFinish"].ToString();
                //lbMetalFinish.Text = "Metal Finish: " + r["MetalFinish"].ToString();

                hfSalePrice.Value = r["SalePrice"].ToString();
                hfProdOrderQty.Value = r["Quantity"].ToString();
                hfRoundingInterval.Value = r["RoundingInterval"].ToString();

                //lbtRounding.Text = $"Rounding Interval: {RoundingInterval.ToString("#0.##")}";

                FillOutputQuantityForAllDepartment(ProdOrderNo, Quantity);
                FillRemainingOutputQtyToDropDownForAllDept(ProdOrderNo, Quantity, RoundingInterval);

            }
            catch { }
        }

        protected void bt1_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime date = DateTime.ParseExact(txtInputDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                if (date > DateTime.Now)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Vui lòng kiểm tra lại ngày giao hàng!','bg-danger');", true);
                    return;
                }
                
                string ProdOrderNo = Request["No"]?.ToString() ?? ""; 

                //string sqlUpdatePC = "exec UpdateProdOrderStatus '" + ddItemCode.SelectedValue + "'";
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                string sql = @"EXEC [ALL_InsertProductionSubOutputDetail]
                    @ProdOrderNo, @Department, @ToDepartment, 
                    @Quantity, @Price, @ProdOrderDate, @UpdatedUser, @UpdatedUserID";
                
                string[] prefixes = { "RM-BOARD", "RM-TIMBER", "FM-BOARD", "FM-TIMBER" };
                var parameters = new List<string>
                    {
                        "@ProdOrderNo",
                        "@Department",
                        "@ToDepartment",
                        "@Quantity",
                        "@Price",
                        "@ProdOrderDate",
                        "@UpdatedUser",
                        "@UpdatedUserID"
                    };
                int count = 0;
                List<string> successDept = new List<string>() { };
                DataTable dt = new DataTable();
                foreach (string prefix in prefixes)
                {
                    try
                    {
                        DropDownList fromDropDown = huu1.FindControl($"dd{prefix.Replace("-", "")}") as DropDownList;
                        DropDownList toDropDown = huu1.FindControl($"to{prefix.Replace("-", "")}") as DropDownList;
                        if (fromDropDown != null && toDropDown != null)
                        {
                            // Check if both dropdowns have a selected value
                            bool fromHasValue = !string.IsNullOrEmpty(fromDropDown.SelectedValue);
                            bool toHasValue = !string.IsNullOrEmpty(toDropDown.SelectedValue);

                            if (fromHasValue && toHasValue)
                            {
                                //do insert
                                if (SQRLibrary.ConvertToDecimal(fromDropDown.SelectedValue) <= 0) continue;
                                var values = new List<object>
                                {
                                    ProdOrderNo,
                                    prefix,
                                    toDropDown.SelectedValue,
                                    SQRLibrary.ConvertToDecimal(fromDropDown.SelectedValue),
                                    Math.Round(SQRLibrary.ConvertToDecimal(hfSalePrice.Value), 4),
                                    txtInputDate.Text,
                                    Session["username"].ToString(),
                                    Session["userid"].ToString()
                                };

                                dt = SQRLibrary.ReturnDatatablefromSQL(sql, parameters, values);
                                if (dt.Rows[0][0].ToString() == "1")
                                {
                                    count++;
                                    successDept.Add(prefix);
                                }
                                else
                                {
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{prefix} - {dt.Rows[0][1]}', 'bg-danger');", true);
                                    continue;
                                }
                            }
                        }
                    }
                    catch { }
                }

                if (count > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!', 'bg-success');", true);

                    FillOutputQuantityForAllDepartment(ProdOrderNo, SQRLibrary.ConvertToDecimal(hfProdOrderQty.Value));
                    FillRemainingOutputQtyToDropDownForAllDept(ProdOrderNo, SQRLibrary.ConvertToDecimal(hfProdOrderQty.Value), SQRLibrary.ConvertToDecimal(hfRoundingInterval.Value), successDept);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post!', 'bg-danger');", true);
                }
                //if (sql.Length > 0)
                //{
                //    SQRLibrary.ExecuteSQL_mrp(sql);
                //    SQRLibrary.ExecuteSQL(sqlUpdatePC);
                //    //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!');", true);
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!');", true);
                //    ddItemCode_SelectedIndexChanged(ddItemCode, e);
                //}
                //else
                //{
                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post!');", true);
                //    //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post');", true);
                //}
            }
            catch { }
        }


        private DataTable GetProductionOutputByProdOrder(string ProdOrderNo)
        {
            DataTable rs = new DataTable();
            try
            {
                string sqlOutput = "EXEC ALL_GetProductionSubOutputSummaryByOrder @ProdOrderNo";

                var paramNames = new List<string> { "@ProdOrderNo" };
                var paramValues = new List<object> { ProdOrderNo };

                rs = SQRLibrary.ReturnDatatablefromSQL(sqlOutput, paramNames, paramValues);
            }
            catch { }
            return rs;
        }

        public static (decimal TotalQuantity, decimal ReceiptQuantity) GetQuantitiesByDepartment(DataTable dtOutput, string prodOrderNo, string department)
        {
            decimal totalQuantity = 0;
            decimal receiptQuantity = 0;

            try
            {
                // Call the SQL procedure


                if (dtOutput != null && dtOutput.Rows.Count > 0)
                {
                    // Filter the DataTable for the given Department
                    var rows = dtOutput.Select($"Department = '{department}'");
                    if (rows.Length > 0)
                    {
                        var row = rows[0];
                        totalQuantity = row["TotalQuantity"] != DBNull.Value ? Convert.ToDecimal(row["TotalQuantity"]) : 0;
                        receiptQuantity = row["ReceiptQuantity"] != DBNull.Value ? Convert.ToDecimal(row["ReceiptQuantity"]) : 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving quantities for department '{department}': {ex.Message}", ex);
            }

            return (totalQuantity, receiptQuantity);
        }

        protected void PopulateDropDown(DropDownList dd, decimal min, decimal max, decimal interval)
        {
            try
            {
                if (max < min) min = max;

                decimal value = min;

                while (value <= max)
                {
                    string displayText = value.ToString("0.#####");
                    string itemValue = value.ToString("0.#####");

                    dd.Items.Add(new ListItem(displayText, itemValue));

                    value += interval;
                }

                decimal lastAdded = value - interval;
                if (lastAdded < max)
                {
                    string displayText = max.ToString("0.#####");
                    string itemValue = max.ToString("0.#####");
                    dd.Items.Add(new ListItem(displayText, itemValue));
                }
            }
            catch { }
        }

        private void FillOutputQuantityForAllDepartment(string ProdOrderNo, decimal ProdOrderQty)
        {
            try
            {
                DataTable dtOutput = GetProductionOutputByProdOrder(ProdOrderNo);

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                List<string> prefixes = new List<string>() { "RMBOARD", "RMTIMBER", "FMBOARD", "FMTIMBER" };
                List<string> prefixes_data = new List<string>() { "RM-BOARD", "RM-TIMBER", "FM-BOARD", "FM-TIMBER" };
                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {
                    try
                    {
                        if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                        {
                            int p = prefixes.IndexOf(dd.ID.Substring(2));
                            if (p < 0) continue;
                            var (totalQty, receiptQty) = GetQuantitiesByDepartment(dtOutput, ProdOrderNo, prefixes_data[p]);
                            
                            decimal sldn = totalQty;
                            decimal sldn_confirmed = receiptQty;

                            decimal temp = ProdOrderQty - sldn;
                            string t = "txt" + dd.ID.Substring(2) + "Quantity";

                            if (temp > 0)
                            {
                                ((TextBox)huu1.FindControl(t)).CssClass = "bg-warning text-white form-control";
                                ((TextBox)huu1.FindControl(t)).Text = $"{sldn.ToString("#0.####")} ({sldn_confirmed.ToString("#0.####")})";
                            }
                            else
                            {
                                ((TextBox)huu1.FindControl(t)).Text = $"{sldn.ToString("#0.####")} ({sldn_confirmed.ToString("#0.####")})";
                                ((TextBox)huu1.FindControl(t)).CssClass = "bg-success text-white form-control";
                            }
                        }
                    }
                    catch { }
                }
            }
            catch { }
        }

        private void FillRemainingOutputQtyToDropDownForAllDept(string ProdOrderNo, decimal ProdOrderQty, decimal RoundingInterval, List<string> successDept = default(List<string>))
        {
            try
            {
                DataTable dtOutput = GetProductionOutputByProdOrder(ProdOrderNo);

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                List<string> prefixes = new List<string>() { "RMBOARD", "RMTIMBER", "FMBOARD", "FMTIMBER" };
                List<string> prefixes_data = new List<string>() { "RM-BOARD", "RM-TIMBER", "FM-BOARD", "FM-TIMBER" };

                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {
                    try
                    {
                        if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                        {
                            //if department not in success, no need update qty dropdown,do for next
                            if ((successDept != null) && (successDept.Count > 0) && !(successDept.Contains(dd.ID.Substring(2)))) continue;

                            dd.Items.Clear(); dd.Items.Add(new ListItem("- Select Qty " + dd.ID.Substring(2), "0"));
                            int p = prefixes.IndexOf(dd.ID.Substring(2));
                            if (p < 0) continue;
                            var (totalQty, receiptQty) = GetQuantitiesByDepartment(dtOutput, ProdOrderNo, prefixes_data[p]);
                            //var (totalQty, receiptQty) = GetQuantitiesByDepartment(dtOutput, ProdOrderNo, dd.ID.Substring(2));

                            decimal sldn = totalQty;
                            decimal temp = ProdOrderQty - sldn;
                            string t = "txt" + dd.ID.Substring(2) + "Quantity";

                            if (temp > 0)
                            {
                                PopulateDropDown(dd, RoundingInterval, temp, RoundingInterval);
                            }
                        }
                    }
                    catch { }
                }
            }
            catch { }
        }
        private void LoadOutputHistory()
        {
            

            string prodOrderNo = Request["No"] == null ? "" : Request["No"].ToString();
            //string sql = "SELECT RowIndex, format (ProdOrderDate, 'dd-MM-yyyy') [Date],a.Department, a.ToDepartment, format(Quantity,'#0.##') Quantity,";
            //sql += " format(a.RemainQuantity,'#0.##') RemainQty, a.UpdatedDate, a.isReceipt, ";
            //sql += "(select top 1 ShowIndex from [MRP_ALL].dbo.POR_ManHourUnitCost b where b.Department = a.Department collate Latin1_General_100_CS_AS) ShowIndex ";
            //sql += "  FROM Custom_ProductionOutputDetail a where ProdOrderNo=@ProdOrderNo order by ShowIndex asc, UpdatedDate asc";
            
            DataTable prodorderinfo = SQRLibrary.ReturnDatatablefromSQL(
                "select * from [LIVE_ALLIANCE_90$Production Order] where No_=@ProdOrderNo",
                new List<string>() { "@ProdOrderNo" },
                new List<object>() { prodOrderNo }
            );
            
            if (prodorderinfo.Rows.Count > 0)
            {
                string caption = prodorderinfo.Rows[0]["Description 2"].ToString()
                    + " - " + prodorderinfo.Rows[0]["Description"].ToString() + " - " + SQRLibrary.ConvertToDecimal(prodorderinfo.Rows[0]["Quantity"]).ToString("#0.####");
                gvDetailOutput.Caption = "Production Order Tracing: " + caption;
                txtProdOrderNo.InnerHtml = caption;
            }

            string mode = OutputViewMode; // "DETAIL" or "GROUP"

            string sql;

            if (mode == "GROUP")
            {
                // Group by Department
                sql = @"
                    SELECT 
                        a.Department, MIN(b.DepartmentName_VN) DepartmentName,
                        COUNT(*) AS [Lines],
                        FORMAT(SUM(a.Quantity),'#0.##') AS [TotalQty],
                        FORMAT(SUM(a.RemainQuantity),'#0.##') AS [TotalRemainQty],
                        FORMAT(SUM(CASE WHEN a.isReceipt = 1 THEN a.Quantity ELSE 0 END),'#0.##') AS [ReceiptQty],
                        MAX(a.UpdatedDate) AS [LastUpdated],
                        MIN(b.ShowIndex) ShowIndex
                    FROM Custom_ProductionOutputDetail a
                    LEFT JOIN [MRP_ALL].dbo.POR_ManHourUnitCost b ON b.Department = a.Department COLLATE Latin1_General_100_CS_AS
                    WHERE a.ProdOrderNo = @ProdOrderNo
                    GROUP BY a.Department
                    ORDER BY ShowIndex ASC, a.Department ASC;
                ";
            }
            else
            {
                
                sql = @"
                    SELECT 
                        RowIndex,
                        FORMAT(ProdOrderDate, 'dd-MM-yyyy') AS [Date],
                        a.Department, b.DepartmentName_VN DepartmentName,
                        a.ToDepartment,
                        FORMAT(Quantity,'#0.##') AS Quantity,
                        FORMAT(a.RemainQuantity,'#0.##') AS RemainQty,
                        a.UpdatedDate,
                        a.isReceipt,
                        b.ShowIndex
                    FROM Custom_ProductionOutputDetail a
                    LEFT JOIN [MRP_ALL].dbo.POR_ManHourUnitCost b ON b.Department = a.Department COLLATE Latin1_General_100_CS_AS
                    WHERE a.ProdOrderNo = @ProdOrderNo
                    ORDER BY ShowIndex ASC, UpdatedDate ASC;
                ";
            }

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string>() { "@ProdOrderNo" },
                new List<object>() { prodOrderNo }
            );
            Library.LibraryFunction.LoadDataTableToGridView(gvDetailOutput, dt, new List<string>() { "ShowIndex" });
        }

        protected void rblOutputView_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOutputHistory(); 
        }

        protected void btnViewDetail_Click(object sender, EventArgs e)
        {
            hfOutputView.Value = "DETAIL";
            ApplyOutputViewUI();
            LoadOutputHistory();
        }

        protected void btnViewGroup_Click(object sender, EventArgs e)
        {
            hfOutputView.Value = "GROUP";
            ApplyOutputViewUI();
            LoadOutputHistory();
        }

        private string OutputViewMode
        {
            get { return (hfOutputView?.Value ?? "DETAIL").ToUpperInvariant(); }
        }

        private void ApplyOutputViewUI()
        {
            bool isGroup = OutputViewMode == "GROUP";

            btnViewDetail.CssClass = isGroup ? "btn btn-outline-primary" : "btn btn-primary";
            btnViewGroup.CssClass = isGroup ? "btn btn-primary" : "btn btn-outline-primary";

            lblViewHint.InnerText = isGroup ? "Showing grouped totals" : "Showing detail lines";
        }


        #region PRODUCTION ORDER IMAGES

        protected void btnUploadImages_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CanUpload)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup",
                        "ShowPopup('POR System', 'You do not have permission to upload images.', 'bg-danger');", true);
                    return;
                }


                string prodOrderNo = GetProdOrderNo();
                if (string.IsNullOrWhiteSpace(prodOrderNo))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup",
                        "ShowPopup('POR System', 'Missing Production Order No (Request[No]).', 'bg-danger');", true);
                    return;
                }

                if (fuProdOrderImages == null || fuProdOrderImages.PostedFiles == null || fuProdOrderImages.PostedFiles.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup",
                        "ShowPopup('POR System', 'Please select image files to upload.', 'bg-warning');", true);
                    return;
                }

                int year = GetYearFromProdOrderNo(prodOrderNo);
                string folder = BuildTargetFolder(prodOrderNo, year);
                Directory.CreateDirectory(folder);

                int ok = 0, skip = 0;

                foreach (var pf in fuProdOrderImages.PostedFiles)
                {
                    try
                    {
                        string ext = Path.GetExtension(pf.FileName);
                        if (!IsAllowedImage(ext))
                        {
                            skip++;
                            continue;
                        }

                        // Unique file name to avoid overwrite
                        string safeName = Path.GetFileNameWithoutExtension(pf.FileName);
                        safeName = Regex.Replace(safeName, @"[^\w\- ]+", "");
                        safeName = (safeName.Length > 80 ? safeName.Substring(0, 80) : safeName).Trim();

                        string newName = $"{safeName}_{DateTime.Now:yyyyMMdd_HHmmssfff}_{Guid.NewGuid():N}{ext}";
                        string fullPath = Path.Combine(folder, newName);

                        pf.SaveAs(fullPath);

                        string relative = ToRelativePathUnderErp(fullPath);

                        // Save DB record
                        SQRLibrary.ReturnDatatablefromSQL(
                            "EXEC dbo.ALL_PRODUCTION_InsertProductionOrderImage " +
                            "@ProdOrderNo,@Year,@FileName,@PhysicalPath,@RelativePath,@FileSizeBytes,@ContentType,@UploadedBy,@UploadedUserId,@SortOrder",
                            new List<string>
                            {
                                "@ProdOrderNo","@Year","@FileName","@PhysicalPath","@RelativePath",
                                "@FileSizeBytes","@ContentType","@UploadedBy","@UploadedUserId","@SortOrder"
                            },
                            new List<object>
                            {
                        prodOrderNo, year, newName, fullPath, relative,
                        (long)pf.ContentLength, pf.ContentType,
                        Session["username"]?.ToString(), Session["userid"]?.ToString(),
                        0
                            }
                        );

                        ok++;
                    }
                    catch
                    {
                        skip++;
                    }
                }

                LoadProdOrderImages();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup",
                    $"ShowPopup('POR System', 'Upload done. Success: {ok}, Skipped/Failed: {skip}', 'bg-success');", true);
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup",
                    "ShowPopup('POR System', 'Upload failed. Please try again.', 'bg-danger');", true);
            }
        }

        private void LoadProdOrderImages()
        {
            try
            {
                string prodOrderNo = GetProdOrderNo();
                if (string.IsNullOrEmpty(prodOrderNo))
                {
                    BindEmptyGallery();
                    return;
                }

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                    "EXEC dbo.ALL_PRODUCTION_GetProductionOrderImages @ProdOrderNo",
                    new List<string> { "@ProdOrderNo" },
                    new List<object> { prodOrderNo }
                );

                if (!dt.Columns.Contains("Url")) dt.Columns.Add("Url", typeof(string));
                if (!dt.Columns.Contains("Idx")) dt.Columns.Add("Idx", typeof(int));
                if (!dt.Columns.Contains("ActiveClass")) dt.Columns.Add("ActiveClass", typeof(string));
                if (!dt.Columns.Contains("AriaCurrent")) dt.Columns.Add("AriaCurrent", typeof(string));
                if (!dt.Columns.Contains("UploadedInfo")) dt.Columns.Add("UploadedInfo", typeof(string));

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    var r = dt.Rows[i];
                    string rel = r["RelativePath"]?.ToString() ?? "";
                    r["Url"] = RelativeToHttpsUrl(rel);
                    r["Idx"] = i;
                    r["ActiveClass"] = (i == 0) ? "active" : "";
                    r["AriaCurrent"] = (i == 0) ? "true" : "false";

                    // Safe formatting
                    var by = (r["UploadedBy"]?.ToString() ?? "").Trim();
                    DateTime d;
                    string dtText = "";
                    if (DateTime.TryParse(r["UploadedDate"]?.ToString(), out d))
                        dtText = d.ToString("dd/MM/yyyy HH:mm");

                    r["UploadedInfo"] = string.IsNullOrEmpty(by) ? dtText : (by + " • " + dtText);
                }

                rpMainCarousel.DataSource = dt;
                rpMainCarousel.DataBind();

                rpThumbs.DataSource = dt;
                rpThumbs.DataBind();

                // For modal carousel too
                rpModalCarousel.DataSource = dt;
                rpModalCarousel.DataBind();

                pnlNoImages.Visible = (dt.Rows.Count == 0);
                pnlGallery.Visible = (dt.Rows.Count > 0);
            }
            catch
            {
                BindEmptyGallery();
            }
        }

        private void BindEmptyGallery()
        {
            rpMainCarousel.DataSource = null; rpMainCarousel.DataBind();
            rpThumbs.DataSource = null; rpThumbs.DataBind();
            rpModalCarousel.DataSource = null; rpModalCarousel.DataBind();

            pnlNoImages.Visible = true;
            pnlGallery.Visible = false;
        }

        private void LoadProdOrderImages_OLD()
        {
            //try
            //{
            //    string prodOrderNo = GetProdOrderNo();
            //    if (string.IsNullOrEmpty(prodOrderNo))
            //    {
            //        rpProdOrderImages.DataSource = null;
            //        rpProdOrderImages.DataBind();
            //        pnlNoImages.Visible = true;
            //        return;
            //    }

            //    DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
            //        "EXEC dbo.ALL_PRODUCTION_GetProductionOrderImages @ProdOrderNo",
            //        new List<string> { "@ProdOrderNo" },
            //        new List<object> { prodOrderNo }
            //    );

            //    // add Url column for binding
            //    dt.Columns.Add("Url", typeof(string));
            //    foreach (DataRow r in dt.Rows)
            //    {
            //        string rel = r["RelativePath"]?.ToString() ?? "";
            //        r["Url"] = RelativeToHttpsUrl(rel);
            //    }

            //    rpProdOrderImages.DataSource = dt;
            //    rpProdOrderImages.DataBind();

            //    pnlNoImages.Visible = (dt.Rows.Count == 0);
            //}
            //catch
            //{
            //    rpProdOrderImages.DataSource = null;
            //    rpProdOrderImages.DataBind();
            //    pnlNoImages.Visible = true;
            //}
        }

        private string GetProdOrderNo()
        {            
            return (Request["No"]?.ToString() ?? "").Trim();
        }

        private int GetYearFromProdOrderNo(string prodOrderNo)
        {
            // Example: RPO25_000033 => 2025
            // Robust: supports RPO25..., RPO2025...
            if (string.IsNullOrWhiteSpace(prodOrderNo)) return DateTime.Now.Year;

            var m = Regex.Match(prodOrderNo, @"RPO(?<y>\d{2}|\d{4})", RegexOptions.IgnoreCase);
            if (!m.Success) return DateTime.Now.Year;

            var y = m.Groups["y"].Value;
            if (y.Length == 2) return 2000 + int.Parse(y);
            return int.Parse(y);
        }

        private string BuildTargetFolder(string prodOrderNo, int year)
        {
            return Path.Combine(ERP_ROOT_PHYSICAL, "IMAGE", "ProductionOrders", year.ToString(), prodOrderNo);
        }

        private string ToRelativePathUnderErp(string physicalFullPath)
        {
            // store relative path so URL conversion is always stable
            // Example: D:\alliance_new\ERP\IMAGE\ProductionOrders\2025\RPO25_000033\a.jpg
            // => IMAGE/ProductionOrders/2025/RPO25_000033/a.jpg
            var p = physicalFullPath.Replace('/', '\\');
            var root = ERP_ROOT_PHYSICAL.Replace('/', '\\');

            if (p.StartsWith(root, StringComparison.OrdinalIgnoreCase))
                p = p.Substring(root.Length);

            return p.TrimStart('\\').Replace('\\', '/');
        }

        private string RelativeToHttpsUrl(string relativePath)
        {
            return ERP_ROOT_HTTPS.TrimEnd('/') + "/" + relativePath.TrimStart('/');
        }

        private bool IsAllowedImage(string ext)
        {
            ext = (ext ?? "").ToLowerInvariant();
            return ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".webp";
        }

        //protected override void RaisePostBackEvent(IPostBackEventHandler source, string eventArgument)
        //{
        //    if (eventArgument != null && eventArgument.Contains(":"))
        //    {
        //        // format: ImageId:Sort|ImageId:Sort
        //        var pairs = eventArgument.Split('|');
        //        foreach (var p in pairs)
        //        {
        //            var arr = p.Split(':');
        //            if (arr.Length != 2) continue;

        //            SQRLibrary.ExecuteSQL(
        //                "EXEC dbo.ALL_PRODUCTION_UpdateProductionOrderImageSort @ImageId,@SortOrder",
        //                new List<string> { "@ImageId", "@SortOrder" },
        //                new List<object> { arr[0], arr[1] }
        //            );
        //        }
        //        LoadProdOrderImages();
        //    }

        //    if (eventArgument != null && eventArgument.All(char.IsDigit))
        //    {
        //        SQRLibrary.ExecuteSQL(
        //            "EXEC dbo.ALL_PRODUCTION_DeleteProductionOrderImage @ImageId",
        //            new List<string> { "@ImageId" },
        //            new List<object> { eventArgument }
        //        );
        //        LoadProdOrderImages();
        //    }

        //}

        protected void lbSaveImageOrder_Click(object sender, EventArgs e)
        {
            if (!CanReorder)
                throw new HttpException(403, "Forbidden");

            string arg = Request["__EVENTARGUMENT"];  // "ImageId:0|ImageId:1|..."
            if (string.IsNullOrWhiteSpace(arg)) return;

            foreach (var p in arg.Split('|'))
            {
                var arr = p.Split(':');
                if (arr.Length != 2) continue;

                long imageId;
                int sortOrder;
                if (!long.TryParse(arr[0], out imageId)) continue;
                if (!int.TryParse(arr[1], out sortOrder)) continue;

                SQRLibrary.ExecuteSQL_mrp(
                    "EXEC dbo.ALL_PRODUCTION_UpdateProductionOrderImageSort @ImageId,@SortOrder",
                    new List<string> { "@ImageId", "@SortOrder" },
                    new List<object> { imageId, sortOrder }
                );
            }

            LoadProdOrderImages(); // refresh gallery
        }

        protected void lbDeleteImage_Click(object sender, EventArgs e)
        {
            if (!CanDelete)
                throw new HttpException(403, "Forbidden");

            string arg = Request["__EVENTARGUMENT"]; 
            long imageId;
            if (!long.TryParse(arg, out imageId)) return;

            SQRLibrary.ExecuteSQL_mrp(
                "EXEC dbo.ALL_PRODUCTION_DeleteProductionOrderImage @ImageId",
                new List<string> { "@ImageId" },
                new List<object> { imageId }
            );

            LoadProdOrderImages();
        }

        private void ApplyImagePermissionUI()
        {
            // Upload controls
            fuProdOrderImages.Visible = CanUpload;
            btnUploadImages.Visible = CanUpload;
                        
            // Push perms to JS (for drag/delete controls)
            var js = $@"
                          window.porPerms = {{
                            canUpload:  {(CanUpload ? "true" : "false")},
                            canDelete:  {(CanDelete ? "true" : "false")},
                            canReorder: {(CanReorder ? "true" : "false")}
                          }};";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "porPerms", js, true);
        }

        #endregion

        private void ApplySubOutputPermissionUI()
        {
            // Upload controls
            UpdatePanel2.Visible = CanUpload;
            bt1.Visible = CanUpload;
        }
    }
}
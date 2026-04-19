using DevExpress.Utils.Filtering.Internal;
using DevExpress.Web;
using DevExpress.Web.Internal.XmlProcessor;
using DevExpress.XtraExport.Helpers;
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
    public partial class OutputRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            if (!IsPostBack)
            {
                //Disable control if users don't have permission on that department
                lbnSubDelivery.Visible = false;
                UpdateValueToDepartment();
                SetPermissionToControl();
                bt1.Text = $"Submit - {Session["userid"].ToString()}";
                txtInputDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                try
                {
                    string sql = "select distinct [Description 2] as [PI] from [LIVE_ALLIANCE_90$Production Order] where [Description 2] <> '' AND [Status] in ('3') AND LEN([Description 2])<=20 ORDER BY [Description 2] desc";
                    System.Data.DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql);
                    Session["PIList"] = dt;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ddPI.Items.Add(new ListItem(dt.Rows[i][0].ToString(), dt.Rows[i][0].ToString()));
                    }
                }
                catch { }

                string ProdNo = Request["prod"]?.ToString() ?? "";
                if (!string.IsNullOrEmpty(ProdNo))
                {
                    hfPI.Value = ProdNo;
                    btnHandleDocNo_Click(sender, e);
                }
                //bt1.OnClientClick = $"sweetAlertConfirm('{bt1.UniqueID}','Do you want to post production output?','question')";
            }
            else
            {
                LoadRelatedProdOrder(ddItemCode.SelectedValue);
            }
            
        }

        private bool TextExistInTable(DataTable dt, string text)
        {
            bool result = false;
            try
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (dt.Rows[i][0].ToString().Equals(text))
                    {
                        return true;
                    }
                }
            }
            catch { }
            return result;
        }
        private void SetPermissionToControl()
        {
            ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
            UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
            Control huu1 = huu.FindControl("ctl00");
            List<string> InchargeDepartment = LibraryFunction.GetInChargeDepartment(Session["userid"].ToString());

            foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
            {
                if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode"))
                {
                    if (InchargeDepartment.IndexOf(dd.ID.Substring(2)) < 0)
                    {
                        dd.Enabled = false;
                    }
                }
            }
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
                if (ddItemCode.SelectedValue == null || ddItemCode.SelectedValue.Equals("0")) return;
                
                string ProdOrderNo = ddItemCode.SelectedValue;
                //var selectedProd = (hfSelectedKeys.Value ?? "")
                //   .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                //   .ToList();

                //string sqlUpdatePC = "exec UpdateProdOrderStatus '" + ddItemCode.SelectedValue + "'";
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                string sql = @"EXEC [ALL_InsertProductionOutputDetail] 
                    @ProdOrderNo, @Department, @ToDepartment, 
                    @Quantity, @Price, @ProdOrderDate, @UpdatedUser, @UpdatedUserID";
                string[] prefixes = { "RM", "FM", "AS", "SA", "SP", "FIN", "IRON", "IRON_DM", "UPH",  "FIT", "TU", "PAC", "OT", "WAREHOUSE" };

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
                        DropDownList fromDropDown = huu1.FindControl($"dd{prefix}") as DropDownList;
                        DropDownList toDropDown = huu1.FindControl($"to{prefix}") as DropDownList;
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
                                    fromDropDown.ID.Substring(2),
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
                    

                    //if (selected.Count == 0)
                        //     ClientScript.RegisterStartupScript(GetType(), "msg", "alert('No rows selected');", true);
                        // else
                        //     ClientScript.RegisterStartupScript(GetType(), "msg", $"alert('Selected: {string.Join(", ", selected)}');", true);

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post!', 'bg-danger');", true);
                }
                
                
                
                LoadRelatedProdOrder(ProdOrderNo);


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


        //protected void bt1_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        DateTime date = DateTime.ParseExact(txtInputDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture);
        //        if (date > DateTime.Now)
        //        {
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Vui lòng kiểm tra lại ngày giao hàng!','bg-danger');", true);
        //            return;
        //        }
        //        if (ddItemCode.SelectedValue == null || ddItemCode.SelectedValue.Equals("0")) return;
        //        string ProdOrderNo = ddItemCode.SelectedValue;

        //        //string sqlUpdatePC = "exec UpdateProdOrderStatus '" + ddItemCode.SelectedValue + "'";
        //        ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
        //        UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
        //        Control huu1 = huu.FindControl("ctl00");

        //        string sql = @"EXEC [ALL_InsertProductionOutputDetail] 
        //            @ProdOrderNo, @Department, @ToDepartment, 
        //            @Quantity, @Price, @ProdOrderDate, @UpdatedUser, @UpdatedUserID";
        //        string[] prefixes = { "RM", "FM", "AS", "SA", "FIN", "IRON", "UPH", "FIT", "PAC" };

        //        var parameters = new List<string>
        //            {
        //                "@ProdOrderNo",
        //                "@Department",
        //                "@ToDepartment",
        //                "@Quantity",
        //                "@Price",
        //                "@ProdOrderDate",
        //                "@UpdatedUser",
        //                "@UpdatedUserID"
        //            };
        //        int count = 0;
        //        List<string> successDept = new List<string>() { };
        //        DataTable dt = new DataTable();
        //        foreach (string prefix in prefixes)
        //        {
        //            try
        //            {
        //                DropDownList fromDropDown = huu1.FindControl($"dd{prefix}") as DropDownList;
        //                DropDownList toDropDown = huu1.FindControl($"to{prefix}") as DropDownList;
        //                if (fromDropDown != null && toDropDown != null)
        //                {
        //                    // Check if both dropdowns have a selected value
        //                    bool fromHasValue = !string.IsNullOrEmpty(fromDropDown.SelectedValue);
        //                    bool toHasValue = !string.IsNullOrEmpty(toDropDown.SelectedValue);

        //                    if (fromHasValue && toHasValue)
        //                    {
        //                        //do insert
        //                        if (SQRLibrary.ConvertToDecimal(fromDropDown.SelectedValue) <= 0) continue;
        //                        var values = new List<object>
        //                        {
        //                            ProdOrderNo,
        //                            fromDropDown.ID.Substring(2),
        //                            toDropDown.SelectedValue,
        //                            SQRLibrary.ConvertToDecimal(fromDropDown.SelectedValue),
        //                            Math.Round(SQRLibrary.ConvertToDecimal(hfSalePrice.Value), 4),
        //                            txtInputDate.Text,
        //                            Session["username"].ToString(),
        //                            Session["userid"].ToString()
        //                        };

        //                        dt = SQRLibrary.ReturnDatatablefromSQL(sql, parameters, values);
        //                        if (dt.Rows[0][0].ToString() == "1")
        //                        {
        //                            count++;
        //                            successDept.Add(prefix);
        //                        }
        //                        else
        //                        {
        //                            ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{prefix} - {dt.Rows[0][1]}', 'bg-danger');", true);
        //                            continue;
        //                        }
        //                    }
        //                }
        //            }
        //            catch { }
        //        }

        //        if (count > 0)
        //        {
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!', 'bg-success');", true);

        //            FillOutputQuantityForAllDepartment(ProdOrderNo, SQRLibrary.ConvertToDecimal(hfProdOrderQty.Value));
        //            FillRemainingOutputQtyToDropDownForAllDept(ProdOrderNo, SQRLibrary.ConvertToDecimal(hfProdOrderQty.Value), SQRLibrary.ConvertToDecimal(hfRoundingInterval.Value), successDept);
        //        }
        //        else
        //        {
        //            ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post!', 'bg-danger');", true);
        //        }
        //        //if (sql.Length > 0)
        //        //{
        //        //    SQRLibrary.ExecuteSQL_mrp(sql);
        //        //    SQRLibrary.ExecuteSQL(sqlUpdatePC);
        //        //    //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!');", true);
        //        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!');", true);
        //        //    ddItemCode_SelectedIndexChanged(ddItemCode, e);
        //        //}
        //        //else
        //        //{
        //        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post!');", true);
        //        //    //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post');", true);
        //        //}
        //    }
        //    catch { }
        //}
        protected void ddPI_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadProdOrderToDDByPI(ddPI.SelectedValue);
                ddItemCode_SelectedIndexChanged(ddItemCode, e);
                LoadProjectNameByPI(ddPI.SelectedValue);
            }
            catch { }
        }

        protected void ddItemCode_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                lbEstimateTotalValue.InnerText = " ";
                if (ddItemCode.SelectedValue.Equals("0"))
                {
                    lbnSubDelivery.Visible = false;
                    linkAddNewNote.Visible = false;
                    RemoveDataInField();
                    return;
                }

                lbnSubDelivery.Visible = true;
                txtNewNote.Visible = false;
                btnAddNewNote.Visible = false;
                Hr1.Visible = false;

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                //string sql = "select No_, Description, [Source No_], format(Quantity, '#0.#') as Quantity from [LIVE_ALLIANCE_90$Production Order] where [Description 2]=@PI";


                string sql = @" SELECT No_, po.Description, [Source No_], format(Quantity, '#0.####') as Quantity, po.SalePrice
                                , SUBSTRING([Source No_], 14,2) ItemGroup, cc.Name_VN
                                , tf.Description [TimberFinish], lf.Description [MetalFinish], ISNULL(co.RoundingInterval, 1) RoundingInterval 
                                FROM [LIVE_ALLIANCE_90$Production Order] po 

                                LEFT JOIN [LIVE_ALLIANCE_90$Timber Finish] tf ON tf.Code= po.[Timber Finish]
                                LEFT JOIN [LIVE_ALLIANCE_90$Leg Finish] lf on lf.Code = po.[Metal_Fab Finish]
                                LEFT JOIN Custom_OutputRoundingPrecision co on co.ProdOrderNo = po.No_
                                LEFT JOIN Custom_CostElement cc ON SUBSTRING(po.[Source No_], 14,2) = cc.Code
                                WHERE [Description 2]= @PI";
                DataTable ProdOrderList = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@PI" }, new List<object>() { ddPI.SelectedValue });
                string ProdOrderNo = ddItemCode.SelectedValue;
                var rs = ProdOrderList.Select($"No_ = '{ProdOrderNo}'");


                if (rs.Length > 0)
                {
                    DataRow r = rs[0];
                    decimal RoundingInterval = SQRLibrary.ConvertToDecimal(r["RoundingInterval"]);
                    lbItemGroup.Text = $"Item Group: {r["Name_VN"].ToString()}";
                    lbItemCode.Text = "Item Code: " + r["Source No_"].ToString();
                    lbQuantity.Text = "Quantity: " + r["Quantity"].ToString();
                    lbTimberFinish.Text = "Timber Finish: " + r["TimberFinish"].ToString();
                    lbMetalFinish.Text = "Metal Finish: " + r["MetalFinish"].ToString();

                    hfSalePrice.Value = r["SalePrice"].ToString();
                    hfProdOrderQty.Value = r["Quantity"].ToString();
                    hfRoundingInterval.Value = r["RoundingInterval"].ToString();

                    lbtRounding.Text = $"Rounding Interval: {RoundingInterval.ToString("#0.##")}";

                    FillOutputQuantityForAllDepartment(ProdOrderNo, SQRLibrary.ConvertToDecimal(r["Quantity"]));
                    FillRemainingOutputQtyToDropDownForAllDept(ProdOrderNo, SQRLibrary.ConvertToDecimal(r["Quantity"]), RoundingInterval);

                }

                //load note into gridview
                linkAddNewNote.Visible = true;
                gvNoteList.Caption = "Note on " + ProdOrderNo;
                LoadNoteToGridView(ProdOrderNo);
                LoadRelatedProdOrder(ProdOrderNo);
            }
            catch { }
        }


        private void LoadProjectNameByPI(string PI)
        {
            try
            {
                string sql = "SELECT No_, LEFT([Sell-to Customer Name],40) + '...' OrderName FROM [LIVE_ALLIANCE_90$Sales Header] WHERE No_ = @No";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql,
                    new List<string>() { "@No" },
                    new List<object>() { PI });

                lbProjectName.Text = dt.Rows.Count > 0 ? dt.Rows[0][1].ToString() : "Project Name:...";
            
            }
            catch { }
        }

       
        private void LoadProdOrderToDDByPI(string PI)
        {
            try
            {
                string sql = "select No_, Description, [Source No_], format(Quantity, '#0.#') as Quantity, ParentProdNo from [LIVE_ALLIANCE_90$Production Order] where [Description 2]=@PI";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@PI" }, new List<object>() { PI });
                ddItemCode.Items.Clear(); ddItemCode.Items.Add(new ListItem("- Select Item", "0"));

                bool isHasSubProdOrder = false;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    isHasSubProdOrder = dt.Rows[i]["ParentProdNo"].ToString().Equals("1");
                    ddItemCode.Items.Add(new ListItem($"{dt.Rows[i]["No_"].ToString()} - {dt.Rows[i]["Description"].ToString()}", dt.Rows[i]["No_"].ToString(), !isHasSubProdOrder));
                }                
            }
            catch { }
        }

        private void UpdateValueToDepartment()
        {
            try
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                string[] prefixes = { "RM", "FM", "AS", "SA", "SP", "FIN", "IRON", "IRON_DM", "UPH", "FIT", "TU", "PAC", "OT", "WAREHOUSE", "SITE" };

                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {
                    try
                    {
                        if (dd.ID.Substring(0, 2).Equals("to"))
                        {
                            dd.Items.Clear();
                            dd.Items.Add(new ListItem() { Text = "--Transfer To--", Value = ""});
                            foreach (string str in prefixes)
                            {
                                if (str != dd.ID.Substring(2)) dd.Items.Add(str);
                            }
                        }
                    }

                    catch { }
                }

                //SET DEFAULT REICEIPT DEPT
                toRM.SelectedValue = "FM";
                toFM.SelectedValue = "AS";
                toAS.SelectedValue = "SA";
                toSA.SelectedValue = "FIN";
                toPAC.SelectedValue = "WAREHOUSE";
                toTU.SelectedValue = "PAC";
                toIRON.SelectedValue = "IRON_DM";
                toOT.SelectedValue = "WAREHOUSE";
                toWAREHOUSE.SelectedValue = "SITE"; toWAREHOUSE.Enabled = true;
            }
            catch { }
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

        private DataTable GetProductionOutputByProdOrder(string ProdOrderNo)
        {
            DataTable rs = new DataTable();
            try
            {
                string sqlOutput = "EXEC ALL_GetProductionOutputSummaryByOrder @ProdOrderNo";

                var paramNames = new List<string> { "@ProdOrderNo" };
                var paramValues = new List<object> { ProdOrderNo };

                rs = SQRLibrary.ReturnDatatablefromSQL(sqlOutput, paramNames, paramValues);
            }
            catch { }
            return rs;
        }

        private void FillRemainingOutputQtyToDropDownForAllDept(string ProdOrderNo, decimal ProdOrderQty, decimal RoundingInterval, List<string> successDept = default(List<string>))
        {
            try
            {
                DataTable dtOutput = GetProductionOutputByProdOrder(ProdOrderNo);

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {                    
                    try
                    {
                        if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                        {
                            //if department not in success, no need update qty dropdown,do for next
                            if ((successDept!=null) && (successDept.Count > 0) && !(successDept.Contains(dd.ID.Substring(2)))) continue;

                            dd.Items.Clear(); dd.Items.Add(new ListItem("- Select Qty " + dd.ID.Substring(2), "0"));
                            var (totalQty, receiptQty) = GetQuantitiesByDepartment(dtOutput, ProdOrderNo, dd.ID.Substring(2));

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
        private void FillOutputQuantityForAllDepartment(string ProdOrderNo, decimal ProdOrderQty)
        {
            try
            {
                DataTable dtOutput = GetProductionOutputByProdOrder(ProdOrderNo);

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {
                    try
                    {
                        if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                        {                            
                            var (totalQty, receiptQty) = GetQuantitiesByDepartment(dtOutput, ProdOrderNo, dd.ID.Substring(2));

                            decimal sldn = totalQty;
                            decimal sldn_confirmed = receiptQty;
                           
                            decimal temp = ProdOrderQty  - sldn;
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

        
        private void LoadRelatedProdOrder(string prodOrderNo)
        {
            try
            {
                string sql = "EXEC [ALL_PRODUCTION_GetAllRelatedProdOrder] @ProdOrderNo";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@ProdOrderNo" }, new List<object>() { prodOrderNo });
                
                gvRelatedProdOrder.Columns.Clear();
                gvRelatedProdOrder.Caption = "Related Prod. Order" ;
                             

                List<string> hidecl = new List<string>() { "RowIndex", "AllowTimeDelete", "isAdjust" };
                foreach (DataColumn cl in dt.Columns)
                {
                    if (!hidecl.Contains(cl.ColumnName)) gvRelatedProdOrder.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                }

                gvRelatedProdOrder.Visible = true;
                gvRelatedProdOrder.AutoGenerateColumns = false;
                gvRelatedProdOrder.DataSource = dt;
                gvRelatedProdOrder.DataBind();
                AddCheckBoxColumn();
                gvRelatedProdOrder.DataBind();
            }
            catch { }
        }

        protected void ddDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                DropDownList cr = (DropDownList)sender;
                string f = Math.Round(SQRLibrary.ConvertToDouble(hfSalePrice.Value) * SQRLibrary.ConvertToDouble(cr.SelectedValue), 2).ToString("##,##0.##");
                
                lbEstimateTotalValue.InnerText = "Value: " + cr.SelectedValue + "pcs ~ " + f + "VND";
            }
            catch { }
        }

        private void LoadNoteToGridView(string ProdOrderNo)
        {
            try
            {
                string sql = "SELECT Note, UpdateUser FROM [POR_Note] where ProdOrderNo= '" + ProdOrderNo + "' order by RowIndex desc";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                LibraryFunction.LoadDataTableToGridView(gvNoteList, dt);
            }
            catch { }
        }

        private void RemoveDataInField()
        {
            ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
            UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
            Control huu1 = huu.FindControl("ctl00");

            lbItemCode.Text = "Item Code: ";
            lbQuantity.Text = "Quantity :";

            foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
            {
                try
                {
                    if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                    {
                        dd.Items.Clear(); dd.Items.Add(new ListItem("- Select Qty " + dd.ID.Substring(2), "0"));
                        string t = "txt" + dd.ID.Substring(2) + "Quantity";

                        ((TextBox)huu1.FindControl(t)).CssClass = "form-control";
                        ((TextBox)huu1.FindControl(t)).Text = "";
                    }
                }
                catch { }
            }
        }

        public static (decimal TotalQuantity, decimal ReceiptQuantity) GetQuantitiesByDepartment(DataTable dtOutput ,string prodOrderNo, string department)
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

        private int RegisterQuantity(string ProdOrderNo, string Department)
        {
            try
            {
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(" select isnull(sum(Quantity),0) from [POR_ProductionOutputDetail] where ProdOrderNo='" + ProdOrderNo + "' and Department='" + Department + "'");
                return SQRLibrary.ConvertToInt(dt.Rows[0][0]);
            }
            catch { return 0; }
        }

        [WebMethod]
        public static List<string> GetPIData(string pino)
        {
            List<string> result = new List<string>() { "HUU/HUU", "AA/AA", "KK/KK" };
            string sql = "select distinct [Description 2] as [PI] from [LIVE_ALLIANCE_90$Production Order] where [Description 2] like  @PINo + '%' AND [Status] in ('3') AND LEN([Description 2])<10  ORDER BY [Description 2] desc";
            System.Data.DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@PINo" }, new List<object>() { pino });
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                result.Add(string.Format("{0}/{1}", dt.Rows[i]["PI"], dt.Rows[i]["PI"]));
            }
            return result;
        }

        protected void linkAddNewNote_Click(object sender, EventArgs e)
        {
            txtNewNote.Visible = true;
            txtNewNote.Text = "";
            btnAddNewNote.Visible = true;
            Hr1.Visible = true;
        }

        protected void btnAddNewNote_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtNewNote.Text.Length <= 0) return;
                string sql = "INSERT INTO POR_Note (ProdOrderNo, Note, UpdateUser, UpdateOn) values (@ProdOrderNo, @Note, @UpdateUser, getdate())";
                SQRLibrary.ExecuteSQL_mrp(sql, new List<string>() { "@ProdOrderNo", "@Note", "@UpdateUser" }, new List<object>() { ddItemCode.SelectedValue, txtNewNote.Text, Session["username"].ToString() });
                LoadNoteToGridView(ddItemCode.SelectedValue);

                txtNewNote.Visible = false;
                btnAddNewNote.Visible = false;
                Hr1.Visible = false;
            }
            catch { }
        }

        protected void lbtRounding_Click(object sender, EventArgs e)
        {
            try
            {
                string ProdOrderNo = ddItemCode.SelectedValue;
                decimal RoundingInterval = SQRLibrary.ConvertToDecimal(hfRoundingInterval.Value) == 1 ? (decimal)0.1 : 1;

                if (ProdOrderNo == "0") return;
                if (RoundingInterval < 1 && SQRLibrary.ConvertToDecimal(hfProdOrderQty.Value) > 1)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Can not change Interval to 0.1 if Quantity != 1','bg-danger');", true);
                    return;
                }

                //Upsert ProdOrderNo with RoundingInterval to table 
                string sql = "EXEC ALL_InsertToOutputRoundingPrecision @ProdOrderNo, @interval";
                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@ProdOrderNo", "@interval" }
                    , new List<object>() { ProdOrderNo, RoundingInterval });

                ddItemCode_SelectedIndexChanged(sender, e);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully changed','bg-success');", true);
            }
            catch { }
        }

        protected void btnHandleDocNo_Click(object sender, EventArgs e)
        {
            try
            {
                string DocNo = hfPI.Value; // txtPI.Text;

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC ALL_OUTPUT_Search_ProductionOrder_OrPI @text"
                    , new List<string>() { "@text" }
                    , new List<object>() { DocNo });

                if (dt!= null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    switch (r["Source"].ToString())
                    {
                        case "PI":
                            ddPI.SelectedValue = r["PI"].ToString();
                            LoadProdOrderToDDByPI(r["PI"].ToString());
                            LoadProjectNameByPI(r["PI"].ToString());
                            break;

                        case "ProdOrder":
                            ddPI.SelectedValue = r["PI"].ToString();
                            LoadProdOrderToDDByPI(r["PI"].ToString());
                            LoadProjectNameByPI(r["PI"].ToString());
                            ddItemCode.SelectedValue = r["No_"].ToString();
                            ddItemCode_SelectedIndexChanged(sender, e);
                            break;
                    }
                }
            }
            catch { }
        }

        protected void lbnSubDelivery_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddItemCode.SelectedValue == null || ddItemCode.SelectedValue.Equals("0")) return;
                string ProdOrderNo = ddItemCode.SelectedValue;

                Response.Redirect("~/production/trace/ProdOrderTracing?No=" + ProdOrderNo);
            }
            catch { }
        }

        protected void gvRelatedProdOrder_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    // Format date
                    //DateTime orderDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "Quantity"));
                    //e.Row.Cells[5].Text = orderDate.ToString("dd-MM-yyyy");

                    string ProdOrderNo = DataBinder.Eval(e.Row.DataItem, "No_").ToString();
                    e.Row.Cells[1].Text = $"<a href='OutputRegister?prod={ProdOrderNo}'>{ProdOrderNo}</a>";

                    decimal quantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity"));
                    e.Row.Cells[2].Text = quantity.ToString("#,##0.##"); // e.g., 1,234.56

                    decimal RemainQuantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "RemainQuantity"));
                    e.Row.Cells[7].Text = RemainQuantity.ToString("#,##0.##"); // e.g., 1,234.56

                    decimal price = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Price"));
                    e.Row.Cells[9].Text = price.ToString("#,##0"); // e.g., 1,234.56

                    decimal Percent = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Percent")) / 100;
                    e.Row.Cells[13].Text = Percent.ToString("P2"); // e.g., 1,234.56

                    decimal Revenue = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Revenue"));
                    e.Row.Cells[14].Text = Revenue.ToString("#,##0"); // e.g., 1,234.56

                    decimal FullRevenue = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "FullRevenue"));
                    e.Row.Cells[15].Text = FullRevenue.ToString("#,##0");

                    decimal ValueQuantity = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "ValueQuantity"));
                    e.Row.Cells[4].Text = ValueQuantity.ToString("#,##0.##");
                }
            }
            catch { }
        }

        private void AddCheckBoxColumn()
        {
            try
            {
                // Add checkbox TemplateField as the first column only once
                if (!gvRelatedProdOrder.Columns.OfType<TemplateField>().Any(tf => tf.HeaderText == "✓"))
                {
                    var tf = new TemplateField { HeaderText = "✓" };
                    tf.HeaderTemplate = new HeaderCheckTemplate(gvRelatedProdOrder, hfSelectedKeys);
                    tf.ItemTemplate = new RowCheckTemplate("No_", gvRelatedProdOrder, hfSelectedKeys);
                    gvRelatedProdOrder.Columns.Insert(0, tf);
                }

               
            }
            catch { }
        }
    }

    // Header & Row templates:
    public class HeaderCheckTemplate : ITemplate
    {
        private readonly GridView _gv; private readonly HiddenField _hf;
        public HeaderCheckTemplate(GridView gv, HiddenField hf) { _gv = gv; _hf = hf; }

        public void InstantiateIn(Control container)
        {
            var cb = new CheckBox { ID = "chkAll", Text = "" };
            // toggle by class, avoids ASP.NET mangled IDs problem
            cb.InputAttributes["onclick"] = $"toggleAll(this, '{_gv.ClientID}', '{_hf.ClientID}')";
            cb.InputAttributes["class"] = "form-check-input";
            container.Controls.Add(cb);
        }
    }

    public class RowCheckTemplate : ITemplate
    {
        private readonly string _keyField;
        private readonly GridView _gv; private readonly HiddenField _hf;
        public RowCheckTemplate(string keyField, GridView gv, HiddenField hf)
        { _keyField = keyField; _gv = gv; _hf = hf; }

        public void InstantiateIn(Control container)
        {
            var cb = new CheckBox { ID = "chkRow", CssClass = "row-check" }; // <- class used by header toggle
            cb.InputAttributes["class"] = "form-check-input row-check";

            cb.DataBinding += (s, e) =>
            {
                var cb = (CheckBox)s;
                var row = (GridViewRow)cb.NamingContainer;
                var drv = (DataRowView)row.DataItem;
                string key = drv[_keyField]?.ToString();

                // Write the key to client-side
                cb.InputAttributes["data-key"] = key;
                cb.InputAttributes["onclick"] = $"rowToggle(this, '{key}', '{_hf.ClientID}')";

                // Restore checked state
                var selected = (_hf.Value ?? "").Split(',').ToList();
                cb.Checked = selected.Contains(key);
            };

            container.Controls.Add(cb);
        }
    }
}
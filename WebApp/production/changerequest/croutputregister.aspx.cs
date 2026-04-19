using DevExpress.Utils.Filtering.Internal;
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
    public partial class croutputregister : System.Web.UI.Page
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
                UpdateValueToDepartment();
                SetPermissionToControl();
                bt1.Text = $"Submit - {Session["userid"].ToString()}";
                txtInputDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                try
                {
                    string sql = "SELECT distinct PINo FROM PRODUCTION_ChangeRequest WHERE [Status] = 1  ORDER BY PINo desc";
                    System.Data.DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                    Session["PIList"] = dt;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        ddPI.Items.Add(new ListItem(dt.Rows[i][0].ToString(), dt.Rows[i][0].ToString()));
                    }
                }
                catch { }

                //bt1.OnClientClick = $"sweetAlertConfirm('{bt1.UniqueID}','Do you want to post production output?','question')";
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

        public static void InsertChangeRequestOutput(
            string requestID,
            string prodOrderNo,
            string department,
            string toDepartment,
            decimal quantity,
            decimal price,
            string prodOrderDate,
            string updateUser,
            string updateUserID)
        {
            string sql = @"
                    EXEC [ALL_Insert_PRODUCTION_ChangeRequestOutput]                        
                        @RequestID, @ProdOrderNo, @Department, @ToDepartment, @Quantity, @Price,
                        @ProdOrderDate, @UpdateUser, @UpdateUserID
                    ";

            var paramNames = new List<string>
            {
                "@RequestID", "@ProdOrderNo", "@Department", "@ToDepartment",
                "@Quantity", "@Price", "@ProdOrderDate", "@UpdateUser", "@UpdateUserID"
            };

            var paramValues = new List<object>
            {
                requestID, prodOrderNo, department, toDepartment,
                quantity, price, prodOrderDate, (object)updateUser ?? DBNull.Value, (object)updateUserID ?? DBNull.Value
            };

            SQRLibrary.ExecuteSQL_mrp(sql, paramNames, paramValues);
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
                string RequestID = ddItemCode.SelectedValue;

                //string sqlUpdatePC = "exec UpdateProdOrderStatus '" + ddItemCode.SelectedValue + "'";
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");                
               
                string[] prefixes = { "RM", "FM", "AS", "SA", "SP", "FIN", "IRON", "UPH", "FIT", "TU", "PAC" };
                
                int count = 0;                
                List<string> successDept = new List<string>() { };
               
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

                                InsertChangeRequestOutput(
                                        RequestID,
                                        hfProOrderNo.Value,
                                        fromDropDown.ID.Substring(2),
                                        toDropDown.SelectedValue,
                                        SQRLibrary.ConvertToDecimal(fromDropDown.SelectedValue),
                                        Math.Round(SQRLibrary.ConvertToDecimal(hfSalePrice.Value), 4),
                                        txtInputDate.Text,
                                        $"{Session["username"]?.ToString() ?? ""} - {Session["userid"]?.ToString() ?? ""}",
                                        $"{Session["userid"]?.ToString() ?? ""}");

                                count++;
                                successDept.Add(prefix);
                            }
                        }
                    }
                    catch { }
                }

                if (count > 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Successfully added!', 'bg-success');", true);
                    
                    DataTable ChangeRequestHeader = GetProductionChangeRequestOutputByRequestID(RequestID);
                    if (ChangeRequestHeader == null || ChangeRequestHeader.Rows.Count <= 0) return;
                    DataRow r = ChangeRequestHeader.Rows[0];
                    FillOutputQuantityForAllDepartment(r);
                    FillRemainingOutputQtyToDropDownForAllDept(r);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Nothing to post!', 'bg-danger');", true);
                }                
            }
            catch { }
        }        
        protected void ddPI_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string sql = "SELECT * FROM PRODUCTION_ChangeRequest WHERE  PINo = @PINo";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@PINo" }, new List<object>() { ddPI.SelectedValue });
                ddItemCode.Items.Clear(); ddItemCode.Items.Add(new ListItem("- Select Item - ", "0"));
                              
                for (int i = 0; i < dt.Rows.Count; i++)
                {                    
                    ddItemCode.Items.Add(new ListItem($"{dt.Rows[i]["ProductName"].ToString()} - {dt.Rows[i]["RequestID"].ToString()}", dt.Rows[i]["RequestID"].ToString()));
                }

                ddItemCode_SelectedIndexChanged(ddItemCode, e);
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

                string[] prefixes = { "RM", "FM", "AS", "SA", "SP", "FIN", "IRON", "UPH", "FIT", "TU", "PAC", "WAREHOUSE" };

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
                toTU.SelectedValue = "PAC";
                toPAC.SelectedValue = "WAREHOUSE";
                
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
        private DataTable GetProductionChangeRequestOutputByRequestID(string RequestID)
        {
            DataTable rs = new DataTable();
            try
            {
                string sqlOutput = "EXEC [ALL_PRODUCTION_ChangeRequest] @RequestID = @RequestID";

                var paramNames = new List<string> { "@RequestID" };
                var paramValues = new List<object> { RequestID };

                rs = SQRLibrary.ReturnDatatablefromSQL_mrp(sqlOutput, paramNames, paramValues);
            }
            catch { }
            return rs;
        }

        private void FillRemainingOutputQtyToDropDownForAllDept(DataRow r)
        {
            try
            {
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {                    
                    try
                    {
                        if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                        {                            
                            dd.Items.Clear(); dd.Items.Add(new ListItem("- Select Qty " + dd.ID.Substring(2), "0"));
                            
                            decimal sldn = SQRLibrary.ConvertToDecimal(r[dd.ID.Substring(2)]);                          
                            decimal temp = SQRLibrary.ConvertToDecimal(r["TotalQuantity"]) - sldn;

                            decimal RoundingInterval = 1;
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
        private void FillOutputQuantityForAllDepartment(DataRow r)
        {
            try
            {                
                if (r == null) return;

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
               
                foreach (DropDownList dd in huu1.Controls.OfType<DropDownList>())
                {
                    try
                    {
                        if (!dd.ID.Equals("ddPI") && !dd.ID.Equals("ddItemCode") && !dd.ID.Substring(0, 2).Equals("to"))
                        { 
                            decimal sldn = SQRLibrary.ConvertToDecimal(r[dd.ID.Substring(2)]);                           
                            decimal temp = SQRLibrary.ConvertToDecimal(r["TotalQuantity"]) - sldn;
                            string t = "txt" + dd.ID.Substring(2) + "Quantity";

                            if (temp > 0)
                            {
                                ((TextBox)huu1.FindControl(t)).CssClass = "bg-warning text-white form-control";
                                ((TextBox)huu1.FindControl(t)).Text = $"{sldn.ToString("#0.####")}";                               
                            }
                            else
                            {
                                ((TextBox)huu1.FindControl(t)).Text = $"{sldn.ToString("#0.####")}";
                                ((TextBox)huu1.FindControl(t)).CssClass = "bg-success text-white form-control";
                            }
                        }
                    }
                    catch { }
                }
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
                    RemoveDataInField();
                    return;
                }

                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");

                string RequestID = ddItemCode.SelectedValue;
                DataTable ChangeRequestHeader = GetProductionChangeRequestOutputByRequestID(RequestID);
                if (ChangeRequestHeader == null || ChangeRequestHeader.Rows.Count <= 0) return;
                DataRow r = ChangeRequestHeader.Rows[0];

                lbDescription.Text = "Description: " + r["ChangeDescription"].ToString();
                lbQuantity.Text = "Quantity: " + SQRLibrary.ConvertToDouble(r["TotalQuantity"]).ToString("#0.##");

                hfSalePrice.Value = r["Price"].ToString();
                hfProdOrderQty.Value = SQRLibrary.ConvertToDouble(r["TotalQuantity"]).ToString("#0.##");
                hfProOrderNo.Value = r["ProdOrderNo"].ToString();

                FillOutputQuantityForAllDepartment(r);
                FillRemainingOutputQtyToDropDownForAllDept(r);

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
        private void RemoveDataInField()
        {
            ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
            UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
            Control huu1 = huu.FindControl("ctl00");

            lbDescription.Text = "Description: ";
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
            System.Data.DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@PINo" }, new List<object>() { pino });
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                result.Add(string.Format("{0}/{1}", dt.Rows[i]["PI"], dt.Rows[i]["PI"]));
            }
            return result;
        }               

        protected void btnHandleInputPIOrRequestID_Click(object sender, EventArgs e)
        {
            try
            {
                string DocNo = hfPI.Value; // txtPI.Text;

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC ALL_OUTPUT_Search_ProdChangeRequest_OrPI @text"
                    , new List<string>() { "@text" }
                    , new List<object>() { DocNo });

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    switch (r["Source"].ToString())
                    {
                        case "PI":
                            ddPI.SelectedValue = r["PI"].ToString();                            
                            ddPI_SelectedIndexChanged(sender, e);
                            break;

                        case "ChangeRequest":
                            ddPI.SelectedValue = r["PI"].ToString();
                            ddPI_SelectedIndexChanged(sender, e);
                            ddItemCode.SelectedValue = r["No_"].ToString();
                            ddItemCode_SelectedIndexChanged(sender, e);
                            break;
                    }
                }
            }
            catch { }
        }

        
    }
}
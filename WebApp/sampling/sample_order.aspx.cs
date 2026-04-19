using DevExpress.Web;
using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PIMS.Model;
using WebApp.Models.Extensions;
using System.Data.Entity.Migrations;
using System.Security.Cryptography;
using Microsoft.Ajax.Utilities;
using DevExpress.Xpo.Logger;
using DevExpress.Data.Browsing;
using System.Runtime.Remoting.Contexts;
using Microsoft.Reporting.Map.WebForms.BingMaps;
using System.Net.NetworkInformation;
using DataContext = PIMS.Model.DataContext;
using System.Web.Configuration;
using System.IO;
using OfficeOpenXml;
using System.ComponentModel;

namespace WebApp.requisition
{
    public partial class sample_order : System.Web.UI.Page
    {
        private const string VS_LINES = "LINES";

        #region Page Lifecycle

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsolutePath;
                Response.Redirect("~/Account/Login?Returnurl=" + url);
            }
            if (!IsPostBack)
            {
                //Session[VS_LINES] = CreateLineTable();
                //BindLines();
                cbHeaderType.SelectedIndex = 0;
                deOrderDate.Value = DateTime.Now;
                GenerateNewOrderNo();
                Session["UOMList"] = GetUOM();
                BindItemUOM();
                BindItemGrid("", true);
            }
            else
            {
                BindItemGrid();
            }
            BindCustomerGrid();            
            BindLines();
            //set default next item no after postback from Session
            txtNewItemNo.Text = Session["NewItemNo"]?.ToString() ?? "";

            //Keep Customer No
            beCustomer.Text = hfCustomerNo.Contains("CustomerNo") ? hfCustomerNo.Get("CustomerNo").ToString() : "";
        }

        #endregion

        #region Header Type & Order Number

        protected void cbHeaderType_SelectedIndexChanged(object sender, EventArgs e)
        {
            GenerateNewOrderNo();
        }

        private void GenerateNewOrderNo()
        {
            string prefix = GetPrefix(cbHeaderType.Value?.ToString());
            string nextNumber = GetNextNumber(prefix).ToString("0000");
            tbOrderNo.Text = $"{prefix}{nextNumber}";
        }

        private string GenerateNewOrderNo(string a)
        {
            string prefix = GetPrefix(cbHeaderType.Value?.ToString());
            string nextNumber = GetNextNumber(prefix).ToString("0000");
            return $"{prefix}{nextNumber}";
        }

        private string GetPrefix(string headerType) => headerType switch
        {
            "SMP" => $"SO-SMP{DateTime.Now.Year.ToString().Substring(2)}-",
            "SPC" => $"SO-SPC{DateTime.Now.Year.ToString().Substring(2)}-",
            _ => $"SO-OTH{DateTime.Now.Year.ToString().Substring(2)}-"
        };

        private int GetNextNumber(string prefix)
        {
            string sql = @"SELECT ISNULL(MAX(CAST(RIGHT([No_], 4) AS INT)), 0) AS MaxNo
                        FROM [LIVE_ALLIANCE_90$Sales Header]
                        WHERE [No_] LIKE @Prefix + '%'";
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@Prefix" }, new List<object>() { prefix });
            return SQRLibrary.ConvertToInt(dt.Rows[0][0]) + 1;
        }

        #endregion

        #region Customer Lookup & Grid

        protected void gvCustomerLookup_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string search = e.Parameters?.Trim() ?? "";
            string sql = @"
        SELECT [No_] AS CustomerNo, [Name], [Address]
        FROM [LIVE_ALLIANCE_90$Customer]
        WHERE (@Search = '' OR [No_] LIKE @Search + '%' OR [Name] LIKE '%' + @Search + '%' OR [Address] LIKE '%' + @Search + '%')
        ORDER BY [No_]";
            var paramNames = new List<string>() { "@Search" };
            var paramValues = new List<object>() { search };

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, paramNames, paramValues);

            gvCustomerLookup.DataSource = dt;
            gvCustomerLookup.DataBind();
        }

        protected void gvCustomerLookup_RowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "Select")
            {
                string customerNo = gvCustomerLookup.GetRowValues(e.VisibleIndex, "CustomerNo") as string;
                string customerName = gvCustomerLookup.GetRowValues(e.VisibleIndex, "Name") as string;
                string customerAddress = gvCustomerLookup.GetRowValues(e.VisibleIndex, "Address") as string;

                Session["SelectedCustomerNo"] = customerNo;
                Session["SelectedCustomerName"] = customerName;
                Session["SelectedCustomerAddress"] = customerAddress;
            }
        }

        private void BindCustomerGrid(string prefix = "")
        {
            if (Session["CustomerList"] == null)
            {
                string sql = @"SELECT [No_] AS CustomerNo, [Name], [Address] 
                   FROM [LIVE_ALLIANCE_90$Customer]
                   WHERE [No_] LIKE @Prefix + '%' OR @Prefix = ''";

                var paramNames = new List<string>() { "@Prefix" };
                var paramValues = new List<object>() { prefix ?? "" };

                Session["CustomerList"] = SQRLibrary.ReturnDatatablefromSQL(sql, paramNames, paramValues);
            }
            gvCustomerLookup.DataSource = Session["CustomerList"] as DataTable;
            gvCustomerLookup.DataBind();
        }

        #endregion

        #region UOM Helpers

        private void BindItemUOM()
        {
            cbNewUOM.DataSource = Session["UOMList"] as DataTable;
            cbNewUOM.ValueField = "Code";
            cbNewUOM.TextField = "Code";
            cbNewUOM.DataBind();
        }

        private DataTable GetUOM()
        {
            return SQRLibrary.ReturnDatatablefromSQL("SELECT Code FROM [LIVE_ALLIANCE_90$Unit of Measure]");
        }

        #endregion

        #region Lines Grid (CRUD, Events, Binding)

        private DataTable CreateLineTable()
        {
            var tbl = new DataTable();
            tbl.Columns.Add("LineID", typeof(Int32));
            tbl.Columns.Add("Type", typeof(string));
            tbl.Columns.Add("ItemNo", typeof(string));
            tbl.Columns.Add("Description", typeof(string));
            tbl.Columns.Add("Quantity", typeof(decimal));
            tbl.Columns.Add("Price", typeof(decimal));
            tbl.Columns.Add("UOM", typeof(string));
            tbl.Columns.Add("PromisedDate", typeof(DateTime));
            tbl.Columns.Add("RequestDate", typeof(DateTime));
            return tbl;
        }

        private void BindLines()
        {
            if (Session[VS_LINES] == null) Session[VS_LINES] = CreateLineTable();
            gvLines.DataSource = Session[VS_LINES] as DataTable;
            gvLines.DataBind();
        }

        protected void gvLines_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            if (string.IsNullOrWhiteSpace((e.NewValues["Description"] ?? "").ToString()))
                e.Errors[gvLines.Columns["Type"]] = "Description is required.";

            if (((string)e.NewValues["Description"]).Length > 50)
                e.Errors[gvLines.Columns["Type"]] = "Description must be at most 50 characters.";

            if (SQRLibrary.ConvertToInt(e.NewValues["Quantity"] ?? "0") <= 0)
                e.Errors[gvLines.Columns["Type"]] = "Quantity must be > 0.";

            if (string.IsNullOrWhiteSpace((e.NewValues["ItemNo"] ?? "").ToString()))
                e.Errors[gvLines.Columns["Type"]] = "Item No is required.";

            if (string.IsNullOrWhiteSpace((e.NewValues["UOM"] ?? "").ToString()))
                e.Errors[gvLines.Columns["Type"]] = "UOM is required.";
        }

        protected void gvLines_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            var tbl = Session[VS_LINES] as DataTable;

            int maxLineID = tbl.Rows.Count > 0
                ? tbl.AsEnumerable().Max(r => r.Field<int>("LineID"))
                : 0;

            int newLineID = maxLineID + 10000;

            tbl.Rows.Add(
                newLineID,
                e.NewValues["Type"],
                e.NewValues["ItemNo"],
                e.NewValues["Description"],
                e.NewValues["Quantity"] ?? 0m,
                e.NewValues["Price"] ?? 0m,
                e.NewValues["UOM"],
                e.NewValues["PromisedDate"],
                e.NewValues["RequestDate"]);

            e.Cancel = true;
            gvLines.CancelEdit();
            BindLines();
        }

        protected void gvLines_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            DataTable tbl = Session[VS_LINES] as DataTable;
            var row = tbl.Rows.Cast<DataRow>().First(r => r["LineID"].ToString() == e.Keys[0].ToString());

            row["Type"] = e.NewValues["Type"];
            row["ItemNo"] = e.NewValues["ItemNo"];
            row["Description"] = e.NewValues["Description"];
            row["Quantity"] = e.NewValues["Quantity"];
            row["Price"] = e.NewValues["Price"] ?? 0m;
            row["UOM"] = e.NewValues["UOM"];
            row["PromisedDate"] = e.NewValues["PromisedDate"] ?? DBNull.Value;
            row["RequestDate"] = e.NewValues["RequestDate"] ?? DBNull.Value;

            e.Cancel = true;
            gvLines.CancelEdit();
            BindLines();
        }

        protected void gvLines_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            var tbl = Session[VS_LINES] as DataTable;
            var row = tbl.AsEnumerable().First(r => r["LineID"].ToString() == e.Keys[0].ToString());
            tbl.Rows.Remove(row);

            e.Cancel = true;
            gvLines.CancelEdit();
            BindLines();
        }

        protected void gvLines_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            e.NewValues["Type"] = "Item";
            e.NewValues["Quantity"] = 0;
            e.NewValues["RequestDate"] = DateTime.Now.Date;
            e.NewValues["PromisedDate"] = DateTime.Now.Date;
        }

        protected void gvLines_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "ItemNo")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += ItemCombo_Callback;

                string objectType = gvLines.GetRowValues(e.VisibleIndex, "Type")?.ToString() ?? Session["OrderType"]?.ToString();
                if (!string.IsNullOrEmpty(objectType))
                {
                    combo.DataSource = GetItemsByType(objectType);
                    combo.TextField = "ItemNo";
                    combo.ValueField = "ItemNo";
                    combo.DataBind();
                }
                else
                {
                    objectType = "Item";
                    combo.DataSource = GetItemsByType(objectType);
                    combo.TextField = "ItemNo";
                    combo.ValueField = "ItemNo";
                    combo.DataBind();
                }
            }
            if (e.Column.FieldName == "UOM")
            {
                ASPxComboBox combo = (ASPxComboBox)e.Editor;
                combo.DataSource = Session["UOMList"] as DataTable;
                combo.DropDownStyle = DropDownStyle.DropDownList;
                combo.ValueField = "Code";
                combo.TextField = "Code";
                combo.DataBindItems();
            }
        }

        protected void gvLines_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            var args = e.Parameters.Split('|');
            if (args.Length == 2 && args[0] == "GetObjectName")
            {
                string objectNo = args[1];
                string objectName = LookupObjectName(objectNo);
                gvLines.JSProperties["cpObjectName"] = objectName;
            }
        }

        private string LookupObjectName(string objectNo)
        {
            var objects = new Dictionary<string, string>
            {
                { "C001", "Customer ABC" },
                { "V001", "Vendor XYZ" }
            };
            return objects.ContainsKey(objectNo) ? objects[objectNo] : "ss";
        }

        #endregion

        #region Item Lookup & Adding

        private void ResetItemAdd()
        { }
        private void BindItemGrid(string search = "", bool refresh = false)
        {
            if (refresh || Session["ItemList_gvItemLookup"] == null)
            {
                string sql = @"SELECT i.No_ ItemNo, i.Description, i.[Base Unit of Measure] UOM
                        , ci.FullName, ci.FullRemark
                        FROM [LIVE_ALLIANCE_90$Item] i
                        INNER JOIN Custom_ItemInformation ci ON ci.ItemCode = i.No_ 
                        WHERE @search = '' OR No_ LIKE '%' + @search + '%' OR Description LIKE '%' + @search + '%'
                        ORDER BY No_";
                Session["ItemList_gvItemLookup"] = SQRLibrary.ReturnDatatablefromSQL(
                    sql,
                    new List<string> { "@search" },
                    new List<object> { search }
                );
            }
            gvItemLookup.DataSource = Session["ItemList_gvItemLookup"] as DataTable;
            gvItemLookup.DataBind();
        }

        protected void gvItemLookup_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            BindItemGrid(e.Parameters);
        }

        protected void btnSaveNewItem_Click(object sender, EventArgs e)
        {
            try
            {
                string prefix = $"ITEM-{(cbHeaderType.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-";
                string nextItemNo = GetNextItemNo(prefix);
                var itemNo = nextItemNo;
                var itemNo2 = txtNewItemNo2.Text.Trim();
                var uom = cbNewUOM.Value?.ToString();
                var itemType = SQRLibrary.ConvertToInt(cbNewItemType.Value?.ToString());
                var desc = memoNewDescription.Text.Trim();
                var fullDesc = memoNewFullDescription.Text.Trim();
                var length = spnNewLength.Value == null ? 0 : Convert.ToDecimal(spnNewLength.Value);
                var width = spnNewWidth.Value == null ? 0 : Convert.ToDecimal(spnNewWidth.Value);
                var height = spnNewHeight.Value == null ? 0 : Convert.ToDecimal(spnNewHeight.Value);

                if (desc.Length <= 0)
                {                    
                    ShowErrorMessage("Description must have value");
                    return;
                }

                bool isInserted = InsertNewItem(itemNo, itemNo2, desc, fullDesc, uom, itemType, length, width, height);

                if (!isInserted)
                {
                    ShowErrorMessage("Something went wrong");
                    return;
                }

              
                txtNewItemNo.Text = GetNextItemNo(prefix);
                cbNewUOM.Value = "PCS";
                txtNewItemNo2.Text = "";
                memoNewDescription.Text = "";
                memoNewFullDescription.Text = "";
                spnNewLength.Value = "";
                spnNewWidth.Value = "";
                spnNewHeight.Value = "";

                Session["ItemList_gvItemLookup"] = null; //clear session to reload item list
                BindItemGrid();
               
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "HideItemAddPopup", "setTimeout(function() {alert('out'); pcItemAdd.Hide();}, 300};", true);
                ShowSuccessMessage("Added successfully!");                
            }
            catch { }
        }

        protected void pcItemAdd_WindowCallback(object source, PopupWindowCallbackArgs e)
        {
            string prefix = $"ITEM-{(cbHeaderType.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-";
            string nextItemNo = GetNextItemNo(prefix);
            txtNewItemNo.Text = nextItemNo;
            
            cbNewUOM.Text = "PCS";
        }

        private bool InsertNewItem(string ItemCode, string ItemCode2, string Description, string FullDescription,
            string UOM, int ItemType, decimal Length, decimal Width, decimal Height)
        {
            try
            {
                DataContext h = new DataContext();
                LIVE_ALLIANCE_90_Item template = h.LIVE_ALLIANCE_90_Item.FirstOrDefault(x => x.No_ == "ITEM_TEMPLATE");
                LIVE_ALLIANCE_90_Item_Unit_of_Measure unit_template = h.LIVE_ALLIANCE_90_Item_Unit_of_Measure.FirstOrDefault(x => x.Item_No_ == "ITEM_TEMPLATE" && x.Qty__per_Unit_of_Measure == 1);

                if (template == null || unit_template == null) return false;

                LIVE_ALLIANCE_90_Item item_buff = new LIVE_ALLIANCE_90_Item();
                LIVE_ALLIANCE_90_Item_Unit_of_Measure uom_buff = new LIVE_ALLIANCE_90_Item_Unit_of_Measure();
                Custom_ItemInformation custom_ItemInformation = new Custom_ItemInformation();

                LIVE_ALLIANCE_90_Timber_Finish timberFinish = new LIVE_ALLIANCE_90_Timber_Finish();
                LIVE_ALLIANCE_90_Leg_Finish metalFabricFinish = new LIVE_ALLIANCE_90_Leg_Finish();

                item_buff.CopyPropertiesFrom(template);
                uom_buff.CopyPropertiesFrom(unit_template);

                var description = SplitLongString(FullDescription);
                string ItemName = RemoveFirstAndLastChar(Description);

                item_buff.No_ = ItemCode;
                item_buff.No__2 = ItemCode2;
                item_buff.Description = ItemName.Length > 50 ? ItemName.Substring(0, 50) : ItemName;
                item_buff.Search_Description = item_buff.Description;
                item_buff.Base_Unit_of_Measure = UOM.ToUpper();
                item_buff.Full_Description = description.part1;
                item_buff.Full_Search_Description = description.part2;
                item_buff.Sales_Unit_of_Measure = item_buff.Base_Unit_of_Measure;
                item_buff.Purch__Unit_of_Measure = item_buff.Base_Unit_of_Measure;
                item_buff.ItemType = ItemType;
                item_buff.Last_Date_Modified = DateTime.Now.Date;
                item_buff.Packing_Description = "";
                item_buff.Length = Length;
                item_buff.Width = Width;
                item_buff.Height = Height;

                uom_buff.Item_No_ = ItemCode;
                uom_buff.Code = item_buff.Base_Unit_of_Measure;
                uom_buff.Length = item_buff.Length;
                uom_buff.Width = item_buff.Width;
                uom_buff.Height = item_buff.Height;

                custom_ItemInformation.ItemCode = ItemCode;
                custom_ItemInformation.FullRemark = RemoveFirstAndLastChar(FullDescription);
                custom_ItemInformation.FullName = ItemName;
                custom_ItemInformation.SiteOrderDescription = "";
                custom_ItemInformation.DrawingCode = "";
                custom_ItemInformation.DrawingVersionCode = "";
                custom_ItemInformation.DrawingNote = "";

                h.LIVE_ALLIANCE_90_Item.AddOrUpdate(item_buff);
                h.LIVE_ALLIANCE_90_Item_Unit_of_Measure.AddOrUpdate(uom_buff);
                h.Custom_ItemInformation.AddOrUpdate(custom_ItemInformation);
                h.SaveChanges();
                return true;
            }
            catch { return false; }
        }

        public string GetNextItemNo(string prefix)
        {
            string sql = @"
                SELECT ISNULL(MAX(CAST(SUBSTRING([No_], LEN(@Prefix) + 1, 10) AS INT)), 0)
                FROM [LIVE_ALLIANCE_90$Item] 
                WHERE [No_] LIKE @Prefix + '%'
            ";

            var maxNo = (int)SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@Prefix" },
                new List<object> { prefix }
            ).Rows[0][0];

            int nextNo = maxNo + 1;
            Session["NewItemNo"] = prefix + nextNo.ToString("D5");
            return prefix + nextNo.ToString("D5");
        }

        #endregion

        #region Item Helper (Combo, ItemByType, Remove, Split)

        protected void ItemCombo_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            var editor = (ASPxComboBox)sender;
            string type = e.Parameter;
            Session["OrderType"] = type;
            editor.DataSource = GetItemsByType(type);
            editor.ValueField = "ItemNo";
            editor.TextField = "ItemNo";
            editor.DataBindItems();
        }

        public static DataTable GetItemsByType(string typeCode)
        {
            var tbl = new DataTable();
            tbl.Columns.Add("ItemNo");
            if (typeCode == "Item") { tbl.Rows.Add("N‑1001"); tbl.Rows.Add("N‑1002"); }
            else if (typeCode == "Service") { tbl.Rows.Add("S‑2001"); tbl.Rows.Add("S‑2002"); }
            else if (typeCode == "Charge") tbl.Rows.Add("C‑3001");
            return tbl;
        }

        private string RemoveFirstAndLastChar(string input)
        {
            if (string.IsNullOrEmpty(input) || input.Length < 2)
                return input;

            if (input[0] == '"' && input[input.Length - 1] == '"')
                return input.Substring(1, input.Length - 2);

            return input;
        }

        private (string part1, string part2) SplitLongString(string input)
        {
            try
            {
                input = RemoveFirstAndLastChar(input);
                if (string.IsNullOrEmpty(input))
                    return (" ", " ");

                if (input.Length <= 250)
                    return (input, " ");

                string part1 = input.Substring(0, 250);
                string part2 = input.Length > 500 ? input.Substring(251, 250) : input.Substring(251);

                return (part1, part2);
            }
            catch { return (" ", " "); }
        }

        #endregion

        #region Save Order

        protected void btnSaveOrder_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateOrderHeader()) return;

                DataTable dtLines = Session[VS_LINES] as DataTable;
                if (dtLines == null || dtLines.Rows.Count <= 0)
                {
                    ShowErrorMessage("The lines is empty. Nothing to do");
                    return;
                }

                bool saveSuccess = false;

                //save header, if success, continue save live
                string OrderNo = SaveHeader();
                if (string.IsNullOrEmpty(OrderNo))
                {
                    ShowErrorMessage("Insert Header failed. Please check data");
                    return;
                }
                               

                try
                {                    
                    if (dtLines != null && dtLines.Rows.Count > 0)
                    {
                        PIMS.Model.DataContext context = new PIMS.Model.DataContext();
                        LIVE_ALLIANCE_90_Sales_Line line_template = context.LIVE_ALLIANCE_90_Sales_Line.FirstOrDefault(x => x.Document_Type == 6 && x.Document_No_ == "TENDER_TEMPLATE");
                        LIVE_ALLIANCE_90_Sales_Line line = new LIVE_ALLIANCE_90_Sales_Line();
                        if (line_template == null)
                        {
                            ShowErrorMessage("Line Template not found");
                            return;
                        }

                        foreach (DataRow row in dtLines.Rows)
                        {
                            int LineID = SQRLibrary.ConvertToInt(row["LineID"]);
                            int Type = SQRLibrary.ConvertToInt(row["Type"]);
                            string itemNo = row["ItemNo"].ToString();
                            string desc = row["Description"].ToString();
                            decimal qty = Convert.ToDecimal(row["Quantity"]);
                            decimal price = Convert.ToDecimal(row["Price"]);
                            string uom = row["UOM"].ToString();
                            DateTime promisedDate = row["PromisedDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(row["PromisedDate"]);
                            DateTime requestDate = row["RequestDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(row["RequestDate"]);
                            
                            line = new LIVE_ALLIANCE_90_Sales_Line();
                            line.CopyPropertiesFrom(line_template);
                            line.Line_No_ = LineID;
                            line.Document_Type = 7;
                            line.Document_No_ = OrderNo;
                            line.No_ = itemNo;
                            line.Quantity = qty;
                            line.Unit_Price = price;
                            line.Quantity__Base_ = qty;
                            line.Requested_Delivery_Date = requestDate;
                            line.Promised_Delivery_Date = promisedDate;                            
                            line.Amount = line.Unit_Price * qty;
                            line.Amount_Including_VAT = line.Amount;
                            line.Description = desc;
                            line.Unit_of_Measure_Code = uom;

                            context.LIVE_ALLIANCE_90_Sales_Line.Add(line);
                            context.SaveChanges();
                            saveSuccess = true;
                        }
                    }                   
                     
                }
                catch (Exception ex)
                {                    
                    saveSuccess = false;
                }

                // On success: Clear session, reset UI, show message
                if (saveSuccess)
                {
                    Session.Remove(VS_LINES);
                    BindLines();
                    GenerateNewOrderNo();
                    beCustomer.Text = "";
                    deOrderDate.Date = DateTime.Today;
                    
                    memoAddress.Text = "";
                    ShowSuccessMessage("Order saved successfully!");
                  
                }
                else
                {
                    ShowErrorMessage("Save failed. Please try again.");                   
                }
            }
            catch (Exception ex ){ ShowErrorMessage(ex.Message); }
            
            //Response.Redirect($"SalesOrderView.aspx?doc={tbOrderNo.Text}");
        }
        private bool ValidateOrderHeader()
        {
            // Order No required
            if (string.IsNullOrWhiteSpace(tbOrderNo.Text))
            {
                ShowErrorMessage("Order No is required.");
                return false;
            }
            // Order Date required
            if (deOrderDate.Value == null)
            {
                ShowErrorMessage("Order Date is required.");
                return false;
            }
            // Allocate For required
            if (string.IsNullOrWhiteSpace(cbAllocate.Value?.ToString()))
            {
                ShowErrorMessage("Allocate For is required.");
                return false;
            }

            // Customer No required
            if (!hfCustomerNo.Contains("CustomerNo"))
            {
                ShowErrorMessage("Customer No is required.");
                return false;
            }
            else
            {
                string customerNo = hfCustomerNo.Get("CustomerNo") as string;
                if (string.IsNullOrWhiteSpace(customerNo))
                {
                    ShowErrorMessage("Customer No is required.");
                    return false;
                }
            } 
            
            // Customer Name required
            if (string.IsNullOrWhiteSpace(tbCustName.Text))
            {
                ShowErrorMessage("Customer Name is required.");
                return false;
            }
            // Address required
            if (string.IsNullOrWhiteSpace(memoAddress.Text))
            {
                ShowErrorMessage("Customer Address is required.");
                return false;
            }

            if (tbNote.Text.Length > 100)
            {
                ShowErrorMessage("Customer Address is required.");
                return false;
            }
            // (Optional) Note can be optional, skip validation
            return true; // All checks passed
        }
        private string SaveHeader()
        {
            try
            {
                string orderNo = GenerateNewOrderNo("");
                DateTime? orderDate = deOrderDate.Value as DateTime?;
                string allocateFor = cbAllocate.Value?.ToString();
                string note = tbNote.Text.Trim();

                string customerNo = beCustomer.Text.Trim();
                string customerName = tbCustName.Text.Trim();
                string address = memoAddress.Text.Trim();
                string projectType = cbProjectType.Value?.ToString();

                PIMS.Model.DataContext context = new PIMS.Model.DataContext();

                LIVE_ALLIANCE_90_Sales_Header SaleOrderTemplate = context.LIVE_ALLIANCE_90_Sales_Header.FirstOrDefault(x => x.Document_Type == 6 && x.No_ == "TENDER_TEMPLATE");
                LIVE_ALLIANCE_90_Sales_Header header = new LIVE_ALLIANCE_90_Sales_Header();
                if (SaleOrderTemplate == null) return "";

                header.CopyPropertiesFrom(SaleOrderTemplate);
                header.Document_Type = 7; //6 Tender; 4 Blanket Order, 7: Factory and Site Order
                header.No_ = orderNo;
                header.Sell_to_Customer_No_ = customerNo;
                header.Sell_to_Customer_Name = customerName;
                header.Sell_to_Address = address;
                header.JobNo = cbHeaderType.Text;
                header.Order_Class = projectType;
                header.AllocationFor = SQRLibrary.ConvertToInt(allocateFor);
                header.Status = 0;
                header.LastUpdatedDate = DateTime.Now;
                header.LastUpdatedUser = $"{Session["userid"].ToString()}: {Session["username"].ToString()}";

                context.LIVE_ALLIANCE_90_Sales_Header.AddOrUpdate(header);
                context.SaveChanges();

                return orderNo;
            }
            catch { return ""; }
        }
        #endregion

        #region SweetAlert2 common
        private void ShowErrorMessage(string Message)
        {
            string error_script = "Swal.fire({ position: 'top-end', type: 'error', title:'" + Message + "', showConfirmButton: false, timer: 2000 });";            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ErrorAlert2Message", error_script, true);
        }

        private void ShowSuccessMessage(string Message)
        {            
            string success = @"Swal.fire({ position: ""top-end"", type: ""success"", title: '" + Message + "', showConfirmButton: false, timer: 2000 });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessAlert2Message", success, true);
        }
        #endregion

        protected void ucImportExcel_FileUploadComplete(object sender, DevExpress.Web.FileUploadCompleteEventArgs e)
        {
            if (!e.IsValid) return;

            ExcelPackage.License.SetNonCommercialPersonal("HuuNguyen");

            // 1. Load uploaded Excel into DataTable
            DataTable imported = new DataTable();
            using (var ms = new MemoryStream(e.UploadedFile.FileBytes))
            using (var package = new OfficeOpenXml.ExcelPackage(ms))
            {
                var worksheet = package.Workbook.Worksheets.First();
                // Example: Map columns, add as needed
                imported.Columns.Add("LineID", typeof(Int32));
                imported.Columns.Add("Type", typeof(string));
                imported.Columns.Add("ItemNo", typeof(string));
                imported.Columns.Add("Description", typeof(string));
                imported.Columns.Add("Quantity", typeof(decimal));
                imported.Columns.Add("Price", typeof(decimal));
                imported.Columns.Add("UOM", typeof(string));
                imported.Columns.Add("PromisedDate", typeof(DateTime));
                imported.Columns.Add("RequestDate", typeof(DateTime));

                int startRow = 2; // assume first row is header
                for (int row = startRow; row <= worksheet.Dimension.End.Row; row++)
                {
                    var dr = imported.NewRow();
                    dr["LineID"] = worksheet.Cells[row, 1].GetValue<int>();
                    dr["Type"] = worksheet.Cells[row, 2].GetValue<string>();
                    dr["ItemNo"] = worksheet.Cells[row, 3].GetValue<string>();
                    dr["Description"] = worksheet.Cells[row, 4].GetValue<string>();
                    dr["Quantity"] = worksheet.Cells[row, 5].GetValue<decimal>();
                    dr["Price"] = worksheet.Cells[row, 6].GetValue<decimal>();
                    dr["UOM"] = worksheet.Cells[row, 7].GetValue<string>();
                    dr["PromisedDate"] = worksheet.Cells[row, 8].GetValue<DateTime>();
                    dr["RequestDate"] = worksheet.Cells[row, 9].GetValue<DateTime>();
                    imported.Rows.Add(dr);
                }
            }

            // 2. Merge/replace with current session lines
            Session[VS_LINES] = imported;
            e.CallbackData = "OK";
        }

        protected void cbRebindLines_Callback(object source, CallbackEventArgs e)
        {
            BindLines();
        }
    }
}

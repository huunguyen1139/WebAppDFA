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

namespace WebApp.requisition
{
    public partial class sample_order : System.Web.UI.Page
    {
        private const string VS_LINES = "LINES";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // initialise empty lines table
                Session[VS_LINES] = CreateLineTable();
                BindLines();
                // pre‑select header type
                cbHeaderType.SelectedIndex = 0;
                deOrderDate.Value = DateTime.Now;
                GenerateNewOrderNo();
                Session["UOMList"] = GetUOM();
                BindItemUOM();

            }
            BindCustomerGrid();
            BindItemGrid();
        }
        private void BindItemUOM()
        {
            // Bind UOM ComboBox (or do it only when needed)
            cbNewUOM.DataSource = Session["UOMList"] as DataTable; // your method, returns DataTable
            cbNewUOM.ValueField = "Code";
            cbNewUOM.TextField = "Code";
            cbNewUOM.DataBind();
        }
        private DataTable GetUOM()
        {
            return SQRLibrary.ReturnDatatablefromSQL("SELECT Code FROM [LIVE_ALLIANCE_90$Unit of Measure]");
        }

        /* -------- HEADER TYPE & ORDER NUMBER -------- */
        protected void cbHeaderType_SelectedIndexChanged(object sender, EventArgs e)
        {
            GenerateNewOrderNo();
        }
        protected void gvCustomerLookup_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
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
        protected void gvCustomerLookup_RowCommand(object sender, DevExpress.Web.ASPxGridViewRowCommandEventArgs e)
        {
            if (e.CommandArgs.CommandName == "Select")
            {
                // Get the selected CustomerNo (KeyFieldName)
                string customerNo = gvCustomerLookup.GetRowValues(e.VisibleIndex, "CustomerNo") as string;
                string customerName = gvCustomerLookup.GetRowValues(e.VisibleIndex, "Name") as string;
                string customerAddress = gvCustomerLookup.GetRowValues(e.VisibleIndex, "Address") as string;

                // Set these values to your form controls.
                // For example, you might store them in Session or hidden fields for use after popup closes:
                Session["SelectedCustomerNo"] = customerNo;
                Session["SelectedCustomerName"] = customerName;
                Session["SelectedCustomerAddress"] = customerAddress;

                // Or, if you have beCustomer and name/address on the parent form and use AJAX,
                // set them via client-side JavaScript after closing the popup (see below).
            }
        }
        private void GenerateNewOrderNo()
        {
            string prefix = GetPrefix(cbHeaderType.Value?.ToString());
            
            string nextNumber = GetNextNumber(prefix).ToString("0000"); // TODO: query DB or series table
            tbOrderNo.Text = $"{prefix}{nextNumber}";
        }
        private string GetPrefix(string headerType) => headerType switch
        {
            "SMP" => $"SO-SMP{DateTime.Now.Year.ToString().Substring(2)}-",
            "SPC" => $"SO-SPC{DateTime.Now.Year.ToString().Substring(2)}-",
            _ => $"SO-OTH{DateTime.Now.Year.ToString().Substring(2)}-"
        };


        /* -------- LINES GRID DATA -------- */
        private DataTable CreateLineTable()
        {
            var tbl = new DataTable();
            tbl.Columns.Add("LineID", typeof(Int32));
            tbl.Columns.Add("Type", typeof(string));
            tbl.Columns.Add("ItemNo", typeof(string));
            tbl.Columns.Add("Description", typeof(string));
            tbl.Columns.Add("Quantity", typeof(decimal));
            tbl.Columns.Add("UOM", typeof(string));
            tbl.Columns.Add("PromisedDate", typeof(DateTime));
            tbl.Columns.Add("RequestDate", typeof(DateTime));
            return tbl;
        }

        private void BindLines()
        {
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

        }
        protected void gvLines_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            var tbl = Session[VS_LINES] as DataTable;

            // Find current max LineID
            int maxLineID = 0;
            if (tbl.Rows.Count > 0)
            {
                maxLineID = tbl.AsEnumerable()
                               .Max(r => r.Field<int>("LineID"));
            }

            // Increment by 1000
            int newLineID = maxLineID + 10000;

            tbl.Rows.Add(
                newLineID,
                e.NewValues["Type"],
                e.NewValues["ItemNo"],
                e.NewValues["Description"],
                e.NewValues["Quantity"] ?? 0m,
                e.NewValues["UOM"],
                e.NewValues["PromisedDate"],
                e.NewValues["RequestDate"]);

            e.Cancel = true; // we handled it
            gvLines.CancelEdit();
            BindLines();
        }
        protected void gvLines_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            DataTable tbl = Session[VS_LINES] as DataTable;
            var row = tbl.Rows
                .Cast<DataRow>()
                .First(r => r["LineID"].ToString() == e.Keys[0].ToString());

            row["Type"] = e.NewValues["Type"];
            row["ItemNo"] = e.NewValues["ItemNo"];
            row["Description"] = e.NewValues["Description"];
            row["Quantity"] = e.NewValues["Quantity"];
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

        /* -------- SAVE ORDER -------- */
        protected void btnSaveOrder_Click(object sender, EventArgs e)
        {
            // 1) insert header to DB
            //    Header table should include OrderNo, HeaderType (perhaps store the prefix), CustomerNo etc.
            // 2) insert line rows (loop tbl.Rows)

            // After save:
            // Redirect to view page or clear form
            Response.Redirect($"SalesOrderView.aspx?doc={tbOrderNo.Text}");
        }

        /* -------- UTIL -------- */
        private int GetNextNumber(string prefix)
        {
            string sql = @"SELECT ISNULL(MAX(CAST(RIGHT([No_], 4) AS INT)), 0) AS MaxNo
                        FROM [LIVE_ALLIANCE_90$Sales Header]
                        WHERE [No_] LIKE @Prefix + '%'";
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@Prefix" }, new List<object>() { prefix });
            return  SQRLibrary.ConvertToInt(dt.Rows[0][0]) + 1;
        }

        public static DataTable GetItemsByType(string typeCode)
        {
            // demo only – replace with real DB query
            // SELECT ItemNo FROM Items WHERE Type = @typeCode ORDER BY ItemNo
            var tbl = new DataTable();
            tbl.Columns.Add("ItemNo");
            if (typeCode == "Item") { tbl.Rows.Add("N‑1001"); tbl.Rows.Add("N‑1002"); }

            else if (typeCode == "Service") { tbl.Rows.Add("S‑2001"); tbl.Rows.Add("S‑2002"); }

            else if (typeCode == "Charge") tbl.Rows.Add("C‑3001");
            return tbl;
        }

        private void BindCustomerGrid(string prefix = "")
        {
            if (Session["CustomerList"] == null)
            {
                string sql = @"SELECT [No_] AS CustomerNo, [Name], [Address] 
                   FROM [LIVE_ALLIANCE_90$Customer]
                   WHERE [No_] LIKE @Prefix + '%' OR @Prefix = ''";

                // Use your custom library for parameterized query
                var paramNames = new List<string>() { "@Prefix" };
                var paramValues = new List<object>() { prefix ?? "" };

                Session["CustomerList"] = SQRLibrary.ReturnDatatablefromSQL(sql, paramNames, paramValues);
            }
            gvCustomerLookup.DataSource = Session["CustomerList"] as DataTable ;
            gvCustomerLookup.DataBind();
        }
        protected void ItemCombo_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            var editor = (ASPxComboBox)sender;
            string type = e.Parameter;          // value sent from JS
            Session["OrderType"] = type;
            editor.DataSource = GetItemsByType(type);
            editor.ValueField = "ItemNo";
            editor.TextField = "ItemNo";
            editor.DataBindItems();             // bind *inside* the callback
        }        
        protected void gvLines_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "ItemNo")           // the column you named above
            {
                var combo = (ASPxComboBox)e.Editor;     // editor object
                combo.Callback += ItemCombo_Callback; // hook server event

                //combo.Items.Clear();
                string objectType = gvLines.GetRowValues(e.VisibleIndex, "Type")?.ToString() ?? Session["OrderType"]?.ToString();
                if (!string.IsNullOrEmpty(objectType))
                {
                    combo.DataSource = GetItemsByType(objectType);
                    combo.TextField = "ItemNo";
                    combo.ValueField = "ItemNo";
                    combo.DataBind();
                } else                    
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

                // Fetch object name based on objectNo
                string objectName = LookupObjectName(objectNo);

                // Store it temporarily for client-side use
                gvLines.JSProperties["cpObjectName"] = objectName;
            }
        }
        private string LookupObjectName(string objectNo)
        {
            // Replace with your actual logic
            var objects = new Dictionary<string, string>
    {
        { "C001", "Customer ABC" },
        { "V001", "Vendor XYZ" }
    };

            return objects.ContainsKey(objectNo) ? objects[objectNo] : "ss";
        }

        protected void gvLines_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            e.NewValues["Type"] = "Item";
            e.NewValues["Quantity"] = 0;
            e.NewValues["RequestDate"] = DateTime.Now.Date;
            e.NewValues["PromisedDate"] = DateTime.Now.Date;
            
        }

        
        private void BindItemGrid(string search = "")
        {
            if (Session["ItemList"] == null)
            {
                string sql = @"SELECT i.No_ ItemNo, i.Description, i.[Base Unit of Measure] UOM
                        , ci.FullName, ci.FullRemark
                        FROM [LIVE_ALLIANCE_90$Item] i
                        INNER JOIN Custom_ItemInformation ci ON ci.ItemCode = i.No_ 
                        WHERE @search = '' OR No_ LIKE '%' + @search + '%' OR Description LIKE '%' + @search + '%'
                        ORDER BY No_";
                Session["ItemList"] = SQRLibrary.ReturnDatatablefromSQL(
                    sql,
                    new List<string> { "@search" },
                    new List<object> { search }
                    );
            }
            gvItemLookup.DataSource = Session["ItemList"] as DataTable;
            gvItemLookup.DataBind();
        }
        protected void gvItemLookup_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            BindItemGrid(e.Parameters);
        }


        protected void btnSaveNewItem_Click(object sender, EventArgs e)
        {
            try
            {
                string prefix = $"ITEM-{(cbHeaderType.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-"; // Get prefix from current header type control
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

                string error_script = @"
                        Swal.fire({
                          position: ""top-end"",
                          type: ""error"",
                          title: ""Error while inserting new item"",
                          showConfirmButton: false,
                          timer: 2500
                        });";

                string success = @"
                        Swal.fire({
                          position: ""top-end"",
                          type: ""success"",
                          title: ""Your work has been saved"",
                          showConfirmButton: false,
                          timer: 2500
                        });";

                if (desc.Length <= 0) 
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "HideItemAddPopup", error_script, true);
                    return; 
                }

                bool isInserted = InsertNewItem(itemNo, itemNo2, desc, fullDesc, uom, itemType, length, width, height);

                if (!isInserted)
                {
                    
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "HideItemAddPopup", error_script, true);
                    return; 
                }                    

                BindItemGrid();
                
                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideItemAddPopup", success + "pcItemAdd.Hide();", true);
            }
            catch { }
        }

        private bool InsertNewItem(string ItemCode, string ItemCode2, string Description, string FullDescription
            , string UOM, int ItemType, decimal Length, decimal Width, decimal Height)
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
            } catch { return false; }
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
        public static string GetNextItemNo(string prefix)
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

            // ITEM-SMP25-00001
            int nextNo = maxNo + 1;
            return prefix + nextNo.ToString("D5");
        }
        protected void pcItemAdd_WindowCallback(object source, PopupWindowCallbackArgs e)
        {
            string prefix = $"ITEM-{(cbHeaderType.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-"; // Get prefix from current header type control
            string nextItemNo = GetNextItemNo(prefix);
            txtNewItemNo.Text = nextItemNo;
            cbNewUOM.Text = "PCS";
        }
    }
}
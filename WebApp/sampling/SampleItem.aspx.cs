using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;
using DevExpress.Web;
using PIMS.Model;
using WebApp.Models.Extensions;
using System.Data.Entity.Migrations;

namespace WebApp.sampling
{
    public partial class SampleItem : System.Web.UI.Page
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
                Session["UOMList"] = GetUOM();
                Session["ItemList"] = GetItemTable();
                BindItemUOM();
                cbNewUOM.Text = "PCS";
                CreateItemNo();
            }
            BindGrid();
        }

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
        private void BindGrid(bool Refresh = false)
        {
            if (Refresh) Session["ItemList"] = GetItemTable();
            gvItems.DataSource = Session["ItemList"] as DataTable;
            gvItems.DataBind();
        }

        /* ------------------------------------------------------------------ */
        /*  Data access                                                       */
        /* ------------------------------------------------------------------ */

        protected string ShortPreview(object val)
        {
            var full = (val ?? "").ToString();
            // first 20 chars plus ellipsis (adjust length if you like)
            return full.Length > 20 ? full.Substring(0, 20) + "…" : full;
        }

        private DataTable GetItemTable()
        {
            const string sql = @"
                    SELECT  i.No_, i.[No_ 2] ItemNo2,
                            ci.FullName,
                            ci.FullRemark,
                            i.[Base Unit of Measure]   AS UOM,
                            i.[Length],
                            i.Width,
                            i.Height,
                            ci.DrawingCode,
                            ci.DrawingVersionCode,
                            i.[Packing Description],
                            CASE
                                WHEN LEFT(i.No_, 4) = 'ITEM'                       THEN '/huu2/' + LEFT(i.No_, 10)+'/' + i.No_ + '.png'
                                WHEN (LEFT(i.No_, 2) = 'DA') AND (LEN(i.No_) >=12) THEN '/image/' + LEFT(i.No_,12) + '.png'
                                ELSE '/huu2/' + LEFT(i.No_,2)+'/' + i.No_ + '.png'
                            END AS ImageURL
                    FROM    [LIVE_ALLIANCE_90$Item] i
                    LEFT JOIN Custom_ItemInformation ci ON i.No_ = ci.ItemCode
                    WHERE   i.No_ LIKE 'ITEM-S%';";

            

            return SQRLibrary.ReturnDatatablefromSQL(sql);
        }

        /* ------------------------------------------------------------------ */
        /*  Editing: insert / update / delete                                 */
        /* ------------------------------------------------------------------ */

        protected void gvItems_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            using (var conn = new SqlConnection(GetConn()))
            using (var cmd = new SqlCommand(@"
INSERT INTO Custom_ItemInformation (ItemCode, FullName, FullRemark, DrawingCode, DrawingVersionCode)
VALUES (@ItemCode,@FullName,@FullRemark,@DrawingCode,@DrawingVersionCode);", conn))
            {
                cmd.Parameters.AddWithValue("@ItemCode", e.NewValues["No_"]);
                cmd.Parameters.AddWithValue("@FullName", e.NewValues["FullName"] ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@FullRemark", e.NewValues["FullRemark"] ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@DrawingCode", e.NewValues["DrawingCode"] ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@DrawingVersionCode", e.NewValues["DrawingVersionCode"] ?? (object)DBNull.Value);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            e.Cancel = true;           // we handled the DB‑write ourselves
            gvItems.CancelEdit();
            BindGrid();                // refresh list
        }

        protected void gvItems_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            try
            {
                var itemNo = e.NewValues["No_"].ToString();
                var itemNo2 = e.NewValues["ItemNo2"]?.ToString()??"";
                var uom = e.NewValues["UOM"].ToString();
                var itemType = 1; //edit later
                var desc = e.NewValues["FullName"]?.ToString() ?? "";
                var fullDesc = e.NewValues["FullRemark"].ToString();
                var length = SQRLibrary.ConvertToDecimal(e.NewValues["Length"] ?? 0);
                var width = SQRLibrary.ConvertToDecimal(e.NewValues["Width"] ?? 0);
                var height = SQRLibrary.ConvertToDecimal(e.NewValues["Height"] ?? 0);

                if (desc.Length <= 0 || desc.Length > 1000)
                {
                    gvItems.JSProperties["cpError"] = "Description must have valid value";
                    _pendingError = "Description must have valid value";
                    e.Cancel = true;                    
                    return;
                }

                if (fullDesc.Length > 1000)
                {
                    gvItems.JSProperties["cpError"] = "Full Description must have valid value";
                    _pendingError = "Full Description must have valid value";
                    e.Cancel = true;                    
                    return;
                }

                bool isUpdated = UpdateNewItem(itemNo, itemNo2, desc, fullDesc, uom, itemType, length, width, height);

                if (!isUpdated)
                {
                    _pendingError = "Something went wrong";
                    e.Cancel = true;
                    return;
                }
                else
                { 
                    _pendingSuccess = "Added successfully!";
                    BindGrid(true);
                    gvItems.CancelEdit();
                    e.Cancel = true; }

                }
            catch (Exception ex) { _pendingError = ex.Message; e.Cancel = true; }
                       
            
            BindGrid();
        }

        protected void gvItems_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            using (var conn = new SqlConnection(GetConn()))
            using (var cmd = new SqlCommand(
                "DELETE FROM Custom_ItemInformation WHERE ItemCode = @ItemCode;", conn))
            {
                cmd.Parameters.AddWithValue("@ItemCode", e.Keys["No_"]);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            e.Cancel = true;
            BindGrid();
        }

        /* ------------------------------------------------------------------ */
        /*  Helpers                                                           */
        /* ------------------------------------------------------------------ */

        private static string GetConn() =>
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void gvItems_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            // Set default ItemType
            e.NewValues["ItemType"] = "SAMPLE";

            // Generate No_ based on the selected ItemType
            string itemType = e.NewValues["ItemType"]?.ToString();

            if (!string.IsNullOrEmpty(itemType))
            {
                e.NewValues["No_"] = GenerateNewItemNo(itemType);
            }

            e.NewValues["DrawingVersionCode"] = "A"; // example default
        }

        protected void pcItemAdd_WindowCallback(object source, PopupWindowCallbackArgs e)
        {
            //string prefix = $"ITEM-{(cbHeaderType.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-";
            string prefix = "";
            string nextItemNo = GetNextItemNo(prefix);
            txtNewItemNo.Text = nextItemNo;

            cbNewUOM.Text = "PCS";
        }

        protected void btnSaveNewItem_Click(object sender, EventArgs e)
        {
            try
            {
                string prefix = $"ITEM-{(cbNewItemCategory.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-";
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

                if (desc.Length <= 0 || desc.Length > 1000 )
                {
                    ShowErrorMessage("Description must have a valid value");
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

                Session["ItemList"] = null; //clear session to reload item list
                BindGrid(true);

                //ScriptManager.RegisterStartupScript(this, this.GetType(), "HideItemAddPopup", "setTimeout(function() {alert('out'); pcItemAdd.Hide();}, 300};", true);
                ShowSuccessMessage("Added successfully!");
            }
            catch { }
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

        private bool UpdateNewItem(string ItemCode, string ItemCode2, string Description, string FullDescription,
            string UOM, int ItemType, decimal Length, decimal Width, decimal Height)
        {
            try
            {
                DataContext h = new DataContext();
                LIVE_ALLIANCE_90_Item item_buff = h.LIVE_ALLIANCE_90_Item.FirstOrDefault(x => x.No_ == ItemCode);
                LIVE_ALLIANCE_90_Item_Unit_of_Measure uom_buff = h.LIVE_ALLIANCE_90_Item_Unit_of_Measure.FirstOrDefault(x => x.Item_No_ == ItemCode && x.Qty__per_Unit_of_Measure == 1);
                Custom_ItemInformation custom_ItemInformation = h.Custom_ItemInformation.FirstOrDefault(x => x.ItemCode == ItemCode);
                
                if (item_buff == null || uom_buff == null) return false;
                
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
                item_buff.Routing_No_ = "IN-HOUSE";

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
        private void ShowErrorMessage(string Message)
        {
            string error_script = "setTimeout() {Swal.fire({ position: 'top-end', type: 'error', title:'" + Message + "', showConfirmButton: false, timer: 2000 });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ErrorAlert2Message", error_script, true);
        }

        private void ShowSuccessMessage(string Message)
        {
            string success = @"Swal.fire({ position: ""top-end"", type: ""success"", title: '" + Message + "', showConfirmButton: false, timer: 2000 });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "SuccessAlert2Message", success, true);
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

        private string GenerateNewItemNo(string itemType)
        {
            // This is just a demo. You can replace this logic with SQL query to fetch next number.
            string prefix = itemType switch
            {
                "SAMPLE" => "ITEM-S",
                "SPECIAL" => "ITEM-P",
                "PROJECT" => "DA",
                _ => "ITEM-X"
            };

            // Generate dummy number
            string datePart = DateTime.Now.ToString("yyMMdd");
            string randomPart = new Random().Next(100, 999).ToString();

            return $"{prefix}{datePart}{randomPart}";
        }
        protected void callbackPanel_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string key = e.Parameter;

            var data = GetDetailByKey(key); // Fetch from DB
            if (data == null) return;
            

            string html = $@"
                <table class='table table-bordered mb-0' style='table-layout: fixed; width: 100%; font-size: 14px;'>
                    <tr class='bg-light' >
                        <th style='width: 40%; text-align: center;'>Remark</th>
                        <th style='text-align: center;' colspan='3'>Dimension</th>
                    </tr>
                    <tr>
                        <td class='text-primary align-top' rowspan=""5""><b>{data.Remark}</b></td>
                        <td class='text-primary text-center'><b>{data.Length}</b></td>
                        <td class='text-primary text-center'><b>{data.Width}</b></td>
                        <td class='text-primary text-center'><b>{data.Height}</b></td>
                    </tr>
                    <tr>
                        <th colspan='3' class='bg-light text-center'>Drawing Info</th>
                    </tr>                  
                    
                    
                </table>";

            popupContent.InnerHtml = html;
        }

        private dynamic GetDetailByKey(string id)
        {
            try
            {                

                string sql = @"
                        SELECT 
	                        i.No_,
							ci.FullName,
	                        ci.FullRemark,
							i.[Base Unit of Measure] UOM,
	                        i.[Length],
	                        i.Width,
	                        i.Height,
	                        ci.DrawingCode,
	                        ci.DrawingVersionCode,	                        
							i.[Packing Description]	

                        FROM [LIVE_ALLIANCE_90$Item] i                        
                        LEFT JOIN Custom_ItemInformation ci ON i.No_ = ci.ItemCode
                        WHERE i.No_ = @No_";
                DataTable dtItemDetailInfo = SQRLibrary.ReturnDatatablefromSQL(sql
                    , new List<string>() { "@No_" }
                    , new List<object>() { id });

                if (dtItemDetailInfo.Rows.Count <= 0) return null;
                DataRow r = dtItemDetailInfo.Rows[0];
                                
               

                return new
                {
                    Remark = r["FullRemark"].ToString(),
                    Length = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    Width = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    Height = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    
                   
                    
                };
            }
            catch { return null; }

        }

        protected void cbNewItemCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                CreateItemNo();
            }
            catch { }           
        }

        private void CreateItemNo()
        {
            string prefix = $"ITEM-{(cbNewItemCategory.Value ?? "").ToString()}{DateTime.Now.Year.ToString().Substring(2)}-";

            string nextItemNo = GetNextItemNo(prefix);
            txtNewItemNo.Text = nextItemNo;
        }

        protected void gvItems_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            
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

        private string _pendingError;
        private string _pendingSuccess;
        protected void gvItems_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            if (!string.IsNullOrEmpty(_pendingError))
            {
                e.Properties["cpError"] = _pendingError;
                _pendingError = null;         // reset so it’s sent only once
            }

            if (!string.IsNullOrEmpty(_pendingSuccess))
            {
                e.Properties["cpSuccess"] = _pendingSuccess;
                _pendingSuccess = null;         // reset so it’s sent only once
            }
        }
    }
}

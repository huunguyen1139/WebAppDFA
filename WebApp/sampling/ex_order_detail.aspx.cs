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
using DevExpress.XtraExport.Helpers;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;
using System.Collections.Specialized;
using System.Runtime.Remoting.Messaging;
using System.IO;
using DevExpress.XtraPrinting;
using DevExpress.XtraPrinting.Native;

using System.Security.Policy;
using DevExpress.Web.Internal;
using DevExpress.XtraRichEdit.API.Layout;
using System.Data.SqlClient;

namespace WebApp.sampling
{
    public partial class ex_order_detail : System.Web.UI.Page
    {        
        protected void Page_PreInit(object sender, EventArgs e)
        {
            //DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";            //MaterialCompact
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            cbGroup.InputAttributes["class"] = "form-check-input ";
            cbSubGroup.InputAttributes["class"] = "form-check-input";
           
            cbParentRemark.InputAttributes["class"] = "form-check-input";
            cbDrawing.InputAttributes["class"] = "form-check-input";
            cbSearchPanel.InputAttributes["class"] = "form-check-input";
            cbDimension.InputAttributes["class"] = "form-check-input";
            cbSiteDescription.InputAttributes["class"] = "form-check-input";
            cbFinish.InputAttributes["class"] = "form-check-input";


        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] == null)
            {
                string url = HttpContext.Current.Request.Url.AbsoluteUri;
                Response.Redirect("~/Account/Login?ReturnUrl=" + Server.UrlEncode(url));
            }
           
            LoadFactoryOrderDetailToControl();

            if (!IsPostBack)
            {                
                LoadDrawingListToGrid();                
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở blanket factory order");
                
                txtSiteRemark.Attributes["onkeydown"] = $"submitOnEnter(event, '{btnSaveSiteRemark.ClientID}')";
               
            }
       
                        
            gridFactoryOrderDetail.DataBind(); //bind to build UI and row custom merge row style            
            
            LoadDrawingListToGrid_gridUploadDrawingByItem();

            string docId = Request["no"].ToString();
            var commentControl = (WebApp.CustomControl.CommentControl)CommentSection;
            commentControl.DocumentID = docId;

        }
                       
        protected void uploadControl_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {           

            if (e.IsValid)
            {
                long filesize = e.UploadedFile.ContentLength;
                string ProjectNo = Session["ProjectCode"].ToString();
                string filetype = Path.GetExtension(e.UploadedFile.FileName);

                string rowKey = hdnRowKey.Value;
                string DrawingCode = rowKey.Split('|')[0];
                string VersionCode = rowKey.Split('|')[1];

                string fn_with_out_ext = Path.GetFileNameWithoutExtension(e.UploadedFile.FileName);
                string fn = string.Format("{0}_{1}{2}", fn_with_out_ext, DateTime.Now.ToString("ddMMyyyy-HHmmss"), filetype);
                string SaveLocation = @"D:\\alliance_new\\ERP\\DRAWING-SITE\\" + ProjectNo + (VersionCode == "V3" ? "\\Shopdrawing" : "\\Construction") + "\\" + fn;
                string FilePath = @"\\192.168.1.244\\alliance_new\\ERP\\DRAWING-SITE\\" + ProjectNo + (VersionCode == "V3" ? "\\Shopdrawing" : "\\Construction") + "\\" + fn;

                // Save to DB
                List<string> allow_file_type = new List<string>() { ".jpg", ".png", ".pdf", ".zip", ".dwg" };
                string sql11 = "EXEC ALL_UpsertDrawingCode @DrawingCode, @VersionCode, @Type, @FileName, @EffectedDate, @Revision, @FilePath, @FileLastModified, @User";
                if (allow_file_type.IndexOf(filetype.ToLower()) >= 0 && filesize <= 15 * 1024 * 1024)
                {
                    try
                    {
                        string directoryPath = Path.GetDirectoryName(SaveLocation);
                        if (!Directory.Exists(directoryPath))
                        {
                            Directory.CreateDirectory(directoryPath);
                        }

                        if (!File.Exists(SaveLocation))
                        {
                            e.UploadedFile.SaveAs(SaveLocation);
                            DateTime dateTime = File.GetLastWriteTime(SaveLocation);
                            SQRLibrary.ExecuteSQL(sql11
                                , new List<string>() { "@DrawingCode", "@VersionCode", "@Type", "@FileName", "@EffectedDate", "@Revision", "@FilePath", "@FileLastModified", "@User" }
                                , new List<object>() { DrawingCode, VersionCode, VersionCode == "V3" ? 3 : 4, fn_with_out_ext, DateTime.Now.Date, "", FilePath, dateTime, $"{Session["userid"].ToString()}: {Session["username"].ToString()}" });

                            ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadSuccess",
                                    "alert('✅ Upload successful.'); setTimeout(function() { ShowDrawingUploadPopupByItem(); }, 100);", true);

                            LoadDrawingListToGrid_gridUploadDrawingByItem();
                        }
                    }
                    catch
                    {
                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadFail",
                "alert('❌ Invalid file type or file too large. Only JPG, PNG, PDF, ZIP, or DWG files are allowed and file Size < 15MB'');", true);
                }

                e.CallbackData = "success";
            }
            else
            {
                e.CallbackData = "fail";
            }
        }

        protected void btnRealUpload_Click(object sender, EventArgs e)
        {
            try
            {                 
                HttpPostedFile httpPostedFile = Request.Files["ctl00$MainContent$fileUploader"];
                if (httpPostedFile != null && httpPostedFile.ContentLength > 0)
                {
                    List<string> allow_file_type = new List<string>() { ".jpg", ".png", ".pdf", ".zip", ".dwg" };
                    string filetype = Path.GetExtension(httpPostedFile.FileName);
                    int filesize = httpPostedFile.ContentLength;
                    string ProjectNo = Session["ProjectCode"].ToString();

                    string rowKey = hdnRowKey.Value;
                    string DrawingCode = rowKey.Split('|')[0];
                    string VersionCode = rowKey.Split('|')[1];

                    string fn_with_out_ext = Path.GetFileNameWithoutExtension(httpPostedFile.FileName);
                    string fn = string.Format("{0}_{1}{2}", fn_with_out_ext, DateTime.Now.ToString("ddMMyyyy-HHmmss"), filetype);
                    string SaveLocation = @"D:\\alliance_new\\ERP\\DRAWING-SITE\\" + ProjectNo + (VersionCode == "V3" ? "\\Shopdrawing" : "\\Construction") + "\\" + fn;
                    string FilePath = @"\\192.168.1.244\\alliance_new\\ERP\\DRAWING-SITE\\" + ProjectNo + (VersionCode == "V3" ? "\\Shopdrawing" : "\\Construction") + "\\" + fn;

                    string sql11 = "EXEC ALL_UpsertDrawingCode @DrawingCode, @VersionCode, @Type, @FileName, @EffectedDate, @Revision, @FilePath, @FileLastModified, @User";

                    if (allow_file_type.IndexOf(filetype.ToLower()) >= 0 && filesize <= 15 * 1024 * 1024)
                    {
                        try
                        {
                            string directoryPath = Path.GetDirectoryName(SaveLocation);
                            if (!Directory.Exists(directoryPath))
                            {
                                Directory.CreateDirectory(directoryPath);
                            }

                            if (!File.Exists(SaveLocation))
                            {
                                httpPostedFile.SaveAs(SaveLocation);
                                DateTime dateTime = File.GetLastWriteTime(SaveLocation);
                                SQRLibrary.ExecuteSQL(sql11
                                    , new List<string>() { "@DrawingCode", "@VersionCode", "@Type", "@FileName", "@EffectedDate", "@Revision", "@FilePath", "@FileLastModified", "@User" }
                                    , new List<object>() { DrawingCode, VersionCode, VersionCode == "V3"? 3:4, fn_with_out_ext, DateTime.Now.Date, "", FilePath, dateTime, $"{Session["userid"].ToString()}: {Session["username"].ToString()}" });

                                ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadSuccess",
                                        "alert('✅ Upload successful.'); setTimeout(function() { ShowDrawingUploadPopupByItem(); }, 100);", true);

                                LoadDrawingListToGrid_gridUploadDrawingByItem(); 
                            }
                        }
                        catch
                        {
                        }

                    }
                    else
                    {                        
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadFail",
                        "alert('❌ Invalid file type or file too large. Only JPG, PNG, PDF, ZIP, or DWG files are allowed and file Size < 15MB'');", true);
                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadFail",
                        "alert('❌ No file selected or upload failed.');", true);
                }
                

                // Rebind grid if needed
                //gridDrawings.DataBind();
            }
            catch { }
        }

        private void LoadFactoryOrderDetailToControl()
        {
            try
            {
                string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";
                UpdateHeaderText(FactoryOrder);

                if (Session["OrderClass"].ToString() == "Domestic")
                {
                    btnDeleteFocusRow.Visible = false;
                    //btnUploadDrawing.Visible = false;
                    gridFactoryOrderDetail.AutoGenerateColumns = false;
                    LoadDomesticFactoryandSiteOrderDetail(FactoryOrder);
                }
                else
                {
                    gridFactoryOrderDetail.Columns.Clear();
                    gridFactoryOrderDetail.AutoGenerateColumns = true;
                    LoadForeignFactoryandSiteOrderDetail(FactoryOrder);
                }
                ShowOrHideColumns(null, null);
            }
            catch { }
        }

        private void UpdateHeaderText(string FactoryOrder)
        {
            try
            {
                string sqlHeader = "SELECT No_, [Sell-to Customer Name], AllocationFor, [Status], [Order Class], JobNo, [VAT Description] SiteRemark FROM [LIVE_ALLIANCE_90$Sales Header] WHERE  No_ = @No AND [Document Type] = 7";
                DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                    , new List<string>() { "@No" }
                    , new List<object>() { FactoryOrder });
                if (dtHeader.Rows.Count <= 0) return;
                DataRow fr = dtHeader.Rows[0];

                Session["ProjectCode"] = fr["JobNo"].ToString();
                Session["OrderClass"] = fr["Order Class"].ToString();
                Session["Status"] = fr["Status"].ToString();

                txtSiteRemark.Text = fr["SiteRemark"].ToString();
                txtDesciptionHeader.InnerHtml = string.Concat(
                        "Factory Order :",
                        fr[0].ToString() + " - ",
                        fr[1].ToString() + " - ",
                        Session["status"].ToString().Equals("0") ? "<text class='text-white bg-warning p-1'> Open </text>" : "<text class='bg-success text-white p-1'> Released </text>");
                this.Title = string.Concat(
                        "Factory Order :",
                        fr[0].ToString() + " - ",
                        fr[1].ToString() + " - ");
            }
            catch { }
        }

        private void LoadForeignFactoryandSiteOrderDetail(string OrderNo)
        {
            try
            {
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_GetFactoryOrSiteOrderLineData_Foreign] @OrderNo"
                    , new List<string>() { "@OrderNo" }
                    , new List<object>() { OrderNo });
                Library.LibraryFunction.MakeAllColumnEditable(dt);
                gridFactoryOrderDetail.SettingsBehavior.AllowCellMerge = false;
                gridFactoryOrderDetail.DataSource = dt;
                gridFactoryOrderDetail.DataBind();

                List<string> editable_cl = new List<string>() { "OrderQty", "NeedOnDate", "SiteOrderDescription" };
                foreach (GridViewDataColumn cl in gridFactoryOrderDetail.DataColumns)
                {
                    if (!editable_cl.Contains(cl.FieldName)) cl.ReadOnly = true;
                }

                List<string> nonwrap_cl = new List<string>() { "No_" };
                foreach (GridViewDataColumn cl in gridFactoryOrderDetail.DataColumns)
                {
                    if (nonwrap_cl.Contains(cl.FieldName)) cl.CellStyle.Wrap = DevExpress.Utils.DefaultBoolean.False;
                }
                gridFactoryOrderDetail.DataColumns["FullDescription"].Width = 400;                
                gridFactoryOrderDetail.DataColumns["Packing Description"].Width = 300;
                gridFactoryOrderDetail.DataColumns["No_"].Width = 150;

                gridFactoryOrderDetail.DataColumns["Quantity"].PropertiesEdit.DisplayFormatString = "#0.####";
                gridFactoryOrderDetail.DataColumns["Unit Price"].PropertiesEdit.DisplayFormatString = "#,##0";
                gridFactoryOrderDetail.DataColumns["Amount"].PropertiesEdit.DisplayFormatString = "#,##0"; 
                gridFactoryOrderDetail.DataColumns["BOQPrice"].PropertiesEdit.DisplayFormatString = "#,##0";

                gridFactoryOrderDetail.DataColumns["Length"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridFactoryOrderDetail.DataColumns["Width"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridFactoryOrderDetail.DataColumns["Height"].PropertiesEdit.DisplayFormatString = "#,##0.####";

                gridFactoryOrderDetail.DataColumns["DocumentType"].Visible = false;
                gridFactoryOrderDetail.DataColumns["LineNo"].Visible = false;
                gridFactoryOrderDetail.DataColumns["DocumentNo"].Visible = false;
            }
            catch { }
        }

        private void LoadDomesticFactoryandSiteOrderDetail(string OrderNo)
        {
            try
            {
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_GetFactoryOrSiteOrderLineData_Domestic] @OrderNo"
                    , new List<string>() { "@OrderNo" }
                    , new List<object>() { OrderNo });
                                
                gridFactoryOrderDetail.SettingsBehavior.AllowCellMerge = true;
                Library.LibraryFunction.MakeAllColumnEditable(dt);
                gridFactoryOrderDetail.DataSource = dt;
                gridFactoryOrderDetail.DataBind();

                gridFactoryOrderDetail.DataColumns["ParentRemark"].Width = 350;
                //gridFactoryOrderDetail.DataColumns["SiteOrderDescription"].Width = 300;
                gridFactoryOrderDetail.DataColumns["UOM"].Width = 50;
                gridFactoryOrderDetail.DataColumns["ParentDescription"].Width = 170;

                
                //gridFactoryOrderDetail.DataColumns["Quantity"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridFactoryOrderDetail.DataColumns["UOM"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridFactoryOrderDetail.DataColumns["Group"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridFactoryOrderDetail.DataColumns["OrderedQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridFactoryOrderDetail.DataColumns["AdjustedQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridFactoryOrderDetail.DataColumns["RemainQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridFactoryOrderDetail.DataColumns["OrderQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;

                //gridFactoryOrderDetail.DataColumns["Quantity"].PropertiesEdit.DisplayFormatString = "#0.####";
                //gridFactoryOrderDetail.DataColumns["OrderedQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                //gridFactoryOrderDetail.DataColumns["AdjustedQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                //gridFactoryOrderDetail.DataColumns["RemainQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                //gridFactoryOrderDetail.DataColumns["OrderQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridFactoryOrderDetail.DataColumns["DocumentType"].Visible = false;
                gridFactoryOrderDetail.DataColumns["LineNo"].Visible = false;
                gridFactoryOrderDetail.DataColumns["DocumentNo"].Visible = false;
                

                if (gridFactoryOrderDetail.VisibleRowCount > 0) UpdateDictionary(rows, gridFactoryOrderDetail, "ParentNo");
                Traverse();


            }
            catch { }
        }

        private Dictionary<int, bool> rows = new Dictionary<int, bool>();
        private List<KeyValuePair<string, List<int>>> allData = new List<KeyValuePair<string, List<int>>>();
        void UpdateDictionary(Dictionary<int, bool> rows, ASPxGridView view, string fieldName)
        {
            try
            {
                rows.Clear();

                //GridColumn column = view.Columns[fieldName];
                bool odd = true;
                rows.Add(0, odd);
                string value = view.GetDataRow(0)[fieldName].ToString();
                for (int i = 1; i < view.VisibleRowCount; i++)
                {
                    string value1 = view.GetDataRow(i)[fieldName].ToString();
                    if (value != value1)
                    {
                        odd = !odd;
                        value = value1;
                    }
                    rows.Add(i, odd);
                }
            }
            catch (Exception ex) { }
        }
        private void Traverse()
        {
            List<int> rows = new List<int>();
            for (int i = 0; i < gridFactoryOrderDetail.VisibleRowCount - 1; i++)
            {
                string text = gridFactoryOrderDetail.GetDataRow(i)["ParentNo"].ToString();
                if (text == gridFactoryOrderDetail.GetDataRow(i + 1)["ParentNo"].ToString())
                {
                    rows.Add(i);
                }
                else
                {
                    rows.Add(i);
                    allData.Add(new KeyValuePair<string, List<int>>(text, rows));
                    rows = new List<int>();
                }
            }
        }
       
        protected void gridFactoryOrderDetai_CustomColumnDisplayText(object sender, DevExpress.Web.ASPxGridViewColumnDisplayTextEventArgs e)
        {
            try
            {

                e.Column.PropertiesEdit.EncodeHtml = false;
                if (e.Column.FieldName == "SiteOrderDescription")
                {
                    e.DisplayText = e.Value != null ? e.Value.ToString().Replace("\r\n", "\n").Replace("\r", "\n").Replace("\n", "<br />") : "";
                }
                if (e.Column.FieldName == "ParentRemark")
                {
                    e.DisplayText = e.Value != null ? e.Value.ToString().Replace("\r\n", "\n").Replace("\r", "\n").Replace("\n", "<br />") : "";
                }
                if (e.Column.FieldName == "DrawingNote")
                {
                    e.DisplayText = e.Value != null ? e.Value.ToString().Replace("\r\n", "\n").Replace("\r", "\n").Replace("\n", "<br />") : "";
                }
                if (e.Column.FieldName == "DrawingVersionCode")
                {
                    e.DisplayText = (e.Value != null && e.Value.ToString().Length > 0) ? e.Value.ToString() == "V3" ? "Shop Drawing" : "Construction Drawing" : "";
                }
            }
            catch { }
        }



        protected void gridFactoryOrderDetail_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {

        }

        protected void gridFactoryOrderDetail_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            try
            {
                if (Session["OrderClass"].ToString() == "Domestic")
                {
                    var palette = ASPxWebControl.GlobalThemeBaseColor;

                    bool odd;
                    rows.TryGetValue(e.VisibleIndex, out odd);
                    if (odd)
                    {
                        e.Row.BackColor = Color.WhiteSmoke;
                    }
                    else
                    {
                        e.Row.BackColor = Color.Transparent;
                    }
                }
            }
            catch { }
        }

        protected void gridFactoryOrderDetail_CustomCellMerge(object sender, ASPxGridViewCustomCellMergeEventArgs e)
        {
            try
            {
                ASPxGridView aSPxGridView = sender as ASPxGridView;
                int t = aSPxGridView.VisibleRowCount;

                DataRow r = aSPxGridView.GetDataRow(e.RowVisibleIndex1);
                if (r == null)
                {
                    e.Merge = false;
                    e.Handled = true;
                    return;
                }
                string id1 = aSPxGridView.GetDataRow(e.RowVisibleIndex1)["ParentNo"].ToString();
                string id2 = aSPxGridView.GetDataRow(e.RowVisibleIndex2)["ParentNo"].ToString();
                if (id1 != null && id1 != id2)
                {
                    e.Merge = false;
                    e.Handled = true;
                }//otherwise, leave the default merging behavior
            }
            catch (Exception ex) { }
        }


        protected void gridFactoryOrderDetail_BeforeGetCallbackResult(object sender, EventArgs e)
        {
            if (Session["OrderClass"].ToString() == "Domestic")
            {
                if (gridFactoryOrderDetail.VisibleRowCount > 0) UpdateDictionary(rows, gridFactoryOrderDetail, "ParentNo");
                Traverse();
            }
        }

        protected void gridFactoryOrderDetail_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            bool isHandled = true;
            try
            {               
                foreach (var args in e.UpdateValues)
                {
                    if (!CheckUpdateItem(args.Keys, args.NewValues))
                    {
                        isHandled = false;                       
                        break;
                    }
                }

                if (isHandled)
                {
                    foreach (var args in e.UpdateValues)
                    {
                        UpdateItem(args.Keys, args.NewValues);
                    }
                }

                e.Handled = isHandled;
                LoadFactoryOrderDetailToControl();
                gridFactoryOrderDetail.DataBind();
                ShowOrHideColumns(sender, e);
            }
            catch { e.Handled = false; }
        }

        private bool CheckUpdateItem(OrderedDictionary keys, OrderedDictionary newValues)
        {
            try
            {
                decimal remainqty = SQRLibrary.ConvertToDecimal(newValues["RemainQty"]);
                decimal quantity = SQRLibrary.ConvertToDecimal(newValues["OrderQty"]);
                return quantity <= remainqty;
            }
            catch { return false; }
        }

        private void UpdateItem(OrderedDictionary keys, OrderedDictionary newValues)
        {
            try
            {
                string DocumentNo = Request["no"] == null ? "" : Request["no"].ToString();
                int LineNo = SQRLibrary.ConvertToInt(keys["LineNo"]);
                string SiteDescription = newValues["SiteOrderDescription"]!= null?  newValues["SiteOrderDescription"].ToString(): "";
                decimal quantity = SQRLibrary.ConvertToDecimal(newValues["OrderQty"]);
                DateTime NeedDate = newValues["NeedOnDate"] != null ? (DateTime)newValues["NeedOnDate"] : DateTime.Today;
                string ItemCode = newValues["No_"].ToString();

                string sql = "EXEC ALL_UPDATE_BLANKET_ORDER_LINE_INFORMATION @DocumentNo, @LineNo, @SiteOrderDescription, @quantity, @NeedDate, @ItemCode";

                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@DocumentNo", "@LineNo", "@SiteOrderDescription", "@quantity", "@NeedDate", "@ItemCode" }
                    , new List<object>() { DocumentNo, LineNo, SiteDescription, quantity, NeedDate, ItemCode });

            }
            catch { }
        }



        protected void ShowOrHideColumns(object sender, EventArgs e)
        {
            try
            {
                if (Session["OrderClass"].ToString() == "Domestic")
                {
                    gridFactoryOrderDetail.DataColumns["SubGroup"].Visible = cbSubGroup.Checked;
                    gridFactoryOrderDetail.DataColumns["Group"].Visible = cbGroup.Checked;                  
                    gridFactoryOrderDetail.DataColumns["ParentRemark"].Visible = cbParentRemark.Checked;
                    gridFactoryOrderDetail.DataColumns["DrawingCode"].Visible = cbDrawing.Checked;
                    gridFactoryOrderDetail.DataColumns["DrawingVersionCode"].Visible = cbDrawing.Checked;
                    gridFactoryOrderDetail.DataColumns["DrawingNote"].Visible = cbDrawing.Checked;
                    gridFactoryOrderDetail.DataColumns["SiteOrderDescription"].Visible = cbSiteDescription.Checked;
                    gridFactoryOrderDetail.SettingsSearchPanel.Visible = cbSearchPanel.Checked;
                }
                else
                {
                    gridFactoryOrderDetail.DataColumns["Group"].Visible = cbGroup.Checked;                    
                    gridFactoryOrderDetail.DataColumns["FullDescription"].Visible = cbParentRemark.Checked;
                    gridFactoryOrderDetail.DataColumns["Packing Description"].Visible = cbParentRemark.Checked;
                    gridFactoryOrderDetail.SettingsSearchPanel.Visible = cbSearchPanel.Checked;
                    gridFactoryOrderDetail.DataColumns["Length"].Visible = cbDimension.Checked;
                    gridFactoryOrderDetail.DataColumns["Width"].Visible = cbDimension.Checked;
                    gridFactoryOrderDetail.DataColumns["Height"].Visible = cbDimension.Checked;
                    
                    gridFactoryOrderDetail.DataColumns["Timber Finish"].Visible = cbFinish.Checked;
                    gridFactoryOrderDetail.DataColumns["MetalFab Finish"].Visible = cbFinish.Checked;
                }
            }
            catch { }
        }

   
        protected void btnCloseModal_ServerClick(object sender, EventArgs e)
        {
            divModalForFullPostBack.Attributes["class"] = "modal fade";
            divModalForFullPostBack.Attributes["style"] = "";
        }

       

        protected void btnDeleteFocusRow_Click(object sender, EventArgs e)
        {
            try
            {
                if (!isHasPermissionOnProject())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to delete order for project {Session["ProjectCode"].ToString()}!', 'bg-danger');", true);
                    return;
                }

                if (Session["status"].ToString() != "0")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Open! You can not modify Released Order', 'bg-danger');", true);
                    return;
                }

                DataRow r = gridFactoryOrderDetail.GetDataRow(gridFactoryOrderDetail.FocusedRowIndex);
                if (r == null) return;
                string DocumentNo = r["DocumentNo"].ToString();
                int LineNo = SQRLibrary.ConvertToInt(r["DocumentNo"]); 
                
                string sqlRelatedProdOrder = "SELECT * FROM [LIVE_ALLIANCE_90$Production Order] WHERE Status in (2,3,4) and [Simulated Order No_] = @RefNo";
                DataTable dtRelatedProdOrder = SQRLibrary.ReturnDatatablefromSQL(sqlRelatedProdOrder
                    , new List<string>() { "@RefNo" }
                    , new List<object>() { $"{DocumentNo}{LineNo.ToString()}" });

                if (dtRelatedProdOrder.Rows.Count >= 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'At least one production order is link with this line! You can not delete it, please cancelled related production order first!', 'bg-danger');", true);
                    return;
                }
                
                string sqlDeleteSaleLine = "delete [LIVE_ALLIANCE_90$Sales Line] WHERE [Document Type]=7 and [Document No_] = @DocumentNo and [Line No_] = @LineNo";
               SQRLibrary.ExecuteSQL(sqlDeleteSaleLine
                    , new List<string>() { "@DocumentNo", @"LineNo" }
                    , new List<object>() { DocumentNo, LineNo });

                LoadFactoryOrderDetailToControl();               
                ShowOrHideColumns(sender, e);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Already deleted!', 'bg-success');", true);
            }
            catch (Exception ex) { ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{ex.Message}', 'bg-danger');", true); }
        }

        private void LoadDrawingListToGrid()
        {
            string OrderNo = Request["no"] != null ? Request["no"].ToString() : "";
            string sql = "EXEC ALL_GETDrawingList @ProjectCode, @DrawingCode ";
            string ProjectCode = Session["ProjectCode"].ToString();
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql
                , new List<string>() { "@ProjectCode", "@DrawingCode" }
                , new List<object>() { ProjectCode, OrderNo });
            gridDrawingHistory.DataSource = dt;
            gridDrawingHistory.DataBind();
        }

        private void LoadDrawingListToGrid_gridUploadDrawingByItem()
        {
            string OrderNo = Request["no"] != null ? Request["no"].ToString() : "";
            string sql = "EXEC ALL_GETDrawingList @ProjectCode, @DrawingCode";
            
            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql
                , new List<string>() { "@ProjectCode", "@DrawingCode" }
                , new List<object>() { Session["ProjectCode"].ToString(), "" });
            gridUploadDrawingByItem.DataSource = dt;
            gridUploadDrawingByItem.DataBind();
        }

        protected void btnMakeOrder_Click(object sender, EventArgs e)
        {
            try
            {           

                if (!isHasPermissionOnProject())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to create order for project {Session["ProjectCode"].ToString()}!', 'bg-danger');", true);
                    return;
                }
               
                string BlanketFactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";
                string sql = "EXEC ALL_CREATE_FACTORY_OR_SITE_ORDER_FROM_BLANKET_ORDER @User, @BlanketOrder, ''";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql
                    , new List<string>() { "@User", "@BlanketOrder" }
                    , new List<object>() { $"{Session["userid"].ToString()}: {Session["username"].ToString()}" , BlanketFactoryOrder });

                if (dt.Rows.Count <= 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'You do not have permission to create order!', 'bg-danger');", true);
                    return;
                }

                if (dt.Rows[0][1].ToString().Equals("0"))
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', '" + dt.Rows[0][0].ToString() + "', 'bg-danger');", true);
                    return;
                }
                LoadFactoryOrderDetailToControl();
                gridFactoryOrderDetail.DataBind();
                ShowOrHideColumns(sender, e);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup"
                    , @"ShowPopup('POR System', 'Order <a href= ""factory_order_detail?orderno=" + dt.Rows[0][0].ToString() + @" target=""_blank"">" + dt.Rows[0][0].ToString() + "</a> has been created successfully!', 'bg-success');", true);
                
            }
            catch { }
        }

     
        protected void btnViewRelatedProductionOrder_ServerClick(object sender, EventArgs e)
        {
            try
            {
                string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";
                if (FactoryOrder != "") Response.Redirect("~/production/ProductionStatus?PI=" + FactoryOrder);
            }
            catch { }
        }

        private bool isHasPermissionOnProject()
        {
            bool rs = true;
            try
            {
                
            }
            catch { }
            return rs;
        }

        protected void linkChangeStatusOpen_Click(object sender, EventArgs e)
        {
            try
            {
                string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";

                if (!isHasPermissionOnProject())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to change order status for project {Session["ProjectCode"].ToString()}!', 'bg-danger');", true);
                    return;
                }

                if (Session["status"].ToString() != "1")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Released!', 'bg-danger');", true);
                    return;
                }
                string sql = "UPDATE [LIVE_ALLIANCE_90$Sales Header] SET Status = 0 WHERE [Document Type] = 7 and No_ = @No_";
                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@No_" }
                    , new List<object> { FactoryOrder });

                Session["status"] = "0";
                UpdateHeaderText(FactoryOrder);
            }
            catch { }
        }

        protected void linkChangeStatusReleased_Click(object sender, EventArgs e)
        {
            try
            {
                string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";

                if (!isHasPermissionOnProject())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to change order status for project {Session["ProjectCode"].ToString()}!', 'bg-danger');", true);
                    return;
                }

                if (Session["status"].ToString() != "0")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Open!', 'bg-danger');", true);
                    return;
                }
                string sql = "UPDATE [LIVE_ALLIANCE_90$Sales Header] SET Status = 1 WHERE [Document Type] = 7 and No_ = @No_";
                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@No_" }
                    , new List<object> { FactoryOrder });

                Session["status"] = "1";
                UpdateHeaderText(FactoryOrder);
            }
            catch { }
        }

        protected void gridFactoryOrderDetail_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            
            try
            {
                if (!isHasPermissionOnProject())
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to delete order for project {Session["ProjectCode"].ToString()}!', 'bg-danger');", true);
                    e.Cancel = true;
                    gridFactoryOrderDetail.JSProperties["cpMessage"] = $"You do not have permission to delete order for project {Session["ProjectCode"].ToString()}!";
                    gridFactoryOrderDetail.JSProperties["cpMessageType"] = "danger";
                    return;
                }

                if (Session["status"].ToString() != "0")
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Open! You can not modify Released Order', 'bg-danger');", true);
                    e.Cancel = true;
                    gridFactoryOrderDetail.JSProperties["cpMessage"] = $"Status must be Open! You can not modify Released Order";
                    gridFactoryOrderDetail.JSProperties["cpMessageType"] = "danger";
                    return;
                }

                string DocumentNo = Request["no"] == null ? "" : Request["no"].ToString();
                int LineNo = SQRLibrary.ConvertToInt(e.Keys["LineNo"]);

                string sqlRelatedProdOrder = "SELECT * FROM [LIVE_ALLIANCE_90$Production Order] WHERE Status in (2,3,4) and [Simulated Order No_] = @RefNo";
                DataTable dtRelatedProdOrder = SQRLibrary.ReturnDatatablefromSQL(sqlRelatedProdOrder
                    , new List<string>() { "@RefNo" }
                    , new List<object>() { $"{DocumentNo}{LineNo.ToString()}" });

                if (dtRelatedProdOrder.Rows.Count > 0)
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'At least one production order is link with this line! You can not delete it, please cancelled related production order first!', 'bg-danger');", true);
                    e.Cancel = true;
                    gridFactoryOrderDetail.JSProperties["cpMessage"] = $"At least one production order is link with this line! You can not delete it, please cancelled related production order first!";
                    gridFactoryOrderDetail.JSProperties["cpMessageType"] = "danger";
                    return;
                }

                string sqlDeleteSaleLine = "delete [LIVE_ALLIANCE_90$Sales Line] WHERE [Document Type]=7 and [Document No_] = @DocumentNo and [Line No_] = @LineNo";
                //SQRLibrary.ExecuteSQL(sqlDeleteSaleLine
                //     , new List<string>() { "@DocumentNo", @"LineNo" }
                //     , new List<object>() { DocumentNo, LineNo });


                LoadFactoryOrderDetailToControl();
                ShowOrHideColumns(sender, e);
                e.Cancel = true;
                gridFactoryOrderDetail.JSProperties["cpMessage"] = $"Successfully deleted!";
                gridFactoryOrderDetail.JSProperties["cpMessageType"] = "success";
            }
            catch (Exception ex) 
            { 
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{ex.Message}', 'bg-danger');", true);
                gridFactoryOrderDetail.JSProperties["cpMessage"] = ex.Message;
                gridFactoryOrderDetail.JSProperties["cpMessageType"] = "danger";
                e.Cancel = true; 
            }
        }
        protected void btnUploadDrawing_Click(object sender, EventArgs e)
        {
            try
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "UploadDrawingPopup", "setTimeout(function() {ShowDrawingUploadPopup();}, 100)", true);
            }
            catch { }
        }
        protected void cvFileUpload_ServerValidate(object source, ServerValidateEventArgs args)
        {            
            if (!fileUpload.HasFile)
            {
                args.IsValid = false;
                return;
            }

            List<string> accept_file = new List<string>() { ".zip", ".dwg",".xls", ".xlsx", ".doc", ".docx", ".pdf", ".png", ".jpg" };
            string extension = System.IO.Path.GetExtension(fileUpload.FileName).ToLower();
            int fileSize = fileUpload.PostedFile.ContentLength;

            if (!accept_file.Contains(extension))
            {
                args.IsValid = false;
                cvFileUpload.ErrorMessage = $"{extension.ToUpper()} files not allowed.";
            }
            else if (fileSize > 15 * 1024 * 1024) // 2MB
            {
                args.IsValid = false;
                cvFileUpload.ErrorMessage = "File must be smaller than 15MB.";
            }
            else
            {
                args.IsValid = true;
            }
        }
        protected void btnUploadDrawingByOrder_ServerClick(object sender, EventArgs e)
        {
            try
            {
                if (Page.IsValid)
                {                    
                    if (UploadFile(fileUpload, Session["ProjectCode"].ToString(), Request["no"].ToString(), SQRLibrary.ConvertToInt(ddDrawingType.SelectedValue)))
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "setTimeout(function() {ShowPopup('POR System', 'Successfully uploaded!', 'bg-success');}, 100)", true);                        
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "setTimeout(function() { ShowDrawingUploadPopup(); }, 100);", true);
                }               
                
            }
            catch (Exception ex) 
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{ex.Message}', 'bg-danger');", true);
            }
        }

        private bool UploadFile(FileUpload fileUpload, string ProjectNo ,string OrderNo, int type)
        {
            bool rs = false;
            try
            {
                if (fileUpload.HasFiles)
                {
                    List<string> allow_file_type = new List<string>() { ".xls", ".xlsx", ".doc", ".docx", ".pdf", ".png", ".jpg", ".zip" };
                    foreach (HttpPostedFile httpPostedFile in fileUpload.PostedFiles)
                    {                        
                        string filetype = Path.GetExtension(httpPostedFile.FileName);
                        int filesize = httpPostedFile.ContentLength;

                        string fn_with_out_ext = Path.GetFileNameWithoutExtension(httpPostedFile.FileName);
                        string fn = string.Format("{0}_{1}_{2}{3}", fn_with_out_ext, OrderNo, DateTime.Now.ToString("ddMMyyyy-HHmm"), filetype);
                        string SaveLocation = @"D:\\alliance_new\\ERP\\DRAWING-SITE\\" + ProjectNo + (type == 3? "\\Shopdrawing": "\\Construction") + "\\" + fn;
                        string FilePath = @"\\192.168.1.244\\alliance_new\\ERP\\DRAWING-SITE\\" + ProjectNo + (type == 3 ? "\\Shopdrawing" : "\\Construction") + "\\" + fn;
                        
                        string sql11 = "EXEC ALL_UpsertDrawingCode @DrawingCode, @VersionCode, @Type, @FileName, @EffectedDate, @Revision, @FilePath, @FileLastModified, @User";

                        if (allow_file_type.IndexOf(filetype.ToLower()) >= 0 && filesize <= 15*1024*1024)
                        {
                            try
                            {
                                string directoryPath = Path.GetDirectoryName(SaveLocation);
                                if (!Directory.Exists(directoryPath))
                                {
                                    Directory.CreateDirectory(directoryPath);
                                }

                                if (!File.Exists(SaveLocation))
                                {
                                    fileUpload.SaveAs(SaveLocation);
                                    DateTime dateTime = File.GetLastWriteTime(SaveLocation);
                                    SQRLibrary.ExecuteSQL(sql11
                                        , new List<string>() { "@DrawingCode", "@VersionCode", "@Type", "@FileName", "@EffectedDate", "@Revision", "@FilePath", "@FileLastModified", "@User" }
                                        , new List<object>() { OrderNo, $"V{type.ToString()}", type, fn_with_out_ext, DateTime.Now.Date, ProjectNo, FilePath, dateTime, $"{Session["userid"].ToString()}: {Session["username"].ToString()}"});
                                    LoadDrawingListToGrid();
                                }
                            }
                            catch
                            {
                            }
                            rs = true;
                        }
                    }
                    
                }
            }
            catch { rs = false; }
            return rs;
        }

        protected void gridDrawingHistory_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e)
        {
            if (e.Column.FieldName == "Type")
            {
                e.DisplayText = e.Value.ToString() == "3" ? "Shop Drawing" : "Construction";
            }
        }

        protected void btnAddDrawingCode_ServerClick(object sender, EventArgs e)
        {
            try
            {
                if (Page.IsValid)
                {
                    if (AddDrawingCode(Session["ProjectCode"].ToString(), txtDrawingCode.Text, SQRLibrary.ConvertToInt(ddDrawingTypeGridItem.SelectedValue)))
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "UploadSuccess",
                                        $"setTimeout(function() {{ alert('✅ Successful create drawing code {txtDrawingCode.Text}!'); ShowDrawingUploadPopupByItem(); }}, 100);", true);
                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "setTimeout(function() {ShowPopup('POR System', 'Successful upload!', 'bg-success');}, 100)", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", " setTimeout(function() {ShowDrawingUploadPopupByItem(); }, 100);", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"setTimeout(function() {{alert('{ex.Message}'); ShowDrawingUploadPopupByItem(); }}, 100);", true);
            }
        }
        private bool AddDrawingCode(string ProjectNo, string DrawingCode, int type)
        {
            bool rs = false;
            if (type == 0) return false;
            try
            {
                string sql11 = "EXEC ALL_UpsertDrawingCode @DrawingCode, @VersionCode, @Type, @FileName, @EffectedDate, @Revision, @FilePath, @FileLastModified, @User";

                SQRLibrary.ExecuteSQL(sql11
                    , new List<string>() { "@DrawingCode", "@VersionCode", "@Type", "@FileName", "@EffectedDate", "@Revision", "@FilePath", "@FileLastModified", "@User" }
                    , new List<object>() { DrawingCode, $"V{type.ToString()}", type, "", DateTime.Now.Date, ProjectNo, "", DateTime.Now, $"{Session["userid"].ToString()}: {Session["username"].ToString()}" });
                rs = true;
                LoadDrawingListToGrid_gridUploadDrawingByItem();
            }
            catch { rs = false; }
            return rs;
        }
        protected void cvDrawingCode_ServerValidate(object source, ServerValidateEventArgs args)
        {
            try
            {
                if (txtDrawingCode.Text.Length > 20)
                {
                    args.IsValid = false;
                    cvDrawingCode.ErrorMessage = "Drawing code length must be <= 20";
                }
                else if (txtDrawingCode.Text.Length > 0)
                {
                    if (ddDrawingTypeGridItem.SelectedValue == "") { args.IsValid = true; return; }
                    string sql = " SELECT dr.* FROM [LIVE_ALLIANCE_90$Drawing Code] dr "
                    + " WHERE dr.[Drawing Code] = @DrawingCode AND dr.[Version Code] = @VersionCode ";
                    DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql
                        , new List<string>() { "@DrawingCode", "@VersionCode" }
                        , new List<object>() { txtDrawingCode.Text, ddDrawingType.SelectedValue == "3" ? "V3" : "V4" });
                    if (dt.Rows.Count > 0)
                    {
                        args.IsValid = false;
                        cvDrawingCode.ErrorMessage = "Drawing Code already exists.";
                    }
                    else
                    { args.IsValid = true; }
                }
                else
                {
                    args.IsValid = false;
                    cvDrawingCode.ErrorMessage = "Please input drawing code";
                }
            }
            catch (Exception ex)
            {
                args.IsValid = false;
                cvDrawingCode.ErrorMessage = ex.Message;
            }
        }

        protected void btnSelectAndApplyDrawingCodeToItem_ServerClick(object sender, EventArgs e)
        {           
            try
            {
                DataRow r = gridUploadDrawingByItem.GetDataRow(gridUploadDrawingByItem.FocusedRowIndex);
                if (r == null) { return; }
                string ApplyToItem = hdnItemCode.Value;
                string DrawingCode = r["Drawing Code"].ToString();
                string VersionCode = r["Version Code"].ToString();

                string sql = "update Custom_ItemInformation SET DrawingCode = @DrawingCode, DrawingVersionCode = @VersionCode WHERE ItemCode = @ItemNo";
                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@ItemNo", "@DrawingCode", "@VersionCode" } 
                    , new List<object>() { ApplyToItem, DrawingCode, VersionCode });
                //Reload grid view
                LoadFactoryOrderDetailToControl();
                gridFactoryOrderDetail.DataBind(); //bind to build UI and row custom merge row style
                //ShowOrHideColumns();
            }
            catch { }
        }

        protected void gridFactoryOrderDetail_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {

            if (e.ButtonID == "btnCustomViewDrawingByItem")
            {
                string filePath = gridFactoryOrderDetail.GetRowValues(e.VisibleIndex, "SDFilePath")?.ToString();

                if (string.IsNullOrWhiteSpace(filePath))
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
        }

        protected void cbAction_Callback(object source, CallbackEventArgs e)
        {
            string[] parts = e.Parameter.Split('|');
            string command = parts[0];
            string idStr = parts[1];

            if (command == "delete" && int.TryParse(idStr, out int id))
            {
                // Do your delete logic here
                // Refresh the grid
            }
        }


        protected void callbackPanel_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string key = e.Parameter;

            var data = GetDetailByKey(key); // Fetch from DB
            if (data == null) return;
            string imageHtml = "";
            foreach (var imgUrl in data.ImageUrls)
            {
                imageHtml += $"<img src='{imgUrl}' class='img-thumbnail m-1' style='max-width: 100px; cursor: pointer;' onclick=\"showLightbox('{imgUrl}')\" />";
            }

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
                    <tr>
                        <td class='text-primary text-center'><b>{data.Code}</b></td>
                        <td class='text-primary text-center'><b>{data.Version}</b></td>
                        <td class='text-primary text-center'><b>{data.DrawingNote}</b></td>
                    </tr>
                    <tr>
                        <th colspan='3' class='bg-light text-center'>Side Order Description</th>
                    </tr>
                    <tr>
                        <td class='text-primary text-center' colspan='3'><b>{data.SiteOrderDescription}</b></td>
                    </tr>
                    <tr>
                        <td colspan='4' class='text-center'>
                            <div class='d-flex flex-wrap justify-content-center'>
                                {imageHtml}
                            </div>
                        </td>
                    </tr>
                </table>";
           
            popupContent.InnerHtml = html;
        }

        private dynamic GetDetailByKey(string id)
        {
            try
            {
                int LineNo = SQRLibrary.ConvertToInt(id);
                string DocumentNo = Request["no"] != null ? Request["no"].ToString() : "";

                string sql = @"
                        SELECT 
	                        line.No_,
	                        ci.FullRemark,
	                        i.Length,
	                        i.Width,
	                        i.Height,
	                        ci.DrawingCode,
	                        ci.DrawingVersionCode,
	                        ci.DrawingNote,
	                        ci.SiteOrderDescription

                        FROM [LIVE_ALLIANCE_90$Sales Line] line
                        LEFT JOIN LIVE_ALLIANCE_90$Item i ON line.No_ = i.No_
                        LEFT JOIN Custom_ItemInformation ci ON line.No_ = ci.ItemCode
                        WHERE [Document No_] = @DocumentNo
                        AND [Line No_] = @LineNo";
                DataTable dtItemDetailInfo = SQRLibrary.ReturnDatatablefromSQL(sql
                    , new List<string>() { "@DocumentNo", "@LineNo" }
                    , new List<object>() { DocumentNo , LineNo});

                if (dtItemDetailInfo.Rows.Count <= 0) return null;
                DataRow r = dtItemDetailInfo.Rows[0];


                List<string> IMGs = new List<string>() { };
                string ParentNo = r["No_"].ToString().Length == 15 ? r["No_"].ToString().Substring(0,12) : "";
                string sqlIMG = @"
                                SELECT ('/IMAGE/TENDER/' + LEFT(ItemNo,7) + '/' + FileName) Link
                                FROM Custom_ImageLinkData WHERE ItemNo = @ItemNo";

                DataTable dtIMG = SQRLibrary.ReturnDatatablefromSQL(sqlIMG
                    , new List<string>() { "@ItemNo" }
                    , new List<object>() { ParentNo });

                foreach (DataRow row in dtIMG.Rows) IMGs.Add(row["Link"].ToString());

                return new
                {
                    Remark = r["FullRemark"].ToString(),
                    Length = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    Width = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    Height = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    Code = r["DrawingCode"].ToString(),
                    Version = r["DrawingVersionCode"].ToString(),
                    DrawingNote = r["DrawingNote"].ToString(),
                    SiteOrderDescription = r["SiteOrderDescription"].ToString(),
                    ImageUrls = IMGs
                };
            }
            catch { return null; }
            
        }


        protected void btnSaveSiteRemark_Click(object sender, EventArgs e)
        {
            try
            {                

                string OrderNo = Request["no"]?.ToString() ?? "";
                string Remark = txtSiteRemark.Text.Trim();

                string sql = @"
                        UPDATE [LIVE_ALLIANCE_90$Sales Header] SET [VAT Description] = @remark 
                        WHERE [Document Type] = 7 and No_ = @No";

                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@remark", "@No" }
                    , new List<object>() { Remark, OrderNo });

                ScriptManager.RegisterStartupScript(this, this.GetType(), "SaveSiteRemark","Swal.fire('Success', 'All permission caches cleared!', 'warning');", true);
            }
            catch { }
        }
    }
}
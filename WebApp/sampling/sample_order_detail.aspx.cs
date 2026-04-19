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
using WebApplication2;

namespace WebApp.sampling
{
    public partial class sample_order_detail : System.Web.UI.Page
    {
        private string _documentCreatedUser = "";
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

            if (!IsPostBack)
            {                
                //LoadDrawingListToGrid();                
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở blanket factory order");
                
                txtSiteRemark.Attributes["onkeydown"] = $"submitOnEnter(event, '{btnSaveSiteRemark.ClientID}')";
                
            }
            LoadFactoryOrderDetailToControl(IsPostBack);

            gridFactorySampleAndSpecialOrderDetail.DataBind(); //bind to build UI and row custom merge row style            
            
            LoadDrawingListToGrid_gridUploadDrawingByItem();

            string docId = Request["no"]?.ToString()??"";
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

        private void LoadFactoryOrderDetailToControl(bool IsPostback = false)
        {
            try
            {
                string FactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";
                if (!IsPostback) UpdateHeaderText(FactoryOrder);

                btnDeleteFocusRow.Visible = false;
                btnUploadDrawing.Visible = false;
                gridFactorySampleAndSpecialOrderDetail.AutoGenerateColumns = false;
                LoadFactorySampleandSpecialOrderDetail(FactoryOrder);

                ShowOrHideColumns(null, null);
            }
            catch { }
        }

        private void UpdateHeaderText(string FactoryOrder)
        {
            try
            {
                string sqlHeader = "SELECT No_, [Sell-to Customer Name], AllocationFor, [Status], [Order Class], JobNo, [VAT Description] SiteRemark, LastUpdatedUser FROM [LIVE_ALLIANCE_90$Sales Header] WHERE  No_ = @No AND [Document Type] = 7";
                DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                    , new List<string>() { "@No" }
                    , new List<object>() { FactoryOrder });
                if (dtHeader.Rows.Count <= 0) return;
                DataRow fr = dtHeader.Rows[0];

                Session["ProjectCode"] = fr["JobNo"].ToString();
                Session["OrderClass"] = fr["Order Class"].ToString();
                Session["Status"] = fr["Status"].ToString();

                txtSiteRemark.Text = fr["SiteRemark"].ToString();
                _documentCreatedUser = fr["LastUpdatedUser"].ToString().Split(':')[0] ?? "";
                txtDesciptionHeader.InnerHtml = string.Concat(
                        "Factory Sample And Special Order: ",
                        fr[0].ToString() + " - ",
                        fr[1].ToString() + " - ",
                        Session["status"].ToString().Equals("0") ? "<text class='text-white bg-warning p-1'> Open </text>" : "<text class='bg-success text-white p-1'> Released </text>");
                this.Title = string.Concat(
                        "Factory Sample And Special Order: ",
                        fr[0].ToString() + " - ",
                        fr[1].ToString() + " - ");
            }
            catch { }
        }

        private void LoadFactorySampleandSpecialOrderDetail(string OrderNo)
        {
            try
            {
                //with factory sample or special order, we don't need to get data with 'domestic' format
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_Get_Factory_Sample_And_Special_Order_LineData] @OrderNo"
                    , new List<string>() { "@OrderNo" }
                    , new List<object>() { OrderNo });                                
                
                Library.LibraryFunction.MakeAllColumnEditable(dt);
                gridFactorySampleAndSpecialOrderDetail.DataSource = dt;
                gridFactorySampleAndSpecialOrderDetail.DataBind();

                //gridFactorySampleAndSpecialOrderDetail.DataColumns["ParentRemark"].Width = 350;
                //gridFactorySampleAndSpecialOrderDetail.DataColumns["SiteOrderDescription"].Width = 300;
                gridFactorySampleAndSpecialOrderDetail.DataColumns["UOM"].Width = 50;
                //gridFactorySampleAndSpecialOrderDetail.DataColumns["ParentDescription"].Width = 170;

                
                gridFactorySampleAndSpecialOrderDetail.DataColumns["DocumentType"].Visible = false;
                gridFactorySampleAndSpecialOrderDetail.DataColumns["LineNo"].Visible = false;
                gridFactorySampleAndSpecialOrderDetail.DataColumns["DocumentNo"].Visible = false;
                

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
            for (int i = 0; i < gridFactorySampleAndSpecialOrderDetail.VisibleRowCount - 1; i++)
            {
                string text = gridFactorySampleAndSpecialOrderDetail.GetDataRow(i)["ParentNo"].ToString();
                if (text == gridFactorySampleAndSpecialOrderDetail.GetDataRow(i + 1)["ParentNo"].ToString())
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

                //e.Column.PropertiesEdit.EncodeHtml = false;
                if (e.Column.FieldName == "SiteOrderDescription")
                {
                    e.DisplayText = e.Value != null ? e.Value.ToString().Replace("\r\n", "\n").Replace("\r", "\n").Replace("\n", "<br />") : "";
                }
                //if (e.Column.FieldName == "ParentRemark")
                //{
                //    e.DisplayText = e.Value != null ? e.Value.ToString().Replace("\r\n", "\n").Replace("\r", "\n").Replace("\n", "<br />") : "";
                //}
                if (e.Column.FieldName == "DrawingNote")
                {
                    e.DisplayText = e.Value != null ? e.Value.ToString().Replace("\r\n", "\n").Replace("\r", "\n").Replace("\n", "<br />") : "";
                }
                if (e.Column.FieldName == "DrawingVersionCode")
                {
                    e.DisplayText = (e.Value != null && e.Value.ToString().Length > 0) ? e.Value.ToString() == "V3" ? "Customer Drawing" : "Construction Drawing" : "";
                }
            }
            catch { }
        }



        protected void gridFactorySampleAndSpecialOrderDetail_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {

        }

        protected void gridFactorySampleAndSpecialOrderDetail_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            try
            {
                //if (Session["OrderClass"]?.ToString() == "Domestic")
                //{
                //    var palette = ASPxWebControl.GlobalThemeBaseColor;

                //    bool odd;
                //    rows.TryGetValue(e.VisibleIndex, out odd);
                //    if (odd)
                //    {
                //        e.Row.BackColor = Color.WhiteSmoke;
                //    }
                //    else
                //    {
                //        e.Row.BackColor = Color.Transparent;
                //    }
                //}
            }
            catch { }
        }

        protected void gridFactorySampleAndSpecialOrderDetail_CustomCellMerge(object sender, ASPxGridViewCustomCellMergeEventArgs e)
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


        protected void gridFactorySampleAndSpecialOrderDetail_BeforeGetCallbackResult(object sender, EventArgs e)
        {
            if (Session["OrderClass"].ToString() == "Domestic")
            {
                
                
            }
        }

        protected void gridFactorySampleAndSpecialOrderDetail_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
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
                gridFactorySampleAndSpecialOrderDetail.DataBind();
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
                if (Session["OrderClass"]?.ToString() == "Domestic")
                {
                    //gridFactorySampleAndSpecialOrderDetail.DataColumns["SubGroup"].Visible = cbSubGroup.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Group"].Visible = cbGroup.Checked;                  
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["FullDescription"].Visible = cbParentRemark.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["DrawingCode"].Visible = cbDrawing.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["DrawingVersionCode"].Visible = cbDrawing.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Length"].Visible = cbDimension.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Width"].Visible = cbDimension.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Height"].Visible = cbDimension.Checked;

                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Timber Finish"].Visible = cbFinish.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["MetalFab Finish"].Visible = cbFinish.Checked;

                    gridFactorySampleAndSpecialOrderDetail.DataColumns["PackingDescription"].Visible = cbSiteDescription.Checked;
                    gridFactorySampleAndSpecialOrderDetail.SettingsSearchPanel.Visible = cbSearchPanel.Checked;
                }
                else
                {
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Group"].Visible = cbGroup.Checked;                    
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["FullDescription"].Visible = cbParentRemark.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Packing Description"].Visible = cbParentRemark.Checked;
                    gridFactorySampleAndSpecialOrderDetail.SettingsSearchPanel.Visible = cbSearchPanel.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Length"].Visible = cbDimension.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Width"].Visible = cbDimension.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Height"].Visible = cbDimension.Checked;
                    
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["Timber Finish"].Visible = cbFinish.Checked;
                    gridFactorySampleAndSpecialOrderDetail.DataColumns["MetalFab Finish"].Visible = cbFinish.Checked;
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

                DataRow r = gridFactorySampleAndSpecialOrderDetail.GetDataRow(gridFactorySampleAndSpecialOrderDetail.FocusedRowIndex);
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
            string ProjectCode = Session["ProjectCode"]?.ToString()?? "";
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
                , new List<object>() { Session["ProjectCode"]?.ToString()??"", "" });
            gridUploadDrawingByItem.DataSource = dt;
            gridUploadDrawingByItem.DataBind();
        }

        protected void btnMakeOrder_Click(object sender, EventArgs e)
        {
            try
            {           

                if (!isHasPermissionOnProject())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to create order for project {Session["ProjectCode"]?.ToString() ?? ""}!', 'bg-danger');", true);
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
                gridFactorySampleAndSpecialOrderDetail.DataBind();
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

        protected void gridFactorySampleAndSpecialOrderDetail_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            
            try
            {
                if (!isHasPermissionOnProject())
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'You do not have permission to delete order for project {Session["ProjectCode"].ToString()}!', 'bg-danger');", true);
                    e.Cancel = true;
                    gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessage"] = $"You do not have permission to delete order for project {Session["ProjectCode"].ToString()}!";
                    gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessageType"] = "danger";
                    return;
                }

                if (Session["status"].ToString() != "0")
                {
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', 'Status must be Open! You can not modify Released Order', 'bg-danger');", true);
                    e.Cancel = true;
                    gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessage"] = $"Status must be Open! You can not modify Released Order";
                    gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessageType"] = "danger";
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
                    gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessage"] = $"At least one production order is link with this line! You can not delete it, please cancelled related production order first!";
                    gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessageType"] = "danger";
                    return;
                }

                string sqlDeleteSaleLine = "delete [LIVE_ALLIANCE_90$Sales Line] WHERE [Document Type]=7 and [Document No_] = @DocumentNo and [Line No_] = @LineNo";
                //SQRLibrary.ExecuteSQL(sqlDeleteSaleLine
                //     , new List<string>() { "@DocumentNo", @"LineNo" }
                //     , new List<object>() { DocumentNo, LineNo });


                LoadFactoryOrderDetailToControl();
                ShowOrHideColumns(sender, e);
                e.Cancel = true;
                gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessage"] = $"Successfully deleted!";
                gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessageType"] = "success";
            }
            catch (Exception ex) 
            { 
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", $"ShowPopup('POR System', '{ex.Message}', 'bg-danger');", true);
                gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessage"] = ex.Message;
                gridFactorySampleAndSpecialOrderDetail.JSProperties["cpMessageType"] = "danger";
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
                e.DisplayText = e.Value.ToString() == "3" ? "Customer Drawing" : "Unknown";
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
                gridFactorySampleAndSpecialOrderDetail.DataBind(); //bind to build UI and row custom merge row style
                //ShowOrHideColumns();
            }
            catch { }
        }

        protected void gridFactorySampleAndSpecialOrderDetail_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {

            if (e.ButtonID == "btnCustomViewDrawingByItem")
            {
                string filePath = gridFactorySampleAndSpecialOrderDetail.GetRowValues(e.VisibleIndex, "SDFilePath")?.ToString();

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
                imageHtml += $"<img src='{imgUrl}' class='img-thumbnail m-1' style='max-width: 100px; cursor: pointer;' onclick=\"showLightbox('{imgUrl}')\" onerror=\"this.onerror=null;this.src='/images/noproduct.png';\" />";
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
                        <th colspan='3' class='bg-light text-center'>Packing Description</th>
                    </tr>
                    <tr>
                        <td class='text-primary text-center' colspan='3'><b>{data.PackingDescription}</b></td>
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
	                        ci.SiteOrderDescription,
                            i.[Packing Description],
                             (
		                    CASE 		
			                    WHEN LEFT(line.No_, 4) = 'ITEM' 
				                    THEN '/huu2/' + LEFT(line.No_, 10)+'/' + line.No_ + '.png' --SAMPLE AND SPECIAL ITEM
			                    WHEN (LEFT(line.No_, 2) = 'DA') AND (LEN(line.No_) >=12)      -- PROJECT ITEM
				                    THEN '/image/' + LEFT(line.No_,12) + '.png'
			                    ELSE '/huu2/' + LEFT(line.No_,2)+'/' + line.No_ + '.png'	-- FOREIGN ITEM
			   
		                    END
		                    ) [ImageURL]
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

                IMGs.Add(r["ImageURL"].ToString());

                return new
                {
                    Remark = r["FullRemark"].ToString(),
                    Length = SQRLibrary.ConvertToDecimal(r["Length"]).ToString("#0.#"),
                    Width = SQRLibrary.ConvertToDecimal(r["Width"]).ToString("#0.#"),
                    Height = SQRLibrary.ConvertToDecimal(r["Height"]).ToString("#0.#"),
                    Code = r["DrawingCode"].ToString(),
                    Version = r["DrawingVersionCode"].ToString(),
                    DrawingNote = r["DrawingNote"].ToString(),
                    PackingDescription = r["Packing Description"].ToString(),
                    ImageUrls = IMGs
                };
            }
            catch { return null; }
            
        }

        protected void btnSaveSiteRemark_Click(object sender, EventArgs e)
        {
            try
            {
                string sqlHeader = "SELECT No_, [Sell-to Customer Name], AllocationFor, [Status], [Order Class], JobNo, [VAT Description] SiteRemark, LastUpdatedUser FROM [LIVE_ALLIANCE_90$Sales Header] WHERE  No_ = @No AND [Document Type] = 7";
                DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                    , new List<string>() { "@No" }
                    , new List<object>() { Request["no"]?.ToString() ?? "" });
                if (dtHeader.Rows.Count <= 0) return;
                DataRow fr = dtHeader.Rows[0];                
                _documentCreatedUser = fr["LastUpdatedUser"].ToString().Split(':')[0] ?? "";

                if (_documentCreatedUser != Session["userid"].ToString())
                {                    
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SaveSiteRemark", "Swal.fire('Warning', 'You do not have permission to update Site remark!', 'warning');", true);
                    return;
                }

                string OrderNo = Request["no"]?.ToString() ?? "";
                string Remark = txtSiteRemark.Text.Trim();

                string sql = @"
                        UPDATE [LIVE_ALLIANCE_90$Sales Header] SET [VAT Description] = @remark 
                        WHERE [Document Type] = 7 and No_ = @No";

                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@remark", "@No" }
                    , new List<object>() { Remark, OrderNo });

                ScriptManager.RegisterStartupScript(this, this.GetType(), "SaveSiteRemark","Swal.fire('Success', 'Save successfully', 'success');", true);
            }
            catch { }
        }
    }
}
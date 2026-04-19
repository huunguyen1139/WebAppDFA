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
using Microsoft.Ajax.Utilities;
using WebApp.functions.approval;

namespace WebApp.site
{
    public partial class blanket_factory_order_detail : System.Web.UI.Page
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";            //MaterialCompact
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            cbGroup.InputAttributes["class"] = "form-check-input ";
            cbSubGroup.InputAttributes["class"] = "form-check-input";
            cbSiteDescription.InputAttributes["class"] = "form-check-input";
            cbParentRemark.InputAttributes["class"] = "form-check-input";
            cbOrderedInfo.InputAttributes["class"] = "form-check-input";
            cbSearchPanel.InputAttributes["class"] = "form-check-input";
            cbDimension.InputAttributes["class"] = "form-check-input";
            cbApply.InputAttributes["class"] = "form-check-input";
            cbFinish.InputAttributes["class"] = "form-check-input";
            cbPrice.InputAttributes["class"] = "form-check-input";
            

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
                Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở blanket factory order");

            }
            LoadBlanketOrderDetailToControl();            
            gridBlanketFactoryOrderDetail.DataBind();
            ShowOrHideColumns();


            

            //set parameter for comment control
            commentSection.DocumentID = Request["no"]?.ToString() ?? ""; 

            //set parameter for approval
            ApprovalService.SetInfoToApprovalControl(
                control: ApprovalFlow1,
                WebApp.Models.Enum.ApprovalEnum.ApprovalDocumentType.BlanketFactoryOrder,
                Request["no"]?.ToString() ?? "",
                $"Blanket Factory Order {Request["no"]?.ToString() ?? ""}",
                "",
                ViewState["DocDes"]?.ToString() ?? ""
                );
        }

        private void LoadOrderQtyDetail()
        {

        }
        private void LoadBlanketOrderDetailToControl()
        {
            try
            {
                string BlanketFactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";
                UpdateHeaderText(BlanketFactoryOrder);
                //string sqlHeader = "SELECT No_, [Sell-to Customer Name], AllocationFor, [Status], [Order Class], JobNo FROM [LIVE_ALLIANCE_90$Sales Header] WHERE  No_ = @No AND [Document Type]=4 AND AllocationFor = 1";
                //DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                //    , new List<string>() { "@No" }
                //    , new List<object>() { BlanketFactoryOrder });
                //if (dtHeader.Rows.Count <= 0) return;
                //DataRow fr = dtHeader.Rows[0];
                //txtDesciptionHeader.InnerHtml = string.Concat(
                //    "Blanket Factory Order :",
                //    fr[0].ToString() + " - ",
                //    fr[1].ToString() + " - ",
                //    fr[3].ToString().Equals("0")? "<text class='text-white bg-warning p-1'> Open </text>" : "<text class='bg-success text-white p-1'> Released </text>");

                //this.Title = string.Concat(
                //    "Blanket Factory Order: ",
                //    fr[0].ToString() + " - ",
                //    fr[1].ToString() + " - ");

                //Session["ProjectCode"] = fr["JobNo"].ToString();
                //Session["OrderClass"] = fr["Order Class"].ToString();

                if ((Session["OrderClass"]?.ToString()??"") == "Domestic")
                {
                    gridBlanketFactoryOrderDetail.AutoGenerateColumns = false;
                    LoadDomesticBlanketFactoryandSiteOrderDetail(BlanketFactoryOrder);
                }
                else
                {
                    gridBlanketFactoryOrderDetail.Columns.Clear();
                    gridBlanketFactoryOrderDetail.AutoGenerateColumns = true;
                    LoadForeignBlanketFactoryandSiteOrderDetail(BlanketFactoryOrder);
                }

            }
            catch { }
        }

        private void UpdateHeaderText(string BlanketFactoryOrder)
        {
            try
            {
                string sqlHeader = "SELECT No_, [Sell-to Customer Name], AllocationFor, [Status], [Order Class], JobNo FROM [LIVE_ALLIANCE_90$Sales Header] WHERE  No_ = @No AND [Document Type]=4 AND AllocationFor = 1";
                DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                    , new List<string>() { "@No" }
                    , new List<object>() { BlanketFactoryOrder });
                if (dtHeader.Rows.Count <= 0) return;
                DataRow fr = dtHeader.Rows[0];

                ViewState["DocDes"] = $"Blanket Factory Order: - {fr["No_"].ToString()} - {fr["Sell-to Customer Name"].ToString()}";
                ViewState["ProjectCode"] = fr["JobNo"].ToString();
                Session["ProjectCode"] = fr["JobNo"].ToString();
                Session["OrderClass"] = fr["Order Class"].ToString();
                ViewState["status"] = fr["Status"].ToString();

                txtDesciptionHeader.InnerHtml = string.Concat(
                    "Blanket Factory Order: ",
                    fr[0].ToString() + " - ",
                    fr[1].ToString() + " - ",
                    ViewState["status"].ToString().Equals("0") ? "<text class='text-white bg-danger p-1'> Open </text>" :
                    ViewState["status"].ToString().Equals("2") ? "<text class='bg-warning text-white p-1'> Pending Approval </text>" :
                    ViewState["status"].ToString().Equals("1") ? "<text class='bg-success text-white p-1'> Released </text>" :
                        "<text class='bg-success text-white p-1'> Undefined </text>");

                this.Title = string.Concat(
                    "Blanket Factory Order: ",
                    fr[0].ToString() + " - ",
                    fr[1].ToString() + " - ");

                
            }
            catch { }
        }
        private void LoadForeignBlanketFactoryandSiteOrderDetail(string OrderNo)
        {
            try
            {
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_GetBlanketFactoryOrSiteOrderLineData_Foreign] @OrderNo, 1"
                    , new List<string>() { "@OrderNo" }
                    , new List<object>() { OrderNo });
                Library.LibraryFunction.MakeAllColumnEditable(dt);
                gridBlanketFactoryOrderDetail.SettingsBehavior.AllowCellMerge = false;
                gridBlanketFactoryOrderDetail.DataSource = dt;
                gridBlanketFactoryOrderDetail.DataBind();

                List<string> editable_cl = new List<string>() { "OrderQty", "NeedOnDate", "SiteOrderDescription" };
                foreach (GridViewDataColumn cl in gridBlanketFactoryOrderDetail.DataColumns)
                {
                    if (!editable_cl.Contains(cl.FieldName)) cl.ReadOnly = true;
                }

                List<string> nonwrap_cl = new List<string>() { "No_" };
                foreach (GridViewDataColumn cl in gridBlanketFactoryOrderDetail.DataColumns)
                {
                    if (nonwrap_cl.Contains(cl.FieldName)) cl.CellStyle.Wrap = DevExpress.Utils.DefaultBoolean.False;
                }
                gridBlanketFactoryOrderDetail.DataColumns["FullDescription"].Width = 400;
                gridBlanketFactoryOrderDetail.DataColumns["SiteOrderDescription"].Width = 300;
                gridBlanketFactoryOrderDetail.DataColumns["Packing Description"].Width = 300;
                gridBlanketFactoryOrderDetail.DataColumns["No_"].Width = 150;

                gridBlanketFactoryOrderDetail.DataColumns["Quantity"].PropertiesEdit.DisplayFormatString = "#0.####";
                gridBlanketFactoryOrderDetail.DataColumns["OrderedQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridBlanketFactoryOrderDetail.DataColumns["AdjustedQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridBlanketFactoryOrderDetail.DataColumns["RemainQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridBlanketFactoryOrderDetail.DataColumns["OrderQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";

                gridBlanketFactoryOrderDetail.DataColumns["Unit Price"].PropertiesEdit.DisplayFormatString = "#,##0";
                gridBlanketFactoryOrderDetail.DataColumns["Amount"].PropertiesEdit.DisplayFormatString = "#,##0";

                gridBlanketFactoryOrderDetail.DataColumns["Length"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridBlanketFactoryOrderDetail.DataColumns["Width"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridBlanketFactoryOrderDetail.DataColumns["Height"].PropertiesEdit.DisplayFormatString = "#,##0.####";

                gridBlanketFactoryOrderDetail.DataColumns["DocumentType"].Visible = false;
                gridBlanketFactoryOrderDetail.DataColumns["LineNo"].Visible = false;
                gridBlanketFactoryOrderDetail.DataColumns["DocumentNo"].Visible = false;
            }
            catch { }
        }

        private void LoadDomesticBlanketFactoryandSiteOrderDetail(string OrderNo)
        {
            try
            {
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC [ALL_GetBlanketFactoryOrSiteOrderLineData_Domestic] @OrderNo, 1"
                    , new List<string>() { "@OrderNo" }
                    , new List<object>() { OrderNo });
                                
                gridBlanketFactoryOrderDetail.SettingsBehavior.AllowCellMerge = true;
                Library.LibraryFunction.MakeAllColumnEditable(dt);
                gridBlanketFactoryOrderDetail.DataSource = dt;
                gridBlanketFactoryOrderDetail.DataBind();

                gridBlanketFactoryOrderDetail.DataColumns["ParentRemark"].Width = 350;
                gridBlanketFactoryOrderDetail.DataColumns["SiteOrderDescription"].Width = 300;
                gridBlanketFactoryOrderDetail.DataColumns["DrawingNote"].Width = 300;
                gridBlanketFactoryOrderDetail.DataColumns["UOM"].Width = 50;
                gridBlanketFactoryOrderDetail.DataColumns["ParentDescription"].Width = 240;

                
                //gridBlanketFactoryOrderDetail.DataColumns["Quantity"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridBlanketFactoryOrderDetail.DataColumns["UOM"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridBlanketFactoryOrderDetail.DataColumns["Group"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridBlanketFactoryOrderDetail.DataColumns["OrderedQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridBlanketFactoryOrderDetail.DataColumns["AdjustedQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridBlanketFactoryOrderDetail.DataColumns["RemainQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;
                //gridBlanketFactoryOrderDetail.DataColumns["OrderQty"].Settings.AllowCellMerge = DevExpress.Utils.DefaultBoolean.False;

                //gridBlanketFactoryOrderDetail.DataColumns["Quantity"].PropertiesEdit.DisplayFormatString = "#0.####";
                //gridBlanketFactoryOrderDetail.DataColumns["OrderedQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                //gridBlanketFactoryOrderDetail.DataColumns["AdjustedQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                //gridBlanketFactoryOrderDetail.DataColumns["RemainQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                //gridBlanketFactoryOrderDetail.DataColumns["OrderQty"].PropertiesEdit.DisplayFormatString = "#,##0.####";
                gridBlanketFactoryOrderDetail.DataColumns["DocumentType"].Visible = false;
                gridBlanketFactoryOrderDetail.DataColumns["LineNo"].Visible = false;
                gridBlanketFactoryOrderDetail.DataColumns["DocumentNo"].Visible = false;

                foreach (GridViewDataColumn cl in gridBlanketFactoryOrderDetail.DataColumns)
                {                    
                    cl.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
                }

                if (gridBlanketFactoryOrderDetail.VisibleRowCount > 0) UpdateDictionary(rows, gridBlanketFactoryOrderDetail, "ParentNo");
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
            for (int i = 0; i < gridBlanketFactoryOrderDetail.VisibleRowCount - 1; i++)
            {
                string text = gridBlanketFactoryOrderDetail.GetDataRow(i)["ParentNo"].ToString();
                if (text == gridBlanketFactoryOrderDetail.GetDataRow(i + 1)["ParentNo"].ToString())
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
        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {


            }
            catch
            { }
        }

        private void CreateDynamicTableRow()
        {

        }

        private Color PaintColortoPICell(string Month)
        {
            switch (Month)
            {
                case "01": return Color.Gold;
                case "02": return Color.PaleGreen;
                case "03": return Color.LightBlue;
                case "04": return Color.LightSalmon;
                case "05": return Color.SpringGreen;
                case "06": return Color.Turquoise;
                case "07": return Color.Orange;
                case "08": return Color.Gainsboro;
                case "09": return Color.NavajoWhite;
                case "10": return Color.LawnGreen;
                case "11": return Color.MediumTurquoise;
                case "12": return Color.AliceBlue;
            }
            return Color.Transparent;
        }

        private void btn_Click(object sender, EventArgs e)
        {
            try
            {

            }
            catch { }
        }
        private string ReturnCssForTop10Target(List<double> listcontrolvalue, double controlvalue)
        {
            int position = listcontrolvalue.Count(x => x > controlvalue) + 1;
            if (position <= 3) return "label label-success";
            if (position <= 6) return "label label-info";
            if (position <= 8) return "label label-warning";
            return "label label-danger";
        }
        private string GetActualTarget(string Department, DataTable data)
        {
            try
            {
                for (int i = 0; i < data.Rows.Count; i++)
                {
                    if (data.Rows[i][0].ToString().Equals(Department))
                    {
                        return data.Rows[i][1].ToString();
                    }
                }
                return "0";
            }
            catch { return "0"; }
        }

        protected void gridFactoryOrder_CustomColumnDisplayText(object sender, DevExpress.Web.ASPxGridViewColumnDisplayTextEventArgs e)
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
            }
            catch { }
        }
        protected void gridBlanketFactoryOrderDetail_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn == null) return;

            if (e.DataColumn.FieldName == "No_")
            {
                object noObj = e.GetValue("No_");
                string itemNo = Convert.ToString(noObj ?? "").Trim();

                if (!string.IsNullOrEmpty(itemNo))
                {
                    string encodedText = HttpUtility.HtmlEncode(itemNo);
                    string encodedJs = HttpUtility.JavaScriptStringEncode(itemNo);

                    e.Cell.Text = string.Format(
                        "<a href='javascript:void(0);' onclick='ShowOrderQtyDetail(\"{0}\");'>{1}</a>",
                        encodedJs,
                        encodedText
                    );
                }
            }
        }
        protected void gridBlanketFactoryOrderDetail_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
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
        protected void gridBlanketFactoryOrderDetail_CustomCellMerge(object sender, ASPxGridViewCustomCellMergeEventArgs e)
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
        protected void gridBlanketFactoryOrderDetail_BeforeGetCallbackResult(object sender, EventArgs e)
        {
            if (Session["OrderClass"].ToString() == "Domestic")
            {
                if (gridBlanketFactoryOrderDetail.VisibleRowCount > 0) UpdateDictionary(rows, gridBlanketFactoryOrderDetail, "ParentNo");
                Traverse();
            }
        }
        protected void gridBlanketFactoryOrderDetail_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            bool isHandled = true;
            string errorMessage = null;
            try
            {
                // === VALIDATE UPDATES ===
                foreach (var args in e.UpdateValues)
                {                    
                    decimal remainqty = SQRLibrary.ConvertToDecimal(args.NewValues["RemainQty"]);
                    decimal remainqty_old = SQRLibrary.ConvertToDecimal(args.OldValues["RemainQty"]);
                    remainqty = Math.Max(remainqty, remainqty_old);

                    decimal quantity = SQRLibrary.ConvertToDecimal(args.NewValues["OrderQty"]);
                    string DrawingNote = args.NewValues["DrawingNote"]?.ToString();

                    if (quantity > remainqty)
                    {
                        errorMessage = "Order Quantity must be <= Remain Quantity!";
                        break;
                    }

                    if (DrawingNote.IsNullOrWhiteSpace())
                    {
                        if (Session["OrderClass"].ToString() == "Domestic")
                            errorMessage = "Drawing Note must not empty!";
                        break;
                    }
                }

                if (errorMessage != null)
                {
                    // Cancel the update
                    e.Handled = true;

                    // Pass error message to client
                    gridBlanketFactoryOrderDetail.JSProperties["cpErrorMessage"] = errorMessage;
                    gridBlanketFactoryOrderDetail.JSProperties["cpHasError"] = true;
                    return;
                }

                foreach (var args in e.UpdateValues)
                {
                    UpdateItem(args.Keys, args.NewValues, args.OldValues);
                }

                e.Handled = true;
                gridBlanketFactoryOrderDetail.JSProperties["cpSuccessMessage"] = "Batch update successful!";
                gridBlanketFactoryOrderDetail.JSProperties["cpHasError"] = false;

                LoadBlanketOrderDetailToControl();
                gridBlanketFactoryOrderDetail.DataBind();
                ShowOrHideColumns();
            }
            catch (Exception ex) { e.Handled = true; gridBlanketFactoryOrderDetail.JSProperties["cpErrorMessage"] = ex.Message; }
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

        private void UpdateItem(OrderedDictionary keys, OrderedDictionary newValues, OrderedDictionary oldValues)
        {
            try
            {
                string DocumentNo = Request["no"] == null ? "" : Request["no"].ToString();
                int LineNo = SQRLibrary.ConvertToInt(keys["LineNo"]);
                string SiteDescription = newValues["SiteOrderDescription"]!= null?  newValues["SiteOrderDescription"].ToString(): "";
                decimal quantity = SQRLibrary.ConvertToDecimal(newValues["OrderQty"]);
                DateTime NeedDate = newValues["NeedOnDate"] != null ? (DateTime)newValues["NeedOnDate"] : DateTime.Today;

                decimal Length = SQRLibrary.ConvertToDecimal(newValues["Length"]);
                decimal Width = SQRLibrary.ConvertToDecimal(newValues["Width"]);
                decimal Height = SQRLibrary.ConvertToDecimal(newValues["Height"]);
                string DrawingNote = newValues["DrawingNote"] != null ? newValues["DrawingNote"].ToString() : "";

                string ItemCode = oldValues["No_"].ToString();

                string sql = "EXEC ALL_UPDATE_BLANKET_ORDER_LINE_INFORMATION @DocumentNo, @LineNo, @SiteOrderDescription, @quantity, @NeedDate, @ItemCode, @Length, @Width, @Height, @DrawingNote";

                SQRLibrary.ExecuteSQL(sql
                    , new List<string>() { "@DocumentNo", "@LineNo", "@SiteOrderDescription", "@quantity", "@NeedDate", "@ItemCode", "@Length", "@Width", "@Height", "@DrawingNote" }
                    , new List<object>() { DocumentNo, LineNo, SiteDescription, quantity, NeedDate, ItemCode, Length, Width, Height, DrawingNote });

            }
            catch { }
        }

        protected void cbOrderedInfo_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbParentRemark_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbGroup_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbSubGroup_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void cbSiteDescription_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        private void ShowOrHideColumns()
        {
            try
            {
                gridBlanketFactoryOrderDetail.DataBind();
                if (Session["OrderClass"] != null && Session["OrderClass"].ToString() == "Domestic")
                {
                    cbFinish.Visible = false;
                    gridBlanketFactoryOrderDetail.DataColumns["SubGroup"].Visible = cbSubGroup.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Group"].Visible = cbGroup.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["OrderedQty"].Visible = cbOrderedInfo.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["AdjustedQty"].Visible = cbOrderedInfo.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["ParentRemark"].Visible = cbParentRemark.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["SiteOrderDescription"].Visible = cbSiteDescription.Checked;
                    gridBlanketFactoryOrderDetail.SettingsSearchPanel.Visible = cbSearchPanel.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Unit Price"].Visible = cbPrice.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Amount"].Visible = cbPrice.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Length"].Visible = cbDimension.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Width"].Visible = cbDimension.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Height"].Visible = cbDimension.Checked;
                }
                else
                {
                    cbFinish.Visible = true;
                    gridBlanketFactoryOrderDetail.DataColumns["Group"].Visible = cbGroup.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["OrderedQty"].Visible = cbOrderedInfo.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["AdjustedQty"].Visible = cbOrderedInfo.Checked;                   
                    gridBlanketFactoryOrderDetail.DataColumns["SiteOrderDescription"].Visible = cbSiteDescription.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["FullDescription"].Visible = cbParentRemark.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Packing Description"].Visible = cbParentRemark.Checked;
                    gridBlanketFactoryOrderDetail.SettingsSearchPanel.Visible = cbSearchPanel.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Length"].Visible = cbDimension.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Width"].Visible = cbDimension.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Height"].Visible = cbDimension.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Unit Price"].Visible = cbPrice.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Amount"].Visible = cbPrice.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["ApplyToOrderNo"].Visible = cbApply.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["ApplyToLineNo"].Visible = cbApply.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["Timber Finish"].Visible = cbFinish.Checked;
                    gridBlanketFactoryOrderDetail.DataColumns["MetalFab Finish"].Visible = cbFinish.Checked;
                }
            }
            catch { }
        }

   
        protected void btnCloseModal_ServerClick(object sender, EventArgs e)
        {
            divModalForFullPostBack.Attributes["class"] = "modal fade";
            divModalForFullPostBack.Attributes["style"] = "";
        }

        protected void cbSearchPanel_CheckedChanged(object sender, EventArgs e)
        {
            ShowOrHideColumns();
        }

        protected void btnClearOrderQty_Click(object sender, EventArgs e)
        {
            try
            {
                string BlanketFactoryOrder = (Request["no"] != null) ? Request["no"].ToString() : "";

                string sqlHeader = "UPDATE [LIVE_ALLIANCE_90$Sales Line] SET [Qty_ to Ship] = 0, [Qty_ to Ship (Base)] = 0 WHERE  [Document No_] = @No AND [Document Type]=4";
                DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                    , new List<string>() { "@No" }
                    , new List<object>() { BlanketFactoryOrder });

                LoadBlanketOrderDetailToControl();
                //gridBlanketFactoryOrderDetail.DataBind();
                ShowOrHideColumns();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup", "ShowPopup('POR System', 'Already cleared!!', 'bg-success');", true);
            }
            catch { }
        }

        protected void btnMakeOrder_Click(object sender, EventArgs e)
        {
            try
            {
                //check permission: project and user create order              
                List<string> ProjectInchargeUser = Library.LibraryFunction.GetUserInchargeOfProject(Session["ProjectCode"].ToString());
                List<string> CreateOrderInchargeUser = new List<string>() { };
                if (Session["OrderClass"].ToString() == "Domestic")
                {
                    CreateOrderInchargeUser = Library.LibraryFunction.GetUserCreateDomesticOrder();
                }
                else CreateOrderInchargeUser = Library.LibraryFunction.GetUserCreateForeignOrder();

                if (!ProjectInchargeUser.Contains(Session["userid"].ToString()) && !CreateOrderInchargeUser.Contains(Session["userid"].ToString()))
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
                LoadBlanketOrderDetailToControl();
                gridBlanketFactoryOrderDetail.DataBind();
                ShowOrHideColumns();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Popup"
                    , @"ShowPopup('POR System', 'Order <a href= ""factory_order_detail?no=" + dt.Rows[0][0].ToString() + @""" target=""_blank"">" + dt.Rows[0][0].ToString() + "</a> has been created successfully!', 'bg-success');", true);
                
            }
            catch { }
        }

        protected void btnGeAllRelatedOrder_Click(object sender, EventArgs e)
        {

        }

        protected void ApprovalFlow1_StatusChanged(object sender, EventArgs e)
        {
            UpdateHeaderText(Request["no"]?.ToString() ?? "");
        }

        protected void cpOrderQtyDetail_Callback(object sender, CallbackEventArgsBase e)
        {
            string itemNo = (e.Parameter ?? "").Trim();
            string requestNo = Request.QueryString["no"] == null ? "" : Request.QueryString["no"].Trim();

            hfPopupItemNo.Value = itemNo;
            hfPopupRequestNo.Value = requestNo;

            litPopupItemNo.Text = Server.HtmlEncode(itemNo);
            litPopupRequestNo.Text = Server.HtmlEncode(requestNo);

            BindOrderQtyDetail(requestNo, itemNo);
        }

        private void BindOrderQtyDetail(string blanketOrderNo, string itemNo)
        {
            string sql = @"
            SELECT 
                CAST(sl.[Document No_] + '_' + CAST(sl.[Line No_] AS NVARCHAR(50)) AS NVARCHAR(100)) AS RowKey,
                sl.[Document No_],
                sl.Quantity,
                sl.[Unit of Measure Code] AS UOM,
                CASE 
                    WHEN sl.[Requested Delivery Date] <= '1753-01-01' THEN NULL
                    ELSE sl.[Requested Delivery Date]
                END AS [Requested Delivery Date],
                CASE 
                    WHEN sl.[Promised Delivery Date] <= '1753-01-01' THEN NULL
                    ELSE sl.[Promised Delivery Date]
                END AS [Promised Delivery Date],
                po.No_ AS [Production Order No]
            FROM [LIVE_ALLIANCE_90$Sales Line] sl
            LEFT JOIN [LIVE_ALLIANCE_90$Production Order] po
                ON po.[Simulated Order No_] = sl.[Document No_] + CAST(sl.[Line No_] AS NVARCHAR(50))
            WHERE sl.[Blanket Order No_] = @BlanketOrderNo
              AND sl.No_ = @ItemNo
              AND sl.[Document Type] = 7
            ORDER BY sl.[Document No_], sl.[Line No_]";

            DataTable dt = SQRLibrary.ReturnDatatablefromSQL(
                sql,
                new List<string> { "@BlanketOrderNo", "@ItemNo" },
                new List<object> { blanketOrderNo, itemNo }
            );

            gridOrderQtyDetail.DataSource = dt;
            gridOrderQtyDetail.DataBind();
        }

        protected void gridOrderQtyDetail_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e)
        {
            if (e.Column == null || e.Value == null) return;

            string fieldName = e.Column.FieldName;

            if (fieldName == "Requested Delivery Date" || fieldName == "Promised Delivery Date")
            {
                DateTime dt;
                if (DateTime.TryParse(Convert.ToString(e.Value), out dt))
                {
                    if (dt <= new DateTime(1753, 1, 1))
                    {
                        e.DisplayText = "";
                    }
                    else
                    {
                        e.DisplayText = dt.ToString("dd-MM-yyyy");
                    }
                }
            }
        }

        protected void gridOrderQtyDetail_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn == null) return;

            if (e.DataColumn.FieldName == "Document No_")
            {
                string docNo = Convert.ToString(e.GetValue("Document No_") ?? "").Trim();

                if (!string.IsNullOrEmpty(docNo))
                {
                    e.Cell.Text = string.Format(
                        "<a href='javascript:void(0);' onclick='OpenFactoryOrderDetail(\"{0}\");'>{1}</a>",
                        HttpUtility.JavaScriptStringEncode(docNo),
                        HttpUtility.HtmlEncode(docNo)
                    );
                }
            }

            if (e.DataColumn.FieldName == "Production Order No")
            {
                string prodOrderNo = Convert.ToString(e.GetValue("Production Order No") ?? "").Trim();

                if (!string.IsNullOrEmpty(prodOrderNo))
                {
                    e.Cell.Text = string.Format(
                        "<a href='javascript:void(0);' onclick='OpenProdOrderTracing(\"{0}\");'>{1}</a>",
                        HttpUtility.JavaScriptStringEncode(prodOrderNo),
                        HttpUtility.HtmlEncode(prodOrderNo)
                    );
                }
            }
        }

    }
}
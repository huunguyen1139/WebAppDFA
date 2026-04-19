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
using System.Net.NetworkInformation;
using DevExpress.XtraExport.Helpers;

namespace WebApp.production
{
    public partial class ProductionStatus : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            cbDrawing.InputAttributes["class"] = "form-check-input";
            cbProductionBOM.InputAttributes["class"] = "form-check-input";
            cbTimberFinish.InputAttributes["class"] = "form-check-input";
            cbMetalFinish.InputAttributes["class"] = "form-check-input";
            cbProductInfo.InputAttributes["class"] = "form-check-input";
            cbDefectHistory.InputAttributes["class"] = "form-check-input";
            cbChangeRequest.InputAttributes["class"] = "form-check-input";
            cbProgress.InputAttributes["class"] = "form-check-input";
            cbImage.InputAttributes["class"] = "form-check-input";
            cbDimension.InputAttributes["class"] = "form-check-input";
            cbRemark.InputAttributes["class"] = "form-check-input";
            cbFullName.InputAttributes["class"] = "form-check-input";
            cbParentCode.InputAttributes["class"] = "form-check-input";
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
                try
                {
                    string PI = (Request["PI"] != null) ? Request["PI"].ToString() : "";
                    Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở Production Status " + PI);
                    string sql = "";
                    sql = "select distinct [Description 2] as [PI] from [LIVE_ALLIANCE_90$Production Order] where [Description 2]<>'' AND [Status] in ('3') AND LEN([Description 2])<=20 ORDER BY [Description 2] desc";
                    
                    System.Data.DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql);
                    
                    Session["PIList"] = dt;
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (dt.Rows[i][0].ToString().Length <= 20)
                        {
                            ddPI.Items.Add(new ListItem(dt.Rows[i][0].ToString(), dt.Rows[i][0].ToString()));
                        }
                    }
                    
                }
                catch { }
            }
            if (Request["PI"] != null)
            {
                ddPI.SelectedValue = Request["PI"].ToString();
                LoadDataToGridView(Request["PI"].ToString(), !IsPostBack);
                ViewState["PI"] = Request["PI"].ToString();
                PaintColorToShowCompleteOrNot();
                ShowColumnsForSelectedCB();
            }
        }


        private void BuildImageColumn()
        {
            //if (gvDetailOutput.Columns.OfType<ImageFieldPlus>()
            //                          .Any(c => c.HeaderText == "Photo")) return; // already added

            //var img = new ImageFieldPlus
            //{
            //    HeaderText = "Image",
            //    DataImageUrlField = "Image",
            //    OnClientError = "this.onerror=null;this.src='/images/noproduct.png';"
            //};
            //img.ControlStyle.Width = 100;
            //img.ControlStyle.Height = 63;

            //gvDetailOutput.Columns.Add(img);
        }

        private void PaintColorToShowCompleteOrNot()
        {
            List<string> DepartmentList = new List<string>() { "RM", "FM", "AS", "SA", "SP", "FIN", "FIT", "TU", "IRON", "UPH", "PAC", "OT", "WH" };
            foreach (GridViewRow row in gvDetailOutput.Rows)
            {
                
                double qty = SQRLibrary.ConvertToDouble(row.Cells[6].Text);

                for (int i=0; i< gvDetailOutput.Columns.Count; i++)
                {
                    if (DepartmentList.IndexOf(gvDetailOutput.Columns[i].HeaderText) >= 0)
                    {
                        if (row.Cells[i].Text.Equals("&nbsp;"))
                        {
                            //row.Cells[i].BackColor = Color.Orange;
                            //row.Cells[i].ForeColor = Color.White;
                            row.Cells[i].Attributes["style"] = "color:#ffffff!important; background-color:#f69500;";
                        }
                        else if (SQRLibrary.ConvertToDouble(row.Cells[i].Text) < qty)
                        {
                            //row.Cells[i].BackColor = Color.Orange;
                            //row.Cells[i].ForeColor = Color.White;
                            row.Cells[i].Attributes["style"] = "color:#ffffff!important; background-color:#f69500;";
                        }
                        else
                        {
                            //row.Cells[i].BackColor = Color.ForestGreen;
                            //row.Cells[i].ForeColor = Color.White;
                            row.Cells[i].Attributes["style"] = "color:#ffffff!important; background-color:#129512;";
                        }
                    }
                }
            }
        }

        private void LoadDataToSession()
        {
            try
            {
                string sql = $"EXEC ALL_ProductionStatus '%{ Request["PI"]?.ToString() ?? ""}%'";
                ViewState["ProductionStatus_GETDETAILDATA"] = SQRLibrary.ReturnDatatablefromSQL(sql);

                ViewState["ProductionStatus_PINote"]  = SQRLibrary.ReturnDatatablefromSQL_mrp($"SELECT [Note], [UpdateUser],[UpdateOn] FROM [POR_PINote] where PINo = '{Request["PI"]?.ToString() ?? ""}'");
            }
            catch { }
        }

        private string GetHeaderText(string OrderNo)
        {
            string _result = "";
            try
            {
                string sqlHeader = "SELECT No_, [Sell-to Customer Name], AllocationFor, [Status], [Order Class], JobNo, [VAT Description] SiteRemark FROM [LIVE_ALLIANCE_90$Sales Header] WHERE  No_ = @No AND [Document Type] = 7";
                DataTable dtHeader = SQRLibrary.ReturnDatatablefromSQL(sqlHeader
                    , new List<string>() { "@No" }
                    , new List<object>() { OrderNo });
                if (dtHeader.Rows.Count <= 0) return "";
                DataRow fr = dtHeader.Rows[0];

                _result = fr[1].ToString();
            }
            catch { }
            return _result;
        }
        private void LoadDataToGridView(string PINo, bool Refresh = false)
        {
            try
            {
                if (Refresh) LoadDataToSession();
                //string sql = "EXEC ALL_ProductionStatus '%" + PINo + "%'";
                //DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql);
                DataTable dt = ViewState["ProductionStatus_GETDETAILDATA"] as DataTable;
                List<string> notshow = new List<string>() {"Spec", "WO", "ColorStyle", "SalePrice", "PI No_", "ShowIndex", "VNDescription" };
                //DataTable dtPINote = SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT [Note], [UpdateUser],[UpdateOn] FROM [POR_PINote] where PINo = '" + PINo + "'");
                DataTable dtPINote = ViewState["ProductionStatus_PINote"] as DataTable;

                if (dt.Rows.Count <= 0) 
                { 
                    divMessage.Visible = true; 
                    divMessage.InnerHtml = $"Production Order for <strong>{PINo}</strong> has not yet been created!"; 
                    return; 
                }
                gvDetailOutput.Columns.Clear();
                gvPINote.Columns.Clear();

                gvDetailOutput.Caption = $"Production Status: {PINo} - {GetHeaderText(PINo)}";
                Page.Title = $"Production Status: {PINo} - {GetHeaderText(PINo)}";
                gvPINote.Caption = "PI Note: " + PINo;

                foreach (DataColumn cl in dt.Columns)
                {
                    if (notshow.IndexOf(cl.ColumnName) < 0 && !cl.ColumnName.Equals("Image"))
                    {
                        gvDetailOutput.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                    }
                    if (notshow.IndexOf(cl.ColumnName) < 0 && cl.ColumnName.Equals("Image"))
                    {
                        ImageFieldPlus img = new ImageFieldPlus()
                        {
                            HeaderText = cl.ColumnName,
                            DataImageUrlField = cl.ColumnName,
                            OnClientError = "this.onerror=null;this.src='/images/noproduct.png';",
                            
                            // Use {img} placeholder — it will be replaced with actual URL
                            OnClientClick = "showLightbox('{img}')"

                        };
                        img.ControlStyle.Width = 100;
                        img.ControlStyle.Height = 63;
                        
                        gvDetailOutput.Columns.Add(img); 
                    }
                }
                foreach (DataColumn cl in dtPINote.Columns)
                {
                    gvPINote.Columns.Add(new BoundField() { DataField = cl.ColumnName, HeaderText = cl.ColumnName });
                }


                gvDetailOutput.Visible = true;            
                gvDetailOutput.AutoGenerateColumns = false;
                gvDetailOutput.DataSource = dt;
                gvDetailOutput.DataBind();
                AddLinkToBOMandDrawingCells(gvDetailOutput);
                AddLinkOfQualityReport(dt);


                gvPINote.Visible = true;
                gvPINote.AutoGenerateColumns = false;
                gvPINote.DataSource = dtPINote;
                gvPINote.DataBind();
                
            }
            catch { }
        }

        private void AddLinkOfQualityReport(DataTable dtProdStatus)
        {
            try
            {
                List<string> ReportNo = new List<string>() { };
                List<string> ProdNo = new List<string>() { };
                string ProdOrderList = string.Empty;
                if (dtProdStatus.Rows.Count < 200)
                {
                    for (int i =0; i < dtProdStatus.Rows.Count; i++)
                    {
                        //('gg';'d';'c')
                        ProdOrderList += dtProdStatus.Rows[i]["No_"].ToString() + "','";
                    }

                    if (ProdOrderList.Length > 3)
                    {
                        ProdOrderList = ProdOrderList.Substring(0, ProdOrderList.Length - 3);
                    }
                }
                string sql = "SELECT ProdOrderNo, Status, count(*) Total FROM [QC_QualityReportHeader] where ProdOrderNo in ('" + ProdOrderList + "')";
                sql += " and Status in (1,2,4) group by ProdOrderNo, Status order by ProdOrderNo";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL_mrp(sql);
                                
                
                for (int i = 0; i < gvDetailOutput.Columns.Count; i++)
                {                    

                    if (gvDetailOutput.Columns[i].HeaderText.Equals("Product Code"))
                    {
                        for (int j = 0; j < gvDetailOutput.Rows.Count; j++)
                        {
                                string ProductCode = string.Empty;
                                if (gvDetailOutput.Rows[j].Cells[i].Text.Substring(0, 3).Equals("POR")) ProductCode = gvDetailOutput.Rows[j].Cells[gvDetailOutput.Columns.Count - 1].Text; else ProductCode = gvDetailOutput.Rows[j].Cells[i].Text;
                            string ProdOrderNo = gvDetailOutput.Rows[j].Cells[i - 1].Text;
                            int total_completed = dt.AsEnumerable()
                                .Where(x => x["ProdOrderNo"].ToString().Equals(ProdOrderNo))
                                .Where(x => x["Status"].ToString().Equals("4"))
                                .Sum(x => SQRLibrary.ConvertToInt(x["Total"]));

                            int total_incompleted = dt.AsEnumerable()
                                .Where(x => x["ProdOrderNo"].ToString().Equals(ProdOrderNo))
                                .Where(x => !x["Status"].ToString().Equals("4"))
                                .Sum(x => SQRLibrary.ConvertToInt(x["Total"]));

                            string html = string.Empty;

                            html = total_incompleted > 0 ? ("<a href='/qc/qrlist?prod=" + ProdOrderNo + "' target='blank' style='color: coral; font-weight: bold;'>" + ProductCode + "</a>")
                                : total_completed > 0 ? ("<a href='/qc/qrlist?prod=" + ProdOrderNo + "' target='blank' style='color: blue; font-weight: bold;'>" + ProductCode + "</a>")
                                : gvDetailOutput.Rows[j].Cells[i].Text;

                            //set link to  Defect History column
                            if (gvDetailOutput.Columns[i+12].HeaderText.Equals("DefectHistory"))
                            {
                                gvDetailOutput.Rows[j].Cells[i + 12].Text = "<a target='_blank' href = 'qc/qrlist?des=" + gvDetailOutput.Rows[j].Cells[i].Text + "'>" + gvDetailOutput.Rows[j].Cells[i + 10].Text + "</a>";
                            }

                            gvDetailOutput.Rows[j].Cells[i].Text = HttpUtility.HtmlDecode(html);

                            //set link to Change Request Column
                            string css = "";
                            string CRcss = "";
                            if (gvDetailOutput.Columns[i + 13].HeaderText.Equals("ChangeRequest"))
                            {
                                string cell_text = gvDetailOutput.Rows[j].Cells[i + 13].Text;
                                var k = cell_text.Split('|');
                                if (k.Length >=2)
                                {
                                    int cr_processing = SQRLibrary.ConvertToInt(k[0]);
                                    int cr_total = SQRLibrary.ConvertToInt(k[1]);
                                    css = (cr_total - cr_processing) > 0 ? "link-danger fw-bold" : cr_total > 0 ? "link-success fw-bold" : "link-info";
                                    CRcss = (cr_total - cr_processing) > 0 ? 
                                        "badge bg-danger-subtle text-danger" 
                                        : cr_total > 0 ?
                                        "badge bg-success-subtle text-success" : "badge bg-success-subtle text-success";
                                    //<span class="badge bg-success-subtle text-success">Very  High</span>

                                    gvDetailOutput.Rows[j].Cells[i + 13].Text = 
                                        $@"<a target='_blank'  
                                            href = '/production/changerequest/requestlist?des={gvDetailOutput.Rows[j].Cells[i - 1].Text}'>
                                        <span class='{CRcss}'> Finished: {cr_processing}| All: {cr_total} </span></a>";
                                }
                                
                            }

                            //set link to first column, No_
                            gvDetailOutput.Rows[j].Cells[i - 1].Text = $"<a target='_blank' class='{css}' href = 'trace/ProdOrderTracing?No=" + gvDetailOutput.Rows[j].Cells[i - 1].Text + "'>" + gvDetailOutput.Rows[j].Cells[i - 1].Text + "</a>";
                                                       

                        }
                        break;
                    }
                }
            }
            catch { }
        }
        private void AddLinkToBOMandDrawingCells(GridView gv)
        {
            try
            {
                string drawing = default(string);
                string drawcode = default(string);
                string drawversion = default(string);
                string productionBOM = default(string);

                

                for (int i = 0; i < gv.Columns.Count; i++)
                {
                    if (gv.Columns[i].HeaderText.Equals("Remark"))
                    {
                        for (int j = 0; j < gv.Rows.Count; j++)
                        {
                            try
                            {
                                gv.Rows[j].Cells[i].Text = HttpUtility.HtmlDecode(gv.Rows[j].Cells[i].Text);
                            }
                            catch { }
                        }
                        break;
                    }
                }
                for (int i = 0; i < gv.Columns.Count; i++ )
                {
                    if (gv.Columns[i].HeaderText.Equals("Drawing"))
                    {
                        for (int j = 0; j < gv.Rows.Count; j++)
                        {
                            try
                            {
                                drawing = gv.Rows[j].Cells[i].Text;
                                drawcode = drawing.Split('*')[0];
                                drawversion = drawing.Split('*')[1];                                
                                gv.Rows[j].Cells[i].Text = "<a href='../DrawingReader?code=" + drawcode + "&version=" + drawversion + "' target='_blank'>" + drawing + "</a>";
                            }
                            catch { }
                        }
                        break;
                    }
                }

                for (int i = 0; i < gv.Columns.Count; i++)
                {
                    if (gv.Columns[i].HeaderText.Equals("FullDescription")) gv.Columns[i].Visible = false;
                    if (gv.Columns[i].HeaderText.Equals("ProductionBOM"))
                    {
                        for (int j = 0; j < gv.Rows.Count; j++)
                        {
                            try
                            {
                                productionBOM = gv.Rows[j].Cells[i].Text;                                
                                gv.Rows[j].Cells[i].Text = "<a href='ReportViewer?type=ProductionBOM&BOMCode=" + productionBOM + "' target='_blank'>" + productionBOM + "</a>";
                            }
                            catch { }
                        }                       
                    }

                    //if (gv.Columns[i].HeaderText.Equals("Description"))
                    //{
                    //    for (int j = 0; j < gv.Rows.Count; j++)
                    //    {
                    //        try
                    //        {
                    //            gv.Rows[j].Cells[i].Text = gv.Rows[j].Cells[i].Text + "<br><font color='red'><i>" + gv.Rows[j].Cells[gv.Columns.Count - 1].Text + "</i></font>";
                    //        }
                    //        catch { }
                    //    }
                    //}
                }

                
            }
            catch { }
        }
        protected void btnLoad_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect("ProductionStatus.aspx?PI=" + ddPI.SelectedValue);               
            }
            catch
            { }
        }

        protected void ddPI_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvDetailOutput.Columns.Clear();
            gvDetailOutput.Visible = false;
            ViewState["PI"] = ddPI.SelectedValue.ToString();
        }

        protected void cbDrawing_CheckedChanged(object sender, EventArgs e)
        {            
            ShowColumnsForSelectedCB();
        }

        private int CountCheckBox()
        {
            ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
            UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
            Control huu1 = huu.FindControl("ctl00");
            int result = 0;
            try
            {
                foreach (CheckBox cb in huu1.Controls.OfType<CheckBox>())
                {
                    if (cb.Checked) result += 1;
                }
            }
            catch { }
            return result;
        }



        private void ShowColumnsForSelectedCB()
        {
            try
            {
                //REMOVE WO
                List<string> DepartmentList = new List<string>() { "RM", "FM", "AS", "SA", "SP", "FIN", "FIT", "TU", "IRON", "UPH", "PAC", "OT", "WH" };
                ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("MainContent");
                UpdatePanel huu = (UpdatePanel)cph.FindControl("UpdatePanel1");
                Control huu1 = huu.FindControl("ctl00");
                
                if (gvDetailOutput.Columns.Count > 0)
                {

                    foreach (DataControlField cl in gvDetailOutput.Columns)
                    {
                        foreach (CheckBox cb in huu1.Controls.OfType<CheckBox>())
                        {
                            if (cl.HeaderText.Equals(cb.ID.Substring(2)))
                            {
                                cl.Visible = cb.Checked;
                            }
                        }

                        if (cl.HeaderText == "Image")
                        {
                            ((ImageField)cl).ControlStyle.Width = 100;
                            ((ImageField)cl).ControlStyle.Height = 63;
                        }
                        if (DepartmentList.IndexOf(cl.HeaderText) >= 0)
                        {
                            cl.Visible = cbProgress.Checked;
                        }
                    }
                }


                if (CountCheckBox() <= 3)
                {
                    huudiv.Attributes["class"] = "table-productionstatus";
                    if (gvDetailOutput.HeaderRow == null) return;
                    gvDetailOutput.HeaderRow.CssClass = "thead-blue";
                    foreach (TableCell cell in gvDetailOutput.HeaderRow.Cells)
                    {
                        cell.CssClass = "fixedheader bg-primary text-white";
                    }
                }
                else
                {
                    huudiv.Attributes["class"] = "table-responsive";
                    if (gvDetailOutput.HeaderRow == null) return;
                    gvDetailOutput.HeaderRow.CssClass = "";
                    foreach (TableCell cell in gvDetailOutput.HeaderRow.Cells)
                    {
                        cell.CssClass = "bg-primary text-white";
                    }
                }
            }
            catch { }
        }

        protected void cbProductionBOM_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }

        protected void cbTimberFinish_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }

        protected void cbMetalFinish_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }

        protected void cbProgress_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }

        protected void cbImage_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }

        protected void gvDetailOutput_DataBound(object sender, EventArgs e)
        {
            try
            {
                var grid = (GridView)sender;
                if (grid.Rows.Count == 0) return;

                // columns to merge when Code is the same
                int[] colsToMerge = { 2, 3, 4 }; // 0=Code, 3=Unit (edit to your needs)

                int i = 0;
                while (i < grid.Rows.Count)
                {
                    string key = GetCodeKey(grid, i);

                    // find the end (exclusive) of the group with the same Code
                    int j = i + 1;
                    while (j < grid.Rows.Count && string.Equals(key, GetCodeKey(grid, j), StringComparison.OrdinalIgnoreCase))
                        j++;

                    int span = j - i;
                    if (span > 1)
                    {
                        foreach (int colIndex in colsToMerge)
                        {
                            // set one rowspan on the first row of the group
                            grid.Rows[i].Cells[colIndex].RowSpan = span;

                            // hide all subsequent cells in the group
                            for (int k = i + 1; k < j; k++)
                                grid.Rows[k].Cells[colIndex].Visible = false;
                        }
                    }

                    i = j; // move to next group
                }
            }
            catch { }
            
        }

        private static string GetCodeKey(GridView grid, int rowIndex)
        {
            // Prefer DataKeys (safe with TemplateFields/HTML encoding)
            var dk = grid.Rows[rowIndex].Cells[3].Text?.Trim() ?? "";
            if (!string.IsNullOrEmpty(dk)) return dk;

            // Fallback: read the first cell text and HTML-decode it
            return HttpUtility.HtmlDecode(grid.Rows[rowIndex].Cells[0].Text)?.Trim() ?? "";
        }

        // Helper method to merge two cells vertically
        private static void MergeCells(GridViewRow top, GridViewRow bottom, int colIndex)
        {
            // if bottom cell already hidden by a previous merge, skip
            if (!bottom.Cells[colIndex].Visible) return;

            // increase rowspan on the top cell
            top.Cells[colIndex].RowSpan = (top.Cells[colIndex].RowSpan == 0)
                ? 2
                : top.Cells[colIndex].RowSpan + 1;

            // hide the bottom cell
            bottom.Cells[colIndex].Visible = false;
        }

        protected void cbProductInfo_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }

        protected void cbDefectHistory_CheckedChanged(object sender, EventArgs e)
        {
            ShowColumnsForSelectedCB();
        }
    }

    public class ImageFieldPlus : ImageField
    {
        // Persist across postbacks
        public string OnClientError
        {
            get => (string)(ViewState[nameof(OnClientError)] ?? string.Empty);
            set => ViewState[nameof(OnClientError)] = value;
        }

        public string OnClientClick
        {
            get => (string)(ViewState[nameof(OnClientClick)] ?? string.Empty);
            set => ViewState[nameof(OnClientClick)] = value;
        }
        public override void InitializeCell(DataControlFieldCell cell, DataControlCellType cellType, DataControlRowState rowState, int rowIndex)
        {
            base.InitializeCell(cell, cellType, rowState, rowIndex);

            if (cellType == DataControlCellType.DataCell)
            {
                cell.DataBinding += (sender, e) =>
                {
                    System.Web.UI.WebControls.Image image = cell.Controls[0] as System.Web.UI.WebControls.Image;
                    if (image != null && !string.IsNullOrEmpty(OnClientClick))
                    {
                        // Replace {0} token in script with resolved image URL
                        string imgUrl = image.ImageUrl ?? "";
                        var safeUrl = imgUrl.Replace("'", "\\'").Replace("~", "..");
                        string script = OnClientClick.Replace("{img}", safeUrl);

                        image.Attributes["onclick"] = script;
                        image.Style.Add("cursor", "pointer");
                    }
                };
            }
        }
        protected override void InitializeDataCell(DataControlFieldCell cell, DataControlRowState state)
        {
            base.InitializeDataCell(cell, state);

            if (cell.Controls.Count > 0 &&
                cell.Controls[0] is System.Web.UI.WebControls.Image img &&
                !string.IsNullOrEmpty(OnClientError))
            {
                img.Attributes["onerror"] = OnClientError;
            }
            
        }

        
    }


}
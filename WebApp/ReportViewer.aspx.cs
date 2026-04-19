using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;
using Microsoft.Reporting.WebForms;
using System.Data;

namespace WebApplication2
{
    public partial class ReportViewer : System.Web.UI.Page
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
                string template = "";
                List<string> dataset = new List<string>() { };
                List<DataTable> dt = new List<DataTable>();
                ReportParameter[] pr = null;
                string DisplayName = null;
                
                #region material request
                if (Request["type"] != null && Request["type"].ToString().Equals("mr"))
                {

                    template = "~/Report/materialrequest.rdlc";
                    dataset.Add("MaterialRequest");
                    string RequestNo = Request["id"].ToString();
                    string sql = "SELECT ItemNo, ItemName, format(Quantity,'#0.####') Quantity, PickQuantity, UOM ";
                    sql += ", (select format(isnull(sum([Remaining Quantity]), 0),'#0.##') from SquareRoots_90.dbo.[LIVE_ALLIANCE_90$Item Ledger Entry] ile where ile.[Item No_] = b.ItemNo collate SQL_Latin1_General_CP1_CI_AS) Inventory ";
                    sql += ", (select [Shelf No_] from SquareRoots_90.dbo.[LIVE_ALLIANCE_90$Item] it where it.No_=b.ItemNo collate SQL_Latin1_General_CP1_CI_AS) ShelfNo";
                    sql += ", (select ISNULL([Qty_ per Unit of Measure],1) from SquareRoots_90.dbo.[LIVE_ALLIANCE_90$Item Unit of Measure] u where u.[Item No_]= b.ItemNo collate SQL_Latin1_General_CP1_CI_AS and u.Code=b.UOM collate SQL_Latin1_General_CP1_CI_AS) QtyPerUOM";
                    sql += ", TransferOrderNo, TransferLineNo, RowIndex";
                    sql += " FROM [WH_RequestLine] b WHERE RequestHeaderNo = @RequestHeaderNo";
                    DataTable dt1 = SQRLibrary.ReturnDatatablefromSQL_mrp(sql, new List<string>() { "@RequestHeaderNo" }, new List<object>() { RequestNo });
                    dt.Add(dt1);

                    string sql1 = "select * from [WH_RequestHeader] where RequestHeaderNo = @RequestHeaderNo";                    
                    DataTable dt0 = SQRLibrary.ReturnDatatablefromSQL_mrp(sql1, new List<string>() { "@RequestHeaderNo" }, new List<object>() { RequestNo });

                    pr = new ReportParameter[] { 
                        new ReportParameter("RequestNo", RequestNo),
                        new ReportParameter("TransferNo", dt0.Rows[0]["TransferOrderNo"].ToString()),
                        new ReportParameter("Description", dt0.Rows[0]["Description"].ToString())

                    }; 

                    DisplayName = "MaterialRequest_" + RequestNo;

                }
                #endregion

                #region master plan
                if (Request["type"] != null && Request["type"].ToString().Equals("masterplan"))
                {
                    template = "~/Report/MasterPlan.rdlc";
                    dataset.Add("MasterPlan");
                    dt.Add(SQRLibrary.ReturnDatatablefromSQL("exec MasterPlan"));
                    DisplayName = "Master Plan";
                    Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Xem report master plan");
                }
                #endregion

                #region kaizen
                if (Request["type"] != null && Request["type"].ToString().Equals("kaizen"))
                {
                    template = "~/Report/kaizenlist.rdlc";
                    dataset.Add("KaizenList");
                    dt.Add((DataTable)Session["kaizendt"]);
                    DisplayName = "Kaizen List";

                    pr = new ReportParameter[] { 
                        new ReportParameter("FromDate", Session["kaizenfromdate"].ToString()),
                        new ReportParameter("ToDate", Session["kaizentodate"].ToString()),
                        new ReportParameter("Status", Session["kaizenstatus"].ToString()),
                        new ReportParameter("Paid", Session["kaizenpaid"].ToString()),
                        new ReportParameter("MonthYear", Session["kaizenmonthyear"].ToString())
                    }; 
                   
                    Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Xem report kaizen list");
                }

                #endregion

                #region kpiresult
                if (Request["type"] != null && Request["type"].ToString().Equals("kpiresult"))
                {
                    template = "~/Report/kpiresult.rdlc";
                    dataset.Add("Supervisor"); 
                    dataset.Add("Leader");
                    
                    dataset.Add("Worker");
                    dataset.Add("DataSet1");
                    //dataset.Add("Cleaner"); 
                    //dataset.Add("WHWorker");
                    //dataset.Add("QC");
                    dt.Add((DataTable)Session["KPISupervisor"]);
                    dt.Add((DataTable)Session["KPILeader"]);
                    dt.Add((DataTable)Session["KPIWorker"]);
                    dt.Add((DataTable)Session["KPITeamLeader"]);
                    //dt.Add((DataTable)Session["KPIWHWorker"]);
                    //dt.Add((DataTable)Session["KPIQC"]);

                    DisplayName = "KPI RESULT";

                    pr = new ReportParameter[] { 
                        new ReportParameter("Month_Supervisor", Session["Month_Supervisor"].ToString()??""),
                        new ReportParameter("Month_Leader", Session["Month_Leader"].ToString()??""),
                        new ReportParameter("Month_Worker", Session["Month_Worker"].ToString()??""),
                        new ReportParameter("Month_TeamLeader", Session["Month_TeamLeader"].ToString()??"")
                       
                    };

                    Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Xem report kpi result list");
                }
                #endregion

                #region Production Order
                if (Request["type"] != null && Request["type"].ToString().Equals("prodorder"))
                {
                    template = "~/Report/ProdOrder.rdlc";
                    dataset.Add("ProductionOrderList"); dataset.Add("PINote");
                    string PI = Request["PI"] == null ? "kkk" : Request["PI"].ToString();
                    pr = new ReportParameter[] { new ReportParameter("PI", PI) }; 
                    
                    dt.Add(SQRLibrary.ReturnDatatablefromSQL("Report_LSX '" + PI + "', 1"));
                    dt.Add(SQRLibrary.ReturnDatatablefromSQL_mrp("SELECT [PINo], [UpdateUser],[UpdateOn], [Note] FROM [POR_PINote] where PINo = '" + PI + "'"));
                    DisplayName = "ProductionOrder_" + PI;

                }
                #endregion

                #region ProductionBOM
                if (Request["type"] != null && Request["type"].ToString().Equals("ProductionBOM"))
                {
                    try
                    {
                        template = "~/Report/ProductionBOM.rdlc";
                        dataset.Add("BOMLineTotal"); dataset.Add("BOMLineDetail");
                        string BOMCode = Request["BOMCode"] == null ? "kkk" : Request["BOMCode"].ToString();
                        string dept = Request["dept"] == null ? "All" : Request["dept"].ToString();

                        string BOMStatus = SQRLibrary.ReturnDatatablefromSQL("select Status from [LIVE_ALLIANCE_90$Production BOM Header] where No_='" + BOMCode + "'").Rows[0][0].ToString();
                        Item item = new Item(BOMCode.Substring(0, BOMCode.Length - 2));

                        pr = new ReportParameter[] 
                        {
                            new ReportParameter("ItemCode", BOMCode.Substring(0, BOMCode.Length - 3)), 
                            new ReportParameter("ItemName", item.Name), 
                            new ReportParameter("TimberFinish", item.TimberFinish),
                            new ReportParameter("LegsFinish", item.LegsFinish),
                            new ReportParameter("Length", item.Length),
                            new ReportParameter("Width", item.Width),
                            new ReportParameter("Height", item.Height),
                            new ReportParameter("ProductionBOM", BOMCode),
                            new ReportParameter("BOMStatus", BOMStatus.Equals("1")? "BOM đã được duyệt": "BOM chưa được duyệt"),
                            new ReportParameter("dept", dept)
                        };

                        dt.Add(Library.LibraryFunction.GetBOMLine(BOMCode, dept));
                        dt.Add(Library.LibraryFunction.GetBOMLine(BOMCode, true, dept));
                        DisplayName = item.Code + " - " + item.Name + " - " + item.TimberFinish + " - " + item.LegsFinish + " (" + item.ProductionBOM + "_" + dept + ")";
                        Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Xem BOM " + BOMCode + " " + Request.Browser.Type + " " + Request.Browser.IsMobileDevice.ToString());
                    }
                    catch { }
                }
                #endregion

                #region BBCL
                if (Request["type"] != null && Request["type"].ToString().Equals("bbcl"))
                {
                    try
                    {
                        template = "~/Report/bbcl.rdlc";
                        dataset.Add("BBCL_InchargePeople"); dataset.Add("BBCL_Approver");
                        string ReportID = Request["id"] == null ? "kkk" : Request["id"].ToString();

                        DataTable DefectHeader = SQRLibrary.ReturnDatatablefromSQL_mrp("select *, format(DefectiveDate,'dd-MM-yyyy') [Date], format(RequiredDate,'dd-MM-yyyy') [RequiredDate1] from [QC_QualityReportHeader] where ReportID=@ReportID"
                    , new List<string>() { "@ReportID" }, new List<object>() { ReportID });

                        if (DefectHeader.Rows.Count > 0)
                        {
                            DataRow r = DefectHeader.Rows[0];
                            string status = "";                            
                            switch (r["Status"].ToString())
                            {
                                case "0": status = "Open"; break;
                                case "1": status = "Approved"; break;
                                case "2": status = "Pending"; break;
                                case "3": status = "Rejected"; break;
                                case "4": status = "Completed"; break;
                                case "99": status = "Cancelled"; break;
                            }

                            pr = new ReportParameter[] 
                            {
                            new ReportParameter("Date", r["Date"].ToString()), 
                            new ReportParameter("PI", r["PINo"].ToString()), 
                            new ReportParameter("ProductName", r["ProductName"].ToString()),
                            new ReportParameter("RequiredDate", r["RequiredDate1"].ToString()),
                            new ReportParameter("DefectAt", r["DefectAtDepartmentName"].ToString()),
                            new ReportParameter("DefectRate", r["DefectQuantity"].ToString() + "/" + r["TotalQuantity"].ToString()),
                            new ReportParameter("ReportID",Request["id"].ToString()),
                            new ReportParameter("DefectDescription", r["DefectDescription"].ToString()),
                            new ReportParameter("DefectReason", r["DefectReason"].ToString()),
                            new ReportParameter("DefectAction", r["DefectAction"].ToString()),
                            new ReportParameter("cbWO", r["WO"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbRM", r["RM"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbFM", r["FM"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbAS", r["AS"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbSA", r["SA"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbFIN", r["FIN"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbIRON", r["IRON"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbUPH", r["UPH"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbFIT", r["FIT"].ToString().Length >= 1 ? "true" : "false"),
                            new ReportParameter("cbPAC", r["PAC"].ToString().Length >= 1 ? "true" : "false")
                            };

                            DataTable dt1 = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_DefectiveList] where ReportID=@ReportID", new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                            DataTable dt2 = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from [QC_ApprovalEntry] where DocumentNo=@ReportID", new List<string>() { "@ReportID" }, new List<object>() { Request["id"].ToString() });
                            dt.Add(dt1);
                            dt.Add(dt2);
                            DisplayName = "Quality report " + ReportID + " " + r["PINo"].ToString();
                            Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Xem BBCL " + ReportID + " " + Request.Browser.Type + " " + Request.Browser.IsMobileDevice.ToString());
                        }
                        
                    }
                    catch { }
                }
                #endregion
                
                #region BundleCode
                if (Request["type"] != null && Request["type"].ToString().Equals("timberbundle"))
                {
                    template = "~/Report/timberbundle.rdlc";
                    dataset.Add("PINote");
                    dt.Add(new DataTable());
                    string bundlecode = Request["no"].ToString(); 
                    
                    DataTable bundle = SQRLibrary.ReturnDatatablefromSQL_mrp("select * from TIMBER_Bundle b INNER JOIN TIMBER_ContainerLabel c on c.Code= b.ContainerCode where b.BundleCode = @BundleCode"
                        , new List<string>() { "@BundleCode" }, new List<object>() { bundlecode});

                    DataRow r = bundle.Rows[0];
                    DateTime d = Convert.ToDateTime(r["Receipt Date"].ToString(), System.Globalization.CultureInfo.CurrentUICulture);
                    pr = new ReportParameter[] { 
                        new ReportParameter("Supplier", r["Supplier"].ToString()) ,
                        new ReportParameter("Grade", "") ,
                        new ReportParameter("Length",  r["TC3"].ToString()) ,
                        new ReportParameter("Thickness",  r["TC1"].ToString()) ,
                        new ReportParameter("Width",  r["TC2"].ToString()) ,
                        new ReportParameter("PCS",  r["IntQuantity"].ToString()) ,
                        new ReportParameter("M3", SQRLibrary.ConvertToDouble(r["CubicQuantity"]).ToString("#0.#####")) ,
                        new ReportParameter("Density", "") ,
                        new ReportParameter("ArrivalDate",  d.ToString("dd-MM-yyyy")) ,
                        new ReportParameter("ContainerNo",  r["ContainerCode"].ToString()) ,
                        new ReportParameter("BundleNo",  r["BundleCode"].ToString()) ,
                        new ReportParameter("Weight", "") ,
                        new ReportParameter("Remark", "") ,
                        new ReportParameter("Moisture", "")
                        

                    };
                    
                    DisplayName = "TIMBER RECORD " + bundlecode;

                }
                #endregion

                ReportViewer1.LocalReport.EnableExternalImages = true;
                ReportViewer1.LocalReport.EnableHyperlinks = true;
                ReportViewer1.ProcessingMode = ProcessingMode.Local;
                ReportViewer1.LocalReport.ReportPath = Server.MapPath(template);
                if (pr != null) ReportViewer1.LocalReport.SetParameters(pr);
                if (DisplayName != null) ReportViewer1.LocalReport.DisplayName = DisplayName;
                ReportViewer1.LocalReport.DataSources.Clear();
                              

                for (int i = 0; i < dataset.Count; i++)
                {                    
                    ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource(dataset[i], dt[i]));
                }  

            }
        }
       
    }
}
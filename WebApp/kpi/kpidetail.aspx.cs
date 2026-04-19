using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;

namespace WebApplication2.kpi
{
    public partial class kpidetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                DataTable data = new DataTable();
                switch (Request["connection"].ToString())
                {
                    case "hr":
                        data = SQRLibrary.ReturnDatatablefromSQL_hr("exec POR_CheckDetailKPIResult @type, @criterion, @from, @to, @object"
                            , new List<string>() { "@type", "@criterion", "@from", "@to", "@object" }
                            , new List<object>() { Request["type"].ToString(), Request["criterion"].ToString(), Request["from"].ToString(), Request["to"].ToString(), Request["object"].ToString() });
                        break;
                    case "mrp":
                        data = SQRLibrary.ReturnDatatablefromSQL_mrp("exec POR_CheckDetailKPIResult @type, @criterion, @from, @to, @object"
                            , new List<string>() { "@type", "@criterion", "@from", "@to", "@object" }
                            , new List<object>() { Request["type"].ToString(), Request["criterion"].ToString(), Request["from"].ToString(), Request["to"].ToString(), Request["object"].ToString() });
                        break;
                }

                Library.LibraryFunction.LoadDataTableToGridView(gvDetailKPIResult, data);
            }
            catch { }
        }
    }
}
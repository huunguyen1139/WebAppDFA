using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Data;
using System.Web.SessionState;
using SQRFunctionLibrary;
namespace WebApplication2
{
    /// <summary>
    /// Summary description for GetPIList
    /// </summary>
    public class GetPIList : IHttpHandler, IRequiresSessionState 
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string term = context.Request["term"] ?? "";
                List<string> result = new List<string>();

                //DataTable PIList = (DataTable)context.Session["PIList"];
                //DataView piview = new DataView(PIList);
                //piview.RowFilter = "[PI] like '*" + term + "*'";

                //string sql = "select distinct top 10 [Description 2] as [PI] from [LIVE_ALLIANCE_90$Production Order] where [Description 2] like  @PINo + '%' AND [Status] in ('3') AND LEN([Description 2])<10  ORDER BY [Description 2] desc";
                //DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql, new List<string>() { "@PINo" }, new List<object>() { term });
                
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC ALL_OUTPUT_Search_ProductionOrder_OrPI @text"
                    , new List<string>() { "@text" }
                    , new List<object>() { term });

                if (dt != null && dt.Rows.Count > 0)
                {
                    string temp = "";
                    foreach (DataRow r in dt.Rows)
                    { 
                        temp = r["Source"].ToString() == "PI" ? r["PI"].ToString() : r["No_"].ToString();
                        result.Add(temp);
                    }
                }    


                //for (int i = 0; i < Math.Min(piview.ToTable().Rows.Count, 10); i++)
                //{
                //    result.Add(piview.ToTable().Rows[i]["PI"].ToString());
                //}

                JavaScriptSerializer js = new JavaScriptSerializer();
                context.Response.Write(js.Serialize(result));
            }
            catch { }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
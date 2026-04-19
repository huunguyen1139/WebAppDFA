using SQRFunctionLibrary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace WebApp
{
    /// <summary>
    /// Summary description for GetCRList
    /// </summary>
    public class GetCRList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string term = context.Request["term"] ?? "";
                List<string> result = new List<string>();                

                DataTable dt = SQRLibrary.ReturnDatatablefromSQL("EXEC ALL_OUTPUT_Search_ProdChangeRequest_OrPI @text"
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
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SQRFunctionLibrary;

namespace WebApplication2
{
    public partial class DrawingReader : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string InchargeDept = "Kỹ thuật";
                try
                {

                    if (Request["code"] != null && Request["version"] != null)
                    {
                        if (Request["code"].ToString().Length == 10) InchargeDept = "R&D";
                        Library.LibraryFunction.InsertActivitiesLog(Session["userid"].ToString(), "Mở bản vẽ " + Request["code"].ToString() + " - " + Request["version"].ToString() + Request.Browser.Type + " " + Request.Browser.IsMobileDevice.ToString());

                        //string drawingpath = Library.LibraryFunction.GetFile(Request["code"].ToString(), Request["version"].ToString())[0];
                        string drawingpath = "";
                        string sql = "select * from [LIVE_ALLIANCE_90$Drawing Code] WHERE [Drawing Code] = @code and [Version Code] = @version";
                        DataTable dt = SQRLibrary.ReturnDatatablefromSQL(sql
                            , new List<string>() { "@code", "@version" }
                            , new List<object>() { Request["code"].ToString(), Request["version"].ToString() });

                        if (dt.Rows.Count < 0) return;
                        string[] FilePath = new string[2];

                       
                        drawingpath = dt.Rows[0]["FilePath"].ToString();
                        drawingpath = drawingpath.Replace(@"\\192.168.1.244\alliance_new\ERP\DRAWING", "drawing");
                        
                        Response.Redirect(drawingpath);
                        
                    }
                }
                catch { Response.Write("<h3>Không tìm thấy bản vẽ <font color='red'> '" + Request["code"].ToString() + "*" + Request["version"].ToString() + "'</font>. Liên hệ với BP " + InchargeDept + " để kiểm tra!</h3>"); }

            }
        }

    }
}
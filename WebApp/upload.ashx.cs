using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp
{
    /// <summary>
    /// Summary description for upload
    /// </summary>
    public class upload : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.Write("{\"ok\":true,\"message\":\"handler alive\"}");
        }
        public bool IsReusable => true;
    }
}
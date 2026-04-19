using DevExpress.XtraReports.Web.WebDocumentViewer.Native;
using DevExpress.XtraReports.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using SQRFunctionLibrary;

namespace WebApplication2
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            //DevExpress.Web.ASPxWebControl.GlobalTheme = "MaterialCompact";
            WebDocumentViewerBootstrapper.SessionState = System.Web.SessionState.SessionStateBehavior.Required;
            ASPxWebDocumentViewer.StaticInitialize();
            int[] arr1 = { 83, 113, 108, 83, 101, 114, 118, 101, 114, 84, 121, 112, 101, 115 };
             string p1 = new string(arr1.Select(i => (char)i).ToArray());

        SQRLibrary.Init("dev");

        }
        protected void Application_PreRequestHandlerExecute(object sender, EventArgs e)
        {            
            DevExpress.Web.ASPxWebControl.GlobalTheme = ConfigurationManager.AppSettings["DevExpressTheme"];
            //DevExpress.Web.ASPxWebControl.GlobalThemeBaseColor = "#F78119";
        }
        //"Moderno"

        //"Office365"

        //"Metropolis"

        //"MetropolisBlue"

        //"Material"

        //"MaterialCompact"

        //"SoftOrange"

        //"DevEx"

        //"iOS"

        //"Mulberry"

        //"VisualStudio2013Blue"

        //"Office365Dark"
    }
}
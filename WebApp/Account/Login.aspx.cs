using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using WebApplication2.Models;
using SQRFunctionLibrary;
using System.Data;
using Library;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace WebApplication2.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userid"] != null)
            {               
                if (Request.QueryString["ReturnUrl"] != null)                   
                {
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    //Response.Redirect(Request.QueryString["ReturnUrl"].Replace('|', '?'));
                    Response.Redirect(Server.UrlDecode(returnUrl));
                }
                else Response.Redirect("~/default.aspx");
            }
            if (!IsPostBack)
            {                
                HttpCookie getCookie = Request.Cookies.Get("myCookie");
                if (getCookie != null)
                {
                    string userName = getCookie.Values["UserName"].ToString();
                    string password = getCookie.Values["Password"].ToString();

                    txtUserName.Attributes["value"] = userName;
                    txtPassword.Attributes["value"] = password;
                }
            }
        }

        private void SetCookie()
        {
            HttpCookie myCookie = new HttpCookie("myCookie");
            myCookie.Values.Add("UserName", txtUserName.Attributes["value"].ToString());
            myCookie.Values.Add("Password", txtPassword.Attributes["value"].ToString());
            DateTime dtxpiry = DateTime.Now.AddDays(15);
            myCookie.Expires = dtxpiry;
            Response.Cookies.Set(myCookie);
        }

        private void SetSession(object userid, object username, object departmentindex, object userrole)
        {
            Session["userid"] = null;
            Session["username"] = null;
            Session["userrole"] = null;
            Session["departmentindex"] = null;
            Session["userid"] = userid;
            Session["username"] = username;
            Session["userrole"] = userrole;
            Session["departmentindex"] = departmentindex;
            Session.Timeout = 60;
        }

        private void RedirectURL()
        {
            if (Request["ReturnUrl"] != null)
            {
                Response.Redirect(Request["ReturnUrl"].ToString().Replace('|', '?'));
            }
            else Response.Redirect("~/default.aspx");
        }
        protected void LogIn(object sender, EventArgs e)
        {
          
            txtErrorMessage.Visible = false;
            if (IsValid)
            {
                DataTable dt = Library.LibraryFunction.ValidateLogin(txtUserName.Attributes["value"]);

                if (dt != null && dt.Rows.Count > 0)
                {                    
                        SetSession(txtUserName.Attributes["value"], dt.Rows[0]["EmployeeName"], dt.Rows[0]["DepartmentIndex"], dt.Rows[0]["Role"]);
                        
                        SQRLibrary.ExecuteSQL_mrp("InsertUserLoginHistory '" + Session["userid"].ToString() + "','',N'" + Session["username"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'");
                        
                        RedirectURL();
                        return;
                }
                else
                {
                    txtErrorMessage.InnerHtml = "User does not exists!";
                    txtErrorMessage.Visible = true;
                    return;
                }
            }
        }
        
    }
}
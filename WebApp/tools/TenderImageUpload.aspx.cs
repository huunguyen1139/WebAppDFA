using DevExpress.Web.Internal.Dialogs;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SQRFunctionLibrary;
using DevExpress.XtraRichEdit.Model;

using DevExpress.RichEdit.Export;

namespace WebApp.tools
{
    public partial class TenderImageUpload : SecurePage
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
                LoadTenderOrderNumbers();
            }
        }
        private void LoadTenderOrderNumbers()
        {
            try
            {
                string query = "select No_ from [LIVE_ALLIANCE_90$Sales Header] where [Document Type]=6 and No_ <> 'TENDER_TEMPLATE'";
                DataTable dt = SQRLibrary.ReturnDatatablefromSQL(query);
                ddlTenderOrder.DataSource = dt;
                ddlTenderOrder.DataValueField = "No_";
                ddlTenderOrder.DataTextField = "No_";
                ddlTenderOrder.DataBind();
                ddlTenderOrder.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select --", ""));
            }

            catch { }
        }

        public class FilesUploaded
        {
            public FilesUploaded(string _DocumentNo, string _filName)
            {
                DocumentNo = _DocumentNo;
                FileName = _filName;
            }
            string DocumentNo { get; set; }
            string FileName { get; set; }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            List<FilesUploaded> filesUploadeds = new List<FilesUploaded>() { };
            string a = Session["TenderOrderNo"].ToString();
            if (string.IsNullOrEmpty(a))
            {
                // Optionally show a client-side alert or message
                uploadControl.JSProperties["cpError"] = "Please select a Tender Order No.";
                ClientScript.RegisterStartupScript(GetType(), "alert", "Alert2('Please select a Tender Order No.','error');", true);
                return;
            }            
            
                // After all uploads, insert file details into database in one connection
                List<string> sqlValues = new List<string>();
            var fileDetails = Session["UploadedFiles"] as List<(string DocumentNo, string FileName, string FilePath)>;
            if (fileDetails != null && fileDetails.Count > 0)
            {
                foreach (var k in fileDetails)
                {
                    string sqlRow = $"('{k.DocumentNo.Replace("'", "''")}', '{k.FileName.Replace("'", "''")}', '{k.FilePath.Replace("'", "''")}')";
                    sqlValues.Add(sqlRow);
                    filesUploadeds.Add(new FilesUploaded(k.DocumentNo, k.FileName));
                }

                if (sqlValues.Count > 0)
                {
                    string insertSQL = $@"
                    INSERT INTO Custom_ImageLinkData ( DocumentNo, FileName, FilePath)
                    VALUES {string.Join(",", sqlValues)}";

                    SQRLibrary.ExecuteSQL(insertSQL);

                    gridUploadedFile.Visible = true;
                    gridUploadedFile.DataSource = filesUploadeds;
                    gridUploadedFile.DataBind();
                    ClientScript.RegisterStartupScript(GetType(), "success", "Alert2('Files uploaded successfully.','success');", true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(GetType(), "fail", "Alert2('No valid files were uploaded. Ensure file names start with the selected Tender Order No.','error');", true);
                }
                Session["UploadedFiles"] = null;
               
            }

            
            
            
        }

        protected void uploadControl_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            if (e.IsValid)
            {
                
                string tenderOrderNo = Session["TenderOrderNo"] as string;

                if (string.IsNullOrEmpty(tenderOrderNo))
                {
                    e.CallbackData = $"Please select a Tender Order No";
                    ClientScript.RegisterStartupScript(GetType(), "alert", "Alert2('Please select a Tender Order No.','error');", true);
                    return;
                }

                string fileName = e.UploadedFile.FileName;
                if (!fileName.StartsWith(tenderOrderNo.Substring(0, 7), StringComparison.OrdinalIgnoreCase))
                {
                    e.CallbackData = $"File name must start with '{tenderOrderNo}'.";
                    return;
                }

                string directoryPath = $@"D:\ALLIANCE_NEW\ERP\IMAGES\TENDER\{tenderOrderNo}";
                string filePath = Path.Combine(directoryPath, fileName);
                try
                {
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }

                    e.UploadedFile.SaveAs(filePath);

                    // Store file details in session for batch insert
                    var fileDetails = Session["UploadedFiles"] as List<(string DocumentNo, string FileName, string FilePath)> ?? new List<(string, string, string)>();
                    string documentNo = fileName.Length >= 12 ? fileName.Substring(0, 12) : fileName;
                    fileDetails.Add((documentNo, fileName, filePath));
                    Session["UploadedFiles"] = fileDetails;

                    e.CallbackData = "File uploaded successfully.";
                }
                catch (Exception ex)
                {
                    e.CallbackData = $"Error uploading file: {ex.Message}";
                }
            }
            else
            {
                e.CallbackData = "Invalid file format or size.";
            }
        }

        protected void ddlTenderOrder_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                Session["TenderOrderNo"] = ddlTenderOrder.SelectedValue;
                
                DataTable filesUploadeds = SQRLibrary.ReturnDatatablefromSQL("SELECT * FROM Custom_ImageLinkData WHERE DocumentNo = @DocumentNo"
                    , new List<string>() { "@DocumentNo" }
                    , new List<object>() { ddlTenderOrder.SelectedValue });
                gridUploadedFile.Visible = true;
                gridUploadedFile.DataSource = filesUploadeds;
                gridUploadedFile.DataBind();
            }
            catch { }
        }

        protected void uploadControl_FilesUploadComplete(object sender, FilesUploadCompleteEventArgs e)
        {
            try
            {
                if (uploadControl.UploadedFiles.Length > 1000)
                {
                    e.CallbackData = $"error|The maximum number of images upload at the one time is 1000";
                    e.ErrorText = $"The maximum number of images upload at the one time is 1000";
                    return;
                }

                string tenderOrderNo = Session["TenderOrderNo"] as string;
                if (string.IsNullOrEmpty(tenderOrderNo))
                {
                    e.CallbackData = $"error|Please select a Tender Order No";                   
                    e.ErrorText = $"Please select a Tender Order No";                    
                    return;
                }

                string directoryPath = $@"D:\ALLIANCE_NEW\ERP\IMAGE\TENDER\{tenderOrderNo.Substring(0,7)}";
                if (!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(directoryPath);
                }

                var fileDetails = new List<(string DocumentNo, string ItemNo, string FileName, string FilePath)>();
                //tenderOrderNo = tenderOrderNo.Substring(0, 7);
                foreach (UploadedFile file in uploadControl.UploadedFiles)
                {
                    string fileName = file.FileName;
                   
                    if (!fileName.StartsWith(tenderOrderNo.Substring(0, 7), StringComparison.OrdinalIgnoreCase))
                    {
                        e.CallbackData = $"error|File name must start with '{tenderOrderNo}'.";
                        return;
                    }
                    string filePath = Path.Combine(directoryPath, fileName);
                    file.SaveAs(filePath);
                                        
                    //string documentNo = Session["TenderOrderNo"] as string;
                    string ItemNo = fileName.Length >= 12 ? fileName.Substring(0, 12) : fileName;
                    fileDetails.Add((tenderOrderNo, ItemNo, fileName, filePath));
                   
                }

                List<string> sqlValues = new List<string>();
                
                
                
                if (fileDetails != null && fileDetails.Count > 0)
                {
                    foreach (var k in fileDetails)
                    {
                        string sqlRow = $"EXEC ALL_INSERT_TENDER_IMAGE_HISTORY '{k.DocumentNo.Replace("'", "''")}', '{k.ItemNo.Replace("'", "''")}', '{k.FileName.Replace("'", "''")}', '{k.FilePath.Replace("'", "''")}'";
                        sqlValues.Add(sqlRow);                        
                    }

                    if (sqlValues.Count > 0)
                    {
                        string insertSQL = $@"{string.Join(";", sqlValues)}";

                        SQRLibrary.ExecuteSQL(insertSQL);

                        //    DataTable filesUploadeds = SQRLibrary.ReturnDatatablefromSQL("SELECT * FROM Custom_ImageLinkData WHERE DocumentNo = @DocumentNo"
                        //, new List<string>() { "@DocumentNo" }
                        //, new List<object>() { tenderOrderNo });
                        //    gridUploadedFile.Visible = true;
                        //    gridUploadedFile.DataSource = filesUploadeds;
                        //    gridUploadedFile.DataBind();
                        ddlTenderOrder_SelectedIndexChanged(null, null);
                        e.CallbackData = $"success|{sqlValues.Count.ToString()} files uploaded successfully.";

                    }
                    else
                    {
                        e.CallbackData = "error|No valid files were uploaded. Ensure file names start with the selected Tender Order No.";                        
                    }                   

                }

            }
            catch (Exception ex) { e.CallbackData = $"error|Error. {ex.Message}"; }
        }
    }
}


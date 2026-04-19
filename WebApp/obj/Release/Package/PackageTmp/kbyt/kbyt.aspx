<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="kbyt.aspx.cs" Inherits="WebApplication2.kbyt.kbyt" %>

<!DOCTYPE html>

<html lang="vi">
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Hệ thống thông tin quản lý Khai báo Y tế</title>
  
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link rel="preload" href="style.css" as="style">
<link rel="preload" href="all.min.css" as="style">
<link type="text/css" rel="stylesheet" href="style.css">
<link rel="stylesheet" type="text/css" href="all.min.css"> 
<link rel="stylesheet" type="text/css" href="jquery-ui.css">
     <script type="text/javascript">

         Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
         function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
 
    
</head>

<body style="padding: 0px;margin: 0px;background-color: rgb(234, 234, 234);">
  


<form runat="server" id="form11">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Scripts>
                <%--To learn more about bundling scripts in ScriptManager see http://go.microsoft.com/fwlink/?LinkID=301884 --%>
                <%--Framework Scripts--%>

                <%--Site Scripts--%>
            </Scripts>
        </asp:ScriptManager>
    <script type="text/javascript">
        function selectAndCopyElementContents(el) {
            var body = document.body,
              range, sel;
            if (document.createRange && window.getSelection) {
                range = document.createRange();
                sel = window.getSelection();
                sel.removeAllRanges();
                try {
                    range.selectNodeContents(el);
                    sel.addRange(range);
                } catch (e) {
                    range.selectNode(el);
                    sel.addRange(range);
                }
            } else if (body.createTextRange) {
                range = body.createTextRange();
                range.moveToElementText(el);
                range.select();
            }
            document.execCommand("Copy");
            ShowPopup('POR System', 'Copied to Clipboard');
        }
    </script>
<asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
 
<div id="whole-page">    
<div id="page-header"></div> <div id="page-content"><div id="module6" class="ModuleWrapper"><div class="home-space"><div id="column1-6" class="column1 container ">
  <div class="foverlay"></div>  <div class="columns-widget row">  <div class="col-md-12 col-xs-12 col-sm-12">
     
       
      <div id="module9" class="ModuleWrapper">
          <div class="passenger-wrapper">
              
<h1 class="text-center mtb-20">Tờ khai y tế - SquareRoots</h1>


   <div class="tab-content" runat="server" style="background: white; padding: 10px; border-left: 1px solid #ddd; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd;">
        <div id="divMessage" runat="server" class="alert alert-danger" role="alert">
            <span id="lbErrorDescription" runat="server">ggg</span>
        </div>
        <div class="row">
            <div class="col-md-4 col-sm-4  col-xs-12 ">
                <div class="form-group label-width ">
                    <label>Từ ngày</label>
                    <asp:TextBox runat="server" ID="txtFromDate" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-4 col-sm-4  col-xs-12 ">
                <div class="form-group label-width">
                    <label>Đến ngày</label>
                    <asp:TextBox runat="server" ID="txtToDate" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-4 col-sm-4  col-xs-12 ">
                <div class="btn-submit-box text-center" style="margin-top: 20px;">
                    <asp:Button runat="server" ID="btnLogin" CssClass="btn btn-success" OnClick="btnLogin_Click" Text="Load"/>
                    <asp:Button runat="server" ID="btnLoadChuaKhaiBao" CssClass="btn btn-success" OnClick="btnLoadChuaKhaiBao_Click" Text="Chưa khai báo"/>
                </div>
            </div>

        </div>

    </div>
<ul class="nav nav-tabs">  
</ul>
<div class="tab-content" runat="server" id="divContent" style="background: white;padding: 10px;border-left: 1px solid #ddd;border-right: 1px solid #ddd;border-bottom: 1px solid #ddd;">
    <div class="table-responsive" style="white-space: nowrap;"><asp:GridView runat="server" CssClass="table table-hover table-striped" ID="gvResult" EmptyDataText="No records found"></asp:GridView></div>
    <asp:Button CssClass="btn btn-warning" Style="margin-bottom: 10px" runat="server" ID="btnCopy" Text ="Copy to Clipboard" OnClientClick="selectAndCopyElementContents(document.getElementById('gvResult'));"/>
</div>



</div>
  

  
<style>
.passenger-wrapper .alert-box {
color: red;
font-size: 14px;
padding: 20px;
}
.hotline-footer9 a{
color: white;
display: inline-flex;
align-items: center;
background: #F2651C;
border-radius: 30px;
padding-right: 10px;
font-weight: bold;
font-size: 24px;
line-height: 1;
}
.passenger-wrapper .nav-tabs .tab-login-home a {
background: #ff5f5f;
color: #FFFFFF;
border-color: #ff5f5f;
}
.passenger-wrapper .nav-tabs .tab-login-home a:hover {
background: #ff3e3e;
color: #FFFFFF;
border-color: #ff3e3e;
}
.hotline-footer9{
position: fixed;
bottom:5px;
left: 5px;
z-index: 999;
}
.hotline-footer9 .totalNewNotification{
position: relative;
display: inline-block;
}
.hotline-footer9 .totalNewNotification span{
position: absolute;
top: 0;
background: red;
color: #fff;
right: -5px;
padding: 1px 5px;
font-weight: bold;
display: inline-block;
border-radius: 999px;
}
.hotline-box p {
margin: 0;
}
.hotline-box a {
color: #015ab4;
}
.download-app9{
position: fixed;
bottom: 125px;
right: 10px;
background-color: #fff;
border-radius: 999px;
border: 1px solid #ccc;
box-shadow: 0 0 5px rgba(0,0,0,0.4);
padding: 5px;
z-index: 1000;
}
.download-app9 .btn-ch-play{
padding: 5px;
}
#module9 .nav-tabs {
text-align: center;
display: -webkit-flex;
display: flex;
background-color: #eaeaea;
}
#module9 .nav-tabs li{
float: none;
display: inline-block;
flex: 1;
-webkit-flex: 1;
}
#module9 .nav-tabs li>a{
margin-right: 0 !important;
}
#module9{
padding-bottom: 100px;
}
.passenger-wrapper .tab-login-home > a{
height: 62px;
line-height: 42px;
}
@media (max-width: 768px) {
.download-app9 {
/*bottom: 5px;
left: auto;
right: 5px;*/
}
}
@media (max-width: 480px) {
.hotline-footer9 a{
padding-right: 0;
}
.hotline-footer9 a span{
display: none;
}
.passenger-wrapper h1.text-center{
font-size: 28px;
}
}
@media screen and (max-width: 992px) {
.passenger-wrapper .tab-login-home{
display: none!important;
}
}
.passenger-wrapper .box-edit-layout .form-group:not(.group-input-inline) .select2-container.select2-container--default{
/*width: auto !important;
min-width: 240px;*/
}
@media(max-width: 768px){
.passenger-wrapper .box-edit-layout .form-group:not(.group-input-inline) .select2-container.select2-container--default{
min-width: 176px;
}
}
@media (max-width: 768px) {
.label-width.form-inline input.form-control {
max-width: 100% !important;
width: 100% !important;
}
}
@media (max-width: 1024px) {
.box-edit-layout{
overflow: hidden;
}
}
</style>

</div></div>  </div></div></div>
</div></div> <div id="page-footer"></div></div>


 <style type="text/css">.input-group-btn ul li{float:left;padding:2px;} .cropit-preview-image{max-width: inherit;}</style>
 
             </ContentTemplate>
    </asp:UpdatePanel>
        <style>
            .modal1 {
                position: fixed;
                z-index: 999;
                height: 100%;
                width: 100%;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: Black;
                filter: alpha(opacity=60);
                opacity: 0.4;
                -moz-opacity: 0.8;
            }

            .center1 {
                z-index: 1000;
                margin: 200px auto;
                padding: 5px;
                width: 140px;
                background-color: White;
                border-radius: 10px;
                filter: alpha(opacity=100);
                opacity: 1;
                -moz-opacity: 1;
            }

                .center1 img {
                    height: 128px;
                    width: 128px;
                }
        </style>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</form>
</body></html>

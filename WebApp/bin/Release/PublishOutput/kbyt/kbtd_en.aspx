<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="kbtd_en.aspx.cs" Inherits="WebApplication2.kbyt.kbtd_en" %>

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
 
    <link href="select2.min.css" rel="stylesheet" />
    <script src="../dist/js/select2.min.js"></script>
    <script>
        function pageLoad(sender, args) { $("#ddTinhThanh").select2(); $("#ddMaNhanVien").select2(); $("#<%= ddQuanHuyen.ClientID %>").select2(); $("#<%= ddPhuongXa.ClientID %>").select2(); };
    </script>
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
<asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
 
<div id="whole-page">    
<div id="page-header"></div> <div id="page-content"><div id="module6" class="ModuleWrapper"><div class="home-space"><div id="column1-6" class="column1 container ">
  <div class="foverlay"></div>  <div class="columns-widget row">  <div class="col-md-12 col-xs-12 col-sm-12">
     
       
      <div id="module9" class="ModuleWrapper">
          <div class="passenger-wrapper">

        <div class="formWrapper formWrapper-mobile mt-20">
            <div class="lang-lbl lang-lbl-desktop text-bold mb-15 pr-20">Chọn ngôn ngữ để khai báo y tế&nbsp;/Select the language to declare health:</div>
            <div class="list-lang">
                <div class="sendType-option inline-block">
                    <label style="font-weight: 100; width: auto; display: inline-block;">
                       
                        <a href="kbtd.aspx"><img alt="" src="vi.jpg" width="70" height="50"></a></label>
                    <label style="font-weight: 100; width: auto; display: inline-block;">
                       
                        <a href="kbtd_en.aspx"><img alt="" src="en.jpg" width="70" height="50"></a></label>
                </div>
            </div>            

        </div>

        <h1 class="text-center mtb-20">Vietnam Health Declaration - SquareRoots</h1>


        <div class="tab-content" runat="server" id="divLogin" style="background: white; padding: 10px; border-left: 1px solid #ddd; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd;">
            <div id="divMessage" runat="server" class="alert alert-danger" role="alert">
                <span id="lbErrorDescription" runat="server">ggg</span>
            </div>
            <div class="row">
                <div class="col-md-4 col-sm-4  col-xs-12 ">
                    <div class="form-group label-width ">
                        <label>User Name</label>
                        <asp:TextBox runat="server" ID="txtUserName" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4  col-xs-12 ">
                    <div class="form-group label-width">
                        <label>Password</label>
                        <asp:TextBox runat="server" ID="txtPassWord" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4  col-xs-12 ">
                    <div class="btn-submit-box text-center" style="margin-top: 20px;">
                        <asp:Button runat="server" ID="btnLogin" CssClass="btn btn-success" OnClick="btnLogin_Click" Text="Login" />
                    </div>
                </div>

            </div>

        </div>
        <ul class="nav nav-tabs">
        </ul>
        <div class="tab-content" runat="server" id="divContent" style="background: white; padding: 10px; border-left: 1px solid #ddd; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd;">

            <div id="tab-9-2" class="tab-pane fade active in" style="background: white">
                <div id="module13" class="ModuleWrapper">
                    <div class="artile-edit-layout ">

                        <div class="box box-edit-layout">
                            <div class="box-body no-padding">
                                <br>

                                <div class="form-resign2">
                                    <div class="">
                                        <div class="national-brand text-center mb-15">
                                            <div class="text-uppercase"><b>GENERAL HEALTH DECLARATION INFORMATION</b></div>

                                        </div>
                                        <div class="text-center text-uppercase">
                                            <div class="">( COVID-19 EPIDEMIC PREVENTION )</div>
                                            <div style="color: red; text-transform: none;">Warning: Declaring false information is a violation of Vietnamese law and may be subject to criminal handling</div>

                                        </div>


                                        <div class="row">
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group label-width ">
                                                    <label>Employee Code <em style="line-height: 1">(*)</em></label>

                                                    <asp:DropDownList runat="server" ID="ddMaNhanVien" AutoPostBack="true" OnSelectedIndexChanged="ddMaNhanVien_SelectedIndexChanged" CssClass="form-control ">
                                                        <asp:ListItem Text="Chọn" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group label-width">
                                                    <label>Full name (CAPITAL LETTERS) <em style="line-height: 1">(*)</em></label>
                                                    <asp:TextBox runat="server" ID="txtTenNhanVien" ReadOnly="true" CssClass="form-control inline-block form-inline" Text="" Style="text-transform: uppercase;"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group label-width ">
                                                    <label>Passport number / ID card</label>
                                                    <asp:TextBox runat="server" ID="txtCMND" CssClass="form-control inline-block form-inline" Text=""></asp:TextBox>
                                                </div>
                                            </div>

                                        </div>

                                        <div class="row ">
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group inline-block form-inline label-width ">
                                                    <label>Year of Birth  <em style="line-height: 1">(*)</em></label>

                                                    <asp:TextBox runat="server" ID="txtNamSinh" CssClass="formNumberInput form-control inline-block form-inline" Text="" TextMode="Number"></asp:TextBox>

                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group  ">
                                                    <label>Gender  <em style="line-height: 1">(*)</em></label>



                                                    <div id="choicebox35769">

                                                        <table>
                                                            <tbody>
                                                                <tr>

                                                                    <td>
                                                                        <asp:RadioButton runat="server" ID="radioNam" Checked="true" Text="Male" GroupName="gioitinh" /></td>
                                                                    <td>&nbsp;</td>

                                                                    <td>
                                                                        <asp:RadioButton runat="server" ID="radioNu" Text="Female" GroupName="gioitinh" /></td>
                                                                    <td>&nbsp;</td>

                                                                    <td>
                                                                        <asp:RadioButton runat="server" ID="radioKhac" Text="Other" GroupName="gioitinh" /></td>
                                                                    <td>&nbsp;</td>


                                                                </tr>
                                                            </tbody>
                                                        </table>


                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                            </div>
                                        </div>

                                        <div class="mb-20"><b>Contact address in Vietnam</b></div>
                                        <div class="row ">
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group label-width">
                                                    <label>Province  <em style="line-height: 1">(*)</em></label>

                                                    <asp:DropDownList runat="server" ID="ddTinhThanh" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddTinhThanh_SelectedIndexChanged">
                                                        <asp:ListItem Text="Chọn" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>

                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group  label-width">
                                                    <label>District   <em style="line-height: 1">(*)</em></label>
                                                    <asp:DropDownList runat="server" ID="ddQuanHuyen" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddQuanHuyen_SelectedIndexChanged">
                                                        <asp:ListItem Text="Chọn" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>


                                            <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                <div class="form-group  label-width">
                                                    <label>Ward  <em style="line-height: 1">(*)</em></label>

                                                    <asp:DropDownList runat="server" ID="ddPhuongXa" CssClass="form-control">
                                                        <asp:ListItem Text="Chọn" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="row ">
                                            <div class="   col-xs-12 ">
                                                <div class="form-group ">
                                                    <label>Number of houses, streets, locality / village / team <em style="line-height: 1">(*)</em></label>
                                                    <asp:TextBox runat="server" ID="txtDiaChiChiTiet" CssClass="form-control" Text=""></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row ">
                                            <div class="col-md-6 col-sm-6  col-xs-12 ">
                                                <div class="form-group label-width ">
                                                    <label>Phone  <em style="line-height: 1">(*)</em></label>
                                                    <asp:TextBox runat="server" ID="txtDienThoai" type="number" CssClass="form-control" Text=""></asp:TextBox>

                                                </div>
                                            </div>
                                            <div class="col-md-6 col-sm-6  col-xs-12 ">
                                                <div class="form-group label-width ">
                                                    <label>Email </label>
                                                    <asp:TextBox runat="server" ID="txtEmail" CssClass="form-control" Text=""></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group form-lenght ">
                                            <label style="width: auto; font-weight: bold;">In the last 14 days, which regions/ countries/ territories have you traveled to (may travel across multiple places)</label>
                                            <div class="mt-10 inline-block pl-10">
                                                <asp:RadioButton runat="server" ID="radioDiaDiemDiQua_Khong" Checked="true" Text="No" AutoPostBack="true" OnCheckedChanged="radioDiaDiemDiQua_Khong_CheckedChanged" GroupName="DiaDiemDiQua" />
                                                <asp:RadioButton runat="server" ID="radioDiaDiemDiQua_Co" Text="Yes" AutoPostBack="true" OnCheckedChanged="radioDiaDiemDiQua_Co_CheckedChanged" GroupName="DiaDiemDiQua" />
                                            </div>
                                            <div class="mt-10 showCountryPassing" runat="server" id="divDiaDiemDiQua">
                                                <div style="clear: both">
                                                    <asp:TextBox runat="server" ID="txtDiaDiemDiQua" TextMode="MultiLine" CssClass="input35774 form-control" Style="height: 60px;"></asp:TextBox>


                                                </div>
                                                <div class="row " style="padding-top: 16px;">
                                                    <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                        <div class="form-group label-width">
                                                            <label>Vehicle  <em style="line-height: 1">(*)</em></label>

                                                            <asp:DropDownList runat="server" ID="ddPhuongTienDiLai" CssClass="form-control" AutoPostBack="true">
                                                                <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                                                <asp:ListItem Text="Planes" Value="1"></asp:ListItem>
                                                                <asp:ListItem Text="Train" Value="2"></asp:ListItem>
                                                                <asp:ListItem Text="Coach" Value="3"></asp:ListItem>
                                                                <asp:ListItem Text="Ships" Value="4"></asp:ListItem>
                                                                <asp:ListItem Text="Personal" Value="5"></asp:ListItem>
                                                            </asp:DropDownList>

                                                        </div>
                                                    </div>
                                                    <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                        <div class="form-group  label-width">
                                                            <label>Vehicle Code  <em style="line-height: 1">(*)</em></label>
                                                            <asp:TextBox runat="server" ID="txtSoHieuPhuongTien" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>


                                                    <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                        <div class="form-group  label-width">
                                                            <label>Departure Date  <em style="line-height: 1">(*)</em></label>

                                                            <asp:TextBox runat="server" ID="txtNgayKhoiHanh" CssClass="form-control" TextMode="Date"></asp:TextBox>

                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="row " style="padding-top: 6px;">

                                                    <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                        <div class="form-group  label-width">
                                                            <label>Departure   <em style="line-height: 1">(*)</em></label>
                                                            <asp:TextBox runat="server" ID="txtNoiDi" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>


                                                    <div class="col-md-4 col-sm-4  col-xs-12 ">
                                                        <div class="form-group  label-width">
                                                            <label>Destination  <em style="line-height: 1">(*)</em></label>
                                                            <asp:TextBox runat="server" ID="txtNoiDen" CssClass="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group form-lenght ">
                                            <label style="width: auto; font-weight: bold;">In the past 14 days Have you seen at least 1 of the following signs: fever, cough, difficulty breathing, pneumonia, sore throat, fatigue?</label>
                                            <div class="mt-10 inline-block pl-10">
                                                <asp:RadioButton runat="server" ID="radioTrieuChungKhong" Checked="true" Text="No" AutoPostBack="true" OnCheckedChanged="radioTrieuChungKhong_CheckedChanged" GroupName="TrieuChung" />
                                                <asp:RadioButton runat="server" ID="radioTrieuChungCo" AutoPostBack="true" OnCheckedChanged="radioTrieuChungCo_CheckedChanged" Text="Yes" GroupName="TrieuChung" />
                                            </div>
                                            <div class="mt-10 showSignal">

                                                <div style="clear: both">

                                                    <asp:TextBox runat="server" ID="txtTrieuChung" TextMode="MultiLine" CssClass="input35775 form-control" Style="height: 60px;"></asp:TextBox>

                                                </div>

                                            </div>
                                        </div>

                                        <div class="mb-10"><b>During the past 14 days, you were in contact with <span class="text-required">(*)</span></b></div>
                                        <div class="row ">
                                            <div class="   col-xs-12 ">
                                                <table class="table table-bordered tableData2">
                                                    <thead>
                                                        <tr>
                                                            <th scope="col"></th>
                                                            <th scope="col" style="width: 100px;" class="text-center">Yes</th>
                                                            <th scope="col" style="width: 100px;" class="text-center">No</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Sick or suspected person, infected with COVID-19 <span class="text-required">(*)</span><br>
                                                                <label class="error" for="fields[hasPatient]"></label>
                                                            </td>
                                                            <td class="text-center">
                                                                <asp:RadioButton runat="server" ID="radiohasPatientCo" Text="" GroupName="hasPatient" />
                                                            </td>
                                                            <td class="text-center">
                                                                <asp:RadioButton runat="server" ID="radiohasPatientKhong" Checked="true" Text="" GroupName="hasPatient" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>People from countries with COVID-19 disease <span class="text-required">(*)</span><br>
                                                                <label class="error" for="fields[hasFromSickCountry]"></label>
                                                            </td>
                                                            <td class="text-center">
                                                                <asp:RadioButton runat="server" ID="radiohasFromSickCountryCo" Text="" GroupName="hasFromSickCountry" />
                                                            </td>
                                                            <td class="text-center">
                                                                <asp:RadioButton runat="server" ID="radiohasFromSickCountryKhong" Checked="true" Text="" GroupName="hasFromSickCountry" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>People with manifestations (fever, cough, shortness of breath, pneumonia) <span class="text-required">(*)</span><br>
                                                                <label class="error" for="fields[hasSick]"></label>
                                                            </td>
                                                            <td class="text-center">
                                                                <asp:RadioButton runat="server" ID="radiohasSickCo" Text="" GroupName="hasSick" />
                                                            </td>
                                                            <td class="text-center">
                                                                <asp:RadioButton runat="server" ID="radiohasSickKhong" Checked="true" Text="" GroupName="hasSick" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>



                                        <div class="agreeWrapper 456">
                                            <div class="label-agree">Dữ liệu bạn cung cấp hoàn toàn bảo mật và chỉ phục vụ cho việc phòng chống dịch, thuộc quản lý SquareRoots</div>
                                        </div>
                                        <style>
                                            .agreeWrapper .label-agree {
                                                color: #f00;
                                                margin-bottom: 20px;
                                                word-break: break-word;
                                                line-height: 22px;
                                            }
                                        </style>
                                        <div id="divValidInfo" runat="server" class="alert alert-danger" role="alert">
                                            <span id="lbErrorOfInfo" runat="server">ggg</span>
                                        </div>
                                        <div class="btn-submit-box text-center">
                                            <asp:Button runat="server" ID="btnSubmit" CssClass="btn btn-success" Text="Gửi tờ khai" OnClick="btnSubmit_Click" />

                                        </div>
                                    </div>
                                </div>
                                <style>
                                    .info-namPas-box label {
                                        display: block !important;
                                    }

                                    .info-comCode-box label {
                                        display: block !important;
                                    }

                                    @media screen and (max-width: 767px) {
                                        .form-resign2 .tableChoiceData {
                                            display: block;
                                        }

                                            .form-resign2 .tableChoiceData .table {
                                                margin-bottom: 0;
                                            }

                                            .form-resign2 .tableChoiceData .cols-right {
                                                margin-top: -1px;
                                            }

                                            .form-resign2 .tableChoiceData .table > tbody > tr > td:nth-child(1) {
                                                min-width: 140px;
                                            }

                                            .form-resign2 .tableChoiceData .cols-right .table > thead {
                                                display: none;
                                            }

                                            .form-resign2 .tableChoiceData .cols-right .table > tbody > tr > td + td {
                                                width: 100px;
                                            }

                                        .form-resign2 {
                                            font-size: 16px;
                                        }

                                            .form-resign2 .table {
                                                font-size: 14px;
                                            }
                                    }

                                    @media screen and (max-width: 480px) {
                                        .form-resign2 .tableChoiceData .cols-right .table > tbody > tr > td:nth-child(1) .formWrapper .tableChoiceData .table > tbody > tr > td:nth-child(1) {
                                        }

                                        .form-resign2 .tableChoiceData .cols-right .table > tbody > tr > td:nth-child(2),
                                        .tableChoiceData .table > tbody > tr > td:nth-child(2) {
                                            min-width: 50px;
                                        }

                                        .form-resign2 .tableChoiceData .cols-right .table > tbody > tr > td:nth-child(3),
                                        .form-resign2 .tableChoiceData .table > tbody > tr > td:nth-child(3) {
                                            min-width: 60px;
                                        }
                                    }

                                    .form-resign2 span.text-required {
                                        color: red;
                                    }

                                    .form-resign2 label em {
                                        color: red;
                                    }

                                    .form-resign2 {
                                        padding: 15px;
                                        background: #fff;
                                    }

                                        .form-resign2 label {
                                            display: unset;
                                            font-weight: normal;
                                        }

                                    .label-width label {
                                        display: inline-block;
                                        width: 250px !important;
                                    }

                                    .form-resign2 .national-brand .text-uppercase {
                                        font-size: 20px;
                                    }

                                    .form-resign2 .national-brand .text-2 {
                                        display: inline-block;
                                        border-bottom: 1px solid #333;
                                        padding: 8px 0;
                                        font-size: 13px;
                                        margin-bottom: 8px;
                                    }

                                    .form-resign2 .text-center.text-uppercase {
                                        font-weight: bold;
                                        line-height: 35px;
                                        padding-bottom: 40px;
                                        font-size: 13px;
                                    }

                                    .request-form > .panel-body {
                                        padding: 0;
                                    }

                                        .request-form > .panel-body > .modal-body {
                                            padding: 0;
                                        }

                                    .request-form .form-inline.form-control {
                                        border: none;
                                        box-shadow: none;
                                        outline: none;
                                        border-bottom: 1px dotted #262626;
                                        border-radius: 0;
                                        vertical-align: middle;
                                    }

                                    .formWrapper .tableChoiceData {
                                        display: flex;
                                    }

                                        .formWrapper .tableChoiceData > div {
                                            flex: 1;
                                        }

                                    @media (min-width: 769px) {
                                        .label-width.form-inline .form-control {
                                            width: 300px!important;
                                        }

                                        .form-inline .form-control {
                                            width: auto !important;
                                            vertical-align: top;
                                        }
                                    }

                                    @media screen and (max-width: 767px) {
                                        .formWrapper .tableChoiceData {
                                            display: block;
                                        }

                                            .formWrapper .tableChoiceData .table {
                                                margin-bottom: 0;
                                            }

                                            .formWrapper .tableChoiceData .cols-right {
                                                margin-top: -1px;
                                            }

                                            .formWrapper .tableChoiceData .table > tbody > tr > td:nth-child(1) {
                                                min-width: 140px;
                                            }

                                            .formWrapper .tableChoiceData .cols-right .table > thead {
                                                display: none;
                                            }

                                            .formWrapper .tableChoiceData .cols-right .table > tbody > tr > td + td {
                                                width: 100px;
                                            }
                                    }

                                    @media screen and (max-width: 480px) {
                                        .formWrapper .tableChoiceData .cols-right .table > tbody > tr > td:nth-child(1) .formWrapper .tableChoiceData .table > tbody > tr > td:nth-child(1) {
                                        }

                                        .formWrapper .tableChoiceData .cols-right .table > tbody > tr > td:nth-child(2),
                                        .formWrapper .tableChoiceData .table > tbody > tr > td:nth-child(2) {
                                            min-width: 50px;
                                        }

                                        .formWrapper .tableChoiceData .cols-right .table > tbody > tr > td:nth-child(3),
                                        .formWrapper .tableChoiceData .table > tbody > tr > td:nth-child(3) {
                                            min-width: 60px;
                                        }
                                    }

                                    @media (max-width: 768px) {
                                        .form-inline .form-control.input-year {
                                            width: 100% !important;
                                        }

                                        .box-gaden label {
                                            display: block;
                                        }

                                        .passenger-wrapper .box-edit-layout .box-gaden.form-group:not(.group-input-inline) .select2-container.select2-container--default {
                                            width: 100% !important;
                                        }
                                    }

                                    #module13 .form-resign2 > div > div:nth-child(4) > div:nth-child(1) label, #module13 .form-resign2 > div > div:nth-child(3) > div:nth-child(1) label, #module13.form-resign2 > div > div:nth-child(5) > div:nth-child(1) label {
                                        display: inline-block;
                                        width: 210px !important;
                                    }

                                    @media screen and (min-width: 1024px) {
                                        .passenger-wrapper .box-edit-layout .form-group:not(.group-input-inline) .select2-container.select2-container--default {
                                            width: 100% !important;
                                        }
                                    }

                                    .form-lenght > label {
                                        width: auto;
                                        font-weight: 700;
                                    }
                                </style>

                            </div>
                        </div>
                    </div>



                    <style>
                        .form-resign2 .tableChoiceData table tbody {
                            white-space: normal;
                        }

                        @media (max-width: 425px) {
                            .insurance-box input {
                                margin-bottom: 5px;
                            }
                        }

                        @media (min-width: 769px) {
                            .label-width.form-inline .form-control {
                                max-width: 299px !important;
                                width: 299px !important;
                            }
                        }

                        @media(max-width: 768px) {
                            .label-width.form-inline .form-control;

                        {
                            width: 100% !important;
                        }

                        }

                        @media screen and (min-width: 1024px) {
                            .artile-edit-layout .form-resign2 .label-width.form-inline .form-control.form-inline:not(.full-width) {
                                max-width: 299px !important;
                                width: 299px !important;
                            }
                        }

                        @media screen and (min-width: 1024px) {
                            .artile-edit-layout .form-resign2 .label-width.form-inline .form-control.form-inline:not(.full-width) {
                                max-width: 299px !important;
                                width: 299px !important;
                            }
                        }

                        @media(max-width: 425px) {
                            .info-namPas-box label;

                        {
                            width: auto !important;
                            white-space: nowrap;
                        }

                        }

                        @media screen and (min-width: 1024px) {
                            .artile-edit-layout .form-resign2 .select2-container.select2-container--default {
                                width: auto !important;
                                min-width: 240px;
                            }
                        }

                        .form-resign2 span.text-required {
                            color: red;
                            font-style: italic;
                        }

                        #module11 .form-resign2 > div > div:nth-child(4) > div:nth-child(1) label, #module11 .form-resign2 > div > div:nth-child(3) > div:nth-child(1) label, #module11.form-resign2 > div > div:nth-child(5) > div:nth-child(1) label {
                            display: inline-block;
                            width: 250px !important;
                        }

                        .insurance-box label {
                            display: inline-block;
                            width: 240px !important;
                        }

                        .label-width label {
                            display: inline-block;
                            width: 220px;
                        }

                        .gender-box label {
                            width: 220px;
                            display: inline-block;
                        }

                        .form-resign2 .form-group.box-gaden > label {
                            display: unset;
                        }

                        @media(min-width: 1024px) {
                            .passenger-wrapper .box-edit-layout .form-group.box-gaden:not(.group-input-inline) .select2-container.select2-container--default;

                        {
                            width: auto !important;
                        }

                        }

                        @media (min-width: 767px) {
                            .form-resign2 > div > div:nth-child(4) > div:nth-child(1) label, .form-resign2 > div > div:nth-child(3) > div:nth-child(1) label, .form-resign2 > div > div:nth-child(5) > div:nth-child(1) label {
                                display: inline-block;
                                width: 250px !important;
                            }
                        }

                        @media (min-width: 768px) {
                            input.form-control.inline-block.form-inline {
                                min-width: 250px;
                            }
                        }

                        .box-edit-layout .insurance-box {
                            margin-bottom: 15px;
                        }

                            .box-edit-layout .insurance-box .form-group {
                                margin-bottom: 0;
                            }

                        .box-edit-layout .insurance-box-inside {
                            margin-top: 15px;
                        }

                        @media screen and (min-width: 1024px) {
                            #module7 .artile-edit-layout .form-resign2 .select2-container.select2-container--default {
                                width: auto !important;
                                min-width: 240px;
                            }
                        }

                        .mt-30 {
                            margin-top: 30px;
                        }

                        #module13 .sendType-option input {
                            display: none !important;
                        }

                        #module13 .sendType-option label {
                            cursor: pointer;
                        }

                        #module13 .sendType-option input + img {
                            padding: 2px;
                            border: 1px solid #eaeaea;
                        }

                        #module13 .sendType-option input:checked + img {
                            border-color: #0a6dd4;
                        }

                        #module13 .list-select li {
                            margin-bottom: 15px;
                            display: -webkit-flex;
                            display: flex;
                        }

                        #module13 .list-select span {
                            width: calc(100% - 105px);
                            display: inline-block;
                            padding-right: 10px;
                            margin-top: -5px;
                        }

                        .formWrapper .btn-larger {
                            font-size: 21px;
                            padding-left: 25px;
                            padding-right: 25px;
                            border-radius: 25px;
                        }

                        @media(max-width: 425px) {
                            .form-control.capcha-text;

                        {
                            min-width: 150px;
                        }

                        }
                    </style>
                </div>

            </div>
        </div>

        <div id="divFinal" runat="server" class="alert alert-success" role="alert">
            <span id="Span1" runat="server"></span>
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

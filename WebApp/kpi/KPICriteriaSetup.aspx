<%@ Page Title="" Language="C#" MasterPageFile="~/kpi/KPI.Master" AutoEventWireup="true" CodeBehind="KPICriteriaSetup.aspx.cs" Inherits="WebApplication2.kpi.KPICriteriaSetup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="KPIContent" runat="server">
    <style id="PRODUCTION KPI Criteria_8973_Styles"><!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
.xl158973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Calibri, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl638973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:red;
	font-size:20.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Tahoma, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:general;
	vertical-align:bottom;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl648973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl658973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl668973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#D0CECE;
	mso-pattern:black none;
	white-space:normal;}
.xl678973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:0%;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl688973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:0%;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl698973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl708973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#D0CECE;
	mso-pattern:black none;
	white-space:normal;}
.xl718973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl728973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl738973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:0%;
	text-align:center;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl748973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:0%;
	text-align:center;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl758973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl768973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl778973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#D0CECE;
	mso-pattern:black none;
	white-space:normal;}
.xl788973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl798973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl808973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:none;
	border-left:1.0pt solid white;
	background:#F2F2F2;
	mso-pattern:black none;
	white-space:normal;}
.xl818973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:none;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#F2F2F2;
	mso-pattern:black none;
	white-space:normal;}
.xl828973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:none;
	border-bottom:1.0pt solid white;
	border-left:none;
	background:#F2F2F2;
	mso-pattern:black none;
	white-space:normal;}
.xl838973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:none;
	background:#F2F2F2;
	mso-pattern:black none;
	white-space:normal;}
.xl848973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:none;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#F2F2F2;
	mso-pattern:black none;
	white-space:normal;}
.xl858973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:13.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#F2F2F2;
	mso-pattern:black none;
	white-space:normal;}
.xl868973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0D0D0D;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#FAE2C0;
	mso-pattern:black none;
	white-space:normal;}
.xl878973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0070C0;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:middle;
	border:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl888973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0070C0;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:middle;
	border-top:1.5pt solid #0070C0;
	border-right:1.0pt solid white;
	border-bottom:1.0pt solid white;
	border-left:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
.xl898973
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#0070C0;
	font-size:12.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:Arial, sans-serif;
	mso-font-charset:0;
	mso-number-format:General;
	text-align:left;
	vertical-align:middle;
	border-top:1.0pt solid white;
	border-right:1.0pt solid white;
	border-bottom:1.5pt solid #0070C0;
	border-left:1.0pt solid white;
	background:#E5F5D0;
	mso-pattern:black none;
	white-space:normal;}
--></style>
    <div class="page-wrapper" style="display: block;">
    <div id="PRODUCTION KPI Criteria_8973" align=center x:publishsource="Excel">

<table  border=0 cellpadding=0 cellspacing=0 width=100% style='border-collapse: collapse;width:967pt'>
 <col width=64 style='width:48pt'>
 <col width=214 style='mso-width-source:userset;mso-width-alt:7826;width:161pt'>
 <col width=87 style='mso-width-source:userset;mso-width-alt:3181;width:65pt'>
 <col width=102 span=9 style='mso-width-source:userset;mso-width-alt:3730;
 width:77pt'>
 <tr height=46 style='mso-height-source:userset;height:34.5pt'>
  <td height=46 class=xl158973 width=64 style='height:34.5pt;width:48pt'></td>
  <td class=xl638973 colspan=3 align=left width=403 style='width:303pt'>THANG
  &#272;I&#7874;M KPI C&#7910;A LEADER</td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
  <td class=xl158973 width=102 style='width:77pt'></td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl158973 style='height:15.75pt'></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <tr height=24 style='height:18.0pt'>
  <td rowspan=2 height=47 class=xl808973 dir=LTR width=64 style='border-bottom:
  1.5pt solid #0070C0;height:35.25pt;width:48pt'>STT</td>
  <td rowspan=2 class=xl808973 dir=LTR width=214 style='border-bottom:1.5pt solid #0070C0;
  width:161pt'>Criteria</td>
  <td rowspan=2 class=xl808973 dir=LTR width=87 style='border-bottom:1.5pt solid #0070C0;
  width:65pt'>Freight %</td>
  <td colspan=9 class=xl818973 dir=LTR width=918 style='border-right:1.0pt solid white;
  border-left:none;width:693pt'>Point</td>
 </tr>
 <tr height=23 style='height:17.25pt'>
  <td height=23 class=xl858973 dir=LTR width=102 style='height:17.25pt;
  border-top:none;border-left:none;width:77pt'>0</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>1</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>2</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>3</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>4</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>5</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>6</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>7</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>8</td>
 </tr>
 <tr height=46 style='mso-height-source:userset;height:34.5pt'>
  <td height=46 class=xl648973 dir=LTR width=64 style='height:34.5pt;
  border-top:none;width:48pt'>1</td>
  <td class=xl658973 dir=LTR width=214 style='border-left:none;width:161pt'>Indepartment
  output (Doanh sô&#769; BP)</td>
  <td class=xl668973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>25</td>
  <td class=xl678973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl678973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 81%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>81% - 86%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>86% - 91%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>91% - 96%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>96% - 101%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>101%-110%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 110%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
 </tr>
 <tr height=46 style='mso-height-source:userset;height:34.5pt'>
  <td height=46 class=xl698973 dir=LTR width=64 style='height:34.5pt;
  border-top:none;width:48pt'>2</td>
  <td class=xl658973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Efficiency (Hiê&#803;u qua&#777;)</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>25</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl728973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 71%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>71% - 81%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>81% - 91%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>91% - 100%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>100% -111%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>111%-120%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>120%-130%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt;= 130%</td>
 </tr>
 <tr height=46 style='mso-height-source:userset;height:34.5pt'>
  <td height=46 class=xl698973 dir=LTR width=64 style='height:34.5pt;
  border-top:none;width:48pt'>3</td>
  <td class=xl658973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Quality (Châ&#769;t l&#432;&#417;&#803;ng)</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>25</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt;= 0.55%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0.45 - 0.55%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0.35 - 0.45%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0.25 - 0.35%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 0.25%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
 </tr>
 <tr height=46 style='mso-height-source:userset;height:34.5pt'>
  <td height=46 class=xl698973 dir=LTR width=64 style='height:34.5pt;
  border-top:none;width:48pt'>4</td>
  <td class=xl658973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Regulation (Nô&#803;i quy)</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>15</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 27%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>20% - 27%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>13% - 20%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>5% - 13%</td>
  <td class=xl748973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt;= 5%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
 </tr>
 <tr height=46 style='mso-height-source:userset;height:34.5pt'>
  <td height=46 class=xl758973 dir=LTR width=64 style='height:34.5pt;
  border-top:none;width:48pt'>5</td>
  <td class=xl768973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>5S</td>
  <td class=xl778973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>10</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 5</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>5</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>4</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>3</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>2</td>
  <td class=xl798973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt;= 1</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
 </tr>
 <tr height=26 style='mso-height-source:userset;height:19.5pt'>
  <td height=26 class=xl158973 style='height:19.5pt'></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <tr height=26 style='mso-height-source:userset;height:19.5pt'>
  <td height=26 class=xl158973 style='height:19.5pt'></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl158973 style='height:15.0pt'></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <tr height=34 style='height:25.5pt'>
  <td height=34 class=xl158973 style='height:25.5pt'></td>
  <td class=xl638973 colspan=4 align=left>THANG &#272;I&#7874;M KPI C&#7910;A
  SUPERVISOR<span style='mso-spacerun:yes'> </span></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl158973 style='height:15.75pt'></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <tr height=24 style='height:18.0pt'>
  <td rowspan=2 height=47 class=xl808973 dir=LTR width=64 style='border-bottom:
  1.5pt solid #0070C0;height:35.25pt;width:48pt'>STT</td>
  <td rowspan=2 class=xl808973 dir=LTR width=214 style='border-bottom:1.5pt solid #0070C0;
  width:161pt'>Criteria</td>
  <td rowspan=2 class=xl808973 dir=LTR width=87 style='border-bottom:1.5pt solid #0070C0;
  width:65pt'>Freight %</td>
  <td colspan=9 class=xl818973 dir=LTR width=918 style='border-right:1.0pt solid white;
  border-left:none;width:693pt'>Point</td>
 </tr>
 <tr height=23 style='height:17.25pt'>
  <td height=23 class=xl858973 dir=LTR width=102 style='height:17.25pt;
  border-top:none;border-left:none;width:77pt'>0</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>1</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>2</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>3</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>4</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>5</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>6</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>7</td>
  <td class=xl858973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>8</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl648973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>1</td>
  <td class=xl888973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Company Output (Doanh s&#7889; công ty)</td>
  <td class=xl668973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>20</td>
  <td class=xl868973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl678973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 76%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>76% - 81%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>81% - 86%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>86% - 91%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>91% - 96%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>96%-100%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 100%</td>
  <td class=xl688973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl698973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>2</td>
  <td class=xl878973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Efficiency (Hi&#7879;u qu&#7843;)</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>15</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl728973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 71%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>71% - 81%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>81% - 91%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>91% - 100%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>100% -111%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>111%-120%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>120%-130%</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt;= 130%</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl698973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>3</td>
  <td class=xl878973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Indepartment output (Doanh s&#7889; BP)</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>15</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 81%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>81% - 86%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>86% - 91%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>91% - 96%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>96% - 101%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>101%-110%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 110%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl698973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>4</td>
  <td class=xl878973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Quality (Ch&#7845;t l&#432;&#7907;ng)</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>20</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt;= 1.1%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0.9% - 1.1%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0.7% - 0.9%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0.5% - 0.7%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt; 0.5%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>-</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl698973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>5</td>
  <td class=xl878973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Regulation</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>15</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 15%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>12% - 15%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>9% - 12%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>6% - 9%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0% - 6%</td>
  <td class=xl748973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>0%</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl738973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl698973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>6</td>
  <td class=xl878973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>5S</td>
  <td class=xl708973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>5</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 5</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>5</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>4</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>3</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>2</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt;= 1</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl718973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
 </tr>
 <tr height=50 style='mso-height-source:userset;height:37.5pt'>
  <td height=50 class=xl758973 dir=LTR width=64 style='height:37.5pt;
  border-top:none;width:48pt'>7</td>
  <td class=xl898973 dir=LTR width=214 style='border-top:none;border-left:none;
  width:161pt'>Absent</td>
  <td class=xl778973 dir=LTR width=87 style='border-top:none;border-left:none;
  width:65pt'>10</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&gt; 7%</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>6% - 7%</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>5% - 6%</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>4% - 5%</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>3% - 4%</td>
  <td class=xl798973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&lt;= 3%</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
  <td class=xl788973 dir=LTR width=102 style='border-top:none;border-left:none;
  width:77pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl158973 style='height:15.75pt'></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
  <td class=xl158973></td>
 </tr>
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=64 style='width:48pt'></td>
  <td width=214 style='width:161pt'></td>
  <td width=87 style='width:65pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
  <td width=102 style='width:77pt'></td>
 </tr>
 <![endif]>
</table>

</div></div>
    </asp:Content>



   


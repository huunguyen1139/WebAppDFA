<%@ Page Title="Kaizen Register Application" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="kaizenlist.aspx.cs" Inherits="WebApplication2.kaizenlist" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Bootstra-->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    <link href="../Content/font-awesome.css" rel="stylesheet" />
    <style>
	 @media(max-width:991px){
	.header-right {
		float: right;
		width: 57%;

	}
	.login-page h3.title1, .signup-page h3.title1 {
		padding: .9em 1em;
		border-bottom: 8px solid #4b7884;
		font-size: 1.4em;
	}
	.login-page input[type="email"], .login-page input[type="password"],.signup-page input[type="text"], .signup-page input[type="email"], .signup-page input[type="password"]{
		font-size: .9em;
		padding: 12px 15px 12px 37px;
	}
	.login-body {
		padding: 3em 2em;
	}
	.login-page input[type="submit"],.sub_home input[type="submit"] {
		padding: .5em 1em;
	}
	.compose-left,.compose-right {
		width: 100%;
		float: left;
		margin-left: 0%;
		margin-top: 2%;
	}
	.mail.mail-name {
		width: 16%;
	}
	.folder, .chat-grid {
		width: 49%;
		float: left;
		margin-right: 2%;
	}
	.chat-grid.widget-shadow {
		margin-top: 0em;
		margin-right: 0%;
	}
	.button-states-top-grid, .button-size-grids {
		width: 100%;
		float: none;
		margin: 0;
		margin-bottom: 1em;
	}
	button.btn.btn-default:nth-child(4) {
		margin-top: .5em;
	}
}
    
	</style>
    <link href="Content/font-awesome.css" rel="stylesheet" />
    <!-- Bootstrap -->
    <!-- Modal Popup -->
    <div id="MyPopup" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">
                    </h4>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function ShowPopup(title, body) {
            $("#MyPopup .modal-title").html(title);
            $("#MyPopup .modal-body").html(body);
            $("#MyPopup").modal("show");
        }
    </script>
    <!-- Modal Popup -->
   <script type="text/javascript">
       $(function () {
           CKEDITOR.replace('cke_MainContent_ckeditor1', {
               extraPlugins: 'imageuploader'
           });
       });
   </script>
    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

</script>

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>

            <div class="main-page">
				<h2 class="title1">Kaizen Summary 
                    <asp:Button runat="server" ID="btnCancel" style="float:right;padding: 5px 12px;" class="btn btn-info" OnClientClick="window.open('kaizencard.aspx', '_blank');" Text="Đăng ký"></asp:Button>
                    <asp:Button runat="server" ID="Button1" style="float:right;padding: 5px 12px;margin-right: 10px;" class="btn btn-warning" OnClientClick="window.open('../ReportViewer.aspx?type=kaizen', '_blank');" Text="Print List"></asp:Button>
				</h2>
			
				<div class="col-md-8 compose-right">
                    <div class="panel-default">
                        <div class="form-two widget-shadow" style="box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.5);">
                            <div class="form-title" style="background-color: cadetblue;">
                                <h4 style="color:white"><asp:LinkButton runat="server" ID="lbCollapse" Text="Data Filter" OnClick="lbCollapse_Click"></asp:LinkButton></h4>
                                <asp:HiddenField runat="server" ID="hfShow" />
                                <%--<h4 style="color:white"><a href="#header" data-toggle="collapse" style="color: white;">Data Filter</a> </h4>--%>
                            </div>                            
                            <div runat="server" class="form-body collapse" data-example-id="simple-form-inline" id="header">

                                <div class="row">
                                    <div class="col-md-4 grid_box1">
                                        <div class="form-group">
                                            <label>Từ ngày</label>
                                            <asp:TextBox runat="server" ID="txtFromDate" AutoPostBack="true" OnTextChanged="txtFromDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4 grid_box1">
                                        <div class="form-group">
                                            <label>Đến ngày</label>
                                            <asp:TextBox runat="server" ID="txtToDate" AutoPostBack="true" OnTextChanged="txtToDate_TextChanged" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Tháng - Năm</label>
                                            <asp:DropDownList runat="server" ID="ddMonthYear" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddMonthYear_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>                                                
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 grid_box1">
                                        <div class="form-group">
                                            <label>Bộ phận</label>
                                            <asp:DropDownList runat="server" ID="ddDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="-Tất cả-"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Nhân viên</label>
                                            <asp:DropDownList runat="server" ID="ddEmployee" AutoPostBack="true" OnSelectedIndexChanged="ddEmployee_SelectedIndexChanged1" CssClass="form-control">
                                                <asp:ListItem Value="0" Text="-Tất cả-"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Xếp loại</label>
                                            <asp:DropDownList runat="server" ID="ddLevel" CssClass="form-control" Enabled="true" AutoPostBack="true" OnSelectedIndexChanged="ddLevel_SelectedIndexChanged">
                                                <asp:ListItem Value="0" Text="-Chọn-"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Cấp 1: Thưởng ý tưởng : 19.000 VND"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Cấp 2: Có hiệu quả nội bộ : 299.000 VND"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Cấp 3: Có hiệu quả nhân rộng : 499.000 VND"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Cấp 4: Tiết kiệm chi phí ≥ 20tr/năm : 1.000.000 NVD"></asp:ListItem>

                                            </asp:DropDownList>
                                        </div>
                                    </div>

                                    <div class="clearfix"></div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 grid_box1">
                                        <div class="form-group">
                                            <label>Mô tả chung</label>
                                            <asp:TextBox runat="server" ID="txtDescription" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtAppliedDate_TextChanged"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-2 grid_box1">
                                        <div class="form-group">
                                            <label>Thanh toán</label>
                                            <asp:DropDownList runat="server" ID="ddPaid" CssClass="form-control" Enabled="true" AutoPostBack="true">
                                               <asp:ListItem Value="all" Text="-Tất cả-"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Not yet"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Paid"></asp:ListItem>                                               
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Trạng thái </label>
                                            <asp:DropDownList runat="server" ID="ddStatus" CssClass="form-control" Enabled="true" AutoPostBack="true">
                                               <asp:ListItem Value="0" Text="-Tất cả-"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Đã gửi"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Đã duyệt"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Chờ xác nhận"></asp:ListItem>
                                                <asp:ListItem Value="99" Text="Đã hủy"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clearfix"></div>
                                </div>


                            </div>
                        </div>
                        <div class="widget-shadow table-responsive" style="margin: 20px 0px;box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.5);">
                            <asp:Table runat="server" ID ="tbKaizenList" CssClass="table table-bordered-green">

                            </asp:Table>
                            <asp:Label runat="server" ID="lbNoRecordFound" style="margin: 10px 10px;" Text="No records found"></asp:Label>
                       </div>
                        
                             
				</div>
                </div>
                    <div class="col-md-4 compose-left">
					<div class="folder widget-shadow">
						<ul>
							<li class="head"><i class="fa fa-user" aria-hidden="true"></i>Leaderboard (Personal) </li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52727-1st-place-medal-icon.png" alt="">
										<label class="small-badge"></label>
									</div>
									<div class="chat-right">
										<p id="per1" runat="server">Nguyễn Văn Hữu</p>
										<h6 id="dper1" runat="server">ERP </h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52728-2nd-place-medal-icon.png" alt="">
										<label class="small-badge bg-green"></label>
									</div>
									<div class="chat-right">
										<p id="per2" runat="server">Null</p>
										<h6 id="dper2" runat="server">null</h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52729-3rd-place-medal-icon.png" alt="">
										<label class="small-badge bg-green"></label>
									</div>
									<div class="chat-right">
										<p id="per3" runat="server">Null </p>
										<h6 id="dper3" runat="server">Null </h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="images/i4.png" alt="">
										<label class="small-badge"></label>
									</div>
									<div class="chat-right">
										<p id="per4" runat="server">Null</p>
										<h6 id="dper4" runat="server">Null</h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
						</ul>
					</div>
					<div class="chat-grid widget-shadow">
						<ul>
							<li class="head"><i class="fa fa-user" aria-hidden="true"></i>Leaderboard (Department) </li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52727-1st-place-medal-icon.png" alt="">
										<label class="small-badge"></label>
									</div>
									<div class="chat-right">
										<p id="der1" runat="server">ERP</p>
										<h6 id="dder1" runat="server">Total of 3 kaizen ideal </h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52728-2nd-place-medal-icon.png" alt="">
										<label class="small-badge bg-green"></label>
									</div>
									<div class="chat-right">
										<p id="der2" runat="server">Null</p>
										<h6 id="dder2" runat="server">Null</h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="http://icons.iconarchive.com/icons/google/noto-emoji-activities/32/52729-3rd-place-medal-icon.png" alt="">
										<label class="small-badge bg-green"></label>
									</div>
									<div class="chat-right">
										<p id="der3" runat="server">Null </p>
										<h6 id="dder3" runat="server">Null </h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
							<li><a href="#">
									<div class="chat-left">
										<img class="img-circle" src="images/i4.png" alt="">
										<label class="small-badge"></label>
									</div>
									<div class="chat-right">
										<p id="der4" runat="server">Null</p>
										<h6 id="dder4" runat="server">Null</h6>
									</div>
									<div class="clearfix"> </div>	
								</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="clearfix"> </div>	
			</div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
       
</asp:Content>

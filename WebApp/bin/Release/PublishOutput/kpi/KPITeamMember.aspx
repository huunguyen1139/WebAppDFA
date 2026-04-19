<%@ Page Title="" Language="C#" MasterPageFile="~/kpi/KPI.Master" AutoEventWireup="true" CodeBehind="KPITeamMember.aspx.cs" Inherits="WebApplication2.kpi.KPITeamMember" %>
<asp:Content ID="Content1" ContentPlaceHolderID="KPIContent" runat="server">
        
       <asp:UpdatePanel runat="server" ID="UpdatePanel1">
           <ContentTemplate>

          <script type="text/javascript">
              function pageLoad(sender, args) {
                  $("input[type=checkbox]").addClass("material-inputs");
              };
        </script>
   <!-- Page wrapper  -->
        <!-- ============================================================== -->
        <div class="page-wrapper" style="display: block;">
            <!-- ============================================================== -->
            <!-- Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <div class="page-breadcrumb">
                <div class="row">
                    <div class="col-md-5 align-self-center">
                        <h4 class="page-title">Online KPI System</h4>
                        <div class="d-flex align-items-center">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="#">Home</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Team member</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                    <div class="col-md-7 d-flex justify-content-end align-self-center d-none d-md-flex">
                        <div class="d-flex">
                            <div class="dropdown mr-2 hidden-sm-down">
                                <asp:TextBox runat="server" ID="txtKPIMonth" TextMode="Month"  CssClass="form-control" AutoPostBack="true" OnTextChanged="txtKPIMonth_TextChanged"></asp:TextBox>
                            </div>
                            <%--<button runat="server" id="btnLoad" class="btn btn-success" onserverclick="btnLoad_ServerClick"><i class="mdi mdi-plus-circle"></i> Load</button>--%>
                           <%--<asp:Button runat="server" ID="btnLoad" OnClick="btnLoad_Click" CssClass="btn btn-success" Text="<b>Load</b>" />--%>
                        </div>
                    </div>
                </div>
            </div>
            <!-- ============================================================== -->
            <!-- End Bread crumb and right sidebar toggle -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- Container fluid  -->
            <!-- ============================================================== -->
           <!-- ============================================================== -->
            <div class="container-fluid">
                <!-- ============================================================== -->
                <!-- Start Page Content -->
                <!-- ============================================================== -->
                <div class="row">
                    <div class="col-12">
                       
                        <div class="card">
                          
                            <div class="">
							
                                <div class="row">
                                    <div class="col-lg-3 border-right pr-0">
                                        <div class="card-body border-bottom">
                                            <%--<h4 class="card-title mt-2">Employee List</h4>--%>
                                            <asp:DropDownList runat="server" ID="ddDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                                <asp:ListItem Text="WO" Value="120"></asp:ListItem>
                                                <asp:ListItem Text="RM" Value="119"></asp:ListItem>
                                                <asp:ListItem Text="FM" Value="104"></asp:ListItem>
                                                <asp:ListItem Text="SA" Value="121"></asp:ListItem>
                                                <asp:ListItem Text="AS" Value="102"></asp:ListItem>
                                                <asp:ListItem Text="FIN" Value="105"></asp:ListItem>
                                                <asp:ListItem Text="IRON" Value="107"></asp:ListItem>
                                                <asp:ListItem Text="UPH" Value="123"></asp:ListItem>
                                                <asp:ListItem Text="FIT" Value="106"></asp:ListItem>
                                                <asp:ListItem Text="PAC" Value="117"></asp:ListItem>                                                           
                                                        </asp:DropDownList>
                                        </div>
                                       
                                        
                                        <div class="card-body border-bottom">
                                            <div class="row" >
                                                <div class="col-md-12">
                                                      <!-- checkbox -->                                                   

                                                    <div runat="server" id="divcheckbox1" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox1" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox2" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox2" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox3" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox3" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox4" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox4" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox5" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox5" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox6" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox6" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox7" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox7" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox8" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox8" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox9" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox9" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox10" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox10" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox11" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox11" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox12" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox12" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox13" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox13" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox14" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox14" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox15" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox15" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox16" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox16" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox17" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox17" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox18" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox18" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox19" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox19" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox20" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox20" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox21" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox21" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox22" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox22" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox23" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox23" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox24" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox24" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox25" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox25" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox26" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox26" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox27" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox27" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox28" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox28" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox29" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox29" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox30" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox30" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox31" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox31" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox32" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox32" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox33" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox33" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox34" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox34" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox35" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox35" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox36" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox36" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox37" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox37" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox38" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox38" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox39" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox39" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox40" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox40" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox41" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox41" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox42" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox42" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox43" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox43" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox44" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox44" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox45" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox45" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox46" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox46" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox47" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox47" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox48" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox48" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="divcheckbox49" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox49" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox50" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox50" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox51" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox51" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox52" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox52" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox53" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox53" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox54" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox54" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox55" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox55" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox56" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox56" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox57" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox57" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox58" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox58" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox59" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox59" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox60" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox60" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox61" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox61" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox62" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox62" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox63" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox63" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox64" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox64" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox65" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox65" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox66" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox66" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox67" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox67" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox68" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox68" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    <div runat="server" id="divcheckbox69" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="checkbox69" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>
                                                    </div>
                                                </div>
                                         </div>

                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div>
                                                        <asp:DropDownList runat="server" ID="DropDownList1" CssClass="form-control" style="margin-bottom:10px">
                                                            <asp:ListItem Text="AS" Value="1"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div> 

                                                    <%--<button runat="server" id="btnAddEmployee" onserverclick="btnAddEmployee_ServerClick" class="btn mt-3 btn-info btn-block waves-effect waves-light">
                                                            <i class="ti-plus"></i> Move Employee btn mt-3 btn-info btn-block waves-effect waves-light
                                                       0142.5703\ </button>--%>
                                                     
                                                    <asp:Button runat="server" ID="btnAdd" OnClick="btnAdd_Click" CssClass="btn btn-info mt-3 btn-block" Text="Move Employee" />
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-lg-9">
                                        <div class="card-body b-l calender-sidebar">
                                            <ul class="nav nav-pills p-3 bg-light mb-3 rounded-pill align-items-center">
                              <li class="nav-item"> 
                                <asp:LinkButton runat="server" OnClick="lbt1_Click" CssClass="nav-link rounded-pill note-link d-flex align-items-center px-2 px-md-3 mr-0 mr-md-2" ID="lbt1" Text="<i class='icon-layers mr-1'></i>LinkButton"></asp:LinkButton> 
                              </li>
                              <li class="nav-item"> 
                                <asp:LinkButton runat="server" OnClick="lbt2_Click" CssClass="nav-link rounded-pill note-link d-flex align-items-center px-2 px-md-3 mr-0 mr-md-2" ID="lbt2" Text="<i class='icon-briefcase mr-1'></i>LinkButton"></asp:LinkButton> 
                              </li>
                              <li class="nav-item"> 
                                <asp:LinkButton runat="server" OnClick="lbt3_Click" CssClass="nav-link rounded-pill note-link d-flex align-items-center px-2 px-md-3 mr-0 mr-md-2" ID="lbt3" Text="<i class='icon-share-alt mr-1'></i>LinkButton"></asp:LinkButton> 
                              </li>
                              <li class="nav-item"> 
                                <asp:LinkButton runat="server" OnClick="lbt4_Click" CssClass="nav-link rounded-pill note-link d-flex align-items-center px-2 px-md-3 mr-0 mr-md-2" ID="lbt4" Text="<i class='icon-tag mr-1'></i>LinkButton"></asp:LinkButton> 
                              </li>
                              <li class="nav-item"> 
                                <asp:LinkButton runat="server" OnClick="lbt5_Click" CssClass="nav-link rounded-pill note-link d-flex align-items-center px-2 px-md-3 mr-0 mr-md-2" ID="lbt5" Text="<i class='icon-note m-1'></i>LinkButton"></asp:LinkButton> 
                              </li>
                                                           
                    </ul>
                                        </div>
                                        <div class="card-body">
                                            <div runat="server" id="lisemcheckbox1" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox1" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox2" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox2" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox3" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox3" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox4" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox4" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox5" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox5" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox6" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox6" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox7" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox7" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox8" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox8" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox9" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox9" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox10" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox10" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox11" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox11" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox12" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox12" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox13" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox13" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox14" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox14" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox15" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox15" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox16" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox16" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox17" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox17" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox18" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox18" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox19" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox19" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox20" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox20" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox21" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox21" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox22" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox22" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox23" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox23" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox24" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox24" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox25" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox25" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox26" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox26" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox27" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox27" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox28" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox28" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox29" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox29" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox30" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox30" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox31" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox31" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox32" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox32" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox33" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox33" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox34" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox34" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox35" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox35" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox36" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox36" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox37" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox37" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox38" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox38" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox39" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox39" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox40" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox40" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox41" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox41" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox42" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox42" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox43" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox43" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox44" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox44" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox45" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox45" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox46" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox46" Text="<i class='fa fa-circle text-success mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox47" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox47" Text="<i class='fa fa-circle text-danger mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox48" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox48" Text="<i class='fa fa-circle text-warning mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                                    <div runat="server" id="lisemcheckbox49" class="checkbox mb-3">
                                                        <asp:CheckBox runat="server" class="material-inputs" ID="emcheckbox49" Text="<i class='fa fa-circle text-info mr-2'></i>Employee Name"/>                                                        
                                                    </div>

                                            <asp:Button runat="server" ID="btnDelete" OnClick="btnDelete_Click" CssClass="btn mt-3 btn-danger btn-block" Text="Remove Employee" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        
                        </div>                       
					
					</div>
                </div>
                <!-- ============================================================== -->
                <!-- End PAge Content -->
                <!-- ============================================================== -->
                <!-- ============================================================== -->
                <!-- Right sidebar -->
                <!-- ============================================================== -->
                <!-- .right-sidebar -->
                <!-- ============================================================== -->
                <!-- End Right sidebar -->
                <!-- ============================================================== -->
            </div>
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- End Container fluid  -->
            <!-- ============================================================== -->
            <!-- ============================================================== -->
            <!-- footer -->
            <!-- ============================================================== -->
            <footer class="footer">
                © 2020 Online KPIs System by Huu
            </footer>
            <!-- ============================================================== -->
            <!-- End footer -->
            <!-- ============================================================== -->
        </div>
        <!-- ============================================================== -->
        <!-- End Page wrapper  -->
        <!-- ============================================================== -->  
     </ContentTemplate>
       </asp:UpdatePanel>   

       <%-- <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div class="modal1">
        <div class="center1">
            <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/kpi/KPI.Master" AutoEventWireup="true" CodeBehind="Productivity.aspx.cs" Inherits="WebApplication2.kpi.Productivity" %>
<asp:Content ID="Content1" ContentPlaceHolderID="KPIContent" runat="server">
<script>
    function OpenLink(link) {
        window.open(link, "_blank", "scrollbars=yes,resizable=no,top=100,left=200,width=800,height=600");
    }
</script>
       <%-- <script type="text/javascript">
            
            $(window).on('load', function AddFootable () {
                $('#KPIContent_tbKPIResult').footable();
            });
     

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            AddFootable();
        });
    </script>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
           <ContentTemplate>--%>
          
   <!-- Page wrapper  -->
        <!-- ============================================================== -->
        <div class="page-wrapper">
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
                                    <li class="breadcrumb-item active" aria-current="page">Productivity Bonus</li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                    <div class="col-md-7 d-flex justify-content-end align-self-center d-md-flex">
                        <div class="d-flex">
                            <div class="dropdown me-2 hidden-sm-down">
                                <asp:TextBox runat="server" ID="txtKPIMonth" TextMode="Month"  CssClass="form-control"></asp:TextBox>
                            </div>
                            <button runat="server" id="btnLoad" class="btn btn-success" onserverclick="btnLoad_ServerClick"><i class="mdi mdi-plus-circle"></i> Load</button>
                            <%--<asp:Button runat="server" ID="btnLoad" class="mdi mdi-plus-circle" CssClass="btn btn-success" Text="Load" />--%>
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
                            <div class="card-body">
                                <h4 class="card-title">Productivity Bonus</h4>
                                <h6 class="card-subtitle"><asp:Label runat="server" id="txtPeriod"></asp:Label></h6>                                

                                <div class="table-responsive">
                                                    
                                                    <asp:GridView runat="server" ID="gvProductivity" border="1" CssClass="table no-wrap table-striped table-bordered" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                        <HeaderStyle CssClass="table-light" />
                                                        <RowStyle VerticalAlign="Middle" CssClass="smallrow"/>
                                                        
                                                        <Columns>
                                                            <asp:BoundField DataField="Year" HeaderText="Year" />
                                                            <asp:BoundField DataField="Month" HeaderText="Month" />
                                                            <asp:BoundField DataField="EmployeeCode" HeaderText="Employee Code" />
                                                            <asp:BoundField DataField="EmployeeName" HeaderText="Employee Name" />
                                                            <asp:BoundField DataField="Department" HeaderText="Department" />
                                                            <asp:BoundField DataField="Bonus" HeaderText="Bonus" />                                                            
                                                        </Columns>
                                                    </asp:GridView>


                                                </div>

                            </div>
                        </div>
                       
					   <!-- Column -->
                      
                        <!-- Column -->
                       
                        <!-- Column -->
                     
                    <!-- Column -->
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
            <%--   </ContentTemplate>
               </asp:UpdatePanel>--%>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>        
                    <div class="modal1" style="position: fixed; z-index: 999; height: 100%; width: 100%; top: 0; left: 0;  right: 0;   bottom: 0;   background-color: Black;  filter: alpha(opacity=60); opacity: 0.4;">
        <div class="center1" style="z-index: 1000; margin: 200px auto;  padding: 5px;  width: 140px;  background-color: White;  border-radius: 10px;  filter: alpha(opacity=100); opacity: 1;">
            <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

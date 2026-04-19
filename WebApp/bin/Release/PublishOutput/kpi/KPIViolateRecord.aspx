<%@ Page Title="" Language="C#" MasterPageFile="~/kpi/KPI.Master" AutoEventWireup="true" CodeBehind="KPIViolateRecord.aspx.cs" Inherits="WebApplication2.kpi.KPIViolateRecord" %>
<asp:Content ID="Content1" ContentPlaceHolderID="KPIContent" runat="server">

    <!-- Add Contact Popup Model -->
    <style>
        .smallrow td{
            padding: .15rem .75rem;
        }
    </style>

    <div id="addviolate" class="modal fade in" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header d-flex align-items-center">
                    <h4 class="modal-title" id="myModalLabel">Add New Violate Record</h4>
                    <button type="button" class="close ml-auto" data-dismiss="modal"
                        aria-hidden="true">
                        ×</button>
                </div>
                <div class="modal-body">
                    <from class="form-horizontal form-material">
                        <div class="form-group">
                            <div class="col-md-12 m-b-20">
                                <asp:DropDownList runat="server" ID="ddViolateType" CssClass="form-control">
                                    <asp:ListItem Text="Chọn lỗi vi phạm..." Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Nội quy" Value="Noiquy"></asp:ListItem>
                                    <asp:ListItem Text="5S" Value="5S"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-12 m-b-20">
                                <asp:TextBox runat="server" TextMode="DateTimeLocal" CssClass="form-control" ID="txtViolateDateTime"></asp:TextBox>
                            </div>
                            <div class="col-md-12 m-b-20">
                                <%--<input type="text" class="form-control" placeholder="Type name">--%>
                                <asp:DropDownList runat="server" ID="ddDepartment" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                    <asp:ListItem Text="Chọn Bộ phận..." Value="0">                                                                    
                                    </asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-12 m-b-20">
                                <asp:DropDownList runat="server" ID="ddEmployee" CssClass="form-control">
                                    <asp:ListItem Text="Chọn Nhân viên..." Value="0">                                                                    
                                    </asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <%--<div class="col-md-12 m-b-20">
                                                            <asp:DropDownList runat="server" ID="ddTeam" CssClass="form-control">
                                                                <asp:ListItem Text="Chọn nhóm..." Value="0">                                                                    
                                                                </asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>--%>
                            <div class="col-md-12 m-b-20">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtViolateDes" placeholder="Mô tả lỗi vi phạm"></asp:TextBox>
                            </div>
                            <div class="col-md-12 m-b-20">
                                <asp:DropDownList runat="server" ID="ddisSupervisorKPI" CssClass="form-control">
                                    <asp:ListItem Text="Tính KPI cho trưởng Bộ phận...?" Value="-1"></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-12 m-b-20">
                                <asp:DropDownList runat="server" ID="ddisLeaderKPI" CssClass="form-control">
                                    <asp:ListItem Text="Tính KPI cho trưởng Nhóm...?" Value="-1"></asp:ListItem>
                                    <asp:ListItem Text="Yes" Value="1" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                        </div>
                    </from>
                </div>
                <div class="modal-footer">
                    <button type="button" runat="server" id="btnSave" onserverclick="btnSave_ServerClick" class="btn btn-info waves-effect">
                        Save</button>
                    <button type="button" class="btn btn-default waves-effect"
                        onclick="HidePopup()">
                        Cancel</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <script type="text/javascript">
        function ShowPopup() {
            $("#addviolate").modal("show");
        }

        function HidePopup() {
            $("#addviolate").modal("hide");
            $("#addviolate").css("display", "none");
            $("#addviolate").removeClass("show");
            var x = document.getElementsByClassName("modal-backdrop fade show");
            var y = document.getElementById("addviolate");
            var i;
            for (i = 0; i < x.length; i++) {
                x[i].className = "";
            }
            y.className = "modal fade in";
            y.css("display", "none");

        }
    </script>
    <asp:UpdatePanel ID="d" runat="server">
        <ContentTemplate>
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
                                        <li class="breadcrumb-item active" aria-current="page">KPI Violate Record</li>
                                    </ol>
                                </nav>
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

                            <!-- Column -->
                            <div class="card">
                                <%--<h4 class="card-title">Accordion Footable</h4>
                                <h6 class="card-subtitle">Create your table with Accordion Footable</h6>--%>
                                
                                <!-- Accordian -->
                                <div class="accordion" id="accordionTable">
                                    <div class="card m-b-5">
                                        <%--<div class="card-header" id="heading1">
                                            <h5 class="mb-0">
                                                <button class="btn btn-link" type="button" data-toggle="collapse"
                                                    data-target="#col1" aria-expanded="true" aria-controls="col1">
                                                    Collapsible Group Item #1
                                                </button>
                                            </h5>
                                        </div>--%>
                                        <div id="col1" class="collapse show" aria-labelledby="heading1"
                                            data-parent="#accordionTable">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center justify-content-end">
                                                    <button type="button" style="margin-bottom: 10px" class="btn btn-info btn-rounded m-t-10"
                                                        data-toggle="modal" onclick="ShowPopup()">
                                                        Add New Record</button>
                                                </div>
                                                <div class="table-responsive">
                                                    
                                                    <asp:GridView runat="server" ID="gvViolationRecord" border="0" CssClass="table no-wrap" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                        <HeaderStyle CssClass="table-light" />
                                                        <RowStyle VerticalAlign="Middle" CssClass="smallrow"/>
                                                        
                                                        <Columns>
                                                            <asp:BoundField DataField="Date" HeaderText="Date" />
                                                            <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
                                                            <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />
                                                            <asp:BoundField DataField="TeamName" HeaderText="Team" />
                                                            <asp:BoundField DataField="ViolateDescription" HeaderText="Description" />
                                                            <asp:BoundField DataField="Type" HeaderText="Type" />
                                                            <asp:BoundField DataField="isSuperviorKPI" HeaderText="isSupervisorKPI" />
                                                            <asp:BoundField DataField="isLeaderKPI" HeaderText="isLeaderKPI" />                                                            
                                                            <asp:TemplateField HeaderText="Actions">
                                                                <ItemTemplate>
                                                                    <%--<asp:LinkButton runat="server" ID="lbtnEdit" OnClick="" data-bs-toggle="tooltip" data-bs-placement="top" title="Edit"><i class="material-icons">&#xE254;</i></asp:LinkButton>--%>
                                                                    <asp:LinkButton Style="color: #E34724;" runat="server" ID="lbtnDelete" OnClick="lbtnDelete_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Delete"><i class="material-icons">&#xE872;</i></asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="RowIndex" HeaderText="RowIndex" Visible="true" ItemStyle-Width="10" ItemStyle-CssClass="display-no1ne" HeaderStyle-CssClass="display-non1e" />
                                                        </Columns>
                                                    </asp:GridView>


                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                            </div>
                            <!-- Column -->

                        </div>
                    </div>
                    
                </div>
                
                <footer class="footer">
                    © 2020 Online KPIs System by Huu           
                </footer>
                
            </div>
          
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

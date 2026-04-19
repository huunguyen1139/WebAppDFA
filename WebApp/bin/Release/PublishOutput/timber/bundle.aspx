<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="bundle.aspx.cs" Inherits="WebApplication2.timber.bundle" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TIMBERContent" runat="server">
    
    <%-- Search Table --%>
    <script>
        function searchTable() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("txtSearchText");
            filter = input.value.toUpperCase();
            table = document.getElementById("TIMBERContent_gvBundleList");
            tr = table.getElementsByTagName("tr");

            // Loop through all table rows, and hide those who don't match the search query
            for (i = 0; i < tr.length; i++) {
                tdl = tr[i].getElementsByTagName("td");
                for (j = 0; j < tdl.length; j++) {
                    td = tdl[j];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                        else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        }
    </script>
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>

            <div class="page-wrapper" style="display: block">
                <style>
                    #txtSearchText {
                        background-image: url('/Content/searchicon.png'); /* Add a search icon to input */
                        background-position: 10px 12px; /* Position the search icon */
                        background-repeat: no-repeat; /* Do not repeat the icon image */
                        width: 100%; /* Full-width */
                        font-size: 16px; /* Increase font-size */
                        padding: 12px 20px 12px 40px; /* Add some padding */
                        border: 1px solid #ddd; /* Add a grey border */
                        margin-bottom: 12px; /* Add some space below the input */
                    }
                </style>
                <div class="container-fluid">
                    <div class="card accordion-flush" runat="server" id="divAddNewBundle">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                Add New
                            </button>
                        </h2>
                        <div class="card-body accordion-collapse show" id="collapseOne">
                            <div id="divMessage" runat="server" class="alert alert-danger" role="alert">
                                <span id="lbErrorDescription" runat="server"></span>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label>Container</label>
                                    <div class="input-group">

                                        <asp:DropDownList runat="server" ID="ddContainerCode" CssClass="form-control select2"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label>Quantity (PCS)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">+</span>
                                        <asp:TextBox runat="server" ID="txtIntQuantity" TextMode="Number" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label>Cubic (M3)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">+</span>
                                        <asp:TextBox runat="server" ID="txtCubicQuantity" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3" runat="server" id="divTC1">
                                    <label for="1" runat="server" id="lbTC1">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC1" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddTC1_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Select"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3" runat="server" id="divTC2">
                                    <label for="1" runat="server" id="lbTC2">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC2" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddTC2_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-4 mb-3" runat="server" id="divTC3">
                                    <label for="1" runat="server" id="lbTC3">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC3" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddTC3_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3" runat="server" id="divTC4">
                                    <label for="1" runat="server" id="lbTC4">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC4" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3" runat="server" id="divTC5">
                                    <label for="1" runat="server" id="lbTC5">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC5" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>

                                <div class="col-md-4 mb-3" runat="server" id="divTC6">
                                    <label for="1" runat="server" id="lbTC6">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC6" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>

                            </div>

                            <div class="row">

                                <div class="col-md-4 mb-3" runat="server" id="divTC7">
                                    <label for="1" runat="server" id="lbTC7">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC7" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3" runat="server" id="divTC8">
                                    <label for="1" runat="server" id="lbTC8">Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:DropDownList runat="server" Visible="false" ID="ddTC8" CssClass="form-control"></asp:DropDownList>
                                    </div>
                                </div>



                            </div>

                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="1">ERP Material Code</label>
                                    <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <asp:TextBox runat="server" ID="txtERPCode" CssClass="form-control" Enabled="false"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                            <div style="text-align: center">
                                <asp:Button runat="server" ID="btnAddBundle" Style="padding: 10px 68px;" CssClass="btn btn-info mt-4 rounded-pill" Text="Create" OnClick="btnAddBundle_Click" />
                            </div>

                        </div>
                    </div>
                    <div class="card">
                        <div class="border-bottom title-part-padding">
                            <h4 class="card-title mb-0">Bundle List
                                    <asp:LinkButton runat="server" ID="lbtnAddNewBundle" Style="float: right;" Text="Add New" OnClick="lbtnAddNewBundle_Click"></asp:LinkButton>
                            </h4>
                        </div>
                        <div class="card-body">
                            <input type="text" id="txtSearchText" onkeyup="searchTable()" placeholder="Search for anything..">
                            <div class="table-responsive">


                                <asp:GridView runat="server" Style="font-size: 13px;" ID="gvBundleList" CssClass="table table-sm  mb-0 v-middle" border="0" EmptyDataText="No records found">
                                    <HeaderStyle CssClass="table-light" />
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
   <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>        
                    <div style="position: fixed;z-index: 999;height: 100%;  width: 100%; top: 0; left: 0; right: 0;  bottom: 0;  background-color: Black;  filter: alpha(opacity=60); opacity: 0.4;  -moz-opacity: 0.8;">
        <div style="z-index: 1000; margin: 200px auto; padding: 5px;  width: 293px; background-color: White;    border-radius: 10px;  filter: alpha(opacity=100); opacity: 1; -moz-opacity: 1;">
            <div style="text-align: center">Loading...</div>
            <img alt="" src="http://www.manbhumsambad.com/images/loader.gif" />
        </div>
    </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

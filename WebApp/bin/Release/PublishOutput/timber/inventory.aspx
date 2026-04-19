<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="inventory.aspx.cs" Inherits="WebApplication2.timber.inventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TIMBERContent" runat="server">
    <link href="../kpi/dist/css/customstyle.css" rel="stylesheet"/>
    <link href="../kpi/src/assets/extra-libs/jquery-steps/steps.css" rel="stylesheet"/>
	<link href="../kpi/src/assets/extra-libs/jquery-steps/jquery.steps.css" rel="stylesheet"/>

	<script>
	    function Huu() {
	        excel = new ExcelGen({
	            "src_id": "<%: gvInventory.ClientID %>",
	            "show_header": true
	        });

            excel.generate();
        }
	   
	</script>
			
		
    <style>
	    .display-none {
            display:none;
	    }

	    @media (min-width: 768px) {
	        .huucenter {
	            margin-left: 33.33333%;
	        }
	    }
	</style>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>

            <div class="page-wrapper" style="display: block">

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="card">
                                <div class="border-bottom title-part-padding">
                                    <h4 class="card-title mb-0">Group by</h4>
                                </div>
                                <div class="card-body">

                                    <ul class="list-group">
                                        <li class="list-group-item">
                                            <div>
                                                <input runat="server" class="material-inputs" type="checkbox" value="" id="cbTC1"/>
                                                <label for="<%: cbTC1.ClientID %>">
                                                    Thickness
                                                </label>
                                            </div>
                                        </li>
                                        <li class="list-group-item">
                                            <div>
                                                <input runat="server" class="material-inputs" type="checkbox" value="" id="cbTC2"/>
                                                <label for="<%: cbTC2.ClientID %>">
                                                    Width of timber board
                                                </label>
                                            </div>
                                        </li>
                                        <li class="list-group-item">
                                            <div>
                                                <input runat="server" class="material-inputs" type="checkbox" value="" id="cbTC3"/>
                                                <label for="<%: cbTC3.ClientID %>">
                                                    Length of timber board
                                                </label>
                                            </div>
                                        </li>

                                    </ul>

                                </div>
                            </div>
                        </div>
                        <div class="col-lg-9">
                            <div class="card">
                                <div class="border-bottom title-part-padding">
                                    <h4 class="card-title mb-0">Option and Submit</h4>
                                </div>
                                <div class="card-body" style="height: 164px">
                                    <div>
                                        <input runat="server" class="material-inputs" type="checkbox" value="" id="cbShowSubInventory"/>
                                        <label for="<%: cbShowSubInventory.ClientID %>">
                                            Aslo display the inventory of parent group when the child item is displayed.
                                        </label>
                                    </div>
                                    <div class="mt-2">
                                        <input runat="server" class="material-inputs" type="checkbox" value="" id="cbMergeCell"/>
                                        <label for="<%: cbMergeCell.ClientID %>">
                                            Merge cells that have the same value
                                        </label>
                                    </div>
                                    <div class="mt-4" style="text-align: center;">
                                        <button runat="server" id="btnLoad" type="submit" onserverclick="btnLoad_ServerClick" class="btn btn-primary font-weight-medium rounded-pill px-4">
                                            <div class="d-flex align-items-center">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-send feather-sm fill-white me-2">
                                                    <line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                                                Submit
                                            </div>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="d-flex border-bottom title-part-padding align-items-center">
                            <div><h4 class="card-title mb-0">Inventory</h4></div>
                            <div class="ms-auto"><a href="#" onclick="Huu()"><i class="ti-download"></i> Download as Excel (.XLSX)</a></div>
                        </div>
                        <div class="card-body">                            
                                    <div class="table-responsive mt-1">
                                        <asp:GridView runat="server" ID="gvInventory" border="0" CssClass="tablesm no-wrap" EmptyDataText="No records found" AutoGenerateColumns="true">
                                            <HeaderStyle CssClass="table-light" />
                                            <RowStyle VerticalAlign="Middle" />
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

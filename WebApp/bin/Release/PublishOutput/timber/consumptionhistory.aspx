<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="consumptionhistory.aspx.cs" Inherits="WebApplication2.timber.consumptionhistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TIMBERContent" runat="server">
    <link href="../kpi/dist/css/customstyle.css" rel="stylesheet"/>
    <link href="../kpi/src/assets/extra-libs/jquery-steps/steps.css" rel="stylesheet"/>
	<link href="../kpi/src/assets/extra-libs/jquery-steps/jquery.steps.css" rel="stylesheet"/>

	<script>

	    function Huu() {
	        excel = new ExcelGen({
	            "src_id": "<%: gvConsumptionHistory.ClientID %>",
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
                    <div class="card">
                        <div class="border-bottom title-part-padding">
                            <h4 class="card-title mb-0">Consumption History</h4>                            
                        </div>
                        <div class="card-body">
                            <div class="border-bottom">
                            <div class="row mb-4">
                                <div class="col-md-4 mb-3">
                                    <label>From Date</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="mdi mdi-calendar-text"></i></span>
                                        <asp:TextBox runat="server" ID="txtFromDate" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                
                                <div class="col-md-4 mb-3">
                                    <label>To Date</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="mdi mdi-calendar-text"></i></span>
                                        <asp:TextBox runat="server" ID="txtToDate" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <%--<asp:Button runat="server" CssClass="btn btn-info mt-4 rounded-pill px-4" ID="btnLoad" Text="Load Data" OnClick="btnLoad_Click"></asp:Button>--%>
                                
                                    <button runat="server" id="btnLoadData" onserverclick="btnLoad_Click" type="submit" class="btn btn-facebook mt-4 font-weight-medium rounded-pill px-4">
                                        <div class="d-flex align-items-center">
                                            <i class="ti-loop fill-white me-2"></i>
                                            Load Data
                                        </div>
                                    </button>
                                </div>
                            </div>
                                </div>
                                <div class="row" runat="server" id="linkDownload">
                                    <div class="col-md-12">
                                        <a href="#" onclick="Huu()" class="mt-3" style="float: right;"><i class="ti-download"></i> Download as Excel (.XLSX)</a>
                                    </div>
                                </div>
                            <asp:HiddenField runat="server" ID="hfMinScrap" Value="2.12" />
                            <div class="border-bottom">
                                <%--<asp:Button runat="server" CssClass="btn btn-info mt-3" ID="btnExportToExcel" Text="Export To Excel" OnClientClick="Huu();"></asp:Button>--%>
                                <div class="row mb-5 mt-2">
                                    
                                    <div class="table-responsive mt-3">
                                        <asp:GridView runat="server" ID="gvConsumptionHistory" border="0" CssClass="tablesm no-wrap" EmptyDataText="No records found" AutoGenerateColumns="false">
                                            <HeaderStyle CssClass="table-light" />
                                            <RowStyle VerticalAlign="Middle" />
                                            <Columns>
                                                <asp:BoundField DataField="PlannedDate" HeaderText="Planned Date" DataFormatString="{0:dd-MMM-yy}"/>
                                                <asp:BoundField DataField="PINo" HeaderText="PI No." />
                                                <asp:BoundField DataField="ProdNo" HeaderText="Prod. Order" />
                                                <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                <asp:BoundField DataField="ProdQty" HeaderText="ProdQty" />
                                                <asp:BoundField DataField="Component" HeaderText="Component" />
                                                <asp:BoundField DataField="MaterialCode" HeaderText="Material Code" />
                                                <asp:BoundField DataField="ComQty" HeaderText="ComQty" />
                                                <asp:BoundField DataField="QtyPer" HeaderText="QtyPer" />
                                                <asp:BoundField DataField="BundleCode" HeaderText="Bundle Code" />
                                                <asp:BoundField DataField="PCS" HeaderText="PCS" />
                                                <asp:BoundField DataField="M3" HeaderText="M3" DataFormatString="{0:#0.#####}"/>
                                                <asp:BoundField DataField="ReturnM3" HeaderText="Re-M3" DataFormatString="{0:#0.#####}" />
                                                <asp:BoundField DataField="SelectCode" HeaderText="Selected Code" />
                                                <asp:BoundField DataField="Waste" HeaderText="% Scrap" DataFormatString="{0:P}"/>

                                               
                                                <%--<asp:TemplateField HeaderText="Bundle">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lbBundleCode" Text='<%# Eval("BundleCode") %>' Visible='<%# Eval("BundleCode").ToString().Length > 0 ? true : false  %>'></asp:Label>
                                                        <asp:DropDownList runat="server" ID="ddBundleCode" CssClass="select2" Style="width: 180px" Visible='<%# Eval("BundleCode").ToString().Length > 0 ? false : true  %>'>
                                                            <asp:ListItem Value="0" Text="Select"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="PCS">
                                                    <ItemTemplate>
                                                       
                                                        <asp:TextBox runat="server" ID="txtPCS" Text='<%# Eval("PCS") %>' Style="border-width: 0px 0px; border-style: solid; width: 40px;"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="M3">
                                                    <ItemTemplate>
                                                        <asp:TextBox runat="server" ID="txtM3" Text='<%# SQRFunctionLibrary.SQRLibrary.ConvertToDouble(Eval("M3")).ToString("#0.#####") %>' Style="border-width: 0px 0px; border-style: solid; width: 60px;"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="Re-M3">
                                                    <ItemTemplate>
                                                        <asp:TextBox runat="server" ID="txtReturnM3" Text='<%# SQRFunctionLibrary.SQRLibrary.ConvertToDouble(Eval("ReturnM3")).ToString("#0.#####") %>' Style="border-width: 0px 0px; border-style: solid; width: 60px;"></asp:TextBox>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RowIndex" HeaderText="RowIndex" />--%>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>

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

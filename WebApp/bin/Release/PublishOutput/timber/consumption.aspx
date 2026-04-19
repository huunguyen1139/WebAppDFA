<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="consumption.aspx.cs" Inherits="WebApplication2.timber.consumption" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TIMBERContent" runat="server">
    <link href="../kpi/dist/css/customstyle.css" rel="stylesheet"/>
    <link href="../kpi/src/assets/extra-libs/jquery-steps/steps.css" rel="stylesheet"/>
	<link href="../kpi/src/assets/extra-libs/jquery-steps/jquery.steps.css" rel="stylesheet"/>
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
                            <h4 class="card-title mb-0">Make Consumption</h4>
                            
                        </div>
                        <div class="card-body wizard-content">
                            <div class="tab-wizard wizard-circle wizard clearfix">
                                
                                <asp:HiddenField runat="server" ID="currentstep" Value="step0"/>
                                <!-- step 1 -->
                                <div id="step1" runat="server">
                                    <h6 class="card-subtitle lh-lg mb-0">Select date to make consumption</h6>
                                    <div class="row border-bottom">
                                        <div class="col-md-4 mb-5 huucenter">
                                            <label for="1">Planned Date</label>
                                            <div class="input-group">
                                                <span class="input-group-text" id="i1"><i class="mdi mdi-calendar-text"></i></span>
                                                <asp:TextBox runat="server" TextMode="Date" class="form-control" ID="txtConsumptionDate" aria-describedby="inputGroupPrepend"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div id="step2" runat="server" class="border-bottom">                                    
                                    <div class="row mb-5">
                                        <span>Component List</span>
                                        <div class="table-responsive">
                                            <asp:GridView runat="server" ID="gvConsumption" border="0" CssClass="tablesm form-material" style="font-size: 13px;" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                <HeaderStyle CssClass="table-light" />
                                                <RowStyle VerticalAlign="Middle" />
                                                <Columns>                                                    
                                                    
                                                    <asp:BoundField DataField="ProdNo" HeaderText="Prod. Order" /> 
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />                                                   
                                                    <asp:BoundField DataField="ProdQty" HeaderText="ProdQty" />     
                                                    <asp:BoundField DataField="Component" HeaderText="Component" />                                                   
                                                                         
                                                    <asp:TemplateField HeaderText="Bundle">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbBundleCode" Text='<%# Eval("BundleCode") %>' Visible='<%# Eval("BundleCode").ToString().Length > 0 ? true : false  %>'></asp:Label>
                                                            <asp:DropDownList runat="server" ID="ddBundleCode" CssClass="select2" style="width: 120px" Visible='<%# Eval("BundleCode").ToString().Length > 0 ? false : true  %>'>
                                                                <asp:ListItem Value="0" Text="Select"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="PCS">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbPCS" Text='<%# Eval("PCS") %>' Visible='<%# IsPositiveNumber(Eval("M3")) %>'></asp:Label>
                                                            <asp:TextBox runat="server" ID="txtPCS" CssClass="form-control" Text='<%# Eval("PCS") %>' Visible='<%# !IsPositiveNumber(Eval("M3")) %>' style="width: 40px;"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="M3">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbM3" Text='<%# FormatNumber(Eval("M3")) %>' Visible='<%# IsPositiveNumber(Eval("M3")) %>'></asp:Label>
                                                            <asp:TextBox runat="server" CssClass="form-control" ID="txtM3" Text='<%# FormatNumber(Eval("M3")) %>' Visible='<%# !IsPositiveNumber(Eval("M3")) %>' style="width: 60px;"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="Re-M3">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbReturnM3" Text='<%# FormatNumber(Eval("ReturnM3")) %>' Visible='<%# IsPositiveNumber(Eval("M3")) %>'></asp:Label>
                                                            <asp:TextBox runat="server" CssClass="form-control" ID="txtReturnM3" Text='<%# FormatNumber(Eval("ReturnM3")) %>' Visible='<%# !IsPositiveNumber(Eval("M3")) %>' style="width: 60px;"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                    <asp:TemplateField HeaderText="">
                                                        <ItemTemplate>                                                            
                                                            <asp:LinkButton runat="server" ID="lbtnDelete" OnClick="lbtnDelete_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Clear Consumption"><i class="text-info far fa-edit"></i></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>

                                                     <asp:BoundField DataField="RowIndex" HeaderText="RowIndex" />     
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>

                                </div>
                                
                                <div class="actions clearfix mt-3">
                                    <ul role="menu" aria-label="Pagination">                                        
                                        <li class="disabled" aria-disabled="true">
                                           <%-- <asp:Button runat="server" CssClass="btn btn-primary" ID="btnPrevious" Text="Previous" OnClick="btnPrevious_Click"></asp:Button>--%>
                                        <button runat="server" id="btnPreviousNew" class="btn btn-primary" onserverclick="btnPrevious_Click"><i class="me-2 mdi mdi-skip-previous"></i> Previous</button>
                                             </li>
                                        <li aria-hidden="false" aria-disabled="false">
                                           <%--  <asp:Button runat="server" CssClass="btn btn-warning" ID="btnNext" Text="Next" OnClick="btnNext_Click"></asp:Button>--%>
                                            <button runat="server" id="btnNextNew" class="btn btn-warning" onserverclick="btnNext_Click"> Next <i class="me-2 mdi mdi-skip-next"></i></button>
                                        </li>

                                        <li aria-hidden="true">
                                             <asp:Button runat="server" CssClass="btn btn-danger" ID="btnSubmit" Text="Submit" OnClick="btnSubmit_Click"></asp:Button>
                                           
                                         </li>
                                    </ul>
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

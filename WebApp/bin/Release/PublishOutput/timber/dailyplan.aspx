<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="dailyplan.aspx.cs" Inherits="WebApplication2.timber.dailyplan" %>
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
                            <h4 class="card-title mb-0">Create Daily Plan</h4>
                            
                        </div>
                        <div class="card-body wizard-content">
                            <div class="tab-wizard wizard-circle wizard clearfix">
                                <div class="steps clearfix">
                                    <ul role="tablist">
                                        <li role="tab" runat="server" id="liStep1" class="first current" aria-disabled="false" aria-selected="true">
                                            <a><span class="step">1</span> Planned Date</a>
                                        </li>
                                        <li role="tab" runat="server" id="liStep2" class="disabled" aria-disabled="true">
                                            <a><span class="step">2</span> Products</a>
                                        </li>
                                        <li role="tab" runat="server" id="liStep3" class="disabled" aria-disabled="true">
                                            <a><span class="step">3</span> Components</a>
                                        </li>
                                        <li role="tab" runat="server" id="liStep4" class="disabled last" aria-disabled="true">
                                            <a><span class="step">4</span> Confirmation</a>
                                        </li>
                                    </ul>
                                </div>
                                <asp:HiddenField runat="server" ID="currentstep" Value="step0"/>
                                <!-- step 1 -->
                                <div id="step1" runat="server">
                                    <div class="row border-bottom">
                                        <div class="col-md-4 mb-5 huucenter">
                                            <label for="1">Planned Date</label>
                                            <div class="input-group">
                                                <span class="input-group-text" id="i1"><i class="mdi mdi-calendar-text"></i></span>
                                                <asp:TextBox runat="server" TextMode="Date" class="form-control" ID="txtPlannedDate" aria-describedby="inputGroupPrepend"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div id="step2" runat="server" class="border-bottom">

                                    <div class="row mb-4">
                                        <div class="col-md-4">
                                            <label for="1">Search Text</label>
                                            <div class="input-group">                                                
                                                <asp:TextBox runat="server" class="form-control" ID="txtSearch" placeholder="Type anything to search..."></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-2">                                            
                                            <asp:Button runat="server" ID="btnSearch" CssClass="btn mt-4 rounded-pill px-4" style="width: 100%; border-color: darkseagreen" Text="Search" OnClick="btnSearch_Click"/>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="1">Result List</label>
                                            <div class="input-group">
                                                <asp:DropDownList runat="server" ID="ddProdOrderList" CssClass="form-control select2" AutoPostBack="true" OnSelectedIndexChanged="ddProdOrderList_SelectedIndexChanged">
                                                    <asp:ListItem Value="0" Text="Select"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-5">
                                        <span>Selected Product</span>
                                        <div class="table-responsive">
                                            <asp:GridView runat="server" ID="gvProductList" border="0" CssClass="tablesm" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                <HeaderStyle CssClass="table-light" />
                                                <RowStyle VerticalAlign="Middle" />
                                                <Columns>
                                                    
                                                    <asp:BoundField DataField="PINo" HeaderText="PI No." />
                                                    <asp:BoundField DataField="ProdOrder" HeaderText="Prod Order" />
                                                    <asp:BoundField DataField="ProductCode" HeaderText="Product Code" />
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                    <asp:TemplateField HeaderText="Quantity">
                                                        <ItemTemplate>
                                                            <asp:TextBox ReadOnly="true" runat="server" ID="txtQuantity" Text='<%# Eval("Quantity") %>' style="border-width: 0px 0px; border-style: solid;" AutoPostBack="true" OnTextChanged="txtQuantity_TextChanged"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Actions">
                                                        <ItemTemplate>                                                            
                                                            <asp:LinkButton runat="server" ID="lbtnEdit" OnClick="lbtnEdit_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Edit"><i class="material-icons">&#xE254;</i></asp:LinkButton>
                                                            <asp:LinkButton style="color: #E34724;" runat="server" ID="lbtnDelete" OnClick="lbtnDelete_Click" data-bs-toggle="tooltip" data-bs-placement="top" title="Delete"><i class="material-icons">&#xE872;</i></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="RowIndex" HeaderText="RowIndex" Visible="true" ItemStyle-Width="10" ItemStyle-CssClass="display-no1ne" HeaderStyle-CssClass="display-non1e"/>
                                                </Columns>
                                            </asp:GridView>
                                            
                                        </div>
                                    </div>
                                </div>

                                <div id="step3" runat="server" class="border-bottom">
                                    <h6 class="card-subtitle lh-lg mb-0">Select components of products which have plan to make consumption report from the <mark><code>Components List</code></mark></h6>
                                    <h6 class="card-subtitle lh-lg mb-3">Then add it to the <mark><code>Selected Components</code></mark> by click on 'Get Selected Components' button</h6>
                                    <div class="row mb-2">
                                        <span>Component List</span>
                                        <div class="table-responsive">
                                            
                                            <asp:GridView runat="server" ID="gvComponents" border="0" CssClass="tablesm" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                <HeaderStyle CssClass="table-light" />
                                                <RowStyle VerticalAlign="Middle" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="">
                                                        <ItemTemplate>
                                                            <asp:CheckBox runat="server" ID="cbCheckBox" Text=""/>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="Component" HeaderText="Component" />
                                                    <asp:BoundField DataField="ProdNo" HeaderText="Production Order" />
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                    <asp:BoundField DataField="PINo" HeaderText="PI No." />
                                                    
                                                    <asp:BoundField DataField="RefRow" HeaderText="RefRow" />
                                                    <asp:BoundField DataField="BOMNo" HeaderText="Production BOM" />       
                                                    <asp:BoundField DataField="BOMLine" HeaderText="BOM Line No" />
                                                                                                        
                                                    <asp:BoundField DataField="ProdQty" HeaderText="ProdQty" />
                                                    <asp:BoundField DataField="MaterialCode" HeaderText="Material Code" />
                                                    <asp:BoundField DataField="ComQty" HeaderText="ComQty" />
                                                    <asp:BoundField DataField="QtyPer" HeaderText="QtyPer" />
                                                    
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                    
                                    <asp:Button runat="server" ID="btnAddToSelectedComponents" CssClass="btn mt-0 rounded-pill px-4 mb-3" style="border-color: darkseagreen" Text="Copy selected rows" OnClick="btnAddToSelectedComponents_Click"/>
                                    <div class="row mb-5">
                                        <span>Selected Components</span>
                                        <div class="table-responsive">
                                            <asp:GridView runat="server" ID="gvSelectedComponents" border="0" CssClass="tablesm" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                <HeaderStyle CssClass="table-light" />
                                                <RowStyle VerticalAlign="Middle" />
                                                <Columns>                                                    
                                                    <asp:BoundField DataField="Component" HeaderText="Component" />
                                                    <asp:BoundField DataField="ComQty" HeaderText="ComQty" /> 
                                                    <asp:BoundField DataField="MaterialCode" HeaderText="Material Code" />
                                                     <asp:BoundField DataField="ProdNo" HeaderText="Prod. Order" /> 
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                    <asp:BoundField DataField="PINo" HeaderText="PI No." />
                                                    <asp:BoundField DataField="ProdQty" HeaderText="ProdQty" />                              
                                                   
                                                    <asp:TemplateField HeaderText="">
                                                        <ItemTemplate>                                                            
                                                            <asp:LinkButton style="color: #E34724;" runat="server" ID="lbtnDeleteComponents" OnClick="lbtnDeleteComponents_Click"><i class="material-icons">&#xE872;</i></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="RowIndex" HeaderText="RowIndex" Visible="true"/>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                            
                                <div id="step4" runat="server" class="border-bottom">
                                    <h6 class="card-subtitle lh-lg mb-0">Are you sure you want to use below data to make the planned and consumption?</h6>
                                    <h6 class="card-subtitle lh-lg mb-3">If <mark><code>Yes</code></mark> click Submit. Otherwise, Click Previous button to modify data</h6>
                                    <div class="row mb-5">
                                        <span>Component List</span>
                                        <div class="table-responsive">
                                            <asp:GridView runat="server" ID="gvSelectedComponentConfirm" border="0" CssClass="tablesm" EmptyDataText="No records found" AutoGenerateColumns="false">
                                                <HeaderStyle CssClass="table-light" />
                                                <RowStyle VerticalAlign="Middle" />
                                                <Columns>                                                    
                                                    <asp:BoundField DataField="Component" HeaderText="Component" />
                                                    <asp:BoundField DataField="ComQty" HeaderText="ComQty" /> 
                                                    <asp:BoundField DataField="MaterialCode" HeaderText="Material Code" />
                                                    <asp:BoundField DataField="ProdNo" HeaderText="Prod. Order" /> 
                                                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                                                    <asp:BoundField DataField="PINo" HeaderText="PI No." />
                                                    <asp:BoundField DataField="ProdQty" HeaderText="ProdQty" />                             
                                                   
                                                    
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </div>

                                </div>
                                
                                <div class="actions clearfix mt-3">
                                    <ul role="menu" aria-label="Pagination">
                                        <li class="disabled" aria-disabled="true">
                                            <%--<asp:Button runat="server" CssClass="btn btn-primary" ID="btnPrevious" Text="Previous" OnClick="btnPrevious_Click"></asp:Button>--%>
                                            
                                            <button runat="server" id="btnPreviousNew" class="btn btn-primary" onserverclick="btnPrevious_Click"><i class="me-2 mdi mdi-skip-previous"></i> Previous</button>
                                        </li>

                                        <li aria-hidden="false" aria-disabled="false">
                                             <%--<asp:Button runat="server" CssClass="btn btn-info" ID="btnNext" Text="Next" OnClick="btnNext_Click"></asp:Button>--%>
                                            <button runat="server" id="btnNextNew" class="btn btn-info" onserverclick="btnNext_Click"> Next <i class="me-2 mdi mdi-skip-next"></i></button>
                                        </li>

                                        <li aria-hidden="true">
                                             <asp:Button runat="server" CssClass="btn btn-info" ID="btnSubmit" Text="Submit" OnClick="btnSubmit_Click"></asp:Button>
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

<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="timbercriteria.aspx.cs" Inherits="WebApplication2.timber.timbercriteria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TIMBERContent" runat="server">
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
    <div class="page-wrapper" style="display: block">
            
            <div class="container-fluid">                             
               
			   <div class="card">
                            <div class="border-bottom title-part-padding">
                                <h4 class="card-title mb-3">Timber Criterion</h4>
								<h6 class="card-subtitle mb-0"><mark><code>Add class of timber criterion. Ex. thickness, Width,...</code></mark></h6>
                            </div>
                            <div class="card-body">
								<div id="divMessage" runat="server" class="alert alert-danger" role="alert">
								<span id="lbErrorDescription" runat="server"></span>
								</div>				
				
                                  <div class="row">
                                    <div class="col-md-4 mb-3">
                                      <label for="1">Code</label>
                                      <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        <input type="text" class="form-control" runat="server" id="txtCriteriaCode" placeholder="Code" aria-describedby="inputGroupPrepend" />                                        
                                      </div>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                      <label for="2">Description</label>
                                      <div class="input-group">
                                        <span class="input-group-text" id="i2">@</span>

                                        <input type="text" class="form-control" id="txtCriteriaDescription" runat="server" placeholder="Description" aria-describedby="inputGroupPrepend"/>
                                        
                                      </div>
                                    </div>
                                    
									<div class="col-md-4 mb-3">									  
                                    
                                        <asp:Button runat="server" ID="btnAddTimberCriteria"  CssClass="btn btn-info mt-4 rounded-pill px-4" Text="Create" OnClick="btnAddTimberCriteria_Click"/>                                  
                                    </div>
									
                                  </div>                               
                                  
                                
                            </div>
                        </div>
			   
			   <div class="card">
                    
					<div class="card-body">
                    <div class="table-responsive">
                        

                        <asp:GridView runat="server" ID ="gvTimberCriteria" CssClass="table table-sm  mb-0 v-middle" border="0" EmptyDataText="No records found">
                        <HeaderStyle CssClass="table-light" />                       
                        </asp:GridView>
                    </div>
					</div>
				</div>
            </div> 
        </div>
             </ContentTemplate></asp:UpdatePanel>
   
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/timber/TIMBER.Master" AutoEventWireup="true" CodeBehind="container_label.aspx.cs" Inherits="WebApplication2.timber.container_label" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TIMBERContent" runat="server">
    <script>
        function searchTable() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("txtSearchText");
            filter = input.value.toUpperCase();
            table = document.getElementById("TIMBERContent_gvContainerLavel");
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
            
            <div class="container-fluid">	   
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
                <div class="card">
                            <div class="border-bottom title-part-padding">
                                <h4 class="card-title mb-0">Add New</h4>								
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
                                        
                                        <asp:TextBox  runat="server" id="txtContainerCode" CssClass="form-control"></asp:TextBox>                                   
                                      </div>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                      <label for="2">Receipt Date</label>
                                      <div class="input-group">
                                        <span class="input-group-text" id="Span1">@</span>

                                        <asp:TextBox  runat="server" id="txtReceiptDate" CssClass="form-control" TextMode="Date"></asp:TextBox>  
                                        
                                      </div>
                                    </div>
                                    
									<div class="col-md-4 mb-3">
                                      <label for="2">Supplier</label>
                                      <div class="input-group">
                                        <span class="input-group-text" id="Span2">@</span>

                                          <asp:TextBox  runat="server" id="txtSupplier" CssClass="form-control"></asp:TextBox>                                          
                                        
                                      </div>
                                    </div>
									
                                  </div>      

                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                      <label for="1">Grade</label>
                                      <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        
                                        <asp:TextBox  runat="server" id="txtGrade" CssClass="form-control"></asp:TextBox>                                   
                                      </div>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                      <label for="2">Unit Price</label>
                                      <div class="input-group">
                                        <span class="input-group-text">@</span>

                                        <asp:TextBox  runat="server" id="txtUnitPrice" CssClass="form-control" ></asp:TextBox>  
                                        
                                      </div>
                                    </div>
                                    
									<div class="col-md-4 mb-3">
                                      <label for="2">CBM</label>
                                      <div class="input-group">
                                        <span class="input-group-text">@</span>

                                          <asp:TextBox  runat="server" id="txtCBM" CssClass="form-control" ></asp:TextBox>                                          
                                        
                                      </div>
                                    </div>
									
                                  </div>    

                                  <div class="row">
                                    <div class="col-md-4 mb-3">
                                      <label for="1">Thickness</label>
                                      <div class="input-group">
                                        <span class="input-group-text">@</span>
                                        
                                       <asp:TextBox  runat="server" id="txtThickness" CssClass="form-control"></asp:TextBox>                                      
                                      </div>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                      <label for="2">Remark</label>
                                      <div class="input-group">
                                        <span class="input-group-text" id="i2">@</span>

                                        <asp:TextBox  runat="server" id="txtRemark" CssClass="form-control"></asp:TextBox>  
                                        
                                      </div>
                                    </div>
                                    
									<div class="col-md-4 mb-3">									  
                                    
                                        <asp:Button runat="server" ID="btnAddContainerLabel"  CssClass="btn btn-info mt-4 rounded-pill px-4" Text="Create" OnClick="btnAddContainerLabele_Click"/>                                  
                                    </div>
									
                                  </div>                               
                                  
                                
                            </div>
                        </div>
			   <div class="card">
                    <div class="border-bottom title-part-padding">
                                <h4 class="card-title mb-0">Container Label</h4>								
                    </div>
					<div class="card-body">
                        <input type="text" id="txtSearchText" onkeyup="searchTable()" placeholder="Search for anything..">	
                        <div class="table-responsive">
                        

                        <asp:GridView runat="server" ID ="gvContainerLavel" CssClass="table table-sm table-striped mb-0 v-middle" border="0" EmptyDataText="No records found">
                        <HeaderStyle CssClass="table-light" />                       
                        </asp:GridView>
                    </div>
					</div>
				</div>
               
            </div> 
        </div>
             </ContentTemplate></asp:UpdatePanel>
   
</asp:Content>

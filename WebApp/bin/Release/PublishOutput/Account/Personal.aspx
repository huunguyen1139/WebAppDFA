<%@ Page Title="Links" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Personal.aspx.cs" Inherits="WebApplication2.Account.Personal" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="buttons_w3ls_agile">
								
									
									<div class="button_set_one two agile_info_shadow">
										<!-- Standard button -->
										 <h3 class="w3_inner_tittle two"> Link</h3>

											<!-- Provides extra visual weight and identifies the primary action in a set of buttons -->
											<button type="button" class="btn btn-primary" onclick="window.open('http://sqrsystem.com:8080/QueryTool/kaizen/kaizenlist','_blank');">My Kaizen</button>
                                            <button type="button" class="btn btn-info" onclick="window.open('http://sqrsystem.com:8080/QueryTool/qc/defectlist','_blank');">QC Defect logs</button>
											<!-- Indicates a successful or positive action -->
											<button type="button" class="btn btn-success" onclick="window.open('http://sqrsystem.com:8080/QueryTool/Account/Manage','_blank');">CHANGE PASSWORD</button>

											<!-- Contextual button for informational alert messages -->
											

											<%--<!-- Indicates caution should be taken with this action -->
											<button type="button" class="btn btn-warning">Warning Button</button>

											<!-- Indicates a dangerous or potentially negative action -->
											<button type="button" class="btn btn-danger">Danger Button</button>--%>

											
									</div>
									<div class="clearfix"></div>
								</div>
</asp:Content>

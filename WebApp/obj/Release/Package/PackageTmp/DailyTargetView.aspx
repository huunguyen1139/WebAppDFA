<%@ Page Title="Daily Target View" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DailyTargetView.aspx.cs" Inherits="WebApplication2.DailyTargetView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap -->
    <script type="text/javascript" src='https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js'></script>
    <script type="text/javascript" src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.0.3/js/bootstrap.min.js'></script>
    

    <!-- Bootstrap -->
    <!-- Modal Popup -->
    <div id="MyPopup" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        &times;</button>
                    <h4 class="modal-title">
                    </h4>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">
                        Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function ShowPopup(title, body) {
            $("#MyPopup .modal-title").html(title);
            $("#MyPopup .modal-body").html(body);
            $("#MyPopup").modal("show");
        }
    </script>
    <!-- Modal Popup -->
    <script type="text/javascript">
        function selectAndCopyElementContents(el) {
            var body = document.body,
              range, sel;
            if (document.createRange && window.getSelection) {
                range = document.createRange();
                sel = window.getSelection();
                sel.removeAllRanges();
                try {
                    range.selectNodeContents(el);
                    sel.addRange(range);
                } catch (e) {
                    range.selectNode(el);
                    sel.addRange(range);
                }
            } else if (body.createTextRange) {
                range = body.createTextRange();
                range.moveToElementText(el);
                range.select();
            }
            document.execCommand("Copy");            
            ShowPopup('POR System', 'Copied to Clipboard');
        }
    </script>
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div style="padding-top: 20px" visible="false">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:140px">
                    <h2>Daily Target View</h2>
                    
                    <div style="width: 40%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control" PlaceHolder="From Date"></asp:TextBox>
                    </div>
                    <div style="width: 40%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtToDate" TextMode="Date" Width="95%" CssClass="form-control" PlaceHolder="To Date"></asp:TextBox>
                    </div>
                                          
                    <div style="width: 20%; float: right">
                        <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text ="View" OnClick="btnLoad_Click" />
                    </div>                      
                </div>
                <br />                         
                      
            </div>
           
            <div class="">             
                <asp:Button CssClass="btn btn-warning" Style="margin-bottom: 10px" runat="server" ID="btnCopy" Text ="Copy to Clipboard" OnClientClick="selectAndCopyElementContents(document.getElementById('MainContent_gvDailyTarget'));"/>
                <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div class="table-responsive">
                    <asp:GridView runat="server" ID ="gvDailyTarget" Width="100%" Visible="False" BorderColor="#333333" Caption="Daily Target Information" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found" AutoGenerateColumns="False" OnRowDataBound="gvDailyTarget_RowDataBound">
                        <HeaderStyle BackColor="#cccccc" BorderColor="#333333" />                       
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
</asp:Content>

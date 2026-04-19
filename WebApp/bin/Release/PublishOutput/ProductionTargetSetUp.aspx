<%@ Page Title="Production Daily Target Setup" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductionTargetSetUp.aspx.cs" Inherits="WebApplication2.ProductionTargetSetUp" %>

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

       //$("MainContent_btnPaste1").addEventListener
       //get raw data from clipboard

       document.getElementById("MainContent_btnLoad").addEventListener("click", multiFieldPasteHandler);

       function getClipboardData(e) {         
           
           if (e.clipboardData) {
               return e.clipboardData.getData("text");               
           }
           else if (window.clipboardData)
           {              
               return window.clipboardData.getData("text");
           }         
           return false;
       }

       //split raw data to array
       function processPasteData(rawPasted) {
           var rows = [], multi = [], rowLen, i;

           //split by newline to get the rows
           rows = rawPasted.split("\n");
           rowLen = rows.length;          
           return rows;
       }

      function multiFieldPasteHandler(e) {
           var rawPasted, pasteData = [], i;          
           e.preventDefault();
           rawPasted = getClipboardData(e);
           pasteData = processPasteData(rawPasted);
                      
           document.getElementById('MainContent_awhWO').value = parseFloat(pasteData[0].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhWO', '');         

           document.getElementById('MainContent_awhRM').value = parseFloat(pasteData[1].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhRM', '');

           document.getElementById('MainContent_awhFM').value = parseFloat(pasteData[2].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhFM', '');

           document.getElementById('MainContent_awhAS').value = parseFloat(pasteData[3].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhAS', '');

           document.getElementById('MainContent_awhSA').value = parseFloat(pasteData[4].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhSA', '');

           document.getElementById('MainContent_awhFIN').value = parseFloat(pasteData[5].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhFIN', '');

           document.getElementById('MainContent_awhIRON').value = parseFloat(pasteData[6].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhIRON', '');

           document.getElementById('MainContent_awhUPH').value = parseFloat(pasteData[7].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhUPH', '');

           document.getElementById('MainContent_awhFIT').value = parseFloat(pasteData[8].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhFIT', '');

           document.getElementById('MainContent_awhPAC').value = parseFloat(pasteData[9].split("\t")[0], 10);
           __doPostBack('ctl00$MainContent$awhPAC', '');

           ShowPopup('POR System', 'Đã copy xong');
      }
      function multiFieldPasteHandler1(e) {
          var rawPasted, pasteData = [], i;        
          e.preventDefault();
          rawPasted = getClipboardData(e);
          pasteData = processPasteData(rawPasted);

          document.getElementById('MainContent_nonWO').value = parseFloat(pasteData[0].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonWO', '');

          document.getElementById('MainContent_nonRM').value = parseFloat(pasteData[1].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonRM', '');

          document.getElementById('MainContent_nonFM').value = parseFloat(pasteData[2].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonFM', '');

          document.getElementById('MainContent_nonAS').value = parseFloat(pasteData[3].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonAS', '');

          document.getElementById('MainContent_nonSA').value = parseFloat(pasteData[4].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonSA', '');

          document.getElementById('MainContent_nonFIN').value = parseFloat(pasteData[5].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonFIN', '');

          document.getElementById('MainContent_nonIRON').value = parseFloat(pasteData[6].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonIRON', '');

          document.getElementById('MainContent_nonUPH').value = parseFloat(pasteData[7].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonUPH', '');

          document.getElementById('MainContent_nonFIT').value = parseFloat(pasteData[8].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonFIT', '');

          document.getElementById('MainContent_nonPAC').value = parseFloat(pasteData[9].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$nonPAC', '');

          ShowPopup('POR System', 'Đã copy xong');
      }
      function multiFieldPasteHandler2(e) {
          var rawPasted, pasteData = [], i;       
          e.preventDefault();
          rawPasted = getClipboardData(e);
          pasteData = processPasteData(rawPasted);

          document.getElementById('MainContent_addWO').value = parseFloat(pasteData[0].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addWO', '');

          document.getElementById('MainContent_addRM').value = parseFloat(pasteData[1].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addRM', '');

          document.getElementById('MainContent_addFM').value = parseFloat(pasteData[2].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addFM', '');

          document.getElementById('MainContent_addAS').value = parseFloat(pasteData[3].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addAS', '');

          document.getElementById('MainContent_addSA').value = parseFloat(pasteData[4].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addSA', '');

          document.getElementById('MainContent_addFIN').value = parseFloat(pasteData[5].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addFIN', '');

          document.getElementById('MainContent_addIRON').value = parseFloat(pasteData[6].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addIRON', '');

          document.getElementById('MainContent_addUPH').value = parseFloat(pasteData[7].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addUPH', '');

          document.getElementById('MainContent_addFIT').value = parseFloat(pasteData[8].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addFIT', '');

          document.getElementById('MainContent_addPAC').value = parseFloat(pasteData[9].split("\t")[0], 10);
          __doPostBack('ctl00$MainContent$addPAC', '');

          ShowPopup('POR System', 'Đã copy xong');
      }
   </script>
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
           
            <div style="padding-top: 20px">
                <div style="background-color: #e2dede; padding: 2px 20px; border-radius: 5px; height:120px">
                    <h2><a href="DailyTargetView.aspx">Production TARGET Setup</a></h2>
                    
                    <div style="width: 50%; float: left">
                        <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control" OnTextChanged="txtFromDate_TextChanged" AutoPostBack="True"></asp:TextBox>
                    </div>
                    <div style="width: 50%; float: right">
                        <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text ="Load" OnClick="btnLoad_Click"/>
                    </div>  
                </div>                       
            </div>
           <br />
            <div class="">
                <div class="work-progres">
                    <header class="widget-header">
                        <h4 id="txtDesciptionHeader" runat="server" class="widget-title">Production Daily Target Setup</h4>
                    </header>
                    <hr class="widget-separator">
                  
                    <div class="table-responsive">
                        <%--<table class ="table table-hover" runat="server" id="tbTargetSetup"></table>--%>
                        <asp:Table CssClass ="table table-hover" runat="server" ID="tbTargetSetup"></asp:Table>
                        <br />
                         <asp:Button CssClass="btn btn-danger" Style="margin-bottom: 10px" runat="server" ID="Button1" Text ="Clear Output Target" OnClick="Button1_Click" />
                    </div>
                </div>

                <hr class="widget-separator" runat="server" id="separator10" visible="false" />

                <div>
                    
                </div>
            </div>
        </ContentTemplate>
        
    </asp:UpdatePanel>
</asp:Content>

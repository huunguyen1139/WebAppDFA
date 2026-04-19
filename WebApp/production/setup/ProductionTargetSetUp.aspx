<%@ Page Title="Production Daily Target Setup" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ProductionTargetSetUp.aspx.cs" Inherits="WebApp.production.ProductionTargetSetUp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.111.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->
    <script src="/masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/dashboards/dashboard4.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

    <!-- Skin Material P -->


    <!-- select 2 -->
    <link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="/masterskin/monster/dist/select2/select2.min.js"></script>

    <!-- Export to Excel -->
    <script type="text/javascript" src="/masterskin/monster/dist/export2excel/jszip.min.js"></script>
    <script type="text/javascript" src="/masterskin/monster/dist/export2excel/FileSaver.min.js"></script>
    <script type="text/javascript" src="/masterskin/monster/dist/export2excel/excel-gen.js"></script>

    <!-- load sweet alert -->
    <%--<script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />--%>


    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Bootstrap -->
    <!-- Modal Popup -->
    <div id="divModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="ModalHeader" class="modal-header rounded-top modal-colored-header text-white">
                    <h4 class="modal-title text-white" id="warning-header-modalLabel">Modal Heading
                    </h4>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="modal-message">
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ShowPopup(title, body, class_style)
        {
            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").className = "modal-header rounded-top modal-colored-header text-white " + class_style;
        }

        function ShowToast(message, type)
        {
            Swal.fire({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                type: type,
                title: message
            });
        }
        
    </script>
    <!-- Modal Popup -->

    <script type="text/javascript">
        function Confirm_btnClearCompanyTarget() {
            event.preventDefault();
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to clear output target for selected date?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes! post it'
            }).then(function (result) {

                if (result.value) {
                    __doPostBack('<%= btnClearCompanyTarget.UniqueID %>', '');
                }
            });
            return false;
        }

        function Confirm_btnUpdateCompanyTarget() {
            event.preventDefault();
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to update output target for selected date?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes! post it'
            }).then(function (result) {

                if (result.value) {
                    __doPostBack('<%= btnUpdateCompanyTarget.UniqueID %>', '');
                }
            });
            return false;
        }

        function Confirm_btnUpdateMHUnitCost() {
            event.preventDefault();
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to update MH Unit Cost for selected date?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes! post it'
            }).then(function (result) {

                if (result.value) {
                    __doPostBack('<%= btnUpdateMHUnitCost.UniqueID %>', '');
                }
            });
            return false;
        }
    </script>

    <script type="text/javascript">

        //$("MainContent_btnPaste1").addEventListener
        //get raw data from clipboard

        document.getElementById("MainContent_btnLoad").addEventListener("click", multiFieldPasteHandler);

        function getClipboardData(e) {

            if (e.clipboardData) {
                return e.clipboardData.getData("text");
            }
            else if (window.clipboardData) {
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

            ShowPopup('POR System', 'Đã copy xong', 'bg-success');
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

            ShowPopup('POR System', 'Đã copy xong', 'bg-success');
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

            ShowPopup('POR System', 'Đã copy xong', 'bg-success');
        }
    </script>

    <script type="text/javascript">
        function ShowIndirectTargetPrompt() {
            Swal.fire({
                title: 'Calculate Indirect Target',
                input: 'number',
                inputLabel: 'Total Indirect Manpower',
                inputAttributes: {
                    min: '0',
                    step: '0.01'
                },
                showCancelButton: true,
                confirmButtonText: 'Calculate',
                cancelButtonText: 'Cancel',
                inputValidator: function (value) {
                    if (!value) return 'Please input total indirect manpower';
                    if (parseFloat(value) < 0) return 'Value must be greater than or equal to 0';
                    return null;
                }
            }).then(function (result) {
                if (result.isConfirmed) {
                    document.getElementById('<%= hfTotalIndirectManpower.ClientID %>').value = result.value;
                __doPostBack('<%= btnCalculateIndirectTarget.UniqueID %>', '');
            }
        });
        }
</script>

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div class="card">
                        <div class="card-body">
                            <h2><a href="DailyTargetView.aspx">Production TARGET Setup</a></h2>

                            <div style="width: 50%; float: left">
                                <asp:TextBox runat="server" Style="margin-bottom: 10px" ID="txtFromDate" TextMode="Date" Width="95%" CssClass="form-control" OnTextChanged="txtFromDate_TextChanged" AutoPostBack="True"></asp:TextBox>
                            </div>
                            <div style="width: 50%; float: right">
                                <asp:Button CssClass="btn btn-success" Style="margin-bottom: 10px" runat="server" ID="btnLoad" Text="Load" OnClick="btnLoad_Click" />
                            </div>
                        </div>
                    </div>

                    <div class="card mb-3 bg-transparent shadow-none">
                        <div class="button-group">
                            <button id="btnUpdateMHUnitCost" runat="server" type="button" class="mx-0 btn btn-success" onclick="return Confirm_btnUpdateMHUnitCost();" onserverclick="btnUpdateMHUnitCost_ServerClick" style="border-radius: 5px; float: right;">
                                <i class="ti ti-cloud-upload fs-4 me-2"></i>Update MHUnitCost
                            </button>
                            <button id="btnUpdateCompanyTarget" runat="server" type="button" class="btn btn-warning" onclick="return Confirm_btnUpdateCompanyTarget();" onserverclick="btnUpdateCompanyTarget_ServerClick" style="border-radius: 5px; float: right;">
                                <i class="ti ti-direction-sign fs-4 me-2"></i>Update Output Target
                            </button>
                            <button id="btnClearCompanyTarget" runat="server" type="button" class="btn btn-danger" onclick="return Confirm_btnClearCompanyTarget();" onserverclick="btnClearCompanyTarget_ServerClick" style="border-radius: 5px; float: right;">
                                <i class="ti ti-direction-sign fs-4 me-2"></i>Clear Output Target
                            </button>

                            <asp:HiddenField ID="hfTotalIndirectManpower" runat="server" />

                            <button type="button" class="btn btn-warning" onclick="ShowIndirectTargetPrompt();" style="border-radius: 5px; float: right;">
                                Calculate Indirect Target
                            </button>
                            <asp:Button ID="btnCalculateIndirectTarget" runat="server"
                            Style="display:none;"
                            OnClick="btnCalculateIndirectTarget_Click" />
                        </div>
                    </div>

                    <div class="">
                        <div class="work-progres">
                            <div class="table-responsive">                               
                                <asp:Table CssClass="tablerowsmall table-hover-old table-striped-old" runat="server" ID="tbTargetSetup"></asp:Table>
                            </div>
                            
                        </div>                      

                        <div>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>

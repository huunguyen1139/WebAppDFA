<%@ Page Title="Output Register" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="OutputRegister.aspx.cs" Inherits="WebApp.production.OutputRegister" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>

    <script src="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="../masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-ui.min.css" />
    <!-- Import Js Files -->
    <script src="../masterskin/MaterialPro/dist/assets/js/breadcrumb/breadcrumbChart.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/apexcharts/dist/apexcharts.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
    <%--<script src="../masterskin/MaterialPro/dist/assets/js/theme/ap1p.init.js"></script>--%>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="../masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

    <%-- select 2 --%>
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>

    <%-- load sweet alert --%>
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <script src="https://cdn.jsdelivr.net/npm/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
    
    <script type="text/javascript">
        function sweetAlertConfirmOutputPost() {
            event.preventDefault();
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to post production output?',
                type: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes! post it'
            }).then(function (result) {

                if (result.value) {
                    __doPostBack('<%= bt1.UniqueID %>', '');
                }
            });
            return false;
        }
    </script>
    <script type="text/javascript">
        function disableBtn(btnID, newText) {

            var btn = document.getElementById(btnID);
            setTimeout("setImage('" + btnID + "')", 1);
            btn.disabled = true;
            btn.value = newText;
        }

        function setImage(btnID) {
            var btn = document.getElementById(btnID);
            btn.style.background = 'url(images/loading.gif)';
            btn.style.backgroundColor = 'yellow';
            btn.style.backgroundRepeat = 'no-repeat';
            btn.style.backgroundPosition = 'center';
            btn.style.color = 'blue';
        }
    </script>
    <script type="text/javascript">
        function SearchPI() {
            $("#<%=txtPI.ClientID%>").autocomplete({
                source: '/GetPIList.ashx',
                select: function (event, ui) {
                    if (ui.item.label == '') {
                        return false;
                    }
                    $('#<%=ddPI.ClientID%>').val(ui.item.label);
                    $("#<%= hfPI.ClientID %>").val(ui.item.label);
                    //__doPostBack("<%# ddPI.ClientID %>", "");
                    document.getElementById('<%= btnHandleDocNo.ClientID %>').click();
                }
            });
        };

        $(document).ready(function () { SearchPI(); });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            SearchPI();
        });
    </script>

    <asp:HiddenField ID="hfSelectedKeys" runat="server" />

        <script>
            function getSet(hfId) {
                var v = document.getElementById(hfId).value || "";
                return v ? v.split(',').filter(x => x) : [];
            }
            function writeSet(hfId, arr) {
                document.getElementById(hfId).value = arr.join(',');
            }

            // row checkbox changed
            function rowToggle(chk, key, hfId) {
                var arr = getSet(hfId);
                if (chk.checked) {
                    if (arr.indexOf(key) < 0) arr.push(key);
                } else {
                    arr = arr.filter(x => x !== key);
                }
                writeSet(hfId, arr);
            }

            // header check-all
            function toggleAll(headerChk, gridId, hfId) {
                var gv = document.getElementById(gridId);
                if (!gv) return;
                var arr = [];
                var boxes = gv.querySelectorAll("input.row-check");
                boxes.forEach(function (cb) {
                    cb.checked = headerChk.checked;
                    var key = cb.getAttribute("data-key");
                    if (headerChk.checked && key) arr.push(key);
                });
                writeSet(hfId, arr);
            }
        </script>


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
        function ShowPopup(title, body, class_style) {

            $("#divModal .modal-title").html(title);
            $("#divModal .modal-message").html(body);
            $("#divModal").modal("show");
            document.getElementById("ModalHeader").className = "modal-header modal-colored-header text-white " + class_style;
        }
    </script>
    <!-- Modal Popup -->

    <!-- HTML SCAN QR CODE -->
    <script>
        let qrScanner = null;

        function wireQrModalEvents() {
            const modalEl = document.getElementById('qrModal');
            if (!modalEl) { console.warn('qrModal not found'); return; }
            
            modalEl.addEventListener('shown.bs.modal', startScanner);
            modalEl.addEventListener('hidden.bs.modal', stopScanner);
        }
       
        document.addEventListener('DOMContentLoaded', wireQrModalEvents);

        function startScanner() {
            
            if (qrScanner) return;
            const config = { fps: 10, qrbox: { width: 250, height: 250 } };
            const onScanSuccess = async (decodedText, decodedResult) => {
                // 1) Put the result into the ASP:TextBox
                document.getElementById('<%= txtPI.ClientID %>').value = decodedText;
                document.getElementById('<%= hfPI.ClientID %>').value = decodedText;

                // 2) Stop scanning and close modal
                await stopScanner();
                $("#qrModal").modal("hide");

                // 3) Trigger server postback to handle the result
                //__doPostBack('<%= btnHandleDocNo.ClientID %>', '');
                document.getElementById('<%= btnHandleDocNo.ClientID %>').click();
            };

            const onScanFailure = (error) => { /* ignore continuous scan errors */ };

            qrScanner = new Html5Qrcode("qr-reader");
            qrScanner.start(
                { facingMode: "environment" }, // back camera on phones
                config,
                onScanSuccess,
                onScanFailure
            ).catch(err => {
                console.error(err);
                alert("Unable to start camera. Check permissions or use HTTPS.");
            });
        }

        function stopScanner() {
            if (!qrScanner) return Promise.resolve();
            const s = qrScanner;
            qrScanner = null;
            return s.stop().then(() => s.clear()).catch(() => { });
        }
    </script>
    <!-- Bootstrap modal for camera scanner -->
    <div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Scan QR Code</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div id="qr-reader" style="width:100%"></div>
          </div>
        </div>
      </div>
    </div>

    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
                <div class="container-fluid">
                    <div style="padding-top: 20px">
                        <h2 class="title1">
                            <span id="MainContent_lbBBCL">Output Shipment</span>
                            <button type="button" class="btn btn-primary mt-0" data-bs-toggle="modal" data-bs-target="#qrModal" style="float: right; padding: 5px 12px;">
                              Scan QR
                            </button> 
                            <asp:Button runat="server" ID="btnHandleDocNo" CssClass="btn d-none" OnClick="btnHandleDocNo_Click"/>
                        </h2>

                        <div class="card mb-1">
                            <div class="card-body shadow-sm" style="background-color: #e2dede; border-radius: 5px">                                
                                <div class="py-2 pe-2" style="width: 30%; float: left">
                                    <asp:HiddenField ID="hfPI" runat="server" />
                                    <asp:TextBox runat="server" ID="txtPI" CssClass="form-control" Width="95%" Style="margin-bottom: 10px" Placeholder="Search PI"></asp:TextBox>

                                </div>
                                <div class="py-2 pe-2" style="width: 36%; float: left">
                                    <asp:DropDownList ID="ddPI" runat="server" CssClass="form-control" Width="95%" Style="margin-bottom: 10px" OnSelectedIndexChanged="ddPI_SelectedIndexChanged" AutoPostBack="True">
                                        <asp:ListItem Value="0">- Select PI</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="py-2" style="width: 34%; float: right">
                                    <asp:TextBox runat="server" ID="txtInputDate" TextMode="Date" Width="100%" CssClass="form-control"></asp:TextBox>
                                </div>

                                <asp:DropDownList ID="ddItemCode" runat="server" CssClass="form-control" Width="100%" Style="margin-bottom: 10px" OnSelectedIndexChanged="ddItemCode_SelectedIndexChanged" AutoPostBack="True">
                                    <asp:ListItem Value="0">- Select Item</asp:ListItem>
                                </asp:DropDownList>

                                <asp:Label runat="server" ID="lbProjectName" Text="Project: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                                <asp:Label runat="server" ID="lbItemGroup" Text="Item Group: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                                <asp:Label runat="server" ID="lbItemCode" Text="Item Code: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                                <asp:Label runat="server" ID="lbQuantity" Text="Quantity: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                                <asp:Label runat="server" ID="lbTimberFinish" Text="Timber Finish: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                                <asp:Label runat="server" ID="lbMetalFinish" Text="Metal Finish: " Width="100%" Style="margin-bottom: 8px"></asp:Label>
                                <%--<asp:Label runat="server" ID="lbRounding" Text="Rounding Interval: " Width="100%" Style="margin-bottom: 8px"></asp:Label>--%>
                                <asp:LinkButton runat="server" ID="lbtRounding" Text="Rounding Interval:" OnClick="lbtRounding_Click" Width="100%"></asp:LinkButton>
                                <asp:LinkButton runat="server" ID="lbnSubDelivery" Text="Odd delivery" OnClick="lbnSubDelivery_Click" Width="100%"></asp:LinkButton>
                            </div>
                        </div>
                        <br />
                        <%--Wood Selection--%>
                        <div class="form-inline mb-2" runat="server" id="divWO" visible="false" style="height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtWO" Width="95%" Text="WO" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtWOQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddWO" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toWO" runat="server" CssClass="form-control" Width="100%" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Rough Mill--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtRM" Width="95%" Text="RM" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtRMQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddRM" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toRM" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Fine Mill--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtFM" Width="95%" Text="FM" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtFMQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddFM" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toFM" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Assembly--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtAS" Width="95%" Text="AS" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtASQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddAS" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toAS" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Sanding--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtSA" Width="95%" Text="SA" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtSAQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddSA" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toSA" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Sanding--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtSP" Width="95%" Text="SP" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtSPQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddSP" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toSP" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>


                        <%--Finishing--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtFIN" Width="95%" Text="FIN" Enabled="False" BackColor="aqua"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtFINQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddFIN" runat="server" CssClass="form-control" Width="95%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toFIN" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--IRONNING--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtIRON" Width="95%" Text="IRON" Enabled="False" BackColor="aqua"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtIRONQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddIRON" runat="server" CssClass="form-control" Width="95%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toIRON" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--IRONNING DM--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtIRON_DM" Width="95%" Text="IRON_DM" Enabled="False" BackColor="aqua"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtIRON_DMQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddIRON_DM" runat="server" CssClass="form-control" Width="95%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toIRON_DM" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--UPH--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtUPH" Width="95%" Text="UPH" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtUPHQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddUPH" runat="server" CssClass="form-control" Width="95%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toUPH" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Fitting--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtFIT" Width="95%" Text="FIT" Enabled="False" BackColor="sandybrown"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtFITQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddFIT" runat="server" CssClass="form-control" Width="95%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toFIT" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--Fitting--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtTU" Width="95%" Text="TU" Enabled="False" BackColor="sandybrown"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtTUQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddTU" runat="server" CssClass="form-control" Width="95%" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toTU" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <%--PACKING--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtPAC" Width="95%" Text="PAC" Enabled="False" BackColor="sandybrown"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtPACQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddPAC" runat="server" CssClass="form-control" Width="95%" AutoPostBack="True" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toPAC" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <hr />

                        <%--THAU PHU--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtOT" Width="95%" Text="OT" Enabled="False" BackColor="SlateBlue"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtOTQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddOT" runat="server" CssClass="form-control" Width="95%" AutoPostBack="True" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toOT" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <hr />

                        <%--WAREHOUSE--%>
                        <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" CssClass="form-control" ID="txtWAREHOUSE" Width="95%" Text="WH" Enabled="False" BackColor="SpringGreen"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:TextBox runat="server" ID="txtWAREHOUSEQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                            </div>
                            <div style="width: 25%; float: left">
                                <asp:DropDownList ID="ddWAREHOUSE" runat="server" CssClass="form-control" Width="95%" AutoPostBack="True" OnSelectedIndexChanged="ddDepartment_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div style="width: 25%; float: right">
                                <asp:DropDownList ID="toWAREHOUSE" runat="server" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>

                        <br />
                        <p id="lbEstimateTotalValue" runat="server" style="color: crimson; padding: 10px 10px; background-color: blanchedalmond; width: 100%"></p>

                        <%--<asp:Label runat="server" ID ="lbEstimateTotalValue" ForeColor="Crimson" Style="color: crimson; padding: 10px 10px; background-color:blanchedalmond; width:100%"></asp:Label>--%>
                        <asp:HiddenField runat="server" ID="hfSalePrice" Value="0" />
                        <asp:HiddenField runat="server" ID="hfProdOrderQty" Value="0" />
                        <asp:HiddenField runat="server" ID="hfRoundingInterval" Value="1" />

                        <div class="table-responsive border rounded-1 mb-4">
                            <asp:GridView runat="server" ID="gvRelatedProdOrder" OnRowDataBound="gvRelatedProdOrder_RowDataBound" Width="100%" Visible="False" Caption="Production Output Detail"
                                CssClass="table mb-0 fs-2 table-h1over table-striped text-nowrap table-bordered" EmptyDataText="No records found">
                                <HeaderStyle CssClass="table-primary" />
                            </asp:GridView>
                        </div>

                        <asp:Button runat="server" ID="bt1" Text="Submit" CssClass="btn btn-success" OnClientClick="return sweetAlertConfirmOutputPost();" OnClick="bt1_Click" CausesValidation="False" UseSubmitBehavior="false" />
                        <hr class="widget-separator" runat="server" id="separator10" />
                        
                        <div>
                            <asp:LinkButton runat="server" ID="linkAddNewNote" Text="Click here to add new note" OnClick="linkAddNewNote_Click" Visible="False"></asp:LinkButton>
                            <asp:TextBox runat="server" ID="txtNewNote" CssClass="form-control" Style="width: 100%; margin-bottom: 10px" PlaceHolder="Add new note here" Visible="False"></asp:TextBox>
                            <asp:Button runat="server" ID="btnAddNewNote" CssClass="btn btn-warning" CausesValidation="false" Text="Add new note" Visible="False" OnClick="btnAddNewNote_Click" />
                            <br />
                            <hr class="widget-separator" runat="server" id="Hr1" visible="false" />
                            <asp:GridView runat="server" ID="gvNoteList" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Note" CssClass="tablerowsmall table-hover table-striped" EmptyDataText="No records found">
                                <HeaderStyle BackColor="Aqua" BorderColor="#E3E6E3" />
                            </asp:GridView>
                        </div>

                    </div>
                </div>
            </div>
        </ContentTemplate>

    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
        <ProgressTemplate>
            <div class="modal1">
                <div class="center1">
                    <img alt="" src="https://www.aspsnippets.com/Demos/loader4.gif" />
                </div>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ScanProdOrder.aspx.cs" Inherits="WebApp.tools.ScanProdOrder" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
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

    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>

    <!-- select 2 -->
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>


    <!-- load sweet alert -->
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <script src="https://cdn.jsdelivr.net/npm/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>

    <script>
        function wireQrModalEvents() {                      
            // Camera controls
            document.getElementById('btnSwitchCam').addEventListener('click', switchCamera);
            document.getElementById('btnStopCam').addEventListener('click', stopScanner);
            document.getElementById('btnStartCam').addEventListener('click', startCurrentCamera);

            // Modal lifecycle: start scanning when opened; stop when closed
            const scanModal = document.getElementById('scanModal');
            scanModal.addEventListener('shown.bs.modal', () => { initScanner(); });
            scanModal.addEventListener('hide.bs.modal', () => { stopScanner(); });

            // Manual submit
            document.getElementById('btnSubmitManual').addEventListener('click', function () {
                const v = (document.getElementById('txtManual').value || '').trim();
                if (!v) { Swal.fire({ icon: 'info', text: 'Please enter ProdOrderNo' }); return; }
                stopScanner().finally(() => {
                    document.getElementById('txtLast').value = v;
                    document.getElementById('txtManual').value = '';
                    postUpsert(v);
                });
            });
            
        }

        document.addEventListener('DOMContentLoaded', wireQrModalEvents);


        let html5QrCode = null;
        let cameraIds = [];
        let currentCamIdx = 0;
        let isScanning = false;

        

        function setStatus(text, muted = false) {
            document.getElementById('scanStatus').innerHTML = 'Status: ' + (muted ? ('<span class="text-muted">' + text + '</span>') : text);
        }

        async function initScanner() {
            alert('init');
            //if (html5QrCode) return;
           
            html5QrCode = new Html5Qrcode("qr-reader");
            try {
                cameraIds = await Html5Qrcode.getCameras();
                if (!cameraIds || cameraIds.length === 0) { setStatus("No camera found"); return; }
                currentCamIdx = 0;
                await startCurrentCamera();
            } catch (e) {
                console.error(e); setStatus("Failed to init camera: " + (e && e.message ? e.message : e));
            }
        }

        async function startCurrentCamera() {
            
            if (!html5QrCode) return;
            const cam = cameraIds[currentCamIdx];
            if (!cam) { setStatus("No camera selected"); return; }
            const config = { fps: 12, qrbox: { width: 300, height: 300 }, aspectRatio: 1.333 };
            await html5QrCode.start(
                { facingMode: "environment" }, config,
                onScanSuccess,
                () => { } // ignore scan failures
            );
            isScanning = true;
            setStatus("Scanning on " + (cam.label || cam.id), true);
            
        }

        async function stopScanner() {           
            if (html5QrCode && isScanning) {
                try { await html5QrCode.stop(); } catch { }
                isScanning = false;
                setStatus("Stopped", true);
            }
        }

        async function switchCamera() {           
            if (!cameraIds || cameraIds.length < 2) { setStatus("Only one camera available", true); return; }
            await stopScanner();
            currentCamIdx = (currentCamIdx + 1) % cameraIds.length;
            await startCurrentCamera();
        }

        
        function postUpsert(prodOrderNo) {
            Swal.fire({
                title: "Confirm Scan",
                text: "Do you want to save this ProdOrderNo: " + prodOrderNo + "?",
                type: "question",
                showCancelButton: true,
                confirmButtonText: "Yes, save it",
                cancelButtonText: "No, cancel",
                reverseButtons: true,
                allowOutsideClick: false
            }).then((result) => {
                if (result.value) {
                    // Set hidden field value and trigger ASP.NET hidden button
                    document.getElementById('<%= hfProdOrderNo.ClientID %>').value = prodOrderNo;
                    document.getElementById('<%= btnUpload.ClientID %>').click();
                } else {
                    Swal.fire({
                        type: "info",
                        title: "Cancelled",
                        text: "Scan was not saved.",
                        timer: 1200,
                        showConfirmButton: false
                    });
                }
            });
        }


        function onScanSuccess(decodedText) {            
            const order = (decodedText || "").trim();
            if (!order) return;

            // Prevent rapid duplicate submits on continuous detection
            stopScanner().finally(() => {
                var lst = document.getElementById('txtLast')                
                lst.value = order;               
                postUpsert(order);
                // Restarting is handled after async postback completes (see endRequest below)
            });
        }

       

        

        // After each async postback (hidden button click), show toast and restart camera
        if (window.Sys && Sys.WebForms) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function (sender, args) {
                // Server may inject a script for toast; we just ensure scanner restarts.
                startCurrentCamera();
            });
        }

    </script>
    <!-- Modal Popup -->

    <div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Scan QR Code</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="qr-reader1" style="width: 100%"></div>
            </div>
        </div>
    </div>
</div>

    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
        <div class="container-fluid">
            <div class="container mt-5">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0">Scan Production Order</h3>
                   
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#scanModal">
    Open Scanner
</button>
                </div>

               <%-- <div class="card mb-3">
                    <div class="card-body">
                        <p class="text-muted mb-1">QR must encode only <code>ProdOrderNo</code> (max 20 chars).</p>
                        <ul class="mb-0">
                            <li>New order → insert with <strong>CreatedDate</strong> and <strong>UpdatedDate</strong>.</li>
                            <li>Existing order → only <strong>UpdatedDate</strong> is refreshed.</li>
                            <li>Fields <code>TransferDate</code>, <code>ReceiptDate</code>, <code>Remark</code> remain <em>NULL</em> on insert.</li>
                        </ul>
                    </div>
                </div>--%>

                <!-- Async postback zone with hidden controls -->
                <asp:UpdatePanel ID="up1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:HiddenField ID="hfProdOrderNo" runat="server" />
                        <!-- Hidden submit button: we click this from JS after each scan -->
                        <asp:Button ID="btnUpload" runat="server" CssClass="d-none" OnClick="btnUpload_Click" UseSubmitBehavior="false" />
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnUpload" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
                <!-- Scan Modal (stays open; backdrop static to avoid accidental close) -->
    <div class="modal fade" id="scanModal" tabindex="-1" aria-labelledby="scanModalLabel"
         aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="scanModalLabel">Scan QR (ProdOrderNo)</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" id="btnCloseModal"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="col-12 col-md-7">
                <div id="qr-reader" class="qr-box border rounded"></div>
              </div>
              <div class="col-12 col-md-5">
                <div class="mb-3">
                  <label class="form-label">Last scanned</label>
                  <input type="text" class="form-control" id="txtLast" readonly />
                </div>

                <div class="mb-3">
                  <label class="form-label">Manual entry (optional)</label>
                  <div class="input-group">
                    <input type="text" class="form-control" id="txtManual" placeholder="Enter ProdOrderNo" />
                    <button class="btn btn-outline-primary" type="button" id="btnSubmitManual">Submit</button>
                  </div>
                </div>

                <div class="d-grid gap-2">
                  <button class="btn btn-secondary" type="button" id="btnSwitchCam">Switch Camera</button>
                  <button class="btn btn-outline-danger" type="button" id="btnStopCam">Stop Camera</button>
                  <button class="btn btn-outline-success" type="button" id="btnStartCam">Start Camera</button>
                </div>

                <div class="mt-3 qr-status" id="scanStatus">Status: <span class="text-muted">Idle</span></div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <small class="text-muted me-auto">Scanner stays open so you can continue scanning.</small>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
                

            </div>

        </div>
    </div>

</asp:Content>

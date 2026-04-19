<%@ Page Title="Production Order Tracing" Language="C#" MasterPageFile="~/SkinMaterialPro.Master" AutoEventWireup="true" CodeBehind="ProdOrderTracing.aspx.cs" Inherits="WebApp.production.ProdOrderTracing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Skin Maretial P -->
    <link rel="stylesheet" href="/masterskin/MaterialPro/dist/assets/css/styles.css" />
    <script src="/masterskin/MaterialPro/dist/assets/libs/jquery/dist/jquery-3.7.1.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/vendor.min.js"></script>
    <!-- Import Js Files -->

    <script src="/masterskin/MaterialPro/dist/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/libs/simplebar/dist/simplebar.min.js"></script>
     
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/theme.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/app.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/sidebarmenu.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/theme/feather.min.js"></script>

    <script src="/masterskin/MaterialPro/dist/assets/libs/jvectormap/jquery-jvectormap.min.js"></script>
    <script src="/masterskin/MaterialPro/dist/assets/js/extra-libs/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- solar icons -->
    <script src="https://cdn.jsdelivr.net/npm/iconify-icon@1.0.8/dist/iconify-icon.min.js"></script>
    <!-- Skin Material P -->

    <!-- select 2 -->
    <link href="/masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="/masterskin/monster/dist/select2/select2.min.js"></script>

    <!-- load sweet alert -->
    <script src="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="/masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />
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
    <!-- Modal Popup -->
    <div id="divModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div id="ModalHeader" class="modal-header modal-colored-header text-white">
                    <h4 class="modal-title" id="warning-header-modalLabel">Modal Heading
                    </h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
            document.getElementById("ModalHeader").classList.add(class_style);
        }
    </script>
    <script type="text/javascript">
        function RemovePreviousChart() {
            location.reload();
        }
    </script>
    <script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(BeginRequestHandler);
        function BeginRequestHandler(sender, args) { var oControl = args.get_postBackElement(); oControl.disabled = true; }

    </script>    

   
    <div class="body-wrapper" style="display: block; min-height: calc(100vh - 53px);">
        <div class="container-fluid">

            <hr class="widget-separator" runat="server" id="separator10" visible="false" />

            <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                <ContentTemplate>
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-muted small">Output view</span>

                            <div class="btn-group btn-group-sm" role="group" aria-label="Output view">
                                <asp:LinkButton ID="btnViewDetail" runat="server"
                                    CssClass="btn btn-outline-primary"
                                    OnClick="btnViewDetail_Click"
                                    >
                                <i class="ti ti-list-details me-1"></i> Detail
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnViewGroup" runat="server"
                                    CssClass="btn btn-outline-primary"
                                    OnClick="btnViewGroup_Click"
                                    UseSubmitBehavior="false">
                                <i class="ti ti-layout-grid me-1"></i> Group by Dept
                                </asp:LinkButton>
                            </div>
                        </div>

                        
                        <span class="badge bg-light text-dark border" id="lblViewHint" runat="server">Showing detail lines
                        </span>
                    </div>

                    <asp:HiddenField ID="hfOutputView" runat="server" Value="DETAIL" />

                    <div class="table-responsive"> 
                        <asp:GridView runat="server" ID="gvDetailOutput" Width="100%" Visible="False" BorderColor="#E3E6E3" Caption="Production Output Tracing" 
                            CssClass="table mb-0 fs-2 table-h1over table-striped text-nowrap table-bordered" EmptyDataText="No records found">
                            <HeaderStyle  CssClass="table-primary" />
                            <RowStyle CssClass="border-1" />
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>


            <%----------------BEGIN PRODUCTION IMAGE UPLOAD AND SHOW--%>
            <!-- ===== Production Order Images ===== -->
            <div class="card mt-3">
                <div class="card-header d-flex align-items-center justify-content-between">
                    <div>
                        <strong>Images</strong>
                        <small runat="server" class="text-muted ms-2" id="txtProdOrderNo"></small>
                    </div>
                </div>

                <div class="card-body">
                    <div class="row g-2 align-items-end">
                        <div class="col-12 col-md-8">
                            <asp:FileUpload ID="fuProdOrderImages" runat="server" CssClass="form-control" AllowMultiple="true" />
                            
                        </div>
                        <div class="col-12 col-md-4 text-md-end">
                            <asp:Button ID="btnUploadImages" runat="server" CssClass="btn btn-primary"
                                Text="Upload Images" OnClick="btnUploadImages_Click" UseSubmitBehavior="false" />
                        </div>
                    </div>

                    <hr />
                    <asp:UpdatePanel runat="server" ID="UpdatePanelProdOrderImage">
                        <ContentTemplate>
                            <!-- Thumbnail gallery -->
                            <%--<asp:Repeater ID="rpProdOrderImages" runat="server">
                                <HeaderTemplate>
                                    <div class="d-flex gap-2 flex-wrap prod-img-grid">
                                </HeaderTemplate>

                                <ItemTemplate>
                                    <a href="javascript:void(0)"
                                        class="prod-img-tile"
                                        onclick="openProdImage('<%# Eval("Url") %>','<%# Eval("FileName") %>');"
                                        title="<%# Eval("FileName") %>">
                                        <img src="<%# Eval("Url") %>" alt="<%# Eval("FileName") %>" loading="lazy" />
                                    </a>
                                </ItemTemplate>

                                <FooterTemplate>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>--%>

                            <!-- ===== Agoda/Booking-style Gallery ===== -->
                            <asp:Panel ID="pnlGallery" runat="server" Visible="false">
                                <div class="por-gallery">
                                    <!-- Main preview -->
                                    <div class="por-gallery-main position-relative">
                                        <div id="porCarousel" class="carousel slide" data-bs-ride="false" data-bs-touch="true">
                                            <div class="carousel-inner">
                                                <asp:Repeater ID="rpMainCarousel" runat="server">
                                                    <ItemTemplate>
                                                        <div class="carousel-item <%# Eval("ActiveClass") %>">
                                                            <img class="d-block w-100 por-main-img"
                                                                src="<%# Eval("Url") %>"
                                                                alt="<%# Eval("FileName") %>"
                                                                loading="lazy"
                                                                onclick="porOpenLightbox(<%# Eval("Idx") %>);" />

                                                            <%--<div class="por-zoom-container">
                                                                                    <img class="por-main-img por-zoom-img"
                                                                                        src="<%# Eval("Url") %>"
                                                                                        data-zoom="<%# Eval("Url") %>"
                                                                                        alt="<%# Eval("FileName") %>"
                                                                                        onclick="porOpenLightbox(<%# Eval("Idx") %>);" />
                                                                                    <div class="por-zoom-lens"></div>
                                                                                </div>--%>
                                                            <div class="por-upload-info">
                                                                <%# Eval("UploadedInfo") %>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </div>

                                            <button class="carousel-control-prev" type="button" data-bs-target="#porCarousel" data-bs-slide="prev">
                                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                                <span class="visually-hidden">Previous</span>
                                            </button>
                                            <button class="carousel-control-next" type="button" data-bs-target="#porCarousel" data-bs-slide="next">
                                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                                <span class="visually-hidden">Next</span>
                                            </button>
                                        </div>

                                        <!-- “Open” hint like booking -->
                                        <div class="por-gallery-openhint" onclick="porOpenLightbox(0);">
                                            View photos
                                        </div>

                                        <div class="por-gallery-counter" id="porGalleryCounter">
                                            1 / <%= rpMainCarousel.Items.Count %>
                                        </div>

                                        <button class="por-btn por-btn-download" onclick="porDownloadCurrent(); return false;">
                                            ⬇ Download
                                        </button>

                                    </div>

                                    <!-- Thumbnails strip -->
                                    <div class="por-thumbs-wrap mt-2">
                                        <div class='por-thumbs <%# (CanReorder ? "can-reorder" : "no-reorder") %>' id="porThumbs">
                                            <asp:Repeater ID="rpThumbs" runat="server">
                                                <ItemTemplate>
                                                    <%--<button type="button"
                                                                        class="por-thumb <%# Eval("ActiveClass") %>"
                                                                        data-bs-target="#porCarousel"
                                                                        data-bs-slide-to="<%# Eval("Idx") %>"
                                                                        aria-current="<%# Eval("AriaCurrent") %>"
                                                                        aria-label="Slide <%# (Convert.ToInt32(Eval("Idx")) + 1) %>">
                                                                        <img src="<%# Eval("Url") %>" alt="<%# Eval("FileName") %>" loading="lazy" />
                                                                    </button>--%>
                                                    <div class="por-thumb-wrap"
                                                        <%# (CanReorder ? "draggable=\"true\"" : "") %>
                                                        data-id="<%# Eval("ImageId") %>">

                                                        <button type="button"
                                                            class="por-thumb <%# Eval("ActiveClass") %>"
                                                            data-bs-target="#porCarousel"
                                                            data-bs-slide-to="<%# Eval("Idx") %>">
                                                            <img src="<%# Eval("Url") %>" draggable="false" />
                                                        </button>

                                                        <span class="por-thumb-del"
                                                            style='<%# (CanDelete ? "": "display:none;") %>'
                                                            onclick="porDeleteImage(<%# Eval("ImageId") %>); event.stopPropagation();">✕
                                                        </span>
                                                    </div>

                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>
                            <asp:LinkButton ID="lbSaveImageOrder" runat="server"
                                OnClick="lbSaveImageOrder_Click" Style="display: none" />

                            <asp:LinkButton ID="lbDeleteImage" runat="server"
                                OnClick="lbDeleteImage_Click" Style="display: none" />


                            <asp:Panel ID="Panel1" runat="server" Visible="false" CssClass="text-muted">
                                No images uploaded for this Production Order.
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <!-- ===== Lightbox Modal (Full screen) ===== -->
                    <div class="modal fade" id="porLightbox" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-fullscreen">
                            <div class="modal-content por-lightbox">
                                <div class="modal-header border-0">
                                    <div class="modal-title text-white" id="porLightboxTitle">Photos</div>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <div class="modal-body pt-0">
                                    <div id="porModalCarousel" class="carousel slide" data-bs-ride="false" data-bs-touch="true">
                                        <div class="carousel-inner">
                                            <asp:Repeater ID="rpModalCarousel" runat="server">
                                                <ItemTemplate>
                                                    <div class="carousel-item <%# Eval("ActiveClass") %>">
                                                        <div class="por-modal-imgwrap">
                                                            <img class="por-modal-img"
                                                                src="<%# Eval("Url") %>"
                                                                alt="<%# Eval("FileName") %>" />
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>

                                        <button class="carousel-control-prev" type="button" data-bs-target="#porModalCarousel" data-bs-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Previous</span>
                                        </button>
                                        <button class="carousel-control-next" type="button" data-bs-target="#porModalCarousel" data-bs-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="visually-hidden">Next</span>
                                        </button>
                                    </div>
                                </div>

                                <div class="modal-footer border-0 justify-content-center">
                                    <small class="text-white-50">Use ← → keys to navigate. ESC to close.</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <style>
                        .por-upload-info {
                            position: absolute;
                            left: 12px;
                            top: 12px;
                            padding: 6px 10px;
                            border-radius: 10px;
                            background: rgba(0,0,0,.55);
                            color: #fff;
                            font-size: 12px;
                            max-width: 75%;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        #porCarousel .carousel-item {
                            position: relative;
                        }


                        /* Prevent native dragging of images/links inside thumbs */
                        .por-thumbs img, .por-thumbs a {
                            -webkit-user-drag: none;
                            user-select: none;
                        }

                        .por-gallery-main {
                            border-radius: 14px;
                            overflow: hidden;
                            background: #f3f4f6;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .por-main-img {
                            width: 100%;
                            max-height: 520px; /* desktop max height */
                            height: auto; /* auto by image ratio */
                            object-fit: contain; /* KEY: show full image */
                            background-color: #f3f4f6; /* Agoda-style gray */
                            cursor: zoom-in;
                        }

                        @media (max-width: 768px) {
                            .por-main-img {
                                max-height: 320px;
                            }
                        }


                        .por-gallery-openhint {
                            position: absolute;
                            right: 12px;
                            bottom: 12px;
                            padding: 6px 10px;
                            border-radius: 10px;
                            background: rgba(0,0,0,.55);
                            color: #fff;
                            font-size: 13px;
                            cursor: pointer;
                            user-select: none;
                        }

                        .por-gallery-counter {
                            position: absolute;
                            left: 12px;
                            bottom: 12px;
                            padding: 6px 10px;
                            border-radius: 10px;
                            background: rgba(0,0,0,.55);
                            color: #fff;
                            font-size: 13px;
                        }


                        .por-thumbs-wrap {
                            overflow-x: auto;
                        }

                        .por-thumbs {
                            display: flex;
                            gap: 10px;
                            padding-bottom: 4px;
                        }

                        .por-thumb {
                            width: 96px;
                            height: 70px;
                            border: 2px solid transparent;
                            border-radius: 12px;
                            padding: 0;
                            overflow: hidden;
                            background: #f3f4f6;
                            flex: 0 0 auto;
                            cursor: pointer;
                        }

                            .por-thumb img {
                                width: 100%;
                                height: 100%;
                                object-fit: cover;
                            }

                            .por-thumb.active {
                                border-color: rgba(13,110,253,.9);
                            }

                        .por-lightbox {
                            background: rgba(0,0,0,.92);
                        }

                        .por-modal-imgwrap {
                            height: calc(100vh - 120px);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .por-modal-img {
                            max-width: 96vw;
                            max-height: calc(100vh - 140px);
                            object-fit: contain;
                        }

                        .por-zoom-container {
                            position: relative;
                            overflow: hidden;
                            background: #f3f4f6;
                        }

                        .por-zoom-img {
                            width: 100%;
                            max-height: 520px;
                            object-fit: contain;
                            cursor: zoom-in;
                        }

                        .por-zoom-lens {
                            position: absolute;
                            border: 2px solid rgba(255,255,255,.9);
                            width: 120px;
                            height: 120px;
                            border-radius: 50%;
                            display: none;
                            pointer-events: none;
                            background-repeat: no-repeat;
                            background-size: 200% 200%;
                            box-shadow: 0 0 12px rgba(0,0,0,.25);
                        }

                        .por-btn {
                            position: absolute;
                            top: 12px;
                            padding: 6px 10px;
                            border-radius: 10px;
                            background: rgba(0,0,0,.6);
                            color: #fff;
                            border: none;
                            font-size: 13px;
                            cursor: pointer;
                        }

                        .por-btn-download {
                            right: 12px;
                        }
                    </style>

                    <script>
                        (function () {
                            // Prevent duplicate binding after partial postbacks
                            function porInitCarousel() {
                                var mainEl = document.getElementById('porCarousel');
                                if (!mainEl) return;

                                // If already initialized/bound for this DOM instance, stop
                                if (mainEl.dataset.porBound === "1") return;
                                mainEl.dataset.porBound = "1";

                                // Create/get instance
                                bootstrap.Carousel.getOrCreateInstance(mainEl, { interval: false, ride: false, touch: true });

                                // One handler does both: thumb active + counter update
                                mainEl.addEventListener('slid.bs.carousel', function (e) {
                                    // 1) Thumbs active sync
                                    var to = e.to;
                                    document.querySelectorAll('.por-thumb').forEach(function (b) { b.classList.remove('active'); });

                                    var t = document.querySelector('.por-thumb[data-bs-slide-to="' + to + '"]');
                                    if (t) {
                                        t.classList.add('active');
                                        try { t.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' }); } catch (ex) { }
                                    }

                                    // 2) Counter
                                    var total = document.querySelectorAll('#porCarousel .carousel-item').length;
                                    var c = document.getElementById('porGalleryCounter');
                                    if (c) c.innerText = (to + 1) + ' / ' + total;
                                });

                                // Also set counter on init (first load / after refresh)
                                try {
                                    var total0 = document.querySelectorAll('#porCarousel .carousel-item').length;
                                    var c0 = document.getElementById('porGalleryCounter');
                                    if (c0) c0.innerText = (total0 > 0 ? "1 / " + total0 : "");
                                } catch (ex) { }
                            }

                            // Runs on first page load AND every UpdatePanel partial postback
                            if (window.Sys && Sys.Application) {
                                Sys.Application.add_load(function () {
                                    porInitCarousel();
                                });
                            } else {
                                // Fallback if ScriptManager isn't present
                                document.addEventListener('DOMContentLoaded', porInitCarousel);
                            }
                        })();
                    </script>

                    <script>
                        document.addEventListener('dragstart', e => {
                            if (!window.porPerms || !porPerms.canReorder) return;
                            const el = e.target.closest('.por-thumb-wrap');
                            if (!el || el.getAttribute('draggable') !== 'true') return;
                            dragSrc = el;
                            e.dataTransfer.effectAllowed = 'move';
                        });

                        

                        function porOpenLightbox(startIndex) {
                            var modalEl = document.getElementById('porLightbox');
                            var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                            modal.show();

                            // When modal is shown, jump to the selected slide
                            modalEl.addEventListener('shown.bs.modal', function onShown() {
                                modalEl.removeEventListener('shown.bs.modal', onShown);

                                var carEl = document.getElementById('porModalCarousel');
                                var car = bootstrap.Carousel.getOrCreateInstance(carEl, { interval: false, ride: false, touch: true });
                                car.to(startIndex || 0);
                            });
                        }

                        // Keyboard navigation for lightbox
                        document.addEventListener('keydown', function (e) {
                            var modalEl = document.getElementById('porLightbox');
                            if (!modalEl || !modalEl.classList.contains('show')) return;

                            var carEl = document.getElementById('porModalCarousel');
                            var car = bootstrap.Carousel.getOrCreateInstance(carEl, { interval: false, ride: false, touch: true });

                            if (e.key === 'ArrowLeft') { e.preventDefault(); car.prev(); }
                            if (e.key === 'ArrowRight') { e.preventDefault(); car.next(); }
                        });
                    </script>

                    <script>
                        document.addEventListener('mousemove', function (e) {
                            const img = e.target.closest('.por-zoom-img');
                            if (!img) return;

                            const lens = img.parentElement.querySelector('.por-zoom-lens');
                            const rect = img.getBoundingClientRect();

                            const x = e.clientX - rect.left;
                            const y = e.clientY - rect.top;

                            if (x < 0 || y < 0 || x > rect.width || y > rect.height) {
                                lens.style.display = 'none';
                                return;
                            }

                            lens.style.display = 'block';
                            lens.style.left = (x - lens.offsetWidth / 2) + 'px';
                            lens.style.top = (y - lens.offsetHeight / 2) + 'px';

                            const fx = (x / rect.width) * 100;
                            const fy = (y / rect.height) * 100;

                            lens.style.backgroundImage = `url('${img.dataset.zoom}')`;
                            lens.style.backgroundPosition = `${fx}% ${fy}%`;
                        });

                        document.addEventListener('mouseleave', function (e) {
                            if (e.target.classList.contains('por-zoom-img')) {
                                const lens = e.target.parentElement.querySelector('.por-zoom-lens');
                                if (lens) lens.style.display = 'none';
                            }
                        });
                    </script>

                    <script>
                        /*get active slide URL*/
                        function porDownloadCurrent() {
                            const activeImg = document.querySelector('#porCarousel .carousel-item.active img');
                            if (!activeImg) return;

                            const a = document.createElement('a');
                            a.href = activeImg.src;
                            a.download = activeImg.alt || 'image';
                            document.body.appendChild(a);
                            a.click();
                            document.body.removeChild(a);
                        }
                    </script>

                    <script>
                        /*Drag - to - reorder JavaScript*/
                        let dragSrc = null;

                        document.addEventListener('dragstart', e => {
                            const el = e.target.closest('.por-thumb-wrap');
                            if (!el) return;
                            dragSrc = el;
                            e.dataTransfer.effectAllowed = 'move';
                        });

                        document.addEventListener('dragover', e => {
                            if (e.target.closest('.por-thumb-wrap')) e.preventDefault();
                        });

                        document.addEventListener('drop', e => {
                            const tgt = e.target.closest('.por-thumb-wrap');
                            if (!dragSrc || !tgt || dragSrc === tgt) return;

                            tgt.parentNode.insertBefore(dragSrc, tgt);
                            porSaveSortOrder();
                        });
                    </script>

                    <script>
                        /*CALL BACK ASP.NET Backend*/
                        function porSaveSortOrder() {
                            const ids = Array.from(document.querySelectorAll('.por-thumb-wrap'))
                                .map((el, i) => el.dataset.id + ':' + i)
                                .join('|');
                            alert(ids);
                            __doPostBack('<%= lbSaveImageOrder.UniqueID %>', ids);
                        }
                    </script>
                    <script>
                        function porDeleteImage(id) {
                            if (!confirm('Delete this image?')) return;
                            __doPostBack('<%= lbDeleteImage.UniqueID %>', String(id));
                        }
                    </script>


                    <asp:Panel ID="pnlNoImages" runat="server" Visible="false" CssClass="text-muted">
                        No images uploaded for this Production Order.
                    </asp:Panel>

                </div>

            </div>

            <!-- Zoom Modal (Bootstrap 5) -->
            <div class="modal fade" id="mdlProdImage" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="mdlProdImageTitle">Image</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body p-2 text-center">
                            <img id="mdlProdImageImg" src="" alt="" style="max-width: 100%; max-height: 80vh;" />
                        </div>
                    </div>
                </div>
            </div>

            <style>
                /* Make main carousel move quickly */
                #porCarousel .carousel-item {
                    transition: transform .3s ease-in-out;
                }

                /* Optional: make modal carousel also fast */
                #porModalCarousel .carousel-item {
                    transition: transform .3s ease-in-out;
                }

                .por-thumb-wrap {
                    position: relative;
                }

                .por-thumb-del {
                    position: absolute;
                    top: -6px;
                    right: -6px;
                    background: #dc3545;
                    color: #fff;
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    font-size: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                }

                .prod-img-grid {
                }

                .prod-img-tile {
                    width: 160px;
                    height: 120px;
                    border-radius: 10px;
                    overflow: hidden;
                    display: inline-flex;
                    border: 1px solid rgba(0,0,0,.08);
                    background: #f8f9fa;
                    cursor: zoom-in;
                }

                    .prod-img-tile img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                        transition: transform .15s ease-in-out;
                    }

                    .prod-img-tile:hover img {
                        transform: scale(1.04);
                    }
            </style>

            <script>
                function openProdImage(url, title) {
                    document.getElementById('mdlProdImageImg').src = url;
                    document.getElementById('mdlProdImageTitle').innerText = title || 'Image';
                    var modal = new bootstrap.Modal(document.getElementById('mdlProdImage'));
                    modal.show();
                }
            </script>

            <%----------------END PRODUCTION IMAGE UPLOAD AND SHOW--%>



            <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                <ContentTemplate>
                    <%--BEGIN SUB PRODUCTION PART OUTPUT--%>
                    <div class="row">
                        <div class="py-2" style="width: 34%; float: right">
                            <asp:TextBox runat="server" ID="txtInputDate" TextMode="Date" Width="100%" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <%--Rough Mill--%>
                    <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtRMBOARD" Width="95%" Text="RM-BOARD" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" ID="txtRMBOARDQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:DropDownList ID="ddRMBOARD" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div style="width: 25%; float: right">
                            <asp:DropDownList ID="toRMBOARD" runat="server" CssClass="form-control" Width="100%">
                                <asp:ListItem Value="FM-BOARD" Text="FM-BOARD" Selected="True"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <%--Fine Mill--%>
                    <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtRMTIMBER" Width="95%" Text="RM-TIMBER" Enabled="False" BackColor="#FFFF66"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" ID="txtRMTIMBERQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:DropDownList ID="ddRMTIMBER" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div style="width: 25%; float: right">
                            <asp:DropDownList ID="toRMTIMBER" runat="server" CssClass="form-control" Width="100%">
                                <asp:ListItem Value="FMTIMBER" Text="FM-TIMBER" Selected="True"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtFMBOARD" Width="95%" Text="FM-BOARD" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" ID="txtFMBOARDQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:DropDownList ID="ddFMBOARD" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div style="width: 25%; float: right">
                            <asp:DropDownList ID="toFMBOARD" runat="server" CssClass="form-control" Width="100%">
                                <asp:ListItem Value="AS" Text="AS" Selected="True"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-inline mb-2" style="/* padding: 0px 20px 10px 20px; */height: 40px">
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" CssClass="form-control" ID="txtFMTIMBER" Width="95%" Text="FM-TIMBER" Enabled="False" BackColor="greenyellow"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:TextBox runat="server" ID="txtFMTIMBERQuantity" CssClass="form-control" Width="95%" Enabled="False"></asp:TextBox>
                        </div>
                        <div style="width: 25%; float: left">
                            <asp:DropDownList ID="ddFMTIMBER" runat="server" CssClass="form-control" Width="95%" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                        <div style="width: 25%; float: right">
                            <asp:DropDownList ID="toFMTIMBER" runat="server" CssClass="form-control" Width="100%">
                                <asp:ListItem Value="AS" Text="AS" Selected="True"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <%--END SUB PRODUCTION PART OUTPUT--%>
                </ContentTemplate>
            </asp:UpdatePanel>

            <asp:HiddenField runat="server" ID="hfSalePrice" Value="0" />
            <asp:HiddenField runat="server" ID="hfProdOrderQty" Value="0" />
            <asp:HiddenField runat="server" ID="hfRoundingInterval" Value="1" />

            <asp:Button runat="server" ID="bt1" Text="Submit" CssClass="btn btn-success" OnClientClick="return sweetAlertConfirmOutputPost();" OnClick="bt1_Click" CausesValidation="False" UseSubmitBehavior="false" />
            <!-- HISTORY -->
            <div class="row">
                <div class="col-12">
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Delivery History</h5>
                                <small class="text-muted">From Custom_ProductionPartOutputDetail</small>
                            </div>
                            <asp:GridView ID="gvHistory" runat="server" CssClass="table table-sm table-striped table-hover mt-3"
                                AutoGenerateColumns="False" EmptyDataText="No history yet.">
                                <Columns>
                                    <asp:BoundField DataField="ProdOrderNo" HeaderText="Prod. Order" />
                                    <asp:BoundField DataField="PostingDate" HeaderText="Posting Date" DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:BoundField DataField="Description" HeaderText="Part" />
                                    <asp:BoundField DataField="Quantity" HeaderText="Qty" DataFormatString="{0:0.####}" />
                                    <asp:BoundField DataField="Department" HeaderText="From" />
                                    <asp:BoundField DataField="ToDepartment" HeaderText="To" />
                                    <asp:BoundField DataField="UpdatedUser" HeaderText="By" />
                                    <asp:BoundField DataField="UpdatedOn" HeaderText="When" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                </Columns>
                                <HeaderStyle CssClass="table-light" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
        
</asp:Content>

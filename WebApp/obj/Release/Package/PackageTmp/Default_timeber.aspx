<%@ Page Title="Home" Language="C#" MasterPageFile="~/SkinTIMBER.Master" AutoEventWireup="true" CodeBehind="Default_timeber.aspx.cs" Inherits="WebApp.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="../masterskin/monster/dist/css/style.min_2021.css" rel="stylesheet" />
    <script src="../masterskin/monster/src/assets/libs/jquery/dist/jquery.min.js"></script>

    <%-- select 2 --%>
    <link href="../masterskin/monster/dist/select2/select2_38.min.css" rel="stylesheet" />
    <script src="../masterskin/monster/dist/select2/select2.min.js"></script>

    <%-- Export to Excel --%>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/jszip.min.js"></script>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/FileSaver.min.js"></script>
    <script type="text/javascript" src="../masterskin/monster/dist/export2excel/excel-gen.js"></script>

    <%-- load sweet alert --%>
    <script src="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <link href="../masterskin/monster/src/assets/libs/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet" />

    <!-- Bootstrap tether Core JavaScript -->
    <script src="../masterskin/monster/src/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
    <!-- apps -->
    <script src="../masterskin/monster/dist/js/app.min.js"></script>
    <script src="../masterskin/monster/dist/js/app.init.horizontal.js"></script>
    <script src="../masterskin/monster/dist/js/app-style-switcher.horizontal.js"></script>
    <script src="../masterskin/monster/dist/js/sidebarmenu.js"></script>
    <!-- slimscrollbar scrollbar JavaScript -->
    <script src="../masterskin/monster/src/assets/libs/perfect-scrollbar/dist/perfect-scrollbar.jquery.min.js"></script>
    <script src="../masterskin/monster/src/assets/libs/jquery-sparkline/jquery.sparkline.min.js"></script>
    <!--Wave Effects -->
    <script src="../masterskin/monster/dist/js/waves.js"></script>
    <!--Menu sidebar -->

    <!--Custom JavaScript -->
    <script src="../masterskin/monster/dist/js/feather.min.js"></script>
    <script src="../masterskin/monster/dist/js/custom.min.js"></script>
    <script src="../masterskin/monster/dist/js/pages/dashboards/dashboard1.js"></script>

    <style>
        a.cta_button {
            -moz-box-sizing: content-box !important;
            -webkit-box-sizing: content-box !important;
            box-sizing: content-box !important;
            vertical-align: middle
        }

        .hs-breadcrumb-menu {
            list-style-type: none;
            margin: 0px 0px 0px 0px;
            padding: 0px 0px 0px 0px
        }

        .hs-breadcrumb-menu-item {
            float: left;
            padding: 10px 0px 10px 10px
        }

        .hs-breadcrumb-menu-divider:before {
            content: '›';
            padding-left: 10px
        }

        .hs-featured-image-link {
            border: 0
        }

        .hs-featured-image {
            float: right;
            margin: 0 0 20px 20px;
            max-width: 50%
        }

        @media (max-width: 568px) {
            .hs-featured-image {
                float: none;
                margin: 0;
                width: 100%;
                max-width: 100%
            }
        }

        .hs-screen-reader-text {
            clip: rect(1px, 1px, 1px, 1px);
            height: 1px;
            overflow: hidden;
            position: absolute !important;
            width: 1px
        }
    </style>

    <style>
        #hs_cos_wrapper_dnd_area-module-1 .button-2 .button,
        #hs_cos_wrapper_dnd_area-module-1 .button-2 .cta_button {
            background-color: rgba(231,234,238,1.0);
            border-color: rgba(231,234,238,1.0);
            color: rgba(30,61,96,1.0);
            fill: rgba(30,61,96,1.0);
        }

            #hs_cos_wrapper_dnd_area-module-1 .button-2 .button:hover,
            #hs_cos_wrapper_dnd_area-module-1 .button-2 .button:focus,
            #hs_cos_wrapper_dnd_area-module-1 .button-2 .cta_button:hover,
            #hs_cos_wrapper_dnd_area-module-1 .button-2 .cta_button:focus {
                background-color: rgba(211,214,218,1.0);
                border-color: rgba(211,214,218,1.0);
            }

            #hs_cos_wrapper_dnd_area-module-1 .button-2 .button:active,
            #hs_cos_wrapper_dnd_area-module-1 .button-2 .cta_button:active {
                background-color: rgba(201,204,208,1.0);
                border-color: rgba(201,204,208,1.0);
            }
    </style>

    <style>
        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__content {
        }

        #hs_cos_wrapper_widget_1643004069988 span.quest-course-slider__duration {
        }

        #hs_cos_wrapper_widget_1643004069988 span.quest-course-slider__price {
        }

        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__content h3 {
        }

        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__content p {
        }

        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__author p {
        }

        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__slider button.slick-arrow {
        }

            #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__slider button.slick-arrow:hover {
            }

        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__slider .slick-prev:before {
        }

        #hs_cos_wrapper_widget_1643004069988 .quest-course-slider__slider button.slick-arrow:hover:before {
        }
    </style>

    <style>
        #hs_cos_wrapper_widget_1643089372777 .quest-card-1 .heading-text .heading-color {
            color: rgba(255,255,255,1.0);
        }

        #hs_cos_wrapper_widget_1643089372777 .quest-card-1 .card {
            background: linear-gradient(to bottom,rgba(255,255,255,1),rgba(255,255,255,1));
            border: 1px solid #dae5ec;
        }

            #hs_cos_wrapper_widget_1643089372777 .quest-card-1 .card .card-icon svg {
                fill: #0f437f;
            }
    </style>

    <style>
        #hs_cos_wrapper_widget_1643095628287 .button-2 .button,
        #hs_cos_wrapper_widget_1643095628287 .button-2 .cta_button {
            background-color: rgba(190,202,215,1.0);
            border-color: rgba(190,202,215,1.0);
            color: rgba(30,61,96,1.0);
            fill: rgba(30,61,96,1.0);
        }

            #hs_cos_wrapper_widget_1643095628287 .button-2 .button:hover,
            #hs_cos_wrapper_widget_1643095628287 .button-2 .button:focus,
            #hs_cos_wrapper_widget_1643095628287 .button-2 .cta_button:hover,
            #hs_cos_wrapper_widget_1643095628287 .button-2 .cta_button:focus {
                background-color: rgba(170,182,195,1.0);
                border-color: rgba(170,182,195,1.0);
            }

            #hs_cos_wrapper_widget_1643095628287 .button-2 .button:active,
            #hs_cos_wrapper_widget_1643095628287 .button-2 .cta_button:active {
                background-color: rgba(160,172,185,1.0);
                border-color: rgba(160,172,185,1.0);
            }
    </style>

    <style>
        #hs_cos_wrapper_dnd_area-module-4 .quest-three-column-testimonial .card {
            background-color: rgba(248,248,248,1.0);
        }

        #hs_cos_wrapper_dnd_area-module-4 .button,
        #hs_cos_wrapper_dnd_area-module-4 .cta_button {
            background-color: rgba(255,255,255,1.0);
            border-color: rgba(255,255,255,1.0);
            color: rgba(15,67,127,1.0);
            fill: rgba(15,67,127,1.0);
        }

            #hs_cos_wrapper_dnd_area-module-4 .button:hover,
            #hs_cos_wrapper_dnd_area-module-4 .button:focus,
            #hs_cos_wrapper_dnd_area-module-4 .cta_button:hover,
            #hs_cos_wrapper_dnd_area-module-4 .cta_button:focus {
                background-color: rgba(#null,0.0);
                border-color: rgba(#null,0.0);
            }

            #hs_cos_wrapper_dnd_area-module-4 .button:active,
            #hs_cos_wrapper_dnd_area-module-4 .cta_button:active {
                background-color: rgba(#null,0.0);
                border-color: rgba(#null,0.0);
            }

        #hs_cos_wrapper_dnd_area-module-4 .quest-three-column-testimonial .content img {
            border-radius: 8px;
        }
    </style>

    <style>
        #hs_cos_wrapper_dnd_area-module-7 .quest-recent-post .blog-card {
            background: linear-gradient(to bottom,rgba(255,255,255,1),rgba(255,255,255,1));
        }
    </style>

    <style>
        #hs_cos_wrapper_footer-module-19 .social-links {
        }

        #hs_cos_wrapper_footer-module-19 .social-links__link {
        }

        #hs_cos_wrapper_footer-module-19 .social-links__icon {
            background-color: rgba(255,255,255,1.0);
        }

            #hs_cos_wrapper_footer-module-19 .social-links__icon svg {
                fill: #263238;
                height: 16px;
                width: 16px;
            }

            #hs_cos_wrapper_footer-module-19 .social-links__icon:hover,
            #hs_cos_wrapper_footer-module-19 .social-links__icon:focus {
                background-color: rgba(235,235,235,1.0);
            }

            #hs_cos_wrapper_footer-module-19 .social-links__icon:active {
                background-color: rgba(225,225,225,1.0);
            }
    </style>

    <style>
        @font-face {
            font-family: "Kumbh Sans";
            font-weight: 400;
            font-style: normal;
            font-display: swap;
            src: url("hs/googlefonts/Kumbh_Sans/regular.woff2") format("woff2"), url("hs/googlefonts/Kumbh_Sans/regular.woff") format("woff");
        }

        @font-face {
            font-family: "Kumbh Sans";
            font-weight: 700;
            font-style: normal;
            font-display: swap;
            src: url("hs/googlefonts/Kumbh_Sans/700.woff2") format("woff2"), url("hs/googlefonts/Kumbh_Sans/700.woff") format("woff");
        }

        @font-face {
            font-family: "Newsreader";
            font-weight: 400;
            font-style: normal;
            font-display: swap;
            src: url("hs/googlefonts/Newsreader/regular.woff2") format("woff2"), url("hs/googlefonts/Newsreader/regular.woff") format("woff");
        }

        @font-face {
            font-family: "Newsreader";
            font-weight: 600;
            font-style: normal;
            font-display: swap;
            src: url("hs/googlefonts/Newsreader/600.woff2") format("woff2"), url("hs/googlefonts/Newsreader/600.woff") format("woff");
        }
    </style>
    <!-- Editor Styles -->
    <style id="hs_editor_style" type="text/css">
        .dnd_area-row-1-force-full-width-section > .row-fluid {
            max-width: none !important;
        }

        .dnd_area-row-7-force-full-width-section > .row-fluid {
            max-width: none !important;
        }
        /* HubSpot Non-stacked Media Query Styles */
        @media (min-width:768px) {
            .footer-row-0-vertical-alignment > .row-fluid {
                display: -ms-flexbox !important;
                -ms-flex-direction: row;
                display: flex !important;
                flex-direction: row;
            }

            .footer-row-3-vertical-alignment > .row-fluid {
                display: -ms-flexbox !important;
                -ms-flex-direction: row;
                display: flex !important;
                flex-direction: row;
            }

            .footer-row-4-vertical-alignment > .row-fluid {
                display: -ms-flexbox !important;
                -ms-flex-direction: row;
                display: flex !important;
                flex-direction: row;
            }

            .cell_1642727906521-vertical-alignment {
                display: -ms-flexbox !important;
                -ms-flex-direction: column !important;
                -ms-flex-pack: center !important;
                display: flex !important;
                flex-direction: column !important;
                justify-content: center !important;
            }

                .cell_1642727906521-vertical-alignment > div {
                    flex-shrink: 0 !important;
                }

            .cell_1642727906519-vertical-alignment {
                display: -ms-flexbox !important;
                -ms-flex-direction: column !important;
                -ms-flex-pack: center !important;
                display: flex !important;
                flex-direction: column !important;
                justify-content: center !important;
            }

                .cell_1642727906519-vertical-alignment > div {
                    flex-shrink: 0 !important;
                }

            .cell_16427279942282-vertical-alignment {
                display: -ms-flexbox !important;
                -ms-flex-direction: column !important;
                -ms-flex-pack: center !important;
                display: flex !important;
                flex-direction: column !important;
                justify-content: center !important;
            }

                .cell_16427279942282-vertical-alignment > div {
                    flex-shrink: 0 !important;
                }

            .footer-column-18-vertical-alignment {
                display: -ms-flexbox !important;
                -ms-flex-direction: column !important;
                -ms-flex-pack: center !important;
                display: flex !important;
                flex-direction: column !important;
                justify-content: center !important;
            }

                .footer-column-18-vertical-alignment > div {
                    flex-shrink: 0 !important;
                }

            .footer-column-18-row-0-vertical-alignment > .row-fluid {
                display: -ms-flexbox !important;
                -ms-flex-direction: row;
                display: flex !important;
                flex-direction: row;
            }

            .footer-module-19-vertical-alignment {
                display: -ms-flexbox !important;
                -ms-flex-direction: column !important;
                -ms-flex-pack: center !important;
                display: flex !important;
                flex-direction: column !important;
                justify-content: center !important;
            }

                .footer-module-19-vertical-alignment > div {
                    flex-shrink: 0 !important;
                }

            .cell_1642728768629-vertical-alignment {
                display: -ms-flexbox !important;
                -ms-flex-direction: column !important;
                -ms-flex-pack: center !important;
                display: flex !important;
                flex-direction: column !important;
                justify-content: center !important;
            }

                .cell_1642728768629-vertical-alignment > div {
                    flex-shrink: 0 !important;
                }
        }
        /* HubSpot Styles (default) */
        .dnd_area-row-0-padding {
            padding-top: 15px !important;
            padding-bottom: 20px !important;
            padding-left: 20px !important;
            padding-right: 20px !important;
        }

        .dnd_area-row-0-background-layers {
            background-image: linear-gradient(rgba(255, 255, 255, 1), rgba(255, 255, 255, 1)) !important;
            background-position: left top !important;
            background-size: auto !important;
            background-repeat: no-repeat !important;
        }

        .dnd_area-row-1-padding {
            padding-top: 150px !important;
            padding-bottom: 150px !important;
            padding-left: 0px !important;
            padding-right: 0px !important;
        }

        .dnd_area-row-1-background-layers {
            background-image: linear-gradient(rgba(249, 250, 251, 1), rgba(249, 250, 251, 1)) !important;
            background-position: left top !important;
            background-size: auto !important;
            background-repeat: no-repeat !important;
        }

        .dnd_area-row-2-padding {
            padding-top: 150px !important;
            padding-bottom: 150px !important;
        }

        .dnd_area-row-2-background-layers {
            background-image: linear-gradient(rgba(30, 61, 96, 1), rgba(30, 61, 96, 1)) !important;
            background-position: left top !important;
            background-size: auto !important;
            background-repeat: no-repeat !important;
        }

        .dnd_area-row-4-padding {
            padding-top: 100px !important;
            padding-bottom: 100px !important;
            padding-left: 20px !important;
            padding-right: 20px !important;
        }

        .dnd_area-row-4-background-layers {
            background-image: url('hs/images/canyon-1852921_1920.jpg') !important;
            background-position: center center !important;
            background-size: cover !important;
            background-repeat: no-repeat !important;
        }

        .dnd_area-row-7-padding {
            padding-left: 0px !important;
            padding-right: 0px !important;
        }

        .dnd_area-row-8-padding {
            padding-top: 100px !important;
            padding-bottom: 100px !important;
            padding-left: 20px !important;
            padding-right: 20px !important;
        }

        .footer-row-0-padding {
            padding-top: 40px !important;
            padding-bottom: 40px !important;
            padding-left: 20px !important;
            padding-right: 20px !important;
        }

        .footer-row-1-padding {
            padding-top: 0px !important;
            padding-bottom: 0px !important;
            padding-left: 0px !important;
            padding-right: 0px !important;
        }

        .footer-row-2-padding {
            padding-top: 60px !important;
            padding-bottom: 40px !important;
            padding-left: 20px !important;
            padding-right: 20px !important;
        }

        .footer-row-3-padding {
            padding-top: 0px !important;
            padding-bottom: 0px !important;
            padding-left: 0px !important;
            padding-right: 0px !important;
        }

        .footer-row-4-padding {
            padding-top: 20px !important;
            padding-bottom: 20px !important;
            padding-left: 20px !important;
            padding-right: 20px !important;
        }

        .footer-column-4-row-0-margin {
            margin-top: 0px !important;
            margin-bottom: 0px !important;
        }

        .footer-column-11-row-1-margin {
            margin-top: 0px !important;
            margin-bottom: 0px !important;
        }

        .footer-column-8-row-1-margin {
            margin-top: 0px !important;
            margin-bottom: 25px !important;
        }

        .footer-column-5-row-1-margin {
            margin-top: 0px !important;
            margin-bottom: 25px !important;
        }

        .cell_1642678619611-row-0-margin {
            margin-top: 0px !important;
            margin-bottom: 25px !important;
        }

        .cell_1642678619611-row-1-margin {
            margin-top: 0px !important;
            margin-bottom: 20px !important;
        }

        .cell_16427279942282-row-0-margin {
            margin-top: 0px !important;
            margin-bottom: 0px !important;
        }

        .footer-column-18-row-0-margin {
            margin-top: 0px !important;
            margin-bottom: 0px !important;
        }
        /* HubSpot Styles (mobile) */
        @media (max-width: 767px) {
            .dnd_area-row-0-padding {
                padding-top: 50px !important;
                padding-bottom: 50px !important;
            }

            .dnd_area-row-4-padding {
                padding-top: 50px !important;
                padding-bottom: 50px !important;
            }

            .dnd_area-row-8-padding {
                padding-top: 50px !important;
                padding-bottom: 50px !important;
            }

            .footer-row-2-padding {
                padding-top: 60px !important;
                padding-bottom: 30px !important;
                padding-left: 20px !important;
                padding-right: 20px !important;
            }

            .footer-row-3-padding {
                padding-top: 0px !important;
                padding-bottom: 0px !important;
                padding-left: 0px !important;
                padding-right: 0px !important;
            }

            .footer-row-4-padding {
                padding-top: 20px !important;
                padding-bottom: 20px !important;
                padding-left: 20px !important;
                padding-right: 20px !important;
            }
        }
    </style>

    <style>
        button, .button, .cta_button {
            background-color: rgba(15,67,127,1.0);
            border: 1px solid #0f437f;
            border-radius: 45px;
            color: #fff;
            fill: #fff;
            padding: 21px 57px;
            font-weight: 700;
            font-family: Kumbh Sans;
            font-size: 16px;
            letter-spacing: .08em;
            text-transform: uppercase
        }

            button:hover, button:focus, .button:hover, .button:focus, .cta_button:hover, .cta_button:focus {
                background-color: rgba(0,47,107,1.0);
                border-color: #002f6b;
                color: #fff
            }

            button:active, .button:active, .cta_button:active {
                background-color: rgba(0,37,97,1.0);
                border-color: #002561;
                color: #fff
            }

        .button-outline {
            background-color: transparent;
            border: 1px solid #0f437f;
            color: #0f437f;
            border-radius: 45px;
            padding: 21px 57px;
            letter-spacing: 2px;
            font-weight: 700;
            font-family: Kumbh Sans;
            transition: all .15s linear
        }

            .button-outline:hover, .button-outline:focus, .button-outline:active, .button-outline.active {
                background-color: #0f437f;
                color: #fff
            }

            .button .hs_cos_wrapper_type_icon, .button-outline .hs_cos_wrapper_type_icon {
                margin-left: 5px
            }

            .button .hs_cos_wrapper_type_icon, .button-outline .hs_cos_wrapper_type_icon {
                display: inline-block
            }

                .button .hs_cos_wrapper_type_icon svg, .button-outline .hs_cos_wrapper_type_icon svg {
                    fill: inherit
                }

        h1, .h1 {
            font-family: Newsreader,serif;
            font-style: normal;
            font-weight: 600;
            text-decoration: none;
            color: #0f437f;
            font-size: 60px
        }

        h2, .h2 {
            font-family: Newsreader,serif;
            font-style: normal;
            font-weight: 600;
            text-decoration: none;
            color: #0f437f;
            font-size: 38px
        }

        h3, .h3 {
            font-family: Newsreader,serif;
            font-style: normal;
            font-weight: 600;
            text-decoration: none;
            color: #0f437f;
            font-size: 24px
        }

        h4, .h4 {
            font-family: Newsreader,serif;
            font-style: normal;
            font-weight: 600;
            text-decoration: none;
            color: #0f437f;
            font-size: 20px
        }

        h5, .h5 {
            font-family: Newsreader,serif;
            font-style: normal;
            font-weight: 600;
            text-decoration: none;
            color: #0f437f;
            font-size: 18px
        }

        h6, .h6 {
            font-family: Newsreader,serif;
            font-style: normal;
            font-weight: 600;
            text-decoration: none;
            color: #0f437f;
            font-size: 16px
        }

        p {
            font-family: 'Kumbh Sans',sans-serif;
            font-style: normal;
            font-weight: normal;
            text-decoration: none
        }

        main p:last-child {
            margin-bottom: 0
        }

        a {
            color: #064ea4
        }

            a:hover, a:focus {
                color: #003a90;
                text-decoration: none
            }

            a:active {
                color: #003086
            }

            a.cta_button {
                box-sizing: border-box !important
            }

        button, .button, .button-outline, .cta_button {
            cursor: pointer;
            display: inline-block;
            font-size: font-size:1rem;
            text-align: center;
            transition: all .15s linear;
            white-space: normal
        }

            button:disabled, .button:disabled, .button-outline:disabled, .cta_button:disabled {
                background-color: #d0d0d0;
                border-color: #d0d0d0;
                color: #e6e6e6
            }

            button:hover, button:focus, .button:hover, .button:focus, .button-outline:hover, .button-outline:focus, .cta_button:hover, .cta_button:focus {
                text-decoration: none;
                -webkit-transform: scale3d(0.96,0.96,1.01);
                transform: scale3d(0.96,0.96,1.01);
            }

            button:active, .button:active, .button-outline:active, .cta_button:active {
                text-decoration: none;
            }

        a {
            cursor: pointer;
            text-decoration: none;
        }

        .dnd-section > .row-fluid {
            margin: 0 auto;
        }

        .dnd-section .dnd-column {
            padding: 0
        }

        .dnd-section, .content-wrapper--vertical-spacing {
            padding: 100px 20px
        }

            .dnd-section > .row-fluid {
                max-width: 1170px;
            }

        .mb-0 {
            margin-bottom: 0
        }

        .mb-5 {
            margin-bottom: 5px
        }

        .mb-10 {
            margin-bottom: 10px
        }

        .mb-15 {
            margin-bottom: 15px
        }

        .mb-20 {
            margin-bottom: 20px
        }

        .mb-25 {
            margin-bottom: 25px
        }

        .mb-30 {
            margin-bottom: 30px
        }

        .mb-35 {
            margin-bottom: 35px
        }

        .mb-40 {
            margin-bottom: 40px;
        }

        .mb-45 {
            margin-bottom: 45px
        }

        .mb-50 {
            margin-bottom: 50px
        }

        @media(min-width: 768px) and (max-width:1139px) {
            .row-fluid {
                width: 100%;
                *zoom: 1
            }

                .row-fluid:before, .row-fluid:after {
                    display: table;
                    content: ""
                }

                .row-fluid:after {
                    clear: both
                }

                .row-fluid [class*="span"] {
                    display: block;
                    float: left;
                    width: 100%;
                    min-height: 1px;
                    margin-left: 2.762430939%;
                    *margin-left: 2.709239449638298%;
                    -webkit-box-sizing: border-box;
                    -moz-box-sizing: border-box;
                    -ms-box-sizing: border-box;
                    box-sizing: border-box
                }

                    .row-fluid [class*="span"]:first-child {
                        margin-left: 0
                    }

                .row-fluid .span12 {
                    width: 99.999999993%;
                    *width: 99.9468085036383%
                }

                .row-fluid .span11 {
                    width: 91.436464082%;
                    *width: 91.38327259263829%
                }

                .row-fluid .span10 {
                    width: 82.87292817100001%;
                    *width: 82.8197366816383%
                }

                .row-fluid .span9 {
                    width: 74.30939226%;
                    *width: 74.25620077063829%
                }

                .row-fluid .span8 {
                    width: 65.74585634900001%;
                    *width: 65.6926648596383%
                }

                .row-fluid .span7 {
                    width: 57.182320438000005%;
                    *width: 57.129128948638304%
                }

                .row-fluid .span6 {
                    width: 48.618784527%;
                    *width: 48.5655930376383%
                }

                .row-fluid .span5 {
                    width: 40.055248616%;
                    *width: 40.0020571266383%
                }

                .row-fluid .span4 {
                    width: 31.491712705%;
                    *width: 31.4385212156383%
                }

                .row-fluid .span3 {
                    width: 22.928176794%;
                    *width: 22.874985304638297%
                }

                .row-fluid .span2 {
                    width: 14.364640883%;
                    *width: 14.311449393638298%
                }

                .row-fluid .span1 {
                    width: 5.801104972%;
                    *width: 5.747913482638298%
                }

            .dnd-section, .content-wrapper--vertical-spacing {
                padding: 100px 20px
            }

                .dnd-section > .row-fluid {
                    max-width: 1170px;
                }
        }

        @media(min-width: 1280px) {
            .row-fluid {
                width: 100%;
                *zoom: 1
            }

                .row-fluid:before, .row-fluid:after {
                    display: table;
                    content: ""
                }

                .row-fluid:after {
                    clear: both
                }

                .row-fluid [class*="span"] {
                    display: block;
                    float: left;
                    width: 100%;
                    min-height: 1px;
                    margin-left: 2.564102564%;
                    *margin-left: 2.510911074638298%;
                    -webkit-box-sizing: border-box;
                    -moz-box-sizing: border-box;
                    -ms-box-sizing: border-box;
                    box-sizing: border-box
                }

                    .row-fluid [class*="span"]:first-child {
                        margin-left: 0
                    }

                .row-fluid .span12 {
                    width: 100%;
                    *width: 99.94680851063829%
                }

                .row-fluid .span11 {
                    width: 91.45299145300001%;
                    *width: 91.3997999636383%
                }

                .row-fluid .span10 {
                    width: 82.905982906%;
                    *width: 82.8527914166383%
                }

                .row-fluid .span9 {
                    width: 74.358974359%;
                    *width: 74.30578286963829%
                }

                .row-fluid .span8 {
                    width: 65.81196581200001%;
                    *width: 65.7587743226383%
                }

                .row-fluid .span7 {
                    width: 57.264957265%;
                    *width: 57.2117657756383%
                }

                .row-fluid .span6 {
                    width: 48.717948718%;
                    *width: 48.6647572286383%
                }

                .row-fluid .span5 {
                    width: 40.170940171000005%;
                    *width: 40.117748681638304%
                }

                .row-fluid .span4 {
                    width: 31.623931624%;
                    *width: 31.5707401346383%
                }

                .row-fluid .span3 {
                    width: 23.076923077%;
                    *width: 23.0237315876383%
                }

                .row-fluid .span2 {
                    width: 14.529914530000001%;
                    *width: 14.4767230406383%
                }

                .row-fluid .span1 {
                    width: 5.982905983%;
                    *width: 5.929714493638298%
                }
        }
    </style>


    <link rel="stylesheet" href="hs/css/quest-hero-1.min.css">

    <%--<script src="Scripts/jquery-1.10.21.js" type="text/javascript"></script>
    <script src="Scripts/jquery-ui1.js" type="text/javascript"></script>        
    <link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.2/themes/blitzer/jquery-ui.css" rel="Stylesheet" type="text/css" />
    <script type="text/javascript" src='chart-lib/bootstrap1.min.js'></script>--%>

    <div class="page-wrapper" style="display: block">
        <div class="container-fluid">
            <main id="main-content" style="display: block">
                <div class="body-container body-container--home container-fluid-custom">
                    <div class="row-fluid-wrapper">
                        <div class="row-fluid">
                            <div class="span12 widget-span widget-type-cell " style="" data-widget-type="cell" data-x="0" data-w="12">

                                <div class="row-fluid-wrapper row-depth-1 row-number-1 dnd_area-row-0-background-color dnd_area-row-0-background-layers dnd-section dnd_area-row-0-padding">
                                    <div class="row-fluid ">
                                        <div class="span12 widget-span widget-type-custom_widget dnd-module" style="" data-widget-type="custom_widget" data-x="0" data-w="12">
                                            <div id="hs_cos_wrapper_dnd_area-module-1" class="hs_cos_wrapper hs_cos_wrapper_widget hs_cos_wrapper_type_module" style="" data-hs-cos-general-type="widget" data-hs-cos-type="module">

                                                <section class="quest-hero-1   ">
                                                    <div class="flex ">

                                                        <div class="col">
                                                            <div class="heading-text">

                                                                <h1 class="heading-type heading-color font-size-0">Welcome to NHF internal application
                                                                </h1>

                                                            </div>


                                                            <div class="mb-40">
                                                                <p data-w-id="625f7db1-5f8f-0dc1-ec74-e70632a80e52">This web application is used for internal operations of Nhan Hoang furniture. To continue, scroll down and click an icon to enter the sub application.</p>
                                                            </div>

                                                        </div>

                                                        <div class="col">
                                                            <img src="hs/images/path-6567149_1280.jpg" alt="path-6567149_1280" loading="lazy" width="1461" height="1920" style="max-width: 100%; height: auto; float: right;">
                                                        </div>

                                                    </div>



                                                </section>
                                            </div>

                                        </div>
                                        <!--end widget-span -->
                                    </div>
                                    <!--end row-->
                                </div>
                                <!--end row-wrapper -->


                            </div>
                            <!--end widget-span -->
                        </div>
                    </div>
                </div>
            </main>

           

            <div class="row mt-4">
                <!-- Kaizen app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="kaizen/default.aspx">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/kaizen.png" data-src="../hs/images/appicon/kaizen.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0">Idea Network</h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
                
                 <!-- 2 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/sale.png" data-src="../hs/images/appicon/sale.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>

                        </div>
                    </div>
                </div>

                 <!-- 3 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/purchase.png" data-src="../hs/images/appicon/purchase.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                                

                        </div>
                    </div>
                </div>

                 <!-- 4 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/warehouse.png" data-src="../hs/images/appicon/warehouse.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
                    
            <div class="row">
                <!-- 5 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/production.png" data-src="../hs/images/appicon/production.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
                
                 <!-- 6 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/quality.png" data-src="../hs/images/appicon/quality.png" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>

                        </div>
                    </div>
                </div>

                 <!-- 3 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/finance.png" data-src="../hs/images/appicon/finance.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                                

                        </div>
                    </div>
                </div>

                 <!-- 4 app -->
                <div class="col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <a href="#">
                                <div class="d-flex align-items-start">
                                    <div class="rounded-circle">
                                        <img src="../hs/images/appicon/hr.png" data-src="../hs/images/appicon/hr.png" alt="Brainstorm" title="Brainstorm" width="64" height="64" class="lzy lazyload--done" />
                                    </div>
                                    <div class="mx-auto mb-auto mt-auto">
                                        <h3 class="mb-0"> </h3>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        
        </div>
    </div>


</asp:Content>

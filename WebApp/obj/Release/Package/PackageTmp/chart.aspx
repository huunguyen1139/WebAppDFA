<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="chart.aspx.cs" Inherits="WebApplication2.chart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- This Page CSS -->
    <link rel="stylesheet" type="text/css" href="chart-lib/c3.min.css">
    <!-- Custom CSS -->
    <link href="chart-lib/style.min.css" rel="stylesheet">
    <script src="chart-lib/jquery.min.js"></script>
    <script type="text/javascript" src="chart-lib/jquery-1.8.3.min.js"></script>
    
    <!-- slimscrollbar scrollbar JavaScript -->
    <script src="chart-lib/perfect-scrollbar.jquery.min.js"></script>
    <script src="chart-lib/jquery.sparkline.min.js"></script>
    
    <!--Custom JavaScript -->
    <script src="chart-lib/feather.min.js"></script>
    <script src="chart-lib/custom.min.js"></script>
    <!-- This Page Plugins -->
    <script src="chart-lib/d3.min.js"></script>
    <script src="chart-lib/c3.min1.js"></script>
    <div class="container-fluid">
                
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="border-bottom title-part-padding">
                                <h4 class="card-title mb-0">Chart name</h4>
                            </div>
                            <div class="card-body">
                                <div id="column-oriented"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Columns Oriented Data Chart -->
				
             
            </div>

   
</asp:Content>

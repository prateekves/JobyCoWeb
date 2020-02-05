<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="ReceiveShipping.aspx.cs" Inherits="JobyCoWeb.Ghana.ReceiveShipping" 
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="../css/jquery.mCustomScrollbar.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css"/>
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <script src="../js/jquery.mCustomScrollbar.concat.min.js"></script>
       <script src="https://cdn.datatables.net/select/1.3.0/js/dataTables.select.min.js"></script>
    <!-- New Script Added for Dynamic Menu Population
================================================== -->
    <style>
        .includeItem {
        }

        .RowBookingId {
            color: white;
            cursor: pointer;
        }
    </style>
    <script>
        // unblock when ajax activity stops 
        //$(document).ajaxStop($.unblockUI);

        //function mainMenu() {
        //    $.ajax({
        //        url: 'Dashboard.aspx',
        //        cache: false
        //    });
        //}

        $(document).ready(function () {

            //$.blockUI({
            //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    message: '<h4>Loading...</h4>',
            //    css: {
            //        border: 'none',
            //        //backgroundColor: 'transparent'
            //    }

            //});

            //mainMenu();

            $("#<%=btnMarkContainerShipped.ClientID%>").css('background-color', '#ff9900');
            $("#<%=btnMarkContainerShipped.ClientID%>").css('color', '#fff');
            $("#<%=btnMarkContainerShipped.ClientID%>").css('opacity', '0.6');
            $("#<%=btnCancelShipped.ClientID%>").css('background-color', 'red');
            $("#<%=btnCancelShipped.ClientID%>").css('color', '#fff');
            $("#<%=btnCancelShipped.ClientID%>").css('opacity', '0.6');

            $("#<%=btnMarkContainerShipped.ClientID%>").attr('disabled', 'disabled');
            $("#<%=btnCancelShipped.ClientID%>").attr('disabled', 'disabled');
            opacity: 0.6

            getAllWarehouse();

            var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
            accessibleMenuItems(hfMenusAccessibleValues);

            var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
            accessiblePageControls(hfControlsAccessible);

            $("#divddlContainerNo").click(function () {
                //Removing classes one by one
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').removeClass("chosen-container");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').removeClass("chosen-container-single-nosearch");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').removeClass("chosen-container-active");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').removeClass("chosen-with-drop");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').removeClass("chosen-container-single");
                //Adding classes one by one
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').addClass("chosen-container chosen-container-single chosen-container-active chosen-with-drop");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').addClass("chosen-container");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').addClass("chosen-container-single");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').addClass("chosen-container-active");
                $('#ContentPlaceHolder1_ddlContainerNo_chosen').addClass("chosen-with-drop");
                //Removing readonly from the search box's textbox
                $("#ContentPlaceHolder1_ddlContainerNo_chosen > .chosen-drop > .chosen-search > input[type=text]").removeAttr("readonly");
                //Condition for open close search box
                if ($("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim() == "Select Container") {
                }
                else {
                    if ($("#ContentPlaceHolder1_ddlContainerNo_chosen > .chosen-drop").is(":visible")) {
                        $('#ContentPlaceHolder1_ddlContainerNo_chosen > .chosen-drop').css('display', 'none');
                    }
                    else {
                        $('#ContentPlaceHolder1_ddlContainerNo_chosen > .chosen-drop').css('display', 'block');
                        //Focus textbox when the search box is opened
                        $("#ContentPlaceHolder1_ddlContainerNo_chosen > .chosen-drop > .chosen-search > input[type=text]").focus();
                    }
                }
            });

            PopulateMapFromTo();

        });

        (function ($) {
            $(window).on("load", function () {

                $("#content-1").mCustomScrollbar({
                    theme: "minimal"
                });

            });
        })(jQuery);
    </script>

    <script>
        function checkBlankControls() {
            //var vShippingReferenceNumber = $("#<%=txtShippingReferenceNumber.ClientID%>");
            var vContainerNumber = $("#<%=ddlContainerNo.ClientID%>");
            var vSealReferenceNumber = $("#<%=txtSealReferenceNumber.ClientID%>");

            var vBookingNumber = $("#<%=ddlBookingId.ClientID%>");

            var vShippingFrom = $("#<%=txtCollectionAddressShippingFrom.ClientID%>");
            var vShippingTo = $("#<%=txtCollectionAddressShippingTo.ClientID%>");

            var vShippingDate = $("#<%=txtShippingDate.ClientID%>");
            var vArrivalDate = $("#<%=txtArrivalDate.ClientID%>");
            var vETA = $("#<%=txtETA.ClientID%>");

            var vConsignee = $("#<%=txtConsignee.ClientID%>");

            var vWarehouseId = $("#<%=ddlWarehouse.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //if (vShippingReferenceNumber.val().trim() == "") {
            //    vErrMsg.text('Enter Shipping Reference Number');
            //    vErrMsg.css("display", "block");
            //    vShippingReferenceNumber.focus();
            //    return false;
            //}

            if (vContainerNumber.val().trim() == "Select Container") {
                vErrMsg.text('Please select a Container Number from dropdown');
                vErrMsg.css("display", "block");
                vContainerNumber.focus();

                $('html,body').animate({
                    scrollTop: $('.welcome-message').offset().top
                },
                  'slow');

                return false;
            }

            if (vSealReferenceNumber.val().trim() == "") {
                vErrMsg.text('Enter Seal Reference Number');
                vErrMsg.css("display", "block");
                vSealReferenceNumber.focus();
                return false;
            }

            if (vBookingNumber.val().trim() == "Select Booking Number") {
                vErrMsg.text('Please select a BookingNumber from dropdown');
                vErrMsg.css("display", "block");
                vBookingNumber.focus();
                return false;
            }

            if (vShippingFrom.val().trim() == "Select Shipping From") {
                vErrMsg.text('Please select a ShippingFrom from dropdown');
                vErrMsg.css("display", "block");
                vShippingFrom.focus();
                return false;
            }

            if (vShippingTo.val().trim() == "Select Shipping To") {
                vErrMsg.text('Please select a ShippingTo from dropdown');
                vErrMsg.css("display", "block");
                vShippingTo.focus();
                return false;
            }


            if (vShippingDate.val().trim() == "") {
                vErrMsg.text('Enter Date Of Shipping');
                vErrMsg.css("display", "block");
                vShippingDate.focus();
                return false;
            }

            if (vArrivalDate.val().trim() == "") {
                vErrMsg.text('Enter Date Of Arrival');
                vErrMsg.css("display", "block");
                vArrivalDate.focus();
                return false;
            }
            
            if (vETA.val().trim() == "") {
                vErrMsg.text('Enter Date Of Arrival');
                vErrMsg.css("display", "block");
                vETA.focus();
                return false;
            }
            
            //if (vBookingNumber.val().trim() == "Select BookingId") {
            //    vErrMsg.text('Enter Booking Number');
            //    vErrMsg.css("display", "block");
            //    vBookingNumber.focus();
            //    return false;
            //}

            if (vShippingDate.val().trim() != "" && vArrivalDate.val().trim() != "") {
                var dt1 = parseInt(vShippingDate.val().trim().substring(0, 2), 10);
                var mon1 = parseInt(vShippingDate.val().trim().substring(3, 5), 10);
                var yr1 = parseInt(vShippingDate.val().trim().substring(6, 10), 10);

                var dt2 = parseInt(vArrivalDate.val().trim().substring(0, 2), 10);
                var mon2 = parseInt(vArrivalDate.val().trim().substring(3, 5), 10);
                var yr2 = parseInt(vArrivalDate.val().trim().substring(6, 10), 10);

                var From_date = new Date(yr1, mon1, dt1);
                var To_date = new Date(yr2, mon2, dt2);
                var diff_date = To_date - From_date;

                var years = Math.floor(diff_date / 31536000000);
                var months = Math.floor((diff_date % 31536000000) / 2628000000);
                var days = Math.floor(((diff_date % 31536000000) % 2628000000) / 86400000);

                //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

                if (years < 0) {
                    vErrMsg.text('Arrival Date cannot be earlier than Shipping Date');
                    vErrMsg.css("display", "block");
                    return false;
                }
                else {
                    if (months < 0) {
                        vErrMsg.text('Arrival Date cannot be earlier than Shipping Date');
                        vErrMsg.css("display", "block");
                        return false;
                    }
                    else {
                        if (days < 0) {
                            vErrMsg.text('Arrival Date cannot be earlier than Shipping Date');
                            vErrMsg.css("display", "block");
                            return false;
                        }
                    }
                }
            }
            
            //var totalRowCount = $('#dtContainerBookingInformation tbody > tr').length
            
            //if (totalRowCount==0)
            //{
            //    //alert(totalRowCount);
            //    vErrMsg.text('Please Select Item For Shipping');
            //    vErrMsg.css("display", "block");
            //    return false;
            //}


            if (vWarehouseId.val().trim() == "Select Warehouse") {
                vErrMsg.text('Please select a Warehouse from dropdown');
                vErrMsg.css("display", "block");
                vWarehouseId.focus();
                return false;
            }

            return true;
        }

        function clearShippingModalPopup()
        {
            $("#<%=lblBookingId.ClientID%>").text("");
            $("#<%=lblCustomerName.ClientID%>").text("");
            $("#<%=lblCustomerMobile.ClientID%>").text("");
            $("#<%=lblItems.ClientID%>").text("");
            
            $("#dvBookingItems tbody tr").remove();
        }


        function clearAllControls() {
            //var vShippingReferenceNumber = $("#<%//=txtShippingReferenceNumber.ClientID%>");
            var vContainerNumber = $("#<%=ddlContainerNo.ClientID%>");
            var vSealReferenceNumber = $("#<%=txtSealReferenceNumber.ClientID%>");

            var vBookingNumber = $("#<%=ddlBookingId.ClientID%>");



            var vShippingFrom = $("#<%=txtCollectionAddressShippingFrom.ClientID%>");
            var vShippingTo = $("#<%=txtCollectionAddressShippingTo.ClientID%>");

            var vShippingDate = $("#<%=txtShippingDate.ClientID%>");
            var vArrivalDate = $("#<%=txtArrivalDate.ClientID%>");
            var vETA = $("#<%=txtETA.ClientID%>");

            var vConsignee = $("#<%=txtConsignee.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //vShippingReferenceNumber.val('');
            vContainerNumber.val('');
            vSealReferenceNumber.val('');

            vBookingNumber.val('Select Booking Number');
            vCustomerName.val('');
            vOrderStatus.val('');

            vShippingFrom.val('Select Shipping From');
            vShippingTo.val('Select Shipping To');

            vShippingPort.val('');
            vFreightType.val('Select Freight Type');

            vShippingDate.val('');
            vArrivalDate.val('');
            vETA.val('');

            vConsignee.val('');

            vInvoiceNumber.val('');
            vInvoiceAmount.val('');
            vPaid.val('');
            vItemCount.val('');
            vLoaded.val('');
            vRemaining.val('');
            hfRemaining.val('');

            location.href = "/Shipping/ViewAllShippings.aspx";
            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }

    </script>

    <script>
        function checkFromAndToDate(vFromDate, vToDate) {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            if (vFromDate != "" && vToDate != "") {
                var dt1 = parseInt(vFromDate.substring(0, 2), 10);
                var mon1 = parseInt(vFromDate.substring(3, 5), 10);
                var yr1 = parseInt(vFromDate.substring(6, 10), 10);

                var dt2 = parseInt(vToDate.substring(0, 2), 10);
                var mon2 = parseInt(vToDate.substring(3, 5), 10);
                var yr2 = parseInt(vToDate.substring(6, 10), 10);

                var stDate = new Date(yr1, mon1, dt1);
                var enDate = new Date(yr2, mon2, dt2);
                var diff_date = enDate - stDate;

                var years = Math.floor(diff_date / 31536000000);
                var months = Math.floor((diff_date % 31536000000) / 2628000000);
                var days = Math.floor(((diff_date % 31536000000) % 2628000000) / 86400000);

                //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

                if (years < 0) {
                    vErrMsg.text('Arrival Date cannot be earlier than Shipping Date');
                    vErrMsg.css("display", "block");
                    return false;
                }
                else {
                    if (months < 0) {
                        vErrMsg.text('Arrival Date cannot be earlier than Shipping Date');
                        vErrMsg.css("display", "block");
                        return false;
                    }
                    else {
                        if (days < 0) {
                            vErrMsg.text('Arrival Date cannot be earlier than Shipping Date');
                            vErrMsg.css("display", "block");
                            return false;
                        }
                    }
                }
            }
        }

        function checkShippingAndArrivalDate() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            //Date Checking Added on Text Change
            var vShippingDate = $("#<%=txtShippingDate.ClientID%>").val().trim();
            var vArrivalDate = $("#<%=txtArrivalDate.ClientID%>").val().trim();
            checkFromAndToDate(vShippingDate, vArrivalDate);
        }

    </script>

    <script>
        $(document).ready(function () {
            
            getAllBookingIds();
            getAllLocationsUK();

            $('#<%=txtShippingDate.ClientID%>').datepicker({
                format: 'dd/mm/yyyy',
                todayHighlight: true,
                autoclose: true
            });

            $('#<%=txtArrivalDate.ClientID%>').datepicker({
                format: 'dd/mm/yyyy',
                todayHighlight: true,
                autoclose: true
            });

            $('#<%=txtETA.ClientID%>').datepicker({
                format: 'dd/mm/yyyy',
                todayHighlight: true,
                autoclose: true
            });
        });
    </script>

    <script>
        // Read a page's GET URL variables and return them as an associative array.
        function getUrlVars() {
            debugger;
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                //vars.push(hash[0]);
                //vars[hash[0]] = hash[1];
            }
            if (hash[1] == null) return '';
            return hash[1];
        }

        function SearchWarehouseBooking(Searchkey)
        {
            <%--var Searchkey = $('#<%=txtSearchWarehouseBooking.ClientID%>').val().trim();--%>
            getBookingInformationByBookingId(Searchkey);
        }

        function SearchContainerBooking(Searchkey)
        {
            var ContainerNo = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            if ( ContainerNo == "Select Container") {}
            else{
                GetContainerDetails(ContainerNo, Searchkey);
            }
        }

        function GetContainerDetails(ContainerNo, SearchKey)
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ReceiveShipping.aspx/GetContainerDetails",
                    data: "{ ContainerNo: '" + ContainerNo + "', SearchKey: '" + SearchKey + "'}",
                    dataType: "json",
                    //beforeSend: function () {
                    //    //$("#loadingDiv").show();
                    //    $("#loadingDiv").css('display', 'flex');
                    //},
                    //complete: function () {
                    //    setTimeout(function () {
                    //        $('#loadingDiv').fadeOut();
                    //    }, 500);
                    //},
                    success: function (result) {
                        var jdata = JSON.parse(result.d);
                        //alert(JSON.stringify(jdata));
                        var len = jdata.length;
                        //alert(len);
                        var IsReceived = $('#<%=hfReceive.ClientID%>').val().trim();
                        $("#cancel_table").html('');

                        if (len > 0) {
                            for (var i = 0; i < len; i++) {
                                var BookingId = jdata[i]['BookingId'];
                                //var InvoiceNumber = jdata[i]['InvoiceNumber'];
                                //var InvoiceAmount = jdata[i]['InvoiceAmount'];
                                //var Paid = jdata[i]['Paid'];
                                var Items = jdata[i]['Items'];
                                var Loaded = jdata[i]['Loaded'];
                                var Remaining = jdata[i]['Remaining'];
                                var table_strat_scrlData = "";
                                if (IsReceived == '1') {
                                    table_strat_scrlData = "<div class='table_strat_main'>" +
                                                    "<div class='top_ship table_strat'>" +
                                                        "<div class='bk_d expand_a' role='button' data-toggle='collapse' href='#can_a" + i + "' onclick='cancelActiveClass(this, \"" + BookingId + "\", " + i + ");' aria-expanded='false' aria-controls='collapseExample'><i class='fa fa-angle-down' aria-hidden='true'></i>" +
                                                        "</div>" +
                                                        "<div class='bk_d'><strong>" + BookingId + "</strong></div>" +
                                                        "<div class='bk_d'>" + Items + "</div>" +
                                                        "<div id='cancelloaded" + BookingId + "' class='bk_d'>" + Loaded + "</div>" +
                                                        "<div id='cancelremaining" + BookingId + "' class='bk_d'>" + Remaining + "</div>" +
                                                        "<div class='bk_d'> <input type='button' id='cancelall" + BookingId + "' class='btn btn-default add_all' onclick='receiveallBookingItem(\"" + BookingId + "\", " + i + ");' value='Receive All'> </div>" +
                                                    "</div>" +
                                                    "<div class='collapse' id='can_a" + i + "'>" +
                                                        "<div class='well'>" +
                                                            "<div class='clps_a'>" +

                                                                "<div class='pick_up_add'>" +
                                                                    "<div class='pick_up_flex'>" +
                                                                        "<div class='pk_add'>" +
                                                                            "<h6><span><img src='/images/pick_up.svg' alt=''></span>Pickup Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='cPickupName" + i + "' ></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='cPickupAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='cPickupEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='cPickupMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                        "<div class='pk_add dlvr_add'>" +
                                                                            "<h6><span><img src='/images/delivery.svg' alt=''></span>Delivery Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='cDeliveryName" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='cDeliveryAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='cDeliveryEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='cDeliveryMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                    "</div>" +
                                                                "</div>" +
                                                            "</div>" +

                                                            "<div class='item_details'>" +
                                                                "<table id='dtContainerItems" + i + "' class='exampleitem table table-striped table-bordered' style='width:100%'>" +
                                                                    "<thead>" +
                                                                        "<tr>" +
                                                                            "<th></th>" +
                                                                            "<th>Pickup Id</th>" +
                                                                            "<th>Items</th>" +
                                                                            "<th>Status</th>" +

                                                                        "</tr>" +
                                                                    "</thead>" +
                                                                    "<tbody>" +

                                                                    "</tbody>" +
                                                                "</table>" +
                                                            "</div>" +
                                                        "</div>" +
                                                    "</div>" +
                                                "</div>";

                                } else {
                                    table_strat_scrlData = "<div class='table_strat_main'>" +
                                                    "<div class='top_ship table_strat'>" +
                                                        "<div class='bk_d expand_a' role='button' data-toggle='collapse' href='#can_a" + i + "' onclick='cancelActiveClass(this, \"" + BookingId + "\", " + i + ");' aria-expanded='false' aria-controls='collapseExample'><i class='fa fa-angle-down' aria-hidden='true'></i>" +
                                                        "</div>" +
                                                        "<div class='bk_d'><strong>" + BookingId + "</strong></div>" +
                                                        "<div class='bk_d'>" + Items + "</div>" +
                                                        "<div id='cancelloaded" + BookingId + "' class='bk_d'>" + Loaded + "</div>" +
                                                        "<div id='cancelremaining" + BookingId + "' class='bk_d'>" + Remaining + "</div>" +
                                                        "<div class='bk_d'> <input type='button' id='cancelall" + BookingId + "' disabled='disabled' class='btn btn-default add_all' onclick='receiveallBookingItem(\"" + BookingId + "\", " + i + ");' value='Receive All'> </div>" +
                                                    "</div>" +
                                                    "<div class='collapse' id='can_a" + i + "'>" +
                                                        "<div class='well'>" +
                                                            "<div class='clps_a'>" +

                                                                "<div class='pick_up_add'>" +
                                                                    "<div class='pick_up_flex'>" +
                                                                        "<div class='pk_add'>" +
                                                                            "<h6><span><img src='/images/pick_up.svg' alt=''></span>Pickup Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='cPickupName" + i + "' ></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='cPickupAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='cPickupEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='cPickupMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                        "<div class='pk_add dlvr_add'>" +
                                                                            "<h6><span><img src='/images/delivery.svg' alt=''></span>Delivery Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='cDeliveryName" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='cDeliveryAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='cDeliveryEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='cDeliveryMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                    "</div>" +
                                                                "</div>" +
                                                            "</div>" +

                                                            "<div class='item_details'>" +
                                                                "<table id='dtContainerItems" + i + "' class='exampleitem table table-striped table-bordered' style='width:100%'>" +
                                                                    "<thead>" +
                                                                        "<tr>" +
                                                                            "<th></th>" +
                                                                            "<th>Pickup Id</th>" +
                                                                            "<th>Items</th>" +
                                                                            "<th>Status</th>" +

                                                                        "</tr>" +
                                                                    "</thead>" +
                                                                    "<tbody>" +

                                                                    "</tbody>" +
                                                                "</table>" +
                                                            "</div>" +
                                                        "</div>" +
                                                    "</div>" +
                                                "</div>";

                                }
                          
                                $("#cancel_table").append(table_strat_scrlData);

                            }

                        }
                        
                    },
                    error: function (response) {
                        alert("Error");
                    }
                });

            }


        function PopulateMapFromTo() {
            $.ajax({
                type: "POST",
                url: "ReceiveShipping.aspx/PopulateMapFromTo",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    debugger;
                    var Jdata = JSON.parse(result.d);
                    var len = Jdata.length;
                    //alert(Jdata[0]["LocationAddress"]);
                    if (len > 0)
                    {
                        $("#<%=ddlWarehouse.ClientID%>").val(Jdata[1]["WarehouseId"]);
                        $("#<%=txtCollectionAddressShippingFrom.ClientID%>").val(Jdata[0]["LocationAddress"]);
                        

                        var latlngCollectionStep1 = new google.maps.LatLng(Jdata[0]["Latitude"], Jdata[0]["Longitude"]);
                        myStep1CollectionOptions = {
                            zoom: 6,
                            center: latlngCollectionStep1,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };
                        mapCollection = new google.maps.Map(document.getElementById("CollectionMapShippingFrom"), myStep1CollectionOptions);
                    }
                    if (len > 1) {
                        $("#<%=txtCollectionAddressShippingTo.ClientID%>").val(Jdata[1]["LocationAddress"]);

                        var latlngCollectionStep1 = new google.maps.LatLng(Jdata[1]["Latitude"], Jdata[1]["Longitude"]);
                        myStep1CollectionOptions = {
                            zoom: 6,
                            center: latlngCollectionStep1,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };
                        mapCollection = new google.maps.Map(document.getElementById("CollectionMapShippingTo"), myStep1CollectionOptions);
                    }
                },
                error: function (response) {
                }
            });


        }
        function donotContainerReceiveCancel()
        {
            $('#ShippingDel-bx').modal('hide');
            return false;
        }

        function ContainerReceiveCancel() {
            
            CancelShipped();
            return true;
        }

        //function MarkContainerShippedModal()
        //{
        //    $('#ShippingDel-bx').modal('show');
        //    return false;
        //}

        function MarkContainerShipped()
        {
            var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            var Success = 0;

                //alert('PickupId= ' + PickupId + ' BookingId= ' + TempBookingId);
            var SealId = $("#<%=txtSealReferenceNumber.ClientID%>").val().trim();
            var ShippingFrom = $("#<%=txtCollectionAddressShippingFrom.ClientID%>").val().trim();
            var ShippingTo = $("#<%=txtCollectionAddressShippingTo.ClientID%>").val().trim();
            
            var ShippingDate = $("#<%=txtShippingDate.ClientID%>").val().trim();
            var ArrivalDate = $("#<%=txtArrivalDate.ClientID%>").val().trim();
            var ETA = $("#<%=txtETA.ClientID%>").val().trim(); 
            var Consignee = $("#<%=txtConsignee.ClientID%>").val().trim();
            var WarehouseId = $("#<%=ddlWarehouse.ClientID%>").find('option:selected').val().trim();

            //alert('ShippingId=' + ShippingId + " ContainerId=" + ContainerId + " SealId=" + SealId + " ShippingFrom=" + ShippingFrom + " ShippingTo=" + ShippingTo + " ShippingDate=" + ShippingDate + " ArrivalDate=" + ArrivalDate + " ETA=" + ETA + " Consignee=" + Consignee);
            var objShipping = {};

            objShipping.ShippingId = ShippingId;
            objShipping.ContainerId = ContainerId.toUpperCase();
            objShipping.SealId = SealId.toUpperCase();
            objShipping.ShippingFrom = ShippingFrom;
            objShipping.ShippingTo = ShippingTo;

            objShipping.ShippingDate = ShippingDate;
            objShipping.ArrivalDate = ArrivalDate;
            objShipping.ETA = ETA;
            objShipping.Consignee = Consignee;
            objShipping.WarehouseId = WarehouseId;

            //alert(JSON.stringify(objShipping));

            $.ajax({
                            type: "POST",
                            url: "ReceiveShipping.aspx/AddShippingInfo",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(objShipping),
                            dataType: "json",
                            async:false,
                            success: function (result) {
                            
                            },
                            error: function (response) {
                            }
            });



            var Jsondata = {};
            Jsondata.ShippingId = ShippingId;
            Jsondata.ContainerId = ContainerId;

            $.ajax({
                type: "POST",
                url: "ReceiveShipping.aspx/MarkContainerReceived",
                data: JSON.stringify(Jsondata),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                     Success = result.d;
                    
                },
                error: function (response) {
                }
            });

            if (Success > 0) {
                //alert('Container Received...');
                $('#<%=btnCancelShipped.ClientID%>').removeAttr('visible');

            }
        }

        function CancelShippedModal()
        {
            $('#<%=btnReceiveCancel.ClientID%>').removeAttr('disabled');
            $('#ShippingDel-bx').modal('show');
            return false;
        }

        function CancelShipped()
        {
            var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            var Success = 0;

                var Jsondata = {};
                    Jsondata.ShippingId = ShippingId;
                    Jsondata.ContainerId = ContainerId;

            $.ajax({
                type: "POST",
                url: "ReceiveShipping.aspx/CancelReceive",
                data: JSON.stringify(Jsondata),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                     Success = result.d;
                    
                },
                error: function (response) {
                }
            });

            if (Success > 0)
            {
                alert('Container Shipping Cancelled...');
                $('#<%=btnCancelShipped.ClientID%>').attr('visible', false);
             }
            
        }

        function getShippingReferenceNumber() {
            $.ajax({
                type: "POST",
                url: "ReceiveShipping.aspx/GetShippingReferenceNumber",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $('#<%=txtShippingReferenceNumber.ClientID%>').val(result.d);
                },
                error: function (response) {
                }
            });
            }

            function getAllBookingIds() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ReceiveShipping.aspx/GetAllBookingIds",
                    data: "{}",
                    dataType: "json",
                    success: function (data) {
                        $.each(data.d, function () {
                            $("#<%=ddlBookingId.ClientID%>").append($("<option></option>").val(this['Value']).html(this['Text']));
                        })
                    },
                    error: function (response) {
                    }
                });
            }

            function getContainerNoFromContainerNo(ContainerNo) {
                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ReceiveShipping.aspx/getContainerNoFromContainerNo",
                    data: "{ ContainerNo: '" + ContainerNo + "'}",
                    success: function (result) {
                        $("#<%=hfCustomerId.ClientID%>").val(result.d);
                    },
                    error: function (response) {
                        alert('Unable to Bind ContainerNo');
                    }
                });
                }

                function getAllLocationsUK() {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "ReceiveShipping.aspx/GetAllLocationsUK",
                        data: "{}",
                        dataType: "json",
                        success: function (data) {
                            $.each(data.d, function (key, value) {
                                //$("#=ddlShippingFrom.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                                //$("#=ddlShippingTo.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                            })
                        },
                        error: function (response) {
                        }
                    });
                }

                function getCustomerIdByBookingId(BookingId) {
                    $.ajax({
                        type: "POST",
                        url: "ReceiveShipping.aspx/GetCustomerIdByBookingId",
                        data: '{ BookingId: "' + BookingId + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            $('#<%=hfCustomerId.ClientID%>').val(result.d);
                        },
                        error: function (response) {
                        }
                    });
                    }

                    function getCustomerNameByBookingId(BookingId) {
                        $.ajax({
                            type: "POST",
                            url: "ReceiveShipping.aspx/GetCustomerNameByBookingId",
                            data: '{ BookingId: "' + BookingId + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {


                            },
                            error: function (response) {
                            }
                        });
                    }

                    function getOrderStatusByBookingId(BookingId) {
                        $.ajax({
                            type: "POST",
                            url: "ReceiveShipping.aspx/GetOrderStatusByBookingId",
                            data: '{ BookingId: "' + BookingId + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {


                            },
                            error: function (response) {
                            }
                        });
                    }

                    function getItemCountByBookingId(BookingId) {
                        $.ajax({
                            type: "POST",
                            url: "ReceiveShipping.aspx/GetItemCountByBookingId",
                            data: '{ BookingId: "' + BookingId + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {


                            },
                            error: function (response) {
                            }
                        });
                    }

                    function getInvoiceAmountByBookingId(BookingId) {
                        $.ajax({
                            type: "POST",
                            url: "ReceiveShipping.aspx/GetInvoiceAmountByBookingId",
                            data: '{ BookingId: "' + BookingId + '"}',
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {


                            },
                            error: function (response) {
                            }
                        });
                    }

                    function populateCustomerNameAndOrderStatusByBookingId(BookingId) {

                        getBookingInformationByBookingId(BookingId);

                        //getCustomerIdByBookingId(BookingId);
                        //getCustomerNameByBookingId(BookingId);
                        //getOrderStatusByBookingId(BookingId);
                        //getItemCountByBookingId(BookingId);
                        //getInvoiceAmountByBookingId(BookingId);
                    }
    </script>

    <script>
        var gCurrentLeftRow = 0;
        var gCurrentRightRow = 0;

        $(document).ready(function () {
            $("#dtBookingInformationByBookingId").css('display', 'none');
            $('#<%=hfShipped.ClientID%>').val('0');
            $('#<%=hfReceive.ClientID%>').val('0');
            getBookingInformationByBookingId('');
            
            var ContainerNo = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            if (ContainerNo == "Select Container") {
                var CN = getUrlVars();
                if (CN.length > 0)
                {
                    $("#<%=ddlContainerNo.ClientID%>").val(CN);
                    GetContainerDetails(CN, '');
                    GetShippingInfo(CN);
                }
                else
                {
                    //getShippingReferenceNumber();
                }
            }
            else {
                GetContainerDetails(ContainerNo, '');
                GetShippingInfo(ContainerNo);
            }
            

            //Dropdown change of BookingID
            $('#<%=ddlBookingId.ClientID%>').on('change', function () {
                getBookingInformationByBookingId(this.value);
            });

            //Dropdown change of ContainerNo
            $('#<%=ddlContainerNo.ClientID%>').on('change', function () {
                //var ContainerNo = this.value;
                GetShippingInfo(this.value);
                getBookingInformationByBookingId('');
                GetContainerDetails(this.value,'');
                
                //window.location.href = 'EditShipping.aspx?CN=' + ContainerNo;
            });

            function GetShippingInfo(ContainerNo)
            {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ReceiveShipping.aspx/GetShippingInfo",
                    data: "{ ContainerNo: '" + ContainerNo + "'}",
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var jdata = JSON.parse(result.d);
                        //alert(JSON.stringify(jdata));
                        var len = jdata.length;

                        if (len > 0) {
                            var ShippingId = jdata[0]['ShippingId'];
                            var SealId = jdata[0]['SealId'];
                            //var ShippingFrom = jdata[0]['ShippingFrom'];
                            //var ShippingTo = jdata[0]['ShippingTo'];
                            var ShippingDate = getFormattedDateUK(jdata[0]['ShippingDate']);
                            var ArrivalDate = getFormattedDateUK(jdata[0]['ArrivalDate']);
                            var ETA = getFormattedDateUK(jdata[0]['ETA']);
                            var Consignee = jdata[0]['Consignee'];
                            var Shipped = jdata[0]['Shipped'];
                            var WarehouseId = jdata[0]['WarehouseId'];
                            var UserId = jdata[0]['UserId'];
                            var Received = jdata[0]['Received'];
                            var GhanaPort = jdata[0]['GhanaPort'];

                            MakeShippingReadonly(Shipped, Received);

                            $('#<%=hfShipped.ClientID%>').val(Shipped);
                            $('#<%=hfReceive.ClientID%>').val(Received);

                            $("#<%=txtShippingReferenceNumber.ClientID%>").val(ShippingId);
                            $("#<%=txtSealReferenceNumber.ClientID%>").val(SealId);
                            $("#<%=txtShippingDate.ClientID%>").val(ShippingDate);
                            if (ArrivalDate == "01/01/2000") {
                                $("#<%=txtArrivalDate.ClientID%>").val('');
                            }
                            else {
                                $("#<%=txtArrivalDate.ClientID%>").val(ArrivalDate);
                            }
                            
                            $("#<%=txtETA.ClientID%>").val(ETA);
                            $("#<%=txtConsignee.ClientID%>").val(Consignee);
                            $("#<%=ddlWarehouse.ClientID%>").val(WarehouseId);
                            $("#<%=ddlGhanaPort.ClientID%>").val(GhanaPort);
                        }
                        else {
                            //$("#<%//=txtShippingReferenceNumber.ClientID%>").val('');
                                
                                $("#<%=txtSealReferenceNumber.ClientID%>").val('');
                                $("#<%=txtShippingDate.ClientID%>").val('');
                                $("#<%=txtArrivalDate.ClientID%>").val('');
                                $("#<%=txtETA.ClientID%>").val('');
                                $("#<%=txtConsignee.ClientID%>").val('');
                                //$("#<%//=ddlWarehouse.ClientID%>").val('');
                        }


                    },
                    error: function (response) {
                        alert("Error");
                    }
                });
            }

            function MakeShippingReadonly(Shipped, Received)
            {
                //alert(Shipped + ' ' + Received);
                if (Shipped > 0 && Received > 0) {
                $("#<%=btnMarkContainerShipped.ClientID%>").attr('disabled', 'disabled');
                $("#<%=btnMarkContainerShipped.ClientID%>").attr('value', 'Container Received');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('background-color', '#00cc00');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('color', '#fff');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('padding', '2px 5px 2px 5px');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('opacity', '0.6');
                $('input[type=submit]').attr('disabled', 'disabled');
                $('input [type=button]').attr('disabled', 'disabled');
                
                $("#<%=txtSealReferenceNumber.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtShippingDate.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtArrivalDate.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtETA.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtCollectionAddressShippingFrom.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtCollectionAddressShippingTo.ClientID%>").attr('disabled', 'disabled');
                $("#<%=txtConsignee.ClientID%>").attr('disabled', 'disabled');
                $('.add-row').attr('disabled', 'disabled');

                $('#<%=btnCancelShipped.ClientID%>').removeAttr('disabled');
                $("#<%=btnCancelShipped.ClientID%>").css('background-color', 'red');
                $("#<%=btnCancelShipped.ClientID%>").css('color', '#fff');
                $("#<%=btnCancelShipped.ClientID%>").css('padding', '2px 5px 2px 5px');
                $("#<%=btnCancelShipped.ClientID%>").css('opacity', '1');
            }
                else if (Shipped > 0 && Received == 0) {
                    $('input[type=submit]').removeAttr('disabled');
                    $('input [type=button]').removeAttr('disabled');
                    $("#<%=btnMarkContainerShipped.ClientID%>").css('background-color', '#ff9900');
                    $("#<%=btnMarkContainerShipped.ClientID%>").css('color', '#fff');
                    $("#<%=btnMarkContainerShipped.ClientID%>").css('padding', '2px 5px 2px 5px');
                    $("#<%=btnMarkContainerShipped.ClientID%>").css('opacity', '1');

                    $('#<%=btnCancelShipped.ClientID%>').attr('disabled', 'disabled');
                    $("#<%=btnCancelShipped.ClientID%>").css('background-color', 'red');
                    $("#<%=btnCancelShipped.ClientID%>").css('color', '#fff');
                    $("#<%=btnCancelShipped.ClientID%>").css('padding', '2px 5px 2px 5px');
                    $("#<%=btnCancelShipped.ClientID%>").css('opacity', '0.6');

//$("#<%=txtArrivalDate.ClientID%>").attr('disabled', 'disabled');
                }
                else
                {
                    $('#<%=btnCancelShipped.ClientID%>').attr('disabled', 'disabled');
                    $("#<%=btnCancelShipped.ClientID%>").css('opacity', '0.6');
                }
        }


            $(".add-row").click(function () {

                //$.blockUI({
                //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
                //    message: '<h4>Loading...</h4>',
                //    css: {
                //        border: 'none',
                //        //backgroundColor: 'transparent'
                //    }

                //});

                //mainMenu();

                $('#dvBookingNumberModal').modal('hide');

                var IsValid = 0;

                $("#dtBookingInformationByBookingId tbody").find('tr').each(function (i, el) {
                    var $tds = $(this).find('td');
                    var BookingId = $tds.eq(0).text();
                    var InvoiceNumber = $tds.eq(1).text();
                    var InvoiceAmount = $tds.eq(2).text();
                    var Paid = $tds.eq(3).text();
                    var Items = $tds.eq(4).text();
                    //var Loaded = $tds.eq(5).text();
                    //var Remaining = $tds.eq(6).text();
                    
                    var Loaded = 0;
                    var Remaining = 0;
                    Loaded = $("#<%=lblLoaded.ClientID%>").text().trim();
                    Remaining = $("#<%=lblRemaining.ClientID%>").text().trim();

                    //Check User Selected any Item or Not and Assign Total Loaded and Remaining From POPUP
                    $('#dvBookingItems tbody tr').each(function (i, row) {
                        var $actualrow = $(row);
                        $checkbox = $actualrow.find(':checkbox:checked');
                        if ($checkbox.is(':checked')) {
                            //Loaded++;
                            //Remaining--;
                            IsValid = 1;
                            //Append Selected Items To dvBookingItemsTemp Table

                            var PickupId = $(this).find('td:eq(1)').text().trim();
                            var CategoryFullName = $(this).find('td:eq(2)').text().trim();
                            var CategoryId = $(this).find('td:eq(3)').text().trim();
                            var CategoryItemId = $(this).find('td:eq(4)').text().trim();
                            var BookingId = $(this).find('td:eq(5)').text().trim();
                            //alert($(this).find('td:eq(1)').text().trim());

                            var newRowContent = "<tr>" +
                                "<td>" + CategoryFullName + "</td>" +
                                "<td>" + PickupId + "</td>" +
                                "<td>" + CategoryId + "</td>" +
                                "<td>" + CategoryItemId + "</td>" +
                                "<td>" + BookingId + "</td>" +
                                "</tr>";
                            $("#dvBookingItemsTemp tbody").append(newRowContent);

                        }
                    });
                    
                    //Check the BookingId is exists or not
                    $("#dtContainerBookingInformation tbody tr td:contains('" + BookingId + "')").each(function () {
                        alert('Booking information is present in the container');
                        IsValid = 0;
                    });

                    // Add Booking Info to Container...........
                    if (IsValid == 1) {
                        var newRowContent = "<tr>" +
                                "<td>" + BookingId + "</td>" +
                                "<td>" + InvoiceNumber + "</td>" +
                                "<td>" + InvoiceAmount + "</td>" +
                                "<td>" + Paid + "</td>" +
                                "<td>" + Items + "</td>" +
                                "<td>" + Loaded + "</td>" +
                                "<td>" + Remaining + "</td>" +
                                "<td><input id='btmDeleteContainerRow' type='button' value='Delete'></td>" +               
                                "</tr>";
                        $("#dtContainerBookingInformation tbody").append(newRowContent);
                    }
                });
            });

            //Called on click of Delete button from the Contailer Details
            $('#dtContainerBookingInformation').on('click', 'input[type="button"]', function (e) {
                //$('#ShippingDel-bx').modal('show');



                var retVal = confirm("Do you want to DELETE ?");
                if (retVal == true) {
                    var ClosestTr = $(this).closest('tr');
                    var BookingId = ClosestTr.find('td:eq(0)').text().trim();
                    //Delete From temp Item List also 

                    $('#dvBookingItemsTemp tbody tr').each(function (i, row) {
                        var TempBookingId = $(this).find('td:eq(4)').text().trim();
                        //alert('TempBookingId=' + TempBookingId);
                        if (BookingId == TempBookingId) {
                            var tempClosestTr = $(this).closest('tr');
                            tempClosestTr.remove();
                        }
                    });
                    ClosestTr.remove();
                    return true;
                }
                else {
                    return false;
                }
                //$(this).closest('tr').remove();
            });
            function deleteFromContainer(x) { }

            function donotDeleteFromCOntainer(x) { }
            // Called to make BookingId Clickable to display Modal POPUP
            $('#dtBookingInformationByBookingId tbody').on('click', 'tr', function (e) {
                //$.blockUI({
                //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
                //    message: '<h4>Loading...</h4>',
                //    css: {
                //        border: 'none',
                //        //backgroundColor: 'transparent'
                //    }

                //});

                //mainMenu();

                var ClosestTr = $(this).closest("tr");
                var BookingId = ClosestTr.find('td').eq(0).text();
                //alert(BookingId);
                getBookingInfoItemsFromBookingId(BookingId)
            })

            //Checkbox check and uncheck in the POPUP
            $('#dvBookingItems tbody').on('click', '.includeItem', function (e) {
                var Loaded = parseInt($(".Loaded").text());
                var Remaining = parseInt($(".Remaining").text());
                if ($(this).is(':checked')) {
                    Loaded++;
                    Remaining--;
                }
                else {
                    Loaded--;
                    Remaining++;
                }
                $("#<%=lblLoaded.ClientID%>").text(Loaded);
                $("#<%=lblRemaining.ClientID%>").text(Remaining);
            });


        });
        function addActiveClass(x, BookingId, row) {
            //alert('addActiveClass');
            $(x).toggleClass("active");
            
            //GetBookingInfoItemsFromBookingId
            if ($(x).hasClass("active")) {

                gCurrentLeftRow = row;
                
                getBookingInfoItemsFromBookingIdForAddTable(BookingId, '', row);
            }
        }

        function cancelActiveClass(x, BookingId, row) {
            //alert('addActiveClass');
            $(x).toggleClass("active");
            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            //alert(ContainerId)
            //GetBookingInfoItemsFromBookingId
            if ($(x).hasClass("active")) {
                gCurrentRightRow = row;
                getBookingInfoItemsFromBookingIdForCancelTable(BookingId, ContainerId, row);

               
            }
        }

        function addallBookingItem(BookingId , row)
        {
            //dtBookingItems0
            //$('#dtBookingItems' + row + ' tbody tr').each(function (i, row) {
            //    var PickupId = $(this).find('td:eq(1)').text().trim();
            //    alert('PickupId= ' + PickupId);
            //});
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
                    vErrMsg.text('');
                    vErrMsg.css("display", "none");
                    vErrMsg.css("background-color", "#ffd3d9");
                    vErrMsg.css("color", "red");
                    vErrMsg.css("text-align", "center");

            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            if (ContainerId.length > 0 && ContainerId != 'Select Container')
            {

                var JsonData = {};
                JsonData.BookingId = BookingId;
                JsonData.IsAdd = 2;
                JsonData.ContainerId = '';
                debugger;
                //alert(JSON.stringify(JsonData));
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ReceiveShipping.aspx/GetBookingInfoItemsFromBookingId",
                    data: JSON.stringify(JsonData),
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var jdata = JSON.parse(result.d);
                        var len = jdata.length;

                        if (len > 0)
                        {
                            for (var i = 0; i < len ; i++) {
                                var PickupId = jdata[i]["PickupId"];
                                //alert('PickupId ' + PickupId);
                                saveSingleShippingItem(BookingId, PickupId, row);
                            }
                        }
                        else
                        {
                            vErrMsg.text('There is no item available in the Warehouse');
                            vErrMsg.css("display", "block");
                            $('html,body').animate({
                                scrollTop: $('.welcome-message').offset().top
                            },
                            'slow');
                        }
                    },
                        error: function (response) {
                            debugger;
                            alert("Error : " + response);
                        }
            });
            } // If Block
            else {
                vErrMsg.text('Please Select The Container');
                vErrMsg.css("display", "block");
                $('html,body').animate({
                    scrollTop: $('.welcome-message').offset().top
                },
                'slow');
                    }
        } // End

        function receiveallBookingItem(BookingId, row)
        {
            //dtBookingItems0
            //$('#dtBookingItems' + row + ' tbody tr').each(function (i, row) {
            //    var PickupId = $(this).find('td:eq(1)').text().trim();
            //    alert('PickupId= ' + PickupId);
            //});
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
                    vErrMsg.text('');
                    vErrMsg.css("display", "none");
                    vErrMsg.css("background-color", "#ffd3d9");
                    vErrMsg.css("color", "red");
                    vErrMsg.css("text-align", "center");

            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            if (ContainerId.length > 0 && ContainerId != 'Select Container') {

                var JsonData = {};
                JsonData.BookingId = BookingId;
                JsonData.IsAdd = 1;
                JsonData.ContainerId = ContainerId;
                debugger;
                //alert(JSON.stringify(JsonData));
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ReceiveShipping.aspx/GetBookingInfoItemsFromBookingId",
                    data: JSON.stringify(JsonData),
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var jdata = JSON.parse(result.d);
                        var len = jdata.length;
                        if (len > 0)
                        {
                            for (var i = 0; i < len ; i++) {
                                var PickupId = jdata[i]["PickupId"];
                                //alert('PickupId ' + PickupId + 'BookingId ' + BookingId);
                                receiveSingleShippingItem(BookingId, PickupId, row);

                            }
                        }
                        else
                        {
                            vErrMsg.text('There is no item available in the Container');
                            vErrMsg.css("display", "block");
                            $('html,body').animate({
                                scrollTop: $('.welcome-message').offset().top
                            },
                            'slow');
                        }

                    },
                    error: function (response) {
                        debugger;
                        alert("Error : " + response);
                    }
                });
            } // If Block
            else
            {
                vErrMsg.text('Please Select The Container');
                vErrMsg.css("display", "block");
                $('html,body').animate({
                    scrollTop: $('.welcome-message').offset().top
                },
                'slow');
            }
        } // End

        function getBookingInformationByBookingId(BookingId) {
            //Called to populate Booking info on change of ddlBookingId Dropdown
            //alert(BookingId);
            //$("#dtBookingInformationByBookingId").css('display', 'table');
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ReceiveShipping.aspx/GetBookingInformationByBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                dataType: "json",
                //beforeSend: function () {
                //    //$("#loadingDiv").show();
                //    $("#loadingDiv").css('display', 'flex');
                //},
                //complete: function () {
                //    setTimeout(function () {
                //        $('#loadingDiv').fadeOut();
                //    }, 500);
                //},
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    var len = jdata.length;
                    //alert(len);
                    if (len > 0) {
                        

                       // debugger;
                        $("#add_table").html('');
                        for (var i = 0; i < len; i++)
                        {
                            var BookingId = jdata[i]['BookingId'];
                            var InvoiceNumber = jdata[i]['InvoiceNumber'];
                            var InvoiceAmount = jdata[i]['InvoiceAmount'];
                            var Paid = jdata[i]['Paid'];
                            var Items = jdata[i]['Items'];
                            var Loaded = jdata[i]['Loaded'];
                            var Remaining = jdata[i]['Remaining'];
                            var IsReceive = $('#<%=hfReceive.ClientID%>').val().trim();

                            var table_strat_scrlData = "";
                            //alert(IsShipped);
                            if (IsReceive == '1') {
                                table_strat_scrlData = "<div class='table_strat_main'>" +
                                                    "<div class='top_ship table_strat'>" +
                                                        "<div class='bk_d expand_a' role='button' data-toggle='collapse' href='#collapseExample" + i + "' onclick='addActiveClass(this, \"" + BookingId + "\", " + i + ");' aria-expanded='false' aria-controls='collapseExample'><i class='fa fa-angle-down' aria-hidden='true'></i>" +
                                                        "</div>" +
                                                       "<div class='bk_d'><strong>" + BookingId + "</strong></div>" +
                                                        "<div class='bk_d'>" + Items + "</div>" +
                                                        "<div id='addloaded" + BookingId + "' class='bk_d'>" + Loaded + "</div>" +
                                                        "<div id='addremaining" + BookingId + "' class='bk_d'>" + Remaining + "</div>" +
                                                        "<div class='bk_d' style='display:none;'> <input type='button' id='addall" + BookingId + "' class='btn btn-default add_all btn_red_can' onclick='addallBookingItem(\"" + BookingId + "\", " + i + ");' value='cancel all'> </div>" +
                                                    "</div>" +
                                                    "<div class='collapse' id='collapseExample" + i + "'>" +
                                                        "<div class='well'>" +
                                                            "<div class='clps_a'>" +

                                                                "<div class='pick_up_add'>" +
                                                                    "<div class='pick_up_flex'>" +
                                                                        "<div class='pk_add'>" +
                                                                            "<h6><span><img src='/images/pick_up.svg' alt=''></span>Pickup Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='PickupName" + i + "' ></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='PickupAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='PickupEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='PickupMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                        "<div class='pk_add dlvr_add'>" +
                                                                            "<h6><span><img src='/images/delivery.svg' alt=''></span>Delivery Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='DeliveryName" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='DeliveryAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='DeliveryEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='DeliveryMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                    "</div>" +
                                                                "</div>" +
                                                            "</div>" +


                                                            "<div class='item_details'>" +
                                                                "<table id='dtBookingItems" + i + "' class='exampleitem table table-striped table-bordered' style='width:100%'>" +
                                                                    "<thead>" +
                                                                        "<tr>" +
                                                                            "<th></th>" +
                                                                            "<th>Pickup Id</th>" +
                                                                            "<th>Items</th>" +
                                                                            "<th>Status</th>" +

                                                                        "</tr>" +
                                                                    "</thead>" +
                                                                    "<tbody>" +

                                                                    "</tbody>" +
                                                                "</table>" +
                                                            "</div>" +
                                                        "</div>" +
                                                    "</div>" +
                                                    "</div>";
                            }
                            else {
                                table_strat_scrlData = "<div class='table_strat_main'>" +
                                                    "<div class='top_ship table_strat'>" +
                                                        "<div class='bk_d expand_a' role='button' data-toggle='collapse' href='#collapseExample" + i + "' onclick='addActiveClass(this, \"" + BookingId + "\", " + i + ");' aria-expanded='false' aria-controls='collapseExample'><i class='fa fa-angle-down' aria-hidden='true'></i>" +
                                                        "</div>" +
                                                       "<div class='bk_d'><strong>" + BookingId + "</strong></div>" +
                                                        "<div class='bk_d'>" + Items + "</div>" +
                                                        "<div id='addloaded" + BookingId + "' class='bk_d'>" + Loaded + "</div>" +
                                                        "<div id='addremaining" + BookingId + "' class='bk_d'>" + Remaining + "</div>" +
                                                        "<div class='bk_d' style='display:none;'> <input type='button' id='addall" + BookingId + "' disabled='disabled' class='btn btn-default add_all' onclick='addallBookingItem(\"" + BookingId + "\", " + i + ");' value='add all'> </div>" +
                                                    "</div>" +
                                                    "<div class='collapse' id='collapseExample" + i + "'>" +
                                                        "<div class='well'>" +
                                                            "<div class='clps_a'>" +

                                                                "<div class='pick_up_add'>" +
                                                                    "<div class='pick_up_flex'>" +
                                                                        "<div class='pk_add'>" +
                                                                            "<h6><span><img src='/images/pick_up.svg' alt=''></span>Pickup Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='PickupName" + i + "' ></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='PickupAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='PickupEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='PickupMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                        "<div class='pk_add dlvr_add'>" +
                                                                            "<h6><span><img src='/images/delivery.svg' alt=''></span>Delivery Address</h6>" +
                                                                            "<p><i class='fa fa-user-o' aria-hidden='true'></i><span id='DeliveryName" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-map-marker' aria-hidden='true'></i><span id='DeliveryAddress" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-envelope-o' aria-hidden='true'></i><span id='DeliveryEmail" + i + "'></span></p>" +
                                                                            "<p><i class='fa fa-phone' aria-hidden='true'></i><span id='DeliveryMobile" + i + "'></span></p>" +
                                                                        "</div>" +
                                                                    "</div>" +
                                                                "</div>" +
                                                            "</div>" +


                                                            "<div class='item_details'>" +
                                                                "<table id='dtBookingItems" + i + "' class='exampleitem table table-striped table-bordered' style='width:100%'>" +
                                                                    "<thead>" +
                                                                        "<tr>" +
                                                                            "<th></th>" +
                                                                            "<th>Pickup Id</th>" +
                                                                            "<th>Items</th>" +
                                                                            "<th>Status</th>" +

                                                                        "</tr>" +
                                                                    "</thead>" +
                                                                    "<tbody>" +

                                                                    "</tbody>" +
                                                                "</table>" +
                                                            "</div>" +
                                                        "</div>" +
                                                    "</div>" +
                                                    "</div>";
                            }
                            

                            $("#add_table").append(table_strat_scrlData);

                        }
                        
                    }
                },
                error: function (response) {
                    debugger;
                    alert("Error : " + response);
                }
            });
        }


        function getBookingInfoItemsFromBookingIdForAddTable(BookingId, ContainerId, row) {
            // alert(BookingId);
            var JsonData = {};
            JsonData.BookingId = BookingId;
            JsonData.IsAdd = 1;
            JsonData.ContainerId = ContainerId;
            debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ReceiveShipping.aspx/GetBookingInfoItemsFromBookingId",
                data: JSON.stringify(JsonData),
                dataType: "json",
                async: false,
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 500);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    clearShippingModalPopup();
                    var len = jdata.length;
                    //alert("Length=" + len + " BookingId=" + jdata[0]["BookingId"]);
                    //debugger;
                    if (len > 0) { 
                    $("#PickupName" + row).text(jdata[0]["PickupName"]);
                    $("#PickupAddress" + row).text(jdata[0]["PickupAddress"]);
                    
                    $("#PickupEmail" + row).text(jdata[0]["PickupEmail"]);
                    $("#PickupMobile" + row).text(jdata[0]["PickupMobile"]);
                    
                    $("#DeliveryName" + row).text(jdata[0]["DeliveryName"]);
                    $("#DeliveryAddress" + row).text(jdata[0]["RecipentAddress"]);
                    $("#DeliveryMobile" + row).text(jdata[0]["DeliveryMobile"]);
                    
                    $("#DeliveryEmail" + row).text(jdata[0]["DeliveryEmail"]);

                    $("#BookingNotes" + row).text(jdata[0]["BookingNotes"]);

                    $('#dtBookingItems' + row + ' tbody').html('');

                    for (var i = 0; i < len; i++)
                    {
                        var tableContent = "";
                        if (jdata[i]["Shipped"] == 0) {
                            if (jdata[i]["IsPickedForShipping"] > 0) {
                                //alert(jdata[i]["IsPickedForShipping"]);
                                tableContent += "<tr>" +
                                                   "<td><input type='button' class='btn btn-default' disabled value='received' ></td>" +
                                                   "<td>" + jdata[i]["PickupId"] + "</td>" +
                                                   "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                                   "<td>" + jdata[i]["Status"] + "</td>" +
                                               "</tr>";
                            }
                            else {
                                //alert(jdata[i]["IsPickedForShipping"]);
                                var IsReceive = $('#<%=hfReceive.ClientID%>').val().trim();
                                //alert(IsShipped);
                                if (IsReceive == '1') {
                                    tableContent += "<tr>" +
                                                   "<td><input type='button' class='btn btn-default' value='Cancel' onclick='return saveSingleShippingItem(\"" + BookingId + "\", \"" + jdata[i]["PickupId"] + "\", " + row + ");'></td>" +
                                                   "<td>" + jdata[i]["PickupId"] + "</td>" +
                                                   "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                                   "<td>" + jdata[i]["Status"] + "</td>" +
                                               "</tr>";
                                } else {
                                    tableContent += "<tr>" +
                                                   "<td><input type='button' class='btn btn-default' value='Cancel' disabled='disabled' onclick='return saveSingleShippingItem(\"" + BookingId + "\", \"" + jdata[i]["PickupId"] + "\", " + row + ");'></td>" +
                                                   "<td>" + jdata[i]["PickupId"] + "</td>" +
                                                   "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                                   "<td>" + jdata[i]["Status"] + "</td>" +
                                               "</tr>";
                                }
                                
                            }
                        }
                        else {
                            tableContent += "<tr>" +
                                                   "<td><input type='button' class='btn btn-default' disabled value='shipped'></td>" +
                                                   "<td>" + jdata[i]["PickupId"] + "</td>" +
                                                   "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                                   "<td>" + jdata[i]["Status"] + "</td>" +
                                               "</tr>";
                        }
                        $('#dtBookingItems' + row + ' tbody').append(tableContent);
                    }

                    }
                        },
                            error: function (response) {
                                alert("Error");
                        }
                        });
        }

        function getBookingInfoItemsFromBookingIdForCancelTable(BookingId, ContainerId, row) {
            // alert(BookingId);
            var JsonData = {};
            JsonData.BookingId = BookingId;
            JsonData.IsAdd = 1;
            JsonData.ContainerId = ContainerId;
             debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ReceiveShipping.aspx/GetBookingInfoItemsFromBookingId",
                data: JSON.stringify(JsonData),
                dataType: "json",
                async: false,
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 500);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    clearShippingModalPopup();
                    var len = jdata.length;
                    //alert("Length=" + len + " BookingId=" + jdata[0]["BookingId"]);
                    //debugger;
                    if (len > 0) {
                        $("#cPickupName" + row).text(jdata[0]["PickupName"]);
                        $("#cPickupAddress" + row).text(jdata[0]["PickupAddress"]);

                        $("#cPickupEmail" + row).text(jdata[0]["PickupEmail"]);
                        $("#cPickupMobile" + row).text(jdata[0]["PickupMobile"]);

                        $("#cDeliveryName" + row).text(jdata[0]["DeliveryName"]);
                        $("#cDeliveryAddress" + row).text(jdata[0]["RecipentAddress"]);
                        $("#cDeliveryMobile" + row).text(jdata[0]["DeliveryMobile"]);

                        $("#cDeliveryEmail" + row).text(jdata[0]["DeliveryEmail"]);

                        $("#cBookingNotes" + row).text(jdata[0]["BookingNotes"]);

                        $('#dtContainerItems' + row + ' tbody').html('');
                        var IsReceive = $('#<%=hfReceive.ClientID%>').val().trim();
                        for (var i = 0; i < len; i++) {
                            var tableContent = "";
                            if (jdata[i]["Shipped"] == 0) {
                                if (jdata[i]["IsPickedForShipping"] > 0) {
                                    //alert(jdata[i]["IsPickedForShipping"]);
                                    if (IsReceive == '1') {
                                        tableContent += "<tr>" +
                                                       "<td><input type='button' class='btn btn-default cancel recei_can' value='Receive' onclick='return receiveSingleShippingItem(\"" + BookingId + "\", \"" + jdata[i]["PickupId"] + "\", " + row + ");' ></td>" +
                                                       "<td>" + jdata[i]["PickupId"] + "</td>" +
                                                       "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                                       "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                                       "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                                       "<td>" + jdata[i]["Status"] + "</td>" +
                                                   "</tr>";
                                    }
                                    else {
                                        tableContent += "<tr>" +
                                                       "<td><input type='button' class='btn btn-default cancel recei_can' value='Receive' disabled='disabled' onclick='return receiveSingleShippingItem(\"" + BookingId + "\", \"" + jdata[i]["PickupId"] + "\", " + row + ");' ></td>" +
                                                       "<td>" + jdata[i]["PickupId"] + "</td>" +
                                                       "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                                       "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                                       "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                                       "<td>" + jdata[i]["Status"] + "</td>" +
                                                   "</tr>";
                                    }
                                    
                                }
                                //else
                                //{
                                //    //alert(jdata[i]["IsPickedForShipping"]);
                                //     tableContent += "<tr>" +
                                //                        "<td><input type='button' class='btn btn-default cancel' value='remove'></td>" +
                                //                        "<td>" + jdata[i]["PickupId"] + "</td>" +
                                //                        "<td>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                //                        //"<td>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                //                        //"<td>" + jdata[i]["EstimatedValue"] + "</td>" +
                                //                        "<td>" + jdata[i]["Status"] + "</td>" +
                                //                    "</tr>";
                                //}
                            }

                            $('#dtContainerItems' + row + ' tbody').append(tableContent);
                        }

                    }
                },
                error: function (response) {
                    debugger;
                    alert("Error");
                }
            });
        }

        function saveSingleShippingItem(BookingId, PickupId, row) {

            if (checkBlankControls()) {
                debugger;
                //alert('saveSingleShippingItem function' + BookingId + ' ' + PickupId + ' ' + row);
                var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
                var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
                var SealId = $("#<%=txtSealReferenceNumber.ClientID%>").val().trim();
                var ShippingFrom = $("#<%=txtCollectionAddressShippingFrom.ClientID%>").val().trim();
                var ShippingTo = $("#<%=txtCollectionAddressShippingTo.ClientID%>").val().trim();

                var ShippingDate = $("#<%=txtShippingDate.ClientID%>").val().trim();
                var ArrivalDate = $("#<%=txtArrivalDate.ClientID%>").val().trim();
                var ETA = $("#<%=txtETA.ClientID%>").val().trim();
                var Consignee = $("#<%=txtConsignee.ClientID%>").val().trim();
                var WarehouseId = $("#<%=ddlWarehouse.ClientID%>").find('option:selected').val().trim();

                //alert('ShippingId=' + ShippingId + " ContainerId=" + ContainerId + " SealId=" + SealId + " ShippingFrom=" + ShippingFrom + " ShippingTo=" + ShippingTo + " ShippingDate=" + ShippingDate + " ArrivalDate=" + ArrivalDate + " ETA=" + ETA + " Consignee=" + Consignee);
                var objShipping = {};

                objShipping.ShippingId = ShippingId;
                objShipping.ContainerId = ContainerId.toUpperCase();
                objShipping.BookingId = BookingId;
                objShipping.PickupId = PickupId;
                objShipping.SealId = SealId.toUpperCase();
                objShipping.ShippingFrom = ShippingFrom;
                objShipping.ShippingTo = ShippingTo;

                objShipping.ShippingDate = ShippingDate;
                objShipping.ArrivalDate = ArrivalDate;
                objShipping.ETA = ETA;
                objShipping.Consignee = Consignee;
                objShipping.WarehouseId = WarehouseId;

                //alert(JSON.stringify(objShipping));

                $.ajax({
                    type: "POST",
                    url: "ReceiveShipping.aspx/AddShippingDetails",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify(objShipping),
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        //alert('Add Successful');
                        getBookingInformationByBookingId('');
                        GetContainerDetails(ContainerId, '');

                        var addloaded = parseInt($('#addloaded' + BookingId).text().trim());
                        $('#addloaded' + BookingId).text(addloaded + 1);

                        var addremaining = parseInt($('#addremaining' + BookingId).text().trim());
                        $('#addremaining' + BookingId).text(addremaining - 1);

                        var cancelloaded = parseInt($('#cancelloaded' + BookingId).text().trim());
                        $('#cancelloaded' + BookingId).text(cancelloaded + 1);

                        var cancelremaining = parseInt($('#cancelremaining' + BookingId).text().trim());
                        $('#cancelremaining' + BookingId).text(cancelremaining - 1);
                        
                        getBookingInfoItemsFromBookingIdForAddTable(BookingId, '', gCurrentLeftRow);
                        getBookingInfoItemsFromBookingIdForCancelTable(BookingId, ContainerId, gCurrentRightRow);

                    },
                    error: function (response) {
                        alert('Error');
                    }
                });
            }
            return false;
        }

        function removeSingleShippingItem(BookingId, PickupId, row) {
            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            var objShipping = {};
            objShipping.ContainerId = ContainerId;
            objShipping.BookingId = BookingId;
            objShipping.PickupId = PickupId;
            
            $.ajax({
                type: "POST",
                url: "ReceiveShipping.aspx/RemoveShippingDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objShipping),
                dataType: "json",
                async: false,
                success: function (result) {
                    //alert('Delete Successful');
                    getBookingInformationByBookingId('');
                    GetContainerDetails(ContainerId, '');
                    var addloaded = parseInt($('#addloaded' + BookingId).text().trim());
                    $('#addloaded' + BookingId).text(addloaded - 1);

                    var addremaining = parseInt($('#addremaining' + BookingId).text().trim());
                    $('#addremaining' + BookingId).text(addremaining + 1);

                    var cancelloaded = parseInt($('#cancelloaded' + BookingId).text().trim());
                    $('#cancelloaded' + BookingId).text(cancelloaded - 1);

                    var cancelremaining = parseInt($('#cancelremaining' + BookingId).text().trim());
                    $('#cancelremaining' + BookingId).text(cancelremaining + 1);

                    getBookingInfoItemsFromBookingIdForAddTable(BookingId, '', gCurrentLeftRow);
                    getBookingInfoItemsFromBookingIdForCancelTable(BookingId, ContainerId, gCurrentRightRow);
                },
                error: function (response) {
                    alert('Error');
                }
            });
        }


        function addShippingDetails() {
            //alert('addShippingDetails function');
            var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            var SealId = $("#<%=txtSealReferenceNumber.ClientID%>").val().trim();
            var ShippingFrom = $("#<%=txtCollectionAddressShippingFrom.ClientID%>").val().trim();
            var ShippingTo = $("#<%=txtCollectionAddressShippingTo.ClientID%>").val().trim();
            
            var ShippingDate = $("#<%=txtShippingDate.ClientID%>").val().trim();
            var ArrivalDate = $("#<%=txtArrivalDate.ClientID%>").val().trim();
            var ETA = $("#<%=txtETA.ClientID%>").val().trim(); 
            var Consignee = $("#<%=txtConsignee.ClientID%>").val().trim();
            var WarehouseId = $("#<%=ddlWarehouse.ClientID%>").find('option:selected').val().trim();

            //alert('ShippingId=' + ShippingId + " ContainerId=" + ContainerId + " SealId=" + SealId + " ShippingFrom=" + ShippingFrom + " ShippingTo=" + ShippingTo + " ShippingDate=" + ShippingDate + " ArrivalDate=" + ArrivalDate + " ETA=" + ETA + " Consignee=" + Consignee);
            var objShipping = {};

            objShipping.ShippingId = ShippingId;
            objShipping.ContainerId = ContainerId.toUpperCase();
            objShipping.SealId = SealId.toUpperCase();
            objShipping.ShippingFrom = ShippingFrom;
            objShipping.ShippingTo = ShippingTo;

            objShipping.ShippingDate = ShippingDate;
            objShipping.ArrivalDate = ArrivalDate;
            objShipping.ETA = ETA;
            objShipping.Consignee = Consignee;
            objShipping.WarehouseId = WarehouseId;

            //alert(JSON.stringify(objShipping));

            $.ajax({
                            type: "POST",
                            url: "ReceiveShipping.aspx/AddShippingInfo",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(objShipping),
                            dataType: "json",
                            success: function (result) {
                    

                    //$('#dtContainerBookingInformation tbody > tr').each(function ()
                    //    {
                    //    var BookingId = $(this).find('td:eq(0)').text().trim();
                    //    var Loaded = $(this).find('td:eq(5)').text().trim();
                    //    var Remaining = $(this).find('td:eq(6)').text().trim();
                    //    objCBI = {};
                    //    objCBI.ShippingId = ShippingId;
                    //    objCBI.ContainerId = ContainerId.toUpperCase();
                    //    objCBI.BookingId = BookingId;
                    //    objCBI.Loaded = Loaded;
                    //    objCBI.Remaining = Remaining;

                    //    //alert(JSON.stringify(objCBI));

                    //    $.ajax({
                    //        type: "POST",
                    //        url: "ReceiveShipping.aspx/AddContainerBookingInfo",
                    //        contentType: "application/json; charset=utf-8",
                    //        data: JSON.stringify(objCBI),
                    //        dataType: "json",
                    //        success: function (result) {
                    //            //alert('AddContainerBookingInfo Success');
                    //            //Item data need to be saved
                    //            $('#dvBookingItemsTemp tbody tr').each(function (i, row) {

                    //                    var PickupId = $(this).find('td:eq(1)').text().trim();
                    //                    var CategoryId = $(this).find('td:eq(2)').text().trim();
                    //                    var CategoryItemId = $(this).find('td:eq(3)').text().trim();
                    //                    var TempBookingId = $(this).find('td:eq(4)').text().trim();

                    //                    if (TempBookingId==BookingId) {
                                        
                    //                        objCSII = {};
                    //                        objCSII.ShippingId = ShippingId;
                    //                        objCSII.ContainerId = ContainerId.toUpperCase();
                    //                        objCSII.BookingId = BookingId;
                    //                        objCSII.PickupId = PickupId;
                    //                        objCSII.CategoryId = CategoryId;
                    //                        objCSII.CategoryItemId = CategoryItemId;

                    //                        //alert('CategoryId=' + CategoryId + ' CategoryItemId=' + CategoryItemId);
                    //                        //alert(JSON.stringify(objCSII));

                    //                        $.ajax({
                    //                            type: "POST",
                    //                            url: "ReceiveShipping.aspx/AddContainerShippingItemInfo",
                    //                            contentType: "application/json; charset=utf-8",
                    //                            data: JSON.stringify(objCSII),
                    //                            dataType: "json",
                    //                            success: function (result) {
                    //                                //alert('AddContainerBookingItemInfo Success');

                    //                            },
                    //                            error: function (response) {

                    //                            }
                    //                        });//end of AddContainerShippingItemInfo 

                    //                    }
                                         
                                      
                    //    });

                    //    },
                    //        error: function (response) {

                    //    }
                    //    });//end of AddContainerBookingInfo

                    //    });
                        $('#Shipping-bx').modal('show');
                        },
                            error: function (response) {
                            alert('Add Shipping failed');
                        }
                        });

            return false;
                        }

        function saveShipping() {
            if (checkBlankControls()) {
                //alert('Save alert');
                addShippingDetails();
                        }

            return false;
        }


        function receiveSingleShippingItem(BookingId, PickupId, row) {
            var ContainerId = $("#<%=ddlContainerNo.ClientID%>").find('option:selected').text().trim();
            var objShipping = {};
            objShipping.ContainerId = ContainerId;
            objShipping.BookingId = BookingId;
            objShipping.PickupId = PickupId;
            
            $.ajax({
                type: "POST",
                url: "ReceiveShipping.aspx/ReceiveShippingDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objShipping),
                dataType: "json",
                async: false,
                success: function (result) {
                    //alert('Delete Successful');
                    getBookingInformationByBookingId('');
                    GetContainerDetails(ContainerId, '');
                    //var addloaded = parseInt($('#addloaded' + BookingId).text().trim());
                    //$('#addloaded' + BookingId).text(addloaded - 1);

                    //var addremaining = parseInt($('#addremaining' + BookingId).text().trim());
                    //$('#addremaining' + BookingId).text(addremaining + 1);

                    //var cancelloaded = parseInt($('#cancelloaded' + BookingId).text().trim());
                    //$('#cancelloaded' + BookingId).text(cancelloaded - 1);

                    //var cancelremaining = parseInt($('#cancelremaining' + BookingId).text().trim());
                    //$('#cancelremaining' + BookingId).text(cancelremaining + 1);

                    getBookingInfoItemsFromBookingIdForAddTable(BookingId, '', gCurrentLeftRow);
                    getBookingInfoItemsFromBookingIdForCancelTable(BookingId, ContainerId, gCurrentRightRow);
                },
                error: function (response) {
                    alert('Error');
                }
            });
        }


        function getAllWarehouse()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ReceiveShipping.aspx/GetAllWarehouse",
            data: "{}",
            dataType: "json",
            success: function ( data )
            {
                $("#<%=ddlWarehouse.ClientID%>").html("");
                $("#<%=ddlWarehouse.ClientID%>").append($("<option></option>").val('Select Warehouse').html('Select Warehouse'));
                $.each( data.d, function ()
                {
                    $( "#<%=ddlWarehouse.ClientID%>" ).append( $( "<option></option>" ).val( this['Value'] ).html( this['Text'] ) );
                } )
            },
            error: function ( response )
            {
            }
        } );
    }

    </script>
    <%--Add Google map api--%>
    <style>
        #CollectionMapShippingFrom, #CollectionMapShippingTo {
            height: 200px;
            width: 400px;
        }
    </style>
    <%--<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap" async="async" defer="defer"></script>--%>
    
    
    <script>

        if (typeof google === 'object' && typeof google.maps === 'object') {
            InitializeMap();
        } else {
            $.getScript('https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap', function () {
                InitializeMap();
            });
        }


        function InitializeMap(){

            var latlng = new google.maps.LatLng( -34.397, 150.644 );

            var myCollectionOptions = {
                            zoom: 6,
                            center: latlng,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };
            var CollectionMap = new google.maps.Map( document.getElementById( "CollectionMapShippingFrom" ), myCollectionOptions );

            var myDeliveryOptions = {
                            zoom: 6,
                            center: latlng,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };
            var DeliveryMap = new google.maps.Map(document.getElementById("CollectionMapShippingTo"), myDeliveryOptions);

            var defaultCollectionBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng( -33.8902, 151.1759 ),
                new google.maps.LatLng( -33.8474, 151.2631 )
                );

            var optionsCollection = {
                            bounds: defaultCollectionBounds
                        };

            var defaultDeliveryBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng( -33.8902, 151.1759 ),
                new google.maps.LatLng( -33.8474, 151.2631 )
                );

            var optionsDelivery = {
                            bounds: defaultDeliveryBounds
                        };

            google.maps.event.addDomListener( window, 'load', function ()
                        {
                var placesCollection = new google.maps.places.Autocomplete( document.getElementById( '<%=txtCollectionAddressShippingFrom.ClientID%>' ), optionsCollection );
                var placesDelivery = new google.maps.places.Autocomplete( document.getElementById( '<%=txtCollectionAddressShippingTo.ClientID%>' ), optionsDelivery );

                google.maps.event.addListener( placesCollection, 'place_changed', function ()
                        {
                    var placeCollection = placesCollection.getPlace();
                    var addressCollection = placeCollection.formatted_address;
                    var latitudeCollection = placeCollection.geometry.location.lat();
                    var longitudeCollection = placeCollection.geometry.location.lng();

                    //var msgCollection = "Address: " + addressCollection;
                    //msgCollection += "\nLatitude: " + latitudeCollection;
                    //msgCollection += "\nLongitude: " + longitudeCollection;

                    //alert(msgCollection);

                    var latlngCollection = new google.maps.LatLng( latitudeCollection, longitudeCollection );

                    myCollectionOptions = {
                            zoom: 8,
                            center: latlngCollection,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };

                    mapCollection = new google.maps.Map(document.getElementById("CollectionMapShippingFrom"), myCollectionOptions);
                    document.getElementById( "CollectionMapShippingFrom" ).style.width = document.getElementById( "<%=txtCollectionAddressShippingFrom.ClientID%>" ).style.width;
                        } );

                google.maps.event.addListener( placesDelivery, 'place_changed', function ()
                        {
                    var placeDelivery = placesDelivery.getPlace();
                    var addressDelivery = placeDelivery.formatted_address;
                    var latitudeDelivery = placeDelivery.geometry.location.lat();
                    var longitudeDelivery = placeDelivery.geometry.location.lng();

                    //var msgDelivery = "Address: " + addressDelivery;
                    //msgDelivery += "\nLatitude: " + latitudeDelivery;
                    //msgDelivery += "\nLongitude: " + longitudeDelivery;

                    //alert(msgDelivery);

                    var latlngDelivery = new google.maps.LatLng( latitudeDelivery, longitudeDelivery );

                    myDeliveryOptions = {
                            zoom: 8,
                            center: latlngDelivery,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };

                    mapDelivery = new google.maps.Map(document.getElementById("CollectionMapShippingTo"), myDeliveryOptions);
                    document.getElementById("CollectionMapShippingTo").style.width = document.getElementById("<%=txtCollectionAddressShippingTo.ClientID%>").style.width;
                        } );

                        } );
                        }
    </script>
    <%--<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB-nhRE7PzI8XvJrAuQA355Yw9FQKPLoFg&libraries=places&callback=initMap" async defer></script>--%>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
            <div class="col-lg-12 text-center welcome-message">
                <h2><span class="add_clr_head">Receive</span> Shipping
                </h2>
                <p></p>
            </div>

            <div class="col-md-12">
                <form id="frmAddShipping" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />
                    <asp:HiddenField ID="hfShipped" runat="server" />
                    <asp:HiddenField ID="hfReceive" runat="server" />

                    <div class="add_shipping_form row">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <asp:HiddenField ID="hfCustomerId" runat="server" />
                        </div>
                        <div id="clm_adjust" class="panel-body clrBLK col-md-12 dashboad-form pannel-body-receive-shipping">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping Ref</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtShippingReferenceNumber" runat="server"
                                                CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            <%--    <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Container Number<span style="color: red">*</span></label>
                                        <div id="divddlContainerNo" class="col-sm-6">
                                            <asp:DropDownListChosen ID="ddlContainerNo" runat="server"
                                                CssClass="vat-option label-lgt"
                                                DataPlaceHolder="Please select an option"
                                                AllowSingleDeselect="true"
                                                NoResultsText="No result found"
                                                DisableSearchThreshold="10">
                                                <asp:ListItem Selected="True">Select Container Number</asp:ListItem>
                                            </asp:DropDownListChosen>
                                        </div>
                                    </div>
                                </div>--%>
                                 <div class="col-md-4">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Container No<span style="color: red">*</span></label>
                                        <div id="divddlContainerNo" class="col-sm-6">
                                            <asp:DropDownListChosen ID="ddlContainerNo" runat="server"
                                                CssClass="vat-option label-lgt"
                                                DataPlaceHolder="Please select an option"
                                                AllowSingleDeselect="true"
                                                NoResultsText="No result found"
                                                DisableSearchThreshold="10">
                                                <asp:ListItem Selected="True">Select Container Number</asp:ListItem>
                                            </asp:DropDownListChosen>
                                        </div>
                                    </div>
                                </div>
                                 <div class="col-md-4">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Seal Ref No<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtSealReferenceNumber" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="e.g. 892/1 2/2009-CX"
                                                title="Please enter Seal Reference Number" Style="text-transform: uppercase;"
                                                MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                
                               
                                <div class="col-md-6" style="display:none;">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping Date<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtShippingDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onchange="clearErrorMessage();checkShippingAndArrivalDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6" style="display:none;">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            ETA of Container</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtETA" runat="server"
                                                CssClass="form-control m-b"
                                                title="Please enter Conignee"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                

                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping From<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <input type="text" id="txtCollectionAddressShippingFrom" class="form-control"
                                                placeholder="Enter a Collection Location" title="" disabled="disabled"
                                                onkeypress="clearErrorMessage();" runat="server" />
                                            <div id="CollectionMapShippingFrom"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping To<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <input type="text" id="txtCollectionAddressShippingTo" class="form-control"
                                                placeholder="Enter a Collection Location" title="" disabled="disabled"
                                                onkeypress="clearErrorMessage();" runat="server" />
                                            <div id="CollectionMapShippingTo"></div>
                                        </div>
                                    </div>
                                </div>    
                                
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Consignee</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtConsignee" runat="server" TextMode="MultiLine"
                                                CssClass="form-control m-b" PlaceHolder=""
                                                title="Please enter Conignee" MaxLength="500"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                 <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Arrival Date<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtArrivalDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onchange="clearErrorMessage();checkShippingAndArrivalDate()"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                                            
                             <%--   <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Consignee</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtConsignee" runat="server" TextMode="MultiLine"
                                                CssClass="form-control m-b" PlaceHolder=""
                                                title="Please enter Conignee" MaxLength="500"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>--%>
                                <div class="col-md-6" style="display:none;">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Destination Warehouse<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlWarehouse" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6" style="display:none;">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Ghana Port<span style="color: red"></span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlGhanaPort" runat="server" Enabled="false"  >
                                                <asp:ListItem Text="" Value="" Selected="True">Select Port</asp:ListItem>
                                                <asp:ListItem Value="Accra">Accra</asp:ListItem>
                                                <asp:ListItem Value="Kumasi">Kumasi</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6" style="display:none;">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Booking Number<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownListChosen ID="ddlBookingId" runat="server"
                                                CssClass="vat-option label-lgt"
                                                DataPlaceHolder="Please select an option"
                                                AllowSingleDeselect="true"
                                                NoResultsText="No result found"
                                                DisableSearchThreshold="10">
                                                <asp:ListItem Selected="True">Select Booking Number</asp:ListItem>
                                            </asp:DropDownListChosen>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            


                            

                            

                            


                            


                            <%--<table border="1" style="color: white; width: 100%;" id="dtBookingInformationByBookingId">
                                <thead>
                                    <tr>
                                        <th>Booking Id</th>
                                        <th>Invoice Number</th>
                                        <th>Invoice Amount</th>
                                        <th>Paid</th>
                                        <th>Items</th>
                                        <th style="display: none;">Loaded</th>
                                        <th style="display: none;">Remaining</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>--%>

                            <div id="BookingInfo"></div>

                              
                            <div class="form-group row">
                                  
                            </div>

                            <div class="form-group row">
                                <label class="col-sm-4 control-label">
                                </label>
                                <div class="col-sm-8">
                                    <%--<input type="button" class="add-row" value="Add To Container">--%>
                                </div>
                            </div>
                             <div class="form-group row">
                                <div class="col-sm-12 text-center ship_bot_a">
                                    <%--<asp:Button ID="btnSaveShipping" runat="server" Text="Save Shipping"
                                        CssClass="btn btn-primary" OnClientClick="return saveShipping();" />--%>
                                    <asp:Button ID="btnCancelShipping" runat="server" Text="Cancel" class="btn btn-default" Visible="false"
                                        OnClientClick="return clearAllControls();" />


                                    <asp:Button ID="btnMarkContainerShipped" runat="server" Text=" Mark Container as Received "
                                         OnClientClick="return MarkContainerShipped();"/>
                                    <asp:Button ID="btnCancelShipped" runat="server" Text=" Cancel Receive "
                                       OnClientClick="return CancelShippedModal();" />
                                    
                                </div>
                            </div>

                          <%--  <div class="tble_main">
                            <table border="1" style="color: white; width: 100%;" id="dtContainerBookingInformation">
                                <thead>
                                    <tr>
                                        <th>Booking Id</th>
                                        <th>Invoice Number</th>
                                        <th>Invoice Amount</th>
                                        <th>Paid</th>
                                        <th>Items</th>
                                        <th>Loaded</th>
                                        <th>Remaining</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            </div>


                            <table border="1" id="dvBookingItemsTemp" style="width: 100%; display:none;">
                                <tbody>
                                </tbody>
                            </table>--%>
    

                              <%--add-edit--%>
                              <div class="row">
                                    <div class="col-sm-6">
                                        <h6 class="table_head_name">Item In Warehouse</h6>
                                        <div class="top_ship_main">
                                                <div class="srch_clr"><asp:TextBox ID="txtSearchWarehouseBooking" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="Search Warehouse Booking"
                                                    title="Search Warehouse Booking" onkeyup="SearchWarehouseBooking(this.value);"
                                                    onkeypress="clearErrorMessage();"></asp:TextBox></div>
                                            <div class="top_ship_padd">
                                                <div class="top_ship">
                                                    <div class="bk_d icon_top">icon</div>
                                                    <div class="bk_d">Booking Id</div>
                                                    <%--<div class="bk_d">Invoice Number</div>--%>
                                                    <%--<div class="bk_d">Invoice Amount</div>
                                                    <div class="bk_d">Paid</div>--%>
                                                    <div class="bk_d">Items</div>
                                                    <div class="bk_d">Loaded</div>
                                                    <div class="bk_d">Remaining</div>
                                                    <div class="bk_d"><div style="visibility:hidden;">Remaining</div></div>
                                                    
                                                </div>
                                                 <a href="#" class="cancel_container_button">Cancel Cotainer</a>
                                            </div>
                                            <div id="add_table" class="table_strat_scrl mCustomScrollbar clearfix">
                                                <!-- scroll -->

                                               
                                                <!-- scroll -->
                                            </div>
                                        </div>
                                    </div>

                                  <div class="col-sm-6">
                                      <h6 class="table_head_name">Container Details</h6>
                                      
                                        <div class="top_ship_main">
                                            <div class="srch_clr"><asp:TextBox ID="txtSearchContainerBooking" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="Search Container Booking"
                                                title="Search Container Booking" onkeyup="SearchContainerBooking(this.value);"
                                                onkeypress="clearErrorMessage();"></asp:TextBox></div>
                                            <div class="top_ship_padd">
                                                <div class="top_ship">
                                                    <div class="bk_d icon_top">icon</div>
                                                    <div class="bk_d">Booking Id</div>
                                                    <div class="bk_d">Items</div>
                                                    <div class="bk_d">Loaded</div>
                                                    <div class="bk_d">Remaining</div>
                                                    <div class="bk_d"><div style="visibility:hidden;">Remaining</div></div>
                                                </div>
                                                <a href="#" class="received_container_button">REceived Cotainer</a>
                                            </div>
                                            <div id="cancel_table" class="table_strat_scrl mCustomScrollbar clearfix">
                                                <!-- scroll -->

                                                
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- scroll -->
                                            </div>
                                        </div>
                                    </div>

                                </div>
                              <%--add-edit--%>




                            <!--Added new Script Files for Date Picker-->
                            <script src="/js/bootstrap-datepicker.js"></script>
                            <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                            <div class="row">
                                <br />
                            </div>

                            <div class="row">
                                <% for (int i = 0; i < 4; i++)
                                    { %>
                                <br />
                                <%  } %>
                            </div>
                           <%-- <div class="form-group row">
                                <div class="col-sm-12 text-center">
                                    <asp:Button ID="btnSaveShipping" runat="server" Text="Save Shipping"
                                        CssClass="btn btn-primary" OnClientClick="return saveShipping();" />
                                    <asp:Button ID="btnCancelShipping" runat="server" Text="Cancel" class="btn btn-default"
                                        OnClientClick="return clearAllControls();" />
                                </div>
                            </div>--%>

                                <!-- Modal -->
                              <div class="modal fade" id="mymodal_received" role="dialog">
                                <div class="modal-dialog modal-md">
                                  <div class="modal-content">
                                    <div class="modal-header">
                                      <button type="button" class="close" data-dismiss="modal">&times;</button>
                                      <h4 class="modal-title">Modal Header</h4>
                                    </div>
                                    <div class="modal-body">
                                      <p>This is a small modal.</p>
                                    </div>
                                    <div class="modal-footer">
                                      <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    </div>
                                  </div>
                                </div>
                              </div>
                                <!-- Modal -->


                            <div class="modal fade" id="Shipping-bx" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">Shipping</h4>
                                        </div>
                                        <div class="modal-body">
                                            <p>Shipping Details added successfully</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-warning" data-dismiss="modal"
                                                onclick="location.href='/Shipping/ViewAllShippings.aspx';">
                                                OK</button>
                                        </div>
                                    </div>

                                </div>
                            </div>

                             <div class="modal fade" id="ShippingDel-bx" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header" style="background-color:##FAA51A;">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title" style="font-size: 24px; color: #111;">#Warning :</h4>
                                        </div>
                                        <div class="modal-body" style="text-align: center; font-size: 22px; color:black;">
                                            <p>Those items are received in the warehouse won't be rollback</p>
                                        </div>
                                        <div class="modal-footer">
                                            <%--<button type="button" class="btn btn-warning" data-dismiss="modal"
                                                onclick="ContainerReceiveCancel();">
                                                Yes</button>--%>

                                            <asp:Button ID="btnReceiveCancel" CssClass="btn btn-warning" runat="server" 
                                                Text="Yes" OnClientClick="return ContainerReceiveCancel();" />
                                             
                                            <button type="button" class="btn btn-warning" data-dismiss="modal"
                                                onclick="return donotContainerReceiveCancel();">
                                                No</button>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        </div>
                        <div class="col-md-12">
                            <hr />
                            <footer>
                                <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                            </footer>
                        </div>
                    </div>
                </form>
            </div>

    <div class="modal fade" id="dvBookingNumberModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>Order Information: 
                                    <span id="spHeaderBookingId" runat="server"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto;">
                    <div id="content-1" class="scroll_content">
                    <p>
                        <strong>Please find the details of order 
                                    <span id="spBodyBookingId" runat="server"></span>below:</strong>
                    </p>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="twoSrvbtn">
                                <button id="btnEditBooking1" data-dismiss="modal" title="Edit Booking"
                                    onclick="return gotoEditBookingPage();">
                                    <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                </button>

                                <button id="btnCancelBooking1" data-dismiss="modal" title="Cancel Booking"
                                    onclick="return showCancelModal();">
                                    <i class="fa fa-times" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="twoSETbtn">
                                <button id="btnPrintBookingModal" data-dismiss="modal" title="Print Booking Details"
                                    onclick="return printDetails('dvBooking');" style="margin-bottom: 10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintPdfBookingModal" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvBooking', 'BookingAllDetails.pdf');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintExcelBookingModal" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('dvAllBookings', 'CustomerDetails.xls');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class="">Booking Details:</h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <ul class="custoDTAIL">
                                                <li><strong>Booking ID</strong><span><asp:Label ID="lblBookingId" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Customer Name</strong><span><asp:Label ID="lblCustomerName" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Customer Mobile</strong><span><asp:Label ID="lblCustomerMobile" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>No of Items</strong><span><asp:Label ID="lblItems" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Loaded</strong><span><asp:Label ID="lblLoaded" CssClass="Loaded" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Remaining</strong><span><asp:Label ID="lblRemaining" CssClass="Remaining" runat="server" Text=""></asp:Label></span></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class="">Item details</h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <br />
                                                    <!-- jQuery DataTable -->
                                                    <table border="1" id="dvBookingItems" style="width: 100%;">
                                                        <thead>
                                                            <tr>
                                                                <th>Select</th>
                                                                <th>Pickup Id</th>
                                                                <th colspan="2">Items</th>
                                                                <%--<th>Pickup Item</th>--%>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                    <%--<div class="bottom_pop clearfix">
                                                    <div class="vatTotal btn btn-">
                                                            <input type="button" class="add-row btn btn-primary" value="Add To Container">
                                                    </div>
                                                    </div>--%>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- New Division for Payment Related Information -->

                    <%--<div class="row" style="height: 30px;">
                    </div>--%>
                    </div>                    
                </div>
                <div class="bottom_pop clearfix">
                    <div class="vatTotal vatTotal1 btn btn-">
                            <input type="button" class="add-row btn btn-primary" value="Add To Container">
                    </div>
                </div>



            </div>
        </div>
    </div>

</asp:Content>

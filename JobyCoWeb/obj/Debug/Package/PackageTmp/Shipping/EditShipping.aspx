<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" 
    AutoEventWireup="true" CodeBehind="EditShipping.aspx.cs" 
    Inherits="JobyCoWeb.Shipping.EditShipping" EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="../css/jquery.mCustomScrollbar.css" rel="stylesheet" />
     <link rel="stylesheet" href="https://cdn.datatables.net/select/1.3.0/css/select.dataTables.min.css">
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <script src="../js/jquery.mCustomScrollbar.concat.min.js"></script>
     <script src="https://cdn.datatables.net/select/1.3.0/js/dataTables.select.min.js"></script>
    <!-- New Script Added for Dynamic Menu Population
================================================== -->
    <style>
        .includeItem {
        }

        .RowBookingId, .RowPickupId {
            color: white;
            cursor: pointer;
        }
        .ItemShipped td {
            color:aqua !important;
        }
        .ItemShipped td a {
            color:aqua !important;
        }
        /*.modal { overflow: auto !important; }*/
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

            getAllWarehouse();

            var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
            accessibleMenuItems(hfMenusAccessibleValues);

            var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
            accessiblePageControls(hfControlsAccessible);

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
            var vContainerNumber = $("#<%=txtContainerNo.ClientID%>");
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
            
            var totalRowCount = $('#dtContainerBookingInformation tbody > tr').length
            
            if (totalRowCount==0)
            {
                //alert(totalRowCount);
                vErrMsg.text('Please Select Item For Shipping');
                vErrMsg.css("display", "block");
                return false;
            }

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

            $("#<%=lblPickupName.ClientID%>").text("");
            $("#<%=lblPickupAddress.ClientID%>").text("");
            $("#<%=lblPickupPostCode.ClientID%>").text("");
            $("#<%=lblPickupEmail.ClientID%>").text("");
            $("#<%=lblPickupMobile.ClientID%>").text("");
                    
            $("#<%=lblDeliveryName.ClientID%>").text("");
            $("#<%=lblRecipentAddress.ClientID%>").text("");
            $("#<%=lblDeliveryMobile.ClientID%>").text("");
            $("#<%=lblDeliveryPostCode.ClientID%>").text("");
            $("#<%=lblDeliveryEmail.ClientID%>").text("");
            
            $("#dvBookingItems tbody tr").remove();

            $("#ImageTable tbody tr td").remove();
        }


        function clearAllControls() {
            //var vShippingReferenceNumber = $("#<%=txtShippingReferenceNumber.ClientID%>");
            var vContainerNumber = $("#<%=txtContainerNo.ClientID%>");
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
            getShippingDetailsByContainer();
            //getShippingReferenceNumber();
            getAllBookingIds();
            getAllLocationsUK();

            $('#<%=txtShippingDate.ClientID%>').datepicker({
                format: 'dd-mm-yyyy',
                todayHighlight: true,
                autoclose: true
            });

            $('#<%=txtArrivalDate.ClientID%>').datepicker({
                format: 'dd-mm-yyyy',
                todayHighlight: true,
                autoclose: true
            });

            $('#<%=txtETA.ClientID%>').datepicker({
                format: 'dd-mm-yyyy',
                todayHighlight: true,
                autoclose: true
            });
        });
    </script>

    <script>

        //Edit Functions
        function getShippingDetailsByContainer()
        {
            var CN = getUrlVars();
            //alert(CN);

            $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EditShipping.aspx/getShippingDetailsFromContainerNo",
                    data: "{ ContainerNo: '" + CN + "'}",
                    beforeSend: function () {
                        //$("#loadingDiv").show();
                        $("#loadingDiv").css('display', 'flex');
                    },
                    complete: function () {
                        setTimeout(function () {
                            $('#loadingDiv').fadeOut();
                        }, 700);
                    },
                    success: function (result) {
                        var Jdata = JSON.parse(result.d);
                        //alert(JSON.stringify(Jdata));
                        var ShippingId= Jdata[0]['ShippingId'];
                        var ContainerId = Jdata[0]['ContainerId'];
                        var SealId = Jdata[0]['SealId'];
                        var ShippingFrom = Jdata[0]['ShippingFrom'];
                        var ShippingTo = Jdata[0]['ShippingTo'];
                        var ShippingDate = getFormattedDateUK(Jdata[0]['ShippingDate']);
                        var ArrivalDate = getFormattedDateUK(Jdata[0]['ArrivalDate']);
                        var ETA = getFormattedDateUK(Jdata[0]['ETA']);
                        var Consignee = Jdata[0]['Consignee'];
                        var Shipped = Jdata[0]['Shipped'];
                        var WarehouseId = Jdata[0]['WarehouseId'];

                            MakeShippingReadonly(Shipped);

                        //alert(ShippingId + ' ' + ContainerId + ' ' + SealId + ' ' + ShippingFrom + ' ' + ShippingTo + ' ' + ShippingDate + ' ' + ArrivalDate + ' ' + ETA + ' ' + Consignee);
                        $('#<%=txtShippingReferenceNumber.ClientID%>').val(ShippingId);
                        $('#<%=txtContainerNo.ClientID%>').val(ContainerId);
                        $('#<%=txtSealReferenceNumber.ClientID%>').val(SealId);
                        $('#<%=txtCollectionAddressShippingFrom.ClientID%>').val(ShippingFrom);
                        $('#<%=txtCollectionAddressShippingTo.ClientID%>').val(ShippingTo);
                        $('#<%=txtShippingDate.ClientID%>').val(ShippingDate);
                        $('#<%=txtArrivalDate.ClientID%>').val(ArrivalDate);
                        $('#<%=txtETA.ClientID%>').val(ETA);
                        $('#<%=txtConsignee.ClientID%>').val(Consignee);
                        $('#<%=ddlWarehouse.ClientID%>').val(WarehouseId);

                        var len = Jdata[0].listShippingDetails.length;

                        
                        var TotalInvoiceAmount = 0;
                        var TotalPaid = 0;
                        var TotalItem = 0;
                        var Totalloaded = 0;
                        var TotalRemaining = 0;

                        for (var i = 0; i < len; i++)
                        {
                            var BookingId = Jdata[0].listShippingDetails[i]['BookingId'];
                            var InvoiceNumber = Jdata[0].listShippingDetails[i]['InvoiceNumber'];
                            var InvoiceAmount = Jdata[0].listShippingDetails[i]['InvoiceAmount'];
                            var Paid = Jdata[0].listShippingDetails[i]['Paid'];
                            var Items = Jdata[0].listShippingDetails[i]['Items'];
                            var Loaded = Jdata[0].listShippingDetails[i]['Loaded'];
                            var Remaining = Jdata[0].listShippingDetails[i]['Remaining'];
                            
                            TotalInvoiceAmount += parseFloat(InvoiceAmount);
                            TotalPaid += parseFloat(Paid);
                            TotalItem += parseInt(Items);
                            Totalloaded += parseInt(Loaded);
                            TotalRemaining += parseInt(Remaining);

                            var newRowContent = "";
                            if (Shipped > 0)
                            {
                                newRowContent = "<tr>" +
                                //"<td>" + BookingId + "</td>" +
                                "<td class='RowBookingId'>" + BookingId + "</td>" +
                                "<td class='RowBookingId'>" + InvoiceNumber + "</td>" +
                                "<td class='RowBookingId'>" + InvoiceAmount + "</td>" +
                                "<td class='RowBookingId'>" + Paid + "</td>" +
                                "<td class='RowBookingId'>" + Items + "</td>" +
                                "<td class='RowBookingId'>" + Loaded + "</td>" +
                                "<td class='RowBookingId'>" + Remaining + "</td>" +
                                "<td><input id='btmDeleteContainerRow' type='button' value='Delete' disabled='disabled'></td>" +
                                 "</tr>";
                            }
                            else
                            { 
                                newRowContent = "<tr>" +
                                //"<td>" + BookingId + "</td>" +
                                "<td class='RowBookingId'>" + BookingId + "</td>" +
                                "<td class='RowBookingId'>" + InvoiceNumber + "</td>" +
                                "<td class='RowBookingId'>" + InvoiceAmount + "</td>" +
                                "<td class='RowBookingId'>" + Paid + "</td>" +
                                "<td class='RowBookingId'>" + Items + "</td>" +
                                "<td class='RowBookingId'>" + Loaded + "</td>" +
                                "<td class='RowBookingId'>" + Remaining + "</td>" +
                                "<td><input id='btmDeleteContainerRow' type='button' value='Delete'></td>" +
                                "</tr>";
                            }
                            $("#dtContainerBookingInformation tbody").append(newRowContent);

                            //Get Shipping item Details from database
                            var jsondata = {};
                            jsondata.ContainerId = ContainerId;
                            jsondata.BookingId = BookingId;
                            $.ajax({
                                    type: "POST",
                                    url: "EditShipping.aspx/GetShippingitemDetailsByBookingId",
                                    data: JSON.stringify(jsondata),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (result) {
                                        jData = JSON.parse(result.d);
                                        //alert(JSON.stringify(jData));
                                        //Fetch Data to dvBookingItemsTemp Table

                                        var len = jData.length;
                                        for (var i = 0; i < len; i++)
                                        {
                                            var PickupId = jData[i]['PickupId'];
                                            var CategoryId = jData[i]['CategoryId'];
                                            var CategoryItemId = jData[i]['CategoryItemId'];
                                            var BookingId = jData[i]['BookingId'];


                                            var newRowContent = "<tr>" +
                                                "<td></td>" +
                                                "<td>" + PickupId + "</td>" +
                                                "<td>" + CategoryId + "</td>" +
                                                "<td>" + CategoryItemId + "</td>" +
                                                "<td>" + BookingId + "</td>" +
                                                "</tr>";
                                            $("#dvBookingItemsTemp tbody").append(newRowContent);
                                        }
                                    },
                                    error: function (response) {
                                    }
                                });



                        }
                        
                        newRowContent = "<tr class='summary'>" +
                                //"<td>" + BookingId + "</td>" +
                                "<td>Total</td>" +
                                "<td></td>" +
                                "<td>" + TotalInvoiceAmount + "</td>" +
                                "<td>" + TotalPaid + "</td>" +
                                "<td>" + TotalItem + "</td>" +
                                "<td>" + Totalloaded + "</td>" +
                                "<td>" + TotalRemaining + "</td>" +
                                "<td></td>" +
                                "</tr>";
                        $("#dtContainerBookingInformation tfoot").append(newRowContent);

                    },
                    error: function (response) {
                        alert('Unable to Bind ContainerNo');
                    }
                });
        }
        // Read a page's GET URL variables and return them as an associative array.
        function getUrlVars() {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                //vars.push(hash[0]);
                //vars[hash[0]] = hash[1];
            }
            return hash[1];
        }
        //Edit Functions

        function getShippingReferenceNumber() {
            $.ajax({
                type: "POST",
                url: "AddShipping.aspx/GetShippingReferenceNumber",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //$('#<%=txtShippingReferenceNumber.ClientID%>').val(result.d);
                },
                error: function (response) {
                }
            });
            }

            function getAllBookingIds() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "AddShipping.aspx/GetAllBookingIds",
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
                    url: "AddShipping.aspx/getContainerNoFromContainerNo",
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
                        url: "AddShipping.aspx/GetAllLocationsUK",
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
                        url: "AddShipping.aspx/GetCustomerIdByBookingId",
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
                            url: "AddShipping.aspx/GetCustomerNameByBookingId",
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
                            url: "AddShipping.aspx/GetOrderStatusByBookingId",
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
                            url: "AddShipping.aspx/GetItemCountByBookingId",
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
                            url: "AddShipping.aspx/GetInvoiceAmountByBookingId",
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
        $(document).ready(function () {
            $("#dtBookingInformationByBookingId").css('display', 'none');

            $('#<%=ddlBookingId.ClientID%>').on('change', function () {
                getBookingInformationByBookingId(this.value);
            });

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
                    var Loaded = 0;
                    var BookingId = "";
                    var InvoiceNumber = "";
                    var InvoiceAmount = "";
                    var Paid = "";
                    var Items = 0;


                    var Remaining = 0;

                //Not Required In the Edit Page As InvoiceNumber, InvoiceAmount, Paid are available in the POP Up
                    //$("#dtBookingInformationByBookingId tbody").find('tr').each(function (i, el) {
                    //    var $tds = $(this).find('td');
                    //     BookingId = $tds.eq(0).text();
                    //     InvoiceNumber = $tds.eq(1).text();
                    //     InvoiceAmount = $tds.eq(2).text();
                    //     Paid = $tds.eq(3).text();
                    //     Items = $tds.eq(4).text();
                    //    //var Loaded = $tds.eq(5).text();
                    //    //var Remaining = $tds.eq(6).text();

                    //    //alert(BookingId + InvoiceNumber + InvoiceAmount + Paid + Items);
                    //});
                    Items = $("#<%=lblItems.ClientID%>").text().trim();
                    Loaded = $("#<%=lblLoaded.ClientID%>").text().trim();
                    Remaining = $("#<%=lblRemaining.ClientID%>").text().trim();
                //alert('Loaded ' + Loaded + ' Remaining : ' + Remaining);
                    //Check User Selected any Item or Not and Assign Total Loaded and Remaining From POPUP
                    $('#dvBookingItems tbody tr').each(function (i, row) {
                        var $actualrow = $(row);
                        $checkbox = $actualrow.find(':checkbox:checked');
                        //alert($(this).find('td:eq(1)').text().trim());
                        // Delete All Items To dvBookingItemsTemp Table

                        //IsValid = 0;

                        var PickupId = $(this).find('td:eq(1)').text().trim();
                        var CategoryFullName = $(this).find('td:eq(2)').text().trim();
                        var CategoryId = $(this).find('td:eq(3)').text().trim();
                        var CategoryItemId = $(this).find('td:eq(4)').text().trim();
                        BookingId = $(this).find('td:eq(5)').text().trim();

                        //ASSIGN InvoiceNumber, InvoiceAmount, Paid FROM POPUP
                        InvoiceNumber = $(this).find('td:eq(6)').text().trim();
                        InvoiceAmount = $(this).find('td:eq(7)').text().trim();
                        Paid = $(this).find('td:eq(8)').text().trim();

                        //alert('PickupId=' + PickupId +
                        //    'CategoryFullName=' + CategoryFullName +
                        //    'CategoryId=' + CategoryId +
                        //    'CategoryItemId=' + CategoryItemId +
                        //    'BookingId=' + BookingId +
                        //    'InvoiceNumber=' + InvoiceNumber +
                        //    'InvoiceAmount=' + InvoiceAmount +
                        //    'Paid=' + Paid
                        //    );

                        $('#dvBookingItemsTemp tbody tr').each(function (i, row) {
                            var tempPickupId = $(this).find('td:eq(1)').text().trim();
                            var tempBookingId = $(this).find('td:eq(4)').text().trim();
                            //alert('tempPickupId=' + tempPickupId + ' ' + PickupId);
                            if (tempPickupId == PickupId && tempBookingId == BookingId) {
                                var ClosestTr = $(this).closest('tr');
                                ClosestTr.remove();
                            }

                        });

                        if ($checkbox.is(':checked') && !$checkbox.is(':disabled')) {

                            IsValid = 1;
                            //Append Selected Items To dvBookingItemsTemp Table

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


                    //Delete Existing data In table
                    $('#dtContainerBookingInformation tbody tr').each(function (i, row) {
                        var RowBookingId = $(this).find('td:eq(0)').text().trim();
                        //alert('In the Delete row of dtContainerBookingInformation' + RowBookingId + ' : ' + BookingId);
                        if (RowBookingId == BookingId) {
                            var ClosestTr = $(this).closest('tr');
                            ClosestTr.remove();
                        }
                    });
                    //alert(IsValid);
                    // Add Booking Info to Container...........
                    if (IsValid == 1) {
                        //alert(BookingId + InvoiceNumber + InvoiceAmount + Paid + Items + Loaded + Remaining);
                        var newRowContent = "<tr>" +
                                "<td  class='RowBookingId'>" + BookingId + "</td>" +
                                "<td class='RowBookingId'>" + InvoiceNumber + "</td>" +
                                "<td class='RowBookingId'>" + InvoiceAmount + "</td>" +
                                "<td class='RowBookingId'>" + Paid + "</td>" +
                                "<td class='RowBookingId'>" + Items + "</td>" +
                                "<td class='RowBookingId'>" + Loaded + "</td>" +
                                "<td class='RowBookingId'>" + Remaining + "</td>" +
                                "<td><input id='btmDeleteContainerRow' type='button' value='Delete'></td>" +
                                "</tr>";
                        $("#dtContainerBookingInformation tbody").append(newRowContent);
                        
                        //Add to Summary dtContainerBookingInformation tfoot
                        AddtoSummarydtContainerBookingInformationtfoot();
                    }

            });

            function AddtoSummarydtContainerBookingInformationtfoot()
            {
                var TotalInvoiceAmount = 0.0;
                var TotalPaid = 0.0;
                var TotalItem = 0;
                var Totalloaded = 0;
                var TotalRemaining = 0;

                $('#dtContainerBookingInformation tbody tr').each(function (i, row) {
                    //var fInvoiceAmount = parseFloat($(this).find('td:eq(2)').text().trim());
                    TotalInvoiceAmount += parseFloat($(this).find('td:eq(2)').text().trim());
                    TotalPaid += parseFloat($(this).find('td:eq(3)').text().trim());
                    TotalItem += parseInt($(this).find('td:eq(4)').text().trim());
                    Totalloaded += parseInt($(this).find('td:eq(5)').text().trim());
                    TotalRemaining += parseInt($(this).find('td:eq(6)').text().trim());
                    //alert(TotalInvoiceAmount + ' ' + TotalPaid + ' ' + TotalItem + ' ' + Totalloaded + ' ' + TotalRemaining);
                });
                $('#dtContainerBookingInformation tfoot tr').each(function (i, row) {
                    $(this).find('td:eq(2)').text(TotalInvoiceAmount);
                    $(this).find('td:eq(3)').text(TotalPaid);
                    $(this).find('td:eq(4)').text(TotalItem);
                    $(this).find('td:eq(5)').text(Totalloaded);
                    $(this).find('td:eq(6)').text(TotalRemaining);
                });
            }

            //Called on click of Delete button from the Contailer Details
            $('#dtContainerBookingInformation').on('click', 'input[type="button"]', function (e) {
                var retVal = confirm("Do you want to DELETE ?");
                if (retVal == true) {
                    var ClosestTr = $(this).closest('tr');
                    var BookingId = ClosestTr.find('td:eq(0)').text().trim();
                    //Delete From temp Item List also 
                    
                    $('#dvBookingItemsTemp tbody tr').each(function (i, row) {
                        var TempBookingId = $(this).find('td:eq(4)').text().trim();
                        //alert('TempBookingId='+TempBookingId);
                        if (BookingId == TempBookingId)
                        {
                            var tempClosestTr = $(this).closest('tr');
                            tempClosestTr.remove();
                        }
                    });
                    ClosestTr.remove();
                    AddtoSummarydtContainerBookingInformationtfoot();
                    return true;
                }
                else {
                    return false;
                }
                //$(this).closest('tr').remove();
            })

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
                var ContainerId = $("#<%=txtContainerNo.ClientID%>").val().trim();
                //alert(BookingId);
                getBookingInfoItemsFromBookingId(BookingId, ContainerId);

            })

            // Called to make BookingId Clickable to display Modal POPUP In the LIST
            $('#dtContainerBookingInformation tbody').on('click', '.RowBookingId', function (e) {
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
                var ContainerId = $("#<%=txtContainerNo.ClientID%>").val().trim();
                //alert(BookingId);
                getBookingInfoItemsFromBookingId(BookingId, ContainerId);
            });

            // Called to make PickupId Clickable to display Modal POPUP In the LIST of Pickup Item
            $('#dvBookingItems tbody').on('click', '.RowPickupId', function (e) {
                
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
                var PickupId = ClosestTr.find('td').eq(1).text();
                var BookingId = ClosestTr.find('td').eq(5).text();
                var ContainerId = $("<%=txtContainerNo.ClientID%>").text().trim();
                getBookingItemsHistory(PickupId, BookingId, ContainerId);
            });

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

        function getBookingItemsHistory(PickupId, BookingId, ContainerId)
        {
            //Loader
            //mainMenu();

            //Loader

            $("#ItemHistory tbody tr").remove();
            var JsonData = {};
            JsonData.PickupId = PickupId;
            JsonData.BookingId = BookingId;
            JsonData.ContainerId = ContainerId;
            var newRowContent = "";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditShipping.aspx/GetBookingItemsHistory",
                data: JSON.stringify(JsonData),
                dataType: "json",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    var len = jdata.length;
                    //alert(JSON.stringify(jdata));
                    
                    if (len > 0) {
                        for (var i = 0; i < len; i++) {
                            newRowContent = "<tr>" +
                                "<td>" + jdata[i]['CreatedOn'] + "</td>" +
                                "<td>" + jdata[i]['Status'] + "</td>" +
                                "<td>" + jdata[i]['StatusDetails'] + "</td>" +
                                "</tr>";
                            $("#ItemHistory tbody").append(newRowContent);
                        }
                    }
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "EditShipping.aspx/GetBookingStatusItemsHistory",
                        data: JSON.stringify(JsonData),
                        dataType: "json",
                        success: function (result) {
                            var jdata = JSON.parse(result.d);
                            var len = jdata.length;
                            //alert(JSON.stringify(jdata));

                            if (len > 0) {

                                newRowContent = "<tr>" +
                                        "<td>" + jdata[0]['Bookingdate'] + "</td>" +
                                        "<td>" + jdata[0]['BookingStatus'] + "</td>" +
                                        "<td>" + jdata[0]['BookingStatusDetails'] + "</td>" +
                                        "</tr>";
                                $("#ItemHistory tbody").append(newRowContent);
                            }
                            //else {
                            //    $("#ItemHistory thead th").remove();
                            //    newRowContent = "<tr><td colspan='2'>No data available</td></tr>"
                            //    $("#ItemHistory tbody").append(newRowContent);
                            //} 
                        }
                    });
                }
            });
            
            //$('.innerModal,.overlay').modal('show');
            $('.innerModal,.overlay').fadeIn(1500);
        }

        function btnItemHistoryClick()
        {
            //$(this).closest(".modal").modal("hide")
            //$('#Shipping-Item-bx').modal('hide');
            $('.innerModal,.overlay').fadeOut();
            $('#dvBookingNumberModal').modal('focus');
        }

        function getBookingInformationByBookingId(BookingId) {
            //Called to populate Booking info on change of ddlBookingId Dropdown
            //alert(BookingId);
            $("#dtBookingInformationByBookingId").css('display', 'table');
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddShipping.aspx/GetBookingInformationByBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                dataType: "json",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(jdata);
                    var len = jdata.length;
                    //alert(len);
                    if (len > 0) {
                        var BookingId = jdata[0]['BookingId'];
                        var InvoiceNumber = jdata[0]['InvoiceNumber'];
                        var InvoiceAmount = jdata[0]['InvoiceAmount'];
                        var Paid = jdata[0]['Paid'];
                        var Items = jdata[0]['Items'];
                        var Loaded = jdata[0]['Loaded'];
                        var Remaining = jdata[0]['Remaining'];

                        $("#dtBookingInformationByBookingId tbody tr").remove();
                        var newRowContent = "<tr class='RowBookingId'>" +
                            "<td>" + BookingId + "</td>" +
                            "<td>" + InvoiceNumber + "</td>" +
                            "<td>" + InvoiceAmount + "</td>" +
                            "<td>" + Paid + "</td>" +
                            "<td>" + Items + "</td>" +
                            "<td style='display:none'>" + Loaded + "</td>" +
                            "<td style='display:none'>" + Remaining + "</td>" +
                            "</tr>";
                        $("#dtBookingInformationByBookingId tbody").append(newRowContent);

                        //alert(BookingId + " " + InvoiceAmount + " " + Paid + " " + Items + " " + Loaded + " " + Remaining);
                    }
                },
                error: function (response) {
                    alert("Error");
                }
            });
        }


        function getBookingInfoItemsFromBookingId(BookingId, ContainerId) {
            // called when we click Booking Id in the searched data from the ddlBookingId dropdown ......
            var JsonData = {};
            JsonData.BookingId = BookingId;
            JsonData.IsAdd = 0;
            JsonData.ContainerId = ContainerId;
            debugger;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditShipping.aspx/GetBookingInfoItemsFromBookingId",
                data: JSON.stringify(JsonData),
                dataType: "json",
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 700);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    clearShippingModalPopup();
                    var len = jdata.length;
                    //alert("Length=" + len + " BookingId=" + jdata[0]["BookingId"]);
                    $("#<%=lblBookingId.ClientID%>").text(jdata[0]["BookingId"]);
                    $("#<%=lblCustomerId.ClientID%>").text(jdata[0]["CustomerId"]);
                    $("#<%=lblCustomerName.ClientID%>").text(jdata[0]["FirstName"] + " " + jdata[0]["LastName"]);
                    $("#<%=lblCustomerMobile.ClientID%>").text(jdata[0]["Mobile"]);
                    <%--$("#<%=lblItems.ClientID%>").text(len);--%>
                    $("#<%=lblItems.ClientID%>").text(jdata[0]["Items"]);
                    $("#<%=lblLoaded.ClientID%>").text(jdata[0]["Loaded"]);
                    $("#<%=lblRemaining.ClientID%>").text(jdata[0]["Remaining"]);
                    $("#<%=lblPickupName.ClientID%>").text(jdata[0]["PickupName"]);
                    $("#<%=lblPickupAddress.ClientID%>").text(jdata[0]["PickupAddress"]);
                    $("#<%=lblPickupPostCode.ClientID%>").text(jdata[0]["PickupPostCode"]);
                    $("#<%=lblPickupEmail.ClientID%>").text(jdata[0]["PickupEmail"]);
                    $("#<%=lblPickupMobile.ClientID%>").text(jdata[0]["PickupMobile"]);
                    
                    $("#<%=lblDeliveryName.ClientID%>").text(jdata[0]["DeliveryName"]);
                    $("#<%=lblRecipentAddress.ClientID%>").text(jdata[0]["RecipentAddress"]);
                    $("#<%=lblDeliveryMobile.ClientID%>").text(jdata[0]["DeliveryMobile"]);
                    $("#<%=lblDeliveryPostCode.ClientID%>").text(jdata[0]["DeliveryPostCode"]);
                    $("#<%=lblDeliveryEmail.ClientID%>").text(jdata[0]["DeliveryEmail"]);

                    $("#<%=lblBookingNotes.ClientID%>").text(jdata[0]["BookingNotes"]);


                    //GET UPloaded Images

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "EditShipping.aspx/GetItemImagesByBookingId",
                        data: "{ BookingId: '" + BookingId + "'}",
                        dataType: "json",
                        success: function (result) {
                            var jdata = JSON.parse(result.d);
                            len = jdata.length;
                            //alert(len);
                            //alert(JSON.stringify(jdata));
                            var newRowContent = "";
                            for (var i = 0; i < len; i++) {
                                newRowContent = "<td style='padding: 4px 4px 4px 4px;'><img src='.." + jdata[i]['ImageName'] + "' alt='" + jdata[i]['PickupItem'] + "' height='50' width='50'/></td>";
                                $("#ImageTable tbody tr").append(newRowContent);
                            }
                        },
                        error: function (response) {
                            alert("Error");
                        }
                    });
                    
                    <%--$("#dtBookingInformationByBookingId tbody").find('tr').each(function (i, el) {
                        var $tds = $(this).find('td');
                        $("#<%=lblLoaded.ClientID%>").text($tds.eq(5).text());
                        $("#<%=lblRemaining.ClientID%>").text($tds.eq(6).text());
                        });--%>
                    
                    for (var i = 0; i < len; i++)
                    {
                        var IsPickedForShipping = 0;
                        var newRowContent = "";
                        IsPickedForShipping = jdata[i]["IsPickedForShipping"];
                        var IsItemShipped = jdata[i]["Shipped"]
                        //alert(IsPickedForShipping);
                        if (IsItemShipped > 0) {
                                    if (IsPickedForShipping == 1) {//Pickup by this container
                                        newRowContent = "<tr class='ItemShipped' align='left'>" +

                                           "<td><input type='Checkbox' disabled checked='checked' class='includeItem' /></td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PickupId"] + "</td>" +
                                           "<td  class='RowPickupId' colspan='2'>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["BookingId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceNumber"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceAmount"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["Paid"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["EstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["Status"] + "</td>" +
                                           "</tr>";
                                    }

                                    else if (IsPickedForShipping == 0) //Not Pickup by this container
                                    {
                                        newRowContent = "<tr class='ItemShipped' align='left'>" +
                                           "<td><input type='Checkbox' disabled class='includeItem' /></td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PickupId"] + "</td>" +
                                           "<td class='RowPickupId' colspan='2'>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["BookingId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceNumber"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceAmount"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["Paid"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["EstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["Status"] + "</td>" +
                                           "</tr>";
                                    }
                                    else if (IsPickedForShipping == 2) { //Pickup by other container
                                        newRowContent = "<tr class='ItemShipped' align='left'>" +
                                           "<td><input type='Checkbox' checked='checked' disabled class='includeItem' /></td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PickupId"] + "</td>" +
                                           "<td class='RowPickupId' colspan='2'>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["BookingId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceNumber"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceAmount"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["Paid"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["EstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["Status"] + "</td>" +
                                           "</tr>";
                                    }
                        } else {
                                    if (IsPickedForShipping == 1) {//Pickup by this container
                                        newRowContent = "<tr align='left'>" +

                                           "<td><input type='Checkbox' checked='checked' class='includeItem' /></td>" +
                                           "<td  class='RowPickupId'>" + jdata[i]["PickupId"] + "</td>" +
                                           "<td class='RowPickupId' colspan='2'>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["BookingId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceNumber"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceAmount"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["Paid"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["EstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["Status"] + "</td>" +
                                           "</tr>";
                                    }

                                    else if (IsPickedForShipping == 0) //Not Pickup by this container
                                    {
                                        newRowContent = "<tr align='left'>" +
                                           "<td><input type='Checkbox' class='includeItem' /></td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PickupId"] + "</td>" +
                                           "<td class='RowPickupId' colspan='2'>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["BookingId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceNumber"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceAmount"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["Paid"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["EstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["Status"] + "</td>" +
                                           "</tr>";
                                    }
                                    else if (IsPickedForShipping == 2) { //Pickup by other container
                                        newRowContent = "<tr align='left'>" +
                                           "<td><input type='Checkbox' checked='checked' disabled class='includeItem' /></td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PickupId"] + "</td>" +
                                           "<td class='RowPickupId' colspan='2'>" + jdata[i]["PickupCategory"] + " " + jdata[i]["PickupItem"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupCategoryId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["PickupItemId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["BookingId"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceNumber"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["InvoiceAmount"] + "</td>" +
                                           "<td style='display:none;'>" + jdata[i]["Paid"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["EstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["PredefinedEstimatedValue"] + "</td>" +
                                           "<td class='RowPickupId'>" + jdata[i]["Status"] + "</td>" +
                                           "</tr>";
                                    }
                        }



                        
                        //alert("inside loop jdata["+i+"]['PickupItem']=" + jdata[i]["PickupItem"]);
                    
                        
                        $("#dvBookingItems tbody").append(newRowContent);


                        // Get Sub-Total
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "EditShipping.aspx/GetBookingByBookingId",
                            data: "{ BookingId: '" + BookingId + "'}",
                            dataType: "json",
                            success: function (result) {
                                var jdata = JSON.parse(result.d);
                                //alert(JSON.stringify(jdata));
                                $('#OrderSubTotal').text(jdata[0]['OrderSubTotal']);
                                $('#VAT').text(jdata[0]['Vat']);
                                $('#OrderTotal').text(jdata[0]['OrderTotal']);


                            },
                            error: function (response) {
                                alert("Error");
                            }
                        });

                        


                        }
                            $('#dvBookingNumberModal').modal('show');
                        },
                            error: function (response) {
                    alert("Error");
                        }
                        });

            return false;
                        }

        function addShippingDetails() {
            //alert('addShippingDetails function');
            var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var ContainerId = $("#<%=txtContainerNo.ClientID%>").val().trim();

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
                            url: "AddShipping.aspx/AddShippingDetails",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(objShipping),
                            dataType: "json",
                            success: function (result) {
                    
                    //alert('AddShippingDetails Success');
                    //Finally saving Booking Data For Container
                    $('#dtContainerBookingInformation tbody > tr').each(function ()
                        {
                        var BookingId = $(this).find('td:eq(0)').text().trim();
                        var Loaded = $(this).find('td:eq(5)').text().trim();
                        var Remaining = $(this).find('td:eq(6)').text().trim();
                        objCBI = {};
                        objCBI.ShippingId = ShippingId;
                        objCBI.ContainerId = ContainerId.toUpperCase();
                        objCBI.BookingId = BookingId;
                        objCBI.Loaded = Loaded;
                        objCBI.Remaining = Remaining;

                        //alert(JSON.stringify(objCBI));

                        $.ajax({
                            type: "POST",
                            url: "AddShipping.aspx/AddContainerBookingInfo",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(objCBI),
                            dataType: "json",
                            success: function (result) {
                                //alert('AddContainerBookingInfo Success');
                                //Item data need to be saved
                                $('#dvBookingItemsTemp tbody tr').each(function (i, row) {

                                        var PickupId = $(this).find('td:eq(1)').text().trim();
                                        var CategoryId = $(this).find('td:eq(2)').text().trim();
                                        var CategoryItemId = $(this).find('td:eq(3)').text().trim();
                                        var TempBookingId = $(this).find('td:eq(4)').text().trim();

                                        if (TempBookingId==BookingId) {
                                        
                                            objCSII = {};
                                            objCSII.ShippingId = ShippingId;
                                            objCSII.ContainerId = ContainerId.toUpperCase();
                                            objCSII.BookingId = BookingId;
                                            objCSII.PickupId = PickupId;
                                            objCSII.CategoryId = CategoryId;
                                            objCSII.CategoryItemId = CategoryItemId;

                                            //alert('CategoryId=' + CategoryId + ' CategoryItemId=' + CategoryItemId);
                                            //alert(JSON.stringify(objCSII));

                                            $.ajax({
                                                type: "POST",
                                                url: "AddShipping.aspx/AddContainerShippingItemInfo",
                                                contentType: "application/json; charset=utf-8",
                                                data: JSON.stringify(objCSII),
                                                dataType: "json",
                                                success: function (result) {
                                                    //alert('AddContainerBookingItemInfo Success');

                                                },
                                                error: function (response) {

                                                }
                                            });//end of AddContainerShippingItemInfo 

                                        }
                                         
                                      
                        });

                        },
                            error: function (response) {

                        }
                        });//end of AddContainerBookingInfo

                        });
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


        function MarkContainerShipped()
        {
            var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var ContainerId = $("#<%=txtContainerNo.ClientID%>").val().trim();
            var Success = 0;

            $('#dvBookingItemsTemp tbody tr').each(function (i, row) {

                var PickupId = $(this).find('td:eq(1)').text().trim();
                var TempBookingId = $(this).find('td:eq(4)').text().trim();

                //alert('PickupId= ' + PickupId + ' BookingId= ' + TempBookingId);

                var Jsondata = {};
                Jsondata.ShippingId = ShippingId;
                Jsondata.ContainerId = ContainerId;
                Jsondata.BookingId = TempBookingId;
                Jsondata.PickupId = PickupId;

            $.ajax({
                type: "POST",
                url: "EditShipping.aspx/MarkContainerShipped",
                data: JSON.stringify(Jsondata),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                     Success = result.d;
                    
                },
                error: function (response) {
                }
            });
            
                
            });


            if (Success > 0) {
                alert('Container Shipped...');
                $('#<%=btnCancelShipped.ClientID%>').removeAttr('visible');

            }
            
        }

        function CancelShipped()
        {
            var ShippingId = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var ContainerId = $("#<%=txtContainerNo.ClientID%>").val().trim();
            var Success = 0;

            $('#dvBookingItemsTemp tbody tr').each(function (i, row) {

                var PickupId = $(this).find('td:eq(1)').text().trim();
                var TempBookingId = $(this).find('td:eq(4)').text().trim();

                var Jsondata = {};
                    Jsondata.ShippingId = ShippingId;
                    Jsondata.ContainerId = ContainerId;
                    Jsondata.BookingId = TempBookingId;
                    Jsondata.PickupId = PickupId;

            $.ajax({
                type: "POST",
                url: "EditShipping.aspx/CancelShipped",
                data: JSON.stringify(Jsondata),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                     Success = result.d;
                    
                },
                error: function (response) {
                }
            });
            });

            if (Success>0)
            {
                alert('Container Shipping Cancelled...');
                $('#<%=btnCancelShipped.ClientID%>').attr('visible', false);
             }
            
        }

        function MakeShippingReadonly(IsReadonly)
        {
            if (IsReadonly > 0) {
                $("#<%=btnMarkContainerShipped.ClientID%>").attr('disabled', 'disabled');
                $("#<%=btnMarkContainerShipped.ClientID%>").attr('value', 'Container Shipped');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('background-color', '#00cc00');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('color', '#fff');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('padding', '2px 5px 2px 5px');
                $('input[type=submit]').attr('disabled', 'disabled');
                
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
                
            }
            else
            {
                $('input[type=submit]').removeAttr('disabled');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('background-color', '#ff9900');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('color', '#fff');
                $("#<%=btnMarkContainerShipped.ClientID%>").css('padding', '2px 5px 2px 5px');

                $('#<%=btnCancelShipped.ClientID%>').attr('disabled', 'disabled');
                $("#<%=btnCancelShipped.ClientID%>").css('background-color', 'red');
                $("#<%=btnCancelShipped.ClientID%>").css('color', '#fff');
                $("#<%=btnCancelShipped.ClientID%>").css('padding', '2px 5px 2px 5px');
                $("#<%=btnCancelShipped.ClientID%>").css('opacity', '0.6');
            }
        }

        function getAllWarehouse()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddShipping.aspx/GetAllWarehouse",
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

    <%--<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap"
        async defer></script>--%>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

            <div class="col-lg-12 text-center welcome-message">
                <h2>Shipping Details
                </h2>
                <p></p>
            </div>
            <div class="col-md-12">
                <form id="frmAddShipping" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="add_shipping_form">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <asp:HiddenField ID="hfCustomerId" runat="server" />
                        </div>
                        <div class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping Reference Number</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtShippingReferenceNumber" runat="server"
                                                CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Container Number<span style="color: red"></span></label>
                                        <div id="divddlContainerNo" class="col-sm-6">
                                            <%--<asp:DropDownListChosen ID="ddlContainerNo" runat="server"
                                                CssClass="vat-option label-lgt"
                                                DataPlaceHolder="Please select an option"
                                                AllowSingleDeselect="true"
                                                NoResultsText="No result found"
                                                DisableSearchThreshold="10">
                                                <asp:ListItem Selected="True">Select Container Number</asp:ListItem>
                                            </asp:DropDownListChosen>--%>
                                            <asp:TextBox ID="txtContainerNo" runat="server"
                                                CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Seal Reference Number<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtSealReferenceNumber" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="e.g. 892/1 2/2009-CX"
                                                title="Please enter Seal Reference Number" Style="text-transform: uppercase;"
                                                MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping Date<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtShippingDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onchange="clearErrorMessage();checkShippingAndArrivalDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
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
                                            Arrival Date<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtArrivalDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onchange="clearErrorMessage();checkShippingAndArrivalDate()"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Shipping From<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <input type="text" id="txtCollectionAddressShippingFrom" class="form-control"
                                                placeholder="Enter a Collection Location" title=""
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
                                                placeholder="Enter a Collection Location" title=""
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
                                                CssClass="form-control m-b" PlaceHolder="e.g. Import and export: customs, declarations, duties and tariffs"
                                                title="Please enter Conignee" MaxLength="500"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group row">
                                        <label class="col-sm-6 control-label">
                                            Destination Warehouse<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlWarehouse" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
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

                            <table border="1" style="color: white; width: 100%;" id="dtBookingInformationByBookingId">
                                <thead>
                                    <tr>
                                        <th style="width: 20%">Booking Id</th>
                                        <th style="width: 20%">Invoice Number</th>
                                        <th style="width: 15%">Invoice Amount</th>
                                        <th style="width: 15%">Paid</th>
                                        <th style="width: 10%">Items</th>
                                        <th style="width: 10%; display: none;">Loaded</th>
                                        <th style="width: 10%; display: none;">Remaining</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                          

                            <div id="BookingInfo"></div>

                            <div class="form-group">
                                <label class="col-sm-4 control-label">
                                </label>
                                <div class="col-sm-8">
                                    
                                </div>
                            </div>

                            <div class="ShippedBtnContainer">
                            <asp:Button ID="btnMarkContainerShipped" runat="server" Text="Mark Container as Shipped"
                                   OnClientClick="return MarkContainerShipped();" />

                            <asp:Button ID="btnCancelShipped" runat="server" Text="Cancel Shipping"
                                   OnClientClick="return CancelShipped();" />
                             </div>
                            
                              <%--add-edit--%>
                              <div class="row">
                                    <div class="col-sm-12">
                                        <div class="top_ship_main">
                                            <div class="top_ship_padd">
                                                <div class="top_ship">
                                                    <div class="bk_d icon_top">icon</div>
                                                    <div class="bk_d">Booking Id</div>
                                                    <div class="bk_d">Invoice Number</div>
                                                    <div class="bk_d">Invoice Amount</div>
                                                    <div class="bk_d">Paid</div>
                                                    <div class="bk_d">Items</div>
                                                    <div class="bk_d">Loaded</div>
                                                    <div class="bk_d">Remaining</div>

                                                </div>
                                            </div>
                                            <div class="table_strat_scrl mCustomScrollbar clearfix">
                                                <!-- scroll -->

                                                <div class="table_strat_main">
                                                    <div class="top_ship table_strat">
                                                        <div class="bk_d expand_a" role="button" data-toggle="collapse" href="#collapseExample" aria-expanded="false" aria-controls="collapseExample"><i class="fa fa-angle-down" aria-hidden="true"></i>
                                                        </div>
                                                        <div class="bk_d"><strong>JBCO0406002</strong></div>
                                                        <div class="bk_d">6</div>
                                                        <div class="bk_d">0</div>
                                                        <div class="bk_d">5</div>
                                                        <div class="bk_d">6</div>
                                                        <div class="bk_d">0</div>
                                                        <div class="bk_d">0</div>

                                                    </div>
                                                    <div class="collapse" id="collapseExample">
                                                        <div class="well">
                                                            <div class="clps_a">
                                                                <div class="pick_up_add">
                                                                    <div class="book_details">
                                                                        <h6><span><img src="/images/book_details.svg" alt=""></span>Booking Details:</h6>

                                                                        <div class="bk_dt_a_main mCustomScrollbar">
                                                                            <div class="bk_dt_a"><span>Booking ID</span>
                                                                                <p>IDJBCO0406002</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>No of Items</span>
                                                                                <p>4</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>Loaded</span>
                                                                                <p>3</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>Remaining</span>
                                                                                <p>2</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>Order Note</span>
                                                                                <p>Nana Frimpong's Goods</p>
                                                                            </div>
                                                                        </div>

                                                                    </div>
                                                                </div>
                                                                <div class="pick_up_add">
                                                                    <div class="pick_up_flex">
                                                                        <div class="pk_add">
                                                                            <h6><span><img src="/images/pick_up.svg" alt=""></span>Pickup Address</h6>
                                                                            <p><i class="fa fa-user-o" aria-hidden="true"></i>Nana Frimpong</p>
                                                                            <p><i class="fa fa-map-marker" aria-hidden="true"></i>Nightingale Corner, Wotton Green, Orpington BR5 3PS, UK-4</p>
                                                                            <p><i class="fa fa-envelope-o" aria-hidden="true"></i>nf@jobycs.com</p>
                                                                            <p><i class="fa fa-phone" aria-hidden="true"></i>07432638941</p>
                                                                        </div>
                                                                        <div class="pk_add dlvr_add">
                                                                            <h6><span><img src="/images/delivery.svg" alt=""></span>Delivery Address</h6>
                                                                            <p><i class="fa fa-user-o" aria-hidden="true"></i>Senya Ahaibel</p>
                                                                            <p><i class="fa fa-map-marker" aria-hidden="true"></i>Accra, Ghana-</p>
                                                                            <p><i class="fa fa-envelope-o" aria-hidden="true"></i>nf@jobycs.com</p>
                                                                            <p><i class="fa fa-phone" aria-hidden="true"></i>02004554855</p>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>


                                                            <div class="item_details">
                                                                <table class="exampleitem table table-striped table-bordered" style="width:100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th></th>
                                                                            <th>Pickup Id</th>
                                                                            <th>Items</th>
                                                                            <th>Cost</th>
                                                                            <th>Estimated</th>
                                                                            <th>Status</th>

                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>Order booked</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>

                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="table_strat_main">
                                                    <div class="top_ship table_strat">
                                                        <div class="bk_d expand_a" role="button" data-toggle="collapse" href="#collapseExamplebb" aria-expanded="false" aria-controls="collapseExample"><i class="fa fa-angle-down" aria-hidden="true"></i>
                                                        </div>
                                                        <div class="bk_d"><strong>JBCO0406002</strong></div>
                                                        <div class="bk_d">6</div>
                                                        <div class="bk_d">0</div>
                                                        <div class="bk_d">5</div>
                                                        <div class="bk_d">6</div>
                                                        <div class="bk_d">0</div>
                                                        <div class="bk_d">0</div>

                                                    </div>
                                                    <div class="collapse" id="collapseExamplebb">
                                                        <div class="well">
                                                            <div class="clps_a">
                                                                <div class="pick_up_add">
                                                                    <div class="book_details">
                                                                        <h6><span><img src="/images/book_details.svg" alt=""></span>Booking Details:</h6>

                                                                        <div class="bk_dt_a_main mCustomScrollbar">
                                                                            <div class="bk_dt_a"><span>Booking ID</span>
                                                                                <p>IDJBCO0406002</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>No of Items</span>
                                                                                <p>4</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>Loaded</span>
                                                                                <p>3</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>Remaining</span>
                                                                                <p>2</p>
                                                                            </div>
                                                                            <div class="bk_dt_a"><span>Order Note</span>
                                                                                <p>Nana Frimpong's Goods</p>
                                                                            </div>
                                                                        </div>

                                                                    </div>
                                                                </div>
                                                                <div class="pick_up_add">
                                                                    <div class="pick_up_flex">
                                                                        <div class="pk_add">
                                                                            <h6><span><img src="/images/pick_up.svg" alt=""></span>Pickup Address</h6>
                                                                            <p><i class="fa fa-user-o" aria-hidden="true"></i>Nana Frimpong</p>
                                                                            <p><i class="fa fa-map-marker" aria-hidden="true"></i>Nightingale Corner, Wotton Green, Orpington BR5 3PS, UK-4</p>
                                                                            <p><i class="fa fa-envelope-o" aria-hidden="true"></i>nf@jobycs.com</p>
                                                                            <p><i class="fa fa-phone" aria-hidden="true"></i>07432638941</p>
                                                                        </div>
                                                                        <div class="pk_add dlvr_add">
                                                                            <h6><span><img src="/images/delivery.svg" alt=""></span>Delivery Address</h6>
                                                                            <p><i class="fa fa-user-o" aria-hidden="true"></i>Senya Ahaibel</p>
                                                                            <p><i class="fa fa-map-marker" aria-hidden="true"></i>Accra, Ghana-</p>
                                                                            <p><i class="fa fa-envelope-o" aria-hidden="true"></i>nf@jobycs.com</p>
                                                                            <p><i class="fa fa-phone" aria-hidden="true"></i>02004554855</p>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>


                                                            <div class="item_details">
                                                                <table class="exampleitem table table-striped table-bordered" style="width:100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th></th>
                                                                            <th>Pickup Id</th>
                                                                            <th>Items</th>
                                                                            <th>Cost</th>
                                                                            <th>Estimated</th>
                                                                            <th>Status</th>

                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>Order booked</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td>JBC0406002</td>
                                                                            <td>Other 1 box</td>
                                                                            <td>200</td>
                                                                            <td>0</td>
                                                                            <td>CONTIANER100 Loaded : ( 26 Jun 2019 ) ETA : ( 29 Jun 2019 )</td>
                                                                        </tr>

                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- scroll -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                              <%--add-edit--%>


                           <%-- <table border="1" style="color: white; width: 100%;" id="dtContainerBookingInformation">
                                <thead>
                                    <tr>
                                        <th style="width: 20%">Booking Id</th>
                                        <th style="width: 20%">Invoice Number</th>
                                        <th style="width: 15%">Invoice Amount</th>
                                        <th style="width: 15%">Paid</th>
                                        <th style="width: 10%">Items</th>
                                        <th style="width: 10%">Loaded</th>
                                        <th style="width: 10%">Remaining</th>
                                        <th style="width: 10%">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                                <tfoot>

                                </tfoot>
                            </table>
                            <table border="1" id="dvBookingItemsTemp" style="width: 100%;display:none;">
                                <tbody>
                                </tbody>
                            </table>--%>

                            <!--Added new Script Files for Date Picker-->
                            <script src="/js/bootstrap-datepicker.js"></script>
                            <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
 

                            <div class="row">
                                <% for (int i = 0; i < 4; i++)
                                    { %>
                                <br />
                                <%  } %>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-8 col-sm-offset-2 pull-right">
                                    <asp:Button ID="btnSaveShipping" runat="server" Text="Save Shipping"
                                        CssClass="btn btn-primary" OnClientClick="return saveShipping();" />
                                    <asp:Button ID="btnCancelShipping" runat="server" Text="Cancel" class="btn btn-default"
                                        OnClientClick="return clearAllControls();" />
                                </div>
                            </div>

                            <div class="modal fade" id="Shipping-bx" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header" style="background-color: #f0ad4ecf;">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title" style="font-size: 24px; color: #111;">Shipping</h4>
                                        </div>
                                        <div class="modal-body" style="text-align: center; font-size: 22px;">
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
    
    <%--<div class="modal innerModal fade" id="Shipping-Item-bx" role="dialog">
                                    <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header" style="background-color: #324153;">
                                            <button type="button" class="close" onclick="parent.btnItemHistoryClick()">&times;</button>
                                            <div class="infoLogo"><img src="../images/info-logo.png" /></div>
                                            <h4 class="modal-title" style="font-size: 24px; color:white;">Item Status History</h4>
                                        </div>
                                        <div class="modal-body" style="text-align: center; font-size: 22px; color:black;">
                                            <table id="ItemHistory" style="width:100%">
                                                <thead>
                                                    <th>Status</th>
                                                    <th>Date</th>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" onclick="btnItemHistoryClick()" class="btn btn-warning" id="btnItemHistory">
                                                OK</button>
                                        </div>
                                    </div>

                                </div>
                            </div>--%>
    <div class="overlay"></div>
    <div class="innerModal" id="Shipping-Item-bx">
        <div class="modal-dialog2">
            <div class="modal-content2">
                <div class="modal-header2" style="background-color: #324153;">
                    <button type="button" class="close" onclick="btnItemHistoryClick()">&times;</button>
                    <div class="infoLogo"><img src="../images/info-logo.png" /></div>
                    <h4 class="modal-title" style="font-size: 24px; color:white;">Item Status History</h4>
                </div>
                <div class="modal-body2" style="text-align: center; font-size: 22px; color:black;">
                    <table id="ItemHistory" style="width:100%">
                        <thead>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Comments</th>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer2">
                    <button type="button" onclick="btnItemHistoryClick()" class="btn btn-primary" id="btnItemHistory">
                        OK</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="dvBookingNumberModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <%--<button type="button" class="close" data-dismiss="modal">&times;</button>--%>
                    <button style="float:right" id="btnCancelBooking1" data-dismiss="modal" title="Close Booking Info"
                                    onclick="return showCancelModal();">
                                    <i class="fa fa-times" aria-hidden="true"></i>
                                </button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>Order Information: 
                                    <span id="spHeaderBookingId" runat="server"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto;">
                    <div id="content-1" class="scroll_content">
                        <p class="find_details">
                            <strong>Please find the details of order 
                                        <span id="spBodyBookingId" runat="server"></span>below:</strong>
                        </p>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="twoSrvbtn">
                                    <%--<button id="btnEditBooking1" data-dismiss="modal" title="Edit Booking"
                                        onclick="return gotoEditBookingPage();">
                                        <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                    </button>--%>

                                    <%--<button id="btnCancelBooking1" data-dismiss="modal" title="Close Booking Info"
                                        onclick="return showCancelModal();">
                                        <i class="fa fa-times" aria-hidden="true"></i>
                                    </button>--%>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="twoSETbtn">
                                    <%--<button id="btnPrintBookingModal" data-dismiss="modal" title="Print Booking Details"
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
                                    </button>--%>
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
                                                    <%--<li><strong>Customer Name</strong><span><asp:Label ID="lblCustomerName" runat="server" Text=""></asp:Label></span></li>--%>
                                                    <%--<li><strong>Customer Mobile</strong><span><asp:Label ID="lblCustomerMobile" runat="server" Text=""></asp:Label></span></li>--%>
                                                    <li><strong>No of Items</strong><span><asp:Label ID="lblItems" runat="server" Text=""></asp:Label></span></li>
                                                    <li><strong>Loaded</strong><span><asp:Label ID="lblLoaded" CssClass="Loaded" runat="server" Text=""></asp:Label></span></li>
                                                    <li><strong>Remaining</strong><span><asp:Label ID="lblRemaining" CssClass="Remaining" runat="server" Text=""></asp:Label></span></li>
                                                    <li><strong>Order Note</strong><span><asp:Label ID="lblBookingNotes" CssClass="Remaining" runat="server" Text=""></asp:Label></span></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="image_table clearfix">
                                        <strong>Uploaded Photo(s)</strong>
                                            <div class="img_tab">
                                                <table id="ImageTable" border="1">
                                                <tr>
                                                
                                                </tr>
                                            </table>                        
                                        </div>
                                    
                                    </div>

                                    <div class="ac_details">
                                        <h2 class="">Customer account Details:</h2>
                                        <table border="1" id="ca_details" style="width: 100%;">                                        
                                            <tbody>
                                                <tr>
                                                    <td><asp:Label ID="lblCustomerId" runat="server" Text=""></asp:Label></td>
                                                    <td><asp:Label ID="lblCustomerName" runat="server" Text=""></asp:Label></td>
                                                    <td><i class="fa fa-phone" aria-hidden="true"></i><asp:Label ID="lblCustomerMobile" runat="server" Text=""></asp:Label></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="ac_details pd_address">

                                        <table border="1" id="ca_details" style="width: 100%;">
                                            <thead>
                                                <tr>
                                                    <th>Pickup Address</th>
                                                    <th>Delivery Address</th>
                                                </tr>
                                            </thead>                                     
                                            <tbody>
                                                <tr>
                                                    <td><asp:Label ID="lblPickupName" runat="server" Text=""></asp:Label></td>
                                                    <td><asp:Label ID="lblDeliveryName" runat="server" Text=""></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td><asp:Label ID="lblPickupAddress" runat="server" Text=""></asp:Label>-<asp:Label ID="lblPickupPostCode" runat="server" Text=""></asp:Label></td>
                                                    <td><asp:Label ID="lblRecipentAddress" runat="server" Text=""></asp:Label>-<asp:Label ID="lblDeliveryPostCode" runat="server" Text=""></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td><i class="fa fa-envelope-o" aria-hidden="true"></i> <asp:Label ID="lblPickupEmail" runat="server" Text=""></asp:Label></td>
                                                    <td><i class="fa fa-envelope-o" aria-hidden="true"></i> <asp:Label ID="lblDeliveryEmail" runat="server" Text=""></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td><i class="fa fa-phone" aria-hidden="true"></i> <asp:Label ID="lblPickupMobile" runat="server" Text=""></asp:Label></td>
                                                    <td><i class="fa fa-phone" aria-hidden="true"></i> <asp:Label ID="lblDeliveryMobile" runat="server" Text=""></asp:Label></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <%--<div class="row">
                                    <div class="dvCNFRM">
                                        <h2 class=""></h2>
                                        <div class="confirm-box">
                                            <div class="confirm-details">
                                                <ul class="custoDTAIL">
                                                    <li><strong>No of Items</strong><span><asp:Label ID="lblItems" runat="server" Text=""></asp:Label></span></li>
                                                    <li><strong>Loaded</strong><span><asp:Label ID="lblLoaded" CssClass="Loaded" runat="server" Text=""></asp:Label></span></li>
                                                    <li><strong>Remaining</strong><span><asp:Label ID="lblRemaining" CssClass="Remaining" runat="server" Text=""></asp:Label></span></li>

                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>--%>
                            </div>

                            <div class="col-md-12">
                                <div class="row">
                                    <div class="dvCNFRM">
                                        <h2 class="">Item details</h2>
                                        <div class="confirm-box">
                                            <div class="confirm-details">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                   
                                                        <!-- jQuery DataTable -->
                                                        <table border="1" id="dvBookingItems" style="width: 100%;">
                                                            <thead>
                                                                <tr>
                                                                    <th>Select</th>
                                                                    <th>Pickup Id</th>
                                                                    <th colspan="2">Items</th>
                                                                    <th>Cost</th>
                                                                    <th>Estimated</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            </tbody>
                                                        </table>
                        
                                
                                                        <%--<br />
                                                        <br />
                                                        <h2 class="">Delivery Items</h2>
                                                        <br />
                                                        <table border="1" id="dvBookingDeliveryItems" style="width: 100%;">
                                                            <thead>
                                                                <tr>
                                                                    <th>Items</th>
                                                                    <th>Quantity</th>
                                                                    <th>Cost</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            </tbody>
                                                        </table>--%>
                                                        <%--<div class="bottom_pop clearfix">
                                                        <div class="orderSubTotal">
                                                            <table>
                                                                <tr>
                                                                    <td>Order Sub-Total : </td>
                                                                    <td><span id="OrderSubTotal"></span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Vat : </td>
                                                                    <td><span id="VAT"></span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Order Total : </td>
                                                                    <td><span id="OrderTotal"></span></td>
                                                                </tr>
                                                            </table>
                                                         </div>
                                                        <div class="vatTotal">
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
                    </div>
                    


                    <!-- New Division for Payment Related Information -->
                    
                    <%--<div class="row" style="height: 30px;">
                    </div>--%>

                </div>
                <div class="bottom_pop clearfix">
                        <div class="orderSubTotal">
                            <table>
                                <tr>
                                    <td>Order Sub-Total : </td>
                                    <td><span id="OrderSubTotal"></span></td>
                                </tr>
                                <tr>
                                    <td>Vat : </td>
                                    <td><span id="VAT"></span></td>
                                </tr>
                                <tr>
                                    <td>Order Total : </td>
                                    <td><span id="OrderTotal"></span></td>
                                </tr>
                            </table>
                            </div>
                        <div class="vatTotal">
                            <input type="button" class="add-row btn btn-primary" value="Add To Container">
                        </div>
                    </div>
            </div>
        </div>
    </div>
      <script>
        $(document).ready(function() {
            $('.exampleitem').DataTable({
                columnDefs: [{
                    orderable: false,
                    className: 'select-checkbox',
                    targets: 0
                }],
                select: {
                    style: 'multi',
                    selector: 'td:first-child'
                },
                order: [
                    [1, 'asc']
                ]
            });
            $(".expand_a ").click(function () {
                $(this).toggleClass("active");
            });
        });
    </script>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true"
    CodeBehind="ViewAllShippings.aspx.cs" Inherits="JobyCoWeb.Shipping.ViewAllShippings"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <style>
        .ShippingReferenceNumber, .BookingNumber {
        }

        .print, .edit, .delete {
            background: none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

            .print:hover, .edit:hover, .delete:hover {
                background: #fca311;
                color: #fff;
                text-shadow: 1px 1px 1px rgba(0,0,0,0.4);
            }

        .hideColumn {
            display: none;
        }
        .rowClickStatus {
            cursor: pointer;
        }
        .greenClass td {
            background-color: #33a50196;
        }
        .orangeClass td {
            background-color: #725405;
        }
    </style>

    <!-- New Script Added for Dynamic Menu Population
================================================== -->
    <script>
        // unblock when ajax activity stops 
        //$(document).ajaxStop($.unblockUI);

        //function mainMenu() {
        //    $.ajax({
        //        url: 'ViewAllShipping.aspx',
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

            var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
        accessibleMenuItems(hfMenusAccessibleValues);

        var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
            accessiblePageControls(hfControlsAccessible);

            $('[data-toggle="tooltip"]').tooltip();
    });
    </script>

    <script>
        function checkBlankControls() {
            //var vShippingReferenceNumber = $("#<%=txtShippingReferenceNumber.ClientID%>");

            var vBookingNumber = $("#<%=ddlBookingNumbers.ClientID%>");
            var vInvoiceNumber = $("#<%=txtInvoiceNumber.ClientID%>");

            var vShippingFrom = $("#<%=ddlShippingFrom.ClientID%>");
            var vShippingTo = $("#<%=ddlShippingTo.ClientID%>");

            var vShippingPort = $("#<%=txtShippingPort.ClientID%>");
            var vFreightType = $("#<%=ddlFreightType.ClientID%>");

            var vShippingDate = $("#<%=txtShippingDate.ClientID%>");
            var vArrivalDate = $("#<%=txtArrivalDate.ClientID%>");

            var vConsignee = $("#<%=txtConsignee.ClientID%>");

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

            if (vBookingNumber.find('option:selected').text().trim() == "Select Booking Number") {
                vErrMsg.text('Please select a BookingNumber');
                vErrMsg.css("display", "block");
                vBookingNumber.focus();
                return false;
            }

            if (vInvoiceNumber.val().trim() == "") {
                vErrMsg.text('Enter Invoice Number');
                vErrMsg.css("display", "block");
                vInvoiceNumber.focus();
                return false;
            }

            if (vShippingFrom.find('option:selected').text().trim() == "Select Shipping From") {
                vErrMsg.text('Please select a ShippingFrom');
                vErrMsg.css("display", "block");
                vShippingFrom.focus();
                return false;
            }

            if (vShippingTo.find('option:selected').text().trim() == "Select Shipping To") {
                vErrMsg.text('Please select a ShippingTo');
                vErrMsg.css("display", "block");
                vShippingTo.focus();
                return false;
            }

            if (vShippingPort.val().trim() == "") {
                vErrMsg.text('Enter Shipping Port');
                vErrMsg.css("display", "block");
                vShippingPort.focus();
                return false;
            }

            if (vFreightType.find('option:selected').text().trim() == "Select Freight Type") {
                vErrMsg.text('Please select a FreightType');
                vErrMsg.css("display", "block");
                vFreightType.focus();
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

            if (vShippingDate.val().trim() != "" && vArrivalDate.val().trim() != "") {
                var vShippingDateUK = convertANSIdateToUK(vShippingDate.val().trim());
                var dt1 = parseInt(vShippingDateUK.substring(0, 2), 10);
                var mon1 = parseInt(vShippingDateUK.substring(3, 5), 10);
                var yr1 = parseInt(vShippingDateUK.substring(6, 10), 10);

                var vArrivalDateUK = convertANSIdateToUK(vArrivalDate.val().trim());
                var dt2 = parseInt(vArrivalDateUK.substring(0, 2), 10);
                var mon2 = parseInt(vArrivalDateUK.substring(3, 5), 10);
                var yr2 = parseInt(vArrivalDateUK.substring(6, 10), 10);

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

            //if ( vConsignee.val().trim() == "" )
            //{
            //    vErrMsg.text( 'Enter Consignee in details' );
            //    vErrMsg.css( "display", "block" );
            //    vConsignee.focus();
            //    return false;
            //}

            return true;
        }

        function clearAllControls() {
            //var vShippingReferenceNumber = $("#<%=txtShippingReferenceNumber.ClientID%>");

            var vBookingNumber = $("#<%=ddlBookingNumbers.ClientID%>");
            var vInvoiceNumber = $("#<%=txtInvoiceNumber.ClientID%>");

            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");

            var vShippingFrom = $("#<%=ddlShippingFrom.ClientID%>");
            var vShippingTo = $("#<%=ddlShippingTo.ClientID%>");

            var vShippingPort = $("#<%=txtShippingPort.ClientID%>");
            var vFreightType = $("#<%=ddlFreightType.ClientID%>");

            var vShippingDate = $("#<%=txtShippingDate.ClientID%>");
            var vArrivalDate = $("#<%=txtArrivalDate.ClientID%>");

            var vConsignee = $("#<%=txtConsignee.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //vShippingReferenceNumber.val('');

            vBookingNumber.find('option:selected').text('Select Booking Number');
            vInvoiceNumber.val('');
            vCustomerName.val('');

            vShippingFrom.find('option:selected').text('Select Shipping From');
            vShippingTo.find('option:selected').text('Select Shipping To');

            vShippingPort.val('');
            vFreightType.find('option:selected').text('Select Freight Type');

            vShippingDate.val('');
            vArrivalDate.val('');

            vConsignee.val('');

            location.href = "/Shipping/ViewAllShippings.aspx";
            return false;
        }

    </script>

    <script>
        function convertUKdateToANSI(vDate) {
            var vDay = vDate.substr(0, 2);
            var vMonth = vDate.substr(3, 2);
            var vYear = vDate.substr(6, 4);

            return vYear + "-" + vMonth + "-" + vDay;
        }

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

        function convertANSIdateToUK(vDate) {
            var vYear = vDate.substr(0, 4);
            var vMonth = vDate.substr(5, 2);
            var vDay = vDate.substr(8, 2);

            return vDay + "-" + vMonth + "-" + vYear;
        }

        function checkShippingAndArrivalDate() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            //Date Checking Added on Text Change
            var vShippingDateANSI = $("#<%=txtShippingDate.ClientID%>").val().trim();
            var vShippingDateUK = convertANSIdateToUK(vShippingDateANSI);

            var vArrivalDateANSI = $("#<%=txtArrivalDate.ClientID%>").val().trim();
            var vArrivalDateUK = convertANSIdateToUK(vArrivalDateANSI);

            checkFromAndToDate(vShippingDateUK, vArrivalDateUK);
        }

    </script>

    <script>
        $(document).ready(function () {
            $('#dvShippingDetails').css('display', 'none');

            getAllShippings();
            getAllBookingIds();
            getAllLocationsUK();

        });

    </script>

    <script>
        function getCustomerNameByBookingId(BookingId) {
            $.ajax({
                type: "POST",
                url: "AddShipping.aspx/GetCustomerNameByBookingId",
                data: '{ BookingId: "' + BookingId + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $('#<%=txtCustomerName.ClientID%>').val(result.d);
                },
                error: function (response) {
                    alert('Unable to Get Customer Name from BookingId');
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
                            $("#<%=ddlBookingNumbers.ClientID%>").append($("<option></option>").val(this['Value']).html(this['Text']));
                    })
                },
                error: function (response) {
                    alert('Unable to Bind All Booking Ids');
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
                        $("#<%=ddlShippingFrom.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                        $("#<%=ddlShippingTo.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                    })
                },
                error: function (response) {
                    alert('Unable to Bind All Locations of UK');
                }
            });
        }
        //Debashish
        function getAllShippingsByDate(startDate, endDate) {
            //alert(startDate + endDate);
            var obj = {};
            obj._startDate = startDate;
            obj._endDate = endDate;
            //alert(startDate + endDate + obj.toString() );
            $.ajax({
                method: "POST",
                data: JSON.stringify(obj),
                url: "ViewAllShippings.aspx/GetAllShippingsByDate",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var jsonShippingDetails = JSON.parse(data.d);
                    
                    //alert('Before Destroy');
                    if ($.fn.dataTable.isDataTable('#dtViewShipping')) {
                        $('#dtViewShipping').DataTable().clear().destroy();
                    }
                    //alert('After Destroy');
                    $('#dtViewShipping').DataTable({
                        data: jsonShippingDetails,
                        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {

                            if (parseInt(aData["Shipped"]) > 0) {
                                $(nRow).addClass('greenClass');
                            }
                            else {
                                $(nRow).addClass('orangeClass');
                            }
                        },
                        columnDefs: [
                                        {
                                            targets: [0],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [1],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [2],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [3],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [4],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [5],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [6],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [7],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [8],
                                            className: "rowClickStatus"
                                        },
                                        {
                                            targets: [9],
                                            className: "hideColumn"
                                        },
                                        {
                                            targets: [10],
                                            className: "hideColumn"
                                        },
                                        {
                                            targets: [11],
                                            className: "hideColumn"
                                        }

                        ],
                        columns: [
                            {
                                data: "ShippingReferenceNumber",
                                render: function (data) {
                                    return '<a class="ShippingReferenceNumber">' + data + '</a>';
                                }
                            },
                            {
                                data: "ContainerNumber",
                                render: function (data, display, datalist, rowcolumn) {
                                    var NewData = data + '<br>' + jsonShippingDetails[rowcolumn.row]['SealReferenceNumber'];
                                    return '<a href="AddShipping.aspx?CN=' + data + '" class="ContainerNumber">' + NewData + '</a>';
                                }
                            },
                            { data: "FreightName" },
                            { data: "ShippingFrom" },
                            { data: "ShippingTo" },

                            {
                                data: "ShippingDate",
                                render: function (jsonShippingDate) {
                                    return getFormattedDateUK(jsonShippingDate);
                                }
                            },
                            {
                                data: "ArrivalDate",
                                render: function (jsonArrivalDate) {
                                    debugger;
                                    var ArrivalDate = getFormattedDateUK(jsonArrivalDate);
                                    if (ArrivalDate == "01/01/2000") {
                                        return "";
                                    }
                                    else {
                                        return ArrivalDate;
                                    }
                                }
                            },
                            { data: "Consignee" },
                            { data: "InvoiceCount" },
                            {
                                data: "Shipped",
                                render: function (data) {
                                    return data;
                                }
                            },
                            { data: "ContainerNumber" },
                            { data: "Status" },
                            { data: "WarehouseName" },
                            
                            {
                                defaultContent:
                                  "<button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-times' aria-hidden='true'></i></button>"
                            }
                        ]
                    });
                },
                error: function (response) {
                    alert('Unable to Bind View All Shippings');
                }
            });//end of ajax
        }
        //Debashish

        function getAllShippings() {
            var rowCount = 0;

            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetAllShippings",
                contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 700);
                },
                success: function (data) {
                    var jsonShippingDetails = JSON.parse(data.d);
                    $('#dtViewShipping').DataTable({
                        data: jsonShippingDetails,
                        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {

                            if (parseInt(aData["Shipped"]) > 0) {
                                $(nRow).addClass('greenClass');
                            }
                            else {
                                $(nRow).addClass('orangeClass');
                            }
                        },
                        columnDefs: [
                            {
                                targets: [0],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [1],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [2],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [3],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [4],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [5],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [6],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [7],
                                className: "rowClickStatus"
                            },
                            {
                                targets: [8],
                                className: "rowClickStatus"
                            },
                                        {
                                            targets: [9],
                                            className: "hideColumn"
                                        },
                                        {
                                            targets: [10],
                                            className: "hideColumn"
                                        },
                                        {
                                            targets: [11],
                                            className: "hideColumn"
                                        }
                        ],
                        columns: [
                            {
                                data: "ShippingReferenceNumber",
                                render: function (data) {
                                    return '<a class="ShippingReferenceNumber">' + data + '</a>';
                                }
                            },
                            {
                                data: "ContainerNumber",
                                render: function (data, display, datalist, rowcolumn) {

                                    var NewData = data + '<br>' + jsonShippingDetails[rowcolumn.row]['SealReferenceNumber'];
                                    return '<a href="AddShipping.aspx?CN=' + data + '" class="ContainerNumber">' + NewData + '</a>';

                                }
                            },
                            { data: "FreightName" },
                            { data: "ShippingFrom" },
                            { data: "ShippingTo" },

                            {
                                data: "ShippingDate",
                                render: function (jsonShippingDate) {
                                    return getFormattedDateUK(jsonShippingDate);
                                }
                            },
                            {
                                data: "ArrivalDate",
                                render: function (jsonArrivalDate) {
                                    debugger;

                                    var ArrivalDate = getFormattedDateUK(jsonArrivalDate);
                                    if (ArrivalDate == "01/01/2000") {
                                        return "";
                                    }
                                    else {
                                        return ArrivalDate;
                                    }
                                }
                            },
                            { data: "Consignee" },
                            { data: "InvoiceCount" },
                            {
                                data: "Shipped",
                                render: function (data) {
                                    return data;
                                }
                            },
                            { data: "ContainerNumber" },
                            { data: "Status" },
                            { data: "WarehouseName" },
                            {
                                defaultContent:
                                  "<button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-times' aria-hidden='true'></i></button>"
                            }
                        ]
                    });
                },
                error: function (response) {
                    alert('Unable to Bind View All Shippings');
                }
            });//end of ajax

            $('#dtViewShipping tbody').on('click', '.ShippingReferenceNumber', function () {
                var vClosestTr = $(this).closest("tr");

                clearShippingModalPopup();

                //============ **** Values Collected from DataTable **** =====================
                var vShippingReferenceNumber = vClosestTr.find('td').eq(0).text();
                $('#spShippingRefNo').text(vShippingReferenceNumber);
                $('#spHeaderShippingReferenceNumber').text(vShippingReferenceNumber);

                var vBookingNumber = vClosestTr.find('td').eq(1).text();
                $('#spBookingNo').text(vBookingNumber);

                var vCustomerName = vClosestTr.find('td').eq(2).text();
                $('#spCustomerFullName').text(vCustomerName);

                var vShippingFrom = vClosestTr.find('td').eq(3).text();
                $('#spShipFrom').text(vShippingFrom);

                var vShippingTo = vClosestTr.find('td').eq(4).text();
                $('#spShipTo').text(vShippingTo);

                var vShippingPort = vClosestTr.find('td').eq(5).text();
                $('#spShipPort').text(vShippingPort);

                var vShippingDate = vClosestTr.find('td').eq(6).text();
                $('#spShipDate').text(vShippingDate);

                var vArrivalDate = vClosestTr.find('td').eq(7).text();
                $('#spArriveDate').text(vArrivalDate);
                //============ ************************** =====================

                getContainerIdFromShippingId(vShippingReferenceNumber);

                $('#dvShippingReferenceModal').modal('show');

                return false;
            });

            $('#dtViewShipping tbody').on('click', '.BookingNumber', function () {
                var vClosestTr = $(this).closest("tr");
                var vBookingNumber = vClosestTr.find('td').eq(1).text();

                clearBookingModalPopup();

                $('#spBookingId').text(vBookingNumber);
                $('#spHeaderBookingId').text(vBookingNumber);

                getPickupNameFromBookingId(vBookingNumber);
                $('#dvBookingNumberModal').modal('show');

                return false;
            });

            $('#dtViewShipping tbody').on('click', '.print', function () {
                var vClosestTr = $(this).closest("tr");

                //============ **** Values Collected from DataTable **** =====================
                var vShippingReferenceNumber = vClosestTr.find('td').eq(0).text();
                $('#spShippingRefNo').text(vShippingReferenceNumber);
                $('#spHeaderShippingReferenceNumber').text(vShippingReferenceNumber);

                var vBookingNumber = vClosestTr.find('td').eq(1).text();
                $('#spBookingNo').text(vBookingNumber);

                var vCustomerName = vClosestTr.find('td').eq(2).text();
                $('#spCustomerFullName').text(vCustomerName);

                var vShippingFrom = vClosestTr.find('td').eq(3).text();
                $('#spShipFrom').text(vShippingFrom);

                var vShippingTo = vClosestTr.find('td').eq(4).text();
                $('#spShipTo').text(vShippingTo);

                var vShippingPort = vClosestTr.find('td').eq(5).text();
                $('#spShipPort').text(vShippingPort);

                var vShippingDate = vClosestTr.find('td').eq(6).text();
                $('#spShipDate').text(vShippingDate);

                var vArrivalDate = vClosestTr.find('td').eq(7).text();
                $('#spArriveDate').text(vArrivalDate);
                //============ ************************** =====================

                getContainerIdFromShippingId(vShippingReferenceNumber);

                return printDetails('tblShippingOwnDetails');

                //$('#dvShippingReferenceModal').modal('show');
                //return false;
            });

            $('#dtViewShipping tbody').on('click', '.rowClickStatus', function () {
                var vClosestTr = $(this).closest("tr");
                var vContainerNumber = vClosestTr.find('td').eq(10).text();
                window.location.replace("AddShipping.aspx?CN=" + vContainerNumber);
            });

            $('#dtViewShipping tbody').on('click', '.edit', function () {
                var vClosestTr = $(this).closest("tr");

                var vContainerNumber = vClosestTr.find('td').eq(10).text();
                //alert(vContainerNumber);

                window.location.replace("AddShipping.aspx?CN=" + vContainerNumber);

                //$('#<%//=txtShippingReferenceNumber.ClientID%>').val(vShippingReferenceNumber);


                <%--var vShippingReferenceNumber = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#<%=txtShippingReferenceNumber.ClientID%>' ).val( vShippingReferenceNumber );

                var vBookingNumber = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=ddlBookingNumbers.ClientID%>' ).find( 'option:selected' ).text( vBookingNumber );

                var vInvoiceNumber = vClosestTr.find( 'td' ).eq( 2 ).text();
                $( '#<%=txtInvoiceNumber.ClientID%>' ).val( vInvoiceNumber );

                var vCustomerName = vClosestTr.find('td').eq(3).text();
                $( '#<%=txtCustomerName.ClientID%>' ).val(vCustomerName);

                var vShippingFrom = vClosestTr.find( 'td' ).eq( 4 ).text();
                $( '#<%=ddlShippingFrom.ClientID%>' ).find('option:selected').text(vShippingFrom);

                var vShippingTo = vClosestTr.find( 'td' ).eq( 5 ).text();
                $( '#<%=ddlShippingTo.ClientID%>' ).find('option:selected').text(vShippingTo);

                var vShippingPort = vClosestTr.find( 'td' ).eq( 6 ).text();
                $( '#<%=txtShippingPort.ClientID%>' ).val(vShippingPort);

                var vFreightType = vClosestTr.find( 'td' ).eq( 7 ).text();
                $( '#<%=ddlFreightType.ClientID%>' ).find('option:selected').text(vFreightType);

                var vShippingDate = vClosestTr.find('td').eq(8).text();
                vShippingDate = convertUKdateToANSI( vShippingDate );
                $( '#<%=txtShippingDate.ClientID%>' ).val(vShippingDate);

                var vArrivalDate = vClosestTr.find( 'td' ).eq( 9 ).text();
                vArrivalDate = convertUKdateToANSI( vArrivalDate );
                $( '#<%=txtArrivalDate.ClientID%>' ).val(vArrivalDate);

                var vConsignee = vClosestTr.find( 'td' ).eq( 10 ).text();
                $( '#<%=txtConsignee.ClientID%>' ).val(vConsignee);

                //Make appear Edit Details
                //====================================================
                $( '#dvShippingDetails' ).css( 'display', 'block' );
                $( '#dvShippingDetails' ).css( 'margin-left', '100px' );
                //====================================================

                //Make disappear View All Details 
                //=======================================================
                $( '#dtViewShipping_wrapper' ).css( 'display', 'none' );
                disappearAllButtons();
                //=======================================================--%>

                return false;
            });

            $('#dtViewShipping tbody').on('click', '.delete', function () {
                var vClosestTr = $(this).closest("tr");

                var vShippingId = vClosestTr.find('td').eq(0).text();
                $('#<%=hfShippingId.ClientID%>').val(vShippingId);

                $('#RemoveShipping-bx').modal('show');
                return false;
            });

            return false;
        }

    </script>

    <script>

        function disappearAllButtons() {
            $('#<%=btnAddNewShipping.ClientID%>').css('display', 'none');
            $('#<%=btnPrintAllShippings.ClientID%>').css('display', 'none');
            $('#<%=btnExportViewAllShippingsPDF.ClientID%>').css('display', 'none');
            $('#<%=btnExportViewAllShippingsExcel.ClientID%>').css('display', 'none');

            return false;
        }

        function gotoAddShippingPage() {
            location.href = '/Shipping/AddShipping.aspx';
            return false;
        }

        function takePrintout() {
            prtContent = document.getElementById('dtViewShipping');
            prtContent.border = 0; //set no border here

            var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
            WinPrint.document.write(prtContent.outerHTML);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

            return false;
        }
    </script>

    <script>
        function updateShippingDetails() {
            var ShippingReferenceNumber = $("#<%=txtShippingReferenceNumber.ClientID%>").val().trim();
            var BookingNumber = $("#<%=ddlBookingNumbers.ClientID%>").find('option:selected').text().trim();

            var InvoiceNumber = $("#<%=txtInvoiceNumber.ClientID%>").val().trim().toUpperCase();
            var CustomerName = $("#<%=txtCustomerName.ClientID%>").val().trim();

            var ShippingFrom = $("#<%=ddlShippingFrom.ClientID%>").find('option:selected').text().trim();
            var ShippingTo = $("#<%=ddlShippingTo.ClientID%>").find('option:selected').text().trim();

            var ShippingPort = $("#<%=txtShippingPort.ClientID%>").val().trim();
            var FreightType = $("#<%=ddlFreightType.ClientID%>").find('option:selected').text().trim();

            var ShippingDate = $("#<%=txtShippingDate.ClientID%>").val().trim();
            var ArrivalDate = $("#<%=txtArrivalDate.ClientID%>").val().trim();

            var Consignee = $("#<%=txtConsignee.ClientID%>").val().trim();

            var objShipping = {};

            objShipping.ShippingReferenceNumber = ShippingReferenceNumber;
            objShipping.BookingNumber = BookingNumber;

            objShipping.InvoiceNumber = InvoiceNumber;
            objShipping.CustomerName = CustomerName;

            objShipping.ShippingFrom = ShippingFrom;
            objShipping.ShippingTo = ShippingTo;

            objShipping.ShippingPort = ShippingPort;
            objShipping.FreightType = FreightType;

            objShipping.ShippingDate = ShippingDate;
            objShipping.ArrivalDate = ArrivalDate;

            objShipping.Consignee = Consignee;

            $.ajax({
                type: "POST",
                url: "ViewAllShippings.aspx/UpdateShippingDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objShipping),
                dataType: "json",
                success: function (result) {
                    $('#Shipping-bx').modal('show');
                },
                error: function (response) {
                    alert('Shipping Details Updation failed');
                }
            });

            return false;
        }

        function editShippingDetails() {
            if (checkBlankControls()) {
                updateShippingDetails();
                //setTimeout( function () { }, 3000 );
            }

            return false;
        }

        function removeShippingDetails() {
            var ShippingId = $('#<%=hfShippingId.ClientID%>').val().trim();

            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/RemoveShippingDetails",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    location.reload();
                },
                error: function (response) {
                    alert('Unable to Remove Shipping Details');
                }
            });
        }
    </script>

    <script>
        function printDetails(vTableId) {
            var prtContent = document.getElementById(vTableId);
            prtContent.border = 0; //set no border here

            var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
            WinPrint.document.write(prtContent.outerHTML);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

            return false;
        }

        function exportToPDF(vTableId, vPDF_FileName) {
            /*var pdf = new jsPDF('p', 'pt', 'letter');
            pdf.canvas.height = 72 * 11;
            pdf.canvas.width = 72 * 8.5;
    
            var vContent = document.getElementById(vTableId);
            pdf.fromHTML(vContent);
    
            pdf.save(vPDF_FileName);*/

            var quotes = document.getElementById(vTableId);
            //alert(quotes.clientHeight);

            html2canvas(quotes, {
                onrendered: function (canvas) {

                    //! MAKE YOUR PDF
                    var pdf = new jsPDF('p', 'pt', 'letter');

                    for (var i = 0; i <= quotes.clientHeight / 980; i++) {
                        //! This is all just html2canvas stuff
                        var srcImg = canvas;
                        var sX = 0;
                        var sY = 980 * i; // start 980 pixels down for every new page
                        var sWidth = 2000;
                        var sHeight = 980;
                        var dX = 0;
                        var dY = 0;
                        var dWidth = 2000;
                        var dHeight = 980;

                        window.onePageCanvas = document.createElement("canvas");
                        onePageCanvas.setAttribute('width', 2000);
                        onePageCanvas.setAttribute('height', 980);
                        var ctx = onePageCanvas.getContext('2d');
                        // details on this usage of this function: 
                        // https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Using_images#Slicing

                        ctx.drawImage(srcImg, 0, 0);
                        //ctx.drawImage(srcImg,sX,sY,sWidth,sHeight,dX,dY,dWidth,dHeight);

                        // document.body.appendChild(canvas);
                        var canvasDataURL = onePageCanvas.toDataURL("image/png", 1.0);

                        var width = onePageCanvas.width;
                        var height = onePageCanvas.clientHeight;

                        //! If we're on anything other than the first page,
                        // add another page
                        if (i > 0) {
                            pdf.addPage(612, 791); //8.5" x 11" in pts (in*72)
                        }
                        //! now we declare that we're working on that page
                        pdf.setPage(i + 1);
                        //! now we add content to that page!
                        pdf.addImage(canvasDataURL, 'PNG', 0, 0, (width * .42), (height * .62));

                    }
                    //! after the for loop is finished running, we save the pdf.
                    pdf.save(vPDF_FileName);
                }
            });

            return false;
        }

        function exportToExcel(vTableId, vExcelFileName) {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById(vTableId); // id of table

            for (j = 0 ; j < tab.rows.length ; j++) {
                tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
                //tab_text=tab_text+"</tr>";
            }

            tab_text = tab_text + "</table>";
            tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
            tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
            tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");

            if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
            {
                txtArea1.document.open("txt/html", "replace");
                txtArea1.document.write(tab_text);
                txtArea1.document.close();
                txtArea1.focus();
                sa = txtArea1.document.execCommand("SaveAs", true, vExcelFileName);
            }
            else                 //other browser not tested on IE 11
                sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

            return (sa);
        }
    </script>

    <script>
        function getContainerIdFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetContainerIdFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spContainerId').text(result.d);
                    getSealIdFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Container Id from Shipping Reference Number');
                }
            });
        }

        function getSealIdFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetSealIdFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spSealId').text(result.d);
                    getConsigneeFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Seal Id from Shipping Reference Number');
                }
            });
        }

        function getConsigneeFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetConsigneeFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spConsignee').text(result.d);
                    getInvoiceNumberFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Consignee from Shipping Reference Number');
                }
            });
        }

        function getInvoiceNumberFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetInvoiceNumberFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spInvoiceNumber').text(result.d);
                    getInvoiceAmountFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Invoice Number from Shipping Reference Number');
                }
            });
        }

        function getInvoiceAmountFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetInvoiceAmountFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spInvoiceAmount').text(result.d);
                    getPaidAmountFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Invoice Amount from Shipping Reference Amount');
                }
            });
        }

        function getPaidAmountFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPaidAmountFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spPaidAmount').text(result.d);
                    getItemCountFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Paid Amount from Shipping Reference Amount');
                }
            });
        }

        function getItemCountFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetItemCountFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spItemCount').text(result.d);
                    getLoadedItemsFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get Item Count from Shipping Reference Amount');
                }
            });
        }

        function getLoadedItemsFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetLoadedItemsFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spLoadedItems').text(result.d);
                    getRemainingItemsFromShippingId(ShippingId);
                },
                error: function (response) {
                    alert('Unable to Get No of Loaded Items from Shipping Reference Amount');
                }
            });
        }

        function getRemainingItemsFromShippingId(ShippingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetRemainingItemsFromShippingId",
                data: "{ ShippingId: '" + ShippingId + "'}",
                success: function (result) {
                    $('#spRemainingItems').text(result.d);
                },
                error: function (response) {
                    alert('Unable to Get No of Remaining Items from Shipping Reference Amount');
                }
            });
        }
    </script>

    <script>
        function getPickupNameFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPickupNameFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spPickupName').text(result.d);

                    getPickupAddressFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Name from Booking Id');
                }
            });

            return false;
        }

        function getPickupAddressFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPickupAddressFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spPickupAddress').text(result.d);

                    getPickupMobileFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Address from Booking Id');
                }
            });

            return false;
        }

        function getPickupMobileFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPickupMobileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spPickupMobile').text(result.d);

                    getDeliveryNameFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Mobile from Booking Id');
                }
            });

            return false;
        }

        function getDeliveryNameFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetDeliveryNameFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spDeliveryName').text(result.d);

                    getDeliveryAddressFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Delivery Name from Booking Id');
                }
            });

            return false;
        }

        function getDeliveryAddressFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetDeliveryAddressFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spRecipentAddress').text(result.d);

                    getDeliveryMobileFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Delivery Address from Booking Id');
                }
            });

            return false;
        }

        function getDeliveryMobileFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetDeliveryMobileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spDeliveryMobile').text(result.d);

                    getPickupDateAndTimeFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Delivery Mobile from Booking Id');
                }
            });

            return false;
        }

        function getPickupDateAndTimeFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPickupDateAndTimeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spPickupDateTime').text(result.d);

                    getVATfromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Date and Time from Booking Id');
                }
            });

            return false;
        }

        function getVATfromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetVATfromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spVAT').text(result.d);

                    getOrderTotalFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get VAT from Booking Id');
                }
            });

            return false;
        }

        function getOrderTotalFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetOrderTotalFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spTotalValue').text(result.d);

                    getOrderStatusFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Order Total from Booking Id');
                }
            });

            return false;
        }

        function getOrderStatusFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetOrderStatusFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spOrderStatus').text(result.d);
                    getIsFragileFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Order Status from Booking Id');
                }
            });

            return false;
        }

        function getIsFragileFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetIsFragileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spIsFragile').text(result.d);

                    getItemCountFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Is Fragile from Booking Id');
                }
            });

            return false;
        }

        function getItemCountFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetItemCountFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spBookingItemCount').text(result.d);

                    getBookingNotesFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Item Count from Booking Id');
                }
            });

            return false;
        }

        function getBookingNotesFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetBookingNotesFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spBookingNotes').text(result.d);

                    getInsurancePremiumFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Booking Notes from Booking Id');
                }
            });

            return false;
        }

        function getInsurancePremiumFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetInsurancePremiumFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spInsurancePremium').text(result.d);

                    getPickupPostCodeFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Insurance Premium from Booking Id');
                }
            });

            return false;
        }

        function getPickupPostCodeFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPickupPostCodeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spPickupPostCode').text(result.d);

                    getDeliveryPostCodeFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup PostCode from Booking Id');
                }
            });

            return false;
        }

        function getDeliveryPostCodeFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetDeliveryPostCodeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spDeliveryPostCode').text(result.d);

                    getBookingDateFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Delivery PostCode from Booking Id');
                }
            });

            return false;
        }

        function getBookingDateFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetBookingDateFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spBookingDate').text(result.d);

                    getPickupEmailFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Booking Date from Booking Id');
                }
            });

            return false;
        }

        function getPickupEmailFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetPickupEmailFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spPickupEmail').text(result.d);

                    getDeliveryEmailFromBookingId(BookingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Email from Booking Id');
                }
            });

            return false;
        }

        function getDeliveryEmailFromBookingId(BookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllShippings.aspx/GetDeliveryEmailFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function (result) {
                    $('#spDeliveryEmail').text(result.d);
                },
                error: function (response) {
                    alert('Unable to get Delivery Email from Booking Id');
                }
            });

            return false;
        }

    </script>

    <script>
        function clearShippingModalPopup() {
            $('#spHeaderShippingReferenceNumber').text('');
            $('#spShippingRefNo').text('');
            $('#spContainerId').text('');
            $('#spSealId').text('');
            $('#spBookingNo').text('');
            $('#spCustomerFullName').text('');
            $('#spShipFrom').text('');
            $('#spShipTo').text('');
            $('#spShipPort').text('');
            $('#spShipDate').text('');
            $('#spArriveDate').text('');
            $('#spConsignee').text('');
            $('#spInvoiceNumber').text('');
            $('#spInvoiceAmount').text('');
            $('#spPaidAmount').text('');
            $('#spItemCount').text('');
            $('#spLoadedItems').text('');
            $('#spRemainingItems').text('');
        }

        function clearBookingModalPopup() {
            $('#spHeaderBookingId').text('');
            $('#spBookingId').text('');
            $('#spPickupDateTime').text('');
            $('#spPickupAddress').text('');
            $('#spIsFragile').text('');
            $('#spBookingItemCount').text('');
            $('#spTotalValue').text('');
            $('#spRecipentAddress').text('');
            $('#spBookingNotes').text('');
            $('#spOrderStatus').text('');
            $('#spVAT').text('');
            $('#spInsurancePremium').text('');
            $('#spPickupName').text('');
            $('#spPickupMobile').text('');
            $('#spDeliveryName').text('');
            $('#spDeliveryMobile').text('');
            $('#spPickupPostCode').text('');
            $('#spDeliveryPostCode').text('');
            $('#spBookingDate').text('');
            $('#spPickupEmail').text('');
            $('#spDeliveryEmail').text('');

            return false;
        }

        function searchByColor(Status) {
            //alert('Status = ' + Status);
            $("#dtViewShipping tbody tr").filter(function () {
                //$(this).toggle($(this).text().toLowerCase().indexOf(Status.toLowerCase()) > -1)

                $('#dtViewShipping').DataTable().search(Status).draw();
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content">
     
            <div class="col-lg-12 text-center welcome-message">
                <h2>View All Shippings
                </h2>
                <p></p>
            </div>
 
            <div class="col-lg-12">
                <form id="frmViewShipping" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>

                            <asp:HiddenField ID="hfShippingId" runat="server" />
                        </div>
                        <div>
                            <%--<div class="col-md-12">
                                <div class="col-md-5 pad_rgt_half">
                                    <span class="iconADD pull-right">
                                        <asp:Button ID="Button1" runat="server"  
                                            Text="Print All Shippings" OnClientClick="return takePrintout();" />
                                        <i class="fa fa-print" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD pull-right">
                                        <asp:Button ID="Button2" runat="server"  
                                        Text="Add New Shipping" OnClientClick="return gotoAddShippingPage();" />
                                        <i class="fa fa-user" aria-hidden="true"></i>
                                    </span>
                                </div>

                                <div class="col-md-1"></div>

                                <div class="col-md-5 pad_left_half" style="padding-right:25px; margin-bottom: 5px;">
                                    
                                    <span class="iconADD pull-right">
                                        <input type="text" style="color:black; width : 200px" name="daterange" value="01/01/2018 - 01/15/2018" />
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                    </span>
                                   
                                    <span class="iconADD pull-right">
                                        <asp:Button ID="Button3" runat="server"  
                                            Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                        <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD pull-right">
                                        <asp:Button ID="Button4" runat="server"  
                                        Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                    </span>
                                </div>
                            </div>--%>
                            
                            <%--Debashish--%>
                            <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
                            <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
                            <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
                            <script>

                                $(function () {
                                    $('input[name="daterange"]').daterangepicker({
                                        opens: 'left',
                                        startDate: new Date()
                                    }, function (start, end, label) {
                                        //console.log("A new date selection was made: " + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'));
                                        //alert("start=" + start.format('YYYY-MM-DD') + " end=" + end.format('YYYY-MM-DD') + " label=" + label);
                                        getAllShippingsByDate(start.format('YYYY-MM-DD'), end.format('YYYY-MM-DD'));
                                    });
                                });
                            </script>
                            <%--Debashish--%>
                            <div class="colorCode">
                                <strong>Key</strong>
                                <ul>
                                    <li class="green_box" onclick="searchByColor('Shipped')" data-toggle="tooltip" data-placement="right" title="Item Shipped from Warehouse"></li>
                                    <li class="orange_box" onclick="searchByColor('Arrive')" data-toggle="tooltip" data-placement="right" title="Item Received In Warehouse"></li>
                                    <li class="white_box" onclick="searchByColor('')" data-toggle="tooltip" data-placement="right" title="Clear Search"></li>
                                </ul>
                            </div>
                            <div id="dvShippingDetails" class="panel-body clrBLK col-md-10 dashboad-form"
                                style="margin-left: 100px;">
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Shipping Reference Number</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtShippingReferenceNumber" runat="server"
                                                CssClass="form-control m-b" ReadOnly="true"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Booking Number <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlBookingNumbers" runat="server"
                                                CssClass="form-control m-b" title="Please select a Booking Number from dropdown"
                                                onchange="getCustomerNameByBookingId(this.value);clearErrorMessage();">
                                                <asp:ListItem>Select Booking Number</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Invoice Number <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtInvoiceNumber" runat="server"
                                                CssClass="form-control m-b" Style="text-transform: uppercase;"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Customer Name <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtCustomerName" runat="server"
                                                CssClass="form-control m-b" ReadOnly="true"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Shipping From <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlShippingFrom" runat="server"
                                                CssClass="form-control m-b" title="Please select a Shipping From"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Shipping From</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Shipping To <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlShippingTo" runat="server"
                                                CssClass="form-control m-b" title="Please select a Shipping To"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Shipping To</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Shipping Port <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtShippingPort" runat="server" MaxLength="30"
                                                CssClass="form-control m-b" size="23" PlaceHolder="e.g. New Haven: Ferry Port"
                                                title="Please enter Shipping Port" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Freight Type <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlFreightType" runat="server"
                                                CssClass="form-control m-b" title="Please select a FreightType from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Freight Type</asp:ListItem>
                                                <asp:ListItem>Freight</asp:ListItem>
                                                <asp:ListItem>Bennett McMahon</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Shipping Date <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtShippingDate" runat="server" CssClass="clrBLK form-control"
                                                TextMode="Date" MaxLength="10"
                                                onchange="clearErrorMessage();checkShippingAndArrivalDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Arrival Date <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtArrivalDate" runat="server" CssClass="clrBLK form-control"
                                                TextMode="Date" MaxLength="10"
                                                onchange="clearErrorMessage();checkShippingAndArrivalDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Consignee </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtConsignee" runat="server" TextMode="MultiLine"
                                                CssClass="form-control m-b" PlaceHolder="e.g. Import and export: customs, declarations, duties and tariffs"
                                                title="Please enter Conignee" MaxLength="500"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8">
                                            <asp:Button ID="btnUpdateShipping" runat="server" Text="Update"
                                                CssClass="btn btn-primary btn-register"
                                                OnClientClick="return editShippingDetails();" />
                                            <asp:Button ID="btnCancelUpdateDelete" runat="server" Text="Cancel" class="btn btn-default"
                                                OnClientClick="return clearAllControls();" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="panel-body box_bg">
                              
                                    <div class="col-md-12">
                               
                                    <div class="col-md-5 view_left">
                                        <span class="iconADD">
                                            <asp:Button ID="btnPrintAllShippings" runat="server"
                                                Text="Print All Shippings" OnClientClick="return takePrintout();" />
                                            <i class="fa fa-print" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD">
                                            <asp:Button ID="btnAddNewShipping" runat="server"
                                                Text="Add New Shipping" OnClientClick="return gotoAddShippingPage();" />
                                            <i class="fa fa-user" aria-hidden="true"></i>
                                        </span>
                                    </div>

                                    <%-- <div class="col-md-1"></div>--%>

                                    <div class="col-md-7 pad_left_half" style="margin-bottom: 5px;">
                                        <%--Debashish--%>
                                        <span class="iconADD pull-right">
                                            <input class="date_input" type="text" style="color: black; width: 200px" name="daterange" value="01/01/2018 - 01/15/2018" />
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                        </span>
                                        <%--Debashish--%>
                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnExportViewAllShippingsPDF" runat="server"
                                                Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                            <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnExportViewAllShippingsExcel" runat="server"
                                                Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                        </span>
                                    </div>
                               
                            </div>
                                
                                <div class="tble_main">
                                <table id="dtViewShipping">
                                    <thead>
                                        <tr>
                                            <th>Shipping Reference Number</th>
                                            <th>Container Number</th>
                                            <th>Freight Name</th>
                                            <th>Shipping From</th>
                                            <th>Shipping To</th>
                                            <th>Shipping Date</th>
                                            <th>Arrival Date</th>
                                            <th>Consignee</th>
                                            <th>Invoice Count</th>
                                            <th style="display: none;">Invoice Count</th>
                                            <th style="display: none;">Container Number</th>
                                            <th style="display: none;">Status</th>
                                            <th>Warehouse</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                                    </div>
                            </div>
                        </div>

                        <div id="dtViewShipping_footer">
                            <hr />
                            <footer>
                                <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                            </footer>
                        </div>
                    </div>
                </form>
            </div>
      
    </div>

    <div class="modal fade" id="Shipping-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Shipping - Update</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Shipping Details updated successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal"
                        onclick="location.reload();">
                        OK</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="RemoveShipping-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Remove Shipping</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                    <p>Sure? You want to remove this Shipping?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="removeShippingDetails();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="dvShippingReferenceModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Shipping Details: #<span id="spHeaderShippingReferenceNumber"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Shipping below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintShippingModal" data-dismiss="modal" title="Print Shipping Details"
                                    onclick="return printDetails('tblShippingOwnDetails');" style="margin-bottom: 10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintPdfShippingModal" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvShippingReferenceModal', 'ShippingOwnDetails.pdf');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintExcelShippingModal" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('tblShippingOwnDetails', 'ShippingOwnDetails.xls');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class=""></h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="table-responsive">
                                                <table class="table custoFULLdet" id="tblShippingOwnDetails">
                                                    <tr>
                                                        <th>Shipping Reference Number: </th>
                                                        <td><span id="spShippingRefNo"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Container Id: </th>
                                                        <td><span id="spContainerId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Seal Id: </th>
                                                        <td><span id="spSealId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Booking Number: </th>
                                                        <td><span id="spBookingNo"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Customer Name: </th>
                                                        <td><span id="spCustomerFullName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Shipping From: </th>
                                                        <td><span id="spShipFrom"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Shipping To: </th>
                                                        <td><span id="spShipTo"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Shipping Port: </th>
                                                        <td><span id="spShipPort"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Shipping Date: </th>
                                                        <td><span id="spShipDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Arrival Date: </th>
                                                        <td><span id="spArriveDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Consignee: </th>
                                                        <td><span id="spConsignee"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Invoice Number: </th>
                                                        <td><span id="spInvoiceNumber"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Invoice Amount: </th>
                                                        <td><span id="spInvoiceAmount"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Paid Amount: </th>
                                                        <td><span id="spPaidAmount"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Item Count: </th>
                                                        <td><span id="spItemCount"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>No of Loaded Items: </th>
                                                        <td><span id="spLoadedItems"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>No of Remaining Items: </th>
                                                        <td><span id="spRemainingItems"></span></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="dvBookingNumberModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Booking Details: #<span id="spHeaderBookingId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Booking below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintBookingModal" data-dismiss="modal" title="Print Booking Details"
                                    onclick="return printDetails('tblBookingOwnDetails');" style="margin-bottom: 10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintPdfBookingModal" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvBookingNumberModal', 'BookingOwnDetails.pdf');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintExcelBookingModal" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('tblBookingOwnDetails', 'BookingOwnDetails.xls');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class=""></h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="table-responsive">
                                                <table class="table custoFULLdet" id="tblBookingOwnDetails">
                                                    <tr>
                                                        <th>Booking Id: </th>
                                                        <td><span id="spBookingId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pickup DateTime: </th>
                                                        <td><span id="spPickupDateTime"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pickup Address: </th>
                                                        <td><span id="spPickupAddress"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Is Fragile: </th>
                                                        <td><span id="spIsFragile"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Booking Item Count: </th>
                                                        <td><span id="spBookingItemCount"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Total Value: </th>
                                                        <td><span id="spTotalValue"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Delivery Address: </th>
                                                        <td><span id="spRecipentAddress"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Booking Notes: </th>
                                                        <td><span id="spBookingNotes"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Order Status: </th>
                                                        <td><span id="spOrderStatus"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>VAT: </th>
                                                        <td><span id="spVAT"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Insurance Premium: </th>
                                                        <td><span id="spInsurancePremium"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pickup Name: </th>
                                                        <td><span id="spPickupName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pickup Mobile: </th>
                                                        <td><span id="spPickupMobile"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Delivery Name: </th>
                                                        <td><span id="spDeliveryName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Delivery Mobile: </th>
                                                        <td><span id="spDeliveryMobile"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pickup PostCode: </th>
                                                        <td><span id="spPickupPostCode"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Delivery PostCode: </th>
                                                        <td><span id="spDeliveryPostCode"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Booking Date: </th>
                                                        <td><span id="spBookingDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pickup Email: </th>
                                                        <td><span id="spPickupEmail"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Delivery Email: </th>
                                                        <td><span id="spDeliveryEmail"></span></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <iframe id="txtArea1" style="display: none"></iframe>
    <iframe id="txtArea2" style="display: none"></iframe>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" 
    CodeBehind="ViewAllOfMyBookings.aspx.cs" Inherits="JobyCoWebCustomize.ViewAllOfMyBookings" %>

<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />

<link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
<script src="/Scripts/jquery.dataTables.min.js"></script>
<script src="/js/jspdf.min.js"></script>

    <style>
        .BookingId, .CustomerName {

        }

        .view, .cancel, .Track {
            background:none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

        .view:hover, .cancel:hover {
            background: #fca311;
            color:#fff;
            text-shadow:1px 1px 1px rgba(0,0,0,0.4);
        }

        .unpaid-bg { background: #9B822E; }

        .cancel-bg { background: #B51013; }

        .paid-bg {background: #238A35;}
        .paid-bg, .cancel-bg, .unpaid-bg {
            color: #fff;
            text-transform:uppercase;
            padding: 5px 0;
            width: 100%;
            display: block;
            text-align: center;
        }   
        .hideColumn {
            display: none;
        }
        .rowClickStatus {
            cursor: pointer;
        }
    </style>

    <script>
        function checkFromAndToDate( vFromDate, vToDate )
        {
            var vErrMsg = $("#<%=lblErrorMessage.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            if ( vFromDate != "" && vToDate != "" )
            {
                var dt1 = parseInt( vFromDate.substring( 0, 2 ), 10 );
                var mon1 = parseInt( vFromDate.substring( 3, 5 ), 10 );
                var yr1 = parseInt( vFromDate.substring( 6, 10 ), 10 );

                var dt2 = parseInt( vToDate.substring( 0, 2 ), 10 );
                var mon2 = parseInt( vToDate.substring( 3, 5 ), 10 );
                var yr2 = parseInt( vToDate.substring( 6, 10 ), 10 );
                
                var curDate = new Date();
                var stDate = new Date( yr1, mon1, dt1 );
                var enDate = new Date( yr2, mon2, dt2 );
                var compDate = enDate - stDate;

                //if ( stDate > curDate )
                //{
                //    alert( "From Date cannot be greater than Current Date" );
                //    return false;
                //}

                //if ( enDate > curDate )
                //{
                //    alert( "To Date cannot be greater than Current Date" );
                //    return false;
                //}

                if ( compDate < 0 )
                {
                    //alert( "To Date cannot be smaller than From Date" );
                    vErrMsg.text( 'To Date cannot be smaller than From Date' );
                    vErrMsg.css( "display", "table" );
                    vErrMsg.css( "margin-left", "340px" );
                    vErrMsg.css( "padding", "10px" );
                    vErrMsg.css( "color", "red" );
                    vErrMsg.css( "background-color", "rgb(255, 211, 217)" );

                    return false;
                }
            }
        }

        function showSuccessMessage(vSuccessMsg) {
            //Displaying Modal Popup
            $( '#pMsg' ).text( vSuccessMsg );
            $( '#Msg-bx' ).modal( 'show' );
        }

        function showErrorMessage( vErrorMsg )
        {
            //Displaying Modal Popup
            $( '#pMsg' ).text( vErrorMsg );
            $( '#Msg-bx' ).modal( 'show' );
        }

    </script>

    <script>
        $( document ).ready( function ()
        {
            $('#btnEditBooking').css('display', 'block');
            getAllOfMyBookings();
        } );
    </script>

    <script>

        function getPickupDeliveryFromBookingId(BookingId)
        {
             $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                //url: "ViewAllOfMyBookings.aspx/GetPickupNameFromBookingId",
                url: "ViewAllOfMyBookings.aspx/GetPickupDeliveryFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                 async: false,
                success: function ( result )
                {
                    var jData = JSON.parse(result.d);
                    $('#<%=lblPickupName.ClientID%>').text(jData[0]['PickupName']);
                    $('#<%=lblPickupAddress.ClientID%>').text(jData[0]['PickupAddress']);
                    $('#<%=lblPickupMobile.ClientID%>').text(jData[0]['PickupMobile']);
                    $('#<%=lblAltPickupMobile.ClientID%>').text(jData[0]['AltPickupMobile']);
                    $('#<%=lblDeliveryName.ClientID%>').text(jData[0]['DeliveryName']);
                    $('#<%=lblDeliveryAddress.ClientID%>').text(jData[0]['RecipientAddress']);
                    $('#<%=lblDeliveryMobile.ClientID%>').text(jData[0]['DeliveryMobile']);
                    $('#<%=lblAltDeliveryMobile.ClientID%>').text(jData[0]['AltDeliveryMobile']);

                    $('#<%=lblCustomerId.ClientID%>').text(jData[0]['CustomerId']);
                    $('#<%=lblCustomerMobile.ClientID%>').text(jData[0]['CustomerMobile']);
                    $('#StatusDetails').text(jData[0]['StatusDetails']);
                    $("#PCustomerTitle").text(jData[0]['PickupCustomerTitle']);
                    $("#DCustomerTitle").text(jData[0]['DeliveryCustomerTitle']);
                    debugger;
                    if (jData[0]['IsPicked'] == "1") {
                        $('#btnEditBooking').css('display', 'none');
                    }
                    else {
                        $('#btnEditBooking').css('display', 'block');
                    }
                    getPickupDateAndTimeFromBookingId(BookingId);
                    //getPickupAddressFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Name from Booking Id' );
                }
            } );
        }

        function getPickupNameFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetPickupNameFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupName.ClientID%>' ).text( result.d );
                    getPickupAddressFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Name from Booking Id' );
                }
            } );

        }

        function getPickupAddressFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetPickupAddressFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupAddress.ClientID%>' ).text( result.d );
                    getPickupMobileFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Address from Booking Id' );
                }
            } );
        }

        function getPickupMobileFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetPickupMobileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupMobile.ClientID%>' ).text( result.d );
                    getDeliveryNameFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Mobile from Booking Id' );
                }
            } );
        }

        function getDeliveryNameFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetDeliveryNameFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryName.ClientID%>' ).text( result.d );
                    getDeliveryAddressFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Name from Booking Id' );
                }
            } );
        }

        function getDeliveryAddressFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetDeliveryAddressFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryAddress.ClientID%>' ).text( result.d );
                    getDeliveryMobileFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Address from Booking Id' );
                }
            } );
        }

        function getDeliveryMobileFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetDeliveryMobileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryMobile.ClientID%>' ).text( result.d );
                    getPickupDateAndTimeFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Mobile from Booking Id' );
                }
            } );
        }

        function getPickupDateAndTimeFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetPickupDateAndTimeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                async: false,
                success: function ( result )
                {
                    $( '#<%=lblPickupDateTime.ClientID%>' ).text( result.d );

                    //Get LongDateTime
                   <%-- var vPickupDateTime = $( '#<%=lblPickupDateTime.ClientID%>' ).text().trim();
                    var vLongDateTime = getLongDateTime( vPickupDateTime );
                    $( '#<%=lblPickupDateTime.ClientID%>' ).text( vLongDateTime );--%>

                    getVATfromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup Date and Time from Booking Id' );
                }
            } );
        }

        function getVATfromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetVATfromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    <%--$( '#<%=lblVAT.ClientID%>' ).text( result.d );--%>
                    getOrderTotalFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get VAT from Booking Id' );
                }
            } );
        }

        function getOrderTotalFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetOrderTotalFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblOrderTotal.ClientID%>' ).text( result.d );
                    getOrderStatusFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Order Total from Booking Id' );
                }
            } );
        }

        function getOrderStatusFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetOrderStatusFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=hfOrderStatus.ClientID%>' ).val( result.d );

                    var vOrderStatus = $( '#<%=hfOrderStatus.ClientID%>' ).val().trim();

                    switch ( vOrderStatus )
                    {
                        case "Cancelled":
                            $( '#btnEditBooking' ).css( 'display', 'none' );
                            $( '#btnCancelBooking' ).css( 'display', 'none' );

                            $('#<%=pPaymentDetails.ClientID%>').css('display', 'none');
                            $( '#dvMyPaymentDetails' ).css( 'display', 'none' );
                            break;

                        case "Unpaid":
                            //$('#btnEditBooking').css('display', 'block');
                            $('#btnCancelBooking').css('display', 'block');

                            $('#<%=pPaymentDetails.ClientID%>').css('display', 'none');
                            $( '#dvMyPaymentDetails' ).css( 'display', 'none' );
                            break;

                        case "Paid":
                            //$('#btnEditBooking').css('display', 'block');
                            $( '#btnCancelBooking' ).css( 'display', 'block' );

                            $('#<%=pPaymentDetails.ClientID%>').css('display', 'block');
                            $( '#dvMyPaymentDetails' ).css( 'display', 'block' );
                            break;
                    }
                },
                error: function ( response )
                {
                    alert( 'Unable to get Order Status from Booking Id' );
                }
            } );
        }

        function getCustomerIdFromBookingId(BookingId)
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerIdFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                async: false,
                success: function ( result )
                {
                    $( '#<%=lblCustomerId.ClientID%>' ).text( result.d );

                    var vCustomerId = $( '#<%=lblCustomerId.ClientID%>' ).text().trim();
                    getCustomerMobileFromCustomerId( vCustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Customer Id from Booking Id' );
                }
            } );
        }

        function getCustomerMobileFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerMobileFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                async: false,
                success: function (result) {
                    $( '#<%=lblCustomerMobile.ClientID%>' ).text( result.d );
                },
                error: function (response) {
                    alert( 'Unable to get Customer Mobile from Customer Id' );
                }
            } );
        }

        function getLongDateTime(vDate) {
            var vDay = parseInt(vDate.substring(0, 2), 10);
            var vMonth = parseInt(vDate.substring(3, 5), 10);
            var vYear = parseInt(vDate.substring(6, 10), 10);

            var dtDate = leftPad(vDay, 2) + "/" + leftPad(vMonth, 2) + "/" + vYear;

            return dtDate;
        }

        function leftPad(number, targetLength) {
            var output = number + '';
            while (output.length < targetLength) {
                output = '0' + output;
            }
            return output;
        }

        function makeProperColor(vOrderStatus) {
            switch (vOrderStatus) {
                case "Cancelled":
                    vOrderStatus = "<span class='cancel-bg'>Cancelled</span>";
                    break;

                case "Paid":
                    vOrderStatus = "<span class='paid-bg'>Paid</span>";
                    break;

                case "Unpaid":
                    vOrderStatus = "<span class='unpaid-bg'>Unpaid</span>";
                    break;
            }

            return vOrderStatus;
        }

        function viewBookingDetails( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/ViewBookingDetails",
                data: "{ BookingId: '" + BookingId + "'}",
                async: false,
                success: function ( result )
                {
                    var jsonBookingDetails = JSON.parse( result.d );
                    $( '#dvMyBookings' ).DataTable( {
                        data: jsonBookingDetails,
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
                               className: "hideColumn"
                           },
                           {
                               targets: [5],
                               className: "hideColumn"
                           },
                           {
                               targets: [6],
                               className: "hideColumn"
                           }
                        ],
                        columns: [
                            { data: "Item" },
                            { data: "Cost" },
                            { data: "EstimatedValue" },
                            { data: "Status" },
                            { data: "BookingId" },
                            { data: "PickupCategoryId" },
                            { data: "PickupItemId" }
                        ],
                        "bLengthChange": false,
                        "bFilter": false,
                        "bInfo": false,
                        "bPaginate": false,
                        "bDestroy": true
                    } );
                },
                error: function ( response )
                {
                    alert( 'Unable to View Booking Details' );
                }
            });//end of ajax

            GetItemImagesByBookingId();


        }

        function GetItemImagesByBookingId()
        {
            var BookingId = $( '#<%=spHeaderBookingId.ClientID%>' ).text().trim().replace('#', '');
            //GET UPloaded Images
            $("#ImageTable tbody tr td").remove();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetItemImagesByBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                dataType: "json",
                async:false,
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    len = jdata.length;
                    //alert(len);
                    //alert(JSON.stringify(jdata));
                    debugger;
                    var newRowContent = "";
                    for (var i = 0; i < len; i++) {
                        newRowContent += "<td style='padding: 4px 4px 4px 4px;'><img src='" + jdata[i]['ImageUrl'] + "' title='" + jdata[i]['PickupItem'] + "' alt='#' height='50' width='50'/></td>";
                    }
                    $("#ImageTable tbody tr").append(newRowContent);
                },
                error: function (response) {
                    alert("Error");
                }
            });
            return false;
        }

        function viewPaymentDetails( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/ViewPaymentDetails",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    var jsonPaymentDetails = JSON.parse( result.d );
                    $( '#dvMyPaymentDetails' ).DataTable( {
                        data: jsonPaymentDetails,
                        columns: [
                            { data: 'TransactionID' },
                            { data: 'EmailId' },
                            { data: 'ContactNo' },
                            { data: 'Quantity' },
                            { data: 'PaymentAmount' },
                            { data: 'PaymentCurrency' },
                            {
                                data: 'PaymentDateTime',
                                render: function ( jsonPaymentDateTime )
                                {
                                    return getFormattedDateUK( jsonPaymentDateTime );
                                }
                            }
                        ],
                        "bLengthChange": false,
                        "bFilter": false,
                        "bInfo": false,
                        "bPaginate": false,
                        "bDestroy": true
                    } );
                },
                error: function ( response )
                {
                    alert( 'Unable to bind Payment Details' );
                }
            } );
        }

        function getAllOfMyBookings()
        {
            var EmailID = $( '#<%=hfEmailID.ClientID%>' ).val().trim();

            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetAllOfMyBookings",
                data: "{ EmailID: '" + EmailID + "'}",
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 700);
                },
                success: function (result)
                {
                    var jsonBookingDetails = JSON.parse(result.d);
                    //alert(JSON.stringify(jsonBookingDetails));
                    $( '#dtViewBookings' ).DataTable( {
                        data: jsonBookingDetails,
                        columns: [
                            {
                                data: "BookingId",
                                render: function (data) {
                                    return '<a class="BookingId">' + data + '</a>';
                                }
                            },
                            { data: "CustomerName" },
                            {
                                data: "OrderDate",
                                render: function ( jsonOrderDate )
                                {
                                    return getFormattedDateUK(jsonOrderDate);
                                }
                            },
                            { data: "InsurancePremium" },
                            { data: "TotalValue" },
                            { data: "OrderStatus" },
                            //{
                            //    data: "CustomerName",
                            //    render: function (data) {
                            //        return '<a class="CustomerName">' + data + '</a>';
                            //    }
                            //},
                            //{
                            //    data: "OrderDate",
                            //    render: function ( jsonOrderDate )
                            //    {
                            //        return getFormattedDateUK( jsonOrderDate );
                            //    }
                            //},
                            //{
                            //    data: "InsurancePremium",
                            //    render: function (InsurancePremium) {
                            //        return roundOffDecimalValue(InsurancePremium);
                            //    }
                            //},
                            //{
                            //    data: "TotalValue",
                            //    render: function (TotalValue) {
                            //        return roundOffDecimalValue(TotalValue);
                            //    }
                            //},
                            //{
                            //    data: "OrderStatus",
                            //    render: function ( jsonOrderStatus )
                            //    {
                            //        return makeProperColor( jsonOrderStatus );
                            //    }
                            //},
                            {
                                defaultContent:
                                  "<button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button><button class='cancel' title='Cancel'><i class='fa fa-times' aria-hidden='true'></i></button><button class='Track' title='Track Your Order'><i class='fa fa-map-marker' aria-hidden='true'></i></button>"
                            }
                        ],
                        "aaSorting": [
                            [0, "desc"]
                        ]
                } );
                },
                error: function ( response )
                {
                    $("#loadingDiv").hide();
                    alert( 'Unable to Bind All Bookings' );
                }
            });//end of ajax


            $('#dvMyBookings tbody').on('click', '.rowClickStatus', function () {
                var vClosestTr = $(this).closest("tr");
                var vBookingId = vClosestTr.find('td').eq(4).text();
                var vPickupCategoryId = vClosestTr.find('td').eq(5).text();
                var vPickupItemId = vClosestTr.find('td').eq(6).text();
                //alert(' vBookingId=' + vBookingId + ' vPickupCategoryId=' + vPickupCategoryId + ' vPickupItemId=' + vPickupItemId);
                GetImagesByItems(vBookingId, vPickupCategoryId, vPickupItemId);
                return false;
            });


            $('#dtViewBookings tbody').on('click', '.BookingId', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );
                var vBookingId = vClosestTr.find( 'td' ).eq( 0 ).text();

                clearBookingModalPopup();

                $('#<%=spHeaderBookingId.ClientID%>').text('#' + vBookingId);
                $( '#<%=spBodyBookingId.ClientID%>' ).text( '#' + vBookingId );

                //First Tabular Details
                //===========================================================================
                //getCustomerIdFromBookingId( vBookingId );

                var vCustomerName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=lblCustomerName.ClientID%>' ).text( vCustomerName );
                //============================================================================

                //Second Tabular Details
                //===========================================================================
                //getPickupNameFromBookingId( vBookingId );
                getPickupDeliveryFromBookingId( vBookingId );
                //============================================================================

                viewBookingDetails( vBookingId );

                viewPaymentDetails( vBookingId );
                ViewBookingChargesDetails(vBookingId);
                $( '#dvBooking' ).modal( 'show' );

                //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                    $("#loadingDiv").css("z-index", "9999");
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 1500);

                return false;
            } );

            $('#dtViewBookings tbody').on('click', '.CustomerName', function () {
                var vClosestTr = $(this).closest("tr");
                var vCustomerName = vClosestTr.find('td').eq(1).text();

                clearCustomerModalPopup();

                $('#spCustomerName').text(vCustomerName);

                getCustomerIdFromCustomerName(vCustomerName);

                $('#dvCustomerDetailsModal').modal('show');

                return false;
            });

            $('#dtViewBookings tbody').on('click', '.view', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );
                var vBookingId = vClosestTr.find( 'td' ).eq( 0 ).text();

                clearBookingModalPopup();

                $('#<%=spHeaderBookingId.ClientID%>').text('#' + vBookingId);
                $( '#<%=spBodyBookingId.ClientID%>' ).text( '#' + vBookingId );

                //First Tabular Details
                //===========================================================================
                //getCustomerIdFromBookingId( vBookingId );

                var vCustomerName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=lblCustomerName.ClientID%>' ).text( vCustomerName );
                //============================================================================

                //Second Tabular Details
                //===========================================================================
                //getPickupNameFromBookingId( vBookingId );
                getPickupDeliveryFromBookingId(vBookingId);
                //============================================================================

                viewBookingDetails( vBookingId );

                viewPaymentDetails( vBookingId );
                ViewBookingChargesDetails(vBookingId);
                $('#dvBooking').modal('show');

                //$("#loadingDiv").show();
                $("#loadingDiv").css('display', 'flex');
                $("#loadingDiv").css("z-index", "9999");
                setTimeout(function () {
                    $('#loadingDiv').fadeOut();
                }, 1500);

                return false;
            } );

            $('#dtViewBookings tbody').on('click', '.Track', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );
                var vBookingId = vClosestTr.find( 'td' ).eq( 0 ).text();

                location.href = "/Tracking.aspx?BookingId=" + vBookingId;

                return false;
            } );

            $( '#dtViewBookings tbody' ).on( 'click', '.cancel', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );
                var vBookingId = vClosestTr.find( 'td' ).eq( 0 ).text();

                $( '#<%=spHeaderBookingId.ClientID%>' ).text( '#' + vBookingId );
                getOrderStatusFromBookingId( vBookingId );
                $('#ErrReason').html('');
                $( '#CancelBooking-bx' ).modal( 'show' );
                return false;
            } );
        }

    </script>

    <script>
        function GetImagesByItems(BookingId, PickupCategoryId, PickupItemId) {
            //GET UPloaded Images
            $("#ImageTable tbody tr td").remove();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetItemImagesByItemId",
                data: "{ BookingId: '" + BookingId + "', PickupCategoryId: '" + PickupCategoryId + "', PickupItemId: '" + PickupItemId + "'}",
                dataType: "json",
                beforeSend: function () {
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 700);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    len = jdata.length;
                    //alert(len);
                    //alert(JSON.stringify(jdata));
                    debugger;
                    var newRowContent = "";
                    for (var i = 0; i < len; i++) {
                        newRowContent += "<td style='padding: 4px 4px 4px 4px;'><img src='" + jdata[i]['ImageUrl'] + "' title='" + jdata[i]['PickupItem'] + "' alt='#' height='50' width='50'/></td>";
                    }
                    $("#ImageTable tbody tr").append(newRowContent);
                },
                error: function (response) {
                    alert("Error");
                }
            });
        }

        function getCustomerIdFromCustomerName(CustomerName)
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerIdFromCustomerName",
                data: "{ CustomerName: '" + CustomerName + "'}",
                success: function ( result )
                {
                    $( '#spCustomerId' ).text( result.d );
                    $( '#<%=spHeaderCustomerId.ClientID%>' ).text( '#' + result.d);

                    getCustomerEmailIdFromCustomerId( result.d );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind CustomerId' );
                }
            } );
        }

        function getCustomerEmailIdFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerEmailIdFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerEmailID' ).text( result.d );

                    getCustomerDOBFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer EmailID' );
                }
            } );
        }

        function getCustomerDOBFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerDOBFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerDOB' ).text( result.d.toString().substring(0,10) );

                    getCustomerAddressFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer DOB' );
                }
            } );
        }

        function getCustomerAddressFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerAddressFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerAddress' ).text( result.d );

                    getCustomerPostCodeFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Address' );
                }
            } );
        }

        function getCustomerPostCodeFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerPostCodeFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerPostCode' ).text( result.d );

                    getCustomerMobileNoFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer PostCode' );
                }
            } );
        }

        function getCustomerMobileNoFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerMobileNoFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerMobile' ).text( result.d );

                    getCustomerLandlineFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Mobile' );
                }
            } );
        }

        function getCustomerLandlineFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerLandlineFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerLandline' ).text( result.d );

                    getCustomerHearAboutUsFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Landline' );
                }
            } );
        }

        function getCustomerHearAboutUsFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetCustomerHearAboutUsFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerHearAboutUs' ).text( result.d );

                    getHavingRegisteredCompanyFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Hear About Us' );
                }
            } );
        }

        function getHavingRegisteredCompanyFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetHavingRegisteredCompanyFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    var vResult = result.d.toString().toLowerCase();

                    switch ( vResult )
                    {
                        case "false":
                            $( '#spHavingRegisteredCompany' ).text( 'No' );
                            break;

                        case "true":
                            $( '#spHavingRegisteredCompany' ).text( 'Yes' );
                            break;
                    }

                    getRegisteredCompanyNameFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Having Registered Company' );
                }
            } );
        }

        function getRegisteredCompanyNameFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetRegisteredCompanyNameFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spRegisteredCompanyName' ).text( result.d );

                    getShippingGoodsInCompanyNameFromCustomerId( CustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Registered Company Name' );
                }
            } );
        }

        function getShippingGoodsInCompanyNameFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/GetShippingGoodsInCompanyNameFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    var vResult = result.d.toString().toLowerCase();

                    switch ( vResult )
                    {
                        case "false":
                            $( '#spShippingGoodsInCompanyName' ).text( 'No' );
                            break;

                        case "true":
                            $( '#spShippingGoodsInCompanyName' ).text( 'Yes' );
                            break;
                    }
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Customer Shipping Goods In Company Name' );
                }
            } );
        }

    </script>

    <script>

        function ViewBookingChargesDetails(vBookingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/ViewBookingChargesDetails",
                data: "{ BookingId: '" + vBookingId + "'}",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    var len = jdata.length;
                    var newRowContent = "";

                    $("#tblCharges tbody tr").remove();

                    if (len > 0) {
                        for (var i = 0; i < len; i++) {
                            newRowContent += '<tr>' +
                                                   '<td><strong>' + jdata[i]["TaxName"] + ':</strong></td>' +
                                                   '<td><em>£ ' + jdata[i]["TaxAmount"] + '</em></td>' +
                                               '</tr>';
                        }

                        $("#tblCharges tbody").append(newRowContent);

                    }


                },
                error: function (response) {
                    alert('Unable to get Customer Id from Booking Id');
                }
            });
        }

        function gotoEditBookingPage()
        {
            var vBodyBookingId = $( '#<%=spBodyBookingId.ClientID%>' ).text().trim();
            var vBookingId = vBodyBookingId.substring( 1, vBodyBookingId.length);

            location.href = "/BookingEdit.aspx?BookingId=" + vBookingId;
            return false;
        }

        function showCancelModal()
        {
            $( '#CancelBooking-bx' ).modal( 'show' );
            return false;
        }

        function cancelBooking()
        {
            debugger;
            var BookingId = $( '#<%=spHeaderBookingId.ClientID%>' ).text().trim().replace('#', '');
            var OrderStatus = $('#<%=hfOrderStatus.ClientID%>').val().trim();
            var taReason = $('#taReason').val().trim();

            if (taReason.length == 0) {
                $('#ErrReason').html('Please enter Reason');
                //alert('Please enter Reason');
                //return false;
            }
            else { 
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyBookings.aspx/CancelBooking",
                data: "{ BookingId: '" + BookingId + "', OrderStatus: '" + OrderStatus + "', Reason: '" + taReason + "' }",
                success: function ( result )
                {
                    $('#CancelBooking-bx').modal('hide');
                    location.reload();
                },
                error: function ( response )
                {
                    alert( 'Unable to Cancel Booking' );
                }
            } );
            }
            return false;
        }

        function clearErrorMessage()
        {
            var vErrMsg = $("#<%=lblErrorMessage.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css( "display", "none" );

            $("#<%=ltrlErrorMessage.ClientID%>").text('');
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
        function clearBookingModalPopup() {
            $('#<%=spHeaderBookingId.ClientID%>').text('');
            $('#<%=spBodyBookingId.ClientID%>').text('');

            $('#<%=lblCustomerId.ClientID%>').text('');
            $('#<%=lblCustomerName.ClientID%>').text('');
            $('#<%=lblCustomerMobile.ClientID%>').text('');

            $('#<%=lblPickupName.ClientID%>').text('');
            $('#<%=lblPickupAddress.ClientID%>').text('');
            $('#<%=lblPickupMobile.ClientID%>').text('');

            $('#<%=lblDeliveryName.ClientID%>').text('');
            $('#<%=lblDeliveryAddress.ClientID%>').text('');
            $('#<%=lblDeliveryMobile.ClientID%>').text('');

            $('#<%=lblPickupDateTime.ClientID%>').text('');
            $('#dvMyBookings tbody').empty();

            <%--$('#<%=lblVAT.ClientID%>').text('');--%>
            $('#<%=lblOrderTotal.ClientID%>').text('');
            $('#dvMyPaymentDetails tbody').empty();

            return false;
        }

        function clearCustomerModalPopup() {
            $('#<%=spHeaderCustomerId.ClientID%>').text('');
            $('#spCustomerId').text('');
            $('#spCustomerName').text('');
            $('#spCustomerEmailID').text('');
            $('#spCustomerDOB').text('');
            $('#spCustomerAddress').text('');
            $('#spCustomerPostCode').text('');
            $('#spCustomerMobile').text('');
            $('#spCustomerLandline').text('');
            $('#spCustomerHearAboutUs').text('');
            $('#spHavingRegisteredCompany').text('');
            $('#spRegisteredCompanyName').text('');
            $('#spShippingGoodsInCompanyName').text('');

            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>View My Bookings
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <form id="frmViewMyBookings" runat="server">
                <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrorMessage"
                                runat="server" Text=""></asp:Label>
                            
                            <asp:Literal ID="ltrlErrorMessage" runat="server"></asp:Literal>

                            <asp:HiddenField ID="hfEmailID" runat="server" />
                            <asp:HiddenField ID="hfOrderStatus" runat="server" />

                            <div class="col-md-12">
                               <div class="hugeLeftGap">
                                    <div class="row">
                                       <div class="col-md-12">
                                            <div class="row">
                                                <span class="iconADD pull-left">
                                                    <asp:Button ID="btnExportPdfBookingDetails" runat="server"  
                                                        Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                                </span>

                                                <span class="iconADD pull-left">
                                                    <asp:Button ID="btnExportExcelBookingDetails" runat="server"  
                                                    Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                                </span>                                        
                                            </div>
                                       </div>
                                   </div>
                                </div>

                                   <br />

                                </div>
                            </div>
                        </div>

                        <div class="panel-body clrBLK col-md-12">
                            <div class="row">
                                <div class="form-group">
                                    <div style="margin-left:0;">
                                        <!-- jQuery DataTable -->
                                        <table id="dtViewBookings" style="margin-left: 0px; width: 100%;">
                                            <thead>
                                                <tr>
                                                    <th>Booking Id</th>
                                                    <th>Customer Name</th>
                                                    <th>Order Date</th>
                                                    <th>Insurance Premium</th>
                                                    <th>Total Value</th>
                                                    <th>Order Status</th>
                                                    <th style="width: 100px;">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                    <br />
                                </div>
                                <br />
                            </div>
                        </div>
                    </div>

                    <div class="modal fade" id="confirmCancel-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Cancel Booking Updation?</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p>Sure you want to Cancel Booking Updation?</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="">Yes</button>
                                    <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="">No</button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="modal fade" id="cancelMsg-bx" role="dialog">
                    <div class="modal-dialog">
    
                        <!-- Modal content-->
                        <div class="modal-content">
                        <div class="modal-header" style="background-color:#f0ad4ecf;">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title pm-modal" style="font-size:24px;color:#111;">Booking Cancelled</h4>
                        </div>
                        <div class="modal-body" style="text-align: center;font-size: 22px;">
                            <p>Your Booking has been cancelled</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                        </div>
                        </div>
      
                    </div>
                    </div>

                    <div class="modal fade" id="Msg-bx" role="dialog">
                        <div class="modal-dialog">
    
                            <!-- Modal content-->
                            <div class="modal-content">
                            <div class="modal-header" style="background-color:#f0ad4ecf;">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title pm-modal" style="font-size:24px;color:#111;">Message Box</h4>
                            </div>
                            <div class="modal-body" style="text-align: center;font-size: 22px;">
                                <p id="pMsg"></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                            </div>
                            </div>
      
                        </div>
                    </div>

                    <div class="modal fade" id="dvBooking" role="dialog">
                        <div class="modal-dialog modal-lg">
                        
                          <!-- Modal content-->
                          <div class="modal-content bkngDtailsPOP viewBKNG">
                            <div class="modal-header" style="background-color:#f0ad4ecf;">
                              <button type="button" class="close" data-dismiss="modal">&times;</button>
                              <h4 class="modal-title pm-modal">
                                  <i class="fa fa-info-circle" aria-hidden="true"></i> Order Information: 
                                  <span id="spHeaderBookingId" runat="server"></span>
                              </h4>
                            </div>
                            <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; overflow-x: auto;">
                                <p><strong>Please find the details of order 
                                    <span id="spBodyBookingId" runat="server"></span> below:</strong></p>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="twoSrvbtn">
                                        <button id="btnEditBooking" data-dismiss="modal" title="Edit Booking"
                                            onclick="return gotoEditBookingPage();">
                                            <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                        </button>
                                
                                        <%--<button id="btnCancelBooking" data-dismiss="modal" title="Cancel Booking"
                                            onclick="return showCancelModal();">
                                            <i class="fa fa-times" aria-hidden="true"></i>
                                        </button> --%>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="twoSETbtn">
                                        <button id="btnPrintBookingModal" data-dismiss="modal" title="Print Booking Details" 
                                            onclick="return printDetails('dvBooking');" style="margin-bottom:10px;">
                                            <i class="fa fa-print" aria-hidden="true"></i></button>
                                        <button id="btnPrintPdfBookingModal" data-dismiss="modal" title="Download as PDF" 
                                            onclick="exportToPDF('dvBooking', 'BookingMyDetails.pdf');" style="margin-bottom:10px;">
                                            <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                        <button id="btnPrintExcelBookingModal" data-dismiss="modal" title="Download as Excel"
                                            onclick="exportToExcel('dvMyBookings', 'CustomerDetails.xls');" style="margin-bottom:10px;">
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12">
                                    <div class="row">
                                        <div class="dvCNFRM">
                                            <h2 class="">Customer Account Details:</h2>
                                            <div class="confirm-box">
                                                <div class="confirm-details">
                                                    <ul class="custoDTAIL">
                                                        <li>Customer ID</li>
                                                        <li>Customer Name</li>
                                                        <li>Customer Mobile</li>

                                                        <li>
                                                            <asp:Label ID="lblCustomerId" runat="server" Text="Customer Id"></asp:Label>
                                                        </li>
                                                        <li>
                                                            <asp:Label ID="lblCustomerName" runat="server" Text="Customer Name"></asp:Label>
                                                        </li>
                                                        <li>
                                                            <asp:Label ID="lblCustomerMobile" runat="server" Text="Customer Mobile"></asp:Label>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                    <div class="image_table clearfix">
                                        <strong>Uploaded Photo(s)</strong>
                                            <div class="img_tab">
                                                <table id="ImageTable">
                                                <tr>
                                                
                                                </tr>
                                            </table>                        
                                        </div>
                                         <div class="rld_img">
                                        <span onclick="return GetItemImagesByBookingId();">refresh images <i class="fa fa-refresh" aria-hidden="true"></i></span>
                                    </div>
                                    </div>
                                <div class="col-md-12" style="text-align: left;font-size: 22px; ">
                                    <p class="bk_id">
                                        <strong>Booking Note : </strong><span id="StatusDetails" style="font-size:20px; "></span>
                                    </p>
                                </div>
                                <div class="col-md-12">
                                    <div class="row">
                                        <div class="dvCNFRM">
                                        <h2 class="">Collection and Delivery Details</h2>
                                        <div class="confirm-box">
                                            <div class="confirm-details">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <h4>Pickup Address</h4>
                                                        <p class="clnName"><strong>
                                                            <span id="PCustomerTitle"></span>  <asp:Label ID="lblPickupName" runat="server" Text=""></asp:Label>
                                                        </strong></p>

                                                        <p class="adrs-sec">
                                                            <span class="icnHGT"><i class="fa fa-map-marker" aria-hidden="true"></i></span>
                                                            <asp:Label ID="lblPickupAddress" runat="server" Text=""></asp:Label>
                                                        </p>

                                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                                            <asp:Label ID="lblPickupMobile" runat="server" Text=""></asp:Label>
                                                        </p>
                                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                                            <asp:Label ID="lblAltPickupMobile" runat="server" Text=""></asp:Label>
                                                        </p>
                                                    </div>

                                                    <div class="col-md-6 rgtALNG">
                                                        <h4>Delivery Address</h4>
                                                        <p class="clnName"><strong>
                                                            <span id="DCustomerTitle"></span>  <asp:Label ID="lblDeliveryName" runat="server" Text=""></asp:Label>
                                                        </strong></p>

                                                        <p class="adrs-sec">
                                                            <span class="icnHGT"><i class="fa fa-map-marker" aria-hidden="true"></i></span>
                                                            <asp:Label ID="lblDeliveryAddress" runat="server" Text=""></asp:Label>
                                                        </p>

                                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                                            <asp:Label ID="lblDeliveryMobile" runat="server" Text=""></asp:Label>
                                                        </p>
                                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                                            <asp:Label ID="lblAltDeliveryMobile" runat="server" Text=""></asp:Label>
                                                        </p>
                                                    </div>
                                                </div>
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
                                                        <p class="mntnTYM">
                                                            <strong>Pickup Date :
                                                            <asp:Label ID="lblPickupDateTime" runat="server" 
                                                                Text=""></asp:Label>
                                                            </strong>
                                                        </p>
                                
                                                        <p class="undrLN" style="display:none!important;"><strong>Pickup:</strong></p><br />
                                                        <!-- jQuery DataTable -->
                                                         <table id="dvMyBookings" style="width: 100%;">
                                                            <thead>
                                                                <tr>
                                                                    <th>Item</th>
                                                                    <th>Cost</th>
                                                                    <th>Estimated Value</th>
                                                                    <th>Status</th>
                                                                    <th style="display:none;">Booking Id</th>
                                                                    <th style="display:none;">Pickup Category Id</th>
                                                                    <th style="display:none;">Pickup Item Id</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            </tbody>
                                                        </table>
                                   
                                                        <div class="table_total">
                                                            <table id="tblCharges" class="table22" border="0">
                                                              <tbody>
                             
                                                              </tbody>
                                                                <tfoot>
                                                                    <tr>
                                                                        <td><strong>Order Total (inc. vat)</strong></td>
                                                                        <td><em>£ <asp:Label ID="lblOrderTotal" runat="server" 
                                                                    Text="Order Total"></asp:Label></em></td>
                                                                    </tr>
                                                                </tfoot>
                                                            </table>
                                                        </div>

                                                        <ul class="vatTotal">
                                                            <%--<li>
                                                                <strong>VAT: 
                                                                <i class="note-disclaimer italic_pound"><i> £
                                                                <asp:Label ID="lblVAT" runat="server" 
                                                                    Text="VAT"></asp:Label>
                                                                    </i></i></strong>
                                                            </li>
                                                            <li>
                                                                <strong>Order Total
                                                                <i class="note-disclaimer italic_pound">(inc. vat)<i>: £
                                                                <asp:Label ID="lblOrderTotal" runat="server" 
                                                                    Text="Order Total"></asp:Label>
                                                                    </i></i></strong>
                                                            </li>--%>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    </div>
                                </div>
                            </div>                        

                            <!-- New Division for Payment Related Information -->
                            <div class="row">
                                <div class="col-md-12">
                                    <p class="undrLN" id="pPaymentDetails" runat="server"><strong>Payment Details:</strong></p>
                                        <!-- jQuery DataTable -->
                                    <table id="dvMyPaymentDetails" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th>Transaction ID</th>
                                                <th>Email Id</th>
                                                <th>Contact No</th>
                                                <th>Quantity</th>
                                                <th>Payment Amount</th>
                                                <th>Payment Currency</th>
                                                <th>Payment Date And Time</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                </table>

                                </div>
                            </div>
                           </div>
                          </div>
      
                        </div>
                      </div>
 
                </form>
            </div>
        </div>

    <div class="modal fade" id="CancelBooking-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Cancel Booking</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <p>Sure? You want to cancel this Booking?</p>
                </div>
                <div id="ReasonSec" class="form-group">
                  <label for="comment">Reason:</label>
                  <textarea id="taReason" style="color:black !important; padding: 0 30px;" class="form-control" rows="5" ></textarea>
                    <div id="ErrReason" style="color:red;"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="return cancelBooking();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>
      
        </div>
    </div>
    
    <div class="modal fade" id="dvCustomerDetailsModal" role="dialog">
        <div class="modal-dialog modal-lg">
    
            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i> Customer Information: 
                        <span id="spHeaderCustomerId" runat="server"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto;position:relative;">
                <p><strong>Please find the details of this Customer below:</strong></p>
                <div class="row">
                    <div class="col-md-12">
                        <div class="twoSETbtn">
                            <button id="btnPrintCustomerModal1" data-dismiss="modal" title="Print Customer Details"
                                onclick="return printDetails('tblCustomerDetails');" style="margin-bottom:10px;">
                                <i class="fa fa-print" aria-hidden="true"></i></button>
                            <button id="btnPrintPdfCustomerModal1" data-dismiss="modal" title="Download as PDF"
                                onclick="exportToPDF('dvCustomerDetailsModal', 'CustomerDetails.pdf');" style="margin-bottom:10px;">
                                <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                            <button id="btnPrintExcelCustomerModal1" data-dismiss="modal" title="Download as Excel"
                                onclick="exportToExcel('tblCustomerDetails', 'CustomerDetails.xls');" style="margin-bottom:10px;">
                                <i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="dvCNFRM">
                                <h2 class="">Customer Details:</h2>
                                <div class="confirm-box">
                                    <div class="confirm-details">
                                        <div class="table-responsive">
                                            <table class="table custoFULLdet" id="tblCustomerDetails">
                                                <tr>
                                                    <th>Customer ID: </th>
                                                    <td><span id="spCustomerId"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Name: </th>
                                                    <td><span id="spCustomerName"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Email ID: </th>
                                                    <td><span id="spCustomerEmailID"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Date Of Birth: </th>
                                                    <td><span id="spCustomerDOB"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Address: </th>
                                                    <td><span id="spCustomerAddress"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Post Code:: </th>
                                                    <td><span id="spCustomerPostCode"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Mobile No: </th>
                                                    <td><span id="spCustomerMobile"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Landline: </th>
                                                    <td><span id="spCustomerLandline"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Hear About Us: </th>
                                                    <td><span id="spCustomerHearAboutUs"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Having Registered Company: </th>
                                                    <td><span id="spHavingRegisteredCompany"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Registered Company Name: </th>
                                                    <td><span id="spRegisteredCompanyName"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>Shipping Goods In Company Name: </th>
                                                    <td><span id="spShippingGoodsInCompanyName"></span></td>
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

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" 
    CodeBehind="ViewAllOfMyQuotations.aspx.cs" Inherits="JobyCoWebCustomize.ViewAllOfMyQuotations" %>

<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

    <style>
        .view, .convert {
            background:none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }
        .view:hover, .convert:hover {
            background: #fca311;
            color:#fff;
            text-shadow:1px 1px 1px rgba(0,0,0,0.4);
        }

        .QuotingId, .CustomerName {

        }
    </style>

    <script>
        var vConvertToBooking = false;

        $(document).ready(function ()
        {
            getAllOfMyQuotations();
            getBookingId();
        });
    </script>

    <script>
        function viewQuotingDetails(QuotingId)
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/ViewQuotingDetails",
                data: "{ QuotingId: '" + QuotingId + "'}",
                contentType: "application/json; charset=utf-8",
                success: function ( result )
                {
                    var jsonQuotationDetails = JSON.parse( result.d );
                    $( '#dvMyQuotations' ).DataTable( {
                        data: jsonQuotationDetails,
                        columns: [
                            { data: "QuotingId" },
                            { data: "CustomerName" },
                            { data: "PickupCategory" },
                            { data: "PickupItem" },
                            { data: "IsFragile" },
                            { data: "EstimatedValue" }
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
                    alert( 'Unable to View Quotation Details' );
                }
            } );//end of ajax
        }

        function viewQuotationDetails(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/ViewQuotingDetails",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    var jsonQuotingDetails = JSON.parse(result.d);
                    $('#dvAllOfMyQuotations').DataTable({
                        data: jsonQuotingDetails,
                        columns: [
                            { data: "Item" },
                            { data: "IsFragile" },
                            {
                                data: "Cost",
                                render: function (Cost) {
                                    return roundOffDecimalValue(Cost);
                                }
                            },
                            {
                                data: "EstimatedValue",
                                render: function (EstimatedValue) {
                                    return roundOffDecimalValue(EstimatedValue);
                                }
                            },
                            { data: "Status" }
                        ],
                        "bLengthChange": false,
                        "bFilter": false,
                        "bInfo": false,
                        "bPaginate": false,
                        "bDestroy": true
                    });
                },
                error: function (response) {
                    alert('Unable to View Quotation Details');
                }
            });//end of ajax
        }

        function getAllOfMyQuotations()
        {
            var EmailID = $( '#<%=hfEmailID.ClientID%>' ).val().trim();

            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetAllOfMyQuotations",
                data: "{ EmailID: '" + EmailID + "'}",
                contentType: "application/json; charset=utf-8",
                success: function ( result )
                {
                    var jsonQuotationDetails = JSON.parse( result.d );
                    $( '#dtViewQuotations' ).DataTable( {
                        data: jsonQuotationDetails,
                        columns: [
                            {
                                data: "QuotingId",
                                render: function (data) {
                                    return '<a class="QuotingId">' + data + '</a>';
                                }
                            },
                            {
                                data: "CustomerName",
                                render: function (data) {
                                    return '<a class="CustomerName">' + data + '</a>';
                                }
                            },
                            {
                                data: "QuotationDate",
                                render: function ( jsonQuotationDate )
                                {
                                    return getFormattedDateUK( jsonQuotationDate );
                                }
                            },
                            {
                                data: "TotalValue",
                                render: function (TotalValue) {
                                    return roundOffDecimalValue(TotalValue);
                                }
                            },
                            {
                                defaultContent:
                                    "<button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button><button class='convert' title='Convert To Booking'><i class='fa fa-adjust' aria-hidden='true'></i></button>"
                            }
                        ],
                        "aaSorting": [
                            [0, "desc"]
                        ]
                } );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind All Quotations' );
                }
            } );//end of ajax

            $( '#dtViewQuotations tbody' ).on( 'click', '.QuotingId', function ()
            {
                vConvertToBooking = false;

                var vClosestTr = $(this).closest("tr");
                var vQuotingId = vClosestTr.find('td').eq(0).text();

                clearQuotationModalPopup();

                $( '#<%=spHeaderQuotationId.ClientID%>' ).text( '#' + vQuotingId );
                $( '#<%=spBodyQuotationId.ClientID%>' ).text( '#' + vQuotingId );

                //First Tabular Details
                //===========================================================================
                getCustomerIdFromQuotingId( vQuotingId );

                var vCustomerName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=lblCustomerName.ClientID%>' ).text( vCustomerName );
                //============================================================================

                //Second Tabular Details
                //===========================================================================
                getPickupNameFromQuotingId( vQuotingId );
                //============================================================================

                viewQuotationDetails(vQuotingId);

                $( '#dvQuotationDetails' ).modal( 'show' );
                return false;
            } );

            $( '#dtViewQuotations tbody' ).on( 'click', '.CustomerName', function ()
            {
                vConvertToBooking = false;

                var vClosestTr = $(this).closest("tr");
                var vCustomerName = vClosestTr.find('td').eq(1).text();

                clearCustomerModalPopup();

                $( '#spCustomerName' ).text( vCustomerName );

                getCustomerIdFromCustomerName( vCustomerName );

                $( '#dvCustomerDetailsModal' ).modal( 'show' );

                return false;
            } );

            $('#dtViewQuotations tbody').on('click', '.view', function ()
            {
                vConvertToBooking = false;

                var vClosestTr = $(this).closest("tr");
                var vQuotingId = vClosestTr.find('td').eq(0).text();

                clearQuotationModalPopup();

                $( '#<%=spHeaderQuotationId.ClientID%>' ).text( '#' + vQuotingId );
                $( '#<%=spBodyQuotationId.ClientID%>' ).text( '#' + vQuotingId );

                //First Tabular Details
                //===========================================================================
                getCustomerIdFromQuotingId( vQuotingId );

                var vCustomerName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=lblCustomerName.ClientID%>' ).text( vCustomerName );
                //============================================================================

                //Second Tabular Details
                //===========================================================================
                getPickupNameFromQuotingId( vQuotingId );
                //============================================================================

                viewQuotationDetails( vQuotingId );

                $( '#dvQuotationDetails' ).modal( 'show' );

                return false;
            });

            $('#dtViewQuotations tbody').on('click', '.convert', function () {
                vConvertToBooking = true;

                var vClosestTr = $(this).closest("tr");
                var vQuotingId = vClosestTr.find('td').eq(0).text();

                //Collection of Values of Different Fields required for Booking
                var vBookingId = $('#spBookingId').text().trim();

                //Setting Data for QuotPickup Table Fields
                //========================================
                viewQuotationDetails(vQuotingId);
                //========================================

                getCustomerIdFromQuotationId(vQuotingId);

                return false;
            });
        }

    </script>

    <script>
        function getBookingId() {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetBookingId",
                data: "{}",
                success: function ( result )
                {
                    $('#spBookingId').text(result.d);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Booking Id' );
                }
            } );
        }

        function getCustomerIdFromQuotationId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetCustomerIdFromQuotationId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#spCustomerId').text(result.d);

                    getPickupCategoryFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert('Unable to get Customer Id from Quoting Id');
                }
            });

            return false;
        }

        function getPickupCategoryFromQuotingId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupCategoryFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#spPickupCategory').text(result.d);

                    getPickupNameFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Category from Quoting Id');
                }
            });

            return false;
        }


    </script>

    <script>
        //=============Customer Details=================
        function getCustomerIdFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetCustomerIdFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblCustomerId.ClientID%>' ).text( result.d );

                    var vCustomerId = $( '#<%=lblCustomerId.ClientID%>' ).text().trim();
                    getCustomerMobileFromCustomerId( vCustomerId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Customer Id from Quoting Id' );
                }
            } );
        }

        function getCustomerMobileFromCustomerId( CustomerId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetCustomerMobileFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    $( '#<%=lblCustomerMobile.ClientID%>' ).text( result.d );
                },
                error: function (response) {
                    alert( 'Unable to get Customer Mobile from Customer Id' );
                }
            } );
        }

        //====================== Quoting Details ================================
        function getPickupNameFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupNameFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupName.ClientID%>' ).text( result.d );
                    $( '#spPickupName' ).text( result.d );

                    getPickupAddressFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Name from Quoting Id' );
                }
            } );

            return false;
        }

        function getPickupAddressFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupAddressFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupAddress.ClientID%>' ).text( result.d );
                    $( '#spPickupAddress' ).text( result.d );

                    getPickupMobileFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Address from Quoting Id' );
                }
            } );

            return false;
        }

        function getPickupMobileFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupMobileFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupMobile.ClientID%>' ).text( result.d );
                    $( '#spPickupMobile' ).text( result.d );

                    getDeliveryNameFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Mobile from Quoting Id' );
                }
            } );

            return false;
        }

        function getDeliveryNameFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetDeliveryNameFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryName.ClientID%>' ).text( result.d );
                    $( '#spDeliveryName' ).text( result.d );

                    getDeliveryAddressFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Name from Quoting Id' );
                }
            } );

            return false;
        }

        function getDeliveryAddressFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetDeliveryAddressFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryAddress.ClientID%>' ).text( result.d );
                    $( '#spRecipentAddress' ).text( result.d );

                    getDeliveryMobileFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Address from Quoting Id' );
                }
            } );

            return false;
        }

        function getDeliveryMobileFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetDeliveryMobileFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryMobile.ClientID%>' ).text( result.d );
                    $( '#spDeliveryMobile' ).text( result.d );

                    getPickupDateAndTimeFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Mobile from Quoting Id' );
                }
            } );

            return false;
        }

        function getLongDateTime( vDate )
        {
            var vDay = parseInt( vDate.substring( 0, 2 ), 10 );
            var vMonth = parseInt( vDate.substring( 3, 5 ), 10 );
            var vYear = parseInt( vDate.substring( 6, 10 ), 10 );

            var dtDate = new Date( vYear, vMonth, vDay );

            return dtDate.toUTCString();
        }

        function getPickupDateAndTimeFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupDateAndTimeFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupDateTime.ClientID%>' ).text( result.d );

                    //Get LongDateTime
                    var vPickupDateTime = $( '#<%=lblPickupDateTime.ClientID%>' ).text().trim();
                    var vLongDateTime = getLongDateTime( vPickupDateTime );

                    $( '#<%=lblPickupDateTime.ClientID%>' ).text( vLongDateTime );
                    $( '#spPickupDateTime' ).text( result.d );

                    getVATfromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup Date and Time from Quoting Id' );
                }
            } );

            return false;
        }

        function getVATfromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetVATfromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblVAT.ClientID%>' ).text( result.d );
                    $( '#spVAT' ).text( result.d );

                    getOrderTotalFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get VAT from Quoting Id' );
                }
            } );

            return false;
        }

        function getOrderTotalFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetOrderTotalFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblOrderTotal.ClientID%>' ).text( result.d );
                    $( '#spTotalValue' ).text( result.d );

                    if (vConvertToBooking) {
                        getOrderStatusFromQuotingId(QuotingId);
                    }
                },
                error: function ( response )
                {
                    alert( 'Unable to get Order Total from Quoting Id' );
                }
            } );

            return false;
        }

        function getOrderStatusFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetOrderStatusFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $('#spOrderStatus').text(result.d);

                    getIsFragileFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Order Status from Quoting Id' );
                }
            } );

            return false;
        }

        function getIsFragileFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetIsFragileFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#spIsFragile' ).text( result.d );

                    getItemCountFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Is Fragile from Quoting Id' );
                }
            } );

            return false;
        }

        function getItemCountFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetItemCountFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#spItemCount' ).text( result.d );

                    getQuotingNotesFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Item Count from Quoting Id' );
                }
            } );

            return false;
        }

        function getQuotingNotesFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetQuotingNotesFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    //$( '#spQuotingNotes' ).text( result.d );
                    $('#spBookingNotes').text(result.d);

                    getInsurancePremiumFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Quoting Notes from Quoting Id' );
                }
            } );

            return false;
        }

        function getInsurancePremiumFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetInsurancePremiumFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#spInsurancePremium' ).text( result.d );

                    getPickupPostCodeFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Insurance Premium from Quoting Id' );
                }
            } );

            return false;
        }

        function getPickupPostCodeFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupPostCodeFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#spPickupPostCode' ).text( result.d );

                    getDeliveryPostCodeFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup PostCode from Quoting Id' );
                }
            } );

            return false;
        }

        function getDeliveryPostCodeFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetDeliveryPostCodeFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#spDeliveryPostCode' ).text( result.d );

                    getQuotingDateFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Delivery PostCode from Quoting Id' );
                }
            } );

            return false;
        }

        function getQuotingDateFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetQuotingDateFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    //$( '#spQuotingDate' ).text( result.d );
                    $('#spBookingDate').text(result.d);

                    getPickupEmailFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Quoting Date from Quoting Id' );
                }
            } );

            return false;
        }

        function getPickupEmailFromQuotingId( QuotingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupEmailFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function ( result )
                {
                    $( '#spPickupEmail' ).text( result.d );

                    getDeliveryEmailFromQuotingId(QuotingId);
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup Email from Quoting Id' );
                }
            } );

            return false;
        }

        function getDeliveryEmailFromQuotingId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetDeliveryEmailFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#spDeliveryEmail').text(result.d);

                    getEstimatedValueFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert('Unable to get Delivery Email from Quoting Id');
                }
            });

            return false;
        }

        function getEstimatedValueFromQuotingId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetEstimatedValueFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#spEstimatedValue').text(result.d);

                    getPickupItemFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert('Unable to get Estimated Value from Quoting Id');
                }
            });

            return false;
        }

        function getPickupItemFromQuotingId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetPickupItemFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#spPickupItem').text(result.d);

                    getDeliveryDateTimeFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert('Unable to get Pickup Item from Quoting Id');
                }
            });

            return false;
        }

        function getDeliveryDateTimeFromQuotingId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetDeliveryDateTimeFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#spDeliveryDateTime').text(result.d);

                    getWhetherOtherExistsFromQuotingId(QuotingId);
                },
                error: function (response) {
                    alert('Unable to get Delivery DateTime from Quoting Id');
                }
            });

            return false;
        }

        function getWhetherOtherExistsFromQuotingId(QuotingId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetWhetherOtherExistsFromQuotingId",
                data: "{ QuotingId: '" + QuotingId + "'}",
                success: function (result) {
                    $('#<%=hfWhetherOtherExists.ClientID%>').val(result.d);

                    //Initializing Values for Convert To Booking
                    //=========================================================
                    var BookingId = $('#spBookingId').text().trim();
                    var CustomerId = $('#spCustomerId').text().trim();

                    var PickupCategory = $('#spPickupCategory').text().trim();
                    var PickupDateTime = $('#spPickupDateTime').text().trim();
                    var PickupAddress = $('#spPickupAddress').text().trim();

                    var IsFragile = $('#spIsFragile').text().trim();
                    var EstimatedValue = $('#spEstimatedValue').text().trim();

                    var ItemCount = $('#spItemCount').text().trim();
                    var TotalValue = $('#spTotalValue').text().trim();

                    var DeliveryCategory = $('#spPickupCategory').text().trim();
                    var DeliveryDateTime = $('#spDeliveryDateTime').text().trim();
                    var RecipientAddress = $('#spRecipentAddress').text().trim();

                    var DeliveryQuantity = $('#spItemCount').text().trim();
                    var TotalCharge = $('#spTotalValue').text().trim();

                    var BookingNotes = $('#spBookingNotes').text().trim();
                    var OrderStatus = $('#spOrderStatus').text().trim();
                    var PickupItem = $('#spPickupItem').text().trim();
                    var VAT = $('#spVAT').text().trim();
                    var InsurancePremium = $('#spInsurancePremium').text().trim();

                    var PickupName = $('#spPickupName').text().trim();
                    var PickupMobile = $('#spPickupMobile').text().trim();

                    var DeliveryName = $('#spDeliveryName').text().trim();
                    var DeliveryMobile = $('#spDeliveryMobile').text().trim();

                    var PickupPostCode = $('#spPickupPostCode').text().trim();
                    var DeliveryPostCode = $('#spDeliveryPostCode').text().trim();

                    var Bookingdate = $('#spBookingDate').text().trim();

                    var PickupEmail = $('#spPickupEmail').text().trim();
                    var DeliveryEmail = $('#spDeliveryEmail').text().trim();

                    var IsAssigned = 'false';
                    var WhetherOtherExists = $('#<%=hfWhetherOtherExists.ClientID%>').val().trim();

                    //Binding Booking Details to object
                    var objBooking = {};
                    objBooking.BookingId = BookingId;
                    objBooking.CustomerId = CustomerId;

                    objBooking.PickupCategory = PickupCategory;
                    objBooking.PickupDateTime = PickupDateTime;
                    objBooking.PickupAddress = PickupAddress;

                    objBooking.Width = "0";
                    objBooking.Height = "0";
                    objBooking.Length = "1";

                    objBooking.IsFragile = IsFragile;
                    objBooking.EstimatedValue = EstimatedValue;

                    objBooking.ItemCount = ItemCount;
                    objBooking.TotalValue = TotalValue;

                    objBooking.DeliveryCategory = DeliveryCategory;
                    objBooking.DeliveryDateTime = DeliveryDateTime;
                    objBooking.RecipientAddress = RecipientAddress;

                    objBooking.DeliveryQuantity = DeliveryQuantity;
                    objBooking.DeliveryCharge = "0";
                    objBooking.TotalCharge = TotalCharge;

                    objBooking.BookingNotes = BookingNotes;
                    objBooking.OrderStatus = OrderStatus;
                    objBooking.PickupItem = PickupItem;
                    objBooking.VAT = VAT;
                    objBooking.InsurancePremium = InsurancePremium;

                    //New Object Property Added for few more Pickup and Delivery Fields
                    //======================================================
                    objBooking.PickupName = PickupName;
                    objBooking.PickupMobile = PickupMobile;

                    objBooking.DeliveryName = DeliveryName;
                    objBooking.DeliveryMobile = DeliveryMobile;

                    objBooking.PickupPostCode = PickupPostCode;
                    objBooking.DeliveryPostCode = DeliveryPostCode;
                    //======================================================
                    objBooking.Bookingdate = Bookingdate;

                    //A Couple of New Fields Added
                    //=========================================================================
                    objBooking.PickupEmail = PickupEmail;
                    objBooking.DeliveryEmail = DeliveryEmail;
                    //=========================================================================

                    objBooking.IsAssigned = IsAssigned;
                    objBooking.WhetherOtherExists = WhetherOtherExists;

                    $.ajax({
                        type: "POST",
                        url: "ViewAllOfMyQuotations.aspx/AddBookingOperation",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(objBooking),
                        dataType: "json",
                        success: function (result) {
                            //Add BookPickup Details Code
                            //=======================================
                            var PickupCategoryItem = "";
                            var PredefinedEstimatedValue = "";

                            $('#dvAllOfMyQuotations tbody > tr').each(function () {
                                //Cutting out Category and Item Separately
                                //========================================================
                                PickupCategoryItem = $(this).find('td:eq(0)').text().trim();

                                if (hasDash(PickupCategoryItem)) {
                                    var CategoryItem = PickupCategoryItem.split('-');

                                    PickupCategory = CategoryItem[0].trim();
                                    PickupItem = CategoryItem[1].trim();
                                }
                                //========================================================

                                IsFragile = $(this).find('td:eq(1)').text().trim();

                                if (IsFragile == 'Yes') IsFragile = "True";
                                if (IsFragile == 'No') IsFragile = "False";

                                PredefinedEstimatedValue = $(this).find('td:eq(2)').text().trim().replace('£', '');
                                EstimatedValue = $(this).find('td:eq(3)').text().trim().replace('£', '');

                                objBP = {};
                                objBP.PickupId = "";
                                objBP.BookingId = BookingId;
                                objBP.CustomerId = CustomerId;
                                objBP.PickupCategory = PickupCategory;
                                objBP.PickupItem = PickupItem;
                                objBP.IsFragile = IsFragile;
                                objBP.EstimatedValue = EstimatedValue;
                                objBP.PredefinedEstimatedValue = PredefinedEstimatedValue;

                                $.ajax({
                                    type: "POST",
                                    url: "ViewAllOfMyQuotations.aspx/AddBookPickup",
                                    contentType: "application/json; charset=utf-8",
                                    data: JSON.stringify(objBP),
                                    dataType: "json",
                                    success: function (result) {

                                    },
                                    error: function (response) {

                                    }
                                });//end of BookPickup Entry
                            });//end of DataTable go through Loop

                            //=======================================

                            //Update the field 'Length' by '1.1' in OrderQuoting
                            //===================================================
                            $.ajax({
                                type: "POST",
                                url: "ViewAllOfMyQuotations.aspx/UpdateQuotationFlag",
                                contentType: "application/json; charset=utf-8",
                                data: "{ QuotingId: '" + QuotingId + "'}",
                                dataType: "json",
                                success: function (result) {

                                },
                                error: function (response) {

                                }
                            });//end of Update 
                            //===================================================
                        },
                        error: function (response) {
                            alert('Unable to Add into OrderBooking Table');
                        }
                    });

                    $('#Success-bx').modal('show');
                },
                error: function (response) {
                    alert('Unable to get Whether Other Exists from Quoting Id');
                }
            });

            return false;
        }
    </script>

    <script>
        function getCustomerIdFromCustomerName(CustomerName)
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllOfMyQuotations.aspx/GetCustomerIdFromCustomerName",
                data: "{ CustomerName: '" + CustomerName + "'}",
                success: function ( result )
                {
                    $( '#spCustomerId' ).text( result.d );
                    $( '#<%=spHeaderCustomerId.ClientID%>' ).text( '#' + result.d.toString() );

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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerEmailIdFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerDOBFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function ( result )
                {
                    $( '#spCustomerDOB' ).text( result.d.toString().substring( 0, 10 ) );

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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerAddressFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerPostCodeFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerMobileNoFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerLandlineFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetCustomerHearAboutUsFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetHavingRegisteredCompanyFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetRegisteredCompanyNameFromCustomerId",
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
                url: "ViewAllOfMyQuotations.aspx/GetShippingGoodsInCompanyNameFromCustomerId",
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
        function clearQuotationModalPopup() {
            $('#<%=spHeaderQuotationId.ClientID%>').text('');
            $('#<%=spBodyQuotationId.ClientID%>').text('');

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
            $('#dvAllOfMyQuotations tbody').empty();

            $('#<%=lblVAT.ClientID%>').text('');
            $('#<%=lblOrderTotal.ClientID%>').text('');

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
                <h2>View My Quotations
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <form id="frmViewMyQuotations" runat="server">
                <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center; padding: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            
                            <asp:HiddenField ID="hfEmailID" runat="server" />
                            <asp:HiddenField ID="hfWhetherOtherExists" runat="server" />
                        </div>

                        <div class="panel-body clrBLK col-md-12">
                            <div class="row">
                                <div class="form-group">
                                    
                                    <div class="col-md-9 col-md-offset-2" align="center">
                                        <div style="width:333px;">
                                            <span class="iconADD pull-right">
                                                <asp:Button ID="btnExportViewAllQuotationsExcel" runat="server"  
                                                Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                                <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                            </span>

                                            <span class="iconADD pull-right">
                                                <asp:Button ID="btnExportViewAllQuotationsPDF" runat="server"  
                                                    Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                                <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                            </span>                                        
                                        </div>
                                    </div>
                                    <br /><br />
                                    <div>
                                        <table id="dtViewQuotations" style="margin-left: 10px; width: 795px;">
                                            <thead>
                                                <tr>
                                                    <th>Quotation Id</th>
                                                    <th>Customer Name</th>
                                                    <th>Quotation Date</th>
                                                    <th>Total Value</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <br />

                    <div class="modal fade" id="dvQuotation" role="dialog">
                    <div class="modal-dialog modal-lg">
    
                        <!-- Modal content-->
                        <div class="modal-content qtngDtailsPOP">
                        <div class="modal-header" style="background-color:#f0ad4ecf;">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title pm-modal">
                                <i class="fa fa-info-circle" aria-hidden="true"></i> Quotation Information: 
                                <span id="spHeaderQuotingId" runat="server"></span>
                            </h4>
                        </div>
                        <div class="modal-body" style="text-align: center;font-size: 22px; overflow-x: auto;">
                            <p><strong>Please find the details of Quotation 
                                <span id="spBodyQuotingId" runat="server"></span> below:</strong></p>
                            <p class="undrLN"><strong>Customer Account Details:</strong></p>
                            <div class="row">
                                <div class="col-md-12">
                                    <table id="dvMyQuotations" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th>Quotation Id</th>
                                                <th>Customer Name</th>
                                                <th>Pickup Category</th>
                                                <th>Pickup Item</th>
                                                <th>Is Fragile</th>
                                                <th>Estimated Value</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="pull-right" style="padding-top: 10px; padding-right: 15px;display: none;">
                                    <asp:Button ID="btnConvertToBooking" runat="server" 
                                        CssClass="btn btn-info"
                                        Text="Convert To Booking" 
                                        />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                        </div>
                        </div>
      
                    </div>
                    </div>

                    <div class="modal fade" id="dvQuotationDetails" role="dialog">
                        <div class="modal-dialog modal-lg">
    
                            <!-- Modal content-->
                            <div class="modal-content bkngDtailsPOP viewBKNG">
                            <div class="modal-header" style="background-color:#f0ad4ecf;">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title pm-modal">
                                    <i class="fa fa-info-circle" aria-hidden="true"></i> Quotation Information: 
                                    <span id="spHeaderQuotationId" runat="server"></span>
                                </h4>
                            </div>
                            <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; overflow-x: auto;">
                                <p><strong>Please find the details of order 
                                    <span id="spBodyQuotationId" runat="server"></span> below:</strong></p>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="twoSETbtn">
                                    <button id="btnPrintQuotationModal" data-dismiss="modal" title="Print Quotation Details"
                                        onclick="return printDetails('dvQuotationDetails');" style="margin-bottom:10px;">
                                        <i class="fa fa-print" aria-hidden="true"></i></button>
                                    <button id="btnPrintPdfQuotationModal" data-dismiss="modal" title="Download as PDF"
                                        onclick="exportToPDF('dvQuotationDetails', 'QuotationDetails.pdf');" style="margin-bottom:10px;">
                                        <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                    <button id="btnPrintExcelQuotationModal" data-dismiss="modal" title="Download as Excel"
                                        onclick="exportToExcel('dvAllOfMyQuotations', 'CustomerDetails.xls');" style="margin-bottom:10px;">
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
                                    
                                <div class="col-md-12">
                                    <div class="row">
                                        <div class="dvCNFRM">
                                        <h2 class="">Confirm your Collection and Delivery Details</h2>
                                        <div class="confirm-box">
                                            <div class="confirm-details">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <h4>Pickup Address</h4>
                                                        <p class="clnName"><strong>
                                                            <asp:Label ID="lblPickupName" runat="server" Text=""></asp:Label>
                                                        </strong></p>

                                                        <p class="adrs-sec">
                                                            <span class="icnHGT"><i class="fa fa-map-marker" aria-hidden="true"></i></span>
                                                            <asp:Label ID="lblPickupAddress" runat="server" Text=""></asp:Label>
                                                        </p>

                                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                                            <asp:Label ID="lblPickupMobile" runat="server" Text=""></asp:Label>
                                                        </p>
                                                    </div>

                                                    <div class="col-md-6 rgtALNG">
                                                        <h4>Delivery Address</h4>
                                                        <p class="clnName"><strong>
                                                            <asp:Label ID="lblDeliveryName" runat="server" Text=""></asp:Label>
                                                        </strong></p>

                                                        <p class="adrs-sec">
                                                            <span class="icnHGT"><i class="fa fa-map-marker" aria-hidden="true"></i></span>
                                                            <asp:Label ID="lblDeliveryAddress" runat="server" Text=""></asp:Label>
                                                        </p>

                                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                                            <asp:Label ID="lblDeliveryMobile" runat="server" Text=""></asp:Label>
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
                                        <h2 class="">Confirm your Item details</h2>
                                        <div class="confirm-box">
                                            <div class="confirm-details">
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <p class="mntnTYM">
                                                            <strong>Pickup Date and Time:
                                                            <asp:Label ID="lblPickupDateTime" runat="server" 
                                                                Text=""></asp:Label>
                                                            </strong>
                                                        </p>
                                
                                                        <p class="undrLN"><strong>Pickup:</strong></p><br />
                                                        <!-- jQuery DataTable -->
                                                        <table id="dvAllOfMyQuotations" style="width: 100%;">
                                                            <thead>
                                                                <tr>
                                                                    <th>Item</th>
                                                                    <th>IsFragile</th>
                                                                    <th>Cost</th>
                                                                    <th>Estimated Value</th>
                                                                    <th>Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            </tbody>
                                                        </table>
                                   
                                                        <ul class="vatTotal">
                                                            <li>
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
                                                            </li>
                                                        </ul>
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
                                                onclick="return printDetails('tblCustomerDetails1');" style="margin-bottom:10px;"><i class="fa fa-print" aria-hidden="true"></i></button>
                                            <button id="btnPrintPdfCustomerModal1" data-dismiss="modal" title="Download as PDF"
                                                onclick="exportToPDF('dvCustomerDetailsModal', 'CustomerDetails.pdf');" style="margin-bottom:10px;"><i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                            <button id="btnPrintExcelCustomerModal1" data-dismiss="modal" title="Download as Excel"
                                                onclick="exportToExcel('tblCustomerDetails1', 'CustomerDetails.xls');" style="margin-bottom:10px;"><i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
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
                                                            <table class="table custoFULLdet" id="tblCustomerDetails1">
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

                    <div class="modal fade" id="Success-bx" role="dialog">
                        <div class="modal-dialog">
    
                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color:#f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title" style="font-size:24px;color:#111;">Conversion Successful</h4>
                                </div>
                                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                                    <p>Quotation converted to Booking successfully</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="location.reload();">OK</button>
                                </div>
                            </div>
                        </div>
                    </div>

                                </div>
                                <br />
                            </div>
                        </div>
                </div>
                </form>
            </div>
        </div>
    </div>

</asp:Content>

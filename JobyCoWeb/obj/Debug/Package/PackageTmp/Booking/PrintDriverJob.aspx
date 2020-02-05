<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="PrintDriverJob.aspx.cs" Inherits="JobyCoWeb.Booking.PrintDriverJob"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
<link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
<script src="/Scripts/jquery.dataTables.min.js"></script>
<script src="/js/jspdf.min.js"></script>

<style>
.DriverName, .BookingId {

}
.print, .reassign {
    background: none;
    margin-right: 0;
    width: 19px;
    height: 19px;
    border: 1px solid #fca311;
    color: #fca311;
    float: left;
    font-size: 10px !important;
}

.print:hover, .reassign:hover {
    background: #fca311;
    color:#fff;
    text-shadow:1px 1px 1px rgba(0,0,0,0.4);
}
</style>
<style type="text/css">
          @media print  
            {
                #PrintContentDiv{
                    page-break-before: always;
                    page-break-inside: avoid;
                    page-break-after: always;
                }
            }
    #PrintContentDiv {
        background-color:aquamarine;
    }
          </style> 
<!-- New Script Added for Dynamic Menu Population
================================================== -->    
<script>
    $(document).ready(function () {
        var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
        accessibleMenuItems(hfMenusAccessibleValues);

        var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
        accessiblePageControls(hfControlsAccessible);
    });
</script>

<script>
    $( document ).ready( function ()
    {
        var DriverId = '';
        DriverId = getUrlVars();
        if (DriverId == null)
        {
            getAllAssignedBookings('');
        }
        else
        {
            getAllAssignedBookings(DriverId);
        }
        

        $( '#<%=txtFromDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

        $( '#<%=txtToDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

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

    });
</script>



<script>

    function checkFewControls()
    {
        var FromDate = $( "#<%=txtFromDate.ClientID%>" );
        var vFromDate = FromDate.val().trim();

        var ToDate = $( "#<%=txtToDate.ClientID%>" );
        var vToDate = ToDate.val().trim();

        var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css("text-align", "center");

        if ( vFromDate == "" )
        {
            vErrMsg.text( 'Please enter From Date' );
            vErrMsg.css( "display", "block" );
            FromDate.focus();
            return false;
        }

        if ( vToDate == "" )
        {
            vErrMsg.text( 'Please enter To Date' );
            vErrMsg.css( "display", "block" );
            ToDate.focus();
            return false;
        }

        return true;
    }

    function clearErrorMessage() {
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
    }

    function clearAllControls()
    {
        var FromDate = $( "#<%=txtFromDate.ClientID%>" );
        var ToDate = $( "#<%=txtToDate.ClientID%>" );

        var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css( "text-align", "center" );

        FromDate.val( '' );
        ToDate.val( '' );

        return false;
    }
</script>

<script>
    function getDriverDetails(DriverName)
    {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AssignBookingToDriver.aspx/GetDriverId",
            data: "{ DriverName: '" + DriverName + "'}",
            dataType: "json",
            success: function (result) {
                $( "#<%=hfDriverId.ClientID%>" ).val( result.d );

                var hfDriverId = $( "#<%=hfDriverId.ClientID%>" ).val().trim();

                $.ajax( {
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "AssignBookingToDriver.aspx/GetDriverType",
                    data: "{ DriverId: '" + hfDriverId + "'}",
                    success: function ( result )
                    {
                        $( "#<%=hfDriverType.ClientID%>" ).val( result.d );

                        $.ajax( {
                            method: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "AssignBookingToDriver.aspx/GetWageType",
                            data: "{ DriverId: '" + hfDriverId + "'}",
                            success: function ( result )
                            {
                                $( "#<%=hfWageType.ClientID%>" ).val( result.d );

                                var DriverType = $( '#<%=hfDriverType.ClientID%>' ).val().trim();
                                var WageType = $( '#<%=hfWageType.ClientID%>' ).val().trim();

                                $.ajax( {
                                    method: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    url: "AssignBookingToDriver.aspx/GetDriverWage",
                                    data: "{ DriverType: '" + DriverType + "', WageType: '" + WageType + "'}",
                                    success: function ( result )
                                    {
                                        $( "#<%=hfDriverWage.ClientID%>" ).val( result.d );
                                    },
                                    error: function ( response )
                                    {
                                        alert( 'Unable to get Driver Wage' );
                                    }
                                } );
                            },
                            error: function ( response )
                            {
                                alert( 'Unable to get Wage Type' );
                            }
                        } );
                    },
                    error: function ( response )
                    {
                        alert( 'Unable to get Driver Type' );
                    }
                } );
            },
            error: function ( response )
            {
                alert( 'Unable to get Driver Id' );
            }
        });
    }

    function checkFromAndToDate( vFromDate, vToDate )
    {
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
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

            var stDate = new Date( yr1, mon1, dt1 );
            var enDate = new Date( yr2, mon2, dt2 );
            var diff_date = enDate - stDate;

            var years = Math.floor( diff_date / 31536000000 );
            var months = Math.floor(( diff_date % 31536000000 ) / 2628000000 );
            var days = Math.floor(( ( diff_date % 31536000000 ) % 2628000000 ) / 86400000 );

            //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

            if ( years < 0 )
            {
                vErrMsg.text( 'Assign Date should be earlier than Current Date' );
                vErrMsg.css( "display", "block" );
                return false;
            }
            else
            {
                if ( months < 0 )
                {
                    vErrMsg.text( 'Assign Date should be earlier than Current Date' );
                    vErrMsg.css( "display", "block" );
                    return false;
                }
                else
                {
                    if ( days < 0 )
                    {
                        vErrMsg.text( 'Assign Date should be earlier than Current Date' );
                        vErrMsg.css( "display", "block" );
                        return false;
                    }
                }
            }
        }
    }

    function checkAssignDate(vAssignDate)
    {
        //Date Checking Added on Text Change
        var vCurrentDate = getCurrentDateDetails();
        checkFromAndToDate( vAssignDate, vCurrentDate );
    }

</script>

<script>
    function getAllAssignedBookings(DriverId)
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetAllAssignedBookings",
            data: "{ DriverId: '" + DriverId + "'}",
            beforeSend: function () {
                //$("#loadingDiv").show();
                $("#loadingDiv").css('display', 'flex');
            },
            complete: function () {
                setTimeout(function () {
                    $('#loadingDiv').fadeOut();
                }, 700);
            },
            success: function ( result )
            {
                var jsonAssignedBookings = JSON.parse( result.d );
                $( '#dtPrintDriverJob' ).DataTable( {
                    data: jsonAssignedBookings,
                    columns: [
                        { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
                        {
                            data: "DriverName",
                            render: function ( data )
                            {
                                return '<a class="DriverName">' + data + '</a>';
                            }
                        },
                        {
                            data: "BookingId",
                            render: function ( data )
                            {
                                return '<a class="BookingId">' + data + '</a>';
                            }
                        },
                        {
                            data: "FromDate",
                            render: function ( jsonFromDate )
                            {
                                return getFormattedDateUK( jsonFromDate );
                            }
                        },
                        {
                            data: "ToDate",
                            render: function ( jsonToDate )
                            {
                                return getFormattedDateUK( jsonToDate );
                            }
                        },
                        { data: "Address" },
                        { data: "PostCode" },
                        { data: "Mobile" },
                        {
                            data: "Wage",
                            render: function ( Wage )
                            {
                                return roundOffDecimalValue( Wage );
                            }
                        },
                        { defaultContent: "<button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button> <button data-toggle='modal' data-target='#Assign-bx' class='reassign' title='Re-assign or Un-assign'><i class='fa fa-arrow-right' aria-hidden='true'></i></button>" }
                    ],
                    "bDestroy": true,
                    "paging": false
                } );
            },
            error: function ( response )
            {
                alert( 'Unable to Bind All Driver Jobs' );
            }
        } );//end of ajax

        
        $('#dtPrintDriverJob tbody').on('click', '.reassign', function () {
            var vClosestTr = $(this).closest("tr");
            var DriverName = vClosestTr.find('td').eq(1).text();
            var BookingId = vClosestTr.find('td').eq(2).text();
            $('#<%=hfBookingId.ClientID%>').val(BookingId);
            // alert(BookingId);
            $('#Assign-bx').modal('show');

            return false;
        });

        $( '#dtPrintDriverJob tbody' ).on( 'click', '.DriverName', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );
            var DriverName = vClosestTr.find('td').eq(1).text();

            clearDriverModalPopup();

            $('#spDriverFullName').text(DriverName);
            $( '#spHeaderDriverName' ).text( DriverName );

            getDriverIdFromDriverName( DriverName );
            $( '#dvDriverOwnDetails' ).modal( 'show' );

            return false;
        } );

        $( '#dtPrintDriverJob tbody' ).on( 'click', '.BookingId', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );
            var vBookingId = vClosestTr.find( 'td' ).eq( 2 ).text();

            clearBookingModalPopup();

            $('#<%=spHeaderBookingId.ClientID%>').text('#' + vBookingId);
            $( '#<%=spBodyBookingId.ClientID%>' ).text( '#' + vBookingId );

            //First Tabular Details
            //===========================================================================
            getCustomerIdFromBookingId( vBookingId );

          $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "PrintDriverJob.aspx/GetCustomerNameByBooking",
                data: "{ BookingId: '" + vBookingId + "' }",
                async: false,
                success: function (result) {
                    var vCustomerName = result.d;
                    $( '#<%=lblCustomerName.ClientID%>' ).text( vCustomerName );
                },
                error: function (response) {
                    alert('Unable to Cancel Booking');
                }
            });

            
            //============================================================================

            //Second Tabular Details
            //===========================================================================
            //getPickupNameFromBookingId( vBookingId );
            getPickupDeliveryFromBookingId(vBookingId);
            //============================================================================

            viewBookingDetails( vBookingId );
            viewPaymentDetails( vBookingId );
            $( '#dvBooking' ).modal( 'show' );
            $("#loadingDiv").show();
            $("#loadingDiv").css("z-index", "9999");
            setTimeout(function () {
                $('#loadingDiv').fadeOut();
            }, 1200);
            return false;
        } );

        $( '#dtPrintDriverJob tbody' ).on( 'click', '.print', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            var DriverName = vClosestTr.find( 'td' ).eq( 1 ).text();
            $( '#spDriverName' ).text( DriverName );

            var BookingId = vClosestTr.find( 'td' ).eq( 2 ).text();
            $( '#spBookingId' ).text( BookingId );

            var FromDate = vClosestTr.find( 'td' ).eq( 3 ).text();
            $( '#spFromDate' ).text( FromDate );

            var ToDate = vClosestTr.find( 'td' ).eq( 4 ).text();
            $( '#spToDate' ).text( ToDate );

            var Address = vClosestTr.find( 'td' ).eq( 5 ).text();
            $( '#spAddress' ).text( Address );

            var PostCode = vClosestTr.find( 'td' ).eq( 6 ).text();
            $( '#spPostCode' ).text( PostCode );

            var Mobile = vClosestTr.find( 'td' ).eq( 7 ).text();
            $( '#spMobile' ).text( Mobile );

            var Wage = vClosestTr.find( 'td' ).eq( 8 ).text();
            $( '#spWage' ).text( Wage );

            //return printDetails('tblDriverDetails');
            return printDriverJobDetails(BookingId, DriverName, Wage);
            //$( '#dvDriverModalDetails' ).modal( 'show' );
            //return false;
        } );

        return false;
    }

        function getPickupDeliveryFromBookingId(BookingId)
        {
             $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                //url: "ViewAllOfMyBookings.aspx/GetPickupNameFromBookingId",
                url: "ViewAllBookings.aspx/GetPickupDeliveryFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                 async: false,
                success: function ( result )
                {
                    var jData = JSON.parse(result.d);
                    $('#<%=lblPickupName.ClientID%>').text(jData[0]['PickupName']);
                    $('#<%=lblPickupAddress.ClientID%>').text(jData[0]['PickupAddress']);
                    $('#<%=lblPickupMobile.ClientID%>').text(jData[0]['PickupMobile']);
                    $('#<%=lblDeliveryName.ClientID%>').text(jData[0]['DeliveryName']);
                    $('#<%=lblDeliveryAddress.ClientID%>').text(jData[0]['RecipientAddress']);
                    $('#<%=lblDeliveryMobile.ClientID%>').text(jData[0]['DeliveryMobile']);

                    $('#<%=lblCustomerId.ClientID%>').text(jData[0]['CustomerId']);
                    $('#<%=lblCustomerMobile.ClientID%>').text(jData[0]['CustomerMobile']);
                    $('#StatusDetails').text(jData[0]['StatusDetails']);

                    getPickupDateAndTimeFromBookingId(BookingId);
                    //getPickupAddressFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Name from Booking Id' );
                }
            } );
        }

    function showDriverJobs()
    {
        if ( checkFewControls() )
        {
            var FromDate = $( "#<%=txtFromDate.ClientID%>" ).val().trim();
            var ToDate = $( "#<%=txtToDate.ClientID%>" ).val().trim();
            //alert('FromDate = ' + FromDate + ' ' + 'ToDate = ' + ToDate);
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "PrintDriverJob.aspx/GetAllAssignedDriverJobs",
                data: "{ FromDate: '" + FromDate + "', ToDate: '" + ToDate + "'}",
                success: function ( result )
                {
                    var jsonDriverJobs = JSON.parse( result.d );
                    $( '#dtPrintDriverJob' ).DataTable( {
                        data: jsonDriverJobs,
                        columns: [
                        { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
                        {
                            data: "DriverName",
                            render: function (data) {
                                return '<a class="DriverName">' + data + '</a>';
                            }
                        },
                        {
                            data: "BookingId",
                            render: function (data) {
                                return '<a class="BookingId">' + data + '</a>';
                            }
                        },
                        {
                            data: "FromDate",
                            render: function ( jsonFromDate )
                            {
                                return getFormattedDateUK( jsonFromDate );
                            }
                        },
                        {
                            data: "ToDate",
                            render: function ( jsonToDate )
                            {
                                return getFormattedDateUK( jsonToDate );
                            }
                        },
                        { data: "Address" },
                        { data: "PostCode" },
                        { data: "Mobile" },
                        { data: "Wage" },
                        { defaultContent: "<button class='print'><i class='fa fa-print' aria-hidden='true'></i></button> <button data-toggle='modal' data-target='#Assign-bx' class='reassign' title='Re-assign or Un-assign'><i class='fa fa-arrow-right' aria-hidden='true'></i></button>" }
                        ],
                        "bDestroy": true
                    } );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Specific Driver Jobs' );
                }
            } );//end of ajax
        }

        return false;
    }

</script>

<script>
    function gotoEditBookingPage() {
        var vBookingId = $('#<%=spBodyBookingId.ClientID%>').text().trim();
        vBookingId = vBookingId.substr(1, vBookingId.length);

        location.href = '/Booking/EditBooking.aspx?BookingId=' + vBookingId;
        return false;
    }

    function showCancelModal()
    {
        $( '#CancelBooking-bx' ).modal( 'show' );
        return false;
    }

    function cancelBooking()
    {
        var BookingId = $( '#<%=spHeaderBookingId.ClientID%>' ).text().trim().replace('#', '');
        var OrderStatus = $('#<%=hfOrderStatus.ClientID%>').val().trim();

        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/CancelBooking",
            data: "{ BookingId: '" + BookingId + "', OrderStatus: '" + OrderStatus + "' }",
            success: function ( result )
            {
                location.reload();
            },
            error: function ( response )
            {
                alert( 'Unable to Cancel Booking' );
            }
        } );
    }

    function gotoAssignBookingToDriver()
    {
        location.href = '/Booking/AssignBookingToDriver.aspx';
        return false;
    }

    function SelectedUnassignBookingToDriver()
    {
        
        var sMessage = "";
        $('#dtPrintDriverJob tbody tr').each(function (i, row) {
            debugger;
            var $actualrow = $(row);
            $checkbox = $actualrow.find(':checkbox');
            var BookingId = $(this).find('td:eq(2)').text().trim();
            
            if ($checkbox.is(':checked')) {

                var objAssignBookingToDriver = {};
                objAssignBookingToDriver.BookingId = BookingId;

                $.ajax({
                        method: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "PrintDriverJob.aspx/UnAssignBookingToDriver",
                        data: JSON.stringify(objAssignBookingToDriver),
                        async:false,
                        success: function (result) {
                            //alert(result.d);
                            sMessage = result.d;
                            

                        },
                        error: function (response) {
                            alert('Unable to Add Assign Booking To Driver Details');
                        }
                    });
                    
            }
        });
        if (sMessage == "Success") {
            $('#USuccess-bx').modal('show');
        }
        else {
            $('#Failure-bx').modal('show');
        }
        return false;
    }

    function takePrintout()
    {
        $( '#PrintDataTable-bx' ).modal( 'show' );
        return false;
    }
</script>

<script>
        function getPickupNameFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetPickupNameFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupName.ClientID%>' ).text( result.d );
                    $( '#spPickupName' ).text( result.d );

                    getPickupAddressFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Name from Booking Id' );
                }
            } );

            return false;
        }

        function getPickupAddressFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetPickupAddressFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupAddress.ClientID%>' ).text( result.d );
                    $( '#spPickupAddress' ).text( result.d );

                    getPickupMobileFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Address from Booking Id' );
                }
            } );

            return false;
        }

        function getPickupMobileFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetPickupMobileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblPickupMobile.ClientID%>' ).text( result.d );
                    $( '#spPickupMobile' ).text( result.d );

                    getDeliveryNameFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Pickup Mobile from Booking Id' );
                }
            } );

            return false;
        }

        function getDeliveryNameFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetDeliveryNameFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryName.ClientID%>' ).text( result.d );
                    $( '#spDeliveryName' ).text( result.d );

                    getDeliveryAddressFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Name from Booking Id' );
                }
            } );

            return false;
        }

        function getDeliveryAddressFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetDeliveryAddressFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryAddress.ClientID%>' ).text( result.d );
                    $( '#spRecipentAddress' ).text( result.d );

                    getDeliveryMobileFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Address from Booking Id' );
                }
            } );

            return false;
        }

        function getDeliveryMobileFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetDeliveryMobileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblDeliveryMobile.ClientID%>' ).text( result.d );
                    $( '#spDeliveryMobile' ).text( result.d );

                    getPickupDateAndTimeFromBookingId( BookingId );
                },
                error: function (response) {
                    alert( 'Unable to get Delivery Mobile from Booking Id' );
                }
            } );

            return false;
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

        function getPickupDateAndTimeFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetPickupDateAndTimeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                async:false,
                success: function ( result )
                {
                    $( '#<%=lblPickupDateTime.ClientID%>' ).text( result.d );

                    //Get LongDateTime
                    <%--var vPickupDateTime = $( '#<%=lblPickupDateTime.ClientID%>' ).text().trim();
                    var vLongDateTime = getLongDateTime( vPickupDateTime );

                    $( '#<%=lblPickupDateTime.ClientID%>' ).text( vLongDateTime );
                    $( '#spPickupDateTime' ).text( result.d );--%>

                    getVATfromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup Date and Time from Booking Id' );
                }
            } );

            return false;
        }

        function getVATfromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetVATfromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblVAT.ClientID%>' ).text( result.d );
                    $( '#spVAT' ).text( result.d );

                    getOrderTotalFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get VAT from Booking Id' );
                }
            } );

            return false;
        }

        function getOrderTotalFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetOrderTotalFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=lblOrderTotal.ClientID%>' ).text( result.d );
                    $( '#spTotalValue' ).text( result.d );

                    getOrderStatusFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Order Total from Booking Id' );
                }
            } );

            return false;
        }

        function getOrderStatusFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetOrderStatusFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#<%=hfOrderStatus.ClientID%>' ).val( result.d );

                    var vOrderStatus = $( '#<%=hfOrderStatus.ClientID%>' ).val().trim();
                    $( '#spOrderStatus' ).text( vOrderStatus );

                    switch ( vOrderStatus )
                    {
                    case "Cancelled":
                        $( '#btnEditBooking' ).css( 'display', 'none' );
                        $( '#btnCancelBooking' ).css( 'display', 'none' );

                        $( '#<%=pPaymentDetails.ClientID%>' ).css( 'display', 'none' );
                        $( '#dvMyPaymentDetails' ).css( 'display', 'none' );
                        break;

                    case "Unpaid":
                        $('#btnEditBooking').css('display', 'block');
                        $('#btnCancelBooking').css('display', 'block');

                        $('#<%=pPaymentDetails.ClientID%>').css('display', 'none');
                        $( '#dvMyPaymentDetails' ).css( 'display', 'none' );
                        break;

                    case "Paid":
                        $('#btnEditBooking').css('display', 'block');
                        $( '#btnCancelBooking' ).css( 'display', 'block' );

                        $( '#<%=pPaymentDetails.ClientID%>' ).css( 'display', 'block' );
                        $( '#dvMyPaymentDetails' ).css( 'display', 'block' );
                        break;
                    }
                },
                error: function ( response )
                {
                    alert( 'Unable to get Order Status from Booking Id' );
                }
            } );

            return false;
        }

        function getIsFragileFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetIsFragileFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spIsFragile' ).text( result.d );

                    getItemCountFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Is Fragile from Booking Id' );
                }
            } );

            return false;
        }

        function getItemCountFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetItemCountFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spItemCount' ).text( result.d );

                    getBookingNotesFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Item Count from Booking Id' );
                }
            } );

            return false;
        }

        function getBookingNotesFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetBookingNotesFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spBookingNotes' ).text( result.d );

                    getInsurancePremiumFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Booking Notes from Booking Id' );
                }
            } );

            return false;
        }

        function getInsurancePremiumFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetInsurancePremiumFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spInsurancePremium' ).text( result.d );

                    getPickupPostCodeFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Insurance Premium from Booking Id' );
                }
            } );

            return false;
        }

        function getPickupPostCodeFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetPickupPostCodeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spPickupPostCode' ).text( result.d );

                    getDeliveryPostCodeFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup PostCode from Booking Id' );
                }
            } );

            return false;
        }

        function getDeliveryPostCodeFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetDeliveryPostCodeFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spDeliveryPostCode' ).text( result.d );

                    getBookingDateFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Delivery PostCode from Booking Id' );
                }
            } );

            return false;
        }

        function getBookingDateFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetBookingDateFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spBookingDate' ).text( result.d );

                    getPickupEmailFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Booking Date from Booking Id' );
                }
            } );

            return false;
        }

        function getPickupEmailFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetPickupEmailFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spPickupEmail' ).text( result.d );

                    getDeliveryEmailFromBookingId( BookingId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Pickup Email from Booking Id' );
                }
            } );

            return false;
        }

        function getDeliveryEmailFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetDeliveryEmailFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
                success: function ( result )
                {
                    $( '#spDeliveryEmail' ).text( result.d );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Delivery Email from Booking Id' );
                }
            } );

            return false;
        }

        function viewBookingDetails( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/ViewBookingDetails",
                data: "{ BookingId: '" + BookingId + "'}",
                async:false,
                success: function ( result )
                {
                    var jsonBookingDetails = JSON.parse( result.d );
                    $( '#dvAllBookings' ).DataTable( {
                        data: jsonBookingDetails,
                        columns: [
                            { data: "Item" },
                            {
                                data: "Cost",
                                render: function ( Cost )
                                {
                                    return roundOffDecimalValue( Cost );
                                }
                            },
                            {
                                data: "EstimatedValue",
                                render: function ( EstimatedValue )
                                {
                                    return roundOffDecimalValue( EstimatedValue );
                                }
                            },
                            { data: "Status" }
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
            } );//end of ajax
        }

        function viewPaymentDetails( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/ViewPaymentDetails",
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
                            {
                                data: 'PaymentAmount',
                                render: function ( PaymentAmount )
                                {
                                    return roundOffDecimalValue( PaymentAmount );
                                }
                            },
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

        //=============Customer Details=================
        function getCustomerIdFromBookingId( BookingId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllBookings.aspx/GetCustomerIdFromBookingId",
                data: "{ BookingId: '" + BookingId + "'}",
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
                url: "ViewAllBookings.aspx/GetCustomerMobileFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    $( '#<%=lblCustomerMobile.ClientID%>' ).text( result.d );
                },
                error: function (response) {
                    alert( 'Unable to get Customer Mobile from Customer Id' );
                }
            } );
        }

</script>

<script>
    function getDriverIdFromDriverName( DriverName )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverIdFromDriverName",
            data: "{ DriverName: '" + DriverName + "'}",
            success: function ( result )
            {
                $( '#<%=hfDriverId.ClientID%>' ).val( result.d );

                var DriverId = $( '#<%=hfDriverId.ClientID%>' ).val();
                getDriverEmailIdFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Id from Driver Name' );
            }
        } );

        return false;
    }

    function getDriverEmailIdFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverEmailIdFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverEmailID' ).text( result.d );
                getDriverDOBFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver EmailId from DriverId' );
            }
        } );

        return false;
    }

    function getDriverDOBFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverDOBFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverDOB' ).text( result.d );
                getDriverAddressFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Date Of Birth from DriverId' );
            }
        } );

        return false;
    }

    function getDriverAddressFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverAddressFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverAddress' ).text( result.d );
                getDriverPostCodeFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Address from DriverId' );
            }
        } );

        return false;
    }
    
    function getDriverPostCodeFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverPostCodeFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverPostCode' ).text( result.d );
                getDriverMobileFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver PostCode from DriverId' );
            }
        } );

        return false;
    }

    function getDriverMobileFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverMobileFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverMobile' ).text( result.d );
                getDriverLandlineFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Mobile from DriverId' );
            }
        } );

        return false;
    }

    function getDriverLandlineFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverLandlineFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverLandline' ).text( result.d );
                getDriverTypeFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Landline from DriverId' );
            }
        } );

        return false;
    }

    function getDriverTypeFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverTypeFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverType' ).text( result.d );
                getDriverWageTypeFromDriverId( DriverId );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Type from DriverId' );
            }
        } );

        return false;
    }

    function getDriverWageTypeFromDriverId( DriverId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/GetDriverWageTypeFromDriverId",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                $( '#spDriverWageType' ).text( result.d );
            },
            error: function ( response )
            {
                alert( 'Unable to Get Driver Wage Type from DriverId' );
            }
        } );

        return false;
    }

</script>

<script>
    function printDetails(vTableId)
    {
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



    function printDriverJobDetails(vTableId, rowDriverName, Wage) {
        debugger;
        if (vTableId != 'dtPrintDriverJob') {
            var PrintContent = "";
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "PrintDriverJob.aspx/GetPickupDetailsForPrint",
                async: false,
                data: "{ BookingId: '" + vTableId + "' }",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    var len = jdata.length;
                    PrintContent += '<br>'
                    PrintContent += '<div id="PrintContentDiv">';
                    PrintContent += '<table border="0"  cellpadding="0" cellspacing="0" id="PrintContentTbl" style="width:100%;page-break-inside: avoid; font-size:16px;">';
                    
                    PrintContent += '<tr>';
                    PrintContent += '<th colspan="2" style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:20px;">' + rowDriverName + '</th>';
                    PrintContent += '<th colspan="2" style="text-align:right; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:20px;">' + jdata[0]["PickupDate"] + '</th>';
                    PrintContent += '</tr>';

                    PrintContent += '<tr>';
                    PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:10%;"><b>SL No.</b><br>1</td>';

                    PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:20%;"><b>Booking Ref.</b>';
                    PrintContent += '<br>' + jdata[0]["BookingId"];
                    PrintContent += '<br><br><b>Total:</b>';
                    PrintContent += '<br>' + Wage;
                    PrintContent += '</td>';
                    PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:35%;">';
                    //Pickup Details
                    PrintContent += '<b>' + jdata[0]["PickupName"] + '</b>';
                    PrintContent += '<br>' + jdata[0]["PickupPhone"];
                    PrintContent += '<br><br><b style="text-decoration: underline;">Pickup Details</b>';
                    PrintContent += '<br>' + jdata[0]["PickupAddress"];
                    PrintContent += '<br>' + jdata[0]["PickupZip"];
                    PrintContent += '<br><br><span style="display: block; border-bottom: 1px dashed #444; height: 1px;"></span><br>';
                    //Delivery Details
                    PrintContent += '<b>' + jdata[0]["DeliveryName"] + '</b>';
                    PrintContent += '<br>' + jdata[0]["DeliveryPhone"];
                    PrintContent += '<br><br><b style="text-decoration: underline;">Delivery Details</b>';
                    PrintContent += '<br>' + jdata[0]["DeliveryAddress"];
                    PrintContent += '<br>' + jdata[0]["DeliveryZip"];

                    PrintContent += '</td>';


                    PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:35%;"><table border="1" style="width:100%"><tr><td><b>Pickup Items</b></td></tr>';
                    for (var i = 0; i < len; i++) {
                        PrintContent += '<tr><td>' + jdata[i]["PickupItem"] + '</td></tr>';
                    }
                    PrintContent += '</table></td>';
                    PrintContent += '</tr>';
                },
                error: function (response) {
                    alert('Unable to Pickup Details For Print');
                }
            });

            PrintContent += '</table>';
            PrintContent += '</div">';

            var MainWindow = window.open('', '', 'height=800,width=1000');
            MainWindow.document.write('<html><head><title></title>');
            MainWindow.document.write('</head><body onload="window.print();window.close()">');
            MainWindow.document.write(PrintContent);
            MainWindow.document.write('</body></html>');
            MainWindow.document.close();
            setTimeout(function () {
                MainWindow.print();
            }, 500)

        }
        else
        {
            var Count = 0;
            var PrintContent = "";
            var checkDriver = "";
            var NewDriverFlag = 0;

            $('#' + vTableId + ' tbody tr').each(function (i, row) {
                var DriverName = $(this).find('td:eq(1)').text().trim();
                var BookingId = $(this).find('td:eq(2)').text().trim();
                var Cost = $(this).find('td:eq(8)').text().trim();
                //alert('BookingId = '+BookingId);
                //Get pickup Details
                Count++;

                if (checkDriver != DriverName) {
                    checkDriver = DriverName;
                    NewDriverFlag = 1;
                    Count = 1;
                }
                else {
                    NewDriverFlag = 0;
                }

                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PrintDriverJob.aspx/GetPickupDetailsForPrint",
                    async: false,
                    data: "{ BookingId: '" + BookingId + "' }",
                    success: function (result) {
                        var jdata = JSON.parse(result.d);
                        //alert(JSON.stringify(jdata));
                        var len = jdata.length;
                        PrintContent += '<br>'
                        PrintContent += '<div id="PrintContentDiv">';
                        PrintContent += '<table border="0" cellpadding="0" cellspacing="0" id="PrintContentTbl" style="width:100%;page-break-inside: avoid; font-size:16px;">';
                        if (NewDriverFlag > 0) {
                            PrintContent += '<tr>';
                            PrintContent += '<th colspan="2" style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:20px;">' + DriverName + '</th>';
                            PrintContent += '<th colspan="2" style="text-align:right; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:20px;">' + jdata[0]["PickupDate"] + '</th>';
                            PrintContent += '</tr>';
                        }

                        PrintContent += '<tr>';
                        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:10%;"><b>SL No.</b><br>' + Count + '</td>';

                        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:20%;"><b>Booking Ref.</b>';
                        PrintContent += '<br>' + jdata[0]["BookingId"];
                        PrintContent += '<br><br><b>Total:</b>';
                        PrintContent += '<br>' + Cost;
                        PrintContent += '</td>';
                        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:35%;">';
                        //Pickup Details
                        PrintContent += '<b>' + jdata[0]["PickupName"] + '</b>';
                        PrintContent += '<br>' + jdata[0]["PickupPhone"];
                        PrintContent += '<br><br><b style="text-decoration: underline;">Pickup Details</b>';
                        PrintContent += '<br>' + jdata[0]["PickupAddress"];
                        PrintContent += '<br>' + jdata[0]["PickupZip"];
                        PrintContent += '<br><br><span style="display: block; border-bottom: 1px dashed #444; height: 1px;"></span><br>';
                        //Delivery Details
                        PrintContent += '<b>' + jdata[0]["DeliveryName"] + '</b>';
                        PrintContent += '<br>' + jdata[0]["DeliveryPhone"];
                        PrintContent += '<br><br><b style="text-decoration: underline;">Delivery Details</b>';
                        PrintContent += '<br>' + jdata[0]["DeliveryAddress"];
                        PrintContent += '<br>' + jdata[0]["DeliveryZip"];

                        PrintContent += '</td>';


                        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:35%;"><table border="1" style="width:100%"><tr><td><b>Pickup Items</b></td></tr>';
                        for (var i = 0; i < len; i++) {
                            PrintContent += '<tr><td>' + jdata[i]["PickupItem"] + '</td></tr>';
                        }
                        PrintContent += '</table></td>';
                        PrintContent += '</tr>';
                    },
                    error: function (response) {
                        alert('Unable to Pickup Details For Print');
                    }
                });

                PrintContent += '</table>';
                PrintContent += '</div">';
            });

            //https: //stackoverflow.com/questions/21379605/printing-div-content-with-css-applied
            

            //$.ajax({
            //    method: "POST",
            //    contentType: "application/json; charset=utf-8",
            //    url: "PrintDriverJob.aspx/GetPickupDetailsForPrint",
            //    async: false,
            //    data: "{ BookingId: 'All' }",
            //    success: function (result) {
            //        var jdata = JSON.parse(result.d);
            //        //alert(JSON.stringify(jdata));
            //        var len = jdata.length;

            //        if (checkDriver != DriverName) {
            //            checkDriver = DriverName;
            //            NewDriverFlag = 1;
            //            Count = 1;
            //        }
            //        else {
            //            NewDriverFlag = 0;
            //        }

            //        PrintContent += '<br>'
            //        PrintContent += '<div id="PrintContentDiv">';
            //        PrintContent += '<table border="0" cellpadding="0" cellspacing="0" id="PrintContentTbl" style="width:100%;page-break-inside: avoid; font-size:16px;">';
            //        if (NewDriverFlag > 0) {
            //            PrintContent += '<tr>';
            //            PrintContent += '<th colspan="2" style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:20px;">' + DriverName + '</th>';
            //            PrintContent += '<th colspan="2" style="text-align:right; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:20px;">' + jdata[0]["PickupDate"] + '</th>';
            //            PrintContent += '</tr>';
            //        }

            //        PrintContent += '<tr>';
            //        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:10%;"><b>SL No.</b><br>' + Count + '</td>';

            //        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:20%;"><b>Booking Ref.</b>';
            //        PrintContent += '<br>' + jdata[0]["BookingId"];
            //        PrintContent += '<br><br><b>Total:</b>';
            //        PrintContent += '<br>' + Cost;
            //        PrintContent += '</td>';
            //        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:35%;">';
            //        //Pickup Details
            //        PrintContent += '<b>' + jdata[0]["PickupName"] + '</b>';
            //        PrintContent += '<br>' + jdata[0]["PickupPhone"];
            //        PrintContent += '<br><br><b style="text-decoration: underline;">Pickup Details</b>';
            //        PrintContent += '<br>' + jdata[0]["PickupAddress"];
            //        PrintContent += '<br>' + jdata[0]["PickupZip"];
            //        PrintContent += '<br><br><span style="display: block; border-bottom: 1px dashed #444; height: 1px;"></span><br>';
            //        //Delivery Details
            //        PrintContent += '<b>' + jdata[0]["DeliveryName"] + '</b>';
            //        PrintContent += '<br>' + jdata[0]["DeliveryPhone"];
            //        PrintContent += '<br><br><b style="text-decoration: underline;">Delivery Details</b>';
            //        PrintContent += '<br>' + jdata[0]["DeliveryAddress"];
            //        PrintContent += '<br>' + jdata[0]["DeliveryZip"];

            //        PrintContent += '</td>';


            //        PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:35%;"><table border="1" style="width:100%"><tr><td><b>Pickup Items</b></td></tr>';
            //        for (var i = 0; i < len; i++) {
            //            PrintContent += '<tr><td>' + jdata[i]["PickupItem"] + '</td></tr>';
            //        }
            //        PrintContent += '</table></td>';
            //        PrintContent += '</tr>';
            //    },
            //    error: function (response) {
            //        alert('Unable to Pickup Details For Print');
            //    }
            //});

            //PrintContent += '</table>';
            //PrintContent += '</div">';



            var MainWindow = window.open('', '', 'height=800,width=1000');
            MainWindow.document.write('<html><head><title></title>');
            MainWindow.document.write('</head><body onload="window.print();window.close()">');
            MainWindow.document.write(PrintContent);
            MainWindow.document.write('</body></html>');
            MainWindow.document.close();
            setTimeout(function () {
                MainWindow.print();
            }, 500)
        }
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
            onrendered: function(canvas) {

                //! MAKE YOUR PDF
                var pdf = new jsPDF('p', 'pt', 'letter');

                for (var i = 0; i <= quotes.clientHeight/980; i++) {
                    //! This is all just html2canvas stuff
                    var srcImg  = canvas;
                    var sX      = 0;
                    var sY      = 980*i; // start 980 pixels down for every new page
                    var sWidth  = 2000;
                    var sHeight = 980;
                    var dX      = 0;
                    var dY      = 0;
                    var dWidth  = 2000;
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

                    var width         = onePageCanvas.width;
                    var height        = onePageCanvas.clientHeight;

                    //! If we're on anything other than the first page,
                    // add another page
                    if (i > 0) {
                        pdf.addPage(612, 791); //8.5" x 11" in pts (in*72)
                    }
                    //! now we declare that we're working on that page
                    pdf.setPage(i+1);
                    //! now we add content to that page!
                    pdf.addImage(canvasDataURL, 'PNG', 0, 0, (width*.42), (height*.62));

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
    
    function UnassignBookingToDriver()
    {
        var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();

        var objAssignBookingToDriver = {};
        objAssignBookingToDriver.BookingId = BookingId;

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "PrintDriverJob.aspx/UnAssignBookingToDriver",
            data: JSON.stringify(objAssignBookingToDriver),
            success: function (result) {
                //alert(result.d);
                $('#Assign-bx').modal('hide');

                if (result.d == "Success") {
                    $('#USuccess-bx').modal('show');
                }
                else {
                    $('#Failure-bx').modal('show');
                }

            },
            error: function (response) {
                alert('Unable to Add Assign Booking To Driver Details');
            }
        });
        return false;
    }


    function assignBookingToDriver()
    {
        var DriverName = $( '#<%=ddlDrivers.ClientID%>' );
        var vDriverName = DriverName.find( 'option:selected' ).text().trim();

        if ( vDriverName == 'Select Driver' )
        {
            $.alert( {
                title: 'Driver Name',
                content: 'Please select a Driver Name from Dropdown'
            } );

            return false;
        }

        $('#spDriverName').text(vDriverName);

        var tblAssignBookingToDriver = $( '#dtAssignBookingToDriver' ).DataTable();

        //var result = $( tblAssignBookingToDriver.$( 'input[type="checkbox"]' ).map( function ()
        //{
        //    return $( this ).prop( "checked" ) ? $( this ).closest( 'tr' ) : null;
        //} ) );

        //Variables required for Add Driver Payment outside the loop
        var result = $(this).closest('tr');
        var DriverId = "";
        var Wage = 0.00;
        var DriverType = "";
        var WageType = "";

        var vCtr = 0;
        debugger;

            var AssignId = '';
            DriverId = $("#<%=hfDriverId.ClientID%>").val().trim();
            var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();
            var sWage = $('#<%=hfDriverWage.ClientID%>').val().trim();
            Wage = parseFloat(sWage);


            //$('.findDriverJoblink').attr('href', '/Booking/PrintDriverJob.aspx?DriverId=' + DriverId);
            //$('.findDriverJoblink').attr('href', '/Booking/PrintDriverJob.aspx');

                var objAssignBookingToDriver = {};
                objAssignBookingToDriver.AssignId = AssignId;
                objAssignBookingToDriver.DriverId = DriverId;
                objAssignBookingToDriver.BookingId = BookingId;
                objAssignBookingToDriver.Wage = Wage;

                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PrintDriverJob.aspx/ReAssignBookingToDriver",
                    data: JSON.stringify(objAssignBookingToDriver),
                    success: function (result) {
                        //var Jdata = JSON.parse(result.d);

                        $('#Assign-bx').modal('hide');
                        //alert(result.d)
                        if (result.d == "Success") {
                            $('#Success-bx').modal('show');
                        }
                        else {
                            $('#Failure-bx').modal('show');
                        }
                        
                    },
                    error: function (response) {
                        alert('Unable to Add Assign Booking To Driver Details');
                    }
                });


        //}//end of for loop

        //var result = tblAssignBookingToDriver.rows().data();

        //result.each( function ( value, index )
        //{
        //    alert( 'Data in index: ' + index + ' is: ' + value.BookingId );
        //} );

        //Driver Payment Section
        //=======================================================================
        /*var PaymentId = '';
        var ExpectedAmount = Wage;
        var AmountReceived = 0;
        var Discrepancy = Wage;
        var CreditDebitNote = vDriverName + " will be paid £ " + ExpectedAmount.toFixed( 2 );

        var objDriverPayment = {};
        objDriverPayment.PaymentId = PaymentId;
        objDriverPayment.DriverId = DriverId;
        objDriverPayment.DriverType = DriverType;
        objDriverPayment.WageType = WageType;
        objDriverPayment.ExpectedAmount = ExpectedAmount;
        objDriverPayment.AmountReceived = AmountReceived;
        objDriverPayment.Discrepancy = Discrepancy;
        objDriverPayment.CreditDebitNote = CreditDebitNote;

        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AssignBookingToDriver.aspx/AddDriverPayment",
            data: JSON.stringify( objDriverPayment ),
            success: function ( result )
            {
            },
            error: function ( response )
            {
                alert( 'Unable to Add Driver Payment' );
            }
        } );*/
        //=========================================================

        return false;
    }

</script>

<script>
    function clearDriverModalPopup() {
        $('#spDriverName').text('');
        $('#spBookingId').text('');
        $('#spFromDate').text('');
        $('#spToDate').text('');
        $('#spAddress').text('');
        $('#spPostCode').text('');
        $('#spMobile').text('');
        $('#spWage').text('');

        return false;
    }

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

        $('#dvAllBookings tbody').empty();

        $('#<%=lblVAT.ClientID%>').text('');
        $('#<%=lblOrderTotal.ClientID%>').text('');

        $('#dvMyPaymentDetails tbody').empty();

        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    View Driver Job
                </h2>
                <p></p>
            </div>
        
            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmPrintDriverJob" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>

                            <asp:HiddenField ID="hfBookingId" runat="server" />
                            <asp:HiddenField ID="hfOrderStatus" runat="server" />
                            <asp:HiddenField ID="hfDriverId" runat="server" />
                            <asp:HiddenField ID="hfDriverWage" runat="server" />
                            <asp:HiddenField ID="hfDriverType" runat="server" />
                            <asp:HiddenField ID="hfWageType" runat="server" />


                    </div>
                    <div class="panel-body clrBLK dashboad-form">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group clearfix"><label class="col-sm-3 control-label">From Date <span style="color: red">*</span></label>
                                        <div class="col-sm-9">
                                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onkeypress="clearErrorMessage();"
                                                onchange="checkAssignDate(this.value);"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group clearfix"><label class="col-sm-4 control-label">To Date <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtToDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onkeypress="clearErrorMessage();"
                                                onchange="checkAssignDate(this.value);"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                       
                            
                        <!--Added new Script Files for Date Picker-->
                        <script src="/js/bootstrap-datepicker.js"></script>
                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                        
                            <div class="form-group clearfix">
                                <div class="col-sm-12 text-center">
                                    <asp:Button ID="btnShowDriverJob" runat="server" Text="Show"
                                        CssClass="btn btn-primary btn-register" 
                                        OnClientClick="return showDriverJobs();" />
                                        <asp:Button ID="btnCancelDriverJob" runat="server" Text="Cancel" 
                                        CssClass="btn btn-default"
                                        OnClientClick="" />
                                </div>
                            </div>

                        <div class="clearfix text-center btn_center">
                            <span class="iconADD">
                                <asp:Button ID="btnExportPrintDriverJobExcel" runat="server"  
                                Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                            </span>

                            <span class="iconADD">
                                <asp:Button ID="btnExportPrintDriverJobPDF" runat="server"  
                                    Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                            </span>

                            <span class="iconADD">
                                <asp:Button ID="btnPrintDriverJobs" runat="server"  
                                Text="Print Driver Jobs" OnClientClick="return takePrintout();" />
                                <i class="fa fa-print" aria-hidden="true"></i>
                            </span>

                            <span class="iconADD">
                                <asp:Button ID="btnGoToAssignBookingToDriver" runat="server"  
                                    Text="Assign Booking To Driver" OnClientClick="return gotoAssignBookingToDriver();" />
                                <i class="fa fa-user" aria-hidden="true"></i>
                            </span>
                            <span class="iconADD">
                                <asp:Button ID="btnUnassignBookingToDriver" runat="server"  
                                    Text="Un-assign Booking From Driver" OnClientClick="return SelectedUnassignBookingToDriver();" />
                                <i class="fa fa-user" aria-hidden="true"></i>
                            </span>
                        </div>

                        <div class="clearfix">
                            <table id="dtPrintDriverJob">
                                <thead>
                                    <tr>
                                        <th>Select Booking</th>
                                        <th>Driver Name</th>
                                        <th>Booking Id</th>
                                        <th>From Date</th>
                                        <th>To Date</th>
                                        <th>Address</th>
                                        <th>Post Code</th>
                                        <th>Contact No</th>
                                        <th>Wage</th>
                                        <th>Print</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="clearfix">
                        <hr/>
                        <footer>
                            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                        </footer>    
                    </div>

                    <div class="modal fade" id="dvBooking" role="dialog" >
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
                                <%--<button id="btnEditBooking" data-dismiss="modal" title="Edit Booking"
                                 onclick="return gotoEditBookingPage();">
                                    <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                </button>--%>
                                
                                <%--<button id="btnCancelBooking" data-dismiss="modal" title="Cancel Booking"
                                 onclick="return showCancelModal();">
                                    <i class="fa fa-times" aria-hidden="true"></i>
                                </button>--%> 
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="twoSETbtn">
                                <button id="btnPrintBookingModal" data-dismiss="modal" title="Print Booking Details"
                                    onclick="return printDetails('dvBooking');" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfBookingModal" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvBooking', 'BookingAllDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelBookingModal" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('dvAllBookings', 'CustomerDetails.xls');" style="margin-bottom:10px;">
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
                                                    <li><strong>Customer ID</strong><span><asp:Label ID="lblCustomerId" runat="server" Text="Customer Id"></asp:Label></span></li>
                                                    <li><strong>Customer Name</strong><span><asp:Label ID="lblCustomerName" runat="server" Text="Customer Name"></asp:Label></span></li>
                                                    <li><strong>Customer Mobile</strong><span><asp:Label ID="lblCustomerMobile" runat="server" Text="Customer Mobile"></asp:Label></span></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-12" style="text-align: center;font-size: 22px; ">
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
                                
                                                    <p class="undrLN"><strong>Pickup:</strong></p><br />
                                                    <!-- jQuery DataTable -->
                                                        <table id="dvAllBookings" style="width: 100%;">
                                                        <thead>
                                                            <tr>
                                                                <th>Item</th>
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
                        <div class="row" style="height: 30px;">

                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                    <ul class="btnList">
                                        <li>
                                        </li>
                                        <li>
                                        </li>
                                        <li>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        </div>
                        </div>
      
                    </div>
                    </div>

    <div class="modal fade" id="Assign-bx" role="dialog">
<div class="modal-dialog">
    
    <!-- Modal content-->
    <div class="modal-content">
    <div class="modal-header" style="background-color:#f0ad4ecf;">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title" style="font-size:24px;color:#111;">Assign Booking Details To Driver</h4>
    </div>
    <div class="modal-body" style="font-size: 20px; color: black;">
        <div class="row">
            <div class="form-group"><label class="col-sm-4 control-label">Select a Driver: <span style="color: red">*</span></label>
                <div class="col-sm-8">
                <asp:DropDownListChosen ID="ddlDrivers" runat="server"
                    CssClass="vat-option label-lgt"
                    ForeColor="Black"
                    DataPlaceHolder="Please select an option"
                    AllowSingleDeselect="true"
                    NoResultsText="No result found"
                    DisableSearchThreshold="10"
                    onchange="clearErrorMessage();getDriverDetails(this.value);"
                    style="float: left;">
                    <asp:ListItem Selected="True">Select Driver</asp:ListItem>
                </asp:DropDownListChosen>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <div class="row">
            <div class="form-group">
                <div class="col-sm-6">
                    <asp:Button ID="btnAssignBookingDetailsToDriver" runat="server" Text="Assign Booking to Driver"
                        CssClass="btn btn-primary btn-register" 
                        OnClientClick="return assignBookingToDriver();" />
                </div>
                <div class="col-sm-6">
                    <asp:Button ID="btnCancelAssignBookingDetails" runat="server" Text="Un-assign Booking" 
                        CssClass="btn btn-default"
                        OnClientClick="return UnassignBookingToDriver();" />
                </div>
            </div>
        </div>
    </div>
    </div>
      
</div>
</div>

    <div class="modal fade" id="Failure-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
            <div class="modal-header" style="background-color:#f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title" style="font-size:24px;color:#111;">Assigning Not Possible</h4>
            </div>
            <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                <p>Please choose ALL Valid Bookings from the list</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-warning" data-dismiss="modal">OK</button>
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
                <h4 class="modal-title" style="font-size:24px;color:#111;">Assign Booking Details To Driver</h4>
            </div>
            <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                <p>Booking is assigned to <span id="spDriverName"></span> successfully</p>
                <%--<p><a class="findDriverJoblink">Click here to View Driver Job</a></p>--%>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="location.reload();">OK</button>
            </div>
        </div>
    </div>
</div>

    <div class="modal fade" id="USuccess-bx" role="dialog">
    <div class="modal-dialog">
    
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header" style="background-color:#f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title" style="font-size:24px;color:#111;">Assign Booking Details To Driver</h4>
            </div>
            <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                <p>Booking Successfully Un-assigned</p>
                <%--<p><a class="findDriverJoblink">Click here to View Driver Job</a></p>--%>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="location.reload();">OK</button>
            </div>
        </div>
    </div>
</div>

                 </form>
                
                
                </div>
            </div>
        
  

    <div class="modal fade" id="PrintDataTable-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Print - Driver Jobs</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <p>Sure? You want to print this Driver Job Details?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return printDriverJobDetails('dtPrintDriverJob', '', '');">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>
      
        </div>
    </div>

    <div class="modal fade" id="dvDriverModalDetails" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Driver Details: 
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Driver below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintDriverModal" data-dismiss="modal" title="Print Driver Details"
                                    onclick="return printDetails('tblDriverDetails');" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfDriverModal" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvDriverModalDetails', 'DriverDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelDriverModal" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('tblDriverDetails', 'DriverDetails.xls');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
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
                                                <table class="table custoFULLdet" id="tblDriverDetails">
                                                    <tr>
                                                        <th>Driver Name: </th>
                                                        <td><span id="spDriverName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Booking Id: </th>
                                                        <td><span id="spBookingId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>From Date: </th>
                                                        <td><span id="spFromDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>To Date: </th>
                                                        <td><span id="spToDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Address: </th>
                                                        <td><span id="spAddress"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Post Code: </th>
                                                        <td><span id="spPostCode"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Contact No: </th>
                                                        <td><span id="spMobile"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Wage: </th>
                                                        <td><span id="spWage"></span></td>
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
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return cancelBooking();">Yes</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
            </div>
        </div>
      
    </div>
   </div>

    <div class="modal fade" id="dvDriverOwnDetails" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Driver Details: #<span id="spHeaderDriverName"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Driver below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintDriverModal2" data-dismiss="modal" title="Print Driver Details"
                                    onclick="return printDetails('tblDriverOwnDetails');" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfDriverModal2" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvDriverOwnDetails', 'DriverOwnDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelDriverModal2" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('tblDriverOwnDetails', 'DriverOwnDetails.xls');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
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
                                                <table class="table custoFULLdet" id="tblDriverOwnDetails">
                                                    <tr>
                                                        <th>Driver EmailID: </th>
                                                        <td><span id="spDriverEmailID"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Driver Name: </th>
                                                        <td><span id="spDriverFullName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Date Of Birth: </th>
                                                        <td><span id="spDriverDOB"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Driver Address: </th>
                                                        <td><span id="spDriverAddress"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>House number: </th>
                                                        <td><span id="spDriverPostCode"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Mobile No: </th>
                                                        <td><span id="spDriverMobile"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Landline No: </th>
                                                        <td><span id="spDriverLandline"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Driver Type: </th>
                                                        <td><span id="spDriverType"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Wage Type: </th>
                                                        <td><span id="spDriverWageType"></span></td>
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



    <iframe id="txtArea1" style="display:none"></iframe>
    <iframe id="txtArea2" style="display:none"></iframe>

</asp:Content>

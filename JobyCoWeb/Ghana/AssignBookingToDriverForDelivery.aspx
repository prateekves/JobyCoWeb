<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
CodeBehind="AssignBookingToDriverForDelivery.aspx.cs" Inherits="JobyCoWeb.Ghana.AssignBookingToDriverForDelivery" 
 EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

<style>
    .SelectCheckBox, .BookingId, .CustomerName {

    }

    #lblSelectAll {
        margin-top: 5px; 
        margin-left: 2px; 
        margin-right: 0px;
        color: #faa51a;
    }

    .unpaid-bg { background: #9B822E; }

    .cancel-bg { background: #B51013; }

    .paid-bg {background: #238A35;}
    .paid-bg, .cancel-bg, .unpaid-bg{
        color: #fff;
        text-transform:uppercase;
        padding: 5px 0;
        width: 100%;
        display: block;
        text-align: center;
    }   

    .SelectAllRight
     {
        background:none;
        margin-right: 5px;
        width: 30px;
        height: 30px;
        border: 1px solid #fca311;
        color: #fca311;
    }

    .SelectAllRight:hover
    {
        background: #fca311;
        color:#fff;
        text-shadow:1px 1px 1px rgba(0,0,0,0.4);
    }
    .hideColumn {
            display: none;
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

        $('[data-toggle="tooltip"]').tooltip();
    });
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

    function checkFewControls()
    {
        //var DriverName = $( '#<%=ddlDrivers.ClientID%>' );
        //var vDriverName = DriverName.find( 'option:selected' ).text().trim();

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

        //if ( vDriverName == "Select Driver" )
        //{
        //    vErrMsg.text( 'Please select a Driver' );
        //    vErrMsg.css( "display", "block" );
        //    DriverName.focus();
        //    return false;
        //}

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
                vErrMsg.text( 'To Date cannot be earlier than From Date' );
                vErrMsg.css( "display", "block" );
                return false;
            }
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
        var DriverName = $( '#<%=ddlDrivers.ClientID%>' );
        var FromDate = $( "#<%=txtFromDate.ClientID%>" );
        var ToDate = $( "#<%=txtToDate.ClientID%>" );

        var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css( "text-align", "center" );

        DriverName.find('option:selected').text( 'Select Driver' );
        FromDate.val( '' );
        ToDate.val( '' );

        return false;
    }
</script>

<script>
    function checkAssignDateAndCurrentDate( vFromDate, vToDate )
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
        checkAssignDateAndCurrentDate( vAssignDate, vCurrentDate );
    }

    function takePrintout()
    {
        var tblAssignBookingToDriver = $( '#dtAssignBookingToDriver' ).DataTable();

        var result = $( tblAssignBookingToDriver.$( 'input[type="checkbox"]' ).map( function ()
        {
            return $( this ).prop( "checked" ) ? $( this ).closest( 'tr' ) : null;
        } ) );

        if ( result.length > 0 )
        {
            $( '#PrintDataTable-bx' ).modal( 'show' );
        }
        else
        {
            $( '#Failure-bx' ).modal( 'show' );
        }

        return false;
    }

    function printDataTable() 
    {
        $( '#PrintDataTable-bx' ).modal( 'hide' );

        var bCheck = 0;
        var prtContent = "";

        if ( $( '#dtAssignBookingToDriver_Check tbody > tr' ).length > 0 )
        {
            $( '#dtAssignBookingToDriver_Check' ).css( 'display', 'block' );

            bCheck = 1;
            prtContent = document.getElementById( 'dtAssignBookingToDriver_Check' );
        }
        else
        {
            bCheck = 0;
            prtContent = document.getElementById( 'dtAssignBookingToDriver' );
        }

        prtContent.border = 0; //set no border here
        var WinPrint = window.open('','','left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
        WinPrint.document.write(prtContent.outerHTML);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();

        if ( bCheck == 1 )
        {
            $( '#dtAssignBookingToDriver_Check' ).css( 'display', 'none' );
        }

        return false;
    }

</script>
    
<script>
    $( document ).ready( function ()
    {
        getAllUnassignedBookings();

        $( '#<%=txtFromDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

        $( '#<%=txtToDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        } );

        $( "#cbSelectAll" ).change( function ()
        {
            var tblAssignBookingToDriver = $( '#dtAssignBookingToDriver' ).DataTable();

            var allCheckBoxes = $( tblAssignBookingToDriver.$( 'input[type="checkbox"]' ).map( function ()
            {
                return $( this ).closest( 'tr' );
            } ) );

            for ( var i = 0; i < allCheckBoxes.length; i++ )
            {
                allCheckBoxes[i].find( 'input[type=checkbox]:eq(0)' ).prop( 'checked', $( this ).prop( "checked" ) );

                var vBookingId = allCheckBoxes[i].find( 'td' ).eq( 1 ).text();
                var vCustomerName = allCheckBoxes[i].find( 'td' ).eq( 2 ).text();
                var vPickupDateTime = allCheckBoxes[i].find( 'td' ).eq( 3 ).text();
                var vPickupAddress = allCheckBoxes[i].find( 'td' ).eq( 4 ).text();
                var vOrderStatus = allCheckBoxes[i].find('td').eq(5).text();
                var vPostCode = allCheckBoxes[i].find('td').eq(6).text();
                var vContactNo = allCheckBoxes[i].find( 'td' ).eq( 7 ).text();

                var vAssignBookingToDriver_Check = "";
                vAssignBookingToDriver_Check += "<tr>";
                vAssignBookingToDriver_Check += "<td>" + vBookingId + "</td>";
                vAssignBookingToDriver_Check += "<td>" + vCustomerName + "</td>";
                vAssignBookingToDriver_Check += "<td>" + vPickupDateTime + "</td>";
                vAssignBookingToDriver_Check += "<td>" + vPickupAddress + "</td>";
                vAssignBookingToDriver_Check += "<td>" + vOrderStatus + "</td>";
                vAssignBookingToDriver_Check += "<td>" + vPostCode + "</td>";
                vAssignBookingToDriver_Check += "<td>" + vContactNo + "</td>";
                vAssignBookingToDriver_Check += "</tr>";

                if ( $( allCheckBoxes[i].find( 'input[type=checkbox]:eq(0)' ) ).is( ":checked" ) )
                {
                    if (vOrderStatus != "Cancelled") {
                        $("#dtAssignBookingToDriver_Check tbody").append(vAssignBookingToDriver_Check);
                    }
                }
                else
                {
                    var vCheckBookingId = "";

                    $( '#dtAssignBookingToDriver_Check tbody > tr' ).each( function ()
                    {
                        vCheckBookingId = $( this ).find( 'td:eq(0)' ).text().trim();

                        if ( vBookingId == vCheckBookingId )
                        {
                            $( this ).remove();
                        }
                    } );
                }
            }

            //For all Checkboxes in the Current Page 
            //$( "input:checkbox" ).prop( 'checked', $( this ).prop( "checked" ) );
        } );
    } );
</script>

<script>
    function getDriverDetails(DriverName)
    {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AssignBookingToDriverForDelivery.aspx/GetDriverId",
            data: "{ DriverName: '" + DriverName + "'}",
            dataType: "json",
            success: function (result) {
                $( "#<%=hfDriverId.ClientID%>" ).val( result.d );

                var hfDriverId = $( "#<%=hfDriverId.ClientID%>" ).val().trim();

                $.ajax( {
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "AssignBookingToDriverForDelivery.aspx/GetDriverType",
                    data: "{ DriverId: '" + hfDriverId + "'}",
                    success: function ( result )
                    {
                        $( "#<%=hfDriverType.ClientID%>" ).val( result.d );

                        $.ajax( {
                            method: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "AssignBookingToDriverForDelivery.aspx/GetWageType",
                            data: "{ DriverId: '" + hfDriverId + "'}",
                            success: function ( result )
                            {
                                $( "#<%=hfWageType.ClientID%>" ).val( result.d );

                                var DriverType = $( '#<%=hfDriverType.ClientID%>' ).val().trim();
                                var WageType = $( '#<%=hfWageType.ClientID%>' ).val().trim();

                                $.ajax( {
                                    method: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    url: "AssignBookingToDriverForDelivery.aspx/GetDriverWage",
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

    function getAllUnassignedBookings()
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AssignBookingToDriverForDelivery.aspx/GetAllUnassignedBookings",
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
                var jsonUnassignedBookings = JSON.parse( result.d );
                $( '#dtAssignBookingToDriver' ).DataTable( {
                    data: jsonUnassignedBookings,
                    columns: [
                        { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
                        {
                            data: "BookingId",
                            render: function ( data )
                            {
                                return '<a class="BookingId">' + data + '</a>';
                            }
                        },
                        {
                            data: "CustomerName",
                            render: function ( data )
                            {
                                return '<a class="CustomerName">' + data + '</a>';
                            }
                        },
                        {
                            data: "PickupDateTime",
                            render: function ( jsonPickupDateTime )
                            {
                                return getFormattedDateUK( jsonPickupDateTime );
                            }
                        },
                        { data: "PickupAddress" },
                        {
                            data: "OrderStatus",
                            render: function (jsonOrderStatus) {
                                return makeProperColor(jsonOrderStatus);
                            }
                        },
                        { data: "PickupPostCode" },
                        { data: "PickupMobile" },
                        {
                            data: "OrderStatus",
                            render: function (jsonOrderStatus) {
                                return jsonOrderStatus.substring(0, 1);
                            }
                        }
                    ],
                    "columnDefs": [
                        {
                            "targets": [ 0 ],
                            "checkboxes": { "selectRow": true }
                        },
                        {
                            targets: [8],
                            className: "hideColumn"
                        }
                    ],
                    "bDestroy": true
                } );
            },
            error: function ( response )
            {
                alert( 'Unable to Bind All Bookings' );
            }
        } );//end of ajax

        $( '#dtAssignBookingToDriver tbody' ).on( 'click', '.SelectCheckBox', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            var vBookingId = vClosestTr.find( 'td' ).eq( 1 ).text();
            var vCustomerName = vClosestTr.find( 'td' ).eq( 2 ).text();
            var vPickupDateTime = vClosestTr.find( 'td' ).eq( 3 ).text();
            var vPickupAddress = vClosestTr.find( 'td' ).eq( 4 ).text();
            var vOrderStatus = vClosestTr.find('td').eq(5).text();
            var vPostCode = vClosestTr.find('td').eq(6).text();
            var vContactNo = vClosestTr.find( 'td' ).eq( 7 ).text();

            var vAssignBookingToDriver_Check = "";
            vAssignBookingToDriver_Check += "<tr>";
            vAssignBookingToDriver_Check += "<td>" + vBookingId + "</td>";
            vAssignBookingToDriver_Check += "<td>" + vCustomerName + "</td>";
            vAssignBookingToDriver_Check += "<td>" + vPickupDateTime + "</td>";
            vAssignBookingToDriver_Check += "<td>" + vPickupAddress + "</td>";
            vAssignBookingToDriver_Check += "<td>" + vOrderStatus + "</td>";
            vAssignBookingToDriver_Check += "<td>" + vPostCode + "</td>";
            vAssignBookingToDriver_Check += "<td>" + vContactNo + "</td>";
            vAssignBookingToDriver_Check += "</tr>";

            if ( $( this ).is( ":checked" ) )
            {
                $( "#dtAssignBookingToDriver_Check tbody" ).append( vAssignBookingToDriver_Check );
            }
            else
            {
                var vCheckBookingId = "";

                $( '#dtAssignBookingToDriver_Check tbody > tr' ).each( function ()
                {
                    vCheckBookingId = $( this ).find( 'td:eq(0)' ).text().trim();

                    if ( vBookingId == vCheckBookingId )
                    {
                        $( this ).remove();
                    }
                } );
            }
        } );

        $( '#dtAssignBookingToDriver tbody' ).on( 'click', '.BookingId', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );
            var vBookingId = vClosestTr.find( 'td' ).eq( 1 ).text();

            clearBookingModalPopup();

            $('#<%=spHeaderBookingId.ClientID%>').text('#' + vBookingId);
            $( '#<%=spBodyBookingId.ClientID%>' ).text( '#' + vBookingId );

            //First Tabular Details
            //===========================================================================
            //getCustomerIdFromBookingId( vBookingId );

            var vCustomerName = vClosestTr.find( 'td' ).eq( 2 ).text();
            $( '#<%=lblCustomerName.ClientID%>' ).text( vCustomerName );
            //============================================================================

            //Second Tabular Details
            //===========================================================================
            //getPickupNameFromBookingId( vBookingId );
            getPickupDeliveryFromBookingId(vBookingId);
            //============================================================================

            viewBookingDetails( vBookingId );
            viewPaymentDetails( vBookingId );
            $('#dvBooking').modal('show');
            $("#loadingDiv").show();
            $("#loadingDiv").css("z-index", "9999");
            setTimeout(function () {
                $('#loadingDiv').fadeOut();
            }, 1200);
            return false;
        } );

        $( '#dtAssignBookingToDriver tbody' ).on( 'click', '.CustomerName', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );
            var vCustomerName = vClosestTr.find('td').eq(2).text();

            clearCustomerModalPopup();

            $( '#spCustomerName' ).text( vCustomerName );
            getCustomerIdFromCustomerName( vCustomerName );
            $( '#dvCustomerDetailsModal' ).modal( 'show' );

            return false;
        } );

        return false;
    }

    function getPickupDeliveryFromBookingId(BookingId)
        {
             $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                //url: "ViewAllOfMyBookings.aspx/GetPickupNameFromBookingId",
                url: "/Booking/ViewAllBookings.aspx/GetPickupDeliveryFromBookingId",
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

    function showSpecificBookings()
    {
        if ( checkFewControls() )
        {
            var FromDate = $( "#<%=txtFromDate.ClientID%>" ).val().trim();
            var ToDate = $( "#<%=txtToDate.ClientID%>" ).val().trim();

            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AssignBookingToDriverForDelivery.aspx/GetAllUnassignedSpecificBookings",
                data: "{ FromDate: '" + FromDate + "', ToDate: '" + ToDate + "'}",
                success: function ( result )
                {
                    var jsonUnassignedBookings = JSON.parse( result.d );
                    $( '#dtAssignBookingToDriver' ).DataTable( {
                        data: jsonUnassignedBookings,
                        columns: [
                            { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
                            {
                                data: "BookingId",
                                render: function (data) {
                                    return '<a class="BookingId">' + data + '</a>';
                                }
                            },
                        {
                            data: "CustomerName",
                            render: function (data) {
                                return '<a class="CustomerName">' + data + '</a>';
                            }
                        },
                            {
                                data: "PickupDateTime",
                                render: function ( jsonPickupDateTime )
                                {
                                    return getFormattedDateUK( jsonPickupDateTime );
                                }
                            },
                            { data: "PickupAddress" },
                            {
                                data: "OrderStatus",
                                render: function (jsonOrderStatus) {
                                    return makeProperColor(jsonOrderStatus);
                                }
                            },
                            { data: "PickupPostCode" },
                            { data: "PickupMobile" },
                            {
                            data: "OrderStatus",
                            render: function (jsonOrderStatus) {
                                return jsonOrderStatus.substring(0, 1);
                                }
                            }
                        ],
                        "columnDefs": [
                            {
                                "targets": [0],
                                "checkboxes": { "selectRow": true }
                            },
                            {
                                targets: [8],
                                className: "hideColumn"
                            }
                        ],
                        "bDestroy": true
                    } );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Specific Bookings' );
                }
            } );//end of ajax
        }

        return false;
    }

</script>

<script>
    function showAssigningModalDialog()
    {
        var tblAssignBookingToDriver = $( '#dtAssignBookingToDriver' ).DataTable();

        var result = $( tblAssignBookingToDriver.$( 'input[type="checkbox"]' ).map( function ()
        {
            return $( this ).prop( "checked" ) ? $( this ).closest( 'tr' ) : null;
        } ) );

        if (result.length > 0) {

            var vCtr = 0;
            for ( var i = 0; i < result.length; i++ )
            {
                var AssignId = '';
                DriverId = $( "#<%=hfDriverId.ClientID%>" ).val().trim();

                var BookingId = result[i].find( 'td' ).eq( 1 ).text();
            
                var CustomerName = result[i].find( 'td' ).eq( 2 ).text();
                var PickupDateTime = result[i].find( 'td' ).eq( 3 ).text();

                var FromDate = $( "#<%=txtFromDate.ClientID%>" ).val().trim();
                var ToDate = $( "#<%=txtToDate.ClientID%>" ).val().trim();

                if ( FromDate == "" )
                {
                    FromDate = PickupDateTime;
                }

                if ( ToDate == "" )
                {
                    ToDate = PickupDateTime;
                }

                var PickupAddress = result[i].find( 'td' ).eq( 4 ).text();
                var OrderStatus = result[i].find('td').eq(5).text();
                var PickupPostCode = result[i].find('td').eq(6).text();
                var PickupMobile = result[i].find( 'td' ).eq( 7 ).text();

                var sWage = $( '#<%=hfDriverWage.ClientID%>' ).val().trim();
                Wage = parseFloat(sWage);
            
                if (OrderStatus == "Cancelled") {
                    vCtr++;
                }
            }//end of for loop

            if (vCtr == 0) {
                $('#Assign-bx').modal('show');
            }
            else {
                $('#Failure-bx').modal('show');
            }
        }
        else
        {
            $( '#Failure-bx' ).modal( 'show' );
        }

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

        var result = $( tblAssignBookingToDriver.$( 'input[type="checkbox"]' ).map( function ()
        {
            return $( this ).prop( "checked" ) ? $( this ).closest( 'tr' ) : null;
        } ) );

        //Variables required for Add Driver Payment outside the loop
        var DriverId = "";
        var Wage = 0.00;
        var DriverType = "";
        var WageType = "";

        var vCtr = 0;

        for ( var i = 0; i < result.length; i++ )
        {
            var AssignId = '';
            DriverId = $( "#<%=hfDriverId.ClientID%>" ).val().trim();
            //alert('DriverId= '+DriverId);
            var BookingId = result[i].find( 'td' ).eq( 1 ).text();
            
            var CustomerName = result[i].find( 'td' ).eq( 2 ).text();
            var PickupDateTime = result[i].find( 'td' ).eq( 3 ).text();

            var FromDate = $( "#<%=txtFromDate.ClientID%>" ).val().trim();
            var ToDate = $( "#<%=txtToDate.ClientID%>" ).val().trim();

            if ( FromDate == "" )
            {
                FromDate = PickupDateTime;
            }

            if ( ToDate == "" )
            {
                ToDate = PickupDateTime;
            }

            var PickupAddress = result[i].find( 'td' ).eq( 4 ).text();
            var OrderStatus = result[i].find('td').eq(5).text();
            var PickupPostCode = result[i].find('td').eq(6).text();
            var PickupMobile = result[i].find( 'td' ).eq( 7 ).text();

            var sWage = $( '#<%=hfDriverWage.ClientID%>' ).val().trim();
            Wage = parseFloat(sWage);
            

            //$('.findDriverJoblink').attr('href', '/Booking/PrintDriverJob.aspx?DriverId=' + DriverId);
            //$('.findDriverJoblink').attr('href', '/Booking/PrintDriverJob.aspx');

<%--        DriverType = $( '#<%=hfDriverType.ClientID%>' ).val().trim();
            WageType = $( '#<%=hfWageType.ClientID%>' ).val().trim();

            switch ( DriverType )
            {
                case "Direct Payroll":

                    switch ( WageType )
                    {
                        case "Hourly Basis":
                            Wage = 2200.00;
                            break;

                        case "Monthly Basis":
                            Wage = 2000.00;
                            break;
                    }
                    break;

                case "Third Party Payroll":

                    switch ( WageType )
                    {
                        case "Hourly Basis":
                            Wage = 1200.00;
                            break;

                        case "Monthly Basis":
                            Wage = 1000.00;
                            break;
                    }
                    break;
            }--%>

            if (OrderStatus != "Cancelled") {
                vCtr++;

                var objAssignBookingToDriver = {};
                objAssignBookingToDriver.AssignId = AssignId;
                objAssignBookingToDriver.DriverId = DriverId;
                objAssignBookingToDriver.BookingId = BookingId;

                objAssignBookingToDriver.FromDate = FromDate;
                objAssignBookingToDriver.ToDate = ToDate;

                objAssignBookingToDriver.PickupAddress = PickupAddress;
                objAssignBookingToDriver.PickupPostCode = PickupPostCode;
                objAssignBookingToDriver.PickupMobile = PickupMobile;

                objAssignBookingToDriver.Wage = Wage;

                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "AssignBookingToDriverForDelivery.aspx/AddAssignBookingToDriver",
                    data: JSON.stringify(objAssignBookingToDriver),
                    success: function (result) {
                        var ResultBookingId = JSON.parse(result.d);

                        $.ajax({
                            method: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "AssignBookingToDriverForDelivery.aspx/UpdateIsAssignedInOrderBooking",
                            data: "{ BookingId: '" + ResultBookingId + "'}",
                            success: function (result) {

                            },
                            error: function (response) {
                                alert('Unable to update IsAssign To Booking');
                            }
                        });
                    },
                    error: function (response) {
                        alert('Unable to Add Assign Booking To Driver Details');
                    }
                });
            }//end of Order Status - 'Cancelled' if
            else {
                $('#Assign-bx').modal('hide');
                $('#Failure-bx').modal('show');
                break;
            }

        }//end of for loop

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
            url: "AssignBookingToDriverForDelivery.aspx/AddDriverPayment",
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

        $('#Assign-bx').modal('hide');

        if (vCtr > 0) {
            $('#Success-bx').modal('show');
        }
        else {
            $('#Failure-bx').modal('show');
        }

        return false;
    }

    function gotoAddDriverPage()
    {
        location.href = '/Drivers/AddDriver.aspx?PageName=AssignBookingToDriver';
        return false;
    }

    function gotoPrintDriverJobPage()
    {
        location.href = '/Booking/PrintDriverJob.aspx';
        return false;
    }
</script>

<script>

    function getCustomerIdFromBookingId(BookingId)
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Booking/ViewAllBookings.aspx/GetCustomerIdFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetCustomerMobileFromCustomerId",
            data: "{ CustomerId: '" + CustomerId + "'}",
            success: function (result) {
                $( '#<%=lblCustomerMobile.ClientID%>' ).text( result.d );
            },
            error: function (response) {
                alert( 'Unable to get Customer Mobile from Customer Id' );
            }
        } );
    }

    function getPickupNameFromBookingId( BookingId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Booking/ViewAllBookings.aspx/GetPickupNameFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetPickupAddressFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetPickupMobileFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetDeliveryNameFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetDeliveryAddressFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetDeliveryMobileFromBookingId",
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

    function getLongDateTime( vDate )
    {
        var vDay = parseInt( vDate.substring( 0, 2 ), 10 );
        var vMonth = parseInt( vDate.substring( 3, 5 ), 10 );
        var vYear = parseInt( vDate.substring( 6, 10 ), 10 );

        var dtDate = new Date( vYear, vMonth, vDay );

        return dtDate.toUTCString();
    }

    function getPickupDateAndTimeFromBookingId( BookingId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Booking/ViewAllBookings.aspx/GetPickupDateAndTimeFromBookingId",
            data: "{ BookingId: '" + BookingId + "'}",
            async:false,
            success: function ( result )
            {
                $( '#<%=lblPickupDateTime.ClientID%>' ).text( result.d );

                //Get LongDateTime
                <%--var vPickupDateTime = $( '#<%=lblPickupDateTime.ClientID%>' ).text().trim();
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
            url: "/Booking/ViewAllBookings.aspx/GetVATfromBookingId",
            data: "{ BookingId: '" + BookingId + "'}",
            success: function ( result )
            {
                $( '#<%=lblVAT.ClientID%>' ).text( result.d );
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
            url: "/Booking/ViewAllBookings.aspx/GetOrderTotalFromBookingId",
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
            url: "/Booking/ViewAllBookings.aspx/GetOrderStatusFromBookingId",
            data: "{ BookingId: '" + BookingId + "'}",
            success: function ( result )
            {
                $( '#<%=hfOrderStatus.ClientID%>' ).val( result.d );
                var vOrderStatus = $( '#<%=hfOrderStatus.ClientID%>' ).val().trim();

                switch (vOrderStatus)
                {
                    case "Cancelled":
                        $( '#btnEditBooking' ).css( 'display', 'none' );
                        $( '#btnCancelBooking' ).css( 'visibility', 'hidden' );

                        $( '#<%=pPaymentDetails.ClientID%>' ).css( 'display', 'none' );
                        $( '#dvMyPaymentDetails' ).css( 'display', 'none' );
                        break;

                    case "Unpaid":
                        $('#btnEditBooking').css('display', 'block');
                        $('#btnCancelBooking').css('visibility', 'visible');

                        $('#<%=pPaymentDetails.ClientID%>').css('display', 'none');
                        $( '#dvMyPaymentDetails' ).css( 'display', 'none' );
                        break;

                    case "Paid":
                        $('#btnEditBooking').css('display', 'block');
                        $('#btnCancelBooking').css('visibility', 'visible');

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
    }

    function viewBookingDetails( BookingId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Booking/ViewAllBookings.aspx/ViewBookingDetails",
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
            url: "/Booking/ViewAllBookings.aspx/ViewPaymentDetails",
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
</script>

<script>
    function getCustomerIdFromCustomerName(CustomerName)
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerIdFromCustomerName",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerEmailIdFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerDOBFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerAddressFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerPostCodeFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerMobileNoFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerLandlineFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetCustomerHearAboutUsFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetHavingRegisteredCompanyFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetRegisteredCompanyNameFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/GetShippingGoodsInCompanyNameFromCustomerId",
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
            url: "AssignBookingToDriverForDelivery.aspx/CancelBooking",
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
</script>

<script>
    function clearCustomerModalPopup() {
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

    function searchByColor(Status) {
        //alert('Status = ' + Status);
        $("#dtAssignBookingToDriver tbody tr").filter(function () {
            //$('#dtViewBookings').DataTable().search(Status).draw();
            $('#dtAssignBookingToDriver').DataTable().column(8).search(Status).draw();
        });
    }

</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <div class="col-lg-12 text-center welcome-message">
            <h2>
                Assign Booking To Driver For Delivery
            </h2>
            <p></p>
        </div>
        
                    <div class="colorCode colorCode1">
                        <strong>Key</strong>
                        <ul>
                            <li class="orange_box" onclick="searchByColor('U')" data-toggle="tooltip" data-placement="right" title="UNPAID"></li>
                            <li class="green_box" onclick="searchByColor('P')" data-toggle="tooltip" data-placement="right" title="PAID"></li>
                            <li class="red_box" onclick="searchByColor('C')" data-toggle="tooltip" data-placement="right" title="CANCELLED"></li>
                            <li class="white_box" onclick="searchByColor('')" data-toggle="tooltip" data-placement="right" title="Clear Search"></li>
                        </ul>
                    </div>
       
        <div class="col-md-12">
            <div class="hpanel">
                <form id="frmAssignBookingToDriver" runat="server">
                <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                <div class="panel-heading">
                    <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                        style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                        
                    <asp:HiddenField ID="hfDriverId" runat="server" />
                    <asp:HiddenField ID="hfDriverType" runat="server" />
                    <asp:HiddenField ID="hfWageType" runat="server" />
                    <asp:HiddenField ID="hfOrderStatus" runat="server" />
                    <asp:HiddenField ID="hfDriverWage" runat="server" />
                </div>
                <div class="panel-body clrBLK dashboad-form pannel-body-assign-booking">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="row">
                                <div class="form-group"><label class="col-sm-3 control-label">From Date <span style="color: red">*</span></label>
                                    <div class="col-sm-9">
                                        <asp:TextBox ID="txtFromDate" runat="server" CssClass="clrBLK form-control"
                                            ReadOnly="true" onkeypress="clearErrorMessage();"
                                            onchange="checkAssignDate(this.value);"></asp:TextBox>
                                    </div>                                    
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 no_padd">
                            <div class="form-group"><label class="col-sm-3 control-label">To Date <span style="color: red">*</span></label>
                                <div class="col-sm-9">
                                    <asp:TextBox ID="txtToDate" runat="server" CssClass="clrBLK form-control"
                                        ReadOnly="true" onkeypress="clearErrorMessage();"
                                        onchange="checkAssignDate(this.value);"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <%--<div class="row">
                        <div class="form-group"><label class="col-sm-6 control-label">From Date <span style="color: red">*</span></label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="txtFromDate" runat="server" CssClass="clrBLK form-control"
                                    ReadOnly="true" onkeypress="clearErrorMessage();"
                                    onchange="checkAssignDate(this.value);"></asp:TextBox>
                            </div>
                        </div>
                    </div>--%>
                    <%--<div class="row">
                        <div class="form-group"><label class="col-sm-6 control-label">To Date <span style="color: red">*</span></label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="txtToDate" runat="server" CssClass="clrBLK form-control"
                                    ReadOnly="true" onkeypress="clearErrorMessage();"
                                    onchange="checkAssignDate(this.value);"></asp:TextBox>
                            </div>
                        </div>
                    </div>--%>
                    <!--Added new Script Files for Date Picker-->
                    <script src="/js/bootstrap-datepicker.js"></script>
                    <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-sm-12 text-center">
                                <asp:Button ID="btnShowSpecificBooking" runat="server" Text="Show"
                                    CssClass="btn btn-primary btn-register" 
                                    OnClientClick="return showSpecificBookings();" />

                                <asp:Button ID="btnCancelAssignForm" runat="server" Text="Cancel" 
                                    CssClass="btn btn-default"
                                    OnClientClick="location.reload();" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group ">
                            <div class="col-sm-12">
                                <ul class="">
                                    <li>
                                    </li>
                                    <li>
                                    </li>
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
                    <div>
                        <div class="all_span">
                            <span>
                            <input id="cbSelectAll" type="checkbox" name="cbSelectAll" />
                            <label id="lblSelectAll" for="cbSelectAll">Select All</label>
                            </span>
                            <span class="iconADD">
                                <asp:Button ID="btnAssignBookingToDriver" runat="server"  
                                Text="Assign Booking To Driver" OnClientClick="return showAssigningModalDialog();" />
                                <i class="fa fa-user" aria-hidden="true"></i>
                            </span>

                            <span class="iconADD">
                                <asp:Button ID="btnAddDriverToAssignBooking" runat="server"  
                                Text="Add Driver To Assign" 
                                OnClientClick="return gotoAddDriverPage();" />
                                <i class="fa fa-user-plus" aria-hidden="true"></i>
                            </span>
                               
                            <span class="iconADD">
                                <asp:Button ID="btnPrintAssignBookingToDriver" 
                                runat="server" Text="Print Details" 
                                OnClientClick="return takePrintout();" />
                                <i class="fa fa-print" aria-hidden="true"></i>
                            </span>

                            <span class="iconADD ">
                                <asp:Button ID="btnExportPdfBookingDetails" runat="server"  
                                    Text="Export to PDF" OnClick="btnExportPdf_Click" />
                                <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                            </span>

                            <span class="iconADD ">
                                <asp:Button ID="btnExportExcelBookingDetails" runat="server"  
                                Text="Export to Excel" OnClick="btnExportExcel_Click" />
                                <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                            </span>
                        </div>                            


                        <table id="dtAssignBookingToDriver">
                            <thead>
                                <tr>
                                    <th>Select Booking</th>
                                    <th>Booking Id</th>
                                    <th>Customer Name</th>
                                    <th>Delivery DateTime</th>
                                    <th>Delivery Address</th>
                                    <th>Order Status</th>
                                    <th>Post Code</th>
                                    <th>Contact No</th>
                                    <th class="hideColumn">Order Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>

                        <table id="dtAssignBookingToDriver_Check" style="display: none;">
                            <thead>
                                <tr>
                                    <th>Booking Id</th>
                                    <th>Customer Name</th>
                                    <th>Delivery DateTime</th>
                                    <th>Delivery Address</th>
                                    <th>Order Status</th>
                                    <th>Post Code</th>
                                    <th>Contact No</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-12">
                    <hr/>
                    <footer>
                        <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                    </footer>    
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
                <p>All Booking Details assigned to <span id="spDriverName"></span> successfully</p>
                <%--<p><a class="findDriverJoblink">Click here to View Driver Job</a></p>--%>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="getAllUnassignedBookings()">OK</button>
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
                    <asp:Button ID="btnAssignBookingDetailsToDriver" runat="server" Text="Assign Booking Details"
                        CssClass="btn btn-primary btn-register" 
                        OnClientClick="return assignBookingToDriver();" />
                </div>
                <div class="col-sm-6">
                    <asp:Button ID="btnCancelAssignBookingDetails" runat="server" Text="Cancel Assigning" 
                        CssClass="btn btn-default"
                        OnClientClick="location.reload();" />
                </div>
            </div>
        </div>
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
                                onclick="return exportToPDF('dvBooking', 'BookingAllDetails.pdf');" 
                                style="margin-bottom:10px;">
                                <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                            <button id="btnPrintExcelBookingModal" data-dismiss="modal" title="Download as Excel"
                                onclick="return exportToExcel('dvAllBookings','CustomerDetails.xls');" 
                                style="margin-bottom:10px;">
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
    </div>
    </div>
    </div>
      
</div>
</div>

                </form>
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
                    overflow-x: auto; position:relative;">
                    <p><strong>Please find the details of this Customer below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintCustomerModal1" data-dismiss="modal" title="Print Customer Details"
                                    onclick="return printDetails('tblCustomerDetails');" style="margin-bottom:10px;"><i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfCustomerModal1" data-dismiss="modal" title="Download as PDF"
                                    onclick="return exportToPDF('dvCustomerDetailsModal', 'CustomerDetails.pdf');" style="margin-bottom:10px;"><i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelCustomerModal1" data-dismiss="modal" title="Download as Excel"
                                    onclick="return exportToExcel('tblCustomerDetails','CustomerDetails.xls');" style="margin-bottom:10px;"><i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
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
                                                        <th>Post Code:</th>
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

    <div class="modal fade" id="PrintDataTable-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Print - Assign Booking To Driver</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <p>Sure? You want to print this Assign Booking To Driver Details?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return printDataTable();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
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

    <iframe id="txtArea1" style="display:none"></iframe>

</asp:Content>

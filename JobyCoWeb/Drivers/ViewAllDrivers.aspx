<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="ViewAllDrivers.aspx.cs" Inherits="JobyCoWeb.Drivers.ViewAllDrivers"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

<style>
    .SelectCheckBox {

    }

    .pdf, .view, .edit, .delete {
        background:none;
        margin-right: 5px;
        width: 30px;
        height: 30px;
        border: 1px solid #fca311;
        color: #fca311;
    }

    .pdf:hover, .view:hover, .edit:hover, .delete:hover {
        background: #fca311;
        color:#fff;
        text-shadow:1px 1px 1px rgba(0,0,0,0.4);
    }

    #ContentPlaceHolder1_txtDOB {
        padding: 10px 5px;
        border: 1px solid #ccc !important;
        border-radius: 0px;
        margin-bottom: 10px;
        width: 100%;
        box-sizing: border-box;
        color: rgba(255,255,255,0.6);
        font-size: 12px;
        letter-spacing: 1px;
        line-height: 16px;
        background: none;
        display:inline-block;
        height:auto;
    }

    /*.flexible {
        display: flex;
        margin-left: 110px;
        margin-top: 10px;
    }*/

    #cbSelectAll {
        margin-right: 1px;
    }

    #lblSelectAll {
        color: #faa51a;
    }

    .InActive-bg { background: #B51013; }
    .Active-bg {background: #238A35;}

    .Active-bg, .InActive-bg{
        color: #fff;
        text-transform:uppercase;
        padding: 5px 0;
        width: 100%;
        display: block;
        text-align: center;
        cursor: pointer;
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
    });
</script>

<script>
    function changeDriverStatus(vDriverStatus) {
        var DriverId = $('#<%=hfDriverId.ClientID%>').val().trim();
        var Enabled = "false";

        switch (vDriverStatus) {
            case "Active":
                Enabled = "true";
                break;

            case "InActive":
                Enabled = "false";
                break;
        }

        //Binding the values with the Object
        var objDriver = {};
        objDriver.DriverId = DriverId;
        objDriver.Enabled = Enabled;

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllDrivers.aspx/ChangeDriverStatus",
            data: JSON.stringify(objDriver),
            success: function (result) {
                location.reload();
            },
            error: function (response) {
                alert('Unable to change Driver Status');
            }
        });

        return false;
    }

    function makeProperColor(vStatus) {
        switch (vStatus) {
            case "Inactive":
                vStatus = "<span class='InActive-bg'>Inactive</span>";
                break;

            case "Active":
                vStatus = "<span class='Active-bg'>Active</span>";
                break;
        }

        return vStatus;
    }

    function clearErrorMessage() {
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
    }

    function clearAllControls() {
        var vDriverId = $( '#<%=hfDriverId.ClientID%>' );
        var vDriverName = $("#<%=txtDriverName.ClientID%>");
        var vEmailID = $( "#<%=txtEmailID.ClientID%>" );
        var vDOB = $("#<%=txtDOB.ClientID%>");
        var vAddressLine1 = $("#txtAddressLine1");
        var vPostCode = $("#<%=txtPostCode.ClientID%>");
        var vMobile = $( "#txtMobile" );
        var vLandline = $( "#txtLandline" );

        //Driver Type Radio Buttons
        //===============================================================
        var vDirectPayroll = $( '#<%=rbDirectPayroll.ClientID%>' );
        var vThirdPartyPayroll = $( '#<%=rbThirdPartyPayroll.ClientID%>' );
        //===============================================================

        //Wage Type Radio Buttons
        //===============================================================
        var vHourlyBasis = $( '#<%=rbHourlyBasis.ClientID%>' );
        var vMonthlyBasis = $( '#<%=rbMonthlyBasis.ClientID%>' );
        //===============================================================

        clearErrorMessage();

        vDriverId.val('');
        vDriverName.val( '' );
        vEmailID.val( '' );
        vDOB.val( '' );
        vAddressLine1.val( '' );
        vPostCode.val( '' );
        vLandline.val( '' );

        vDirectPayroll.removeAttr( 'checked' );
        vThirdPartyPayroll.removeAttr( 'checked' );

        vHourlyBasis.removeAttr( 'checked' );
        vMonthlyBasis.removeAttr( 'checked' );

        $( '#dvDriverDetails' ).css( 'display', 'none' );
        $( '#dtViewDriver_wrapper' ).css( 'display', 'block' );
        appearAllButtons();

        //Few extra elements to make visible
        $( '.flexible' ).css( 'display', 'block' );
        $( '.iconADD i' ).css( 'display', 'block' );

        return false;
    }

    function checkBlankControls() {
        var vDriverName = $("#<%=txtDriverName.ClientID%>");
        var vEmailID = $("#<%=txtEmailID.ClientID%>");
        var vDOB = $("#<%=txtDOB.ClientID%>");
        var vAddressLine1 = $("#txtAddressLine1");
        var vMobile = $( "#txtMobile" );

        //Driver Type Radio Buttons
        //===============================================================
        var vDirectPayroll = $( '#<%=rbDirectPayroll.ClientID%>' );
        var vThirdPartyPayroll = $( '#<%=rbThirdPartyPayroll.ClientID%>' );
        //===============================================================

        //Wage Type Radio Buttons
        //===============================================================
        var vHourlyBasis = $( '#<%=rbHourlyBasis.ClientID%>' );
        var vMonthlyBasis = $( '#<%=rbMonthlyBasis.ClientID%>' );
        //===============================================================

        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css("text-align", "center");

        if (vDriverName.val().trim() == "") {
            vErrMsg.text('Enter Driver Name');
            vErrMsg.css("display", "block");
            vDriverName.focus();
            return false;
        }

        if ( vEmailID.val().trim() == "" )
        {
            vErrMsg.text( 'Enter Email Address' );
            vErrMsg.css( "display", "block" );
            vEmailID.focus();
            return false;
        }

        if ( !IsEmail( vEmailID.val().trim() ) )
        {
            vErrMsg.text( 'Invalid Email Address' );
            vErrMsg.css( "display", "block" );
            vEmailID.focus();
            return false;
        }

        var DriverDateTime = vDOB.val().trim();
        if ( DriverDateTime == "" )
        {
            vErrMsg.text( 'Enter Date Of Birth' );
            vErrMsg.css( "display", "block" );
            vDOB.focus();
            return false;
        }

        var vCurrentDate = getCurrentDateDetails();

        if ( DriverDateTime != "" && vCurrentDate != "" )
        {
            var dt1 = parseInt( DriverDateTime.substring( 0, 2 ), 10 );
            var mon1 = parseInt( DriverDateTime.substring( 3, 5 ), 10 );
            var yr1 = parseInt( DriverDateTime.substring( 6, 10 ), 10 );

            var dt2 = parseInt( vCurrentDate.substring( 0, 2 ), 10 );
            var mon2 = parseInt( vCurrentDate.substring( 3, 5 ), 10 );
            var yr2 = parseInt( vCurrentDate.substring( 6, 10 ), 10 );

            var From_date = new Date( yr1, mon1, dt1 );
            var To_date = new Date( yr2, mon2, dt2 );
            var diff_date = To_date - From_date;

            var years = Math.floor( diff_date / 31536000000 );
            var months = Math.floor(( diff_date % 31536000000 ) / 2628000000 );
            var days = Math.floor(( ( diff_date % 31536000000 ) % 2628000000 ) / 86400000 );

            //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

            if ( years < 18 )
            {
                vErrMsg.text( 'Driver must be atleast 18 years of age' );
                vErrMsg.css( "display", "block" );
                return false;
            }
            else
            {
                if ( months < 0 )
                {
                    vErrMsg.text( 'Driver must be atleast 18 years of age' );
                    vErrMsg.css( "display", "block" );
                    return false;
                }
                else
                {
                    if ( days < 0 )
                    {
                        vErrMsg.text( 'Driver must be atleast 18 years of age' );
                        vErrMsg.css( "display", "block" );
                        return false;
                    }
                }
            }
        }

        if ( vAddressLine1.val().trim() == "" )
        {
            vErrMsg.text( 'Plese enter Address' );
            vErrMsg.css( "display", "block" );
            vAddressLine1.focus();
            return false;
        }

        if ( vMobile.val().trim() == "" )
        {
            vErrMsg.text('Enter Mobile No');
            vErrMsg.css("display", "block");
            vMobile.focus();
            return false;
        }

        if (vMobile.val().trim().length < 10) {
            vErrMsg.text('Invalid Mobile No');
            vErrMsg.css("display", "block");
            vMobile.focus();
            return false;
        }

        if ( !vDirectPayroll.is( ":checked" )
            && !vThirdPartyPayroll.is( ":checked" ) )
        {
            vErrMsg.text( 'Please choose a Payroll Type of this Driver' );
            vErrMsg.css( "display", "block" );
            return false;
        }

        if ( !vHourlyBasis.is( ":checked" )
            && !vMonthlyBasis.is( ":checked" ) )
        {
            vErrMsg.text( 'Please choose a Wage Type of this Driver' );
            vErrMsg.css( "display", "block" );
            return false;
        }

        return true;
    }

</script>

<script>
    $( document ).ready( function ()
    {
        $( '#dvDriverDetails' ).css( 'display', 'none' );

        getAllDrivers();

        // Change the country selection for Driver Mobile    
        $( "#txtMobile" ).intlTelInput( "setCountry", "gb" );

        // Change the country selection for Driver Mobile    
        $( "#txtLandline" ).intlTelInput( "setCountry", "gb" );

        $( "#cbSelectAll" ).change( function ()
        {
            var tblViewDriver = $( '#dtViewDriver' ).DataTable();

            var allCheckBoxes = $( tblViewDriver.$( 'input[type="checkbox"]' ).map( function ()
            {
                return $( this ).closest( 'tr' );
            } ) );

            for ( var i = 0; i < allCheckBoxes.length; i++ )
            {
                allCheckBoxes[i].find( 'input[type=checkbox]:eq(0)' ).prop( 'checked', $( this ).prop( "checked" ) );

                var vDriverName = allCheckBoxes[i].find( 'td' ).eq( 1 ).text();
                var vDriverPhone = allCheckBoxes[i].find( 'td' ).eq( 2 ).text();
                var vDriverEmail = allCheckBoxes[i].find( 'td' ).eq( 3 ).text();
                var vDriverStatus = allCheckBoxes[i].find( 'td' ).eq( 4 ).text();

                var vViewDriver_Check = "";
                vViewDriver_Check += "<tr>";
                vViewDriver_Check += "<td>" + vDriverName + "</td>";
                vViewDriver_Check += "<td>" + vDriverPhone + "</td>";
                vViewDriver_Check += "<td>" + vDriverEmail + "</td>";
                vViewDriver_Check += "<td>" + vDriverStatus + "</td>";
                vViewDriver_Check += "</tr>";

                if ( $( allCheckBoxes[i].find( 'input[type=checkbox]:eq(0)' ) ).is( ":checked" ) )
                {
                    $( "#dtViewDriver_Check_WithoutDriverId tbody" ).append( vViewDriver_Check );
                }
                else
                {
                    var vCheckDriverName = "";

                    $( '#dtViewDriver_Check_WithoutDriverId tbody > tr' ).each( function ()
                    {
                        vCheckDriverName = $( this ).find( 'td:eq(0)' ).text().trim();
                        if ( vDriverName == vCheckDriverName )
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
    function getAllDrivers()
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllDrivers.aspx/GetAllDrivers",
            contentType: "application/json; charset=utf-8",
            success: function ( data )
            {
                var jsonDriverDetails = JSON.parse( data.d );

                $( '#dtViewDriver' ).DataTable( {
                    data: jsonDriverDetails,
                    columns: [
                        { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
                        { data: "DriverId" },
                        { data: "Name" },
                        { data: "Phone" },
                        { data: "Email" },
                        { data: "WarehouseName" },
                        {
                            data: "Status",
                            render: function (jsonStatus) {
                                return makeProperColor(jsonStatus);
                            }
                        },
                        {
                            defaultContent:
                                "<button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-trash' aria-hidden='true'></i></button>"
                        },
                        { data: "DriverId" }
                    ],
                    "columnDefs": [
                        {
                            "targets": [1],
                            "visible": false,
                            "searchable": false
                        },
                        {
                            targets: [8],
                            className: "hideColumn"
                        }
                    ],
                    "aaSorting": [
                        [1, "desc"]
                    ]
                } );
            },
            error: function ( response )
            {
                alert( 'Unable to Bind All Drivers' );
            }
        } );//end of ajax

        $( '#dtViewDriver tbody' ).on( 'click', '.SelectCheckBox', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            var vIndex = vClosestTr.index();
            var tblViewDriver = $( '#dtViewDriver' ).DataTable();

            var vDriverId = tblViewDriver.column( 1 ).data()[vIndex];
            var vDriverName = vClosestTr.find( 'td' ).eq( 1 ).text();
            var vDriverPhone = vClosestTr.find( 'td' ).eq( 2 ).text();
            var vDriverEmail = vClosestTr.find( 'td' ).eq( 3 ).text();
            var vDriverStatus = vClosestTr.find( 'td' ).eq( 4 ).text();

            var ViewDriver_Check = "";
            ViewDriver_Check += "<tr>";
            ViewDriver_Check += "<td>" + vDriverId + "</td>";
            ViewDriver_Check += "<td>" + vDriverName + "</td>";
            ViewDriver_Check += "<td>" + vDriverPhone + "</td>";
            ViewDriver_Check += "<td>" + vDriverEmail + "</td>";
            ViewDriver_Check += "<td>" + vDriverStatus + "</td>";
            ViewDriver_Check += "</tr>";

            if ( $( this ).is( ":checked" ) )
            {
                $( "#dtViewDriver_Check tbody" ).append( ViewDriver_Check );
            }
            else
            {
                var vCheckDriverId = "";

                $( '#dtViewDriver_Check tbody > tr' ).each( function ()
                {
                    vCheckDriverId = $( this ).find( 'td:eq(0)' ).text().trim();

                    if ( vDriverId == vCheckDriverId )
                    {
                        $( this ).remove();
                    }
                } );
            }
        } );

        $( '#dtViewDriver tbody' ).on( 'click', '.view', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            var vIndex = vClosestTr.index();
            var tblViewDriver = $( '#dtViewDriver' ).DataTable();

            clearDriverModalPopup();

            var vDriverId = tblViewDriver.column(1).data()[vIndex];
            $( '#spHeaderDriverId' ).text( vDriverId );
            $( '#spDriverId' ).text( vDriverId );

            var vDriverName = vClosestTr.find( 'td' ).eq( 1 ).text();
            $( '#spDriverName' ).text( vDriverName );

            var vDriverMobile = vClosestTr.find('td').eq(2).text();
            $('#spDriverMobile').text(vDriverMobile);

            var vDriverEmailID = vClosestTr.find('td').eq(3).text();
            $( '#spDriverEmailID' ).text( vDriverEmailID );

            getDriverDOB( vDriverId );

            $( '#dvDriverDetailsModal' ).modal( 'show' );

            return false;
        } );

        $( '#dtViewDriver tbody' ).on( 'click', '.edit', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            var vIndex = vClosestTr.index();
            var tblViewDriver = $('#dtViewDriver').DataTable();
            var vDriverId = tblViewDriver.column( 1 ).data()[vIndex];

            var vDriverName = vClosestTr.find( 'td' ).eq( 1 ).text();
            var vMobile = vClosestTr.find( 'td' ).eq( 2 ).text();
            var vEmailID = vClosestTr.find( 'td' ).eq( 3 ).text();
            var vStatus = vClosestTr.find( 'td' ).eq( 4 ).text();

            $( '#<%=hfDriverId.ClientID%>' ).val( vDriverId );
            $( '#<%=txtDriverName.ClientID%>' ).val( vDriverName );
            $( '#<%=txtEmailID.ClientID%>' ).val( vEmailID );

            getDriverDOB( vDriverId );

            $( '#txtMobile' ).val( vMobile );

            //Setting Status Value
            //===========================================
            switch ( vStatus )
            {
                case "Inactive":
                    $( '#<%=chkStatus.ClientID%>' ).removeAttr( 'checked' );
                    break;

                case "Active":
                    $( '#<%=chkStatus.ClientID%>' ).attr( 'checked', 'checked' );
                    break;
            }

            //Make appear Edit Details
            //====================================================
            $( '#dvDriverDetails' ).css( 'display', 'block' );
            $( '#dvDriverDetails' ).css( 'margin-left', '100px' );
            //====================================================

            //Make disappear View All Details 
            //=======================================================
            $( '#dtViewDriver_wrapper' ).css( 'display', 'none' );
            disappearAllButtons();
            //=======================================================

            //Few extra elements to invisible
            $( '.flexible' ).css( 'display', 'none' );
            $( '.iconADD i' ).css( 'display', 'none' );

            return false;
        } );

        $( '#dtViewDriver tbody' ).on( 'click', '.delete', function ()
        {
                var vClosestTr = $( this ).closest( "tr" );

                var vIndex = vClosestTr.index();
                var tblViewDriver = $( '#dtViewDriver' ).DataTable();

                var vDriverId = tblViewDriver.column( 1 ).data()[vIndex];

                $( '#<%=hfDriverId.ClientID%>' ).val( vDriverId );
                $( '#DriverRemoval-bx' ).modal( 'show' );

                return false;
        } );

        $( '#dtViewDriver tbody' ).on( 'click', '.Active-bg', function ()
        {
                var vClosestTr = $( this ).closest( "tr" );

                var vIndex = vClosestTr.index();
                var tblViewDriver = $( '#dtViewDriver' ).DataTable();

                var vDriverId = tblViewDriver.column( 1 ).data()[vIndex];

                $( '#<%=hfDriverId.ClientID%>' ).val( vDriverId );
                
                changeDriverStatus('InActive');

                return false;
        } );

        $( '#dtViewDriver tbody' ).on( 'click', '.InActive-bg', function ()
        {
                var vClosestTr = $( this ).closest( "tr" );

                var vIndex = vClosestTr.index();
                var tblViewDriver = $( '#dtViewDriver' ).DataTable();

                var vDriverId = tblViewDriver.column( 1 ).data()[vIndex];

                $( '#<%=hfDriverId.ClientID%>' ).val( vDriverId );
                
                changeDriverStatus('Active');

                return false;
        } );

        return false;
    }
</script>

<script>
    function gotoAddDriverPage()
    {
        location.href = '/Drivers/AddDriver.aspx?PageName=ViewAllDrivers';
        return false;
    }

    function takePrintout()
    {
        var tblViewDriver = $( '#dtViewDriver' ).DataTable();

        var result = $( tblViewDriver.$( 'input[type="checkbox"]' ).map( function ()
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

        if ( $( '#dtViewDriver_Check tbody > tr' ).length > 0 )
        {
            $( '#dtViewDriver_Check' ).css( 'display', 'block' );
            bCheck = 1;
            prtContent = document.getElementById( 'dtViewDriver_Check' );
        }
        else
        {
            $( '#dtViewDriver_Check_WithoutDriverId' ).css( 'display', 'block' );
            bCheck = 0;
            prtContent = document.getElementById( 'dtViewDriver_Check_WithoutDriverId' );
        }

        prtContent.border = 0; //set no border here
        var WinPrint = window.open( '', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1' );
        WinPrint.document.write( prtContent.outerHTML );
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();

        if ( bCheck == 1 )
        {
            $( '#dtViewDriver_Check' ).css( 'display', 'none' );
        }
        else
        {
            $( '#dtViewDriver_Check_WithoutDriverId' ).css( 'display', 'none' );
        }

        return false;
    }


    function printDataTableDriverInfo() {
        $('#PrintDataTable-bx').modal('hide');

        var bCheck = 0;
        var prtContent = "";

        if ($('#dtViewDriver_Check tbody > tr').length > 0) {
            $('#dtViewDriver_Check').css('display', 'block');
            bCheck = 1;
            prtContent = document.getElementById('dtViewDriver_Check');
        }
        else {
            $('#dtViewDriver_Check_WithoutDriverId').css('display', 'block');
            bCheck = 0;
            prtContent = document.getElementById('dtViewDriver_Check_WithoutDriverId');
        }

        // print Content
            
            var PrintContent = "";
            var tempBookingId = "";
            var Count = 0;
            $('#dtViewDriver tbody tr').each(function (i, row) {
                var $actualrow = $(row);
                $checkbox = $actualrow.find(':checkbox:checked');
                Count++;
                if ($checkbox.is(':checked') && !$checkbox.is(':disabled')) {
                    var DriverName = $(this).find('td:eq(1)').text().trim();
                    var DriverPhone = $(this).find('td:eq(2)').text().trim();
                    var DriverEmail = $(this).find('td:eq(3)').text().trim();
                    var DriverStatus = $(this).find('td:eq(4)').text().trim();
                    var vDriverId = $(this).find('td:eq(6)').text().trim();
                    //alert('DriverName = ' + DriverName);
                    //alert('vDriverId = ' + vDriverId + ' DriverName = ' + DriverName);
                   $.ajax({
                       method: "POST",
                       contentType: "application/json; charset=utf-8",
                       url: "ViewAllDrivers.aspx/GetDriverDetailsForPrint",
                       async: false,
                       data: "{ DriverId: '" + vDriverId + "' }",
                       success: function (result) {
                           var jdata = JSON.parse(result.d);
                           //alert(JSON.stringify(jdata));
                           var len = jdata.length;
                           var headerActive = 0;
                           //PrintContent += '<br>'
                           //PrintContent += '<div id="PrintContentDiv">';
                           //PrintContent += '<table border="0"  cellpadding="0" cellspacing="0" id="PrintContentTbl" style="width:100%;page-break-inside: avoid; font-size:16px;">';
                           //PrintContent += '<tr>';
                           //PrintContent += '<th style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">' + DriverName + '</th>';
                           //PrintContent += '<th style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">' + DriverPhone + '</th>';
                           //PrintContent += '<th style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">' + DriverEmail + '</th>';
                           //PrintContent += '<th style="text-align:left; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">' + DriverStatus + '</th>';
                           //PrintContent += '</tr>';
                           //PrintContent += '</table>';

                           for (var j = 0; j < len; j++) {
                               if (tempBookingId == DriverName) {
                                   headerActive = 0;
                               }
                               else
                               {
                                   tempBookingId = DriverName;
                                   headerActive = 1;
                               }
                               if (headerActive > 0)
                               {
                                   PrintContent += '<br>'
                                   PrintContent += '<div id="PrintContentDiv">';
                                   PrintContent += '<table border="0"  cellpadding="0" cellspacing="0" id="PrintContentTbl" style="width:100%;page-break-inside: avoid; font-size:16px;">';
                                   PrintContent += '<tr>';
                                   PrintContent += '<th style="text-align:center; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">' + DriverName + '</th>';
                                   PrintContent += '<th style="text-align:center; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">  ' + DriverPhone + '</th>';
                                   PrintContent += '<th style="text-align:center; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">  ' + DriverEmail + '</th>';
                                   PrintContent += '<th style="text-align:center; vertical-align:top;border-bottom:1px solid #444; border-top:1px solid #444; padding: 5px 0; font-size:18px;">  ' + DriverStatus + '</th></tr>';
                               }
                               else
                               {
                                   PrintContent += '<br><table border="0"  cellpadding="0" cellspacing="0" id="PrintContentTbl" style="width:100%;page-break-inside: avoid; font-size:16px;">';
                               }

                               PrintContent += '<tr>';
                               PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:20%;"><b>' + jdata[j]["PickupDate"] + '</b></td>';

                               PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:30%;"><b>Booking Ref.</b>';
                               PrintContent += '<br>' + jdata[j]["BookingId"];
                               PrintContent += '<br><br><b>Total:</b>';
                               PrintContent += '<br>' + jdata[j]["Wage"];
                               PrintContent += '</td>';
                               PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:30%;">';
                               //Pickup Details
                               PrintContent += '<b>' + jdata[j]["PickupName"] + '</b>';
                               PrintContent += '<br>' + jdata[j]["PickupPhone"];
                               PrintContent += '<br><br><b style="text-decoration: underline;">Pickup Details</b>';
                               PrintContent += '<br>' + jdata[j]["PickupAddress"];
                               PrintContent += '<br>' + jdata[j]["PickupZip"];
                               PrintContent += '<br><br><span style="display: block; border-bottom: 1px dashed #444; height: 1px;"></span><br>';
                               //Delivery Details
                               PrintContent += '<b>' + jdata[j]["DeliveryName"] + '</b>';
                               PrintContent += '<br>' + jdata[j]["DeliveryPhone"];
                               PrintContent += '<br><br><b style="text-decoration: underline;">Delivery Details</b>';
                               PrintContent += '<br>' + jdata[j]["DeliveryAddress"];
                               PrintContent += '<br>' + jdata[j]["DeliveryZip"];

                               PrintContent += '</td>';
                               //alert(jdata[j]["PickupItem"]);
                               //PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:20%;">' + jdata[i]["PickupItem"] + '</td>';
                               PrintContent += '<td style="vertical-align:top; padding: 5px 0; width:20%;"><table border="1" style="width:100%"><tr><td><b>Pickup Items</b></td></tr>';
                               //for (var i = 0; i < len; i++) {
                               PrintContent += '<tr><td>' + jdata[j]["PickupItem"] + '</td></tr>';
                               //}
                               PrintContent += '</table></td>';
                               PrintContent += '</tr>';
                               PrintContent += '</table>';
                               PrintContent += '</div">';
                               PrintContent += '<br><br><span style="display: block; border-bottom: 1px dashed #444; height: 1px;"></span><br>';
                           }
                       },
                       error: function (response) {
                           alert('Unable to Pickup Details For Print');
                       }
                   });
                   
                }
            });
        


        

        var MainWindow = window.open('', '', 'height=800,width=1000');
        MainWindow.document.write('<html><head><title></title>');
        MainWindow.document.write('</head><body onload="window.print();window.close()">');
        MainWindow.document.write(PrintContent);
        MainWindow.document.write('</body></html>');
        MainWindow.document.close();
        setTimeout(function () {
            MainWindow.print();
        }, 500)


        //prtContent.border = 0; //set no border here
        //var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
        //WinPrint.document.write(prtContent.outerHTML);
        //WinPrint.document.close();
        //WinPrint.focus();
        //WinPrint.print();
        //WinPrint.close();

        if (bCheck == 1) {
            $('#dtViewDriver_Check').css('display', 'none');
        }
        else {
            $('#dtViewDriver_Check_WithoutDriverId').css('display', 'none');
        }

        return false;
    }

</script>

<script>
    function reloadAllDrivers()
    {
        //$( '#dvDriverDetails' ).css( 'display', 'none' );

        //$( '#dtViewDriver' ).DataTable().destroy();
        //getAllDrivers();
        //$( '#dtViewDriver_wrapper' ).css( 'display', 'block' );

        location.href = '/Drivers/ViewAllDrivers.aspx';
    }

    function updateDriverDetails()
    {
        //Saving Driver Details First
        var DriverId = $("#<%=hfDriverId.ClientID%>").val().trim();

        var FullName = $("#<%=txtDriverName.ClientID%>").val().trim();
        var Title = "";
        var FirstName = "";
        var LastName = "";

        if (hasWhiteSpace(FullName)) {
            var spaceCount = countWhiteSpace(FullName);
            if (spaceCount == 1) {
                var Names = FullName.split(' ');

                FirstName = Names[0];
                LastName = Names[1];
            }
            if (spaceCount == 2) {
                var Names = FullName.split(' ');

                Title = Names[0];
                FirstName = Names[1];
                LastName = Names[2];
            }
        }
        else
        {
            Title = "";
            FirstName = "";
            LastName = FullName;
        }

        var EmailID = $( "#<%=txtEmailID.ClientID%>" ).val().trim();
        var DOB = $("#<%=txtDOB.ClientID%>").val().trim();
        var Address = $("#txtAddressLine1").val().trim();
        var PostCode = $("#<%=txtPostCode.ClientID%>").val().trim();
        var Mobile = $( "#txtMobile" ).val().trim();
        var Landline = $( "#txtLandline" ).val().trim();

        //Driver Type
        //=================================================================
        var DriverType = "";
        var vDirectPayroll = $("#<%=rbDirectPayroll.ClientID%>");
        var vThirdPartyPayroll = $("#<%=rbThirdPartyPayroll.ClientID%>");

        if (vDirectPayroll.is(":checked")) {
            DriverType = "Direct Payroll";
        }

        if (vThirdPartyPayroll.is(":checked")) {
            DriverType = "Third Party Payroll";
        }

        //Wage Type
        //=================================================================
        var WageType = "";
        var vHourlyBasis = $("#<%=rbHourlyBasis.ClientID%>");
        var vMonthlyBasis = $("#<%=rbMonthlyBasis.ClientID%>");

        if (vHourlyBasis.is(":checked")) {
            WageType = "Hourly Basis";
        }

        if (vMonthlyBasis.is(":checked")) {
            WageType = "Monthly Basis";
        }

        //Set Status Value
        //===============================================
        var chkStatus = $( '#<%=chkStatus.ClientID%>' );
        var Status = "";

        if ( chkStatus.is( ':checked' ) )
        {
            Status = "true";
        }
        else
        {
            Status = "false";
        }
        //===============================================

        //alert( DriverId + '\n'
        
        //    + Title + '\n'
        //    + FirstName + '\n'
        //    + LastName + '\n'

        //    + Mobile + '\n'
        //    + EmailID + '\n'
        //    + Status + '\n'
        //    );

        //Binding Driver Details to object
        var objDriver = {};

        objDriver.DriverId = DriverId;

        objDriver.Title = Title;
        objDriver.FirstName = FirstName;
        objDriver.LastName = LastName;

        objDriver.EmailID = EmailID;
        objDriver.DOB = DOB;

        objDriver.Address = Address;
        objDriver.PostCode = PostCode;

        objDriver.Mobile = Mobile;
        objDriver.Landline = Landline;

        objDriver.DriverType = DriverType;
        objDriver.WageType = WageType;

        objDriver.Status = Status;

        $.ajax({
            type: "POST",
            url: "ViewAllDrivers.aspx/UpdateDriverDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objDriver),
            dataType: "json",
            success: function (result) {
                $( '#spFullName' ).text( FullName + "'s Details updated successfully" );
                $( '#Driver-bx' ).modal( 'show' );
            },
            error: function ( response )
            {
                alert( 'Unable to Update Driver Details' );
            }
        });

        return false;
    }

    function editDriverDetails()
    {
        if ( checkBlankControls() )
        {
            updateDriverDetails();
        }

        return false;
    }

    function deactivateDriver()
    {
        var DriverId = $( '#<%=hfDriverId.ClientID%>' ).val().trim();

        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllDrivers.aspx/DeactivateDriver",
            data: "{ DriverId: '" + DriverId + "'}",
            success: function ( result )
            {
                reloadAllDrivers();
            },
            error: function ( response )
            {
                alert( 'Unable to deactivate Driver Details' );
            }
        } );

        return false;
    }

    function disappearAllButtons()
    {
        $( '#<%=btnAddDriverDetails.ClientID%>' ).css( 'display', 'none' );
        $( '#<%=btnPrintDriverDetails.ClientID%>' ).css( 'display', 'none' );
        $( '#<%=btnExportPdfDriverDetails.ClientID%>' ).css( 'display', 'none' );
        $( '#<%=btnExportExcelDriverDetails.ClientID%>' ).css( 'display', 'none' );

        return false;
    }

    function appearAllButtons()
    {
        $( '#<%=btnAddDriverDetails.ClientID%>' ).css( 'display', 'block' );
        $( '#<%=btnPrintDriverDetails.ClientID%>' ).css( 'display', 'block' );
        $( '#<%=btnExportPdfDriverDetails.ClientID%>' ).css( 'display', 'block' );
        $( '#<%=btnExportExcelDriverDetails.ClientID%>' ).css( 'display', 'block' );

        return false;
    }

</script>

<script>
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

            if ( years < 18 )
            {
                vErrMsg.text( 'Customer must be atleast 18 years of age' );
                vErrMsg.css( "display", "block" );
                return false;
            }
            else
            {
                if ( months < 0 )
                {
                    vErrMsg.text( 'Customer must be atleast 18 years of age' );
                    vErrMsg.css( "display", "block" );
                    return false;
                }
                else
                {
                    if ( days < 0 )
                    {
                        vErrMsg.text( 'Customer must be atleast 18 years of age' );
                        vErrMsg.css( "display", "block" );
                        return false;
                    }
                }
            }
        }
    }

    function convertANSIdateToUK( vDate )
    {
        var vYear = vDate.substr( 0, 4 );
        var vMonth = vDate.substr( 5, 2 );
        var vDay = vDate.substr( 8, 2 );

        return vDay + "-" + vMonth + "-" + vYear;
    }

    function checkAdultDate()
    {
        //Date Checking Added on Text Change
        var vDateOfBirthANSI = $( "#<%=txtDOB.ClientID%>" ).val().trim();
        var vDateOfBirthUK = convertANSIdateToUK( vDateOfBirthANSI );

        var vCurrentDate = getCurrentDateDetails();
        checkFromAndToDate( vDateOfBirthUK, vCurrentDate );
    }

</script>

<script>
        function convertUKdateToANSI( vDate )
        {
            var vDay = vDate.substr( 0, 2 );
            var vMonth = vDate.substr( 3, 2 );
            var vYear = vDate.substr( 6, 4 );

            return vYear + "-" + vMonth + "-" + vDay;
        }
        function convertmmddyyyToyyyymmdd(vDate) {
            var vMonth = vDate.substr(0, 2);
            var vDay = vDate.substr(3, 2);
            var vYear = vDate.substr(6, 4);

            return vYear + "-" + vMonth + "-" + vDay;
        }

        function getDriverDOB( DriverId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllDrivers.aspx/GetDriverDOB",
                data: "{ DriverId: '" + DriverId + "'}",
                success: function ( result )
                {
                    var vDateTime = result.d.toString();
                    var vCutoutDateTime = vDateTime.substring( 0, 10 );
                    $( '#spDriverDOB' ).text( vCutoutDateTime );

                    var vCutOutDateTime = convertmmddyyyToyyyymmdd(vCutoutDateTime)
                    $( '#<%=txtDOB.ClientID%>' ).val( vCutOutDateTime );

                    getDriverAddress( DriverId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Driver DOB' );
                }
            } );
        }

        function getDriverAddress( DriverId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllDrivers.aspx/GetDriverAddress",
                data: "{ DriverId: '" + DriverId + "'}",
                success: function ( result )
                {
                    $( '#txtAddressLine1' ).val( result.d );

                    $( '#spDriverAddress' ).text( result.d );
                    getDriverPostCode( DriverId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Driver Address' );
                }
            } );
        }

        function getDriverPostCode( DriverId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllDrivers.aspx/GetDriverPostCode",
                data: "{ DriverId: '" + DriverId + "'}",
                success: function ( result )
                {
                    $('#<%=txtPostCode.ClientID%>').val(result.d);

                    $( '#spDriverPostCode' ).text( result.d );
                    getDriverLandline( DriverId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Driver PostCode' );
                }
            } );
        }

        function getDriverLandline( DriverId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllDrivers.aspx/GetDriverLandline",
                data: "{ DriverId: '" + DriverId + "'}",
                success: function ( result )
                {
                    $( '#txtLandline' ).val( result.d );

                    $( '#spDriverLandline' ).text( result.d );
                    getDriverPayrollType( DriverId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Driver Landline' );
                }
            } );
        }

        function getDriverPayrollType( DriverId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllDrivers.aspx/GetDriverPayrollType",
                data: "{ DriverId: '" + DriverId + "'}",
                success: function ( result )
                {
                    var vDriverType = result.d.toString();

                    switch ( vDriverType )
                    {
                        case "Third Party Payroll":
                            $( '#<%=rbThirdPartyPayroll.ClientID%>' ).attr( 'checked', 'checked' );
                            break;

                        case "Direct Payroll":
                            $( '#<%=rbDirectPayroll.ClientID%>' ).attr( 'checked', 'checked' );
                            break;
                    }

                    $( '#spDriverType' ).text( vDriverType );
                    getDriverWageType( DriverId );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Driver Payroll Type' );
                }
            } );
        }

        function getDriverWageType( DriverId )
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllDrivers.aspx/GetDriverWageType",
                data: "{ DriverId: '" + DriverId + "'}",
                success: function ( result )
                {
                    var vWageType = result.d.toString();

                    switch ( vWageType )
                    {
                        case "Monthly Basis":
                            $( '#<%=rbMonthlyBasis.ClientID%>' ).attr( 'checked', 'checked' );
                            break;

                        case "Hourly Basis":
                            $( '#<%=rbHourlyBasis.ClientID%>' ).attr( 'checked', 'checked' );
                            break;
                    }

                    $( '#spDriverWageType' ).text( vWageType );
                },
                error: function ( response )
                {
                    alert( 'Unable to get Driver Wage Type' );
                }
            } );
        }
</script>

<script>
    function printDriverDetails()
    {
        var prtContent = document.getElementById( 'tblDriverDetails' );
        prtContent.border = 0; //set no border here

        var WinPrint = window.open( '', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1' );
        WinPrint.document.write( prtContent.outerHTML );
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();

        return false;
    }

    function createPDF()
    {
        var pdf = new jsPDF( 'p', 'pt', 'letter' );
        pdf.canvas.height = 72 * 11;
        pdf.canvas.width = 72 * 8.5;

        var vContent = document.getElementById( "dvDriverDetailsModal" );
        pdf.fromHTML( vContent );

        pdf.save( 'DriverDetails.pdf' );
    }

    function fnExcelReport()
    {
        var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
        var textRange; var j = 0;
        tab = document.getElementById( 'tblDriverDetails' ); // id of table

        for ( j = 0 ; j < tab.rows.length ; j++ )
        {
            tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
            //tab_text=tab_text+"</tr>";
        }

        tab_text = tab_text + "</table>";
        tab_text = tab_text.replace( /<A[^>]*>|<\/A>/g, "" );//remove if u want links in your table
        tab_text = tab_text.replace( /<img[^>]*>/gi, "" ); // remove if u want images in your table
        tab_text = tab_text.replace( /<input[^>]*>|<\/input>/gi, "" ); // reomves input params

        var ua = window.navigator.userAgent;
        var msie = ua.indexOf( "MSIE " );

        if ( msie > 0 || !!navigator.userAgent.match( /Trident.*rv\:11\./ ) )      // If Internet Explorer
        {
            txtArea1.document.open( "txt/html", "replace" );
            txtArea1.document.write( tab_text );
            txtArea1.document.close();
            txtArea1.focus();
            sa = txtArea1.document.execCommand( "SaveAs", true, "DriverDetails.xls" );
        }
        else                 //other browser not tested on IE 11
            sa = window.open( 'data:application/vnd.ms-excel,' + encodeURIComponent( tab_text ) );

        return ( sa );
    }

</script>

<script>
    function clearDriverModalPopup() {
        $('#spDriverId').text('');
        $('#spDriverName').text('');
        $('#spDriverEmailID').text('');
        $('#spDriverDOB').text('');
        $('#spDriverAddress').text('');
        $('#spDriverPostCode').text('');
        $('#spDriverMobile').text('');
        $('#spDriverLandline').text('');
        $('#spDriverType').text('');
        $('#spDriverWageType').text('');

        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    View All Drivers
                </h2>
                <p></p>
            </div>

            <div class="col-lg-12">
                <div class="hpanel">
                    <form id="frmViewDriver" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;margin-left: 90px;" runat="server" Text="" Font-Size="Small"></asp:Label>

                            <asp:HiddenField ID="hfDriverId" runat="server" />                            
                        </div>
                        
                        
                        <div id="dvDriverDetails" class="panel-body clrBLK col-md-12 dashboad-form">

                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Name <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtDriverName" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter Name"
                                                onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Email Address <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtEmailID" runat="server"
                                                CssClass="form-control m-b border-BLK" PlaceHolder="example@gmail.com" 
                                                title="Please enter Email Address" style="text-transform: lowercase;"
                                                MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Date Of Birth <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtDOB" runat="server" CssClass="clrBLK form-control" 
                                             TextMode="Date" MaxLength="10"
                                             onchange="clearErrorMessage();checkAdultDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Address <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                            <input type="text" id="txtAddressLine1" class="form-control" 
                            placeholder="Enter an Address" title="Please enter Address for Driver"
                            onkeypress="clearErrorMessage();" />
                            <div id="CollectionMap"></div>    
                                        </div>
                                    </div>
                                    <br /><br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">House number</label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control m-b"
                                                       PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                                       onkeypress="clearErrorMessage();" style="text-transform: uppercase;"></asp:TextBox>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Mobile (+44) <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                 
                         <input id="txtMobile" class="flag-tel" type="tel" placeholder="Enter Phone Number" 
                             title="Please enter Driver Mobile Number"
                             onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;" />

                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Landline (+44)</label>
                                        <div class="col-sm-8">
                                            <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                 
                         <input id="txtLandline" class="flag-tel" type="tel" placeholder="Enter Driver Landline Number" 
                             title="Please enter Driver Landline Number"
                             onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;" />

                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Driver Type 
                                        <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <div class="row">
                                                <div class="col-md-4">
                                                <label>Direct Payroll &nbsp;<asp:RadioButton 
                                                    ID="rbDirectPayroll" runat="server" 
                                                    GroupName="PayrollType"
                                                    onchange = "clearErrorMessage();" /></label>
                                                </div>

                                                <div class="col-md-4">
                                                <label>3rd Party Payroll &nbsp;
                                                    <asp:RadioButton ID="rbThirdPartyPayroll" runat="server" 
                                                    GroupName="PayrollType"
                                                    onchange = "clearErrorMessage();" /></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Wage Type 
                                        <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <div class="row">
                                                <div class="col-md-4">
                                                <label>Hourly Basis &nbsp;<asp:RadioButton 
                                                    ID="rbHourlyBasis" runat="server" 
                                                    GroupName="WageType"
                                                    onchange = "clearErrorMessage();" /></label>
                                                </div>

                                                <div class="col-md-4">
                                                <label>Monthly Basis &nbsp;
                                                    <asp:RadioButton ID="rbMonthlyBasis" runat="server" 
                                                    GroupName="WageType"
                                                    onchange = "clearErrorMessage();" /></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Status <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:CheckBox ID="chkStatus" runat="server" />
                                        </div>                        
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8">
                                                <asp:Button ID="btnUpdateDriver" runat="server" Text="Update"
                                                    CssClass="btn btn-primary btn-register" 
                                                    OnClientClick="return editDriverDetails();" />
                                                <asp:Button ID="btnCancelUpdateDelete" runat="server" Text="Cancel" class="btn btn-default"
                                                OnClientClick="return clearAllControls();" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                       
                        
                        <div class="panel-body box_bg">
                            <div class="row">
                                <div class="col-md-12">
                            <div class="row">
                            <div class="col-md-2 col-sm-2 col-xs-12">
                                <span class="flexible">
                                    <input id="cbSelectAll" type="checkbox" name="cbSelectAll" />
                                    <label id="lblSelectAll" for="cbSelectAll">Select All</label>
                                </span>                            
                            </div>
                            <div class="col-md-10 col-sm-10 col-sm-12 pull-right">
                                <span class="iconADD">
                                    <asp:Button ID="btnPrintDriverDetails" runat="server"  
                                        Text="Print Driver" OnClientClick="return takePrintout();" />
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </span>

                                <span class="iconADD">
                                    <asp:Button ID="btnAddDriverDetails" runat="server"  
                                    Text="Add Driver" OnClientClick="return gotoAddDriverPage();" />
                                    <i class="fa fa-user" aria-hidden="true"></i>
                                </span>
                           
                                <span class="iconADD">
                                    <asp:Button ID="btnExportExcelDriverDetails" runat="server"  
                                    Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </span>

                                <span class="iconADD ">
                                    <asp:Button ID="btnExportPdfDriverDetails" runat="server"  
                                        Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </span>
                            </div>
                            </div>
                        </div>
                            </div>
                            <div class="tble_main">
                            <table id="dtViewDriver">
                                <thead>
                                    <tr>
                                        <th>Select Driver</th>
                                        <th>Driver Id</th>
                                        <th>Name</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Warehouse Name</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                        <th class="hideColumn">Driver Id</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            </div>
                            <table id="dtViewDriver_Check" style="display: none;">
                                <thead>
                                    <tr>
                                        <th>Driver Id</th>
                                        <th>Name</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Warehouse Name</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                            <table id="dtViewDriver_Check_WithoutDriverId" style="display: none;">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                        </div>

                        <div class="col-md-12">
                            <hr id="dtViewDriver_hr" />
                            <footer>
                                <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                            </footer>    
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
                <h4 class="modal-title" style="font-size:24px;color:#111;">Print - Driver Details</h4>
            </div>
            <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                <p>Sure? You want to print these Driver Details?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return printDataTableDriverInfo('');">Yes</button>
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
            <h4 class="modal-title" style="font-size:24px;color:#111;">Printing Not Possible</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
            <p>Please choose a Driver from the list</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-warning" data-dismiss="modal">OK</button>
        </div>
        </div>
      
    </div>
</div>

  <div class="modal fade" id="Driver-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Driver Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spFullName"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return reloadAllDrivers();">OK</button>
        </div>
      </div>
      
    </div>
  </div>

  <div class="modal fade" id="DriverRemoval-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Driver Removal</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p>Sure? You want to remove this Driver's Details?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return deactivateDriver();">Yes</button>
          <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="">No</button>
        </div>
      </div>
      
    </div>
  </div>

    <div class="modal fade" id="dvDriverDetailsModal" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Driver Information: #<span id="spHeaderDriverId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Driver below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintDriverModal" data-dismiss="modal" 
                                    onclick="return printDriverDetails();" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfDriverModal" data-dismiss="modal" 
                                    onclick="createPDF();" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelDriverModal" data-dismiss="modal" 
                                    onclick="fnExcelReport();" style="margin-bottom:10px;">
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
                                                        <th>Driver Id: </th>
                                                        <td><span id="spDriverId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Driver Name: </th>
                                                        <td><span id="spDriverName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Email ID: </th>
                                                        <td><span id="spDriverEmailID"></span></td>
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
                                                        <th>Landline: </th>
                                                        <td><span id="spDriverLandline"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Payroll Type: </th>
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

</asp:Content>

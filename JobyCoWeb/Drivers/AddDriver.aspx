<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
   CodeBehind="AddDriver.aspx.cs" Inherits="JobyCoWeb.Drivers.AddDriver"
   EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />

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
    $(document).ready(function () {

        // Change the country selection for Driver Mobile    
        $("#txtMobile").intlTelInput("setCountry", "gb");

        // Change the country selection for Driver Mobile    
        $( "#txtLandline" ).intlTelInput( "setCountry", "gb" );

        $( '#<%=txtDOB.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

        getAllWarehouse();
    });
</script>

<script>

    function getAllWarehouse()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Users/NewUser.aspx/GetAllWarehouse",
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


        function checkBlankControls() {
            var EmailID = $( "#<%=txtEmailID.ClientID%>" );
            var vEmailID = EmailID.val().trim();

            var Password = $("#<%=txtPassword.ClientID%>");
            var vPassword = Password.val().trim();

            var DriverName = $( "#<%=txtDriverName.ClientID%>" );
            var vDriverName = DriverName.val().trim();

            var DOB = $( "#<%=txtDOB.ClientID%>" );
            var vDOB = DOB.val().trim();

            var AddressLine1 = $("#<%=txtAddressLine1.ClientID%>");
            var vAddressLine1 = AddressLine1.val().trim();

            var Mobile = $("#txtMobile");
            var vMobile = Mobile.val().trim();

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

            var vWarehouseId = $("#<%=ddlWarehouse.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vEmailID == "") {
                vErrMsg.text('Enter Email Address');
                vErrMsg.css("display", "block");
                EmailID.focus();
                return false;
            }

            if (!IsEmail(vEmailID)) {
                vErrMsg.text('Invalid Email Address');
                vErrMsg.css("display", "block");
                EmailID.focus();
                return false;
            }

            if (vPassword == "") {
                vErrMsg.text('Enter Password');
                vErrMsg.css("display", "block");
                Password.focus();
                return false;
            }

            if ( vPassword.length < 6 )
            {
                vErrMsg.text( 'Password should be minimum of 6 Characters' );
                vErrMsg.css( "display", "block" );
                Password.focus();
                return false;
            }

            if ( vPassword.length > 14 )
            {
                vErrMsg.text( 'Password should be maximum of 14 characters' );
                vErrMsg.css( "display", "block" );
                Password.focus();
                return false;
            }

            if ( vDriverName == "" )
            {
                vErrMsg.text('Enter Driver Name');
                vErrMsg.css("display", "block");
                DriverName.focus();
                return false;
            }

            if (vDOB == "") {
                vErrMsg.text('Enter Date Of Birth');
                vErrMsg.css("display", "block");
                DOB.focus();
                return false;
            }

            var vCurrentDate = getCurrentDateDetails();
            var DriverDateTime = vDOB;

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

            if ( vAddressLine1 == "" )
            {
                vErrMsg.text( 'Plese enter Address' );
                vErrMsg.css( "display", "block" );
                AddressLine1.focus();
                return false;
            }

            if ( vMobile == "" )
            {
                vErrMsg.text('Enter Mobile No');
                vErrMsg.css("display", "block");
                Mobile.focus();
                return false;
            }

            if (vMobile.length < 10) {
                vErrMsg.text('Invalid Mobile No');
                vErrMsg.css("display", "block");
                Mobile.focus();
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

            if (vWarehouseId.val().trim() == "Select Warehouse") {
                vErrMsg.text('Please select a Warehouse from dropdown');
                vErrMsg.css("display", "block");
                vWarehouseId.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");

            var vDriverName = $("#<%=txtDriverName.ClientID%>");
            var vDOB = $("#<%=txtDOB.ClientID%>");

            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");
            var vPostCode = $( "#<%=txtPostCode.ClientID%>" );

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

            var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            vEmailID.val('');
            vPassword.val('');

            vDriverName.val('');
            vDOB.val( '' );

            vAddressLine1.val( '' );
            vPostCode.val('');

            vMobile.val( '' );
            vLandline.val( '' );

            vDirectPayroll.removeAttr( 'checked' );
            vThirdPartyPayroll.removeAttr( 'checked' );

            vHourlyBasis.removeAttr( 'checked' );
            vMonthlyBasis.removeAttr( 'checked' );

            var vPageName = $( '#<%=hfPageName.ClientID%>' ).val().trim();
            if ( vPageName != "" )
            {
                switch ( vPageName )
                {
                    case "ViewAllDrivers":
                        location.href = "/Drivers/" + vPageName + ".aspx";
                        break;
                    
                    case "AssignBookingToDriver":
                        location.href = "/Booking/" + vPageName + ".aspx";
                        break;
                }
            }

            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
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
    }

    function checkAdultDate()
    {
        //Date Checking Added on Text Change
        var vDateOfBirth = $( "#<%=txtDOB.ClientID%>" ).val().trim();
        var vCurrentDate = getCurrentDateDetails();
        checkFromAndToDate( vDateOfBirth, vCurrentDate );
    }

</script>

<script>
    function getDriverId() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddDriver.aspx/GetDriverId",
            data: "{}",
            dataType: "json",
            async:false,
            success: function (result) {
                $("#<%=hfDriverId.ClientID%>").val(result.d);
            },
            error: function (response) {
            }
        });
    }

    function checkEmailID( EmailID )
    {
        var Error = true;

        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css("text-align", "center");

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddDriver.aspx/checkEmailID",
            data: "{ EmailID: '" + EmailID + "'}",
            dataType: "json",
            async : false,
            success: function (result) {
                $( "#<%=hfDriverIdFromEmailId.ClientID%>" ).val( result.d );   
                
                if (result.d == "True") {
                    vErrMsg.text('This Email Address already Exists. Try another');
                    vErrMsg.css("display", "block");
                    $("#<%=txtEmailID.ClientID%>").focus();
                    Error = false;
                }
                else {
                    Error = true;
                }
            },
            error: function (response) {
            }
        } );

        return Error;
    }
            
    function addDriverDetails() {
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#f9edef");
        vErrMsg.css("color", "red");
        getDriverId();
        //Saving Driver Details First
        var DriverId = $("#<%=hfDriverId.ClientID%>").val().trim();
        var EmailID = $("#<%=txtEmailID.ClientID%>").val().trim().toLowerCase();
        var Password = $("#<%=txtPassword.ClientID%>").val().trim();
        var WarehouseId = $("#<%=ddlWarehouse.ClientID%>").find('option:selected').val().trim();

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

        var DOB = $("#<%=txtDOB.ClientID%>").val().trim();
        var Address = $("#<%=txtAddressLine1.ClientID%>").val().trim();

        var Town = "";
        var Country = "";
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

        var Enabled = "true";

        //Binding Driver Details to object
        var objDriver = {};

        objDriver.DriverId = DriverId;
        objDriver.EmailID = EmailID;
        objDriver.Password = Password;

        objDriver.Title = Title;
        objDriver.FirstName = FirstName;
        objDriver.LastName = LastName;

        objDriver.DOB = DOB;

        objDriver.Address = Address;
        objDriver.Town = Town;
        objDriver.Country = Country;
        objDriver.PostCode = PostCode;

        objDriver.Mobile = Mobile;
        objDriver.Landline = Landline;

        //Two New Fields Added
        //===========================
        objDriver.DriverType = DriverType;
        objDriver.WageType = WageType;
        objDriver.WarehouseId = WarehouseId;
        //===========================

        objDriver.Enabled = Enabled;

        $.ajax({
            type: "POST",
            url: "AddDriver.aspx/AddDriverDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objDriver),
            dataType: "json",
            success: function (result) {
                clearErrorMessage();
                $( '#spFullName' ).text( FullName );
                $( '#Driver-bx' ).modal( 'show' );
            },
            error: function ( response )
            {
                alert( 'Driver Details could not be added' );
            }
        });

        return false;
    }

    function saveDriverDetails()
    {
        var EmailID = $("#<%=txtEmailID.ClientID%>");
        var vEmailID = EmailID.val().trim();
        
        if ( checkEmailID( vEmailID ) )
        {
            if ( checkBlankControls() )
            {
                addDriverDetails();
            }
        }

        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    Add Driver
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmDriver" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <asp:HiddenField ID="hfDriverId" runat="server" />
                    <asp:HiddenField ID="hfDriverIdFromEmailId" runat="server" />
                    
                    <!-- New Hidden Field for Redirection to Proper Page-->                    
                    <asp:HiddenField ID="hfPageName" runat="server" />

                    <div class="panel-heading err-hd">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                    </div>

                    <div class="panel-body clrBLK col-md-12 dashboad-form">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Email Address <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtEmailID" runat="server"
                                            CssClass="form-control m-b border-BLK" PlaceHolder="example@gmail.com" 
                                            title="Please enter Email Address" style="text-transform: lowercase;"
                                            MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                    </div>                        
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Password <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                            CssClass="form-control m-b" PlaceHolder="******" title="Please enter Password"
                                                MaxLength="50" onkeypress="clearErrorMessage();" 
                                            ></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Name <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtDriverName" runat="server" MaxLength="50"
                                            CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter Name"
                                            onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>                            
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Date Of Birth <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtDOB" runat="server" CssClass="clrBLK form-control"
                                            ReadOnly="true" onchange="clearErrorMessage();checkAdultDate();"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group"><label class="col-sm-4 control-label">Address <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtAddressLine1" Style="background:none !important" runat="server" TextMode="MultiLine"
                                        CssClass="form-control"  PlaceHolder="Enter an Address" title="Please enter Address for Driver"
                                        onkeypress="clearErrorMessage();"></asp:TextBox>

                                        <%--<input type="text" id="txtAddressLine1" class="form-control" 
                                        placeholder="Enter an Address" title="Please enter Address for Driver"
                                        onkeypress="clearErrorMessage();" />--%>
                                        <div id="CollectionMap"></div>    
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group"><label class="col-sm-4 control-label">House number</label>
                                    <div class="col-sm-8">
                                            <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control m-b"
                                                   PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                                   onkeypress="clearErrorMessage();" style="text-transform: uppercase;"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Mobile (+44) <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                 
                     <input id="txtMobile" class="flag-tel" type="tel" placeholder="Enter Driver Mobile Number" 
                         title="Please enter Driver Mobile Number" maxlength ="13"
                         onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Landline (+44)</label>
                                    <div class="col-sm-8">
                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                 
                     <input id="txtLandline" class="flag-tel" type="tel" placeholder="Enter Driver Landline Number" 
                         title="Please enter Driver Landline Number"
                         onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Driver Type 
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
                            <div class="col-sm-12">
                                <div class="row form-group marginbottom">
                                    <label class="col-sm-4 control-label">Wage Type 
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
                            <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                         Select Location<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:DropDownList ID="ddlWarehouse" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Warehouse from dropdown"
                                                    onchange="getSpecificWarehouseDetails(this.value); clearErrorMessage();">
                                                    <asp:ListItem>Select Role</asp:ListItem>
                                                </asp:DropDownList>                        
                                        </div>
                                    </div>
                                </div>
                        </div>
                        
                        <!--Added new Script Files for Date Picker-->
                        <script src="/js/bootstrap-datepicker.js"></script>
                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                        

                        <div class="form-group">
                            <div class="col-sm-12 text-center">
                                <asp:Button ID="btnRegisterDriver" runat="server" Text="Register"
                                    CssClass="btn btn-primary btn-register" 
                                    OnClientClick="return saveDriverDetails();" />
                                    <asp:Button ID="btnCancelDriver" runat="server" Text="Cancel" class="btn btn-default"
                                    OnClientClick="return clearAllControls();" />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <hr/>
                        <footer>
                            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                        </footer>    
                    </div>

                    </form>
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
          <p><span id="spFullName"></span>'s Details added successfully</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" 
              onclick="location.href='/Drivers/ViewAllDrivers.aspx';">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="NewUser.aspx.cs" Inherits="JobyCoWeb.Users.NewUser"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>

<style>
    .no-check {

    }
    .yes-check {

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


        //$("#dtUserRoles").wrapAll("<div class="tabl_outer"><div>");
    });
</script>

<script>
        function checkBlankControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vConfirmEmailID = $("#<%=txtConfirmEmailID.ClientID%>");

            var vPassword = $("#<%=txtPassword.ClientID%>");
            var vConfirmPassword = $("#<%=txtConfirmPassword.ClientID%>");

            var vTitle = $("#<%=ddlTitle.ClientID%>");
            var vFirstName = $("#<%=txtFirstName.ClientID%>");
            var vLastName = $("#<%=txtLastName.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");

            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");
            var vAddressLine2 = $("#<%=txtAddressLine2.ClientID%>");
            var vAddressLine3 = $("#<%=txtAddressLine3.ClientID%>");

            var vTown = $("#<%=txtTown.ClientID%>");
            var vCountry = $("#<%=ddlCountry.ClientID%>");
            var vPostCode = $("#<%=txtPostCode.ClientID%>");

            var vMobile = $("#<%=txtMobile.ClientID%>");
            var vTelephone = $("#<%=txtTelephone.ClientID%>");

            //var vSecretQuestion = $("#<%//=txtSecretQuestion.ClientID%>");
            //var vSecretAnswer = $("#<%//=txtSecretAnswer.ClientID%>");

            var vUserRole = $("#<%=ddlUserRole.ClientID%>");

            var vWarehouseId = $("#<%=ddlWarehouse.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vEmailID.val().trim() == "") {
                vErrMsg.text('Enter Email Address');
                vErrMsg.css("display", "block");
                vEmailID.focus();
                return false;
            }

            if (!IsEmail(vEmailID.val().trim())) {
                vErrMsg.text('Invalid Email Address');
                vErrMsg.css("display", "block");
                vEmailID.focus();
                return false;
            }

            //if (vConfirmEmailID.val().trim() == "") {
            //    vErrMsg.text('Confirm Email Address');
            //    vErrMsg.css("display", "block");
            //    vConfirmEmailID.focus();
            //    return false;
            //}

            //if (!IsEmail(vConfirmEmailID.val().trim())) {
            //    vErrMsg.text('Invalid Email Address');
            //    vErrMsg.css("display", "block");
            //    vConfirmEmailID.focus();
            //    return false;
            //}

            //if (vEmailID.val().trim() != vConfirmEmailID.val().trim()) {
            //    $( '#hHeader' ).text( 'Error: Email Mismatch' );
            //    $( '#pBody' ).text( 'Email Address and Confirm Email Address must match' );
            //    $( '#User-bx' ).modal( 'show' );

            //    return false;
            //}

            if (vPassword.val().trim() == "") {
                vErrMsg.text('Enter Password');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            var vPasswordLength = vPassword.val().trim().length;
            if ( vPasswordLength > 0 && vPasswordLength < 6 )
            {
                vErrMsg.text( 'Password should be minimum of 6 and maximum of 14 characters' );
                vErrMsg.css( "display", "block" );
                vPassword.focus();
                return false;
            }

            if ( vPasswordLength > 14 )
            {
                vErrMsg.text( 'Password should be minimum of 6 and maximum of 14 characters' );
                vErrMsg.css( "display", "block" );
                vPassword.focus();
                return false;
            }

            //if (!vPassword.val().trim().match(/[a-z]/)) {
            //    vErrMsg.text('Password should contain atleast 1 Alphabet');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            //if (!vPassword.val().trim().match(/[A-Z]/)) {
            //    vErrMsg.text('Password should contain atleast 1 Capital Letter');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            //if (!vPassword.val().trim().match(/\d/)) {
            //    vErrMsg.text('Password should contain atleast 1 Number');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            //if (vConfirmPassword.val().trim() == "") {
            //    vErrMsg.text('Confirm Password');
            //    vErrMsg.css("display", "block");
            //    vConfirmPassword.focus();
            //    return false;
            //}

            //if (vPassword.val().trim() != vConfirmPassword.val().trim()) {

            //    $( '#hHeader' ).text( 'Error: Password Mismatch' );
            //    $( '#pBody' ).text( 'Password and Confirm Password must match' );
            //    $( '#User-bx' ).modal( 'show' );

            //    return false;
            //}

            //if (vTitle.val().trim() == "Select Title") {
            //    vErrMsg.text('Please select a title from dropdown');
            //    vErrMsg.css("display", "block");
            //    vTitle.focus();
            //    return false;
            //}

            if (vFirstName.val().trim() == "") {
                vErrMsg.text('Enter First Name');
                vErrMsg.css("display", "block");
                vFirstName.focus();
                return false;
            }

            if (vLastName.val().trim() == "") {
                vErrMsg.text('Enter Last Name');
                vErrMsg.css("display", "block");
                vLastName.focus();
                return false;
            }

            if (vDOB.val().trim() == "") {
                vErrMsg.text('Enter Date Of Birth');
                vErrMsg.css("display", "block");
                vDOB.focus();
                return false;
            }

            var vCurrentDate = getCurrentDateDetails();

            if ( vDOB.val().trim() != "" && vCurrentDate != "" )
            {
                var dt1 = parseInt( vDOB.val().trim().substring( 0, 2 ), 10 );
                var mon1 = parseInt( vDOB.val().trim().substring( 3, 5 ), 10 );
                var yr1 = parseInt( vDOB.val().trim().substring( 6, 10 ), 10 );

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
                    vErrMsg.text( 'User must be atleast 18 years of age' );
                    vErrMsg.css( "display", "block" );
                    return false;
                }
                else
                {
                    if ( months < 0 )
                    {
                        vErrMsg.text( 'User must be atleast 18 years of age' );
                        vErrMsg.css( "display", "block" );
                        return false;
                    }
                    else
                    {
                        if ( days < 0 )
                        {
                            vErrMsg.text( 'User must be atleast 18 years of age' );
                            vErrMsg.css( "display", "block" );
                            return false;
                        }
                    }
                }
            }

            if ( vAddressLine1.val().trim() == "" )
            {
                vErrMsg.text('Enter Address Line 1 atleast');
                vErrMsg.css("display", "block");
                vAddressLine1.focus();
                return false;
            }

            //if (vTown.val().trim() == "") {
            //    vErrMsg.text('Enter Town');
            //    vErrMsg.css("display", "block");
            //    vTown.focus();
            //    return false;
            //}

            if (vCountry.val().trim() == "Select Country") {
                vErrMsg.text('Please select a country from dropdown');
                vErrMsg.css("display", "block");
                vCountry.focus();
                return false;
            }

            //if (vPostCode.val().trim() == "") {
            //    vErrMsg.text('Enter PostCode');
            //    vErrMsg.css("display", "block");
            //    vPostCode.focus();
            //    return false;
            //}

            if (vMobile.val().trim() == "") {
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

            //if (vTelephone.val().trim() == "") {
            //    vErrMsg.text('Enter Telephone No');
            //    vErrMsg.css("display", "block");
            //    vTelephone.focus();
            //    return false;
            //}

            //if (vTelephone.val().trim().length < 11) {
            //    vErrMsg.text('Invalid Telephone No');
            //    vErrMsg.css("display", "block");
            //    vTelephone.focus();
            //    return false;
            //}

            //if (vSecretQuestion.val().trim() == "") {
            //    vErrMsg.text('Enter Secret Question');
            //    vErrMsg.css("display", "block");
            //    vSecretQuestion.focus();
            //    return false;
            //}

            //if (vSecretAnswer.val().trim() == "") {
            //    vErrMsg.text('Enter Secret Answer');
            //    vErrMsg.css("display", "block");
            //    vSecretAnswer.focus();
            //    return false;
            //}

            if (vUserRole.val().trim() == "Select Role") {
                vErrMsg.text('Please select a User Role from dropdown');
                vErrMsg.css("display", "block");
                vUserRole.focus();
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
            var vConfirmEmailID = $("#<%=txtConfirmEmailID.ClientID%>");

            var vPassword = $("#<%=txtPassword.ClientID%>");
            var vConfirmPassword = $("#<%=txtConfirmPassword.ClientID%>");

            var vTitle = $("#<%=ddlTitle.ClientID%>");
            var vFirstName = $("#<%=txtFirstName.ClientID%>");
            var vLastName = $("#<%=txtLastName.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");

            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");
            var vAddressLine2 = $("#<%=txtAddressLine2.ClientID%>");
            var vAddressLine3 = $("#<%=txtAddressLine3.ClientID%>");

            var vTown = $("#<%=txtTown.ClientID%>");
            var vCountry = $("#<%=ddlCountry.ClientID%>");
            var vPostCode = $("#<%=txtPostCode.ClientID%>");

            var vMobile = $("#<%=txtMobile.ClientID%>");
            var vTelephone = $("#<%=txtTelephone.ClientID%>");

            //var vSecretQuestion = $("#<%//=txtSecretQuestion.ClientID%>");
            //var vSecretAnswer = //$("#<%//=txtSecretAnswer.ClientID%>");

            var vUserRole = $("#<%=ddlUserRole.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            vEmailID.val('');
            vConfirmEmailID.val('');

            vPassword.val('');
            vConfirmPassword.val('');

            vTitle.val('Select Title');
            vFirstName.val('');
            vLastName.val('');

            vDOB.val('');

            vAddressLine1.val('');
            vAddressLine2.val('');
            vAddressLine3.val('');

            vTown.val('');
            vCountry.val('Select Country');
            vPostCode.val('');

            vMobile.val('');
            vTelephone.val('');

            //vSecretQuestion.val('');
            //vSecretAnswer.val('');

            vUserRole.val('Select Role');

            location.href = "/Users/ViewAllUsers.aspx";
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
                vErrMsg.text( 'User must be atleast 18 years of age' );
                vErrMsg.css( "display", "block" );
                return false;
            }
            else
            {
                if ( months < 0 )
                {
                    vErrMsg.text( 'User must be atleast 18 years of age' );
                    vErrMsg.css( "display", "block" );
                    return false;
                }
                else
                {
                    if ( days < 0 )
                    {
                        vErrMsg.text( 'User must be atleast 18 years of age' );
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
    $( document ).ready( function ()
    {
        
        getAllTitles();
        getAllCountries();
        getAllRoles();
        getAllWarehouse();

        $('#<%=txtDOB.ClientID%>').datepicker({
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });
    } );
</script>

<script>
    function getLatestUserId()
    {
        $.ajax( {
            type: "POST",
            url: "NewUser.aspx/GetLatestUserId",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function ( result )
            {
                $( '#<%=hfUserId.ClientID%>').val( result.d );
            },
            error: function ( response )
            {
            }
        } );
    }

    function getAllTitles()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/GetAllTitles",
            data: "{}",
            dataType: "json",
            success: function ( data )
            {
                $.each( data.d, function ( key, value )
                {
                    $( "#<%=ddlTitle.ClientID%>" ).append( $( "<option></option>" ).val( value.ItemId ).html( value.ItemValue ) );
                } )
            },
            error: function ( response )
            {
            }
        } );
    }

    function getAllCountries()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/GetAllCountries",
            data: "{}",
            dataType: "json",
            success: function ( data )
            {
                $.each( data.d, function ( key, value )
                {
                    $( "#<%=ddlCountry.ClientID%>" ).append( $( "<option></option>" ).val( value.ItemId ).html( value.ItemValue ) );
                } )
            },
            error: function ( response )
            {
            }
        } );
    }

    function getAllRoles()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/GetAllRoles",
            data: "{}",
            dataType: "json",
            success: function ( data )
            {
                $.each( data.d, function ( key, value )
                {
                    if (value.ItemValue != 'Customer') {
                      $( "#<%=ddlUserRole.ClientID%>" ).append( $( "<option></option>" ).val( value.ItemId ).html( value.ItemValue ) );
                    }
                } )
            },
            error: function ( response )
            {
            }
        } );
    }


    function getAllWarehouse()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/GetAllWarehouse",
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

<script>
    function addUserDetails()
    {
        getLatestUserId();

        var UserId = $( '#<%=hfUserId.ClientID%>' ).val().trim();
        var EmailID = $( "#<%=txtEmailID.ClientID%>" ).val().trim();
        var Password = $( "#<%=txtPassword.ClientID%>" ).val().trim();

        var bExists = false;
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/CheckUserId",
            data: "{ EmailID: '" + EmailID + "'}",
            dataType: "json",
            success: function ( result )
            {
                if ( result.d.toString() == "true" )
                {
                    $( '#hHeader' ).text( 'Existence detected' );
                    $( '#pBody' ).text( 'This User already exists..Try another..' );

                    $( '#User-bx' ).modal( 'show' );

                    bExists = true;

                    return false;
                }
                else
                {
                    bExists = false;

                    var Title = $( "#<%=ddlTitle.ClientID%>" ).find( 'option:selected' ).text().trim();
                    Title = '';
                    var FirstName = $("#<%=txtFirstName.ClientID%>").val().trim();
                    var LastName = $( "#<%=txtLastName.ClientID%>" ).val().trim();

                    var DOB = $( "#<%=txtDOB.ClientID%>" ).val().trim();

                    var AddressLine1 = $( "#<%=txtAddressLine1.ClientID%>" ).val().trim();
                    var AddressLine2 = $( "#<%=txtAddressLine2.ClientID%>" ).val().trim();
                    var AddressLine3 = $( "#<%=txtAddressLine3.ClientID%>" ).val().trim();

                    var Address = AddressLine1 + ', ' + AddressLine2 + ', ' + AddressLine3;

                    var Town = $( "#<%=txtTown.ClientID%>" ).val().trim();
                    var Country = $( "#<%=ddlCountry.ClientID%>" ).find('option:selected').text().trim();
                    var PostCode = $( "#<%=txtPostCode.ClientID%>" ).val().trim();

                    var Mobile = $( "#<%=txtMobile.ClientID%>" ).val().trim();
                    var Telephone = $( "#<%=txtTelephone.ClientID%>" ).val().trim();

                    var SecretQuestion = ""; //$( "#<%//=txtSecretQuestion.ClientID%>" ).val().trim();
                    var SecretAnswer = ""; //$( "#<%//=txtSecretAnswer.ClientID%>" ).val().trim();
        
                    var UserRole = $("#<%=ddlUserRole.ClientID%>").find('option:selected').text().trim();
                    var WarehouseId = $("#<%=ddlWarehouse.ClientID%>").find('option:selected').val().trim();

                    var Locked = "false";

                    var objUser = {};

                    objUser.UserId = UserId;
                    objUser.EmailID = EmailID.toLowerCase();
                    objUser.Password = Password;
                    objUser.Title = Title;
                    objUser.FirstName = FirstName;
                    objUser.LastName = LastName;
                    objUser.DOB = DOB;
                    objUser.Address = Address;
                    objUser.Town = Town;
                    objUser.Country = Country;
                    objUser.PostCode = PostCode;
                    objUser.Mobile = Mobile;
                    objUser.Telephone = Telephone;
                    objUser.SecretQuestion = SecretQuestion;
                    objUser.SecretAnswer = SecretAnswer;
                    objUser.UserRole = UserRole;
                    objUser.WarehouseId = WarehouseId;
                    objUser.Locked = Locked;

                    $.ajax( {
                        type: "POST",
                        url: "NewUser.aspx/AddUserDetails",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify( objUser ),
                        dataType: "json",
                        success: function ( result )
                        {
                            if ( !bExists )
                            {
                                //$( '#hHeader' ).text( 'Registration Successful' );
                                //$( '#pBody' ).text( 'User Details added successfully' );

                                //$( '#User-bx' ).modal( 'show' );

                                sendRegistrationEmail( EmailID );
                            }
                        },
                        error: function ( response )
                        {
                            alert( 'User Addition failed' );
                        }
                    } );
                }//end of Existence Else
            },
            error: function ( response )
            {

            }
        } );
    }

    function sendRegistrationEmail( EmailID )
    {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/SendRegistrationEmail",
            data: "{ EmailID: '" + EmailID + "'}",
            dataType: "json",
            beforeSend: function ()
            {
                $( "#userDiv" ).show();

                $( "#loaderRegistrationText" ).show();
                $( "#successRegistrationText" ).hide();

                $( "#userImage" ).show();
            },
            success: function ( result )
            {
                $( "#userDiv" ).hide();

                $( "#loaderRegistrationText" ).hide();
                $( "#successRegistrationText" ).show();

                $( "#userImage" ).hide();

                //Add User Role Details to User Access Table
                //==============================================
                addSpecificRoleDetails();
                //==============================================

            },
            error: function (response) {
                $( "#userDiv" ).hide();
            }
        });
    }

    function saveUser()
    {
        if ( checkBlankControls() )
        {
            addUserDetails();
            setTimeout( function () { }, 3000 );
        }

        return false;
    }
</script>

<script>
    function getNoOfTableRows() {
        var count = 0;
        $('#dtUserRoles tr').each(function () {
            count++;
        });

        return count;
    }

    function showCheckBox(vIsChecked) {
        switch (vIsChecked) {
            case false:
                vIsChecked = "<input type='checkbox' class='no-check'>";
                break;

            case true:
                vIsChecked = "<input type='checkbox' class='yes-check' checked>";
                break;
        }

        return vIsChecked;
    }

    function getSpecificRoleDetails(DropdownId) {
        var RoleName = "";

        $('#dtUserRoles').css('display', 'table');

        switch (DropdownId) {
            case "8":
                RoleName = "Administrator";
                break;

            case "10":
                RoleName = "Customer";
                break;

            case "12":
                RoleName = "Staff";
                break;

            default:
                $('#dtUserRoles').css('display', 'none');
                break;
        }

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewUser.aspx/GetSpecificRoleDetails",
            data: "{RoleName: '" + RoleName + "'}",
            success: function (result) {
                var jsonUserRoles = JSON.parse(result.d);
                $('#dtUserRoles').DataTable({
                    data: jsonUserRoles,
                    columns: [
                        { data: "Menu_Name" },//0
                        {
                            data: "AssignBookingToDriver",//1
                            render: function (jsonAssignBookingToDriver) {
                                return showCheckBox(jsonAssignBookingToDriver);
                            }
                        },
                        { data: "AssignBookingToDriverId" },//2
                        {
                            data: "AddDriverToAssignBooking",//3
                            render: function (jsonAddDriverToAssignBooking) {
                                return showCheckBox(jsonAddDriverToAssignBooking);
                            }
                        },
                        { data: "AddDriverToAssignBookingId" },//4
                        {
                            data: "AddBooking",//5
                            render: function (jsonAddBooking) {
                                return showCheckBox(jsonAddBooking);
                            }
                        },
                        { data: "AddBookingId" },//6
                        {
                            data: "AddShipping",//7
                            render: function (jsonAddShipping) {
                                return showCheckBox(jsonAddShipping);
                            }
                        },
                        { data: "AddShippingId" },//8
                        {
                            data: "AddCustomer",//9
                            render: function (jsonAddCustomer) {
                                return showCheckBox(jsonAddCustomer);
                            }
                        },
                        { data: "AddCustomerId" },//10
                        {
                            data: "AddDriver",//11
                            render: function (jsonAddDriver) {
                                return showCheckBox(jsonAddDriver);
                            }
                        },
                        { data: "AddDriverId" },//12
                        {
                            data: "AddWarehouse",//13
                            render: function (jsonAddWarehouse) {
                                return showCheckBox(jsonAddWarehouse);
                            }
                        },
                        { data: "AddWarehouseId" },//14
                        {
                            data: "AddLocation",//15
                            render: function (jsonAddLocation) {
                                return showCheckBox(jsonAddLocation);
                            }
                        },
                        { data: "AddLocationId" },//16
                        {
                            data: "AddZone",//17
                            render: function (jsonAddZone) {
                                return showCheckBox(jsonAddZone);
                            }
                        },
                        { data: "AddZoneId" },//18
                        {
                            data: "AddUser",//19
                            render: function (jsonAddUser) {
                                return showCheckBox(jsonAddUser);
                            }
                        },
                        { data: "AddUserId" },//20
                        {
                            data: "PrintDetails",//21
                            render: function (jsonPrintDetails) {
                                return showCheckBox(jsonPrintDetails);
                            }
                        },
                        { data: "PrintDetailsId" },//22
                        {
                            data: "ExportToPDF",//23
                            render: function (jsonExportToPDF) {
                                return showCheckBox(jsonExportToPDF);
                            }
                        },
                        { data: "ExportToPDFId" },//24
                        {
                            data: "ExportToExcel",//25
                            render: function (jsonExportToExcel) {
                                return showCheckBox(jsonExportToExcel);
                            }
                        },
                        { data: "ExportToExcelId" }//26
                    ],

                    "bDestroy": true
                });

                disableAllCheckBoxesNonExistingOnPage();
            },
            error: function (response) {
                alert('Unable to Bind Specific Role Details');
            }
        });//end of ajax

        return false;
    }

    function disableAllCheckBoxesNonExistingOnPage() {

        var count = 0;
        var tblSpecificRoleDetails = $('#dtUserRoles').DataTable();

        var RoleTableSpecificData = $(tblSpecificRoleDetails.$('input[type="checkbox"]').map(function () {
            return $(this).closest('tr');
        }));

        for (var i = 0; i < RoleTableSpecificData.length; i++) {

            var vAssignBookingToDriverId = RoleTableSpecificData[i].find('td').eq(2).text().trim();
            if (vAssignBookingToDriverId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(0)').attr("disabled", 'disabled');
            }

            var vAddDriverToAssignBookingId = RoleTableSpecificData[i].find('td').eq(4).text().trim();
            if (vAddDriverToAssignBookingId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(1)').attr("disabled", 'disabled');
            }

            var vAddBookingId = RoleTableSpecificData[i].find('td').eq(6).text().trim();
            if (vAddBookingId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(2)').attr("disabled", 'disabled');
            }

            var vAddShippingId = RoleTableSpecificData[i].find('td').eq(8).text().trim();
            if (vAddShippingId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(3)').attr("disabled", 'disabled');
            }

            var vAddCustomerId = RoleTableSpecificData[i].find('td').eq(10).text().trim();
            if (vAddCustomerId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(4)').attr("disabled", 'disabled');
            }

            var vAddDriverId = RoleTableSpecificData[i].find('td').eq(12).text().trim();
            if (vAddDriverId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(5)').attr("disabled", 'disabled');
            }

            var vAddWarehouseId = RoleTableSpecificData[i].find('td').eq(14).text().trim();
            if (vAddWarehouseId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(6)').attr("disabled", 'disabled');
            }

            var vAddLocationId = RoleTableSpecificData[i].find('td').eq(16).text().trim();
            if (vAddLocationId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(7)').attr("disabled", 'disabled');
            }

            var vAddZoneId = RoleTableSpecificData[i].find('td').eq(18).text().trim();
            if (vAddZoneId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(8)').attr("disabled", 'disabled');
            }

            var vAddUserId = RoleTableSpecificData[i].find('td').eq(20).text().trim();
            if (vAddUserId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(9)').attr("disabled", 'disabled');
            }

            var vPrintDetailsId = RoleTableSpecificData[i].find('td').eq(22).text().trim();
            if (vPrintDetailsId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(10)').attr("disabled", 'disabled');
            }

            var vExportToPDFId = RoleTableSpecificData[i].find('td').eq(24).text().trim();
            if (vExportToPDFId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(11)').attr("disabled", 'disabled');
            }

            var vExportToExcelId = RoleTableSpecificData[i].find('td').eq(26).text().trim();
            if (vExportToExcelId == "") {
                RoleTableSpecificData[i].find('input[type=checkbox]:eq(12)').attr("disabled", 'disabled');
            }
        }
    }

    function addSpecificRoleDetails() {

        var tblSpecificRoleDetails = $('#dtUserRoles').DataTable();

        var RoleTableSpecificData = $(tblSpecificRoleDetails.$('input[type="checkbox"]').map(function () {
            return $(this).closest('tr');
        }));

        var vRoleTableLength = tblSpecificRoleDetails.data().length;
        //alert('Role Table Length: ' + vRoleTableLength);

        var TableData = tblSpecificRoleDetails.rows().data();
        TableData.each(function (value, index) {
            var vUserId = $( '#<%=hfUserId.ClientID%>').val().trim();
            var vRoleName = $("#<%=ddlUserRole.ClientID%>").find('option:selected').text().trim();

            var vMenu_Name = TableData.column(0).data()[index];

            //0
            //=====================================================================
            var vAssignBookingToDriver = TableData.column(1).data()[index];
            var vAssignBookingToDriverId = TableData.column(2).data()[index];

            //1
            //=====================================================================
            var vAddDriverToAssignBooking = TableData.column(3).data()[index];
            var vAddDriverToAssignBookingId = TableData.column(4).data()[index];

            //2
            //=====================================================================
            var vAddBooking = TableData.column(5).data()[index];
            var vAddBookingId = TableData.column(6).data()[index];

            //3
            //=====================================================================
            var vAddShipping = TableData.column(7).data()[index];
            var vAddShippingId = TableData.column(8).data()[index];

            //4
            //=====================================================================
            var vAddCustomer = TableData.column(9).data()[index];
            var vAddCustomerId = TableData.column(10).data()[index];

            //5
            //=====================================================================
            var vAddDriver = TableData.column(11).data()[index];
            var vAddDriverId = TableData.column(12).data()[index];

            //6
            //=====================================================================
            var vAddWarehouse = TableData.column(13).data()[index];
            var vAddWarehouseId = TableData.column(14).data()[index];

            //7
            //=====================================================================
            var vAddLocation = TableData.column(15).data()[index];
            var vAddLocationId = TableData.column(16).data()[index];

            //8
            //=====================================================================
            var vAddZone = TableData.column(17).data()[index];
            var vAddZoneId = TableData.column(18).data()[index];

            //9
            //=====================================================================
            var vAddUser = TableData.column(19).data()[index];
            var vAddUserId = TableData.column(20).data()[index];

            //10
            //=====================================================================
            var vPrintDetails = TableData.column(21).data()[index];
            var vPrintDetailsId = TableData.column(22).data()[index];

            //11
            //=====================================================================
            var vExportToPDF = TableData.column(23).data()[index];
            var vExportToPDFId = TableData.column(24).data()[index];

            //12
            //=====================================================================
            var vExportToExcel = TableData.column(25).data()[index];
            var vExportToExcelId = TableData.column(26).data()[index];

            //Binding User Roles to object
            var objUserAccess = {};

            objUserAccess.UserId = vUserId;
            objUserAccess.RoleName = vRoleName;
            objUserAccess.Menu_Name = vMenu_Name;

            //0
            //===================================================================
            objUserAccess.AssignBookingToDriver = vAssignBookingToDriver;
            objUserAccess.AssignBookingToDriverId = vAssignBookingToDriverId;

            //1
            //===================================================================
            objUserAccess.AddDriverToAssignBooking = vAddDriverToAssignBooking;
            objUserAccess.AddDriverToAssignBookingId = vAddDriverToAssignBookingId;

            //2
            //===================================================================
            objUserAccess.AddBooking = vAddBooking;
            objUserAccess.AddBookingId = vAddBookingId;

            //3
            //===================================================================
            objUserAccess.AddShipping = vAddShipping;
            objUserAccess.AddShippingId = vAddShippingId;

            //4
            //===================================================================
            objUserAccess.AddCustomer = vAddCustomer;
            objUserAccess.AddCustomerId = vAddCustomerId;

            //5
            //===================================================================
            objUserAccess.AddDriver = vAddDriver;
            objUserAccess.AddDriverId = vAddDriverId;

            //6
            //===================================================================
            objUserAccess.AddWarehouse = vAddWarehouse;
            objUserAccess.AddWarehouseId = vAddWarehouseId;

            //7
            //===================================================================
            objUserAccess.AddLocation = vAddLocation;
            objUserAccess.AddLocationId = vAddLocationId;

            //8
            //===================================================================
            objUserAccess.AddZone = vAddZone;
            objUserAccess.AddZoneId = vAddZoneId;

            //9
            //===================================================================
            objUserAccess.AddUser = vAddUser;
            objUserAccess.AddUserId = vAddUserId;

            //10
            //===================================================================
            objUserAccess.PrintDetails = vPrintDetails;
            objUserAccess.PrintDetailsId = vPrintDetailsId;

            //11
            //===================================================================
            objUserAccess.ExportToPDF = vExportToPDF;
            objUserAccess.ExportToPDFId = vExportToPDFId;

            //12
            //===================================================================
            objUserAccess.ExportToExcel = vExportToExcel;
            objUserAccess.ExportToExcelId = vExportToExcelId;

            $.ajax({
                type: "POST",
                url: "NewUser.aspx/AddUserSpecificRoles",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objUserAccess),
                dataType: "json",
                success: function (result) {
                },
                error: function (response) {
                }
            });
        });

        $('#spRoleMessage').text("User Creation with Role successful");
        $('#UserRole-bx').modal('show');

        return false;
    }

    function gotoViewAllUsers() {
        location.href = '/Users/ViewAllUsers.aspx';
    }

</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    New User
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <form id="frmNewUser" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <asp:HiddenField ID="hfUserId" runat="server" />
                        </div>
                        <div class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Email Address<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtEmailID" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="example@gmail.com" 
                                                title="Please enter Email Address"
                                                    MaxLength="255" onkeypress="clearErrorMessage();"
                                    
                                                ></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Confirm Email Address<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtConfirmEmailID" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="example@gmail.com" 
                                                title="Please confirm Email Address"
                                                    MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Password<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                                CssClass="form-control m-b" PlaceHolder="******" title="Please enter Password"
                                                    MaxLength="50" onkeypress="clearErrorMessage();" 
                                    
                                                ></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Confirm Password<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                                                CssClass="form-control m-b" PlaceHolder="******" title="Please confirm Password"
                                                    MaxLength="50" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Title<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:DropDownList ID="ddlTitle" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Title from dropdown"
                                                    onchange="clearErrorMessage();">
                                                    <asp:ListItem>Select Title</asp:ListItem>
                                                </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        First Name<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtFirstName" runat="server" MaxLength="50"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. Tom" title="Please enter First Name"
                                                    onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Last Name<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtLastName" runat="server" MaxLength="50"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. Alter" title="Please enter Last Name"
                                                       onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Date Of Birth<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtDOB" runat="server" CssClass="clrBLK form-control"
                                                     onchange="clearErrorMessage();checkAdultDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Address Line 1<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtAddressLine1" runat="server" MaxLength="150"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. 1/A, Hasselfree Road, Marko Town" 
                                                       title="Please enter Address Line 1" 
                                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Address Line 2</label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtAddressLine2" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. P.O. - Joomla Park, P.S. - Oly Street"
                                                       title="Please enter Address Line 2" MaxLength="150"
                                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Address Line 3</label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtAddressLine3" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. East London"
                                                       title="Please enter Address Line 3" MaxLength="150"
                                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Town<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtTown" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. Bristol" 
                                                    title="Please enter Town" MaxLength="50"
                                                       onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Country<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:DropDownList ID="ddlCountry" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Country from dropdown"
                                                    onchange="clearErrorMessage();">
                                                    <asp:ListItem>Select Country</asp:ListItem>
                                                </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6" style="display:none;">
                                    <div class="row form-group"><label class="col-sm-4 control-label">
                                        House number</label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control m-b"
                                                       PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                                       onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                        Mobile (+44)<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtMobile" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. 87123 123456" 
                                                    title="Please enter Mobile Number" 
                                                       MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Telephone (+44)</label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtTelephone" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. 0117 9460018" 
                                                    title="Please enter Telephone Number" 
                                                       MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <%--<div class="col-sm-6">
                                    <div class="row form-group"><label class="col-sm-4 control-label">
                                         Secret Question<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtSecretQuestion" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. What is Pet's Name?" 
                                                       title="Please enter Secret Question"
                                                       MaxLength="100" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>--%>
                                <%--<div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                         Secret Answer<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:TextBox ID="txtSecretAnswer" runat="server"
                                                    CssClass="form-control m-b" PlaceHolder="e.g. Katty" 
                                                    title="Please enter Secret Answer"
                                                       MaxLength="100" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>--%>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                         Primary Role<span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                                <asp:DropDownList ID="ddlUserRole" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Role from dropdown"
                                                    onchange="getSpecificRoleDetails(this.value); clearErrorMessage();">
                                                    <asp:ListItem>Select Role</asp:ListItem>
                                                </asp:DropDownList>                        
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


                        <div class="table-responsive" style="display: none;">
                            <table id="dtUserRoles" class="table" style="display: none;">
                                <thead>
                                    <tr>
                                        <th>Menu Name</th>

                                        <!--0-->
                                        <th>Assign Booking To Driver</th>
                                        <th>Assign Booking To Driver Id</th>

                                        <!--1-->
                                        <th>Add Driver To Assign Booking</th>
                                        <th>Add Driver To Assign Booking Id</th>

                                        <!--2-->
                                        <th>Add Booking</th>
                                        <th>Add Booking Id</th>

                                        <!--3-->
                                        <th>Add Shipping</th>
                                        <th>Add Shipping Id</th>

                                        <!--4-->
                                        <th>Add Customer</th>
                                        <th>Add Customer Id</th>

                                        <!--5-->
                                        <th>Add Driver</th>
                                        <th>Add Driver Id</th>

                                        <!--6-->
                                        <th>Add Warehouse</th>
                                        <th>Add Warehouse Id</th>

                                        <!--7-->
                                        <th>Add Location</th>
                                        <th>Add Location Id</th>

                                        <!--8-->
                                        <th>Add Zone</th>
                                        <th>Add Zone Id</th>

                                        <!--9-->
                                        <th>Add User</th>
                                        <th>Add User Id</th>

                                        <!--10-->
                                        <th>Print Details</th>
                                        <th>Print Details Id</th>

                                        <!--11-->
                                        <th>Export To PDF</th>
                                        <th>Export To PDF Id</th>

                                        <!--12-->
                                        <th>Export To Excel</th>
                                        <th>Export To Excel Id</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                       <div class="form-group">
                            <div class="col-sm-12 text-center">
                                    <asp:Button ID="btnSaveUser" runat="server" Text="Save User"
                                        CssClass="btn btn-primary" OnClientClick="return saveUser();"
                                        />
                                    <asp:Button ID="btnCancelUser" runat="server" Text="Cancel" class="btn btn-default"
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
                    </div>
                </form>
            </div>
        </div>
    </div>

<div class="modal fade" id="User-bx" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header" style="background-color: #f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 id="hHeader" class="modal-title" style="font-size: 24px; color: #111;">User Header</h4>
            </div>
            <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                <p id="pBody">User Body</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
            </div>
        </div>

    </div>
</div>

<div class="modal fade" id="UserRole-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Role Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spRoleMessage"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="gotoViewAllUsers();">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

<%--<script type="text/javascript">
    $(document).ready(function () {
        $("#dtUserRoles").wrapAll("<div class="tabl_outer"><div>");
    });

</script>--%>

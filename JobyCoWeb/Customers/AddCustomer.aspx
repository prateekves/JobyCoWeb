<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
CodeBehind="AddCustomer.aspx.cs" Inherits="JobyCoWeb.Customers.AddCustomer"
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

        if (typeof google === 'object' && typeof google.maps === 'object') {
            InitializeMap();
        } else {
            $.getScript('https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap', function () {
                InitializeMap();
            });
        }

        getAllOptions();

        // Change the country selection for Collection Mobile    
        $("#txtMobile").intlTelInput("setCountry", "gb");

        $( '#<%=txtDOB.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });
    });


        function InitializeMap()
        {
                

                var PLat = $("#<%=hfPickupLatitude.ClientID%>").val();
                var Plong = $("#<%=hfPickupLongitude.ClientID%>").val();

                //alert(PLat + '  '+ Plong);

                var latlng = new google.maps.LatLng( PLat,  Plong);

                var myCollectionOptions = {
                    zoom: 6,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };
                var CollectionMap = new google.maps.Map( document.getElementById( "CollectionMap" ), myCollectionOptions );

                //alert(DLat + '  '+ Dlong);

                var defaultCollectionBounds = new google.maps.LatLngBounds(
                    new google.maps.LatLng( -33.8902, 151.1759 ),
                    new google.maps.LatLng( -33.8474, 151.2631 )
                );

                var optionsCollection = {
                    bounds: defaultCollectionBounds
                };
                var placesCollection = new google.maps.places.Autocomplete( document.getElementById( '<%=txtAddressLine1.ClientID%>' ), optionsCollection );

                google.maps.event.addListener( placesCollection, 'place_changed', function()
                {
                    var placeCollection = placesCollection.getPlace();
                    var addressCollection = placeCollection.formatted_address;
                    var latitudeCollection = placeCollection.geometry.location.lat();
                    var longitudeCollection = placeCollection.geometry.location.lng();

                    var msgCollection = "Address: " + addressCollection;
                    msgCollection += "\nLatitude: " + latitudeCollection;
                    msgCollection += "\nLongitude: " + longitudeCollection;

                    alert(msgCollection);
                    $("#<%=hfPickupLatitude.ClientID%>").val(latitudeCollection);
                    $("#<%=hfPickupLongitude.ClientID%>").val(longitudeCollection);

                    var latlngCollection = new google.maps.LatLng( latitudeCollection, longitudeCollection );

                    myCollectionOptions = {
                        zoom: 8,
                        center: latlngCollection,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };

                    mapCollection = new google.maps.Map( document.getElementById( "CollectionMap" ), myCollectionOptions );
                    document.getElementById( "CollectionMap" ).style.width = document.getElementById( "<%=txtAddressLine1.ClientID%>" ).style.width;
                    //alert( 'Collection Place Changed' );
                });
        }

</script>

<script>
    function checkAddressDetails()
        {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");
            var Success = false;
            var Address1 = $( "#<%=txtAddressLine1.ClientID%>" ).val().trim();

            var geocoder = new google.maps.Geocoder();
            var address = Address1;

            geocoder.geocode({ 'address': address }, function (results, status) {

                if (status == google.maps.GeocoderStatus.OK) {
                    //
                    var latitude = results[0].geometry.location.latitude;
                    var longitude = results[0].geometry.location.longitude;
                    //2nd Block
                    var Address2 = $( "#<%=txtAddressLine1.ClientID%>" ).val().trim();
                                var geocoder = new google.maps.Geocoder();
                                var address = Address2;

                                geocoder.geocode({ 'address': address }, function (results, status) {

                                    if (status == google.maps.GeocoderStatus.OK) {
                                        //
                                        var latitude = results[0].geometry.location.latitude;
                                        var longitude = results[0].geometry.location.longitude;
                                        //alert(latitude);
                                        addCustomerDetails();
                                    }
                                    else {
                                        Success = false;
                                       //alert('Invalid ' + PickupOrDelivery + ' Address : Please select address from the given location');
                                        vErrMsg.text('Invalid Delivery Address : Please select address from the given location');
                                        vErrMsg.css("display", "block");

                                        return Success;
                                    }
                                });
                                //2nd Block
                    Success = true;
                    return Success;
                }
                else {
                    Success = false;
                    //alert('Invalid ' + PickupOrDelivery + ' Address : Please select address from the given location');
                    vErrMsg.text('Invalid Pickup Address : Please select address from the given location');
                    vErrMsg.css("display", "block");

                    return Success;
                }
            });

            

            return false;
        }


        function checkBlankControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");

            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");
            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");
            var vLegalAge = $("#<%=chkLegalAge.ClientID%>");

            var vPostCode = $("#<%=txtPostCode.ClientID%>");
            var vMobile = $("#txtMobile");

            var vHearAboutUs = $("#<%=ddlHearAboutUs.ClientID%>");
            var vYesRegisteredCompany = $("#<%=rbYesRegisteredCompany.ClientID%>");
            var vNoRegisteredCompany = $("#<%=rbNoRegisteredCompany.ClientID%>");

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

            //if (vPassword.val().trim() == "") {
            //    vErrMsg.text('Enter Password');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            /*if (vPassword.val().trim().length < 8) {
                vErrMsg.text('Password should be atleast 8 characters with minimum 1 alphabet, 1 number and 1 Capital Letter');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            if (!vPassword.val().trim().match(/[a-z]/)) {
                vErrMsg.text('Password should contain atleast 1 Alphabet');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            if (!vPassword.val().trim().match(/[A-Z]/)) {
                vErrMsg.text('Password should contain atleast 1 Capital Letter');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            if (!vPassword.val().trim().match(/\d/)) {
                vErrMsg.text('Password should contain atleast 1 Number');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }*/

            if (vCustomerName.val().trim() == "") {
                vErrMsg.text('Enter Customer Name');
                vErrMsg.css("display", "block");
                vCustomerName.focus();
                return false;
            }
            var spaceCount = countWhiteSpace(vCustomerName.val().trim());
            if (spaceCount > 3) {
                vErrMsg.text('Your Name is Too Long');
                vErrMsg.css("display", "block");
                vCustomerName.focus();
                return false;
            }

            if (vAddressLine1.val().trim() == "") {
                vErrMsg.text('Plese enter Address');
                vErrMsg.css("display", "block");
                vAddressLine1.focus();
                return false;
            }
            else
            {
                //check address is valid address or not
               <%-- var Address1 = $( "#<%=txtAddressLine1.ClientID%>" ).val().trim();

            var geocoder = new google.maps.Geocoder();
            var address = Address1;

            geocoder.geocode({ 'address': address }, function (results, status) {

                if (status == google.maps.GeocoderStatus.OK) {
                    //
                    var latitude = results[0].geometry.location.latitude;
                    var longitude = results[0].geometry.location.longitude;
                    //2nd Block
                    var Address2 = $( "#<%=txtAddressLine1.ClientID%>" ).val().trim();
                                var geocoder = new google.maps.Geocoder();
                                var address = Address2;

                                geocoder.geocode({ 'address': address }, function (results, status) {

                                    if (status == google.maps.GeocoderStatus.OK) {
                                        //
                                        var latitude = results[0].geometry.location.latitude;
                                        var longitude = results[0].geometry.location.longitude;
                                        //alert(latitude);
                                       


                                    }
                                    else {
                                        Success = false;
                                       //alert('Invalid ' + PickupOrDelivery + ' Address : Please select address from the given location');
                                        vErrMsg.text('Invalid Delivery Address : Please select address from the given location');
                                        vErrMsg.css("display", "block");

                                        return Success;
                                    }
                                });
                                //2nd Block
                    Success = true;
                    return Success;
                }
                else {
                    Success = false;
                    //alert('Invalid ' + PickupOrDelivery + ' Address : Please select address from the given location');
                    vErrMsg.text('Invalid Address : Please select address from the given location');
                    vErrMsg.css("display", "block");

                    return Success;
                }
            });--%>
            }

            //var CustomerDateTime = vDOB.val().trim();
            //if (CustomerDateTime == "") {
            //    vErrMsg.text('Enter Date Of Birth');
            //    vErrMsg.css("display", "block");
            //    vDOB.focus();
            //    return false;
            //}

            //var vCurrentDate = getCurrentDateDetails();

            //if ( CustomerDateTime != "" && vCurrentDate != "" )
            //{
            //    var dt1 = parseInt( CustomerDateTime.substring( 0, 2 ), 10 );
            //    var mon1 = parseInt( CustomerDateTime.substring( 3, 5 ), 10 );
            //    var yr1 = parseInt( CustomerDateTime.substring( 6, 10 ), 10 );

            //    var dt2 = parseInt( vCurrentDate.substring( 0, 2 ), 10 );
            //    var mon2 = parseInt( vCurrentDate.substring( 3, 5 ), 10 );
            //    var yr2 = parseInt( vCurrentDate.substring( 6, 10 ), 10 );

            //    var From_date = new Date( yr1, mon1, dt1 );
            //    var To_date = new Date( yr2, mon2, dt2 );
            //    var diff_date = To_date - From_date;

            //    var years = Math.floor( diff_date / 31536000000 );
            //    var months = Math.floor(( diff_date % 31536000000 ) / 2628000000 );
            //    var days = Math.floor(( ( diff_date % 31536000000 ) % 2628000000 ) / 86400000 );

            //    //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

            //    if ( years < 18 )
            //    {
            //        vErrMsg.text( 'Customer must be atleast 18 years of age' );
            //        vErrMsg.css( "display", "block" );
            //        return false;
            //    }
            //    else
            //    {
            //        if ( months < 0 )
            //        {
            //            vErrMsg.text( 'Customer must be atleast 18 years of age' );
            //            vErrMsg.css( "display", "block" );
            //            return false;
            //        }
            //        else
            //        {
            //            if ( days < 0 )
            //            {
            //                vErrMsg.text( 'Customer must be atleast 18 years of age' );
            //                vErrMsg.css( "display", "block" );
            //                return false;
            //            }
            //        }
            //    }
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

            //if (vHearAboutUs.val().trim() == "Select Option") {
            //    vErrMsg.text('Please select an Option from dropdown');
            //    vErrMsg.css("display", "block");
            //    vHearAboutUs.focus();
            //    return false;
            //}

            if (!vYesRegisteredCompany.is(":checked") && !vNoRegisteredCompany.is(":checked")) {
                vErrMsg.text('Please choose Answer whether you have a Registered Company or not');
                vErrMsg.css("display", "block");
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");

            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");
            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");
            //var vLegalAge = $("#<%=chkLegalAge.ClientID%>");

            var vPostCode = $("#<%=txtPostCode.ClientID%>");
            var vMobile = $("#txtMobile");

            var vHearAboutUs = $("#<%=ddlHearAboutUs.ClientID%>");
            var vYesRegisteredCompany = $("#<%=rbYesRegisteredCompany.ClientID%>");
            var vNoRegisteredCompany = $("#<%=rbNoRegisteredCompany.ClientID%>");

            var vYesShippingGoodsInCompanyName = $("#<%=rbYesShippingGoodsInCompanyName.ClientID%>");
            var vNoShippingGoodsInCompanyName = $("#<%=rbNoShippingGoodsInCompanyName.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            vEmailID.val('');
            vPassword.val('');

            vCustomerName.val('');
            vAddressLine1.val('');

            vDOB.val('');
            //vLegalAge.removeAttr('checked');

            vPostCode.val('');
            vMobile.val('');

            vHearAboutUs.val('Select Option');
            vYesRegisteredCompany.removeAttr('checked');
            vNoRegisteredCompany.removeAttr('checked');

            vYesShippingGoodsInCompanyName.removeAttr('checked');
            vNoShippingGoodsInCompanyName.removeAttr('checked');

            location.href = "/Customers/ViewAllCustomers.aspx";
            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }

        function showHideDiv() {

        var vYesRegisteredCompany = $("#<%=rbYesRegisteredCompany.ClientID%>");
        var vShippingGoodsInCompanyName = $("#dvShippingGoodsInCompanyName");
        var vRegisteredCompanyName = $("#dvRegisteredCompanyName");

            if (vYesRegisteredCompany.is(":checked")) {
                vShippingGoodsInCompanyName.show();
                vRegisteredCompanyName.show();
            } else {
                vShippingGoodsInCompanyName.hide();
                vRegisteredCompanyName.hide();
            }
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

    function checkAdultDate()
    {
        //Date Checking Added on Text Change
        var vDateOfBirth = $( "#<%=txtDOB.ClientID%>" ).val().trim();
        var vCurrentDate = getCurrentDateDetails();
        checkFromAndToDate( vDateOfBirth, vCurrentDate );
    }

</script>

<script>
    function getCustomerId() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddCustomer.aspx/GetCustomerId",
            data: "{}",
            dataType: "json",
            async: false,
            success: function (result) {
                $("#<%=hfCustomerId.ClientID%>").val(result.d);
            },
            error: function (response) {
            }
        });
    }

    function getAllOptions()
    {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddCustomer.aspx/GetAllOptions",
            data: "{}",
            dataType: "json",
            success: function (result) {
                $.each( result.d, function ( key, value )
                {
                    $( "#<%=ddlHearAboutUs.ClientID%>" ).append( $( "<option></option>" ).val( value.ItemId ).html( value.ItemValue ) );
                } )
            },
            error: function (response) {
            }
        });
    }

    function checkEmailID( EmailID )
    {
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css("text-align", "center");

        var IsExist = false;

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddCustomer.aspx/checkEmailID",
            data: "{ EmailID: '" + EmailID + "'}",
            dataType: "json",
            async:false,
            success: function (result) {
                $( "#<%=hfCustomerIdFromEmailId.ClientID%>" ).val( result.d );   
                
                if ($("#<%=hfCustomerIdFromEmailId.ClientID%>").val().trim() == "True") {
                    vErrMsg.text('This Email Address already Exists. Try another');
                    vErrMsg.css("display", "block");
                    $("#<%=txtEmailID.ClientID%>").focus();
                    IsExist = false;
                }
                else {
                    IsExist = true;
                }
            },
            error: function (response) {
                IsExist = false;
            }
        } );

        return IsExist;
    }
            
    function addCustomerDetails() {
        getCustomerId();
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#f9edef");
        vErrMsg.css("color", "red");

        //Saving Customer Details First
        var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
        var EmailID = $("#<%=txtEmailID.ClientID%>").val().trim();
        var Password = $("#<%=txtPassword.ClientID%>").val().trim();

        var FullName = $("#<%=txtCustomerName.ClientID%>").val().trim();
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

                //Title = Names[0];
                FirstName = Names[0] + " " + Names[1];
                LastName = Names[2];
            }
            if (spaceCount == 3) {
                var Names = FullName.split(' ');

                //Title = Names[0];
                FirstName = Names[0] + " " + Names[1] + " " + Names[2];
                LastName = Names[3];
            }
        }
        else {
            LastName = FullName;
        }

        var DOB = $("#<%=txtDOB.ClientID%>").val().trim();
        var Address = $("#<%=txtAddressLine1.ClientID%>").val().trim();

        var LatitudePickup = $("#<%=hfPickupLatitude.ClientID%>").val().trim();
        var LongitudePickup = $("#<%=hfPickupLongitude.ClientID%>").val().trim();

        var Town = "";
        var Country = "";

        var PostCode = $("#<%=txtPostCode.ClientID%>").val().trim();
        var Mobile = $("#txtMobile").val().trim();
        var Telephone = "";

        var vHearAboutUs = $("#<%=ddlHearAboutUs.ClientID%>");
        var HearAboutUs = vHearAboutUs.find("option:selected").text().trim();

        //Having Registered Company
        var HavingRegisteredCompany = "";
        var vYesRegisteredCompany = $("#<%=rbYesRegisteredCompany.ClientID%>");
        var vNoRegisteredCompany = $("#<%=rbNoRegisteredCompany.ClientID%>");

        if (vYesRegisteredCompany.is(":checked")) {
            HavingRegisteredCompany = "true";
        }

        if (vNoRegisteredCompany.is(":checked")) {
            HavingRegisteredCompany = "false";
        }
       
        var Locked = "false";

        //Shipping the Goods in the name of Company
        var ShippingGoodsInCompanyName = "false";
        var vYesShippingGoodsInCompanyName = $("#<%=rbYesShippingGoodsInCompanyName.ClientID%>");
        var vNoShippingGoodsInCompanyName = $("#<%=rbNoShippingGoodsInCompanyName.ClientID%>");

        if (vYesShippingGoodsInCompanyName.is(":checked")) {
            ShippingGoodsInCompanyName = "true";
        }

        if (vNoShippingGoodsInCompanyName.is(":checked")) {
            ShippingGoodsInCompanyName = "false";
        }

        var RegisteredCompanyName = $("#<%=txtCompanyName.ClientID%>").val().trim();

        var CustomerTitle = $("#CustomerTitle").find('option:selected').text().trim();

        Title = CustomerTitle;
        //alert(CustomerTitle);
        //Binding Customer Details to object
        var objCustomer = {};

        objCustomer.CustomerId = CustomerId;
        objCustomer.EmailID = EmailID;
        objCustomer.Password = Password;

        objCustomer.Title = Title;
        objCustomer.FirstName = FirstName;
        objCustomer.LastName = LastName;

        objCustomer.DOB = DOB;

        objCustomer.Address = Address;
        objCustomer.LatitudePickup = LatitudePickup;
        objCustomer.LongitudePickup = LongitudePickup;

        objCustomer.Town = Town;
        objCustomer.Country = Country;
        objCustomer.PostCode = PostCode;

        objCustomer.Mobile = Mobile;
        objCustomer.Telephone = Telephone;
        objCustomer.HearAboutUs = HearAboutUs;

        objCustomer.HavingRegisteredCompany = HavingRegisteredCompany;
        objCustomer.Locked = Locked;
        objCustomer.ShippingGoodsInCompanyName = ShippingGoodsInCompanyName;
        objCustomer.RegisteredCompanyName = RegisteredCompanyName;

        $.ajax({
            type: "POST",
            url: "AddCustomer.aspx/AddCustomerDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objCustomer),
            dataType: "json",
            success: function (result) {

            },
            error: function (response) {
            }
        });

        //alert(FullName + "'s Details added successfully");
        $( '#spFullName' ).text( FullName );
        $( '#Customer-bx' ).modal( 'show' );

        setTimeout(function () {
            location.href = '/Booking/AddBooking.aspx?CustomerId=' + CustomerId;
        }, 3000);

        return false;
    }

    function saveCustomerDetails()
    {
        
        var EmailID = $("#<%=txtEmailID.ClientID%>");
        var vEmailID = EmailID.val().trim();

        if ( checkEmailID( vEmailID ) )
        {
            if ( checkBlankControls() )
            {
                checkAddressDetails();   
            }
        }

        return false;
    }
</script>
    <style>
        #CollectionMap {
            height: 150px;
            width: 400px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   

            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    Add Customer
                </h2>
                <p></p>
            </div>

            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmCustomer" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <asp:HiddenField ID="hfCustomerId" runat="server" />
                    <asp:HiddenField ID="hfCustomerIdFromEmailId" runat="server" />
                    
                    <asp:HiddenField ID="hfPickupLatitude" runat="server" />
                    <asp:HiddenField ID="hfPickupLongitude" runat="server" />

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
                                        <asp:TextBox ID="txtEmailID" runat="server" autocomplete="off"
                                            CssClass="form-control m-b border-BLK" PlaceHolder="example@gmail.com" 
                                            title="Please enter Email Address" style="text-transform: lowercase;"
                                            MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                    </div>                        
                                </div>
                            </div>
                            <div style="display:none;" class="col-sm-6">
                                <div class="row form-group"><label class="col-sm-4 control-label">Password <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtPassword" Text="12345" runat="server" TextMode="Password"
                                            CssClass="form-control m-b" PlaceHolder="******" title="Please enter Password"
                                                MaxLength="50" onkeypress="clearErrorMessage();" 
                                            ></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label name_slct">  
                                        <span class="name_span">Name<span style="color: red">*</span></span>                                  
                                        <select id="CustomerTitle">
                                            <option value="Mr" selected="selected">Mr</option>
                                            <option value="Mrs">Mrs</option>
                                            <option value="Miss">Miss</option>
                                        </select>
                                    </label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtCustomerName" runat="server" MaxLength="50"
                                        CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter Name"
                                        onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>                            
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group"><label class="col-sm-4 control-label">Address <span style="color: red"></span></label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtAddressLine1" Style="background:none !important" runat="server"
                                        CssClass="form-control"  PlaceHolder="Enter an Address" title="Please enter Address for Customer"
                                        onkeypress="clearErrorMessage();"></asp:TextBox>
                                    <%--<textarea id="txtAddressLine1" class="form-control" 
                                    placeholder="Enter an Address" title="Please enter Address for Customer"
                                    onkeypress="clearErrorMessage();" ></textarea>--%>
                                    <div id="CollectionMap"></div>    
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group"><label class="col-sm-4 control-label">Date Of Birth <span style="color: red"></span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtDOB" runat="server" CssClass="clrBLK form-control"
                                            ReadOnly="true" onchange="clearErrorMessage();"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Post Code</label>
                                    <div class="col-sm-8">
                                            <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control m-b"
                                                   PlaceHolder="e.g. 44" title="Please enter Post Code" MaxLength="20"
                                                   onkeypress="clearErrorMessage();" style="text-transform: uppercase;"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Mobile (+44) <span style="color: red">*</span></label>
                                <div class="col-sm-8">
                                    <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                 
                 <input id="txtMobile" class="flag-tel" type="tel" placeholder="Enter Phone Number" 
                     title="Please enter Customer Mobile Number"
                     onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;" />

                                    </div>
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">How did you hear about us? </label>
                                    <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlHearAboutUs" runat="server"
                                                CssClass="form-control m-b" title="Please select an Option from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Option</asp:ListItem>
                                            </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="row form-group marginbottom">
                                    <label class="col-sm-4 control-label">Do you have a Registered Company? <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <div class="row">
                                            <div class="col-md-3">
                                            <label>Yes &nbsp;<asp:RadioButton ID="rbYesRegisteredCompany" runat="server" GroupName="RegisteredCompany"
                                                onchange = "showHideDiv();clearErrorMessage();" /></label>
                                            </div>

                                            <div class="col-md-3">
                                            <label>No &nbsp;<asp:RadioButton ID="rbNoRegisteredCompany" runat="server" GroupName="RegisteredCompany"
                                                onchange = "showHideDiv();clearErrorMessage();" /></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group" id="dvShippingGoodsInCompanyName" style="display: none;">
                                    <label class="col-sm-4 control-label">If Yes, are you shipping the goods in the name of the company?</label>
                                    <div class="col-sm-8">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <label>Yes &nbsp;
                                                    <asp:RadioButton ID="rbYesShippingGoodsInCompanyName" runat="server" GroupName="ShippingGoodsInCompanyName"
                                                onchange = "clearErrorMessage();" /></label>
                                            </div>                                    
                                            <div class="col-md-3">
                                                <label>No &nbsp;
                                                    <asp:RadioButton ID="rbNoShippingGoodsInCompanyName" runat="server" GroupName="ShippingGoodsInCompanyName"
                                                    onchange = "clearErrorMessage();" /></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group" id="dvRegisteredCompanyName" style="display: none;">
                                    <label class="col-sm-4 control-label">Registered Company Name</label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtCompanyName" runat="server"
                                            CssClass="form-control m-b" PlaceHolder="e.g. ABC Ltd"
                                            onkeypress = "clearErrorMessage();">
                                        </asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!--Added new Script Files for Date Picker-->
                        <script src="/js/bootstrap-datepicker.js"></script>
                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>

                        <!--<div class="row">
                            <div class="form-group"><label class="col-sm-4 control-label">Legal Age <span style="color: red">*</span></label>
                                <div class="col-sm-8">
                                    <label class="age">Customer is 18 or over at the time of Registration
                                     &nbsp;<asp:CheckBox ID="chkLegalAge" runat="server" onchange="clearErrorMessage();" />
                                    </label>
                                </div>
                            </div>
                            <br />
                        </div>-->
                        

                        <div class="form-group">
                            <div class="col-sm-12 text-center">
                                <asp:Button ID="btnRegisterCustomer" runat="server" Text="Register"
                                    CssClass="btn btn-primary btn-register" 
                                    OnClientClick="return saveCustomerDetails();" />
                                    <asp:Button ID="btnCancelRegister" runat="server" Text="Cancel" class="btn btn-default"
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
  

  <div class="modal fade" id="Customer-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Customer Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spFullName"></span>'s Details added successfully</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

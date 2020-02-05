<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="NewLocation.aspx.cs" Inherits="JobyCoWeb.Location.NewLocation"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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
        function checkBlankControls() {            
           
            var vLocationName = $('#<%=txtLocationName.ClientID%>');
            var vCollectionAddressLocation = $('#<%=txtCollectionAddressLocation.ClientID%>');

            var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vLocationName.val().trim() == "")
            {
                vErrMsg.text( 'Please Enter The  Location Name' );
                vErrMsg.css("display", "block");
                vLocationName.focus();
                return false;
            }

            if (vCollectionAddressLocation.val().trim() == "") {
                vErrMsg.text('Please Select The Location Address');
                vErrMsg.css("display", "block");
                vCollectionAddressLocation.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var Country = $("#<%=ddlCountry.ClientID%>");
            var City = $("#<%=ddlCity.ClientID%>");
            var LocationName = $("#<%=ddlLocations.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            Country.find( "option:contains(Select Country)" ).attr( 'selected', 'selected' );
            City.find( "option:contains(Select City)" ).attr( 'selected', 'selected' );
            LocationName.find( "option:contains(Select LocationName)" ).attr( 'selected', 'selected' );

            location.href = "/Location/ViewAllLocations.aspx";
            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }
</script>

<script>
    $( document ).ready( function ()
    {
        getLatestLocationId();
        getAllCountries();
    } );
</script>


    



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
            var CollectionMap = new google.maps.Map( document.getElementById( "CollectionMapLocation" ), myCollectionOptions );

            var myDeliveryOptions = {
                            zoom: 6,
                            center: latlng,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };

            var defaultCollectionBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng( -33.8902, 151.1759 ),
                new google.maps.LatLng( -33.8474, 151.2631 )
                );

            var optionsCollection = {
                            bounds: defaultCollectionBounds
                        };


            google.maps.event.addDomListener( window, 'load', function ()
                        {
                var placesCollection = new google.maps.places.Autocomplete( document.getElementById( '<%=txtCollectionAddressLocation.ClientID%>' ), optionsCollection );

                google.maps.event.addListener( placesCollection, 'place_changed', function ()
                {
                    debugger;
                    var placeCollection = placesCollection.getPlace();
                    var addressCollection = placeCollection.formatted_address;
                    var latitudeCollection = placeCollection.geometry.location.lat();
                    var longitudeCollection = placeCollection.geometry.location.lng();

                    //var msgCollection = "Address: " + addressCollection;
                    //msgCollection += "\nLatitude: " + latitudeCollection;
                    //msgCollection += "\nLongitude: " + longitudeCollection;

                    //alert(placeCollection.addressComponents);
                    //alert(placeCollection.address_components[placeCollection.address_components.length - 1].long_name);
                    for (var i = 0; i < placeCollection.address_components.length; i++ )
                    {
                        for (var b = 0; b < placeCollection.address_components[i].types.length; b++) {
                            if (placeCollection.address_components[i].types[b] == "country") {
                                //this is the object you are looking for
                                //alert(placeCollection.address_components[i].long_name);
                                $('#<%=hfCountry.ClientID%>').val(placeCollection.address_components[i].long_name);
                                //setCookie('setlocation', results[0].address_components[i].long_name, 1);
                                break;
                            }
                        }
                    }
                    


                    $('#<%=hfLocationLatitude.ClientID%>').val(latitudeCollection);
                    $('#<%=hfLocationLongitude.ClientID%>').val(longitudeCollection);
                    
                    var latlngCollection = new google.maps.LatLng( latitudeCollection, longitudeCollection );

                    myCollectionOptions = {
                            zoom: 8,
                            center: latlngCollection,
                            mapTypeId: google.maps.MapTypeId.ROADMAP
                        };

                    mapCollection = new google.maps.Map(document.getElementById("CollectionMapLocation"), myCollectionOptions);
                    document.getElementById( "CollectionMapLocation" ).style.width = document.getElementById( "<%=txtCollectionAddressLocation.ClientID%>" ).style.width;
                        } );

                        } );
        }
    </script>


<script>
    function getLatestLocationId()
    {
        $.ajax( {
            type: "POST",
            url: "NewLocation.aspx/GetLatestLocationId",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function ( result )
            {
                $( '#<%=txtLocationId.ClientID%>').val( result.d );
            },
            error: function ( response )
            {
            }
        } );

        return false;
    }

    function getAllCountries()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewLocation.aspx/GetAllCountries",
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

        return false;
    }

    function getCountryIdFromName()
    {
        var CountryName = $( "#<%=ddlCountry.ClientID%>" ).find( 'option:selected' ).text().trim();        

        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewLocation.aspx/GetCountryIdFromName",
            data: "{ CountryName: '" + CountryName + "'}",
            dataType: "json",
            success: function ( data )
            {
                $( "#<%=hfCountryId.ClientID%>" ).val( data.d );
                //alert( 'hfCountryId = ' + data.d );
                getSpecificCities();
            },
            error: function ( response )
            {
            }
        } );

        return false;
    }

    function getSpecificCities()
    {
        var CountryId = $( "#<%=hfCountryId.ClientID%>" ).val().trim();
        //alert( 'Specific CountryId: ' + CountryId );

        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewLocation.aspx/GetSpecificCities",
            data: "{ CountryId: '" + CountryId + "'}",
            dataType: "json",
            success: function ( result )
            {
                    $( "#<%=ddlCity.ClientID%>" ).html( "" );
                    $( "#<%=ddlCity.ClientID%>" ).append( $( "<option></option>" ).val( null ).html( "Select City" ) );

                    $.each( result.d, function ( key, value )
                    {
                        $( "#<%=ddlCity.ClientID%>" ).append( $( "<option></option>" ).val( value.CityId ).html( value.CityName ) );
                    } );
            },
            error: function ( response )
            {
            }
        } );

        return false;
    }

    function getCityIdFromName()
    {
        var CityName = $( "#<%=ddlCity.ClientID%>" ).find( 'option:selected' ).text().trim();        

        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewLocation.aspx/GetCityIdFromName",
            data: "{ CityName: '" + CityName + "'}",
            dataType: "json",
            success: function ( data )
            {
                $( "#<%=hfCityId.ClientID%>" ).val(data.d);
                //alert( 'hfCityId = ' + data.d );
                getSpecificLocations();
            },
            error: function ( response )
            {
            }
        } );

        return false;
    }

    function getSpecificLocations()
    {
        var CityId = $( "#<%=hfCityId.ClientID%>" ).val().trim();
        //alert( 'Specific CityId: ' + CityId );

        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewLocation.aspx/GetSpecificLocations",
            data: "{ CityId: '" + CityId + "'}",
            dataType: "json",
            success: function ( result )
            {
                    $( "#<%=ddlLocations.ClientID%>" ).html( "" );
                    $( "#<%=ddlLocations.ClientID%>" ).append( $( "<option></option>" ).val( null ).html( "Select Location" ) );

                    $.each( result.d, function ( key, value )
                    {
                        $( "#<%=ddlLocations.ClientID%>" ).append( $( "<option></option>" ).val( value.LocationId ).html( value.LocationName ) );
                    } );
            },
            error: function ( response )
            {
            }
        } );

        return false;
    }

</script>

<script>
    function addLocationDetails()
    {
        var LocationId = $( "#<%=txtLocationId.ClientID%>" ).val().trim();
        var LocationName = $('#<%=txtLocationName.ClientID%>').val().trim();
        var LocationAddress = $('#<%=txtCollectionAddressLocation.ClientID%>').val().trim();
        var LocationLatitude = $('#<%=hfLocationLatitude.ClientID%>').val().trim();
        var LocationLongitude = $('#<%=hfLocationLongitude.ClientID%>').val().trim();
        var Country = $('#<%=hfCountry.ClientID%>').val().trim();

        var objLocation = {};

        objLocation.LocationId = LocationId;
        objLocation.LocationName = LocationName;
        objLocation.LocationAddress = LocationAddress;
        objLocation.LocationLatitude = LocationLatitude;
        objLocation.LocationLongitude = LocationLongitude;
        objLocation.Country = Country;

        $.ajax( {
            type: "POST",
            url: "NewLocation.aspx/AddLocationDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify( objLocation ),
            dataType: "json",
            success: function ( result )
            {
                $( '#Location-bx' ).modal( 'show' );                
            },
            error: function ( response )
            {
                alert( 'Location Details Addition failed' );
            }
        } );

        return false;
    }

    function saveLocation()
    {
        if ( checkBlankControls() )
        {
            addLocationDetails();
            //setTimeout( function () { }, 3000 );
        }
        //alert('Insert');
        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    New Location
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <form id="frmLocation" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            
                            <asp:HiddenField ID="hfCountryId" runat="server" />
                            <asp:HiddenField ID="hfCityId" runat="server" />
                            <asp:HiddenField ID="hfLocationLatitude" runat="server" />
                            <asp:HiddenField ID="hfLocationLongitude" runat="server" />
                            <asp:HiddenField ID="hfCountry" runat="server" />
                        </div>
                        <div class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div style="display:none;" class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Location Id</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtLocationId" runat="server"
                                                CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div style="display:none;" class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Country</label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlCountry" runat="server"
                                                CssClass="form-control m-b" title="Please select a Country from dropdown"
                                                onchange="getCountryIdFromName(); clearErrorMessage();">
                                                <asp:ListItem>Select Country</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div style="display:none;" class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">City</label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlCity" runat="server"
                                                CssClass="form-control m-b" title="Please select a City from dropdown"
                                                onchange="getCityIdFromName();clearErrorMessage();">
                                                <asp:ListItem>Select City</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Location Name</label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlLocations" runat="server" Visible="false"
                                                CssClass="form-control m-b" title="Please select a Location from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Location</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:TextBox ID="txtLocationName" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Location Address</label>
                                        <div class="col-sm-8">
                                            <input type="text" id="txtCollectionAddressLocation" class="form-control"
                                                placeholder="Enter a Collection Location" title=""
                                                onkeypress="clearErrorMessage();" runat="server" />
                                            <div style="height: 200px;" id="CollectionMapLocation"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                           <div class="form-group">
                             <div class="col-sm-12 text-center">
                                <asp:Button ID="btnSaveLocation" runat="server" Text="Save Location"
                                    CssClass="btn btn-primary" OnClientClick="return saveLocation();"
                                    />
                                <asp:Button ID="btnCancelLocation" runat="server" Text="Cancel" class="btn btn-default"
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
    <div class="modal fade" id="Location-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Location - Add</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Location Details added successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" 
                        onclick="location.href='/Location/ViewAllLocations.aspx';">OK</button>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

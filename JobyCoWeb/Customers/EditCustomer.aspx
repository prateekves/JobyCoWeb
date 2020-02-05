<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="EditCustomer.aspx.cs" Inherits="JobyCoWeb.Customers.EditCustomer"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>

<script>
    $(document).ready(function () {
        if (typeof google === 'object' && typeof google.maps === 'object') {
            InitializeMap();
        } else {
            $.getScript('https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap', function () {
                InitializeMap();
            });
        }


        getAllCustomers();

        $( '#dvCustomerDetails' ).css( 'display', 'none' );

        // Change the country selection for Collection Mobile    
        $("#txtMobile").intlTelInput("setCountry", "gb");

        $( '#<%=txtDOB.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });
    });
</script>

<script>
    function InitializeMap()
        {
                debugger;

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

                    //var msgCollection = "Address: " + addressCollection;
                    //msgCollection += "\nLatitude: " + latitudeCollection;
                    //msgCollection += "\nLongitude: " + longitudeCollection;

                    //alert(msgCollection);
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

        function checkBlankControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");
            var vAddressLine1 = $( "#txtAddressLine1" );

            var vMobile = $("#txtMobile");

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

            if (vCustomerName.val().trim() == "") {
                vErrMsg.text('Enter Customer Name');
                vErrMsg.css("display", "block");
                vCustomerName.focus();
                return false;
            }

            var CustomerDateTime = vDOB.val().trim();
            if (CustomerDateTime == "") {
                vErrMsg.text('Enter Date Of Birth');
                vErrMsg.css("display", "block");
                vDOB.focus();
                return false;
            }

            var vCurrentDate = getCurrentDateDetails();

            if ( CustomerDateTime != "" && vCurrentDate != "" )
            {
                var dt1 = parseInt( CustomerDateTime.substring( 0, 2 ), 10 );
                var mon1 = parseInt( CustomerDateTime.substring( 3, 5 ), 10 );
                var yr1 = parseInt( CustomerDateTime.substring( 6, 10 ), 10 );

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

            return true;
        }

        function clearAllControls() {
            var vCustomerId = $( '#<%=hfCustomerId.ClientID%>' );
            var vEmailID = $( "#<%=txtEmailID.ClientID%>" );
            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");
            var vDOB = $("#<%=txtDOB.ClientID%>");
            var vAddressLine1 = $("#txtAddressLine1");
            var vMobile = $("#txtMobile");

            clearErrorMessage();

            vCustomerId.val('');
            vEmailID.val( '' );

            vCustomerName.val('');
            vDOB.val('');
            vAddressLine1.val( '' );
            vMobile.val('');

            $( '#dvCustomerDetails' ).css( 'display', 'none' );
            $( '#dtViewCustomers_wrapper' ).css( 'display', 'block' );

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
    function getAllCustomers()
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "EditCustomer.aspx/GetAllCustomers",
            contentType: "application/json; charset=utf-8",
            success: function ( result )
            {
                var jsonCustomerDetails = JSON.parse( result.d );
                $( '#dtViewCustomers' ).DataTable( {
                    data: jsonCustomerDetails,
                    columns: [
                        { data: "CustomerId" },
                        { data: "EmailID" },
                        { data: "CustomerName" },
                        {
                            data: "DOB",
                            render: function ( jsonDOB )
                            {
                                return getFormattedDateUK( jsonDOB );
                            }
                        },
                        { data: "Address" },
                        { data: "Mobile" },
                        { defaultContent: "<button class='btn btn-warning'>Select</button>" }
                    ]
                } );
            },
            error: function ( response )
            {
                alert( 'Unable to Bind All Customers' );
            }
        } );//end of ajax

        $( '#dtViewCustomers tbody' ).on( 'click', 'button', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            var vCustomerId = vClosestTr.find( 'td' ).eq( 0 ).text();
            var vEmailID = vClosestTr.find( 'td' ).eq( 1 ).text();
            var vCustomerName = vClosestTr.find( 'td' ).eq( 2 ).text();
            var vDateOfBirth = vClosestTr.find( 'td' ).eq( 3 ).text();
            var vAddress = vClosestTr.find( 'td' ).eq( 4 ).text();
            var vMobile = vClosestTr.find( 'td' ).eq( 5 ).text();

            $( '#<%=hfCustomerId.ClientID%>' ).val( vCustomerId );
            $( '#<%=txtEmailID.ClientID%>' ).val( vEmailID );
            $( '#<%=txtCustomerName.ClientID%>' ).val( vCustomerName );
            $( '#<%=txtDOB.ClientID%>' ).val( vDateOfBirth );
            $( '#txtAddressLine1' ).val( vAddress );
            $( '#txtMobile' ).val(vMobile);

            $( '#dvCustomerDetails' ).css( 'display', 'block' );
            $( '#dtViewCustomers_wrapper' ).css( 'display', 'none' );

            return false;
        } );
    }
</script>

<script>
    function updateCustomerDetails()
    {
        //Saving Customer Details First
        var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
        var EmailID = $("#<%=txtEmailID.ClientID%>").val().trim();

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

                Title = Names[0];
                FirstName = Names[1];
                LastName = Names[2];
            }
        }

        var DOB = $("#<%=txtDOB.ClientID%>").val().trim();
        var Address = $("#txtAddressLine1").val().trim();
        var Mobile = $("#txtMobile").val().trim();

        //alert( CustomerId + '\n'
        //    + EmailID + '\n'
        
        //    + Title + '\n'
        //    + FirstName + '\n'
        //    + LastName + '\n'

        //    + DOB + '\n'
        //    + Address + '\n'
        //    + Mobile + '\n'
        //    );

        //Binding Customer Details to object
        var objCustomer = {};

        objCustomer.CustomerId = CustomerId;
        objCustomer.EmailID = EmailID;

        objCustomer.Title = Title;
        objCustomer.FirstName = FirstName;
        objCustomer.LastName = LastName;

        objCustomer.DOB = DOB;
        objCustomer.Address = Address;
        objCustomer.Mobile = Mobile;

        $.ajax({
            type: "POST",
            url: "EditCustomer.aspx/UpdateCustomerDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objCustomer),
            dataType: "json",
            success: function (result) {
                $( '#spFullName' ).text( FullName );
                $( '#Customer-bx' ).modal( 'show' );

                $( '#dvCustomerDetails' ).css( 'display', 'none' );
                $( '#dtViewCustomers' ).DataTable().destroy();
                getAllCustomers();
                $( '#dtViewCustomers_wrapper' ).css( 'display', 'block' );
            },
            error: function ( response )
            {
                alert( 'Unable to Update Customer Details' );
            }
        });

        return false;
    }

    function editCustomerDetails()
    {
        if ( checkBlankControls() )
        {
            updateCustomerDetails();
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
                    Edit Customer
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 col-md-offset-2">
                <div class="hpanel">
                    <form id="frmEditCustomer" runat="server">

                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                        
                        <asp:HiddenField ID="hfCustomerId" runat="server" />

                    <asp:HiddenField ID="hfPickupLatitude" runat="server" />
                    <asp:HiddenField ID="hfPickupLongitude" runat="server" />
                    </div>
                    <div class="panel-body clrBLK col-md-10 dashboad-form">
                        <div id="dvCustomerDetails">
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
                                <div class="form-group"><label class="col-sm-4 control-label">Name <span style="color: red">*</span></label>
                                    <select id="CustomerTitle">
                                            <option value="Mr" selected="selected">Mr</option>
                                            <option value="Mrs">Mrs</option>
                                            <option value="Miss">Miss</option>
                                        </select>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtCustomerName" runat="server" MaxLength="50"
                                            CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter Name"
                                            onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>                            
                                    </div>
                                    <br />
                                </div>
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">Date Of Birth <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtDOB" runat="server" CssClass="clrBLK form-control"
                                            ReadOnly="true" onchange="clearErrorMessage();checkAdultDate();"></asp:TextBox>
                                    </div>
                                </div>
                                <br />
                            </div>
                            <!--Added new Script Files for Date Picker-->
                            <script src="/js/bootstrap-datepicker.js"></script>
                            <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">Address <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <input type="text" id="txtAddressLine1" class="form-control" 
                                        placeholder="Enter an Address" title="Please enter Address for Customer"
                                        onkeypress="clearErrorMessage();" />
                                        <div id="CollectionMap"></div>    
                                    </div>
                                </div>
                                <br /><br />
                            </div>
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">Mobile (+44) <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                 
                     <input id="txtMobile" class="flag-tel" type="tel" placeholder="Enter Phone Number" 
                         title="Please enter Customer Mobile Number"
                         onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;" />

                                        </div>
                                    </div>
                                </div>
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <div class="col-sm-4"></div>
                                    <div class="col-sm-8">
                                            <asp:Button ID="btnUpdateCustomer" runat="server" Text="Update"
                                                CssClass="btn btn-primary btn-register" 
                                                OnClientClick="return editCustomerDetails();" />
                                            <asp:Button ID="btnCancelUpdate" runat="server" Text="Cancel" class="btn btn-default"
                                            OnClientClick="return clearAllControls();" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div>
                            <table id="dtViewCustomers">
                                <thead>
                                    <tr>
                                        <th>Customer Id</th>
                                        <th>Email Address</th>
                                        <th>Customer Name</th>
                                        <th>Date Of Birth</th>
                                        <th>Customer Address</th>
                                        <th>Mobile</th>
                                        <th>Select</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-10">
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

  <div class="modal fade" id="Customer-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Customer Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spFullName"></span>'s Details updated successfully</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

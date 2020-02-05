<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="ViewAllLocations.aspx.cs" Inherits="JobyCoWeb.Location.ViewAllLocations"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

    <style>
        .print, .edit, .delete {
            background:none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

        .print:hover, .edit:hover, .delete:hover {
            background: #fca311;
            color:#fff;
            text-shadow:1px 1px 1px rgba(0,0,0,0.4);
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
            function checkBlankControls() {            
                var Country = $( "#<%=ddlCountry.ClientID%>" );
                var vCountry = Country.find( 'option:selected' ).text().trim();

                var City = $("#<%=ddlCity.ClientID%>");
                var vCity = City.find( 'option:selected' ).text().trim();

                var LocationName = $("#<%=ddlLocations.ClientID%>");
                var vLocationName = LocationName.find( 'option:selected' ).text().trim();

                var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
                vErrMsg.text('');
                vErrMsg.css("display", "none");
                vErrMsg.css("background-color", "#ffd3d9");
                vErrMsg.css("color", "red");
                vErrMsg.css("text-align", "center");

                if ( vCountry == "Select Country" )
                {
                    vErrMsg.text( 'Please select a Country from dropdown' );
                    vErrMsg.css( "display", "block" );
                    Country.focus();
                    return false;
                }

                if ( vCity == "Select City" )
                {
                    vErrMsg.text( 'Please select a City from dropdown' );
                    vErrMsg.css( "display", "block" );
                    City.focus();
                    return false;
                }

                if ( vLocationName == "Select Location" )
                {
                    vErrMsg.text( 'Please select a Location from dropdown' );
                    vErrMsg.css("display", "block");
                    LocationName.focus();
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
        function updateLocationDetails()
        {
            var LocationId = $( "#<%=txtLocationID.ClientID%>" ).val().trim();
            var LocationName = $( "#<%=ddlLocations.ClientID%>" ).find( 'option:selected' ).text().trim();

            var CountryId = $( '#<%=hfCountryId.ClientID%>' ).val().trim();
            //alert('CountryId = ' + CountryId);
            var CityId = $('#<%=hfCityId.ClientID%>').val().trim();
            //alert( 'CityId = ' + CityId );

            var objLocation = {};

            objLocation.LocationId = LocationId;
            objLocation.LocationName = LocationName;
            objLocation.CountryId = CountryId;
            objLocation.CityId = CityId;

            $.ajax( {
                type: "POST",
                url: "ViewAllLocations.aspx/UpdateLocationDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify( objLocation ),
                dataType: "json",
                success: function ( result )
                {
                    $( '#Location-bx' ).modal( 'show' );                
                },
                error: function ( response )
                {
                    alert( 'Location Details Updation failed' );
                }
            } );

            return false;
        }

        function editLocationDetails()
        {
            if ( checkBlankControls() )
            {
                updateLocationDetails();
                //setTimeout( function () { }, 3000 );
            }

            return false;
        }

        function removeLocationDetails()
        {
            var LocationId = $( '#<%=hfLocationId.ClientID%>' ).val().trim();

            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllLocations.aspx/RemoveLocationDetails",
                data: "{ LocationId: '" + LocationId + "'}",
                success: function ( result )
                {
                    location.reload();
                },
                error: function ( response )
                {
                    alert( 'Unable to Remove Location Details' );
                }
            } );
        }

    </script>

    <script>
        $( document ).ready( function ()
        {
            $( '#dvLocationDetails' ).css( 'display', 'none' );

            getAllLocations();
            getAllCountries();
        } );
    </script>

    <script>
        function getAllLocations()
        {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllLocations.aspx/GetAllLocations",
                contentType: "application/json; charset=utf-8",
                success: function (data)
                {
                    var jsonLocationDetails = JSON.parse( data.d );
                    $( '#dtViewLocation' ).DataTable( {
                        data: jsonLocationDetails,
                        columns: [
                            { data: "LocationId" },
                            { data: "LocationName" },
                            { data: "LocationAddress" },
                            {
                                defaultContent:
                                  "<button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-times' aria-hidden='true'></i></button>"
                            }
                        ]
                    } );
                },
                error: function (response) {
                    alert('Unable to Bind View All Locations');
                }
            } );//end of ajax

            $( '#dtViewLocation tbody' ).on( 'click', '.print', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vLocationId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#spLocationId' ).text( vLocationId );
                $( '#spHeaderLocationId' ).text( vLocationId );

                var vLocationName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#spLocationName' ).text( vLocationName );

                var vCountryName = vClosestTr.find( 'td' ).eq( 2 ).text();
                $( '#spCountryName' ).text( vCountryName );

                var vCityName = vClosestTr.find( 'td' ).eq( 3 ).text();
                $( '#spCityName' ).text( vCityName );

                return printDetails('tblLocationDetails');

                //$( '#dvLocationModal' ).modal( 'show' );
                //return false;
            } );

            $( '#dtViewLocation tbody' ).on( 'click', '.edit', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vLocationId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#<%=txtLocationID.ClientID%>' ).val( vLocationId );

                var vLocationName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=ddlLocations.ClientID%>' ).find('option:selected').text(vLocationName);

                var vCountryName = vClosestTr.find( 'td' ).eq( 2 ).text();
                $( '#<%=ddlCountry.ClientID%>' ).find('option:selected').text(vCountryName);

                var vCityName = vClosestTr.find( 'td' ).eq( 3 ).text();
                $( '#<%=ddlCity.ClientID%>' ).find('option:selected').text(vCityName);

                //Make appear Edit Details
                //====================================================
                $( '#dvLocationDetails' ).css( 'display', 'block' );
                $( '#dvLocationDetails' ).css( 'margin-left', '100px' );
                //====================================================

                //Make disappear View All Details 
                //=======================================================
                $( '#dtViewLocation_wrapper' ).css( 'display', 'none' );
                disappearAllButtons();
                //=======================================================

                return false;
            } );

            $( '#dtViewLocation tbody' ).on( 'click', '.delete', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vLocationId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#<%=hfLocationId.ClientID%>' ).val( vLocationId );

                $( '#RemoveLocation-bx' ).modal( 'show' );
                return false;
            } );

            return false;
        }

    </script>

    <script>
        function disappearAllButtons()
        {
            $( '#<%=btnAddNewLocation.ClientID%>' ).css( 'display', 'none' );
            $( '#<%=btnPrintAllLocations.ClientID%>' ).css( 'display', 'none' );
            $( '#<%=btnExportViewAllLocationsPDF.ClientID%>' ).css( 'display', 'none' );
            $( '#<%=btnExportViewAllLocationsExcel.ClientID%>' ).css( 'display', 'none' );

            return false;
        }

        function gotoAddLocation()
        {
            location.href = '/Location/NewLocation.aspx';
            return false;
        }

        function takePrintout()
        {
            prtContent = document.getElementById( 'dtViewLocation' );
            prtContent.border = 0; //set no border here

            var WinPrint = window.open( '', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1' );
            WinPrint.document.write( prtContent.outerHTML );
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

            return false;
        }
    </script>

    <script>
    function getAllCountries()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllLocations.aspx/GetAllCountries",
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
            url: "ViewAllLocations.aspx/GetCountryIdFromName",
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
            url: "ViewAllLocations.aspx/GetSpecificCities",
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
            url: "ViewAllLocations.aspx/GetCityIdFromName",
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
            url: "ViewAllLocations.aspx/GetSpecificLocations",
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
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    View All Locations
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <form id="frmViewLocation" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                <div class="hpanel">
                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>

                            <asp:HiddenField ID="hfLocationId" runat="server" />
                            <asp:HiddenField ID="hfCountryId" runat="server" />
                            <asp:HiddenField ID="hfCityId" runat="server" />
                    </div>

                    <div id="dvLocationDetails" class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">Location Id</label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtLocationID" runat="server"
                                            CssClass="form-control m-b" ReadOnly="true"></asp:TextBox>
                                    </div>                        
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">Country Name <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:DropDownList ID="ddlCountry" runat="server"
                                            CssClass="form-control m-b" title="Please select a Country from dropdown"
                                            onchange="getCountryIdFromName(); clearErrorMessage();">
                                            <asp:ListItem>Select Country</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">City Name <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlCity" runat="server"
                                        CssClass="form-control m-b" title="Please select a City from dropdown"
                                        onchange="getCityIdFromName();clearErrorMessage();">
                                        <asp:ListItem>Select City</asp:ListItem>
                                    </asp:DropDownList>
                                    </div>
                                </div>
                                <br /><br />
                            </div>
                            <div class="row">
                                <div class="form-group"><label class="col-sm-4 control-label">Location Name <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:DropDownList ID="ddlLocations" runat="server"
                                            CssClass="form-control m-b" title="Please select a Location from dropdown"
                                            onchange="clearErrorMessage();">
                                            <asp:ListItem>Select Location</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <br />
                                </div>
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <div class="col-sm-4"></div>
                                    <div class="col-sm-8">
                                            <asp:Button ID="btnUpdateLocation" runat="server" Text="Update"
                                                CssClass="btn btn-primary btn-register" 
                                                OnClientClick="return editLocationDetails();" />
                                            <asp:Button ID="btnCancelUpdateDelete" runat="server" Text="Cancel" class="btn btn-default"
                                            OnClientClick="return clearAllControls();" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    <div class="box_bg">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="row marginbottom1">
                                    <div class="col-md-12 view_left">
                                        <span class="iconADD">
                                            <asp:Button ID="btnPrintAllLocations" runat="server"  
                                                Text="Print All Locations" OnClientClick="return takePrintout();" />
                                            <i class="fa fa-print" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD">
                                            <asp:Button ID="btnAddNewLocation" runat="server"  
                                            Text="Add New Location" OnClientClick="return gotoAddLocation();" />
                                            <i class="fa fa-user" aria-hidden="true"></i>
                                        </span>
                               
                                        <span class="iconADD">
                                            <asp:Button ID="btnExportViewAllLocationsExcel" runat="server"  
                                            Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD">
                                            <asp:Button ID="btnExportViewAllLocationsPDF" runat="server"  
                                                Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                            <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tble_main">
                        <%--<table id="dtViewLocation">
                            <thead>
                                <tr>
                                    <th>Location Id</th>
                                    <th>Location Name</th>
                                    <th>Country Name</th>
                                    <th>City Name</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>--%>
                            <table id="dtViewLocation">
                                <thead>
                                    <tr>
                                        <th>Location Id</th>
                                        <th>Location Name</th>
                                        <th>Location Address</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
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
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Location - Update</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Location Details updated successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" 
                        onclick="location.reload();">OK</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="RemoveLocation-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Remove Location</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <p>Sure? You want to remove this Location?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="removeLocationDetails();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>
      
        </div>
    </div>

    <div class="modal fade" id="dvLocationModal" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Location Details: #<span id="spHeaderLocationId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Location below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintLocationModal" data-dismiss="modal" 
                                    onclick="return printDetails('tblLocationDetails');" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfLocationModal" data-dismiss="modal" 
                                    onclick="exportToPDF('dvLocationModal', 'LocationDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelLocationModal" data-dismiss="modal" 
                                    onclick="exportToExcel('tblLocationDetails', 'LocationDetails.xls');" style="margin-bottom:10px;">
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
                                                <table class="table custoFULLdet" id="tblLocationDetails">
                                                    <tr>
                                                        <th>Location Id: </th>
                                                        <td><span id="spLocationId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Location Name: </th>
                                                        <td><span id="spLocationName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Country Name: </th>
                                                        <td><span id="spCountryName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>City Name: </th>
                                                        <td><span id="spCityName"></span></td>
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

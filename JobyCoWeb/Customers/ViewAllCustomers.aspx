<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true"
    CodeBehind="ViewAllCustomers.aspx.cs" Inherits="JobyCoWeb.Customers.ViewAllCustomers"
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
            background: none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

            .pdf:hover, .view:hover, .edit:hover, .delete:hover {
                background: #fca311;
                color: #fff;
                text-shadow: 1px 1px 1px rgba(0,0,0,0.4);
            }

        #btnPrintPdfCustomerModal, #btnPrintExcelCustomerModal {
            background: #FAA51A /*url(../images/load.png) 5px center no-repeat*/;
            color: #fff;
            padding: 5.5px 12px !important;
            border: none;
            padding: 0;
            border-radius: 0;
            width: auto;
            border: 1px solid #FAA51A;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 0;
        }

            #btnPrintPdfCustomerModal:hover, #btnPrintExcelCustomerModal:hover {
                background: none;
                color: #FAA51A;
                border: 1px solid #FAA51A !important;
                -webkit-transition: all 0.2s linear;
                -moz-transition: all 0.2s linear;
                -o-transition: all 0.2s linear;
                transition: all 0.2s linear;
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
            display: inline-block;
            height: auto;
        }
        .dataTables_filter, .dataTables_info { display: none; }

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
    </style>

    <!-- New Script Added for Dynamic Menu Population
================================================== -->
    <script>
        $(document).ready(function () {
            getAllCustomers();

            var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
            accessibleMenuItems(hfMenusAccessibleValues);

            var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
            accessiblePageControls(hfControlsAccessible);



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
            $("#txtLandline").intlTelInput("setCountry", "gb");

            $( '#<%=txtDOB.ClientID%>').datepicker({
                format: 'dd-mm-yyyy',
                todayHighlight: true,
                autoclose: true
            });

            $("#cbSelectAll").change(function () {
                var tblCustomer = $('#dtViewCustomer').DataTable();

                var allCheckBoxes = $(tblCustomer.$('input[type="checkbox"]').map(function () {
                    return $(this).closest('tr');
                }));

                for (var i = 0; i < allCheckBoxes.length; i++) {
                    allCheckBoxes[i].find('input[type=checkbox]:eq(0)').prop('checked', $(this).prop("checked"));

                    var vCustomerId = allCheckBoxes[i].find('td').eq(1).text();
                    var vEmailID = allCheckBoxes[i].find('td').eq(2).text();
                    var vCustomerName = allCheckBoxes[i].find('td').eq(3).text();
                    var vDateOfBirth = allCheckBoxes[i].find('td').eq(4).text();
                    var vAddress = allCheckBoxes[i].find('td').eq(5).text();
                    var vMobile = allCheckBoxes[i].find('td').eq(6).text();

                    var vCustomer_Check = "";
                    vCustomer_Check += "<tr>";
                    vCustomer_Check += "<td>" + vCustomerId + "</td>";
                    vCustomer_Check += "<td>" + vEmailID + "</td>";
                    vCustomer_Check += "<td>" + vCustomerName + "</td>";
                    vCustomer_Check += "<td>" + vDateOfBirth + "</td>";
                    vCustomer_Check += "<td>" + vAddress + "</td>";
                    vCustomer_Check += "<td>" + vMobile + "</td>";
                    vCustomer_Check += "</tr>";

                    if ($(allCheckBoxes[i].find('input[type=checkbox]:eq(0)')).is(":checked")) {
                        $("#dtViewCustomer_Check tbody").append(vCustomer_Check);
                    }
                    else {
                        var vCheckCustomerId = "";

                        $('#dtViewCustomer_Check tbody > tr').each(function () {
                            vCheckCustomerId = $(this).find('td:eq(0)').text().trim();

                            if (vCustomerId == vCheckCustomerId) {
                                $(this).remove();
                            }
                        });
                    }
                }

                //For all Checkboxes in the Current Page 
                //$( "input:checkbox" ).prop( 'checked', $( this ).prop( "checked" ) );
            });

        });
</script>

    <script>
        function InitializeMap() {


            var PLat = $("#<%=hfPickupLatitude.ClientID%>").val();
            var Plong = $("#<%=hfPickupLongitude.ClientID%>").val();

            //alert(PLat + '  '+ Plong);

            var latlng = new google.maps.LatLng(PLat, Plong);

            var myCollectionOptions = {
                zoom: 6,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var CollectionMap = new google.maps.Map(document.getElementById("CollectionMap"), myCollectionOptions);

            //alert(DLat + '  '+ Dlong);

            var defaultCollectionBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(-33.8902, 151.1759),
                new google.maps.LatLng(-33.8474, 151.2631)
            );

            var optionsCollection = {
                bounds: defaultCollectionBounds
            };
            var placesCollection = new google.maps.places.Autocomplete(document.getElementById( '<%=txtAddressLine1.ClientID%>'), optionsCollection);

            google.maps.event.addListener(placesCollection, 'place_changed', function () {
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

                var latlngCollection = new google.maps.LatLng(latitudeCollection, longitudeCollection);

                myCollectionOptions = {
                    zoom: 8,
                    center: latlngCollection,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                mapCollection = new google.maps.Map(document.getElementById("CollectionMap"), myCollectionOptions);
                document.getElementById("CollectionMap").style.width = document.getElementById("<%=txtAddressLine1.ClientID%>").style.width;
                $("#CollectionMap").css('height', '150px');
                //alert( 'Collection Place Changed' );
            });
        }

        function checkBlankControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");
            var vMobile = $("#txtMobile");

            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");

            var vHearAboutUs = $("#<%=ddlHearAboutUs.ClientID%>");
            var vYesRegisteredCompany = $("#<%=rbYesRegisteredCompany.ClientID%>");
            var vNoRegisteredCompany = $("#<%=rbNoRegisteredCompany.ClientID%>");

            var vErrMsg = $( "#<%=lblErrMsg.ClientID%>");
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

            var spaceCount = countWhiteSpace(vCustomerName.val().trim());
            if (spaceCount > 3) {
                vErrMsg.text('Your Name is Too Long');
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

            if (CustomerDateTime != "" && vCurrentDate != "") {
                var dt1 = parseInt(CustomerDateTime.substring(0, 2), 10);
                var mon1 = parseInt(CustomerDateTime.substring(3, 5), 10);
                var yr1 = parseInt(CustomerDateTime.substring(6, 10), 10);

                var dt2 = parseInt(vCurrentDate.substring(0, 2), 10);
                var mon2 = parseInt(vCurrentDate.substring(3, 5), 10);
                var yr2 = parseInt(vCurrentDate.substring(6, 10), 10);

                var From_date = new Date(yr1, mon1, dt1);
                var To_date = new Date(yr2, mon2, dt2);
                var diff_date = To_date - From_date;

                var years = Math.floor(diff_date / 31536000000);
                var months = Math.floor((diff_date % 31536000000) / 2628000000);
                var days = Math.floor(((diff_date % 31536000000) % 2628000000) / 86400000);

                //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

                if (years < 18) {
                    vErrMsg.text('User must be atleast 18 years of age');
                    vErrMsg.css("display", "block");
                    return false;
                }
                else {
                    if (months < 0) {
                        vErrMsg.text('User must be atleast 18 years of age');
                        vErrMsg.css("display", "block");
                        return false;
                    }
                    else {
                        if (days < 0) {
                            vErrMsg.text('User must be atleast 18 years of age');
                            vErrMsg.css("display", "block");
                            return false;
                        }
                    }
                }
            }

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

            if (vAddressLine1.val().trim() == "") {
                vErrMsg.text('Plese enter Address');
                vErrMsg.css("display", "block");
                vAddressLine1.focus();
                return false;
            }

            if (!vYesRegisteredCompany.is(":checked") && !vNoRegisteredCompany.is(":checked")) {
                vErrMsg.text('Please choose Answer whether you have a Registered Company or not');
                vErrMsg.css("display", "block");
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vCustomerId = $( '#<%=hfCustomerId.ClientID%>');
            var vEmailID = $( "#<%=txtEmailID.ClientID%>");
            var vCustomerName = $("#<%=txtCustomerName.ClientID%>");
            var vDOB = $("#<%=txtDOB.ClientID%>");
            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");
            var vMobile = $("#txtMobile");

            clearErrorMessage();

            vCustomerId.val('');
            vEmailID.val('');

            vCustomerName.val('');
            vDOB.val('');
            vAddressLine1.val('');
            vMobile.val('');

            $('#dvCustomerDetails').css('display', 'none');
            $('#dtViewCustomer_wrapper').css('display', 'block');
            appearAllButtons();

            //Few extra elements to make visible
            $('.flexible').css('display', 'block');
            $('.iconADD i').css('display', 'block');

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
            }
            else {
                vShippingGoodsInCompanyName.hide();
                vRegisteredCompanyName.hide();
            }
        }

</script>

    <script>
        function checkFromAndToDate(vFromDate, vToDate) {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            if (vFromDate != "" && vToDate != "") {
                var dt1 = parseInt(vFromDate.substring(0, 2), 10);
                var mon1 = parseInt(vFromDate.substring(3, 5), 10);
                var yr1 = parseInt(vFromDate.substring(6, 10), 10);

                var dt2 = parseInt(vToDate.substring(0, 2), 10);
                var mon2 = parseInt(vToDate.substring(3, 5), 10);
                var yr2 = parseInt(vToDate.substring(6, 10), 10);

                var stDate = new Date(yr1, mon1, dt1);
                var enDate = new Date(yr2, mon2, dt2);
                var diff_date = enDate - stDate;

                var years = Math.floor(diff_date / 31536000000);
                var months = Math.floor((diff_date % 31536000000) / 2628000000);
                var days = Math.floor(((diff_date % 31536000000) % 2628000000) / 86400000);

                //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

                if (years < 18) {
                    vErrMsg.text('User must be atleast 18 years of age');
                    vErrMsg.css("display", "block");
                    return false;
                }
                else {
                    if (months < 0) {
                        vErrMsg.text('User must be atleast 18 years of age');
                        vErrMsg.css("display", "block");
                        return false;
                    }
                    else {
                        if (days < 0) {
                            vErrMsg.text('User must be atleast 18 years of age');
                            vErrMsg.css("display", "block");
                            return false;
                        }
                    }
                }
            }
        }

        function checkAdultDate() {
            //Date Checking Added on Text Change
            var vDateOfBirth = $( "#<%=txtDOB.ClientID%>").val().trim();
            var vCurrentDate = getCurrentDateDetails();
            checkFromAndToDate(vDateOfBirth, vCurrentDate);
        }

</script>

    <script>
        function getAllOptions() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AddCustomer.aspx/GetAllOptions",
                data: "{}",
                dataType: "json",
                success: function (result) {
                    $.each(result.d, function (key, value) {
                        $( "#<%=ddlHearAboutUs.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                    })
                },
                error: function (response) {
                }
            });
        }

        function getAllCustomers() {
            if ($('#hdnpgIdx').val() == "") {
                $('#hdnpgIdx').val('1');
            }
            //$("#loadingDiv").css('display', 'flex');
            //$.ajax( {
            //    method: "POST",
            //    contentType: "application/json; charset=utf-8",
            //    url: "ViewAllCustomers.aspx/GetAllCustomers",
            //    data: JSON.stringify({ "pageidx": $('#hdnpgIdx').val(), "length": 10 }),
            //    beforeSend: function () {
            //        //$("#loadingDiv").show();
            //        $("#loadingDiv").css('display', 'flex');
            //    },
            //    complete: function () {
            //        setTimeout(function () {
            //            $('#loadingDiv').fadeOut();
            //        }, 700);
            //    },
            //    success: function ( result )
            //    {
            //        console.log(result);
            //        var jsonCustomerDetails = JSON.parse( result.d );
            //        $( '#dtViewCustomer' ).DataTable({
            //            data: jsonCustomerDetails,
            //            "pagingType": "full_numbers",
            //            "paging": true,
            //            deferRender: true,
            //            columns: [
            //                { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
            //                { data: "CustomerId" },
            //                { data: "EmailID" },
            //                { data: "CustomerName" },
            //                {
            //                    data: "sDOB",
            //                    render: function ( jsonDOB )
            //                    {
            //                        //return getFormattedDateUK( jsonDOB );
            //                        return jsonDOB;
            //                    }
            //                },
            //                { data: "Address" },
            //                { data: "Mobile" },
            //                {
            //                    defaultContent:
            //                        "<button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-trash' aria-hidden='true'></i></button>"
            //                }
            //            ],
            //            "aaSorting": [
            //                [1, "desc"]
            //            ]
            //        } );
            //    },
            //    error: function ( response )
            //    {

            //        $('#loadingDiv').fadeOut();
            //        alert( 'Unable to Bind All Customers' );
            //    }
            //} );//end of ajax

            var tableInstance = $('#dtViewCustomer').DataTable({
                "serverSide": true,
                //"processing": true,
                "pagingType": "numbers",
                //"pageLength": 10,
                language: {
                    searchPlaceholder: "Search by press enter"
                },
                "columns": [
                    { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
                    { "data": "CustomerId", "searchable": true },
                    { "data": "EmailID", "searchable": true },
                    { "data": "CustomerName", "searchable": true },
                    {
                        "data": "DOB",
                        "render": function (date) {
                            return getFormattedDateUK(date);
                        }

                    },
                    { "data": "Address", "searchable": true },
                    { "data": "Mobile", "searchable": true },
                    {
                        defaultContent:
                            "<button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-trash' aria-hidden='true'></i></button>"
                    }
                ],
                "ajax": {
                    contentType: "application/json; charset=utf-8",
                    url: "ViewAllCustomers.aspx/GetAllCustomers",
                    type: "Post",
                    // compensate for where .net puts the data in the d object
                    //dataSrc: "d.data",
                    data: function (dtParms) {
                        // notice dtParameters exactly matches the web service parameter name
                        return JSON.stringify({ dtParameters: dtParms });
                    },
                   dataFilter: function(data){
                    var json = jQuery.parseJSON( data );
                    json.draw = json.d.draw;
                    json.recordsFiltered = json.d.recordsTotal; //This is very important for paging to calculate. I am getting total from unfiltered count from SP to get total number of pages
                    json.data = json.d.data;
          
                    return JSON.stringify( json ); // return JSON string
                },
                    error: function (x) {
                        console.log(x);
                    }
                },
                "fnInfoCallback": function (settings, start, end, max, total, pre) {
                    var api = this.api();
                    var pageInfo = api.page.info();
                    return '';
                },
                order: [[0, 'asc']]
            });

            // Apply the search
            //This is not a good method but since this is server side we will have to bring records which matches with the input string by making a server side call
            //If we use column method it keeps searching the grid and do the roundtrip so , user need to search only when it hits enter
            tableInstance.columns().eq(0).each(function (colIdx) {
                $('input').keyup(function (e) {
                    var key = e.which;
                    if (key == 13)  // the enter key code
                    {
                        tableInstance.columns().search(this.value).draw();
                    }
                });
            });

            var oTable = $('#dtViewCustomer').DataTable();
            $('#txtSearch').on('keyup',function(e){
                oTable.columns(0).search($('#txtSearch').val());
                oTable.columns(1).search($('#txtSearch').val());
                oTable.columns(2).search($('#txtSearch').val());
                oTable.columns(3).search($('#txtSearch').val());
                oTable.columns(4).search($('#txtSearch').val());
                oTable.columns(5).search($('#txtSearch').val());
                oTable.draw(false);
                if ($('#txtSearch').val().trim() == '') { oTable.ajax.reload(); }
            });
            //$('#txtSearch').onchange(function () {
            //    oTable.columns(0).search($('#txtSearch').val().trim());
            //    oTable.columns(1).search($('#txtSearch').val().trim());
            //    oTable.columns(2).search($('#txtSearch').val().trim());
            //    oTable.columns(3).search($('#txtSearch').val().trim());
            //    oTable.columns(4).search($('#txtSearch').val().trim());
            //    oTable.columns(5).search($('#txtSearch').val().trim());
            //    oTable.draw();
            //});

            $('#dtViewCustomer tbody').on('click', '.SelectCheckBox', function () {
                console.log($('#dtViewCustomer').DataTable().page.info());
                var vClosestTr = $(this).closest("tr");

                var vCustomerId = vClosestTr.find('td').eq(1).text();
                var vEmailID = vClosestTr.find('td').eq(2).text();
                var vCustomerName = vClosestTr.find('td').eq(3).text();
                var vDateOfBirth = vClosestTr.find('td').eq(4).text();
                var vAddress = vClosestTr.find('td').eq(5).text();
                var vMobile = vClosestTr.find('td').eq(6).text();

                var vCustomer_Check = "";
                vCustomer_Check += "<tr>";
                vCustomer_Check += "<td>" + vCustomerId + "</td>";
                vCustomer_Check += "<td>" + vEmailID + "</td>";
                vCustomer_Check += "<td>" + vCustomerName + "</td>";
                vCustomer_Check += "<td>" + vDateOfBirth + "</td>";
                vCustomer_Check += "<td>" + vAddress + "</td>";
                vCustomer_Check += "<td>" + vMobile + "</td>";
                vCustomer_Check += "</tr>";

                if ($(this).is(":checked")) {
                    $("#dtViewCustomer_Check tbody").append(vCustomer_Check);
                }
                else {
                    var vCheckCustomerId = "";

                    $('#dtViewCustomer_Check tbody > tr').each(function () {
                        vCheckCustomerId = $(this).find('td:eq(0)').text().trim();

                        if (vCustomerId == vCheckCustomerId) {
                            $(this).remove();
                        }
                    });
                }
            });

            $('#dtViewCustomer tbody').on('click', '.view', function () {
                var vClosestTr = $(this).closest("tr");

                clearCustomerModalPopup();

                var vCustomerId = vClosestTr.find('td').eq(1).text();
                var vEmailID = vClosestTr.find('td').eq(2).text();
                var vCustomerName = vClosestTr.find('td').eq(3).text();
                var vDateOfBirth = vClosestTr.find('td').eq(4).text();
                var vAddress = vClosestTr.find('td').eq(5).text();
                var vMobile = vClosestTr.find('td').eq(6).text();

                $('#spCustomerId').text(vCustomerId);
                $('#spCustomerName').text(vCustomerName);
                $('#spCustomerEmailID').text(vEmailID);
                $('#spCustomerDOB').text(vDateOfBirth);
                $('#spCustomerAddress').text(vAddress);
                $('#spCustomerMobile').text(vMobile);

                $('#spHeaderCustomerId').text('#' + vCustomerId);
                getCustomerPostCodeFromCustomerId(vCustomerId);
                $('#dvCustomerDetailsModal').modal('show');

                return false;
            });

            $('#dtViewCustomer tbody').on('click', '.edit', function () {
                var vClosestTr = $(this).closest("tr");

                var vCustomerId = vClosestTr.find('td').eq(1).text();
                var vEmailID = vClosestTr.find('td').eq(2).text();
                var vCustomerName = vClosestTr.find('td').eq(3).text();
                var vDateOfBirth = vClosestTr.find('td').eq(4).text();
                var vAddress = vClosestTr.find('td').eq(5).text();
                var vMobile = vClosestTr.find('td').eq(6).text();


                vCustomerName = vCustomerName.replace('  ', ' ');
                if (hasWhiteSpace(vCustomerName)) {
                    var spaceCount = countWhiteSpace(vCustomerName);
                    if (spaceCount == 1) {
                        var Names = vCustomerName.split(' ');
                        vCustomerName = Names[1];
                    }
                    if (spaceCount == 2) {
                        var Names = vCustomerName.split(' ');
                        vCustomerName = Names[1] + ' ' + Names[2];
                    }
                    if (spaceCount == 3) {
                        var Names = vCustomerName.split(' ');
                        vCustomerName = Names[1] + ' ' + Names[2] + ' ' + Names[3];
                    }
                    if (spaceCount == 4) {
                        var Names = vCustomerName.split(' ');
                        vCustomerName = Names[1] + ' ' + Names[2] + ' ' + Names[3] + ' ' + Names[3];
                    }
                }

                $( '#<%=hfCustomerId.ClientID%>').val(vCustomerId);
                $( '#<%=txtEmailID.ClientID%>').val(vEmailID);
                $( '#<%=txtCustomerName.ClientID%>').val(vCustomerName);
                $( '#<%=txtDOB.ClientID%>').val(vDateOfBirth);
                $( '#<%=txtAddressLine1.ClientID%>').val(vAddress);
                $('#txtMobile').val(vMobile);

                getCustomerPostCodeFromCustomerId(vCustomerId);
                getCustomerTitleFromCustomerId(vCustomerId);

                $('#dvCustomerDetails').css('display', 'block');
                $('#dtViewCustomer_wrapper').css('display', 'none');
                disappearAllButtons();

                //Few extra elements to invisible
                $('.flexible').css('display', 'none');
                $('.iconADD i').css('display', 'none');
                return false;
            });

            $('#dtViewCustomer tbody').on('click', '.delete', function () {
                var vClosestTr = $(this).closest("tr");
                var vCustomerId = vClosestTr.find('td').eq(1).text();
                $( '#<%=hfCustomerId.ClientID%>').val(vCustomerId);
                $('#CustomerRemoval-bx').modal('show');

                return false;
            });
        }
</script>

    <script>
        function RefreshGrid() {
            $('#dtViewCustomer').DataTable().ajax.reload();
        }
        function takePrintout() {
            var tblCustomer = $('#dtViewCustomer').DataTable();

            var result = $(tblCustomer.$('input[type="checkbox"]').map(function () {
                return $(this).prop("checked") ? $(this).closest('tr') : null;
            }));

            if (result.length > 0) {
                $('#PrintDataTable-bx').modal('show');
            }
            else {
                $('#Failure-bx').modal('show');
            }

            return false;
        }

        function printDataTable() {
            $('#PrintDataTable-bx').modal('hide');

            var bCheck = 0;
            var prtContent = "";

            if ($('#dtViewCustomer_Check tbody > tr').length > 0) {
                $('#dtViewCustomer_Check').css('display', 'block');

                bCheck = 1;
                prtContent = document.getElementById('dtViewCustomer_Check');
            }
            else {
                bCheck = 0;
                prtContent = document.getElementById('dtViewCustomer');
            }

            prtContent.border = 0; //set no border here
            var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
            WinPrint.document.write(prtContent.outerHTML);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

            if (bCheck == 1) {
                $('#dtViewCustomer_Check').css('display', 'none');
            }

            return false;
        }

</script>

    <script>
        function getCustomerPostCodeFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetCustomerPostCodeFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    $('#spCustomerPostCode').text(result.d);
                    $( '#<%=txtPostCode.ClientID%>').val(result.d);

                    getCustomerLandlineFromCustomerId(CustomerId);
                },
                error: function (response) {
                    alert('Unable to Bind Customer PostCode');
                }
            });
        }

        function getCustomerTitleFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetCustomerTitleFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    //alert(result.d);
                    $('#CustomerTitle').val(result.d);

                <%--$( '#spCustomerPostCode' ).text( result.d );
                $( '#<%=txtPostCode.ClientID%>' ).val( result.d );

                getCustomerLandlineFromCustomerId( CustomerId );--%>
                },
                error: function (response) {
                    alert('Unable to Bind Customer PostCode');
                }
            });
        }

        function getCustomerLandlineFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetCustomerLandlineFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    $('#spCustomerLandline').text(result.d);
                    $('#txtLandline').val(result.d);

                    getCustomerHearAboutUsFromCustomerId(CustomerId);
                },
                error: function (response) {
                    alert('Unable to Bind Customer Landline');
                }
            });
        }

        function getCustomerHearAboutUsFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetCustomerHearAboutUsFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    $('#spCustomerHearAboutUs').text(result.d);
                    $( '#<%=ddlHearAboutUs.ClientID%>').find('option:selected').text(result.d);

                    getHavingRegisteredCompanyFromCustomerId(CustomerId);
                },
                error: function (response) {
                    alert('Unable to Bind Customer Hear About Us');
                }
            });
        }

        function getHavingRegisteredCompanyFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetHavingRegisteredCompanyFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    var vResult = result.d.toString().toLowerCase();

                    switch (vResult) {
                        case "false":
                            $('#spHavingRegisteredCompany').text('No');
                            $( '#<%=rbNoRegisteredCompany.ClientID%>').attr('checked', 'checked');
                            break;

                        case "true":
                            $('#spHavingRegisteredCompany').text('Yes');
                            $( '#<%=rbYesRegisteredCompany.ClientID%>').attr('checked', 'checked');
                            break;
                    }

                    getRegisteredCompanyNameFromCustomerId(CustomerId);
                },
                error: function (response) {
                    alert('Unable to Bind Customer Having Registered Company');
                }
            });
        }

        function getRegisteredCompanyNameFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetRegisteredCompanyNameFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    $('#spRegisteredCompanyName').text(result.d);
                    $('#<%=txtCompanyName.ClientID%>').val(result.d);

                    getShippingGoodsInCompanyNameFromCustomerId(CustomerId);
                },
                error: function (response) {
                    alert('Unable to Bind Customer Registered Company Name');
                }
            });
        }

        function getShippingGoodsInCompanyNameFromCustomerId(CustomerId) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/GetShippingGoodsInCompanyNameFromCustomerId",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    var vResult = result.d.toString().toLowerCase();

                    switch (vResult) {
                        case "false":
                            $('#spShippingGoodsInCompanyName').text('No');
                            $( '#<%=rbNoShippingGoodsInCompanyName.ClientID%>').attr('checked', 'checked');
                            break;

                        case "true":
                            $('#spShippingGoodsInCompanyName').text('Yes');
                            $( '#<%=rbYesShippingGoodsInCompanyName.ClientID%>').attr('checked', 'checked');
                            break;
                    }
                },
                error: function (response) {
                    alert('Unable to Bind Customer Shipping Goods In Company Name');
                }
            });
        }

</script>

    <script>

        function disappearAllButtons() {
            $( '#<%=btnAddCustomerDetails.ClientID%>').css('display', 'none');
            $( '#<%=btnPrintCustomerDetails.ClientID%>').css('display', 'none');
            $( '#<%=btnExportPdfCustomerDetails.ClientID%>').css('display', 'none');
            $('#<%=btnExportExcelCustomerDetails.ClientID%>').css('display', 'none');
            $('#<%=btnRefresh.ClientID%>').css('display', 'none');
            $( '#txtSearch').css('display', 'none');

            return false;
        }

        function appearAllButtons() {
            $( '#<%=btnAddCustomerDetails.ClientID%>').css('display', 'block');
            $( '#<%=btnPrintCustomerDetails.ClientID%>').css('display', 'block');
            $( '#<%=btnExportPdfCustomerDetails.ClientID%>').css('display', 'block');
            $('#<%=btnExportExcelCustomerDetails.ClientID%>').css('display', 'block');
            $('#<%=btnRefresh.ClientID%>').css('display', 'block');
            $( '#txtSearch').css('display', 'block');

            return false;
        }

        function deactivateCustomer() {
            var CustomerId = $( '#<%=hfCustomerId.ClientID%>').val().trim();

            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllCustomers.aspx/DeactivateCustomer",
                data: "{ CustomerId: '" + CustomerId + "'}",
                success: function (result) {
                    location.reload();
                },
                error: function (response) {
                    alert('Unable to deactivate Customer Details');
                }
            });

            return false;
        }

        function updateCustomerDetails() {
            //Saving Customer Details First
            var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
            var EmailID = $("#<%=txtEmailID.ClientID%>").val().trim();

            var FullName = $("#<%=txtCustomerName.ClientID%>").val().trim();
            var Title = "";
            var FirstName = "";
            var LastName = "";
            var vCustomerTitle = $("#CustomerTitle").find('option:selected').text().trim();
            Title = vCustomerTitle;
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
                    FirstName = Names[0] + ' ' + Names[1];
                    LastName = Names[2];
                }
                if (spaceCount == 3) {
                    var Names = FullName.split(' ');

                    //Title = Names[0];
                    FirstName = Names[0] + ' ' + Names[1] + ' ' + Names[2];
                    LastName = Names[3];
                }
            }
            else {
                LastName = FullName;
            }

            var DOB = $("#<%=txtDOB.ClientID%>").val().trim();
            var Mobile = $("#txtMobile").val().trim();
            var Landline = $("#txtLandline").val().trim();

            var Address = $("#<%=txtAddressLine1.ClientID%>").val().trim();

            var LatitudePickup = $("#<%=hfPickupLatitude.ClientID%>").val().trim();
            var LongitudePickup = $("#<%=hfPickupLongitude.ClientID%>").val().trim();

            var PostCode = $( "#<%=txtPostCode.ClientID%>").val().trim();

            var HearAboutUs = $( '#<%=ddlHearAboutUs.ClientID%>').find('option:selected').text().trim();

            //========== Determining Whether having a Registered Company or not
            var HavingRegisteredCompany = "";
            var YesHavingRegisteredCompany = $( '#<%=rbYesRegisteredCompany.ClientID%>');
            var NoHavingRegisteredCompany = $( '#<%=rbNoRegisteredCompany.ClientID%>');

            if (YesHavingRegisteredCompany.is(":checked")) {
                HavingRegisteredCompany = "true";
            }

            if (NoHavingRegisteredCompany.is(":checked")) {
                HavingRegisteredCompany = "false";
            }
            //============================================================

            var RegisteredCompanyName = $( '#<%=txtCompanyName.ClientID%>').val().trim();

            //========== Determining Whether shipping Goods in Company Name or not
            var ShippingGoodsInCompanyName = "";
            var YesShippingGoodsInCompanyName = $( '#<%=rbYesShippingGoodsInCompanyName.ClientID%>');
            var NoShippingGoodsInCompanyName = $( '#<%=rbNoShippingGoodsInCompanyName.ClientID%>');

            if (YesShippingGoodsInCompanyName.is(":checked")) {
                ShippingGoodsInCompanyName = "true";
            }

            if (NoShippingGoodsInCompanyName.is(":checked")) {
                ShippingGoodsInCompanyName = "false";
            }


            //============================================================

            //Binding Customer Details to object
            var objCustomer = {};

            objCustomer.CustomerId = CustomerId;
            objCustomer.EmailID = EmailID;

            objCustomer.Title = Title;
            objCustomer.FirstName = FirstName;
            objCustomer.LastName = LastName;

            objCustomer.DOB = DOB;
            objCustomer.Mobile = Mobile;
            objCustomer.Landline = Landline;

            objCustomer.Address = Address;
            objCustomer.LatitudePickup = LatitudePickup;
            objCustomer.LongitudePickup = LongitudePickup;
            objCustomer.PostCode = PostCode;

            objCustomer.HearAboutUs = HearAboutUs;
            objCustomer.HavingRegisteredCompany = HavingRegisteredCompany;
            objCustomer.RegisteredCompanyName = RegisteredCompanyName;
            objCustomer.ShippingGoodsInCompanyName = ShippingGoodsInCompanyName;
            //alert(JSON.stringify(objCustomer));
            $.ajax({
                type: "POST",
                url: "ViewAllCustomers.aspx/UpdateCustomerDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objCustomer),
                dataType: "json",
                success: function (result) {
                    $('#spFullName').text(FullName);
                    $('#Customer-bx').modal('show');

                    //Instead of Resetting DataTable, load the Page once again
                    //=========================================================
                    //$( '#dvCustomerDetails' ).css( 'display', 'none' );

                    //$( '#dtViewCustomer' ).DataTable().destroy();
                    //getAllCustomers();
                    //$( '#dtViewCustomer_wrapper' ).css( 'display', 'block' );

                    //appearAllButtons();

                    //Few extra elements to make visible
                    //$( '.flexible' ).css( 'display', 'block' );
                    //$( '.iconADD i' ).css( 'display', 'block' );
                    //=========================================================
                },
                error: function (response) {
                    alert('Unable to Update Customer Details');
                }
            });

            return false;
        }

        function editCustomerDetails() {
            if (checkBlankControls()) {
                checkAddressDetails();
            }

            return false;
        }


        function checkAddressDetails() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");
            var Success = false;
            var Address1 = $( "#<%=txtAddressLine1.ClientID%>").val().trim();

            var geocoder = new google.maps.Geocoder();
            var address = Address1;

            geocoder.geocode({ 'address': address }, function (results, status) {

                if (status == google.maps.GeocoderStatus.OK) {
                    //debugger;
                    var latitude = results[0].geometry.location.latitude;
                    var longitude = results[0].geometry.location.longitude;
                    //2nd Block
                    var Address2 = $( "#<%=txtAddressLine1.ClientID%>").val().trim();
                    var geocoder = new google.maps.Geocoder();
                    var address = Address2;

                    geocoder.geocode({ 'address': address }, function (results, status) {

                        if (status == google.maps.GeocoderStatus.OK) {
                            //debugger;
                            var latitude = results[0].geometry.location.latitude;
                            var longitude = results[0].geometry.location.longitude;
                            //alert(latitude);
                            updateCustomerDetails();
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

</script>

    <script>
        function gotoAddCustomerPage() {
            location.href = '/Customers/AddCustomer.aspx';
            return false;
        }

        function createPDF1() {
            var pdf = new jsPDF('p', 'pt', 'letter');
            pdf.canvas.height = 72 * 11;
            pdf.canvas.width = 72 * 8.5;

            var vContent = document.getElementById("dvCustomerDetailsModal");
            pdf.fromHTML(vContent);

            pdf.save('CustomerDetails.pdf');
        }

        function fnExcelReport1() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tblCustomerDetails1'); // id of table

            for (j = 0; j < tab.rows.length; j++) {
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
                sa = txtArea1.document.execCommand("SaveAs", true, "CustomerDetails.xls");
            }
            else                 //other browser not tested on IE 11
                sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

            return (sa);
        }

        function printCustomerDetails() {
            var prtContent = document.getElementById('tblCustomerDetails1');
            prtContent.border = 0; //set no border here

            var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
            WinPrint.document.write(prtContent.outerHTML);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

            return false;
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
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="col-lg-12 text-center welcome-message">
        <h2>View All Customers
                </h2>
        <p></p>
    </div>
    <div style="display: none" id="hdnpgIdx"></div>
    <div class="col-lg-12">
        <div class="hpanel">
            <form id="frmViewAllCustomers" runat="server">
                <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                <asp:HiddenField ID="hfPickupLatitude" runat="server" />
                <asp:HiddenField ID="hfPickupLongitude" runat="server" />

                <div class="panel-heading">
                    <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                        Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>

                    <asp:HiddenField ID="hfCustomerId" runat="server" />
                </div>


                <div class="panel-body box_bg">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="form-group">
                                    <div class="col-sm-8">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <input type="text" class="form-control" style="color:black;" placeholder="Search" id="txtSearch" style="width: 400px;" />
                                            </div>
                                            <div class="col-md-3" style="display:none">
                                                <span class="iconADD pull-left">
                                                    <input type="button" class="btn btn-Export btn-Export-Customer-right" value="Filter" id="btnFilter" />
                                                    <i class="fa fa-search" aria-hidden="true"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-2 col-sm-2 col-xs-12">
                                        <span class="flexible">
                                            <input id="cbSelectAll" type="checkbox" name="cbSelectAll" />
                                            <label id="lblSelectAll" for="cbSelectAll">Select All</label>
                                        </span>
                                    </div>

                                    <div class="col-md-10 col-sm-10 col-xs-12">
                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnRefresh" runat="server"
                                                class="btn btn-info aa-add-row btn-Export btn-Export-Customer-right"
                                                Text="Refresh" OnClientClick="return RefreshGrid();" />
                                            <i class="fa fa-refresh" aria-hidden="true"></i>
                                        </span>
                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnPrintCustomerDetails" runat="server"
                                                class="btn btn-info aa-add-row btn-Export btn-Export-Customer-right"
                                                Text="Print Customer" OnClientClick="return takePrintout();" />
                                            <i class="fa fa-print" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnAddCustomerDetails" runat="server"
                                                class="btn btn-info aa-add-row btn-Export btn-Export-Customer-right"
                                                Text="Add Customer" OnClientClick="return gotoAddCustomerPage();" />
                                            <i class="fa fa-user" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD pull-right ">
                                            <asp:Button ID="btnExportPdfCustomerDetails" runat="server"
                                                class="btn btn-info aa-add-row btn-Export btn-Export-Customer-left"
                                                Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                            <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnExportExcelCustomerDetails" runat="server"
                                                class="btn btn-info aa-add-row btn-Export btn-Export-Customer-left"
                                                Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="dvCustomerDetails" class="clrBLK col-md-12 dashboad-form" style="padding: 0px; box-shadow: none; border: none; display: none;">
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Email Address <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtEmailID" runat="server"
                                            CssClass="form-control m-b border-BLK" PlaceHolder="example@gmail.com"
                                            title="Please enter Email Address" Style="text-transform: lowercase;"
                                            MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                        Name <span style="color: red">*</span>
                                        <select id="CustomerTitle" style="width: auto; float: right; margin: 0px 0 0 0; padding: 9px 4px; background: #3d4145;">
                                            <option value="Mr" selected="selected">Mr</option>
                                            <option value="Mrs">Mrs</option>
                                            <option value="Miss">Miss</option>
                                        </select>
                                        <%--<asp:DropDownList ID="ddlCustomerTitle" runat="server" CssClass="CustomerEditTitleStyle"  >
                                            <asp:ListItem Text="Mr" Value="Mr" Selected="True">Mr</asp:ListItem>
                                            <asp:ListItem Text="Mrs" Value="Mrs">Mrs</asp:ListItem>
                                            <asp:ListItem Text="Miss" Value="Miss">Miss</asp:ListItem>
                                        </asp:DropDownList>--%>
                                    </label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtCustomerName" runat="server" MaxLength="50"
                                            CssClass="form-control" PlaceHolder="e.g. Tom" title="Please enter Name"
                                            onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                    </div>
                                    <br />
                                </div>
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Date Of Birth <span style="color: red">*</span></label>
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
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Mobile (+44) <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width: 100%;">

                                            <input id="txtMobile" class="flag-tel" type="tel" placeholder="Customer Mobile Number"
                                                title="Please enter Customer Mobile Number"
                                                onkeypress="NumericOnly(event);clearErrorMessage();" style="width: 100%; padding-left: 50px;" />

                                        </div>
                                    </div>
                                </div>
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Landline (+44) </label>
                                    <div class="col-sm-8">
                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width: 100%;">

                                            <input id="txtLandline" class="flag-tel" type="tel" placeholder="Customer Landline Number"
                                                title="Please enter Customer Landline Number"
                                                onkeypress="NumericOnly(event);clearErrorMessage();" style="width: 100%; padding-left: 50px;" />

                                        </div>
                                    </div>
                                </div>
                                <br />
                            </div>

                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Address <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <input type="text" id="txtAddressLine1" runat="server" class="form-control"
                                            placeholder="Enter an Address" title="Please enter Address for Customer"
                                            onkeypress="clearErrorMessage();" />
                                        <div id="CollectionMap"></div>
                                    </div>
                                </div>
                                <br />
                                <br />
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Post Code: </label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control m-b"
                                            PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                            onkeypress="clearErrorMessage();" Style="text-transform: uppercase;"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">How did you hear about us? </label>
                                    <div class="col-sm-8">
                                        <asp:DropDownList ID="ddlHearAboutUs" runat="server"
                                            CssClass="form-control m-b" title="Please select an Option from dropdown"
                                            onchange="clearErrorMessage();">
                                            <asp:ListItem>Select Option</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <br />
                            </div>

                            <div class="row">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Do you have a Registered Company? <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <label>
                                                    Yes &nbsp;<asp:RadioButton ID="rbYesRegisteredCompany" runat="server" GroupName="RegisteredCompany"
                                                        onchange="showHideDiv();clearErrorMessage();" /></label>
                                            </div>

                                            <div class="col-md-3">
                                                <label>
                                                    No &nbsp;<asp:RadioButton ID="rbNoRegisteredCompany" runat="server" GroupName="RegisteredCompany"
                                                        onchange="showHideDiv();clearErrorMessage();" /></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br />
                            </div>

                            <div class="row">
                                <div class="form-group" id="dvShippingGoodsInCompanyName" style="display: none;">
                                    <label class="col-sm-4 control-label">If Yes, are you shipping the goods in the name of the company?</label>
                                    <div class="col-sm-8">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <label>
                                                    Yes &nbsp;
                                               
                                                    <asp:RadioButton ID="rbYesShippingGoodsInCompanyName" runat="server" GroupName="ShippingGoodsInCompanyName"
                                                        onchange="clearErrorMessage();" /></label>
                                            </div>
                                            <div class="col-md-3">
                                                <label>
                                                    No &nbsp;
                                               
                                                    <asp:RadioButton ID="rbNoShippingGoodsInCompanyName" runat="server" GroupName="ShippingGoodsInCompanyName"
                                                        onchange="clearErrorMessage();" /></label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br />
                            </div>

                            <div class="row">
                                <div class="form-group" id="dvRegisteredCompanyName" style="display: none;">
                                    <label class="col-sm-4 control-label">Registered Company Name</label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtCompanyName" runat="server"
                                            CssClass="form-control m-b" PlaceHolder="e.g. ABC Ltd"
                                            onkeypress="clearErrorMessage();">
                                    </asp:TextBox>
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
                            <table id="dtViewCustomer">
                                <thead>
                                    <tr>
                                        <th>Select</th>
                                        <th>Customer Id</th>
                                        <th>Email Address</th>
                                        <th style="width: 90px;">Customer Name</th>
                                        <th style="width: 70px;">Date Of Birth</th>
                                        <th>Customer Address</th>
                                        <th>Mobile</th>
                                        <th style="width: 100px;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <table id="dtViewCustomer_Check" style="display: none;">
                                <thead>
                                    <tr>
                                        <th>Customer Id</th>
                                        <th>Email Address</th>
                                        <th>Customer Name</th>
                                        <th>Date Of Birth</th>
                                        <th>Customer Address</th>
                                        <th>Mobile</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <hr />
                        <footer>
                            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                        </footer>
                    </div>
                </div>
            </form>
        </div>
    </div>


    <div class="modal fade" id="Customer-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Customer Details</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                    <p><span id="spFullName"></span>'s Details updated successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="location.reload();">OK</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="CustomerRemoval-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Customer Deactivation</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                    <p>Sure? You want to deactivate this Customer's Details?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="return deactivateCustomer();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="">No</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="dvCustomerDetailsModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>Customer Information: 
                   
                        <span id="spHeaderCustomerId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto;">
                    <p><strong>Please find the details of this Customer below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintCustomerModal1" data-dismiss="modal"
                                    onclick="return printCustomerDetails();" style="margin-bottom: 10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintPdfCustomerModal1" data-dismiss="modal"
                                    onclick="createPDF1();" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintExcelCustomerModal1" data-dismiss="modal"
                                    onclick="fnExcelReport1();" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </button>
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
                                                    <th>House number: </th>
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

    <div class="modal fade" id="PrintDataTable-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Print - Customer Details</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                    <p>Sure? You want to print this Customer Details?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="return printDataTable();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="Failure-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Printing Not Possible</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                    <p>Please choose a Customer from the list</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal">OK</button>
                </div>
            </div>

        </div>
    </div>
    <iframe id="txtArea1" style="display: none"></iframe>
</asp:Content>

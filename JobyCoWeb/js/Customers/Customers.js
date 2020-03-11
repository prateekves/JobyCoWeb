$(document).ready(function () {
    getAllCustomers();

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

    $('#<%=txtDOB.ClientID%>').datepicker({
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

    $("#loadingDiv").css('display', 'flex');
    var filterValues = {};

    var refDataTable = $("#dtViewCustomer").dataTable({
        serverSide: true,
        bFilter: false,
        columns: [
            { defaultContent: "<input type='checkbox' class='SelectCheckBox'>" },
            { data: "CustomerId" },
            { data: "EmailID" },
            { data: "CustomerName" },
            {
                data: "sDOB",
                render: function (jsonDOB) {
                    //return getFormattedDateUK( jsonDOB );
                    return jsonDOB;
                }
            },
            { data: "Address" },
            { data: "Mobile" },
            {
                defaultContent:
                    "<button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-trash' aria-hidden='true'></i></button>"
            }
        ],
        ajax: function (data, callback, settings) {
            filterValues.draw = data.draw;
            filterValues.start = data.start;
            filterValues.length = data.length;
            $.ajax({
                url: 'ViewAllCustomers.aspx/GetAllCustomers',
                method: 'GET',
                data: filterValues
            }).done(callback);
        }
    });
    $("#filterBtn").click(function () {
        filterValues.name = $("#filterName").val();
        filterValues.surname = $("#filterSurName").val();
        filterValues.classroom = $("#filterClassRoom").val();
        refDataTable.fnDraw();
    });
});

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
    var placesCollection = new google.maps.places.Autocomplete(document.getElementById('<%=txtAddressLine1.ClientID%>'), optionsCollection);

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
    var vCustomerId = $('#<%=hfCustomerId.ClientID%>');
    var vEmailID = $("#<%=txtEmailID.ClientID%>");
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
    var vDateOfBirth = $("#<%=txtDOB.ClientID%>").val().trim();
    var vCurrentDate = getCurrentDateDetails();
    checkFromAndToDate(vDateOfBirth, vCurrentDate);
}

function getAllOptions() {
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "AddCustomer.aspx/GetAllOptions",
        data: "{}",
        dataType: "json",
        success: function (result) {
            $.each(result.d, function (key, value) {
                $("#<%=ddlHearAboutUs.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
            })
        },
        error: function (response) {
        }
    });
}

function getAllCustomers() {
    
   
    
    //$.ajax( {
    //    method: "POST",
    //    contentType: "application/json; charset=utf-8",
    //    url: "ViewAllCustomers.aspx/GetAllCustomers",
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
    //        var jsonCustomerDetails = JSON.parse( result.d );
    //        $( '#dtViewCustomer' ).DataTable({
    //            data: jsonCustomerDetails,
    //            deferRender : true,
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

    $('#dtViewCustomer tbody').on('click', '.SelectCheckBox', function () {
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

        debugger;
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

        $('#<%=hfCustomerId.ClientID%>').val(vCustomerId);
        $('#<%=txtEmailID.ClientID%>').val(vEmailID);
        $('#<%=txtCustomerName.ClientID%>').val(vCustomerName);
        $('#<%=txtDOB.ClientID%>').val(vDateOfBirth);
        $('#<%=txtAddressLine1.ClientID%>').val(vAddress);
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
        $('#<%=hfCustomerId.ClientID%>').val(vCustomerId);
        $('#CustomerRemoval-bx').modal('show');

        return false;
    });
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

function getCustomerPostCodeFromCustomerId(CustomerId) {
    $.ajax({
        method: "POST",
        contentType: "application/json; charset=utf-8",
        url: "ViewAllCustomers.aspx/GetCustomerPostCodeFromCustomerId",
        data: "{ CustomerId: '" + CustomerId + "'}",
        success: function (result) {
            $('#spCustomerPostCode').text(result.d);
            $('#<%=txtPostCode.ClientID%>').val(result.d);

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
            $('#<%=ddlHearAboutUs.ClientID%>').find('option:selected').text(result.d);

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
                    $('#<%=rbNoRegisteredCompany.ClientID%>').attr('checked', 'checked');
                    break;

                case "true":
                    $('#spHavingRegisteredCompany').text('Yes');
                    $('#<%=rbYesRegisteredCompany.ClientID%>').attr('checked', 'checked');
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
                    $('#<%=rbNoShippingGoodsInCompanyName.ClientID%>').attr('checked', 'checked');
                    break;

                case "true":
                    $('#spShippingGoodsInCompanyName').text('Yes');
                    $('#<%=rbYesShippingGoodsInCompanyName.ClientID%>').attr('checked', 'checked');
                    break;
            }
        },
        error: function (response) {
            alert('Unable to Bind Customer Shipping Goods In Company Name');
        }
    });
}

function disappearAllButtons() {
    $('#<%=btnAddCustomerDetails.ClientID%>').css('display', 'none');
    $('#<%=btnPrintCustomerDetails.ClientID%>').css('display', 'none');
    $('#<%=btnExportPdfCustomerDetails.ClientID%>').css('display', 'none');
    $('#<%=btnExportExcelCustomerDetails.ClientID%>').css('display', 'none');

    return false;
}

function appearAllButtons() {
    $('#<%=btnAddCustomerDetails.ClientID%>').css('display', 'block');
    $('#<%=btnPrintCustomerDetails.ClientID%>').css('display', 'block');
    $('#<%=btnExportPdfCustomerDetails.ClientID%>').css('display', 'block');
    $('#<%=btnExportExcelCustomerDetails.ClientID%>').css('display', 'block');

    return false;
}

function deactivateCustomer() {
    var CustomerId = $('#<%=hfCustomerId.ClientID%>').val().trim();

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

    var PostCode = $("#<%=txtPostCode.ClientID%>").val().trim();

    var HearAboutUs = $('#<%=ddlHearAboutUs.ClientID%>').find('option:selected').text().trim();

    //========== Determining Whether having a Registered Company or not
    var HavingRegisteredCompany = "";
    var YesHavingRegisteredCompany = $('#<%=rbYesRegisteredCompany.ClientID%>');
    var NoHavingRegisteredCompany = $('#<%=rbNoRegisteredCompany.ClientID%>');

    if (YesHavingRegisteredCompany.is(":checked")) {
        HavingRegisteredCompany = "true";
    }

    if (NoHavingRegisteredCompany.is(":checked")) {
        HavingRegisteredCompany = "false";
    }
    //============================================================

    var RegisteredCompanyName = $('#<%=txtCompanyName.ClientID%>').val().trim();

    //========== Determining Whether shipping Goods in Company Name or not
    var ShippingGoodsInCompanyName = "";
    var YesShippingGoodsInCompanyName = $('#<%=rbYesShippingGoodsInCompanyName.ClientID%>');
    var NoShippingGoodsInCompanyName = $('#<%=rbNoShippingGoodsInCompanyName.ClientID%>');

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
    var Address1 = $("#<%=txtAddressLine1.ClientID%>").val().trim();

    var geocoder = new google.maps.Geocoder();
    var address = Address1;

    geocoder.geocode({ 'address': address }, function (results, status) {

        if (status == google.maps.GeocoderStatus.OK) {
            //debugger;
            var latitude = results[0].geometry.location.latitude;
            var longitude = results[0].geometry.location.longitude;
            //2nd Block
            var Address2 = $("#<%=txtAddressLine1.ClientID%>").val().trim();
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
<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true"
    CodeBehind="LoggedQuote.aspx.cs" Inherits="JobyCoWebCustomize.LoggedQuote" EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!--<link href="/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />-->
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>

    <style>
        #CollectionMap, #DeliveryMap, #CollectionMapStep1 {
            height: 200px;
            width: 400px;
        }
    </style>

    <script>
        if (typeof google === 'object' && typeof google.maps === 'object') {
            InitializeMap();
        } else {
            $.getScript('https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap', function () {
                InitializeMap();
            });
        }

        function InitializeMap() {
            var latlng = new google.maps.LatLng(-34.397, 150.644);

            var myCollectionOptions = {
                zoom: 6,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var CollectionMap = new google.maps.Map(document.getElementById("CollectionMap"), myCollectionOptions);

            var myStep1CollectionOptions = {
                zoom: 6,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var Step1CollectionMap = new google.maps.Map(document.getElementById("CollectionMapStep1"), myStep1CollectionOptions);

            var myDeliveryOptions = {
                zoom: 6,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };

            var DeliveryMap = new google.maps.Map(document.getElementById("DeliveryMap"), myDeliveryOptions);

            var defaultCollectionBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(-33.8902, 151.1759),
                new google.maps.LatLng(-33.8474, 151.2631)
                );

            var optionsCollection = {
                bounds: defaultCollectionBounds
            };

            var defaultDeliveryBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(-33.8902, 151.1759),
                new google.maps.LatLng(-33.8474, 151.2631)
                );

            var optionsDelivery = {
                bounds: defaultDeliveryBounds
            };

            google.maps.event.addDomListener(window, 'load', function () {
                var placesCollection = new google.maps.places.Autocomplete(document.getElementById('<%=txtCollectionAddressLine1.ClientID%>'), optionsCollection);
                var placesDelivery = new google.maps.places.Autocomplete(document.getElementById('<%=txtDeliveryAddressLine1.ClientID%>'), optionsDelivery);

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
                    document.getElementById("CollectionMap").style.width = document.getElementById("<%=txtCollectionAddressLine1.ClientID%>").style.width;
                });

                google.maps.event.addListener(placesDelivery, 'place_changed', function () {
                    var placeDelivery = placesDelivery.getPlace();
                    var addressDelivery = placeDelivery.formatted_address;
                    var latitudeDelivery = placeDelivery.geometry.location.lat();
                    var longitudeDelivery = placeDelivery.geometry.location.lng();

                    //var msgDelivery = "Address: " + addressDelivery;
                    //msgDelivery += "\nLatitude: " + latitudeDelivery;
                    //msgDelivery += "\nLongitude: " + longitudeDelivery;

                    //alert(msgDelivery);
                    $("#<%=hfDeliveryLatitude.ClientID%>").val(latitudeDelivery);
                    $("#<%=hfDeliveryLongitude.ClientID%>").val(longitudeDelivery);

                    var latlngDelivery = new google.maps.LatLng(latitudeDelivery, longitudeDelivery);

                    myDeliveryOptions = {
                        zoom: 8,
                        center: latlngDelivery,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };

                    mapDelivery = new google.maps.Map(document.getElementById("DeliveryMap"), myDeliveryOptions);
                    document.getElementById("DeliveryMap").style.width = document.getElementById("<%=txtDeliveryAddressLine1.ClientID%>").style.width;
                });

            });
        }

    </script>

    <%--<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA079i9v8OTWYxstBB53I-nydb8zt1c_tk&libraries=places&callback=InitializeMap" 
        async defer></script>--%>

    <script>
        $(document).ready(function () {
            getPickupCategories();

            //getCustomerId();
            //getBookingId();
            generateQuoteId();

            $('#<%=ddlInsurance.ClientID%>').val(2);
            $('#<%=ddlRegisteredCompany.ClientID%>').val(0);

            //getUserName();

            $('#<%=ddlCustomerAddress.ClientID%>').change(function () {
            var item = $(this);
            var vAddressId = item.val();
            if (vAddressId == "Create New Address") {

                $('#<%=txtCollectionAddressLine1.ClientID%>').val("");
                $('#<%=txtCollectionName.ClientID%>').val("");
                $('#<%=txtCollectionName.ClientID%>').removeAttr('readonly');
                $('#<%=txtPickupEmailAddress.ClientID%>').removeAttr('readonly');
                $('#<%=txtCollectionPostCode.ClientID%>').val("");
                $('#<%=txtCollectionMobile.ClientID%>').val("");
            }
            else { 
            var JsonData = {};
            JsonData.SelectedAddressId = vAddressId;

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetAddressDetails",
                data: JSON.stringify(JsonData),
                dataType: "json",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    var len = jdata.length;
                    //alert(len);
                    $("#<%=hfPickupLatitude.ClientID%>").val(jdata[0]["LatitudePickup"]);
                    $("#<%=hfPickupLongitude.ClientID%>").val(jdata[0]["LongitudePickup"]);

                    var defaultCollectionBounds = new google.maps.LatLngBounds(
                        new google.maps.LatLng(-33.8902, 151.1759),
                        new google.maps.LatLng(-33.8474, 151.2631)
                        );

                    var optionsCollection = {
                        bounds: defaultCollectionBounds
                    };
                    
                    //var placeCollection = placesCollection.getPlace();
                    //var addressCollection = jdata[0]["Address"];
                    var latitudeCollection = jdata[0]["LatitudePickup"];
                    var longitudeCollection = jdata[0]["LongitudePickup"];

                    <%--var msgCollection = "Address: " + addressCollection;
                    msgCollection += "\nLatitude: " + latitudeCollection;
                    msgCollection += "\nLongitude: " + longitudeCollection;

                    alert(msgCollection);
                    $("#<%=hfPickupLatitude.ClientID%>").val(latitudeCollection);
                    $("#<%=hfPickupLongitude.ClientID%>").val(longitudeCollection);--%>

                    var latlngCollectionStep1 = new google.maps.LatLng(latitudeCollection, longitudeCollection);

                    myStep1CollectionOptions = {
                        zoom: 6,
                        center: latlngCollectionStep1,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };

                    mapCollection = new google.maps.Map(document.getElementById("CollectionMapStep1"), myStep1CollectionOptions);
                    mapCollection = new google.maps.Map(document.getElementById("CollectionMap"), myStep1CollectionOptions);
                    //document.getElementById("CollectionMapStep1").style.width = document.getElementById("<%=txtCollectionAddressLine1.ClientID%>").style.width;
                    $('#<%=txtCollectionAddressLine1.ClientID%>').val(jdata[0]["Address"]);
                    $('#<%=txtCollectionName.ClientID%>').val(jdata[0]["PickupName"]);
                    $('#<%=txtCollectionName.ClientID%>').attr('readonly', 'readonly');
                    $('#<%=txtPickupEmailAddress.ClientID%>').attr('readonly', 'readonly');
                    
                    $('#<%=txtCollectionPostCode.ClientID%>').val(jdata[0]["PostCode"]);
                    $('#<%=txtCollectionMobile.ClientID%>').val(jdata[0]["Mobile"]);
                    $('#PickupCustomerTitle').val(jdata[0]["PickupTitle"]);
                }
            });  //Ajax Call
            }
        });

        $("#dvStep2").css("display", "none");
        $("#dvStep3").css("display", "none");

        $("table.order-list").on("click", ".ibtnDel", function (event) {

            var vIndex = $(this).closest("tr").index();

            var vMyTable_PickupCategory = $(this).closest("tr").find('select:eq(0)').find("option:selected").text().trim();
            var vMyTable_PickupItem = $(this).closest("tr").find('select:eq(1)').find("option:selected").text().trim();
            var vMyTable_EstimatedValue = $(this).closest("tr").find('input[type=text]:eq(1)').val().trim();
            var vMyTable_PredefinedEstimatedValue = $(this).closest("tr").find('input[type=text]:eq(2)').val().trim();

            //alert(vIndex + '\n' + vMyTable_PickupCategory + '\n' + vMyTable_PickupItem + '\n' + vMyTable_EstimatedValue + '\n' + vMyTable_PredefinedEstimatedValue);

            var vBookPickup_PickupCategory = "";
            var vBookPickup_PickupItem = "";
            var vBookPickup_PredefinedEstimatedValue = "";

            $('#tblBookPickup tbody > tr').each(function () {
                vBookPickup_PickupCategory = $(this).find('td:eq(0)').text().trim();
                vBookPickup_PickupItem = $(this).find('td:eq(1)').text().trim();
                vBookPickup_PredefinedEstimatedValue = $(this).find('td:eq(3)').text().trim();

                if (vMyTable_PickupCategory == vBookPickup_PickupCategory) {
                    if (vMyTable_PickupItem == vBookPickup_PickupItem) {
                        if (vMyTable_PredefinedEstimatedValue == vBookPickup_PredefinedEstimatedValue) {

                            //First Row can't be removed from BookPickup Table
                            if (vIndex != 0) {
                                $(this).remove();
                            }
                        }
                    }
                }
            });

            var vConfirmItems_PickupCategory = "";
            var vConfirmItems_PickupItem = "";
            var vConfirmItems_EstimatedValue = "";
            var vConfirmItems_PredefinedEstimatedValue = "";

            $('#tblConfirmItems tbody > tr').each(function () {
                vConfirmItems_PickupCategory = $(this).find('td:eq(0)').text().trim();
                vConfirmItems_PickupItem = $(this).find('td:eq(1)').text().trim();
                vConfirmItems_EstimatedValue = $(this).find('td:eq(3)').text().trim();
                vConfirmItems_PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();

                if (vMyTable_PickupCategory == vConfirmItems_PickupCategory) {
                    if (vMyTable_PickupItem == vConfirmItems_PickupItem) {
                        if (vMyTable_EstimatedValue == vConfirmItems_EstimatedValue) {
                            if (vMyTable_PredefinedEstimatedValue == vConfirmItems_PredefinedEstimatedValue) {

                                //First Row can't be removed from ConfirmItems Table
                                if (vIndex != 0) {
                                    $(this).remove();
                                }
                            }
                        }
                    }
                }
            });
            
            var rowCount = $('#myTable >tbody >tr').length;
          
            //First Row can't be removed from 'myTable' Table
            if (rowCount > 1) {
                swal({
                    title: "Are you sure?",
                    text: "All information of this item will be deleted if you delete this item!",
                    icon: "warning",
                    buttons: ["No, cancel pls!", "Yes, delete it!"],
                    dangerMode: true,
                })
                .then((willDelete) => {
                    if (willDelete) {
                        swal("You have successfully deleted the item.", {
                            icon: "success",
                        });
                        $(this).closest("tr").remove();
                    } else {
                        swal("You have cancelled the deletion :)", {
                            icon: "error",
                        });
                    }
                });
            }
            else {
                //$('#NoRemoval-bx').modal('show');
                swal({
                    title: "Warning",
                    text: "First Row can't be Removed!",
                    icon: "warning",
                    button: "Ok",
                });
            }

            //New Code Added for Image Removal
            //=================================
            var vUploadId = $(this).closest("tr").find('input[type=file]:eq(0)').attr('id');
            var vOutputId = vUploadId.replace("upload", "output");
            $('#' + vOutputId).remove();
            //=================================

            //return deleteRowBookPickup();
            getMyTableItemCount();

            $("#<%=btnSendQuote.ClientID%>").removeAttr("disabled");
        });

        // Change the country selection for Collection Mobile    
        $("#<%=txtCollectionMobile.ClientID%>").intlTelInput("setCountry", "gb");

        // Change the country selection for Delivery Mobile    
        $("#<%=txtDeliveryMobile.ClientID%>").intlTelInput("setCountry", "gh");

        //Set Current Date in Bootstrap Date Picker
        var date = new Date();
        date.setDate(date.getDate());

        //$('#<%=txtCollectionDate.ClientID%>').datetimepicker({
        //startDate: date,
        //autoclose: true
        //});

        $('#<%=txtCollectionDate.ClientID%>').datepicker({
            format: 'dd-mm-yyyy',
            startDate: date,
            autoclose: true
        });

    });
    </script>

    <script>

        function displayImage(event, x, y) {
            var ImageUrl = URL.createObjectURL(event.target.files[0]);
            var ImageName = event.target.files[0].name;
            var IsExists = 1;
            //Check Duplicate Image
            $('.file_viwer_sec img').each(function () {
                
                var ImageTitle = $(this).attr('title');
                if (ImageTitle == ImageName) {
                    //alert('Image already added');
                    swal({
                        title: "Warning",
                        text: "Image already added!",
                        icon: "warning",
                        button: "Ok",
                    });
                    IsExists = 0;
                }
            });
            if (IsExists) {
                $('#ViewImage' + x + y).attr('src', ImageUrl).attr('title', ImageName);
            }

            return false;
        }

        function ToggleButton(num) {
            $("#upload_fileToggle" + num).toggleClass("main");
            return false;
        }

        function removeFileUploadRow(x, a, b) {
            $(x).closest("div").css('display', 'none');
            $('#FileUpload' + a + b).val(null);
            $('#ViewImage' + a + b).removeAttr('title').removeAttr('src');
        }

        function AddImageUploadRow(num) {
            
            //alert(num);
            var Count = $('#apnd_div' + num).find('.mlty_ple_upload').length;


            //alert(Count);
            var structure = $('<div class="mlty_ple_upload"> <i class="fa fa-times-circle remove_images_single" onclick="return removeFileUploadRow(this, ' + num + ', ' + Count + ');" aria-hidden="true"></i> <div class="form-group"><label class="add_img_file_aa"><i class="fa fa-upload" aria-hidden="true"></i>Upload File<input type="file" id="FileUpload' + num + '' + Count + '" size="60" onchange="return displayImage(event, ' + num + ', ' + Count + ');" ></label></div><div class="file_viwer_sec"> <img id="ViewImage' + num + '' + Count + '" src="/images/no_image.jpg" /> </div><div class="apnd_mlty_ple"> <button type="button" class="btn g" style="visibility:hidden;"><i class="fa fa-plus-circle" aria-hidden="true"></i> Add More </button> </div></div>');
            $('#apnd_div' + num).append(structure);
            return false;
        }
        //Reset Loaded Image Files

        var resetloadFile = function (event, ImageId, row) {
            $('.Imgli' + row).closest('li').remove();
        }

        //View Image after uploading
        var loadFile = function (event, ImageId, row) {

            var Count = event.target.files.length;
            $('.Imgli' + row).closest('li').remove();
            //alert(Count);

            var vImageList = '';
            for (var i = 0; i < Count; i++) {
                var vImageList = '<li style="display: inline-block;" class="lstImage"><img class="Imgli' + row + '" id="' + ImageId + '" src="' + URL.createObjectURL(event.target.files[i]) + '" height="50" width="50" /></li>';
                $("#ulOutput").append(vImageList);
            }
        };

        function closeNearestImage(x, i, row) {
            
            //$(x).closest("li").css('display', 'none');
            $(x).closest("li").remove();

            $('#upload' + row)[i].Value = "";
            //alert($('#upload' + row));
            //$('#' + ButtonId).closest('li').css('display', 'none');
            //alert('hi');
            return false;
        }
    </script>

    <script>
        function closeNearestImage(ButtonId) {
            $('#' + ButtonId).closest('li').css('display', 'none');
            return false;
        }
    </script>

    <script>
        function getMyTableTotal() {
            var vMyTable_PredefinedEstimatedValue_String = "";
            var vMyTable_PredefinedEstimatedValue_Float = 0.0;

            var vMyTable_EstimatedValue_String = "";
            var vMyTable_EstimatedValue_Float = 0.0;

            var vMyTable_TotalValue_Float = 0.0;
            var vMyTable_VAT = 0.00;

            $('#myTable tbody tr').each(function (i, row) {

                if ($(this).closest("tr").find('input[type=text]:eq(2)') != "") {
                    vMyTable_PredefinedEstimatedValue_String = $(this).closest("tr").find('input[type=text]:eq(2)').val();
                }
                if ($(this).closest("tr").find('input[type=text]:eq(1)').val() != "") {
                    vMyTable_EstimatedValue_String = $(this).closest("tr").find('input[type=text]:eq(1)').val();
                }

                //alert('vMyTable_PredefinedEstimatedValue_String=' + vMyTable_PredefinedEstimatedValue_String + ' vMyTable_EstimatedValue_String=' + vMyTable_EstimatedValue_String);
                vMyTable_PredefinedEstimatedValue_Float = parseFloat(vMyTable_PredefinedEstimatedValue_String);
                vMyTable_EstimatedValue_Float = parseFloat(vMyTable_EstimatedValue_String);

                //if (vMyTable_EstimatedValue_Float > vMyTable_PredefinedEstimatedValue_Float) {
                //    vMyTable_PredefinedEstimatedValue_Float = vMyTable_EstimatedValue_Float;
                //}

                if (!isNaN(vMyTable_PredefinedEstimatedValue_Float) && (vMyTable_PredefinedEstimatedValue_String != "" || vMyTable_EstimatedValue_String != "")) {
                    vMyTable_TotalValue_Float += vMyTable_PredefinedEstimatedValue_Float;
                    //alert('vMyTable_TotalValue_Float' + vMyTable_TotalValue_Float);

                }
            });

            //alert('vMyTable_TotalValue_Float  after loop : ' + vMyTable_TotalValue_Float);
            var TotalValue = parseFloat(vMyTable_TotalValue_Float);
            var JsonData = {};
            JsonData.TotalValue = TotalValue;
            //alert(JSON.stringify(JsonData));
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetTaxationDetails",
                data: JSON.stringify(JsonData),
                dataType: "json",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    var len = jdata.length;
                    //alert(JSON.stringify(jdata));
                    var TempTotal = TotalValue;
                    if (len > 0) {
                        var newRowContent = "";
                        var newRowContentConfirmation = "";
                        var ChargesType = "";
                        for (var i = 0; i < len; i++) {
                            //
                            var TaxAmount = parseFloat(jdata[i]["TaxAmount"]);
                            var IsPercent = jdata[i]["IsPercent"];
                            ChargesType = jdata[i]["RadioChargesType"].toString();
                            var CalculateTax = 0.00;

                            if (ChargesType == "VAT") {
                                var RegisteredCompany = $("#<%=ddlRegisteredCompany.ClientID%>");
                                var vRegisteredCompany = RegisteredCompany.find("option:selected").text().trim();

                                if (vRegisteredCompany == "Yes") {
                                    var GoodsInName = $("#<%=ddlGoodsInName.ClientID%>");
                                    var vGoodsInName = GoodsInName.find("option:selected").text().trim();

                                    if (vGoodsInName == "Yes") {
                                        //vMyTable_VAT = ( vMyTable_PredefinedEstimatedValue_Float * 20 ) / 100;
                                        if (IsPercent == 1) {
                                            CalculateTax = parseFloat(TotalValue * TaxAmount * 0.01).toFixed(2);
                                            //TempTotal = parseFloat(TotalValue) + parseFloat(CalculateTax);
                                            TempTotal = parseFloat(TempTotal) + parseFloat(CalculateTax);
                                        }
                                        else {
                                            CalculateTax = parseFloat(TaxAmount);
                                            TempTotal = parseFloat(TempTotal) + parseFloat(CalculateTax);
                                        }

                                        newRowContent += '<tr>' +
                                                            '<td>' +
                                                                '<div>' +
                                                                    '<strong id="taxName">' + jdata[i]["TaxName"] + '</strong>' +
                                                                    '<i class="note-disclaimer"><i>: £' +
                                                                    '<span id="taxValue" runat="server">' + CalculateTax + '</span></i></i>' +
                                                                '</div>' +
                                                            '</td>' +
                                                            '</tr>';

                                        newRowContentConfirmation += '<tr><td style="display:none;">' + jdata[i]["Id"] + '</td>' +
                                                                        '<td style="display:none;">' + jdata[i]["TaxName"] + '</td>' +
                                                                        '<td style="display:none;">' + CalculateTax + '</td>' +
                                                                        '<td><strong>' + jdata[i]["TaxName"] + '</strong></td>' +
                                                                        '<td><i>£ ' + CalculateTax + '</i></td>' +
                                                                    '</tr>';

                                        $("#<%=hfVAT.ClientID%>").val(CalculateTax);
                                        $('#<%=spVAT.ClientID%>').text(vMyTable_VAT.toFixed(2).toString());
                                        $('#spVATAmount').text(vMyTable_VAT.toFixed(2).toString());
                                    }
                                }

                                <%--vMyTable_TotalValue_Float += vMyTable_VAT;
                                //alert('vMyTable_TotalValue_Float' + vMyTable_TotalValue_Float);
                                $( "#<%=hfVAT.ClientID%>" ).val( vMyTable_VAT );

                                //===========================================================
                                $( '#<%=spVAT.ClientID%>' ).text( vMyTable_VAT.toFixed( 2 ).toString() );
                                $( '#spVATAmount' ).text( vMyTable_VAT.toFixed( 2 ).toString() );--%>
                            }
                            else if (ChargesType == "Insurance") {
                                var Insurance = $("#<%=ddlInsurance.ClientID%>");
                                var vInsurance = Insurance.find("option:selected").text().trim();

                                if (vInsurance == "No") {
                                    if (IsPercent == 1) {
                                        CalculateTax = parseFloat(TotalValue * TaxAmount * 0.01).toFixed(2);
                                        //TempTotal = parseFloat(TotalValue) + parseFloat(CalculateTax);
                                        TempTotal = parseFloat(TempTotal) + parseFloat(CalculateTax);
                                    }
                                    else {
                                        CalculateTax = parseFloat(TaxAmount);
                                        TempTotal = parseFloat(TempTotal) + parseFloat(CalculateTax);
                                    }

                                    newRowContent += '<tr>' +
                                                        '<td>' +
                                                            '<div>' +
                                                                '<strong id="taxName">' + jdata[i]["TaxName"] + '</strong>' +
                                                                '<i class="note-disclaimer"><i>: £' +
                                                                '<span runat="server">' + CalculateTax + '</span></i></i>' +
                                                            '</div>' +
                                                        '</td>' +
                                                        '</tr>';
                                    newRowContentConfirmation += '<tr><td style="display:none;">' + jdata[i]["Id"] + '</td>' +
                                                                        '<td style="display:none;">' + jdata[i]["TaxName"] + '</td>' +
                                                                        '<td style="display:none;">' + CalculateTax + '</td>' +
                                                                        '<td><strong>' + jdata[i]["TaxName"] + '</strong></td>' +
                                                                        '<td><i>£ ' + CalculateTax + '</i></td>' +
                                                                    '</tr>';

                                    $('#<%=txtInsurancePremium.ClientID%>').val(CalculateTax);
                                    $('#<%=spInsurancePremium.ClientID%>').text(CalculateTax);
                                    $('#spInsurancePremiumAmount').text(CalculateTax);
                                }
                            }
                            else if (ChargesType == "Other") {
                                if (IsPercent == 1) {
                                    CalculateTax = parseFloat(TotalValue * TaxAmount * 0.01).toFixed(2);
                                    //TempTotal = parseFloat(TotalValue) + parseFloat(CalculateTax);
                                    TempTotal = parseFloat(TempTotal) + parseFloat(CalculateTax);
                                }
                                else {
                                    CalculateTax = parseFloat(TaxAmount);
                                    TempTotal = parseFloat(TempTotal) + parseFloat(CalculateTax);
                                }

                                newRowContent += '<tr>' +
                                                    '<td>' +
                                                        '<div>' +
                                                            '<strong id="taxName">' + jdata[i]["TaxName"] + '</strong>' +
                                                            '<i class="note-disclaimer"><i>: £ ' +
                                                            '<span runat="server">' + CalculateTax + '</span></i></i>' +
                                                        '</div>' +
                                                    '</td>' +
                                                    '</tr>';
                                newRowContentConfirmation += '<tr><td style="display:none;">' + jdata[i]["Id"] + '</td>' +
                                                                        '<td style="display:none;">' + jdata[i]["TaxName"] + '</td>' +
                                                                        '<td style="display:none;">' + CalculateTax + '</td>' +
                                                                        '<td><strong>' + jdata[i]["TaxName"] + '</strong></td>' +
                                                                        '<td><i>£ ' + CalculateTax + '</i></td>' +
                                                                    '</tr>';
                            }
                            else { }

                    }
                    newRowContent += '<tr>' +
                                            '<td>' +
                                                '<div>' +
                                                    '<strong id="taxName">Total :</strong>' +
                                                    '<i class="note-disclaimer"><i>: £ ' +
                                                    '<span id="TotaltaxValue" runat="server">' + TempTotal.toFixed(2) + '</span></i></i>' +
                                                '</div>' +
                                            '</td>' +
                                            '</tr>';
                    newRowContentConfirmation += '<tr><td style="display:none;"></td>' +
                                                                    '<td style="display:none;">Total</td>' +
                                                                    '<td style="display:none;">' + CalculateTax + '</td>' +
                                                                    '<td><strong>Total</strong></td>' +
                                                                    '<td><i>£ ' + TempTotal.toFixed(2) + '</i></td>' +
                                                                '</tr>';
                    $("#<%=spTotal.ClientID%>").text(TempTotal.toFixed(2).toString());
                        $('#spTotalAmount').text("" + $("#<%=spTotal.ClientID%>").text().trim());

                        $("#tblTaxDetails tbody").append(newRowContent);
                        $("#tblTaxDetailsConfirmation tbody").append(newRowContentConfirmation);
                    }
                }
            });
        }

        //New Function for Item Count
        function getMyTableItemCount() {
            var vItemCount = parseInt($("#<%=hfItemCount.ClientID%>").val().trim());
            vItemCount--;

            $("#<%=hfItemCount.ClientID%>").val(vItemCount.toString());
            $("#<%=spItemCount.ClientID%>").text(vItemCount.toString());

            getMyTableTotal();
            if ($("#<%=spItemCount.ClientID%>").text() == "0") {
                counter = 1;
                vCount = 0;
                $("#<%=spTotal.ClientID%>").text("0.00");
            }
        }

        function blurEstimatedValue() {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");

            var vEstimatedValue = $("#txtEstimatedValue").val().trim();
            var vPredefinedEstimatedValue = $("#txtPredefinedEstimatedValue").val().trim();

            var vEstimatedValue_Float = parseFloat(vEstimatedValue);
            var vPredefinedEstimatedValue_Float = parseFloat(vPredefinedEstimatedValue);

            if (vEstimatedValue_Float > 0) {
                getMyTableTotal();
            } else if (vPredefinedEstimatedValue_Float > 0) {
                getMyTableTotal();
            }
        }

        function transferMyTableDataToConfirmItems() {

            var vMyTable_PickupCategory = "";
            var vMyTable_PickupItem = "";

            //New Line Added
            //====================
            var vMyTable_TextPickupItem = "";
            //====================

            var vMyTable_EstimatedValue = "";
            var vMyTable_PredefinedEstimatedValue = "";

            $("#tblConfirmItems > tbody").html("");

            $('#myTable tbody > tr').each(function () {

                vMyTable_PickupCategory = $(this).closest("tr").find('select:eq(0)').find("option:selected").text().trim();
                vMyTable_PickupItem = $(this).closest("tr").find('select:eq(1)').find("option:selected").text().trim();
                if (vMyTable_PickupItem == "Pickup Item") {
                    vMyTable_PickupItem = "";
                }

                //New Code Added
                //====================
                vMyTable_TextPickupItem = $(this).closest("tr").find('input[type=text]:eq(0)').val().trim();
                if (vMyTable_TextPickupItem != "") {
                    if (vMyTable_PickupItem == "") {
                        vMyTable_PickupItem = vMyTable_TextPickupItem;
                    }
                }
                //====================
                //alert('vMyTable_PickupItem\t' + vMyTable_PickupItem + '\n'
                //+ 'vMyTable_TextPickupItem\t' + vMyTable_TextPickupItem);

                var MyTable_IsFragile = $(this).closest("tr").find('input:checkbox');
                if (MyTable_IsFragile.is(":checked")) {
                    vMyTable_IsFragile = "Yes";
                }
                else {
                    vMyTable_IsFragile = "No";
                }

                //Index Modified and Value Initialized
                //=============================================
                vMyTable_EstimatedValue = $(this).closest("tr").find('input[type=text]:eq(1)').val().trim();
                vMyTable_PredefinedEstimatedValue = $(this).closest("tr").find('input[type=text]:eq(2)').val().trim();

                if (vMyTable_EstimatedValue == "") {
                    vMyTable_EstimatedValue = "0.00";
                }

                    //New Clause Added for Estimated Value
                else {
                    vMyTable_EstimatedValue = roundOffEstimatedValue(vMyTable_EstimatedValue);
                }

                if (vMyTable_PredefinedEstimatedValue == "") {
                    vMyTable_PredefinedEstimatedValue = "0.00";
                }
                //=============================================

                var vTableRowLast = "";
                vTableRowLast += "<tr>";
                vTableRowLast += "<td>" + vMyTable_PickupCategory + "</td>";
                vTableRowLast += "<td>" + vMyTable_PickupItem + "</td>";
                vTableRowLast += "<td>" + vMyTable_IsFragile + "</td>";
                vTableRowLast += "<td>" + vMyTable_EstimatedValue + "</td>";
                vTableRowLast += "<td>" + vMyTable_PredefinedEstimatedValue + "</td>";
                vTableRowLast += "</tr>";

                //alert('Last:\n' + vTableRowLast);
                if (vMyTable_PickupCategory != "Pickup Category") {
                    $("#tblConfirmItems tbody").append(vTableRowLast);
                }
            });
        }

        function checkInternetConnection() {
            /*$.ajax({
                url: "http://www.google.com",
                context: document.body,
                error: function (jqXHR, exception) {
                    $.dialog({
                        title: 'No Internet',
                        content: 'Please check your Internet Connection to view the Map'
                    });
                },
                success: function () {
                    alert('Online');
                }
            });*/

            // check whether this function works (online only)
            try {
                var x = google.maps.MapTypeId.TERRAIN;
            } catch (e) {
                $.dialog({
                    title: 'No Internet',
                    content: 'Please check your Internet Connection to view the Map'
                });
            }
        }
    </script>

    <script>
        $(window).load(function () {
            // everything’s finished loaded code here…
            checkInternetConnection();
        });
    </script>

    <script>
        function showStep1MandatoryFields() {
            var RegisteredCompany = $("#<%=ddlRegisteredCompany.ClientID%>");
            if (RegisteredCompany.find("option:selected").text().trim() == "Please Select") {
                RegisteredCompany.addClass('manField');
            }

            var Insurance = $("#<%=ddlInsurance.ClientID%>");
            if (Insurance.find("option:selected").text().trim() == "Please Select") {
                Insurance.addClass('manField');
            }

            var CollectionDate = $("#<%=txtCollectionDate.ClientID%>");
            if (CollectionDate.val().trim() == "") {
                CollectionDate.addClass('manField');
            }

            var chkAgree = $("#<%=chkAgree.ClientID%>");
            if (!chkAgree.is(":checked")) {
                chkAgree.addClass('manField');
            }
        }

        function showStep1DataTableMandatoryFields() {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");

            var PickupCategory = $("#ddlPickupCategory");
            var vPickupCategory = PickupCategory.find("option:selected").text().trim();

            if (vPickupCategory == "Pickup Category") {
                ErrMsg.text('Please select a Pickup Category');
                ErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PickupCategory.focus();
                PickupCategory.addClass('manField');
                return false;
            }

            var PickupItem = $("#ddlPickupItem");
            var vPickupItem = PickupItem.find("option:selected").text().trim();

            if (vPickupItem == "Pickup Item") {
                if (vPickupCategory != "Pickup Category") {
                    var vLength = $('#ddlPickupItem > option').length;
                    if (vLength > 1) {
                        ErrMsg.text('Please select a Pickup Item');
                        ErrMsg.css("display", "block");
                        //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                        PickupCategory.removeClass('manField');
                        PickupItem.focus();
                        PickupItem.addClass('manField');
                        return false;
                    }
                }
            }

            //New Code Added
            //======================
            var TextPickupItem = $("#txtPickupItem");
            var vTextPickupItem = TextPickupItem.val().trim();

            if (vPickupCategory == 'Other') {
                if (vTextPickupItem == '') {
                    ErrMsg.text('Please enter a Pickup Item');
                    ErrMsg.css("display", "block");

                    PickupCategory.removeClass('manField');
                    TextPickupItem.focus();
                    TextPickupItem.addClass('manField');
                    return false;
                }
            }
            //======================

            var vRadioButtonValue = "";

            var vFragile = $("#roundedTwo");

            if (vFragile.is(":checked")) {
                vRadioButtonValue = "Yes";
            }
            else {
                vRadioButtonValue = "No";
            }

            var EstimatedValue = $("#txtEstimatedValue");
            if (EstimatedValue.val().trim() == "") {
                ErrMsg.text('Please enter Estimated Value is correct');
                ErrMsg.css("display", "block");

                PickupItem.removeClass('manField');
                EstimatedValue.focus();
                EstimatedValue.addClass('manField');
                return false;
            }

            return true;
        }

        function showCollectionMandatoryFields() {
            var CollectionName = $("#<%=txtCollectionName.ClientID%>");
            if (CollectionName.val().trim() == "") {
                CollectionName.addClass('manField');
            }

            var CollectionAddressLine1 = $("#<%=txtCollectionAddressLine1.ClientID%>");
            if (CollectionAddressLine1.val().trim() == "") {
                CollectionAddressLine1.addClass('manField');
            }

            var CollectionPostCode = $("#<%=txtCollectionPostCode.ClientID%>");
            if (CollectionPostCode.val().trim() == "")
            {
                CollectionPostCode.addClass('manField');
            }

            var CollectionMobile = $("#<%=txtCollectionMobile.ClientID%>");
            if (CollectionMobile.val().trim() == "") {
                CollectionMobile.addClass('manField');
            }

            var PickupEmailAddress = $("#<%=txtPickupEmailAddress.ClientID%>");
            var vPickupEmailAddress = PickupEmailAddress.val().trim();

            if (vPickupEmailAddress == "") {
                PickupEmailAddress.addClass('manField');
            }
        }

        function showDeliveryMandatoryFields() {
            var DeliveryName = $("#<%=txtDeliveryName.ClientID%>");
            if (DeliveryName.val().trim() == "") {
                DeliveryName.addClass('manField');
            }

            var DeliveryAddressLine1 = $("#<%=txtDeliveryAddressLine1.ClientID%>");
            if (DeliveryAddressLine1.val().trim() == "") {
                DeliveryAddressLine1.addClass('manField');
            }

            var DeliveryPostCode = $("#<%=txtDeliveryPostCode.ClientID%>");
            //if (DeliveryPostCode.val().trim() == "")
            //{
            //    DeliveryPostCode.addClass('manField');
            //}

            var DeliveryMobile = $("#<%=txtDeliveryMobile.ClientID%>");
            if (DeliveryMobile.val().trim() == "") {
                DeliveryMobile.addClass('manField');
            }

            var DeliveryEmailAddress = $("#<%=txtDeliveryEmailAddress.ClientID%>");
            var vDeliveryEmailAddress = DeliveryEmailAddress.val().trim();

            //if (vDeliveryEmailAddress == "") {
            //    DeliveryEmailAddress.addClass('manField');
            //}
        }

        function showStep3MandatoryFields() {
            //$("#<%=txtConfirmEmailAddress.ClientID%>").addClass('manField');
            $("#<%=chkConfirm.ClientID%>").addClass('manField');
        }

        function hideStep1MandatoryFields() {
            $("#<%=ddlRegisteredCompany.ClientID%>").removeClass('manField');
            $("#<%=ddlInsurance.ClientID%>").removeClass('manField');
            $("#<%=txtCollectionDate.ClientID%>").removeClass('manField');
            $("#<%=chkAgree.ClientID%>").removeClass('manField');
        }

        function hideStep1DataTableMandatoryFields() {
            $("#ddlPickupCategory").removeClass('manField');
            $("#ddlPickupItem").removeClass('manField');

            //New Line Added
            //====================
            $("#txtPickupItem").removeClass('manField');
            //====================

            $("#txtEstimatedValue").removeClass('manField');
        }

        function hideCollectionMandatoryFields() {
            $("#<%=txtCollectionName.ClientID%>").removeClass('manField');
            $("#<%=txtCollectionAddressLine1.ClientID%>").removeClass('manField');
            $("#<%=txtCollectionMobile.ClientID%>").removeClass('manField');
            $("#<%=txtPickupEmailAddress.ClientID%>").removeClass('manField');
        }

        function hideDeliveryMandatoryFields() {
            $("#<%=txtDeliveryName.ClientID%>").removeClass('manField');
            $("#<%=txtDeliveryAddressLine1.ClientID%>").removeClass('manField');
            $("#<%=txtDeliveryMobile.ClientID%>").removeClass('manField');
            //$("#<%=txtDeliveryEmailAddress.ClientID%>").removeClass('manField');
        }

        function hideStep3MandatoryFields() {
            //$("#<%=txtConfirmEmailAddress.ClientID%>").removeClass('manField');
            $("#<%=chkConfirm.ClientID%>").removeClass('manField');
        }

        function hideAllMandatoryFields() {
            hideStep1MandatoryFields();

            var CompanyName = $("#<%=txtCompanyName.ClientID%>");
            var vCompanyName = CompanyName.val().trim();

            if (vCompanyName == "") {
                CompanyName.addClass('manField');
            }
            else {
                CompanyName.removeClass('manField');
            }

            var GoodsInName = $("#<%=ddlGoodsInName.ClientID%>");
            var vGoodsInName = GoodsInName.find("option:selected").text().trim();

            if (vGoodsInName == "Please Select") {
                GoodsInName.addClass('manField');
            }
            else {
                GoodsInName.removeClass('manField');
            }

            //New Code Added for Insurance Premium
            //======================================
            var InsurancePremium = $("#<%=txtInsurancePremium.ClientID%>");
            var vInsurancePremium = InsurancePremium.val().trim();

            if (vInsurancePremium == "") {
                InsurancePremium.addClass('manField');
            }
            else {
                InsurancePremium.removeClass('manField');
            }
            //======================================

            hideStep1DataTableMandatoryFields();

            hideCollectionMandatoryFields();
            hideDeliveryMandatoryFields();

            hideStep3MandatoryFields();

            return false;
        }
    </script>

    <script>
        var counter = 1;
        var vCount = 0;

        //New Flag Added
        //=================
        var bUpdate = false;
        //=================

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            //vErrMsg.hide(1000).delay(1000).fadeOut(1000);

            var vErrMsg2 = $("#<%=lblErrMsg2.ClientID%>");
            vErrMsg2.text('');
            vErrMsg2.css("display", "none");
            //vErrMsg2.hide(1000).delay(1000).fadeOut(1000);

            var vErrMsg3 = $("#<%=lblErrMsg3.ClientID%>");
            vErrMsg3.text('');
            vErrMsg3.css("display", "none");
            //vErrMsg3.hide(1000).delay(1000).fadeOut(1000);

            hideAllMandatoryFields();
        }

        function checkDropDownValue() {
            var RegisteredCompany = $("#<%=ddlRegisteredCompany.ClientID%>");
            var vRegisteredCompany = RegisteredCompany.find("option:selected").text().trim();

            if (vRegisteredCompany == "Yes") {

                $("#<%=dvGoodsInName.ClientID%>").css("display", "block");
                clearErrorMessage();

                var CompanyName = $("#<%=txtCompanyName.ClientID%>");
                var vCompanyName = CompanyName.val().trim();

                if (vCompanyName == "") {
                    //CompanyName.addClass('manField');
                    CompanyName.removeClass('manField');
                }

                var GoodsInName = $("#<%=ddlGoodsInName.ClientID%>");
                var vGoodsInName = GoodsInName.find("option:selected").text().trim();

                if (vGoodsInName == "Please Select") {
                    //GoodsInName.addClass('manField');
                    GoodsInName.removeClass('manField');
                }
            }
            else if (vRegisteredCompany == "No") {
                $("#<%=dvGoodsInName.ClientID%>").css("display", "none");
                clearErrorMessage();

                $("#<%=txtCompanyName.ClientID%>").removeClass('manField');
                $("#<%=ddlGoodsInName.ClientID%>").removeClass('manField');

                $("#<%=txtCompanyName.ClientID%>").val('');
                $("#<%=ddlGoodsInName.ClientID%>")[0].selectedIndex = 0;
            }

        return false;
    }

    function checkInsuranceValue() {
        var Insurance = $("#<%=ddlInsurance.ClientID%>");
            var vInsurance = Insurance.find("option:selected").text().trim();

            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#f9edef");
            ErrMsg.css("color", "red");
            ErrMsg.css("text-align", "center");

            Insurance.removeClass('manField');

            //New Code Added for Insurance Premium
            //======================================
            var InsurancePremium = $("#<%=txtInsurancePremium.ClientID%>");

            if (vInsurance == "No") {
                //alert('Insurance Premium');
                /*ErrMsg.text('You have to buy the insurance');
                ErrMsg.css("display", "block");*/

                InsurancePremium.val('0.00');
                InsurancePremium.addClass('manField');

                //$("#<%=dvInsurancePremium.ClientID%>").css("display", "block");
            }
                //New Logic Added for 'I am not interested' just like 'No'
                //===============================================================
            else if (vInsurance == "I am not interested") {
                //alert('Insurance Premium');
                /*ErrMsg.text('You have to buy the insurance');
                ErrMsg.css("display", "block");*/

                InsurancePremium.val('0.00');
                InsurancePremium.addClass('manField');

                //$("#<%=dvInsurancePremium.ClientID%>").css("display", "block");
            }
                //===============================================================
            else if (vInsurance == "Yes") {

                InsurancePremium.val('');
                InsurancePremium.removeClass('manField');

                $("#<%=dvInsurancePremium.ClientID%>").css("display", "none");
            }

            //return false;
}

//New Round Off Function Added
function roundOffEstimatedValue(vEstimatedValue) {
    var fEstimatedValue = parseFloat(vEstimatedValue).toFixed(2);
    var sEstimatedValue = fEstimatedValue.toString();

    return sEstimatedValue;
}

function hideFirstRowOfMyTable() {
    $("#myTable > tbody > tr:first").hide();
}

function showOtherInfo() {
    $('#OtherInfo-bx').modal('show');
    return false;
}

function hideQuestionBoxIfExists() {
    if ($('#btnQuestion').length > 0) {
        $('#btnQuestion').css('display', 'none');
    }

    return false;
}

function hideQuestionBoxIfExistsAny(ctr) {
    var ButtonId = "btnQuestion" + ctr.toString();
    if ($('#' + ButtonId).length > 0) {
        $('#' + ButtonId).css('display', 'none');
    }

    return false;
}

function addRowBookPickup() {

    //New Code for Image Upload 
    //==================================
    var vImageList = "";
    vImageList = '<li style="display: none;"><img id="output' + (counter + 1) + '" src="#" height="50" width="50" /><button id="x' + (counter + 1) + '" class="closeRoundButton" onclick="return closeNearestImage(\'x' + (counter + 1) + '\');"><i class="fa fa-times" aria-hidden="true"></i></button></li>';
    $("#ulOutput").append(vImageList);
    //==================================

    var vMyTableRow = "";
    vMyTableRow += "<tr>";
    vMyTableRow += '<td class="col-sm-3 col-xs-12"><select id="ddlPickupCategory' + counter + '" name="pickupCategory[]"  class="itemcatPickup" title="" onchange="clearErrorMessage();hideQuestionBoxIfExistsAny(' + counter + ');"><option value="">Pickup Category</option></select></td>';
    vMyTableRow += '<td class="col-sm-3 col-xs-12"><select id="ddlPickupItem' + counter + '" name="pickupItem[]"  class="items" title="" onchange="clearErrorMessage();"><option value="">Pickup Item</option></select><input type="text" id="txtPickupItem' + counter + '" class="" style="display: none;" title="Please enter value for \'Others\' Category" placeholder="Item description" onkeypress="clearErrorMessage();" /></td>';
    vMyTableRow += '<td class="col-sm-1 col-xs-12"><div class="ondisplay"><section title=".roundedTwo"><div class="roundedTwo"><input id="roundedTwo' + counter + '" type="checkbox" value="None" name="check" /><label for="roundedTwo' + counter + '"><span>FRAGILE?</span></label></div></section></div></td>';
    vMyTableRow += '<td class="col-sm-2 col-xs-12"><label class="float_label">£</label><input id="txtEstimatedValue' + counter + '" name="estimatedValue[]" class="estimatevalue" placeholder="e.g. £123.45" maxlength="10" title="" type="text"  onkeypress="DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);" /></td>';
    vMyTableRow += '<td class="col-sm-2 col-xs-12"><label class="float_label">£</label><input id="txtPredefinedEstimatedValue' + counter + '" name="predefinedestimatedValue[] class="estimatevalue" placeholder="e.g. £123.45" readonly="readonly" onkeyup="blurEstimatedValue();" title="Price" type="text"  style="padding-left: 40px;" onkeypress="DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);" /></td>';

    //New td added for 'Other' information
    //========================================================================================================================================================================================
    vMyTableRow += '<td class="col-sm-2 col-xs-12"><button id="btnQuestion' + counter + '" class="question-mark" style="display: none;" onclick="return showOtherInfo();"><i class="fa fa-question-circle" aria-hidden="true"></i></button></td>';
    //========================================================================================================================================================================================

    //vMyTableRow += '<td class="col-sm-1 col-xs-12"><label class="brwsBtn" for="upload' + (counter + 1) + '">Upload an image (optional)<input class="isVisuallyHidden" id="upload' + (counter + 1) + '" name="upload[]" type="file" accept="image/*" onchange="loadFile(event, \'output' + (counter + 1) + '\', ' + (counter + 1) + ')" onclick="resetloadFile(event, \'output' + (counter + 1) + '\', ' + (counter + 1) + ')" multiple  /></label></td>';
    //vMyTableRow += '<td class="col-sm-1 col-xs-12"><a class="btn-danger deleteRow btn-sm ibtnDel" onclick="resetloadFile(event, \'output' + (counter + 1) + '\', ' + (counter + 1) + ')"><span class="glyphicon glyphicon-minus remove"></span></a></td>';
    //vMyTableRow += "</tr>";
    vMyTableRow += '<td class="col-sm-1 col-xs-12"> <label class="brwsBtn brwsBtn_tgle" onclick="return ToggleButton(' + counter + ');">Upload an image <i class="fa fa-plus-circle" aria-hidden="true"></i></label></td>';
    vMyTableRow += '<td class="last-minus col-sm-1 col-xs-12"><a class="btn-danger deleteRow btn-sm ibtnDel" onclick="resetloadFile(event, \'output' + (counter + 1) + '\', ' + (counter + 1) + ')"><span class="glyphicon glyphicon-minus remove"></span></a></td>';
    //vMyTableRow += '<table order-list item-tbl"><tbody><div class="mlty_ple_upload_file">inputgrgr</div></tbody></table>';
    vMyTableRow += '<td id="upload_fileToggle' + counter + '" class="mlty_ple_upload_file">';

    vMyTableRow += '<div class="mlty_ple_upload_main">';
    //Already Added Row for Upload
    vMyTableRow += '<div id="apnd_div' + counter + '" class="apnd_div">';
    vMyTableRow += '<div class="mlty_ple_upload">';
    vMyTableRow += '<i class="fa fa-times-circle remove_images_single" onclick="return removeFileUploadRow(this, ' + counter + ', 0);" aria-hidden="true"></i>';
    vMyTableRow += '<div class="form-group">';
    vMyTableRow += '<label class="add_img_file_aa"><i class="fa fa-upload" aria-hidden="true"></i>Upload File<input type="file" id="FileUpload' + counter + '0" size="60" onchange="return displayImage(event, ' + counter + ', 0);" ></label> ';
    vMyTableRow += '</div> ';
    //Already Added Row for Upload
    vMyTableRow += '<div class="file_viwer_sec">';
    vMyTableRow += '<img id="ViewImage' + counter + '0" src="/images/no_image.jpg" />';
    vMyTableRow += '</div>';
    vMyTableRow += '<div class="apnd_mlty_ple">';
    vMyTableRow += '<button type="button" class="btn add_more_img" style="visibility:hidden;"><i class="fa fa-plus-circle" aria-hidden="true"></i> Add More </button>';
    vMyTableRow += '</div>';
    vMyTableRow += '</div>';
    vMyTableRow += '</div>';
    vMyTableRow += '<div class="apnd_mlty_ple">';
    vMyTableRow += '<button type="button" class="btn add_more_img" onclick="return AddImageUploadRow(' + counter + ');"><i class="fa fa-plus-circle" aria-hidden="true"></i> Add More </button>';
    vMyTableRow += '</div>';
    vMyTableRow += '</div>';

    vMyTableRow += '</td>';


    vMyTableRow += "</tr>";


    $("#myTable tbody").append(vMyTableRow);

    var PickupCategoryId = "ddlPickupCategory" + counter.toString();
    var vPickupCategory = $('#' + PickupCategoryId).find("option:selected").text().trim();
    getPickupCategoriesByName(PickupCategoryId);

    var PickupItemId = "ddlPickupItem" + counter.toString();
    var vPickupItem = $('#' + PickupItemId).find("option:selected").text().trim();

    //New Code Added
    //====================
    var TextPickupItemId = "txtPickupItem" + counter.toString();
    var vTextPickupItem = $('#' + TextPickupItemId).val().trim();

    if (vPickupItem == "Pickup Item") {
        vPickupItem = "";
    }

    if (vTextPickupItem != "") {
        if (vPickupItem == "") {
            vPickupItem = vTextPickupItem;
        }
    }
    //====================

    var vRadioButtonValue = "";

    var FragileId = "roundedTwo" + counter.toString();
    var vFragile = $('#' + FragileId);

    if (vFragile.is(":checked")) {
        vRadioButtonValue = "Yes";
    }
    else {
        vRadioButtonValue = "No";
    }

    var EstimatedValueId = "txtEstimatedValue" + counter.toString();
    var vEstimatedValue = $('#' + EstimatedValueId).val().trim();

    if (vEstimatedValue == "")
        vEstimatedValue = "0.00";

    var PredefinedEstimatedValueId = "txtPredefinedEstimatedValue" + counter.toString();
    var vPredefinedEstimatedValue = $('#' + PredefinedEstimatedValueId).val().trim();

    if (vPredefinedEstimatedValue == "")
        vPredefinedEstimatedValue = "0.00";

    $('#myTable').on('change', '#' + PickupCategoryId, function () {
        vPickupCategory = $('#' + PickupCategoryId).find("option:selected").text().trim();
        getPredefinedEstimatedValueByCategoryValue(vPickupCategory, PredefinedEstimatedValueId, PickupItemId);

    });

    $('#myTable').on('change', '#' + PickupItemId, function () {
        vPickupItem = $('#' + PickupItemId).find("option:selected").text().trim();
        getPredefinedEstimatedValueByItemValue(vPickupItem, PredefinedEstimatedValueId);
    });

    //New Code added here
        <%--$('#myTable').on('blur', '#' + EstimatedValueId, function () {
            if (vEstimatedValue != "") {
                if (vPredefinedEstimatedValue != "") {

                    var vMyTable_PredefinedEstimatedValue_String = "";
                    var vMyTable_PredefinedEstimatedValue_Float = 0.0;
                    var vMyTable_TotalValue_Float = 0.0;
                    var vMyTable_VAT = 0.00;

                    $('#myTable tbody > tr').each(function () {
                        vMyTable_PredefinedEstimatedValue_String = $(this).closest("tr").find('input[type=text]:eq(2)').val().trim();

                        vMyTable_PredefinedEstimatedValue_Float = parseFloat(vMyTable_PredefinedEstimatedValue_String);
                        if (!isNaN(vMyTable_PredefinedEstimatedValue_Float)) {
                            vMyTable_TotalValue_Float += vMyTable_PredefinedEstimatedValue_Float;

                            var RegisteredCompany = $("#<%=ddlRegisteredCompany.ClientID%>");
                            var vRegisteredCompany = RegisteredCompany.find("option:selected").text().trim();

                            if (vRegisteredCompany == "Yes") {
                                var GoodsInName = $("#<%=ddlGoodsInName.ClientID%>");
                                var vGoodsInName = GoodsInName.find("option:selected").text().trim();

                                if (vGoodsInName == "Yes") {
                                    vMyTable_VAT = (vMyTable_PredefinedEstimatedValue_Float * 20) / 100;
                                }
                            }

                            vMyTable_TotalValue_Float += vMyTable_VAT;
                            $( "#<%=hfVAT.ClientID%>" ).val( vMyTable_VAT );

                            //===========================================================
                            $( '#<%=spVAT.ClientID%>' ).text( vMyTable_VAT.toFixed( 2 ).toString() );
                            $( '#spVATAmount' ).text( vMyTable_VAT.toFixed( 2 ).toString() );
                            //===========================================================

                            //Insurance Premium Calculation
                            //============================================================
                            var fTotal = vMyTable_TotalValue_Float;
                            var fInsurancePremium = ( fTotal * 10 ) / 100;
                            var vInsurancePremium = fInsurancePremium.toFixed( 2 ).toString();

                            //New Logic Added for 'I am not interested'
                            //==============================================================
                            var Insurance = $( "#<%=ddlInsurance.ClientID%>" );
                            var vInsurance = Insurance.find( "option:selected" ).text().trim();

                            if (vInsurance == "I am not interested")
                                vInsurancePremium = "0.0";
                            //==============================================================

                            $('#<%=txtInsurancePremium.ClientID%>').val(vInsurancePremium);

                            $( '#<%=spInsurancePremium.ClientID%>' ).text( vInsurancePremium );
                            $( '#spInsurancePremiumAmount' ).text( vInsurancePremium );
                            //=============================================================

                            //Insurance Premium added with Total Value
                            //===========================================
                            vMyTable_TotalValue_Float += fInsurancePremium;
                            $( "#<%=spTotal.ClientID%>" ).text( vMyTable_TotalValue_Float.toFixed( 2 ).toString() );
                            $( '#spTotalAmount' ).text($( "#<%=spTotal.ClientID%>" ).text().trim() );
                            //===========================================
                        }
                    });
                }
            }
        });--%>

            if (counter == 1) {
                /*var vId = $("#myTable tbody").closest("tr").find('select:eq(0)').attr('id');
                if (vId == 'ddlPickupCategory1') {
                    counter++;
                }
                alert(vId);*/

                vPickupCategory = $("#ddlPickupCategory").find("option:selected").text().trim();
                vPickupItem = $("#ddlPickupItem").find("option:selected").text().trim();

                //New Code Added
                //=====================
                vTextPickupItem = $("#txtPickupItem").val().trim();

                if (vPickupItem == "Pickup Item") {
                    vPickupItem = "";
                }

                if (vTextPickupItem != "") {
                    if (vPickupItem == "") {
                        vPickupItem = vTextPickupItem;
                    }
                }
                //=====================
                //alert('counter == 1\t' + vPickupItem);

                if ($("#roundedTwo").is(":checked")) {
                    vRadioButtonValue = "Yes";
                }
                else {
                    vRadioButtonValue = "No";
                }

                vEstimatedValue = $("#txtEstimatedValue").val().trim();
                vPredefinedEstimatedValue = $("#txtPredefinedEstimatedValue").val().trim();
            }
            else {
                //Picking up just earlier details
                vCount = counter - 1;

                var PickupCategory_Id = "ddlPickupCategory" + vCount.toString();
                vPickupCategory = $('#' + PickupCategory_Id).find("option:selected").text().trim();
                //alert('Pickup Category Id:\t' + PickupCategory_Id);

                var PickupItem_Id = "ddlPickupItem" + vCount.toString();
                vPickupItem = $('#' + PickupItem_Id).find("option:selected").text().trim();
                //alert('Pickup Item Id:\t' + PickupItem_Id);

                //New Code Added
                //====================
                var TextPickupItem_Id = "txtPickupItem" + vCount.toString();
                vTextPickupItem = $('#' + TextPickupItem_Id).val().trim();

                if (vPickupItem == "Pickup Item") {
                    vPickupItem = "";
                }

                if (vTextPickupItem != "") {
                    if (vPickupItem == "") {
                        vPickupItem = vTextPickupItem;
                    }
                }
                //====================
                //alert('else {\t' + vPickupItem);

                var Fragile_Id = "roundedTwo" + vCount.toString();
                vFragile = $('#' + Fragile_Id);

                if (vFragile.is(":checked")) {
                    vRadioButtonValue = "Yes";
                }
                else {
                    vRadioButtonValue = "No";
                }
                //alert('Radio Button Value:\t' + vRadioButtonValue);

                var EstimatedValue_Id = "txtEstimatedValue" + vCount.toString();
                vEstimatedValue = $('#' + EstimatedValue_Id).val().trim();

                if (vEstimatedValue == "")
                    vEstimatedValue = "0.00";
                //alert('Estimated Value:\t' + vEstimatedValue);

                var PredefinedEstimatedValue_Id = "txtPredefinedEstimatedValue" + vCount.toString();
                vPredefinedEstimatedValue = $('#' + PredefinedEstimatedValue_Id).val().trim();

                if (vPredefinedEstimatedValue == "")
                    vPredefinedEstimatedValue = "0.00";
                //alert('Price:\t' + vPredefinedEstimatedValue);
            }

            if (vPickupCategory == "Pickup Category") {

            }
            else {
                //alert('Pickup Category Else');

                /*if (vPickupItem == "Pickup Item") {
                        var vLength = $('#' +  PickupItemId + ' > option').length;
                        if (vLength > 1) {
                            alert(PickupItemId);
                            PickupItem.focus();
                            return false;
                        }
                        else {
                            vPickupItem = "";
                        }
    
                    vPickupItem = "";
                }*/
                //alert('After Pickup Item');

                if (vPredefinedEstimatedValue == "") {
                    vPredefinedEstimatedValue = "0.00";
                }
                //else {
                var vTableRowFirst = "";
                vTableRowFirst += "<tr>";
                vTableRowFirst += "<td>" + vPickupCategory + "</td>";
                vTableRowFirst += "<td>" + vPickupItem + "</td>";
                vTableRowFirst += "<td>" + vRadioButtonValue + "</td>";
                vTableRowFirst += "<td>" + vPredefinedEstimatedValue + "</td>";
                vTableRowFirst += "</tr>";

                //alert('First:\n' + vTableRowFirst);
                $("#tblBookPickup tbody").append(vTableRowFirst);

                if (vEstimatedValue == "")
                    vEstimatedValue = "0.00";

                    //New Clause Added for Estimated Value
                else {
                    vEstimatedValue = roundOffEstimatedValue(vEstimatedValue);
                }

                var vTableRowLast = "";
                vTableRowLast += "<tr>";
                vTableRowLast += "<td>" + vPickupCategory + "</td>";
                vTableRowLast += "<td>" + vPickupItem + "</td>";
                vTableRowLast += "<td>" + vRadioButtonValue + "</td>";
                vTableRowLast += "<td>" + vEstimatedValue + "</td>";
                vTableRowLast += "<td>" + vPredefinedEstimatedValue + "</td>";
                vTableRowLast += "</tr>";

                //alert('Last:\n' + vTableRowLast);
                $("#tblConfirmItems tbody").append(vTableRowLast);

                var vTableDataValue = 0.00;
                var vTotalValue = 0.00;
                var dVAT = 0.00;

                $('#tblBookPickup tbody > tr').each(function () {
                    vTableDataValue = parseFloat($(this).find('td:eq(3)').text().trim());
                    if (!isNaN(vTableDataValue)) {
                        vTotalValue += vTableDataValue;
                        dVAT = (vTotalValue * 20) / 100;
                        vTotalValue += dVAT;
                    }
                });

                if ($("#secBookPickup").height() > 522) {
                    $("#secBookPickup").css('height', 'auto');
                }

                //$("#<%=spTotal.ClientID%>").text(vTotalValue.toFixed(2).toString());
            //}
        }

            counter = parseInt($("#<%=hfItemCount.ClientID%>").val().trim());
            counter++;
            $("#<%=hfItemCount.ClientID%>").val(counter.toString());
            $("#<%=spItemCount.ClientID%>").text(counter.toString());

            return false;
        }

        function addMultipleRowBookPickup() {
            var sRows = prompt("How many Rows?", "2");
            var iRows = 0;

            try {
                iRows = parseInt(sRows);
                var rowCount = $('#myTable >tbody').find('tr').length;
                if (iRows >= 2) {
                    for (var i = 0; i < iRows; i++) {
                        addRowBookPickup();
                    }
                    CopyFirstRow(rowCount);
                    getMyTableTotal();
                }
                else {
                    $.alert({
                        title: 'Invalid Number',
                        content: 'You must add atleast a couple of rows'
                    });
                }
            }
            catch (e) {
                $.alert({
                    title: 'Invalid Number',
                    content: 'Please enter a valid number'
                });
            }

            return false;
        }


        //function CopyFirstRow(rowCount) {
        //    
        //    var vMyTable_PickupCategory = "";
        //    var vMyTable_PickupCategoryValue = "";
        //    var vMyTable_PickupItem = "";
        //    var vMyTable_PickupItemHtml = "";
        //    var vMyTable_PickupItemValue = "";

        //    var MyTable_IsFragile = "";
        //    var vMyTable_IsFragile = "";
        //    var vMyTable_EstimatedValue = "";
        //    var vMyTable_PredefinedEstimatedValue = "";

        //    $('#myTable >tbody >tr').each(function (index, val) {
        //        

        //        if (rowCount == val.rowIndex) {
        //            //alert(rowCount + '  ' + val.rowIndex);
        //            vMyTable_PickupCategory = $(this).closest("tr").find('select:eq(0)').find("option:selected").text().trim();
        //            vMyTable_PickupCategoryValue = $(this).closest("tr").find('select:eq(0)').find("option:selected").val().trim();

        //            vMyTable_PickupItem = $(this).closest("tr").find('select:eq(1)').find("option:selected").text().trim();
        //            vMyTable_PickupItemValue = $(this).closest("tr").find('select:eq(1)').find("option:selected").val().trim();
        //            vMyTable_PickupItemHtml = $(this).closest("tr").find('select:eq(1)').html().trim();

        //            //New Code Added for Other Textbox
        //            //====================
        //            //vMyTable_TextPickupItem = $(this).closest("tr").find('input[type=text]:eq(0)').val().trim();

        //            var MyTable_IsFragile = $(this).closest("tr").find('input:checkbox');
        //            if (MyTable_IsFragile.is(":checked")) {
        //                vMyTable_IsFragile = "true";
        //            }
        //            else {
        //                vMyTable_IsFragile = "false";
        //            }
        //            vMyTable_EstimatedValue = $(this).closest("tr").find('input[type=text]:eq(1)').val().trim();
        //            vMyTable_PredefinedEstimatedValue = $(this).closest("tr").find('input[type=text]:eq(2)').val().trim();
        //            //alert(vMyTable_PickupCategory);

        //            $('#myTable >tbody >tr').each(function (index, val) {
        //                
        //                if (rowCount < val.rowIndex) {
        //                    var vMyTable_PickupCategoryId = $(this).closest("tr").find('select:eq(0)').attr("id");
        //                    $('#' + vMyTable_PickupCategoryId).val(vMyTable_PickupCategoryValue);

        //                    var vMyTable_PickupItemId = $(this).closest("tr").find('select:eq(1)').attr("id");
        //                    $('#' + vMyTable_PickupItemId).html(vMyTable_PickupItemHtml);
        //                    $('#' + vMyTable_PickupItemId).val(vMyTable_PickupItemValue);

        //                    var MyTable_IsFragileId = $(this).closest("tr").find('input:checkbox').attr("id");
        //                    $('#' + MyTable_IsFragileId).prop('checked', vMyTable_IsFragile);

        //                    var vMyTable_EstimatedValueId = $(this).closest("tr").find('input[type=text]:eq(1)').attr("id");
        //                    $('#' + vMyTable_EstimatedValueId).val(vMyTable_EstimatedValue);

        //                    var vMyTable_PredefinedEstimatedValueId = $(this).closest("tr").find('input[type=text]:eq(2)').attr("id");
        //                    $('#' + vMyTable_PredefinedEstimatedValueId).val(vMyTable_PredefinedEstimatedValue);
        //                }
        //            });
        //        }
        //    });

        //}

        function CopyFirstRow(rowCount) {
            
            var vMyTable_PickupCategory = "";
            var vMyTable_PickupCategoryValue = "";

            var vMyTable_PickupItemTextBox = "";

            var vMyTable_PickupItem = "";
            var vMyTable_PickupItemHtml = "";
            var vMyTable_PickupItemValue = "";

            var MyTable_IsFragile = "";
            var vMyTable_IsFragile = false;
            var vMyTable_EstimatedValue = "";
            var vMyTable_PredefinedEstimatedValue = "";

            $('#myTable >tbody >tr').each(function (index, val) {
                

                if (rowCount == val.rowIndex) {
                    //alert(rowCount + '  ' + val.rowIndex);
                    vMyTable_PickupCategory = $(this).closest("tr").find('select:eq(0)').find("option:selected").text().trim();
                    vMyTable_PickupCategoryValue = $(this).closest("tr").find('select:eq(0)').find("option:selected").val().trim();

                    if (vMyTable_PickupCategory == "Other") {
                        vMyTable_PickupItemTextBox = $(this).closest("tr").find('input[type=text]:eq(0)').val().trim();
                        //alert(vMyTable_PickupItemTextBox);
                    }
                    else {
                        vMyTable_PickupItem = $(this).closest("tr").find('select:eq(1)').find("option:selected").text().trim();
                        vMyTable_PickupItemValue = $(this).closest("tr").find('select:eq(1)').find("option:selected").val().trim();
                        vMyTable_PickupItemHtml = $(this).closest("tr").find('select:eq(1)').html().trim();
                    }

                    //New Code Added for Other Textbox
                    //====================
                    //vMyTable_TextPickupItem = $(this).closest("tr").find('input[type=text]:eq(0)').val().trim();

                    var MyTable_IsFragile = $(this).closest("tr").find('input:checkbox');
                    if (MyTable_IsFragile.is(":checked")) {
                        vMyTable_IsFragile = true;
                    }
                    else {
                        vMyTable_IsFragile = false;
                    }
                    vMyTable_EstimatedValue = $(this).closest("tr").find('input[type=text]:eq(1)').val().trim();
                    vMyTable_PredefinedEstimatedValue = $(this).closest("tr").find('input[type=text]:eq(2)').val().trim();
                    //alert(vMyTable_PickupCategory);

                    $('#myTable >tbody >tr').each(function (index, val) {
                        
                        if (rowCount < val.rowIndex) {
                            var vMyTable_PickupCategoryId = $(this).closest("tr").find('select:eq(0)').attr("id");
                            $('#' + vMyTable_PickupCategoryId).val(vMyTable_PickupCategoryValue);

                            var vMyTable_PickupItemId = $(this).closest("tr").find('select:eq(1)').attr("id");
                            if (vMyTable_PickupCategory == "Other") {
                                var vMyTable_PickupItemTextBoxId = $(this).closest("tr").find('input[type=text]:eq(0)').attr("id");
                                //vMyTable_PickupItemTextBox = $(this).closest("tr").find('input[type=text]:eq(0)').val().trim();
                                //alert(vMyTable_PickupItemTextBox);
                                $('#' + vMyTable_PickupItemId).css("display", "none");
                                $('#' + vMyTable_PickupItemTextBoxId).css("display", "block");

                                $('#' + vMyTable_PickupItemTextBoxId).val(vMyTable_PickupItemTextBox);
                                var vMyTable_EstimatedValueId = $(this).closest("tr").find('input[type=text]:eq(1)').attr("id");
                                $('#' + vMyTable_EstimatedValueId).val(vMyTable_EstimatedValue);

                                var vMyTable_PredefinedEstimatedValueId = $(this).closest("tr").find('input[type=text]:eq(2)').attr("id");
                                $('#' + vMyTable_PredefinedEstimatedValueId).val(vMyTable_PredefinedEstimatedValue);

                            }
                            else {

                                $('#' + vMyTable_PickupItemId).html(vMyTable_PickupItemHtml);
                                $('#' + vMyTable_PickupItemId).val(vMyTable_PickupItemValue);

                                var vMyTable_EstimatedValueId = $(this).closest("tr").find('input[type=text]:eq(1)').attr("id");
                                $('#' + vMyTable_EstimatedValueId).val(vMyTable_EstimatedValue);

                                var vMyTable_PredefinedEstimatedValueId = $(this).closest("tr").find('input[type=text]:eq(2)').attr("id");
                                $('#' + vMyTable_PredefinedEstimatedValueId).val(vMyTable_PredefinedEstimatedValue);
                            }


                            var MyTable_IsFragileId = $(this).closest("tr").find('input:checkbox').attr("id");
                            $('#' + MyTable_IsFragileId).prop('checked', vMyTable_IsFragile);
                        }
                    });
                }
            });

        }

        function deleteRowBookPickup() {

            var vTableDataValue = 0.00;
            var vTotalValue = 0.00;
            var dVAT = 0.00;

            $('#tblBookPickup tbody > tr').each(function () {
                vTableDataValue = parseFloat($(this).find('td:eq(3)').text().trim());
                if (!isNaN(vTableDataValue)) {
                    vTotalValue += vTableDataValue;
                    dVAT = (vTotalValue * 20) / 100;
                    vTotalValue += dVAT;
                }
            });

            counter--;

            $("#<%=hfItemCount.ClientID%>").val(counter.toString());
            $("#<%=spItemCount.ClientID%>").text(counter.toString());

            getMyTableTotal();

            if ($("#<%=spItemCount.ClientID%>").text() == "0") {
                counter = 1;
                vCount = 0;
                $("#<%=spTotal.ClientID%>").text("0.00");
            }

            return false;
        }

        function checkCollectionDate() {
            var CollectionDateTime = $("#<%=txtCollectionDate.ClientID%>").val().trim();
            var From_date = new Date(CollectionDateTime);

            var Current_date = new Date();
            var diff_date = Current_date - From_date;

            var years = Math.floor(diff_date / 31536000000);
            var months = Math.floor((diff_date % 31536000000) / 2628000000);
            var days = Math.floor(((diff_date % 31536000000) % 2628000000) / 86400000);

            //alert(years + " year(s) " + months + " month(s) and " + days + " day(s)");

            clearErrorMessage();

            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#f9edef");
            ErrMsg.css("color", "red");
            ErrMsg.css("text-align", "center");

            if (years > 0) {
                ErrMsg.text('Collection Date cannot be earlier than Current Date');
                ErrMsg.css("display", "block");
                //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                return false;
            }
            else {

                if (months > 0) {
                    ErrMsg.text('Collection Date cannot be earlier than Current Date');
                    ErrMsg.css("display", "block");
                    //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                    return false;
                }
                else {

                    if (days > 0) {
                        ErrMsg.text('Collection Date cannot be earlier than Current Date');
                        ErrMsg.css("display", "block");
                        //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                        return false;
                    }
                    else {

                    }
                }
            }
        }

        function gotoStep2() {
            $("#dvStep1").hide(500);
            $("#dvStep2").show(500);

            $("#progressbar li").eq(1).addClass("active");
        }

        function checkMyPackageDetails() {
            var RegisteredCompany = $("#<%=ddlRegisteredCompany.ClientID%>");
            var vRegisteredCompany = RegisteredCompany.find("option:selected").text().trim();

            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#f9edef");
            ErrMsg.css("color", "red");
            ErrMsg.css("text-align", "center");

            showStep1MandatoryFields();

            if (vRegisteredCompany == "Please Select") {
                ErrMsg.text("Please Select either 'Yes' or 'No' from 'Registered Company' dropdown");
                ErrMsg.css("display", "block");
                //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                RegisteredCompany.focus();
                return false;
            }

            if (RegisteredCompany.val().trim() == "1") {
                var CompanyName = $("#<%=txtCompanyName.ClientID%>");
                var vCompanyName = CompanyName.val().trim();

                var GoodsInName = $("#<%=ddlGoodsInName.ClientID%>");
                var vGoodsInName = GoodsInName.find("option:selected").text().trim();

                if (vCompanyName == "") {
                    ErrMsg.text("Please mention your Company Name");
                    ErrMsg.css("display", "block");
                    //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                    CompanyName.addClass('manField');
                    CompanyName.focus();
                    return false;
                }
                else {
                    CompanyName.removeClass('manField');
                }

                if (vGoodsInName == "Please Select") {
                    ErrMsg.text("Please Select either 'Yes' or 'No' from 'Goods In Name' dropdown");
                    ErrMsg.css("display", "block");
                    //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                    GoodsInName.focus();
                    GoodsInName.addClass('manField');
                    return false;
                }
                else {
                    GoodsInName.removeClass('manField');
                }
            }

            var Insurance = $("#<%=ddlInsurance.ClientID%>");
            var vInsurance = Insurance.find("option:selected").text().trim();

            if (vInsurance == "Please Select") {
                //alert('Insurance');
                ErrMsg.text("Please Select either 'Yes' or 'No' from 'Insurance' dropdown");
                ErrMsg.css("display", "block");
                Insurance.addClass('manField');
                return false;
            }
            else {
                Insurance.removeClass('manField');

                //New Code Added for Insurance Premium
                //======================================
                if (vInsurance == "No") {

                    var InsurancePremium = $("#<%=txtInsurancePremium.ClientID%>");
                    var vInsurancePremium = InsurancePremium.val().trim();

                    if (vInsurancePremium == "") {
                        ErrMsg.text("Please pay Insurance Premium");
                        ErrMsg.css("display", "block");

                        InsurancePremium.addClass('manField');
                        InsurancePremium.focus();

                        return false;
                    }
                }
                //======================================
            }

            var NoErrorFound = true;

            NoErrorFound = BookingTableValidation();
            if (!NoErrorFound) {
                return false;
            }


            var CollectionDate = $("#<%=txtCollectionDate.ClientID%>");
            var vCollectionDate = CollectionDate.val().trim();

            if (vCollectionDate == "") {
                ErrMsg.text("Please Select a Collection Date after Current Date");
                ErrMsg.css("display", "block");
                //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionDate.focus();
                return false;
            }
            else {
                var ConfirmCollectionDate = $('#<%=lblConfirmCollectionDate.ClientID%>');
                var vConfirmCollectionDate = ConfirmCollectionDate.text().trim();

                var vCollectionDateTime = "";
                if (vConfirmCollectionDate == "") {
                    try {
                        vDay = vCollectionDate.substr(0, 2);
                        vMonth = vCollectionDate.substr(3, 2);
                        vYear = vCollectionDate.substr(6, 4);

                        vCollectionDate = vYear + '-' + vMonth + '-' + vDay;
                        vCollectionDateTime = new Date(vCollectionDate).toDateString();

                        ConfirmCollectionDate.text(vCollectionDateTime);
                    }
                    catch (e) {
                        var vYear = "", vMonth = "", vDay = "";
                        try {
                            vYear = vCollectionDate.substr(0, 4);
                            vMonth = vCollectionDate.substr(5, 2);
                            vDay = vCollectionDate.substr(8, 2);
                        }
                        catch (e) {
                        }

                        vCollectionDate = vDay + "-" + vMonth + "-" + vYear;

                        vCollectionDateTime = new Date(vCollectionDate).toDateString();
                        ConfirmCollectionDate.text(vCollectionDateTime);
                    }
                }
            }
            //Assign BookingNotes To Confirmation page
            var ConfirmStatusDetails = $('#StatusDetails').val().trim();
            //alert(ConfirmStatusDetails);
            $('#<%=lblConfirmStatusDetails.ClientID%>').text(ConfirmStatusDetails);


            var chkAgree = $("#<%=chkAgree.ClientID%>");
            if (!chkAgree.is(":checked")) {
                ErrMsg.text("Please tick on the Agreement Checkbox");
                ErrMsg.css("display", "block");
                //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                chkAgree.focus();
                return false;
            }

            var bStep1 = false;
            if ($("#<%=spItemCount.ClientID%>").text().trim() == "0") {
                hideStep1MandatoryFields();
                if (showStep1DataTableMandatoryFields()) {
                    bStep1 = true;
                    $("#<%=spItemCount.ClientID%>").text('1');

                    var vPredefinedEstimatedValue = $("#txtPredefinedEstimatedValue").val().trim();
                    $("#<%=spTotal.ClientID%>").text(vPredefinedEstimatedValue);

                    var PickupCateogry = $("#ddlPickupCategory");
                    var PickupItem = $("#ddlPickupItem");

                    var vPickupCategory = PickupCateogry.find("option:selected").text().trim();
                    var vPickupItem = PickupItem.find("option:selected").text().trim();

                    if (vPickupItem == "Pickup Item") {
                        vPickupItem = "";
                    }

                    //New Code Added
                    //====================
                    var vTextPickupItem = $("#txtPickupItem").val().trim();

                    if (vTextPickupItem != "") {
                        if (vPickupItem == "") {
                            vPickupItem = vTextPickupItem;
                        }
                    }
                    //====================

                    var vRadioButtonValue = "";

                    if ($("#roundedTwo").is(":checked")) {
                        vRadioButtonValue = "Yes";
                    }
                    else {
                        vRadioButtonValue = "No";
                    }

                    var vEstimatedValue = $("#txtEstimatedValue").val().trim();

                    if (vEstimatedValue == "")
                        vEstimatedValue = "0.00";

                        //New Clause Added for Estimated Value
                    else {
                        vEstimatedValue = roundOffEstimatedValue(vEstimatedValue);
                    }

                    var vTableRowLast = "";
                    vTableRowLast += "<tr>"
                    vTableRowLast += "<td>" + vPickupCategory + "</td>";
                    vTableRowLast += "<td>" + vPickupItem + "</td>";
                    vTableRowLast += "<td>" + vRadioButtonValue + "</td>";
                    vTableRowLast += "<td>" + vEstimatedValue + "</td>";
                    vTableRowLast += "<td>" + vPredefinedEstimatedValue + "</td>";
                    vTableRowLast += "</tr>";

                    $("#tblConfirmItems tbody").append(vTableRowLast);

                    //uploadImageFile();

                    gotoStep2();
                }
                else {
                    return bStep1;
                }
            }
            else {
                hideStep1DataTableMandatoryFields();
                bStep1 = true;
            }

            bStep1 = false;
            //uploadImageFile();

            gotoStep2();

            return bStep1;
        }

        function BookingTableValidation() {

            var NoErrorFound = true;

            var ErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
                ErrMsg.text( '' );
                ErrMsg.css( "display", "none" );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css("text-align", "center");

            //==========Check Category In Booking Table
            $('#myTable >tbody >tr').each(function (index, val) {
                
                if (index >= 0) {
                    var vMyTable_PickupCategoryId = $(this).closest("tr").find('select:eq(0)').attr("id");
                    var vMyTable_PickupCategory = $(this).closest("tr").find('select:eq(0)').find("option:selected").text().trim();
                    //alert(vMyTable_PickupCategoryId + ' = ' + vMyTable_PickupCategory);



                    if (vMyTable_PickupCategory == "Pickup Category" || vMyTable_PickupCategory == "") {

                        ErrMsg.text('Please select a Pickup Category');
                        ErrMsg.css("display", "block");
                        $("#" + vMyTable_PickupCategoryId).focus();
                        $("#" + vMyTable_PickupCategoryId).addClass('manField');
                        NoErrorFound = false;
                    }
                    else { $("#" + vMyTable_PickupCategoryId).removeClass('manField'); }

                    var vMyTable_PickupItemId = $(this).closest("tr").find('select:eq(1)').attr("id");
                    var vMyTable_PickupItem = $(this).closest("tr").find('select:eq(1)').find("option:selected").text().trim();

                    var PickupItem = $("#" + vMyTable_PickupItemId);
                    var vPickupItem = PickupItem.find("option:selected").text().trim();

                    if (vPickupItem == "Pickup Item") {
                        if (vMyTable_PickupCategory != "Pickup Category" && vMyTable_PickupCategory != "Other") {
                            var vLength = $('#' + vMyTable_PickupItemId).children('option').length;
                            //alert('vLength' + vLength + ', vLength1 = ' + vLength1)
                            if (vLength > 1) {
                                ErrMsg.text('Please select a Pickup Item');
                                ErrMsg.css("display", "block");
                                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                                $("#" + vMyTable_PickupCategoryId).removeClass('manField');
                                PickupItem.focus();
                                PickupItem.addClass('manField');
                                NoErrorFound = false;
                            }
                        }
                    }
                    else { $("#" + vMyTable_PickupItemId).removeClass('manField'); }
                    //New Code Added
                    //======================
                    var TextPickupItem = $(this).closest("tr").find('input[type=text]:eq(0)').attr('id');
                    var vTextPickupItem = $("#" + TextPickupItem).val().trim();

                    var PredefinedEstimatedId = $(this).closest("tr").find('input[type=text]:eq(2)').attr('id');
                    var PredefinedEstimatedValue = $(this).closest("tr").find('input[type=text]:eq(2)').val();

                    if (vMyTable_PickupCategory == 'Other') {
                        if (vTextPickupItem == '') {
                            ErrMsg.text('Please enter a Pickup Item');
                            ErrMsg.css("display", "block");

                            $("#" + vMyTable_PickupCategoryId).removeClass('manField');
                            $("#" + TextPickupItem).focus();
                            $("#" + TextPickupItem).addClass('manField');
                            NoErrorFound = false;
                        }
                        else {
                            $("#" + TextPickupItem).removeClass('manField');

                            if (parseFloat(PredefinedEstimatedValue) == 0.0) {
                                ErrMsg.text('Please enter amount to pay');
                                ErrMsg.css("display", "block");
                                $("#" + PredefinedEstimatedId).focus();
                                $("#" + PredefinedEstimatedId).addClass('manField');
                                NoErrorFound = false;
                            }
                            else { $("#" + PredefinedEstimatedId).removeClass('manField'); }
                        }



                    }
                    //======================


                    //if (vMyTable_PickupItem == "" || vMyTable_PickupItem == "") {

                    //}
                }
            });

            //==========Check Category In Booking Table

            return NoErrorFound;
        }


        function gotoPreviousStep2() {

            $("#dvStep1").show(500);
            $("#dvStep2").hide(500);

            $("#progressbar li").eq(1).removeClass("active");

            return false;
        }

        function gotoPreviousStep3() {

            $("#dvStep2").show(500);
            $("#dvStep3").hide(500);

            $("#progressbar li").eq(2).removeClass("active");

            return false;
        }

        function gotoPreviousStep4() {

            $("#dvStep3").show(500);
            $("#dvStep4").hide(500);

            $("#progressbar li").eq(3).removeClass("active");

            return false;
        }

        function gotoPreviousStep5() {

            $("#dvStep3").show(500);
            $("#dvStep5").hide(500);

            $("#progressbar li").eq(2).removeClass("active");

            return false;
        }

        function checkLoginStatus() {
            if (checkBlankTextBoxes() == true) {
                getLoginResult();
            }

            return false;
        }
    </script>

    <script>
        function getPickupCategories() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetPickupCategories",
                data: "{}",
                async: false,
                dataType: "json",
                success: function (data) {
                    $.each(data.d, function (key, value) {
                        $("#ddlPickupCategory").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                    })
                },
                error: function (response) {
                }
            });

        }

        function getPickupCategoriesByName(PickupCategoryName) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetPickupCategories",
                data: "{}",
                async: false,
                dataType: "json",
                success: function (data) {
                    $.each(data.d, function (key, value) {
                        //$('[name="' + PickupCategoryName + '"]').append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                        $('#' + PickupCategoryName).append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                    })
                },
                error: function (response) {
                }
            });

        }

        function getPickupItemsByCategory(PickupCategory) {
            $.ajax({
                type: "POST",
                url: "LoggedQuote.aspx/GetPickupItemsByCategory",
                data: "{ PickupCategory: '" + PickupCategory + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    $("#ddlPickupItem").html("");
                    $("#ddlPickupItem").append($("<option></option>").val(null).html("Pickup Item"));

                    $.each(result.d, function (key, value) {
                        $("#ddlPickupItem").append($("<option></option>").val(value.PickupItemId).html(value.PickupItem));
                    });
                    //alert($('#ddlPickupItem option').length);
                    //New Code Added to Show/Hide Pickup Items based on No of Items
                    //=============================================================
                    if ($('#ddlPickupItem option').length > 2) {
                        $('#ddlPickupItem').css('display', 'block');
                    }
                    else {
                        $('#ddlPickupItem').css('display', 'none');
                        getMyTableTotal();
                    }
                    //=============================================================
                },
                error: function (response) {
                }
            });
        }

        function getPickupItemsByCategoryUsingItemId(PickupCategoryValue, PickupItemId) {
            $.ajax({
                type: "POST",
                url: "LoggedQuote.aspx/GetPickupItemsByCategory",
                data: "{ PickupCategory: '" + PickupCategoryValue + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $('#' + PickupItemId).html("");
                    $('#' + PickupItemId).append($("<option></option>").val(null).html("Pickup Item"));

                    $.each(result.d, function (key, value) {
                        $('#' + PickupItemId).append($("<option></option>").val(value.PickupItemId).html(value.PickupItem));
                    });

                    //New Code Added to Show/Hide Pickup Items based on No of Items
                    //=============================================================
                    //alert(PickupItemId + ": " + $('#' + PickupItemId + ' option').length);

                    if ($('#' + PickupItemId + ' option').length > 2) {
                        $('#' + PickupItemId).css('display', 'block');
                    }
                    else {
                        $('#' + PickupItemId).css('display', 'none');
                    }
                    //=============================================================
                },
                error: function (response) {
                }
            });
        }

        function getPredefinedEstimatedValueByCategory() {
            var PickupCategory = $("#ddlPickupCategory").find("option:selected").text().trim();

            //alert('PickupCategory: ' + PickupCategory);

            $.ajax({
                type: "POST",
                url: "LoggedQuote.aspx/GetPredefinedEstimatedValueByCategory",
                data: '{ PickupCategory: "' + PickupCategory + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $("#txtPredefinedEstimatedValue").val(result.d);
                    $("#txtPredefinedEstimatedValue").removeClass('manField');
                    $("#txtPredefinedEstimatedValue").attr("readonly", "readonly");
                    //New Code Added
                    //==================
                    if (PickupCategory == 'Other') {
                        //debashish
                        $("#txtPredefinedEstimatedValue").val('0.00');

                        $("#txtEstimatedValue").val('0.00');
                        //debashish

                        $("#ddlPickupItem").css("display", "none");
                        $("#txtPickupItem").css("display", "block");
                        $("#txtEstimatedValue").val('0.00');
                        $("#txtPredefinedEstimatedValue").removeAttr("readonly");
                        $("#txtPredefinedEstimatedValue").val('0.00');
                        $("#txtPickupItem").focus();

                        //New Button Added
                        //===========================================
                        $('#btnQuestion').css('display', 'block');
                        //===========================================

                        $('#myTable').addClass('incTblWidth');
                    }
                    else {
                        //Debashish
                        $("#txtEstimatedValue").val('0.00');
                        //$("#txtPredefinedEstimatedValue").removeAttr("readonly");
                        //Debashish

                        $("#txtPickupItem").css("display", "none");
                        $("#ddlPickupItem").css("display", "block");
                    }

                    getPickupItemsByCategory(PickupCategory);
                },
                error: function (response) {
                }
            });
        }

        // Getting PredefinedEstimatedValueOnly From Category
        function getPredefinedEstimatedValueOnlyByCategory(PickupCategoryValue, PredefinedEstimatedValueId) {
            $.ajax({
                type: "POST",
                url: "LoggedQuote.aspx/GetPredefinedEstimatedValueByCategory",
                data: '{ PickupCategory: "' + PickupCategoryValue + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $('#' + PredefinedEstimatedValueId).val(result.d);
                },
                error: function (response) {
                }
            });
        }

        function getPredefinedEstimatedValueByCategoryValue(PickupCategoryValue, PredefinedEstimatedValueId, PickupItemId) {

            $.ajax({
                type: "POST",
                url: "LoggedQuote.aspx/GetPredefinedEstimatedValueByCategory",
                data: '{ PickupCategory: "' + PickupCategoryValue + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    $('#' + PredefinedEstimatedValueId).val(result.d);
                    $('#' + PredefinedEstimatedValueId).removeClass('manField');
                    getMyTableTotal();
                    //New Code Added
                    //==================
                    var LastDigit = PickupItemId.substr(PickupItemId.length - 1);
                    var TextPickupItemId = "txtPickupItem" + LastDigit;
                    var EstimatedValueId = "txtEstimatedValue" + LastDigit;

                    //New ButtonId Created
                    //=====================================================
                    var QuestionButtonId = "btnQuestion" + LastDigit;
                    //=====================================================

                    //alert(LastDigit + '\n' + TextPickupItemId + '\n' + EstimatedValueId);

                    var EstimatedValueId = "txtEstimatedValue" + LastDigit;
                    var PreDefinedValueId = "txtPredefinedEstimatedValue" + LastDigit;
                    $('#' + PreDefinedValueId).attr("readonly", "readonly");
                    //alert(PickupItemId + ' ' + PickupCategoryValue);
                    // ddlPickupItem1 ddlPickupItem1
                    if (PickupCategoryValue == 'Other') {

                        $('#' + PickupItemId).css("display", "none");
                        $('#' + TextPickupItemId).css("display", "block");
                        $('#' + EstimatedValueId).val('0.00');
                        $('#' + PredefinedEstimatedValueId).removeAttr("readonly");
                        $('#' + PredefinedEstimatedValueId).val('0.00');
                        $('#' + TextPickupItemId).focus();

                        $('#' + PreDefinedValueId).val('0.00');
                        
                        $('#' + EstimatedValueId).val('0.00');

                        //New Button Added
                        //===================================================
                        $('#' + QuestionButtonId).css('display', 'block');
                        //===================================================

                        $('#myTable').addClass('incTblWidth');
                    }
                    else {
                        $('#' + TextPickupItemId).css("display", "none");
                        $('#' + PickupItemId).css("display", "block");

                        $('#' + EstimatedValueId).val('0.00');

                    }

                    getPickupItemsByCategoryUsingItemId(PickupCategoryValue, PickupItemId);
                },
                error: function (response) {
                }
            });
        }

        function getPredefinedEstimatedValueByItem() {
            var PickupItem = $("#ddlPickupItem").find("option:selected").text().trim();
            //alert('Text: ' + PickupItem);

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetPredefinedEstimatedValueByItem",
                data: "{ PickupItem: '" + PickupItem + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    //alert("txtPredefinedEstimatedValue=" + result.d);
                    $("#txtPredefinedEstimatedValue").val(result.d);
                    $("#txtPredefinedEstimatedValue").removeClass('manField');
                    getMyTableTotal();
                },
                error: function (response) {
                }
            });
        }

        function getPredefinedEstimatedValueByItemValue(PickupItemValue, PredefinedEstimatedValueId) {

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetPredefinedEstimatedValueByItem",
                data: "{ PickupItem: '" + PickupItemValue + "'}",
                dataType: "json",
                async: false,
                success: function (result) {
                    $('#' + PredefinedEstimatedValueId).val(result.d);
                    $('#' + PredefinedEstimatedValueId).removeClass('manField');
                    getMyTableTotal();
                },
                error: function (response) {
                }
            });
        }

        function getCustomerId() {

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/GetCustomerId",
                data: "{}",
                dataType: "json",
                async: false,
                success: function (result) {
                    var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
                        if (CustomerId == null || CustomerId == "") {
                            $("#<%=hfCustomerId.ClientID%>").val(result.d);
                        }
                    //$("#<%//=hfCustomerId.ClientID%>").val(result.d);
                        //alert(result.d);
                    },
                    error: function (response) {
                    }
                });
                }

                function getBookingId() {

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LoggedQuote.aspx/GetBookingId",
                        data: "{}",
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            $("#<%=hfBookingId.ClientID%>").val(result.d);
                        //alert(result.d);
                    },
                    error: function (response) {
                    }
                });
                }

                function generateQuoteId() {

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "LoggedQuote.aspx/GenerateQuoteId",
                        data: "{}",
                        dataType: "json",
                        success: function (result) {
                            $("#<%=hfQuoteId.ClientID%>").val(result.d);
                        //alert(result.d);
                    },
                    error: function (response) {
                    }
                });
                }

                function sendBookingByEmail(EmailID, jQueryDataTableContent) {
                    var vErrMsg = $("#<%=lblErrMsg3.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            showStep3MandatoryFields();
            var timeDuration = 2000;

            var QuoteId = $("#<%=hfQuoteId.ClientID%>").val().trim();
            var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
            var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();

            //objQuote = {};
            //objQuote.QuoteId = QuoteId;
            //objQuote.CustomerId = CustomerId;
            //objQuote.BookingId = BookingId;

            //$.ajax({
            //    type: "POST",
            //    contentType: "application/json; charset=utf-8",
            //    url: "LoggedQuote.aspx/AddQuote",
            //    data: JSON.stringify(objQuote),
            //    dataType: "json",
            //    success: function (result) {

            //    },
            //    error: function (response) {

            //    }
            //});//end of Quote Entry

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "LoggedQuote.aspx/SendBookingByEmail",
                data: "{ EmailID: '" + EmailID + "', jQueryDataTableContent: '" + jQueryDataTableContent + "', BookingId: '" + BookingId + "'}",
                dataType: "json",
                beforeSend: function () {
                    $("#loaderDiv").show();

                    $("#loaderQuotationText").hide();
                    $("#successQuotationText").hide();
                    $("#anchorHome").hide();

                    $("#loaderBookingText").show();
                    $("#successBookingText").hide();
                    $("#anchorHomeB").hide();

                    $("#loaderImage").show();
                },
                success: function (result) {
                    $("#loaderDiv").show();

                    $("#loaderQuotationText").hide();
                    $("#successQuotationText").hide();
                    $("#anchorHome").hide();

                    $("#loaderBookingText").hide();
                    $("#successBookingText").hide();
                    $("#anchorHomeB").hide();

                    $("#loaderImage").hide();
                },
                error: function (response) {
                    $("#loaderDiv").hide();
                }
            });

        }//end of function

        function sendPayLaterEmail(EmailID, jQueryDataTableContent) {
            var vErrMsg = $("#<%=lblErrMsg3.ClientID%>");
                vErrMsg.text('');
                vErrMsg.css("display", "none");

                showStep3MandatoryFields();
                var timeDuration = 2000;

                var QuoteId = $("#<%=hfQuoteId.ClientID%>").val().trim();
                var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
                var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();

                //objQuote = {};
                //objQuote.QuoteId = QuoteId;
                //objQuote.CustomerId = CustomerId;
                //objQuote.BookingId = BookingId;

                //$.ajax({
                //    type: "POST",
                //    contentType: "application/json; charset=utf-8",
                //    url: "LoggedQuote.aspx/AddQuote",
                //    data: JSON.stringify(objQuote),
                //    dataType: "json",
                //    success: function (result) {

                //    },
                //    error: function (response) {

                //    }
                //});//end of Quote Entry

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "LoggedQuote.aspx/SendPayLaterEmail",
                    data: "{ EmailID: '" + EmailID + "', jQueryDataTableContent: '" + jQueryDataTableContent + "', BookingId: '" + BookingId + "'}",
                    dataType: "json",
                    beforeSend: function () {
                        $("#loaderDiv").show();

                        $("#loaderQuotationText").hide();
                        $("#successQuotationText").hide();
                        $("#anchorHome").hide();

                        $("#loaderBookingText").show();
                        $("#successBookingText").hide();
                        $("#anchorHomeB").hide();

                        $("#loaderImage").show();
                    },
                    success: function (result) {
                        $("#loaderDiv").show();

                        $("#loaderQuotationText").hide();
                        $("#successQuotationText").hide();
                        $("#anchorHome").hide();

                        $("#loaderBookingText").hide();
                        $("#successBookingText").show();
                        $("#anchorHomeB").show();

                        $("#loaderImage").hide();
                    },
                    error: function (response) {
                        $("#loaderDiv").hide();
                    }
                });
            }//end of function

            function uploadImageFile()
            {
                
                var files = "";
                var OuterLoopCount = 0;
                var BookingId = $( "#<%=hfBookingId.ClientID%>" ).val().trim();
                //alert('uploadImageFile ' + BookingId);
            //New Code for Removing Existing Images
            //==========================================
            $.ajax( {
                type: "POST",
                url: "LoggedQuote.aspx/RemoveImagePickup",
                contentType: "application/json; charset=utf-8",
                data: "{ BookingId: '" + BookingId + "'}",
                dataType: "json",
                success: function ( result )
                {

                    $( "#myTable >tbody >tr" ).each( function ()
                    {
                        
                        var InnerLoopCount = 0;
                        InnerLoopCount = $('#apnd_div' + OuterLoopCount).find('.mlty_ple_upload').length;
                        //alert('OuterLoopCount= ' + OuterLoopCount + ' InnerLoopCount= ' + InnerLoopCount);
                        //New Lines Added
                        //===========================
                        var CustomerId = $( "#<%=hfCustomerId.ClientID%>" ).val().trim();
                        var PickupCategory = $( this ).find( 'select:eq(0)' ).find( "option:selected" ).text().trim();
                        var PickupItem = $( this ).find( 'select:eq(1)' ).find( "option:selected" ).text().trim();

                        var PickupCategoryId = parseInt($( this ).find( 'select:eq(0)' ).find( "option:selected" ).val().trim());
                        var PickupItemId = parseInt($( this ).find( 'select:eq(1)' ).find( "option:selected" ).val().trim());
                        
                        for (var i = 0; i < InnerLoopCount; i++) {

                            var files = $('#FileUpload' + OuterLoopCount + i)[0].files;
                            
                            if (files.length > 0) {

                                var ImageName = BookingId + '-' + files[0].name;;
                                //var ImageUrl = 'https://firebasestorage.googleapis.com/v0/b/jobycoimages.appspot.com/o/images%2F' + BookingId + '-' + files[0].name + '?alt=media';
                                var ImageUrl = 'https://firebasestorage.googleapis.com/v0/b/jobycodirect.appspot.com/o/images%2F' + BookingId + '-' + files[0].name + '?alt=media';
                                

                                //Save in the Customer Portal
                                //New Code for Image Insert
                                //==========================================
                                objIP = {};
                                objIP.ImagePickupId = "";
                                objIP.BookingId = BookingId;
                                objIP.CustomerId = CustomerId;
                                objIP.PickupCategory = PickupCategory;
                                objIP.PickupItem = PickupItem;
                                objIP.ImageName = ImageName;
                                objIP.ImageUrl = ImageUrl;
                                //alert(JSON.stringify(objIP));

                                $.ajax({
                                    type: "POST",
                                    url: "LoggedQuote.aspx/AddImagePickup",
                                    contentType: "application/json; charset=utf-8",
                                    data: JSON.stringify(objIP),
                                    dataType: "json",
                                    async: false,
                                    success: function (result) {
                                        //alert('AddImagePickup success');

                                        var file = files[0];
                                        var storage = firebase.storage();
                                        var storageRef = firebase.storage().ref('images');
                                        var thisRef = storageRef.child(ImageName);
                                        thisRef.put(file).then(function (snapshot1) {
                                            //alert('Upload success');
                                        });

                                    },
                                    error: function (response) {
                                        alert('Error on AddImagePickup');
                                    }
                                });//end of ImagePickup Entry

                                }//end of files length

                            }//end of For
    
                        OuterLoopCount++;
              });//end of myTable each

                },
                error: function ( response )
                {

                }
            });//end of Removing Existing Images
            }
    </script>
    <!-- The core Firebase JS SDK is always required and must be listed first -->
    <script src="https://www.gstatic.com/firebasejs/6.6.1/firebase.js"></script>

<script>
  // Your web app's Firebase configuration
  //var firebaseConfig = {
  //  apiKey: "AIzaSyDIVr61f9nleAhqJhFGMZpHZW9LpwAmaNk",
  //  authDomain: "jobycoimages.firebaseapp.com",
  //  databaseURL: "https://jobycoimages.firebaseio.com",
  //  projectId: "jobycoimages",
  //  storageBucket: "jobycoimages.appspot.com",
  //  messagingSenderId: "99926466301",
  //  appId: "1:99926466301:web:3f2823c97ced3d3839e894"
    //};
    var firebaseConfig = {
        apiKey: "AIzaSyA54QLnBT-Qem_nEY52-FuDHwPjxR7pn-E",
        authDomain: "jobycodirect.firebaseapp.com",
        databaseURL: "https://jobycodirect.firebaseio.com",
        projectId: "jobycodirect",
        storageBucket: "jobycodirect.appspot.com",
        messagingSenderId: "731181140810",
        appId: "1:731181140810:web:f3df80f48d12b893bc0fb3",
        measurementId: "G-YW1GZQEXKC"
    };

  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
</script>
    <script>
        function checkCollectionDetails() {
            var CollectionName = $("#<%=txtCollectionName.ClientID%>");
            var vCollectionName = CollectionName.val().trim();

            var lblCollectionName = $("#<%=lblCollectionName.ClientID%>");
            lblCollectionName.text(vCollectionName);

            var vPickupCustomerTitle = $("#PickupCustomerTitle").find('option:selected').text().trim();
            $("#PCustomerTitle").text(vPickupCustomerTitle);

            var CollectionAddressLine1 = $("#<%=txtCollectionAddressLine1.ClientID%>");
            var vCollectionAddressLine1 = CollectionAddressLine1.val().trim();

            var lblCollectionAddressLine1 = $("#<%=lblCollectionAddressLine1.ClientID%>");
            lblCollectionAddressLine1.text(vCollectionAddressLine1);

            var CollectionPostCode = $("#<%=txtCollectionPostCode.ClientID%>");
            var vCollectionPostCode = CollectionPostCode.val().trim();

            var lblCollectionPostCode = $("#<%=lblCollectionPostCode.ClientID%>");
            lblCollectionPostCode.text(vCollectionPostCode);

            var CollectionMobile = $("#<%=txtCollectionMobile.ClientID%>");
            var vCollectionMobile = CollectionMobile.val().trim();

            var lblCollectionMobile = $("#<%=lblCollectionMobile.ClientID%>");
            lblCollectionMobile.text(vCollectionMobile);

            var AltCollectionMobile = $( "#<%=txtAltCollectionMobile.ClientID%>" );
            $("#<%=lblAltCollectionMobile.ClientID%>").text(AltCollectionMobile.val().trim());

            var PickupEmailAddress = $("#<%=txtPickupEmailAddress.ClientID%>");
            var vPickupEmailAddress = PickupEmailAddress.val().trim();

            var vErrMsg = $("#<%=lblErrMsg2.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            showCollectionMandatoryFields();

            if (vCollectionName == "") {
                vErrMsg.text('Enter Your Name in Pickup Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionName.focus();
                return false;
            }

            if (vCollectionAddressLine1 == "") {
                vErrMsg.text('Enter Your Address in Pickup Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionAddressLine1.focus();
                return false;
            }

            if (vCollectionPostCode == "") {
                vErrMsg.text('Enter Post Code in Pickup Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionPostCode.focus();
                return false;
            }

            //if (vCollectionTown == "") {
            //vErrMsg.text('Enter Your Town in User Details');
            //vErrMsg.css("display", "block");
            //vErrMsg.show(1000).delay(1000).fadeOut(1000);
            //CollectionTown.focus();
            //return false;
            //}

            //if (vCollectionCountry == "Select Country") {
            //vErrMsg.text('Please select a Country in User Details');
            //vErrMsg.css("display", "block");
            //vErrMsg.show(1000).delay(1000).fadeOut(1000);
            //CollectionCountry.focus();
            //return false;
            //}

            if (vCollectionMobile == "") {
                vErrMsg.text('Enter Your Mobile in Pickup Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionMobile.focus();
                return false;
            }

            if (vCollectionMobile.length < 10) {
                vErrMsg.text('Invalid Mobile No in Pickup Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionMobile.focus();
                return false;
            }

            if (vPickupEmailAddress == "") {
                vErrMsg.text('Pickup email address is mandatory');
                vErrMsg.css("display", "block");
                PickupEmailAddress.focus();
                return false;
            }

            if (vPickupEmailAddress != "") {
                if (!IsEmail(vPickupEmailAddress)) {
                    vErrMsg.text('Invalid Email Address in Pickup Details');
                    vErrMsg.css("display", "block");
                    //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                    PickupEmailAddress.focus();
                    return false;
                }
            }

            return true;
        }

        function checkDeliveryDetails() {
            var DeliveryName = $("#<%=txtDeliveryName.ClientID%>");
            var vDeliveryName = DeliveryName.val().trim();

            var lblDeliveryName = $("#<%=lblDeliveryName.ClientID%>");
            lblDeliveryName.text(vDeliveryName);

            var vDeliveryCustomerTitle = $("#DeliveryCustomerTitle").find('option:selected').text().trim();
            $("#DCustomerTitle").text(vDeliveryCustomerTitle);

            var DeliveryAddressLine1 = $("#<%=txtDeliveryAddressLine1.ClientID%>");
            var vDeliveryAddressLine1 = DeliveryAddressLine1.val().trim();

            var lblDeliveryAddressLine1 = $("#<%=lblDeliveryAddressLine1.ClientID%>");
            lblDeliveryAddressLine1.text(vDeliveryAddressLine1);

            var DeliveryPostCode = $("#<%=txtDeliveryPostCode.ClientID%>");
            var vDeliveryPostCode = DeliveryPostCode.val().trim();

            var lblDeliveryPostCode = $("#<%=lblDeliveryPostCode.ClientID%>");
            lblDeliveryPostCode.text(vDeliveryPostCode);

            var DeliveryMobile = $("#<%=txtDeliveryMobile.ClientID%>");
            var vDeliveryMobile = DeliveryMobile.val().trim();

            var lblDeliveryMobile = $("#<%=lblDeliveryMobile.ClientID%>");
            lblDeliveryMobile.text(vDeliveryMobile);

            var AltDeliveryMobile = $("#<%=txtAltDeliveryMobile.ClientID%>");
            $("#<%=lblAltDeliveryMobile.ClientID%>").text(AltDeliveryMobile.val().trim());

            var DeliveryEmailAddress = $("#<%=txtDeliveryEmailAddress.ClientID%>");
            var vDeliveryEmailAddress = DeliveryEmailAddress.val().trim();

            var vErrMsg = $("#<%=lblErrMsg2.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            hideCollectionMandatoryFields();
            showDeliveryMandatoryFields();

            if (vDeliveryName == "") {
                vErrMsg.text('Enter Your Name in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryName.focus();
                return false;
            }

            if (vDeliveryAddressLine1 == "") {
                vErrMsg.text('Enter Your Address in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryAddressLine1.focus();
                return false;
            }

            //if (vDeliveryPostCode == "") {
            //    vErrMsg.text('Enter Other Address in Recipient Details');
            //    vErrMsg.css("display", "block");
            //    //vErrMsg.show(1000).delay(1000).fadeOut(1000);
            //    DeliveryPostCode.focus();
            //    return false;
            //}

            //if (vDeliveryTown == "") {
            //vErrMsg.text('Enter Your Town in Recipient Details');
            //vErrMsg.css("display", "block");
            //vErrMsg.show(1000).delay(1000).fadeOut(1000);
            //DeliveryTown.focus();
            //return false;
            //}

            //if (vDeliveryCountry == "Select Country") {
            //vErrMsg.text('Please select a Country in Recipient Details');
            //vErrMsg.css("display", "block");
            //vErrMsg.show(1000).delay(1000).fadeOut(1000);
            //DeliveryCountry.focus();
            //return false;
            //}

            if (vDeliveryMobile == "") {
                vErrMsg.text('Enter Your Mobile in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryMobile.focus();
                return false;
            }

            if (vDeliveryMobile.length < 10) {
                vErrMsg.text('Invalid Mobile No in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryMobile.focus();
                return false;
            }

            if (vDeliveryEmailAddress != "") {
                if (!IsEmail(vDeliveryEmailAddress)) {
                    vErrMsg.text('Invalid Email Address in Recipient Details');
                    vErrMsg.css("display", "block");
                    //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                    DeliveryEmailAddress.focus();
                    return false;
                }
            }

            return true;
        }

        //function checkAllDetails() {
        //    if (checkCollectionDetails()) {
        //        if (checkDeliveryDetails()) {
        //            $("#dvStep2").hide(500);
        //            $("#dvStep3").show(500);

        //            $("#progressbar li").eq(2).addClass("active");

        //            transferMyTableDataToConfirmItems();
        //        }
        //    }

        //    return false;
        //}

        function checkAllDetails()
        {
            var vErrMsg = $("#<%=lblErrMsg2.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            var Address1 = $( "#<%=txtCollectionAddressLine1.ClientID%>" ).val().trim();

            var geocoder = new google.maps.Geocoder();
            var address = Address1;

            geocoder.geocode({ 'address': address }, function (results, status) {

                if (status == google.maps.GeocoderStatus.OK) {
                    
                    var latitude = results[0].geometry.location.latitude;
                    var longitude = results[0].geometry.location.longitude;
                    //2nd Block
                    var Address2 = $( "#<%=txtDeliveryAddressLine1.ClientID%>" ).val().trim();
                                var geocoder = new google.maps.Geocoder();
                                var address = Address2;

                                geocoder.geocode({ 'address': address }, function (results, status) {

                                    if (status == google.maps.GeocoderStatus.OK) {
                                        
                                        var latitude = results[0].geometry.location.latitude;
                                        var longitude = results[0].geometry.location.longitude;
                                        //alert(latitude);
                                        
                                        if (checkCollectionDetails()) {
                                            if (checkDeliveryDetails()) {
                                                $("#dvStep2").hide(500);
                                                $("#dvStep3").show(500);

                                                $("#progressbar li").eq(2).addClass("active");

                                                transferMyTableDataToConfirmItems();
                                            }
                                        }


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

        function checkConfirmation() {
            //var ConfirmEmailAddress = $("#<%=txtConfirmEmailAddress.ClientID%>");
            var ConfirmEmailAddress = $("#<%=txtPickupEmailAddress.ClientID%>");
            var vConfirmEmailAddress = ConfirmEmailAddress.val().trim();

            var chkConfirm = $("#<%=chkConfirm.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg3.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            showStep3MandatoryFields();

            if (vConfirmEmailAddress == "") {
                vErrMsg.text('Please confirm Your Email Address');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                ConfirmEmailAddress.focus();
                return false;
            }

            if (!IsEmail(vConfirmEmailAddress)) {
                vErrMsg.text('Invalid Email Address to Confirm');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                ConfirmEmailAddress.focus();
                return false;
            }

            if (!chkConfirm.is(":checked")) {
                vErrMsg.text("Please confirm the above details are correct");
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                chkConfirm.focus();
                return false;
            }

            return true;
        }

        function cancelBooking() {
            setTimeout(function () {
                location.href = '/Dashboard.aspx';
            }, 1000);
        }

        function sendEmailAfterConfirmation() {
            if (checkConfirmation()) {
                placeOrder();
            }

            return false;
        }
    </script>

    <script>
        function getDeliveryDateDetails() {
            var CurrentDate = new Date();
            CurrentDate.setDate(CurrentDate.getDate() + 7);

            var DeliveryDate = CurrentDate;
            var DeliveryDay = DeliveryDate.getDate().toString();
            var DeliveryMonth = (DeliveryDate.getMonth() + 1).toString();
            var DeliveryFullYear = DeliveryDate.getFullYear().toString();

            return DeliveryDay + "-" + DeliveryMonth + "-" + DeliveryFullYear;
        }

        function saveBooking() {
            var vErrMsg = $("#<%=lblErrMsg3.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");
            //alert('Booking Started!!');
            getCustomerId();
            getBookingId();
            uploadImageFile();
            //Saving Customer Details First
            var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
            var EmailID = $("#<%=txtConfirmEmailAddress.ClientID%>").val().trim();
            //var EmailID = $("#<%=txtPickupEmailAddress.ClientID%>").val().trim();
            var Password = "";

            var FullName = $("#<%=txtCollectionName.ClientID%>").val().trim();
            var Title = "";
            var FirstName = "";
            var LastName = "";

            var vPickupCustomerTitle = $("#PickupCustomerTitle").find('option:selected').text().trim();
            Title = vPickupCustomerTitle;

            var vDeliveryCustomerTitle = $("#DeliveryCustomerTitle").find('option:selected').text().trim();

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
            }
            else {
                LastName = FullName;
            }

            var DOB = getCurrentDateDetails();
            var Address = $("#<%=txtCollectionAddressLine1.ClientID%>").val().trim();
            var Town = "";
            var Country = "";
            var PostCode = $("#<%=txtCollectionPostCode.ClientID%>").val().trim();
            var Mobile = $("#<%=txtCollectionMobile.ClientID%>").val().trim();
            var Telephone = Mobile;
            var HearAboutUs = "";

            //Having Registered Company
            var HavingRegisteredCompany =
                $("#<%=ddlRegisteredCompany.ClientID%>").find("option:selected").text().trim();

            if (HavingRegisteredCompany == "Yes")
                HavingRegisteredCompany = "true";
            else
                HavingRegisteredCompany = "false";

            var Locked = "false";

            //Shipping the Goods in the name of Company
            var ShippingGoodsInCompanyName =
                $("#<%=ddlGoodsInName.ClientID%>").find("option:selected").text().trim();

            if (ShippingGoodsInCompanyName == "Yes")
                ShippingGoodsInCompanyName = "true";
            else
                ShippingGoodsInCompanyName = "false";

            //Adding RegisteredCompanyName
            var RegisteredCompanyName = $("#<%=txtCompanyName.ClientID%>").val().trim();


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

            //var timeDuration = 2000;

            $.ajax({
                type: "POST",
                url: "LoggedQuote.aspx/AddCustomer",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objCustomer),
                dataType: "json",
                async:false,
                success: function (result) {
                    //Saving Booking Details next
                    var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();
                    var PickupCategory =
                        $("#ddlPickupCategory").find("option:selected").text().trim();
                    var PickupDateTime = $("#<%=txtCollectionDate.ClientID%>").val().trim();

                    //Pickup Full Address Details
                    var PickupAddress = $("#<%=txtCollectionAddressLine1.ClientID%>").val().trim();

                    //IsFragile value selection
                    var IsFragile = "false";
                    if ($("#roundedTwo").is(":checked")) {
                        IsFragile = "true";
                    }
                    else {
                        IsFragile = "false";
                    }

                    var EstimatedValue = $("#txtEstimatedValue").val().trim();
                    if (EstimatedValue == "") {
                        EstimatedValue = "0.00";
                    }

                    //New Field Added for BookPickup
                    //=====================================
                    var PredefinedEstimatedValue = $("#txtPredefinedEstimatedValue").val().trim();
                    if (PredefinedEstimatedValue == "") {
                        PredefinedEstimatedValue = "0.00";
                    }
                    //=====================================

                    //Counting the No of Items and Calculating the Total Estimated Value
                    var ctrBP = 0;
                    var sEstimatedValue = "";
                    var fEstimatedValue = 0.0;
                    var fTotalValue = 0.0;

                    $('#tblBookPickup tbody > tr').each(function () {
                        ctrBP++;
                        sEstimatedValue = $(this).find('td:eq(3)').text().trim();
                        fEstimatedValue = parseFloat(sEstimatedValue);
                        if (!isNaN(fEstimatedValue)) {
                            fTotalValue += fEstimatedValue;
                        }
                    });

                    var ItemCount = $("#<%=spItemCount.ClientID%>").text();
                    var TotalValue = $("#<%=spTotal.ClientID%>").text();

                    var DeliveryCategory = PickupCategory;
                    var DeliveryDateTime = getDeliveryDateDetails();

                    //Recipient Full Address Details
                    var RecipientAddress = $("#<%=txtDeliveryAddressLine1.ClientID%>").val().trim();

                    //Delivery Calculation Details
                    var iDeliveryQuantity = ctrBP;
                    var fDeliveryCharge = 3.0;
                    var fTotalCharge = fDeliveryCharge * iDeliveryQuantity;

                    var DeliveryQuantity = ItemCount;
                    var DeliveryCharge = fDeliveryCharge.toFixed(2).toString();
                    var TotalCharge = fTotalCharge.toFixed(2).toString();

                    var BookingNotes = FullName + "'s Goods";
                    var OrderStatus = "Unpaid";

                    var PickupItem =
                        $("#ddlPickupItem").find("option:selected").text().trim();

                    //New Code Added
                    //===================
                    if (PickupItem == "Pickup Item") {
                        PickupItem = "";
                    }

                    var TextPickupItem = $("#txtPickupItem").val().trim();

                    if (TextPickupItem != "") {
                        if (PickupItem == "") {
                            PickupItem = TextPickupItem;
                        }
                    }
                    //===================

                    var fVAT = 0.0;
                    var VAT = "0.00";

                    if (HavingRegisteredCompany == "true") {
                        if (ShippingGoodsInCompanyName == "true") {
                            //fTotalValue = parseFloat(TotalValue);
                            //fVAT = ( fTotalValue * 20 ) / 100;
                            //VAT = fVAT.toFixed(2).toString();
                            VAT = $("#<%=hfVAT.ClientID%>").val().trim();
                        }
                    }

                    //New Code Added for Insurance Premium
                    //====================================
                    var fInsurancePremium = 0.0;
                    var InsurancePremium = "0.00";

                    var vInsurancePremium = $("#<%=txtInsurancePremium.ClientID%>").val().trim();

                    if (vInsurancePremium != "") {
                        InsurancePremium = vInsurancePremium;
                    }
                    //====================================



                    //New Charges data Save
                    $('#tblTaxDetailsConfirmation tbody tr').each(function (i, row) {
                        ChargesId = $(this).find('td:eq(0)').text().trim();
                        ChargesName = $(this).find('td:eq(1)').text().trim();
                        ChargedAmount = $(this).find('td:eq(2)').text().trim();

                        objCharges = {};
                        objCharges.ChargesId = ChargesId;
                        objCharges.ChargesName = ChargesName;
                        objCharges.ChargedAmount = ChargedAmount;
                        objCharges.BookingId = BookingId;
                        //alert(JSON.stringify(objCharges));
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "LoggedQuote.aspx/AddCharges",
                            data: JSON.stringify(objCharges),
                            dataType: "json",
                            async: false,
                            success: function (result) {

                            },
                            error: function (response) {

                            }
                        });//end of Quote Entry
                    });

                    //New Code Added for few more Pickup and Delivery Fields
                    //======================================================
                    var PickupName = $("#<%=txtCollectionName.ClientID%>").val().trim();
                    var PickupMobile = $("#<%=txtCollectionMobile.ClientID%>").val().trim();
                    var AltPickupMobile = $("#<%=txtAltCollectionMobile.ClientID%>").val().trim();

                    var DeliveryName = $("#<%=txtDeliveryName.ClientID%>").val().trim();
                    var DeliveryMobile = $("#<%=txtDeliveryMobile.ClientID%>").val().trim();
                    var AltDeliveryMobile = $("#<%=txtAltDeliveryMobile.ClientID%>").val().trim();

                    var PickupPostCode = $("#<%=txtCollectionPostCode.ClientID%>").val().trim();
                    var DeliveryPostCode = $("#<%=txtDeliveryPostCode.ClientID%>").val().trim();

                    var LatitudePickup = $("#<%=hfPickupLatitude.ClientID%>").val().trim();
                    var LongitudePickup = $("#<%=hfPickupLongitude.ClientID%>").val().trim();

                    var LatitudeDelivery = $("#<%=hfDeliveryLatitude.ClientID%>").val().trim();
                    var LongitudeDelivery = $("#<%=hfDeliveryLongitude.ClientID%>").val().trim();
                    //======================================================
                    var Bookingdate = getCurrentDateDetails();

                    //A Couple of New Fields Added
                    //=========================================================================
                    var PickupEmail = $('#<%=txtPickupEmailAddress.ClientID%>').val().trim();
                    var DeliveryEmail = $('#<%=txtDeliveryEmailAddress.ClientID%>').val().trim();
                    //=========================================================================

                    var IsAssigned = 'false';

                    //Checking must be done for PickupCategory "Other" and its Price
                    //==================================================================
                    var WhetherOtherExists = false;

                    $('#tblConfirmItems tbody > tr').each(function () {
                        PickupCategory = $(this).find('td:eq(0)').text().trim();
                        PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();

                        if (PickupCategory == "Other") {
                            if (PredefinedEstimatedValue == "0.00") {
                                WhetherOtherExists = true;
                            }
                        }
                    });
                    //==================================================================

                    var ConfirmStatusDetails = $('#StatusDetails').val().trim();

                    //Binding Booking Details to object
                    var objBooking = {};
                    objBooking.BookingId = BookingId;
                    objBooking.CustomerId = CustomerId;

                    objBooking.PickupCategory = PickupCategory;
                    objBooking.PickupDateTime = PickupDateTime;
                    objBooking.PickupAddress = PickupAddress;

                    objBooking.Width = "0";
                    objBooking.Height = "0";
                    objBooking.Length = "0";

                    objBooking.IsFragile = IsFragile;
                    objBooking.EstimatedValue = EstimatedValue;

                    objBooking.ItemCount = ItemCount;
                    objBooking.TotalValue = TotalValue;

                    objBooking.DeliveryCategory = DeliveryCategory;
                    objBooking.DeliveryDateTime = DeliveryDateTime;
                    objBooking.RecipientAddress = RecipientAddress;

                    objBooking.DeliveryQuantity = DeliveryQuantity;
                    objBooking.DeliveryCharge = DeliveryCharge;
                    objBooking.TotalCharge = TotalCharge;

                    objBooking.BookingNotes = BookingNotes;
                    objBooking.OrderStatus = OrderStatus;
                    objBooking.PickupItem = PickupItem;
                    objBooking.VAT = VAT;
                    objBooking.InsurancePremium = InsurancePremium;

                    //New Object Property Added for few more Pickup and Delivery Fields
                    //======================================================
                    objBooking.PickupName = PickupName;
                    objBooking.PickupMobile = PickupMobile;
                    objBooking.AltPickupMobile = AltPickupMobile;

                    objBooking.DeliveryName = DeliveryName;
                    objBooking.DeliveryMobile = DeliveryMobile;
                    objBooking.AltDeliveryMobile = AltDeliveryMobile;

                    objBooking.PickupPostCode = PickupPostCode;
                    objBooking.DeliveryPostCode = DeliveryPostCode;

                    objBooking.LatitudePickup = LatitudePickup;
                    objBooking.LongitudePickup = LongitudePickup;

                    objBooking.LatitudeDelivery = LatitudeDelivery;
                    objBooking.LongitudeDelivery = LongitudeDelivery;

                    //======================================================
                    objBooking.Bookingdate = Bookingdate;

                    //A Couple of New Fields Added
                    //=========================================================================
                    objBooking.PickupEmail = PickupEmail;
                    objBooking.DeliveryEmail = DeliveryEmail;
                    //=========================================================================

                    objBooking.IsAssigned = IsAssigned;
                    objBooking.WhetherOtherExists = WhetherOtherExists;
                    objBooking.StatusDetails = ConfirmStatusDetails;
                    objBooking.PickupCustomerTitle = vPickupCustomerTitle;
                    objBooking.DeliveryCustomerTitle = vDeliveryCustomerTitle;

                    $.ajax({
                        type: "POST",
                        url: "LoggedQuote.aspx/AddBookingOperation",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(objBooking),
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            //timeDuration = 4000;
                            var BookPickupDetails = "";

                            //Finally saving BookPickup Data
                            $('#tblConfirmItems tbody > tr').each(function () {
                                PickupCategory = $(this).find('td:eq(0)').text().trim();
                                PickupItem = $(this).find('td:eq(1)').text().trim();
                                IsFragile = $(this).find('td:eq(2)').text().trim();

                                if (IsFragile == 'Yes') IsFragile = "True";
                                if (IsFragile == 'No') IsFragile = "False";

                                EstimatedValue = $(this).find('td:eq(3)').text().trim();
                                //===============================================
                                PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();
                                //===============================================

                                BookPickupDetails = "";
                                //BookPickupDetails += "<h2>Pickup Details</h2>";
                                BookPickupDetails += "<b>Pickup Category: </b>" + PickupCategory + "<br/>";
                                BookPickupDetails += "<b>Pickup Item: </b>" + PickupItem + "<br/>";
                                BookPickupDetails += "<b>Fragile: </b>" + IsFragile + "<br/>";
                                BookPickupDetails += "<b>Estimated Value: </b>" + EstimatedValue + "<br/>";
                                //===============================================
                                BookPickupDetails += "<b>Predefined Estimated Value: </b>" + PredefinedEstimatedValue + "<br/>";
                                //===============================================
                                
                                objBP = {};
                                objBP.PickupId = "";
                                objBP.BookingId = BookingId;
                                objBP.CustomerId = CustomerId;
                                objBP.PickupCategory = PickupCategory;
                                objBP.PickupItem = PickupItem;
                                objBP.IsFragile = IsFragile;
                                objBP.EstimatedValue = EstimatedValue;
                                //===============================================
                                objBP.PredefinedEstimatedValue = PredefinedEstimatedValue;
                                //===============================================

                                $.ajax({
                                    type: "POST",
                                    url: "LoggedQuote.aspx/AddBookPickup",
                                    contentType: "application/json; charset=utf-8",
                                    data: JSON.stringify(objBP),
                                    dataType: "json",
                                    async: false,
                                    success: function (result) {

                                    },
                                    error: function (response) {

                                    }
                                });//end of BookPickup Entry
                            });
                        },
                        error: function (response) {

                        }
                    });//end of OrderBooking Entry
                },
                error: function (response) {

                }
            });

            return false;
        }

        function proceedToPayment() {
            
            saveBooking();
                var EmailID = $("#<%=txtPickupEmailAddress.ClientID%>").val().trim();

                var jQueryDataTableContent = "<table border=1>";
                jQueryDataTableContent += "<tr>";
                jQueryDataTableContent += "<th>Pickup Category</th>";
                jQueryDataTableContent += "<th>Pickup Item</th>";
                jQueryDataTableContent += "<th>Fragile</th>";
                jQueryDataTableContent += "<th>Estimated Value</th>";
                jQueryDataTableContent += "<th>Price</th>";
                jQueryDataTableContent += "</tr>";

                var vTableRow = "";

                $('#tblConfirmItems tbody > tr').each(function () {
                    var PickupCategory = $(this).find('td:eq(0)').text().trim();
                    var PickupItem = $(this).find('td:eq(1)').text().trim();
                    var IsFragile = $(this).find('td:eq(2)').text().trim();
                    var EstimatedValue = $(this).find('td:eq(3)').text().trim();
                    var PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();

                    vTableRow += "<tr>"
                    vTableRow += "<td>" + PickupCategory + "</td>";
                    vTableRow += "<td>" + PickupItem + "</td>";
                    vTableRow += "<td>" + IsFragile + "</td>";
                    vTableRow += "<td>" + EstimatedValue + "</td>";
                    vTableRow += "<td>" + PredefinedEstimatedValue + "</td>";
                    vTableRow += "</tr>";

                });

                jQueryDataTableContent += vTableRow;
                jQueryDataTableContent += "</table>";

                //New Code Added here
                jQueryDataTableContent += "<br /><br />";
                jQueryDataTableContent += "<strong>Total : </strong>£";
                //jQueryDataTableContent += "<i class=\'note-disclaimer\'><i>: £";
                jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                //Booking Mail
                sendBookingByEmail(EmailID, jQueryDataTableContent);

                var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();
                        //setTimeout(function () {
                        //    location.href = '/ProceedToPayment.aspx?BookingId=' + BookingId;
                        //}, 3000);
                //var TotaltaxValue = $('#TotaltaxValue').val().trim();
                //alert('TotaltaxValue=' + TotaltaxValue);
                    var objBP = {};
                    objBP.BookingId = BookingId;
                    objBP.Total = $("#<%=spTotal.ClientID%>").text().trim();
                    objBP.EmailID = EmailID;
                    //alert(JSON.stringify(objBP));
                    $.ajax({
                        type: "POST",
                        url: "LoggedQuote.aspx/PaymentProceed",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(objBP),
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            window.location = result.d;
                        },
                        error: function (response) {

                        }
                    });//end of BookPickup Entry
            }

        function goHome() {
            saveBooking();
                //var EmailID = $("#<%=txtConfirmEmailAddress.ClientID%>").val().trim();
              var EmailID = $("#<%=txtPickupEmailAddress.ClientID%>").val().trim();

              var jQueryDataTableContent = "<table border=1>";
              jQueryDataTableContent += "<tr>";
              jQueryDataTableContent += "<th>Pickup Category</th>";
              jQueryDataTableContent += "<th>Pickup Item</th>";
              jQueryDataTableContent += "<th>Fragile</th>";
              jQueryDataTableContent += "<th>Estimated Value</th>";
              jQueryDataTableContent += "<th>Price</th>";
              jQueryDataTableContent += "</tr>";

              var vTableRow = "";

              $('#tblConfirmItems tbody > tr').each(function () {
                  var PickupCategory = $(this).find('td:eq(0)').text().trim();
                  var PickupItem = $(this).find('td:eq(1)').text().trim();
                  var IsFragile = $(this).find('td:eq(2)').text().trim();
                  var EstimatedValue = $(this).find('td:eq(3)').text().trim();
                  var PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();

                  vTableRow += "<tr>"
                  vTableRow += "<td>" + PickupCategory + "</td>";
                  vTableRow += "<td>" + PickupItem + "</td>";
                  vTableRow += "<td>" + IsFragile + "</td>";
                  vTableRow += "<td>" + EstimatedValue + "</td>";
                  vTableRow += "<td>" + PredefinedEstimatedValue + "</td>";
                  vTableRow += "</tr>";

              });

              jQueryDataTableContent += vTableRow;
              jQueryDataTableContent += "</table>";

              //New Code Added here
              jQueryDataTableContent += "<br /><br />";
              jQueryDataTableContent += "<strong>Total : </strong>£";
              //jQueryDataTableContent += "<i class=\'note-disclaimer\'><i>: £";
              jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                sendPayLaterEmail(EmailID, jQueryDataTableContent);
              //sendPayLaterEmail("eniinfo4@gmail.com", jQueryDataTableContent);

              //setTimeout(function () {
              //    location.href = '/Dashboard.aspx';
              //}, 3000);
            }

            function placeOrder() {
                
                setTimeout(function () { }, 3000);

                //New Code Added for Pay at @ Collection
                //===========================================================================
                $('#lblCollectionAddress').text($('#<%=txtCollectionAddressLine1.ClientID%>').val().trim());
            //===========================================================================

            $('#payment-bx').modal('show');

            return false;
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-md-12">
        <div class="row">
            <!-- MultiStep Form -->
            <div class="col-md-11 ms_frm">
                <form id="msform" runat="server">
                    <ul id="progressbar">
                        <li class="active">Parcel Details</li>
                        <li>Address Details</li>
                        <li>Order Summary</li>
                    </ul>

                    <fieldset class="next-mov" id="dvStep1">
                        <h2 class="fs-title">My Package Details</h2>
                        <div class="row">
                            <div class="col-sm-6">
                                <label for="existing-address" class="control-label">Select Existing Address</label>
                                <asp:DropDownList ID="ddlCustomerAddress" runat="server"
                                    CssClass="vat-option"
                                    onchange="return onChangeAddressValue();">
                                    <asp:ListItem Selected="True">Please Select Address</asp:ListItem>
                                </asp:DropDownList>
                                Notes : Please fill your new address in the next page. 
Your new address will be saved for your future reference. Alternatively please select address from above dropdown.
                            </div>
                            <div class="col-sm-6">
                                <div id="CollectionMapStep1"></div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-6">
                                <label for="registered-company" class="control-label">Do you have a registered company in UK?</label>
                                <asp:DropDownList ID="ddlRegisteredCompany" runat="server"
                                    CssClass="vat-option"
                                    onchange="return checkDropDownValue();">
                                    <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>

                                <div id="dvGoodsInName" style="display: none;" runat="server">
                                    <label for="goods-in-name" class="control-label">If Yes, please mention the name of the company</label>
                                    <asp:TextBox ID="txtCompanyName" runat="server" MaxLength="100"
                                        CssClass="form-control" PlaceHolder="e.g. XYZ LTD" title="Please enter Company Name"
                                        onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>

                                    <label for="goods-in-name" class="control-label">If Yes, are you shipping the goods in the name of the company?</label>
                                    <asp:DropDownList ID="ddlGoodsInName" runat="server"
                                        CssClass="vat-option" onchange="clearErrorMessage();getMyTableTotal();">
                                        <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="registered-company" class="control-label">Have you got insurance?</label>
                                <asp:DropDownList ID="ddlInsurance" runat="server"
                                    CssClass="vat-option"
                                    onchange="checkInsuranceValue();getMyTableTotal();">
                                    <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                    <asp:ListItem Value="2">I am not interested</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-sm-6" id="dvInsurancePremium" style="display: none;" runat="server">

                                <label for="insurance-premium" class="control-label">If No, please pay the Insurance Premium</label>
                                <asp:TextBox ID="txtInsurancePremium" runat="server" MaxLength="100"
                                    CssClass="form-control" PlaceHolder="e.g. £10.00" title="Please pay the Insurance Premium"
                                    onkeypress="DecimalOnly(event);clearErrorMessage();"></asp:TextBox>

                            </div>
                            <%--<div class="col-sm-6">
                                        <label for="No-of-box" class="control-label">Have you got insurance?</label>
                                            <asp:DropDownList ID="ddlNoOfBox" runat="server"
                                                CssClass="vat-option"
                                                onchange="return OnNoOfBoxChange(this.value);">
                                                <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                                <asp:ListItem Value="0">0</asp:ListItem>
                                                <asp:ListItem Value="1">1</asp:ListItem>
                                                <asp:ListItem Value="2">2</asp:ListItem>
                                                <asp:ListItem Value="3">3</asp:ListItem>
                                                <asp:ListItem Value="4">4</asp:ListItem>
                                                <asp:ListItem Value="5">5</asp:ListItem>
                                                <asp:ListItem Value="6">6</asp:ListItem>
                                                <asp:ListItem Value="7">7</asp:ListItem>
                                                <asp:ListItem Value="8">8</asp:ListItem>
                                                <asp:ListItem Value="9">9</asp:ListItem>
                                                <asp:ListItem Value="10">10</asp:ListItem>
                                            </asp:DropDownList>
                                    </div>--%>
                        </div>
                        <div id="ItemSecContainer">
                        </div>

                        <div class="item_sec" id="dvBookPickup">
                            <div id="secBookPickup">
                                <table id="myTable" class="table order-list">
                                    <thead>
                                        <tr>
                                            <td colspan="5">
                                                <h3 class="fs-subtitle">Category</h3>
                                            </td>
                                            <td colspan="5">
                                                <h3 class="fs-subtitle">Item</h3>
                                            </td>
                                            <td colspan="5">
                                                <h3 class="fs-subtitle">Type</h3>
                                            </td>
                                            <td colspan="5">
                                                <h3 class="fs-subtitle">Estimated Value</h3>
                                            </td>
                                            <td colspan="5">
                                                <h3 class="fs-subtitle"><%--Predefined Value--%>Amount To Pay</h3>
                                            </td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="col-sm-3 col-xs-12">
                                                <select id="ddlPickupCategory" name="pickupCategory[]" class="itemcatPickup"
                                                    title=""
                                                    onchange="getPredefinedEstimatedValueByCategory();clearErrorMessage();hideQuestionBoxIfExists();">
                                                    <option value="">Pickup Category</option>
                                                </select>

                                            </td>
                                            <td class="col-sm-3 col-xs-12">
                                                <select id="ddlPickupItem" name="pickupItem[]" class="items"
                                                    title=""
                                                    onchange="getPredefinedEstimatedValueByItem();clearErrorMessage();">
                                                    <option value="">Pickup Item</option>
                                                </select>
                                                <input type="text" id="txtPickupItem" class="" style="display: none;"
                                                    title="Please enter value for 'Others' Category"
                                                    placeholder="Item description"
                                                    onkeypress="clearErrorMessage();" />
                                            </td>
                                            <td class="col-sm-1 col-xs-12">
                                                <section title=".roundedTwo">
                                                    <!-- .roundedTwo -->
                                                    <div class="roundedTwo">
                                                        <input type="checkbox" value="None" id="roundedTwo" name="check" />
                                                        <label for="roundedTwo"><span>FRAGILE?</span></label>
                                                    </div>
                                                    <!-- end .roundedTwo -->
                                                </section>
                                            </td>

                                            <td class="col-sm-2 col-xs-12">
                                                <label class="float_label">£</label>
                                                <input id="txtEstimatedValue" name="estimatedValue[]"
                                                    class="estimatevalue" placeholder="e.g. £123.45"
                                                    maxlength="10" title="" type="text" <%--onkeyup="blurEstimatedValue();"--%>
                                                    onkeypress="DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);" />

                                            </td>
                                            <td class="col-sm-2 col-xs-12">
                                                <label class="float_label">£</label>
                                                <input id="txtPredefinedEstimatedValue" name="predefinedestimatedValue[]"
                                                    class="estimatevalue" placeholder="e.g. £123.45" readonly="readonly"
                                                    title="Price" type="text" onkeyup="blurEstimatedValue();" onkeypress="DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);" />
                                            </td>

                                            <!--New td added for 'Other' information-->
                                            <!--====================================-->
                                            <td class="col-sm-2 col-xs-12">
                                                <button id="btnQuestion" class="question-mark" style="display: none;"
                                                    onclick="return showOtherInfo();">
                                                    <i class="fa fa-question-circle" aria-hidden="true"></i>
                                                </button>
                                            </td>
                                            <!--====================================-->

                                            <%--<td class="col-sm-1 col-xs-12">
                                                <label class="brwsBtn" for="upload1">
                                                    Upload an image (optional)
                                                          <input class="isVisuallyHidden" id="upload1" name="upload[]" type="file"
                                                              accept="image/*" onchange="loadFile(event, 'output1', 1)" onclick="resetloadFile(event, 'output1', 1);" multiple />
                                                </label>
                                            </td>--%>
                                            <td class="col-sm-1 col-xs-12">
                                                <label id="brwsBtn_tgle0" class="brwsBtn brwsBtn_tgle" onclick="return ToggleButton(0);">Upload an image <i class="fa fa-plus-circle" aria-hidden="true"></i></label>
                                            </td>

                                            <td class="last_mm col-sm-1 col-xs-12">
                                                <a class="btn-danger deleteRow btn-sm ibtnDel" onclick="resetloadFile(event, 'output1', 1);">
                                                    <span class="glyphicon glyphicon-minus remove"></span>
                                                </a>
                                            </td>

                                            <td id="upload_fileToggle0" class="mlty_ple_upload_file">
                                               <div class="mlty_ple_upload_main">
                                                    <div id="apnd_div0" class="apnd_div">
                                                  <div class="mlty_ple_upload">
                                                    <i class="fa fa-times-circle remove_images_single" onclick="return removeFileUploadRow(this, 0, 0);" aria-hidden="true"></i>
                                                           <div class="form-group">
                                                                <label class="add_img_file_aa"><i class="fa fa-upload" aria-hidden="true"></i>Upload File<input type="file" id="FileUpload00" size="60" onchange="return displayImage(event, 0, 0);" ></label> 
                                                           </div> 
                                                       <div class="file_viwer_sec">
                                                        <img id="ViewImage00" src="/images/no_image.jpg" />
                                                     </div>
                                                     <div class="apnd_mlty_ple">
                                                         <button type="button" class="btn add_more_img" style="visibility:hidden;"><i class="fa fa-plus-circle" aria-hidden="true"></i> Add More </button>
                                                     </div>
                                                   </div>
                                                  </div>
                                                    <div class="apnd_mlty_ple">
                                                         <button type="button" class="btn add_more_img" onclick="return AddImageUploadRow(0);"><i class="fa fa-plus-circle" aria-hidden="true"></i> Add More </button>
                                                     </div>
                                                   </div>
                                           </td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td style="height: 20px;"></td>
                                        </tr>
                                        <tr>
                                            <td class="col-sm-6 col-xs-12" style="width: 180px !important;">
                                                <button class="btn btn-success aa-add-row" type="button"
                                                    id="btnBookPickupAddRow" onclick="return addRowBookPickup();">
                                                    <span class="glyphicon glyphicon-plus add"
                                                        style="padding-right: 10px"></span>Add Row
                                                </button>
                                            </td>
                                            <td class="col-sm-6 col-xs-12" style="width: 180px !important;">
                                                <button class="btn btn-success aa-add-row" type="button"
                                                    id="btnBookPickupAddMultipleRow" onclick="return addMultipleRowBookPickup();">
                                                    <span class="glyphicon glyphicon-plus add"
                                                        style="padding-right: 10px"></span>Add Multiple Rows
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 20px;"></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100% !important;">
                                                <ul id="ulOutput" style="list-style: none;">
                                                    <%--<li style="display: none;">
                                                        <img id="output1" src="#" height="50" width="50" />
                                                        <button id="x" class="closeRoundButton" onclick="return closeNearestImage('x');">
                                                            <i class="fa fa-times" aria-hidden="true"></i>
                                                        </button>
                                                    </li>--%>
                                                </ul>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="col-sm-12 col-xs-12 table-responsive" style="padding: 0 !important;">
                                                <table class="table table-bordered" id="tblBookPickup" style="width: 100%; display: none;">
                                                    <thead class="jsTblH">
                                                        <tr>
                                                            <th>Pickup Category</th>
                                                            <th>Pickup Item</th>
                                                            <th>Fragile</th>
                                                            <th>Estimated Value</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="jsTable">
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                                <table class="tblInfo table vatTBL">
                                    <tr>
                                        <td>
                                            <div style="text-align: left; display: none;">
                                                <strong>VAT </strong>
                                                <i class="note-disclaimer"><i>: £
                                                        <span id="spVAT" runat="server">0.0</span></i></i>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="text-align: right; display: none;">
                                                <strong>Insurance Premium </strong>
                                                <i class="note-disclaimer"><i>: £
                                                        <span id="spInsurancePremium" runat="server">0.0</span></i></i>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <div style="text-align: left;">
                                                <strong>No of Items </strong>
                                                <i class="note-disclaimer"><i>:
                                                            <span id="spItemCount" runat="server">0</span></i></i>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="text-align: right; display: none;">
                                                <strong>Total </strong>
                                                <i class="note-disclaimer"><i>: £
                                                        <span id="spTotal" runat="server">0.0</span></i></i>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <%--tblTaxDetails--%>
                                <div class="taxDetails_container">
                                    <table id="tblTaxDetails" class="tbl_TaxDetails">
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                             <div class="col-md-6" style="padding:0px;"> 
                            <div class="control-group">
                                <div class="col-md-4">
                                    <label class="control-label" for="collection-date">Collection Date <span style="color: red">*</span>:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="input-group date" style="display:block;">
                                        <input id="txtCollectionDate" type="text" class="form-control" runat="server" readonly="true" />
                                      <%--  <span class="input-group-addon"><i class="glyphicon glyphicon-th"></i></span>--%>
                                    </div>
                                </div>
                            </div>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-6" style="padding:0px;">                   
                            <div class="control-group clearfix">
                                <div class="col-md-4">
                                    <label class="control-label" for="StatusDetails">Booking Notes <span style="color: red"></span>:</label>
                                </div>
                                <div class="col-md-8">
                                    <div class="input-group date" style="display:block;">
                                        <textarea id="StatusDetails" name="StatusDetails" rows="4" cols="100" placeholder="Enter Booking Notes" class="form-control" ></textarea>
                                    </div>                                                            
                                </div>
                            </div>
                            </div>
                        </div>

                        <!--<script src="/js/bootstrap-datetimepicker.js"></script>-->
                        <script src="/js/bootstrap-datepicker.js"></script>
                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>

                        <div class="row">
                            <div class="col-md-12 col-xs-12">
                                <asp:Label ID="lblErrMsg" CssClass="ErrMsg" BackColor="#f9edef"
                                    Style="text-align: center; vertical-align: middle; width: 500px; line-height: 30px; border-radius: 0px; padding: 0px;"
                                    runat="server" Text="" Font-Size="Small"></asp:Label>
                            </div>

                            <div class="col-md-12 col-xs-12">
                                <label class="control-label" for="conditions">
                                    I have read and agree to the <a href="/prohibited" target="_blank">Prohibited &amp; Restricted items list*</a>
                                    &nbsp;<asp:CheckBox ID="chkAgree" runat="server"
                                        onchange="clearErrorMessage();" CssClass="lastChk" />
                                </label>
                            </div>
                        </div>

                        <br />
                        <input type="button" name="next" class="next action-button" value="Next Step"
                            onclick="return checkMyPackageDetails();" />
                    </fieldset>
                    <!--end of first form-->

                    <fieldset class="next-mov" id="dvStep2">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="address-details">
                                    <h2>Pickup Details</h2>
                                    <div class="">
                                        <!--quote-box-->
                                        <div class="details">
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label" for="collection-title" style="width: 100%;">Name 
                                                            <span style="color: red">*</span>:
                                                           
                                                        </label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                         <select id="PickupCustomerTitle" class="slct_box_inline" style="margin: 0px 0 0 0;padding: 9px 4px;">
                                                                <option>Mr</option>
                                                                <option>Mrs</option>
                                                                <option>Miss</option>
                                                            </select>
                                                        <asp:TextBox ID="txtCollectionName" runat="server" TabIndex="1" MaxLength="50"
                                                            CssClass="form-control di_in_put" PlaceHolder="e.g. Tom" title=""
                                                            onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group address-field">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label" for="collection-address" data-label-prepend="Collection: ">Address <span style="color: red">*</span>:</label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                        <input type="text" id="txtCollectionAddressLine1" tabindex="2" class="form-control"
                                                            placeholder="Enter a Collection Location" title=""
                                                            onkeypress="clearErrorMessage();" runat="server" />
                                                        <div id="CollectionMap"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-sm-12 col-xs-12">
                                                        <div class="row">
                                                            <div class="col-md-4 col-xs-12">
                                                                <label class="control-label postcode-label" for="collection-postcode" data-label-prepend="Collection: ">&nbsp;&nbsp;&nbsp;Post Code <span style="color: red">*</span>:</label>
                                                            </div>
                                                            <div class="col-md-8 col-xs-12">
                                                                <asp:TextBox ID="txtCollectionPostCode" runat="server" TabIndex="3" CssClass="form-control"
                                                                    PlaceHolder="e.g. 44" title="" MaxLength="20"
                                                                    onkeypress="clearErrorMessage();"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group ovrFlwnone">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Contact No <span style="color: red">*</span>:</label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width: 100%;">
                                                            <input id="txtCollectionMobile" class="flag-tel" tabindex="4" type="tel" placeholder="Enter Phone Number"
                                                                onkeypress="NumericOnly(event);clearErrorMessage();" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group ovrFlwnone">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Alt Contact No <%--<span style="color: red">*</span>--%>:</label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width: 100%;">
                                                            <input id="txtAltCollectionMobile" class="flag-tel" tabindex="4" type="tel" placeholder="Enter Phone Number"
                                                                onkeypress="NumericOnly(event);clearErrorMessage();" runat="server" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" id="dvPickupEmailAddress">
                                                <div class="col-md-4 col-xs-12">
                                                    <label class="control-label" for="quoteEmail" data-label-premend="Your "
                                                        data-label-append=" for a quote">
                                                        Pickup Email Address<span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-8 col-xs-12">
                                                    <asp:TextBox ID="txtPickupEmailAddress" runat="server" TabIndex="5"
                                                        CssClass="form-control" PlaceHolder="example@gmail.com"
                                                        title="" Style="text-transform: lowercase;"
                                                        MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <!--end of collection filed-->
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="address-details">
                                    <h2>Recipient Details</h2>
                                    <div class="">
                                        <!--quote-box-->
                                        <div class="details">
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label" for="collection-title" style="width:100%;">Name 
                                                            <span style="color: red">*</span>:
                                                           
                                                        </label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                         <select id="DeliveryCustomerTitle" class="slct_box_inline" style="margin: 0px 0 0 0;padding: 9px 4px;">
                                                                <option>Mr</option>
                                                                <option>Mrs</option>
                                                                <option>Miss</option>
                                                            </select>
                                                        <asp:TextBox ID="txtDeliveryName" runat="server" MaxLength="50" TabIndex="6"
                                                            CssClass="form-control di_in_put" PlaceHolder="e.g. Tom" title=""
                                                            onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group address-field">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label" for="collection-address" data-label-prepend="Collection: ">Address <span style="color: red">*</span>:</label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                        <input type="text" id="txtDeliveryAddressLine1" class="form-control" tabindex="7"
                                                            placeholder="Enter a Delivery Location" title=""
                                                            onkeypress="clearErrorMessage();" runat="server" />
                                                        <div id="DeliveryMap"></div>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group">
                                                    <div class="col-sm-12 col-xs-12">
                                                        <div class="row">
                                                            <div class="col-md-4 col-xs-12">
                                                                <label class="control-label postcode-label" for="collection-postcode" data-label-prepend="Collection: ">&nbsp;&nbsp;&nbsp;Other Address <span style="color: red"></span>:</label>
                                                            </div>
                                                            <div class="col-md-8 col-xs-12">
                                                                <asp:TextBox ID="txtDeliveryPostCode" runat="server" TabIndex="8" CssClass="form-control"
                                                                    PlaceHolder="e.g. 44" title="" MaxLength="150"
                                                                    onkeypress="clearErrorMessage();"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group ovrFlwnone">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Contact No <span style="color: red">*</span>:</label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width: 100%;">
                                                            <input id="txtDeliveryMobile" class="flag-tel" tabindex="9" type="tel" placeholder="Enter Phone Number"
                                                                onkeypress="NumericOnly(event);clearErrorMessage();" runat="server" />

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group ovrFlwnone">
                                                    <div class="col-md-4 col-xs-12">
                                                        <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Alt Contact No <%--<span style="color: red">*</span>--%>:</label>
                                                    </div>
                                                    <div class="col-md-8 col-xs-12">
                                                        <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width: 100%;">
                                                            <input id="txtAltDeliveryMobile" class="flag-tel" tabindex="9" type="tel" placeholder="Enter Phone Number"
                                                                onkeypress="NumericOnly(event);clearErrorMessage();" runat="server" />

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" id="dvDeliveryEmailAddress">
                                                <div class="col-md-4 col-xs-12">
                                                    <label class="control-label" for="quoteEmail" data-label-premend="Your "
                                                        data-label-append=" for a quote">
                                                        Delivery Email Address<br />
                                                        (Optional):</label>
                                                </div>
                                                <div class="col-md-8 col-xs-12">
                                                    <asp:TextBox ID="txtDeliveryEmailAddress" runat="server" TabIndex="10"
                                                        CssClass="form-control" PlaceHolder="example@gmail.com"
                                                        title="" Style="text-transform: lowercase;"
                                                        MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>



                        <div class="row">
                            <div class="col-md-12 col-xs-12">
                                <asp:Label ID="lblErrMsg2" CssClass="ErrMsg" BackColor="#f9edef"
                                    Style="text-align: center; vertical-align: middle; width: 500px; line-height: 30px; border-radius: 0px;"
                                    runat="server" Text="" Font-Size="Small"></asp:Label>
                            </div>
                        </div>
                        <input type="button" name="previous" class="previous action-button-previous"
                            value="Previous Step" onclick="gotoPreviousStep2();" />
                        <input type="button" name="next" class="next action-button" value="Next Step"
                            onclick="return checkAllDetails();" />
                    </fieldset>
                    <!--end of 2nd form-->

                    <fieldset class="next-mov" id="dvStep3">
                        <asp:HiddenField ID="hfCustomerId" runat="server" />
                        <asp:HiddenField ID="hfBookingId" runat="server" />
                        <asp:HiddenField ID="hfQuoteId" runat="server" />

                        <asp:HiddenField ID="hfEditBookingId" runat="server" />
                        <asp:HiddenField ID="hfEditCustomerId" runat="server" />
                        <asp:HiddenField ID="hfItemCount" runat="server" Value="1" />
                        <asp:HiddenField ID="hfTotalValue" runat="server" />
                        <asp:HiddenField ID="hfVAT" runat="server" />

                        <asp:HiddenField ID="hfPickupLatitude" runat="server" />
                        <asp:HiddenField ID="hfPickupLongitude" runat="server" />
                        <asp:HiddenField ID="hfDeliveryLatitude" runat="server" />
                        <asp:HiddenField ID="hfDeliveryLongitude" runat="server" />

                        <h2 class="fs-title">Confirm your User Details</h2>
                        <div class="confirm-box">
                            <div class="confirm-details">
                                <div class="">
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel">Name:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-forename cmnLabel">
                                                <span id="PCustomerTitle"></span> <asp:Label ID="lblCollectionName" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel">Address:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-address cmnLabel">
                                                <asp:Label ID="lblCollectionAddressLine1" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel">Post Code::</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-postcode cmnLabel">
                                                <asp:Label ID="lblCollectionPostCode" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel"><i class="fa fa-mobile" aria-hidden="true"></i>Contact No:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-mobile cmnLabel">
                                                <asp:Label ID="lblCollectionMobile" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel label-lgt"><i class="fa fa-mobile label-lgt" aria-hidden="true"></i>Alt Contact No:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-mobile cmnLabel label-lgt2">
                                                <asp:Label ID="lblAltCollectionMobile" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <h2 class="fs-title">Confirm your Recipient Details</h2>
                        <div class="confirm-box">
                            <div class="confirm-details">
                                <div class="">
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel">Name:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-forename cmnLabel">
                                                <span id="DCustomerTitle"></span> <asp:Label ID="lblDeliveryName" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel">Address:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-address cmnLabel">
                                                <asp:Label ID="lblDeliveryAddressLine1" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel">Post Code::</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-postcode cmnLabel">
                                                <asp:Label ID="lblDeliveryPostCode" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel"><i class="fa fa-mobile" aria-hidden="true"></i>Contact No:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-mobile cmnLabel">
                                                <asp:Label ID="lblDeliveryMobile" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <span class="ylwLabel label-lgt"><i class="fa fa-mobile label-lgt2" aria-hidden="true"></i>Alt Contact No:</span>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="collection-mobile cmnLabel label-lgt">
                                                <asp:Label ID="lblAltDeliveryMobile" runat="server" Text=""></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <h2 class="fs-title">Confirm your Item details</h2>
                        <div class="confirm-box">
                            <div class="confirm-details">
                                <div class="">
                                    <div class="row">
                                        <div class="confirm-items table-responsive">
                                            <table class="table table-bordered" id="tblConfirmItems" style="width: 100%;">
                                                <thead class="jsTblH">
                                                    <tr class="Khaki">
                                                        <th scope="col">Pickup Category</th>
                                                        <th scope="col">Pickup Item</th>
                                                        <th scope="col">Fragile</th>
                                                        <th scope="col">Estimated Value</th>
                                                        <th scope="col">Price</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>

                                            <div class="table9">
                                                <table id="tblTaxDetailsConfirmation">
                                                    <tbody>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div style="display: none;" class="totalCAL">
                                                <div class="col-md-6">VAT</div>
                                                <div class="col-md-6" align="right">
                                                    <i class="note-disclaimer"><i>£
                                                            <span id="spVATAmount"></span></i></i>
                                                </div>
                                            </div>
                                            <div style="display: none;" class="totalCAL">
                                                <div class="col-md-6">Insurance Premium</div>
                                                <div class="col-md-6" align="right">
                                                    <i class="note-disclaimer"><i>£
                                                            <span id="spInsurancePremiumAmount"></span></i></i>
                                                </div>
                                            </div>
                                            <div style="display: none;" class="totalCAL">
                                                <div class="col-md-6">Total Amount</div>
                                                <div class="col-md-6" align="right">
                                                    <i class="note-disclaimer"><i>£
                                                            <span id="spTotalAmount"></span></i></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <label><b style="font-weight: bolder;">To be collected:</b></label>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="confirm-collection-date cmnLabel">
                                                <asp:Label ID="lblConfirmCollectionDate" runat="server" Text=""
                                                    Font-Bold="true" Style="font-weight: bolder;"></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <label><b style="font-weight: bolder;">Booking Notes:</b></label>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <span class="confirm-collection-date label-lgt cmnLabel">
                                                <asp:Label ID="lblConfirmStatusDetails" runat="server" Text=""
                                                    Font-Bold="true" style="font-weight: bolder;"></asp:Label>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!--<h2 class="fs-title">Send Booking Details To</h2>-->
                        <div class="confirm-box">
                            <div class="confirm-details">
                                <div class="" style="display: none;">
                                    <div class="row">
                                        <div class="col-md-4 col-sm-3 col-xs-12">
                                            <label class="control-label" for="quoteEmail" data-label-premend="Your " data-label-append=" for a quote">Email Address<span style="color: red">*</span>:</label>
                                        </div>
                                        <div class="col-md-8 col-sm-9 col-xs-12">
                                            <asp:TextBox ID="txtConfirmEmailAddress" runat="server"
                                                CssClass="form-control" PlaceHolder="example@gmail.com"
                                                title="Please enter Email Address" Style="text-transform: lowercase;"
                                                MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group confirm-check">
                                    <label class="control-label" for="confirm">
                                        <span>I Confirm that the order summary above is correct <span style="color: red">*</span></span>
                                        <asp:CheckBox ID="chkConfirm" runat="server" onchange="clearErrorMessage();" />
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 col-xs-12">
                                <asp:Label ID="lblErrMsg3" CssClass="ErrMsg" BackColor="#f9edef"
                                    Style="text-align: center; vertical-align: middle; width: 500px; line-height: 30px; border-radius: 0px;"
                                    runat="server" Text="" Font-Size="Small"></asp:Label>
                            </div>
                        </div>

                        <input type="button" name="previous" class="previous action-button-previous"
                            value="Previous Step" onclick="gotoPreviousStep3();" />
                        <asp:Button ID="btnSendQuote" runat="server" Text="Confirm" CssClass="action-button"
                            OnClientClick="return sendEmailAfterConfirmation();" />
                        <input type="button" name="cancelQuote" class="action-button rdBTN"
                            value="Cancel" onclick="$('#cancel-bx').modal('show');" />
                    </fieldset>
                    <!--end of 3rd form-->

                    <div class="modal fade" id="booking-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Booking</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p>Wish to Book Now?</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="placeOrder();">Yes</button>
                                    <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="cancelBooking();">No</button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="modal fade" id="cancel-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Cancel Booking</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p>Sure you want to cancel this Booking?</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="cancelBooking();">Yes</button>
                                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="modal fade" id="payment-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title pm-modal" style="font-size: 24px; color: #111;">Payment</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p>Wish to make Payment online?</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="proceedToPayment();">Pay Now</button>
                                    <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="goHome();">Pay at collection<%--<label id="lblCollectionAddress" style="color: #fff;"></label>--%></button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="modal fade" id="NoRemoval-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Removal Restricted</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p>First Row can't be Removed</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="modal fade" id="OtherInfo-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Information about 'Other' Category</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p>The Price of Category 'Other' will be paid at Collection</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
                                </div>
                            </div>

                        </div>
                    </div>

                </form>

            </div>
        </div>
    </div>

</asp:Content>

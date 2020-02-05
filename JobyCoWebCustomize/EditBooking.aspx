<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" 
    CodeBehind="EditBooking.aspx.cs" Inherits="JobyCoWebCustomize.EditBooking" EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!--<link href="/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />-->
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <script>
        // unblock when ajax activity stops 
        $(document).ajaxStop($.unblockUI);

        function mainMenu() {
            $.ajax({
                url: 'Booking/EditBooking.aspx',
                cache: false
            });
        }

        $(document).ready(function () {

            //$.blockUI({
            //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    message: '<h4>Loading...</h4>',
            //    css: {
            //        border: 'none',
            //        //backgroundColor: 'transparent'
            //    }

            //});

            //mainMenu();

            var rowCount = $('#myTable > tbody > tr').length;
            rowCount--;
            
            $( "#<%=hfItemCount.ClientID%>" ).val( rowCount.toString() );
            $( "#<%=spItemCount.ClientID%>" ).text( rowCount.toString() );

        getPickupCategories();

        getCustomerId();
        getBookingId();
        generateQuoteId();

        //getUserName();

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
                            //alert('BookPickup Removal');
                            $(this).remove();
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

                //New Code Added for Blank Pickup Items
                //================================================
                if ( vMyTable_PickupCategory == "Pickup Category" )
                {
                    if ( vConfirmItems_PickupCategory == "" )
                    {
                        $( this ).remove();
                    }
                }
                //================================================

                //New Code Added for Blank Pickup Items
                //================================================
                vConfirmItems_PickupItem = $( this ).find( 'td:eq(1)' ).text().trim();
                if ( vConfirmItems_PickupItem == '' )
                {
                    vConfirmItems_PickupItem = 'Pickup Item';
                }
                //================================================

                vConfirmItems_EstimatedValue = $( this ).find( 'td:eq(3)' ).text().trim();
                vConfirmItems_PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();

                if (vMyTable_PredefinedEstimatedValue == "") {
                    vMyTable_PredefinedEstimatedValue = "0.00";
                }

                if (vMyTable_PickupCategory == vConfirmItems_PickupCategory) {
                    if (vMyTable_PickupItem == vConfirmItems_PickupItem) {
                        if (vMyTable_EstimatedValue == vConfirmItems_EstimatedValue) {
                            if (vMyTable_PredefinedEstimatedValue == vConfirmItems_PredefinedEstimatedValue) {
                                //alert('Confirm Items Removal');
                                $(this).remove();
                            }
                        }
                    }
                }
            });

            $(this).closest("tr").remove();

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

        $( '#<%=txtCollectionDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            startDate: date,
            autoclose: true
        });

        $( '#<%=hfChanged.ClientID%>' ).val( 'Not Changed' );
    } );
    </script>

    <script>
        //View Image after uploading
        var loadFile = function (event, ImageId) {
            var output = document.getElementById(ImageId);
            output.src = URL.createObjectURL(event.target.files[0]);
            $('#' + ImageId).closest('li').css("display", "inline-block");
            //$("#ulOutput li").css("display", "inline");

            $('#' + ImageId).closest('li').addClass("lstImage");
            $('#' + ImageId).addClass("imgIcon");
        };
    </script>

    <script>
        function getMyTableTotal()
        {
            //debugger;
            var vMyTable_PredefinedEstimatedValue_String = "";
            var vMyTable_PredefinedEstimatedValue_Float = 0.0;

            var vMyTable_EstimatedValue_String = "";
            var vMyTable_EstimatedValue_Float = 0.0;

            var vMyTable_TotalValue_Float = 0.0;
            var vMyTable_VAT = 0.00;
            

            //$("#tblTaxDetails tbody tr").remove();

            //$("#tblTaxDetailsConfirmation tbody tr").remove();
            //$("#tblTaxDetails tbody").html("");
            //$("#tblTaxDetailsConfirmation tbody").html("");
            $('#myTable tbody tr').each(function (i, row) {
                
                if ($(this).closest("tr").find('input[type=text]:eq(2)') != ""){
                    vMyTable_PredefinedEstimatedValue_String = $(this).closest("tr").find('input[type=text]:eq(2)').val();
                } 
                if ($(this).closest("tr").find('input[type=text]:eq(1)').val() != "") {
                    vMyTable_EstimatedValue_String = $(this).closest("tr").find('input[type=text]:eq(1)').val();
                }
                
                //alert('vMyTable_PredefinedEstimatedValue_String=' + vMyTable_PredefinedEstimatedValue_String + ' vMyTable_EstimatedValue_String=' + vMyTable_EstimatedValue_String);
                vMyTable_PredefinedEstimatedValue_Float = parseFloat(vMyTable_PredefinedEstimatedValue_String);
                vMyTable_EstimatedValue_Float = parseFloat(vMyTable_EstimatedValue_String);

                if (vMyTable_EstimatedValue_Float > vMyTable_PredefinedEstimatedValue_Float) {
                    vMyTable_PredefinedEstimatedValue_Float = vMyTable_EstimatedValue_Float;
                }

                if (!isNaN(vMyTable_PredefinedEstimatedValue_Float) && (vMyTable_PredefinedEstimatedValue_String != "" || vMyTable_EstimatedValue_String != "")) {
                    //alert('vMyTable_TotalValue_Float : Before ' + vMyTable_TotalValue_Float);
                    vMyTable_TotalValue_Float += vMyTable_PredefinedEstimatedValue_Float;
                    //alert('vMyTable_TotalValue_Float : after ' + vMyTable_TotalValue_Float);

                }
            });

            //alert('vMyTable_TotalValue_Float  after loop Total : ' + vMyTable_TotalValue_Float);
            var TotalValue = parseFloat(vMyTable_TotalValue_Float);
            var JsonData = {};
            JsonData.TotalValue = TotalValue;
            //alert(JSON.stringify(JsonData));
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditBooking.aspx/GetTaxationDetails",
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
                            //debugger;
                            var TaxAmount = parseFloat(jdata[i]["TaxAmount"]);
                            var IsPercent = jdata[i]["IsPercent"];
                            ChargesType = jdata[i]["RadioChargesType"].toString();
                            var CalculateTax = 0.00;
                            
                            if (ChargesType == "VAT")
                            {
                                var RegisteredCompany = $( "#<%=ddlRegisteredCompany.ClientID%>" );
                                var vRegisteredCompany = RegisteredCompany.find( "option:selected" ).text().trim();

                                if ( vRegisteredCompany == "Yes" ){
                                    var GoodsInName = $( "#<%=ddlGoodsInName.ClientID%>" );
                                    var vGoodsInName = GoodsInName.find( "option:selected" ).text().trim();

                                    if ( vGoodsInName == "Yes" ){
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
                                        
                                        //$("#<%//=hfVAT.ClientID%>").val(CalculateTax);
                                        //$( '#<%//=spVAT.ClientID%>' ).text( vMyTable_VAT.toFixed( 2 ).toString() );
                                        //$( '#spVATAmount' ).text( vMyTable_VAT.toFixed( 2 ).toString() );
                                    }
                                }

                                <%--vMyTable_TotalValue_Float += vMyTable_VAT;
                                //alert('vMyTable_TotalValue_Float' + vMyTable_TotalValue_Float);
                                $( "#<%=hfVAT.ClientID%>" ).val( vMyTable_VAT );

                                //===========================================================
                                $( '#<%=spVAT.ClientID%>' ).text( vMyTable_VAT.toFixed( 2 ).toString() );
                                $( '#spVATAmount' ).text( vMyTable_VAT.toFixed( 2 ).toString() );--%>
                            }
                            else if (ChargesType == "Insurance")
                            {
                                var Insurance = $( "#<%=ddlInsurance.ClientID%>" );
                                var vInsurance = Insurance.find( "option:selected" ).text().trim();

                                if (vInsurance == "No")
                                {
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
                                    //$('#<%//=spInsurancePremium.ClientID%>').text(CalculateTax);
                                    //$('#spInsurancePremiumAmount').text(CalculateTax);
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
                        //$( '#spTotalAmount' ).text( "" + $( "#<%//=spTotal.ClientID%>" ).text().trim() );
                        $("#tblTaxDetails tbody tr").remove();
                        $("#tblTaxDetailsConfirmation tbody tr").remove();
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
            alert('Onkeyup');
            var ErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            ErrMsg.text( '' );
            ErrMsg.css( "display", "none" );

            var vEstimatedValue = $( "#txtEstimatedValue" ).val().trim();
            var vPredefinedEstimatedValue = $( "#txtPredefinedEstimatedValue" ).val().trim();

            var vEstimatedValue_Float = parseFloat(vEstimatedValue);
            var vPredefinedEstimatedValue_Float = parseFloat(vPredefinedEstimatedValue);

            if (vEstimatedValue_Float > 0) {
                getMyTableTotal();
            }else if (vPredefinedEstimatedValue_Float > 0) {
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

                //alert( 'Estimated Value: ' + vMyTable_EstimatedValue +
                //    '\nPredefined Estimated Value: ' + vMyTable_PredefinedEstimatedValue );

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

        function loadConfirmItems( ctr, PickupCategoryValue,
            PickupItemValue, IsFragileValue, EstimatedValue, PredefinedEstimatedValue )
        {
            //alert( 'loadConfirmItems: ' + ctr.toString() );

            var vTableRowLast = "";
            vTableRowLast += "<tr>";
            vTableRowLast += "<td>" + PickupCategoryValue + "</td>";
            vTableRowLast += "<td>" + PickupItemValue + "</td>";
            vTableRowLast += "<td>" + IsFragileValue + "</td>";
            vTableRowLast += "<td>" + EstimatedValue + "</td>";
            vTableRowLast += "<td>" + PredefinedEstimatedValue + "</td>";
            vTableRowLast += "</tr>";

            if ( PickupCategoryValue != "Pickup Category" )
            {
                $( "#tblConfirmItems tbody" ).append( vTableRowLast );
            }
        }

        function checkInternetConnection()
        {
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
            if(!chkAgree.is(":checked")) {
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

            var CollectionMobile = $("#<%=txtCollectionMobile.ClientID%>");
            if (CollectionMobile.val().trim() == "") {
                CollectionMobile.addClass('manField');
            }

            var PickupEmailAddress = $( "#<%=txtPickupEmailAddress.ClientID%>" );
            var vPickupEmailAddress = PickupEmailAddress.val().trim();

            if ( vPickupEmailAddress == "" )
            {
                PickupEmailAddress.addClass( 'manField' );
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

            var DeliveryMobile = $("#<%=txtDeliveryMobile.ClientID%>");
            if (DeliveryMobile.val().trim() == "") {
                DeliveryMobile.addClass('manField');
            }

            var DeliveryEmailAddress = $( "#<%=txtDeliveryEmailAddress.ClientID%>" );
            var vDeliveryEmailAddress = DeliveryEmailAddress.val().trim();

            if ( vDeliveryEmailAddress == "" )
            {
                DeliveryEmailAddress.addClass( 'manField' );
            }
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
            $("#<%=txtDeliveryEmailAddress.ClientID%>").removeClass('manField');
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

                valueChanged();
            }
            else if (vRegisteredCompany == "No") {
                $("#<%=dvGoodsInName.ClientID%>").css("display", "none");
                clearErrorMessage();

                $("#<%=txtCompanyName.ClientID%>").removeClass('manField');
                $("#<%=ddlGoodsInName.ClientID%>").removeClass('manField');

                $("#<%=txtCompanyName.ClientID%>").val('');
                $("#<%=ddlGoodsInName.ClientID%>")[0].selectedIndex = 0;

                valueChanged();
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

                valueChanged();
            }
            //New Logic Added for 'I am not interested' just like 'No'
            //===============================================================
            else if (vInsurance == "I am not interested")
            {
                //alert('Insurance Premium');
                /*ErrMsg.text('You have to buy the insurance');
                ErrMsg.css("display", "block");*/

                InsurancePremium.val( '0.00' );
                InsurancePremium.addClass( 'manField' );

                //$("#<%=dvInsurancePremium.ClientID%>").css("display", "block");

                valueChanged();
            }
            //===============================================================
            else if (vInsurance == "Yes") {

                InsurancePremium.val('');
                InsurancePremium.removeClass('manField');

                $("#<%=dvInsurancePremium.ClientID%>").css("display", "none");

                valueChanged();
           }

            //return false;
        }

        //New Round Off Function Added
        function roundOffEstimatedValue(vEstimatedValue) {
            var fEstimatedValue = parseFloat(vEstimatedValue).toFixed(2);
            var sEstimatedValue = fEstimatedValue.toString();

            return sEstimatedValue;
        }

        function valueChanged()
        {
            $( '#<%=hfChanged.ClientID%>' ).val( 'Changed' );
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

        function dynamicallyGeneratedTable(ctr, PickupCategoryValue,
            PickupItemValue, IsFragileValue, EstimatedValue, PredefinedEstimatedValue) {

            //New Code for Image Upload 
            //==================================
                var vImageList = "";
                vImageList = '<li style="display: none;"><img id="output' + (counter + 1) + '" src="#" height="50" width="50" /></li>';
                $("#ulOutput").append(vImageList);
            //==================================

            var vMyTableRow = "";
            vMyTableRow += "<tr>";
            vMyTableRow += '<td><select id="ddlPickupCategory' + ctr + '" name="pickupCategory[]"  class="itemcatPickup" title="" onchange="clearErrorMessage();hideQuestionBoxIfExistsAny(' + ctr + ');"><option value="">Pickup Category</option></select></td>';
            vMyTableRow += '<td><select id="ddlPickupItem' + ctr + '" name="pickupItem[]" required class="items" title="Please select a Pickup Item from dropdown" onchange="clearErrorMessage();"><option value="">Pickup Item</option></select><input type="text" id="txtPickupItem' + ctr + '" class="" style="display: none;" title="Please enter value for \'Others\' Category" placeholder="Please enter value" onkeypress="valueChanged();clearErrorMessage();" /></td>';
            vMyTableRow += '<td><div class="ondisplay"><section title=".roundedTwo"><div class="roundedTwo"><input id="roundedTwo' + ctr + '" type="checkbox" value="None" name="check" /><label for="roundedTwo' + ctr + '"><span>FRAGILE?</span></label></div></section></div></td>';
            vMyTableRow += '<td><label class="float_label">£</label><input id="txtEstimatedValue' + ctr + '" name="estimatedValue[]" class="estimatevalue" placeholder="e.g. £123.45" maxlength="10" title="Please enter Estimated Value is correct" type="text" required="" onkeyup="getMyTableTotal();" onkeypress="valueChanged();DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);" /></td>';
            vMyTableRow += '<td><label class="float_label">£</label><input id="txtPredefinedEstimatedValue' + ctr + '" name="predefinedestimatedValue[] class="estimatevalue" placeholder="e.g. £123.45" title="Price" type="text" onkeyup="getMyTableTotal();" required="" style="padding-left: 40px;" /></td>';

            //New td added for 'Other' information
            //========================================================================================================================================================================================
            vMyTableRow += '<td><button id="btnQuestion' + ctr + '" class="question-mark" style="display: none;" onclick="return showOtherInfo();"><i class="fa fa-question-circle" aria-hidden="true"></i></button></td>';
            //========================================================================================================================================================================================

            vMyTableRow += '<td><label class="brwsBtn" for="upload' + (counter + 1) + '">Upload an image (optional)<input class="isVisuallyHidden" id="upload' + (counter + 1) + '" name="upload[]" type="file" accept="image/*" onchange="loadFile(event, \'output' + (counter + 1) + '\')" multiple required /></label></td>';
            vMyTableRow += '<td><a class="btn-danger deleteRow btn-sm ibtnDel"><span class="glyphicon glyphicon-minus remove"></span></a></td>';
            vMyTableRow += "</tr>";

            $("#myTable tbody").append(vMyTableRow);

            var PickupCategoryId = "ddlPickupCategory" + ctr.toString();

            //New Code Added
            //==========================================================================
            $('#' + PickupCategoryId).find("option:selected").text(PickupCategoryValue);
            //==========================================================================

            var vPickupCategory = $('#' + PickupCategoryId).find("option:selected").text().trim();
            getPickupCategoriesByName(PickupCategoryId);

            var PickupItemId = "ddlPickupItem" + ctr.toString();

            //New Code Added
            //==========================================================================
            $('#' + PickupItemId).find("option:selected").text(PickupItemValue);
            //==========================================================================

            var vPickupItem = $('#' + PickupItemId).find("option:selected").text().trim();

            var PredefinedEstimatedValueId = "txtPredefinedEstimatedValue" + ctr.toString();
            var vPredefinedEstimatedValue = $('#' + PredefinedEstimatedValueId).val().trim();

            //New Code Added
            //==========================================================================
            if (vPickupItem == "") {
                $('#' + PickupItemId).find("option:selected").text("Pickup Item");

                getPredefinedEstimatedValueOnlyByCategory(vPickupCategory, PredefinedEstimatedValueId);
            }
            //==========================================================================

            var TextPickupItemId = "txtPickupItem" + ctr.toString();
            var vTextPickupItem = $('#' + TextPickupItemId).val().trim();

            var FragileId = "roundedTwo" + ctr.toString();
            var vFragile = $('#' + FragileId);

            //New Code Added
            //==========================================================================
            if (IsFragileValue == "True") {
                vFragile.attr('checked', 'checked');
            }
            else {
                vFragile.removeAttr('checked');
            }
            //==========================================================================

            var EstimatedValueId = "txtEstimatedValue" + ctr.toString();

            //New Code Added
            //==========================================================================
            $('#' + EstimatedValueId).val(EstimatedValue);
            //==========================================================================

            var vEstimatedValue = $('#' + EstimatedValueId).val().trim();

            if (vEstimatedValue == "") {
                vEstimatedValue = "0.00";

                //New Code Added
                //==========================================================================
                $('#' + EstimatedValueId).val(vEstimatedValue);
                //==========================================================================
            }

            //New Code Added for - Predefined Estimated Value
            //==========================================================================
            $('#' + PredefinedEstimatedValueId).val(PredefinedEstimatedValue);
            //==========================================================================

            var vPredefinedEstimatedValue = $('#' + PredefinedEstimatedValueId).val().trim();

            if (vPredefinedEstimatedValue == "") {
                vPredefinedEstimatedValue = "0.00";

                //New Code Added
                //==========================================================================
                $('#' + PredefinedEstimatedValueId).val(vPredefinedEstimatedValue);
                //==========================================================================
            }

            //New Code Added
            //==========================================================================
            if (vPickupItem != "") {
                if (vPickupItem != "Pickup Item") {
                    getPredefinedEstimatedValueByItemValue(vPickupItem, PredefinedEstimatedValueId);
                }
            }
            //==========================================================================

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
                            $("#<%=spTotal.ClientID%>").text(vMyTable_TotalValue_Float.toFixed(2).toString());

                            //Insurance Premium Calculation
                            //==============================
                            var fTotal = parseFloat( $("#<%=spTotal.ClientID%>").text().trim() );
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
                            //==============================
                        }
                    });
                }
            }
        });--%>

            counter = ctr + 1;
            bUpdate = true;

        //return false;
        }

        function addRowBookPickup() {
        
            counter = parseInt($("#<%=hfItemCount.ClientID%>").val().trim());
            counter++;

            //New Code for Image Upload 
            //==================================
            var vImageList = "";
            vImageList = '<li style="display: none;"><img id="output' + (counter + 1) + '" src="#" height="50" width="50" /></li>';
            $("#ulOutput").append(vImageList);
            //==================================

            var vMyTableRow = "";
            vMyTableRow += "<tr>";
            vMyTableRow += '<td><select id="ddlPickupCategory' + counter + '" name="pickupCategory[]"  class="itemcatPickup" title="" onchange="clearErrorMessage();hideQuestionBoxIfExistsAny(' + counter + ');"><option value="">Pickup Category</option></select></td>';
            vMyTableRow += '<td><select id="ddlPickupItem' + counter + '" name="pickupItem[]" required class="items" title="Please select a Pickup Item from dropdown" onchange="clearErrorMessage();"><option value="">Pickup Item</option></select><input type="text" id="txtPickupItem' + counter + '" class="" style="display: none;" title="Please enter value for \'Others\' Category" placeholder="Please enter value" onkeypress="valueChanged();clearErrorMessage();" /></td>';
            vMyTableRow += '<td><div class="ondisplay"><section title=".roundedTwo"><div class="roundedTwo"><input id="roundedTwo' + counter + '" type="checkbox" value="None" name="check" /><label for="roundedTwo' + counter + '"><span>FRAGILE?</span></label></div></section></div></td>';
            vMyTableRow += '<td><label class="float_label">£</label><input id="txtEstimatedValue' + counter + '" name="estimatedValue[]" class="estimatevalue" placeholder="e.g. £123.45" maxlength="10" title="Please enter Estimated Value is correct" type="text" required="" onkeyup="getMyTableTotal();" onkeypress="valueChanged();DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);" /></td>';
            vMyTableRow += '<td><label class="float_label">£</label><input id="txtPredefinedEstimatedValue' + counter + '" name="predefinedestimatedValue[] class="estimatevalue" placeholder="e.g. £123.45" readonly="readonly" title="Price" type="text" required="" onkeyup="getMyTableTotal();" style="padding-left: 40px;" /></td>';

            //New td added for 'Other' information
            //========================================================================================================================================================================================
            vMyTableRow += '<td><button id="btnQuestion' + counter + '" class="question-mark" style="display: none;" onclick="return showOtherInfo();"><i class="fa fa-question-circle" aria-hidden="true"></i></button></td>';
            //========================================================================================================================================================================================

            vMyTableRow += '<td><label class="brwsBtn" for="upload' + (counter + 1) + '">Upload an image (optional)<input class="isVisuallyHidden" id="upload' + (counter + 1) + '" name="upload[]" type="file" accept="image/*" onchange="loadFile(event, \'output' + (counter + 1) + '\')" multiple required /></label></td>';
            vMyTableRow += '<td><a class="btn-danger deleteRow btn-sm ibtnDel"><span class="glyphicon glyphicon-minus remove"></span></a></td>';
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

            //tblConfirmItems PickupCategory Value updation
            //==========================================
            var ConfirmItems_PickupCategoryId = "tdPickupCategory" + counter.toString();
            if ( $( "#tblConfirmItems > tbody > tr" ).has( $( '#' + ConfirmItems_PickupCategoryId ) ).length > 0 )
            {
                $( '#' + ConfirmItems_PickupCategoryId ).text( vPickupCategory );
            }
            //==========================================

            //Clearing Table Confirm Items PickupItem, IsFragile, Estimated Value, Predefined Estimated Value
            //=================================================================================
            var myTable_IsFragileId_Reset = "roundedTwo" + counter.toString();
            $( '#' + myTable_IsFragileId_Reset ).removeAttr( 'checked' );

            var myTable_EstimatedValueId_Reset = "txtEstimatedValue" + counter.toString();
            $( '#' + myTable_EstimatedValueId_Reset ).val( '' );

            var myTable_PredefinedEstimatedValueId_Reset = "txtPredefinedEstimatedValue" + counter.toString();
            $( '#' + myTable_PredefinedEstimatedValueId_Reset ).val( '' );
            //=================================================================================

            //Clearing Table Confirm Items PickupItem, IsFragile, Estimated Value, Predefined Estimated Value
            //=================================================================================
            var ConfirmItems_PickupItemId_Reset = "tdPickupItem" + counter.toString();
            $( '#' + ConfirmItems_PickupItemId_Reset ).text( '' );

            var ConfirmItems_IsFragileId_Reset = "tdIsFragile" + counter.toString();
            $( '#' + ConfirmItems_IsFragileId_Reset ).text( '' );

            var ConfirmItems_EstimatedValueId_Reset = "tdEstimatedValue" + counter.toString();
            $( '#' + ConfirmItems_EstimatedValueId_Reset ).text( '' );

            var ConfirmItems_PredefinedEstimatedValueId_Reset = "tdPredefinedEstimatedValue" + counter.toString();
            $( '#' + ConfirmItems_PredefinedEstimatedValueId_Reset ).text( '' );
            //=================================================================================
        } );

        $('#myTable').on('change', '#' + PickupItemId, function () {
            vPickupItem = $('#' + PickupItemId).find("option:selected").text().trim();
            getPredefinedEstimatedValueByItemValue(vPickupItem, PredefinedEstimatedValueId);

            //tblConfirmItems PickupItem Value updation
            //==========================================
            var ConfirmItems_PickupItemId = "tdPickupItem" + counter.toString();
            if ( $( "#tblConfirmItems > tbody > tr" ).has( $( '#' + ConfirmItems_PickupItemId ) ).length > 0 )
            {
                var CurrentPickupItemId = "ddlPickupItem" + counter.toString();
                var vCurrentPickupItem = $( '#' + CurrentPickupItemId ).find( "option:selected" ).text().trim();

                var CurrentTextPickupItemId = "txtPickupItem" + counter.toString();
                var vCurrentTextPickupItem = $( '#' + CurrentTextPickupItemId ).val().trim();

                if ( vCurrentPickupItem == "Pickup Item" )
                {
                    vCurrentPickupItem = "";
                }

                if ( vCurrentTextPickupItem != "" )
                {
                    if ( vCurrentPickupItem == "" )
                    {
                        vCurrentPickupItem = vCurrentTextPickupItem;
                    }
                }

                $( '#' + ConfirmItems_PickupItemId ).text( vCurrentPickupItem );
            }
            //==========================================
        } );

        //New Code added here
        <%--$('#myTable').on('blur', '#' + EstimatedValueId, function () {
            if (vEstimatedValue != "") {
                if (vPredefinedEstimatedValue != "") {

                    //Round Off Estimated Value on Blur
                    //===============================================
                    var CurrentEstimatedValueId = "txtEstimatedValue" + counter.toString();
                    var vCurrentEstimatedValue = $( '#' + CurrentEstimatedValueId ).val().trim();

                    vCurrentEstimatedValue = roundOffEstimatedValue( vCurrentEstimatedValue );
                    $( '#' + CurrentEstimatedValueId ).val( vCurrentEstimatedValue );
                    //===============================================

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
                            $("#<%=spTotal.ClientID%>").text(vMyTable_TotalValue_Float.toFixed(2).toString());

                            //Insurance Premium Calculation
                            //==============================
                            var fTotal = parseFloat( $("#<%=spTotal.ClientID%>").text().trim() );
                            var fInsurancePremium = ( fTotal * 10 ) / 100;
                            var vInsurancePremium = fInsurancePremium.toFixed( 2 ).toString();
                            $( '#<%=txtInsurancePremium.ClientID%>' ).val( vInsurancePremium );
                            //==============================

                            //tblConfirmItems IsFragile Value updation
                            //==========================================
                            var vConfirmItems_RadioButtonValue = "";

                            var ConfirmItems_FragileId = "roundedTwo" + counter.toString();
                            var vConfirmItems_Fragile = $( '#' + ConfirmItems_FragileId );

                            if ( vConfirmItems_Fragile.is( ":checked" ) )
                            {
                                vConfirmItems_RadioButtonValue = "True";
                            }
                            else
                            {
                                vConfirmItems_RadioButtonValue = "False";
                            }

                            var ConfirmItems_IsFragileId = "tdIsFragile" + counter.toString();
                            if ( $( "#tblConfirmItems > tbody > tr" ).has( $( '#' + ConfirmItems_IsFragileId ) ).length > 0 )
                            {
                                $( '#' + ConfirmItems_IsFragileId ).text( vConfirmItems_RadioButtonValue );
                            }
                            //==========================================

                            //tblConfirmItems EstimatedValue Value updation
                            //==========================================
                            var ConfirmItems_EstimatedValueId = "tdEstimatedValue" + counter.toString();
                            if ( $( "#tblConfirmItems > tbody > tr" ).has( $( '#' + ConfirmItems_EstimatedValueId ) ).length > 0 )
                            {
                                //var CurrentEstimatedValueId = "txtEstimatedValue" + counter.toString();
                                //var vCurrentEstimatedValue = $( '#' + CurrentEstimatedValueId ).val().trim();

                                $( '#' + ConfirmItems_EstimatedValueId ).text( vCurrentEstimatedValue );
                            }
                            //==========================================

                            //tblConfirmItems PredefinedEstimatedValue Value updation
                            //==========================================
                            var ConfirmItems_PredefinedEstimatedValueId = "tdPredefinedEstimatedValue" + counter.toString();
                            if ( $( "#tblConfirmItems > tbody > tr" ).has( $( '#' + ConfirmItems_PredefinedEstimatedValueId ) ).length > 0 )
                            {
                                var CurrentPredefinedEstimatedValueId = "txtPredefinedEstimatedValue" + counter.toString();
                                var vCurrentPredefinedEstimatedValue = $( '#' + CurrentPredefinedEstimatedValueId ).val().trim();

                                $( '#' + ConfirmItems_PredefinedEstimatedValueId ).text( vCurrentPredefinedEstimatedValue );
                            }
                            //==========================================
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

                //var vTableRowLast = "";
                //vTableRowLast += "<tr>";
                //vTableRowLast += "<td>" + vPickupCategory + "</td>";
                //vTableRowLast += "<td>" + vPickupItem + "</td>";
                //vTableRowLast += "<td>" + vRadioButtonValue + "</td>";
                //vTableRowLast += "<td>" + vEstimatedValue + "</td>";
                //vTableRowLast += "<td>" + vPredefinedEstimatedValue + "</td>";
                //vTableRowLast += "</tr>";

                var vTableRowLast = "";
                var vConfirmItemsPickupCategory = "";
                var vConfirmItemsPickupItem = "";
                var vConfirmItemsIsFragile = "";
                var vConfirmItemsEstimatedValue = "";
                var vConfirmItemsPredefinedEstimatedValue = "";
                //debugger;
                vTableRowLast += "<tr>";
                vTableRowLast += "<td id='tdPickupCategory" + counter.toString() + "'>" + vConfirmItemsPickupCategory + "</td>";
                vTableRowLast += "<td id='tdPickupItem" + counter.toString() + "'>" + vConfirmItemsPickupItem + "</td>";
                vTableRowLast += "<td id='tdIsFragile" + counter.toString() + "'>" + vConfirmItemsIsFragile + "</td>";
                vTableRowLast += "<td id='tdEstimatedValue" + counter.toString() + "'>" + vConfirmItemsEstimatedValue + "</td>";
                vTableRowLast += "<td id='tdPredefinedEstimatedValue" + counter.toString() + "'>" + vConfirmItemsPredefinedEstimatedValue + "</td>";
                vTableRowLast += "</tr>";

                //alert( 'Last:\n' + vTableRowLast );
                $( "#tblConfirmItems tbody" ).append( vTableRowLast );

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

                if (iRows >= 2) {
                    for (var i = 0; i < iRows; i++) {
                        addRowBookPickup();
                    }
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

                if (vGoodsInName == "Please Select") {
                    ErrMsg.text("Please Select either 'Yes' or 'No' from 'Goods In Name' dropdown");
                    ErrMsg.css("display", "block");
                    //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                    GoodsInName.focus();
                    GoodsInName.addClass('manField');
                    return false;
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

            var CollectionDate = $("#<%=txtCollectionDate.ClientID%>");
            var vCollectionDate = CollectionDate.val().trim();

            if (vCollectionDate == "") {
                ErrMsg.text("Please Select a Collection Date after Current Date");
                ErrMsg.css("display", "block");
                //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionDate.focus();
                return false;
            }
            else
            {
                var ConfirmCollectionDate = $('#<%=lblConfirmCollectionDate.ClientID%>');
                var vConfirmCollectionDate = ConfirmCollectionDate.text().trim();

                var vCollectionDateTime = "";
                if (vConfirmCollectionDate == "") {
                    try
                    {
                        vDay = vCollectionDate.substr( 0, 2 );
                        vMonth = vCollectionDate.substr( 3, 2 );
                        vYear = vCollectionDate.substr( 6, 4 );

                        vCollectionDate = vYear + '-' + vMonth + '-' + vDay;
                        vCollectionDateTime = new Date( vCollectionDate ).toDateString();

                        ConfirmCollectionDate.text( vCollectionDateTime );

                        valueChanged();
                    }
                    catch ( e )
                    {
                        var vYear = "", vMonth = "", vDay = "";
                        try
                        {
                            vYear = vCollectionDate.substr( 0, 4 );
                            vMonth = vCollectionDate.substr( 5, 2 );
                            vDay = vCollectionDate.substr( 8, 2 );
                        }
                        catch ( e )
                        {
                        }

                        vCollectionDate = vDay + "-" + vMonth + "-" + vYear;

                        vCollectionDateTime = new Date( vCollectionDate ).toDateString();
                        ConfirmCollectionDate.text( vCollectionDateTime );
                    }
                }
            }

            var chkAgree = $("#<%=chkAgree.ClientID%>");
            if (!chkAgree.is(":checked")) {
                ErrMsg.text("Please tick on the Agreement Checkbox");
                ErrMsg.css("display", "block");
                //ErrMsg.show(1000).delay(1000).fadeOut(1000);
                chkAgree.focus();
                return false;
            }

            if ( $( "#<%=spTotal.ClientID%>" ).text().trim() == "0.00" )
            {
                ErrMsg.text( "Please provide proper Item Information" );
                ErrMsg.css( "display", "block" );
                return false;
            }

            //uploadImageFile();

            return true;
        }
    </script>

    <script>
                function getPickupCategories() {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EditBooking.aspx/GetPickupCategories",
                    data: "{}",
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
                        url: "EditBooking.aspx/GetPickupCategories",
                        data: "{}",
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
                    url: "EditBooking.aspx/GetPickupItemsByCategory",
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
                        if ($('#ddlPickupItem option').length > 1) {
                            $('#ddlPickupItem').css('display', 'block');
                        }
                        else {
                            $('#ddlPickupItem').css('display', 'none');
                            //getMyTableTotal();
                        }
                        transferMyTableDataToConfirmItems();
                        //=============================================================
                    },
                    error: function (response) {
                    }
                });
            }

                function getPickupItemsByCategoryUsingItemId(PickupCategoryValue, PickupItemId) {
                $.ajax({
                    type: "POST",
                    url: "EditBooking.aspx/GetPickupItemsByCategory",
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
                            getMyTableTotal();
                        }
                        transferMyTableDataToConfirmItems();
                        //=============================================================
                    },
                    error: function (response) {
                    }
                });
            }

                function getPredefinedEstimatedValueByCategory() {
                var PickupCategory = $("#ddlPickupCategory").find("option:selected").text().trim();
                //alert('Text: ' + PickupCategory);

                $.ajax({
                    type: "POST",
                    url: "EditBooking.aspx/GetPredefinedEstimatedValueByCategory",
                    data: '{ PickupCategory: "' + PickupCategory + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        $("#txtPredefinedEstimatedValue").val(result.d);
                        getMyTableTotal();
                        transferMyTableDataToConfirmItems();
                        //New Code Added
                        //==================
                        if (PickupCategory == 'Other') {
                            $("#ddlPickupItem").css("display", "none");
                            $("#txtPickupItem").css("display", "block");
                            $("#txtEstimatedValue").val('0.00');
                            $("#txtPredefinedEstimatedValue").val('0.00');
                            $("#txtPickupItem").focus();

                            //New Button Added
                            //===========================================
                            $('#btnQuestion').css('display', 'block');
                            //===========================================

                            $('#myTable').addClass('incTblWidth');
                        }
                        else {
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
                        url: "EditBooking.aspx/GetPredefinedEstimatedValueByCategory",
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
                        url: "EditBooking.aspx/GetPredefinedEstimatedValueByCategory",
                        data: '{ PickupCategory: "' + PickupCategoryValue + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            $('#' + PredefinedEstimatedValueId).val(result.d);
                            
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

                            if (PickupCategoryValue == 'Other') {
                                $('#' + PickupItemId).css("display", "none");
                                $('#' + TextPickupItemId).css("display", "block");
                                $('#' + EstimatedValueId).val('0.00');
                                $('#' + PredefinedEstimatedValueId).val('0.00');
                                $('#' + TextPickupItemId).focus();

                                $('#' + PreDefinedValueId).val('0.00');
                                $('#' + PreDefinedValueId).attr("readonly", "readonly");

                                $('#' + EstimatedValueId).removeAttr("readonly");
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
                                $('#' + EstimatedValueId).attr("readonly", "readonly");
                                $('#' + PreDefinedValueId).removeAttr("readonly");
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
                    url: "EditBooking.aspx/GetPredefinedEstimatedValueByItem",
                    data: "{ PickupItem: '" + PickupItem + "'}",
                    dataType: "json",
                    success: function (result) {
                        $("#txtPredefinedEstimatedValue").val(result.d);
                        getMyTableTotal();
                        transferMyTableDataToConfirmItems();
                    },
                    error: function (response) {
                    }
                });
            }

            function getPredefinedEstimatedValueByItemValue(PickupItemValue, PredefinedEstimatedValueId) {

                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "EditBooking.aspx/GetPredefinedEstimatedValueByItem",
                        data: "{ PickupItem: '" + PickupItemValue + "'}",
                        dataType: "json",
                        success: function (result) {
                            $('#' + PredefinedEstimatedValueId).val(result.d);
                            getMyTableTotal();
                            transferMyTableDataToConfirmItems();
                        },
                        error: function (response) {
                        }
                    });
                }

        function getCustomerId() {

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "EditBooking.aspx/GetCustomerId",
                    data: "{}",
                    dataType: "json",
                    success: function (result) {
                        $("#<%=hfCustomerId.ClientID%>").val(result.d);
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
                    url: "EditBooking.aspx/GetBookingId",
                    data: "{}",
                    dataType: "json",
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
                    url: "EditBooking.aspx/GenerateQuoteId",
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

            function sendUpdateBookingEmail(EmailID, jQueryDataTableContent) {
                var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
                vErrMsg.text('');
                vErrMsg.css("display", "none");

                showStep3MandatoryFields();
                var timeDuration = 2000;

                var QuoteId = $("#<%=hfQuoteId.ClientID%>").val().trim();
                var CustomerId = $("#<%=hfEditCustomerId.ClientID%>").val().trim();
                var BookingId = $("#<%=hfEditBookingId.ClientID%>").val().trim();

                //objQuote = {};
                //objQuote.QuoteId = QuoteId;
                //objQuote.CustomerId = CustomerId;
                //objQuote.BookingId = BookingId;

                //$.ajax({
                //    type: "POST",
                //    contentType: "application/json; charset=utf-8",
                //    url: "EditBooking.aspx/AddQuote",
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
                    url: "EditBooking.aspx/SendUpdateBookingEmail",
                    data: "{ EmailID: '" + EmailID + "', jQueryDataTableContent: '" + jQueryDataTableContent + "', BookingId: '" + BookingId + "'}",
                    dataType: "json",
                    beforeSend: function () {
                        $( "#loaderDiv" ).show();

                        $( "#loaderQuotationText" ).hide();
                        $( "#successQuotationText" ).hide();
                        $( "#anchorHome" ).hide();

                        $( "#loaderBookingText" ).show().text( 'Please wait while we update your Booking Details' );
                        $( "#successBookingText" ).hide();
                        $( "#anchorHomeB" ).hide();

                        $( "#loaderImage" ).show();
                    },
                    success: function (result) {
                        //$( "#loaderDiv" ).show();

                        $( "#loaderQuotationText" ).hide();
                        $( "#successQuotationText" ).hide();
                        $( "#anchorHome" ).hide();

                        $( "#loaderBookingText" ).hide();
                        $( "#successBookingText" ).hide();
                        $( "#anchorHomeB" ).hide();

                        $( "#loaderImage" ).hide();

                        //New Code Added for Proceed To Payment Gateway
                        //===================================================================
                        var vFinalMovement = $('#<%=hfFinalMovement.ClientID%>').val().trim();
                        if ( vFinalMovement == "proceedToPaymentAfterBookingUpdate" )
                        {
                            //New Code Added for Pay at @ Collection
                            //===========================================================================
                            $('#lblCollectionAddress').text($('#<%=txtCollectionAddressLine1.ClientID%>').val().trim());
                            //===========================================================================

                            $('#payment-bx').modal('show');
                        }
                        else
                        {
                            $('#confirmUpdate-bx').modal('show');
                            gotoViewAllBookings();
                        }
                    },
                    error: function (response) {
                        $("#loaderDiv").hide();
                    }
                });

            }//end of function

        function uploadImageFile() {
            var files = "";

            var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();

            //New Code for Removing Existing Images
            //==========================================
            $.ajax({
                type: "POST",
                url: "EditBooking.aspx/RemoveImagePickup",
                contentType: "application/json; charset=utf-8",
                data: "{ BookingId: '" + BookingId + "'}",
                dataType: "json",
                success: function (result) {

              $("#myTable >tbody >tr").each(function () {
                var columnIdName = $(this).find("input[type=file]").attr('id');
                files = $('#' + columnIdName)[0].files;

                //New Lines Added
                //===========================
                var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
                var PickupCategory = $(this).find('select:eq(0)').find("option:selected").text().trim();
                var PickupItem = $(this).find('select:eq(1)').find("option:selected").text().trim();

                //var imgConcatenated = imgBookingId + "_" + imgPickupCategory + "_" + imgPickupItem + "_"
                //=============================

                    if (files.length > 0) {
                    var ImageName = "/images/items/" + files[0].name;

                    var formData = new FormData();
                    for (var i = 0; i < files.length; i++) {
                        formData.append(files[i].name, files[i]);
                    }

                    $.ajax({
                        url: '/UploadHandler.ashx',
                        method: 'post',
                        data: formData,
                        contentType: false,
                        processData: false,
                        success: function () {
                            //New Code for Image Insert
                            //==========================================
                            objIP = {};
                            objIP.ImagePickupId = "";
                            objIP.BookingId = BookingId;
                            objIP.CustomerId = CustomerId;
                            objIP.PickupCategory = PickupCategory;
                            objIP.PickupItem = PickupItem;
                            objIP.ImageName = ImageName;

                            $.ajax({
                                type: "POST",
                                url: "EditBooking.aspx/AddImagePickup",
                                contentType: "application/json; charset=utf-8",
                                data: JSON.stringify(objIP),
                                dataType: "json",
                                success: function (result) {

                                },
                                error: function (response) {

                                }
                            });//end of ImagePickup Entry
                        },
                        error: function (err) {
                            //alert(err.statusText)
                        }
                    });

                    //==========================================
                }//end of files length
            });//end of myTable each

                },
                error: function (response) {

                }
            });//end of Removing Existing Images

        }

    </script>

    <script>
        function checkCollectionDetails() {
            var CollectionName = $("#<%=txtCollectionName.ClientID%>");
            var vCollectionName = CollectionName.val().trim();

            var lblCollectionName = $("#<%=lblCollectionName.ClientID%>");
            lblCollectionName.text(vCollectionName);

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

            var PickupEmailAddress = $("#<%=txtPickupEmailAddress.ClientID%>");
            var vPickupEmailAddress = PickupEmailAddress.val().trim();

            var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            showCollectionMandatoryFields();

            //New Boolean Added
            bStep2 = true;

            if (vCollectionName == "") {
                vErrMsg.text('Enter Your Name in User Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionName.focus();

                bStep2 = false;
                return bStep2;
            }

            if (vCollectionAddressLine1 == "") {
                vErrMsg.text('Enter Your Address in User Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionAddressLine1.focus();

                bStep2 = false;
                return bStep2;
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
                vErrMsg.text('Enter Your Mobile in User Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionMobile.focus();

                bStep2 = false;
                return bStep2;
            }

            if (vCollectionMobile.length < 10) {
                vErrMsg.text('Invalid Mobile No in User Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                CollectionMobile.focus();

                bStep2 = false;
                return bStep2;
            }

            if ( vPickupEmailAddress == "" )
            {
                vErrMsg.text( 'Enter Your Email Address in User Details' );
                vErrMsg.css( "display", "block" );
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PickupEmailAddress.focus();

                bStep2 = false;
                return bStep2;
            }

            if ( !IsEmail( vPickupEmailAddress ) )
            {
                vErrMsg.text( 'Invalid Email Address in User Details' );
                vErrMsg.css( "display", "block" );
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PickupEmailAddress.focus();

                bStep2 = false;
                return bStep2;
            }

            return bStep2;
        }

        function checkDeliveryDetails() {
            var DeliveryName = $("#<%=txtDeliveryName.ClientID%>");
            var vDeliveryName = DeliveryName.val().trim();

            var lblDeliveryName = $("#<%=lblDeliveryName.ClientID%>");
            lblDeliveryName.text(vDeliveryName);

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

            var DeliveryEmailAddress = $("#<%=txtDeliveryEmailAddress.ClientID%>");
            var vDeliveryEmailAddress = DeliveryEmailAddress.val().trim();

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            hideCollectionMandatoryFields();
            showDeliveryMandatoryFields();

            //New Boolean Added
            bStep3 = true;

            if (vDeliveryName == "") {
                vErrMsg.text('Enter Your Name in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryName.focus();

                bStep3 = false;
                return bStep3;
            }

            if (vDeliveryAddressLine1 == "") {
                vErrMsg.text('Enter Your Address in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryAddressLine1.focus();

                bStep3 = false;
                return bStep3;
            }

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

                bStep3 = false;
                return bStep3;
            }

            if (vDeliveryMobile.length < 10) {
                vErrMsg.text('Invalid Mobile No in Recipient Details');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                DeliveryMobile.focus();

                bStep3 = false;
                return bStep3;
            }

            if ( vDeliveryEmailAddress != "" )
            {
                if ( !IsEmail( vDeliveryEmailAddress ) )
                {
                    vErrMsg.text( 'Invalid Email Address in Recipient Details' );
                    vErrMsg.css( "display", "block" );
                    //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                    DeliveryEmailAddress.focus();
                    return false;
                }
            }

            return bStep3;
        }

        function checkAllDetails()
        {
            bStep4 = false;

            if ( checkCollectionDetails() )
            {
                bStep4 = true;
                if (checkDeliveryDetails()) {
                    bStep4 = true;
                    //transferMyTableDataToConfirmItems();
                }
                else
                {
                    bStep4 = false;
                }
            }
            else
            {
                bStep4 = false;
            }

            return bStep4;
        }

        function checkConfirmation() {
            //var ConfirmEmailAddress = $("#<%=txtConfirmEmailAddress.ClientID%>");
            var ConfirmEmailAddress = $("#<%=txtPickupEmailAddress.ClientID%>");
            var vConfirmEmailAddress = ConfirmEmailAddress.val().trim();

            var chkConfirm = $("#<%=chkConfirm.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
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
            jQueryDataTableContent += "<strong>Total (inc. vat): </strong>£";
            //jQueryDataTableContent += "<i class=\'note-disclaimer\'>(inc. vat)<i>: £";
            jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

            sendQuoteByEmail(EmailID, jQueryDataTableContent);
            //sendQuoteByEmail("eniinfo4@gmail.com", jQueryDataTableContent);

            //setTimeout(function () {
            //    location.href = '/Dashboard.aspx';
            //}, 3000);
        }

        function calculateDetails()
        {
            var sNowTotal = $("#<%=spTotal.ClientID%>").text().trim();
            $("#<%=spCurrentBill.ClientID%>").text(sNowTotal);
            var fNowTotal = parseFloat(sNowTotal).toFixed(2);

            var sPreviousTotal = $("#<%=spEarlierPayment.ClientID%>").text().trim();
            var fPreviousTotal = parseFloat(sPreviousTotal).toFixed(2);

            var fHaveToPay = fNowTotal - fPreviousTotal;
            var sHaveToPay = fHaveToPay.toFixed(2).toString();

            //Displaying Popup Financial Contents in case of Payment or Refund
            $( "#strngBill" ).css( 'display', 'inline-block' );
            $( '#<%=spCurrentBill.ClientID%>' ).css( 'display', 'inline-block' );

            $( "#strngPay" ).css( 'display', 'inline-block' );
            $( '#<%=spEarlierPayment.ClientID%>' ).css( 'display', 'inline-block' );

            $( "#strng" ).css( 'display', 'inline-block' );
            $( '#<%=spHaveToPay.ClientID%>' ).css( 'display', 'inline-block' );

            $( '.note-disclaimer' ).css( 'display', 'inline-block' );

            if ( fHaveToPay < 0 )
            {
                $("#strng").text('You will get a Refund of: ');
                fHaveToPay = fPreviousTotal - fNowTotal;
                sHaveToPay = fHaveToPay.toFixed(2).toString();
            }
            else if ( fHaveToPay == 0 )
            {
                $( "#strng" ).text( 'No Payment Required. Go Back?' );
                sHaveToPay = "0.00";

                //Hiding Popup Financial Contents in case of No Payment or Refund
                $( "#strngBill" ).css( 'display', 'none' );
                $( '#<%=spCurrentBill.ClientID%>' ).css( 'display', 'none' );

                $( "#strngPay" ).css( 'display', 'none' );
                $( '#<%=spEarlierPayment.ClientID%>' ).css( 'display', 'none' );

                $( "#strng" ).css( 'display', 'none' );
                $( '#<%=spHaveToPay.ClientID%>' ).css( 'display', 'none' );

                $( '.note-disclaimer' ).css( 'display', 'none' );
            }

            $("#<%=spHaveToPay.ClientID%>").text(sHaveToPay);
            $('#edit-bx').modal('show');

            return false;
        }

        function sendEmailAfterConfirmation()
        {
            var hfChanged = $( '#<%=hfChanged.ClientID%>' ).val().trim();

            if ( hfChanged == 'Changed' )
            {
                if ( checkMyPackageDetails() )
                {
                    if ( checkAllDetails() )
                    {
                        if ( checkConfirmation() )
                        {
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
                            jQueryDataTableContent += "<strong>Total (inc. vat): </strong>£";
                            //jQueryDataTableContent += "<i class=\'note-disclaimer\'>(inc. vat)<i>: £";
                            jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                            //New Action Added based on Status
                            //=======================================
                            if ( bUpdate == true )
                            {
                                calculateDetails();
                            }
                            else {
                                //$( '#booking-bx' ).modal( 'show' );
                                $( '#gotoView-bx' ).modal( 'show' );
                            }
                            //=======================================
                        }

                    }//end of checkAllDetails
                }//end of checkMyPackageDetails

            }//end of Hidden Field Changed
            else
            {
                var chkConfirm = $( "#<%=chkConfirm.ClientID%>" );

                var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
                vErrMsg.text('');
                vErrMsg.css("display", "none");
                vErrMsg.css("background-color", "#f9edef");
                vErrMsg.css("color", "red");

                if ( !chkConfirm.is( ":checked" ) )
                {
                    vErrMsg.text("Please confirm the above details are correct");
                    vErrMsg.css("display", "block");
                    //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                    chkConfirm.focus();
                    return false;
                }
                else
                {
                    var vItemCountAtFirst = $( "#<%=htItemCountAtFirst.ClientID%>" ).val().trim();
                    var vItemCountAtLast = $('#<%=spItemCount.ClientID%>').text().trim();

                    if ( vItemCountAtFirst == vItemCountAtLast )
                    {
                        var vTotalValueAtFirst = $( '#<%=hfTotalValue.ClientID%>' ).val().trim();
                        var vTotalValueAtLast = $( '#<%=spTotal.ClientID%>' ).text().trim();

                        if ( vTotalValueAtFirst == vTotalValueAtLast )
                            $( '#gotoView-bx' ).modal( 'show' );
                        else
                            calculateDetails();
                    }
                    else
                        calculateDetails();
                }
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
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            //Saving Customer Details First
            var CustomerId = $("#<%=hfCustomerId.ClientID%>").val().trim();
            //var EmailID = $("#<%=txtConfirmEmailAddress.ClientID%>").val().trim();
            var EmailID = $("#<%=txtPickupEmailAddress.ClientID%>").val().trim();
            var Password = "";

            var FullName = $("#<%=txtCollectionName.ClientID%>").val().trim();
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

            var timeDuration = 2000;

            $.ajax({
                type: "POST",
                url: "EditBooking.aspx/AddCustomer",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objCustomer),
                dataType: "json",
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
                    else
                    {
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
                            fVAT = (fTotalCharge * 20) / 100;
                            VAT = fVAT.toFixed(2).toString();
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
                            url: "EditBooking.aspx/AddCharges",
                            data: JSON.stringify(objCharges),
                            dataType: "json",
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

                    var DeliveryName = $("#<%=txtDeliveryName.ClientID%>").val().trim();
                    var DeliveryMobile = $("#<%=txtDeliveryMobile.ClientID%>").val().trim();

                    var PickupPostCode = $("#<%=txtCollectionPostCode.ClientID%>").val().trim();
                    var DeliveryPostCode = $("#<%=txtDeliveryPostCode.ClientID%>").val().trim();
                    //======================================================
                    var Bookingdate = getCurrentDateDetails();

                    //A Couple of New Fields Added
                    //=========================================================================
                    var PickupEmail = $( '#<%=txtPickupEmailAddress.ClientID%>' ).val().trim();
                    var DeliveryEmail = $( '#<%=txtDeliveryEmailAddress.ClientID%>' ).val().trim();
                    //=========================================================================

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

                    objBooking.DeliveryName = DeliveryName;
                    objBooking.DeliveryMobile = DeliveryMobile;

                    objBooking.PickupPostCode = PickupPostCode;
                    objBooking.DeliveryPostCode = DeliveryPostCode;
                    //======================================================

                    objBooking.Bookingdate = Bookingdate;

                    //A Couple of New Fields Added
                    //=========================================================================
                    objBooking.PickupEmail = PickupEmail;
                    objBooking.DeliveryEmail = DeliveryEmail;
                    //=========================================================================

                    objBooking.IsAssigned = IsAssigned;
                    objBooking.WhetherOtherExists = WhetherOtherExists;

                    $.ajax({
                        type: "POST",
                        url: "EditBooking.aspx/AddBookingOperation",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(objBooking),
                        dataType: "json",
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
                                    url: "EditBooking.aspx/AddBookPickup",
                                    contentType: "application/json; charset=utf-8",
                                    data: JSON.stringify(objBP),
                                    dataType: "json",
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
                jQueryDataTableContent += "<strong>Total (inc. vat): </strong>£";
                //jQueryDataTableContent += "<i class=\'note-disclaimer\'>(inc. vat)<i>: £";
                jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                //Booking Mail
                sendBookingByEmail(EmailID, jQueryDataTableContent);

                var BookingId = $("#<%=hfBookingId.ClientID%>").val().trim();
                setTimeout(function () {
                    location.href = '/ProceedToPayment.aspx?BookingId=' + BookingId;
                }, 3000);
            }

        function proceedToPaymentGatewayPage()
        {
            var BookingId = $( "#<%=hfEditBookingId.ClientID%>" ).val().trim();
            var HaveToPay = $( "#<%=spHaveToPay.ClientID%>" ).text().trim();

            setTimeout( function ()
            {
                location.href = '/ProceedToPayment.aspx?BookingId=' + BookingId + '&HaveToPay=' + HaveToPay;
            }, 1000 );
            
            return false;
        }

        function proceedToPaymentAfterBookingUpdate()
        {
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
                jQueryDataTableContent += "<strong>Total (inc. vat): </strong>£";
                //jQueryDataTableContent += "<i class=\'note-disclaimer\'>(inc. vat)<i>: £";
                jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                $( '#<%=hfFinalMovement.ClientID%>' ).val( 'proceedToPaymentAfterBookingUpdate' );
                sendUpdateBookingEmail(EmailID, jQueryDataTableContent);
                //sendUpdateBookingEmail("eniinfo4@gmail.com", jQueryDataTableContent);

                return false;
          }

        function gotoViewAllBookings()
        {
            setTimeout( function ()
            {
                location.href = '/ViewAllOfMyBookings.aspx';
            }, 1000 );

            return false;
        }

        function goHome()
        {
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
                jQueryDataTableContent += "<strong>Total (inc. vat): </strong>£";
                //jQueryDataTableContent += "<i class=\'note-disclaimer\'>(inc. vat)<i>: £";
                jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                sendUpdateBookingEmail(EmailID, jQueryDataTableContent);

            return false;
        }

          function goHomeAfterBookingUpdate() {
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
                jQueryDataTableContent += "<strong>Total (inc. vat): </strong>£";
                //jQueryDataTableContent += "<i class=\'note-disclaimer\'>(inc. vat)<i>: £";
                jQueryDataTableContent += $("#<%=spTotal.ClientID%>").text().trim();

                $( '#<%=hfFinalMovement.ClientID%>' ).val( 'goHomeAfterBookingUpdate' );
                sendUpdateBookingEmail(EmailID, jQueryDataTableContent);
                //sendUpdateBookingEmail("eniinfo4@gmail.com", jQueryDataTableContent);

                return false;
            }

        function placeOrder() {
            saveBooking();
            setTimeout(function () { }, 3000);

            return false;
        }

        //New Function Added
        function editOrder() {
            debugger;
            ///alert('hiiii');
            var BookingId = $("#<%=hfEditBookingId.ClientID%>").val().trim();
            var CustomerId = $("#<%=hfEditCustomerId.ClientID%>").val().trim();

            uploadImageFile();

            var PickupCategory = "";
            var PickupItem = "";
            var IsFragile = "";
            var EstimatedValue = "";
            //==========================
            var PredefinedEstimatedValue = "";
            //==========================

            var ItemCount = $("#<%=spItemCount.ClientID%>").text().trim();
            var TotalValue = $("#<%=spTotal.ClientID%>").text().trim();

            //Removing Old BookPickup Data
            $.ajax({
                type: "POST",
                url: "EditBooking.aspx/RemoveBookPickup",
                contentType: "application/json; charset=utf-8",
                data: "{ BookingId: '" + BookingId + "'}",
                dataType: "json",
                success: function (result) {
                    //Saving Latest BookPickup Data
                    $('#tblConfirmItems tbody > tr').each(function () {
                        PickupCategory = $(this).find('td:eq(0)').text().trim();
                        PickupItem = $(this).find('td:eq(1)').text().trim();
                        IsFragile = $(this).find('td:eq(2)').text().trim();

                        if (IsFragile == 'Yes') IsFragile = "True";
                        if (IsFragile == 'No') IsFragile = "False";

                        EstimatedValue = $(this).find('td:eq(3)').text().trim();
                        //==========================
                        PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();
                        //==========================

                        objBP = {};
                        objBP.PickupId = "";
                        objBP.BookingId = BookingId;
                        objBP.CustomerId = CustomerId;
                        objBP.PickupCategory = PickupCategory;
                        objBP.PickupItem = PickupItem;
                        objBP.IsFragile = IsFragile;
                        objBP.EstimatedValue = EstimatedValue;
                        //==========================
                        objBP.PredefinedEstimatedValue = PredefinedEstimatedValue;
                        //==========================

                        $.ajax({
                            type: "POST",
                            url: "EditBooking.aspx/AddBookPickup",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(objBP),
                            dataType: "json",
                            success: function (result) {

                            },
                            error: function (response) {

                            }
                        });

                    });//end of 'Saving Latest BookPickup Data'

                    var RegisteredCompanyName = $("#<%=txtCompanyName.ClientID%>").val().trim();
                    var InsurancePremium = $("#<%=txtInsurancePremium.ClientID%>").val().trim();

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
                            url: "EditBooking.aspx/AddCharges",
                            data: JSON.stringify(objCharges),
                            dataType: "json",
                            success: function (result) {

                            },
                            error: function (response) {

                            }
                        });//end of Quote Entry
                    });

                    var PickupAddress = $("#<%=txtCollectionAddressLine1.ClientID%>").val().trim();
                    var RecipentAddress = $("#<%=txtDeliveryAddressLine1.ClientID%>").val().trim();

                    var PostCode = $("#<%=txtCollectionPostCode.ClientID%>").val().trim();

                    //New Fields Added for Order Booking 
                    //====================================================
                    var CollectionName = $("#<%=txtCollectionName.ClientID%>").val().trim();
                    var CollectionMobile = $("#<%=txtCollectionMobile.ClientID%>").val().trim();

                    var DeliveryName = $("#<%=txtDeliveryName.ClientID%>").val().trim();
                    var DeliveryMobile = $("#<%=txtDeliveryMobile.ClientID%>").val().trim();

                    var CollectionPostCode = $("#<%=txtCollectionPostCode.ClientID%>").val().trim();
                    var DeliveryPostCode = $("#<%=txtDeliveryPostCode.ClientID%>").val().trim();

                    var LatitudePickup = $("#<%=hfPickupLatitude.ClientID%>").val().trim();
                    var LongitudePickup = $("#<%=hfPickupLongitude.ClientID%>").val().trim();

                    var LatitudeDelivery = $("#<%=hfDeliveryLatitude.ClientID%>").val().trim();
                    var LongitudeDelivery = $("#<%=hfDeliveryLongitude.ClientID%>").val().trim();
                    //====================================================

                    var Bookingdate = getCurrentDateDetails();

                    //A Couple of New Fields Added
                    //=========================================================================
                    var PickupEmail = $( '#<%=txtPickupEmailAddress.ClientID%>' ).val().trim();
                    var DeliveryEmail = $( '#<%=txtDeliveryEmailAddress.ClientID%>' ).val().trim();
                    //=========================================================================

                    var IsAssigned = 'false';

                    //Checking must be done for PickupCategory "Other" and its Price
                    //==================================================================
                    var WhetherOtherExists = 'false';

                    $('#tblConfirmItems tbody > tr').each(function () {
                        PickupCategory = $(this).find('td:eq(0)').text().trim();
                        PredefinedEstimatedValue = $(this).find('td:eq(4)').text().trim();

                        if (PickupCategory == "Other") {
                            if (PredefinedEstimatedValue == "0.00") {
                                WhetherOtherExists = 'true';
                            }
                        }
                    });
                    //==================================================================

                    //Updating Booking Details
                    $.ajax({
                        type: "POST",
                        url: "EditBooking.aspx/UpdateBookingDetails",
                        contentType: "application/json; charset=utf-8",
                        data: "{ BookingId: '" + BookingId
                            + "', RegisteredCompanyName: '" + RegisteredCompanyName
                            + "', InsurancePremium: '" + InsurancePremium
                            + "', PickupAddress: '" + PickupAddress
                            + "', RecipentAddress: '" + RecipentAddress
                            + "', ItemCount: '" + ItemCount
                            + "', TotalValue: '" + TotalValue
                            + "', PostCode: '" + PostCode

                    //New Fields Added for Order Booking 
                    //====================================================
                            + "', CollectionName: '" + CollectionName
                            + "', CollectionMobile: '" + CollectionMobile
                            + "', DeliveryName: '" + DeliveryName
                            + "', DeliveryMobile: '" + DeliveryMobile

                            + "', CollectionPostCode: '" + CollectionPostCode
                            + "', DeliveryPostCode: '" + DeliveryPostCode

                            + "', LatitudePickup: '" + LatitudePickup
                            + "', LongitudePickup: '" + LongitudePickup
                            + "', LatitudeDelivery: '" + LatitudeDelivery
                            + "', LongitudeDelivery: '" + LongitudeDelivery

                            + "', Bookingdate: '" + Bookingdate

                            + "', PickupEmail: '" + PickupEmail
                            + "', DeliveryEmail: '" + DeliveryEmail

                            + "', IsAssigned: '" + IsAssigned

                            + "', WhetherOtherExists: '" + WhetherOtherExists
                    //===========================================================
                            + "'}",
                        dataType: "json",
                        success: function (result) {
                            var vStrongText = $( "#strng" ).text().trim();

                            //Mail to be thrown and Page to be redirected
                            switch ( vStrongText )
                            {
                                case "You will get a Refund of:":
                                    goHomeAfterBookingUpdate();
                                    break;
                                case "So, now you have to Pay:":
                                    proceedToPaymentAfterBookingUpdate();
                                    break;
                                case "No Payment Required. Go Back?":
                                    goHome();
                                    break;
                            }
                        },
                        error: function (response) {

                        }
                    });//end of 'Updating Booking Details'
                },
                error: function (response) {

                }
            });//end of 'Removing Old BookPickup Data'

            return false;
        }

        function cancelEdit()
        {
            setTimeout( function ()
            {
                location.href = '/ViewAllOfMyBookings.aspx';
            }, 1000 );

            return false;
        }
    </script>

    <style>
        #CollectionMap, #DeliveryMap {
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
            var latlng = new google.maps.LatLng( $("#<%=hfPickupLatitude.ClientID%>").val(), $("#<%=hfPickupLongitude.ClientID%>").val() );

            var myCollectionOptions = {
                zoom: 6,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var CollectionMap = new google.maps.Map(document.getElementById("CollectionMap"), myCollectionOptions);

            var latlng = new google.maps.LatLng( $("#<%=hfDeliveryLatitude.ClientID%>").val(), $("#<%=hfDeliveryLongitude.ClientID%>").val() );

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
                    //document.getElementById( "CollectionMap" ).style.width = document.getElementById( "<%=txtCollectionAddressLine1.ClientID%>" ).style.width;
                    document.getElementById( "<%=lblCollectionAddressLine1.ClientID%>" ).innerText = document.getElementById( "<%=txtCollectionAddressLine1.ClientID%>" ).value;
                    //alert( 'Collection Place Changed' );
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
                    //document.getElementById("DeliveryMap").style.width = document.getElementById("<%=txtDeliveryAddressLine1.ClientID%>").style.width;
                    document.getElementById( "<%=lblDeliveryAddressLine1.ClientID%>" ).innerText = document.getElementById( "<%=txtDeliveryAddressLine1.ClientID%>" ).value;
                    //alert( 'Delivery Place Changed' );
                } );

            });
    }
    </script>

    <script>
        function fillCollectionName()
        {
           $('#<%=lblCollectionName.ClientID%>').text($('#<%=txtCollectionName.ClientID%>').val());
        }
        function fillCollectionAddressLine1()
        {
           $('#<%=lblCollectionAddressLine1.ClientID%>').text($('#<%=txtCollectionAddressLine1.ClientID%>').val());
        }
        function fillCollectionPostCode()
        {
           $('#<%=lblCollectionPostCode.ClientID%>').text($('#<%=txtCollectionPostCode.ClientID%>').val());
        }
        function fillCollectionMobile()
        {
           $('#<%=lblCollectionMobile.ClientID%>').text($('#<%=txtCollectionMobile.ClientID%>').val());
        }
        function fillDeliveryName()
        {
           $('#<%=lblDeliveryName.ClientID%>').text($('#<%=txtDeliveryName.ClientID%>').val());
        }
        function fillDeliveryAddressLine1()
        {
           $('#<%=lblDeliveryAddressLine1.ClientID%>').text($('#<%=txtDeliveryAddressLine1.ClientID%>').val());
        }
        function fillDeliveryPostCode()
        {
           $('#<%=lblDeliveryPostCode.ClientID%>').text($('#<%=txtDeliveryPostCode.ClientID%>').val());
        }
        function fillDeliveryMobile()
        {
           $('#<%=lblDeliveryMobile.ClientID%>').text($('#<%=txtDeliveryMobile.ClientID%>').val());
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-md-12">
        <div class="row">
            <!-- MultiStep Form -->
            <div class="col-md-11">
                <form id="msform" runat="server" class="accordianEB_main" novalidate="novalidate">
                    <fieldset class="next-mov" id="dvStep1">

                        <div class="panel-group accordianEB" id="accordianEB" role="tablist" aria-multiselectable="true">

                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="headingOne">
                                    <h4 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordianEB" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                            <i class="fa fa-building"></i> Registered Company
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                    <div class="panel-body">
                                        <label for="registered-company" class="control-label">Do you have a registered company in UK?</label>
                                        <asp:DropDownList ID="ddlRegisteredCompany" runat="server"
                                            CssClass="vat-option"
                                            onchange="return checkDropDownValue();">
                                            <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                        </asp:DropDownList>

                                        <br />
                                        <div id="dvGoodsInName" style="display: none;" runat="server">
                                            <label for="goods-in-name" class="control-label">If Yes, please mention the name of the company</label>
                                            <asp:TextBox ID="txtCompanyName" runat="server" MaxLength="100"
                                                CssClass="form-control"  PlaceHolder="e.g. XYZ LTD" title="Please enter Company Name"
                                                onkeypress="valueChanged();AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>

                                            <label for="goods-in-name" class="control-label">If Yes, are you shipping the goods in the name of the company?</label>
                                            <asp:DropDownList ID="ddlGoodsInName" runat="server"
                                                CssClass="vat-option" onchange="clearErrorMessage();getMyTableTotal();">
                                                <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                                <asp:ListItem Value="0">No</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordianEB" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                            <i class="fa fa-shirtsinbulk"></i> Insurance Premium
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                        <label for="registered-company" class="control-label">Have you got insurance?</label>
                                        <asp:DropDownList ID="ddlInsurance" runat="server"
                                            CssClass="vat-option"
                                            onchange="checkInsuranceValue();getMyTableTotal();">
                                            <asp:ListItem Selected="True">Please Select</asp:ListItem>
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                            <asp:ListItem Value="2">I am not interested</asp:ListItem>
                                        </asp:DropDownList>

                                        <!-- New TextBox added for Insurance Premium -->
                                        <div id="dvInsurancePremium" style="display: none;" runat="server">
                                            <label for="insurance-premium" class="control-label">If No, please pay the Insurance Premium</label>
                                            <asp:TextBox ID="txtInsurancePremium" runat="server" MaxLength="100"
                                                CssClass="form-control" PlaceHolder="e.g. £10.00" title="Please pay the Insurance Premium"
                                                onkeypress="valueChanged();DecimalOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="headingThree">
                                    <h4 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordianEB" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                            <i class="fa fa-archive"></i> Item Details
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                    <div class="panel-body">
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
                                                                <h3 class="fs-subtitle">Predefined Value</h3>
                                                            </td>
                                                            <td></td>
                                                            <td></td>                                                                                                                          
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td class="col-sm-3 col-xs-12">
                                                                <select id="ddlPickupCategory" name="pickupCategory[]"  class="itemcatPickup"
                                                                    title="Please select a Pickup Category from dropdown" 
                                                                    onchange="getPredefinedEstimatedValueByCategory();clearErrorMessage();hideQuestionBoxIfExists();">
                                                                    <option value="">Pickup Category</option>
                                                                </select>

                                                            </td>
                                                            <td class="col-sm-3 col-xs-12">
                                                                <select id="ddlPickupItem" name="pickupItem[]"  class="items"
                                                                    title="Please select a Pickup Item from dropdown"
                                                                    onchange="getPredefinedEstimatedValueByItem();clearErrorMessage();">
                                                                    <option value="">Pickup Item</option>
                                                                </select>
                                                                <input type="text" id="txtPickupItem" class="" style="display: none;"
                                                                    title="Please enter value for 'Others' Category"
                                                                    placeholder="Please enter value"
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
                                                                maxlength="10" title="Please enter Estimated Value is correct" type="text"
                                                                onkeypress="DecimalOnly(event);clearErrorMessage();restrictToOneDot(event, this.value);"
                                                                onblur="blurEstimatedValue();" />

                                                            </td>
                                                            <td class="col-sm-2 col-xs-12">
                                                                <label class="float_label">£</label>
                                                                <input id="txtPredefinedEstimatedValue" name="predefinedestimatedValue[]" 
                                                                class="estimatevalue" placeholder="e.g. £123.45" readonly="readonly" 
                                                                title="Price" type="text" />
                                                            </td>

                                            <!--New td added for 'Other' information-->
                                            <!--====================================-->
                                            <td class="col-sm-2 col-xs-12">
                                                <button id="btnQuestion" class="question-mark" style="display: none;" 
                                                    onclick="return showOtherInfo();">
                                                <i class="fa fa-question-circle" aria-hidden="true"></i></button>
                                            </td>
                                            <!--====================================-->

                                                            <td class="col-sm-1 col-xs-12">
                                                                <label class="brwsBtn" for="upload1">
                                                                    Upload an image (optional)
                                                                    <input class="isVisuallyHidden" id="upload1" name="upload[]" type="file" 
                                                                        accept="image/*" onchange="loadFile(event, 'output1')" />
                                                                </label>
                                                            </td>

                                                            <td class="col-sm-1 col-xs-12">
                                                                <a class="btn-danger deleteRow btn-sm ibtnDel">
                                                                    <span class="glyphicon glyphicon-minus remove"></span>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                            
                                                    <tfoot>
                                                        <tr>
                                                            <td style="height: 20px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-6 col-xs-12" style="width: 180px !important; margin-right:10px;">
                                                                <button class="btn btn-success aa-add-row" type="button" style="width: 180px !important;" 
                                                                    id="btnBookPickupAddRow" onclick="return addRowBookPickup();">
                                                                    <span class="glyphicon glyphicon-plus add" 
                                                                        style="padding-right: 10px"></span> Add Row
                                                                </button>              
                                                            </td>

                                                            <td class="col-sm-6 col-xs-12" style="width: 180px !important">
                                                                <button class="btn btn-success aa-add-row" type="button" style="width: 180px !important;"
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
                                                            <td style="width:100% !important;">
                                                                <ul id="ulOutput" style="list-style: none;">
                                                                    <li style="display: none;">
                                                                        <img id="output1" src="#" height="50" width="50" />
                                                                    </li>
                                                                </ul>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="col-sm-12 col-xs-12 table-responsive" style="padding:0 !important;">
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
                                                <table class="tblInfo table">
                                                        <tr>
                                                            <td>
                                                                <div style="text-align: left;">
                                                                    <strong>No of Items </strong>
                                                                        <i class="note-disclaimer"><i>:
                                                                        <span id="spItemCount" runat="server">0</span></i></i>
                                                                </div>   
                                                            </td>
                                                            <td> 
                                                                
                                                                <div class="taxDetails_container">
                                                                <table id="tblTaxDetails" class="tbl_TaxDetails">
                                                                    <tbody>
                                    
                                                                        </tbody>
                                                                </table>
                                                            </div>
                                                                              
                                                                <div style="text-align: right; display:none;">
                                                                    <strong>Total </strong>
                                                                    <i class="note-disclaimer">(inc. vat)<i>: £
                                                                    <span id="spTotal" runat="server">0.0</span></i></i>              
                                                                </div>
                                                            </td>
                                                        </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                
                		    <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="heading4">
                                    <h4 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordianEB" href="#collapse4" aria-expanded="false" aria-controls="collapse6">
                                            <i class="fa fa-calendar"></i> Collection Date and Agreement
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapse4" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading4">
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="control-group">
                                                <div class="col-md-4">
                                                    <label class="control-label" for="collection-date">Collection Date <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-8 col-xs-12">
                                                    <div class="input-group date">
                                                        <input id="txtCollectionDate" type="text" class="form-control" 
                                                            runat="server" readonly="true" onchange="valueChanged();" />
                                                        <span class="input-group-addon">
                                                                <i class="glyphicon glyphicon-th"></i></span>
                                                    </div>                                                            
                                                </div>
                                            </div>
                                        </div>

                                        <!--<script src="/js/bootstrap-datetimepicker.js"></script>-->
                                        <script src="/js/bootstrap-datepicker.js"></script>
                                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                               
                                        <div class="row">                                                    
                                            <div class="col-md-12 col-xs-12">
                                                <label class="control-label" for="conditions">
                                                    I have read and agree to the <a href="/prohibited" target="_blank">Prohibited &amp; Restricted items list*</a>
                                                    &nbsp;<asp:CheckBox ID="chkAgree" runat="server"
                                                        onchange="clearErrorMessage();" CssClass="lastChk" />
                                                </label>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                
                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="heading5">
                                    <h4 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordianEB" href="#collapse5" aria-expanded="false" aria-controls="collapse5">
                                            <i class="fa fa-file-text"></i> User Details
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapse5" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading5">
                                    <div class="panel-body">
                                        <div class="address-details">
                                            <div class=""><!--quote-box-->
                                                <div class="details">
                                                    <div class="row">
                                                        <div class="form-group">
                                                            <div class="col-md-3 col-xs-12">
                                                                <label class="control-label" for="collection-title">Name <span style="color: red">*</span>:</label>
                                                            </div>
                                                            <div class="col-md-9 col-xs-12">
                                                                <asp:TextBox ID="txtCollectionName" runat="server" MaxLength="50"
                                                                    CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter Name"
                                                                    onkeypress="valueChanged();CharacterOnly(event);clearErrorMessage();"
                                                                    onkeyup="fillCollectionName();"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="form-group address-field">
                                                            <div class="col-md-3 col-xs-12">
                                                                <label class="control-label" for="collection-address" data-label-prepend="Collection: ">Address <span style="color: red">*</span>:</label>
                                                            </div>
                                                            <div class="col-md-9 col-xs-12">
                        <input type="text" id="txtCollectionAddressLine1" class="form-control" 
                        placeholder="Enter a Collection Location" title="Please enter Address for Collection"
                        onkeypress="valueChanged();clearErrorMessage();" onkeyup="fillCollectionAddressLine1();" runat="server" />
                        <div id="CollectionMap"></div>    
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="form-group">
                                                            <div class="col-sm-12 col-xs-12">
                                                                <div class="row">
                                                                    <div class="col-md-3 col-xs-12">
                                                                        <label class="control-label postcode-label" for="collection-postcode" data-label-prepend="Collection: ">&nbsp;&nbsp;&nbsp;Post Code::</label>
                                                                    </div>
                                                                    <div class="col-md-9 col-xs-12">
                                                                        <asp:TextBox ID="txtCollectionPostCode" runat="server" CssClass="form-control" 
                                                                            PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                                                            onkeypress="valueChanged();clearErrorMessage();" onkeyup="fillCollectionPostCode();"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="form-group ovrFlwnone">
                                                            <div class="col-md-3 col-xs-12">
                                                                <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Contact No <span style="color: red">*</span>:</label>
                                                            </div>
                                                            <div class="col-md-9 col-xs-12">
                                                                <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                            <input id="txtCollectionMobile" class="flag-tel" type="tel" placeholder="Enter Phone Number" 
                                onkeypress="valueChanged();NumericOnly(event);clearErrorMessage();" onkeyup="fillCollectionMobile();" runat="server" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row" id="dvPickupEmailAddress">
                                                        <div class="col-md-3 col-xs-12">
                                                            <label class="control-label" for="quoteEmail" data-label-premend="Your " 
                                                                data-label-append=" for a quote">Pickup Email Address <span style="color: red">*</span>:</label>
                                                        </div>
                                                        <div class="col-md-9 col-xs-12">
                                                        <asp:TextBox ID="txtPickupEmailAddress" runat="server"
                                                            CssClass="form-control" PlaceHolder="example@gmail.com"
                                                            title="Please enter Pickup Email Address" Style="text-transform: lowercase;"
                                                            MaxLength="255" onkeypress="valueChanged();clearErrorMessage();"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!--end of collection filed-->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        
                            <div class="panel panel-default">
                                <div class="panel-heading" role="tab" id="heading6">
                                    <h4 class="panel-title">
                                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordianEB" href="#collapse6" aria-expanded="false" aria-controls="collapse6">
                                            <i class="fa fa-truck"></i> Recipient Details
                                        </a>
                                    </h4>
                                </div>
                                <div id="collapse6" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading6">
                                    <div class="panel-body">
                                        <div class=""><!--quote-box-->
                                            <div class="details">
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-md-3 col-xs-12">
                                                            <label class="control-label" for="collection-title">Name <span style="color: red">*</span>:</label>
                                                        </div>
                                                        <div class="col-md-9 col-xs-12">
                                                            <asp:TextBox ID="txtDeliveryName" runat="server" MaxLength="50"
                                                                CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter Name"
                                                                onkeypress="valueChanged();CharacterOnly(event);clearErrorMessage();"
                                                                onkeyup="fillDeliveryName();"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group address-field">
                                                        <div class="col-md-3 col-xs-12">
                                                            <label class="control-label" for="collection-address" data-label-prepend="Collection: ">Address <span style="color: red">*</span>:</label>
                                                        </div>
                                                        <div class="col-md-9 col-xs-12">
                    <input type="text" id="txtDeliveryAddressLine1" class="form-control" 
                    placeholder="Enter a Delivery Location" title="Please enter Address for Delivery"
                    onkeypress="valueChanged();clearErrorMessage();" onkeyup="fillDeliveryAddressLine1();" runat="server" />
                    <div id="DeliveryMap"></div>    

                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group">
                                                        <div class="col-sm-12 col-xs-12">
                                                            <div class="row">
                                                                <div class="col-md-3 col-xs-12">
                                                                    <label class="control-label postcode-label" for="collection-postcode" data-label-prepend="Collection: ">&nbsp;&nbsp;&nbsp;House number:</label>
                                                                </div>
                                                                <div class="col-md-9 col-xs-12">
                                                                    <asp:TextBox ID="txtDeliveryPostCode"  runat="server" CssClass="form-control"
                                                                        PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                                                        onkeypress="valueChanged();clearErrorMessage();" onkeyup="fillDeliveryPostCode();"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group ovrFlwnone">
                                                        <div class="col-md-3 col-xs-12">
                                                            <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Contact No <span style="color: red">*</span>:</label>
                                                        </div>
                                                        <div class="col-md-9 col-xs-12">
                                                            <div class="input-group" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890" style="width:100%;">
                        <input id="txtDeliveryMobile" class="flag-tel" type="tel" placeholder="Enter Phone Number" 
                            onkeypress="valueChanged();NumericOnly(event);clearErrorMessage();" onkeyup="fillDeliveryMobile();" runat="server" />

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row" id="dvDeliveryEmailAddress">
                                                    <div class="col-md-3 col-xs-12">
                                                        <label class="control-label" for="quoteEmail" data-label-premend="Your " 
                                                            data-label-append=" for a quote">Delivery Email Address<br />(Optional):</label>
                                                    </div>
                                                    <div class="col-md-9 col-xs-12">
                                                        <asp:TextBox ID="txtDeliveryEmailAddress" runat="server"
                                                            CssClass="form-control" PlaceHolder="example@gmail.com"
                                                            title="Please enter Delivery Email Address" Style="text-transform: lowercase;"
                                                            MaxLength="255" onkeypress="valueChanged();clearErrorMessage();"></asp:TextBox>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div><!-- panel-group -->

                        <!--Confirm Section outside of Panel Group-->
                        <!--======================================-->
                        <asp:HiddenField ID="hfCustomerId" runat="server" />
                        <asp:HiddenField ID="hfBookingId" runat="server" />
                        <asp:HiddenField ID="hfQuoteId" runat="server" />

                        <asp:HiddenField ID="hfEditBookingId" runat="server" />
                        <asp:HiddenField ID="hfEditCustomerId" runat="server" />
                        <asp:HiddenField ID="hfItemCount" runat="server" Value="1" />
                        <asp:HiddenField ID="hfTotalValue" runat="server" />

                        <asp:HiddenField ID="hfChanged" runat="server" />

                        <asp:HiddenField ID="hfPickupLatitude" runat="server" />
                        <asp:HiddenField ID="hfPickupLongitude" runat="server" />
                        <asp:HiddenField ID="hfDeliveryLatitude" runat="server" />
                        <asp:HiddenField ID="hfDeliveryLongitude" runat="server" />

                        <!--No of Items at the very beginning-->
                        <asp:HiddenField ID="htItemCountAtFirst" runat="server" />

                        <!-- Final Movement from this Page to either Home OR Payment -->
                        <asp:HiddenField ID="hfFinalMovement" runat="server" />

                        <div class="row">
                            <div class="col-md-12">
                                <div class="dvCNFRM">
                                    <h2 class="">Confirm your Collection and Recipient Details</h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <h4>Pickup Address</h4>
                                                    <p class="nameBLD"><asp:Label ID="lblCollectionName" runat="server" Text=""></asp:Label></p>
                                                    <p><asp:Label ID="lblCollectionAddressLine1" runat="server" Text=""></asp:Label></p>
                                                    <p><asp:Label ID="lblCollectionPostCode" runat="server" Text=""></asp:Label></p>
                                                    <p><i class="fa fa-phone fa-lg"></i>
                                                        <asp:Label ID="lblCollectionMobile" runat="server" Text=""></asp:Label>
                                                    </p>
                                                </div>

                                                <div class="col-md-6 rgtALNG">
                                                    <h4>Delivery Address</h4>
                                                    <p class="nameBLD"><asp:Label ID="lblDeliveryName" runat="server" Text=""></asp:Label></p>
                                                    <p><asp:Label ID="lblDeliveryAddressLine1" runat="server" Text=""></asp:Label></p>
                                                    <p><asp:Label ID="lblDeliveryPostCode" runat="server" Text=""></asp:Label></p>
                                                    <p><i class="fa fa-phone fa-lg"></i> 
                                                        <asp:Label ID="lblDeliveryMobile" runat="server" Text=""></asp:Label>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-12">
                                <div class="dvCNFRM">
                                    <h2 class="">Confirm your Item details</h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="confirm-box">
                                                <div class="confirm-details">
                                                    <div class="">
                                                        <div class="row">
                                                            <div class="confirm-items table-responsive">
                                                                <table class="table table-bordered label-lgt" id="tblConfirmItems" style="width: 100%;">
                                                                    <thead class="jsTblH">
                                                                        <tr>
                                                                            <th scope="col">Pickup Category</th>
                                                                            <th scope="col">Pickup Item</th>
                                                                            <th scope="col">Fragile</th>
                                                                            <th scope="col">Estimated Value</th>
                                                                            <th scope="col">Price</th>                                                            
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody></tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                        <div class="table9">
                                                            <table id="tblTaxDetailsConfirmation">
                                                                <tbody>
                                                    
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                        <br />
                                                        <div class="row">
                                                            <div class="col-md-4 col-sm-3 col-xs-12">
                                                                <label style="color:#fff;"><b style="font-weight: bolder;">To be collected:</b></label>
                                                            </div>
                                                            <div class="col-md-8 col-sm-9 col-xs-12">
                                                                <span class="confirm-collection-date label-lgt cmnLabel">
                                                                    <asp:Label ID="lblConfirmCollectionDate" runat="server" Text=""
                                                                      Font-Bold="true" style="font-weight: bolder;"></asp:Label>
                                                                </span>
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

                        <div class="row">
                            <div class="col-md-12">
                                <div class="dvCNFRM">
                                    <!--<h2 class="">Send Booking Details To</h2>-->
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="" style="display: none;">
                                                <div class="row">
                                                    <div class="col-md-4 col-sm-3 col-xs-12">
                                                        <label class="control-label" for="quoteEmail" data-label-premend="Your " data-label-append=" for a quote" style="color:#fff;">Email Address<span style="color: red">*</span>:</label>
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
                                </div>
                            </div>
                        </div>

                        
                        <!--======================================-->
                        <!-- End of Confirm Section outside Panel Group-->

                        <div class="col-md-12 col-xs-12">
                            <asp:Label ID="lblErrMsg" CssClass="ErrMsg" BackColor="#f9edef"
                            Style="text-align: center; vertical-align: middle; width: 500px; line-height: 30px; border-radius: 0px; padding: 0px;"
                            runat="server" Text="" Font-Size="Small"></asp:Label>
                        </div>

                        <asp:Button ID="btnSendQuote" runat="server" Text="Confirm" CssClass="action-button"
                            OnClientClick="return sendEmailAfterConfirmation();" />
                        <input type="button" name="cancelQuote" class="action-button rdBTN"
                            value="Cancel" onclick="$( '#confirmCancel-bx' ).modal( 'show' );" />

                    </fieldset>
                    <!--end of first form-->

    <div class="modal fade" id="booking-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Booking</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px;">
          <p>Wish to Book Now?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="placeOrder();">Yes</button>
          <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="cancelBooking();">No</button>
        </div>
      </div>
      
    </div>
  </div>

    <div class="modal fade" id="edit-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Booking Details</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px;">
                    <p>Wish to Update Booking Now?</p>
                    <br />
                    <strong id="strngBill">Your Current Bill is: </strong>
                    <i class="note-disclaimer">(inc. vat)<i>: £
<span id="spCurrentBill" runat="server"></span></i></i>
                    <br />
                    <strong id="strngPay">Your Earlier Payment was: </strong>
                    <i class="note-disclaimer">(inc. vat)<i>: £
<span id="spEarlierPayment" runat="server"></span></i></i>
                    <br />
                    <strong id="strng">So, now you have to Pay: </strong>
                    <i class="note-disclaimer">(inc. vat)<i>: £
<span id="spHaveToPay" runat="server"></span></i></i>
                    <br />
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="editOrder();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="">No</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="confirmUpdate-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Booking Updation Confirmed</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px;">
                    <p>Your Booking Updation has been confirmed</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="confirmCancel-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Cancel Booking Updation?</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px;">
                    <p>Sure you want to Cancel Booking Updation?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="return cancelEdit();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="">No</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="cancel-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Booking Updation Cancelled</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px;">
          <p>You have cancelled Booking Updation</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
        </div>
      </div>
      
    </div>
  </div>

    <div class="modal fade" id="payment-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title pm-modal" style="font-size:24px;color:#111;">Payment</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px;">
          <p>Wish to make Payment online?</p>
        </div>
        <div class="modal-footer">
          <%--<button type="button" class="btn btn-warning" data-dismiss="modal" onclick="return proceedToPaymentGatewayPage();">Pay Now</button>--%>
          <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="return gotoViewAllBookings();">Pay  at @ <label id="lblCollectionAddress" style="color: #fff;"></label></button>
        </div>
      </div>
      
    </div>
  </div>

    <div class="modal fade" id="gotoView-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">No Booking Updation</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px;">
          <p>You haven't made any changes here. Going back to View</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="return gotoViewAllBookings();">OK</button>
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
    <a href="/ViewAllOfMyBookings.aspx" class="upNEW flash"><i class="fa fa-arrow-circle-left"></i> <span>Go to View Bookings</span></a>


</asp:Content>

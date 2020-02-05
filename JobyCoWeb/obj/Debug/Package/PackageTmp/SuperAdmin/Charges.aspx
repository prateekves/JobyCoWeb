<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Charges.aspx.cs" Inherits="JobyCoWeb.SuperAdmin.Charges" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <style>
        .divHide {
            display: none;
        }

        .divUnhide {
            display: block;
        }

        .unpaid-bg { background: #9B822E; }

        .cancel-bg { background: #B51013; }

        .paid-bg {background: #238A35;}

        .cancel-bg, .paid-bg, .unpaid-bg{
            color: #fff;
            text-transform:uppercase;
            padding: 5px 0;
            width: 100%;
            display: block;
            text-align: center;
        } 

        .RowClick {
            cursor: pointer;
        }
        .hideColumn {
            display: none;
        }
    </style>

    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <!-- New Script Added for Dynamic Menu Population
================================================== -->
    <script>

        // unblock when ajax activity stops 
        $(document).ajaxStop($.unblockUI);

        function mainMenu() {
            $.ajax({
                url: 'Dashboard.aspx',
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


            var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
        accessibleMenuItems(hfMenusAccessibleValues);

        var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
        accessiblePageControls(hfControlsAccessible);

            $('#<%=AddOrEdit.ClientID%>').val("Add");
            $('#<%=ChargesId.ClientID%>').val("");
            $('#<%=ChargesIdForCancel.ClientID%>').val("");
            $('#<%=HChargestxt.ClientID%>').val("");
            $('#pageHeading').text("Add Charges");

            getTaxation();


        if (!$('#IsRange').prop('checked') == true) {
            $('#TaxAmountFixed').addClass('divUnhide');
            $('#TaxAmountRange').addClass('divHide');
        }

        $('#IsRange').click(function () {
            $('#TaxAmountFixed').removeClass('divHide');
            $('#TaxAmountFixed').removeClass('divUnhide');

            $('#TaxAmountRange').removeClass('divHide');
            $('#TaxAmountRange').removeClass('divUnhide');

            if ($(this).is(':checked')) {
                $('#TaxAmountRange').addClass('divUnhide');
                $('#TaxAmountFixed').addClass('divHide');
            }
            else {
                $('#TaxAmountRange').addClass('divHide');
                $('#TaxAmountFixed').addClass('divUnhide');
            }
        });


        $('#dtTaxRangeTable').on('click', 'input[type="button"]', function (e) {
            var ClosestTr = $(this).closest('tr');
            ClosestTr.remove();
        });


            $('#dtViewBookings tbody').on('click', '.view', function (e) {

                var ClosestTr = $(this).closest("tr");

                var ChargesId = ClosestTr.find('td').eq(0).text();
                var SerialNo = ClosestTr.find('td').eq(1).text();
                var ChargesType = ClosestTr.find('td').eq(2).text();
                var ChargesName = ClosestTr.find('td').eq(3).text();


                alert(
                    'SerialNo=' + SerialNo + ', ' +
                    'ChargesId=' + ChargesId + ', ' +
                    'ChargesType=' + ChargesType + ', ' +
                    'ChargesName=' + ChargesName + ', '
                );
                return false;
            });

            $('#dtViewBookings tbody').on('click', '.RowClick', function (e) {

                var ClosestTr = $(this).closest("tr");

                var ChargesId = ClosestTr.find('td').eq(0).text();
                var SerialNo = ClosestTr.find('td').eq(1).text();
                var ChargesType = ClosestTr.find('td').eq(2).text();
                var ChargesName = ClosestTr.find('td').eq(3).text();


                //alert(
                //    'SerialNo=' + SerialNo + ', ' +
                //    'ChargesId=' + ChargesId + ', ' +
                //    'ChargesType=' + ChargesType + ', ' +
                //    'ChargesName=' + ChargesName + ', '
                //);
                return false;
            });

            $('#dtViewBookings tbody').on('click', '.edit', function (e) {
                var ClosestTr = $(this).closest("tr");
                var ChargesId = ClosestTr.find('td').eq(0).text();
                //var SerialNo = ClosestTr.find('td').eq(1).text();
                //var ChargesType = ClosestTr.find('td').eq(2).text();
                //var ChargesName = ClosestTr.find('td').eq(3).text();
                //alert(ChargesId);
                $('#<%=AddOrEdit.ClientID%>').val("Edit");
                $('#<%=ChargesId.ClientID%>').val(ChargesId);
                $('#pageHeading').text("Edit Charges");

                var objTaxation = {};
                
                objTaxation.ChargesId = ChargesId;

                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Charges.aspx/GetAllTaxationForEdit",
                    data: JSON.stringify(objTaxation),
                    success: function (result) {
                        var jData = JSON.parse(result.d);
                        //alert(JSON.stringify(jData));
                        var Id = parseInt(jData[0]["Id"]);
                        var TaxName = jData[0]["TaxName"];
                        var RadioChargesType = jData[0]["RadioChargesType"];
                        var IsRange = jData[0]["IsRange"];
                        var IsPercent = jData[0]["IsPercent"];
                        var TaxAmount = jData[0]["TaxAmount"];
                        //alert(Id + ' ' + TaxName + ' ' + RadioChargesType + ' ' + IsRange + ' ' + IsPercent + ' ' + TaxAmount);

                        $('#<%=txtTaxationName.ClientID%>').val(TaxName);

                        if (RadioChargesType == "VAT") {
                            
                            var rad_id = document.getElementById('<%=RadioChargesType.ClientID %>');
                            var radio = rad_id.getElementsByTagName("input");
                            radio[0].checked = true;
                        }
                        else if (RadioChargesType == "Insurance") {
                            var rad_id = document.getElementById('<%=RadioChargesType.ClientID %>');
                            var radio = rad_id.getElementsByTagName("input");
                            radio[1].checked = true;
                        }
                        else if (RadioChargesType == "Other") {
                            var rad_id = document.getElementById('<%=RadioChargesType.ClientID %>');
                            var radio = rad_id.getElementsByTagName("input");
                            radio[2].checked = true;
                        }

                        $('#TaxAmountFixed').removeClass('divHide');
                        $('#TaxAmountFixed').removeClass('divUnhide');

                        $('#TaxAmountRange').removeClass('divHide');
                        $('#TaxAmountRange').removeClass('divUnhide');

                        if (IsRange)
                        {
                            $(".IsRange:checkbox").prop("checked", true);
                            $('#TaxAmountRange').addClass('divUnhide');
                            $('#TaxAmountFixed').addClass('divHide');

                            // Data Fetch for range
                            var objTaxation = {};
                            objTaxation.ChargesId = ChargesId;
                            $("#dtTaxRangeTable tbody").find("tr:gt(0)").remove();

                            $.ajax({
                                method: "POST",
                                contentType: "application/json; charset=utf-8",
                                url: "Charges.aspx/GetAllTaxationForEditRange",
                                data: JSON.stringify(objTaxation),
                                success: function (result) {
                                    var jdata = JSON.parse(result.d);
                                    //alert(JSON.stringify(jdata));
                                    var len = jdata.length;

                                    if (len > 0) {

                                        $("#MinVal").val(jdata[0]["MinVal"]);
                                        $("#MaxVal").val(jdata[0]["MaxVal"]);
                                        if (jdata[0]["IsPercent"]) {
                                            $(".IsPercent:checkbox").prop("checked", true);
                                        }
                                        else {
                                            $(".IsPercent:checkbox").prop("checked", false);
                                        }
                                        $("#TaxAmount").val(jdata[0]["TaxAmount"]);

                                        for (var i = 0; i < len; i++)
                                        {
                                            if (jdata[i+1]["IsPercent"]) {
                                                var newRowContent = '<tr>' +
                                            '<td><label class="control-label">Min</label></td>' +
                                            '<td><input type="text" id="MinVal" value="' + jdata[i + 1]["MinVal"] + '" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
                                            '<td><label class="control-label">Max</label></td>' +
                                            '<td><input type="text" id="MaxVal" value="' + jdata[i + 1]["MaxVal"] + '" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
                                            '<td class="check_td"><label class="control-label">In percent</label><input type="checkbox" checked name="IsPercent" id="IsPercent"/></td>' +
                                            '<td><label class="control-label">Charges Amount</label></td>' +
                                            '<td><input type="text" id="TaxAmount"  value="' + jdata[i + 1]["TaxAmount"] + '"  onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
                                            '<td><input id="btmDeleteTaxRangeRow" type="button" value="Delete"></td>' +
                                            '</tr>';
                                            }
                                            else {
                                                var newRowContent = '<tr>' +
                                            '<td><label class="control-label">Min</label></td>' +
                                            '<td><input type="text" id="MinVal" value="' + jdata[i + 1]["MinVal"] + '" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
                                            '<td><label class="control-label">Max</label></td>' +
                                            '<td><input type="text" id="MaxVal" value="' + jdata[i + 1]["MaxVal"] + '" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
                                            '<td class="check_td"><label class="control-label">In percent</label><input type="checkbox" name="IsPercent" id="IsPercent"/></td>' +
                                            '<td><label class="control-label">Charges Amount</label></td>' +
                                            '<td><input type="text" id="TaxAmount"  value="' + jdata[i + 1]["TaxAmount"] + '"  onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
                                            '<td><input id="btmDeleteTaxRangeRow" type="button" value="Delete"></td>' +
                                            '</tr>';
                                            }
                                            
                                            $("#dtTaxRangeTable tbody").append(newRowContent);
                                        }
                                        
                                    }

                                }
                            });
                        }
                        else
                        {
                            $(".IsRange:checkbox").prop("checked", false);
                            $('#TaxAmountRange').addClass('divHide');
                            $('#TaxAmountFixed').addClass('divUnhide');
                            
                            $('#<%=txtTaxAmount.ClientID%>').val(TaxAmount);

                            if (IsPercent) {
                                $(".IsFixPercent:checkbox").prop("checked", true);
                            }
                            else {
                                $(".IsFixPercent:checkbox").prop("checked", false);
                            }
                        }
                    }
                    });


                return false;
            });

            $('#dtViewBookings tbody').on('click', '.delete', function (e) {

                var ClosestTr = $(this).closest("tr");

                var ChargesId = ClosestTr.find('td').eq(0).text();
                var ChargesStatus = ClosestTr.find('td').eq(5).text();
                $('#<%=ChargesIdForCancel.ClientID%>').val(ChargesId);
                $('#<%=HChargestxt.ClientID%>').val(ChargesStatus);
                
                //alert(ChargesStatus);
                if (ChargesStatus == "Active") {
                    $("#Chargestxt").text("Sure? You want to Cancel this Charges?");
                }
                else {
                    $("#Chargestxt").text("Sure? You want to apply this Charges?");
                }
                

                //var SerialNo = ClosestTr.find('td').eq(1).text();
                //var ChargesType = ClosestTr.find('td').eq(2).text();
                //var ChargesName = ClosestTr.find('td').eq(3).text();


                //deleteTransaction(ChargesId, "Add");
                $('#RemoveShipping-bx').modal('show');
                return false;
            });



        });//document.ready function

        function makeProperColor(vStatus) {
            switch (vStatus) {
                case "Inactive":
                    vStatus = "<span class='cancel-bg'>Inactive</span>";
                    break;

                case "Active":
                    vStatus = "<span class='paid-bg'>Active</span>";
                    break;
            }

            return vStatus;
        }

        function getTaxation()
        {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Charges.aspx/GetAllTaxation",
                success: function (result) {
                    var jsonTaxationDetails = JSON.parse(result.d);

                    //========================= clear destroy
                    if ($.fn.dataTable.isDataTable('#dtViewBookings')) {
                        $('#dtViewBookings').DataTable().clear().destroy();
                    }

                    $('#dtViewBookings').DataTable({
                        data: jsonTaxationDetails,
                        columnDefs: [
                                        {

                                            targets: [0],
                                            className: "hideColumn",
                                        },
                                        {
                                            targets: [5],
                                            className: "hideColumn"
                                        }
                                        //{

                                        //    targets: [1],
                                        //    className: "RowClick",
                                        //},
                                        //{

                                        //    targets: [2],
                                        //    className: "RowClick",
                                        //},
                                        //{
                                        //    targets: [3],
                                        //    className: "RowClick",
                                        //},
                                        //{
                                        //    targets: [4],
                                        //    className: "RowClick"
                                        //}
                        ],
                        columns: [
                            { data: "Id" },
                            { data: "Slno" },
                            { data: "RadioChargesType" },
                            { data: "TaxName" },
                            {
                                data: "Status",
                                render: function (data) {
                                    return makeProperColor(data);
                                }
                            },
                            { data: "Status" },
                            {
                                defaultContent:
                                    "<button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Cancel or Keep'><i class='fa fa-trash' aria-hidden='true'></i></button>"
                            }
                        ],
                        "aaSorting": [
                            [0, "desc"]
                        ]
                    });
                },
                error: function (response) {
                    alert('Unable to Bind The Table');
                }
            });//end of ajax

            
        }

        function deleteTransaction(ChargesId, AddOrEdit, Chargestxt) {
            var objTaxation = {};

            objTaxation.ChargesId = ChargesId;
            objTaxation.Chargestxt = Chargestxt;

            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Charges.aspx/DeleteTaxation",
                data: JSON.stringify(objTaxation),
                success: function (result) {
                    if (result.d) {
                        if (AddOrEdit == "Add")
                        {
                            //alert("you have successfully Deleted...");
                        }
                        
                        getTaxation();
                    }
                }
            });
        }


    function addRowToRange() {

        $('#dtTaxRangeTable tbody tr').each(function (i, row) {

            var vMinVal = "";
            var vMaxVal = "";
            var vTaxAmount = "";
            $(this).closest('tr').find('input[type=text]').each(function (i, row) {
                if(i==0)
                {
                    vMinVal = $(this).val();
                }
                if (i == 1) {
                    vMaxVal = $(this).val();
                }
                if (i == 2) {
                    vTaxAmount = $(this).val();
                }
                //alert(vMinVal + ' ' + vMaxVal + ' ' + vTaxAmount);
            });

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");

            // Field Validation

            if (vMinVal == "") {
                vErrMsg.text('Enter Min Value');
                vErrMsg.css("display", "block");
                vMinVal.focus();
                return false;
            }
            if (vMaxVal == "") {
                vErrMsg.text('Enter Max Value');
                vErrMsg.css("display", "block");
                vMaxVal.focus();
                return false;
            }
            if (vTaxAmount == "") {
                vErrMsg.text('Enter Tax Amount');
                vErrMsg.css("display", "block");
                vTaxAmount.focus();
                return false;
            }
            // Range Validation
            if (parseInt(vMinVal) >=  parseInt(vMaxVal)) {
                vErrMsg.text('Max Value must be grater than Min Value');
                vErrMsg.css("display", "block");
                vMaxVal.focus();
                return false;
            }

        });

        var newRowContent = '<tr>' +
        '<td><label class="control-label">Min</label></td>' +
        '<td><input type="text" id="MinVal" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
        '<td><label class="control-label">Max</label></td>' +
        '<td><input type="text" id="MaxVal" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
        '<td class="check_td"><label class="control-label">In percent</label><input type="checkbox" name="IsPercent" id="IsPercent"/></td>' +
        '<td><label class="control-label">Charges Amount</label></td>' +
        '<td><input type="text" id="TaxAmount" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>' +
        '<td><input id="btmDeleteTaxRangeRow" type="button" value="Delete"></td>' +
        '</tr>';
        $("#dtTaxRangeTable tbody").append(newRowContent);

        return false;
    }
        function checkErrorMsg()
        {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.css("display", "none");
        }

        function checkTaxNameExistance(vTaxationName)
        {
            var vAddOrEdit = $('#<%=AddOrEdit.ClientID%>').val().trim();
            var vChargesId = $('#<%=ChargesId.ClientID%>').val().trim();

            if (vAddOrEdit == "Edit")
            {
                deleteTransaction(vChargesId, vAddOrEdit, "");
            }

            var objTaxation = {};
            var returnFlag = true;
            objTaxation.TaxationName = vTaxationName;
            $.ajax({
                type: "POST",
                url: "Charges.aspx/checkTaxNameExistance",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objTaxation),
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "success") {
                        returnFlag =  true;
                    }
                    else if (result.d == "available") {
                        $('#Taxation-bx-msg').text('Tax Name already exists in the system');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        returnFlag = false;
                    }
                    else
                    {
                        $('#Taxation-bx-msg').text('Add Taxation failed');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        returnFlag = false;
                    }
                },
                error: function (response) {
                    alert('Add Taxation failed');
                }
            });
            return returnFlag;
        }

        function saveTaxation() {
            
            //$.blockUI({
            //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    message: '<h4>Loading...</h4>',
            //    css: {
            //        border: 'none',
            //        //backgroundColor: 'transparent'
            //    }

            //});

            //mainMenu();

            var vRadioChargesType = $('#<%=RadioChargesType.ClientID %>').find('input:checked').val();

            if ($("#IsRange").is(':checked')) {
                //alert('checked');
                var vTaxationName = $('#<%=txtTaxationName.ClientID%>').val().trim();
                //Validation if the Tax name is exists
                if (!checkTaxNameExistance(vTaxationName)) {
                    return false;
                }
                var SaveFlag = 1;

                $('#dtTaxRangeTable tbody tr').each(function (i, row) {
                    
                    var vMinVal = "";
                    var vMaxVal = "";
                    var vIsPercent = false;
                    var vTaxAmount = "";
                    var iCount = 0;
                    $(this).closest('tr').find('input').each(function (i, row) {
                        if (i == 0) {
                            vMinVal = $(this).val();
                        }
                        if (i == 1) {
                            vMaxVal = $(this).val();
                        }
                        if (i == 2) {
                            vIsPercent = $(this).is(":checked");
                        }
                        if (i == 3) {
                            vTaxAmount = $(this).val();
                        }
                        //alert($(this).val());
                        
                    });
                    //alert(vMinVal + ' ' + vMaxVal + ' ' + vIsPercent + ' ' + vTaxAmount);

                    // Field Validation
                    
                    if (vTaxationName == "") {
                        $('#Taxation-bx-msg').text('Enter Taxation Name');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        SaveFlag = 0;
                        return false;
                    }

                    if (vMinVal == "") {
                        $('#Taxation-bx-msg').text('Enter Min Value');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        SaveFlag = 0;
                        return false;
                    } 
                    if (vMaxVal == "") {
                        $('#Taxation-bx-msg').text('Enter Max Value');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        SaveFlag = 0;
                        return false;
                    }
                    if (vTaxAmount == "") {
                        $('#Taxation-bx-msg').text('Enter Tax Amount');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        SaveFlag = 0;
                        return false;
                    }
                    // Range Validation
                    if (parseInt(vMinVal) >= parseInt(vMaxVal)) {
                        $('#Taxation-bx-msg').text('Max Value must be grater than Min Value');
                        $('#Shipping-bx').addClass('error_modal');
                        $('#Shipping-bx').modal('show');
                        SaveFlag = 0;
                        return false;
                    }
                });

                if (SaveFlag == 1){
                $('#dtTaxRangeTable tbody tr').each(function (i, row) {

                    var vMinVal = "";
                    var vMaxVal = "";
                    var vIsPercent = false;
                    var vTaxAmount = "";
                    var iCount = 0;
                    $(this).closest('tr').find('input').each(function (i, row) {
                        if (i == 0) {
                            vMinVal = $(this).val();
                        }
                        if (i == 1) {
                            vMaxVal = $(this).val();
                        }
                        if (i == 2) {
                            vIsPercent = $(this).is(":checked");
                        }
                        if (i == 3) {
                            vTaxAmount = $(this).val();
                        }
                        //alert($(this).val());

                    });
                    var objTaxation = {};

                    objTaxation.TaxationName = vTaxationName;
                    objTaxation.MinVal = vMinVal;
                    objTaxation.MaxVal = vMaxVal;
                    objTaxation.IsPercent = vIsPercent;
                    objTaxation.TaxAmount = vTaxAmount;
                    objTaxation.RadioChargesType = vRadioChargesType;
                    //alert(JSON.stringify(objTaxation));
                    $.ajax({
                        type: "POST",
                        url: "Charges.aspx/AddTaxation",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(objTaxation),
                        dataType: "json",
                        success: function (result) {

                            //alert(result.d);
                            if (result.d == 'success') {
                                $('#Taxation-bx-msg').text('Tax Settings have been saved successfully..');
                                $('#Shipping-bx').removeClass('error_modal');
                            }
                            else if (result.d == 'available') {
                                $('#Taxation-bx-msg').text('Tax Name already exists in the system');
                                $('#Shipping-bx').addClass('error_modal');
                            }
                            //clearAllControls();
                            $('#Shipping-bx').modal('show');
                        },
                        error: function (response) {
                            alert('Add Taxation failed');
                        }
                    });

                });
                }
            }
            else {
                //alert('not checked');
                if (validateFlatControls())
                {
                    checkErrorMsg();
                    var vTaxationName = $('#<%=txtTaxationName.ClientID%>').val().trim();
                    var vtxtTaxAmount = $('#<%=txtTaxAmount.ClientID%>').val().trim();

                    var vIsFixPercent = false;
                    if ($("#IsFixPercent").is(':checked')) {
                        //alert('checked');
                        vIsFixPercent = true;
                    }
                    // Save content
                    //alert(vRadioChargesType);
                    var objTaxation = {};

                    objTaxation.TaxationName = vTaxationName;
                    objTaxation.TaxAmount = vtxtTaxAmount;
                    objTaxation.IsFixPercent = vIsFixPercent;
                    objTaxation.RadioChargesType = vRadioChargesType;

                    $.ajax({
                        type: "POST",
                        url: "Charges.aspx/AddFlatTaxation",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(objTaxation),
                        dataType: "json",
                        success: function (result) {

                            //alert(result.d);
                            if (result.d == 'success') {
                                $('#Taxation-bx-msg').text('Tax Settings have been saved successfully..');
                                $('#Shipping-bx').removeClass('error_modal');
                            }
                            else if (result.d == 'available') {
                                $('#Taxation-bx-msg').text('Tax Name already exists in the system');
                                $('#Shipping-bx').addClass('error_modal');
                            }
                            //clearAllControls();
                            $('#Shipping-bx').modal('show');
                        },
                        error: function (response) {
                            alert('Add Taxation failed');
                        }
                    });

                }
            }
            return false;
        }

        function btnOKClick() {
            $('#Taxation-bx-msg').text('');
            //window.onload();
            getTaxation();
            initializeControl();
            return false;
        }

        function initializeControl() {
            $('#<%=txtTaxationName.ClientID%>').val('');
            $('#<%=txtTaxAmount.ClientID%>').val('');
            var rad_id = document.getElementById('<%=RadioChargesType.ClientID %>');
            var radio = rad_id.getElementsByTagName("input");
            radio[0].checked = false;

            $('#TaxAmountFixed').removeClass('divHide');
            $('#TaxAmountFixed').removeClass('divUnhide');

            $('#TaxAmountRange').removeClass('divHide');
            $('#TaxAmountRange').removeClass('divUnhide');

            $(".IsRange:checkbox").prop("checked", false);
            $('#TaxAmountRange').addClass('divHide');
            $('#TaxAmountFixed').addClass('divUnhide');

            $("#dtTaxRangeTable tbody").find("tr:gt(0)").remove();
            $("#MinVal").val("");
            $("#MaxVal").val("");
            $("#TaxAmount").val("");
            $(".IsPercent:checkbox").prop("checked", false);
        }

        function validateFlatControls()
        {
            var vTaxationName = $('#<%=txtTaxationName.ClientID%>');
            var vtxtTaxAmount = $('#<%=txtTaxAmount.ClientID%>');

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");

            if (vTaxationName.val().trim() == "") {
                vErrMsg.text('Enter Taxation Name');
                vErrMsg.css("display", "block");
                vTaxationName.focus();
                return false;
            }
            if (vtxtTaxAmount.val().trim() == "") {
                vErrMsg.text('Enter Tax Amount');
                vErrMsg.css("display", "block");
                vtxtTaxAmount.focus();
                return false;
            }
            return true;
        }
        function CloseModal() {
            $('#dvBookingNumberModal').modal('close');
        }

        function refreshScreen()
        {
            initializeControl();
            location.reload();
        }

        function cancelCharges() {
            var vChargesId = $('#<%=ChargesIdForCancel.ClientID%>').val().trim();
            var vChargestxt = $('#<%=HChargestxt.ClientID%>').val().trim();
            deleteTransaction(vChargesId, "Add", vChargestxt);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2 id="pageHeading">
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmAddShipping" runat="server">
                        <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                        <asp:HiddenField ID="hfControlsAccessible" runat="server" />
                        <asp:HiddenField ID="AddOrEdit" runat="server" />
                        <asp:HiddenField ID="ChargesId" runat="server" />

                        <div class="panel-heading">
                        </div>
                        <div class="panel-body clrBLK dashboad-form">
                            <div style="height:58px;" class="row">
                                <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" Style="text-align: center; width: 100%;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            </div>
                            <div class="row">
                                <div class="form-group clearfix top_row11">
                                    <label class="col-lg-2 col-md-3 col-sm-4 control-label">Charges Type : <span style="color: red">*</span></label>
                                    <div class="col-lg-6 col-md-4 col-sm-8">
                                        <asp:RadioButtonList ID="RadioChargesType" runat="server" RepeatDirection="Horizontal" CellPadding="10" CellSpacing="10" Height="20px">
                                            <asp:ListItem Selected="True" Text="VAT" Value="VAT">VAT</asp:ListItem>
                                            <asp:ListItem Text="Insurance" Value="Insurance">Insurance</asp:ListItem>
                                            <asp:ListItem Text="Other" Value="Other">Other</asp:ListItem>
                                        </asp:RadioButtonList>

                                        <!-- Material inline 1 -->
                                        <%--<div class="form-check form-check-inline">
                                          <input type="radio" class="form-check-input" id="VAT" name="inlineMaterialRadiosExample">
                                          <label class="form-check-label" for="materialInline1">1</label>
                                        </div>

                                        <!-- Material inline 2 -->
                                        <div class="form-check form-check-inline">
                                          <input type="radio" class="form-check-input" id="Insurance" name="inlineMaterialRadiosExample">
                                          <label class="form-check-label" for="materialInline2">2</label>
                                        </div>

                                        <!-- Material inline 3 -->
                                        <div class="form-check form-check-inline">
                                          <input type="radio" class="form-check-input" id="Other" name="inlineMaterialRadiosExample">
                                          <label class="form-check-label" for="materialInline3">3</label>
                                        </div>--%>

                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-lg-2 col-md-3 col-sm-4 control-label">Charges Name : <span style="color: red">*</span></label>
                                    <div class="col-lg-6 col-md-4 col-sm-8">
                                        <asp:TextBox ID="txtTaxationName" runat="server" MaxLength="50"
                                            CssClass="form-control" PlaceHolder="e.g. Tom" title=""
                                            onkeypress="CharacterOnly(event);clearErrorMessage();" BackColor="#3D4145" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>
                                    </div>
                                    <div class="col-lg-4 col-md-5 col-sm-12 switch_outer">
                                        <label class="control-label">Enter Charges In Range : </label>
                                        <span class="span1">
                                            <strong>Off</strong>                                           
                                            <label class="switch">
                                                <input type="checkbox" id="IsRange" class="IsRange" />
                                                <span class="slider round"></span>
                                            </label>
                                            <strong>On</strong> 
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div id="TaxAmountRange">
                                    <div class="col-lg-12">
                                        <table class="tax_table" style="width: 100%" id="dtTaxRangeTable">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <label class="control-label">Min</label></td>
                                                    <td>
                                                        <input type="text" id="MinVal" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>
                                                    <td>
                                                        <label class="control-label">Max</label></td>
                                                    <td>
                                                        <input type="text" id="MaxVal" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>
                                                    <td class="check_td">
                                                        <label class="control-label">In percent</label><input type="checkbox" name="IsPercent" id="IsPercent" class="IsPercent" /></td>
                                                    <td>
                                                        <label class="control-label">Charges Amount</label></td>
                                                    <td>
                                                        <input type="text" id="TaxAmount" onkeyup="checkErrorMsg()" onkeypress="NumericOnly(event);clearErrorMessage();" /></td>
                                                    <td>
                                                        
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="col-lg-12 marginbottom1 text-left">
                                        <button class="btn btn-success aa-add-row" type="button" style="width: 150px; margin-right: 5px;" id="btnBookPickupAddRow" onclick="return addRowToRange();">
                                            <span class="glyphicon glyphicon-plus add" style="padding-right: 10px"></span>Add Row
                                        </button>
                                    </div>
                                </div>

                                <div id="TaxAmountFixed">
                                    <div class="form-group">
                                        <div class="col-md-2 col-sm-4 check_td">
                                            <label class="control-label">In percent</label><input type="checkbox" name="IsFixPercent" id="IsFixPercent" class="IsFixPercent" />
                                        </div>
                                        <label class="col-md-3 col-sm-4 control-label">Enter Charges Amount: <span style="color: red">*</span></label>
                                        <div class="col-md-3 col-sm-4">
                                            <asp:TextBox ID="txtTaxAmount" runat="server" MaxLength="50"
                                                CssClass="form-control" PlaceHolder="e.g. Tom" title=""
                                                onkeypress="NumericOnly(event);clearErrorMessage();" BackColor="#3D4145" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row marginbottom">
                                <div class="form-group text-center">
                                    <div class="col-sm-12">
                                        <asp:Button ID="btnSaveUserAccess" runat="server" Text="Save Charges"
                                            CssClass="btn btn-default"
                                            OnClientClick="return saveTaxation();" />

                                        <asp:Button ID="btnCancelUserAccess" runat="server" Text="Cancel"
                                            CssClass="btn btn-default"
                                            OnClientClick="refreshScreen();" />
                                    </div>
                                </div>
                            </div>

                            <%--<div class="table-responsive">
                                <table id="dtTaxation" class="table">
                                    <thead>
                                        <tr>
                                            <th>Serial No</th>
                                            <th>Taxation Name</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>--%>
                            <div class="tble_main table_tax">
                                    <div>
                                        <!-- jQuery DataTable -->
                                        <table id="dtViewBookings" class="chargesTbl">
                                            <thead>
                                                <tr>
                                                    <th style="display:none;">Id</th>
                                                    <th>Serial No</th>
                                                    <th>Charges Type</th>
                                                    <th>Charges Name</th>
                                                    <th>Status</th>
                                                    <th style="display:none;">Status</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>
                            </div>
                            <div class="row">
                                <div style="padding: 10px;">
                                </div>
                            </div>

                            
                        </div>
                        <div class="col-md-12">
                            <hr />
                            <footer>
                                <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                            </footer>
                        </div>
                        <div class="modal fade" id="RemoveShipping-bx" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <%--<form id="CancelForm" runat="server">--%>
                                        <div class="modal-header" style="background-color: #f0ad4ecf;">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title" style="font-size: 24px; color: #111;">Cancel Charges</h4>
                                        </div>
                                        <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                                            <asp:HiddenField ID="ChargesIdForCancel" runat="server" />
                                            <asp:HiddenField ID="HChargestxt" runat="server" />
                                            <p id="Chargestxt"></p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-success" data-dismiss="modal" onclick="cancelCharges();">Yes</button>
                                            <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                                        </div>
                                        <%--</form>--%>
                                    </div>

                                </div>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="Shipping-bx" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content modal-content-Container">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">Add Taxation</h4>
                                        </div>
                                        <div class="modal-body" style="text-align: center; font-size: 22px;">
                                            <p id="Taxation-bx-msg"></p>
                                        </div>
                                        <div class="modal-footer" style="text-align: center !important;">
                                            <button type="button" class="btn btn-primary" data-dismiss="modal"
                                                 onclick="return btnOKClick()">
                                                OK</button>
                                        </div>
                                    </div>

                                </div>
                            </div>

    <div class="modal fade" id="dvBookingNumberModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>Order Information: 
                                    <span id="spHeaderBookingId" runat="server"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto;">
                    <div id="content-1" class="scroll_content">
                    <p>
                        <strong>Please find the details of order 
                                    <span id="spBodyBookingId" runat="server"></span>below:</strong>
                    </p>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="twoSrvbtn">
                                <button id="btnEditBooking1" data-dismiss="modal" title="Edit Booking"
                                    onclick="return gotoEditBookingPage();">
                                    <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                </button>

                                <button id="btnCancelBooking1" data-dismiss="modal" title="Close"
                                    onclick="CloseModal();">
                                    <i class="fa fa-times" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="twoSETbtn">
                                <button id="btnPrintBookingModal" data-dismiss="modal" title="Print Booking Details"
                                    onclick="return printDetails('dvBooking');" style="margin-bottom: 10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintPdfBookingModal" data-dismiss="modal" title="Download as PDF"
                                    onclick="exportToPDF('dvBooking', 'BookingAllDetails.pdf');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintExcelBookingModal" data-dismiss="modal" title="Download as Excel"
                                    onclick="exportToExcel('dvAllBookings', 'CustomerDetails.xls');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class="">Booking Details:</h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <ul class="custoDTAIL">
                                                <li><strong>Charges Type</strong><span><asp:Label ID="lblChargesType" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Charges Name</strong><span><asp:Label ID="lblChargesName" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Customer Mobile</strong><span><asp:Label ID="lblCustomerMobile" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>No of Items</strong><span><asp:Label ID="lblItems" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Loaded</strong><span><asp:Label ID="lblLoaded" CssClass="Loaded" runat="server" Text=""></asp:Label></span></li>
                                                <li><strong>Remaining</strong><span><asp:Label ID="lblRemaining" CssClass="Remaining" runat="server" Text=""></asp:Label></span></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class="">Item details</h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <br />
                                                    <!-- jQuery DataTable -->
                                                    <table border="1" id="dvBookingItems" style="width: 100%;">
                                                        <thead>
                                                            <tr>
                                                                <th>Select</th>
                                                                <th>Pickup Id</th>
                                                                <th colspan="2">Items</th>
                                                                <%--<th>Pickup Item</th>--%>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        </tbody>
                                                    </table>
                                                    <%--<div class="bottom_pop clearfix">
                                                    <div class="vatTotal btn btn-">
                                                            <input type="button" class="add-row btn btn-primary" value="Add To Container">
                                                    </div>
                                                    </div>--%>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- New Division for Payment Related Information -->

                    <%--<div class="row" style="height: 30px;">
                    </div>--%>
                    </div>                    
                </div>
                <div class="bottom_pop clearfix">
                    <div class="vatTotal vatTotal1 btn btn-">
                            <input type="button" class="add-row btn btn-primary" value="Add To Container">
                    </div>
                </div>



            </div>
        </div>
    </div>
    
     

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="UpdateStatus.aspx.cs"
    EnableEventValidation="false" Inherits="JobyCoWeb.Shipping.UpdateStatus" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="../css/jquery.mCustomScrollbar.css" rel="stylesheet" />
    <link href="../styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>
    <style type="text/css">
        .RowItemStatus {
            cursor: pointer;
        }
        .ItemShipped td {
            color:aqua !important;
        }
        .hideColumn {
            display: none;
        }
    </style>
    <script>
        // unblock when ajax activity stops 
        //$(document).ajaxStop($.unblockUI);

        //function mainMenu() {
        //    $.ajax({
        //        url: 'Dashboard.aspx',
        //        cache: false
        //    });
        //}

        $(document).ready(function () { //Ready Start

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

            // restriction on space input
            $("#<%=txtContainerNoORBookingNo.ClientID%>").on("keypress", function (e) {
                //alert('Press');
                if (e.which === 32)
                    e.preventDefault();
            });

            var BookingId = getUrlVars();
            $("#<%=txtContainerNoORBookingNo.ClientID%>").val(BookingId);
            SearchItems();

            $("#divddlItemStatus").click(function () {
                //Removing classes one by one
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').removeClass("chosen-container");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').removeClass("chosen-container-single-nosearch");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').removeClass("chosen-container-active");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').removeClass("chosen-with-drop");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').removeClass("chosen-container-single");
                //Adding classes one by one
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').addClass("chosen-container chosen-container-single chosen-container-active chosen-with-drop");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').addClass("chosen-container");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').addClass("chosen-container-single");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').addClass("chosen-container-active");
                $('#ContentPlaceHolder1_ddlItemStatus_chosen').addClass("chosen-with-drop");
                //Removing readonly from the search box's textbox
                $("#ContentPlaceHolder1_ddlItemStatus_chosen > .chosen-drop > .chosen-search > input[type=text]").removeAttr("readonly");
                //Condition for open close search box
                if ($("#<%=ddlItemStatus.ClientID%>").find('option:selected').val() == 0) {
                }
                else {
                    if ($("#ContentPlaceHolder1_ddlItemStatus_chosen > .chosen-drop").is(":visible")) {
                        $('#ContentPlaceHolder1_ddlItemStatus_chosen > .chosen-drop').css('display', 'none');
                        $(".result-selected").removeClass("highlighted");
                    }
                    else {
                        $('#ContentPlaceHolder1_ddlItemStatus_chosen > .chosen-drop').css('display', 'block');
                        $(".result-selected").removeClass("highlighted");
                        $(".result-selected").addClass("highlighted");
                        //Focus textbox when the search box is opened
                        $("#ContentPlaceHolder1_ddlItemStatus_chosen > .chosen-drop > .chosen-search > input[type=text]").focus();
                    }
                }

                if ($("#<%=ddlItemStatus.ClientID%>").find('option:selected').val() == 1)
                {
                    $('input:checkbox').removeAttr('checked');
                    $('input:checkbox').attr('disabled', 'disabled');
                }
            });
            // Read a page's GET URL variables and return them as an associative array.
            function getUrlVars() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    //vars.push(hash[0]);
                    //vars[hash[0]] = hash[1];
                }
                return hash[1];
            }

            // Called to make PickupId Clickable to display Modal POPUP In the LIST of Pickup Item
            $('#tblSearchedItem tbody').on('click', '.RowItemStatus', function (e) {

                //$.blockUI({
                //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
                //    message: '<h4>Loading...</h4>',
                //    css: {
                //        border: 'none',
                //        //backgroundColor: 'transparent'
                //    }

                //});

                //mainMenu();

                var ClosestTr = $(this).closest("tr");
                
                var BookingId = ClosestTr.find('td').eq(1).text();
                var PickupId = ClosestTr.find('td').eq(2).text();
                var ContainerId = "";
                
                getBookingItemsHistory(PickupId, BookingId, ContainerId);
            });

            $('#<%=ddlItemStatus.ClientID%>').on('change', function () {
                OnItemStatus(this.value);
            });


            $('.checkall:checkbox').on('change', function () {

                if ($(this).is(":checked")) {
                    $('.checkItem:checkbox').removeAttr('checked');
                    $('.checkItem:checkbox').attr('checked', 'checked');
                    $('.checkItem:checkbox').prop('checked', true);
                }
                else {
                    $('.checkItem:checkbox').removeAttr('checked');
                    $('.checkItem:checkbox').prop('checked', false);
                }
            });

            $('#btnBackStatus').on('click', function () {
                 var lastUrl = $("#<%=RefUrl.ClientID%>").val();
                 //alert(lastUrl);
                 window.location.replace(lastUrl); 
            });

            $('[data-toggle="tooltip"]').tooltip();

        }); //Ready END

        function hideTableColunm()
        {
            $("#tblSearchedItem tbody").find('tr').each(function (i, el) {
                 var $tds = $(this).find('td');
                 var IsContainer = parseInt($tds.eq(6).text());
                 if (IsContainer == 0) {
                     $(".view").addClass('hideColumn');
                     $tds.eq(1).addClass('hideColumn');
                 }
                 else {
                     $(".view").removeClass('hideColumn');
                     $tds.eq(1).removeClass('hideColumn');
                 }
                 //alert('IsContainer : ' + IsContainer);
            });
        }

        function OnItemStatus(ChangedStatus)
        {
            if (ChangedStatus == 'Order booked')
            {
                $('input:checkbox').removeAttr('checked');
                $('input:checkbox').attr('disabled', 'disabled');
            }
            else
            {
                $('input:checkbox').removeAttr('disabled');
            }
        }

        function getAllBookingIds() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "UpdateStatus.aspx/GetAllItemStatus",
                data: "{}",
                dataType: "json",
                success: function (data) {
                    $.each(data.d, function () {
                        $("#<%=ddlItemStatus.ClientID%>").append($("<option></option>").val(this['Value']).html(this['Text']));
                        })
                    },
                    error: function (response) {
                    }
                });
        }

        function PropertyCheckControl(x) {
            if ($(x).is(":checked")) {
                $(x).removeAttr('checked');
                $(x).attr('checked', 'checked');
                $(x).prop('checked', true);
            }
            else {
                $(x).removeAttr('checked');
                $(x).prop('checked', false);
            }
        }


        function SearchItems()
        {

            //$.blockUI({
            //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    message: '<h4>Loading...</h4>',
            //    css: {
            //        border: 'none',
            //        //backgroundColor: 'transparent'
            //    }

            //});

            //mainMenu();

            $("#tblSearchedItem tbody tr").remove();

            $('input:checkbox').removeAttr('checked');

            var ContainerNoORBookingNo = $("#<%=txtContainerNoORBookingNo.ClientID%>").val().trim();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "UpdateStatus.aspx/SearchByContainerNoORBookingNo",
                data: "{ ContainerNoORBookingNo: '" + ContainerNoORBookingNo.toUpperCase() + "'}",
                dataType: "json",
                async: false,
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 700);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    
                    //========================= clear destroy
                    if ($.fn.dataTable.isDataTable('#tblSearchedItem')) {
                        $('#tblSearchedItem').DataTable().clear().destroy();
                    }

                    $('#tblSearchedItem').DataTable({
                        data: jdata,
                        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                            //add class on the basis of Status Color Code
                            if (parseInt(aData["StatusId"]) == 1) {
                                $(nRow).addClass('blue_box');
                            }
                            else if (parseInt(aData["StatusId"]) == 2) {
                                $(nRow).addClass('pink_box');
                            }
                            else if (parseInt(aData["StatusId"]) == 3) {
                                $(nRow).addClass('perpel_box');
                            }
                            else if (parseInt(aData["StatusId"]) == 4) {
                                $(nRow).addClass('orangeClass');
                            }
                            else if (parseInt(aData["StatusId"]) == 5) {
                                $(nRow).addClass('greenClass');
                            }
                            else if (parseInt(aData["StatusId"]) == 6) {
                                $(nRow).addClass('deepgreen_box');
                            }
                            else if (parseInt(aData["StatusId"]) == 7) {
                                $(nRow).addClass('brown_box');
                            }
                            else if (parseInt(aData["StatusId"]) == 8) {
                                $(nRow).addClass('red_box');
                            }
                        },

                        columnDefs: [
                                        //{
                                        //    targets: [1],
                                        //    className: "hideColumn",
                                        //},
                                        
                                        {
                                            
                                            targets: [1],
                                            className: "RowItemStatus",
                                        },
                                        {
                                            targets: [2],
                                            className: "RowItemStatus",
                                        },
                                        {
                                            targets: [3],
                                            className: "RowItemStatus"
                                        },
                                        {
                                            targets: [4],
                                            className: "RowItemStatus"
                                        },
                                        {
                                            targets: [5],
                                            className: "RowItemStatus"
                                        },
                                        {
                                            targets: [6],
                                            className: "hideColumn"
                                        }

                        ],
                        columns: [
                            {
                                defaultContent:
                                  "<input type='checkbox' onchange='PropertyCheckControl(this);' class='checkItem'/>"
                            },
                            { data: "BookingId" },
                            { data: "PickupId" },
                            { data: "Items" },
                            { data: "Paid" },
                            { data: "Status" },
                            { data: "IsContainer" }
                        ]
                    });

                    hideTableColunm();

                    //=========================

                    //var len = jdata.length;
                    
                    //if (len > 0) {
                            
                    //    for (var i = 0; i < len; i++)
                    //    {
                    //        var BookingId = jdata[i]['BookingId'];
                    //        var PickupId = jdata[i]['PickupId'];
                    //        var Items = jdata[i]['Items'];
                    //        var Paid = jdata[i]['Paid'];
                    //        var Shipped = jdata[i]['Shipped'];
                    //        var Status = jdata[i]['Status'];

                    //        var newRowContent = "";
                    //        if (Shipped > 0)
                    //        {
                    //            newRowContent = "<tr class='greenClass'>" +
                    //                                            "<td><input type='checkbox' onchange='PropertyCheckControl(this);' class='checkItem'/></td>" +
                    //                                            "<td style='display:none;' class='RowItemStatus'>" + BookingId + "</td>" +
                    //                                            "<td style='display:none;' class='RowItemStatus'>" + PickupId + "</td>" +
                    //                                            "<td class='RowItemStatus'>" + Items + "</td>" +
                    //                                            "<td class='RowItemStatus'>" + Paid + "</td>" +
                    //                                            "<td class='RowItemStatus'>" + Status + "</td>" +
                    //                                             "</tr>";
                    //        }
                    //        else
                    //        {
                    //            newRowContent = "<tr>" +
                    //                                            "<td><input type='checkbox' onchange='PropertyCheckControl(this);' class='checkItem'/></td>" +
                    //                                            "<td style='display:none;' class='RowItemStatus'>" + BookingId + "</td>" +
                    //                                            "<td style='display:none;' class='RowItemStatus'>" + PickupId + "</td>" +
                    //                                            "<td class='RowItemStatus'>" + Items + "</td>" +
                    //                                            "<td class='RowItemStatus'>" + Paid + "</td>" +
                    //                                            "<td class='RowItemStatus'>" + Status + "</td>" +
                    //                                             "</tr>";
                    //        }

                                 
                    //            $("#tblSearchedItem tbody").append(newRowContent);
                    //        }
                            
                    //    }
                    //    else
                    //    {
                    //        // Validation If data not available
                    //        var newRowContent = "<tr>" +
                    //            "<td align='center' colspan='6'>There are no results that match your search</td>" +
                    //             "</tr>";
                    //        $("#tblSearchedItem tbody").append(newRowContent);
                    //    }
                    },
                    error: function (response) {
                    }
                
                });
        }
        function saveStatus()
        {
            if (validateControls()) {

                var vddlItemStatus = $("#<%=ddlItemStatus.ClientID%>").find('option:selected').text().trim();
                
                var vddlItemStatusVal = $("#<%=ddlItemStatus.ClientID%>").find('option:selected').val().trim();;
                //alert(vddlItemStatusVal);
                var vStatusDetails = $("#<%=txtStatusDetails.ClientID%>").val().trim();
                //alert('vddlItemStatus=' + vddlItemStatus);
            
             //Find Each Checked Rows and Update the Status
            if (vddlItemStatus == "Order booked") {
                //alert(vddlItemStatus + '   ' + vStatusDetails);
                var JsonData = {};
                JsonData.BookingId = $("#<%=txtContainerNoORBookingNo.ClientID%>").val().trim();
                JsonData.PickupId = "";
                JsonData.ItemName = "";
                JsonData.Status = vddlItemStatusVal;
                JsonData.StatusDetails = vStatusDetails;
                JsonData.IsOrderBookStatus = 1;
                //alert(JSON.stringify(JsonData));

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "UpdateStatus.aspx/SaveStatus",
                    data: JSON.stringify(JsonData),
                    dataType: "json",
                    success: function (result) {
                        //var jdata = JSON.parse(result.d);
                        //if (jdata > 0) {
                        //    //alert('Status Updated!!');

                        //}
                    }
                });
                $('#Status-bx-msg').text("Status Update Successful...");
                $('#Shipping-bx').modal('show');
                clearAllControls();

            }
            else
            {
                var ErrorMsg = "";

                $('#tblSearchedItem tbody tr').each(function (i, row) {

                    var $actualrow = $(row);
                    $checkbox = $actualrow.find(':checkbox:checked');

                        
                    if ($checkbox.is(':checked')) {

                        var BookingId = $(this).find('td:eq(1)').text().trim();
                        var PickupId = $(this).find('td:eq(2)').text().trim();
                        var ItemName = $(this).find('td:eq(3)').text().trim();

                        var JsonData = {};
                        JsonData.BookingId = BookingId;
                        JsonData.PickupId = PickupId;
                        JsonData.ItemName = ItemName;
                        JsonData.Status = vddlItemStatusVal;
                        JsonData.StatusDetails = vStatusDetails;
                        JsonData.IsOrderBookStatus = 0;
                        //alert(JSON.stringify(JsonData));
                        var newRowContent = "";
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "UpdateStatus.aspx/SaveStatus",
                            data: JSON.stringify(JsonData),
                            dataType: "json",
                            success: function (result) {
                                //alert(result.d);
                                var IsErrActive = 0;
                                var len = result.d.length;
                                //alert(len);
                                if (len > 0) {
                                    //alert(result.d);
                                    ErrorMsg = result.d;
                                    IsErrActive = 1;
                                    $('#Status-bx-msg').text(ErrorMsg);
                                    $('#Shipping-bx').addClass('error_modal');
                                }
                                if (IsErrActive == 0)
                                {
                                    $('#Status-bx-msg').text("Status Update Successful...");
                                    $('#Shipping-bx').removeClass('error_modal');
                                }
                            }
                        });

                        $('#Shipping-bx').modal('show');
                        clearAllControls();
                        //SearchItems();
                    }

                });
                
            }
            
            }
            else
            {
                return false;
            }

            
            return false;
        }

        function validateControls()
        {
            var vContainerNoORBookingNo = $("#<%=txtContainerNoORBookingNo.ClientID%>");
            var vStatus = $("#<%=ddlItemStatus.ClientID%>");
            var vStatusDetails = $("#<%=txtStatusDetails.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vContainerNoORBookingNo.val().trim() == "") {
                vErrMsg.text('Please Enter Container OR Booking Number');
                vErrMsg.css("display", "block");
                vContainerNoORBookingNo.focus();
                return false;
            }
            //alert(vStatus.val() + vStatus.val().trim() + vStatus.find('option:selected').text().trim());

            if (vStatus.val()==null || vStatus.val().trim() == "Select Status") {
                vErrMsg.text('Please select a Status from dropdown');
                vErrMsg.css("display", "block");
                vStatus.focus();
                return false;
            }
            
            if (vStatusDetails.val().trim() == "") {
                vErrMsg.text('Please Enter Status Details');
                vErrMsg.css("display", "block");
                vStatusDetails.focus();
                return false;
            }

            var IsMultipleStatusSelected = 0;
            <%--var vddlItemStatus = $("#<%=ddlItemStatus.ClientID%>").find('option:selected').text().trim();--%>
            var vItemStatus = "";
            var IsCheckboxChecked = 0;
            
            $('#tblSearchedItem tbody tr').each(function (i, row) {
                var $actualrow = $(row);
                $checkbox = $actualrow.find(':checkbox:checked');
                if ($checkbox.is(':checked')) {
                    IsCheckboxChecked++;
                    var Status = $(this).find('td:eq(5)').text().trim();
                    if (IsCheckboxChecked == 1) { vItemStatus = Status }
                    //alert(vddlItemStatus + ' == ' + Status)
                    if (vItemStatus != Status)
                    {
                        IsMultipleStatusSelected = 1;
                    }
                }
            });
            if (IsMultipleStatusSelected == 1)
            {
                vErrMsg.text('Mass update is not possible for items having multiple status');
                vErrMsg.css("display", "block");
                vErrMsg.focus();
                return false;
            }
            if (IsCheckboxChecked == 0 && vStatus.find('option:selected').text().trim() != "Order booked")
            {
                vErrMsg.text('Please select items from the Item list');
                vErrMsg.css("display", "block");
                vErrMsg.focus();
                return false;
            }

            return true;
        }

        function getBookingItemsHistory(PickupId, BookingId, ContainerId) {
            $("#ItemHistory tbody tr").remove();
            var JsonData = {};
            JsonData.PickupId = PickupId;
            JsonData.BookingId = BookingId;
            JsonData.ContainerId = ContainerId;
            var newRowContent = "";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditShipping.aspx/GetBookingItemsHistory",
                data: JSON.stringify(JsonData),
                dataType: "json",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    var len = jdata.length;
                    //alert(JSON.stringify(jdata));

                    if (len > 0) {
                        for (var i = 0; i < len; i++) {
                            newRowContent = "<tr>" +
                                "<td>" + jdata[i]['CreatedOn'] + "</td>" +
                                "<td>" + jdata[i]['Status'] + "</td>" +
                                "<td>" + jdata[i]['StatusDetails'] + "</td>" +
                                "</tr>";
                            $("#ItemHistory tbody").append(newRowContent);
                        }
                    }
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "EditShipping.aspx/GetBookingStatusItemsHistory",
                        data: JSON.stringify(JsonData),
                        dataType: "json",
                        success: function (result) {
                            var jdata = JSON.parse(result.d);
                            var len = jdata.length;
                            //alert(JSON.stringify(jdata));

                            if (len > 0) {

                                newRowContent = "<tr>" +
                                        "<td>" + jdata[0]['Bookingdate'] + "</td>" +
                                        "<td>" + jdata[0]['BookingStatus'] + "</td>" +
                                        "<td>" + jdata[0]['BookingStatusDetails'] + "</td>" +
                                        "</tr>";
                                $("#ItemHistory tbody").append(newRowContent);
                            }
                            //else {
                            //    $("#ItemHistory thead th").remove();
                            //    newRowContent = "<tr><td colspan='2'>No data available</td></tr>"
                            //    $("#ItemHistory tbody").append(newRowContent);
                            //} 
                        }
                    });
                }
            });

            //$('.innerModal,.overlay').modal('show');
            $('.innerModal,.overlay').fadeIn(1500);
        }

        function btnItemHistoryClick() {
            $('.innerModal,.overlay').fadeOut();
            $('#dvBookingNumberModal').modal('focus');
        }

        function clearAllControls() {
            $("#<%=txtStatusDetails.ClientID%>").val('');
            //$("#<%//=ddlItemStatus.ClientID%>").find('option:selected').removeAttr('selected');
            //$('#<%//=ddlItemStatus.ClientID%>').val('').trigger('chosen:updated');
            //$("#<%//=ddlItemStatus.ClientID%>").find('option:selected').text().trim();
            $('#<%=ddlItemStatus.ClientID%>').val(0);
            
            $(".chosen-single span").text('Select Status');
            $('input:checkbox').removeAttr('disabled');
            //$("#<%//=txtContainerNoORBookingNo.ClientID%>").val('');
            //$("#tblSearchedItem tbody tr").remove();
        }

        function btnOKClick() {
            //$('#Shipping-bx').text('');
            SearchItems();
            MaillingTheChangedStatus();
            //setTimeout(function () {
            //    MaillingTheChangedStatus();
            //}, 1000);
            
        }

        function MaillingTheChangedStatus() {
            var ContainerNoORBookingNo = $("#<%=txtContainerNoORBookingNo.ClientID%>").val().trim();
            
                var jQueryDataTableContent = "<table border=1>";
                jQueryDataTableContent += "<tr>";
                jQueryDataTableContent += "<th>BookingId</th>";
                jQueryDataTableContent += "<th>Items</th>";
                jQueryDataTableContent += "<th>Status</th>";
                jQueryDataTableContent += "</tr>";

                var vTableRow = "";

                $('#tblSearchedItem tbody tr').each(function (i, row) {
                    var BookingId = $(this).find('td:eq(1)').text().trim();
                    var Item = $( this ).find( 'td:eq(3)' ).text().trim();
                    var Status = $( this ).find( 'td:eq(5)' ).text().trim();
                    //alert(BookingId +' '+ Item +' '+ Status);
                    vTableRow += "<tr>"
                    vTableRow += "<td>" + BookingId + "</td>";
                    vTableRow += "<td>" + Item + "</td>";
                    vTableRow += "<td>" + Status + "</td>";
                    vTableRow += "</tr>";

                });

                jQueryDataTableContent += vTableRow;
                jQueryDataTableContent += "</table>";

                //Booking Mail
                sendBookingByEmail(jQueryDataTableContent, ContainerNoORBookingNo);


        }

        function sendBookingByEmail(jQueryDataTableContent, ContainerNoORBookingNo)
        {
            //alert(jQueryDataTableContent);
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "UpdateStatus.aspx/SendBookingStatusByEmail",
                data: "{ jQueryDataTableContent: '" + jQueryDataTableContent + "', ContainerNoORBookingNo: '" + ContainerNoORBookingNo + "'}",
                dataType: "json",
                success: function (result) {
                    
                },
                error: function (response) {
                    
                }
            });

        }//end of function

        function searchByColor(Status)
        {
            //alert('Status = ' + Status);
            //$("#tblSearchedItem tbody tr").filter(function () {
            //    $(this).toggle($(this).text().toLowerCase().indexOf(Status.toLowerCase()) > -1)
            //    });

            $("#tblSearchedItem tbody tr").filter(function () {
                //Filter Glibally
                //$('#tblSearchedItem').DataTable().search(Status).draw();
                //Filter By Column
                $('#tblSearchedItem').DataTable().column(5).search(Status).draw();
            });
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="col-lg-12 text-center welcome-message">
        <h2>Enquiry
                </h2>
        <p></p>
    </div>

    <div class="col-md-12">
        <form id="frmUpdateStatus" runat="server">
            <asp:HiddenField ID="hfMenusAccessible" runat="server" />
            <asp:HiddenField ID="hfControlsAccessible" runat="server" />

            <div class="add_shipping_form row">
                <div class="panel-heading">
                    <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                        Style="text-align: center; width:100%" runat="server" Text="" Font-Size="Small"></asp:Label>
                    <asp:HiddenField ID="hfCustomerId" runat="server" />
                </div>
                <div class="panel-body clrBLK col-md-12 box_bg">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group row">
                                <label class="col-sm-3 label1">
                                    Container No / Booking No<span style="color: red">*</span></label>
                                <div class="col-sm-9">
                                    <div class="row">
                                        <div class="col-sm-9"><asp:TextBox ID="txtContainerNoORBookingNo" Style="background:none !important" runat="server"
                                        CssClass="form-control m-b"></asp:TextBox></div>
                                        <div class="col-sm-3">
                                            <div id="divddlContainerNo">
                                                <asp:Button ID="btnSearchItems" runat="server" Text="Search"
                                                    CssClass="btn btn-warning StatusButton" OnClientClick="return SearchItems();" UseSubmitBehavior="False" />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    
                                    
                                </div>
                            </div>
                        </div>
                        <%--<div class="col-md-6">
                            <div class="form-group row divbtnSearchItems">


                            </div>
                        </div>--%>
                    </div>
                    <asp:HiddenField ID="RefUrl" runat="server" />
                    
                    <div class="colorCode colorCode1">
                        <strong>Key</strong>
                        <ul>
                            <li class="blue_box" onclick="searchByColor('Order booked')" data-toggle="tooltip" data-placement="right" title="Order booked UK"></li>
                            <li class="pink_box" onclick="searchByColor('Item Assigned To Driver')" data-toggle="tooltip" data-placement="right" title="Item Assigned To Driver UK"></li>
                            <li class="perpel_box" onclick="searchByColor('Item Picked Up')" data-toggle="tooltip" data-placement="right" title="Item Picked Up UK"></li>
                            <li class="orange_box" onclick="searchByColor('Item In Warehouse')" data-toggle="tooltip" data-placement="right" title="Item In Warehouse UK"></li>
                            <li class="green_box" onclick="searchByColor('Item Shipped from Warehouse')" data-toggle="tooltip" data-placement="right" title="Item Shipped from Warehouse UK"></li>
                            <li class="deepgreen_box" onclick="searchByColor('Item Received in Warehouse')" data-toggle="tooltip" data-placement="right" title="Item Received in Warehouse Ghana"></li>
                            <li class="brown_box" onclick="searchByColor('Item out for delivery')" data-toggle="tooltip" data-placement="right" title="Item out for delivery Ghana"></li>
                            <li class="red_box" onclick="searchByColor('Delivered')" data-toggle="tooltip" data-placement="right" title="Delivered Ghana"></li>
                            <li class="white_box" onclick="searchByColor('')" data-toggle="tooltip" data-placement="right" title="Clear Search"></li>
                        </ul>
                    </div>
                     <div class="tble_main">
                    <table border="1" style="color: white; width: 100%;" id="tblSearchedItem">
                        <thead>
                            <tr>
                                <th><span><input type='checkbox' class="checkall" /></span><strong>All</strong></th>
                                <%--<th style='display:none;'>Booking Id</th>--%>
                                <th class="view">Booking Id</th>
                                <th>Item Id</th>
                                <th>Items</th>
                                <th>Paid</th>
                                <th>Status</th>
                                <th>IsContainer</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
</div>
                    <div class="row" style="display:none;">
                        <div class="col-sm-6">
                            <div class="form-group row">
                                <label class="col-sm-4 label1">
                                    Select Status<span style="color: red">*</span>
                                </label>
                                <div id="divddlItemStatus" class="col-sm-8 no_marg_select">
                                    <asp:DropDownListChosen ID="ddlItemStatus" runat="server"
                                        CssClass="vat-option label-lgt"
                                        DataPlaceHolder="Select Status"
                                        AllowSingleDeselect="true"
                                        NoResultsText="No result found" 
                                        DisableSearchThreshold="10">
                                        <%--<asp:ListItem Selected="True" Value="Select Status">Select Status</asp:ListItem>--%>
                                    </asp:DropDownListChosen>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group row">
                                <label class="col-sm-4 label1">
                                    Enter Status Details<span style="color: red">*</span>
                                </label>
                                <div class="col-sm-8 divStatusDetails">
                                    <asp:TextBox ID="txtStatusDetails" Style="background:none !important" runat="server" TextMode="MultiLine"
                                        CssClass="form-control m-b" PlaceHolder=""
                                        title="Please enter Status Details" MaxLength="500"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                    

                    


                    

                    <!--Added new Script Files for Date Picker-->
                    <script src="/js/bootstrap-datepicker.js"></script>
                    <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                    <div class="row">
                        <br />
                    </div>

                    <div class="row">
                        <% for (int i = 0; i < 4; i++)
                            { %>
                        <br />
                        <%  } %>
                    </div>
                    <div class="form-group row"  style="display:none;">
                        <div class="col-sm-12 text-center">
                            <asp:Button ID="btnSaveStatus" runat="server" Text="Save Status"
                                CssClass="btn btn-warning StatusButton1" OnClientClick="return saveStatus();" />
                            <asp:Button ID="btnBackStatus" runat="server" Text="Back" class="btn btn-warning StatusButton1" OnClick="btnBackStatus_Click"
                                 />
                        </div>
                    </div>

                    <div class="modal fade" id="Shipping-bx" role="dialog">
                        <div class="modal-dialog">

                            <!-- Modal content-->
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #f0ad4ecf;">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title">Status Update</h4>
                                </div>
                                <div class="modal-body" style="text-align: center; font-size: 22px;">
                                    <p id="Status-bx-msg"></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" data-dismiss="modal"
                                                 onclick="btnOKClick()">
                                                OK</button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="overlay"></div>
    <div class="innerModal" id="Shipping-Item-bx">
        <div class="modal-dialog2">
            <div class="modal-content2">
                <div class="modal-header2" style="background-color: #324153;">
                    <button type="button" class="close" onclick="btnItemHistoryClick()">&times;</button>
                    <div class="infoLogo"><img src="../images/info-logo.png" /></div>
                    <h4 class="modal-title" style="font-size: 24px; color:white;">Item Status History</h4>
                </div>
                <div class="modal-body2" style="text-align: center; font-size: 22px; color:black;">
                    <table id="ItemHistory" style="width:100%">
                        <thead>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Comments</th>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer2">
                    <button type="button" onclick="btnItemHistoryClick()" class="btn btn-primary" id="btnItemHistory">
                        OK</button>
                </div>
            </div>
        </div>
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
    
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" CodeBehind="Tracking.aspx.cs" Inherits="JobyCoWebCustomize.Tracking" %>
<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <%--<link href="../css/jquery.mCustomScrollbar.css" rel="stylesheet" />--%>
    <%--<link href="../styles/jquery.dataTables.min.css" rel="stylesheet" />--%>
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
            display: none !important;
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

            // restriction on space input
           <%-- $("#<%=txtContainerNoORBookingNo.ClientID%>").on("keypress", function (e) {
                //alert('Press');
                if (e.which === 32)
                    e.preventDefault();
            });--%>
            $('#ItemHeading').css('display', 'none');
            //SearchItems();

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
                
                getBookingItemsHistory(PickupId, BookingId, ContainerId, 'moreItem');
            });


            

            $('#btnBackStatus').on('click', function () {
                 //var lastUrl = $("#<%//=RefUrl.ClientID%>").val();
                 //alert(lastUrl);
                 window.location.replace(lastUrl); 
            });

            $('[data-toggle="tooltip"]').tooltip();

            var BookingId = getUrlVars();
            $("#<%=txtContainerNoORBookingNo.ClientID%>").val(BookingId);
            SearchItems();
        }); //Ready END

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
            $("#LowestMoreItem ul").html("");
            //$('input:checkbox').removeAttr('checked');

            var ContainerNoORBookingNo = $("#<%=txtContainerNoORBookingNo.ClientID%>").val().trim();
            //alert(ContainerNoORBookingNo);
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Tracking.aspx/SearchByContainerNoORBookingNo",
                data: "{ ContainerNoORBookingNo: '" + ContainerNoORBookingNo.toUpperCase() + "'}",
                dataType: "json",
                beforeSend: function () {
                    //$("#loadingDiv").show();
                    $("#loadingDiv").css('display', 'flex');
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 300);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    var len = jdata.length;
                    var tblContent = "";
                    var BookingId = "";
                    var PickupId = "";
                    if (len > 0) {
                        var StatusId = parseInt(jdata[0]["StatusId"]);
                        for (var i = 0; i < len; i++) {
                            tblContent += '<tr role="row">' +
                            '<td class="hideColumn sorting_1"><input type="checkbox" onchange="PropertyCheckControl(this);" class="checkItem"></td>' +
                            '<td class="RowItemStatus hideColumn">' + jdata[i]["BookingId"] + '</td>' +
                            '<td class=" hideColumn">' + jdata[i]["PickupId"] + '</td>' +
                            '<td class=" RowItemStatus">' + jdata[i]["Items"] + ' </td>' +
                            '<td class=" RowItemStatus hideColumn">' + jdata[i]["Paid"] + '</td>' +
                            '<td class=" RowItemStatus hideColumn">' + jdata[i]["Status"] + '</td>' +
                            '<td class=" hideColumn hideColumn">' + jdata[i]["IsContainer"] + '</td>' +
                            '</tr>';

                            var tempStatusId = parseInt(jdata[i]["StatusId"]);
                            if (StatusId > tempStatusId || tempStatusId == StatusId) {
                                StatusId = tempStatusId;
                                BookingId = jdata[i]["BookingId"];
                                PickupId = jdata[i]["PickupId"];
                            }

                        }
                        $('#ItemHeading').css('display', 'block');
                        $("#tblSearchedItem tbody").append(tblContent);

                        //=========================Fetch Lowest Status History

                        getBookingItemsHistory(PickupId, BookingId, "", 'LowestMoreItem');
                    }
                    else {
                        $("#LowestMoreItem ul").html('<li style="color:#fca311">No data found!!</li>');
                        $('#ItemHeading').css('display', 'none');
                    }
                    //========================= clear destroy
                    //if ($.fn.dataTable.isDataTable('#tblSearchedItem')) {
                    //    $('#tblSearchedItem').DataTable().clear().destroy();
                    //}

                    //$('#tblSearchedItem').DataTable({
                    //    data: jdata,
                    //    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    //        //add class on the basis of Status Color Code
                    //        if (parseInt(aData["StatusId"]) == 1) {
                    //            $(nRow).addClass('blue_box');
                    //        }
                    //        else if (parseInt(aData["StatusId"]) == 2) {
                    //            $(nRow).addClass('perpel_box');
                    //        }
                    //        else if (parseInt(aData["StatusId"]) == 3) {
                    //            $(nRow).addClass('deepgreen_box');
                    //        }
                    //        else if (parseInt(aData["StatusId"]) == 4) {
                    //            $(nRow).addClass('orangeClass');
                    //        }
                    //        else if (parseInt(aData["StatusId"]) == 5) {
                    //            $(nRow).addClass('greenClass');
                    //        }
                    //        else if (parseInt(aData["StatusId"]) == 6) {
                    //            $(nRow).addClass('brown_box');
                    //        }
                    //        else if (parseInt(aData["StatusId"]) == 7) {
                    //            $(nRow).addClass('red_box');
                    //        }
                    //    },

                    //    columnDefs: [
                    //                    {
                    //                        targets: [0],
                    //                        className: "hideColumn",
                    //                    },
                                        
                    //                    {
                                            
                    //                        targets: [1],
                    //                        className: "RowItemStatus",
                    //                    },
                    //                    {
                    //                        targets: [2],
                    //                        className: "hideColumn",
                    //                    },
                    //                    {
                    //                        targets: [3],
                    //                        className: "RowItemStatus"
                    //                    },
                    //                    {
                    //                        targets: [4],
                    //                        className: "RowItemStatus"
                    //                    },
                    //                    {
                    //                        targets: [5],
                    //                        className: "RowItemStatus"
                    //                    },
                    //                    {
                    //                        targets: [6],
                    //                        className: "hideColumn"
                    //                    }

                    //    ],
                    //    columns: [
                    //        {
                    //            defaultContent:
                    //              "<input type='checkbox' onchange='PropertyCheckControl(this);' class='checkItem'/>"
                    //        },
                    //        { data: "BookingId" },
                    //        { data: "PickupId" },
                    //        { data: "Items" },
                    //        { data: "Paid" },
                    //        { data: "Status" },
                    //        { data: "IsContainer" }
                    //    ]
                    //});

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
        

        function getBookingItemsHistory(PickupId, BookingId, ContainerId, ULDivId) {
            //$("#moreItem").remove();
            $("#" + ULDivId + " ul").html("");
            var JsonData = {};
            JsonData.PickupId = PickupId;
            JsonData.BookingId = BookingId;
            JsonData.ContainerId = ContainerId;

            //alert(JSON.stringify(JsonData));
            var newRowContent = "";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Tracking.aspx/GetBookingItemsTracking",
                data: JSON.stringify(JsonData),
                dataType: "json",
                beforeSend: function () {
                    $("#loadingDiv").show();
                },
                complete: function () {
                    setTimeout(function () {
                        $('#loadingDiv').fadeOut();
                    }, 300);
                },
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    var len = jdata.length;
                    //alert(JSON.stringify(jdata));
                    var iCount = 0;
                    if (len > 0) {
                        for (var i = 0; i < len; i++) {
                            
                            if (jdata[i]['CreatedOn'] != '') {
                                newRowContent += '<li class="progress-step is-complete">' +
                                  '<span class="progress-marker"></span>' +
                                  '<span class="progress-text">' +
                                    '<h4 class="progress-title">' + jdata[i]['Status'] + '</h4>' +
                                    '<p class="first_time">' + jdata[i]['CreatedOn'] + '</p>' +
                                    '<p>' + jdata[i]['StatusDetails'] + '</p>' +
                                  '</span>' +
                                '</li>';
                            }
                            else {
                                if (iCount == 0)
                                {
                                    iCount = 1;
                                    //newRowContent += '<li class="progress-step is-active">' +
                                    newRowContent += '<li class="progress-step">' +
                                                                      '<span class="progress-marker"></span>' +
                                                                      '<span class="progress-text">' +
                                                                        '<h4 class="progress-title">' + jdata[i]['Status'] + '</h4>' +
                                                                        '<p class="first_time">' + jdata[i]['CreatedOn'] + '</p>' +
                                                                        '<p>' + jdata[i]['StatusDetails'] + '</p>' +
                                                                      '</span>' +
                                                                    '</li>';
                                }
                                else
                                {
                                    newRowContent += '<li class="progress-step">' +
                                  '<span class="progress-marker"></span>' +
                                  '<span class="progress-text">' +
                                    '<h4 class="progress-title">' + jdata[i]['Status'] + '</h4>' +
                                    '<p class="first_time">' + jdata[i]['CreatedOn'] + '</p>' +
                                    '<p>' + jdata[i]['StatusDetails'] + '</p>' +
                                  '</span>' +
                                '</li>';
                                }

                                
                            }
                            

                            
                        }
                        $("#" + ULDivId + " ul").append(newRowContent);
                    }
                }
            });

            
            if (ULDivId == "moreItem")
            $('#more').modal('show');
        }

        function btnItemHistoryClick() {
            //$('.innerModal,.overlay').fadeOut();
            //$('#dvBookingNumberModal').modal('focus');
            $('#more').modal('hide');
        }

        function clearAllControls() {
            //$("#<%//=txtStatusDetails.ClientID%>").val('');
            //$("#<%//=ddlItemStatus.ClientID%>").find('option:selected').removeAttr('selected');
            //$('#<%//=ddlItemStatus.ClientID%>').val('').trigger('chosen:updated');
            //$("#<%//=ddlItemStatus.ClientID%>").find('option:selected').text().trim();
            //$('#<%//=ddlItemStatus.ClientID%>').val(0);
            
            $(".chosen-single span").text('Select Status');
            $('input:checkbox').removeAttr('disabled');
            //$("#<%//=txtContainerNoORBookingNo.ClientID%>").val('');
            //$("#tblSearchedItem tbody tr").remove();
        }

        function btnOKClick() {
            //$('#Shipping-bx').text('');
            SearchItems();
        }
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

    <%--<div class="col-md-12">
               <div class="tracing_inr clearfix">
                   <div class="srch_top">
                           <p>Track Your Order</p>
                           <label>Booking No :
                         <span><input type="text" placeholder="Enter Your Booking Id">
                         <button type="submit" class="bking_sbmt"><img src="images/srch_book.png"/></button>
                        </span> </label>
                   </div>

                  <div class="col-sm-8">
                        <ul class="progress-tracker progress-tracker--vertical">
                                <li class="progress-step is-complete" >
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Picked Up</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step is-complete">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item in Jobyco Facility UK</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step is-complete">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Shifted</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step is-active">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item in Jobyco Facility Ghana</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Out for Delivery</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Delivered</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                       </ul>
                  </div>
                  <div class="col-sm-4">
                      <div class="rght_prdct">
                          <h2>Your Item's</h2>
                         <span>
                            <p>Cooking Oil Cooking Oil (3/box)</p>
                            <a href="#" data-toggle="modal" data-target="#more">More</a>
                         </span>
                         <span>
                            <p>Cooking Oil Cooking Oil (3/box)</p>
                            <a href="#" data-toggle="modal" data-target="#more">More</a>
                         </span>
                      </div>
                </div>
               </div>
            </div>--%>


     <div class="col-lg-12 text-center welcome-message">
        <h2>Tracking
                </h2>
        <p></p>
    </div>

    <div class="col-md-12">
        <form id="frmUpdateStatus" runat="server">
            <asp:HiddenField ID="hfMenusAccessible" runat="server" />
            <asp:HiddenField ID="hfControlsAccessible" runat="server" />
            <asp:HiddenField ID="hfEmailID" runat="server" />
            <div class="add_shipping_form">
                <div class="panel-heading">
                    <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                        Style="text-align: center; width:100%" runat="server" Text="" Font-Size="Small"></asp:Label>
                    <asp:HiddenField ID="hfCustomerId" runat="server" />
                </div>
                    <div class="container">

                <div id="pnl_srch_main" class="panel-body clrBLK box_bg">
                    <div class="row">
                        <div class="col-md-12">
                            <div id="frm_grp_a" class="form-group">
                                        <h3>Booking No<span style="color: red">*</span></h3>
                                     
                                   <div class="srch_book">
                                            <asp:TextBox ID="txtContainerNoORBookingNo" Style="background:none !important" runat="server"
                                        CssClass="form-control m-b"></asp:TextBox>
                                             <div id="divddlContainerNo">
                                                <asp:Button ID="btnSearchItems" runat="server" Text=""
                                                    CssClass="btn btn-warning StatusButton" OnClientClick="return SearchItems();" UseSubmitBehavior="False" />
                                            </div>
                                        </div>
                            </div>
                        </div>
                    </div>
                    <asp:HiddenField ID="RefUrl" runat="server" />
                    
                    <div class="colorCode colorCode1">
                        <strong></strong>
                        <ul>
                            <li class="blue_box" onclick="searchByColor('Order booked')" data-toggle="tooltip" data-placement="right" title="Order booked"></li>
                            <li class="perpel_box" onclick="searchByColor('Item Picked Up')" data-toggle="tooltip" data-placement="right" title="Item Picked Up"></li>
                            <li class="deepgreen_box" onclick="searchByColor('Item To Reach Warehouse')" data-toggle="tooltip" data-placement="right" title="Item To Reach Warehouse"></li>
                            <li class="orange_box" onclick="searchByColor('Item In Warehouse')" data-toggle="tooltip" data-placement="right" title="Item In Warehouse"></li>
                            <li class="green_box" onclick="searchByColor('Item Shipped from Warehouse')" data-toggle="tooltip" data-placement="right" title="Item Shipped from Warehouse"></li>
                            <li class="brown_box" onclick="searchByColor('Item out for delivery')" data-toggle="tooltip" data-placement="right" title="Item out for delivery"></li>
                            <li class="red_box" onclick="searchByColor('Delivered')" data-toggle="tooltip" data-placement="right" title="Delivered"></li>
                            <li class="white_box" onclick="searchByColor('')" data-toggle="tooltip" data-placement="right" title="Clear Search"></li>
                        </ul>
                    </div>
                     <div class="row">
                     <div id="LowestMoreItem" class="col-sm-8">
                         <ul class="progress-tracker progress-tracker--vertical">
                                
                       </ul>
                         </div>
                     <div class="col-sm-4">
                     <div class="tble_book_item tble_main">
                         <p id="ItemHeading">Your Item's</p>
                    <table border="1" style="color: black; width: 100%;" id="tblSearchedItem">
                       <%-- <thead>
                            <tr>
                                <th  style='display:none;'><span><input type='checkbox' class="checkall" /></span><strong>All</strong></th>
                                <th style='display:none;' class="view">Booking Id</th>
                                <th style='display:none;'>Pickup Id</th>
                                <th>Items</th>
                                <th>Paid</th>
                                <th>Status</th>
                                <th style='display:none;'>IsContainer</th>
                            </tr>
                        </thead>--%>
                        <tbody>
                            <%--<tr>
                                <td data-toggle="modal" data-target="#more">
                                    <div>
                                        Cooking Oil Cooking Oil (3/box)
                                    </div>
                                </td>
                            </tr>
                             <tr>
                                <td data-toggle="modal" data-target="#more">
                                    <div>
                                        Cooking Oil Cooking Oil (3/box)
                                    </div>
                                </td>
                            </tr>--%>
                        </tbody>
                    </table>
                    </div>
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
                    <h4 class="modal-title" style="font-size: 24px; color:white;">Item Tracking History</h4>
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
                </div>
                <div class="col-md-12">
                    <hr />
                    <footer>
                        <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                    </footer>
                </div>
            </div>



            <!-- Modal -->
 <div class="modal fade" id="more" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content255">
        <div class="modal-header2" style="background-color: #324153;">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <div class="infoLogo"><img src="images/info-logo.png"></div>
            <h4 class="modal-title" style="font-size: 24px; color:white;">Item Status History</h4>
        </div>
        <div id="moreItem" class="modal-body2" style="text-align: center; font-size: 22px; color:black;">
            <ul  class="progress-tracker progress-tracker--vertical">
                                <%--<li class="progress-step is-complete">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Picked Up</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step is-complete">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item in Jobyco Facility UK</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step is-complete">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Shifted</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step is-active">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item in Jobyco Facility Ghana</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Out for Delivery</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>
                                <li class="progress-step">
                                  <span class="progress-marker"></span>
                                  <span class="progress-text">
                                    <h4 class="progress-title">Item Delivered</h4>
                                    <p class="first_time">7th august 2019 <time>7:36 pm</time></p>
                                    <p>Summary text explaining this step to the user</p>
                                  </span>
                                </li>--%>
                       </ul>
        </div>
        <div class="modal-footer2">
            <button type="button" data-dismiss="modal" class="btn btn-primary" id="btnItemHistory">
                OK</button>
        </div>
    </div>    </div>    </div>
        </form>
    </div>

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" CodeBehind="AssignBookedItemToBox.aspx.cs" Inherits="JobyCoWebCustomize.AssignBookedItemToBox" %>

<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="../css/jquery.mCustomScrollbar.css" rel="stylesheet" />
    <link href="../styles/jquery.dataTables.min.css" rel="stylesheet" />
    <style type="text/css">
        /*.RowItemStatus {
            cursor: pointer;
        }*/
        .ItemShipped td {
            color:aqua !important;
        }
        .hideColumn {
            display: none;
        }
    </style>
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jquery.blockUI.js"></script>


    <script>
        // unblock when ajax activity stops 
        $(document).ajaxStop($.unblockUI);

        function mainMenu() {
            $.ajax({
                url: 'Dashboard.aspx',
                cache: false
            });
        }


        $(document).ready(function () { //Ready Start

            //$.blockUI({
            //    message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    css: {
            //        border: 'none',
            //        backgroundColor: 'transparent'
            //    }

            //});

            //mainMenu();

            // restriction on space input
            $("#<%=txtBookingNo.ClientID%>").on("keypress", function (e) {
                //alert('Press');
                if (e.which === 32)
                    e.preventDefault();
            });

            SearchItems();

        }); //Ready End

        function SearchItems()
        {

            //$.blockUI({
            //    message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    css: {
            //        border: 'none',
            //        backgroundColor: 'transparent'
            //    }

            //});

            //mainMenu();

            $("#tblSearchedBookedItem tbody tr").remove();

            $('input:checkbox').removeAttr('checked');

            var BookingNo = $("#<%=txtBookingNo.ClientID%>").val().trim();

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "AssignBookedItemToBox.aspx/ItemSearchByBookingNo",
                data: "{ BookingNo: '" + BookingNo.toUpperCase() + "'}",
                dataType: "json",
                success: function (result) {
                    var jdata = JSON.parse(result.d);
                    //alert(JSON.stringify(jdata));
                    //========================= clear destroy
                    //if ($.fn.dataTable.isDataTable('#tblSearchedBookedItem')) {
                    //    $('#tblSearchedBookedItem').DataTable().clear().destroy();
                    //}

                    //$('#tblSearchedBookedItem').DataTable({
                    //    data: jdata,
                    //    columnDefs: [
                    //                    {
                    //                        targets: [1],
                    //                        className: "hideColumn",
                    //                    },
                                        
                    //                    {
                    //                        targets: [2],
                    //                        className: "hideColumn",
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

                    },
                    error: function (response) {
                    }
                
            });
            //return false;
        }

    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

       <div class="col-lg-12 text-center welcome-message">
        <h2>Assign Item To Box
                </h2>
        <p></p>
    </div>

    <div class="col-md-12">
        <form id="frmAssignItemToBox" runat="server">

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
                                    Booking No<span style="color: red">*</span></label>
                                <div class="col-sm-9">
                                    <div class="row">
                                        <div class="col-sm-9"><asp:TextBox ID="txtBookingNo" Style="background:none !important" runat="server"
                                        CssClass="form-control m-b"></asp:TextBox></div>
                                        <div class="col-sm-3">
                                            <div id="divSearchItems">
                                                <asp:Button ID="btnSearchItems" runat="server" Text="Search"
                                                    CssClass="btn btn-warning StatusButton" OnClientClick="return SearchItems();" UseSubmitBehavior="False" />
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:HiddenField ID="RefUrl" runat="server" />
                    
                    <%--<div class="colorCode colorCode1">
                        <strong>Key</strong>
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
                    </div>--%>


                    <table border="1" style="color: black; width: 100%;" id="tblSearchedBookedItem">
                        <thead>
                            <tr>
                                <th><span><input type='checkbox' class="checkall" /></span><strong>All</strong></th>
                                <th style='display:none;'>Booking Id</th>
                                <th style='display:none;'>Pickup Id</th>
                                <th>Items</th>
                                <th>Paid</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>

                    <div class="form-group row">
                        <label class="col-sm-4 label1">
                            Select Box<span style="color: red">*</span>
                        </label>
                        <div id="divddlBox" class="col-sm-8">
                            <asp:DropDownListChosen ID="ddlBox" runat="server"
                                CssClass="vat-option label-lgt"
                                DataPlaceHolder="Please select an option"
                                AllowSingleDeselect="true"
                                NoResultsText="No result found"
                                DisableSearchThreshold="10">
                                <asp:ListItem Selected="True">Select Box</asp:ListItem>
                            </asp:DropDownListChosen>
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
                    <div class="form-group row">
                        <div class="col-sm-12 text-center">
                            <asp:Button ID="btnSaveStatus" runat="server" Text="Save Status"
                                CssClass="btn btn-warning StatusButton1" OnClientClick="return saveStatus();" />
                            <asp:Button ID="btnBackStatus" runat="server" Text="Back" class="btn btn-warning StatusButton1"
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
    <%--<div class="innerModal" id="Shipping-Item-bx">
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
    </div>--%>

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

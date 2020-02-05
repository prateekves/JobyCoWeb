<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="UserAccess.aspx.cs" Inherits="JobyCoWeb.UserAccess" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>

<style>
    .no-check {

    }
    .yes-check {

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
    $(document).ready(function () {
        //getAllUserIds();
        //getAllUserAccess();

        //$('#dtUserAccess').css('word-wrap', 'break-word');
        //$('#dtUserAccess').css('word-break', 'break-all');
    });
</script>

<script>
    function showCheckBox(vIsChecked) {
        switch (vIsChecked) {
            case false:
                vIsChecked = "<input type='checkbox' class='no-check'>";
                break;

            case true:
                vIsChecked = "<input type='checkbox' class='yes-check' checked>";
                break;
        }

        return vIsChecked;
    }

    function getNoOfTableRows() {
        var count = 0;
        $('#dtUserAccess tr').each(function () {
            count++;
        });

        return count;
    }

    function getAllUserIds() {
        $.ajax({
            method: "POST",
            contentType: "application/json, charset=utf-8",
            url: "UserAccess.aspx/GetAllUserIds",
            data: "{}",
            success: function (result) {
                $.each(result.d, function (key, value) {
                    $("#<%=ddlUserId.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                });
            },
            error: function (response) {
                alert('Unable to Get All UserIds');
            }
        });
    }

    function getSpecificUserAccess(UserId) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "UserAccess.aspx/GetSpecificUserAccess",
            data: "{UserId: '" + UserId + "'}",
            success: function (result) {
                var jsonUserAccess = JSON.parse(result.d);

                $('#dtUserAccess').DataTable({
                    data: jsonUserAccess,
                    columns: [
                        //{ data: "UserId" },//0
                        //{ data: "RoleName" },//1
                        {
                            data: "WhetherDefault",//2
                            render: function (jsonWhetherDefault) {
                                return showCheckBox(jsonWhetherDefault);
                            }
                        },
                        { data: "Menu_Name" },//3
                        {
                            data: "AssignBookingToDriver",//4
                            render: function (jsonAssignBookingToDriver) {
                                return showCheckBox(jsonAssignBookingToDriver);
                            }
                        },
                        //{ data: "AssignBookingToDriverId" },//5
                        {
                            data: "AddDriverToAssignBooking",//6
                            render: function (jsonAddDriverToAssignBooking) {
                                return showCheckBox(jsonAddDriverToAssignBooking);
                            }
                        },
                        //{ data: "AddDriverToAssignBookingId" },//7
                        {
                            data: "AddBooking",//8
                            render: function (jsonAddBooking) {
                                return showCheckBox(jsonAddBooking);
                            }
                        },
                        //{ data: "AddBookingId" },//9
                        {
                            data: "AddShipping",//10
                            render: function (jsonAddShipping) {
                                return showCheckBox(jsonAddShipping);
                            }
                        },
                        //{ data: "AddShippingId" },//11
                        {
                            data: "AddCustomer",//12
                            render: function (jsonAddCustomer) {
                                return showCheckBox(jsonAddCustomer);
                            }
                        },
                        //{ data: "AddCustomerId" },//13
                        {
                            data: "AddDriver",//14
                            render: function (jsonAddDriver) {
                                return showCheckBox(jsonAddDriver);
                            }
                        },
                        //{ data: "AddDriverId" },//15
                        {
                            data: "AddWarehouse",//16
                            render: function (jsonAddWarehouse) {
                                return showCheckBox(jsonAddWarehouse);
                            }
                        },
                        //{ data: "AddWarehouseId" },//17
                        {
                            data: "AddLocation",//18
                            render: function (jsonAddLocation) {
                                return showCheckBox(jsonAddLocation);
                            }
                        },
                        //{ data: "AddLocationId" },//19
                        {
                            data: "AddZone",//20
                            render: function (jsonAddZone) {
                                return showCheckBox(jsonAddZone);
                            }
                        },
                        //{ data: "AddZoneId" },//21
                        {
                            data: "AddUser",//22
                            render: function (jsonAddUser) {
                                return showCheckBox(jsonAddUser);
                            }
                        },
                        //{ data: "AddUserId" },//23
                        {
                            data: "PrintDetails",//24
                            render: function (jsonPrintDetails) {
                                return showCheckBox(jsonPrintDetails);
                            }
                        },
                        //{ data: "PrintDetailsId" },//25
                        {
                            data: "ExportToPDF",//26
                            render: function (jsonExportToPDF) {
                                return showCheckBox(jsonExportToPDF);
                            }
                        },
                        //{ data: "ExportToPDFId" },//27
                        {
                            data: "ExportToExcel",//28
                            render: function (jsonExportToExcel) {
                                return showCheckBox(jsonExportToExcel);
                            }
                        }
                        //{ data: "ExportToExcelId" }//29
                    ],
                    "bDestroy": true
                });

                disableAllCheckBoxesNonExistingOnPage();
            },
            error: function (response) {
                alert('Unable to Bind All User Access');
            }
        });//end of ajax

        return false;
    }

    function getSpecificRoleAccess(RoleName) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "UserAccess.aspx/GetSpecificRoleAccess",
            data: "{RoleName: '" + RoleName + "'}",
            success: function (result) {
                var jsonUserAccess = JSON.parse(result.d);

                $('#dtUserAccess').DataTable({
                    data: jsonUserAccess,
                    columns: [
                        //{ data: "UserId" },//0
                        //{ data: "RoleName" },//1
                        {
                            data: "WhetherDefault",//2
                            render: function (jsonWhetherDefault) {
                                return showCheckBox(jsonWhetherDefault);
                            }
                        },
                        { data: "Menu_Name" },//3
                        {
                            data: "AssignBookingToDriver",//4
                            render: function (jsonAssignBookingToDriver) {
                                return showCheckBox(jsonAssignBookingToDriver);
                            }
                        },
                        //{ data: "AssignBookingToDriverId" },//5
                        {
                            data: "AddDriverToAssignBooking",//6
                            render: function (jsonAddDriverToAssignBooking) {
                                return showCheckBox(jsonAddDriverToAssignBooking);
                            }
                        },
                        //{ data: "AddDriverToAssignBookingId" },//7
                        {
                            data: "AddBooking",//8
                            render: function (jsonAddBooking) {
                                return showCheckBox(jsonAddBooking);
                            }
                        },
                        //{ data: "AddBookingId" },//9
                        {
                            data: "AddShipping",//10
                            render: function (jsonAddShipping) {
                                return showCheckBox(jsonAddShipping);
                            }
                        },
                        //{ data: "AddShippingId" },//11
                        {
                            data: "AddCustomer",//12
                            render: function (jsonAddCustomer) {
                                return showCheckBox(jsonAddCustomer);
                            }
                        },
                        //{ data: "AddCustomerId" },//13
                        {
                            data: "AddDriver",//14
                            render: function (jsonAddDriver) {
                                return showCheckBox(jsonAddDriver);
                            }
                        },
                        //{ data: "AddDriverId" },//15
                        {
                            data: "AddWarehouse",//16
                            render: function (jsonAddWarehouse) {
                                return showCheckBox(jsonAddWarehouse);
                            }
                        },
                        //{ data: "AddWarehouseId" },//17
                        {
                            data: "AddLocation",//18
                            render: function (jsonAddLocation) {
                                return showCheckBox(jsonAddLocation);
                            }
                        },
                        //{ data: "AddLocationId" },//19
                        {
                            data: "AddZone",//20
                            render: function (jsonAddZone) {
                                return showCheckBox(jsonAddZone);
                            }
                        },
                        //{ data: "AddZoneId" },//21
                        {
                            data: "AddUser",//22
                            render: function (jsonAddUser) {
                                return showCheckBox(jsonAddUser);
                            }
                        },
                        //{ data: "AddUserId" },//23
                        {
                            data: "PrintDetails",//24
                            render: function (jsonPrintDetails) {
                                return showCheckBox(jsonPrintDetails);
                            }
                        },
                        //{ data: "PrintDetailsId" },//25
                        {
                            data: "ExportToPDF",//26
                            render: function (jsonExportToPDF) {
                                return showCheckBox(jsonExportToPDF);
                            }
                        },
                        //{ data: "ExportToPDFId" },//27
                        {
                            data: "ExportToExcel",//28
                            render: function (jsonExportToExcel) {
                                return showCheckBox(jsonExportToExcel);
                            }
                        }
                        //{ data: "ExportToExcelId" }//29
                    ],
                    "bDestroy": true
                });

                disableAllCheckBoxesNonExistingOnPage();
            },
            error: function (response) {
                alert('Unable to Bind All User Access');
            }
        });//end of ajax

        return false;
    }

    function disableAllCheckBoxesNonExistingOnPage() {

        var count = 0;
        var tblUserAccess = $('#dtUserAccess').DataTable();

        var UserTableAllData = $(tblUserAccess.$('input[type="checkbox"]').map(function () {
            return $(this).closest('tr');
        }));

        for (var i = 0; i < UserTableAllData.length; i++) {

            //WhetherDefault
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(0)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(0)').attr("disabled", 'disabled');
            }

            //AssignBookingToDriver
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(1)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(1)').attr("disabled", 'disabled');
            }

            //AddDriverToAssignBooking
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(2)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(2)').attr("disabled", 'disabled');
            }

            //AddBooking
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(3)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(3)').attr("disabled", 'disabled');
            }

            //AddShipping
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(4)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(4)').attr("disabled", 'disabled');
            }

            //AddCustomer
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(5)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(5)').attr("disabled", 'disabled');
            }

            //AddDriver
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(6)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(6)').attr("disabled", 'disabled');
            }

            //AddWarehouse
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(7)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(7)').attr("disabled", 'disabled');
            }

            //AddLocation
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(8)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(8)').attr("disabled", 'disabled');
            }

            //AddZone
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(9)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(9)').attr("disabled", 'disabled');
            }

            //AddUser
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(10)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(10)').attr("disabled", 'disabled');
            }

            //PrintDetails
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(11)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(11)').attr("disabled", 'disabled');
            }

            //ExportToPDF
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(12)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(12)').attr("disabled", 'disabled');
            }

            //ExportToExcel
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(13)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(13)').attr("disabled", 'disabled');
            }
        }
    }

    function updateUserAccess() {

        var tblUserAccess = $('#dtUserAccess').DataTable();

        var UserTableAllData = $(tblUserAccess.$('input[type="checkbox"]').map(function () {
            return $(this).closest('tr');
        }));

        for (var i = 0; i < UserTableAllData.length; i++) {

            //var vUserId = UserTableAllData[i].find('td').eq(0).text();
            var vNewRoleName = UserTableAllData[i].find('td').eq(1).text();

            var vWhetherDefault = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(0)')).is(":checked")) {
                vWhetherDefault = "true";
            }

            var vMenu_Name = UserTableAllData[i].find('td').eq(3).text();

            var vAssignBookingToDriver = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(1)')).is(":checked")) {
                vAssignBookingToDriver = "true";
            }

            var vAddDriverToAssignBooking = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(2)')).is(":checked")) {
                vAddDriverToAssignBooking = "true";
            }

            var vAddBooking = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(3)')).is(":checked")) {
                vAddBooking = "true";
            }

            var vAddShipping = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(4)')).is(":checked")) {
                vAddShipping = "true";
            }

            var vAddCustomer = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(5)')).is(":checked")) {
                vAddCustomer = "true";
            }

            var vAddDriver = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(6)')).is(":checked")) {
                vAddDriver = "true";
            }

            var vAddWarehouse = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(7)')).is(":checked")) {
                vAddWarehouse = "true";
            }

            var vAddLocation = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(8)')).is(":checked")) {
                vAddLocation = "true";
            }

            var vAddZone = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(9)')).is(":checked")) {
                vAddZone = "true";
            }

            var vAddUser = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(10)')).is(":checked")) {
                vAddUser = "true";
            }

            var vPrintDetails = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(11)')).is(":checked")) {
                vPrintDetails = "true";
            }

            var vExportToPDF = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(12)')).is(":checked")) {
                vExportToPDF = "true";
            }

            var vExportToExcel = "false";
            if ($(UserTableAllData[i].find('input[type=checkbox]:eq(13)')).is(":checked")) {
                vExportToExcel = "true";
            }

            //Binding User Access to object
            var objUserAccess = {};

            //objUserAccess.UserId = vUserId;
            objUserAccess.RoleName = vNewRoleName;
            objUserAccess.WhetherDefault = vWhetherDefault;
            objUserAccess.Menu_Name = vMenu_Name;
            objUserAccess.AssignBookingToDriver = vAssignBookingToDriver;//0
            objUserAccess.AddDriverToAssignBooking = vAddDriverToAssignBooking;//1
            objUserAccess.AddBooking = vAddBooking;//2
            objUserAccess.AddShipping = vAddShipping;//3
            objUserAccess.AddCustomer = vAddCustomer;//4
            objUserAccess.AddDriver = vAddDriver;//5
            objUserAccess.AddWarehouse = vAddWarehouse;//6
            objUserAccess.AddLocation = vAddLocation;//7
            objUserAccess.AddZone = vAddZone;//8
            objUserAccess.AddUser = vAddUser;//9
            objUserAccess.PrintDetails = vPrintDetails;//10
            objUserAccess.ExportToPDF = vExportToPDF;//11
            objUserAccess.ExportToExcel = vExportToExcel;//12

            $.ajax({
                type: "POST",
                url: "UserAccess.aspx/UpdateUserAccess",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objUserAccess),
                dataType: "json",
                success: function (result) {
                },
                error: function (response) {
                }
            });
        }//end of Row Updation for loop

        $('#spAccessMessage').text("Overall Access Updation successful");
        $('#UserAccess-bx').modal('show');

        return false;
    }

    function saveUserAccess() {
        updateUserAccess();

        return false;
    }

    function refreshScreen() {
        location.reload();
    }

</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    User Role Access 
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmUserAccess" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="panel-heading">
                    </div>
                    <div class="panel-body clrBLK dashboad-form">
                        <div class="row">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" style="text-align:center; width: 100%;" runat="server" Text="" Font-Size="Small"></asp:Label>                       
                        </div>

                        <div class="row">
                            <div class="form-group"><label class="col-sm-4 control-label">Select UserId: <span style="color: red">*</span></label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlUserId" runat="server"
                                        CssClass="form-control m-b" title="Please select a User Id from dropdown" onchange="getSpecificUserAccess(this.value);">
                                        <asp:ListItem>Select UserId</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="form-group"><label class="col-sm-4 control-label">Select RoleName: <span style="color: red">*</span></label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlRoleName" runat="server"
                                        CssClass="form-control m-b" title="Please select a User Id from dropdown" onchange="getSpecificRoleAccess(this.value);">
                                        <asp:ListItem>Select RoleName</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive">
                        <table id="dtUserAccess" class="table">
                            <thead>
                                <tr>
                                    <!--<th>User Id</th>-->
                                    <!--<th>Role Name</th>-->
                                    <th>Whether Default</th>
                                    <th>Menu Name</th>
                                    <th>Assign Booking To Driver</th>
                                    <!--<th>Assign Booking To Driver Id</th>-->

                                    <th>Add Driver To Assign Booking</th>
                                    <!--<th>Add Driver To Assign Booking Id</th>-->

                                    <th>Add Booking</th>
                                    <!--<th>Add Booking Id</th>-->

                                    <th>Add Shipping</th>
                                    <!--<th>Add Shipping Id</th>-->

                                    <th>Add Customer</th>
                                    <!--<th>Add Customer Id</th>-->

                                    <th>Add Driver</th>
                                    <!--<th>Add Driver Id</th>-->

                                    <th>Add Warehouse</th>
                                    <!--<th>Add Warehouse Id</th>-->

                                    <th>Add Location</th>
                                    <!--<th>Add Location Id</th>-->

                                    <th>Add Zone</th>
                                    <!--<th>Add Zone Id</th>-->

                                    <th>Add User</th>
                                    <!--<th>Add User Id</th>-->

                                    <th>Print Details</th>
                                    <!--<th>Print Details Id</th>-->

                                    <th>Export To PDF</th>
                                    <!--<th>Export To PDF Id</th>-->

                                    <th>Export To Excel</th>
                                    <!--<th>Export To Excel Id</th>-->
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                        <div class="row">
                            <div style="padding: 10px;">

                            </div>
                        </div>

                        <div class="row">
                            <div class="form-group">
                                <div class="col-sm-4"></div>
                                <div class="col-sm-8">
                                    <asp:Button ID="btnSaveUserAccess" runat="server" Text="Save User Access"
                                        CssClass="btn btn-primary btn-register" 
                                        OnClientClick="return saveUserAccess();" />

                                    <asp:Button ID="btnCancelUserAccess" runat="server" Text="Cancel" 
                                        CssClass="btn btn-default"
                                        OnClientClick="refreshScreen();" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
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

  <div class="modal fade" id="UserAccess-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Access Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spAccessMessage"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="refreshScreen();">OK</button>
        </div>
      </div>
      
    </div>
  </div>
</asp:Content>

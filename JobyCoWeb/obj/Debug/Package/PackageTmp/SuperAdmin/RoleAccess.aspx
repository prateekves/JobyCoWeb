<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="RoleAccess.aspx.cs" Inherits="JobyCoWeb.RoleAccess" %>

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
        getAllUserRoles();
    });
</script>

<%--<script>
$(document).ready(function () {
    $('#dtUserRoles').DataTable({
    "scrollY": "200px",
    "scrollCollapse": true,
  });
  $('.dataTables_length').addClass('bs-select');
});
</script>--%>
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
        $('#dtUserRoles tr').each(function () {
            count++;
        });

        return count;
    }

    function getAllUserRoles() {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "RoleAccess.aspx/GetAllUserRoles",
            success: function (result) {
                var jsonUserRoles = JSON.parse(result.d);
                $('#dtUserRoles').DataTable({
                    data: jsonUserRoles,
                    columns: [
                        //{ data: "RoleId" },//0
                        //{ data: "RoleName" },//1
                        { data: "Menu_Name" },//2
                        {
                            data: "AssignBookingToDriver",//3
                            render: function (jsonAssignBookingToDriver) {
                                return showCheckBox(jsonAssignBookingToDriver);
                            }
                        },
                        //{ data: "AssignBookingToDriverId" },//4
                        {
                            data: "AddDriverToAssignBooking",//5
                            render: function (jsonAddDriverToAssignBooking) {
                                return showCheckBox(jsonAddDriverToAssignBooking);
                            }
                        },
                        //{ data: "AddDriverToAssignBookingId" },//6
                        {
                            data: "AddBooking",//7
                            render: function (jsonAddBooking) {
                                return showCheckBox(jsonAddBooking);
                            }
                        },
                        //{ data: "AddBookingId" },//8
                        {
                            data: "AddShipping",//9
                            render: function (jsonAddShipping) {
                                return showCheckBox(jsonAddShipping);
                            }
                        },
                        //{ data: "AddShippingId" },//10
                        {
                            data: "AddCustomer",//11
                            render: function (jsonAddCustomer) {
                                return showCheckBox(jsonAddCustomer);
                            }
                        },
                        //{ data: "AddCustomerId" },//12
                        {
                            data: "AddDriver",//13
                            render: function (jsonAddDriver) {
                                return showCheckBox(jsonAddDriver);
                            }
                        },
                        //{ data: "AddDriverId" },//14
                        {
                            data: "AddWarehouse",//15
                            render: function (jsonAddWarehouse) {
                                return showCheckBox(jsonAddWarehouse);
                            }
                        },
                        //{ data: "AddWarehouseId" },//16
                        {
                            data: "AddLocation",//17
                            render: function (jsonAddLocation) {
                                return showCheckBox(jsonAddLocation);
                            }
                        },
                        //{ data: "AddLocationId" },//18
                        {
                            data: "AddZone",//19
                            render: function (jsonAddZone) {
                                return showCheckBox(jsonAddZone);
                            }
                        },
                        //{ data: "AddZoneId" },//20
                        {
                            data: "AddUser",//21
                            render: function (jsonAddUser) {
                                return showCheckBox(jsonAddUser);
                            }
                        },
                        //{ data: "AddUserId" },//22
                        {
                            data: "PrintDetails",//23
                            render: function (jsonPrintDetails) {
                                return showCheckBox(jsonPrintDetails);
                            }
                        },
                        //{ data: "PrintDetailsId" },//24
                        {
                            data: "ExportToPDF",//25
                            render: function (jsonExportToPDF) {
                                return showCheckBox(jsonExportToPDF);
                            }
                        },
                        //{ data: "ExportToPDFId" },//26
                        {
                            data: "ExportToExcel",//27
                            render: function (jsonExportToExcel) {
                                return showCheckBox(jsonExportToExcel);
                            }
                        }
                        //{ data: "ExportToExcelId" }//28
                    ],
                    //"columnDefs": [
                    //    {
                    //        "targets": [4],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [6],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [8],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [10],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [12],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [14],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [16],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [18],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [20],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [22],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [24],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [26],
                    //        "visible": false
                    //    },
                    //    {
                    //        "targets": [28],
                    //        "visible": false
                    //    },

                    //],
                    "bDestroy": true
                });

                disableAllCheckBoxesNonExistingOnPage();
            },
            error: function (response) {
                alert('Unable to Bind All User Roles');
            }
        });//end of ajax

        return false;
    }

    function getSpecificUserRole(RoleName) {
        if (RoleName == "Select RoleName") {
            getAllUserRoles();

            return false;
        }

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "RoleAccess.aspx/GetSpecificUserRole",
            data: "{RoleName: '" + RoleName + "'}",
            success: function (result) {
                var jsonUserRoles = JSON.parse(result.d);

                $('#dtUserRoles').DataTable({
                    data: jsonUserRoles,
                    columns: [
                        //{ data: "RoleId" },//0
                        //{ data: "RoleName" },//1
                        { data: "Menu_Name" },//2
                        {
                            data: "AssignBookingToDriver",//3
                            render: function (jsonAssignBookingToDriver) {
                                return showCheckBox(jsonAssignBookingToDriver);
                            }
                        },
                        //{ data: "AssignBookingToDriverId" },//4
                        {
                            data: "AddDriverToAssignBooking",//5
                            render: function (jsonAddDriverToAssignBooking) {
                                return showCheckBox(jsonAddDriverToAssignBooking);
                            }
                        },
                        //{ data: "AddDriverToAssignBookingId" },//6
                        {
                            data: "AddBooking",//7
                            render: function (jsonAddBooking) {
                                return showCheckBox(jsonAddBooking);
                            }
                        },
                        //{ data: "AddBookingId" },//8
                        {
                            data: "AddShipping",//9
                            render: function (jsonAddShipping) {
                                return showCheckBox(jsonAddShipping);
                            }
                        },
                        //{ data: "AddShippingId" },//10
                        {
                            data: "AddCustomer",//11
                            render: function (jsonAddCustomer) {
                                return showCheckBox(jsonAddCustomer);
                            }
                        },
                        //{ data: "AddCustomerId" },//12
                        {
                            data: "AddDriver",//13
                            render: function (jsonAddDriver) {
                                return showCheckBox(jsonAddDriver);
                            }
                        },
                        //{ data: "AddDriverId" },//14
                        {
                            data: "AddWarehouse",//15
                            render: function (jsonAddWarehouse) {
                                return showCheckBox(jsonAddWarehouse);
                            }
                        },
                        //{ data: "AddWarehouseId" },//16
                        {
                            data: "AddLocation",//17
                            render: function (jsonAddLocation) {
                                return showCheckBox(jsonAddLocation);
                            }
                        },
                        //{ data: "AddLocationId" },//18
                        {
                            data: "AddZone",//19
                            render: function (jsonAddZone) {
                                return showCheckBox(jsonAddZone);
                            }
                        },
                        //{ data: "AddZoneId" },//20
                        {
                            data: "AddUser",//21
                            render: function (jsonAddUser) {
                                return showCheckBox(jsonAddUser);
                            }
                        },
                        //{ data: "AddUserId" },//22
                        {
                            data: "PrintDetails",//23
                            render: function (jsonPrintDetails) {
                                return showCheckBox(jsonPrintDetails);
                            }
                        },
                        //{ data: "PrintDetailsId" },//24
                        {
                            data: "ExportToPDF",//25
                            render: function (jsonExportToPDF) {
                                return showCheckBox(jsonExportToPDF);
                            }
                        },
                        //{ data: "ExportToPDFId" },//26
                        {
                            data: "ExportToExcel",//27
                            render: function (jsonExportToExcel) {
                                return showCheckBox(jsonExportToExcel);
                            }
                        }
                        //{ data: "ExportToExcelId" }//28
                    ],
                    "bDestroy": true
                });

                disableAllCheckBoxesNonExistingOnPage();
            },
            error: function (response) {
                alert('Unable to Bind Specific User Roles');
            }
        });//end of ajax

        return false;
    }

    function disableAllCheckBoxesNonExistingOnPage() {

        var count = 0;
        var tblUserRole = $('#dtUserRoles').DataTable();

        var UserTableAllData = $(tblUserRole.$('input[type="checkbox"]').map(function () {
            return $(this).closest('tr');
        }));

        for (var i = 0; i < UserTableAllData.length; i++) {

            //AssignBookingToDriver
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(0)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(0)').attr("disabled", 'disabled');
            }

            //AddDriverToAssignBooking
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(1)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(1)').attr("disabled", 'disabled');
            }

            //AddBooking
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(2)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(2)').attr("disabled", 'disabled');
            }

            //AddShipping
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(3)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(3)').attr("disabled", 'disabled');
            }

            //AddCustomer
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(4)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(4)').attr("disabled", 'disabled');
            }

            //AddDriver
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(5)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(5)').attr("disabled", 'disabled');
            }

            //AddWarehouse
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(6)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(6)').attr("disabled", 'disabled');
            }

            //AddLocation
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(7)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(7)').attr("disabled", 'disabled');
            }

            //AddZone
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(8)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(8)').attr("disabled", 'disabled');
            }

            //AddUser
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(9)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(9)').attr("disabled", 'disabled');
            }

            //PrintDetails
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(10)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(10)').attr("disabled", 'disabled');
            }

            //ExportToPDF
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(11)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(11)').attr("disabled", 'disabled');
            }

            //ExportToExcel
            if (!$(UserTableAllData[i].find('input[type=checkbox]:eq(12)')).is(":checked")) {
                UserTableAllData[i].find('input[type=checkbox]:eq(12)').attr("disabled", 'disabled');
            }
        }
    }

<%--    function getSelectedCheckBoxListValues() {
        var vSelectedCheckBoxListValues = "";
        $("#<%=cblMenuNames.ClientID %> input[type=checkbox]:checked").each(function() {
            if ($(this).is(":checked")) {
                vSelectedCheckBoxListValues += $(this).val().trim() + ",";
            }
        });

        return vSelectedCheckBoxListValues;
    }--%>

    function updateUserRoles() {

        var tblUserRoles = $('#dtUserRoles').DataTable();

        var RoleTableAllData = $(tblUserRoles.$('input[type="checkbox"]').map(function () {
            return $(this).closest('tr');
        }));

        for (var i = 0; i < RoleTableAllData.length; i++) {

            var vRoleId = RoleTableAllData[i].find('td').eq(0).text();
            var vRoleName = RoleTableAllData[i].find('td').eq(1).text();
            var vMenu_Name = RoleTableAllData[i].find('td').eq(2).text();

            var vAssignBookingToDriver = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(0)')).is(":checked")) {
                vAssignBookingToDriver = "true";
            }

            var vAddDriverToAssignBooking = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(1)')).is(":checked")) {
                vAddDriverToAssignBooking = "true";
            }

            var vAddBooking = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(2)')).is(":checked")) {
                vAddBooking = "true";
            }

            var vAddShipping = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(3)')).is(":checked")) {
                vAddShipping = "true";
            }

            var vAddCustomer = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(4)')).is(":checked")) {
                vAddCustomer = "true";
            }

            var vAddDriver = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(5)')).is(":checked")) {
                vAddDriver = "true";
            }

            var vAddWarehouse = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(6)')).is(":checked")) {
                vAddWarehouse = "true";
            }

            var vAddLocation = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(7)')).is(":checked")) {
                vAddLocation = "true";
            }

            var vAddZone = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(8)')).is(":checked")) {
                vAddZone = "true";
            }

            var vAddUser = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(9)')).is(":checked")) {
                vAddUser = "true";
            }

            var vPrintDetails = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(10)')).is(":checked")) {
                vPrintDetails = "true";
            }

            var vExportToPDF = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(11)')).is(":checked")) {
                vExportToPDF = "true";
            }

            var vExportToExcel = "false";
            if ($(RoleTableAllData[i].find('input[type=checkbox]:eq(12)')).is(":checked")) {
                vExportToExcel = "true";
            }

            //Binding User Roles to object
            var objUserRoles = {};

            objUserRoles.RoleId = vRoleId;
            objUserRoles.RoleName = vRoleName;
            objUserRoles.Menu_Name = vMenu_Name;
            objUserRoles.AssignBookingToDriver = vAssignBookingToDriver;//0
            objUserRoles.AddDriverToAssignBooking = vAddDriverToAssignBooking;//1
            objUserRoles.AddBooking = vAddBooking;//2
            objUserRoles.AddShipping = vAddShipping;//3
            objUserRoles.AddCustomer = vAddCustomer;//4
            objUserRoles.AddDriver = vAddDriver;//5
            objUserRoles.AddWarehouse = vAddWarehouse;//6
            objUserRoles.AddLocation = vAddLocation;//7
            objUserRoles.AddZone = vAddZone;//8
            objUserRoles.AddUser = vAddUser;//9
            objUserRoles.PrintDetails = vPrintDetails;//10
            objUserRoles.ExportToPDF = vExportToPDF;//11
            objUserRoles.ExportToExcel = vExportToExcel;//12

            $.ajax({
                type: "POST",
                url: "RoleAccess.aspx/UpdateUserRoles",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objUserRoles),
                dataType: "json",
                success: function (result) {
                },
                error: function (response) {
                }
            });
        }//end of Row Updation for loop

        $('#spRoleMessage').text("Overall Role Updation successful");
        $('#UserRole-bx').modal('show');

        return false;
    }

    function saveUserRoles()
    {
        updateUserRoles();

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
                    User Role Management
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmUserRoles" runat="server">
                        <asp:HiddenField ID="hfMenusAccessible" runat="server" />               <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="panel-heading">
                    </div>
                    <div class="panel-body clrBLK dashboad-form">
                        <div class="row">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" style="text-align:center; width: 100%;" runat="server" Text="" Font-Size="Small"></asp:Label>                       
                        </div>

                        
                            <div class="row form-group"><label class="col-sm-4 control-label">Select RoleName: <span style="color: red">*</span></label>
                                <div class="col-sm-8">
                                    <asp:DropDownList ID="ddlRoleName" runat="server"
                                        CssClass="form-control m-b" title="Please select a User Id from dropdown" onchange="getSpecificUserRole(this.value);">
                                        <asp:ListItem>Select RoleName</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                        <div class="table-responsive">
                        <table id="dtUserRoles" class="table">
                            <thead>
                                <tr>
                                    <!--<th>Role Id</th>-->
                                    <!--<th>Role Name</th>-->
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
                                <div class="col-sm-8 btn_cnctr">
                                    <asp:Button ID="btnSaveUserRole" runat="server" Text="Save User Role with Menus"
                                        CssClass="btn btn-primary btn-register" 
                                        OnClientClick="return saveUserRoles();" />

                                    <asp:Button ID="btnCancelUserRole" runat="server" Text="Cancel" 
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

  <div class="modal fade" id="UserRole-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Role Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spRoleMessage"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="refreshScreen();">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

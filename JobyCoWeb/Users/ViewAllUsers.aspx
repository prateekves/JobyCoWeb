<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="ViewAllUsers.aspx.cs" Inherits="JobyCoWeb.Users.ViewAllUsers"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

    <style>
        .EmailID {
        }

        .print, .edit, .delete {
            background: none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

            .print:hover, .edit:hover, .delete:hover {
                background: #fca311;
                color: #fff;
                text-shadow: 1px 1px 1px rgba(0,0,0,0.4);
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
        function checkBlankControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
                var vConfirmEmailID = $("#<%=txtConfirmEmailID.ClientID%>");

                var vPassword = $("#<%=txtPassword.ClientID%>");
                var vConfirmPassword = $("#<%=txtPassword.ClientID%>"); //copying same pwd as we dont have feature of confirm password when create user

                var vTitle = $("#<%=ddlTitle.ClientID%>");
                var vFirstName = $("#<%=txtFirstName.ClientID%>");
                var vLastName = $("#<%=txtLastName.ClientID%>");

                var vDOB = $("#<%=txtDOB.ClientID%>");

                var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");

                var vTown = $("#<%=txtTown.ClientID%>");
                var vCountry = $("#<%=ddlCountry.ClientID%>");
                var vPostCode = $("#<%=txtPostCode.ClientID%>");

                var vMobile = $("#<%=txtMobile.ClientID%>");
                var vTelephone = $("#<%=txtTelephone.ClientID%>");

                var vUserRole = $("#<%=ddlUserRole.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");

            //Driver Type Radio Buttons
            //===============================================================
            var vDirectPayroll = $( '#<%=rbDirectPayroll.ClientID%>');
            var vThirdPartyPayroll = $( '#<%=rbThirdPartyPayroll.ClientID%>');
            //===============================================================

            //Wage Type Radio Buttons
            //===============================================================
            var vHourlyBasis = $( '#<%=rbHourlyBasis.ClientID%>');
            var vMonthlyBasis = $( '#<%=rbMonthlyBasis.ClientID%>');
            //===============================================================
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

            if (vConfirmEmailID.val().trim() == "") {
                vErrMsg.text('Confirm Email Address');
                vErrMsg.css("display", "block");
                vConfirmEmailID.focus();
                return false;
            }

            if (!IsEmail(vConfirmEmailID.val().trim())) {
                vErrMsg.text('Invalid Email Address');
                vErrMsg.css("display", "block");
                vConfirmEmailID.focus();
                return false;
            }

            if (vEmailID.val().trim() != vConfirmEmailID.val().trim()) {
                vErrMsg.text('EmailID and Confirm EmailID must match');
                vErrMsg.css("display", "block");
                return false;
            }

            if (vPassword.val().trim() == "") {
                vErrMsg.text('Enter Password');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            var vPasswordLength = vPassword.val().trim().length;
            if (vPasswordLength > 0 && vPasswordLength < 6) {
                vErrMsg.text('Password should be minimum of 6 and maximum of 14 characters');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            if (vPasswordLength > 14) {
                vErrMsg.text('Password should be minimum of 6 and maximum of 14 characters');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            //if (!vPassword.val().trim().match(/[a-z]/)) {
            //    vErrMsg.text('Password should contain atleast 1 Alphabet');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            //if (!vPassword.val().trim().match(/[A-Z]/)) {
            //    vErrMsg.text('Password should contain atleast 1 Capital Letter');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            //if (!vPassword.val().trim().match(/\d/)) {
            //    vErrMsg.text('Password should contain atleast 1 Number');
            //    vErrMsg.css("display", "block");
            //    vPassword.focus();
            //    return false;
            //}

            if (vConfirmPassword.val().trim() == "") {
                vErrMsg.text('Confirm Password');
                vErrMsg.css("display", "block");
                vConfirmPassword.focus();
                return false;
            }

            if (vPassword.val().trim() != vConfirmPassword.val().trim()) {
                vErrMsg.text('Password and Confirm Password must match');
                vErrMsg.css("display", "block");
                return false;
            }

            if (vTitle.find('option:selected').text().trim() == "Select Title") {
                vErrMsg.text('Please select a title from dropdown');
                vErrMsg.css("display", "block");
                vTitle.focus();
                return false;
            }

            if (vFirstName.val().trim() == "") {
                vErrMsg.text('Enter First Name');
                vErrMsg.css("display", "block");
                vFirstName.focus();
                return false;
            }

            if (vLastName.val().trim() == "") {
                vErrMsg.text('Enter Last Name');
                vErrMsg.css("display", "block");
                vLastName.focus();
                return false;
            }

            if (vDOB.val().trim() == "") {
                vErrMsg.text('Enter Date Of Birth');
                vErrMsg.css("display", "block");
                vDOB.focus();
                return false;
            }
          <%--   var Role = $("#<%=ddlUserRole.ClientID%>").find('option:selected').text().trim();
            if (Role == "Driver") {
                if (!vDirectPayroll.is(":checked")
                    && !vThirdPartyPayroll.is(":checked")) {
                    vErrMsg.text('Please choose a Payroll Type of this Driver');
                    vErrMsg.css("display", "block");
                    return false;
                }

                if (!vHourlyBasis.is(":checked")
                    && !vMonthlyBasis.is(":checked")) {
                    vErrMsg.text('Please choose a Wage Type of this Driver');
                    vErrMsg.css("display", "block");
                    return false;
                }
            }--%>

            var vCurrentDate = getCurrentDateDetails();

            if (vDOB.val().trim() != "" && vCurrentDate != "") {
                var dt1 = parseInt(vDOB.val().trim().substring(0, 2), 10);
                var mon1 = parseInt(vDOB.val().trim().substring(3, 5), 10);
                var yr1 = parseInt(vDOB.val().trim().substring(6, 10), 10);

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

            if (vAddressLine1.val().trim() == "") {
                vErrMsg.text('Enter Address Line 1 atleast');
                vErrMsg.css("display", "block");
                vAddressLine1.focus();
                return false;
            }

            if (vTown.val().trim() == "") {
                vErrMsg.text('Enter Town');
                vErrMsg.css("display", "block");
                vTown.focus();
                return false;
            }

            if (vCountry.find('option:selected').text().trim() == "Select Country") {
                vErrMsg.text('Please select a country from dropdown');
                vErrMsg.css("display", "block");
                vCountry.focus();
                return false;
            }

            //if (vPostCode.val().trim() == "") {
            //    vErrMsg.text('Enter PostCode');
            //    vErrMsg.css("display", "block");
            //    vPostCode.focus();
            //    return false;
            //}

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

            //if (vTelephone.val().trim() == "") {
            //    vErrMsg.text('Enter Telephone No');
            //    vErrMsg.css("display", "block");
            //    vTelephone.focus();
            //    return false;
            //}

            //if (vTelephone.val().trim().length < 11) {
            //    vErrMsg.text('Invalid Telephone No');
            //    vErrMsg.css("display", "block");
            //    vTelephone.focus();
            //    return false;
            //}

            if (vUserRole.find('option:selected').text().trim() == "Select Role") {
                vErrMsg.text('Please select a User Role from dropdown');
                vErrMsg.css("display", "block");
                vUserRole.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
                var vConfirmEmailID = $("#<%=txtConfirmEmailID.ClientID%>");

                var vPassword = $("#<%=txtPassword.ClientID%>");
                var vConfirmPassword = $("#<%=txtConfirmPassword.ClientID%>");

                var vTitle = $("#<%=ddlTitle.ClientID%>");
                var vFirstName = $("#<%=txtFirstName.ClientID%>");
                var vLastName = $("#<%=txtLastName.ClientID%>");

                var vDOB = $("#<%=txtDOB.ClientID%>");

                var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");

                var vTown = $("#<%=txtTown.ClientID%>");
                var vCountry = $("#<%=ddlCountry.ClientID%>");
                var vPostCode = $("#<%=txtPostCode.ClientID%>");

                var vMobile = $("#<%=txtMobile.ClientID%>");
                var vTelephone = $("#<%=txtTelephone.ClientID%>");

                var vUserRole = $("#<%=ddlUserRole.ClientID%>");

                var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            vEmailID.val('');
            vConfirmEmailID.val('');

            vPassword.val('');
            vConfirmPassword.val('');

            vTitle.val('Select Title');
            vFirstName.val('');
            vLastName.val('');

            vDOB.val('');

            vAddressLine1.val('');
            vAddressLine2.val('');
            vAddressLine3.val('');

            vTown.val('');
            vCountry.val('Select Country');
            vPostCode.val('');

            vMobile.val('');
            vTelephone.val('');

            vUserRole.val('Select Role');

            location.href = "/Users/ViewAllUsers.aspx";
            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }
    </script>

    <script>
        function updateUserDetails() {
            var UserId = $( "#<%=hfUserID.ClientID%>").val().trim();
            var EmailID = $( "#<%=txtEmailID.ClientID%>").val().trim();
            var Password = $( "#<%=txtPassword.ClientID%>").val().trim();

            var Title = $( "#<%=ddlTitle.ClientID%>").find('option:selected').text().trim();
            var FirstName = $( "#<%=txtFirstName.ClientID%>").val().trim();
            var LastName = $( "#<%=txtLastName.ClientID%>").val().trim();

            var DOB = $( "#<%=txtDOB.ClientID%>").val().trim();

            var Address = $( "#<%=txtAddressLine1.ClientID%>").val().trim();
            var Town = $( "#<%=txtTown.ClientID%>").val().trim();
            var Country = $( "#<%=ddlCountry.ClientID%>").find('option:selected').text().trim();
            var PostCode = $( "#<%=txtPostCode.ClientID%>").val().trim();

            var Mobile = $( "#<%=txtMobile.ClientID%>").val().trim();
            var Telephone = $( "#<%=txtTelephone.ClientID%>").val().trim();

            var UserRole = $( "#<%=ddlUserRole.ClientID%>").find('option:selected').text().trim();
           <%-- var DriverType = "";
            var WageType = "";
            if (UserRole == "Driver") {
                //Driver Type
                //=================================================================
               
                var vDirectPayroll = $("#<%=rbDirectPayroll.ClientID%>");
                var vThirdPartyPayroll = $("#<%=rbThirdPartyPayroll.ClientID%>");

                if (vDirectPayroll.is(":checked")) {
                    DriverType = "Direct Payroll";
                }

                if (vThirdPartyPayroll.is(":checked")) {
                    DriverType = "Third Party Payroll";
                }

                //Wage Type
                //=================================================================
               
                var vHourlyBasis = $("#<%=rbHourlyBasis.ClientID%>");
                var vMonthlyBasis = $("#<%=rbMonthlyBasis.ClientID%>");

                if (vHourlyBasis.is(":checked")) {
                    WageType = "Hourly Basis";
                }

                if (vMonthlyBasis.is(":checked")) {
                    WageType = "Monthly Basis";
                }
            }--%>
            var objUser = {};

            objUser.UserId = UserId;
            objUser.EmailID = EmailID;
            objUser.Password = Password;

            objUser.Title = Title;
            objUser.FirstName = FirstName;
            objUser.LastName = LastName;

            objUser.DOB = DOB;

            objUser.Address = Address;
            objUser.Town = Town;
            objUser.Country = Country;
            objUser.PostCode = PostCode;

            objUser.Mobile = Mobile;
            objUser.Telephone = Telephone;

            //objUser.DriverType = DriverType;
            //objUser.WageType = WageType;
            objUser.UserRole = UserRole;

            $.ajax({
                type: "POST",
                url: "ViewAllUsers.aspx/UpdateUserDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(objUser),
                dataType: "json",
                success: function (result) {
                    $('#User-bx').modal('show');
                },
                error: function (response) {
                    alert('User Details Updation failed');
                }
            });

            return false;
        }

        function editUserDetails() {
            if (checkBlankControls()) {
                updateUserDetails();
                //setTimeout( function () { }, 3000 );
            }

            return false;
        }

        function removeUserDetails() {
            var UserId = $( '#<%=hfUserID.ClientID%>').val().trim();

            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/RemoveUserDetails",
                data: "{ UserId: '" + UserId + "'}",
                success: function (result) {
                    location.reload();
                },
                error: function (response) {
                    alert('Unable to Remove User Details');
                }
            });
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
        $(document).ready(function () {
            $('#dvUserDetails').css('display', 'none');
           <%-- document.getElementById("<%=rbUser.ClientID%>").checked = true;
            document.getElementById("<%=rbDriver.ClientID%>").checked = false;--%>
            getAllUsers();

            getAllTitles();
            getAllCountries();
            getAllRoles();

            $('#<%=txtDOB.ClientID%>').datepicker({
                format: 'dd-mm-yyyy',
                todayHighlight: true,
                autoclose: true
            });
        });
    </script>

    <script>
        function getSpecificRoleDetails(DropdownId) {
           <%-- var Role = $("#<%=ddlUserRole.ClientID%>").find('option:selected').text().trim();
            if (Role == "Driver") {
                $('#driverSection').css('display', 'table');
            }
            else {
                $('#driverSection').css('display', 'none');
            }--%>
        }
        function getUserAddress(EmailID) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetUserAddress",
                data: "{EmailID : '" + EmailID + "'}",
                success: function (result) {
                    var vAddress = result.d.trim();
                    $('#spAddress').text(vAddress);

                    getUserTown(EmailID);
                },
                error: function (response) {
                    alert('Unable to get User Address');
                }
            });
        }

        function getUserTown(EmailID) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetUserTown",
                data: "{EmailID : '" + EmailID + "'}",
                success: function (result) {
                    var vTown = result.d.trim();
                    $('#spTown').text(vTown);

                    getUserCountry(EmailID);
                },
                error: function (response) {
                    alert('Unable to get User Town');
                }
            });
        }

        function getUserCountry(EmailID) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetUserCountry",
                data: "{EmailID : '" + EmailID + "'}",
                success: function (result) {
                    var vCountry = result.d.trim();
                    $('#spCountry').text(vCountry);

                    getUserPostCode(EmailID);
                },
                error: function (response) {
                    alert('Unable to get User Country');
                }
            });
        }

        function getUserPostCode(EmailID) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetUserPostCode",
                data: "{EmailID : '" + EmailID + "'}",
                success: function (result) {
                    var vPostCode = result.d.trim();
                    $('#spPostCode').text(vPostCode);

                    getUserMobile(EmailID);
                },
                error: function (response) {
                    alert('Unable to get User PostCode');
                }
            });
        }

        function getUserMobile(EmailID) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetUserMobile",
                data: "{EmailID : '" + EmailID + "'}",
                success: function (result) {
                    var vMobile = result.d.trim();
                    $('#spMobile').text(vMobile);

                    getUserTelephone(EmailID);
                },
                error: function (response) {
                    alert('Unable to get User Mobile');
                }
            });
        }

        function getUserTelephone(EmailID) {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetUserTelephone",
                data: "{EmailID : '" + EmailID + "'}",
                success: function (result) {
                    var vTelephone = result.d.trim();
                    $('#spTelephone').text(vTelephone);
                },
                error: function (response) {
                    alert('Unable to get User Telephone');
                }
            });
        }

    </script>

    <script>
        function getAllUsers() {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetAllUsers",
                success: function (data) {
                    var jsonUsersDetails = JSON.parse(data.d);
                    $('#dtViewUsers').DataTable({
                        data: jsonUsersDetails,
                        "columns": [
                            { data: "id", "visible": true  },
                            { "data": "UserId" },
                            {
                                "data": "EmailID",
                                render: function (data) {
                                    return '<a class="EmailID">' + data + '</a>';
                                }
                            },
                            { "data": "CustomerName" },
                            {
                                "data": "DateOfBirth",
                                render: function (jsonDateOfBirth) {
                                    return getFormattedDateUK(jsonDateOfBirth);
                                }
                            },
                            { "data": "FirstName", "visible": false },
                            { "data": "LastName", "visible": false },
                            { "data": "Address", "visible": false },
                            { "data": "Town", "visible": false },
                            { "data": "Country", "visible": false },
                            { "data": "PostCode", "visible": false },
                            { "data": "Mobile", "visible": false },
                            { "data": "Telephone", "visible": false },
                            { "data": "Title", "visible": false },
                            //{ "data": "DriverType", "visible": false },
                            //{ "data": "WageType", "visible": false },
                            { data: "UserRole" },
                            {
                                defaultContent:
                                    "<ul class='userActionButtons'><li><button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button></li><li><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button></li><li><button class='delete' title='Delete'><i class='fa fa-times' aria-hidden='true'></i></button></li></ul>"
                            },

                        ],
                        render: function (data, type, row, meta) {
                            console.log(meta.row + meta.settings._iDisplayStart + 1);
                             return meta.row + meta.settings._iDisplayStart + 1;
                        },
                        "bDestroy": true
                    });
                },
                error: function (response) {
                    alert('Unable to Bind View All Userss');
                }
            });//end of ajax

            $('#dtViewUsers tbody').on('click', '.EmailID', function () {
                var vClosestTr = $(this).closest("tr");

                var vUserId = vClosestTr.find('td').eq(0).text();
                $('#spUserId').text(vUserId);
                $('#spHeaderUserId').text(vUserId);

                var vEmailAddress = vClosestTr.find('td').eq(1).text();
                $('#spEmailAddress').text(vEmailAddress);

                var vUserName = vClosestTr.find('td').eq(2).text();
                $('#spUserName').text(vUserName);

                var vDateOfBirth = vClosestTr.find('td').eq(3).text();
                $('#spDateOfBirth').text(vDateOfBirth);

                var vUserRole = vClosestTr.find('td').eq(4).text();
                $('#spUserRole').text(vUserRole);

                getUserAddress(vEmailAddress);

                $('#dvUserModal').modal('show');
                return false;
            });

            $('#dtViewUsers tbody').on('click', '.print', function () {
                var vClosestTr = $(this).closest("tr");


                var vUserId = vClosestTr.find('td').eq(0).text();
                $('#spUserId').text(vUserId);
                $('#spHeaderUserId').text(vUserId);

                var vEmailAddress = vClosestTr.find('td').eq(1).text();
                $('#spEmailAddress').text(vEmailAddress);

                var vUserName = vClosestTr.find('td').eq(2).text();
                $('#spUserName').text(vUserName);

                var vDateOfBirth = vClosestTr.find('td').eq(3).text();
                $('#spDateOfBirth').text(vDateOfBirth);

                var vAddress = vClosestTr.find('td').eq(6).text();
                $('#spAddress').text(vAddress);

                var vTown = vClosestTr.find('td').eq(7).text();
                $('#spTown').text(vTown);

                var vCountry = vClosestTr.find('td').eq(8).text();
                $('#spCountry').text(vCountry);

                var vPostCode = vClosestTr.find('td').eq(9).text();
                $('#spPostCode').text(vPostCode);

                var vMobile = vClosestTr.find('td').eq(10).text();
                $('#spMobile').text(vMobile);

                var vTelephone = vClosestTr.find('td').eq(11).text();
                $('#spTelephone').text(vTelephone);

                var vUserRole = vClosestTr.find('td').eq(13).text();
                $('#spUserRole').text(vUserRole);

                return printDetails('tblUserDetails');

                //$( '#dvUserModal' ).modal( 'show' );
                //return false;
            });

            $('#dtViewUsers tbody').on('click', '.edit', function () {

                
                //var idx = $(this).row(this).index();
                //console.log($(this).closest('tr').index());
                var vClosestTr = $(this).closest("tr");
                
                var vIndex = vClosestTr.index();
                
                var ViewUsers = $('#dtViewUsers').DataTable();

              

                var uniqueId = vClosestTr.find('td').eq(0).text() - 1;
                console.log(uniqueId);
                var rowIdx = ViewUsers.column(12).data()[uniqueId];
                

                var vUserId = vClosestTr.find('td').eq(1).text();
                $( '#<%=hfUserID.ClientID%>').val(vUserId);

                var vEmailAddress = vClosestTr.find('td').eq(2).text();
                $( '#<%=txtEmailID.ClientID%>').val(vEmailAddress);
                $( '#<%=txtConfirmEmailID.ClientID%>').val(vEmailAddress);

                //var vUserName = vClosestTr.find('td').eq(2).text();

               

                var Title = ViewUsers.column(13).data()[uniqueId];
                var FirstName = ViewUsers.column(5).data()[uniqueId];
                var LastName = ViewUsers.column(6).data()[uniqueId];

                //console.log(Title);
                //console.log(FirstName);

                $( "#<%=ddlTitle.ClientID%>").find('option:selected').text(Title);
                $( "#<%=txtFirstName.ClientID%>").val(FirstName);
                $( "#<%=txtLastName.ClientID%>").val(LastName);

                var vDateOfBirth = vClosestTr.find('td').eq(4).text();
                $( "#<%=txtDOB.ClientID%>").val(vDateOfBirth);

                var vAddress = ViewUsers.column(7).data()[uniqueId];//ViewUsers.column(4).data()[vIndex];
                $( "#<%=txtAddressLine1.ClientID%>").val(vAddress);

                var vTown = ViewUsers.column(8).data()[uniqueId];
                $( "#<%=txtTown.ClientID%>").val(vTown);

                var vCountry = ViewUsers.column(9).data()[uniqueId];//ViewUsers.column(6).data()[vIndex];
                $( "#<%=ddlCountry.ClientID%>").find('option:selected').text(vCountry);

                var vPostCode = ViewUsers.column(10).data()[uniqueId]; //ViewUsers.column(7).data()[vIndex];
                $( "#<%=txtPostCode.ClientID%>").val(vPostCode);

                var vMobile = ViewUsers.column(11).data()[uniqueId];//ViewUsers.column(8).data()[vIndex];
                $( "#<%=txtMobile.ClientID%>").val(vMobile);

                var vTelephone = ViewUsers.column(12).data()[uniqueId]; //ViewUsers.column(9).data()[vIndex];
                $("#<%=txtTelephone.ClientID%>").val(vTelephone);

             <%--   var vDirectParoll = ViewUsers.column(10).data()[vIndex];
                var vHourly = ViewUsers.column(11).data()[vIndex];
                if (ViewUsers.column(12).data()[vIndex] == 'Driver') {
                    //do Wage Type and Driver Type here
                    $('#driverSection').css('display', 'table');
                    $("#<%=rbDirectPayroll.ClientID%>").find('option:selected').text(vDirectParoll);
                    $( "#<%=rbHourlyBasis.ClientID%>").find('option:selected').text(vHourly);
                }--%>

                var vUserRole = ViewUsers.column(14).data()[uniqueId];
                $( "#<%=ddlUserRole.ClientID%>").find('option:selected').text(vUserRole);

                //Make appear Edit Details
                //====================================================
                $('#dvUserDetails').css('display', 'block');
                $('#dvUserDetails').css('margin-left', '100px');
                //====================================================

                //Make disappear View All Details 
                //=======================================================
                $('#dtViewUsers_wrapper').css('display', 'none');
                disappearAllButtons();
                //=======================================================

                return false;
            });

            $('#dtViewUsers tbody').on('click', '.delete', function () {
                var vClosestTr = $(this).closest("tr");

                var vUserId = vClosestTr.find('td').eq(0).text();
                $( '#<%=hfUserID.ClientID%>').val(vUserId);

                $('#RemoveUser-bx').modal('show');
                return false;
            });

            return false;
        }

        function getAllTitles() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetAllTitles",
                data: "{}",
                dataType: "json",
                success: function (data) {
                    $.each(data.d, function (key, value) {
                        $( "#<%=ddlTitle.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));

                    })
                },
                error: function (response) {
                }
            });
        }

        function getAllCountries() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetAllCountries",
                data: "{}",
                dataType: "json",
                success: function (data) {
                    $.each(data.d, function (key, value) {
                        $( "#<%=ddlCountry.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                    })
                },
                error: function (response) {
                }
            });
        }

        function getAllRoles() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllUsers.aspx/GetAllRoles",
                data: "{}",
                dataType: "json",
                success: function (data) {
                    $.each(data.d, function (key, value) {
                        $("#<%=ddlUserRole.ClientID%>").append($("<option></option>").val(value.ItemId).html(value.ItemValue));
                        //if (value.ItemValue == 'Administrator' || value.ItemValue == 'Staff') {

                        //}
                    })
                },
                error: function (response) {
                }
            });
        }

    </script>

    <script>
        function disappearAllButtons() {
            $( '#<%=btnAddNewUser.ClientID%>').css('display', 'none');
            $( '#<%=btnPrintAllUsers.ClientID%>').css('display', 'none');
            $( '#<%=btnExportViewAllUsersPDF.ClientID%>').css('display', 'none');
            $( '#<%=btnExportViewAllUsersExcel.ClientID%>').css('display', 'none');

            return false;
        }

        function gotoAddUserPage() {
            location.href = '/Users/NewUser.aspx';
            return false;
        }

        function takePrintout() {
            prtContent = document.getElementById('dtViewUsers');
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
        function printDetails(vTableId) {
            var prtContent = document.getElementById(vTableId);
            prtContent.border = 0; //set no border here

            var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
            WinPrint.document.write(prtContent.outerHTML);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

            return false;
        }

        function exportToPDF(vTableId, vPDF_FileName) {
            /*var pdf = new jsPDF('p', 'pt', 'letter');
            pdf.canvas.height = 72 * 11;
            pdf.canvas.width = 72 * 8.5;

            var vContent = document.getElementById(vTableId);
            pdf.fromHTML(vContent);

            pdf.save(vPDF_FileName);*/

            var quotes = document.getElementById(vTableId);
            //alert(quotes.clientHeight);

            html2canvas(quotes, {
                onrendered: function (canvas) {

                    //! MAKE YOUR PDF
                    var pdf = new jsPDF('p', 'pt', 'letter');

                    for (var i = 0; i <= quotes.clientHeight / 980; i++) {
                        //! This is all just html2canvas stuff
                        var srcImg = canvas;
                        var sX = 0;
                        var sY = 980 * i; // start 980 pixels down for every new page
                        var sWidth = 2000;
                        var sHeight = 980;
                        var dX = 0;
                        var dY = 0;
                        var dWidth = 2000;
                        var dHeight = 980;

                        window.onePageCanvas = document.createElement("canvas");
                        onePageCanvas.setAttribute('width', 2000);
                        onePageCanvas.setAttribute('height', 980);
                        var ctx = onePageCanvas.getContext('2d');
                        // details on this usage of this function: 
                        // https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Using_images#Slicing

                        ctx.drawImage(srcImg, 0, 0);
                        //ctx.drawImage(srcImg,sX,sY,sWidth,sHeight,dX,dY,dWidth,dHeight);

                        // document.body.appendChild(canvas);
                        var canvasDataURL = onePageCanvas.toDataURL("image/png", 1.0);

                        var width = onePageCanvas.width;
                        var height = onePageCanvas.clientHeight;

                        //! If we're on anything other than the first page,
                        // add another page
                        if (i > 0) {
                            pdf.addPage(612, 791); //8.5" x 11" in pts (in*72)
                        }
                        //! now we declare that we're working on that page
                        pdf.setPage(i + 1);
                        //! now we add content to that page!
                        pdf.addImage(canvasDataURL, 'PNG', 0, 0, (width * .42), (height * .62));

                    }
                    //! after the for loop is finished running, we save the pdf.
                    pdf.save(vPDF_FileName);
                }
            });

            return false;
        }

        function exportToExcel(vTableId, vExcelFileName) {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById(vTableId); // id of table

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
                sa = txtArea1.document.execCommand("SaveAs", true, vExcelFileName);
            }
            else                 //other browser not tested on IE 11
                sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

            return (sa);
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>View All Users
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <form id="frmViewAllUsers" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <asp:HiddenField ID="hfUserID" runat="server" />
                        </div>
                        <div class="panel-body clrBLK box_bg">
                            <div class="col-md-12">
                                <div class="col-md-5 pad_rgt_half">
                                    <span class="iconADD pull-right">
                                        <asp:Button ID="btnPrintAllUsers" runat="server"
                                            Text="Print User Details" OnClientClick="return takePrintout();" />
                                        <i class="fa fa-print" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD pull-right">
                                        <asp:Button ID="btnAddNewUser" runat="server"
                                            Text="Add New User" OnClientClick="return gotoAddUserPage();" />
                                        <i class="fa fa-user" aria-hidden="true"></i>
                                    </span>
                                </div>

                          <%--      <div class="col-md-2">
                                    <label class="iconADD control-label" style="color:white"> User <asp:RadioButton ID="rbUser" runat="server"
                                                    GroupName="DriverFilter"
                                                    onchange="getAllUsers();" /> </label>
                                    <label class="iconADD control-label" style="color:white"> Driver <asp:RadioButton ID="rbDriver" runat="server"
                                                    GroupName="DriverFilter"
                                                    onchange="getAllUsers();" /> </label>
                                </div>--%>

                                <div class="col-md-5 pad_left_half" style="padding-right: 25px;">
                                    <span class="iconADD pull-right" style="margin-bottom: 5px;">
                                        <asp:Button ID="btnExportViewAllUsersExcel" runat="server"
                                            Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD pull-right">
                                        <asp:Button ID="btnExportViewAllUsersPDF" runat="server"
                                            Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                        <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                    </span>
                                </div>
                            </div>

                            <div id="dvUserDetails" class="panel-body clrBLK col-md-10 dashboad-form"
                                style="margin-left: 100px;">
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Email Address<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtEmailID" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="example@gmail.com"
                                                title="Please enter Email Address"
                                                MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Confirm Email Address<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtConfirmEmailID" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="example@gmail.com"
                                                title="Please confirm Email Address"
                                                MaxLength="255" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Password<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                                CssClass="form-control m-b" PlaceHolder="******" title="Please enter Password"
                                                MaxLength="50" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Confirm Password<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                                                CssClass="form-control m-b" PlaceHolder="******" title="Please confirm Password"
                                                MaxLength="50" onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Title<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlTitle" runat="server"
                                                CssClass="form-control m-b" title="Please select a Title from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Title</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            First Name<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtFirstName" runat="server" MaxLength="50"
                                                CssClass="form-control m-b" PlaceHolder="e.g. Tom" title="Please enter First Name"
                                                onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Last Name<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtLastName" runat="server" MaxLength="50"
                                                CssClass="form-control m-b" PlaceHolder="e.g. Alter" title="Please enter Last Name"
                                                onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Date Of Birth<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtDOB" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onchange="clearErrorMessage();checkAdultDate();"></asp:TextBox>
                                        </div>
                                    </div>
                                    <!--Added new Script Files for Date Picker-->
                                    <script src="/js/bootstrap-datepicker.js"></script>
                                    <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Address Line 1<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtAddressLine1" runat="server" MaxLength="150"
                                                CssClass="form-control m-b" PlaceHolder="e.g. 1/A, Hasselfree Road, Marko Town"
                                                title="Please enter Address Line 1"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Country<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlCountry" runat="server"
                                                CssClass="form-control m-b" title="Please select a Country from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Country</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            House number</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control m-b"
                                                PlaceHolder="e.g. 44" title="Please enter House number" MaxLength="20"
                                                onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Town<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtTown" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="e.g. Bristol"
                                                title="Please enter Town" MaxLength="50"
                                                onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Mobile (+44)<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtMobile" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="e.g. 87123 123456"
                                                title="Please enter Mobile Number"
                                                MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">Telephone (+44)</label>
                                        <div class="col-sm-6">
                                            <asp:TextBox ID="txtTelephone" runat="server"
                                                CssClass="form-control m-b" PlaceHolder="e.g. 0117 9460018"
                                                title="Please enter Telephone Number"
                                                MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                 <div class="row" id="driverSection" style="display: none;">
                                
                                <div class="col-sm-12">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">
                                            Driver Type 
                                    <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <label>
                                                        Direct Payroll &nbsp;<asp:RadioButton
                                                            ID="rbDirectPayroll" runat="server"
                                                            GroupName="PayrollType"
                                                            onchange="clearErrorMessage();" /></label>
                                                </div>

                                                <div class="col-md-4">
                                                    <label>
                                                        3rd Party Payroll &nbsp;
                                                <asp:RadioButton ID="rbThirdPartyPayroll" runat="server"
                                                    GroupName="PayrollType"
                                                    onchange="clearErrorMessage();" /></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-12">
                                    <div class="row form-group marginbottom">
                                        <label class="col-sm-4 control-label">
                                            Wage Type 
                                    <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <label>
                                                        Hourly Basis &nbsp;<asp:RadioButton
                                                            ID="rbHourlyBasis" runat="server"
                                                            GroupName="WageType"
                                                            onchange="clearErrorMessage();" /></label>
                                                </div>

                                                <div class="col-md-4">
                                                    <label>
                                                        Monthly Basis &nbsp;
                                                <asp:RadioButton ID="rbMonthlyBasis" runat="server"
                                                    GroupName="WageType"
                                                    onchange="clearErrorMessage();" /></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                <div class="row">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            Primay Role<span style="color: red">*</span></label>
                                        <div class="col-sm-6">
                                            <asp:DropDownList ID="ddlUserRole" runat="server"
                                                CssClass="form-control m-b" title="Please select a Role from dropdown"
                                                onchange="getSpecificRoleDetails(this.value); clearErrorMessage();">
                                                <asp:ListItem>Select Role</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8">
                                            <asp:Button ID="btnUpdateUser" runat="server" Text="Update"
                                                CssClass="btn btn-primary btn-register"
                                                OnClientClick="return editUserDetails();" />
                                            <asp:Button ID="btnCancelUpdateDelete" runat="server"
                                                Text="Cancel" class="btn btn-default"
                                                OnClientClick="return clearAllControls();" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <table id="dtViewUsers">
                                <thead>
                                    <tr>
                                        <th>&nbsp;</th>
                                        <th>User Id</th>
                                        <th>Email Address</th>
                                        <th>User Name</th>
                                        <th>Date Of Birth</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>&nbsp;</th>
                                        <th>User Role</th>
                                        <th>Actions</th>


                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                        <div id="dtViewUsers_footer">
                            <hr />
                            <footer>
                                <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                            </footer>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="User-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">User - Update</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>User Details updated successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal"
                        onclick="location.reload();">
                        OK</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="RemoveUser-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Remove User</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: black;">
                    <p>Sure? You want to remove this User?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="removeUserDetails();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="dvUserModal" role="dialog">
        <div class="modal-dialog modal-lg">

            <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print User Details: #<span id="spHeaderUserId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center; font-size: 22px; overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this User below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintUserModal" data-dismiss="modal"
                                    onclick="return printDetails('tblUserDetails');" style="margin-bottom: 10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintPdfUserModal" data-dismiss="modal"
                                    onclick="exportToPDF('dvUserModal', 'UserDetails.pdf');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                </button>
                                <button id="btnPrintExcelUserModal" data-dismiss="modal"
                                    onclick="exportToExcel('tblUserDetails', 'UserDetails.xls');" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class=""></h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="table-responsive">
                                                <table class="table custoFULLdet" id="tblUserDetails">
                                                    <tr>
                                                        <th>User Id: </th>
                                                        <td><span id="spUserId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Email Address: </th>
                                                        <td><span id="spEmailAddress"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>User Name: </th>
                                                        <td><span id="spUserName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Date of Birth: </th>
                                                        <td><span id="spDateOfBirth"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Address: </th>
                                                        <td><span id="spAddress"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Town: </th>
                                                        <td><span id="spTown"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Country: </th>
                                                        <td><span id="spCountry"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>House number: </th>
                                                        <td><span id="spPostCode"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Mobile: </th>
                                                        <td><span id="spMobile"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Telephone: </th>
                                                        <td><span id="spTelephone"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>User Role: </th>
                                                        <td><span id="spUserRole"></span></td>
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
    </div>

    <iframe id="txtArea1" style="display: none"></iframe>

</asp:Content>

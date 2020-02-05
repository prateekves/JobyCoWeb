<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="JobyCoWeb.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script>
        function showPasswordInfo(vPassword) {
            var vPSWD = $(vPassword).val();

            //validate the length
            if (vPSWD.length < 8) {
                $('#length').removeClass('valid').addClass('invalid');
            } else {
                $('#length').removeClass('invalid').addClass('valid');
            }

            //validate letter
            if (vPSWD.match(/[A-z]/)) {
                $('#letter').removeClass('invalid').addClass('valid');
            } else {
                $('#letter').removeClass('valid').addClass('invalid');
            }

            //validate capital letter
            if (vPSWD.match(/[A-Z]/)) {
                $('#capital').removeClass('invalid').addClass('valid');
            } else {
                $('#capital').removeClass('valid').addClass('invalid');
            }

            //validate number
            if (vPSWD.match(/\d/)) {
                $('#number').removeClass('invalid').addClass('valid');
            } else {
                $('#number').removeClass('valid').addClass('invalid');
            }
        }

        function checkBlankControls() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vConfirmEmailID = $("#<%=txtConfirmEmailID.ClientID%>");

            var vPassword = $("#<%=txtPassword.ClientID%>");
            var vConfirmPassword = $("#<%=txtConfirmPassword.ClientID%>");

            var vTitle = $("#<%=ddlTitle.ClientID%>");
            var vFirstName = $("#<%=txtFirstName.ClientID%>");
            var vLastName = $("#<%=txtLastName.ClientID%>");

            var vDOB = $("#<%=txtDOB.ClientID%>");

            var vAddressLine1 = $("#<%=txtAddressLine1.ClientID%>");
            var vAddressLine2 = $("#<%=txtAddressLine2.ClientID%>");
            var vAddressLine3 = $("#<%=txtAddressLine3.ClientID%>");

            var vTown = $("#<%=txtTown.ClientID%>");
            var vCountry = $("#<%=ddlCountry.ClientID%>");
            var vPostCode = $("#<%=txtPostCode.ClientID%>");

            var vMobile = $("#<%=txtMobile.ClientID%>");
            var vTelephone = $("#<%=txtTelephone.ClientID%>");

            var vSecretQuestion = $("#<%=txtSecretQuestion.ClientID%>");
            var vSecretAnswer = $("#<%=txtSecretAnswer.ClientID%>");

            var vUserRole = $("#<%=ddlUserRole.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vEmailID.val().trim() == "") {
                vErrMsg.text('Enter Your Email Address');
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
                vErrMsg.text('Repeat Your Email Address');
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
                showErrorMessage("Error: Email Mismatch", "Email Address and Repeat Email Address must match");
                return false;
            }

            if (vPassword.val().trim() == "") {
                vErrMsg.text('Enter Your Password');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }

            if (vConfirmPassword.val().trim() == "") {
                vErrMsg.text('Repeat Your Password');
                vErrMsg.css("display", "block");
                vConfirmPassword.focus();
                return false;
            }

            if (vPassword.val().trim() != vConfirmPassword.val().trim()) {
                showErrorMessage("Error: Password Mismatch", "Password and Repeat Password must match");
                return false;
            }

            if (vTitle.val().trim() == "Select Title") {
                vErrMsg.text('Please select a title from dropdown');
                vErrMsg.css("display", "block");
                vTitle.focus();
                return false;
            }

            if (vFirstName.val().trim() == "") {
                vErrMsg.text('Enter Your First Name');
                vErrMsg.css("display", "block");
                vFirstName.focus();
                return false;
            }

            if (vLastName.val().trim() == "") {
                vErrMsg.text('Enter Your Last Name');
                vErrMsg.css("display", "block");
                vLastName.focus();
                return false;
            }

            if (vDOB.val().trim() == "") {
                vErrMsg.text('Enter Your Date Of Birth');
                vErrMsg.css("display", "block");
                vDOB.focus();
                return false;
            }

            if (vAddressLine1.val().trim() == "") {
                vErrMsg.text('Enter Your Address Line 1 atleast');
                vErrMsg.css("display", "block");
                vAddressLine1.focus();
                return false;
            }

            if (vTown.val().trim() == "") {
                vErrMsg.text('Enter Your Town');
                vErrMsg.css("display", "block");
                vTown.focus();
                return false;
            }

            if (vCountry.val().trim() == "Select Country") {
                vErrMsg.text('Please select a country from dropdown');
                vErrMsg.css("display", "block");
                vCountry.focus();
                return false;
            }

            if (vPostCode.val().trim() == "") {
                vErrMsg.text('Enter Your PostCode');
                vErrMsg.css("display", "block");
                vPostCode.focus();
                return false;
            }

            if (vMobile.val().trim() == "") {
                vErrMsg.text('Enter Your Mobile No');
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

            if (vTelephone.val().trim() == "") {
                vErrMsg.text('Enter Your Telephone No');
                vErrMsg.css("display", "block");
                vTelephone.focus();
                return false;
            }

            if (vTelephone.val().trim().length < 11) {
                vErrMsg.text('Invalid Telephone No');
                vErrMsg.css("display", "block");
                vTelephone.focus();
                return false;
            }

            if (vSecretQuestion.val().trim() == "") {
                vErrMsg.text('Enter Your Secret Question');
                vErrMsg.css("display", "block");
                vSecretQuestion.focus();
                return false;
            }

            if (vSecretAnswer.val().trim() == "") {
                vErrMsg.text('Enter Your Secret Answer');
                vErrMsg.css("display", "block");
                vSecretAnswer.focus();
                return false;
            }

            if (vUserRole.val().trim() == "Select Role") {
                vErrMsg.text('Please select a User Role from dropdown');
                vErrMsg.css("display", "block");
                vUserRole.focus();
                return false;
            }
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
            var vAddressLine2 = $("#<%=txtAddressLine2.ClientID%>");
            var vAddressLine3 = $("#<%=txtAddressLine3.ClientID%>");

            var vTown = $("#<%=txtTown.ClientID%>");
            var vCountry = $("#<%=ddlCountry.ClientID%>");
            var vPostCode = $("#<%=txtPostCode.ClientID%>");

            var vMobile = $("#<%=txtMobile.ClientID%>");
            var vTelephone = $("#<%=txtTelephone.ClientID%>");

            var vSecretQuestion = $("#<%=txtSecretQuestion.ClientID%>");
            var vSecretAnswer = $("#<%=txtSecretAnswer.ClientID%>");

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

            vSecretQuestion.val('');
            vSecretAnswer.val('');

            vUserRole.val('Select Role');

            //return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }

        function blockCutCopyPaste() {
            showErrorMessage('Do not be a Robot...Be a Human', 'No Cut Copy Paste here Please...');
            return false;
        }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="register-container">
    <div class="row">
        <div class="col-md-12">
            <div class="text-center m-b-md">
                <h3>Registration</h3>
                <img src="images/JobyCo_Logo.png" />
            </div>
            <div class="hpanel">
                <div class="panel-body">
                    <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                        style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                        <div class="row" style="border: 1px solid buttonface;">
                            <h3 class="text-center m-b-md">Login Details</h3>
                            <div class="form-group col-lg-6">
                                <label>Email Address</label>
                                <asp:TextBox ID="txtEmailID" runat="server"
                                    CssClass="form-control" PlaceHolder="example@gmail.com" 
                                    title="Please enter your Email Address"
                                       MaxLength="255" onkeypress="clearErrorMessage();"
                                       oncopy="return blockCutCopyPaste();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Repeat Email Address</label>
                                <asp:TextBox ID="txtConfirmEmailID" runat="server"
                                    CssClass="form-control" PlaceHolder="example@gmail.com" 
                                    title="Please repeat your Email Address"
                                       MaxLength="255" onkeypress="clearErrorMessage();"
                                    onpaste="return blockCutCopyPaste();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                    CssClass="form-control" PlaceHolder="******" title="Please enter your Password"
                                       MaxLength="50" onkeypress="clearErrorMessage();" 
                                    oncopy="return blockCutCopyPaste();"
                                    onpaste="return blockCutCopyPaste();"
                                    onfocus="$('#pswd_info').show();"
                                    onkeyup="showPasswordInfo(this);"
                                    onblur="$('#pswd_info').hide();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Repeat Password</label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                                    CssClass="form-control" PlaceHolder="******" title="Please repeat your Password"
                                       MaxLength="50" onkeypress="clearErrorMessage();"
                                    onpaste="return blockCutCopyPaste();"
                                    onfocus="$('#pswd_info').show();"
                                    onkeyup="showPasswordInfo(this);"
                                    onblur="$('#pswd_info').hide();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="row" style="border: 1px solid buttonface;">
                            <div id="pswd_info" class="form-group col-lg-12">
                                <h4 class="text-center m-b-md">Password must meet the following requirements:</h4>
                                <ul>
                                    <li id="letter" class="invalid">At least <strong>one letter</strong></li>
                                    <li id="capital" class="invalid">At least <strong>one capital letter</strong></li>
                                    <li id="number" class="invalid">At least <strong>one number</strong></li>
                                    <li id="length" class="invalid">Be at least <strong>8 characters</strong></li>
                                </ul>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="row" style="border: 1px solid buttonface;">
                            <h3 class="text-center m-b-md">Personal Details</h3>
                            <div class="form-group col-lg-6">
                                <label>Title</label>
                                <asp:DropDownList ID="ddlTitle" runat="server"
                                    CssClass="form-control" title="Please select a title from dropdown"
                                    onchange="clearErrorMessage();">
                                    <asp:ListItem>Select Title</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" MaxLength="50"
                                    CssClass="form-control" PlaceHolder="e.g. Tom" title="Please enter your First Name"
                                    onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" MaxLength="50"
                                    CssClass="form-control" PlaceHolder="e.g. Alter" title="Please enter your Last Name"
                                       onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Date Of Birth</label>
                                <asp:TextBox ID="txtDOB" runat="server" MaxLength="10" 
                                    CssClass="form-control" size="23" PlaceHolder="e.g. 12/13/2001" TextMode="Date" 
                                    title="Please enter your Date Of Birth"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="row" style="border: 1px solid buttonface;">
                            <h3 class="text-center m-b-md">Address Details</h3>
                            <div class="form-group col-lg-6">
                                <label>Address Line 1</label>
                                <asp:TextBox ID="txtAddressLine1" runat="server" MaxLength="150"
                                    CssClass="form-control" PlaceHolder="e.g. 1/A, Hasselfree Road, Marko Town" 
                                       title="Please enter your Address Line 1" 
                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Address Line 2</label>
                                <asp:TextBox ID="txtAddressLine2" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. P.O. - Joomla Park, P.S. - Oly Street"
                                       title="Please enter your Address Line 2" MaxLength="150"
                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Address Line 3</label>
                                <asp:TextBox ID="txtAddressLine3" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. East London"
                                       title="Please enter your Address Line 3" MaxLength="150"
                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Town</label>
                                <asp:TextBox ID="txtTown" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. Bristol" 
                                    title="Please enter your Town" MaxLength="50"
                                       onkeypress="CharacterOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Country</label>
                                <asp:DropDownList ID="ddlCountry" runat="server"
                                    CssClass="form-control" title="Please select a Country from dropdown"
                                    onchange="clearErrorMessage();">
                                    <asp:ListItem>Select Country</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>House number</label>
                                <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control"
                                       PlaceHolder="e.g. 44" title="Please enter your House number" MaxLength="20"
                                       onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Mobile</label>
                                +44<asp:TextBox ID="txtMobile" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. 87123 123456" 
                                    title="Please enter your Mobile Number" 
                                       MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Telephone</label>
                                +44<asp:TextBox ID="txtTelephone" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. 0117 9460018" 
                                    title="Please enter your Telephone Number" 
                                       MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                           <!--<div class="checkbox col-lg-12">
                            <input type="checkbox" class="i-checks" checked>
                            Sign up for our newsletter
                            </div>-->
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="row" style="border: 1px solid buttonface;">
                            <h3 class="text-center m-b-md">Password Recovery</h3>
                            <div class="form-group col-lg-6">
                                <label>Secret Question</label>
                                <asp:TextBox ID="txtSecretQuestion" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. What is your Pet's Name?" 
                                       title="Please enter your Secret Question"
                                       MaxLength="100" onkeypress="clearErrorMessage();"></asp:TextBox>
                            </div>
                            <div class="form-group col-lg-6">
                                <label>Secret Answer</label>
                                <asp:TextBox ID="txtSecretAnswer" runat="server"
                                    CssClass="form-control" PlaceHolder="e.g. Katty" 
                                    title="Please enter your Secret Answer"
                                       MaxLength="100" onkeypress="clearErrorMessage();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="row" style="border: 1px solid buttonface;">
                            <h3 class="text-center m-b-md">User Roles</h3>
                            <div class="form-group col-lg-6">
                                <label>Primay Role</label>
                                <asp:DropDownList ID="ddlUserRole" runat="server"
                                    CssClass="form-control" title="Please select a Role from dropdown"
                                    onchange="clearErrorMessage();">
                                    <asp:ListItem>Select Role</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="row" style="border: 1px solid buttonface;">
                            <h3 class="text-center m-b-md">Upload Photo</h3>
                            <div class="form-group col-lg-6">
                                <label>Upload your Photo</label>
                                <asp:FileUpload ID="fuPhoto" runat="server" title="Please Upload your Photo" /> 
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="text-center">
                            <asp:Button ID="btnRegister" runat="server" Text="Register"
                              CssClass="btn btn-success" OnClientClick="return checkBlankControls();"
                                 OnClick="btnRegister_Click" />
                            <button class="btn btn-default" onclick="clearAllControls();">Cancel</button>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                        <div class="text-center">
                            <a class="btn btn-primary" href="Login.aspx">Back to Login</a>
                        </div>
                </div>
            </div>
        </div>
    </div>
   <!--<div class="row">
            <div class="col-md-12 text-center">
                <strong>HOMER</strong> - AngularJS Responsive WebApp <br /> 2015 Copyright Company Name
            </div>
        </div>-->
</div>

</asp:Content>

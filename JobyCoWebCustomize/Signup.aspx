<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithMenuBar.Master" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" 
    Inherits="JobyCoWebCustomize.Signup" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>
    $(document).ready(function () {
        getUserId();

        $("#<%=txtName.ClientID%>").on('change keyup paste', function () {
            clearErrorMessage();
        });

        $("#<%=txtEmailID.ClientID%>").on('change keyup paste', function () {
			clearErrorMessage();
        });

        $("#<%=txtPassword.ClientID%>").on('change keyup paste', function () {
			clearErrorMessage();
        });

        $("#phone").on('change keyup paste', function () {
			clearErrorMessage();
        });

        // Change the country selection for Collection Mobile    
        $("#phone").intlTelInput("setCountry", "gb");

        //Password Box Focus movement
        var Password = $("#<%=txtPassword.ClientID%>");
        Password.blur(function () {
            var vPassword = Password.val().trim();

            if (vPassword == "") {
                Password.focus();
            }
            else {
                $("#phone").focus();
            }
        });
    });
</script>

    <script>
     function getUserId() {

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Signup.aspx/GetUserId",
            data: "{}",
            dataType: "json",
            success: function (result) {
                $("#<%=hfUserId.ClientID%>").val(result.d);
                //alert(result.d);
            },
            error: function (response) {

            }
        });
     }
</script>

    <script>
        function checkBlankTextBoxes() {
            var vName = $("#<%=txtName.ClientID%>");
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");
            var vPhoneNo = $("#phone");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");

            if (vName.val().trim() == "") {
                vErrMsg.text('Enter Your Name');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                vName.focus();
                return false;
            }

            if (vEmailID.val().trim() == "") {
                vErrMsg.text('Enter Your Email ID');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                vEmailID.focus();
                return false;
            }

            if (!IsEmail(vEmailID.val().trim())) {
                vErrMsg.text('Invalid Email ID');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                vEmailID.focus();
                return false;
            }

            if (vPassword.val().trim() == "") {
                vErrMsg.text('Enter Your Password');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                vPassword.focus();
                return false;
            }

            var vPasswordLength = vPassword.val().trim().length;
            if ( vPasswordLength > 0 && vPasswordLength < 6 )
            {
                vErrMsg.text( 'Password should be minimum of 6 and maximum of 14 characters' );
                vErrMsg.css( "width", "400px" );
                vErrMsg.css( "display", "block" );
                vPassword.focus();
                return false;
            }

            if ( vPasswordLength > 14 )
            {
                vErrMsg.text( 'Password should be minimum of 6 and maximum of 14 characters' );
                vErrMsg.css( "width", "400px" );
                vErrMsg.css( "display", "block" );
                vPassword.focus();
                return false;
            }

            if ( vPhoneNo.val().trim() == "" )
            {
                vErrMsg.text('Enter Your Phone Number');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                vPhoneNo.focus();
                return false;
            }

            if (vPhoneNo.val().trim().length < 10) {
                vErrMsg.text('Invalid Phone Number');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                vPhoneNo.focus();
                return false;
            }

            return true;
        }

        function clearAllTextBoxes() {
            var vName = $("#<%=txtName.ClientID%>");
            //var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");
            var vPhoneNo = $("#phone");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "aliceblue");
            vErrMsg.css("color", "green");

            vName.val('');
            //vEmailID.val('');
            vPassword.val('');
            vPhoneNo.val('');

            vName.focus();

            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            //vErrMsg.hide(1000).delay(1000).fadeOut(1000);
        }

        function signUp() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

            //Saving User Details First
            var UserId = $("#<%=hfUserId.ClientID%>").val().trim();
            //alert('UserId: ' + UserId);

            //Checking Existence of EmailID
            var FullName = $("#<%=txtName.ClientID%>").val().trim();
            var EmailID = $("#<%=txtEmailID.ClientID%>").val().trim();
            var Password = $("#<%=txtPassword.ClientID%>").val().trim();
            var Mobile = $("#phone").val().trim();

            var bExists = false;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Signup.aspx/CheckUserId",
                data: "{ EmailID: '" + EmailID + "'}",
                dataType: "json",
                success: function (result) {
                    if (result.d.toString() == "true") {
                        //$.dialog({
                        //    title: 'Existence Detected',
                        //    content: 'This User already exists..Try another..'
                        //});

                        $( '#hHeader' ).text( 'Existence detected' );
                        $( '#pBody' ).text( 'This User already exists..Try another..' );

                        $( '#SignUp-bx' ).modal( 'show' );

                        bExists = true;

                        //setTimeout(function () {
                        //    location.href = '/Signup.aspx';
                        //}, 3000);

                        return false;
                    }
                    else {
                        bExists = false;

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

                        var DOB = getCurrentDateDetails();
                        var Address = "";
                        var Town = "";
                        var Country = "";
                        var PostCode = "";
                        var Telephone = "";
                        var SecretQuestion = "No Secret Question";
                        var SecretAnswer = "No Secret Answer";
                        var UserRole = "Customer";
                        var Locked = "false";

                        //Binding User Details to object
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

                        objUser.SecretQuestion = SecretQuestion;
                        objUser.SecretAnswer = SecretAnswer;
                        objUser.UserRole = UserRole;
                        objUser.Locked = Locked;

                        var timeDuration = 2000;

                        $.ajax({
                            type: "POST",
                            url: "Signup.aspx/AddUserDetails",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify(objUser),
                            dataType: "json",
                            success: function (result) {
                                if (!bExists) {
                                    //$.dialog({
                                    //    title: 'Sign up completed',
                                    //    content: 'User Details added successfully'
                                    //});
                                    //$( '#hHeader' ).text( 'Sign up completed' );
                                    //$( '#pBody' ).text( 'User Details added successfully' );

                                    //$( '#SignUp-bx' ).modal( 'show' );

                                    SendSignupEmail(EmailID, Password);
                                }
                            },
                            error: function (response) {

                            }
                        });
                    }//end of Existence Else
                },
                error: function (response) {

                }
            });

            return true;
    }

        function freeRegister() {
        if (checkBlankTextBoxes()) {
            if (signUp()) {

            }
        }

        return false;
    }

        function SendSignupEmail(EmailID, Password) {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Signup.aspx/SendSignupEmail",
                    data: "{ EmailID: '" + EmailID + "', Password: '" + Password + "'}",
                    dataType: "json",
                    beforeSend: function () {
                        $("#loaderDiv").show();

                        $("#loaderQuotationText").hide();
                        $("#successQuotationText").show().text('Please wait while we send your login credentials to your email');
                        $("#anchorHome").hide();

                        $("#loaderBookingText").hide();
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
                        $("#successBookingText").show().html(

                            '<i class="fa fa-check" aria-hidden="true"></i>' +
                        ' Signup Successfully Completed' +
                        '<br><a href="/Login.aspx" style="text-decoration: none;" id="anchorHomeB">' +
                            'Back to Login</a>'
                            );
                        $("#anchorHomeB").show();

                        $("#loaderImage").hide();
                        clearAllTextBoxes();
                        //vErrMsg.text(result.d);

                        //if (vErrMsg.text().trim() == "Signup successfull") {
                        //    vErrMsg.css("background-color", "#f9edef");
                        //    vErrMsg.css("color", "red");
                        //}

                        //if (vErrMsg.text().trim() == "Signup failed") {
                        //    vErrMsg.css("background-color", "aliceblue");
                        //    vErrMsg.css("color", "green");
                        //}

                        //vErrMsg.css("display", "none");
                    },
                    error: function (response) {

                    }
                });

                return false;
            }

    //function closeSuccessDialog() {
            //clearErrorMessage();
            //$("#dvSignupEmail").hide(500);
            //$("#<%=btnSignUpForFreeAccount.ClientID%>").attr("disabled", "disabled");
        //}

</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="col-md-5 col-sm-6">
    <div class="row whtLay">
        <div class="col-md-12">
<%--            <a class="navbar-brand" href="/Landing.aspx"><img src="/images/logo.svg" alt="" class="img-responsive" /></a>--%>
        </div>
        <div class="fromPad">
         <div class="loginForm">
            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                style="text-align:center; vertical-align: middle; line-height: 30px; 
                border-radius: 0px; padding: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>
            <h5>Sign Up</h5>
             <asp:HiddenField ID="hfUserId" runat="server" />
            <label for="siFname" class="custom_register_form-group">Name <span class="ft-color-red">*</span></label>
            <asp:TextBox ID="txtName" CssClass="form-control" 
                    PlaceHolder="Enter Name" title="Please enter your Name"
                    MaxLength="32" onkeypress="CharacterOnly(event);clearErrorMessage();" runat="server"
                    ></asp:TextBox>

            <label for="siEmail1" class="custom_register_form-group">Email <span class="ft-color-red">*</span></label>
            <asp:TextBox ID="txtEmailID" CssClass="form-control" 
                    PlaceHolder="Enter Email" title="This is your Signup Email"
                    MaxLength="255" onkeypress="clearErrorMessage();" runat="server"
                    style="text-transform: lowercase;"></asp:TextBox>

            <label>Password <span class="ft-color-red">*</span></label>
            <asp:TextBox ID="txtPassword" runat="server" PlaceHolder="Enter Password" title="Please enter your Password"
                TextMode="Password" MaxLength="50" CssClass="form-control" 
                onkeypress="clearErrorMessage();"></asp:TextBox>

                 <label>Phone Number <span class="ft-color-red">*</span></label>
                 <input id="phone" class="flag-tel" type="tel" placeholder="Enter Phone Number" 
                     onkeypress="NumericOnly(event);clearErrorMessage();" />
             
            <%--<asp:TextBox ID="txtPhoneNo" CssClass="form-control" 
                    PlaceHolder="081234 56789" title="Please enter your Phone Number"
                    MaxLength="11" onkeypress="NumericOnly(event);clearErrorMessage();" 
                    runat="server"></asp:TextBox>--%>

            <div class="row">
                <div class="col-md-6 col-md-push-6">
                    <asp:Button ID="btnSignUpForFreeAccount" runat="server" Text="Sign Up" 
                    CssClass="lg-sg-BTN" OnClientClick="return freeRegister();" OnClick="btnSignUpForFreeAccount_Click" />
                </div>
                <div class="col-md-6 col-md-pull-6">
                    <p class="custom_register_span">&nbsp;Already have an Account? 
                        <a href="/Login.aspx" class="signUPlink">Login</a></p>
                </div>
            </div>
            <div id="loaderDiv" style="display: none;">
                <i class="fa fa-spinner fa-spin fa-2x fa-fw"></i>
                <span class="sr-only">Loading...</span>
            </div>
         </div>
    </div>
    </div>
</div>
<div class="col-md-7 col-sm-6">
    <div class="row">
        <div class="mapBGholder" style="background:#293038 url(/images/map.png) no-repeat center center; height:100vh;">
            <div class="infographHldr" align="center">
                <img src="/images/infographic.png" alt="" class="img-responsive"/>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="SignUp-bx" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header" style="background-color: #f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 id="hHeader" class="modal-title" style="font-size: 24px; color: #111;">Sign Up Header</h4>
            </div>
            <div class="modal-body" style="text-align: center; font-size: 22px;">
                <p id="pBody">Sign Up Body</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="">OK</button>
            </div>
        </div>

    </div>
</div>

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithMenuBar.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="JobyCoWebCustomize.Login" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script>
    $(document).ready(function () {

        $("#<%=txtEmailID.ClientID%>").on('change keyup paste', function () {
			clearErrorMessage();
        });

        $("#<%=txtPassword.ClientID%>").on('change keyup paste', function () {
			clearErrorMessage();
        });

        $("#navbar > ul > li").removeClass("active");
        $("#CustomerPortal").addClass("active");

        <%--$("#<%=txtEmailID.ClientID%>").val(('#HiddenCheckedEmail').val().trim());--%>
    });
</script>

<script>
    function checkBlankTextBoxes() {
        
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");

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

            return true;
        }

        function clearAllTextBoxes() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");
            var vPassword = $("#<%=txtPassword.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");

            vEmailID.val('');
            vPassword.val('');
            vEmailID.focus();

            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            //vErrMsg.hide(1000).delay(1000).fadeOut(1000);
        }

        function getLoginResult() {
            var EmailID = $("#<%=txtEmailID.ClientID%>").val().trim();
            var Password = $("#<%=txtPassword.ClientID%>").val().trim();

            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#f9edef");
            ErrMsg.css("color", "red");
            ErrMsg.css("text-align", "center");

            var vErrMsg = "";

            $.ajax({
                type: "POST",
                url: "Login.aspx/getLoginResult",
                data: '{ EmailID: "' + EmailID + '", Password: "'+ Password + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ErrMsg.text(result.d);
                    vErrMsg = ErrMsg.text().trim();

                    if (vErrMsg != "Login successful") {
                        /*ErrMsg.css("display", "block");
                        ErrMsg.show(1000).delay(1000).fadeOut(1000);*/

                        $("#dvLoginResult").show(500);
                    }
                    else {
                        /*ErrMsg.css("background-color", "aliceblue");
                        ErrMsg.css("color", "green");
                        ErrMsg.css("display", "block");
                        ErrMsg.show(1000).delay(1000).fadeOut(1000);*/

                        $("#dvLoginResult").hide(500);
                        location.href = "/Dashboard.aspx";
                    }
                },
                error: function (response) {
                    alert('Unable to get Login Result');
                }
            });

            //return true;
        }

    function closeErrorDialog() {
        clearErrorMessage();
        $("#dvLoginResult").hide(500);
        clearAllTextBoxes();
    }

    function checkLoginStatus() {
        if (checkBlankTextBoxes()) {
            if (getLoginResult()) {
                clearAllTextBoxes();
            }
        }

        return false;
    }

    function gotoLandingPage() {
        location.href = '/Landing.aspx';
        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="col-md-5 col-sm-6">
    <div class="row whtLay">
        <%--    <div class="col-md-12">
                    <a class="navbar-brand" href="/Landing.aspx"><img src="/images/logo.svg" alt="" class="img-responsive" /></a>
                </div>--%>
        <div class="fromPad">
            <div class="loginForm" id="loginDiv">
            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                style="text-align:center; vertical-align: middle; line-height: 30px; 
                border-radius: 0px; padding: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>
                
                <h5>Login</h5>
                <div class="login-alert alert alert-danger alert-dismissible" role="alert" id="dvLoginResult" style="display: none;">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close" onclick="closeErrorDialog();"><span aria-hidden="true">&times;</span></button>
                    <strong>Error!</strong> We were unable to log you in: <span class="error-reason"> </span><br/><br/>
                    You can visit the <a href="//logmandirect.com">Customer Portal</a> to reset your password.
                </div>
                <div class="">
                    <label style="color: white;">Email</label>
                    <asp:TextBox ID="txtEmailID" CssClass="form-control" 
                            PlaceHolder="Enter Email" title="Please enter your Email"
                            MaxLength="255" onkeypress="clearErrorMessage();" runat="server"
                            style="text-transform: lowercase;"></asp:TextBox>
                </div>               
                    <br />                
                <div class="">
                    <label style="color: white;">Password <span class="ft-color-red">*</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" PlaceHolder="Enter Password" title="Please enter your Password"
                        TextMode="Password" MaxLength="50" CssClass="form-control" onkeypress="clearErrorMessage();"
                        ></asp:TextBox>
                </div>
                
                    <br />
               
                <div class="row">
                    <div class="col-md-6 col-md-push-6">
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="lg-sg-BTN" 
                        OnClientClick="return checkBlankTextBoxes();" OnClick="btnLogin_Click" />
                        
                    </div>
                    <div class="col-md-6 col-md-pull-6">
                   
                        <a href="/ResetPassword.aspx" class="frogotPass">Forgot Password?</a>
                        <%--<p class="custom_register_span">Don't have an account? &nbsp;--%>
                        <%--<a href="/Signup.aspx" class="signUPlink" id="show">Sign Up</a></p>--%>
                    </div>
                </div>

                <div class="row">
                    <div style="height: 50px;">

                    </div>
                </div>

                <%--            <div class="row">
                                    <div class="col-md-12">
                                        <!--New Back Button Added-->
                                        <button id="btnBack" class="buttonBK" onclick="return gotoLandingPage();">
                                            Back
                                        </button>
                                    </div>
                                    <div class="col-md-6 col-md-pull-6">

                                    </div>
                                </div>--%>
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

</asp:Content>

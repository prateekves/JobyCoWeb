<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithoutMenuBar.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="JobyCoWeb.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script>
    $(document).ready(function () {

        $("#<%=txtEmailID.ClientID%>").on('change keyup paste', function () {
			clearErrorMessage();
        });

        $("#<%=txtPassword.ClientID%>").on('change keyup paste', function () {
			clearErrorMessage();
        });

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
                vEmailID.focus();
                return false;
            }

            if (!IsEmail(vEmailID.val().trim())) {
                vErrMsg.text('Invalid Email ID');
                vErrMsg.css("display", "block");
                vEmailID.focus();
                return false;
            }

            if (vPassword.val().trim() == "") {
                vErrMsg.text('Enter Your Password');
                vErrMsg.css("display", "block");
                vPassword.focus();
                return false;
            }
            var Location = getCookie('setlocation');
            //alert(Location);
            $('#<%=hfSetLocation.ClientID%>').val(Location);

             //alert(Location);
            //return false;
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
        }

</script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfSetLocation" runat="server" />
    <div class="hmForm" id="dvSignup">
        <div class="formContent">
        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
            style="text-align:center; vertical-align: middle; line-height: 30px; 
            border-radius: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>
            <span class="stfPGlogo"><img src="/images/logo.svg" alt="" class="img-responsive" /></span>
            <h4>Login to your account</h4>
            <div class="indexSign">
                <div class="row">
                    <div class="col-md-12">
                    <asp:TextBox ID="txtEmailID" CssClass="form-control"
                    PlaceHolder="Enter Email" title="Please enter your Email"
                    MaxLength="255" onkeypress="clearErrorMessage();" runat="server"
                    style="text-transform: lowercase;"></asp:TextBox>
                </div>                               
                    <div class="col-md-12">
                    <asp:TextBox ID="txtPassword" runat="server" PlaceHolder="Enter Password" title="Please enter your Password"
                    TextMode="Password" MaxLength="50" CssClass="form-control" onkeypress="clearErrorMessage();"
                    ></asp:TextBox>
                </div>
                </div>
                <div class="row">
                    <div class="col-md-6 col-md-push-6">
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="inSGNbtn" 
                        OnClientClick="return checkBlankTextBoxes();" OnClick="btnLogin_Click" />
                    </div>
                    <div class="col-md-6 col-md-pull-6">                   
                        <a href="/ResetPassword.aspx" class="frogotPass">Forgot Password?</a>
                        <!--<p class="custom_register_span">Don't have an account? &nbsp;
                        <a href="/Signup.aspx" class="signUPlink" id="show">Sign Up</a></p>-->
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

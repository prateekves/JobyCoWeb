<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithMenuBar.Master" AutoEventWireup="true" 
    CodeBehind="ResetPassword.aspx.cs" Inherits="JobyCoWebCustomize.ResetPassword"
    EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script>
         function checkBlankTextBoxes() {
            var RegisteredEmailID = $("#<%=txtRegisteredEmailID.ClientID%>");
            var vRegisteredEmailID = RegisteredEmailID.val().trim();

            var ErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#ffd3d9");
            ErrMsg.css("color", "red");

            if (vRegisteredEmailID == "") {
                ErrMsg.text('Enter Your Registered EmailID');
                ErrMsg.css("display", "block");
                RegisteredEmailID.focus();
                return false;
            }

            if (!IsEmail(vRegisteredEmailID)) {
                ErrMsg.text('Invalid EmailID');
                ErrMsg.css("display", "block");
                RegisteredEmailID.focus();
                return false;
            }

            return true;
        }

        function clearErrMsg() {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
        }

<%--        function clearAllTextBoxes()
        {
           var RegisteredEmailID = $("#<%=txtRegisteredEmailID.ClientID%>");

            RegisteredEmailID.val('');
            clearErrMsg();
            RegisteredEmailID.focus();

            return false;
        }--%>
</script>

<script>

    function checkRegisteredEmailID() {
        var RegisteredEmailID = $( '#<%=txtRegisteredEmailID.ClientID%>' ).val().trim();

            var ErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#ffd3d9");
            ErrMsg.css("color", "red");

            $.ajax({
                type: "POST",
                url: "ResetPassword.aspx/CheckRegisteredEmailID",
                data: "{ RegisteredEmailID: '" + RegisteredEmailID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d) {

                        $.ajax({
                            type: "POST",
                            url: "ResetPassword.aspx/GetEncryptedEmailID",
                            data: "{ RegisteredEmailID: '" + RegisteredEmailID + "'}",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {
                                var EncryptedEmailID = result.d;

                                //Binding EmailIDs to Objects
                                //===========================================
                                objResetLink = {};
                                objResetLink.RegisteredEmailID = RegisteredEmailID;
                                objResetLink.EncryptedEmailID = EncryptedEmailID;

                                $.ajax({
                                    type: "POST",
                                    contentType: "application/json; charset=utf-8",
                                    url: "ResetPassword.aspx/SendResetLinkByEmail",
                                    data: JSON.stringify(objResetLink),
                                    dataType: "json",
                                    beforeSend: function () {
                                        $("#resetPasswordDiv").show();

                                        $("#loaderResetPasswordText").show();
                                        $("#successResetPasswordText").hide();

                                        $("#resetPasswordImage").show();
                                    },
                                    success: function (result) {
                                        $("#resetPasswordDiv").show();

                                        $("#loaderResetPasswordText").hide();
                                        $("#successResetPasswordText").show();

                                        $("#resetPasswordImage").hide();

                                        //Store The Details in 'Reset Password' Table
                                        //===========================================
                                        objResetPassword = {};
                                        objResetPassword.RegisteredEmailID = RegisteredEmailID;
                                        objResetPassword.EncryptedEmailID = EncryptedEmailID;

                                        $.ajax({
                                            type: "POST",
                                            url: "ResetPassword.aspx/AddResetPassword",
                                            data: JSON.stringify(objResetPassword),
                                            contentType: "application/json; charset=utf-8",
                                            dataType: "json",
                                            success: function (result) {

                                            },
                                            error: function (response) {
                                                alert('Unable to Store Encrypted EmailID');
                                            }
                                        });
                                    },
                                    error: function (response) {
                                        $("#resetPasswordDiv").hide();
                                    }
                                });
                            },
                            error: function (response) {
                                alert('Unable to Encrypt Registered EmailID');
                            }
                        });
                    }
                    else {
                        ErrMsg.text('This EmailID is not Registered');
                        ErrMsg.css("display", "block");
                    }
                },
                error: function (response) {
                    alert('Unable to Check Registered EmailID');
                }
            });

        return false;
    }

    function sendResetLink() {
        if (checkBlankTextBoxes()) {
            checkRegisteredEmailID();
        }

        return false;
    }

</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="row nomargin">
<div class="col-md-5">
    <div class="row whtLay">
        <div class="col-md-12">
<%--            <a class="navbar-brand" href="/login.aspx"><img src="/images/logo.svg" alt="" class="img-responsive" /></a>--%>
        </div>
        <div class="fromPad">
            <div class="loginForm" id="loginDiv">
            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                style="text-align:center; vertical-align: middle; line-height: 30px; 
                border-radius: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>
                
                <h5>Reset Password</h5>               
                <div id="dvResetPassword" class="row">
                    <div class="row">
                        <%--<div class="col-md-6">
                            <label>Registered Email:</label>
                        </div>--%>
                        <div class="col-md-12">
                            <asp:TextBox ID="txtRegisteredEmailID" runat="server" PlaceHolder="Registered Email"
                            onkeypress="clearErrMsg();"></asp:TextBox>                           
                        </div>
                    </div>
                    <div class="row">
                        <%--<div class="col-md-6"></div>--%>
                        <div class="col-md-12 btn_section">
                            <asp:Button ID="btnSavePassword" runat="server" Text="Reset Password"
                                OnClientClick="return sendResetLink();" />
<%--                            <asp:Button ID="btnCancelPassword" runat="server" Text="Cancel"
                                OnClientClick="return clearAllTextBoxes();" />--%>
                        </div>
                    </div>
                </div>
            </div>        
       </div>
   </div>
</div>

<div class="col-md-7">
    <div class="row">
        <div class="mapBGholder" style="background:#293038 url(/images/map.png) no-repeat center center;">
            <div class="infographHldr" align="center">
                <img src="/images/infographic.png" alt="" class="img-responsive"/>
            </div>
        </div>
    </div>
</div>
</div>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithMenuBar.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="JobyCoWebCustomize.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>
        $(document).ready(function () {
            var PasswordChangeDate = $('#<%=hfPasswordChangeDate.ClientID%>').val().trim();
            checkExpiryDate(PasswordChangeDate);
        });
    </script>

    <script>
         function checkBlankTextBoxes() {
            var NewPassword = $("#<%=txtNewPassword.ClientID%>");
            var vNewPassword = NewPassword.val().trim();

            var ConfirmPassword = $("#<%=txtConfirmPassword.ClientID%>");
            var vConfirmPassword = ConfirmPassword.val().trim();

            var ErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#ffd3d9");
            ErrMsg.css("color", "red");

                if (vNewPassword == "") {
                    ErrMsg.text('Enter Your New Password');
                    ErrMsg.css("display", "block");
                    NewPassword.focus();
                    return false;
                }

                if (vNewPassword.length < 6) {
                    ErrMsg.text('New Password should be minimum of 6 characters');
                    ErrMsg.css("display", "block");
                    NewPassword.focus();
                    return false;
                }

                //if ( vNewPassword.length > 14 )
                //{
                //    ErrMsg.text( 'New Password should be maximum of 14 characters' );
                //    ErrMsg.css( "display", "block" );
                //    NewPassword.focus();
                //    return false;
                //}

                if (vConfirmPassword == "") {
                    ErrMsg.text('Enter Your Confirm Password');
                    ErrMsg.css("display", "block");
                    ConfirmPassword.focus();
                    return false;
                }

                if (vConfirmPassword.length < 6) {
                    ErrMsg.text('Confirm Password should be minimum of 6 characters');
                    ErrMsg.css("display", "block");
                    ConfirmPassword.focus();
                    return false;
                }

                //if ( vConfirmPassword.length > 14 )
                //{
                //    ErrMsg.text( 'Confirm Password should be maximum of 14 characters' );
                //    ErrMsg.css( "display", "block" );
                //    ConfirmPassword.focus();
                //    return false;
                //}

                if (vNewPassword != vConfirmPassword) {
                    ErrMsg.text('New and Confirm Password must match');
                    ErrMsg.css("display", "block");
                    return false;
                }

            return true;
        }

        function clearErrMsg() {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
        }

        function clearAllTextBoxes()
        {
           var NewPassword = $("#<%=txtNewPassword.ClientID%>");
           var ConfirmPassword = $("#<%=txtConfirmPassword.ClientID%>");

            NewPassword.val('');
            ConfirmPassword.val( '' );
            clearErrMsg();
            NewPassword.focus();

            return false;
        }
</script>

    <script>

    function checkExpiryDate(PasswordChangeDate) {

            var ErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#ffd3d9");
            ErrMsg.css("color", "red");

        $.ajax({
            type: "POST",
            url: "ChangePassword.aspx/CheckExpiryDate",
            data: '{ PasswordChangeDate: "' + PasswordChangeDate + '"}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                if (result.d == "Blocked") {
                  var EncryptedEmailID = $('#<%=hfEncryptedEmailID.ClientID%>').val().trim();

                    $.ajax({
                        type: "POST",
                        url: "ChangePassword.aspx/GetRegisteredEmailID",
                        data: '{ EncryptedEmailID: "' + EncryptedEmailID + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            var RegisteredEmailID = result.d;

                            //Store The Details in 'Reset Password' Table
                            //===========================================
                            objResetPassword = {};
                            objResetPassword.RegisteredEmailID = RegisteredEmailID;
                            objResetPassword.EncryptedEmailID = EncryptedEmailID;

                            $.ajax({
                                type: "POST",
                                url: "ChangePassword.aspx/UpdateResetPassword",
                                data: JSON.stringify(objResetPassword),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (result) {

                                    $('#<%=txtNewPassword.ClientID%>').attr("disabled", "disabled");
                                    $('#<%=txtConfirmPassword.ClientID%>').attr("disabled", "disabled");
                                    $('#<%=btnSavePassword.ClientID%>').attr("disabled", "disabled");
                                    $('#<%=btnCancelPassword.ClientID%>').attr("disabled", "disabled");

                                    ErrMsg.text('Your Reset Password Link has been expired');
                                    ErrMsg.css("display", "block");

                                },
                                error: function (response) {
                                    alert('Unable to Update Reset Password');
                                }
                            });
                        },
                        error: function (response) {
                            alert('Unable to Get Registered EmailID');
                        }
                    });
                }
            },
            error: function (response) {
                alert('Unable to Check Expiry Date');
            }
        });
    }

    function updateNewPassword()
    {
        var EncryptedEmailID = $('#<%=hfEncryptedEmailID.ClientID%>').val().trim();

        $.ajax({
            type: "POST",
            url: "ChangePassword.aspx/GetRegisteredEmailID",
            data: '{ EncryptedEmailID: "' + EncryptedEmailID + '"}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (result) {
                var RegisteredEmailID = result.d;
                var NewPassword = $( "#<%=txtNewPassword.ClientID%>" ).val().trim();

                $.ajax( {
                    type: "POST",
                    url: "ChangePassword.aspx/UpdateUserPassword",
                    data: '{ RegisteredEmailID: "' + RegisteredEmailID + '", NewPassword: "' + NewPassword + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function ( result )
                    {
                        $('#pMsg').text('Password reset successfully');
                        $('#ResetPassword-bx').modal('show');
                    },
                    error: function ( response )
                    {
                        alert( 'Unable to Update User Password' );
                    }
                } );
            },
            error: function (response) {
                alert('Unable to Get Registered EmailID');
            }
        });

        return false;
    }

    function updateUserPassword()
    {
        if ( checkBlankTextBoxes() )
        {
            updateNewPassword();
        }

        return false;
    }
</script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                        <div class="col-md-6">
<%--                            <label>Registered Email:</label>--%>
                        </div>
                        <div class="col-md-6">
<%--                            <asp:TextBox ID="txtRegisteredEmailID" runat="server"
                            onkeypress="clearErrMsg();" ReadOnly="true"></asp:TextBox>          --%>                                 
                            <asp:HiddenField ID="hfEncryptedEmailID" runat="server" />          
                            <asp:HiddenField ID="hfPasswordChangeDate" runat="server" />          
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>New Password: </label>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtNewPassword" runat="server" MaxLength="14"
                            onkeypress="clearErrMsg();" TextMode="Password"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>Confirm Password: </label>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" MaxLength="14"
                            onkeypress="clearErrMsg();" TextMode="Password"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6"></div>
                        <div class="col-md-6">
                            <asp:Button ID="btnSavePassword" runat="server" Text="Reset"
                                OnClientClick="return updateUserPassword();" />
                            <asp:Button ID="btnCancelPassword" runat="server" Text="Cancel"
                                OnClientClick="return clearAllTextBoxes();" />
                        </div>
                    </div>
                </div>
            </div>        
       </div>
   </div>
</div>

<div class="col-md-7">
    <div class="row">
        <div class="mapBGholder" style="background:#293038 url(/images/map.png) no-repeat center center; height:100vh;">
            <div class="infographHldr" align="center">
                <img src="/images/infographic.png" alt="" class="img-responsive"/>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="ResetPassword-bx" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header" style="background-color: #f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title" style="font-size: 24px; color: #111;">Reset Password</h4>
            </div>
            <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                <p id="pMsg"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-warning" data-dismiss="modal" 
                    onclick="location.href = '/Login.aspx'">OK</button>
            </div>
        </div>

    </div>
</div>

</asp:Content>

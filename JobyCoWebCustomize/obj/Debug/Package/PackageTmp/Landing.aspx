<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithMenuBar.Master" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="JobyCoWebCustomize.Landing" %>
<%@ MasterType VirtualPath="~/JobyCoWithMenuBar.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script src="/Scripts/jquery-ui.min.js"></script>
<script>
         function checkBlankTextBox() {
            var vEmailID = $("#<%=txtEmailID.ClientID%>");

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

            return true;
        }

        function showToggleDashboardDiv() {

            if (checkBlankTextBox()) {
                var EmailID = $( "#<%=txtEmailID.ClientID%>" ).val().trim();
                checkEmailIdFromUsers( EmailID );
            }

            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            //vErrMsg.hide(1000).delay(1000).fadeOut(1000);
        }
</script>
<script>
    function checkEmailIdFromUsers( EmailID )
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Landing.aspx/CheckEmailIdFromUsers",
            data: "{ EmailID: '" + EmailID + "'}",
            dataType: "json",
            success: function ( result )
            {
                $( '#<%=hfCheckEmailIdFromUsers.ClientID%>' ).val( result.d );

                var vFound = $( '#<%=hfCheckEmailIdFromUsers.ClientID%>' ).val().trim();
                //alert(vFound)

                if ( vFound == "EmailID exists" )
                {
                    $('#emailExists-bx').modal('show');
                    <%--$('#Login_email').val($("#<%=txtEmailID.ClientID%>").val().trim());
                    //$( '#emailExists-bx' ).modal( 'show' ); 
                    $('#divTrackMyPaecel').css('display', 'block');
                    $( "#secSignup" ).hide( 'slide', { direction: 'left' }, 800 );
                    $( "#dvDashboard" ).show( 'slide', { direction: 'right' }, 800 );
                    //$( "#dvQuote" ).show( 'slide', { direction: 'right' }, 800 );--%>
                    
                    $('#HiddenCheckedEmail').val($("#<%=txtEmailID.ClientID%>").val().trim());
                    $('#<%=((TextBox)Master.FindControl("txtConfirmEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    $('#<%=((TextBox)Master.FindControl("txtPickupEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    //$('#<%=((TextBox)Master.FindControl("txtDeliveryEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                

                    $('#<%=((TextBox)Master.FindControl("txtConfirmEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    $('#<%=((TextBox)Master.FindControl("txtPickupEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    //$('#<%=((TextBox)Master.FindControl("txtDeliveryEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                }
                else if (vFound == "CustomerID exists")
                {
                    $('#Reg_email').val($("#<%=txtEmailID.ClientID%>").val().trim());
                    $('#divTrackMyPaecel').css('display', 'block');
                    $( "#secSignup" ).hide( 'slide', { direction: 'left' }, 800 );
                    $( "#dvDashboard" ).show( 'slide', { direction: 'right' }, 800 );
                    //$( "#dvQuote" ).show( 'slide', { direction: 'right' }, 800 );

                    $('#<%=((TextBox)Master.FindControl("txtConfirmEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    $('#<%=((TextBox)Master.FindControl("txtPickupEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    //$('#<%=((TextBox)Master.FindControl("txtDeliveryEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                

                    $('#<%=((TextBox)Master.FindControl("txtConfirmEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    $('#<%=((TextBox)Master.FindControl("txtPickupEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    //$('#<%=((TextBox)Master.FindControl("txtDeliveryEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                }
                else
                {
                    $('#Reg_email').val($("#<%=txtEmailID.ClientID%>").val().trim());
                    //$('#divTrackMyPaecel').css('display', 'none');
                    $( "#secSignup" ).hide( 'slide', { direction: 'left' }, 800 );
                    //$( "#dvDashboard" ).show( 'slide', { direction: 'right' }, 800 );
                    //$( "#dvQuote" ).show( 'slide', { direction: 'right' }, 800 );
                    $("#dvLoggedQuote").show('slide', { direction: 'right' }, 800);

                    $('#<%=((TextBox)Master.FindControl("txtConfirmEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    $('#<%=((TextBox)Master.FindControl("txtPickupEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    //$('#<%=((TextBox)Master.FindControl("txtDeliveryEmailAddress_Q")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                

                    $('#<%=((TextBox)Master.FindControl("txtConfirmEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    $('#<%=((TextBox)Master.FindControl("txtPickupEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                
                    //$('#<%=((TextBox)Master.FindControl("txtDeliveryEmailAddress")).ClientID %>').val($("#<%=txtEmailID.ClientID%>").val().trim());                

                    //var vIndex = vEmailID.indexOf("@");
                    //var vLoggedInUser = vEmailID.substr(0, vIndex);
                }
            },
            error: function ( response )
            {

            }
        } );
    }
</script>
<script>
    $(document).ready(function () {

        $("#<%=txtEmailID.ClientID%>").on('change keyup paste', function() {
            $('#btnFreeSignUp').removeAttr('disabled');
			clearErrorMessage();
        });

        if($("#<%=txtEmailID.ClientID%>").val().trim() == "")
            $("#btnFreeSignUp").attr("disabled", "disabled");

    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="hmForm" id="dvSignup">
        <div class="formContent">
        <asp:HiddenField ID="hfCheckEmailIdFromUsers" runat="server" />
        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" ForeColor="Red"
            style="text-align:center; vertical-align: middle; line-height: 30px; 
            border-radius: 0px; padding: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>
            <h4>Book Pickup and Delivery</h4>
            <div class="indexSign">
                    <asp:TextBox ID="txtEmailID" CssClass="form-control" 
                        PlaceHolder="Please enter your Email" title="Please enter your Email"
                        MaxLength="255" onkeypress="clearErrorMessage();" runat="server"
                        style="text-transform: lowercase;"></asp:TextBox><br />
                    <button id="btnFreeSignUp" class="inSGNbtn"
                        onclick="return showToggleDashboardDiv();">Book Now</button>
            </div>
        </div>
    </div>
    <div class="modal fade" id="emailExists-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111; text-align:center;">You are an existing user</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px;">
                    <p>Please login</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="EmailExistClickOK();">OK</button>
                </div>
            </div>

        </div>
    </div>
    <script>
        function EmailExistClickOK() {
            location.href = "/Login.aspx?Email=" + $("#<%=txtEmailID.ClientID%>").val().trim();
        }
    </script>
</asp:Content>

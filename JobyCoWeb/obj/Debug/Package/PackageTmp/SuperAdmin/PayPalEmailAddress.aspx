<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithoutMenuBar.Master" AutoEventWireup="true" CodeBehind="PayPalEmailAddress.aspx.cs" Inherits="JobyCoWeb.PayPalEmailAddress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        function checkEmailAddress() {
            var PayPalEmailAddress = $("#<%=txtPayPalEmailAddress.ClientID%>");
            var vPayPalEmailAddress = PayPalEmailAddress.val().trim();

            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
            ErrMsg.css("background-color", "#ffd3d9");
            ErrMsg.css("color", "red");

            if (vPayPalEmailAddress == "") {
                ErrMsg.text('Enter Your Email ID');
                ErrMsg.css("display", "block");
                PayPalEmailAddress.focus();
                return false;
            }
            
            if (!IsEmail(vPayPalEmailAddress)) {
                ErrMsg.text('Invalid Email Address');
                ErrMsg.css("display", "block");
                PayPalEmailAddress.focus();
                return false;
            }

            return true;
        }

        function clearErrorMessage() {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
        }

        function updatePayPalEmailAddress() {
            var PayPalEmailAddress = $("#<%=txtPayPalEmailAddress.ClientID%>").val().trim();

            if (checkEmailAddress()) {

                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "PayPalEmailAddress.aspx/UpdatePayPalEmailAddress",
                    data: "{ PayPalEmailAddress: '" + PayPalEmailAddress + "'}",
                    success: function (result) {
                        $.alert({
                            title: 'Success...',
                            content:    'PayPalEmailAddress updated in web.config'
                        });
                    },
                    error: function (response) {
                        alert('Unable to Update PayPalEmailAddress');
                    }
                });
            }

            return false;
        }

        function gotoDashboard() {
            location.href = "/Dashboard.aspx";
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="division-bx">
    <h2>PayPal Email Address</h2>
    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

    <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
        style="text-align:center; vertical-align: middle; line-height: 30px; 
        border-radius: 0px; padding: 0px;" runat="server" Text="" Font-Size="Small"></asp:Label>

    <div class="row">
      <div class="col-md-12">
            <div class="col-md-6">
                    <asp:TextBox ID="txtPayPalEmailAddress" 
                        placeholder="PayPal Email Address" 
                        onkeypress="clearErrorMessage();"
                        runat="server"></asp:TextBox>                   
            </div>
            <div class="col-md-6">
                    <asp:Button ID="btnUpdatePayPalEmailAddress" runat="server" 
                        Text="Update PayPal Email Address" 
                        OnClientClick="return updatePayPalEmailAddress();" />
            </div>
      </div>
    </div>
    <div class="row">
        <div class="col-md-12 txt_cnct">
            <a href="/Dashboard.aspx" id="paymentBKD">Back to Dashboard</a>
        </div>
        <div class="col-md-6 col-md-pull-6">

        </div>
    </div>
</div>
</asp:Content>

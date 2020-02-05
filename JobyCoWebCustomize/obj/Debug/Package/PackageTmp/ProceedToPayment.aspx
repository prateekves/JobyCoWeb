<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithoutMenuBar.Master" AutoEventWireup="true" CodeBehind="ProceedToPayment.aspx.cs" Inherits="JobyCoWebCustomize.ProceedToPayment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://www.paypalobjects.com/api/checkout.js"></script>

    <script>
        $(document).ready(function () {
            // Change the country selection for Collection Mobile    
            $("#<%=txtPayPalContactNo.ClientID%>").intlTelInput("setCountry", "gb");
        });
    </script>

    <script>
        function hidePayPalMandatoryFields() {
            $("#<%=txtPayPalName.ClientID%>").removeClass('manField');
            $("#<%=txtPayPalEmailId.ClientID%>").removeClass('manField');
            $("#<%=txtPayPalContactNo.ClientID%>").removeClass('manField');
            $("#<%=txtPayPalItemInfo.ClientID%>").removeClass('manField');
            $("#<%=txtPayPalQuantity.ClientID%>").removeClass('manField');
            $("#<%=txtPayPalAmount.ClientID%>").removeClass('manField');
            $("#<%=ddlPayPalCurrency.ClientID%>").removeClass('manField');
        }

        function showPayPalMandatoryFields() {
            var PayPalName = $("#<%=txtPayPalName.ClientID%>");
            if (PayPalName.val().trim() == "") {
                PayPalName.addClass('manField');
            }

            var PayPalEmailId = $("#<%=txtPayPalEmailId.ClientID%>");
            if (PayPalEmailId.val().trim() == "") {
                PayPalEmailId.addClass('manField');
            }

            var PayPalContactNo = $("#<%=txtPayPalContactNo.ClientID%>");
            if (PayPalContactNo.val().trim() == "") {
                PayPalContactNo.addClass('manField');
            }

            var PayPalItemInfo = $("#<%=txtPayPalItemInfo.ClientID%>");
            if (PayPalItemInfo.val().trim() == "") {
                PayPalItemInfo.addClass('manField');
            }

            var PayPalQuantity = $("#<%=txtPayPalQuantity.ClientID%>");
            if (PayPalQuantity.val().trim() == "") {
                PayPalQuantity.addClass('manField');
            }

            var PayPalAmount = $("#<%=txtPayPalAmount.ClientID%>");
            if (PayPalAmount.val().trim() == "") {
                PayPalAmount.addClass('manField');
            }

            var PayPalCurrency = $("#<%=ddlPayPalCurrency.ClientID%>");
            if (PayPalCurrency.find("option:selected").text().trim() == "Select Currency") {
                PayPalCurrency.addClass('manField');
            }
        }

        function clearErrorMessage() {
            var vErrMsg5 = $("#<%=lblErrMsg5.ClientID%>");
            vErrMsg5.text('');
            vErrMsg5.css("display", "none");
            //vErrMsg5.hide(1000).delay(1000).fadeOut(1000);
            hidePayPalMandatoryFields();
        }

        function checkPayPalDetails() {
            var PayPalName = $("#<%=txtPayPalName.ClientID%>");
            var vPayPalName = PayPalName.val().trim();

            var PayPalEmailId = $("#<%=txtPayPalEmailId.ClientID%>");
            var vPayPalEmailId = PayPalEmailId.val().trim();

            var PayPalContactNo = $("#<%=txtPayPalContactNo.ClientID%>");
            var vPayPalContactNo = PayPalContactNo.val().trim();

            var PayPalItemInfo = $("#<%=txtPayPalItemInfo.ClientID%>");
            var vPayPalItemInfo = PayPalItemInfo.val().trim();

            var PayPalQuantity = $("#<%=txtPayPalQuantity.ClientID%>");
            var vPayPalQuantity = PayPalQuantity.val().trim();

            var PayPalAmount = $("#<%=txtPayPalAmount.ClientID%>");
            var vPayPalAmount = PayPalAmount.val().trim();

            var PayPalCurrency = $("#<%=ddlPayPalCurrency.ClientID%>");
            var vPayPalCurrency = PayPalCurrency.val().trim();

            var vErrMsg = $("#<%=lblErrMsg5.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#f9edef");
            vErrMsg.css("color", "red");

            showPayPalMandatoryFields();

            if (vPayPalName == "") {
                vErrMsg.text('Enter Your Name for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalName.focus();
                return false;
            }

            if (vPayPalEmailId == "") {
                vErrMsg.text('Enter Your Email Id for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalEmailId.focus();
                return false;
            }

            if (!IsEmail(vPayPalEmailId)) {
                vErrMsg.text('Invalid Email Id for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalEmailId.focus();
                return false;
            }

            if (vPayPalContactNo == "") {
                vErrMsg.text('Enter Your Contact No for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalContactNo.focus();
                return false;
            }

            if (vPayPalContactNo.length < 10) {
                vErrMsg.text('Invalid Contact No for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalContactNo.focus();
                return false;
            }

            if (vPayPalItemInfo == "") {
                vErrMsg.text('Enter Your Item Info for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalItemInfo.focus();
                return false;
            }

            if (vPayPalQuantity == "") {
                vErrMsg.text('Enter Your Quantity for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalQuantity.focus();
                return false;
            }

            if (vPayPalAmount == "") {
                vErrMsg.text('Enter Your Amount for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalAmount.focus();
                return false;
            }

            if (vPayPalCurrency == "Select Currency") {
                vErrMsg.text('Please select a Currency for PayPal');
                vErrMsg.css("display", "block");
                //vErrMsg.show(1000).delay(1000).fadeOut(1000);
                PayPalCurrency.focus();
                return false;
            }

            //return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="paymentMNdiv" style="background-color: white; background-size:cover; height:100vh; width:100%;">
        <div class="">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-xs-12 col-md-offset-3">
                        <div class="bgpayment">
                            <h2>PayPal Payment Details</h2>
                            <asp:Label ID="lblErrMsg5" CssClass="ErrMsg" BackColor="#f9edef"
                            Style="text-align: center; vertical-align: middle; width: 500px; line-height: 30px; border-radius: 0px; padding: 0px;"
                            runat="server" Text="" Font-Size="Small"></asp:Label>
                            <div class="address-details"><br />
                                <div class="payMent-box">
                                    <div class="details">
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label" for="collection-title">Name <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:TextBox ID="txtPayPalName" runat="server" MaxLength="50"
                                                        CssClass="form-control"  PlaceHolder="e.g. Tom" title="Please enter PayPal Name"
                                                        onkeypress="CharacterOnly(event);clearErrorMessage();" ReadOnly="true"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label" for="collection-town" data-label-prepend="Collection: ">Email Id <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:TextBox ID="txtPayPalEmailId" runat="server"
                                                        CssClass="form-control"  PlaceHolder="e.g. example@gmail.com"
                                                        title="Please enter PayPal Email Id" MaxLength="100" ReadOnly="true"
                                                        onkeypress="clearErrorMessage();"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Contact No <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <div class="input-group payFlag" data-trigger="focus" data-toggle="popover" data-placement="top" title="" data-original-title="Telephone number without leading 0, eg: 1234 567 890">
                                                        <asp:TextBox ID="txtPayPalContactNo" runat="server"
                                                            CssClass="flag-tel"  PlaceHolder="e.g. 87123 123456"
                                                            title="Please enter PayPal Contact Number" TextMode="Phone" ReadOnly="true"
                                                            MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();" style="width:100%;"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Item Info <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:TextBox ID="txtPayPalItemInfo" runat="server"
                                                        CssClass="form-control"  PlaceHolder="e.g. Bicycles, Boxes"
                                                        title="Please enter PayPal Item Info" ReadOnly="true"
                                                        MaxLength="20" onkeypress="clearErrorMessage();"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Quantity <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:TextBox ID="txtPayPalQuantity" runat="server"
                                                        CssClass="form-control"  PlaceHolder="e.g. 12"
                                                        title="Please enter PayPal Quantity" ReadOnly="true"
                                                        MaxLength="20" onkeypress="NumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Amount <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:TextBox ID="txtPayPalAmount" runat="server"
                                                        CssClass="form-control"  PlaceHolder="e.g. 87123.12"
                                                        title="Please enter PayPal Amount" ReadOnly="true"
                                                        MaxLength="20" onkeypress="DecimalOnly(event);clearErrorMessage();"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12">
                                                    <label class="control-label mobile-label" for="collection-mobile" data-label-prepend="Collection: ">Currency <span style="color: red">*</span>:</label>
                                                </div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:DropDownList ID="ddlPayPalCurrency" runat="server" CssClass="form-control"
                                                        PlaceHolder="e.g. INR/USD/EURO/GBP" title="Please select PayPal Currency"
                                                        onkeypress="clearErrorMessage();" Enabled="false">
                                                        <asp:ListItem>Select Currency</asp:ListItem>
                                                        <asp:ListItem Selected="True">GBP</asp:ListItem>
                                                        <asp:ListItem>USD</asp:ListItem>
                                                        <asp:ListItem>EURO</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-md-3 col-xs-12"></div>
                                                <div class="col-md-9 col-xs-12">
                                                    <asp:Button ID="btnPayNow" runat="server" Text="Pay Now" CssClass="action-button"
                                                    OnClientClick="return checkPayPalDetails();" OnClick="btnPayNow_Click" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--end of PayPal filed-->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithoutMenuBar.Master" AutoEventWireup="true" CodeBehind="PaymentSuccess.aspx.cs" Inherits="JobyCoWeb.PaymentSuccess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="hmForm" id="dvSignup">
        <div class="division-bx">
            <h1>Your Payment is successful</h1>
            <h2>Thank you for your Payment</h2>
            <%--<button class="btn-success" onclick="location.href='/Dashboard.aspx'">Back to Dashboard</button>--%>
            <a href="/Booking/ViewAllBookings.aspx" id="paymentBKD">Back to All Bookings</a>
        </div>
    </div>
</asp:Content>

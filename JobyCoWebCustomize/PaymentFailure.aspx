<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoWithoutMenuBar.Master" AutoEventWireup="true" CodeBehind="PaymentFailure.aspx.cs" Inherits="JobyCoWebCustomize.PaymentFailure" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="division-bx">
    <h1>Sorry, Your Payment Failed</h1>
    <h2>Please try again</h2>
    <asp:LinkButton ID="paymentBKD" runat="server">Back to Booking</asp:LinkButton>
    <%--<button class="btn-danger" onclick="location.href='/Dashboard.aspx';">Back to Dashboard</button>--%>
    <%--<a href="/Dashboard.aspx" id="paymentBKD">Back to Dashboard</a>--%>

</div>
</asp:Content>

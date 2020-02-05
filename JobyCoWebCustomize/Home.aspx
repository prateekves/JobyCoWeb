<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCo.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="JobyCoWebCustomize.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .MiddleDiv {
            width: 30%;
            margin-left: auto;
            margin-right: auto;
            border: 1px solid black;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-xs-12 col-md-4 quote-block">
        <div class="column-block">
            <%--<a class="btn btn-success" href="/Quote.aspx"> Get a Quote</a>--%>
            <a class="btn btn-primary" href="/Quote.aspx"> Create a Booking</a>
            <a class="btn btn-warning" href="/Track.aspx"> Where is my parcel?</a>
        </div>
    </div>
</asp:Content>

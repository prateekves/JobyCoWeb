<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="DashboardNew.aspx.cs" Inherits="JobyCoWeb.DashboardNew" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="msDB" runat="server">
        <div class="welcome-message">
            <h2>Choose Your Option</h2>
        </div>
        <p>Welcome To Jobyco, Leaders in Parcel Delivery And Courier Services. With Jobyco, you can be assured of a company with a good track record and a long and extensive history in Door to Door shipping from the UK to Ghana</p>
        <ul class="list extended">
            <li class="list__item" style="display: none;">
                <input class="radio-btn" name="choise" id="b-opt" type="radio" onclick="location.href = '/Booking/AddQuoting.aspx'; $(this).removeAttr('checked');" />
                <label for="b-opt" class="label">
                    <figure>
                        <img src="/images/bkQuotation.png" alt="" class="img-responsive" />
                    </figure>
                    <br />
                    <div class="listItem_label">
                       <span class="labelHdng">Request A Quote</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p> 
                    </div>
                    
                </label>
            </li>
            <li class="list__item">
                <input class="radio-btn" name="choise" id="a-opt" type="radio" onclick="location.href = '/Booking/AddBooking.aspx'; $(this).removeAttr('checked');" />
                <label for="a-opt" class="label">
                    <figure>
                        <img src="/images/bookPick.png" alt="" class="img-responsive" />
                    </figure>
                    <br />
                    <div class="listItem_label">
                       <span class="labelHdng">Make a Booking</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p> 
                    </div>
                    
                </label>
            </li>
            <li class="list__item">
                <input class="radio-btn" name="choise" id="d-opt" type="radio" />
                <label for="d-opt" class="label">
                    <figure>
                        <img src="/images/tarckPar.png" alt="" class="img-responsive" />
                    </figure>
                    <br />
                    <div class="listItem_label">
                        <span class="labelHdng">Track My Parcel</span>
                        <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    </div>
                </label>
            </li>

        </ul>
    </form>

</asp:Content>

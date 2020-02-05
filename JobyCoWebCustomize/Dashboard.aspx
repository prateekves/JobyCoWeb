<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JobyCoWebCustomize.Dashboard" %>

<%@ MasterType VirtualPath="~/LoggedJobyCo.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            $(".radio-btn").removeAttr("checked");
        });
    </script>
    <script>
        function goNext() {
            var GetQuote = $("#q-opt");
            var BookPickup = $("#b-opt");
            var BookDelivery = $("#c-opt");
            var TrackParcel = $("#d-opt");

            if (GetQuote.is(":checked")) {
                location.href = "/Quote.aspx";
            }

            if (BookPickup.is(":checked")) {
                location.href = "/LoggedQuote.aspx";
            }

            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="col-md-12">
        <form id="msDB" runat="server">

        <h2>Choose Your Option</h2>
        <p>Welcome To Jobyco, Leaders in Parcel Delivery And Courier Services. With Jobyco, you can be assured of a company with a good track record and a long and extensive history in Door to Door shipping from the UK to Ghana</p>
        <ul class="list">
            <li class="list__item" style="display: none;">
                <input class="radio-btn" name="choise" id="q-opt" type="radio" onclick="location.href = '/Quote.aspx';"/>
                <label for="q-opt" class="label">
                    <figure>
                        <img src="/images/bkQuotation.png" alt="" class="img-responsive"/>
					</figure>
                    <br/>
                    <span class="labelHdng">Request A Quote</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
				</label>
            </li>
            <li class="list__item">
                <input class="radio-btn" name="choise" id="b-opt" type="radio" onclick="location.href = '/LoggedQuote.aspx';"/>
                <label for="b-opt" class="label">
                    <figure>
                        <img src="/images/bookPick.png" alt="" class="img-responsive"/>
					</figure>
                    <br/>
                    <div class="listItem_label">
                        <span class="labelHdng">Make a Booking</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    </div>
                    
				</label>
            </li>
            <li class="list__item">
                <input class="radio-btn" name="choise" id="d-opt" type="radio" onclick="location.href = '/Tracking.aspx';"/>
                <label for="d-opt" class="label">
                    <figure>
                        <img src="/images/tarckPar.png" alt="" class="img-responsive"/>
					</figure>
                    <br/>
                    <div class="listItem_label">
                        <span class="labelHdng">Track My Parcel</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    </div>
                    
				</label>
            </li>
            <!--<li class="list__item">
                <input class="radio-btn" name="choise" id="a-opt" type="radio" onclick="window.open('https://enimarkets.com/'); $(this).removeAttr('checked');" />
                <label for="a-opt" class="label">
                    <figure>
                        <img src="/images/marketPlace.jpg" alt="" class="img-responsive"/>
			        </figure>
                    <br/>
                <div class="listItem_label">
                        <span class="labelHdng">Market Place</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    </div>
                    
		        </label>
            </li>-->
        </ul>
        <!--<a href="#" class="nextBtn" runat="server" onclick="return goNext();">Go Next</a>-->
      </form>
    </div>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCo.Master" AutoEventWireup="true" CodeBehind="TestPageWithMaster.aspx.cs" Inherits="JobyCoWebCustomize.TestPageWithMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=places"></script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=places"></script>
<script type="text/javascript">
        google.maps.event.addDomListener(window, 'load', function () {
            var places = new google.maps.places.Autocomplete(document.getElementById('<%=FromTxtBx.ClientID%>'));
            google.maps.event.addListener(places, 'place_changed', function () {
                var place = places.getPlace();
                var address = place.formatted_address;
                var latitude = place.geometry.location.lat();
                var longitude = place.geometry.location.lng();
                var mesg = "Address: " + address;
                mesg += "\nLatitude: " + latitude;
                mesg += "\nLongitude: " + longitude;
                alert(mesg);
            });
        });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="frmTest" runat="server">
        <div class="row">
            <br /><br /><br /><br />
      
            <div class="input-field col s12 m4 l5">
                <label for="last_name">FROM</label>
                <asp:TextBox runat="server" id="FromTxtBx" class="validate" ClientIDMode="Static"></asp:TextBox>
                <asp:HiddenField runat="server" ID="FromPred" />
            </div>
     
            <div class="input-field col s12 m4 15">
                <label for="ToTxtBx">TO</label>   
                    <asp:TextBox runat="server" ID="ToTxtBx"></asp:TextBox>
            </div>
        </div>

        <br/>
        
        <div class="row">
            <div class="col s6 offset-s4">
                <asp:Button runat="server" class="waves-effect waves-light btn" ID="HomeSearch" Text="SEARCH NOW" />
                <i class="material-icons right">Send</i>
            </div>
        </div>
    </form>
    <script src="/js/bootstrap.js"></script>
</asp:Content>

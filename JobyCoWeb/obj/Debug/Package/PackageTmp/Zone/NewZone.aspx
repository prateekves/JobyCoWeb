<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="NewZone.aspx.cs" Inherits="JobyCoWeb.Zone.NewZone"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

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
        function checkBlankControls() {
            var vZoneId = $("#<%=txtZoneId.ClientID%>");
            var vZoneName = $("#<%=txtZoneName.ClientID%>");

            var vZoneLocation = $("#<%=ddlZoneLocation.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //if (vZoneId.val().trim() == "") {
            //    vErrMsg.text('Enter Zone Id');
            //    vErrMsg.css("display", "block");
            //    vZoneId.focus();
            //    return false;
            //}

            if (vZoneName.val().trim() == "") {
                vErrMsg.text('Enter Zone Name');
                vErrMsg.css("display", "block");
                vZoneName.focus();
                return false;
            }

            if (vZoneLocation.val().trim() == "Select Zone Location") {
                vErrMsg.text('Please select a Zone Location from dropdown');
                vErrMsg.css("display", "block");
                vZoneLocation.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vZoneId = $("#<%=txtZoneId.ClientID%>");
            var vZoneName = $("#<%=txtZoneName.ClientID%>");
            var vZoneLocation = $("#<%=ddlZoneLocation.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //vZoneId.val('');
            vZoneName.val('');
            vZoneLocation.val('Select Zone Location');

            location.href = "/Zone/ViewAllZones.aspx";
            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }
</script>

<script>
    $( document ).ready( function ()
    {
        getLatestZoneId();
        getAllLocations();
    } );
</script>

<script>
    function getLatestZoneId()
    {
        $.ajax( {
            type: "POST",
            url: "NewZone.aspx/GetLatestZoneId",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function ( result )
            {
                $( '#<%=txtZoneId.ClientID%>').val( result.d );
            },
            error: function ( response )
            {
            }
        } );
    }

    function getAllLocations()
    {
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewZone.aspx/GetAllLocations",
            data: "{}",
            dataType: "json",
            success: function ( data )
            {
                $.each( data.d, function ()
                {
                    $( "#<%=ddlZoneLocation.ClientID%>" ).append( $( "<option></option>" ).val( this['Value'] ).html( this['Text'] ) );
                } )
            },
            error: function ( response )
            {
            }
        } );
    }

</script>

<script>
    function addZoneDetails()
    {
        var ZoneId = $( "#<%=txtZoneId.ClientID%>" ).val().trim();
        var ZoneName = $( "#<%=txtZoneName.ClientID%>" ).val().trim();
        var LocationId = $( "#<%=ddlZoneLocation.ClientID%>" ).find('option:selected').val().trim();
        
        var objZone = {};

        objZone.ZoneId = ZoneId;
        objZone.ZoneName = ZoneName;
        objZone.LocationId = LocationId;

        $.ajax( {
            type: "POST",
            url: "NewZone.aspx/AddZoneDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify( objZone ),
            dataType: "json",
            success: function ( result )
            {
                $( '#Zone-bx' ).modal( 'show' );                
            },
            error: function ( response )
            {
                alert( 'Zone Details Addition failed' );
            }
        } );

        return false;
    }

    function saveZone()
    {
        if ( checkBlankControls() )
        {
            addZoneDetails();
            setTimeout( function () { }, 3000 );
        }

        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    New Zone
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <form id="frmZone" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <asp:HiddenField ID="hfLocationId" runat="server" />
                        </div>
                        <div class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Zone Id</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtZoneId" runat="server"
                                                CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Zone Name</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtZoneName" runat="server" 
                                                CssClass="form-control m-b" PlaceHolder="e.g. Greater London" 
                                                MaxLength="32" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-4 control-label">Select Location</label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlZoneLocation" runat="server"
                                                CssClass="form-control m-b" title="Please select a Location from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Zone Location</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-12">
                                    <div class="row form-group margintop1">
                                        <div class="col-sm-12 text-center">
                                            <asp:Button ID="btnSaveZone" runat="server" Text="Save Zone"
                                                CssClass="btn btn-primary" OnClientClick="return saveZone();"
                                                />
                                            <asp:Button ID="btnCancelZone" runat="server" Text="Cancel" class="btn btn-default"
                                            OnClientClick="return clearAllControls();" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <hr/>
                            <footer>
                                <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                            </footer>    
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="Zone-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Zone</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Zone Details added successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" 
                        onclick="location.href='/Zone/ViewAllZones.aspx';">OK</button>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

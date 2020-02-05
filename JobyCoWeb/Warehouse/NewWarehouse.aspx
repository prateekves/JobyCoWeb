<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="NewWarehouse.aspx.cs" Inherits="JobyCoWeb.Warehouse.NewWarehouse"
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
            var vWarehouseId = $("#<%=txtWarehouseId.ClientID%>");
            var vWarehouseName = $("#<%=txtWarehouseName.ClientID%>");

            var vWarehouseLocation = $("#<%=ddlWarehouseLocation.ClientID%>");
            var vWarehouseZone = $("#<%=ddlWarehouseZone.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //if (vWarehouseId.val().trim() == "") {
            //    vErrMsg.text('Enter Warehouse Id');
            //    vErrMsg.css("display", "block");
            //    vWarehouseId.focus();
            //    return false;
            //}

            if (vWarehouseName.val().trim() == "") {
                vErrMsg.text('Enter Warehouse Name');
                vErrMsg.css("display", "block");
                vWarehouseName.focus();
                return false;
            }

            if (vWarehouseLocation.val().trim() == "Select Warehouse Location") {
                vErrMsg.text('Please select a Warehouse Location from dropdown');
                vErrMsg.css("display", "block");
                vWarehouseLocation.focus();
                return false;
            }

            if (vWarehouseZone.val().trim() == "Select Warehouse Zone") {
                vErrMsg.text('Please select a Warehouse Zone from dropdown');
                vErrMsg.css("display", "block");
                vWarehouseZone.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vWarehouseId = $("#<%=txtWarehouseId.ClientID%>");
            var vWarehouseName = $("#<%=txtWarehouseName.ClientID%>");

            var vWarehouseLocation = $("#<%=ddlWarehouseLocation.ClientID%>");
            var vWarehouseZone = $("#<%=ddlWarehouseZone.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //vWarehouseId.val('');
            vWarehouseName.val('');

            vWarehouseLocation.val('Select Warehouse Location');
            vWarehouseZone.val('Select Warehouse Zone');

            location.href = "/Warehouse/ViewAllWarehouses.aspx";
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
        getLatestWarehouseId();
        getAllLocations();
        //getAllZones();
    } );
</script>

<script>
    function getLatestWarehouseId()
    {
        $.ajax( {
            type: "POST",
            url: "NewWarehouse.aspx/GetLatestWarehouseId",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function ( result )
            {
                $( '#<%=txtWarehouseId.ClientID%>').val( result.d );
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
            url: "NewWarehouse.aspx/GetAllLocations",
            data: "{}",
            dataType: "json",
            success: function ( data )
            {
                $.each( data.d, function ()
                {
                    $( "#<%=ddlWarehouseLocation.ClientID%>" ).append( $( "<option></option>" ).val( this['Value'] ).html( this['Text'] ) );
                } )
            },
            error: function ( response )
            {
            }
        } );
    }

    function getAllZonesByLocation()
    {
        var WarehouseLocationId = $('#<%=ddlWarehouseLocation.ClientID%>').find('option:selected').val().trim();
        //alert(WarehouseLocationId);
        $.ajax( {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewWarehouse.aspx/GetAllZones",
            data: "{ WarehouseLocationId : '" + WarehouseLocationId + "'}",
            dataType: "json",
            success: function ( data )
            {
                $("#<%=ddlWarehouseZone.ClientID%>").html("");
                $("#<%=ddlWarehouseZone.ClientID%>").append($("<option></option>").val("Select Warehouse Zone").html("Select Warehouse Zone"));

                $.each( data.d, function ()
                {
                    $( "#<%=ddlWarehouseZone.ClientID%>" ).append( $( "<option></option>" ).val( this['Value'] ).html( this['Text'] ) );
                } )
            },
            error: function ( response )
            {
            }
        } );
    }

</script>

<script>
    function addWarehouseDetails()
    {
        var WarehouseId = $( "#<%=txtWarehouseId.ClientID%>" ).val().trim();
        var WarehouseName = $( "#<%=txtWarehouseName.ClientID%>" ).val().trim();
        var LocationName = $( "#<%=ddlWarehouseLocation.ClientID%>" ).find('option:selected').text().trim();
        var ZoneName = $( "#<%=ddlWarehouseZone.ClientID%>" ).find('option:selected').text().trim();
        
        var objWarehouse = {};

        objWarehouse.WarehouseId = WarehouseId;
        objWarehouse.WarehouseName = WarehouseName;
        objWarehouse.LocationName = LocationName;
        objWarehouse.ZoneName = ZoneName;

        $.ajax( {
            type: "POST",
            url: "NewWarehouse.aspx/AddWarehouseDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify( objWarehouse ),
            dataType: "json",
            success: function ( result )
            {
                $( '#Warehouse-bx' ).modal( 'show' );                
            },
            error: function ( response )
            {
                alert( 'Warehouse Details Addition failed' );
            }
        } );

        return false;
    }

    function saveWarehouse()
    {
        if ( checkBlankControls() )
        {
            addWarehouseDetails();
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
                    New Warehouse
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <form id="frmWarehouse" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                        </div>
                        <div class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">Warehouse Id</label>
                                        <div class="col-sm-7">
                                            <asp:TextBox ID="txtWarehouseId" runat="server"
                                                CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">Warehouse Name</label>
                                    <div class="col-sm-7">
                                        <asp:TextBox ID="txtWarehouseName" runat="server" 
                                            CssClass="form-control m-b" PlaceHolder="e.g. Centrumix.com.mx" 
                                            title="Please enter Warehouse Name"
                                                MaxLength="50" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                    </div>
                                </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">Warehouse Location</label>
                                        <div class="col-sm-7">
                                            <asp:DropDownList ID="ddlWarehouseLocation" runat="server"
                                                CssClass="form-control m-b" title="Please select a Warehouse Location from dropdown"
                                                onchange="clearErrorMessage(); getAllZonesByLocation();">
                                                <asp:ListItem>Select Warehouse Location</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">Warehouse Zone</label>
                                        <div class="col-sm-7">
                                            <asp:DropDownList ID="ddlWarehouseZone" runat="server"
                                                CssClass="form-control m-b" title="Please select a Warehouse Zone from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Warehouse Zone</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>
                           <div class="form-group">
                                <div class="col-sm-12 text-center">
                                    <asp:Button ID="btnSaveWarehouse" runat="server" Text="Save Warehouse"
                                        CssClass="btn btn-primary" OnClientClick="return saveWarehouse();"
                                        />
                                    <asp:Button ID="btnCancelWarehouse" runat="server" Text="Cancel" class="btn btn-default"
                                        OnClientClick="return clearAllControls();" />
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
    <div class="modal fade" id="Warehouse-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Warehouse</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Warehouse Details added successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" 
                        onclick="location.href='/Warehouse/ViewAllWarehouses.aspx';">OK</button>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

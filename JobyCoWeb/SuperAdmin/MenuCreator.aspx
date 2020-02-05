<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="MenuCreator.aspx.cs" Inherits="JobyCoWeb.MenuCreator" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>

<style>
    .no-bg { background: #B51013; }
    .yes-bg {background: #238A35;}

    .yes-bg, .no-bg{
        color: #fff;
        text-transform:uppercase;
        padding: 5px 0;
        width: 100%;
        display: block;
        text-align: center;
    }   
</style>

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
    $(document).ready(function () {
        //getAllMenuNames();
        getAllMenuDetails();

    });
</script>

<script>
        function checkBlankControls() {
            var MenuName = $("#<%=txtMenuName.ClientID%>");
            var vMenuName = MenuName.val().trim();

            var ParentMenuName = $("#<%=ddlParentMenuName.ClientID%>");
            var vParentMenuName = ParentMenuName.find('option:selected').text().trim();

            var PageName = $("#<%=txtPageName.ClientID%>");
            var vPageName = PageName.val().trim();

            var ActivateDeactivate = $("#<%=chkActivateDeactivate.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vMenuName == "") {
                vErrMsg.text('Enter Menu Name');
                vErrMsg.css("display", "block");
                MenuName.focus();
                return false;
            }

            if (vParentMenuName == "Select ParentMenuName") {
                vErrMsg.text('Choose a Parent Menu Name');
                vErrMsg.css("display", "block");
                ParentMenuName.focus();
                return false;
            }

            if (vPageName == "") {
                vErrMsg.text('Enter Page Name');
                vErrMsg.css("display", "block");
                PageName.focus();
                return false;
            }

            //if (!ActivateDeactivate.is(":checked")) {
            //    vErrMsg.text('It should be ticked on ');
            //    vErrMsg.css("display", "block");
            //    return false;
            //}

            return true;
        }

        function clearAllControls() {

            var MenuName = $("#<%=txtMenuName.ClientID%>");
            MenuName.val('');

            var ParentMenuName = $("#<%=ddlParentMenuName.ClientID%>");
            ParentMenuName.find('option:selected').text('Select ParentMenuName');

            var PageName = $("#<%=txtPageName.ClientID%>");
            PageName.val('');

            var ActivateDeactivate = $("#<%=chkActivateDeactivate.ClientID%>");

            if (ActivateDeactivate.is(":checked")) {
                ActivateDeactivate.removeAttr('checked');
                return false;
            }

            clearErrorMessage();

            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }

    function makeProperColor(vIsActive) {
        switch (vIsActive) {
            case false:
                vIsActive = "<span class='no-bg'>No</span>";
                break;

            case true:
                vIsActive = "<span class='yes-bg'>Yes</span>";
                break;
        }

        return vIsActive;
    }

    function changeMenuStatus(MenuId, vMenuStatus) {
        var Enabled = "false";

        switch (vMenuStatus) {
            case "Active":
                Enabled = "true";
                break;

            case "InActive":
                Enabled = "false";
                break;
        }

        //Binding the values with the Object
        var objMenu = {};
        objMenu.MenuId = MenuId;
        objMenu.Enabled = Enabled;

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "MenuCreator.aspx/ChangeMenuStatus",
            data: JSON.stringify(objMenu),
            success: function (result) {

                location.reload();
            },
            error: function (response) {
                alert('Unable to change Menu Status');
            }
        });

        return false;
    }

</script>

<script>
     function getParentMenuId(MenuName) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "MenuCreator.aspx/GetParentMenuId",
            data: "{MenuName: '" + MenuName + "'}",
            success: function (result) {
                $("#<%=hfParentMenuId.ClientID%>").val(result.d);
            },
            error: function (response) {
                alert('Unable to fetch Parent Menu Id');
            }
        });
    }

    function getAllMenuNames()
    {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "MenuCreator.aspx/GetAllMenuNames",
            data: "{}",
            dataType: "json",
            success: function (result) {
                $.each( result.d, function ( key, value )
                {
                    $( "#<%=ddlParentMenuName.ClientID%>" ).append( $( "<option></option>" ).val( value.ItemId ).html( value.ItemValue ) );
                } )
            },
            error: function (response) {
                alert('Unable to fetch All Menu Names');
            }
        });
    }
            
    function getAllMenuDetails()
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "MenuCreator.aspx/GetAllMenuDetails",
            success: function ( result )
            {
                var jsonMenuDetails = JSON.parse( result.d );
                $('#dtMenuDetails').DataTable({
                    data: jsonMenuDetails,
                    columns: [
                        { data: "Menu_ID" },
                        { data: "Menu_Name" },
                        //{ data: "Parent_ID" },
                        { data: "Parent_Name" },
                        {
                            data: "IsActive",
                            render: function (jsonIsActive) {
                                return makeProperColor(jsonIsActive);
                            }
                        }
                    ],
                    "bDestroy": true
                });
            },
            error: function ( response )
            {
                alert( 'Unable to Bind All Menu Details' );
            }
        } );//end of ajax

        $( '#dtMenuDetails tbody' ).on( 'click', '.yes-bg', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );
            var vMenuId = vClosestTr.children('td:first').text().trim();

            changeMenuStatus(vMenuId, 'InActive');

            return false;
        } );

        $( '#dtMenuDetails tbody' ).on( 'click', '.no-bg', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );
            var vMenuId = vClosestTr.children('td:first').text().trim();

            changeMenuStatus(vMenuId, 'Active');

            return false;
        } );

        return false;
    }

    function addMenuDetails() {
        //Saving Menu Details First
        var MenuName = $("#<%=txtMenuName.ClientID%>");
        var vMenuName = MenuName.val().trim();

        var ParentMenuName = $("#<%=ddlParentMenuName.ClientID%>");
        var vParentMenuName = ParentMenuName.find('option:selected').text().trim();

        var PageName = $("#<%=txtPageName.ClientID%>");
        var vPageName = PageName.val().trim();

        if (vPageName.indexOf(".aspx") == -1) {
            vPageName += ".aspx";
        }
        var vPagePath = "/" + vParentMenuName + "/" + vPageName;

        var ActivateDeactivate = $("#<%=chkActivateDeactivate.ClientID%>");
        var vActivateDeactivate = "";

        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#f9edef");
        vErrMsg.css("color", "red");

        if (ActivateDeactivate.is(":checked")) {
            vActivateDeactivate = "true";
        }
        else {
            vActivateDeactivate = "false";
        }

        //Binding Menu Details to object
        var objMenu = {};

        objMenu.Menu_Name = vMenuName;
        objMenu.Parent_ID = $("#<%=hfParentMenuId.ClientID%>").val().trim();
        objMenu.PagePath = vPagePath;
        objMenu.IsActive = vActivateDeactivate;

        $.ajax({
            type: "POST",
            url: "MenuCreator.aspx/AddMenuDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objMenu),
            dataType: "json",
            success: function (result) {
                $('#spMenuMessage').text(result.d);
                $('#Menu-bx').modal('show');
            },
            error: function (response) {
                alert('Unable to add Menu Details');
            }
        });

        return false;
    }

    function saveMenuDetails()
    {
        if ( checkBlankControls() )
        {
            addMenuDetails();
        }

        return false;
    }

    function refreshScreen() {
        location.reload();
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    Menu Creator
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="hpanel">
                    <form id="frmMenuDetails" runat="server">
                        <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                        <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <asp:HiddenField ID="hfParentMenuId" runat="server" />

                    <div class="panel-heading">
                    </div>
                    <div class="panel-body clrBLK dashboad-form">
                        <div class="row">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" style="text-align:center; width: 100%;" runat="server" Text="" Font-Size="Small"></asp:Label>                        
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Menu Name: <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtMenuName" 
                                            placeholder="Menu Name" 
                                            onkeypress="clearErrorMessage();"
                                            runat="server"></asp:TextBox>                   
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-4 control-label">Parent Menu: <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlParentMenuName" runat="server"
                                                CssClass="form-control m-b" title="Please select a Parent Menu Name from dropdown"
                                                onchange="clearErrorMessage();getParentMenuId(this.value);">
                                                <asp:ListItem>Select ParentMenuName</asp:ListItem>
                                            </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group"><label class="col-sm-4 control-label">Page Name: <span style="color: red">*</span></label>
                                    <div class="col-sm-8">
                                        <asp:TextBox ID="txtPageName" 
                                            placeholder="Page Name" 
                                            onkeypress="clearErrorMessage();restrictSpaceEntry(event, this.value);"
                                            runat="server"></asp:TextBox>                   
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="row form-group">
                                    <label class="col-sm-7 control-label">Activate / Deactivate Menu Item <span style="color: red">*</span></label>
                                    <div class="col-sm-5">
                                        <label class="age"><asp:CheckBox ID="chkActivateDeactivate" runat="server" onchange="clearErrorMessage();" />
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group">
                                <div class="col-sm-12 text-center">
                                    <asp:Button ID="btnSaveMenuDetails" runat="server" Text="Save Menu Details"
                                        CssClass="btn btn-primary btn-register" 
                                        OnClientClick="return saveMenuDetails();" />

                                    <asp:Button ID="btnCancelMenuDetails" runat="server" Text="Cancel" 
                                        CssClass="btn btn-default"
                                        OnClientClick="return clearAllControls();" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <table id="dtMenuDetails">
                            <thead>
                                <tr>
                                    <th>Menu ID</th>
                                    <th>Menu Name</th>
                                    <th>Parent Name</th>
                                    <th>Is Active</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-md-12">
                        <hr/>
                        <footer>
                            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                        </footer>    
                    </div>
                   </form>
                </div>
            </div>
        </div>
    </div>

  <div class="modal fade" id="Menu-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Menu Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spMenuMessage"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="refreshScreen();">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

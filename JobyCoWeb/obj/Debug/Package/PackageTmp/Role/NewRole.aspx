<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="NewRole.aspx.cs" Inherits="JobyCoWeb.Role.NewRole"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script>
         function checkBlankControls() {
            var vRoleId = $("#<%=txtRoleId.ClientID%>");
            var vRoleName = $("#<%=txtRoleName.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //if (vRoleId.val().trim() == "") {
            //    vErrMsg.text('Enter Role Id');
            //    vErrMsg.css("display", "block");
            //    vRoleId.focus();
            //    return false;
            //}

            if (vRoleName.val().trim() == "") {
                vErrMsg.text('Enter Role Name');
                vErrMsg.css("display", "block");
                vRoleName.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {
            var vRoleId = $("#<%=txtRoleId.ClientID%>");
            var vRoleName = $("#<%=txtRoleName.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            //vRoleId.val('');
            vRoleName.val('');

            location.href = "/Role/ViewAllRoles.aspx";
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
        getNewRoleId();
    } );
</script>
<script>
    function getNewRoleId() {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "NewRole.aspx/GetNewRoleId",
            data: "{}",
            success: function (result) {
                $("#<%=txtRoleId.ClientID%>").val(result.d);
            },
            error: function ( response )
            {
                alert( 'Unable to get New Role Id' );
            }
        });
    }

    function addRoleDetails()
    {
        var RoleId = $( "#<%=txtRoleId.ClientID%>" ).val().trim();
        var RoleName = $( "#<%=txtRoleName.ClientID%>" ).val().trim();
        
        //var objRole = {};

        //objRole.RoleId = RoleId;
        //objRole.RoleName = RoleName;

        //$.ajax( {
        //    type: "POST",
        //    url: "NewRole.aspx/AddRoleDetails",
        //    contentType: "application/json; charset=utf-8",
        //    data: JSON.stringify( objRole ),
        //    dataType: "json",
        //    success: function ( result )
        //    {
        //        $( '#Role-bx' ).modal( 'show' );                
        //    },
        //    error: function ( response )
        //    {
        //        alert( 'Role Details Addition failed' );
        //    }
        //} );

        $.ajax( {
            method: "POST",
            contentType: "application/json;charset=utf-8",
            url:    "NewRole.aspx/AddRoleDetails",
            data: "{ RoleId: '" + RoleId + "', RoleName: '" + RoleName + "'}",
            success: function ( result )
            {
                $( '#Role-bx' ).modal( 'show' );
            },
            error: function ( response )
            {
                alert( 'Role Details Addition failed' );
            }
        } );

        return false;
    }

    function saveRole()
    {
        if ( checkBlankControls() )
        {
            addRoleDetails();
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
                    New Role
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <form id="frmNewRole" runat="server">
                <div class="hpanel">
                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center; margin-left: 100px;" runat="server" Text="" Font-Size="Small"></asp:Label>
                    </div>
                    <div class="panel-body clrBLK col-md-10 dashboad-form" style="margin-left: 110px;">
                        <div class="form-group"><label class="col-sm-4 control-label">Role Id</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="txtRoleId" runat="server"
                                    CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                            </div>                        
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group"><label class="col-sm-4 control-label">Role Name</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="txtRoleName" runat="server" 
                                    CssClass="form-control m-b" PlaceHolder="e.g. Customer/Driver/Administrator" 
                                    title="Please enter Role Name"
                                        MaxLength="50" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group">
                            <div class="col-sm-4"></div>
                            <div class="col-sm-8">
                                <asp:Button ID="btnSaveRole" runat="server" Text="Save Role"
                                    CssClass="btn btn-primary" OnClientClick="return saveRole();"
                                    />
                                <asp:Button ID="btnCancelRole" runat="server" Text="Cancel" class="btn btn-default"
                                    OnClientClick="return clearAllControls();" />
                            </div>
                        </div>

                    </div>
                    <div class="col-md-10" style="margin-left: 110px;">
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

    <div class="modal fade" id="Role-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Role</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Role Details added successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" 
                        onclick="location.reload();">OK</button>
                </div>
            </div>

        </div>
    </div>

</asp:Content>

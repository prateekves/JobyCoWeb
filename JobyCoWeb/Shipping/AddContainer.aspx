<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="AddContainer.aspx.cs" Inherits="JobyCoWeb.Shipping.AddContainer" EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
    <link href="../css/custom.css" rel="stylesheet" />
    <script src="/js/jquery.blockUI.js"></script>
<!-- New Script Added for Dynamic Menu Population
================================================== -->    
<script>
    // unblock when ajax activity stops 
    //$(document).ajaxStop($.unblockUI);

    //function mainMenu() {
    //    $.ajax({
    //        url: 'Dashboard.aspx',
    //        cache: false
    //    });
    //}

    $(document).ready(function () {

        //$.blockUI({
        //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
        //    message: '<h4>Loading...</h4>',
        //    css: {
        //        border: 'none',
        //        //backgroundColor: 'transparent'
        //    }

        //});

        //mainMenu();

        var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
        accessibleMenuItems(hfMenusAccessibleValues);

        var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
        accessiblePageControls(hfControlsAccessible);
    });
</script>

    <script>
        $(document).ready(function () {
            var hfMenusAccessibleValues = $('#<%=hfMenusAccessible.ClientID%>').val().trim();
            accessibleMenuItems(hfMenusAccessibleValues);

            var hfControlsAccessible = $('#<%=hfControlsAccessible.ClientID%>').val().trim();
            accessiblePageControls(hfControlsAccessible);

            $("#divContainerType").click(function () {
                //Removing classes one by one
                $('#ContentPlaceHolder1_ddlContainerType_chosen').removeClass("chosen-container");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').removeClass("chosen-container-single-nosearch");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').removeClass("chosen-container-active");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').removeClass("chosen-with-drop");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').removeClass("chosen-container-single");
                //Adding classes one by one
                $('#ContentPlaceHolder1_ddlContainerType_chosen').addClass("chosen-container chosen-container-single chosen-container-active chosen-with-drop");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').addClass("chosen-container");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').addClass("chosen-container-single");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').addClass("chosen-container-active");
                $('#ContentPlaceHolder1_ddlContainerType_chosen').addClass("chosen-with-drop");
                //Removing readonly from the search box's textbox
                $("#ContentPlaceHolder1_ddlContainerType_chosen > .chosen-drop > .chosen-search > input[type=text]").removeAttr("readonly");
                //Condition for open close search box
                if ($("#<%=ddlContainerType.ClientID%>").find('option:selected').text().trim() == "Select ContainerType") {
                }
                else {
                    if ($("#ContentPlaceHolder1_ddlContainerType_chosen > .chosen-drop").is(":visible")) {
                        $('#ContentPlaceHolder1_ddlContainerType_chosen > .chosen-drop').css('display', 'none');
                    }
                    else {
                        $('#ContentPlaceHolder1_ddlContainerType_chosen > .chosen-drop').css('display', 'block');
                        //Focus textbox when the search box is opened
                        $("#ContentPlaceHolder1_ddlContainerType_chosen > .chosen-drop > .chosen-search > input[type=text]").focus();
                    }
                }
            });
        });
    </script>





    <script>

    $( document ).ready( function ()
    {
        $("#<%=ddlContainers.ClientID%>").val("").trigger("chosen:updated");
        initialisedControls();
        // restriction on space input
        $("#<%=txtContainerNumber.ClientID%>").on("keypress", function (e) {
            //alert('Press');
            if (e.which === 32)
                e.preventDefault();
        });

        //getAllContainerType();
      //Dropdown change of BookingID
        $('#<%=ddlContainers.ClientID%>').on('change', function () {
            if (this.value != 'Select Container') {
                getContainerInformationByContainerId(this.value);
            }
            else {
                initialisedControls();
            }
            
        });
    });

        function initialisedControls() {

            $("#<%=txtContainerNumber.ClientID%>").val("");
            $("#<%=ddlContainerType.ClientID%>").val("").trigger("chosen:updated");

            $("#<%=txtCompanyName.ClientID%>").val("");
            $("#<%=txtContainerAddress.ClientID%>").val("");
            $("#<%=txtContactPersonNo.ClientID%>").val("");
            $("#<%=txtFreightName.ClientID%>").val("");
        }

        function getContainerInformationByContainerId(ContainerId) {
            //alert(ContainerId);
            $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "AddContainer.aspx/GetAllContainerInfo",
                        data: "{ ContainerId : '" + ContainerId + "'}",
                        dataType: "json",
                        success: function (data) {
                            
                            var Jdata = JSON.parse(data.d);
                            //alert('1' + Jdata[0]["ContainerTypeId"]);
                            $("#<%=txtContainerNumber.ClientID%>").val(Jdata[0]["ContainerNumber"]);
                            $("#<%=ddlContainerType.ClientID%>").val(Jdata[0]["ContainerTypeId"]).trigger("chosen:updated");
                            $("#<%=txtCompanyName.ClientID%>").val(Jdata[0]["CompanyName"]);
                            $("#<%=txtContainerAddress.ClientID%>").val(Jdata[0]["ContainerAddress"]);
                            $("#<%=txtContactPersonNo.ClientID%>").val(Jdata[0]["ContactPersonNo"]);
                            $("#<%=txtFreightName.ClientID%>").val(Jdata[0]["FreightName"]);
                        },
                        error: function (response) {
                        }
                    });
        }


    function saveContainer() {
        if (checkBlankControls()) {
            addContainerDetails();
        }

        return false;
    }

        function getAllContainerType()
        {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "AddContainer.aspx/GetAllContainerType",
                        data: "{}",
                        dataType: "json",
                        success: function (data) {
                            $.each(data.d, function () {
                                $("#<%=ddlContainerType.ClientID%>").append($("<option></option>").val(this['Value']).html(this['Text']));
                            })
                        },
                        error: function (response) {
                        }
                    });
        }

    function checkBlankControls() {
        
        var vContainerNumber = $("#<%=txtContainerNumber.ClientID%>");
        var vContainerName = $("#<%=ddlContainerType.ClientID%>");
        var vCompanyName = $("#<%=txtCompanyName.ClientID%>");
        var vContainerAddress = $("#<%=txtContainerAddress.ClientID%>");
        var vContactPersonNo = $("#<%=txtContactPersonNo.ClientID%>");
        var vFreightName = $("#<%=txtFreightName.ClientID%>");
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");

        if (vContainerNumber.val().trim() == "") {
            vErrMsg.text('Enter Container Number');
            vErrMsg.css("display", "block");
            vContainerNumber.focus();
            return false;
        }

        if (vContainerName.val() == null || vContainerName.val().trim() == "Select Freight Type") {
            vErrMsg.text('Select Freight Type');
            vErrMsg.css("display", "block");
            vContainerName.focus();
            return false;
        }
        //if (vCompanyName.val().trim() == "") {
        //    vErrMsg.text('Enter Company Name');
        //    vErrMsg.css("display", "block");
        //    vCompanyName.focus();
        //    return false;
        //}
        //if (vContainerAddress.val().trim() == "") {
        //    vErrMsg.text('Enter Container Address');
        //    vErrMsg.css("display", "block");
        //    vContainerAddress.focus();
        //    return false;
        //}
        //if (vContactPersonNo.val().trim() == "") {
        //    vErrMsg.text('Enter Contact Person Number');
        //    vErrMsg.css("display", "block");
        //    vContactPersonNo.focus();
        //    return false;
        //}
        //if (vFreightName.val().trim() == "") {
        //    vErrMsg.text('Enter Freight Name');
        //    vErrMsg.css("display", "block");
        //    vFreightName.focus();
        //    return false;
        //}

        return true;
    }

        function addContainerDetails()
        {
            //$.blockUI({
            //    //message: '<h6><img src="/images/loadingImage.gif" /></h6>',
            //    message: '<h4>Loading...</h4>',
            //    css: {
            //        border: 'none',
            //        //backgroundColor: 'transparent'
            //    }
            //});

            //mainMenu();

            //alert('Add Container Function');
            

            var ContainerNumber = $("#<%=txtContainerNumber.ClientID%>").val().trim();
            var ContainerTypeId = $("#<%=ddlContainerType.ClientID%>").find('option:selected').val().trim();
            var CompanyName = $("#<%=txtCompanyName.ClientID%>").val().trim();
            var ContainerAddress = $("#<%=txtContainerAddress.ClientID%>").val().trim();
            var ContactPersonNo = $("#<%=txtContactPersonNo.ClientID%>").val().trim();
            var FreightName = $("#<%=txtFreightName.ClientID%>").val().trim();


            var objContainer = {};

            objContainer.ContainerNumber = ContainerNumber.toUpperCase();
            objContainer.ContainerTypeId = ContainerTypeId;
            objContainer.CompanyName = CompanyName;
            objContainer.ContainerAddress = ContainerAddress;
            objContainer.ContactPersonNo = ContactPersonNo;
            objContainer.FreightName = FreightName;

            var ddlContainerNumber = $("#<%=ddlContainers.ClientID%>").find('option:selected').val().trim();
            if (ddlContainerNumber != null || ddlContainerNumber != "" || ddlContainerNumber != 'Select Container') {
                objContainer.OptionType = "Edit";
            }
            else {
                objContainer.OptionType = "Add";
            }


        $.ajax( {
            type: "POST",
            url: "AddContainer.aspx/AddContainerDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objContainer),
            dataType: "json",
            success: function ( result )
            {
                
                if (result.d == 'success' || ContainerNumber.toUpperCase() == result.d) {
                    initialisedControls();
                    $('#Container-bx-msg').text('Container Saved Successfully..');
                    $('#Shipping-bx').removeClass('error_modal');
                }
                else if (result.d == 'error')
                {
                    $('#Container-bx-msg').text('This Container already exists in the system');
                    $('#Shipping-bx').addClass('error_modal');
                }
                
                clearAllControls();
                $('#Shipping-bx').modal('show');
            },
            error: function ( response )
            {
                alert('Add Container failed');
            }
        } );
        clearAllControls();
        return false;
        }
        function clearAllControls()
        {
            $("#<%=txtContainerNumber.ClientID%>").val("");
            //$("#<%=ddlContainerType.ClientID%>").val('Select Container Type');
            var SelectContainerType = $(".chosen-single").find('span');
            SelectContainerType.text('Select Freight Type')
            $("#<%=txtCompanyName.ClientID%>").val("");
            $("#<%=txtContainerAddress.ClientID%>").val("");
            $("#<%=txtContactPersonNo.ClientID%>").val("");
            $("#<%=txtFreightName.ClientID%>").val("");
        }
        function btnOKClick()
        {
            $('#Container-bx-msg').text('');
        }

</script>

    




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">

        <div class="col-lg-12 text-center welcome-message">
            <h2>
                Add or Edit Container
            </h2>
            <p></p>
        </div>

        <div class="col-md-12 box_bg">
            <form id="frmAddContainer" runat="server">
                <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />
                <div class="addcontainer1">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                                Select Container For Edit<span style="color: red"></span></label>
                                <div class="col-sm-8">
                                    <asp:DropDownListChosen ID="ddlContainers" runat="server"
                                        CssClass="vat-option label-lgt"
                                        DataPlaceHolder="Select Container"
                                        AllowSingleDeselect="true"
                                        NoResultsText="No result found"
                                        DisableSearchThreshold="10">
                                        <asp:ListItem Selected="True">Select Container</asp:ListItem>
                                    </asp:DropDownListChosen>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                                Container Number<span style="color: red">*</span></label>
                                <div class="col-sm-8">
                                    <asp:TextBox ID="txtContainerNumber" runat="server" 
                                        CssClass="form-control m-b" PlaceHolder="e.g. CSQU3054383" 
                                        title="Please enter Container Number" style="text-transform: uppercase;"
                                            MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                            Freight Type<span style="color: red">*</span></label>
                            <div id="divContainerType" class="col-sm-8 no_marg_select">
                                <%--<asp:TextBox ID="txtContainerType" runat="server" 
                                    CssClass="form-control m-b" 
                                    title="Please enter Container Name"
                                        MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>--%>

                                <asp:DropDownListChosen ID="ddlContainerType" runat="server"
                                        CssClass="vat-option label-lgt"
                                        DataPlaceHolder="Select Freight Type"
                                        AllowSingleDeselect="true"
                                        NoResultsText="No result found"
                                        DisableSearchThreshold="10">
                                        <asp:ListItem Selected="True">Select Freight Type</asp:ListItem>
                                    </asp:DropDownListChosen>
                            </div>
                        </div>
                        </div>
                        <div class="col-sm-6" style="display:none;">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                            Company Name<span style="color: red"></span></label>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtCompanyName" runat="server" 
                                    CssClass="form-control m-b" 
                                    title="Please enter Company Name"
                                        MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                        </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                            Container Address<span style="color: red"></span></label>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtContainerAddress" runat="server" 
                                    CssClass="form-control m-b" PlaceHolder="e.g. 134  Newgate Street, KEIL" 
                                    title="Please enter Container Address"
                                        MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                            Contact Person Number<span style="color: red"></span></label>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtContactPersonNo" runat="server" 
                                    CssClass="form-control m-b"
                                    title="Please enter Contact Person Number"
                                        MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                        </div>
                        </div>
                        <div class="col-sm-6" style="display:none;">
                            <div class="form-group clearfix"><label class="col-sm-4 control-label">
                            Agent Name<span style="color: red"></span></label>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtFreightName" runat="server" 
                                    CssClass="form-control m-b"
                                    title="Please enter Agent Name"
                                        MaxLength="30" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                            </div>
                        </div>
                        </div>
                        <div class="col-sm-6"></div>
                    </div>
                       <div class="form-group clearfix">
                            <div class="col-sm-12 text-center">
                                    <asp:Button ID="btnSaveContainer" runat="server" Text="Save Container"
                                        CssClass="btn btn-primary" OnClientClick="return saveContainer();"
                                        />
                                    <asp:Button ID="btnCancelContainer" runat="server" Text="Cancel" class="btn btn-default"
                                        OnClientClick="return clearAllControls();" />
                            </div>
                        </div>

                </div>
                
            </form>
        </div>
        </div>
    <div class="row">
    <div class="clearfix">
        <hr/>
        <footer>
            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
        </footer>    
    </div>
    </div>
    <div class="modal fade" id="Shipping-bx" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content modal-content-Container">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">Add Container</h4>
                                        </div>
                                        <div class="modal-body" style="text-align: center; font-size: 22px;">
                                            <p id="Container-bx-msg"></p>
                                        </div>
                                        <div class="modal-footer" style="text-align: center !important;">
                                            <button type="button" class="btn btn-primary" data-dismiss="modal"
                                                 onclick="btnOKClick()">
                                                OK</button>
                                        </div>
                                    </div>

                                </div>
                            </div>

</asp:Content>

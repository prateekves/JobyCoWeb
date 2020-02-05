<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="AddEscalationLevel.aspx.cs" Inherits="JobyCoWeb.CustomerCare.AddEscalationLevel"  EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />

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
        $('#<%=txtLodgingDate.ClientID%>').datepicker({
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

        $('#<%=txtResolvedDate.ClientID%>').datepicker({
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

        //Dropdown change of CustomerName
            $('#<%=ddlCustomerName.ClientID%>').on('change', function () {
                getAllBookingIdsFromCustomerId(this.value);
            });

    });
</script>
<script>
    function clearComplaintTextBoxes() {
       var OtherSource = $("#<%=txtOtherSource.ClientID%>");
       var OtherReason = $("#<%=txtOtherReason.ClientID%>");
       
        OtherSource.val('');
        OtherReason.val('');
    }

    function makeDivVisible(dropDownValue, divId) {
        if (dropDownValue == "Other (Please Specify)") {
            $('#' + divId).css('display', 'block');
        }
        else {
            $('#' + divId).css('display', 'none');
            clearComplaintTextBoxes();
        }
    }

        function checkBlankControls() {

            var CustomerName = $("#<%=ddlCustomerName.ClientID%>");
            var vCustomerName = CustomerName.find('option:selected').text().trim();

            var BookingId = $("#<%=ddlBookingId.ClientID%>");
            var vBookingId = BookingId.find('option:selected').text().trim();

            var ComplaintSource = $("#<%=ddlComplaintSource.ClientID%>");
            var vComplaintSource = ComplaintSource.find('option:selected').text().trim();
            
            var OtherSource = $("#<%=txtOtherSource.ClientID%>");
            var vOtherSource = OtherSource.val().trim();

            var ComplaintReason = $("#<%=ddlComplaintReason.ClientID%>");
            var vComplaintReason = ComplaintReason.find('option:selected').text().trim();
            
            var OtherReason = $("#<%=txtOtherReason.ClientID%>");
            var vOtherReason = OtherReason.val().trim();

            var ComplaintPriority = $("#<%=ddlComplaintPriority.ClientID%>");
            var vComplaintPriority = ComplaintPriority.find('option:selected').text().trim();

            var ComplaintStatus = $("#<%=ddlComplaintStatus.ClientID%>");
            var vComplaintStatus = ComplaintStatus.find('option:selected').text().trim();

            var LodgingDate = $("#<%=txtLodgingDate.ClientID%>");
            var vLodgingDate = LodgingDate.val().trim();

            var ResolvedDate = $("#<%=txtResolvedDate.ClientID%>");
            var vResolvedDate = ResolvedDate.val().trim();

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vCustomerName == "Select CustomerName") {
                vErrMsg.text('Please Select Customer Name');
                vErrMsg.css("display", "block");
                CustomerName.focus();
                return false;
            }

            if (vBookingId == "Select BookingId") {
                vErrMsg.text('Please select a Booking Id');
                vErrMsg.css("display", "block");
                BookingId.focus();
                return false;
            }

            if (vComplaintSource == "Select ComplaintSource") {
                vErrMsg.text('Please select a Complaint Source');
                vErrMsg.css("display", "block");
                ComplaintSource.focus();
                return false;
            }

            if (vComplaintSource == "Other (Please Specify)") {
                if (vOtherSource == "") {
                    vErrMsg.text('Please Specify Other Source');
                    vErrMsg.css("display", "block");
                    OtherSource.focus();
                    return false;
                }
            }

            if (vComplaintReason == "Select ComplaintReason") {
                vErrMsg.text('Please select a Complaint Reason');
                vErrMsg.css("display", "block");
                ComplaintReason.focus();
                return false;
            }

            if (vComplaintReason == "Other (Please Specify)") {
                if (vOtherReason == "") {
                    vErrMsg.text('Please Specify Other Reason');
                    vErrMsg.css("display", "block");
                    OtherReason.focus();
                    return false;
                }
            }

            if (vComplaintPriority == "Select ComplaintPriority") {
                vErrMsg.text('Please select a Complaint Priority');
                vErrMsg.css("display", "block");
                ComplaintPriority.focus();
                return false;
            }

            if (vComplaintStatus == "Select ComplaintStatus") {
                vErrMsg.text('Please select a Complaint Status');
                vErrMsg.css("display", "block");
                ComplaintStatus.focus();
                return false;
            }

            if (vLodgingDate == "") {
                vErrMsg.text('Please enter Complaint Lodging Date');
                vErrMsg.css("display", "block");
                LodgingDate.focus();
                return false;
            }

            //if (vResolvedDate == "") {
            //    vErrMsg.text('Please enter Complaint Resolved Date');
            //    vErrMsg.css("display", "block");
            //    ResolvedDate.focus();
            //    return false;
            //}

            return true;
        }

        function clearAllControls() {
            var CustomerName = $("#<%=ddlCustomerName.ClientID%>");
            var BookingId = $("#<%=ddlBookingId.ClientID%>");

            var ComplaintSource = $("#<%=ddlComplaintSource.ClientID%>");
            var OtherSource = $("#<%=txtOtherSource.ClientID%>");

            var ComplaintReason = $("#<%=ddlComplaintReason.ClientID%>");
            var OtherReason = $("#<%=txtOtherReason.ClientID%>");

            var ComplaintPriority = $("#<%=ddlComplaintPriority.ClientID%>");
            var ComplaintStatus = $("#<%=ddlComplaintStatus.ClientID%>");

            var LodgingDate = $("#<%=txtLodgingDate.ClientID%>");
            var ResolvedDate = $("#<%=txtResolvedDate.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            CustomerName.find('option:selected').text('Select CustomerName');
            BookingId.find('option:selected').text('Select BookingId');

            ComplaintSource.find('option:selected').text('Select ComplaintSource');
            OtherSource.val('');

            ComplaintReason.find('option:selected').text('Select ComplaintReason');
            OtherReason.val('');

            ComplaintPriority.find('option:selected').text('Select ComplaintPriority');
            ComplaintStatus.find('option:selected').text('Select ComplaintStatus');

            LodgingDate.val('');
            ResolvedDate.val('');

            location.href = "/CustomerCare/ViewAllEscalationLevels.aspx";
            return false;
        }

        function clearErrorMessage() {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
        }

</script>

<script>

    function getAllBookingIdsFromCustomerId(CustomerId)
    {
        $('#<%=hfCustomerId.ClientID%>').val(CustomerId);
        var BookingId = $("#<%=ddlBookingId.ClientID%>");
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddEscalationLevel.aspx/GetAllBookingIdsFromCustomerId",
            data: "{CustomerId: '" + CustomerId + "', ddlBookingId: '" + BookingId + "' }",
            success: function ( result )
            {
                //var BookingId = $("#<%//=ddlBookingId.ClientID%>");
                BookingId.html("");
                BookingId.append($("<option></option>").val(null).html("Select BookingId"));
                ////$('.chosen-results').removeData();
                //$('.chosen-results').append('<li class="active-result result-selected" data-option-array-index="0" style="">Select Booking Number</li>');
                var iCount = 0;
                $.each(result.d, function (key, value) {
                    iCount++;
                    BookingId.append($("<option></option>").val(value.BookingId).html(value.BookingId));
                    //$('.chosen-results').append('<li class="active-result" data-option-array-index="' + iCount + '" style="">Select Booking Number</li>');
                });
            },
            error: function ( response )
            {
                alert('Unable to Get All Booking Ids from Customer Id');
            }
        } );
    }

    function addEscalationDetails()
    {
        var ComplaintId = "";
        var CustomerId = $('#<%=hfCustomerId.ClientID%>').val().trim();
        var BookingId = $('#<%=ddlBookingId.ClientID%>').find('option:selected').text().trim();

        var ComplaintSource = $('#<%=ddlComplaintSource.ClientID%>').find('option:selected').text().trim();

        if (ComplaintSource == "Other (Please Specify)") {
            ComplaintSource = $('#<%=txtOtherSource.ClientID%>').val().trim();
        }

        var ComplaintReason = $('#<%=ddlComplaintReason.ClientID%>').find('option:selected').text().trim();

        if (ComplaintReason == "Other (Please Specify)") {
            ComplaintReason = $('#<%=txtOtherReason.ClientID%>').val().trim();
        }

        var ComplaintPriority = $('#<%=ddlComplaintPriority.ClientID%>').find('option:selected').text().trim();

        var ComplaintStatus = $('#<%=ddlComplaintStatus.ClientID%>').find('option:selected').text().trim();

        LodgingDate = $('#<%=txtLodgingDate.ClientID%>').val().trim();
        ResolvedDate = $('#<%=txtResolvedDate.ClientID%>').val().trim();

        var objComplaint = {};

        objComplaint.ComplaintId = ComplaintId;
        objComplaint.CustomerId = CustomerId;
        objComplaint.BookingId = BookingId;

        objComplaint.ComplaintSource = ComplaintSource;
        objComplaint.ComplaintReason = ComplaintReason;

        objComplaint.ComplaintPriority = ComplaintPriority;
        objComplaint.ComplaintStatus = ComplaintStatus;

        objComplaint.LodgingDate = LodgingDate;
        objComplaint.ResolvedDate = ResolvedDate;

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddEscalationLevel.aspx/AddEscalationDetails",
            data: JSON.stringify(objComplaint),
            success: function ( result )
            {
                $.ajax({
                    method: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "AddEscalationLevel.aspx/GetCustomerEmailIDFromCustomerId",
                    data: "{CustomerId: '" + CustomerId + "'}",
                    success: function (result) {
                        var EmailID = result.d;

                        var jQueryDataTableContent = "<table border=1>";

                        //Header Portion
                        //=================================================
                        jQueryDataTableContent += "<tr>";
                        jQueryDataTableContent += "<th>Complaint Id</th>";
                        jQueryDataTableContent += "<th>Booking Id</th>";
                        jQueryDataTableContent += "<th>Complaint Source</th>";
                        jQueryDataTableContent += "<th>Complaint Reason</th>";
                        jQueryDataTableContent += "<th>Complaint Priority</th>";
                        jQueryDataTableContent += "<th>Complaint Status</th>";
                        jQueryDataTableContent += "<th>Complaint Lodge Date</th>";
                        jQueryDataTableContent += "</tr>";
                        //=================================================

                        //Body Portion
                        //=================================================
                        jQueryDataTableContent += "<tr>";
                        jQueryDataTableContent += "<td>" + ComplaintId + "</td>";
                        jQueryDataTableContent += "<td>" + BookingId + "</td>";
                        jQueryDataTableContent += "<td>" + ComplaintSource + "</td>";
                        jQueryDataTableContent += "<td>" + ComplaintReason + "</td>";
                        jQueryDataTableContent += "<td>" + ComplaintPriority + "</td>";
                        jQueryDataTableContent += "<td>" + ComplaintStatus + "</td>";
                        jQueryDataTableContent += "<td>" + LodgingDate + "</td>";
                        jQueryDataTableContent += "</tr>";
                        //=================================================

                        jQueryDataTableContent += "</table>";

                        sendComplaintEmail(EmailID, jQueryDataTableContent, ComplaintId);
                    },
                    error: function (response) {
                        alert('Unable to Get Customer EmailID from CustomerId');
                    }
                });

            },
            error: function ( response )
            {
                alert( 'Complaint Lodging failed' );
            }
        } );
    }

    function sendComplaintEmail(EmailID, jQueryDataTableContent, ComplaintId)
    {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "AddEscalationLevel.aspx/SendComplaintEmail",
            data: "{ EmailID: '" + EmailID + "', jQueryDataTableContent: '" + jQueryDataTableContent + "', ComplaintId: '" + ComplaintId + "'}",
            beforeSend: function ()
            {
                $("#userDiv").show();

                $("#loaderRegistrationText").text('Please wait while we lodge your complaint');
                $("#loaderRegistrationText").show();

                $( "#successRegistrationText" ).hide();

                $( "#userImage" ).show();
            },
            success: function ( result )
            {
                $( "#userDiv" ).hide();
                $( "#loaderRegistrationText" ).hide();

                $("#loaderRegistrationText").text('We have successfully lodged your complaint');
                $("#successRegistrationText").show();

                $("#userImage").hide();

                //Show Modal Popup
                //======================================
                $('#hHeader').text('Complaint');
                $('#pBody').text('Complaint lodged successfully');
                $('#Escalation-bx').modal('show');
                //======================================
            },
            error: function (response) {
                $( "#userDiv" ).hide();
            }
        });
    }

    function saveEscalation()
    {
        if ( checkBlankControls() )
        {
            addEscalationDetails();
            setTimeout( function () { }, 3000 );
        }

        return false;
    }

    function gotoViewAllEscalationsPage() {
        location.href = "/CustomerCare/ViewAllEscalationLevels.aspx";
        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    Add A New Ticket
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <form id="frmNewEscalation" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />
                    <div class="">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <!-- List Of Ids -->
                            <asp:HiddenField ID="hfCustomerId" runat="server" />
                        </div>
                        <div class="panel-body clrBLK col-md-12 dashboad-form">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="row form-group form_first">
                                        <label class="col-sm-5 control-label">
                                        Select Customer Name: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <%--<asp:DropDownList ID="ddlCustomerName" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Customer Name from dropdown"
                                                    onchange="getAllBookingIdsFromCustomerId(this.value);clearErrorMessage();">
                                                    <asp:ListItem>Select CustomerName</asp:ListItem>
                                                </asp:DropDownList>--%>
                                            <asp:DropDownListChosen ID="ddlCustomerName" runat="server"
                                                CssClass="vat-option label-lgt"
                                                DataPlaceHolder="Please select an option"
                                                AllowSingleDeselect="true"
                                                NoResultsText="No result found"
                                                DisableSearchThreshold="10">
                                                <asp:ListItem Selected="True">Select CustomerName</asp:ListItem>
                                            </asp:DropDownListChosen>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Select Booking Id: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:DropDownList ID="ddlBookingId" runat="server"
                                                    CssClass="form-control m-b" title="Please select a BookingId from dropdown"
                                                    onchange="clearErrorMessage();">
                                                    <asp:ListItem>Select BookingId</asp:ListItem>
                                                </asp:DropDownList>
                                            <%--<asp:DropDownListChosen ID="ddlBookingId" runat="server"
                                                CssClass="vat-option label-lgt"
                                                DataPlaceHolder="Please select an option"
                                                AllowSingleDeselect="true"
                                                NoResultsText="No result found"
                                                DisableSearchThreshold="10">
                                                <asp:ListItem Selected="True">Select Booking Number</asp:ListItem>
                                            </asp:DropDownListChosen>--%>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Complaint Source: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:DropDownList ID="ddlComplaintSource" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Complaint Source from dropdown"
                                                    onchange="makeDivVisible(this.value, 'OtherSource');clearErrorMessage();">
                                                    <asp:ListItem>Select ComplaintSource</asp:ListItem>
                                                    <asp:ListItem>Telephone</asp:ListItem>
                                                    <asp:ListItem>Email</asp:ListItem>
                                                    <asp:ListItem>Web</asp:ListItem>
                                                    <asp:ListItem>Social Media</asp:ListItem>
                                                    <asp:ListItem>Other (Please Specify)</asp:ListItem>
                                                </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group" id="OtherSource" style="display: none;">
                                        <label class="col-sm-5 control-label">
                                        Other Source (Please Specify): </label>
                                        <div class="col-sm-7">
                                                <asp:TextBox ID="txtOtherSource" runat="server" CssClass="form-control m-b"
                                                       PlaceHolder="e.g. Fax" title="Please enter Other Complaint Resource" MaxLength="200"
                                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Complaint Reason: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:DropDownList ID="ddlComplaintReason" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Complaint Reason from dropdown"
                                                    onchange="makeDivVisible(this.value, 'OtherReason');clearErrorMessage();">
                                                    <asp:ListItem>Select ComplaintReason</asp:ListItem>
                                                    <asp:ListItem>Delivery Delayed</asp:ListItem>
                                                    <asp:ListItem>Delivery Missing</asp:ListItem>
                                                    <asp:ListItem>Delivery Incomplete</asp:ListItem>
                                                    <asp:ListItem>Item Not Picked Up</asp:ListItem>
                                                    <asp:ListItem>Other (Please Specify)</asp:ListItem>
                                                </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6" id="OtherReason" style="display: none;">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Other Reason (Please Specify): </label>
                                        <div class="col-sm-7">
                                                <asp:TextBox ID="txtOtherReason" runat="server" CssClass="form-control m-b"
                                                       PlaceHolder="e.g. Item lost after pickup" title="Please enter Other Reason" MaxLength="200"
                                                       onkeypress="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Complaint Priority: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:DropDownList ID="ddlComplaintPriority" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Complaint Priority from dropdown"
                                                    onchange="clearErrorMessage();">
                                                    <asp:ListItem>Select ComplaintPriority</asp:ListItem>
                                                    <asp:ListItem>High</asp:ListItem>
                                                    <asp:ListItem>Normal</asp:ListItem>
                                                    <asp:ListItem>Low</asp:ListItem>
                                                </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Complaint Status: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:DropDownList ID="ddlComplaintStatus" runat="server"
                                                    CssClass="form-control m-b" title="Please select a Complaint Status from dropdown"
                                                    onchange="clearErrorMessage();">
                                                    <asp:ListItem>Select ComplaintStatus</asp:ListItem>
                                                    <asp:ListItem>New</asp:ListItem>
                                                    <asp:ListItem>Open</asp:ListItem>
                                                    <asp:ListItem>Fixed</asp:ListItem>
            <%--                                        <asp:ListItem>Closed</asp:ListItem>--%>
                                                </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Complaint Lodging Date: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:TextBox ID="txtLodgingDate" runat="server" CssClass="clrBLK form-control"
                                                    ReadOnly="true" onchange="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6" id="ResolvedDate" style="display: none;">
                                    <div class="row form-group">
                                        <label class="col-sm-5 control-label">
                                        Complaint Resolved Date: <span style="color: red">*</span></label>
                                        <div class="col-sm-7">
                                                <asp:TextBox ID="txtResolvedDate" runat="server" CssClass="clrBLK form-control"
                                                    ReadOnly="true" onchange="clearErrorMessage();"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <div class="col-sm-12 text-center">
                                                <asp:Button ID="btnSaveEscalation" runat="server" Text="Save Ticket"
                                                    CssClass="btn btn-primary" OnClientClick="return saveEscalation();"
                                                    />
                                                <asp:Button ID="btnCancelEscalation" runat="server" Text="Cancel" class="btn btn-default"
                                                    OnClientClick="return clearAllControls();" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                        
                        

                        
                        <!--Added new Script Files for Date Picker-->
                        <script src="/js/bootstrap-datepicker.js"></script>
                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>

                        <!--Added new Script Files for Date Picker-->
                        <script src="/js/bootstrap-datepicker.js"></script>
                        <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>

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
<div class="modal fade" id="Escalation-bx" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header" style="background-color: #f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 id="hHeader" class="modal-title" style="font-size: 24px; color: #111;">Escalation Header</h4>
            </div>
            <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                <p id="pBody">Escalation Body</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="gotoViewAllEscalationsPage();">OK</button>
            </div>
        </div>

    </div>
</div>
</asp:Content>

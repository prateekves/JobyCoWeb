﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="ViewAllInteractions.aspx.cs" EnableEventValidation="false" Inherits="JobyCoWeb.ViewAllInteractions" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

    <style>
        .new-bg { background: #8593E9; }
        .open-bg { background: #9B822E; }
        .fixed-bg {background: #238A35;}
        .closed-bg { background: #B51013; }

        .new-bg, .open-bg, .fixed-bg, .closed-bg
        {
            color: #fff;
            text-transform:uppercase;
            padding: 5px 0;
            width: 100%;
            display: block;
            text-align: center;
        }   

        .print {
            background:none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

        .print:hover {
            background: #fca311;
            color:#fff;
            text-shadow:1px 1px 1px rgba(0,0,0,0.4);
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
    function makeProperColor(vComplaintStatus) {
        switch (vComplaintStatus) {
            case "New":
                vComplaintStatus = "<span class='new-bg'>New</span>";
                break;

            case "Open":
                vComplaintStatus = "<span class='open-bg'>Open</span>";
                break;

            case "Fixed":
                vComplaintStatus = "<span class='fixed-bg'>Fixed</span>";
                break;

            case "Closed":
                vComplaintStatus = "<span class='closed-bg'>Closed</span>";
                break;
        }

        return vComplaintStatus;
    }

    function getAllInteractions(ComplaintId) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllInteractions.aspx/GetAllInteractions",
            data: "{ComplaintId: '" + ComplaintId + "'}",
            success: function (data) {
                var jsonInteractionDetails = JSON.parse(data.d);

                $('#dtViewInteractions').DataTable({
                    data: jsonInteractionDetails,
                    columns: [
                        {
                            data: "InteractionDate",
                            render: function (jsonInteractionDate) {
                                return getFormattedDateUK(jsonInteractionDate);
                            }
                        },
                        { data: "Comments" },
                        { data: "PostedBy" },
                        {
                            data: "ComplaintStatus",
                            render: function (jsonComplaintStatus) {
                                return makeProperColor(jsonComplaintStatus);
                            }
                        },
                        {
                            defaultContent:
                              "<ul class='commentsActionButtons'><li><button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button></li></ul>"
                        }
                    ],
                    "bDestroy": true
                });
            },
            error: function (response) {
                alert('Unable to Bind All Interactions');
            }
        });//end of ajax

        $('#dtViewInteractions tbody').on('click', '.print', function () {
            var vClosestTr = $(this).closest("tr");

            var vComplaintId = $('#<%=txtComplaintId.ClientID%>').val().trim();
            $('#spComplaintId').text(vComplaintId);
            $('#spHeaderComplaintId').text(vComplaintId);

            var vCustomerName = $('#<%=txtCustomerName.ClientID%>').val().trim();
            $('#spCustomerName').text(vCustomerName);

            var vBookingId = $('#<%=txtBookingId.ClientID%>').val().trim();
            $('#spBookingId').text(vBookingId);

            var vInteractionDate = vClosestTr.find('td').eq(0).text().trim();
            $('#spInteractionDate').text(vInteractionDate);

            var vComments = vClosestTr.find('td').eq(1).text().trim();
            $('#spComments').text(vComments);

            var vPostedBy = vClosestTr.find('td').eq(2).text().trim();
            $('#spPostedBy').text(vPostedBy);

            var vComplaintStatus = vClosestTr.find('td').eq(3).text().trim();
            $('#spComplaintStatus').text(vComplaintStatus);

            printDetails('tblInteractionDetails');

            return false;
        });
    }

    $(document).ready(function () {
        var ComplaintId = $('#<%=txtComplaintId.ClientID%>').val().trim();
        getAllInteractions(ComplaintId);

    });
</script>

<script>
        function checkBlankControls() {

            var Comments = $("#<%=txtComments.ClientID%>");
            var vComments = Comments.val().trim();

            var ComplaintStatus = $("#<%=ddlComplaintStatus.ClientID%>");
            var vComplaintStatus = ComplaintStatus.find('option:selected').text().trim();

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            if (vComments == "") {
                vErrMsg.text('Please Enter Comments');
                vErrMsg.css("display", "block");
                vErrMsg.css("margin-left", "100px");
                vErrMsg.css("margin-top", "25px");
                Comments.focus();
                return false;
            }

            if (vComplaintStatus == "Select ComplaintStatus") {
                vErrMsg.text('Please select a Complaint Status');
                vErrMsg.css("display", "block");
                vErrMsg.css("margin-left", "100px");
                vErrMsg.css("margin-top", "25px");
                ComplaintStatus.focus();
                return false;
            }

            return true;
        }

        function clearAllControls() {

            var Comments = $("#<%=txtComments.ClientID%>");
            var vComments = Comments.val().trim();

            var ComplaintStatus = $("#<%=ddlComplaintStatus.ClientID%>");
            var vComplaintStatus = ComplaintStatus.find('option:selected').text().trim();

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            Comments.val('');
            ComplaintStatus.find('option:selected').text('Select ComplaintStatus');

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
    function addInteractionDetails()
    {
        var ComplaintId = $('#<%=txtComplaintId.ClientID%>').val().trim();
        var InteractionDate = "";
        var Comments = $("#<%=txtComments.ClientID%>").val().trim();
        var PostedBy = $("#<%=hfUserName.ClientID%>").val().trim();
        var ComplaintStatus = $('#<%=ddlComplaintStatus.ClientID%>').find('option:selected').text().trim();

        var objInteraction = {};

        objInteraction.ComplaintId = ComplaintId;
        objInteraction.InteractionDate = InteractionDate;
        objInteraction.Comments = Comments;
        objInteraction.PostedBy = PostedBy;
        objInteraction.ComplaintStatus = ComplaintStatus;

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllInteractions.aspx/AddInteractionDetails",
            data: JSON.stringify(objInteraction),
            success: function ( result )
            {
                location.reload();
            },
            error: function ( response )
            {
                alert( 'Customer Interaction Collection failed' );
            }
        } );
    }

    function saveInteraction() {
        if (checkBlankControls()) {
            addInteractionDetails();
            setTimeout(function () { }, 3000);
        }

        return false;
    }

</script>

<script>
    function printDetails(vTableId) {
        var prtContent = document.getElementById(vTableId);
        prtContent.border = 0; //set no border here

        var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
        WinPrint.document.write(prtContent.outerHTML);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();

        //return false;
    }

    function exportToPDF(vTableId, vPDF_FileName) {
        /*var pdf = new jsPDF('p', 'pt', 'letter');
        pdf.canvas.height = 72 * 11;
        pdf.canvas.width = 72 * 8.5;

        var vContent = document.getElementById(vTableId);
        pdf.fromHTML(vContent);

        pdf.save(vPDF_FileName);*/

        var quotes = document.getElementById(vTableId);
        //alert(quotes.clientHeight);

        html2canvas(quotes, {
            onrendered: function (canvas) {

                //! MAKE YOUR PDF
                var pdf = new jsPDF('p', 'pt', 'letter');

                for (var i = 0; i <= quotes.clientHeight / 980; i++) {
                    //! This is all just html2canvas stuff
                    var srcImg = canvas;
                    var sX = 0;
                    var sY = 980 * i; // start 980 pixels down for every new page
                    var sWidth = 2000;
                    var sHeight = 980;
                    var dX = 0;
                    var dY = 0;
                    var dWidth = 2000;
                    var dHeight = 980;

                    window.onePageCanvas = document.createElement("canvas");
                    onePageCanvas.setAttribute('width', 2000);
                    onePageCanvas.setAttribute('height', 980);
                    var ctx = onePageCanvas.getContext('2d');
                    // details on this usage of this function: 
                    // https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Using_images#Slicing

                    ctx.drawImage(srcImg, 0, 0);
                    //ctx.drawImage(srcImg,sX,sY,sWidth,sHeight,dX,dY,dWidth,dHeight);

                    // document.body.appendChild(canvas);
                    var canvasDataURL = onePageCanvas.toDataURL("image/png", 1.0);

                    var width = onePageCanvas.width;
                    var height = onePageCanvas.clientHeight;

                    //! If we're on anything other than the first page,
                    // add another page
                    if (i > 0) {
                        pdf.addPage(612, 791); //8.5" x 11" in pts (in*72)
                    }
                    //! now we declare that we're working on that page
                    pdf.setPage(i + 1);
                    //! now we add content to that page!
                    pdf.addImage(canvasDataURL, 'PNG', 0, 0, (width * .42), (height * .62));

                }
                //! after the for loop is finished running, we save the pdf.
                pdf.save(vPDF_FileName);
            }
        });

        return false;
    }

    function exportToExcel(vTableId, vExcelFileName) {
        var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
        var textRange; var j = 0;
        tab = document.getElementById(vTableId); // id of table

        for (j = 0 ; j < tab.rows.length ; j++) {
            tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
            //tab_text=tab_text+"</tr>";
        }

        tab_text = tab_text + "</table>";
        tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
        tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
        tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

        var ua = window.navigator.userAgent;
        var msie = ua.indexOf("MSIE ");

        if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
        {
            txtArea1.document.open("txt/html", "replace");
            txtArea1.document.write(tab_text);
            txtArea1.document.close();
            txtArea1.focus();
            sa = txtArea1.document.execCommand("SaveAs", true, vExcelFileName);
        }
        else                 //other browser not tested on IE 11
            sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

        return (sa);
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    View All Customer Interactions
                </h2>
                <p></p>
            </div>
        </div>
       <div class="container">
        <div class="row">
            <div class="col-md-12">
                <form id="frmAllInteractions" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="cust_int">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <!--List of Hidden Fields-->
                            <asp:HiddenField ID="hfCustomerId" runat="server" />
                            <asp:HiddenField ID="hfUserName" runat="server" />
                        </div>
                        <div class="panel-body clrBLK dashboad-form">
                        <div class="row">
                            <div class="col-md-6 col-md-offset-3">
                                <div class="form-group row text-center">
                                    <label class="col-sm-12 control-label">Complaint Id: </label>
                                    <div class="col-sm-12">
                                            <asp:TextBox ID="txtComplaintId" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Complaint Id" MaxLength="200" ReadOnly="true" onkeypress="clearErrorMessage();"></asp:TextBox>                            
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group row">
                                    <label class="col-sm-5 control-label">Customer Name: </label>
                                    <div class="col-sm-7">
                                            <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Customer Name" MaxLength="200" ReadOnly="true" onkeypress="clearErrorMessage();"></asp:TextBox>                            
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group row">
                                    <label class="col-sm-5 control-label">Booking Id: </label>
                                    <div class="col-sm-7">
                                            <asp:TextBox ID="txtBookingId" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Booking Id" MaxLength="200" ReadOnly="true" onkeypress="clearErrorMessage();"></asp:TextBox>                                 
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group row">
                                    <label class="col-sm-5 control-label">Complaint Source: </label>
                                    <div class="col-sm-7">
                                            <asp:TextBox ID="txtComplaintSource" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Complaint Source" MaxLength="200" ReadOnly="true" onkeypress="clearErrorMessage();"></asp:TextBox>                                        
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group row">
                                    <label class="col-sm-5 control-label">Complaint Reason: </label>
                                    <div class="col-sm-7">
                                            <asp:TextBox ID="txtComplaintReason" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Complaint Reason" MaxLength="200" ReadOnly="true" onkeypress="clearErrorMessage();"></asp:TextBox>                                        
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group row">
                                    <label class="col-sm-5 control-label">Complaint Priority: </label>
                                    <div class="col-sm-7">
                                            <asp:TextBox ID="txtComplaintPriority" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Complaint Priority" MaxLength="200" ReadOnly="true" onkeypress="clearErrorMessage();"></asp:TextBox>                                        
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group row">
                                    <label class="col-sm-5 control-label">Complaint Lodging Date: </label>
                                    <div class="col-sm-7">
                                            <asp:TextBox ID="txtLodgingDate" runat="server" PlaceHolder="e.g. Complaint Lodging Date" CssClass="clrBLK form-control" ReadOnly="true" onchange="clearErrorMessage();"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                            <div class="hr-line-dashed"></div>
                        <div class="row">
                            <div class="col-md-8 col-md-offset-2">
                            <div class="form-group center_text">
                                <label class="col-sm-12 control-label">Comments: <span style="color: red">*</span></label>
                                <div class="col-sm-12">
                                        <asp:TextBox ID="txtComments" runat="server" CssClass="form-control m-b" PlaceHolder="e.g. Comments" MaxLength="1000" TextMode="MultiLine" onkeypress="clearErrorMessage();"></asp:TextBox>                                        
                                </div>
                            </div>
                            </div>
                        </div>                        
                        <div class="row">
                            <div class="col-md-4 col-md-offset-4">
                                <div class="form-group center_text">
                                    <label class="col-sm-12 control-label">Complaint Status: <span style="color: red">*</span></label>
                                    <div class="col-sm-12">
                                            <asp:DropDownList ID="ddlComplaintStatus" runat="server"
                                                CssClass="form-control m-b" title="Please select a Complaint Status from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select ComplaintStatus</asp:ListItem>
                                                <asp:ListItem>New</asp:ListItem>
                                                <asp:ListItem>Open</asp:ListItem>
                                                <asp:ListItem>Fixed</asp:ListItem>
                                                <asp:ListItem>Closed</asp:ListItem>
                                            </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>

                       
                       <div class="form-group">
                            <div class="col-sm-12 text-center bdr">
                                    <asp:Button ID="btnSaveInteraction" runat="server" Text="Submit"
                                        CssClass="btn btn-primary" OnClientClick="return saveInteraction();"
                                        />
                                    <asp:Button ID="btnCancelInteraction" runat="server" Text="Cancel" class="btn btn-default"
                                        OnClientClick="return clearAllControls();" />
                            </div>
                        </div>

                            <table id="dtViewInteractions">
                                <thead>
                                    <tr>
                                        <th>Interaction Date</th>
                                        <th>Comments</th>
                                        <th>Posted By</th>
                                        <th>Complaint Status</th>
                                        <th>Actions</th>
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
                    </div>
                </form>
            </div>
        </div>
       </div>
    </div>

    <div class="modal fade" id="dvInteractionModal" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Interaction Details: #<span id="spHeaderComplaintId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Interaction below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintInteractionModal" data-dismiss="modal" 
                                    onclick="printDetails('tblInteractionDetails'); return false;" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfInteractionModal" data-dismiss="modal" 
                                    onclick="exportToPDF('dvInteractionModal', 'InteractionDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelInteractionModal" data-dismiss="modal" 
                                    onclick="exportToExcel('tblInteractionDetails', 'InteractionDetails.xls');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-excel-o" aria-hidden="true"></i></button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="dvCNFRM">
                                    <h2 class=""></h2>
                                    <div class="confirm-box">
                                        <div class="confirm-details">
                                            <div class="table-responsive">
                                                <table class="table custoFULLdet" id="tblInteractionDetails">
                                                    <tr>
                                                        <th>Complaint Id: </th>
                                                        <td><span id="spComplaintId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Customer Name: </th>
                                                        <td><span id="spCustomerName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Booking Id: </th>
                                                        <td><span id="spBookingId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Interaction Date: </th>
                                                        <td><span id="spInteractionDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Comments: </th>
                                                        <td><span id="spComments"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Posted By: </th>
                                                        <td><span id="spPostedBy"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Complaint Status: </th>
                                                        <td><span id="spComplaintStatus"></span></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>                                    
                    </div>                        
                </div>
            </div>
        </div>
    </div>

</asp:Content>

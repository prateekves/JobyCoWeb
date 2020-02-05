<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="ViewAllEscalationLevels.aspx.cs" Inherits="JobyCoWeb.CustomerCare.ViewAllEscalationLevels" EnableEventValidation="false"  %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

    <style>
        .ComplaintId {

        }

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

        .print, .resolve, .view {
            background:none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

        .print:hover, .resolve:hover, .view:hover {
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
    var vGlobalComplaintId = "";
</script>

<script>
    function getComplaintBookingId(ComplaintId) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllEscalationLevels.aspx/GetComplaintBookingId",
            data: "{ComplaintId: '" + ComplaintId + "'}",
            success: function (result) {
                $('#spBookingId').text(result.d);
                getComplaintSource(ComplaintId);
            },
            error: function (response) {
                alert('Unable to Get Booking Id from Complaint Id');
            }
        });
    }

    function getComplaintSource(ComplaintId) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllEscalationLevels.aspx/GetComplaintSource",
            data: "{ComplaintId: '" + ComplaintId + "'}",
            success: function (result) {
                $('#spComplaintSource').text(result.d);
                getComplaintReason(ComplaintId);
            },
            error: function (response) {
                alert('Unable to Get Complaint Source from Complaint Id');
            }
        });
    }

    function getComplaintReason(ComplaintId) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllEscalationLevels.aspx/GetComplaintReason",
            data: "{ComplaintId: '" + ComplaintId + "'}",
            success: function (result) {
                $('#spComplaintReason').text(result.d);
                getComplaintPriority(ComplaintId);
            },
            error: function (response) {
                alert('Unable to Get Complaint Reason from Complaint Id');
            }
        });
    }

    function getComplaintPriority(ComplaintId) {
        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllEscalationLevels.aspx/GetComplaintPriority",
            data: "{ComplaintId: '" + ComplaintId + "'}",
            success: function (result) {
                $('#spComplaintPriority').text(result.d);
            },
            error: function (response) {
                alert('Unable to Get Complaint Priority from Complaint Id');
            }
        });
    }

</script>

<script>
    $(document).ready(function () {
        getAllComplaints();

    });
    
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
   
    function selectComplaintStatus() {
        //alert(vGlobalComplaintId);

        //$('#pErrMsg').css('display', 'none');
        var vStatusChoice = $('#txtChoice').val().trim();

        switch (vStatusChoice) {
            case "1":
                changeComplaintStatus(vGlobalComplaintId, "New");
                break;

            case "2":
                changeComplaintStatus(vGlobalComplaintId, "Open");
                break;

            case "3":
                changeComplaintStatus(vGlobalComplaintId, "Fixed");
                break;

            default:
                //$('#pErrMsg').text('It is none of the choices.');
                //$('#pErrMsg').css('display', 'block');
                alert('It is none of the choices');
                break;
        }

        $('#txtChoice').val('');

        return false;
    }

    function changeComplaintStatus(ComplaintId, ComplaintStatus) {

        //Binding the values with the Object
        var objComplaint = {};
        objComplaint.ComplaintId = ComplaintId;
        objComplaint.ComplaintStatus = ComplaintStatus;

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllEscalationLevels.aspx/ChangeComplaintStatus",
            data: JSON.stringify(objComplaint),
            success: function (result) {
                location.reload();
            },
            error: function (response) {
                alert('Unable to change Complaint Status');
            }
        });

        return false;
    }

    function getAllComplaints() {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllEscalationLevels.aspx/GetAllComplaints",
                data: "{}",
                success: function (data)
                {
                    var jsonEscalationsDetails = JSON.parse( data.d );

                    $('#dtViewComplaints').DataTable({
                        data: jsonEscalationsDetails,
                        columns: [
                            {
                                data: "ComplaintId",
                                render: function (data) {
                                    return '<a class="ComplaintId">' + data + '</a>';
                                }
                            },
                            { data: "CustomerName" },
                            //{ data: "BookingId" },
                            //{ data: "ComplaintSource" },
                            //{ data: "ComplaintReason" },
                            //{ data: "ComplaintPriority" },
                            {
                                data: "LodgingDate",
                                render: function ( jsonLodgingDate )
                                {
                                    return getFormattedDateUK( jsonLodgingDate );
                                }
                            },
                            {
                                data: "ResolvedDate",
                                render: function (jsonResolvedDate) {
                                    return getFormattedDateUK(jsonResolvedDate);
                                }
                            },
                            {
                                data: "ComplaintStatus",
                                render: function (jsonComplaintStatus) {
                                    return makeProperColor(jsonComplaintStatus);
                                }
                            },
                            {
                                defaultContent:
                                  "<ul class='complaintActionButtons'><li><button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button></li></li><li><button class='view' title='View'><i class='fa fa-eye' aria-hidden='true'></i></button></li></ul>"
                            }
                        ],
                        "bDestroy": true
                    } );
                },
                error: function (response) {
                    alert('Unable to Bind All Escalations');
                }
            } );//end of ajax

            $('#dtViewComplaints tbody').on('click', '.ComplaintId', function () {
                var vClosestTr = $(this).closest("tr");

                var vComplaintId = vClosestTr.find('td').eq(0).text().trim();
                $('#spComplaintId').text(vComplaintId);
                $('#spHeaderComplaintId').text(vComplaintId);

                var vCustomerName = vClosestTr.find('td').eq(1).text().trim();
                $('#spCustomerName').text(vCustomerName);

                var vComplaintStatus = vClosestTr.find('td').eq(2).text().trim();
                $('#spComplaintStatus').text(vComplaintStatus);

                var vLodgingDate = vClosestTr.find('td').eq(3).text().trim();
                $('#spLodgingDate').text(vLodgingDate);

                var vResolvedDate = vClosestTr.find('td').eq(4).text().trim();
                $('#spResolvedDate').text(vResolvedDate);

                getComplaintBookingId(vComplaintId);
                $('#dvComplaintModal').modal('show');

                return false;
            });

            $('#dtViewComplaints tbody').on('click', '.print', function () {
                var vClosestTr = $(this).closest("tr");

                var vComplaintId = vClosestTr.find('td').eq(0).text().trim();
                $('#spComplaintId').text(vComplaintId);
                $('#spHeaderComplaintId').text(vComplaintId);

                var vCustomerName = vClosestTr.find('td').eq(1).text().trim();
                $('#spCustomerName').text(vCustomerName);

                var vComplaintStatus = vClosestTr.find('td').eq(2).text().trim();
                $('#spComplaintStatus').text(vComplaintStatus);

                var vLodgingDate = vClosestTr.find('td').eq(3).text().trim();
                $('#spLodgingDate').text(vLodgingDate);

                var vResolvedDate = vClosestTr.find('td').eq(4).text().trim();
                $('#spResolvedDate').text(vResolvedDate);

                getComplaintBookingId(vComplaintId);
                printDetails('tblComplaintDetails');

                return false;
            });

            $( '#dtViewComplaints tbody' ).on( 'click', '.resolve', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vComplaintId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#<%=hfComplaintID.ClientID%>' ).val( vComplaintId );

                $( '#RemoveComplaint-bx' ).modal( 'show' );
                return false;
            } );

            $( '#dtViewComplaints tbody' ).on( 'click', '.view', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vComplaintId = vClosestTr.find( 'td' ).eq( 0 ).text();
                
                gotoViewAllInteractionsPage(vComplaintId);                
                return false;
            } );

            //$('#dtViewComplaints tbody').on('click', '.new-bg', function () {
            //    var vClosestTr = $(this).closest("tr");
            //    vGlobalComplaintId = vClosestTr.children('td:first').text().trim();

            //    $('#ComplaintStatus-bx').modal('show');
                
            //    return false;
            //});

            //$('#dtViewComplaints tbody').on('click', '.open-bg', function () {
            //    var vClosestTr = $(this).closest("tr");
            //    vGlobalComplaintId = vClosestTr.children('td:first').text().trim();

            //    $('#ComplaintStatus-bx').modal('show');

            //    return false;
            //});

            //$('#dtViewComplaints tbody').on('click', '.fixed-bg', function () {
            //    var vClosestTr = $(this).closest("tr");
            //    vGlobalComplaintId = vClosestTr.children('td:first').text().trim();

            //    $('#ComplaintStatus-bx').modal('show');

            //    return false;
            //});

            return false;
    }
</script>
<script>
    function gotoAddNewEscalationPage() {
        location.href = '/CustomerCare/AddEscalationLevel.aspx';
        return false;
    }

    function gotoViewAllInteractionsPage(ComplaintId) {
        location.href = '/CustomerCare/ViewAllInteractions.aspx?ComplaintId=' + ComplaintId;
        return false;
    }

    function takePrintout() {
        prtContent = document.getElementById('dtViewComplaints');
        prtContent.border = 0; //set no border here

        var WinPrint = window.open('', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1');
        WinPrint.document.write(prtContent.outerHTML);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();

        return false;
    }

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

    function removeComplaintDetails() {
        var ComplaintId = $('#<%=hfComplaintID.ClientID%>').val().trim();

        $.ajax({
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "ViewAllEscalationLevels.aspx/RemoveComplaintDetails",
            data: "{ ComplaintId: '" + ComplaintId + "'}",
            success: function (result) {
                location.reload();
            },
            error: function (response) {
                alert('Unable to Remove Complaint Details');
            }
        });
    }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    View All Tickets
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <form id="frmViewAllEscalations" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                    <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                                style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                            <asp:HiddenField ID="hfComplaintID" runat="server" />
                        </div>
                        <div class="panel-body box_bg">
                            <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                <div class="col-md-12 view_left">
                                    <span class="iconADD">
                                        <asp:Button ID="btnPrintAllEscalations" runat="server"  
                                            Text="Print Ticket" OnClientClick="return takePrintout();" />
                                        <i class="fa fa-print" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD">
                                        <asp:Button ID="btnAddNewEscalation" runat="server"  
                                        Text="Add Ticket" OnClientClick="return gotoAddNewEscalationPage();" />
                                        <i class="fa fa-user" aria-hidden="true"></i>
                                    </span>
                               
                                    <span class="iconADD" style="margin-bottom: 5px;">
                                        <asp:Button ID="btnExportViewAllEscalationsExcel" runat="server"  
                                        Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD">
                                        <asp:Button ID="btnExportViewAllEscalationsPDF" runat="server"  
                                            Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                        <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                    </span>
                                </div>
                                </div>
                            </div>
                           </div>
                            <table id="dtViewComplaints">
                                <thead>
                                    <tr>
                                        <th>Complaint Id</th>
                                        <th>Customer Name</th>
                                        <!--<th>Booking Id</th>
                                        <th>Complaint Source</th>
                                        <th>Complaint Reason</th>
                                        <th>Complaint Priority</th>-->
                                        <th>Lodging Date</th>
                                        <th>Resolved Date</th>
                                        <th>Complaint Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                        <div id="dtViewComplaints_footer">
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

    <div class="modal fade" id="RemoveComplaint-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Close Complaint</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <p>Sure? You want to Close this Complaint?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="removeComplaintDetails();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>
      
        </div>
    </div>

    <div class="modal fade" id="dvComplaintModal" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Complaint Details: #<span id="spHeaderComplaintId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Complaint below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintComplaintModal" data-dismiss="modal" 
                                    onclick="printDetails('tblComplaintDetails'); return false;" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfComplaintModal" data-dismiss="modal" 
                                    onclick="exportToPDF('dvComplaintModal', 'ComplaintDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelComplaintModal" data-dismiss="modal" 
                                    onclick="exportToExcel('tblComplaintDetails', 'ComplaintDetails.xls');" style="margin-bottom:10px;">
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
                                                <table class="table custoFULLdet" id="tblComplaintDetails">
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
                                                        <th>Complaint Source: </th>
                                                        <td><span id="spComplaintSource"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Complaint Reason: </th>
                                                        <td><span id="spComplaintReason"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Complaint Priority: </th>
                                                        <td><span id="spComplaintPriority"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Complaint Status: </th>
                                                        <td><span id="spComplaintStatus"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Lodging Date: </th>
                                                        <td><span id="spLodgingDate"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Resolved Date: </th>
                                                        <td><span id="spResolvedDate"></span></td>
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

    <div class="modal fade" id="ComplaintStatus-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Select Complaint Status</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <!--<p id="pErrMsg" style="color: orangered; display: none;"></p>-->
                    <p>1. New</p>
                    <p>2. Open</p>
                    <p>3. Fixed</p>
                    <p>Enter your choice: <input type="text" id="txtChoice" style="border: 1px solid black;" onchange="$('#pErrMsg').css('display', 'none');" /></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="selectComplaintStatus();">OK</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                </div>
            </div>
      
        </div>
    </div>

</asp:Content>

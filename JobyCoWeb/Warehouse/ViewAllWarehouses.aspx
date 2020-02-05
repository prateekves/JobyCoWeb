<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="ViewAllWarehouses.aspx.cs" Inherits="JobyCoWeb.Warehouse.ViewAllWarehouses"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script src="/Scripts/jquery.dataTables.min.js"></script>
    <script src="/js/jspdf.min.js"></script>

    <style>
        .print, .edit, .delete {
            background:none;
            margin-right: 5px;
            width: 30px;
            height: 30px;
            border: 1px solid #fca311;
            color: #fca311;
        }

        .print:hover, .edit:hover, .delete:hover {
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
        function checkBlankControls() {
            var vWarehouseId = $("#<%=txtWarehouseID.ClientID%>");
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
            var vWarehouseId = $("#<%=txtWarehouseID.ClientID%>");
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
        function updateWarehouseDetails()
        {
            var WarehouseId = $( "#<%=txtWarehouseID.ClientID%>" ).val().trim();
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
                url: "ViewAllWarehouses.aspx/UpdateWarehouseDetails",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify( objWarehouse ),
                dataType: "json",
                success: function ( result )
                {
                    $( '#Warehouse-bx' ).modal( 'show' );                
                },
                error: function ( response )
                {
                    alert( 'Warehouse Details Updation failed' );
                }
            } );

            return false;
        }

        function editWarehouseDetails()
        {
            if ( checkBlankControls() )
            {
                updateWarehouseDetails();
                //setTimeout( function () { }, 3000 );
            }

            return false;
        }

        function removeWarehouseDetails()
        {
            var WarehouseId = $( '#<%=hfWarehouseId.ClientID%>' ).val().trim();

            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllWarehouses.aspx/RemoveWarehouseDetails",
                data: "{ WarehouseId: '" + WarehouseId + "'}",
                success: function ( result )
                {
                    location.reload();
                },
                error: function ( response )
                {
                    alert( 'Unable to Remove Warehouse Details' );
                }
            } );
        }

    </script>

    <script>
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

        function getAllZones()
        {
            $.ajax( {
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "NewWarehouse.aspx/GetAllZones",
                data: "{}",
                dataType: "json",
                success: function ( data )
                {
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
        $( document ).ready( function ()
        {
            $( '#dvWarehouseDetails' ).css( 'display', 'none' );
            getAllWarehouses();

            getAllLocations();
            getAllZones();
        } );
    </script>

    <script>
        function getAllWarehouses()
        {
            $.ajax({
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ViewAllWarehouses.aspx/GetAllWarehouses",
                contentType: "application/json; charset=utf-8",
                success: function (data)
                {
                    var jsonWarehouseDetails = JSON.parse( data.d );
                    $( '#dtViewWarehouse' ).DataTable( {
                        data: jsonWarehouseDetails,
                        columns: [
                            { data: "WarehouseId" },
                            { data: "WarehouseName" },
                            { data: "LocationName" },
                            { data: "ZoneName" },
                            {
                                defaultContent:
                                  "<button class='print' title='Print'><i class='fa fa-print' aria-hidden='true'></i></button><button class='edit' title='Edit'><i class='fa fa-pencil' aria-hidden='true'></i></button><button class='delete' title='Delete'><i class='fa fa-times' aria-hidden='true'></i></button>"
                            }
                        ]
                    } );
                },
                error: function (response) {
                    alert('Unable to Bind View All Warehouses');
                }
            } );//end of ajax

            $( '#dtViewWarehouse tbody' ).on( 'click', '.print', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vWarehouseId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#spWarehouseId' ).text( vWarehouseId );
                $( '#spHeaderWarehouseId' ).text( vWarehouseId );

                var vWarehouseName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#spWarehouseName' ).text( vWarehouseName );

                var vLocationName = vClosestTr.find( 'td' ).eq( 2 ).text();
                $( '#spLocationName' ).text( vLocationName );

                var vZoneName = vClosestTr.find( 'td' ).eq( 3 ).text();
                $( '#spZoneName' ).text( vZoneName );

                return printDetails('tblWarehouseDetails');

                //$( '#dvWarehouseModal' ).modal( 'show' );
                //return false;
            } );

            $( '#dtViewWarehouse tbody' ).on( 'click', '.edit', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vWarehouseId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#<%=txtWarehouseID.ClientID%>' ).val( vWarehouseId );

                var vLocationName = vClosestTr.find( 'td' ).eq( 1 ).text();
                $( '#<%=txtWarehouseName.ClientID%>' ).val( vLocationName );

                var vWarehouseLocation = vClosestTr.find( 'td' ).eq( 2 ).text();
                $( '#<%=ddlWarehouseLocation.ClientID%>' ).find('option:selected').text(vWarehouseLocation);

                var vWarehouseZone = vClosestTr.find( 'td' ).eq( 3 ).text();
                $( '#<%=ddlWarehouseZone.ClientID%>' ).find('option:selected').text(vWarehouseZone);

                //Make appear Edit Details
                //====================================================
                $( '#dvWarehouseDetails' ).css( 'display', 'block' );
                $( '#dvWarehouseDetails' ).css( 'margin-left', '100px' );
                //====================================================

                //Make disappear View All Details 
                //=======================================================
                $( '#dtViewWarehouse_wrapper' ).css( 'display', 'none' );
                disappearAllButtons();
                //=======================================================

                return false;
            } );

            $( '#dtViewWarehouse tbody' ).on( 'click', '.delete', function ()
            {
                var vClosestTr = $( this ).closest( "tr" );

                var vWarehouseId = vClosestTr.find( 'td' ).eq( 0 ).text();
                $( '#<%=hfWarehouseId.ClientID%>' ).val( vWarehouseId );

                $( '#RemoveWarehouse-bx' ).modal( 'show' );
                return false;
            } );

            return false;
        }

    </script>

    <script>
        function disappearAllButtons()
        {
            $( '#<%=btnAddNewWarehouse.ClientID%>' ).css( 'display', 'none' );
            $( '#<%=btnPrintAllWarehouses.ClientID%>' ).css( 'display', 'none' );
            $( '#<%=btnExportViewAllWarehousesPDF.ClientID%>' ).css( 'display', 'none' );
            $( '#<%=btnExportViewAllWarehousesExcel.ClientID%>' ).css( 'display', 'none' );

            return false;
        }

        function gotoAddWarehousePage()
        {
            location.href = '/Warehouse/NewWarehouse.aspx';
            return false;
        }

        function takePrintout()
        {
            prtContent = document.getElementById( 'dtViewWarehouse' );
            prtContent.border = 0; //set no border here

            var WinPrint = window.open( '', '', 'left=100,top=100,width=1000,height=1000,toolbar=0,scrollbars=1,status=0,resizable=1' );
            WinPrint.document.write( prtContent.outerHTML );
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();

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

        return false;
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
            onrendered: function(canvas) {

                //! MAKE YOUR PDF
                var pdf = new jsPDF('p', 'pt', 'letter');

                for (var i = 0; i <= quotes.clientHeight/980; i++) {
                    //! This is all just html2canvas stuff
                    var srcImg  = canvas;
                    var sX      = 0;
                    var sY      = 980*i; // start 980 pixels down for every new page
                    var sWidth  = 2000;
                    var sHeight = 980;
                    var dX      = 0;
                    var dY      = 0;
                    var dWidth  = 2000;
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

                    var width         = onePageCanvas.width;
                    var height        = onePageCanvas.clientHeight;

                    //! If we're on anything other than the first page,
                    // add another page
                    if (i > 0) {
                        pdf.addPage(612, 791); //8.5" x 11" in pts (in*72)
                    }
                    //! now we declare that we're working on that page
                    pdf.setPage(i+1);
                    //! now we add content to that page!
                    pdf.addImage(canvasDataURL, 'PNG', 0, 0, (width*.42), (height*.62));

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

            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    View All Warehouses
                </h2>
                <p></p>
            </div>

            <div class="col-lg-12">
                <form id="frmViewZone" runat="server">
                    <asp:HiddenField ID="hfMenusAccessible" runat="server" />
                    <asp:HiddenField ID="hfControlsAccessible" runat="server" />

                <div class="hpanel">
                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>

                            <asp:HiddenField ID="hfWarehouseId" runat="server" />
                    </div>                                                
                        <div class="panel-body box_bg">
                            <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                <div class="col-md-12 icon_center">
                                    <span class="iconADD">
                                        <asp:Button ID="btnPrintAllWarehouses" runat="server"  
                                            Text="Print Warehouse Details" OnClientClick="return takePrintout();" />
                                        <i class="fa fa-print" aria-hidden="true"></i>
                                    </span>

                                    <span class="iconADD">
                                        <asp:Button ID="btnAddNewWarehouse" runat="server"  
                                        Text="Add New Warehouse" OnClientClick="return gotoAddWarehousePage();" />
                                        <i class="fa fa-user" aria-hidden="true"></i>
                                    </span>
                             
                                    <span class="iconADD">
                                        <asp:Button ID="btnExportViewAllWarehousesExcel" runat="server"  
                                        Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                        <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                    </span>
                                    <span class="iconADD">
                                        <asp:Button ID="btnExportViewAllWarehousesPDF" runat="server"  
                                            Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                        <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                    </span>
                                </div>
                                </div>
                            </div>
                        </div>
                        <div id="dvWarehouseDetails" class="panel-body clrBLK col-md-12 dashboad-form"
                            style="margin-left: 100px;">
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Warehouse Id</label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtWarehouseID" runat="server"
                                                CssClass="form-control m-b" ReadOnly="true"></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Warehouse Name <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                        <asp:TextBox ID="txtWarehouseName" runat="server" 
                                            CssClass="form-control m-b" PlaceHolder="e.g. Centrumix.com.mx" 
                                            title="Please enter Warehouse Name"
                                                MaxLength="50" onkeypress="AlphaNumericOnly(event);clearErrorMessage();"></asp:TextBox>
                                        </div>                        
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Location Name <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:DropDownList ID="ddlWarehouseLocation" runat="server"
                                                CssClass="form-control m-b" title="Please select a Warehouse from dropdown"
                                                onchange="clearErrorMessage();">
                                                <asp:ListItem>Select Warehouse</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Zone Name <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                        <asp:DropDownList ID="ddlWarehouseZone" runat="server"
                                            CssClass="form-control m-b" title="Please select a Zone from dropdown"
                                            onchange="clearErrorMessage();">
                                            <asp:ListItem>Select Zone</asp:ListItem>
                                        </asp:DropDownList>
                                        </div>
                                    </div>
                                    <br /><br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8">
                                                <asp:Button ID="btnUpdateWarehouse" runat="server" Text="Update"
                                                    CssClass="btn btn-primary btn-register" 
                                                    OnClientClick="return editWarehouseDetails();" />
                                                <asp:Button ID="btnCancelUpdateDelete" runat="server" Text="Cancel" class="btn btn-default"
                                                OnClientClick="return clearAllControls();" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                         <div class="tble_main">
                            <table id="dtViewWarehouse">
                                <thead>
                                    <tr>
                                        <th>Warehouse Id</th>
                                        <th>Warehouse Name</th>
                                        <th>Location Name</th>
                                        <th>Zone Name</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            </div>
                        </div>
                    <div class="col-lg-12 dtViewWarehouse_footer">
                        <hr id="dtViewWarehouse_hr" />
                        <footer>
                            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                        </footer>    
                    </div>
                </div>
               </form>
            </div>


    <div class="modal fade" id="Warehouse-bx" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color: #f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size: 24px; color: #111;">Warehouse - Update</h4>
                </div>
                <div class="modal-body" style="text-align: center; font-size: 22px; color: #000;">
                    <p>Warehouse Details updated successfully</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" 
                        onclick="location.reload();">OK</button>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="RemoveWarehouse-bx" role="dialog">
        <div class="modal-dialog">
    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" style="font-size:24px;color:#111;">Remove Warehouse</h4>
                </div>
                <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
                    <p>Sure? You want to remove this Warehouse?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal" onclick="removeWarehouseDetails();">Yes</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">No</button>
                </div>
            </div>
      
        </div>
    </div>

    <div class="modal fade" id="dvWarehouseModal" role="dialog">
        <div class="modal-dialog modal-lg">
    
        <!-- Modal content-->
            <div class="modal-content bkngDtailsPOP viewBKNG">
                <div class="modal-header" style="background-color:#f0ad4ecf;">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title pm-modal">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Print Warehouse Details: #<span id="spHeaderWarehouseId"></span>
                    </h4>
                </div>
                <div class="modal-body viewBKNG-body" style="text-align: center;font-size: 22px; 
                    overflow-x: auto; position: relative;">
                    <p><strong>Please find the details of this Warehouse below:</strong></p>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="twoSETbtn">
                                <button id="btnPrintWarehouseModal" data-dismiss="modal" 
                                    onclick="return printDetails('tblWarehouseDetails');" style="margin-bottom:10px;">
                                    <i class="fa fa-print" aria-hidden="true"></i></button>
                                <button id="btnPrintPdfWarehouseModal" data-dismiss="modal" 
                                    onclick="exportToPDF('dvWarehouseModal', 'WarehouseDetails.pdf');" style="margin-bottom:10px;">
                                    <i class="fa fa-file-pdf-o" aria-hidden="true"></i></button>
                                <button id="btnPrintExcelWarehouseModal" data-dismiss="modal" 
                                    onclick="exportToExcel('tblWarehouseDetails', 'WarehouseDetails.xls');" style="margin-bottom:10px;">
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
                                                <table class="table custoFULLdet" id="tblWarehouseDetails">
                                                    <tr>
                                                        <th>Warehouse Id: </th>
                                                        <td><span id="spWarehouseId"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Warehouse Name: </th>
                                                        <td><span id="spWarehouseName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Location Name: </th>
                                                        <td><span id="spLocationName"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Zone Name: </th>
                                                        <td><span id="spZoneName"></span></td>
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

    <iframe id="txtArea1" style="display:none"></iframe>

</asp:Content>

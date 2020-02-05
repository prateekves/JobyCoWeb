<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" 
    CodeBehind="DriverPayment.aspx.cs" Inherits="JobyCoWeb.Accounting.DriverPayment"
    EnableEventValidation="false" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="/css/bootstrap-datepicker.min.css" rel="stylesheet" />
<link href="/styles/jquery.dataTables.min.css" rel="stylesheet" />
<script src="/Scripts/jquery.dataTables.min.js"></script>

<script>
    function checkFewControls()
    {
        var FromDate = $( "#<%=txtFromDate.ClientID%>" );
        var vFromDate = FromDate.val().trim();

        var ToDate = $( "#<%=txtToDate.ClientID%>" );
        var vToDate = ToDate.val().trim();

        var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css("text-align", "center");

        if ( vFromDate == "" )
        {
            vErrMsg.text( 'Please enter From Date' );
            vErrMsg.css( "display", "block" );
            FromDate.focus();
            return false;
        }

        if ( vToDate == "" )
        {
            vErrMsg.text( 'Please enter To Date' );
            vErrMsg.css( "display", "block" );
            ToDate.focus();
            return false;
        }

        return true;
    }

    function clearAllControls()
    {
        var FromDate = $( "#<%=txtFromDate.ClientID%>" );
        var ToDate = $( "#<%=txtToDate.ClientID%>" );

        var vErrMsg = $( "#<%=lblErrMsg.ClientID%>" );
        vErrMsg.text('');
        vErrMsg.css("display", "none");
        vErrMsg.css("background-color", "#ffd3d9");
        vErrMsg.css("color", "red");
        vErrMsg.css( "text-align", "center" );

        FromDate.val( '' );
        ToDate.val( '' );

        return false;
    }
</script>

<script>
        function checkUpdateRevertAmount() {
            var UpdateRevertAmount = $("#<%=txtUpdateRevertAmount.ClientID%>");

            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            var vUpdateRevertAmount = UpdateRevertAmount.val().trim();
            var fUpdateRevertAmount = 0.0;

            if ( vUpdateRevertAmount != "" )
                fUpdateRevertAmount = parseFloat( vUpdateRevertAmount );

            if ( vUpdateRevertAmount == "" )
            {
                vErrMsg.text( 'Please enter Amount for Update/Revert' );
                vErrMsg.css( "display", "block" );
                UpdateRevertAmount.focus();
                return false;
            }

            if ( fUpdateRevertAmount == 0 )
            {
                vErrMsg.text( 'Please enter Amount for Update/Revert' );
                vErrMsg.css("display", "block");
                UpdateRevertAmount.focus();
                return false;
            }

            return true;
        }

        function checkAmountReceivedDB()
        {
            var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
            vErrMsg.text('');
            vErrMsg.css("display", "none");
            vErrMsg.css("background-color", "#ffd3d9");
            vErrMsg.css("color", "red");
            vErrMsg.css("text-align", "center");

            var vAmountReceivedDB = $('#<%=txtAmountReceived.ClientID%>').val().trim();
            var fAmountReceivedDB = parseFloat( vAmountReceivedDB );

            var UpdateRevertAmount = $("#<%=txtUpdateRevertAmount.ClientID%>");
            var vUpdateRevertAmount = UpdateRevertAmount.val().trim();
            var fUpdateRevertAmount = 0.0;

            if ( vUpdateRevertAmount != "" )
                fUpdateRevertAmount = parseFloat( vUpdateRevertAmount );

            if ( vUpdateRevertAmount == "" )
            {
                vErrMsg.text( 'Please enter for Update/Revert' );
                vErrMsg.css( "display", "block" );
                UpdateRevertAmount.focus();
                return false;
            }

            if ( fUpdateRevertAmount == 0 )
            {
                vErrMsg.text( 'Please enter for Update/Revert' );
                vErrMsg.css( "display", "block" );
                UpdateRevertAmount.focus();
                return false;
            }

            if ( fAmountReceivedDB == 0 )
            {
                vErrMsg.text( 'No Amount can be reverted as this Driver has not received any amount yet' );
                vErrMsg.css( "display", "block" );
                UpdateRevertAmount.focus();
                return false;
            }

            if ( fAmountReceivedDB < fUpdateRevertAmount )
            {
                vErrMsg.text( '£ ' + fUpdateRevertAmount.toFixed( 2 ) +
                    ' can not be reverted as this Driver has received only £ '
                    + vAmountReceivedDB );
                vErrMsg.css( "display", "block" );
                UpdateRevertAmount.focus();
                return false;
            }

            return true;
        }

        function clearUpdateRevertAmount() {
            var vUpdateRevertAmount = $("#<%=txtUpdateRevertAmount.ClientID%>");

            clearErrorMessage();

            vUpdateRevertAmount.val( '' );
            reloadAllDriverPayments();

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
        $( '#dvDriverPaymentDisbursementDetails' ).css( 'display', 'none' );
        getAllDriverPayments();

        $( '#<%=txtFromDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

        $( '#<%=txtToDate.ClientID%>' ).datepicker( {
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            autoclose: true
        });

    } );
</script>

<script>
    function getAllDriverPayments()
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "DriverPayment.aspx/GetAllDriverPayments",
            success: function (result) {
                var jsonDriverPayments = JSON.parse( result.d );
                $( '#dtDriverPayment' ).DataTable( {
                    data: jsonDriverPayments,
                    columns: [
                        { data: "PaymentId" },
                        { data: 'DriverName' },
                        { data: 'DriverType' },
                        { data: 'WageType' },
                        {
                            data: 'ExpectedAmount',
                            render: function(ExpectedAmount) {
                                return roundOffDecimalValue( ExpectedAmount );
                            }
                        },
                        {
                            data: 'AmountReceived',
                            render: function ( AmountReceived )
                            {
                                return roundOffDecimalValue( AmountReceived );
                            }
                        },
                        {
                            data: 'Discrepancy',
                            render: function ( Discrepancy )
                            {
                                return roundOffDecimalValue( Discrepancy );
                            }
                        },
                        { defaultContent: "<button class='btn btn-warning'>Pay</button>" }
                    ],
                    "columnDefs": [
                        {
                            "targets": [0],
                            "visible": false,
                            "searchable": false
                        }
                    ],
                    "bDestroy": true
                } );
            },
            error: function ( response )
            {
                alert( 'Unable to Bind all Driver Payments' );
            }
        } );

        $( '#dtDriverPayment tbody' ).on( 'click', 'button', function ()
        {
            var vClosestTr = $( this ).closest( "tr" );

            //Getting Current Page Number
            var tblDriverPayment = $( '#dtDriverPayment' ).DataTable();
            var vPageInfo = tblDriverPayment.page.info();
            var iPageIndex = vPageInfo.page;
            var iPageNumber = iPageIndex + 1;
            //alert( 'Page No: ' + iPageNumber );

            //Getting Current Number of Pages
            var iPageLength = tblDriverPayment.page.len();            
            //alert( 'Number of Pages: ' + iPageLength );

            var vIndex = vClosestTr.index();

            //Getting Resultant Index
            var iTotalIndex = iPageLength * iPageIndex;
            var vResultIndex = iTotalIndex + vIndex;
            //alert( 'Result Index: ' + vResultIndex );

            var vPaymentId = tblDriverPayment.column( 0 ).data()[vResultIndex];

            var vDriverName = vClosestTr.find( 'td' ).eq( 0 ).text();
            var vDriverType = vClosestTr.find( 'td' ).eq( 1 ).text();
            var vWageType = vClosestTr.find( 'td' ).eq( 2 ).text();

            var vExpectedAmount = vClosestTr.find( 'td' ).eq( 3 ).text();
            var vAmountReceived = vClosestTr.find( 'td' ).eq( 4 ).text();
            var vDiscrepancy = vClosestTr.find( 'td' ).eq( 5 ).text();

            getCreditDebitNote(vPaymentId);
            getAmountReceived( vPaymentId );

            //Populate all the values for Payment Update
            //=======================================================
            $( '#<%=hfPaymentId.ClientID%>' ).val( vPaymentId );

            $( '#<%=txtDriverName.ClientID%>' ).val( vDriverName );
            $( '#<%=txtDriverType.ClientID%>' ).val( vDriverType );
            $( '#<%=txtWageType.ClientID%>' ).val( vWageType );

            $( '#<%=txtExpectedAmount.ClientID%>' ).val( vExpectedAmount.replace('£ ', '' ));
            $( '#<%=txtAmountReceived.ClientID%>' ).val( vAmountReceived.replace( '£ ', '' ) );
            $( '#<%=txtDiscrepancy.ClientID%>' ).val( vDiscrepancy.replace( '£ ', '' ) );

            //Make appear Edit Particular Payment Details
            //====================================================
            $( '#dvDriverPaymentDisbursementDetails' ).css( 'display', 'block' );
            $( '#dvDriverPaymentDisbursementDetails' ).css( 'margin-left', '100px' );
            //====================================================

            //Make disappear View All Payment Details 
            //=======================================================
            $( '#dvDriverPaymentSearchDetails' ).css( 'display', 'none' );
            //=======================================================

            /*var fExpectedAmount = parseFloat( vExpectedAmount.replace( '£ ', '' ) );
            var fAmountReceived = parseFloat( vAmountReceived.replace( '£ ', '' ) );
            var fDiscrepancy = parseFloat( vDiscrepancy.replace( '£ ', '' ) );

            if ( fAmountReceived < fExpectedAmount )
            {
            }
            else
            {
                $( '#spFullName' ).text( vDriverName + "'s No Payment Remaining.. No Discrepancy" );
                $( '#Driver-bx' ).modal( 'show' );
            }*/

            return false;
        } );

        return false;
    }
</script>

<script>
    function reloadAllDriverPayments()
    {
        location.href = '/Accounting/DriverPayment.aspx';
    }

    function getCreditDebitNote( PaymentId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "DriverPayment.aspx/GetCreditDebitNote",
            data: "{ PaymentId: '" + PaymentId + "'}",
            success: function ( result )
            {
                $('#<%=txtCreditDebitNote.ClientID%>').val(result.d);
            },
            error: function ( response )
            {
                alert( 'Unable to get Credit Debit Note' );
            }
        } );
    }

    function getAmountReceived( PaymentId )
    {
        $.ajax( {
            method: "POST",
            contentType: "application/json; charset=utf-8",
            url: "DriverPayment.aspx/GetAmountReceived",
            data: "{ PaymentId: '" + PaymentId + "'}",
            success: function ( result )
            {
                $('#<%=txtAmountReceived.ClientID%>').val(result.d);
            },
            error: function ( response )
            {
                alert( 'Unable to get Amount Received' );
            }
        } );
    }

    function updateDriverPaymentDetails()
    {
        //Updating Driver Payment Details
        var PaymentId = $("#<%=hfPaymentId.ClientID%>").val().trim();
        var DriverName = $( '#<%=txtDriverName.ClientID%>' ).val().trim();
        var AmountReceived = $( '#<%=txtUpdateRevertAmount.ClientID%>' ).val().trim();
        var CreditDebitNote = $( '#<%=txtCreditDebitNote.ClientID%>' ).val().trim();

        //Binding Driver Payment Details to object
        var objDriverPayment = {};

        objDriverPayment.PaymentId = PaymentId;
        objDriverPayment.AmountReceived = AmountReceived;
        objDriverPayment.CreditDebitNote = CreditDebitNote;

        $.ajax({
            type: "POST",
            url: "DriverPayment.aspx/UpdateDriverPaymentDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objDriverPayment),
            dataType: "json",
            success: function (result) {
                $( '#spFullName' ).text( DriverName + "'s Details updated successfully" );
                $( '#Driver-bx' ).modal( 'show' );
            },
            error: function ( response )
            {
                alert( 'Unable to Update Driver Payment Details' );
            }
        });

        return false;
    }

    function editDriverPaymentDetails()
    {
        if ( checkUpdateRevertAmount() )
        {
            updateDriverPaymentDetails();
        }

        return false;
    }

    function reverseDriverPaymentDetails()
    {
        //Updating Driver Payment Details
        var PaymentId = $("#<%=hfPaymentId.ClientID%>").val().trim();
        var DriverName = $( '#<%=txtDriverName.ClientID%>' ).val().trim();
        var AmountReceived = $( '#<%=txtUpdateRevertAmount.ClientID%>' ).val().trim();
        var CreditDebitNote = $( '#<%=txtCreditDebitNote.ClientID%>' ).val().trim();

        //Binding Driver Payment Details to object
        var objDriverPayment = {};

        objDriverPayment.PaymentId = PaymentId;
        objDriverPayment.AmountReceived = AmountReceived;
        objDriverPayment.CreditDebitNote = CreditDebitNote;

        $.ajax({
            type: "POST",
            url: "DriverPayment.aspx/RevertDriverPaymentDetails",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(objDriverPayment),
            dataType: "json",
            success: function (result) {
                $( '#spFullName' ).text( DriverName + "'s Details reverted successfully" );
                $( '#Driver-bx' ).modal( 'show' );
            },
            error: function ( response )
            {
                alert( 'Unable to Revert Driver Payment Details' );
            }
        });

        return false;
    }

    function revertDriverPaymentDetails()
    {
        if ( checkAmountReceivedDB() )
        {
            reverseDriverPaymentDetails();
        }

        return false;
    }
</script>

<script>
    function showSpecificDriverPayments()
    {
        if ( checkFewControls() )
        {
            var FromDate = $( "#<%=txtFromDate.ClientID%>" ).val().trim();
            var ToDate = $( "#<%=txtToDate.ClientID%>" ).val().trim();

            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "DriverPayment.aspx/GetSpecificDriverPayments",
                data: "{ FromDate: '" + FromDate + "', ToDate: '" + ToDate + "'}",
                success: function ( result )
                {
                    var jsonDriverPayments = JSON.parse( result.d );
                    $( '#dtDriverPayment' ).DataTable( {
                        data: jsonDriverPayments,
                        columns: [
                            { data: "PaymentId" },
                            { data: 'DriverName' },
                            { data: 'DriverType' },
                            { data: 'WageType' },
                            {
                                data: 'ExpectedAmount',
                                render: function ( ExpectedAmount )
                                {
                                    return roundOffDecimalValue( ExpectedAmount );
                                }
                            },
                            {
                                data: 'AmountReceived',
                                render: function ( AmountReceived )
                                {
                                    return roundOffDecimalValue( AmountReceived );
                                }
                            },
                            {
                                data: 'Discrepancy',
                                render: function ( Discrepancy )
                                {
                                    return roundOffDecimalValue( Discrepancy );
                                }
                            },
                            { defaultContent: "<button class='btn btn-warning'>Pay</button>" }
                        ],
                        "columnDefs": [
                            {
                                "targets": [0],
                                "visible": false,
                                "searchable": false
                            }
                        ],
                        "bDestroy": true
                    } );
                },
                error: function ( response )
                {
                    alert( 'Unable to Bind Specific Driver Payments' );
                }
            } );//end of ajax
        }

        return false;
    }

</script>

<script>
    function checkFromAndToDate( vFromDate, vToDate )
    {
        var vErrMsg = $("#<%=lblErrMsg.ClientID%>");
        vErrMsg.text('');
        vErrMsg.css("display", "none");

        if ( vFromDate != "" && vToDate != "" )
        {
            var dt1 = parseInt( vFromDate.substring( 0, 2 ), 10 );
            var mon1 = parseInt( vFromDate.substring( 3, 5 ), 10 );
            var yr1 = parseInt( vFromDate.substring( 6, 10 ), 10 );

            var dt2 = parseInt( vToDate.substring( 0, 2 ), 10 );
            var mon2 = parseInt( vToDate.substring( 3, 5 ), 10 );
            var yr2 = parseInt( vToDate.substring( 6, 10 ), 10 );

            var stDate = new Date( yr1, mon1, dt1 );
            var enDate = new Date( yr2, mon2, dt2 );
            var diff_date = enDate - stDate;

            var years = Math.floor( diff_date / 31536000000 );
            var months = Math.floor(( diff_date % 31536000000 ) / 2628000000 );
            var days = Math.floor(( ( diff_date % 31536000000 ) % 2628000000 ) / 86400000 );

            //alert(years + " year(s) " + months + " month(s) " + days + " day(s)");

            if ( years < 0 )
            {
                vErrMsg.text( 'Payment Date should be earlier than Current Date' );
                vErrMsg.css( "display", "block" );
                return false;
            }
            else
            {
                if ( months < 0 )
                {
                    vErrMsg.text( 'Payment Date should be earlier than Current Date' );
                    vErrMsg.css( "display", "block" );
                    return false;
                }
                else
                {
                    if ( days < 0 )
                    {
                        vErrMsg.text( 'Payment Date should be earlier than Current Date' );
                        vErrMsg.css( "display", "block" );
                        return false;
                    }
                }
            }
        }
    }

    function checkPaymentDate(vPaymentDate)
    {
        //Date Checking Added on Text Change
        var vCurrentDate = getCurrentDateDetails();
        checkFromAndToDate( vPaymentDate, vCurrentDate );
    }

</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    Driver Payment
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 col-md-offset-2">
                <div class="hpanel">
                 <form id="frmDriverPayment" runat="server">
                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>

                            <asp:HiddenField ID="hfPaymentId" runat="server" />                            
                            <asp:HiddenField ID="hfAmountReceived" runat="server" />                            
                    </div>
                    <div class="panel-body clrBLK col-md-10 dashboad-form">
                        <div id="dvDriverPaymentDisbursementDetails" style="margin-left: 100px;">
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Driver Name </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtDriverName" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. Tom"
                                                onkeypress="clearErrorMessage();" ReadOnly="true"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Driver Type </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtDriverType" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. Direct Payroll"
                                                onkeypress="clearErrorMessage();" ReadOnly="true"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Wage Type </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtWageType" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. Monthly"
                                                onkeypress="clearErrorMessage();" ReadOnly="true"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Expected Amount </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtExpectedAmount" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. 2000"
                                                onkeypress="clearErrorMessage();" ReadOnly="true"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Amount Received </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtAmountReceived" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. 1000" title="Please enter Amount"
                                                onkeypress="DecimalOnly(event);clearErrorMessage();" ReadOnly="true"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Discrepancy </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtDiscrepancy" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. 500"
                                                onkeypress="clearErrorMessage();" ReadOnly="true"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Enter Amount for Update/Revert <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtUpdateRevertAmount" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. 500"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">Credit / Debit Note </label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtCreditDebitNote" runat="server" MaxLength="50"
                                                CssClass="form-control"  PlaceHolder="e.g. 50 Extra"
                                                onkeypress="clearErrorMessage();"></asp:TextBox>                            
                                        </div>
                                        <br />
                                    </div>
                                    <br />
                                </div>
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8">
                                            <asp:Button ID="btnUpdateDriverPayment" runat="server" 
                                                Text="Update" CssClass="btn btn-primary btn-register" 
                                                OnClientClick="return editDriverPaymentDetails();" />
                                            <asp:Button ID="btnCancelUpdateDriverPayment" runat="server" 
                                                Text="Cancel" CssClass="btn btn-default"
                                                OnClientClick="return clearUpdateRevertAmount();" />
                                            <asp:Button ID="btnRevertDriverPayment" runat="server" 
                                                Text="Revert" CssClass="btn btn-primary btn-register" 
                                                OnClientClick="return revertDriverPaymentDetails();" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                        <div id="dvDriverPaymentSearchDetails" class="row">
                            <div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">From Date <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onkeypress="clearErrorMessage();"
                                                onchange="checkPaymentDate(this.value);"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group"><label class="col-sm-4 control-label">To Date <span style="color: red">*</span></label>
                                        <div class="col-sm-8">
                                            <asp:TextBox ID="txtToDate" runat="server" CssClass="clrBLK form-control"
                                                ReadOnly="true" onkeypress="clearErrorMessage();"
                                                onchange="checkPaymentDate(this.value);"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <!--Added new Script Files for Date Picker-->
                                <script src="/js/bootstrap-datepicker.js"></script>
                                <script src="/js/locales/bootstrap-datetimepicker.fr.js"></script>
                                <div class="row">
                                    <div class="form-group">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-8">
                                            <asp:Button ID="btnShowSpecificPayments" runat="server" Text="Show"
                                                CssClass="btn btn-primary btn-register" 
                                                OnClientClick="return showSpecificDriverPayments();" />
                                                <asp:Button ID="btnCancelPaymentForm" runat="server" Text="Cancel" 
                                                CssClass="btn btn-default"
                                                OnClientClick="location.reload();" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-12" style="margin-left: 570px;">
                                <asp:Button ID="btnExportDriverPaymentPDF" runat="server"  
                                    class="btn btn-info aa-add-row" 
                                    Text="Export To PDF" OnClick="btnExportPdf_Click" />

                                <asp:Button ID="btnExportDriverPaymentExcel" runat="server"  
                                    class="btn btn-info aa-add-row" 
                                    Text="Export To Excel" OnClick="btnExportExcel_Click" />
                            </div>

                            <table id="dtDriverPayment">
                                <thead>
                                    <tr>
                                        <th>Payment Id</th>
                                        <th>Driver Name</th>
                                        <th>Driver Type</th>
                                        <th>Wage Type</th>
                                        <th>Expected Amount</th>
                                        <th>Amount Received</th>
                                        <th>Discrepancy</th>
                                        <th>Make Payment</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                    </div>
                    <div class="col-md-10">
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
  <div class="modal fade" id="Driver-bx" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="background-color:#f0ad4ecf;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title" style="font-size:24px;color:#111;">Driver Payment Details</h4>
        </div>
        <div class="modal-body" style="text-align: center;font-size: 22px; color: black;">
          <p><span id="spFullName"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="return reloadAllDriverPayments();">OK</button>
        </div>
      </div>
      
    </div>
  </div>

</asp:Content>

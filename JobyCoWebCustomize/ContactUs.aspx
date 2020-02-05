<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoForOthers.Master" AutoEventWireup="true" 
    CodeBehind="ContactUs.aspx.cs" Inherits="JobyCoWebCustomize.ContactUs"
    EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $( document ).ready( function ()
        {
            getLatestContactId();

            $( "#ContactUs" ).addClass( "active" );
        } );
    </script>

    <script>
        function clearErrorMessage()
        {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");
        }

        function checkBlankTextBoxes()
        {
            var ErrMsg = $("#<%=lblErrMsg.ClientID%>");
            ErrMsg.text('');
            ErrMsg.css("display", "none");

            var ContactTitle = $( '#ddlContactTitle' );
            var vContactTitle = ContactTitle.find( 'option:selected' ).text().trim();
            if ( vContactTitle == "Select Title" )
            {
                ErrMsg.text( 'Please select a Title' );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css( "text-align", "center" );
                ErrMsg.css( "display", "block" );
                ContactTitle.focus();
                return false;
            }

            var ContactFirstName = $( '#txtContactFirstName' );
            var vContactFirstName = ContactFirstName.val().trim();

            if ( vContactFirstName == "" )
            {
                ErrMsg.text( 'Please enter First Name' );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css( "text-align", "center" );
                ErrMsg.css( "display", "block" );
                ContactFirstName.focus();
                return false;
            }

            var ContactLastName = $( '#txtContactLastName' );
            var vContactLastName = ContactLastName.val().trim();

            if ( vContactLastName == "" )
            {
                ErrMsg.text( 'Please enter Last Name' );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css( "text-align", "center" );
                ErrMsg.css( "display", "block" );
                ContactLastName.focus();
                return false;
            }

            var ContactEmail = $( '#txtContactEmail' );
            var vContactEmail = ContactEmail.val().trim();

            if ( vContactEmail == "" )
            {
                ErrMsg.text( 'Please enter Email Id' );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css( "text-align", "center" );
                ErrMsg.css( "display", "block" );
                ContactEmail.focus();
                return false;
            }

            if ( !IsEmail( vContactEmail ) )
            {
                ErrMsg.text( 'Invalid Email Id' );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css( "text-align", "center" );
                ErrMsg.css( "display", "block" );
                ContactEmail.focus();
                return false;
            }

            var ContactComments = $( '#txtContactComments' );
            var vContactComments = ContactComments.val().trim();

            if ( vContactComments == "" )
            {
                ErrMsg.text( 'Please make your remark' );
                ErrMsg.css( "background-color", "#f9edef" );
                ErrMsg.css( "color", "red" );
                ErrMsg.css( "text-align", "center" );
                ErrMsg.css( "display", "block" );
                ContactComments.focus();
                return false;
            }

            return true;
        }

    </script>

    <script>
        function getLatestContactId()
        {
            $.ajax( {
                method: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ContactUs.aspx/GetLatestContactId",
                data: "{}",
                success: function ( result )
                {
                    $('#<%=hfContactId.ClientID%>').val(result.d);
                },
                error: function ( response )
                {
                    alert( 'Unable to Get Latest Contact Id' );
                }
            } );

            return false;
        }

        function addContactDetails()
        {
            var ContactId = $( '#<%=hfContactId.ClientID%>' ).val().trim();
            var ContactTitle = $( '#ddlContactTitle' ).find( 'option:selected' ).text().trim();
            var ContactFirstName = $('#txtContactFirstName').val().trim();
            var ContactLastName = $('#txtContactLastName').val().trim();
            var ContactEmail = $('#txtContactEmail').val().trim().toLowerCase();
            var ContactComments = $('#txtContactComments').val().trim();

            objContactDetails = {};

            objContactDetails.ContactId = ContactId;
            objContactDetails.ContactTitle = ContactTitle;
            objContactDetails.ContactFirstName = ContactFirstName;
            objContactDetails.ContactLastName = ContactLastName;
            objContactDetails.ContactEmail = ContactEmail;
            objContactDetails.ContactComments = ContactComments;

            $.ajax( {
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "ContactUs.aspx/AddContactDetails",
                data: JSON.stringify(objContactDetails),
                dataType: "json",
                success: function ( result )
                {
                    $( '#AddContactDetails-bx' ).modal( 'show' );
                },
                error: function ( response )
                {
                    alert('Unable to Add Contact Details');
                }
            } );

            return false;
        }

        function saveContactDetails()
        {
            if ( checkBlankTextBoxes() )
            {
                addContactDetails();
            }

            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 
<div class="inner_ban">
    <figure>
        <img src="/images/contact-us.jpg" alt="" class="img-responsive" />
    </figure>	
</div>	

<section class="innr_cntnt cntctFRMsec">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="abt-cnt-BG" style="display:inline-block;">
                	<h1>Contact Us Via Email</h1>
                    <div id="contact-us">
                        <div class="row">
                            <asp:Label ID="lblErrMsg" CssClass="ErrMsg" BackColor="#f9edef"
                            Style="text-align: center; vertical-align: middle; width: 500px; 
                            line-height: 30px; border-radius: 0px; padding: 0px; border: 1px solid red;"
                            runat="server" Text="" Font-Size="Small"></asp:Label>
                            
                            <asp:HiddenField ID="hfContactId" runat="server" />

                            <div class="col-md-3 col-xs-12">
                                <label class="control-label" for="contact-title">Your Name <span style="color: red">*</span>:</label>
                            </div>
                            <div class="col-md-2 col-xs-5">
                                <select id="ddlContactTitle" name="contact-title" 
                                    class="form-control" onchange="clearErrorMessage();">
                                    <option>Select Title</option>
                                    <option>Mr</option>
                                    <option>Mrs</option>
                                    <option>Miss</option>
                                    <option>Ms</option>
                                    <option>Dr</option>
                                </select>
                            </div>
                            <div class="col-md-3 col-xs-12">
                                <div class="row">
                                    <input id="txtContactFirstName" name="contact-forename" 
                                        placeholder="First Name" class="form-control" 
                                        type="text" 
                                        onkeypress="CharacterOnly(event);clearErrorMessage();"/>
							    </div>
                            </div>
                            <div class="col-md-4 col-xs-12">
                                <input id="txtContactLastName" name="contact-surname" 
                                    placeholder="Last Name" class="form-control" 
                                    type="text" 
                                    onkeypress="CharacterOnly(event);clearErrorMessage();"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="row">
								<div class="form-group">
									<div class="col-md-3 col-xs-12">
										<label class="control-label" for="email">Your Email <span style="color: red">*</span>:</label>
									</div>
									<div class="col-md-9 col-xs-12">
										<input id="txtContactEmail" name="email" placeholder="Your@email.com" 
											class="form-control" type="email" style="text-transform: lowercase;"
											onkeypress="clearErrorMessage();"/>
									</div>
								</div>
                            </div>

							<div class="row">
								<div class="form-group">
									<div class="col-md-3 col-xs-12">
										<label class="control-label" for="comments">Your Message:</label>
									</div>
									<div class="col-md-9 col-xs-12">
										<textarea id="txtContactComments" name="comments" 
											class="form-control" 
											onkeypress="clearErrorMessage();"></textarea>
									</div>
								</div>
							</div>

							<div class="row">
								<div class="col-md-3"></div>
								<div class="col-md-9">
									<button id="btnSend" type="button" class="btn btn-success" 
										onclick="return saveContactDetails();">
										<span class="fa fa-envelope-o gi-pad-right"></span> Send</button>
								</div>                                    
							</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="abt-cnt-BG adrsSEC">
                	<h1>Contact Us Directly </h1>
                    <p>While we prefer to be contacted via the form, 
                        we can be contacted by phone or snail mail.</p>

                        <div class="row">
                            <div class="col-sm-6 col-xs-12">
                                <address>
                                    <strong><img class="country-flag" src="/images/gb.png" align="UK Flag Icon" alt=""/> UK Customer Services</strong><br />
                                    <a href="https://jobycodirect.com/">www.jobycodirect.com</a><br />
                                    194 Camford Way, <br />
                                    Luton, <br />
                                    Bedfordshire, <br />
                                    LU3 3AN
                                </address>
                                <strong class="phone-number"><a href="tel:01582574569"><i class="fa fa-phone-square" aria-hidden="true"></i> 01582 574 569</a></strong>
                            </div>
                        </div>
                        <hr style="border-top: 1px solid rgba(252,163,17,1);" />
                        <div class="row">
                            <div class="col-sm-6 col-xs-12">
                                <address>
                                    <strong>
                                    <img class="country-flag" src="/images/gh.png" align="Ghana Flag Icon" alt=""/> Accra Office, Ghana</strong><br />
                                    Oyibi Lorm Nava junction, <br />
                                    Dodowa Road, <br />
                                    Ghana, <br />
                                </address>
                                <strong class="phone-number">
                                	<a href="tel:0244234285"><i class="fa fa-phone-square" aria-hidden="true"></i> 0244 234 285</a>
								</strong><br />
                                <strong class="phone-number">
                                	<a href="tel:0544358918"><i class="fa fa-phone-square" aria-hidden="true"></i> 0544 358 918</a>
								</strong><br />
                                <strong class="phone-number">
                                	<a href="tel:0544358919"><i class="fa fa-phone-square" aria-hidden="true"></i> 0544 358 919</a>
								</strong>
                            </div>
                            <div class="col-sm-6 col-xs-12">
                                <address>
                                    <strong>
                                    	<img class="country-flag" src="/images/gh.png" align="Ghana Flag Icon" alt=""/> Kumasi Office, Ghana
                                    </strong><br />
                                    PLT No5 BLKJ, <br />
                                    New Tafo Nhyiaso, <br />
                                    Ghana, <br />
                                </address>
                                <strong class="phone-number"><a href="tel:0322021778"><i class="fa fa-phone-square" aria-hidden="true"></i> 0322 021 778</a></strong>
                            </div>
                        </div>                        
                </div>
            </div>
        </div>
    </div>        
</section>
<footer>
    <div class="container">
        <div class="row">	
            <div class="col-md-6">
                <h5>about us</h5>
                <ul>
                    <li><a href="#">Introducing Jobyco</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Careers</a></li>
                </ul>
            </div>
                
            <div class="col-md-6">
                <h5>Our Website</h5>
                <ul>
                    <li><a href="#">Terms & Conditions</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Cookie Policy</a></li>
                    <li><a href="#">Prohibited Items</a></li>
                    <li><a href="#">Our Mission</a></li>
				</ul>
            </div>
        </div>
    </div>
</footer>
<div class="modal fade" id="AddContactDetails-bx" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header" style="background-color: #f0ad4ecf;">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title" style="font-size: 24px; color: #111;">Addition Successful</h4>
            </div>
            <div class="modal-body" style="text-align: center; font-size: 22px;">
                <p>Your Contact Details saved successfully</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="location.reload();">OK</button>
            </div>
        </div>

    </div>
</div>

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoForOthers.Master" AutoEventWireup="true" CodeBehind="FAQs.aspx.cs" Inherits="JobyCoWebCustomize.FAQs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            $("#FAQs").addClass("active");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="inner_ban">
    <figure>
        <img src="/images/helpBG.jpg" alt="" class="img-responsive" />
    </figure>	
</div>
    	
    <section class="innr_cntnt">
    	<div class="container">
        	<div class="row">
            	<div class="col-md-12">
                	<div class="abt-cnt-BG helpSEC">
                    	<h1>Customer Help Centre</h1>
                        
                        <h2>What can we help you with?</h2>
                        <p>If you can't find what you are looking for on our website, please get in touch - we are always happy to help.</p>
                    </div>
                </div>
            </div>
        	<div class="row">
            	<div class="col-md-12">
                	<h2 class="faqTittle">Most Frequently Asked Questions</h2>
                    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="headingOne">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                        How do I book a collection? Do I need to register?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                <div class="panel-body">
                                      Yes, to book a collection online, you will need to register. It is quick and easy and will take less than two minutes.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="headingTwo">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                       What types of services does Jobyco provide? Do you provide express services?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                <div class="panel-body">
                                    We provide Door to Door shipping from the UK to Ghana which takes between 3 – 6 weeks. We also provide Air freight services which take 5 working days, but your recipient will need to collect from Kotoka Airport and pay any due duty.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="headingThree">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        Where can I find your prices for items?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                <div class="panel-body">
                                    On our website or call our dedicated customer service team
                                </div>
                            </div>
                        </div>
                
                		<div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading4">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse4" aria-expanded="false" aria-controls="collapse6">
                                       Do you provide packaging?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse4" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading4">
                                <div class="panel-body">
                                   Yes, we do. We sell boxes, drums and tapes.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading5">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse5" aria-expanded="false" aria-controls="collapse5">
                                        Can I use my own packaging?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse5" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading5">
                                <div class="panel-body">
                                    Yes you can, although we recommend using our Jobyco branded packaging as they are firm, strong and secure.
                                </div>
                            </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading6">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse6" aria-expanded="false" aria-controls="collapse6">
                                      How do I change or cancel a booking request?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse6" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading6">
                                <div class="panel-body">
                                   We cover about 95 percent of Ghana.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading7">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse7" aria-expanded="false" aria-controls="collapse7">
                                        Are there maximum weight and size limits for a parcel?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse7" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading7">
                                <div class="panel-body">
                                    Yes there are. Please call our dedicated team of customer services personnel on <strong><em>01582 574569</em></strong> to answer any queries you may have regarding size limits.
                                </div>
                            </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading8">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse8" aria-expanded="false" aria-controls="collapse6">
                                      Are there any prohibited items I cannot send through Jobyco?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse8" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading8">
                                <div class="panel-body">
                                	Yes there are, for a full and comprehensive list please see our Prohibited Items List.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading9">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse9" aria-expanded="false" aria-controls="collapse9">
                                        Does my recipient need to pay anything when the goods arrive in Ghana?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse9" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading9">
                                <div class="panel-body">
                                    No, they will not be charged for anything. They just need to receive and enjoy.
                                </div>
                            </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading10">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse10" aria-expanded="false" aria-controls="collapse10">
                                      Does my recipient need to pay anything when the goods arrive in Ghana?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse10" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading10">
                                <div class="panel-body">
                                	No, they will not be charged for anything. They just need to receive and enjoy.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading11">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse11" aria-expanded="false" aria-controls="collapse11">
                                       Will my parcel be opened for inspection?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse11" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading11">
                                <div class="panel-body">
                                   The customs reserve the right to examine our container at any time.
                                </div>
                            </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading12">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse12" aria-expanded="false" aria-controls="collapse12">
                                      Is my consignment covered by insurance?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse12" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading12">
                                <div class="panel-body">
                                	Yes we offer insurance from £25.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading13">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse13" aria-expanded="false" aria-controls="collapse13">
                                       Can I track the status and location of my shipment?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse13" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading13">
                                <div class="panel-body">
                                   Yes you can via our Customer Portal.
                                </div>
                            </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading14">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse14" aria-expanded="false" aria-controls="collapse14">
                                      What should I do if my consignment is damaged on arrival in Ghana?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse14" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading14">
                                <div class="panel-body">
                                	We have a complaints form which can be found <a href="#">here</a>.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading15">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse15" aria-expanded="false" aria-controls="collapse15">
                                       Within what time frame do I have to report a lost or damaged item??
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse15" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading15">
                                <div class="panel-body">
                                   All items have to be inspected before signing the delivery note.
                                </div>
                            </div>
                        </div>
                        
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading16">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse16" aria-expanded="false" aria-controls="collapse16">
                                      How long does it take for my goods to arrive in Ghana?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse16" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading16">
                                <div class="panel-body">
                                	How long your shipment arrives at the final destination in Ghana depends on the picking date in the Uk. Usually all items are distributed to the receipient's home in Ghana within four weeks from the picking date.
                                </div>
                            </div>
                        </div>
                
                        <div class="panel panel-default">
                            <div class="panel-heading" role="tab" id="heading17">
                                <h4 class="panel-title">
                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse17" aria-expanded="false" aria-controls="collapse17">
                                      	How do we pack our things so that they don't get damaged?
                                    </a>
                                </h4>
                            </div>
                            <div id="collapse17" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading17">
                                <div class="panel-body">
                                   At Jobyco we do our best to bring your packages in an intact condition at their final destination. We however advice our customers whenever possible to use boxes and packaging materials that are in good condition.<br/>
If you must reuse a box, please make sure it is in an excellent condition with no holes, tears, rips or corner damage and that all flaps are intact.
                                </div>
                            </div>
                        </div>
                
                    </div><!-- panel-group -->
            	</div>
            </div>
        </div>
	</section>

</asp:Content>

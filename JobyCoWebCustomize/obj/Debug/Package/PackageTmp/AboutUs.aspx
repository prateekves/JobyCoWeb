<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoForOthers.Master" AutoEventWireup="true" CodeBehind="AboutUs.aspx.cs" Inherits="JobyCoWebCustomize.AboutUs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            $("#AboutUs").addClass("active");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="inner_ban">
        <figure>
            <img src="/images/about_us_banner.jpg" alt="" class="img-responsive" />
        </figure>	
    </div>	
    
    <section class="innr_cntnt">
    	<div class="container">
        	<div class="row">
            	<div class="col-md-6">
                	<div class="abt-cnt-BG">
                		<h1>Introducing Jobyco</h1>
                        <p>Founded in 2002, Jobyco was birthed in response to the growing need of Ghanaians in the UK to send packages home to Ghana at affordable prices. Since its inception, Jobyco has been at the forefront of door to door shipping as a leader and a force to be reckoned with within this field. We pride ourselves in offering you our vast expertise of door to door business.</p>
						<p><strong>JOBYCO</strong> offers customers the most comprehensive coverage of most localities in the United Kingdom to any locality in Ghana With its control over the door to door service in the UK, JOBYCO can handle the shipment of most items on sea, while keeping customers informed of its status, particularly via this website.</p>
					</div>
                </div>
                
                <div class="col-md-6">
                	<div class="abt-cnt-BG">
                		<h1>Services</h1>
                        <p><strong>Sea Freight:</strong> Jobyco offers Door-to-Door Shipping from the UK to Ghana by sea. With this service, Jobyco can either supply you with the boxes or drums you need or you can use your own packaging to pack. After packing your items, Jobyco will then pickup your items from your chosen address in the UK for onwards shipping to Ghana. This service takes between 3 to 6 weeks and payments are usually made in the UK but can be made in Ghana, subject to meeting certain criteria.</p>
						<p><strong>Air Freight:</strong> With this service, we pick up your items from your chosen address in the UK and deliver to Kotoka Airport in Ghana. Your recipient will then need to pick it up from the airport and pay the necessary duty charges.</p>
					</div>
                </div>
                
                <div class="col-md-12">
                	<blockquote class="quote-box">
                      <p class="quotation-mark">
                        “
                      </p>
                      <p class="quote-text">
                        I have been using jobyco for the past five(5)years and have had no problem both from me and my recipient being my mum back home.They are reliable and the best.
                      </p>
                      <hr>
                      <div class="blog-post-actions">
                        <p class="blog-post-bottom pull-left">
                          Foster Kafui Dzakwasi
                        </p>
                        <p class="blog-post-bottom pull-right">
                          <span class="badge quote-badge">896</span>  ❤
                        </p>
                      </div>
                    </blockquote>
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

</asp:Content>

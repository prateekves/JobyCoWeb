<%@ Page Title="" Language="C#" MasterPageFile="~/JobyCoForOthers.Master" AutoEventWireup="true" CodeBehind="Careers.aspx.cs" Inherits="JobyCoWebCustomize.Careers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            $("#Careers").addClass("active");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="inner_ban">
        <figure>
            <img src="/images/careerBG.jpg" alt="" class="img-responsive" />
        </figure>	
    </div>	

    <section class="innr_cntnt">
    	<div class="container">
        	<div class="row">
            	<div class="col-md-7">
                	
					<h3>Careers with Jobyco</h3>
                    
                    <table class="rwd-table">
                    	<tr>
                        <th>Job ID</th>
                        <th>Position</th>
                        <th>Location</th>
                        <th>Job Type</th>
                        <th>Salary</th>
                      </tr>
                      <tr>
                        <td data-th="Job ID">JB-CSALTN</td>
                        <td data-th="Position">Adventure, Sci-fi</td>
                        <td data-th="Location">1977</td>
                        <td data-th="Job Type">$460,935,665</td>
                        <td data-th="Salary">$460,935,665</td>
                      </tr>
                    </table>
					
                </div>
                
                <div class="col-md-5">
                	<h3>Position in customer services</h3>
                    <input id="email-addr" class="form-control pull-right" placeholder="Your Email Address" type="text">
                    <button class="btn-email-send"><i class="fa fa-envelope pad-right"></i> Send</button>
                </div>
                
                <div class="col-md-12">
                	<p>Jobyco Limited is a shipping and logistics company seeking for a customer service personnel to join our vibrant administration team. This role is suitable for someone who has previous experience but willing to learn or gain more experience in customer service, although training will be provided. </p>
                    
                </div>
			</div>
            <hr/>
            <div class="row">
                <div class="col-md-6"> 
                    <h3>The Role is varied and the ideal candidate should:</h3>  
                    <ul class="careerList">                    	
                        <li>Be Proactive</li>
                        <li>Have excellent communication skills</li>
                        <li>Be Friendly and warm</li>
                        <li>Be able to sell products and services to customers over the telephone and face-to-face</li>
                    </ul>
                 </div>
                 
                 <div class="col-md-6">
                    <h3>Duties include but are not limited to:</h3>  
                    <ul class="careerList">                    	
                        <li>Answering calls</li>
                        <li>Meeting and greeting clients</li>
                        <li>Respond to external and internal enquiries via telephone, email and face-to- face</li>
                        <li>Using database management systems</li>
                        <li>Manage and update client records</li>
                        <li>Perform general administration tasks</li>
                        <li>Manage customer order entries</li>
                        <li>Provide customers with quotes and service knowledge</li>
                    </ul>
                </div>
            </div>
            <hr/>
                
			<div class="row">
                	<div class="col-md-12">
                	 <p>If you are hardworking, friendly and can work well in a fast-paced environment, then this role is for you.</p>
					 <h4 class="grtOpr"><strong>Great Opportunity, Apply Today!</strong></h4>

					<p>You will be required to submit a Covering Letter and CV as a ONE WORD DOCUMENT respectively for this position.</p>

					<p>Your application must address the job description and person specification (no more than 2 pages). </p>
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

<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JobyCoWeb.Dashboard1" %>

<%@ MasterType VirtualPath="~/Dashboard.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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

        getDashboardStatus();

        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            // some code..
            $("#ScanLink").attr("href", "#");
            //alert('Not PC');
        }
        else { //alert('PC'); 
        }
    });

    function getDashboardStatus()
    {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Dashboard.aspx/GetDashboardStatus",
            data: "{}",
            dataType: "json",
            success: function (result) {
                var jData = JSON.parse(result.d)
                //alert(JSON.stringify(jData));
                $("#WeeklyBooking").text(jData[0]["WeeklyBooking"]);
                $("#MonthlyBooking").text(jData[0]["MonthlyBooking"]);
                $("#TotalBooking").text(jData[0]["TotalBooking"]);

                $("#WeeklyShipping").text(jData[0]["WeeklyShipping"]);
                $("#MonthlyShipping").text(jData[0]["MonthlyShipping"]);
                $("#TotalShipping").text(jData[0]["TotalShipping"]);

                $("#WeeklyCustomer").text(jData[0]["WeeklyCustomer"]);
                $("#MonthlyCustomer").text(jData[0]["MonthlyCustomer"]);
                $("#TotalCustomer").text(jData[0]["TotalCustomer"]);
            },
            error: function (response) {
            }
        });
    }



</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <form id="msDB" runat="server">
            <asp:HiddenField ID="hfMenusAccessible" runat="server" />

            <div class="welcome-message">
            <%--<h2>Choose Your Option</h2>--%>
                </div>
            <%--<p>Welcome To Jobyco, Leaders in Parcel Delivery And Courier Services. With Jobyco, you can be assured of a company with a good track record and a long and extensive history in Door to Door shipping from the UK to Ghana</p>--%>
            
            
            <div class="accordion_sec">
            <div class="panel-group" id="accordion">
              <div class="panel panel-default animate" data-animate="fadeInUp" data-duration="1.5s" data-delay="0.1s"> 
                <div class="panel-heading">
                  <h4 class="panel-title">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse1">
                      Dashboard Menu
                    </a>
                  </h4>
                </div>
                <div id="collapse1" class="panel-collapse collapse in">
                  <div class="panel-body">
                      <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-4">
                            <div class="d_box">
                                <div class="d_img"><a href="/Booking/AddBooking.aspx"><img src="images/d_img1.jpg" alt=""></a></div>
                                <div class="d_info">
                                    <a class="d_box_heading" href="/Booking/AddBooking.aspx">New Booking</a>
                                    <div class="d_bottom_row clearfix">
                                        <div class="calendar_icon"><img src="images/calender_icon.png" alt=""></div>
                                        <div class="calendar_right">
                                            <span><strong  id="WeeklyBooking">0</strong>Week</span>
                                            <span><strong  id="MonthlyBooking">0</strong>Month</span>
                                            <span><strong  id="TotalBooking">0</strong>All Time</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-4">
                            <div class="d_box">
                                <div class="d_img"><a href="/Shipping/AddShipping.aspx"><img src="images/d_img2.jpg" alt=""></a></div>
                                <div class="d_info">
                                    <a class="d_box_heading" href="/Shipping/AddShipping.aspx">New Shipping</a>
                                    <div class="d_bottom_row clearfix">
                                        <div class="calendar_icon"><img src="images/calender_icon.png" alt=""></div>
                                        <div class="calendar_right">
                                            <span><strong id="WeeklyShipping">0</strong>Week</span>
                                            <span><strong id="MonthlyShipping">0</strong>Month</span>
                                            <span><strong id="TotalShipping">0</strong>All Time</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-4">
                            <div class="d_box">
                                <div class="d_img"><a href="/Customers/AddCustomer.aspx"><img src="images/d_img3.jpg" alt=""></a></div>
                                <div class="d_info">
                                    <a class="d_box_heading" href="/Customers/AddCustomer.aspx">New Customer</a>
                                    <div class="d_bottom_row clearfix">
                                        <div class="calendar_icon"><img src="images/calender_icon.png" alt=""></div>
                                        <div class="calendar_right">
                                            <span><strong  id="WeeklyCustomer">0</strong>Week</span>
                                            <span><strong id="MonthlyCustomer">0</strong>Month</span>
                                            <span><strong id="TotalCustomer">0</strong>All Time</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-4">
                            <div class="d_box">
                                <div class="d_img"><a href="/Booking/ScanQR.aspx"><img src="images/d_img4.jpg" alt=""></a></div>
                                <div class="d_info">
                                    <a class="d_box_heading" href="/Booking/ScanQR.aspx">Scan</a>
                                    <div class="d_bottom_row clearfix">
                                        <div class="calendar_icon"><img src="images/calender_icon.png" alt=""></div>
                                        <div class="calendar_right">
                                            <span><strong>0</strong>Week</span>
                                            <span><strong>0</strong>Month</span>
                                            <span><strong>0</strong>All Time</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                      <%--<div class="d_menu_outer">
                          <div class="d_menu_block">
                                <figure>
                                    <img src="images/img1.jpg" alt="" class="img-responsive"/>
					            </figure>
                                <div class="side_column">
                                    <span><strong id="WeeklyBooking">0</strong> Week</span>
                                    <span><strong id="MonthlyBooking">0</strong> Month</span>
                                    <span><strong id="TotalBooking">0</strong> All Time</span>
                                </div>
                                <a href="/Booking/AddBooking.aspx"><span>New Booking</span></a>
                          </div>
                          <div class="d_menu_block">
                                <figure>
                                    <img src="/images/img3.jpg" alt="" class="img-responsive"/>
					            </figure>
                                <div class="side_column">
                                    <span><strong id="WeeklyShipping">0</strong> Week</span>
                                    <span><strong id="MonthlyShipping">0</strong> Month</span>
                                    <span><strong id="TotalShipping">0</strong> All Time</span>
                                </div>
                                <a href="/Shipping/AddShipping.aspx"><span>New Shipping</span></a>
                          </div>
                          <div class="d_menu_block">
                                <figure>
                                    <img src="/images/img2.jpg" alt="" class="img-responsive"/>
					            </figure>
                                <div class="side_column">
                                    <span><strong id="WeeklyCustomer">0</strong> Week</span>
                                    <span><strong id="MonthlyCustomer">0</strong> Month</span>
                                    <span><strong id="TotalCustomer">0</strong> All Time</span>
                                </div>
                                <a href="/Customers/AddCustomer.aspx"><span>Add Customer</span></a>
                          </div>
                          <div class="d_menu_block">
                                <figure>
                                    <img src="images/img4.jpg" alt="" class="img-responsive"/>
					            </figure>
                                <div class="side_column">
                                    <span><strong>0</strong> Week</span>
                                    <span><strong>0</strong> Month</span>
                                    <span><strong>0</strong> All Time</span>
                                </div>
                                <a id="ScanLink" href="#"><span>Scan</span></a>
                          </div>
                          
                      </div>--%>
                    <%--<ul class="list">
                        <li class="list__item">
                        </li>
                        <li class="list__item">
                            <input class="radio-btn" name="choise" id="c-opt" type="radio" onclick="location.href = '/Shipping/AddShipping.aspx'; $(this).removeAttr('checked');"/>
                            <label for="b-opt" class="label">
                                <figure>
                                    <img src="/images/getQt.png" alt="" class="img-responsive"/>
					            </figure>
                                <br/>
                                <span class="labelHdng">New Shipping</span>
                                <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
				            </label>
                        </li>
                        <li class="list__item">
                            <input class="radio-btn" name="choise" id="b-opt" type="radio" onclick="location.href = '/Customers/AddCustomer.aspx'; $(this).removeAttr('checked');"/>
                            <label for="b-opt" class="label">
                                <figure>
                                    <img src="/images/getQt.png" alt="" class="img-responsive"/>
					            </figure>
                                <br/>
                                <span class="labelHdng">New Customer</span>
                                <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
				            </label>
                        </li>
                        <li class="list__item">
                            <input class="radio-btn" name="choise" id="a-opt" type="radio" onclick="location.href = '/DashboardNew.aspx'; $(this).removeAttr('checked');" />
                            <label for="a-opt" class="label">
                                <figure>
                                    <img src="/images/bokDel.png" alt="" class="img-responsive"/>
			                    </figure>
                                <br/>
                                <span class="labelHdng">Existing Customer</span>
                                <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
		                    </label>
                        </li>
                    </ul>--%>
                  </div>
                </div>
              </div>
              <div class="panel panel-default animate" data-animate="fadeInUp" data-duration="1.5s" data-delay="0.1s"> 
                <div class="panel-heading">
                  <h4 class="panel-title">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse2">
                      Google Map
                    </a>
                  </h4>
                </div>
                <div id="collapse2" class="panel-collapse collapse">
                  <div class="panel-body">
                      <div class="mapHolder">
                          <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d4944787.486200897!2d-6.81342276041096!3d52.760210894703434!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47d0a98a6c1ed5df%3A0xf4e19525332d8ea8!2sEngland%2C+UK!5e0!3m2!1sen!2sin!4v1549451525717" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>
                      </div>
                  </div>
                </div>
              </div>
              <div class="panel panel-default animate" data-animate="fadeInUp" data-duration="1.5s" data-delay="0.1s"> 
                <div class="panel-heading">
                  <h4 class="panel-title">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse3">
                      In scelerisque nibh arcu, eget euismod nisl consequat sit amet?
                    </a>
                  </h4>
                </div>
                <div id="collapse3" class="panel-collapse collapse">
                  <div class="panel-body">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris bibendum tincidunt justo quis tristique. In scelerisque nibh arcu, eget euismod nisl consequat sit amet. Maecenas tristique quam nec metus rhoncus finibus. Proin quis tellus laoreet nisi tempus porta. Aenean molestie eleifend nulla at efficitur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque ut diam in est commodo fermentum ut a purus.
                  </div>
                </div>
              </div>
              <div class="panel panel-default animate" data-animate="fadeInUp" data-duration="1.5s" data-delay="0.1s"> 
                <div class="panel-heading">
                  <h4 class="panel-title">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse4">
                      Lorem ipsum dolor sit amet, consectetur adipiscing elit?
                    </a>
                  </h4>
                </div>
                <div id="collapse4" class="panel-collapse collapse">
                  <div class="panel-body">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris bibendum tincidunt justo quis tristique. In scelerisque nibh arcu, eget euismod nisl consequat sit amet. Maecenas tristique quam nec metus rhoncus finibus. Proin quis tellus laoreet nisi tempus porta. Aenean molestie eleifend nulla at efficitur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque ut diam in est commodo fermentum ut a purus.
                  </div>
                </div>
              </div>
              <div class="panel panel-default animate" data-animate="fadeInUp" data-duration="1.5s" data-delay="0.1s"> 
                <div class="panel-heading">
                  <h4 class="panel-title">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse5">
                      Aenean molestie eleifend nulla at efficitur?
                    </a>
                  </h4>
                </div>
                <div id="collapse5" class="panel-collapse collapse">
                  <div class="panel-body">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris bibendum tincidunt justo quis tristique. In scelerisque nibh arcu, eget euismod nisl consequat sit amet. Maecenas tristique quam nec metus rhoncus finibus. Proin quis tellus laoreet nisi tempus porta. Aenean molestie eleifend nulla at efficitur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque ut diam in est commodo fermentum ut a purus.
                  </div>
                </div>
              </div>
            </div>          
        </div>




            
            <%--<ul class="list">
            <li class="list__item">
                <input class="radio-btn" name="choise" id="b-opt" type="radio" onclick="location.href = '/Customers/AddCustomer.aspx'; $(this).removeAttr('checked');"/>
                <label for="b-opt" class="label">
                    <figure>
                        <img src="/images/getQt.png" alt="" class="img-responsive"/>
					</figure>
                    <br/>
                    <span class="labelHdng">New Customer</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
				</label>
            </li>
            <li class="list__item">
                <input class="radio-btn" name="choise" id="a-opt" type="radio" onclick="location.href = '/DashboardNew.aspx'; $(this).removeAttr('checked');" />
                <label for="a-opt" class="label">
                    <figure>
                        <img src="/images/bokDel.png" alt="" class="img-responsive"/>
			        </figure>
                    <br/>
                    <span class="labelHdng">Existing Customer</span>
                    <p class="smlTxt">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
		        </label>
            </li>
        </ul>--%>
      </form>

</asp:Content>

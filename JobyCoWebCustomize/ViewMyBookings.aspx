﻿<%@ Page Title="" Language="C#" MasterPageFile="~/LoggedJobyCo.Master" AutoEventWireup="true" CodeBehind="ViewMyBookings.aspx.cs" Inherits="JobyCoWebCustomize.ViewMyBookings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script src="/js/bootstrap.js"></script>

<script>
    function showPopup() {
        //alert('Modal Popup');
        $("#dvBooking").modal('show');
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2 class="whtCLR">View My Bookings</h2>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="hpanel">
                        <div class="panel-heading">
                            <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9"
                                Style="text-align: center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                        </div>

                        <div class="panel-body clrBLK col-md-12">
                            <div class="row">
                                <div class="form-group">
                                    <div class="col-md-12" style="margin-left: -300px;">
                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnPayNow" runat="server"  
                                                Text="Pay Now" OnClick="btnPayNow_Click" />
                                            <i class="fa fa-paypal" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnExportExcelBookingDetails" runat="server"  
                                            Text="Export To Excel" OnClick="btnExportExcel_Click" />
                                            <i class="fa fa-file-excel-o" aria-hidden="true"></i>
                                        </span>

                                        <span class="iconADD pull-right">
                                            <asp:Button ID="btnExportPdfBookingDetails" runat="server"  
                                                Text="Export To PDF" OnClick="btnExportPdf_Click" />
                                            <i class="fa fa-file-pdf-o" aria-hidden="true"></i>
                                        </span>
                                    </div>
                                    <br /><br />
                                    <div style="width: 100%; margin-left: 80px;">
                                        <asp:GridView ID="gvMyBookings" runat="server" 
                                            BorderWidth="1px" CellPadding="3" 
                                            BorderStyle="None" CellSpacing="2"
                                            OnRowCommand="gvMyBookings_RowCommand"
                                            >

                                            <Columns>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:Button ID="btnViewDetails" CssClass="btn btn-Warning" runat="server" 
                                                            Text="View" CommandName="ViewDetails" CommandArgument="<%# Container.DataItemIndex %>" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>                                    
                                        </asp:GridView>
                                        
                                    </div>
                                    <br />
                                </div>
                                <br />
                            </div>
                        </div>
                </div>

             <div class="modal fade" id="dvBooking" role="dialog">
                        <div class="modal-dialog modal-lg">
    
                          <!-- Modal content-->
                          <div class="modal-content bkngDtailsPOP">
                            <div class="modal-header" style="background-color:#f0ad4ecf;">
                              <button type="button" class="close" data-dismiss="modal">&times;</button>
                              <h4 class="modal-title pm-modal">
                                  <i class="fa fa-info-circle" aria-hidden="true"></i> Order Information: 
                                  <span id="spHeaderBookingId" runat="server"></span>
                              </h4>
                            </div>
                            <div class="modal-body" style="text-align: center;font-size: 22px; overflow-x: auto;">
                                <p><strong>Please find the details of order 
                                    <span id="spBodyBookingId" runat="server"></span> below:</strong></p>
                            <div class="row">
                                <div class="col-md-12">
                                    <p class="undrLN"><strong>Customer Account Details:</strong></p>

                                    <ul class="custoDTAIL">
                                        <li><strong>Customer ID</strong><span><asp:Label ID="lblCustomerId" runat="server" Text="Customer Id"></asp:Label></span></li>
                                        <li><strong>Customer Name</strong><span><asp:Label ID="lblCustomerName" runat="server" Text="Customer Name"></asp:Label></span></li>
                                        <li><strong>Customer Mobile</strong><span><asp:Label ID="lblCustomerMobile" runat="server" Text="Customer Mobile"></asp:Label></span></li>
                                    </ul>
                                </div>

                                <div class="col-md-6">
                                    <div class="pickUPadrs">
                                        <h5>Pickup Address</h5>

                                        <p class="clnName"><strong>
                                            <asp:Label ID="lblPickupName" runat="server" Text="John Doe"></asp:Label>
                                        </strong></p>

                                        <p class="adrs-sec">
                                            <span class="icnHGT"><i class="fa fa-map-marker" aria-hidden="true"></i></span>
                                            <asp:Label ID="lblPickupAddress" runat="server" Text="123 lorem Ipsum,<br />London<br /> United Kingdom"></asp:Label>
                                        </p>

                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                            <asp:Label ID="lblPickupMobile" runat="server" Text="0321456987"></asp:Label>
                                        </p>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="pickUPadrs">
                                        <h5>Delivery Address</h5>

                                        <p class="clnName"><strong>
                                            <asp:Label ID="lblDeliveryName" runat="server" Text="John Doe"></asp:Label>
                                        </strong></p>

                                        <p class="adrs-sec">
                                            <span class="icnHGT"><i class="fa fa-map-marker" aria-hidden="true"></i></span>
                                            <asp:Label ID="lblDeliveryAddress" runat="server" Text="123 lorem Ipsum,<br />London<br /> United Kingdom"></asp:Label>
                                        </p>

                                        <p class="phSEC"><i class="fa fa-mobile" aria-hidden="true"></i> 
                                            <asp:Label ID="lblDeliveryMobile" runat="server" Text="0321456987"></asp:Label>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <p class="mntnTYM">
                                        <strong>Pickup Date and Time:
                                        <asp:Label ID="lblPickupDateTime" runat="server" 
                                            Text="Pickup Date and Time"></asp:Label>
                                       </strong>

                                    </p>
                                
                                    <p class="undrLN"><strong>Pickup:</strong></p>
                                    <asp:GridView ID="dvMyBookings" runat="server" CssClass="itemDTL">
                                    </asp:GridView>
                                    
                                    <p></p>
                                    
                                    <ul class="vatTotal">
                                        <li>
                                            <strong>VAT: 
                                            <i class="note-disclaimer italic_pound"><i> £
                                            <asp:Label ID="lblVAT" runat="server" 
                                                Text="VAT"></asp:Label>
                                                </i></i></strong>
                                        </li>
                                        <li>
                                            <strong>Order Total
                                            <i class="note-disclaimer italic_pound">(inc. vat)<i>: £
                                            <asp:Label ID="lblOrderTotal" runat="server" 
                                                Text="Order Total"></asp:Label>
                                                </i></i></strong>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            </div>
                            <div class="modal-footer">
                            </div>
                          </div>
      
                        </div>
                      </div>

            </div>
        </div>
    </div>
<script src="/js/bootstrap.js"></script>

</asp:Content>

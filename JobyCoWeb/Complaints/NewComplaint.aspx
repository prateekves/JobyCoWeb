<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.Master" AutoEventWireup="true" CodeBehind="NewComplaint.aspx.cs" Inherits="JobyCoWeb.Complaints.NewComplaint" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="content">
        <div class="row">
            <div class="col-lg-12 text-center welcome-message">
                <h2>
                    New Complaint
                </h2>
                <p></p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="hpanel">
                    <div class="panel-heading">
                        <asp:Label ID="lblErrMsg" CssClass="form-group label ErrMsg" BackColor="#ffd3d9" 
                            style="text-align:center;" runat="server" Text="" Font-Size="Small"></asp:Label>
                    </div>
                    <div class="panel-body">
                    
                        <div class="form-group"><label class="col-sm-2 control-label">New Complaint Id</label>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtComplaintId" runat="server"
                                    CssClass="form-control m-b" Enabled="false"></asp:TextBox>
                            </div>                        
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group"><label class="col-sm-2 control-label">Booking Number</label>
                            <div class="col-sm-3">
                                <asp:DropDownList ID="ddlBookingNumber" runat="server" AutoPostBack="true"
                                    CssClass="form-control m-b" title="Please select a Booking Number from dropdown"
                                    onchange="clearErrorMessage();" onmouseover="this.size=10;" onmouseout="this.size=1;"
                                     OnSelectedIndexChanged="ddlBookingNumber_SelectedIndexChanged">
                                    <asp:ListItem>Select Booking Number</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group"><label class="col-sm-2 control-label">Customer Name</label>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtCustomerName" runat="server" ReadOnly="true" 
                                    CssClass="form-control m-b" PlaceHolder="e.g. John Cusack"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>
                                            
                        <div class="form-group"><label class="col-sm-2 control-label">Complaint Source</label>
                            <div class="col-sm-3">
                                <asp:DropDownList ID="ddlComplaintSource" runat="server"
                                    CssClass="form-control m-b" onchange="clearErrorMessage();">
                                    <asp:ListItem>Select Complaint Source</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group"><label class="col-sm-2 control-label">Complaint Reason</label>
                            <div class="col-sm-3">
                                <asp:DropDownList ID="ddlComplaintReason" runat="server"
                                    CssClass="form-control m-b" onchange="clearErrorMessage();">
                                    <asp:ListItem>Select Complaint Reason</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group"><label class="col-sm-2 control-label">Complaint Status</label>
                            <div class="col-sm-3">
                                <asp:DropDownList ID="ddlComplaintStatus" runat="server"
                                    CssClass="form-control m-b" onchange="clearErrorMessage();">
                                    <asp:ListItem>Select Complaint Status</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>

                        <div class="form-group"><label class="col-sm-2 control-label">Complaint Date</label>
                            <div class="col-sm-3">
                                    <asp:TextBox ID="txtComplaintDate" runat="server" MaxLength="10" 
                                        CssClass="form-control m-b" size="23" PlaceHolder="e.g. 12/13/2001" TextMode="Date" 
                                        title="Please enter Complaint Date" onchange="clearErrorMessage();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <br />
                        </div>

                    </div>
                    <div class="panel-footer">
                        <hr/>
                        <footer>
                            <p style="text-align: center;">&copy; JobyCo - <%=DateTime.Now.Year%></p>
                        </footer>    
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

#region Required Global NameSpaces

using DataAccessLayer;
using EntityLayer;
using SecurityLayer;
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Globalization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class PaymentFailure : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                #region Checking SessionID
                string sBookingId = Request.QueryString["BookingId"].Trim();
                if (!string.IsNullOrEmpty(sBookingId))
                {
                    paymentBKD.PostBackUrl = "/ViewAllOfMyBookings.aspx?BookingId=" + sBookingId;
                }
                else
                {
                    paymentBKD.PostBackUrl = "/Dashboard.aspx";
                }
                

                BOLogin ObjLogin = new BOLogin();
                ObjLogin = (BOLogin)Session["Login"];

                if (ObjLogin == null)
                {
                    Response.Redirect("/Login.aspx");
                }
                else
                {
                    string sessionid = ObjLogin.SESSIONID;
                    if (sessionid == "")
                    {
                        Response.Redirect("/Login.aspx");
                    }
                }

                #endregion
            }
        }
    }
}
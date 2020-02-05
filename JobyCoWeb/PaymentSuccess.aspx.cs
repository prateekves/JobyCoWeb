using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

#region Required Global NameSpaces

using DataAccessLayer;
using EntityLayer;
using SecurityLayer;
using JobyCoWeb.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb
{
    public partial class PaymentSuccess : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                #region Checking SessionID
                string sBookingId = Request.QueryString["BookingId"].Trim();

                string PaymentId = string.Empty;
                string Token = string.Empty;
                string PayerId = string.Empty;
                string PayPalContactNo = string.Empty;
                string PaypalEmail = string.Empty;
                string sCustomerId = string.Empty;
                string sHaveToPay = string.Empty;

                if (Request.QueryString["sHaveToPay"] != null)
                {
                    sHaveToPay = Request.QueryString["sHaveToPay"].ToString();

                    if (Request.QueryString["paymentId"] != null
                    && Request.QueryString["token"] != null
                    && Request.QueryString["PayPalContactNo"] != null
                    && Request.QueryString["PaypalEmail"] != null
                    && Request.QueryString["sCustomerId"] != null
                    && Request.QueryString["PayerID"] != null)
                    {
                        //If it exists
                        PaymentId = Request.QueryString["paymentId"].ToString();
                        Token = Request.QueryString["token"].ToString();
                        PayerId = Request.QueryString["PayerID"].ToString();
                        PayPalContactNo = Request.QueryString["PayPalContactNo"].ToString();
                        PaypalEmail = Request.QueryString["PaypalEmail"].ToString();
                        sCustomerId = Request.QueryString["sCustomerId"].ToString();
                    }

                    objDB.UpdateOrderStatus(sBookingId, "Paid", PaymentId, PayPalContactNo, PaypalEmail, sCustomerId, sHaveToPay);
                }
                else
                {
                    if (Request.QueryString["paymentId"] != null
                    && Request.QueryString["token"] != null
                    && Request.QueryString["PayPalContactNo"] != null
                    && Request.QueryString["PaypalEmail"] != null
                    && Request.QueryString["sCustomerId"] != null
                    && Request.QueryString["PayerID"] != null)
                    {
                        //If it exists
                        PaymentId = Request.QueryString["paymentId"].ToString();
                        Token = Request.QueryString["token"].ToString();
                        PayerId = Request.QueryString["PayerID"].ToString();
                        PayPalContactNo = Request.QueryString["PayPalContactNo"].ToString();
                        PaypalEmail = Request.QueryString["PaypalEmail"].ToString();
                        sCustomerId = Request.QueryString["sCustomerId"].ToString();
                    }


                    if (!string.IsNullOrEmpty(sBookingId))
                    {
                        objDB.UpdateOrderStatus(sBookingId, "Paid", PaymentId, PayPalContactNo, PaypalEmail, sCustomerId, sHaveToPay);
                    }
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
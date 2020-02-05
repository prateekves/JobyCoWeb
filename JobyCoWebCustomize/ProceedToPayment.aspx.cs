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
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;

using System.Net;
using System.Net.Mail;
using System.Configuration;
using PayPal.Api;

#endregion

namespace JobyCoWebCustomize
{
    public partial class ProceedToPayment : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string sBookingId = Request.QueryString["BookingId"].Trim();

                //Filling up the Payment Form
                string sCustomerId = objOP.RetrieveField2FromField1("CustomerId", 
                    "OrderBooking", "BookingId", sBookingId);

                txtPayPalName.Text = objOP.GetFullNameFromCustomerId(sCustomerId);

                string sEmailID = objOP.RetrieveField2FromField1("EmailID",
                    "Customers", "CustomerId", sCustomerId);
                txtPayPalEmailId.Text = sEmailID;

                txtPayPalContactNo.Text = objOP.RetrieveField2FromField1("Mobile", 
                    "Customers", "CustomerId", sCustomerId);

                #region Item Info

                string sPickupCategory = objOP.RetrieveField2FromField1("PickupCategory",
                    "OrderBooking", "CustomerId", sCustomerId);

                string sPickupItem = objOP.RetrieveField2FromField1("PickupItem",
                    "OrderBooking", "CustomerId", sCustomerId);

                txtPayPalItemInfo.Text = sPickupCategory + " - " + sPickupItem;

                #endregion

                txtPayPalQuantity.Text = objOP.RetrieveField2FromField1("ItemCount",
                    "OrderBooking", "CustomerId", sCustomerId);

                try
                {
                    string sHaveToPay = Request.QueryString["HaveToPay"].Trim();
                    txtPayPalAmount.Text = sHaveToPay;
                }
                catch
                {
                    txtPayPalAmount.Text = objOP.RetrieveField2FromField1("TotalValue",
                        "OrderBooking", "CustomerId", sCustomerId);
                }

                ddlPayPalCurrency.SelectedIndex = 4;
            }
            catch
            {

            }
        }

        protected void PayWithPayPal(string BookingId, string name, string email, string phone,
            string iteminfo, string quantity, string amount, string currency)
        {
            string redirecturl = "";

            //Mention URL to redirect content to paypal site
            redirecturl += "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_xclick&business=" +
                           ConfigurationManager.AppSettings["PaypalEmail"].ToString();

            //Name
            redirecturl += "&name=" + name;

            //Address 
            redirecturl += "&address=" + email;

            //Phone No
            redirecturl += "&phone=" + phone;

            //Item Info
            redirecturl += "&item_info=" + iteminfo;

            //Quantity 
            redirecturl += "&quantity=" + quantity;

            //Amount
            redirecturl += "&amount=" + amount;

            //Business contact id
            redirecturl += "&business=judy@jobyco.com";

            //Currency code 
            redirecturl += "&currency=" + currency;

            if (Session["Login"] == null)
            {
                //Success return page url
                redirecturl += "&return=" +
                  ConfigurationManager.AppSettings["SuccessURL"].ToString() + "?BookingId="+ BookingId;

                //Failed return page url
                redirecturl += "&cancel_return=" +
                  ConfigurationManager.AppSettings["FailedURL"].ToString() + "?BookingId=" + BookingId;
            }
            else
            {
                string sLoginValue = Session["Login"].ToString();
                if (!string.IsNullOrEmpty(sLoginValue))
                {
                    //Success return page url
                    redirecturl += "&return=" +
                      ConfigurationManager.AppSettings["LoggedSuccessURL"].ToString() + "?BookingId=" + BookingId;

                    //Failed return page url
                    redirecturl += "&cancel_return=" +
                      ConfigurationManager.AppSettings["LoggedFailedURL"].ToString() + "?BookingId=" + BookingId;
                }
            }

            Response.Redirect(redirecturl);
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            string sName = txtPayPalName.Text.Trim();
            string sEmailId = txtPayPalEmailId.Text.Trim();
            string sPhoneNo = txtPayPalContactNo.Text.Trim();
            string sItemInfo = txtPayPalItemInfo.Text.Trim();
            string sQuantity = txtPayPalQuantity.Text.Trim();
            string sAmount = txtPayPalAmount.Text.Trim();
            string sCurrency = ddlPayPalCurrency.SelectedItem.Text.Trim();

            try
            {
                string sBookingId = Request.QueryString["BookingId"].Trim();
                string sCustomerId = objOP.RetrieveField2FromField1(
                    "CustomerId", "OrderBooking", "BookingId", sBookingId);

                //Saving PayPal details in Database Table
                EntityLayer.PayPal objPP = new EntityLayer.PayPal();
                objPP.PayPalId = objOP.GetAutoGeneratedValue("PayPalId", "PayPal", "PAY", 9);
                objPP.PayPalName = sName;
                objPP.PayPalEmailId = sEmailId;
                objPP.PayPalContactNo = sPhoneNo;
                objPP.PayPalItemInfo = sItemInfo;
                objPP.PayPalQuantity = Convert.ToInt32(sQuantity);
                objPP.PayPalAmount = Convert.ToDecimal(sAmount);
                objPP.PayPalCurrency = sCurrency;
                objPP.PayPalDateTime = DateTime.Now;
                objPP.BookingId = sBookingId;
                objPP.CustomerId = sCustomerId;

                objDB.AddPayPal(objPP);

                //objDB.UpdateOrderStatus(sBookingId, "Paid");
                PayWithPayPal(sBookingId, sName, sEmailId, sPhoneNo, sItemInfo, sQuantity, sAmount, sCurrency);

            }
            catch { }

            
        }
        
    }
}
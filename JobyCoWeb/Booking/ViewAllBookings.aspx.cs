using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PayPal.Api;

#region Required NameSpaces for Download

using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;

#endregion

#region Required Global NameSpaces

using DataAccessLayer;
using EntityLayer;
using SecurityLayer;
using JobyCoWeb.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb.Booking
{
    public partial class ViewAllBookings : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        string sEmailID = string.Empty;
        static string authorityDomain { get; set; }
        static string _bookingId;
        static Payment payment;
        static string _sHaveToPay;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(authorityDomain))
                authorityDomain = "http://staff.jobycodirect.com/";// + HttpContext.Current.Request.Url.Authority;

            if (!IsPostBack)
            {
                #region Menu Items & Page Controls

                objCM.PopulateAccessibleMenuItemsOnHiddenField(hfMenusAccessible);

                string sPagePath = objCM.GetCurrentPageName();
                int iMenuId = Convert.ToInt32(objOP.RetrieveField2FromAlikeField1("Menu_ID", "MenuDetails", "PagePath", sPagePath));
                objCM.PopulatePageControlsOnHiddenField(hfControlsAccessible, iMenuId);

                #endregion

                #region Checking SessionID

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
                    else
                    {
                        try
                        {
                            sEmailID = ObjLogin.EMAILID.ToString();
                            Master.LoggedInUser = objOP.GetUserName(sEmailID);

                            hfEmailID.Value = sEmailID;
                        }
                        catch
                        {
                        }
                    }
                }

                #endregion
            }
        }

        [WebMethod]
        public static string GetAllBookings()
        {
            DataTable dtBooking = objDB.GetAllBookings();
            List<EntityLayer.AllBookings> lstBooking = new List<EntityLayer.AllBookings>();

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.AllBookings objBooking = new EntityLayer.AllBookings();

                objBooking.Id = Convert.ToInt32(drBooking["Id"].ToString());
                objBooking.BookingId = drBooking["BookingId"].ToString();
                objBooking.CustomerName = drBooking["CustomerName"].ToString();
                objBooking.OrderDate = Convert.ToDateTime(drBooking["OrderDate"].ToString());
                objBooking.PickupDate = Convert.ToDateTime(drBooking["PickupDate"].ToString());
                objBooking.InsurancePremium = Convert.ToDecimal(drBooking["InsurancePremium"].ToString());
                objBooking.TotalValue = Convert.ToDecimal(drBooking["TotalValue"].ToString());
                objBooking.OrderStatus = drBooking["OrderStatus"].ToString();
                objBooking.PickupPostCode = drBooking["PickupPostCode"].ToString();
                objBooking.DeliveryPostCode = drBooking["DeliveryPostCode"].ToString();
                objBooking.PickupCustomerTitle = drBooking["PickupTitle"].ToString();
                objBooking.CreatedBy = drBooking["CreatedBy"].ToString();
                objBooking.IsRegisteredUser = drBooking["IsRegisteredUser"].ToString();

                lstBooking.Add(objBooking);
            }
            
            var js = new JavaScriptSerializer();
            //return js.Serialize(lstBooking.OrderBy(x => x.Id).Reverse());
            return js.Serialize(lstBooking);
        }

        [WebMethod]
        public static string GetPickupDeliveryFromBookingId(string BookingId)
        {
            List<EntityLayer.Booking> ListBooking = new List<EntityLayer.Booking>();
            DataTable dtBooking = objDB.GetPickupDeliveryByBookingId(BookingId);

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.Booking booking = new EntityLayer.Booking();
                booking.PickupName = drBooking["PickupName"].ToString();
                booking.PickupAddress = drBooking["PickupAddress"].ToString();
                booking.PickupMobile = drBooking["PickupMobile"].ToString();
                booking.AltPickupMobile = drBooking["AltPickupMobile"].ToString();

                booking.DeliveryName = drBooking["DeliveryName"].ToString();
                booking.RecipientAddress = drBooking["RecipientAddress"].ToString();
                booking.DeliveryMobile = drBooking["DeliveryMobile"].ToString();
                booking.AltDeliveryMobile = drBooking["AltDeliveryMobile"].ToString();

                booking.CustomerId = drBooking["CustomerId"].ToString();
                booking.CustomerMobile = drBooking["CustomerMobile"].ToString();
                booking.StatusDetails = drBooking["StatusDetails"].ToString();
                booking.PickupCustomerTitle = drBooking["PickupTitle"].ToString();
                booking.DeliveryCustomerTitle = drBooking["DeliveryTitle"].ToString();
                booking.IsPicked = drBooking["IsPicked"].ToString();

                ListBooking.Add(booking);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBooking);
        }

        [WebMethod]
        public static string ViewBookingChargesDetails(string BookingId)
        {
            DataTable dtTaxation = objDB.ViewBookingChargesDetails(BookingId);
            List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            foreach (DataRow drTaxation in dtTaxation.Rows)
            {
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

                objTaxation.BookingId = drTaxation["BookingId"].ToString();
                objTaxation.TaxName = drTaxation["TaxName"].ToString();
                objTaxation.TaxAmount = Convert.ToDecimal(drTaxation["TaxAmount"].ToString());

                lstTaxation.Add(objTaxation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstTaxation);
        }

        [WebMethod]
        public static object GetItemImagesByBookingId(string BookingId)
        {
            List<ImagePickup> ListImagePickup = new List<ImagePickup>();
            DataTable dtImagePickup = objDB.GetItemImagesByBookingId(BookingId);
            foreach (DataRow drImagePickup in dtImagePickup.Rows)
            {
                ImagePickup imagePickup = new ImagePickup();
                imagePickup.BookingId = drImagePickup["BookingId"].ToString();
                imagePickup.ImagePickupId = drImagePickup["ImagePickupId"].ToString();
                imagePickup.PickupItem = drImagePickup["PickupItem"].ToString();
                imagePickup.ImageName = drImagePickup["ImageName"].ToString();
                imagePickup.ImageUrl = drImagePickup["ImageUrl"].ToString();



                ListImagePickup.Add(imagePickup);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListImagePickup);
        }

        [WebMethod]
        public static object GetItemImagesByItemId(string BookingId, string PickupCategoryId, string PickupItemId)
        {
            List<ImagePickup> ListImagePickup = new List<ImagePickup>();
            DataTable dtImagePickup = objDB.GetItemImagesByItemId(BookingId, PickupCategoryId, PickupItemId);
            foreach (DataRow drImagePickup in dtImagePickup.Rows)
            {
                ImagePickup imagePickup = new ImagePickup();
                imagePickup.BookingId = drImagePickup["BookingId"].ToString();
                imagePickup.ImagePickupId = drImagePickup["ImagePickupId"].ToString();
                imagePickup.PickupItem = drImagePickup["PickupItem"].ToString();
                imagePickup.ImageName = drImagePickup["ImageName"].ToString();
                imagePickup.ImageUrl = drImagePickup["ImageUrl"].ToString();



                ListImagePickup.Add(imagePickup);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListImagePickup);
        }

        [WebMethod]
        public static void PaymentBookingStatusChange(string BookingId, string OrderStatus, string PaymentNotes)
        {
            EntityLayer.Booking objBooking = new EntityLayer.Booking();

            objBooking.BookingId = BookingId;
            objBooking.OrderStatus = OrderStatus;
            objBooking.PaymentNotes = PaymentNotes;

            objDB.PaymentBookingStatusChange(objBooking);
        }


        [WebMethod]
        public static string GetCustomerIdFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("CustomerId", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetCustomerMobileFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Mobile", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetPickupNameFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("PickupName", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetPickupAddressFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("PickupAddress", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetPickupMobileFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("PickupMobile", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetDeliveryNameFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryName", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetDeliveryAddressFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("RecipentAddress", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetDeliveryMobileFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryMobile", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetPickupDateAndTimeFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("FORMAT (PickupDateTime, 'dd/MM/yyyy ')", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetVATfromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("VAT", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetOrderTotalFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("TotalValue", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetOrderStatusFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("OrderStatus", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetIsFragileFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("IsFragile", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetItemCountFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("ItemCount", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetBookingNotesFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("BookingNotes", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetInsurancePremiumFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("InsurancePremium", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetPickupPostCodeFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("PickupPostCode", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetDeliveryPostCodeFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryPostCode", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetBookingDateFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("Bookingdate", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetPickupEmailFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("PickupEmail", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetDeliveryEmailFromBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryEmail", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string ViewBookingDetails(string BookingId)
        {
            DataTable dtBooking = objDB.ViewBookingDetails(BookingId);
            List<EntityLayer.clsBookingDetails> lstBooking = new List<EntityLayer.clsBookingDetails>();
            if (dtBooking.Rows.Count > 0) { 
                foreach (DataRow drBooking in dtBooking.Rows)
                {
                    EntityLayer.clsBookingDetails objBooking = new EntityLayer.clsBookingDetails();

                    //BP.[BookingId], BP.PickupCategoryId, BP.PickupItemId,

                    objBooking.BookingId = drBooking["BookingId"].ToString();
                    objBooking.PickupCategoryId = drBooking["PickupCategoryId"].ToString();
                    objBooking.PickupItemId = drBooking["PickupItemId"].ToString();
                    objBooking.Item = drBooking["Item"].ToString();
                    objBooking.Cost = Convert.ToDecimal(drBooking["Cost"].ToString());
                    objBooking.EstimatedValue = Convert.ToDecimal(drBooking["EstimatedValue"].ToString());
                    objBooking.Status = drBooking["Status"].ToString();

                    lstBooking.Add(objBooking);
                }
            }
            var js = new JavaScriptSerializer();
            return js.Serialize(lstBooking);
        }

        [WebMethod]
        public static string ViewPaymentDetails(string BookingId)
        {
            DataTable dtPaymentDetails = objDB.ViewPaymentDetails(BookingId);
            List<EntityLayer.PaymentDetails> lstPaymentDetails = new List<EntityLayer.PaymentDetails>();

            foreach (DataRow drPaymentDetails in dtPaymentDetails.Rows)
            {
                EntityLayer.PaymentDetails objPaymentDetails = new EntityLayer.PaymentDetails();

                objPaymentDetails.TransactionID = drPaymentDetails["TransactionID"].ToString();
                objPaymentDetails.EmailId = drPaymentDetails["EmailId"].ToString();
                objPaymentDetails.ContactNo = drPaymentDetails["ContactNo"].ToString();
                objPaymentDetails.Quantity = Convert.ToInt32(drPaymentDetails["Quantity"].ToString());
                objPaymentDetails.PaymentAmount = Convert.ToDecimal(drPaymentDetails["PaymentAmount"].ToString());
                objPaymentDetails.PaymentCurrency = drPaymentDetails["PaymentCurrency"].ToString();
                objPaymentDetails.PaymentDateTime = Convert.ToDateTime(drPaymentDetails["PaymentDateTime"].ToString());

                lstPaymentDetails.Add(objPaymentDetails);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstPaymentDetails);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtBookings = objDB.GetAllBookings();
            objCM.DownloadPDF(dtBookings, "Booking");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtBookings = objDB.GetAllBookings();
            objCM.DownloadExcel(dtBookings, "Booking");
        }

        #region Paypal Payment Getway
        [WebMethod]
        public static string PaymentProceed(string BookingId, string Total, string EmailID, string sHaveToPay)
        {
            _bookingId = BookingId;
            _sHaveToPay = sHaveToPay;
            


            //getting the apiContext
            APIContext apiContext = PaypalConfiguration.GetAPIContext();

            try
            {
                //A resource representing a Payer that funds a payment Payment Method as paypal
                //Payer Id will be returned when payment proceeds or click to pay
                string payerId = HttpContext.Current.Request.Params["PayerID"];

                if (string.IsNullOrEmpty(payerId))
                {
                    //this section will be executed first because PayerID doesn't exist
                    //it is returned by the create function call of the payment class

                    // Creating a payment
                    // baseURL is the url on which paypal sendsback the data.
                    //string baseURI = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority +
                    //            "/PaymentWithPayPal?";
                    
                    string baseURI = "";
                    //here we are generating guid for storing the paymentID received in session
                    //which will be used in the payment execution

                    var guid = Convert.ToString((new Random()).Next(100000));

                    //CreatePayment function gives us the payment approval url
                    //on which payer is redirected for paypal account payment

                    var createdPayment = CreatePayment(apiContext, baseURI + "&guid=" + guid);

                    //get links returned from paypal in response to Create function call

                    var links = createdPayment.links.GetEnumerator();

                    string paypalRedirectUrl = null;

                    while (links.MoveNext())
                    {
                        Links lnk = links.Current;

                        if (lnk.rel.ToLower().Trim().Equals("approval_url"))
                        {
                            //saving the payapalredirect URL to which user will be redirected for payment
                            paypalRedirectUrl = lnk.href;
                        }
                    }

                    // saving the paymentID in the key guid
                    HttpContext.Current.Session.Add(guid, createdPayment.id);

                    //HttpContext.Current.Response.Redirect(paypalRedirectUrl, false);
                    return paypalRedirectUrl;
                }
                else
                {

                    // This function exectues after receving all parameters for the payment

                    var guid = HttpContext.Current.Request.Params["guid"];

                    var executedPayment = ExecutePayment(apiContext, payerId, HttpContext.Current.Session[guid] as string);

                    //If executed payment failed then we will show payment failure message to user
                    if (executedPayment.state.ToLower() != "approved")
                    {
                        //HttpContext.Current.Response.Redirect("PaymentFailure.aspx", false);
                        return authorityDomain + "/PaymentFailure.aspx?BookingId=" + _bookingId;
                    }
                }
            }
            catch (Exception ex)
            {
                //HttpContext.Current.Response.Redirect("PaymentFailure.aspx", false);
                return authorityDomain + "/PaymentFailure.aspx?BookingId=" + _bookingId;
            }

            //on successful payment, show success page to user.

            //HttpContext.Current.Response.Redirect("PaymentSuccess.aspx", false);
            return authorityDomain + "/PaymentSuccess.aspx?BookingId=" + _bookingId;
        }
        //Paypal Api Payment
        private static Payment ExecutePayment(APIContext apiContext, string payerId, string paymentId)
        {
            var paymentExecution = new PaymentExecution() { payer_id = payerId };
            payment = new Payment() { id = paymentId };
            return payment.Execute(apiContext, paymentExecution);
        }
        private static Payment CreatePayment(APIContext apiContext, string redirectUrl)
        {

            //Filling up the Payment Form
            string sCustomerId = objOP.RetrieveField2FromField1("CustomerId",
                "OrderBooking", "BookingId", _bookingId);

            string PayPalName = objOP.GetFullNameFromCustomerId(sCustomerId);

            string PaypalEmail = objOP.RetrieveField2FromField1("EmailID",
                "Customers", "CustomerId", sCustomerId);

            string PayPalContactNo = objOP.RetrieveField2FromField1("Mobile",
                "Customers", "CustomerId", sCustomerId);


            var ListItems = new ItemList() { items = new List<Item>() };

            string TotalPrice = objOP.RetrieveField2FromField1("SUM(PredefinedEstimatedValue)",
                "BookPickup", "BookingId", _bookingId);


            DataTable dtTaxation = objDB.ViewBookingChargesDetails(_bookingId);
            List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            foreach (DataRow drTaxation in dtTaxation.Rows)
            {
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();
                objTaxation.ChargesType = drTaxation["ChargesType"].ToString();
                objTaxation.BookingId = drTaxation["BookingId"].ToString();
                objTaxation.TaxName = drTaxation["TaxName"].ToString();
                objTaxation.TaxAmount = Convert.ToDecimal(drTaxation["TaxAmount"].ToString());

                lstTaxation.Add(objTaxation);
            }

            decimal TransactionTotal = objDB.GetTransactionTotal(_bookingId);

            decimal GrandTotal = Math.Round(Convert.ToDecimal(TotalPrice), 2)
                + Math.Round(lstTaxation.Where(x => x.ChargesType == "Insurance").Sum(x => x.TaxAmount), 2)
                + Math.Round(lstTaxation.Where(x => x.ChargesType == "VAT").Sum(x => x.TaxAmount), 2) - TransactionTotal;
            _sHaveToPay = GrandTotal.ToString();

            redirectUrl = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority +
                                "/PaymentSuccess.aspx?sHaveToPay=" + _sHaveToPay + "&sCustomerId=" + sCustomerId + "&PayPalContactNo=" + PayPalContactNo + "&PaypalEmail=" + PaypalEmail + "&BookingId=" + _bookingId;

            string cancelURI = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority +
                                "/PaymentFailure.aspx?BookingId=" + _bookingId;

            #region Item Info

            ListItems.items.Add(new Item
            {
                name = "Remaining Payment",
                currency = "USD",
                //currency = "GBP",  // Currency for UK
                price = _sHaveToPay,
                quantity = "1",
                sku = "sku"
            });
            #endregion



            var payer = new Payer() { payment_method = "paypal" };

            // Do the configuration RedirectUrls here with RedirectUrls object
            var redirUrls = new RedirectUrls()
            {
                cancel_url = cancelURI,
                return_url = redirectUrl
            };

            

            

            //Create details object
            var details = new Details()
            {
                //tax = "0",
                //insurance = "0",
                subtotal = _sHaveToPay
            };



            //Final amount with details
            var amount = new Amount()
            {
                currency = "USD",
                // Total must be equal to sum of tax, shipping and subtotal.
                total = _sHaveToPay,
                details = details
            };

            var transactionList = new List<Transaction>();
            // Adding description about the transaction
            transactionList.Add(new Transaction()
            {
                description = "Transaction description",
                invoice_number = Convert.ToString((new Random()).Next(100000)), //Generate an Invoice No
                amount = amount,
                item_list = ListItems
            });


            payment = new Payment()
            {
                intent = "sale",
                payer = payer,
                transactions = transactionList,
                redirect_urls = redirUrls
            };

            // Create a payment using a APIContext
            return payment.Create(apiContext);
        }
        #endregion

    }
}
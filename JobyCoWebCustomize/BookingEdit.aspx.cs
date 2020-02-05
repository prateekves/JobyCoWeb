using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PayPal.Api;

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
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class BookingEdit : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion
        static string authorityDomain { get; set; }
        static string _bookingId;
        static Payment payment;
        static string _sHaveToPay;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(authorityDomain))
                authorityDomain = "http://" + HttpContext.Current.Request.Url.Authority;

            if (!IsPostBack)
            {
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
                        Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());

                        #region RegisteredEmailIDs

                        txtConfirmEmailAddress.Text = ((BOLogin)Session["Login"]).EMAILID.ToString();
                        txtPickupEmailAddress.Text = ((BOLogin)Session["Login"]).EMAILID.ToString();
                        //txtDeliveryEmailAddress.Text = Session["Login"].ToString();

                        #endregion

                        #region Fillup Booking Details

                        try
                        {
                            string sBookingId = Request.QueryString["BookingId"].Trim();
                            hfEditBookingId.Value = sBookingId;

                            //Filling up fieldset - 1

                            #region CustomerId

                            string sCustomerId = objOP.RetrieveField2FromField1("CustomerId",
                                "OrderBooking", "BookingId", sBookingId);
                            hfEditCustomerId.Value = sCustomerId;

                            #endregion

                            #region PaymentStatus

                            string sTotalValue = objOP.RetrieveField2FromField1("TotalValue",
                                "OrderBooking", "BookingId", sBookingId);
                            hfTotalValue.Value = sTotalValue;

                            spEarlierPayment.InnerText = sTotalValue;

                            #endregion

                            #region HavingRegisteredCompany

                            string sHavingRegisteredCompany = objOP.RetrieveField2FromField1("HavingRegisteredCompany",
                                "Customers", "CustomerId", sCustomerId);

                            if (sHavingRegisteredCompany == "True")
                            {
                                ddlRegisteredCompany.SelectedIndex = 1;

                                #region RegisteredCompanyName

                                string sRegisteredCompanyName = objOP.RetrieveField2FromField1("RegisteredCompanyName",
                                "Customers", "CustomerId", sCustomerId);

                                txtCompanyName.Text = sRegisteredCompanyName;

                                #endregion

                                #region ShippingGoodsInCompanyName

                                dvGoodsInName.Attributes.CssStyle.Add("display", "block");

                                string sShippingGoodsInCompanyName = objOP.RetrieveField2FromField1("ShippingGoodsInCompanyName",
                                    "Customers", "CustomerId", sCustomerId);

                                if (sShippingGoodsInCompanyName == "True")
                                {
                                    ddlGoodsInName.SelectedIndex = 1;
                                }
                                else
                                {
                                    ddlGoodsInName.SelectedIndex = 2;
                                }

                                #endregion
                            }
                            else
                            {
                                ddlRegisteredCompany.SelectedIndex = 2;
                            }

                            #endregion

                            #region InsurancePremium

                            string sInsurancePremium = objOP.RetrieveField2FromField1("InsurancePremium",
                                "OrderBooking", "BookingId", sBookingId);

                            try
                            {
                                decimal dInsurancePremium = Convert.ToDecimal(sInsurancePremium);
                                if (dInsurancePremium >= 0 && dInsurancePremium <= 10)
                                {
                                    ddlInsurance.SelectedIndex = 2;
                                }
                                else if (dInsurancePremium > 10)
                                {
                                    ddlInsurance.SelectedIndex = 1;
                                }

                                //dvInsurancePremium.Attributes.CssStyle.Add("display", "block");
                                txtInsurancePremium.Text = sInsurancePremium;
                            }
                            catch
                            {
                                ddlInsurance.SelectedIndex = 2;
                            }

                            #endregion

                            #region Filling up myTable

                            //The BookPickup Table
                            DataTable dtMyBookings = objDB.GetMyBookingDetails(sBookingId);
                            int iNoOfBookings = dtMyBookings.Rows.Count;

                            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideFirstRowOfMyTable", "hideFirstRowOfMyTable();", true);
                            if (iNoOfBookings > 0)
                            {
                                for (int counter = 1; counter <= iNoOfBookings; counter++)
                                {
                                    string sPickupCategory = dtMyBookings.Rows[counter - 1][0].ToString();
                                    string sPickupItem = dtMyBookings.Rows[counter - 1][1].ToString();
                                    string sIsFragile = dtMyBookings.Rows[counter - 1][2].ToString();
                                    string sEstimatedValue = dtMyBookings.Rows[counter - 1][3].ToString();

                                    //New Line Added for Predefined Estimated Value
                                    //====================================================
                                    string sPredefinedEstimatedValue = dtMyBookings.Rows[counter - 1][4].ToString();
                                    //====================================================
                                    string sPickupCategoryId = dtMyBookings.Rows[counter - 1]["PickupCategoryId"].ToString();
                                    string sPickupItemId = dtMyBookings.Rows[counter - 1]["PickupItemId"].ToString();

                                    ScriptManager.RegisterStartupScript(this, this.GetType(),
                                        "dynamicallyGeneratedTable" + counter,
                                        "dynamicallyGeneratedTable(" + counter
                                        + ", '" + sPickupCategory
                                        + "', '" + sPickupItem
                                        + "', '" + sIsFragile
                                        + "', '" + sEstimatedValue
                                        + "', '" + sPredefinedEstimatedValue
                                        + "', '" + sPickupCategoryId
                                        + "', '" + sPickupItemId
                                        + "', '" + sBookingId
                                        + "');"
                                        , true);

                                    //New Line Added for Predefined Estimated Value
                                    //====================================================
                                    ScriptManager.RegisterStartupScript(this, this.GetType(),
                                        "loadConfirmItems" + counter,
                                        "loadConfirmItems(" + counter
                                        + ", '" + sPickupCategory
                                        + "', '" + sPickupItem
                                        + "', '" + sIsFragile
                                        + "', '" + sEstimatedValue
                                        + "', '" + sPredefinedEstimatedValue
                                        + "');"
                                        , true);
                                    //====================================================

                                }
                            }

                            #endregion

                            #region OtherDetails

                            spItemCount.InnerText = objOP.RetrieveField2FromField1("ItemCount",
                                "OrderBooking", "BookingId", sBookingId);
                            hfItemCount.Value = spItemCount.InnerText;

                            //No of Items at the very beginning
                            htItemCountAtFirst.Value = hfItemCount.Value;

                            spTotal.InnerText = objOP.RetrieveField2FromField1("TotalValue",
                                "OrderBooking", "BookingId", sBookingId);

                            txtCollectionDate.Value = objOP.RetrieveField2FromField1("PickupDateTime",
                                "OrderBooking", "BookingId", sBookingId);

                            StatusDetails.Value = objOP.RetrieveField2FromField1("StatusDetails",
                                "OrderBooking", "BookingId", sBookingId);

                            chkAgree.Checked = true;

                            #endregion

                            //end of fieldset - 1

                            //Filling up fieldset - 2

                            #region CollectionDetails

                            txtCollectionName.Text = objOP.RetrieveField2FromField1("PickupName",
                                "OrderBooking", "BookingId", sBookingId);
                            lblCollectionName.Text = txtCollectionName.Text.Trim();

                            txtCollectionAddressLine1.Value = objOP.RetrieveField2FromField1("PickupAddress",
                                "OrderBooking", "BookingId", sBookingId);
                            lblCollectionAddressLine1.Text = txtCollectionAddressLine1.Value.Trim();

                            txtCollectionPostCode.Text = objOP.RetrieveField2FromField1("PickupPostCode",
                                "OrderBooking", "BookingId", sBookingId);
                            lblCollectionPostCode.Text = txtCollectionPostCode.Text.Trim();

                            txtCollectionMobile.Value = objOP.RetrieveField2FromField1("PickupMobile",
                                "OrderBooking", "BookingId", sBookingId);
                            lblCollectionMobile.Text = txtCollectionMobile.Value.Trim();

                            txtAltCollectionMobile.Value = objOP.RetrieveField2FromField1("AltPickupMobile",
                                "OrderBooking", "BookingId", sBookingId);
                            lblAltCollectionMobile.Text = txtAltCollectionMobile.Value.Trim();

                            #endregion

                            #region DeliveryDetails

                            txtDeliveryName.Text = objOP.RetrieveField2FromField1("DeliveryName",
                                "OrderBooking", "BookingId", sBookingId);
                            lblDeliveryName.Text = txtDeliveryName.Text.Trim();

                            txtDeliveryAddressLine1.Value = objOP.RetrieveField2FromField1("RecipentAddress",
                                "OrderBooking", "BookingId", sBookingId);
                            lblDeliveryAddressLine1.Text = txtDeliveryAddressLine1.Value.Trim();

                            txtDeliveryPostCode.Text = objOP.RetrieveField2FromField1("DeliveryPostCode",
                                "OrderBooking", "BookingId", sBookingId);
                            lblDeliveryPostCode.Text = txtDeliveryPostCode.Text.Trim();

                            txtDeliveryMobile.Value = objOP.RetrieveField2FromField1("DeliveryMobile",
                                "OrderBooking", "BookingId", sBookingId);
                            lblDeliveryMobile.Text = txtDeliveryMobile.Value.Trim();

                            txtAltDeliveryMobile.Value = objOP.RetrieveField2FromField1("AltDeliveryMobile",
                                "OrderBooking", "BookingId", sBookingId);
                            lblAltDeliveryMobile.Text = txtAltDeliveryMobile.Value.Trim();


                            String sql = @"Select PDA.PickupTitle, PDA.DeliveryTitle From[dbo].[OrderBooking] OB
                            INNER JOIN[dbo].[PickupDeliveryAddress]
                                    PDA ON PDA.Ids = OB.Address_Id
                            Where OB.CustomerId = '" + sCustomerId + "' AND OB.BookingId = '" + sBookingId + "'";

                            DataTable dt = objOP.Retrieve_Data(sql, "PickupDeliveryAddress");

                            ddlPickupCustomerTitle.SelectedValue = dt.Rows[0][0].ToString();
                            lblPCustomerTitle.Text = dt.Rows[0][0].ToString();

                            ddlDeliveryCustomerTitle.SelectedValue = dt.Rows[0][1].ToString();
                            lblDCustomerTitle.Text = dt.Rows[0][1].ToString();
                            #endregion

                            #region CollectionDate

                            string sCollectionDate = txtCollectionDate.Value;
                            //DateTime dtCollection = DateTime.Parse(sCollectionDate, new CultureInfo("en-US"));
                            DateTime dtCollection = Convert.ToDateTime(sCollectionDate);
                            lblConfirmCollectionDate.Text = dtCollection.ToLongDateString();

                            #endregion

                            //end of fieldset - 2

                            #region Latitude Longitude
                            string LatitudePickup = objOP.RetrieveField2FromField1("LatitudePickup",
                                "OrderBooking", "BookingId", sBookingId);
                            if (!string.IsNullOrEmpty(LatitudePickup))
                            {
                                hfPickupLatitude.Value = LatitudePickup;
                            }
                            else
                            {
                                hfPickupLatitude.Value = "0";
                            }


                            string LongitudePickup = objOP.RetrieveField2FromField1("LongitudePickup",
                                "OrderBooking", "BookingId", sBookingId);

                            if (!string.IsNullOrEmpty(LongitudePickup))
                            {
                                hfPickupLongitude.Value = LongitudePickup;
                            }
                            else
                            {
                                hfPickupLongitude.Value = "0";
                            }
                            string LatitudeDelivery = objOP.RetrieveField2FromField1("LatitudeDelivery",
                                "OrderBooking", "BookingId", sBookingId);

                            if (!string.IsNullOrEmpty(LatitudeDelivery))
                            {
                                hfDeliveryLatitude.Value = LatitudeDelivery;
                            }
                            else
                            {
                                hfDeliveryLatitude.Value = "0";
                            }
                            string LongitudeDelivery = objOP.RetrieveField2FromField1("LongitudeDelivery",
                                "OrderBooking", "BookingId", sBookingId);

                            if (!string.IsNullOrEmpty(LongitudeDelivery))
                            {
                                hfDeliveryLongitude.Value = LongitudeDelivery;
                            }
                            else
                            {
                                hfDeliveryLongitude.Value = "0";
                            }
                            #endregion
                        }
                        catch
                        {

                        }

                        #endregion

                    }
                }

                #endregion
            }
        }

        [WebMethod]
        public static string DeleteItemImages(string ImagePickupId, string ImageName)
        {
            string sMessage = string.Empty;
            sMessage = objOP.DeleteItemImage(ImagePickupId, ImageName);
            return sMessage;
        }

        [WebMethod]
        public static string SelectRedundentImages
        (
            string BookingId
        )
        {
            List<ImagePickup> ListImagePickup = new List<ImagePickup>();
            DataTable dtImagePickup = objDB.SelectRedundentImages(BookingId);
            foreach (DataRow drImagePickup in dtImagePickup.Rows)
            {
                ImagePickup imagePickup = new ImagePickup();
                imagePickup.BookingId = drImagePickup["Id"].ToString();
                imagePickup.BookingId = drImagePickup["BookingId"].ToString();
                imagePickup.ImagePickupId = drImagePickup["ImagePickupId"].ToString();
                imagePickup.ImageName = drImagePickup["ImageName"].ToString();
                imagePickup.ImageUrl = drImagePickup["ImageUrl"].ToString();



                ListImagePickup.Add(imagePickup);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListImagePickup);

        }

        #region Paypal Payment Getway
        [WebMethod]
        public static string PaymentProceed(string BookingId, string Total, string EmailID, string sHaveToPay)
        {
            _bookingId = BookingId;
            _sHaveToPay = sHaveToPay;
            //Filling up the Payment Form
            string sCustomerId = objOP.RetrieveField2FromField1("CustomerId",
                "OrderBooking", "BookingId", BookingId);

            string PayPalName = objOP.GetFullNameFromCustomerId(sCustomerId);

            string PaypalEmail = EmailID;

            string PayPalContactNo = objOP.RetrieveField2FromField1("Mobile",
                "Customers", "CustomerId", sCustomerId);


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
                    string baseURI = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority +
                                "/PaymentSuccess.aspx?sHaveToPay="+ _sHaveToPay + "&sCustomerId=" + sCustomerId + "&PayPalContactNo=" + PayPalContactNo + "&PaypalEmail=" + PaypalEmail + "&BookingId=" + BookingId;

                    string cancelURI = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority +
                                "/PaymentFailure.aspx?BookingId=" + _bookingId;

                    //here we are generating guid for storing the paymentID received in session
                    //which will be used in the payment execution

                    var guid = Convert.ToString((new Random()).Next(100000));

                    //CreatePayment function gives us the payment approval url
                    //on which payer is redirected for paypal account payment

                    var createdPayment = CreatePayment(apiContext, baseURI + "&guid=" + guid, cancelURI);

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
        private static Payment CreatePayment(APIContext apiContext, string redirectUrl, string cancelURI)
        {
            #region Item Info
            var ListItems = new ItemList() { items = new List<Item>() };

            //DataTable dt = new DataTable();
            //string sql = "SELECT PickupCategory + SPACE(1) + PickupItem As Items, PredefinedEstimatedValue FROM BookPickup WHERE BookingId ='" + _bookingId + "'";
            //dt = objOP.Retrieve_Data(sql, "BookPickup");
            //foreach (DataRow dr in dt.Rows)
            //{
            //    ListItems.items.Add(new Item
            //    {
            //        name = dr["Items"].ToString(),
            //        currency = "USD",
            //        //currency = "GBP",  // Currency for UK
            //        price = dr["PredefinedEstimatedValue"].ToString(),
            //        quantity = "1",
            //        sku = "sku"
            //    });
            //}
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

            //DataTable dtTaxation = objDB.ViewBookingChargesDetails(_bookingId);
            //List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            //foreach (DataRow drTaxation in dtTaxation.Rows)
            //{
            //    EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();
            //    objTaxation.ChargesType = drTaxation["ChargesType"].ToString();
            //    objTaxation.BookingId = drTaxation["BookingId"].ToString();
            //    objTaxation.TaxName = drTaxation["TaxName"].ToString();
            //    objTaxation.TaxAmount = Convert.ToDecimal(drTaxation["TaxAmount"].ToString());

            //    lstTaxation.Add(objTaxation);
            //}

            //decimal TransactionTotal = objDB.GetTransactionTotal(_bookingId);

            //decimal GrandTotal = Math.Round(ListItems.items.Sum(x => Convert.ToDecimal(x.price)), 2)
            //    + Math.Round(lstTaxation.Where(x => x.ChargesType == "Insurance").Sum(x => x.TaxAmount), 2)
            //    + Math.Round(lstTaxation.Where(x => x.ChargesType == "VAT").Sum(x => x.TaxAmount), 2) - TransactionTotal;

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
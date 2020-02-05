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

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Globalization;

#endregion

namespace JobyCoWeb.Booking
{
    public partial class AddQuoting : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion
        static string authorityDomain { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (string.IsNullOrEmpty(authorityDomain))
                authorityDomain = "http://jobycodirect.com/";// + HttpContext.Current.Request.Url.Authority;

            if (!IsPostBack)
            {
                objCM.PopulateAccessibleMenuItemsOnHiddenField(hfMenusAccessible);

                #region BindDropdown

                DataTable dtCustomers = objOP.GetFullNames("Customers");
                objCM.FillDropDown(ddlCustomers, "Customer", dtCustomers);

                try
                {
                    string sCustomerName = Request.QueryString["CustomerName"].Trim().Replace("+", " ");
                    if (sCustomerName != "")
                    {
                        ddlCustomers.SelectedItem.Text = sCustomerName;
                    }
                }
                catch
                {

                }

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
                        Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());

                        #region Collection and Delivery Name

                        txtCollectionName.Text = objOP.GetUserFullNameFromEmailId(Session["Login"].ToString());
                        txtDeliveryName.Text = objOP.GetUserFullNameFromEmailId(Session["Login"].ToString());

                        #endregion

                        #region RegisteredEmailIDs

                        txtConfirmEmailAddress.Text = Session["Login"].ToString();
                        txtPickupEmailAddress.Text = Session["Login"].ToString();
                        //txtDeliveryEmailAddress.Text = Session["Login"].ToString();

                        #endregion
                    }
                }

                #endregion
            }
        }

        public static EntityLayer.ItemValues[] GetDropDownValues(int iTableId, int iFieldId)
        {
            DataTable dtItemValues = objDB.GetDropDownValues(iTableId, iFieldId);
            List<EntityLayer.ItemValues> lstItemValues = new List<EntityLayer.ItemValues>();

            foreach (DataRow drCategories in dtItemValues.Rows)
            {
                EntityLayer.ItemValues iv = new EntityLayer.ItemValues();
                iv.ItemId = Convert.ToInt32(drCategories["ItemId"].ToString());
                iv.ItemValue = drCategories["ItemValue"].ToString();
                lstItemValues.Add(iv);
            }

            return lstItemValues.ToArray();
        }

        [WebMethod]
        public static EntityLayer.ItemValues[] GetPickupCategories()
        {
            return GetDropDownValues(9, 12);
        }

        [WebMethod]
        public static EntityLayer.PickupItems[] GetPickupItemsByCategory(string PickupCategory)
        {
            DataTable dtPickupItems = objDB.GetPickupItemsByCategory(PickupCategory);
            List<EntityLayer.PickupItems> lstItems = new List<EntityLayer.PickupItems>();

            foreach (DataRow drItems in dtPickupItems.Rows)
            {
                EntityLayer.PickupItems objPickupItems = new EntityLayer.PickupItems();
                objPickupItems.PickupItemId = Convert.ToInt32(drItems["PickupItemId"].ToString());
                objPickupItems.PickupItem = drItems["PickupItem"].ToString();

                lstItems.Add(objPickupItems);
            }

            return lstItems.ToArray();
        }

        [WebMethod]
        public static string GetPredefinedEstimatedValueByCategory(string PickupCategory)
        {
            return objDB.GetPredefinedEstimatedValueByCategory(PickupCategory);
        }

        [WebMethod]
        public static string GetPredefinedEstimatedValueByItem(string PickupItem)
        {
            return objDB.GetPredefinedEstimatedValueByItem(PickupItem);
        }

        [WebMethod]
        public static EntityLayer.ItemValues[] GetTitles()
        {
            return GetDropDownValues(1, 1);
        }

        [WebMethod]
        public static EntityLayer.ItemValues[] GetCountries()
        {
            return GetDropDownValues(10, 13);
        }

        [WebMethod]
        public static string GetCustomerId()
        {
            //return objOP.GetAutoGeneratedValue("CustomerId", "Customers", "CUST", 9);
            //return objOP.GetAutoGeneratedValueClientFormat("CustomerId", "Customers", "CUST", 3);
            return objOP.GetAutoGeneratedValueClientFormatNew("CustomerId", "Customers", "CS", 5);
        }

        [WebMethod]
        public static string GetCustomerIdFromCustomerName(string CustomerName)
        {
            return objOP.GetCustomerIdFromFullName(CustomerName);
        }

        //[WebMethod]
        //public static void AddCustomer
        //    (
        //    string CustomerId,
        //    string EmailID,
        //    string Password,
        //    string Title,
        //    string FirstName,
        //    string LastName,
        //    string DOB,
        //    string Address,
        //    string Town,
        //    string Country,
        //    string PostCode,
        //    string Mobile,
        //    string Telephone,
        //    string HearAboutUs,
        //    string HavingRegisteredCompany,
        //    string Locked,
        //    string ShippingGoodsInCompanyName,
        //    string RegisteredCompanyName
        //    )
        //{
        //    EntityLayer.Customer objCustomer = new EntityLayer.Customer();

        //    objCustomer.CustomerId = CustomerId;
        //    objCustomer.EmailID = EmailID;
        //    objCustomer.Password = objCG.getMd5Hash(Password);
        //    objCustomer.Title = Title;
        //    objCustomer.FirstName = FirstName;
        //    objCustomer.LastName = LastName;
        //    objCustomer.DOB = Convert.ToDateTime(DOB,
        //    System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);
        //    objCustomer.Address = Address;
        //    objCustomer.Town = Town;
        //    objCustomer.Country = Country;
        //    objCustomer.PostCode = PostCode;
        //    objCustomer.Mobile = Mobile;
        //    objCustomer.Telephone = Telephone;
        //    objCustomer.HearAboutUs = HearAboutUs;
        //    objCustomer.HavingRegisteredCompany = Convert.ToBoolean(HavingRegisteredCompany);
        //    objCustomer.Locked = Convert.ToBoolean(Locked);
        //    objCustomer.ShippingGoodsInCompanyName = Convert.ToBoolean(ShippingGoodsInCompanyName);
        //    objCustomer.RegisteredCompanyName = RegisteredCompanyName;

        //    objDB.AddCustomer(objCustomer);
        //}

        [WebMethod]
        public static string GetBookingId()
        {
            return objOP.GetAutoGeneratedValue("BookingId", "OrderBooking", "J", 5);
        }

        [WebMethod]
        public static void AddImagePickup
        (
            string ImagePickupId,
            string BookingId,
            string CustomerId,
            int PickupCategoryId,
            int PickupItemId,
            string ImageName
        )
        {
            EntityLayer.ImagePickup objIP = new EntityLayer.ImagePickup();

            //ImagePickupId = objOP.GetAutoGeneratedValue("ImagePickupId", "ImagePickup", "IP", 9);
            ImagePickupId = objOP.GetAutoGeneratedValueClientFormat("ImagePickupId", "ImagePickup", "IP", 3);
            objIP.ImagePickupId = ImagePickupId;

            objIP.BookingId = BookingId;
            objIP.CustomerId = CustomerId;
            objIP.PickupCategoryId = PickupCategoryId;
            objIP.PickupItemId = PickupItemId;
            objIP.ImageName = ImageName;

            objDB.AddImagePickup(objIP);
        }

        [WebMethod]
        public static void RemoveImagePickup
        (
            string BookingId
        )
        {
            objDB.RemoveImageDetails(BookingId);
        }

        [WebMethod]
        public static void RemoveBookPickup
        (
            string BookingId
        )
        {
            objDB.RemoveBookingDetails(BookingId);
        }

        [WebMethod]
        public static void AddQuotingOperation
            (
            string QuotingId,
            string CustomerId,
            string PickupCategory,
            string PickupDateTime,
            string PickupAddress,
            string Width,
            string Height,
            string Length,
            string IsFragile,
            string EstimatedValue,
            string ItemCount,
            string TotalValue,
            string DeliveryCategory,
            string DeliveryDateTime,
            string RecipientAddress,
            string DeliveryQuantity,
            string DeliveryCharge,
            string TotalCharge,
            string QuotingNotes,
            string OrderStatus,
            string PickupItem,
            string VAT,
            string InsurancePremium,

            //New Parameters Added for few more Pickup and Delivery Fields
            //======================================================
            string PickupName,
            string PickupMobile,
            string DeliveryName,
            string DeliveryMobile,

            string PickupPostCode,
            string DeliveryPostCode,
            //======================================================
            string QuotingDate,

            //A Couple of New Fields Added for Pickup and Delivery
            //======================================================
            string PickupEmail,
            string DeliveryEmail,
            //======================================================

            string WhetherOtherExists
            )
        {
            EntityLayer.Quoting objQuoting = new EntityLayer.Quoting();

            objQuoting.QuotingId = QuotingId;
            objQuoting.CustomerId = CustomerId;
            objQuoting.PickupCategory = PickupCategory;

            objQuoting.PickupDateTime = Convert.ToDateTime(PickupDateTime,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objQuoting.PickupAddress = PickupAddress;
            objQuoting.Width = Convert.ToDecimal(Width);
            objQuoting.Height = Convert.ToDecimal(Height);
            objQuoting.Length = Convert.ToDecimal(Length);
            objQuoting.IsFragile = Convert.ToBoolean(IsFragile);
            objQuoting.EstimatedValue = Convert.ToDecimal(EstimatedValue);
            objQuoting.ItemCount = Convert.ToInt32(ItemCount);
            objQuoting.TotalValue = Convert.ToDecimal(TotalValue);
            objQuoting.DeliveryCategory = DeliveryCategory;

            objQuoting.DeliveryDateTime = Convert.ToDateTime(DeliveryDateTime,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objQuoting.RecipientAddress = RecipientAddress;
            objQuoting.DeliveryQuantity = Convert.ToInt32(DeliveryQuantity);
            objQuoting.DeliveryCharge = Convert.ToDecimal(DeliveryCharge);
            objQuoting.TotalCharge = Convert.ToDecimal(TotalCharge);
            objQuoting.QuotingNotes = QuotingNotes;
            objQuoting.OrderStatus = OrderStatus;
            objQuoting.PickupItem = PickupItem;
            objQuoting.VAT = Convert.ToDecimal(VAT);
            objQuoting.InsurancePremium = Convert.ToDecimal(InsurancePremium);

            //New Object Property Added for few more Pickup and Delivery Fields
            //======================================================
            objQuoting.PickupName = PickupName;
            objQuoting.PickupMobile = PickupMobile;

            objQuoting.DeliveryName = DeliveryName;
            objQuoting.DeliveryMobile = DeliveryMobile;

            objQuoting.PickupPostCode = PickupPostCode;
            objQuoting.DeliveryPostCode = DeliveryPostCode;
            //======================================================

            objQuoting.QuotingDate = Convert.ToDateTime(QuotingDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            //A Couple of New Fields Added for Pickup and Delivery
            //======================================================
            objQuoting.PickupEmail = PickupEmail;
            objQuoting.DeliveryEmail = DeliveryEmail;
            //======================================================

            objQuoting.WhetherOtherExists = Convert.ToBoolean(WhetherOtherExists);

            objDB.AddQuoting(objQuoting);
        }

        [WebMethod]
        public static void AddQuotPickup
        (
            string PickupId,
            string QuotingId,
            string CustomerId,
            string PickupCategory,
            string PickupItem,
            string IsFragile,
            string EstimatedValue,

            //New Field Added for QuotPickup
            //=====================================
            string PredefinedEstimatedValue
        //=====================================
        )
        {
            EntityLayer.QuotPickup objQP = new EntityLayer.QuotPickup();

            PickupId = objOP.GetAutoGeneratedValue("PickupId", "QuotPickup", "QP", 9);
            objQP.PickupId = PickupId;

            objQP.QuotingId = QuotingId;
            objQP.CustomerId = CustomerId;
            objQP.PickupCategory = PickupCategory;
            objQP.PickupItem = PickupItem;
            objQP.IsFragile = Convert.ToBoolean(IsFragile);
            objQP.EstimatedValue = Convert.ToDecimal(EstimatedValue);

            //New Field Added for QuotPickup
            //=====================================
            objQP.PredefinedEstimatedValue = Convert.ToDecimal(PredefinedEstimatedValue);
            //=====================================

            objDB.AddQuotPickup(objQP);
        }

        [WebMethod]
        public static string SendQuoteByEmail(string EmailID, string jQueryDataTableContent, string QuoteId)
        {
            string sMessage = string.Empty;
            //string sFrom = "switch2web2017@gmail.com";
            //string sFromPassword = "switch2web2017@#";

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = EmailID;
            string sSubject = "jobycodirect.com Quote - " + QuoteId;

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Quote<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>";
            sBody += "&nbsp;Your jobycodirect.com Quote</h1>";
            sBody += "Thank you for your interest in Jobyco.<br/>";
            sBody += "Please find your recent quote below, the quote will be active for a period ";
            sBody += "of 30 days from the date of this email.<br/>";
            sBody += "Bookings can be made and viewed any time in the jobycodirect.com ";
            sBody += "<a href='" + authorityDomain + "'><b><u>Customer Portal</u></b></a>.";
            sBody += "<p>Please note that this is NOT a booking, this is just a quote. ";
            sBody += "If you still have the quote window open you can click on the ";
            sBody += "\"Accept Quote and continue with order\" button to place a booking ";
            sBody += "on the website or you can retrieve a quote and continue with the order ";
            sBody += "By clicking on the following link: ";
            sBody += "<a href='" + authorityDomain + "/LoggedQuote.aspx'><b><u>Continue With Order</u></b></a>.</p>";
            sBody += "<p>You can also sign into the ";
            sBody += "<a href='" + authorityDomain + "'><b><u>Customer Portal</u></b></a>";
            sBody += " and place a booking there, or call the customer service team on 01582 574569.</p>";
            sBody += "<h1>Quote: - " + QuoteId + " </h1>";

            sBody += jQueryDataTableContent;

            //New Line Added for "Other" Category Message
            //=======================================================================================
            sBody += "<h4 style='background-color: navy; color: whitesmoke; padding: 0 0 0 20px;'>";
            sBody += "&nbsp;The Price of Category 'Other' will be paid at Collection</h4>";
            //=======================================================================================

            sBody += "<br/><br/>Please note that the final price for any quotes containing \"Other\" is ";
            sBody += "likely to change depending on what exactly is being shipped, ";
            sBody += "for a more precise quote please call our Customer Services Team ";
            sBody += "between 8:30 am and 8:30 pm Monday to Friday or between 9:00 am and 6:00 pm ";
            sBody += "Saturday on 01582 574569<br/><br/>";

            //New Code Added for Links: -
            //===========================================================================================================================
            sBody += "You can view your Quotations from <a href='" + authorityDomain + "/ViewMyQuotations.aspx?QuoteId=" + QuoteId + "'>here</a><br/><br/>";
            sBody += "You can make Payment from <a href='" + authorityDomain + "/ProceedToPaymentForQuotation.aspx?QuoteId=" + QuoteId + "'>here</a><br/><br/><br/><br/>";
            //===========================================================================================================================

            sBody += "Regards,<br/>";
            sBody += "Jobyco Customer Services Team.<br/>";
            sBody += "<img src='/images/JobyCoLimited.png' />";
            sBody += "<font size='-2'>Jobyco Limited<br/>";
            sBody += "194 Camford Way, Sundon Park,<br/>";
            sBody += "Luton, Bedfordshire, LU3 3AN<br/>";
            sBody += "<font style='color: yellow;'><a href='" + authorityDomain + "'>www.jobycodirect.com</a></font><br/>";
            sBody += "Jobyco Limited is registered with Companies House in England and Wales. ";
            sBody += "Registered Number: 5046487.<br/>";
            sBody += "<p>\"If you've received this email by mistake, we're sorry for bothering you. ";
            sBody += "It may contain information that's confidential, so please delete it without ";
            sBody += "sharing it. And if you let us know, we can try to stop it from happening again. ";
            sBody += "Please note that any views or opinions presented in this email are solely those ";
            sBody += "of the author and do not necessarily represent those of the company. ";
            sBody += "This e-mail was scanned for infections at the time it left the system. ";
            sBody += "However, please check this email and any attachments for the presence of ";
            sBody += "any infection.\"</p></font>";

            try
            {
                if (objOP.SendMail(sFrom, sTo, sSubject, sBody, sFromPassword))
                {
                    sMessage = "Your Booking Details could not be sent into your Email Id";
                }
                else
                {
                    sMessage = "Your Booking Details has been sent successfully into your Email Id";
                }
            }
            catch { }

            return sMessage;
        }

        protected void PayWithPayPal(string name, string email, string phone,
            string iteminfo, string amount, string currency)
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

            redirecturl += "&item_info=" + iteminfo;

            //Product Name
            redirecturl += "&amount=" + amount;

            //Business contact id
            redirecturl += "&business=judy@jobyco.com";

            //Add quatity i added one only statically 
            redirecturl += "&quantity=1";

            //Currency code 
            redirecturl += "&currency=" + currency;

            //Success return page url
            redirecturl += "&return=" +
              ConfigurationManager.AppSettings["SuccessURL"].ToString();

            //Failed return page url
            redirecturl += "&cancel_return=" +
              ConfigurationManager.AppSettings["FailedURL"].ToString();

            Response.Redirect(redirecturl);
        }

        #region Quote Id Generation

        [WebMethod]
        public static string GenerateQuoteId()
        {
            ///Random Number Generation getting Duplicated
            ///For this reason Insertion failed in DB Table
            ///That's why the following Code Snippet is Blocked

            /*var bytes = new byte[4];
            var rng = RandomNumberGenerator.Create();
            rng.GetBytes(bytes);
            uint random = BitConverter.ToUInt32(bytes, 0) % 100000000;
            string sQuoteId = "JBCOQID" + String.Format("{0:D8}", random);
            return sQuoteId;*/

            return objOP.GetAutoGeneratedValue("QuotingId", "OrderQuoting", "JBCOQ", 10);
        }

        //[WebMethod]
        //public static void AddQuote
        //(
        //    string QuoteId,
        //    string CustomerId,
        //    string BookingId
        //)
        //{
        //    clsQuote objQ = new clsQuote();

        //    objQ.QuoteId = QuoteId;
        //    objQ.CustomerId = CustomerId;
        //    objQ.BookingId = BookingId;

        //    objDB.AddQuote(objQ);
        //}

        #endregion

        [WebMethod]
        public static void uploadImage(string uploadImagePath)
        {
            FileUpload fuPhoto = new FileUpload();
            //fuPhoto.FileName = uploadImagePath;

            string fileExtension = System.IO.Path.GetExtension(uploadImagePath).ToLower();
            string[] extensionsAllowed = { ".jpg", ".png", ".gif" };

            if (extensionsAllowed.Contains(fileExtension))
            {
                fuPhoto.SaveAs(HttpContext.Current.Server.MapPath("/images/items/" + uploadImagePath));
            }
        }
    }
}
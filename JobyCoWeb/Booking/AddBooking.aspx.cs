using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using Newtonsoft.Json;
using PayPal.Api;
using System.Collections.Specialized;

#region Required Global NameSpaces

using DataAccessLayer;
using EntityLayer;
using SecurityLayer;
using JobyCoWeb.Models;
using System.Data;

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb.Booking
{
    public partial class AddBooking : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();
        static string _bookingId;
        static Payment payment;
        #endregion
        static string authorityDomain { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if(string.IsNullOrEmpty(authorityDomain))
             authorityDomain = "http://jobycodirect.com/";// + HttpContext.Current.Request.Url.Authority;

            if (!IsPostBack)
            {
                objCM.PopulateAccessibleMenuItemsOnHiddenField(hfMenusAccessible);

                #region BindDropdown

                DataTable dtCustomers = objOP.GetCustomerIdNames("Customers");
                //objCM.FillDropDown(ddlCustomers, "Customer", dtCustomers);
                //Modified to get the Id field from dropdown
                ddlCustomers.DataSource = dtCustomers;
                ddlCustomers.DataTextField = "CustomerName";
                ddlCustomers.DataValueField = "CustomerId";
                ddlCustomers.DataBind();
                ddlCustomers.Items[0].Text = "Select Customer";
                ddlCustomers.Items[0].Value = "Select Customer";
                ddlCustomers.Items[0].Selected = true;
                try
                {
                    string sCustomerId = Request.QueryString["CustomerId"].Trim().Replace("+", " ");
                    if (sCustomerId != "")
                    {
                        ddlCustomers.SelectedValue = sCustomerId;
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


                        //txtConfirmEmailAddress.Text = ObjLogin.EMAILID.ToString();
                        //txtPickupEmailAddress.Text = ObjLogin.EMAILID.ToString();
                        
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
        public static string GetTaxationDetails(string TotalValue)
        {
            DataTable dtTaxation = objDB.GetTaxationDetails(TotalValue);
            List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            foreach (DataRow drTaxation in dtTaxation.Rows)
            {
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

                objTaxation.Id = Convert.ToInt32(drTaxation["Id"].ToString());
                objTaxation.TaxName = drTaxation["TaxName"].ToString();
                objTaxation.IsRange = Convert.ToBoolean(drTaxation["IsRange"].ToString());
                objTaxation.Active = Convert.ToBoolean(drTaxation["Active"].ToString());
                objTaxation.MinVal = Convert.ToInt32(drTaxation["MinVal"].ToString());
                objTaxation.MaxVal = Convert.ToInt32(drTaxation["MaxVal"].ToString());
                objTaxation.TaxAmount = Convert.ToDecimal(drTaxation["TaxAmount"].ToString());
                objTaxation.IsPercent = Convert.ToBoolean(drTaxation["IsPercent"].ToString());
                objTaxation.RadioChargesType = drTaxation["ChargesType"].ToString();
                lstTaxation.Add(objTaxation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstTaxation);
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
        public static string GetCustomerIdFromCustomerId(string CustomerId)
        {
            DataTable dt = new DataTable();
            EntityLayer.clsCustomers customer = new clsCustomers();

            dt =  objOP.GetCustomerIdFromFullNameAdminBooking(CustomerId);
            if (dt.Rows.Count>0)
            {
                customer.CustomerId = dt.Rows[0]["CustomerId"].ToString();
                customer.CustomerName = dt.Rows[0]["CustomerName"].ToString();
                customer.EmailID = dt.Rows[0]["EmailID"].ToString();
                customer.Mobile = dt.Rows[0]["Mobile"].ToString();
                customer.PostCode = dt.Rows[0]["PostCode"].ToString();
                customer.Title = dt.Rows[0]["Title"].ToString();
            }

            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(customer);
        }

        [WebMethod]
        public static EntityLayer.Booking[] GetAddressesFromCustomerId(string CustomerId)
        {
            DataTable dtAddress = new DataTable();
            List<EntityLayer.Booking> objBookingList = new List<EntityLayer.Booking>();
            dtAddress = objOP.GetAddressesFromCustomerId(CustomerId);

            foreach (DataRow drAddress in dtAddress.Rows)
            {
                EntityLayer.Booking objBooking = new EntityLayer.Booking();
                objBooking.AddressId = Convert.ToInt32(drAddress["Id"].ToString());
                objBooking.PickupName = drAddress["PickupName"].ToString();
                objBooking.PickupAddress = drAddress["PickupAddress"].ToString();
                objBooking.IsDefault = drAddress["IsDefault"].ToString();

                objBookingList.Add(objBooking);
            }

            return objBookingList.ToArray();
        }

        [WebMethod]
        public static EntityLayer.Booking[] GetDeliveryAddressesFromCustomerId(string CustomerId)
        {
            DataTable dtAddress = new DataTable();
            List<EntityLayer.Booking> objBookingList = new List<EntityLayer.Booking>();
            dtAddress = objOP.GetDeliveryAddressesFromCustomerId(CustomerId);

            foreach (DataRow drAddress in dtAddress.Rows)
            {
                EntityLayer.Booking objBooking = new EntityLayer.Booking();
                objBooking.AddressId = Convert.ToInt32(drAddress["Id"].ToString());
                objBooking.DeliveryName = drAddress["DeliveryName"].ToString();
                objBooking.PickupAddress = drAddress["DeliveryAddress"].ToString();

                objBookingList.Add(objBooking);
            }

            return objBookingList.ToArray();
        }

        [WebMethod]
        public static object GetCustomerDetailsFromCustomerName(string AddressId)
        {
            List<clsCustomers> ListCustomers = new List<clsCustomers>();
            DataTable dtCustomers = objOP.GetCustomerDetailsFromCustomerName(AddressId);
            foreach (DataRow drCustomerInfo in dtCustomers.Rows)
            {
                clsCustomers CustomerInfo = new clsCustomers();
                CustomerInfo.CustomerId = drCustomerInfo["CustomerId"].ToString();
                CustomerInfo.Title = drCustomerInfo["PickupTitle"].ToString();
                CustomerInfo.CustomerName = drCustomerInfo["PickupName"].ToString();
                CustomerInfo.Address = drCustomerInfo["Address"].ToString();
                CustomerInfo.EmailID = drCustomerInfo["EmailID"].ToString();
                CustomerInfo.Mobile = drCustomerInfo["Mobile"].ToString();
                CustomerInfo.PostCode = drCustomerInfo["PostCode"].ToString();
                CustomerInfo.LatitudePickup = Convert.ToDecimal(drCustomerInfo["LatitudePickup"].ToString());
                CustomerInfo.LongitudePickup = Convert.ToDecimal(drCustomerInfo["LongitudePickup"].ToString());
                ListCustomers.Add(CustomerInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListCustomers);
        }


        [WebMethod]
        public static object GetCustomerDeliveryDetailsFromCustomerName(string AddressId)
        {
            List<clsCustomers> ListCustomers = new List<clsCustomers>();
            DataTable dtCustomers = objOP.GetCustomerDeliveryDetailsFromCustomerName(AddressId);
            foreach (DataRow drCustomerInfo in dtCustomers.Rows)
            {
                clsCustomers CustomerInfo = new clsCustomers();
                CustomerInfo.CustomerId = drCustomerInfo["CustomerId"].ToString();
                CustomerInfo.Title = drCustomerInfo["DeliveryTitle"].ToString();
                CustomerInfo.CustomerName = drCustomerInfo["DeliveryName"].ToString();
                CustomerInfo.Address = drCustomerInfo["DeliveryAddress"].ToString();
                CustomerInfo.EmailID = drCustomerInfo["EmailID"].ToString();
                CustomerInfo.Mobile = drCustomerInfo["Mobile"].ToString();
                CustomerInfo.PostCode = drCustomerInfo["PostCode"].ToString();
                CustomerInfo.LatitudePickup = Convert.ToDecimal(drCustomerInfo["LatitudeDelivery"].ToString());
                CustomerInfo.LongitudePickup = Convert.ToDecimal(drCustomerInfo["LongitudeDelivery"].ToString());
                ListCustomers.Add(CustomerInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListCustomers);
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
        //    objCustomer.DOB = Convert.ToDateTime(DOB);
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
            //return objOP.GetAutoGeneratedValueOld("BookingId", "OrderBooking", "JB", 5);
            return objOP.GetAutoGeneratedValueClientFormatNew("BookingId", "OrderBooking", "J", 5);
        }

        [WebMethod]
        public static void AddBookingOperation
            (
            string BookingId,
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
            string BookingNotes,
            string OrderStatus,
            string PickupItem,
            string VAT,
            string InsurancePremium,

            //New Parameters Added for few more Pickup and Delivery Fields
            //======================================================
            string PickupName,
            string PickupMobile,
            string AltPickupMobile,

            string DeliveryName,
            string DeliveryMobile,
            string AltDeliveryMobile,

            string PickupPostCode,
            string DeliveryPostCode,

            string LatitudePickup,
            string LongitudePickup,

            string LatitudeDelivery,
            string LongitudeDelivery,
            //======================================================
            string Bookingdate,

            //A Couple of New Fields Added for Pickup and Delivery
            //======================================================
            string PickupEmail,
            string DeliveryEmail,
            //======================================================

            string IsAssigned,
            string WhetherOtherExists,
            string StatusDetails,
            string PickupCustomerTitle,
            string DeliveryCustomerTitle
            )
        {
            EntityLayer.Booking objBooking = new EntityLayer.Booking();

            objBooking.BookingId = BookingId;
            objBooking.CustomerId = CustomerId;
            objBooking.PickupCategory = PickupCategory;

            objBooking.PickupDateTime = Convert.ToDateTime(PickupDateTime,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objBooking.PickupAddress = PickupAddress;
            objBooking.Width = Convert.ToDecimal(Width);
            objBooking.Height = Convert.ToDecimal(Height);
            objBooking.Length = Convert.ToDecimal(Length);
            objBooking.IsFragile = Convert.ToBoolean(IsFragile);
            if (EstimatedValue.Equals(string.Empty) && EstimatedValue == "NaN") EstimatedValue = "0.0";
            objBooking.EstimatedValue = Convert.ToDecimal(EstimatedValue);
            objBooking.ItemCount = Convert.ToInt32(ItemCount);

            if (TotalValue.Equals(string.Empty) && TotalValue=="NaN") TotalValue = "0.0";
            objBooking.TotalValue = Convert.ToDecimal(TotalValue);

            objBooking.DeliveryCategory = DeliveryCategory;

            objBooking.DeliveryDateTime = Convert.ToDateTime(DeliveryDateTime,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objBooking.RecipientAddress = RecipientAddress;
            objBooking.DeliveryQuantity = Convert.ToInt32(DeliveryQuantity);
            objBooking.DeliveryCharge = Convert.ToDecimal(DeliveryCharge);
            if (TotalCharge.Equals(string.Empty) && TotalCharge == "NaN") TotalCharge = "0.0";
            objBooking.TotalCharge = Convert.ToDecimal(TotalCharge);
            objBooking.BookingNotes = BookingNotes;
            objBooking.OrderStatus = OrderStatus;
            objBooking.PickupItem = PickupItem;
            objBooking.VAT = Convert.ToDecimal(VAT);
            objBooking.InsurancePremium = Convert.ToDecimal(InsurancePremium);

            //New Object Property Added for few more Pickup and Delivery Fields
            //======================================================
            objBooking.PickupName = PickupName;
            objBooking.PickupMobile = PickupMobile;
            objBooking.AltPickupMobile = AltPickupMobile;

            objBooking.DeliveryName = DeliveryName;
            objBooking.DeliveryMobile = DeliveryMobile;
            objBooking.AltDeliveryMobile = AltDeliveryMobile;

            objBooking.PickupPostCode = PickupPostCode;
            objBooking.DeliveryPostCode = DeliveryPostCode;

            objBooking.LatitudePickup = Convert.ToDecimal(LatitudePickup);
            objBooking.LongitudePickup = Convert.ToDecimal(LongitudePickup);

            objBooking.LatitudeDelivery = Convert.ToDecimal(LatitudeDelivery);
            objBooking.LongitudeDelivery = Convert.ToDecimal(LongitudeDelivery);
            //======================================================

            objBooking.Bookingdate = Convert.ToDateTime(Bookingdate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            //A Couple of New Fields Added for Pickup and Delivery
            //======================================================
            objBooking.PickupEmail = PickupEmail;
            objBooking.DeliveryEmail = DeliveryEmail;
            //======================================================

            objBooking.IsAssigned = Convert.ToBoolean(IsAssigned);
            objBooking.WhetherOtherExists = Convert.ToBoolean(WhetherOtherExists);
            objBooking.StatusDetails = StatusDetails;
            objBooking.PickupCustomerTitle = PickupCustomerTitle;
            objBooking.DeliveryCustomerTitle = DeliveryCustomerTitle;

            objDB.AddBooking(objBooking);
        }

        [WebMethod]
        public static void AddBookPickup
        (
            string PickupId,
            string BookingId,
            string CustomerId,
            string PickupCategory,
            string PickupItem,
            string IsFragile,
            string EstimatedValue,

            //New Field Added for BookPickup
            //=====================================
            string PredefinedEstimatedValue
            //=====================================
        )
        {
            EntityLayer.BookPickup objBP = new EntityLayer.BookPickup();

            //PickupId = objOP.GetAutoGeneratedValue("PickupId", "BookPickup", "BP", 9);
            //PickupId = objOP.GetAutoGeneratedValueClientFormat("PickupId", "BookPickup", "JBC", 3);
            PickupId = objOP.GetAutoGeneratedValueClientFormatNew("PickupId", "BookPickup", "JP", 5);
            objBP.PickupId = PickupId;

            objBP.BookingId = BookingId;
            objBP.CustomerId = CustomerId;
            objBP.PickupCategory = PickupCategory;
            objBP.PickupItem = PickupItem;
            objBP.IsFragile = Convert.ToBoolean(IsFragile);
            objBP.EstimatedValue = Convert.ToDecimal(EstimatedValue);

            //New Field Added for BookPickup
            //=====================================
            objBP.PredefinedEstimatedValue = Convert.ToDecimal(PredefinedEstimatedValue);
            //=====================================

            objDB.AddBookPickup(objBP);
        }


        [WebMethod]
        public static void AddCharges
        (
            string ChargesId,
            string ChargesName,
            string ChargedAmount,
            string BookingId
        )
        {
            if (!string.IsNullOrEmpty(ChargesId))
            { 
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();
                objTaxation.Id = Convert.ToInt32(ChargesId);
                objTaxation.TaxName = ChargesName;
                objTaxation.TaxAmount = Convert.ToDecimal(ChargedAmount);
                objTaxation.BookingId = BookingId;
                objTaxation.Status = "Add";
                objDB.AddCharges(objTaxation);
            }
        }



        [WebMethod]
        public static void AddImagePickup
        (
            string ImagePickupId,
            string BookingId,
            string CustomerId,
            string PickupCategory,
            string PickupItem,
            string ImageName,
            string ImageUrl
        )
        {
            EntityLayer.ImagePickup objIP = new EntityLayer.ImagePickup();

            //ImagePickupId = objOP.GetAutoGeneratedValue("ImagePickupId", "ImagePickup", "IP", 9);
            ImagePickupId = objOP.GetAutoGeneratedValueClientFormat("ImagePickupId", "ImagePickup", "IP", 3);
            objIP.ImagePickupId = ImagePickupId;

            objIP.BookingId = BookingId;
            objIP.CustomerId = CustomerId;
            objIP.PickupCategoryId = objOP.GetCategoryIdFromName(PickupCategory);
            objIP.PickupItemId = objOP.GetItemIdFromName(PickupItem);
            objIP.ImageName = ImageName;
            objIP.ImageUrl = ImageUrl;

            objDB.AddImagePickup(objIP);
        }

        //[WebMethod]
        //public static string GetImageName(string FileType)
        //{
        //    //Guid uniqId = new Guid();
        //    //uniqId = Guid.NewGuid();
        //    string ImageName = Guid.NewGuid().ToString().Substring(0, 7);
        //    ImageName = ImageName + "." + FileType;
        //    return ImageName;
        //}
        


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
        public static string SendBookingByEmail(string EmailID, string jQueryDataTableContent, string BookingId)
        {
            string sMessage = string.Empty;
            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            //string sFrom = "oliviasand16@gmail.com";
            //string sFromPassword = "Iamthebest@143";

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sTo = EmailID;
            string sSubject = "jobycodirect.com Booking - " + BookingId;

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Booking<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>";
            sBody += "&nbsp;Your jobycodirect.com Booking</h1>";
            sBody += "Thank you for your interest in Jobyco. ";
            sBody += "Please find your recent Booking below, the Booking will be active for a period ";
            sBody += "of 30 days from the date of this email.<br/>";
            sBody += "Bookings can be made and viewed any time in the jobycodirect.com ";
            sBody += "<a href='" + authorityDomain + "'><b><u>Customer Portal</u></b></a>.";
            sBody += "<h1>Booking: - " + BookingId + " </h1>";

            sBody += jQueryDataTableContent;

            //New Line Added for "Other" Category Message
            //=======================================================================================
            sBody += "<h4 style='background-color: navy; color: whitesmoke; padding: 0 0 0 20px;'>";
            sBody += "&nbsp;The Price of Category 'Other' will be paid at Collection</h4>";
            //=======================================================================================

            sBody += "<br/><br/>For Booking Enquiry, please call our Customer Services Team ";
            sBody += "between 8:30 am and 8:30 pm Monday to Friday or between 9:00 am and 6:00 pm ";
            sBody += "Saturday on 01582 574569<br/><br/><br/><br/><br/><br/>";
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

        [WebMethod]
        public static string SendPayLaterEmail(string EmailID, string jQueryDataTableContent, string BookingId)
        {
            string sMessage = string.Empty;
            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            //#region Gmail Credentials
            //string sFrom = "topstarclub2018@gmail.com";
            //string sFromPassword = "TopStarClub@123";
            //#endregion


            string sTo = EmailID;
            string sSubject = "jobycodirect.com Booking - " + BookingId;

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Booking<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>";
            sBody += "&nbsp;Your jobycodirect.com Booking</h1>";
            sBody += "Thank you for your interest in Jobyco. ";
            sBody += "Please find your recent Booking below, the Booking will be active for a period ";
            sBody += "of 30 days from the date of this email.<br/>";
            sBody += "Bookings can be made and viewed any time in the jobycodirect.com ";
            sBody += "<a href='" + authorityDomain + "'><b><u>Customer Portal</u></b></a>.";
            sBody += "<h1>Booking: - " + BookingId + " </h1>";

            sBody += jQueryDataTableContent;

            //New Line Added for "Other" Category Message
            //=======================================================================================
            sBody += "<h4 style='background-color: navy; color: whitesmoke; padding: 0 0 0 20px;'>";
            sBody += "&nbsp;The Price of Category 'Other' will be paid at Collection</h4>";
            //=======================================================================================

            sBody += "<br/><br/>For Booking Enquiry, please call our Customer Services Team ";
            sBody += "between 8:30 am and 8:30 pm Monday to Friday or between 9:00 am and 6:00 pm ";
            sBody += "Saturday on 01582 574569<br/><br/>";

            //New Code Added for Links: -
            //===========================================================================================================================
            sBody += "You can view your Booking from <a href='" + authorityDomain + "/ViewMyBookings.aspx?BookingId=" + BookingId + "'>here</a><br/><br/>";
            sBody += "You can make Payment from <a href='" + authorityDomain + "/ProceedToPayment.aspx?BookingId=" + BookingId + "'>here</a><br/><br/><br/><br/>";
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

            //return objOP.GetAutoGeneratedValue("QuotingId", "OrderQuoting", "JBCOQ", 10);
            return objOP.GetAutoGeneratedValueClientFormat("QuotingId", "OrderQuoting", "JBCOQ", 3);
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


        #region Paypal Payment Getway
        [WebMethod]
        public static string PaymentProceed(string BookingId, string Total, string EmailID)
        {
            _bookingId = BookingId;
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
                                "/PaymentSuccess.aspx?sCustomerId=" + sCustomerId + "&PayPalContactNo=" + PayPalContactNo + "&PaypalEmail=" + PaypalEmail + "&BookingId=" + BookingId;

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

            DataTable dt = new DataTable();
            string sql = "SELECT PickupCategory + SPACE(1) + PickupItem As Items, PredefinedEstimatedValue FROM BookPickup WHERE BookingId ='" + _bookingId + "'";
            dt = objOP.Retrieve_Data(sql, "BookPickup");
            foreach (DataRow dr in dt.Rows)
            {
                ListItems.items.Add(new Item
                {
                    name = dr["Items"].ToString(),
                    currency = "USD",
                    //currency = "GBP",  // Currency for UK
                    price = dr["PredefinedEstimatedValue"].ToString(),
                    quantity = "1",
                    sku = "sku"
                });
            }
            #endregion



            var payer = new Payer() { payment_method = "paypal" };

            // Do the configuration RedirectUrls here with RedirectUrls object
            var redirUrls = new RedirectUrls()
            {
                cancel_url = cancelURI,
                return_url = redirectUrl
            };

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

            //Create details object
            var details = new Details()
            {
                tax = lstTaxation.Where(x => x.ChargesType == "VAT").Sum(x => x.TaxAmount).ToString(),
                insurance = lstTaxation.Where(x => x.ChargesType == "Insurance").Sum(x => x.TaxAmount).ToString(),
                subtotal = (ListItems.items.Sum(x => Convert.ToDecimal(x.price))).ToString()
            };

            decimal GrandTotal = Math.Round(ListItems.items.Sum(x => Convert.ToDecimal(x.price)), 2)
                + Math.Round(lstTaxation.Where(x => x.ChargesType == "Insurance").Sum(x => x.TaxAmount), 2)
                + Math.Round(lstTaxation.Where(x => x.ChargesType == "VAT").Sum(x => x.TaxAmount), 2);

            //Final amount with details
            var amount = new Amount()
            {
                currency = "USD",
                // Total must be equal to sum of tax, shipping and subtotal.
                total = GrandTotal.ToString(),
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

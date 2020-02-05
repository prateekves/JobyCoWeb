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
using System.Security.Cryptography;
using System.Globalization;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class EditBooking : System.Web.UI.Page
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
        public static void AddCustomer
            (
            string CustomerId,
            string EmailID,
            string Password,
            string Title,
            string FirstName,
            string LastName,
            string DOB,
            string Address,
            string Town,
            string Country,
            string PostCode,
            string Mobile,
            string Telephone,
            string HearAboutUs,
            string HavingRegisteredCompany,
            string Locked,
            string ShippingGoodsInCompanyName,
            string RegisteredCompanyName
            )
        {
            EntityLayer.Customer objCustomer = new EntityLayer.Customer();

            objCustomer.CustomerId = CustomerId;
            objCustomer.EmailID = EmailID;
            objCustomer.Password = objCG.getMd5Hash(Password);
            objCustomer.Title = Title;
            objCustomer.FirstName = FirstName;
            objCustomer.LastName = LastName;

            objCustomer.DOB = Convert.ToDateTime(DOB,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objCustomer.Address = Address;
            objCustomer.Town = Town;
            objCustomer.Country = Country;
            objCustomer.PostCode = PostCode;
            objCustomer.Mobile = Mobile;
            objCustomer.Telephone = Telephone;
            objCustomer.HearAboutUs = HearAboutUs;
            objCustomer.HavingRegisteredCompany = Convert.ToBoolean(HavingRegisteredCompany);
            objCustomer.Locked = Convert.ToBoolean(Locked);
            objCustomer.ShippingGoodsInCompanyName = Convert.ToBoolean(ShippingGoodsInCompanyName);
            objCustomer.RegisteredCompanyName = RegisteredCompanyName;

            objDB.AddCustomer(objCustomer);
        }

        [WebMethod]
        public static string GetBookingId()
        {
            return objOP.GetAutoGeneratedValue("BookingId", "OrderBooking", "J", 5);
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
            string DeliveryName,
            string DeliveryMobile,

            string PickupPostCode,
            string DeliveryPostCode,
            //======================================================
            string Bookingdate,

            //A Couple of New Fields Added for Pickup and Delivery
            //======================================================
            string PickupEmail,
            string DeliveryEmail,
            //======================================================

            string IsAssigned,
            string WhetherOtherExists
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
            objBooking.EstimatedValue = Convert.ToDecimal(EstimatedValue);
            objBooking.ItemCount = Convert.ToInt32(ItemCount);
            objBooking.TotalValue = Convert.ToDecimal(TotalValue);
            objBooking.DeliveryCategory = DeliveryCategory;

            objBooking.DeliveryDateTime = Convert.ToDateTime(DeliveryDateTime,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objBooking.RecipientAddress = RecipientAddress;
            objBooking.DeliveryQuantity = Convert.ToInt32(DeliveryQuantity);
            objBooking.DeliveryCharge = Convert.ToDecimal(DeliveryCharge);
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

            objBooking.DeliveryName = DeliveryName;
            objBooking.DeliveryMobile = DeliveryMobile;

            objBooking.PickupPostCode = PickupPostCode;
            objBooking.DeliveryPostCode = DeliveryPostCode;
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
                objTaxation.Status = "Edit";
                objDB.AddCharges(objTaxation);
            }
        }


        [WebMethod]
        public static void RemoveImagePickup
        (
            string BookingId
        )
        {
            //objDB.RemoveImageDetails(BookingId);
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
        public static void UpdateBookingDetails
        (
            string BookingId,
            string RegisteredCompanyName,
            string InsurancePremium,
            string PickupAddress,
            string RecipentAddress,
            string ItemCount,
            string TotalValue,
            string PostCode,

            //New Fields Added for Order Booking 
            //====================================================
            string CollectionName,
            string CollectionMobile,
            string AltPickupMobile,
            string DeliveryName,
            string DeliveryMobile,
            string AltDeliveryMobile,

            string CollectionPostCode,
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
            string PickupTitle,
            string DeliveryTitle,
            string StatusDetails,
            string PickupDateTime
        )
        {
            EntityLayer.BookingPayment objBP = new EntityLayer.BookingPayment();

            objBP.BookingId = BookingId;

            objBP.RegisteredCompanyName = RegisteredCompanyName;
            objBP.InsurancePremium = InsurancePremium;

            objBP.PickupAddress = PickupAddress;
            objBP.RecipentAddress = RecipentAddress;

            objBP.ItemCount = Convert.ToInt32(ItemCount);
            objBP.TotalValue = Convert.ToDecimal(TotalValue);

            objBP.PostCode = PostCode;

            //New Fields Added for Order Booking 
            //====================================================
            objBP.CollectionName = CollectionName;
            objBP.CollectionMobile = CollectionMobile;
            objBP.AltPickupMobile = AltPickupMobile;
            objBP.DeliveryName = DeliveryName;
            objBP.DeliveryMobile = DeliveryMobile;
            objBP.AltDeliveryMobile = AltDeliveryMobile;

            objBP.CollectionPostCode = CollectionPostCode;
            objBP.DeliveryPostCode = DeliveryPostCode;

            objBP.LatitudePickup = Convert.ToDecimal(LatitudePickup);
            objBP.LongitudePickup = Convert.ToDecimal(LongitudePickup);
            objBP.LatitudeDelivery = Convert.ToDecimal(LatitudeDelivery);
            objBP.LongitudeDelivery = Convert.ToDecimal(LongitudeDelivery);
            //====================================================
            objBP.Bookingdate = Convert.ToDateTime(Bookingdate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            //A Couple of New Fields Added for Pickup and Delivery
            //======================================================
            objBP.PickupEmail = PickupEmail;
            objBP.DeliveryEmail = DeliveryEmail;
            //======================================================

            objBP.IsAssigned = Convert.ToBoolean(IsAssigned);
            objBP.WhetherOtherExists = Convert.ToBoolean(WhetherOtherExists);
            objBP.PickupTitle = PickupTitle;
            objBP.DeliveryTitle = DeliveryTitle;
            objBP.StatusDetails = StatusDetails;
            objBP.PickupDateTime = Convert.ToDateTime(PickupDateTime,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objDB.UpdateBookingDetails(objBP);
        }

        [WebMethod]
        public static string SendUpdateBookingEmail(string EmailID, string jQueryDataTableContent, string BookingId)
        {
            string sMessage = string.Empty;
            
            //string sFrom = "switch2web2017@gmail.com";
            //string sFromPassword = "switch2web2017@#";

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = EmailID;
            string sSubject = "jobycodirect.com Booking Update - " + BookingId;

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Booking Update<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>";
            sBody += "&nbsp;Your jobycodirect.com Booking</h1>";
            sBody += "Thank you for your Booking Update in Jobyco. ";
            sBody += "Please find your recent Booking Update below, this Booking Update will be active for a period ";
            sBody += "of 30 days from the date of this email.<br/>";
            sBody += "Booking Updations can be made and viewed any time in the jobycodirect.com ";
            sBody += "<a href='" + authorityDomain + "'><b><u>Customer Portal</u></b></a>.";
            sBody += "<h1>Booking: - " + BookingId + " </h1>";

            sBody += jQueryDataTableContent;

            //New Line Added for "Other" Category Message
            //=======================================================================================
            sBody += "<h4 style='background-color: navy; color: whitesmoke; padding: 0 0 0 20px;'>";
            sBody += "&nbsp;The Price of Category 'Other' will be paid at Collection</h4>";
            //=======================================================================================

            sBody += "<br/><br/>For Booking Update Enquiry, please call our Customer Services Team ";
            sBody += "between 8:30 am and 8:30 pm Monday to Friday or between 9:00 am and 6:00 pm ";
            sBody += "Saturday on 01582 574569<br/><br/>";

            //New Code Added for Links: -
            //===========================================================================================================================
            sBody += "You can view your Booking Update from <a href='" + authorityDomain + "/ViewMyBookings.aspx?BookingId=" + BookingId + "'>here</a><br/><br/>";
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
                    sMessage = "Your Booking Update Details could not be sent into your Email Id";
                }
                else
                {
                    sMessage = "Your Booking Update Details has been sent successfully into your Email Id";
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

        [WebMethod]
        public static void AddQuote
        (
            string QuoteId,
            string CustomerId,
            string BookingId
        )
        {
            clsQuote objQ = new clsQuote();

            objQ.QuoteId = QuoteId;
            objQ.CustomerId = CustomerId;
            objQ.BookingId = BookingId;

            objDB.AddQuote(objQ);
        }

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
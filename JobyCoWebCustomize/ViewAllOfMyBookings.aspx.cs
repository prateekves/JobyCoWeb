using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class ViewAllOfMyBookings : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        string sEmailID = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
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
        public static string GetAllOfMyBookings(string EmailID)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            EmailID = ObjLogin.EMAILID.ToString();
            DataTable dtBooking = objDB.GetAllOfMyBookings(EmailID);

            List<EntityLayer.AllOfMyBookings> lstBooking = new List<EntityLayer.AllOfMyBookings>();

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.AllOfMyBookings objBooking = new EntityLayer.AllOfMyBookings();

                objBooking.BookingId = drBooking["BookingId"].ToString();
                objBooking.CustomerName = drBooking["CustomerName"].ToString();
                objBooking.OrderDate = Convert.ToDateTime(drBooking["OrderDate"].ToString());
                objBooking.InsurancePremium = Convert.ToDecimal(drBooking["InsurancePremium"].ToString());
                objBooking.TotalValue = Convert.ToDecimal(drBooking["TotalValue"].ToString());
                objBooking.OrderStatus = drBooking["OrderStatus"].ToString();

                lstBooking.Add(objBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstBooking);
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
        public static string GetPickupDeliveryFromBookingId(string BookingId)
        {
            List<Booking> ListBooking = new List<Booking>();
            DataTable dtBooking = objDB.GetPickupDeliveryByBookingId(BookingId);

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                Booking booking = new Booking();
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
        public static string ViewBookingDetails(string BookingId)
        {
            DataTable dtBooking = objDB.ViewBookingDetails(BookingId);
            List<EntityLayer.clsBookingDetails> lstBooking = new List<EntityLayer.clsBookingDetails>();

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.clsBookingDetails objBooking = new EntityLayer.clsBookingDetails();

                objBooking.BookingId = drBooking["BookingId"].ToString();
                objBooking.PickupCategoryId = drBooking["PickupCategoryId"].ToString();
                objBooking.PickupItemId = drBooking["PickupItemId"].ToString();
                objBooking.Item = drBooking["Item"].ToString();
                objBooking.Cost = Convert.ToDecimal(drBooking["Cost"].ToString());
                objBooking.EstimatedValue = Convert.ToDecimal(drBooking["EstimatedValue"].ToString());
                objBooking.Status = drBooking["Status"].ToString();

                lstBooking.Add(objBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstBooking);
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
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            sEmailID = ObjLogin.EMAILID.ToString();
            DataTable dtBookings = objDB.GetAllOfMyBookings(sEmailID);
            objCM.DownloadPDF(dtBookings, "Booking");
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            sEmailID = ObjLogin.EMAILID.ToString();
            DataTable dtBookings = objDB.GetAllOfMyBookings(sEmailID);
            objCM.DownloadExcel(dtBookings, "Booking");
        }

        [WebMethod]
        public static void CancelBooking(string BookingId, string OrderStatus, string Reason)
        {
            EntityLayer.Booking objBooking = new EntityLayer.Booking();

            objBooking.BookingId = BookingId;
            objBooking.OrderStatus = OrderStatus;
            objBooking.Reason = Reason;

            objDB.CancelBooking(objBooking);
        }

        [WebMethod]
        public static string GetCustomerIdFromCustomerName(string CustomerName)
        {
            return objOP.GetCustomerIdFromFullName(CustomerName);
        }

        [WebMethod]
        public static string GetCustomerEmailIdFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("EmailID", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerDOBFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("DOB", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerAddressFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Address", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerPostCodeFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("PostCode", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerMobileNoFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Mobile", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerLandlineFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Telephone", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerHearAboutUsFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("HearAboutUs", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetHavingRegisteredCompanyFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("HavingRegisteredCompany", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetRegisteredCompanyNameFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("RegisteredCompanyName", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetShippingGoodsInCompanyNameFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("ShippingGoodsInCompanyName", "Customers", "CustomerId", CustomerId);
        }
    }
}
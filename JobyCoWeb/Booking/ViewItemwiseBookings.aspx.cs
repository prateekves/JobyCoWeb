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
using JobyCoWeb.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb.Booking
{
    public partial class ViewItemwiseBookings : System.Web.UI.Page
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
        public static string GetItemwiseBookings()
        {
            DataTable dtBooking = objDB.GetItemwiseBookings();
            List<EntityLayer.ItemwiseBookings> lstBooking = new List<EntityLayer.ItemwiseBookings>();

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.ItemwiseBookings objBooking = new EntityLayer.ItemwiseBookings();

                objBooking.BookingId = drBooking["BookingId"].ToString();
                objBooking.PickupCategory = drBooking["PickupCategory"].ToString();
                objBooking.PickupItem = drBooking["PickupItem"].ToString();
                objBooking.ItemCount = Convert.ToInt32(drBooking["ItemCount"].ToString());
                objBooking.TotalValue = Convert.ToDecimal(drBooking["TotalValue"].ToString());
                objBooking.BookingDate = Convert.ToDateTime(drBooking["BookingDate"].ToString());

                lstBooking.Add(objBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstBooking);
        }

        [WebMethod]
        public static string GetItemwiseSpecificBookings(string FromDate, string ToDate)
        {
            System.Globalization.CultureInfo uk = new System.Globalization.CultureInfo("en-GB");
            DataTable dtItemwiseBooking = objDB.GetItemwiseSpecificBookings(
                Convert.ToDateTime(FromDate, uk), Convert.ToDateTime(ToDate, uk));

            List<EntityLayer.ItemwiseBookings> lstItemwiseBooking = new List<EntityLayer.ItemwiseBookings>();

            foreach (DataRow drBooking in dtItemwiseBooking.Rows)
            {
                EntityLayer.ItemwiseBookings objItemwiseBooking = new EntityLayer.ItemwiseBookings();

                objItemwiseBooking.BookingId = drBooking["BookingId"].ToString();
                objItemwiseBooking.PickupCategory = drBooking["PickupCategory"].ToString();
                objItemwiseBooking.PickupItem = drBooking["PickupItem"].ToString();
                objItemwiseBooking.ItemCount = Convert.ToInt32(drBooking["ItemCount"].ToString());
                objItemwiseBooking.TotalValue = Convert.ToDecimal(drBooking["TotalValue"].ToString());
                objItemwiseBooking.BookingDate = Convert.ToDateTime(drBooking["BookingDate"].ToString());

                lstItemwiseBooking.Add(objItemwiseBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstItemwiseBooking);
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

        [WebMethod]
        public static string ViewBookingDetails(string BookingId)
        {
            DataTable dtBooking = objDB.ViewBookingDetails(BookingId);
            List<EntityLayer.clsBookingDetails> lstBooking = new List<EntityLayer.clsBookingDetails>();

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.clsBookingDetails objBooking = new EntityLayer.clsBookingDetails();

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
            DataTable dtBookings = objDB.GetItemwiseBookings();
            objCM.DownloadPDF(dtBookings, "Booking");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtBookings = objDB.GetItemwiseBookings();
            objCM.DownloadExcel(dtBookings, "Booking");
        }
    }
}
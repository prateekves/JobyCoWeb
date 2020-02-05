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

namespace JobyCoWeb.Ghana
{
    public partial class AssignBookingToDriverForDelivery : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            objCM.ResetMessageBar(lblErrMsg);

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
                        Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());

                    }
                }

                #endregion

                DataTable dtDrivers = objOP.GetDriversForDelivery("Ghana");
                objCM.FillDropDownByFields(ddlDrivers, "Name", dtDrivers);
            }
        }

        [WebMethod]
        public static string GetDriverId(string DriverName)
        {
            return objOP.GetDriverIdFromFullName(DriverName);
        }

        [WebMethod]
        public static string GetDriverType(string DriverId)
        {
            return objOP.RetrieveField2FromField1("DriverType", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetWageType(string DriverId)
        {
            return objOP.RetrieveField2FromField1("WageType", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetDriverWage(string DriverType, string WageType)
        {
            return objOP.RetrieveField3FromField1AndField2("Wage", "DriverWage"
                , "DriverType", DriverType, "WageType", WageType);
        }

        [WebMethod]
        public static string GetAllUnassignedBookings()
        {
            DataTable dtUnassignedBooking = objDB.GetAllUnassignedBookings("Ghana");
            List<EntityLayer.AllUnassignedBookings> lstUnassignedBooking = new List<EntityLayer.AllUnassignedBookings>();

            foreach (DataRow drBooking in dtUnassignedBooking.Rows)
            {
                EntityLayer.AllUnassignedBookings objUnassignedBooking = new EntityLayer.AllUnassignedBookings();

                objUnassignedBooking.BookingId = drBooking["BookingId"].ToString();
                objUnassignedBooking.CustomerName = drBooking["CustomerName"].ToString();
                objUnassignedBooking.PickupDateTime = Convert.ToDateTime(drBooking["PickupDateTime"].ToString());
                objUnassignedBooking.PickupAddress = drBooking["PickupAddress"].ToString();
                objUnassignedBooking.OrderStatus = drBooking["OrderStatus"].ToString();
                objUnassignedBooking.PickupPostCode = drBooking["PickupPostCode"].ToString();
                objUnassignedBooking.PickupMobile = drBooking["PickupMobile"].ToString();

                lstUnassignedBooking.Add(objUnassignedBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUnassignedBooking);
        }

        [WebMethod]
        public static string GetAllUnassignedSpecificBookings(string FromDate, string ToDate)
        {
            System.Globalization.CultureInfo uk = new System.Globalization.CultureInfo("en-GB");
            DataTable dtUnassignedBooking = objDB.GetAllUnassignedSpecificBookings(
                Convert.ToDateTime(FromDate, uk), Convert.ToDateTime(ToDate, uk), "Ghana");

            List<EntityLayer.AllUnassignedBookings> lstUnassignedBooking = new List<EntityLayer.AllUnassignedBookings>();

            foreach (DataRow drBooking in dtUnassignedBooking.Rows)
            {
                EntityLayer.AllUnassignedBookings objUnassignedBooking = new EntityLayer.AllUnassignedBookings();

                objUnassignedBooking.BookingId = drBooking["BookingId"].ToString();
                objUnassignedBooking.CustomerName = drBooking["CustomerName"].ToString();
                objUnassignedBooking.PickupDateTime = Convert.ToDateTime(drBooking["PickupDateTime"].ToString());
                objUnassignedBooking.PickupAddress = drBooking["PickupAddress"].ToString();
                objUnassignedBooking.OrderStatus = drBooking["OrderStatus"].ToString();
                objUnassignedBooking.PickupPostCode = drBooking["PickupPostCode"].ToString();
                objUnassignedBooking.PickupMobile = drBooking["PickupMobile"].ToString();

                lstUnassignedBooking.Add(objUnassignedBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUnassignedBooking);
        }

        [WebMethod]
        public static string AddAssignBookingToDriver(
           string AssignId,
           string DriverId,
           string BookingId,
           string FromDate,
           string ToDate,
           string PickupAddress,
           string PickupPostCode,
           string PickupMobile,
           string Wage
            )
        {
            EntityLayer.AssignBookingToDriver objAssign = new EntityLayer.AssignBookingToDriver();

            AssignId = objOP.GetAutoGeneratedValue("AssignId", "AssignBookingForDelivery", "ASGN", 9);
            objAssign.AssignId = AssignId;
            objAssign.DriverId = DriverId;
            objAssign.BookingId = BookingId;

            objAssign.FromDate = Convert.ToDateTime(FromDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objAssign.ToDate = Convert.ToDateTime(ToDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objAssign.PickupAddress = PickupAddress;
            objAssign.PickupPostCode = PickupPostCode;
            objAssign.PickupMobile = PickupMobile;

            objAssign.Wage = Convert.ToDecimal(Wage);
            objAssign.OptionType = "Ghana";

            objDB.AddAssignBookingToDriver(objAssign);

            var AssignList = new JavaScriptSerializer();
            return AssignList.Serialize(objAssign.BookingId);
        }

        [WebMethod]
        public static void UpdateIsAssignedInOrderBooking(string BookingId)
        {
            objDB.UpdateIsAssignedInOrderBooking(BookingId, "Ghana");
        }

        [WebMethod]
        public static void AddDriverPayment
        (
            string PaymentId,
            string DriverId,
            string DriverType,
            string WageType,
            string ExpectedAmount,
            string AmountReceived,
            string Discrepancy,
            string CreditDebitNote
        )
        {
            EntityLayer.clsAddDriverPayment objDriverPayment = new EntityLayer.clsAddDriverPayment();

            PaymentId = objOP.GetAutoGeneratedValue("PaymentId", "DriverPayment", "PAY", 9);
            objDriverPayment.PaymentId = PaymentId;
            objDriverPayment.DriverId = DriverId;
            objDriverPayment.DriverType = DriverType;
            objDriverPayment.WageType = WageType;

            objDriverPayment.ExpectedAmount = Convert.ToDecimal(ExpectedAmount);
            objDriverPayment.AmountReceived = Convert.ToDecimal(AmountReceived);
            objDriverPayment.Discrepancy = Convert.ToDecimal(Discrepancy);

            objDriverPayment.CreditDebitNote = CreditDebitNote;

            objDB.AddDriverPayment(objDriverPayment);
        }
        protected void btnEditBooking_Click(object sender, EventArgs e)
        {
            //Fetch values from GridView
            string sBookingId = spBodyBookingId.InnerText.Trim().Remove(0, 1);

            Response.Redirect("/EditBooking.aspx?BookingId=" + sBookingId);
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

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtUnassignedBooking = objDB.GetAllUnassignedBookings("Ghana");
            objCM.DownloadPDF(dtUnassignedBooking, "AssignBookingToDriver");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtUnassignedBooking = objDB.GetAllUnassignedBookings("Ghana");
            objCM.DownloadExcel(dtUnassignedBooking, "AssignBookingToDriver");
        }
        [WebMethod]
        public static void CancelBooking(string BookingId, string OrderStatus)
        {
            EntityLayer.Booking objBooking = new EntityLayer.Booking();

            objBooking.BookingId = BookingId;
            objBooking.OrderStatus = OrderStatus;

            objDB.CancelBooking(objBooking);
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

                ListBooking.Add(booking);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBooking);
        }

    }
}
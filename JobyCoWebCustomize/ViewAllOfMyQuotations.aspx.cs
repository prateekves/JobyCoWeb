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
    public partial class ViewAllOfMyQuotations : System.Web.UI.Page
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
                        catch { }
                    }
                }

                #endregion
            }
        }

        [WebMethod]
        public static string GetAllOfMyQuotations(string EmailID)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            EmailID = ObjLogin.EMAILID.ToString();
            DataTable dtQuotation = objDB.GetAllOfMyQuotations(EmailID);

            List<EntityLayer.AllOfMyQuotations> lstQuotation = new List<EntityLayer.AllOfMyQuotations>();

            foreach (DataRow drQuotation in dtQuotation.Rows)
            {
                EntityLayer.AllOfMyQuotations objQuotation = new EntityLayer.AllOfMyQuotations();

                objQuotation.QuotingId = drQuotation["QuotingId"].ToString();
                objQuotation.CustomerName = drQuotation["CustomerName"].ToString();
                objQuotation.QuotationDate = Convert.ToDateTime(drQuotation["QuotationDate"].ToString());
                objQuotation.TotalValue = Convert.ToDecimal(drQuotation["TotalValue"].ToString());

                lstQuotation.Add(objQuotation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstQuotation);
        }

        [WebMethod]
        public static string ViewQuotingDetails(string QuotingId)
        {
            DataTable dtQuotation = objDB.ViewQuotingDetails(QuotingId);
            List<EntityLayer.QuotingDetails> lstQuotation = new List<EntityLayer.QuotingDetails>();

            foreach (DataRow drQuotation in dtQuotation.Rows)
            {
                EntityLayer.QuotingDetails objQuotation = new EntityLayer.QuotingDetails();

                objQuotation.Item = drQuotation["Item"].ToString();
                objQuotation.IsFragile = drQuotation["IsFragile"].ToString();
                objQuotation.Cost = Convert.ToDecimal(drQuotation["Cost"].ToString());
                objQuotation.EstimatedValue = Convert.ToDecimal(drQuotation["EstimatedValue"].ToString());
                objQuotation.Status = drQuotation["Status"].ToString();

                lstQuotation.Add(objQuotation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstQuotation);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            sEmailID = ObjLogin.EMAILID.ToString();
            DataTable dtQuotations = objDB.GetAllOfMyQuotations(sEmailID);
            objCM.DownloadPDF(dtQuotations, "Quotation");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            sEmailID = ObjLogin.EMAILID.ToString();
            DataTable dtQuotations = objDB.GetAllOfMyQuotations(sEmailID);
            objCM.DownloadExcel(dtQuotations, "Quotation");
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

        //===================== Customer Details from Quoting Id ===========================
        [WebMethod]
        public static string GetCustomerIdFromQuotationId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("CustomerId", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetCustomerIdFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("CustomerId", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetCustomerMobileFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Mobile", "Customers", "CustomerId", CustomerId);
        }

        //====================Quoting Modal Popup just Like Booking Modal Popup===================
        [WebMethod]
        public static string GetPickupCategoryFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupCategory", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupNameFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupName", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupAddressFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupAddress", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupMobileFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupMobile", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetDeliveryNameFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryName", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetDeliveryAddressFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("RecipentAddress", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetDeliveryMobileFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryMobile", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupDateAndTimeFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupDateTime", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetVATfromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("VAT", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetOrderTotalFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("TotalValue", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetOrderStatusFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("OrderStatus", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetIsFragileFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("IsFragile", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetItemCountFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("ItemCount", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetQuotingNotesFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("QuotingNotes", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetInsurancePremiumFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("InsurancePremium", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupPostCodeFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupPostCode", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetDeliveryPostCodeFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryPostCode", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetQuotingDateFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("Quotingdate", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupEmailFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupEmail", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetDeliveryEmailFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryEmail", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetDeliveryDateTimeFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("DeliveryDateTime", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetEstimatedValueFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("EstimatedValue", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetPickupItemFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("PickupItem", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string GetWhetherOtherExistsFromQuotingId(string QuotingId)
        {
            return objOP.RetrieveField2FromField1("WhetherOtherExists", "OrderQuoting", "QuotingId", QuotingId);
        }

        [WebMethod]
        public static string ViewQuotationDetails(string QuotingId)
        {
            DataTable dtQuoting = objDB.ViewQuotationDetails(QuotingId);
            List<EntityLayer.clsQuotingDetails> lstQuoting = new List<EntityLayer.clsQuotingDetails>();

            foreach (DataRow drQuoting in dtQuoting.Rows)
            {
                EntityLayer.clsQuotingDetails objQuoting = new EntityLayer.clsQuotingDetails();

                objQuoting.Item = drQuoting["Item"].ToString();
                objQuoting.IsFragile = drQuoting["IsFragile"].ToString();
                objQuoting.Cost = Convert.ToDecimal(drQuoting["Cost"].ToString());
                objQuoting.EstimatedValue = Convert.ToDecimal(drQuoting["EstimatedValue"].ToString());
                objQuoting.Status = drQuoting["Status"].ToString();

                lstQuoting.Add(objQuoting);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstQuoting);
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

            BookingId = GetBookingId();
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
            PickupId = objOP.GetAutoGeneratedValueClientFormat("PickupId", "BookPickup", "JBC", 3);
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
        public static void UpdateQuotationFlag(string QuotingId)
        {
            objDB.UpdateQuotationFlag(QuotingId);
        }
    }
}
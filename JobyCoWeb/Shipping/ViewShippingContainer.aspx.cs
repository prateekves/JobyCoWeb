using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

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

namespace JobyCoWeb.Shipping
{
    public partial class ViewShippingContainer : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

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
                        Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());
                    }
                }

                #endregion

            }
        }

        [WebMethod]
        public static string GetAllShippingsByContainer(string CN)
        {
            DataTable dtShipping = objDB.GetAllShippings(CN);
            List<EntityLayer.clsShipping> lstShipping = new List<EntityLayer.clsShipping>();

            foreach (DataRow drShipping in dtShipping.Rows)
            {
                EntityLayer.clsShipping objShipping = new EntityLayer.clsShipping();

                objShipping.ShippingReferenceNumber = drShipping["ShippingId"].ToString();
                objShipping.ContainerNumber = drShipping["ContainerId"].ToString();
               
                objShipping.BookingNumber = drShipping["BookingId"].ToString();
                objShipping.InvoiceNumber = drShipping["InvoiceNumber"].ToString();
               
                objShipping.InvoiceAmount = Convert.ToDecimal(drShipping["InvoiceAmount"].ToString());
                objShipping.PaidAmount = Convert.ToDecimal(drShipping["Paid"].ToString());
                objShipping.NoOfItems = Convert.ToInt32(drShipping["Items"].ToString());
                objShipping.NoOfLoadedItems = Convert.ToInt32(drShipping["Loaded"].ToString());
                objShipping.NoOfRemainingItems = Convert.ToInt32(drShipping["Remaining"].ToString());

                lstShipping.Add(objShipping);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstShipping);
        }

        [WebMethod]
        public static string GetAllShippingsByDate(string _startDate, string _endDate)
        {
            DateTime startDate, endDate;
            DataTable dtShipping = new DataTable();
            if (DateTime.TryParse(_startDate, out startDate) && DateTime.TryParse(_endDate, out endDate))
            {
                dtShipping = objDB.GetAllShippings(startDate, endDate);
            }
            else
            {
                dtShipping = objDB.GetAllShippings();
            }

            List<EntityLayer.clsShipping> lstShipping = new List<EntityLayer.clsShipping>();

            foreach (DataRow drShipping in dtShipping.Rows)
            {
                EntityLayer.clsShipping objShipping = new EntityLayer.clsShipping();

                objShipping.ShippingReferenceNumber = drShipping["ShippingId"].ToString();
                objShipping.ContainerNumber = drShipping["ContainerId"].ToString();
                //objShipping.SealReferenceNumber = drShipping["SealId"].ToString();
                objShipping.BookingNumber = drShipping["BookingId"].ToString();
                objShipping.InvoiceNumber = drShipping["InvoiceNumber"].ToString();
                objShipping.CustomerName = drShipping["CustomerName"].ToString();
                objShipping.ShippingFrom = drShipping["ShippingFrom"].ToString();
                objShipping.ShippingTo = drShipping["ShippingTo"].ToString();
                objShipping.ShippingPort = drShipping["ShippingPort"].ToString();
                objShipping.FreightName = drShipping["FreightType"].ToString();
                objShipping.ShippingDate = Convert.ToDateTime(drShipping["ShippingDate"].ToString());
                objShipping.ArrivalDate = Convert.ToDateTime(drShipping["ArrivalDate"].ToString());
                objShipping.Consignee = drShipping["Consignee"].ToString();
                //objShipping.InvoiceAmount = Convert.ToDecimal(drShipping["InvoiceAmount"].ToString());
                //objShipping.PaidAmount = Convert.ToDecimal(drShipping["Paid"].ToString());
                //objShipping.NoOfItems = Convert.ToInt32(drShipping["ItemCount"].ToString());
                //objShipping.NoOfLoadedItems = Convert.ToInt32(drShipping["Loaded"].ToString());
                //objShipping.NoOfRemainingItems = Convert.ToInt32(drShipping["Remaining"].ToString());

                lstShipping.Add(objShipping);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstShipping);
        }
        
        [WebMethod]
        public static object GetCustomerInformationByBookingId(string BookingId)
        {
            List<CustomerInformation> ListCustomerInfo = new List<CustomerInformation>();
            DataTable dtCustomerInfo = objDB.GetCustomerInfoItemsFromBookingId(BookingId);
            foreach (DataRow drCustomerInfo in dtCustomerInfo.Rows)
            {
                CustomerInformation CustomerInfo = new CustomerInformation();
                CustomerInfo.BookingId = drCustomerInfo["BookingId"].ToString();
                CustomerInfo.CustomerId = drCustomerInfo["CustomerId"].ToString();
                CustomerInfo.CustomerName = drCustomerInfo["CustomerName"].ToString();
                CustomerInfo.PickupAddress = drCustomerInfo["PickupAddress"].ToString();
                CustomerInfo.DeliveryAddress = drCustomerInfo["DeliveryAddress"].ToString();
                CustomerInfo.Mobile = drCustomerInfo["Mobile"].ToString();
                CustomerInfo.Email = drCustomerInfo["Email"].ToString();

                ListCustomerInfo.Add(CustomerInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListCustomerInfo);
        }

        
        [WebMethod]
        public static object GetPickupItemsByBookingId(string ContainerId, string BookingId)
        {
            List<PickupItems> ListPickupItems = new List<PickupItems>();
            DataTable dtPickupItems = objDB.GetPickupItemsByBookingId(ContainerId, BookingId);
            foreach (DataRow drPickupItems in dtPickupItems.Rows)
            {
                PickupItems pickupItems = new PickupItems();
                pickupItems.BookingId = drPickupItems["BookingId"].ToString();
                pickupItems.Items = drPickupItems["Items"].ToString();
                pickupItems.Cost = Convert.ToDecimal(drPickupItems["Cost"].ToString());
                pickupItems.EstimatedValue = Convert.ToDecimal(drPickupItems["EstimatedValue"].ToString());
                pickupItems.Status = drPickupItems["Status"].ToString();

                ListPickupItems.Add(pickupItems);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListPickupItems);
        }

        //[WebMethod]
        //public static object GetDeliveryItemsByBookingId(string BookingId)
        //{
        //    List<DeliveryItem> ListDeliveryItems = new List<DeliveryItem>();
        //    DataTable dtDeliveryItems = objDB.GetDeliveryItemsByBookingId(BookingId);
        //    foreach (DataRow drDeliveryItems in dtDeliveryItems.Rows)
        //    {
        //        DeliveryItem deliveryItem = new DeliveryItem();
        //        deliveryItem.BookingId = drDeliveryItems["BookingId"].ToString();
        //        deliveryItem.Items = drDeliveryItems["Items"].ToString();
        //        deliveryItem.Quantity = Convert.ToInt32(drDeliveryItems["Quantity"].ToString());
        //        deliveryItem.Cost = Convert.ToDecimal(drDeliveryItems["Cost"].ToString());
        //        deliveryItem.Status = drDeliveryItems["Status"].ToString();

        //        ListDeliveryItems.Add(deliveryItem);
        //    }
        //    var jsonSerialiser = new JavaScriptSerializer();
        //    return jsonSerialiser.Serialize(ListDeliveryItems);
        //}


        [WebMethod]
        public static object GetBookingByBookingId(string BookingId)
        {
            List<BookingCalculation> ListBookingCalculation = new List<BookingCalculation>();
            DataTable dtBookingCalculation = objDB.GetBookingByBookingId(BookingId);
            foreach (DataRow drBookingCalculation in dtBookingCalculation.Rows)
            {
                BookingCalculation bookingCalculation = new BookingCalculation();
                bookingCalculation.OrderSubTotal  = Convert.ToDecimal(drBookingCalculation["OrderSubTotal"].ToString());
                bookingCalculation.Vat = Convert.ToDecimal(drBookingCalculation["VAT"].ToString());
                bookingCalculation.OrderTotal = Convert.ToDecimal(drBookingCalculation["OrderTotal"].ToString());


                ListBookingCalculation.Add(bookingCalculation);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBookingCalculation);
        }
        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtShippings = objDB.GetAllShippings();
            objCM.DownloadPDF(dtShippings, "Shipping");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtShippings = objDB.GetAllShippings();
            objCM.DownloadExcel(dtShippings, "Shipping");
        }

        [WebMethod]
        public static void UpdateShippingDetails
        (
            string ShippingReferenceNumber,
            string BookingNumber,
            string InvoiceNumber,
            string CustomerName,
            string ShippingFrom,
            string ShippingTo,
            string ShippingPort,
            string FreightType,
            string ShippingDate,
            string ArrivalDate,
            string Consignee
        )
        {
            EntityLayer.clsShipping objShipping = new EntityLayer.clsShipping();

            objShipping.ShippingReferenceNumber = ShippingReferenceNumber;
            objShipping.BookingNumber = BookingNumber;

            objShipping.InvoiceNumber = InvoiceNumber;
            objShipping.CustomerName = CustomerName;

            objShipping.ShippingFrom = ShippingFrom;
            objShipping.ShippingTo = ShippingTo;

            objShipping.ShippingPort = ShippingPort;
            objShipping.FreightName = FreightType;

            objShipping.ShippingDate = Convert.ToDateTime(ShippingDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.ArrivalDate = Convert.ToDateTime(ArrivalDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.Consignee = Consignee;

            objDB.UpdateShippingDetails(objShipping);
        }

        [WebMethod]
        public static void RemoveShippingDetails(string ShippingId)
        {
            objDB.RemoveShippingDetails(ShippingId);
        }

        [WebMethod]
        public static string GetContainerIdFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("ContainerId", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetSealIdFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("SealId", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetConsigneeFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("Consignee", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetInvoiceNumberFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("InvoiceNumber", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetInvoiceAmountFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("InvoiceAmount", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetPaidAmountFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("Paid", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetItemCountFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("ItemCount", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetLoadedItemsFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("Loaded", "Shipping", "ShippingId", ShippingId);
        }

        [WebMethod]
        public static string GetRemainingItemsFromShippingId(string ShippingId)
        {
            return objOP.RetrieveField2FromField1("Remaining", "Shipping", "ShippingId", ShippingId);
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
    }
}
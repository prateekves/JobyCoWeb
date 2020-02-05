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

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Web.Services;
using System.Web.Script.Serialization;
using Newtonsoft.Json.Linq;

#endregion

namespace JobyCoWeb.Shipping
{
    public partial class EditShipping : System.Web.UI.Page
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

                #region ddlBookingId

                DataTable dtBookingIds = objDB.GetAllBookingIds("edit");
                objCM.FillDropDown(ddlBookingId, "BookingId", dtBookingIds);


                try
                {
                    string sBookingId = Request.QueryString["BookingId"].Trim().Replace("+", " ");
                    if (sBookingId != "")
                    {
                        ddlBookingId.SelectedItem.Text = sBookingId;
                    }
                }
                catch
                {

                }

                #endregion

            }
        }
        [WebMethod]
        public static object getShippingDetailsFromContainerNo(string ContainerNo)
        {
            List<Shippings> ListShippingsInfo = new List<Shippings>();
            DataSet dsShippingInfo = objDB.GetShippingDetailsFromContainerNo(ContainerNo);
            int iCount = 0;
            int iInnCount = 0;
            foreach (DataRow drShippingInfo in dsShippingInfo.Tables[0].Rows)
            {    
                Shippings ShippingsInfo = new Shippings();
                ShippingsInfo.ShippingId = drShippingInfo["ShippingId"].ToString();
                ShippingsInfo.ContainerId = drShippingInfo["ContainerId"].ToString();
                ShippingsInfo.SealId = drShippingInfo["SealId"].ToString();
                ShippingsInfo.ShippingFrom = drShippingInfo["ShippingFrom"].ToString();
                ShippingsInfo.ShippingTo = drShippingInfo["ShippingTo"].ToString();
                ShippingsInfo.ShippingDate = Convert.ToDateTime(drShippingInfo["ShippingDate"].ToString());
                ShippingsInfo.ArrivalDate = Convert.ToDateTime(drShippingInfo["ArrivalDate"].ToString());
                ShippingsInfo.ETA = Convert.ToDateTime(drShippingInfo["ETA"].ToString()); 
                ShippingsInfo.Consignee = drShippingInfo["Consignee"].ToString();
                ShippingsInfo.Shipped = Convert.ToInt32(drShippingInfo["Shipped"].ToString());
                ShippingsInfo.WarehouseId = drShippingInfo["WarehouseId"].ToString();

                foreach (DataRow drShippingDetailsInfo in dsShippingInfo.Tables[1].Rows)
                {
                    
                    ShippingDetails ShippingDetails = new ShippingDetails();
                    ShippingDetails.BookingId = drShippingDetailsInfo["BookingId"].ToString();
                    ShippingDetails.InvoiceNumber = drShippingDetailsInfo["InvoiceNumber"].ToString();
                    ShippingDetails.InvoiceAmount = Convert.ToDecimal(drShippingDetailsInfo["InvoiceAmount"].ToString());
                    ShippingDetails.Paid = Convert.ToDecimal(drShippingDetailsInfo["Paid"].ToString());
                    ShippingDetails.Items = Convert.ToInt32(drShippingDetailsInfo["Items"].ToString());
                    ShippingDetails.Loaded = drShippingDetailsInfo["Loaded"].ToString();
                    ShippingDetails.Remaining = drShippingDetailsInfo["Remaining"].ToString();

                    //foreach (DataRow drShippingItemDetailsInfo in dsShippingInfo.Tables[2].Rows)
                    //{
                    //    ShippingItemDetails shippingItemDetails = new ShippingItemDetails();
                    //    shippingItemDetails.BookingId = drShippingItemDetailsInfo["BookingId"].ToString();
                    //    shippingItemDetails.PickupId = drShippingItemDetailsInfo["PickupId"].ToString();
                    //    shippingItemDetails.CategoryId = drShippingItemDetailsInfo["CategoryId"].ToString();
                    //    shippingItemDetails.CategoryItemId = drShippingItemDetailsInfo["CategoryItemId"].ToString();
                    //    ShippingsInfo.listShippingDetails[iCount].listShippingItemDetails.Add(shippingItemDetails);
                    //}
                    ShippingsInfo.listShippingDetails.Add(ShippingDetails);
                    //iInnCount++;
                }

                ListShippingsInfo.Add(ShippingsInfo);
                //iCount++;
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListShippingsInfo);
        }

        [WebMethod]
        public static object GetShippingitemDetailsByBookingId(string ContainerId, string BookingId)
        {
            DataTable dtShippingitemDetails = objDB.GetShippingitemDetailsByBookingId(ContainerId, BookingId);
            List<ShippingItemDetails> listShippingDetails = new List<ShippingItemDetails>();

            foreach (DataRow drShippingItemDetails in dtShippingitemDetails.Rows)
            {
                ShippingItemDetails shippingItemDetails = new ShippingItemDetails();
                shippingItemDetails.BookingId = drShippingItemDetails["BookingId"].ToString();
                shippingItemDetails.PickupId = drShippingItemDetails["PickupId"].ToString();
                shippingItemDetails.CategoryId = drShippingItemDetails["CategoryId"].ToString();
                shippingItemDetails.CategoryItemId= drShippingItemDetails["CategoryItemId"].ToString();
                listShippingDetails.Add(shippingItemDetails);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(listShippingDetails);

        }

        [WebMethod]
        public static int MarkContainerShipped(string ShippingId, string ContainerId)
        {
            int Success = objDB.MarkContainerShipped(ShippingId, ContainerId);
            return Success;
        }

        [WebMethod]
        public static int CancelShipped(string ShippingId, string ContainerId)
        {
            int Success = objDB.CancelShipped(ShippingId, ContainerId);
            return Success;
        }

        [WebMethod]
        public static object GetBookingInfoItemsFromBookingId(string BookingId, int IsAdd, string ContainerId)
        {
            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.GetBookingInfoItemsFromBookingId(BookingId, IsAdd, ContainerId, "Add");
            foreach (DataRow drBookingInfo in dtBookingInfo.Rows)
            {
                BookingInformationForShipping BookingInfo = new BookingInformationForShipping();
                BookingInfo.BookingId = drBookingInfo["BookingId"].ToString();


                BookingInfo.PickupId = drBookingInfo["PickupId"].ToString();
                BookingInfo.BookingId = drBookingInfo["BookingId"].ToString();
                BookingInfo.CustomerId = drBookingInfo["CustomerId"].ToString();
                BookingInfo.FirstName = drBookingInfo["FirstName"].ToString();
                BookingInfo.LastName = drBookingInfo["LastName"].ToString();
                BookingInfo.Mobile = drBookingInfo["Mobile"].ToString();
                BookingInfo.PickupCategoryId = drBookingInfo["PickupCategoryId"].ToString();
                BookingInfo.PickupCategory = drBookingInfo["PickupCategory"].ToString();
                BookingInfo.PickupCategory = drBookingInfo["PickupCategory"].ToString();
                BookingInfo.PickupItemId = drBookingInfo["PickupItemId"].ToString();
                BookingInfo.PickupItem = drBookingInfo["PickupItem"].ToString();

                BookingInfo.PickupName = drBookingInfo["PickupName"].ToString();
                BookingInfo.PickupAddress = drBookingInfo["PickupAddress"].ToString();
                BookingInfo.PickupPostCode = drBookingInfo["PickupPostCode"].ToString();
                BookingInfo.PickupEmail = drBookingInfo["PickupEmail"].ToString();
                BookingInfo.PickupMobile = drBookingInfo["PickupMobile"].ToString();
                

                BookingInfo.DeliveryName = drBookingInfo["DeliveryName"].ToString();
                BookingInfo.RecipentAddress = drBookingInfo["RecipentAddress"].ToString();
                BookingInfo.DeliveryMobile = drBookingInfo["DeliveryMobile"].ToString();
                BookingInfo.DeliveryPostCode = drBookingInfo["DeliveryPostCode"].ToString();
                BookingInfo.DeliveryEmail = drBookingInfo["DeliveryEmail"].ToString();
                BookingInfo.BookingNotes = drBookingInfo["BookingNotes"].ToString();
                
                BookingInfo.IsFragile = Convert.ToBoolean(drBookingInfo["IsFragile"]);
                BookingInfo.EstimatedValue = Convert.ToDecimal(drBookingInfo["EstimatedValue"]);
                BookingInfo.PredefinedEstimatedValue = Convert.ToDecimal(drBookingInfo["PredefinedEstimatedValue"]);
                BookingInfo.IsPickedForShipping = Convert.ToInt32(drBookingInfo["IsPickedForShipping"]);
                BookingInfo.Items = drBookingInfo["Items"].ToString();
                BookingInfo.Loaded = drBookingInfo["Loaded"].ToString();
                BookingInfo.Remaining = drBookingInfo["Remaining"].ToString();
                BookingInfo.Status = drBookingInfo["Status"].ToString();
                BookingInfo.Shipped = Convert.ToInt32(drBookingInfo["Shipped"].ToString());
                BookingInfo.InvoiceNumber = drBookingInfo["InvoiceNumber"].ToString();
                BookingInfo.InvoiceAmount = drBookingInfo["InvoiceAmount"].ToString();
                BookingInfo.Paid = drBookingInfo["Paid"].ToString();


                ListBookingInfo.Add(BookingInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBookingInfo);
        }

        [WebMethod]
        public static object GetBookingByBookingId(string BookingId)
        {
            List<BookingCalculation> ListBookingCalculation = new List<BookingCalculation>();
            DataTable dtBookingCalculation = objDB.GetBookingByBookingId(BookingId);
            foreach (DataRow drBookingCalculation in dtBookingCalculation.Rows)
            {
                BookingCalculation bookingCalculation = new BookingCalculation();
                bookingCalculation.OrderSubTotal = Convert.ToDecimal(drBookingCalculation["OrderSubTotal"].ToString());
                bookingCalculation.Vat = Convert.ToDecimal(drBookingCalculation["VAT"].ToString());
                bookingCalculation.OrderTotal = Convert.ToDecimal(drBookingCalculation["OrderTotal"].ToString());


                ListBookingCalculation.Add(bookingCalculation);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBookingCalculation);
        }

        [WebMethod]
        public static object GetItemImagesByBookingId(string BookingId)
        {
            List<ImagePickup> ListImagePickup = new List<ImagePickup>();
            DataTable dtImagePickup = objDB.GetItemImagesByBookingId(BookingId);
            foreach (DataRow drImagePickup in dtImagePickup.Rows)
            {
                ImagePickup imagePickup = new ImagePickup();
                imagePickup.PickupItem = drImagePickup["PickupItem"].ToString();
                imagePickup.ImageName = drImagePickup["ImageName"].ToString();

                ListImagePickup.Add(imagePickup);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListImagePickup);
        }

        [WebMethod]
        public static object getBookingItemsHistory(string PickupId, string BookingId, string ContainerId)
        {
            List<ItemHistory> ListItemHistory = new List<ItemHistory>();
            DataTable dtItemHistory = objDB.GetBookingItemsHistory(PickupId, BookingId, ContainerId);
            foreach (DataRow drItemHistory in dtItemHistory.Rows)
            {
                ItemHistory itemHistory = new ItemHistory();
                //itemHistory.BookingId = drItemHistory["BookingId"].ToString();
                //itemHistory.BookingStatus = drItemHistory["BookingStatus"].ToString();
                //itemHistory.Bookingdate = drItemHistory["Bookingdate"].ToString();
                itemHistory.Status = drItemHistory["Status"].ToString();
                itemHistory.StatusDetails = drItemHistory["StatusDetails"].ToString();
                itemHistory.CreatedOn = drItemHistory["CreatedOn"].ToString();

                ListItemHistory.Add(itemHistory);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListItemHistory);
        }

        [WebMethod]
        public static object GetBookingStatusItemsHistory(string PickupId, string BookingId, string ContainerId)
        {
            List<ItemHistory> ListItemHistory = new List<ItemHistory>();
            DataTable dtItemHistory = objDB.GetBookingStatusItemsHistory(PickupId, BookingId, ContainerId);
            foreach (DataRow drItemHistory in dtItemHistory.Rows)
            {
                ItemHistory itemHistory = new ItemHistory();
                itemHistory.BookingId = drItemHistory["BookingId"].ToString();
                itemHistory.BookingStatus = drItemHistory["BookingStatus"].ToString();
                itemHistory.BookingStatusDetails = drItemHistory["BookingStatusDetails"].ToString();
                itemHistory.Bookingdate = drItemHistory["Bookingdate"].ToString();

                ListItemHistory.Add(itemHistory);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListItemHistory);
        }
    }
}
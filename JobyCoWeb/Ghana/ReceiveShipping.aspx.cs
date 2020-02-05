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
namespace JobyCoWeb.Ghana
{

    public partial class ReceiveShipping : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();
        static BOLogin ObjLogin = new BOLogin();
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

                #region UserRole

                string UserRole = objOP.RetrieveField2FromField1("UserRole", "Users", "EmailID", ObjLogin.EMAILID.ToString());

                if (UserRole.ToLower() == "superadmin" || UserRole.ToLower() == "administrator")
                {
                    btnMarkContainerShipped.Visible = true;
                    btnCancelShipped.Visible = true;
                }
                else
                {
                    btnMarkContainerShipped.Visible = false;
                    btnCancelShipped.Visible = false;
                }

                #endregion

                #region ddlContainerDataBind
                DataTable dtContainers = objOP.GetAllContainerNumber("ContainerDetails");
                objCM.FillDropDown(ddlContainerNo, "Container", dtContainers);

                try
                {
                    string sContainerNo = Request.QueryString["ContainerNumber"].Trim().Replace("+", " ");
                    if (sContainerNo != "")
                    {
                        ddlContainerNo.SelectedItem.Text = sContainerNo;
                    }
                }
                catch
                {

                }
                #endregion

                #region ddlBookingId

                DataTable dtBookingIds = objDB.GetAllBookingIds("add");
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
        public static string getContainerNoFromContainerNo(string ContainerNo)
        {
            return ContainerNo;//objOP.GetgetContainerNo(ContainerNo);
        }

        [WebMethod]
        public static int MarkContainerReceived(string ShippingId, string ContainerId)
        {
            int Success = objDB.MarkContainerReceived(ShippingId, ContainerId);
            return Success;
        }

        [WebMethod]
        public static int CancelReceive(string ShippingId, string ContainerId)
        {
            int Success = objDB.CancelReceive(ShippingId, ContainerId);
            return Success;
        }

        [WebMethod]
        public static object GetContainerDetails(string ContainerNo, string SearchKey)
        {

            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.GetContainerDetails(ContainerNo, SearchKey, "Receive");
            foreach (DataRow drBookingInfo in dtBookingInfo.Rows)
            {
                BookingInformationForShipping BookingInfo = new BookingInformationForShipping();
                BookingInfo.BookingId = drBookingInfo["BookingId"].ToString();
                BookingInfo.InvoiceNumber = drBookingInfo["InvoiceNumber"].ToString();
                BookingInfo.InvoiceAmount = drBookingInfo["InvoiceAmount"].ToString();
                BookingInfo.Paid = drBookingInfo["Paid"].ToString();
                BookingInfo.Items = drBookingInfo["Items"].ToString();
                BookingInfo.Loaded = drBookingInfo["Loaded"].ToString();
                BookingInfo.Remaining = drBookingInfo["Remaining"].ToString();

                BookingInfo.ShippingId = drBookingInfo["ShippingId"].ToString();
                BookingInfo.ContainerId = drBookingInfo["ContainerId"].ToString();
                BookingInfo.SealId = drBookingInfo["SealId"].ToString();
                BookingInfo.ShippingFrom = drBookingInfo["ShippingFrom"].ToString();
                BookingInfo.ShippingTo = drBookingInfo["ShippingTo"].ToString();
                BookingInfo.ShippingDate = Convert.ToDateTime(drBookingInfo["ShippingDate"].ToString());
                BookingInfo.ArrivalDate = Convert.ToDateTime(drBookingInfo["ArrivalDate"].ToString());
                BookingInfo.ETA = Convert.ToDateTime(drBookingInfo["ETA"].ToString());
                BookingInfo.Consignee = drBookingInfo["Consignee"].ToString();
                BookingInfo.Shipped = Convert.ToInt32(drBookingInfo["Shipped"].ToString());
                BookingInfo.WarehouseId = drBookingInfo["WarehouseId"].ToString();
                BookingInfo.UserId = drBookingInfo["UserId"].ToString();

                ListBookingInfo.Add(BookingInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            //jsonSerialiser.MaxJsonLength = 2147483644;
            return jsonSerialiser.Serialize(ListBookingInfo);
        }

        [WebMethod]
        public static object GetShippingInfo(string ContainerNo)
        {
            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.GetShippingInfo(ContainerNo);
            foreach (DataRow drBookingInfo in dtBookingInfo.Rows)
            {
                BookingInformationForShipping BookingInfo = new BookingInformationForShipping();

                BookingInfo.ShippingId = drBookingInfo["ShippingId"].ToString();
                BookingInfo.ContainerId = drBookingInfo["ContainerId"].ToString();
                BookingInfo.SealId = drBookingInfo["SealId"].ToString();
                BookingInfo.ShippingFrom = drBookingInfo["ShippingFrom"].ToString();
                BookingInfo.ShippingTo = drBookingInfo["ShippingTo"].ToString();
                BookingInfo.ShippingDate = Convert.ToDateTime(drBookingInfo["ShippingDate"].ToString());
                BookingInfo.ArrivalDate = Convert.ToDateTime(drBookingInfo["ArrivalDate"].ToString());
                BookingInfo.ETA = Convert.ToDateTime(drBookingInfo["ETA"].ToString());
                BookingInfo.Consignee = drBookingInfo["Consignee"].ToString();
                BookingInfo.Shipped = Convert.ToInt32(drBookingInfo["Shipped"].ToString());
                BookingInfo.WarehouseId = drBookingInfo["WarehouseId"].ToString();
                BookingInfo.UserId = drBookingInfo["UserId"].ToString();
                BookingInfo.Received = Convert.ToInt32(drBookingInfo["Received"].ToString());
                BookingInfo.GhanaPort = drBookingInfo["GhanaPort"].ToString();

                ListBookingInfo.Add(BookingInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            //jsonSerialiser.MaxJsonLength = 2147483644;
            return jsonSerialiser.Serialize(ListBookingInfo);
        }

        [WebMethod]
        public static object GetBookingInformationByBookingId(string BookingId)
        {
            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.GetBookingInformationByBookingId(BookingId, "Receive");
            foreach (DataRow drBookingInfo in dtBookingInfo.Rows)
            {
                BookingInformationForShipping BookingInfo = new BookingInformationForShipping();
                BookingInfo.BookingId = drBookingInfo["BookingId"].ToString();
                BookingInfo.InvoiceNumber = drBookingInfo["InvoiceNumber"].ToString();
                BookingInfo.InvoiceAmount = drBookingInfo["InvoiceAmount"].ToString();
                BookingInfo.Paid = drBookingInfo["Paid"].ToString();
                BookingInfo.Items = drBookingInfo["Items"].ToString();
                BookingInfo.Loaded = drBookingInfo["Loaded"].ToString();
                BookingInfo.Remaining = drBookingInfo["Remaining"].ToString();
                BookingInfo.InWarehouse = drBookingInfo["InWarehouse"].ToString();
                ListBookingInfo.Add(BookingInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            //jsonSerialiser.MaxJsonLength = 2147483644;
            return jsonSerialiser.Serialize(ListBookingInfo);
        }
        [WebMethod]
        public static object GetBookingInfoItemsFromBookingId(string BookingId, int IsAdd, string ContainerId)
        {
            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.GetBookingInfoItemsFromBookingId(BookingId, IsAdd, ContainerId, "Receive");
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
                BookingInfo.IsFragile = Convert.ToBoolean(drBookingInfo["IsFragile"]);
                BookingInfo.EstimatedValue = Convert.ToDecimal(drBookingInfo["EstimatedValue"]);
                BookingInfo.PredefinedEstimatedValue = Convert.ToDecimal(drBookingInfo["PredefinedEstimatedValue"]);
                BookingInfo.IsPickedForShipping = Convert.ToInt32(drBookingInfo["IsPickedForShipping"]);
                BookingInfo.Items = drBookingInfo["Items"].ToString();
                BookingInfo.Loaded = drBookingInfo["Loaded"].ToString();
                BookingInfo.Remaining = drBookingInfo["Remaining"].ToString();

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
                BookingInfo.Status = drBookingInfo["Status"].ToString();

                ListBookingInfo.Add(BookingInfo);
            }

            if (ListBookingInfo.Count == 0)
            {
                return 0;
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBookingInfo);

        }

        [WebMethod]
        public static List<ListItem> GetAllWarehouse()
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            DataTable dtWarehouse = objDB.GetAllWarehouse(ObjLogin.EMAILID.ToString());
            List<ListItem> lstWarehouse = new List<ListItem>();

            string sWarehouseId = string.Empty;
            string sWarehouseName = string.Empty;

            foreach (DataRow drLocation in dtWarehouse.Rows)
            {
                sWarehouseId = drLocation["WarehouseId"].ToString();
                sWarehouseName = drLocation["WarehouseName"].ToString();

                lstWarehouse.Add(new ListItem
                {
                    Value = sWarehouseId,
                    Text = sWarehouseName
                });
            }

            return lstWarehouse;
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
        public static EntityLayer.ItemValues[] GetAllLocationsUK()
        {
            return GetDropDownValues(11, 14);
        }

        [WebMethod]
        public static string GetShippingReferenceNumber()
        {
            return objOP.GetAutoGeneratedValue("ShippingId", "Shipping", "SHIP", 9);
        }

        [WebMethod]
        public static string GetCustomerIdByBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("CustomerId", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static List<ListItem> GetAllBookingIds()
        {
            DataTable dtBookingIds = objDB.GetAllBookingIds("add");
            List<ListItem> lstBookingIds = new List<ListItem>();
            string sBookingId = string.Empty;

            foreach (DataRow drBookingIds in dtBookingIds.Rows)
            {
                sBookingId = drBookingIds["BookingId"].ToString();
                lstBookingIds.Add(new ListItem
                {
                    Value = sBookingId,
                    Text = sBookingId
                });
            }

            return lstBookingIds;
        }

        [WebMethod]
        public static List<ListItem> GetAllContainerNumber()
        {
            DataTable dtContainerNumbers = objDB.GetAllContainerNumber();
            List<ListItem> lstContainerNumbers = new List<ListItem>();
            string sContainerNumber = string.Empty;

            foreach (DataRow drBookingIds in dtContainerNumbers.Rows)
            {
                sContainerNumber = drBookingIds["ContainerNumber"].ToString();
                lstContainerNumbers.Add(new ListItem
                {
                    Value = sContainerNumber,
                    Text = sContainerNumber
                });
            }

            return lstContainerNumbers;
        }

        [WebMethod]
        public static string GetCustomerNameByBookingId(string BookingId)
        {
            string sCustomerId = objOP.RetrieveField2FromField1("CustomerId", "OrderBooking", "BookingId", BookingId);
            return objOP.GetFullNameFromCustomerId(sCustomerId);
        }

        [WebMethod]
        public static string GetOrderStatusByBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("OrderStatus", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetItemCountByBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("ItemCount", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static string GetInvoiceAmountByBookingId(string BookingId)
        {
            return objOP.RetrieveField2FromField1("TotalValue", "OrderBooking", "BookingId", BookingId);
        }

        [WebMethod]
        public static void AddShippingDetails
            (
            string ShippingId,
            string ContainerId,
            string BookingId,
            string PickupId,
            string SealId,
            string ShippingFrom,
            string ShippingTo,
            string ShippingDate,
            string ArrivalDate,
            string ETA,
            string Consignee,
            string WarehouseId
            )
        {
            EntityLayer.Shippings objShipping = new EntityLayer.Shippings();

            objShipping.ShippingId = ShippingId;
            objShipping.ContainerId = ContainerId;
            objShipping.BookingId = BookingId;
            objShipping.PickupId = PickupId;
            objShipping.SealId = SealId;
            objShipping.ShippingFrom = ShippingFrom;
            objShipping.ShippingTo = ShippingTo;

            objShipping.ShippingDate = Convert.ToDateTime(ShippingDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.ArrivalDate = Convert.ToDateTime(ArrivalDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.ETA = Convert.ToDateTime(ETA,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.Consignee = Consignee;
            objShipping.WarehouseId = WarehouseId;

            if (ObjLogin.EMAILID == null)
            {
                ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];
            }
            objShipping.UserId = ObjLogin.EMAILID.ToString();


            objDB.AddShipping(objShipping);
        }


        [WebMethod]
        public static void AddShippingInfo
            (
            string ShippingId,
            string ContainerId,
            string SealId,
            string ShippingFrom,
            string ShippingTo,
            string ShippingDate,
            string ArrivalDate,
            string ETA,
            string Consignee,
            string WarehouseId
            )
        {
            EntityLayer.Shippings objShipping = new EntityLayer.Shippings();

            objShipping.ShippingId = ShippingId;
            objShipping.ContainerId = ContainerId;

            objShipping.SealId = SealId;
            objShipping.ShippingFrom = ShippingFrom;
            objShipping.ShippingTo = ShippingTo;

            objShipping.ShippingDate = Convert.ToDateTime(ShippingDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.ArrivalDate = Convert.ToDateTime(ArrivalDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.ETA = Convert.ToDateTime(ETA,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objShipping.Consignee = Consignee;
            objShipping.WarehouseId = WarehouseId;

            if (ObjLogin.EMAILID == null)
            {
                ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];
            }
            objShipping.UserId = ObjLogin.EMAILID.ToString();


            objDB.AddShippingInfo(objShipping);
        }

        [WebMethod]
        public static void AddContainerBookingInfo(
            string ShippingId,
            string ContainerId,
            string BookingId,
            string Loaded,
            string Remaining
            )
        {
            ShippingDetails shippingDetails = new ShippingDetails();
            shippingDetails.ShippingId = ShippingId;
            shippingDetails.ContainerId = ContainerId;
            shippingDetails.BookingId = BookingId;
            shippingDetails.Loaded = Loaded;
            shippingDetails.Remaining = Remaining;

            objDB.AddShippingContainerBookingInfo(shippingDetails);
        }

        [WebMethod]
        public static void AddContainerShippingItemInfo(
            string ShippingId,
            string ContainerId,
            string BookingId,
            string PickupId,
            string CategoryId,
            string CategoryItemId
            )
        {
            ShippingDetails shippingDetails = new ShippingDetails();
            shippingDetails.ShippingId = ShippingId;
            shippingDetails.ContainerId = ContainerId;
            shippingDetails.BookingId = BookingId;
            shippingDetails.PickupId = PickupId;
            shippingDetails.CategoryId = CategoryId;
            shippingDetails.CategoryItemId = CategoryItemId;

            objDB.AddContainerShippingItemInfo(shippingDetails);
        }

        [WebMethod]
        public static void ReceiveShippingDetails
            (
            string ContainerId,
            string BookingId,
            string PickupId

            )
        {
            EntityLayer.Shippings objShipping = new EntityLayer.Shippings();

            objShipping.ContainerId = ContainerId;
            objShipping.BookingId = BookingId;
            objShipping.PickupId = PickupId;

            objDB.ReceiveShippingDetails(objShipping);
        }

        [WebMethod]
        public static int CheckContainerAvailability(string ContainerNo)
        {
            return objDB.CheckContainerAvailability(ContainerNo);
        }


        [WebMethod]

        public static object PopulateMapFromTo()
        {

            List<EntityLayer.Location> ListLocationInfo = new List<EntityLayer.Location>();
            DataSet dsLocationInfo = objDB.PopulateMapFromTo(ObjLogin.EMAILID.ToString());

            if (dsLocationInfo != null && dsLocationInfo.Tables.Count > 0)
            {
                DataTable dt = dsLocationInfo.Tables[0];
                foreach (DataRow drLocationInfo in dt.Rows)
                {
                    EntityLayer.Location LocationInfo = new EntityLayer.Location();
                    LocationInfo.WarehouseId = drLocationInfo["WarehouseId"].ToString();
                    LocationInfo.LocationName = drLocationInfo["LocationName"].ToString();
                    LocationInfo.LocationAddress = drLocationInfo["LocationAddress"].ToString();
                    LocationInfo.Latitude = Convert.ToDecimal(drLocationInfo["Latitude"].ToString());
                    LocationInfo.Longitude = Convert.ToDecimal(drLocationInfo["Longitude"].ToString());
                    LocationInfo.Country = drLocationInfo["Country"].ToString();

                    ListLocationInfo.Add(LocationInfo);
                }
            }
            if (dsLocationInfo != null && dsLocationInfo.Tables.Count > 1)
            {
                DataTable dt = dsLocationInfo.Tables[1];
                foreach (DataRow drLocationInfo in dt.Rows)
                {
                    EntityLayer.Location LocationInfo = new EntityLayer.Location();
                    LocationInfo.WarehouseId = drLocationInfo["WarehouseId"].ToString();
                    LocationInfo.LocationName = drLocationInfo["LocationName"].ToString();
                    LocationInfo.LocationAddress = drLocationInfo["LocationAddress"].ToString();
                    LocationInfo.Latitude = Convert.ToDecimal(drLocationInfo["Latitude"].ToString());
                    LocationInfo.Longitude = Convert.ToDecimal(drLocationInfo["Longitude"].ToString());
                    LocationInfo.Country = drLocationInfo["Country"].ToString();

                    ListLocationInfo.Add(LocationInfo);
                }
            }

            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListLocationInfo);
        }
    }
}
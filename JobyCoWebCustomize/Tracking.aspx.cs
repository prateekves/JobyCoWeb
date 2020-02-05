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
using System.Data;

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Web.Services;
using System.Web.Script.Serialization;
using Newtonsoft.Json.Linq;

#endregion

namespace JobyCoWebCustomize
{
    public partial class Tracking : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        //static ControlModels objCM = new ControlModels();

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
        public static List<ListItem> GetAllItemStatus()
        {
            DataTable dtItemStatus = objOP.GetAllItemStatus("");
            List<ListItem> lstItemStatus = new List<ListItem>();
            string sItemStatus = string.Empty;
            string sStatusId = string.Empty;
            foreach (DataRow drItemStatus in dtItemStatus.Rows)
            {
                sStatusId = drItemStatus["Id"].ToString();
                sItemStatus = drItemStatus["Status"].ToString();
                lstItemStatus.Add(new ListItem
                {
                    Value = sStatusId,
                    Text = sItemStatus
                });
            }

            return lstItemStatus;
        }

        [WebMethod]
        public static object SearchByContainerNoORBookingNo(string ContainerNoORBookingNo)
        {
            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.SearchByContainerNoORBookingNo(ContainerNoORBookingNo);
            foreach (DataRow drBookingInfo in dtBookingInfo.Rows)
            {
                BookingInformationForShipping BookingInfo = new BookingInformationForShipping();
                BookingInfo.BookingId = drBookingInfo["BookingId"].ToString();
                BookingInfo.PickupId = drBookingInfo["PickupId"].ToString();
                BookingInfo.Items = drBookingInfo["Items"].ToString();
                BookingInfo.Paid = drBookingInfo["Paid"].ToString();
                BookingInfo.Shipped = Convert.ToInt32(drBookingInfo["Shipped"].ToString());
                BookingInfo.Status = drBookingInfo["Status"].ToString();
                BookingInfo.StatusId = Convert.ToInt32(drBookingInfo["StatusId"].ToString());
                BookingInfo.IsContainer = Convert.ToInt32(drBookingInfo["IsContainer"].ToString());
                ListBookingInfo.Add(BookingInfo);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListBookingInfo);
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
        public static object GetBookingItemsTracking(string PickupId, string BookingId, string ContainerId)
        {
            DataSet dsItemHistory = new DataSet();
            dsItemHistory.Tables.Add("Table");
            dsItemHistory.Tables.Add("Table1");
            dsItemHistory.Tables.Add("Table2");
            DataTable dt = new DataTable();
            List<ItemHistory> ListItemHistory = new List<ItemHistory>();
            dsItemHistory = objDB.GetBookingItemsTracking(PickupId, BookingId, ContainerId);

            foreach (DataRow drItemHistory in dsItemHistory.Tables["Table"].Rows)
            {
                ItemHistory itemHistory = new ItemHistory();
                itemHistory.Status = drItemHistory["Status"].ToString();
                itemHistory.CreatedOn = "";
                itemHistory.StatusDetails = "";
                ListItemHistory.Add(itemHistory);
            }
            foreach (DataRow drItemHistory in dsItemHistory.Tables["Table1"].Rows)
            {
                ItemHistory itemHistory = new ItemHistory();
                ListItemHistory.Where(x => x.Status == drItemHistory["BookingStatus"].ToString()).SingleOrDefault().CreatedOn = drItemHistory["Bookingdate"].ToString();
                ListItemHistory.Where(x => x.Status == drItemHistory["BookingStatus"].ToString()).SingleOrDefault().StatusDetails = drItemHistory["BookingStatusDetails"].ToString();
            }
            foreach (DataRow drItemHistory in dsItemHistory.Tables["Table2"].Rows)
            {
                ItemHistory itemHistory = new ItemHistory();
                ListItemHistory.Where(x => x.Status == drItemHistory["Status"].ToString()).SingleOrDefault().CreatedOn = drItemHistory["CreatedOn"].ToString();
                ListItemHistory.Where(x => x.Status == drItemHistory["Status"].ToString()).SingleOrDefault().StatusDetails = drItemHistory["StatusDetails"].ToString();
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
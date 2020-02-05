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
using System.Globalization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class AssignBookedItemToBox : System.Web.UI.Page
    {
        clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
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
                        Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());
                    }
                }

                #endregion
            }
        }

        [WebMethod]
        public static object ItemSearchByBookingNo(string BookingNo)
        {
            List<BookingInformationForShipping> ListBookingInfo = new List<BookingInformationForShipping>();
            DataTable dtBookingInfo = objDB.ItemSearchByBookingNo(BookingNo);
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
    }
}
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
    public partial class UpdateStatus : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();
        static BOLogin ObjLogin = new BOLogin();
        #endregion
        static string authorityDomain { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(authorityDomain))
                authorityDomain = "http://jobycodirect.com/";// + HttpContext.Current.Request.Url.Authority;

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

                #region ddlStatus

                DataTable dtItemStatus = objOP.GetAllItemStatus(ObjLogin.EMAILID.ToString());

                ddlItemStatus.DataSource = dtItemStatus;
                ddlItemStatus.DataTextField = "Status";
                ddlItemStatus.DataValueField = "id";
                ddlItemStatus.DataBind();
                ddlItemStatus.Items[0].Text = "Select Status";
                ddlItemStatus.Items[0].Value = "Select Status";
                ddlItemStatus.Items[0].Selected = true;

                //ddlItemStatus.Items.Insert(0, new ListItem("Select Status", "0"));
                //ddlItemStatus.Items.Insert(0 , new ListItem { Value = "0", Text = "Select Status", Selected = true });

                //objCM.FillDropDown(ddlItemStatus, "Status", dtItemStatus);

                try
                {
                    string sStatus = Request.QueryString["Status"].Trim().Replace("+", " ");
                    if (sStatus != "")
                    {
                        ddlItemStatus.SelectedItem.Text = sStatus;
                    }
                }
                catch
                {

                }
                #endregion
                if (Request != null && Request.UrlReferrer != null)
                {
                    string url = Request.UrlReferrer.ToString();
                    // url = System.IO.Path.GetFileName(url);
                    //url = "Shipping/" + url;
                    RefUrl.Value = url;
                }
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

        public static string SaveStatus
        (
            string BookingId,
            string PickupId,
            string ItemName,
            string Status,
            string StatusDetails,
            int IsOrderBookStatus
            )
        {
            StatusDetails statusDetails = new StatusDetails();
            statusDetails.BookingId = BookingId;
            statusDetails.PickupId = PickupId;
            statusDetails.Status = Status;
            statusDetails.StatusDetail = StatusDetails;
            statusDetails.IsOrderBookStatus = IsOrderBookStatus;

            if (objDB.UpdateItemStatus(statusDetails) > 0)
            {
                if (IsOrderBookStatus == 1)
                {

                }
                else
                {
                    //SendBookingByEmail(ObjLogin.EMAILID.ToString(), BookingId, ItemName, Status, StatusDetails);
                }
                return "";
            }
            else
            {
                return "";
            }

        }

        [WebMethod]
        public static void SendBookingStatusByEmail(string jQueryDataTableContent, string ContainerNoORBookingNo)
        {
            DataTable dt = objDB.GetAllPickupEmailId(ContainerNoORBookingNo);

            string sMessage = string.Empty;
            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = ObjLogin.EMAILID.ToString();
            string sSubject = "jobycodirect.com Booking - Item - status has been changed";

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Booking Item Status<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>";
            sBody += "&nbsp;Your jobycodirect.com Item Status</h1>";
            sBody += "Thank you for your interest in Jobyco. ";
            //sBody += "Please find your recent Booking below, the Booking will be active for a period ";
            //sBody += "of 30 days from the date of this email.<br/>";
            //sBody += "Bookings can be made and viewed any time in the jobycodirect.com ";
            //sBody += "<a href='" + authorityDomain + "'><b><u>Customer Portal</u></b></a>.";
            //sBody += "<h1>Booking: - " + BookingId + " </h1>";

            sBody += jQueryDataTableContent;

            //New Line Added for "Other" Category Message
            //=======================================================================================
            //sBody += "<h4 style='background-color: navy; color: whitesmoke; padding: 0 0 0 20px;'>";
            //sBody += "&nbsp;The Price of Category 'Other' will be paid at Collection</h4>";
            //=======================================================================================

            sBody += "<br/><br/>For Booking Enquiry, please call our Customer Services Team ";
            sBody += "between 8:30 am and 8:30 pm Monday to Friday or between 9:00 am and 6:00 pm ";
            sBody += "Saturday on 01582 574569<br/><br/><br/><br/><br/><br/>";
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
                    sMessage = "Your Booking Details could not be sent into your Email Id";
                }
                else
                {
                    sMessage = "Your Booking Details has been sent successfully into your Email Id";
                }
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow _temp in dt.Rows)
                    {
                        sTo = _temp["PickupEmail"].ToString();
                        objOP.SendMail(sFrom, sTo, sSubject, sBody, sFromPassword);
                    }
                }
            }
            catch { }

        }

        protected void btnBackStatus_Click(object sender, EventArgs e)
        {
            Response.Redirect(RefUrl.Value);
        }
    }
}

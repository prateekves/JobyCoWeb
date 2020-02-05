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

#endregion

namespace JobyCoWeb.CustomerCare
{
    public partial class AddEscalationLevel : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion
        static string authorityDomain { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            objCM.ResetMessageBar(lblErrMsg);

            if (string.IsNullOrEmpty(authorityDomain))
                authorityDomain = "http://jobycodirect.com/";// + HttpContext.Current.Request.Url.Authority;

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

                #region Customer Name                

                //Binding Dropdown with Customer Names
                //=======================================================
                DataTable dtAllCustomerNamesFromCustomerId = new DataTable();
                string sCustomerId = string.Empty;
                string sCustomerName = string.Empty;

                //Collecting CustomerIds who have Bookings
                //=======================================================
                DataTable dtAllCustomerIdsFromBooking = objOP.RetrieveAllDataFromField("CustomerId", "OrderBooking");

                for (int i = 0; i < dtAllCustomerIdsFromBooking.Rows.Count; i++)
                {
                    sCustomerId = Convert.ToString(dtAllCustomerIdsFromBooking.Rows[i][0]);
                    if (!sCustomerId.Equals(string.Empty))
                    {
                        //Collecting Customer Full Names from CustomerIds
                        //=======================================================
                        sCustomerName = objOP.GetFullNameFromCustomerId(sCustomerId);
                        if (!sCustomerName.Equals(string.Empty))
                        {
                            ddlCustomerName.Items.Add(new ListItem(sCustomerName, sCustomerId));
                        }
                    }
                }

                #endregion
            }
        }

        [WebMethod]
        public static EntityLayer.AllCustomerBookingIds[] GetAllBookingIdsFromCustomerId(string CustomerId)
        {
            DataTable dtAllBookingIds = objDB.GetAllBookingIdsFromCustomerId(CustomerId);
            List<EntityLayer.AllCustomerBookingIds> lstAllCustomerBookingIds = new List<EntityLayer.AllCustomerBookingIds>();

            foreach (DataRow drRoleItem in dtAllBookingIds.Rows)
            {
                EntityLayer.AllCustomerBookingIds objAllCustomerBookingIds = new EntityLayer.AllCustomerBookingIds();

                objAllCustomerBookingIds.BookingId = Convert.ToString(drRoleItem["BookingId"]);

                lstAllCustomerBookingIds.Add(objAllCustomerBookingIds);
            }

            //var js = new JavaScriptSerializer();
            //return js.Serialize(lstAllCustomerBookingIds);

            return lstAllCustomerBookingIds.ToArray();
        }

        [WebMethod]
        public static void AddEscalationDetails
           (
           string ComplaintId,
           string CustomerId,
           string BookingId,
           string ComplaintSource,
           string ComplaintReason,
           string ComplaintPriority,
           string ComplaintStatus,
           string LodgingDate,
           string ResolvedDate
           )
        {
            EntityLayer.Complaint objComplaint = new EntityLayer.Complaint();

            objComplaint.ComplaintId = objOP.GetAutoGeneratedValue("ComplaintId", "Complaints", "JBCOM", 9);
            objComplaint.CustomerId = CustomerId;
            objComplaint.BookingId = BookingId;

            objComplaint.ComplaintSource = ComplaintSource;
            objComplaint.ComplaintReason = ComplaintReason;

            objComplaint.ComplaintPriority = ComplaintPriority;
            objComplaint.ComplaintStatus = ComplaintStatus;

            objComplaint.LodgingDate = Convert.ToDateTime(LodgingDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            //For a New Complaint where no Resolved Date, this will be 7 days later
            //=====================================================================
            //DateTime dtResolvedDate = objComplaint.LodgingDate.AddDays(7);
            DateTime dtResolvedDate = new DateTime();
            ResolvedDate = dtResolvedDate.ToString("01/01/1900");

            objComplaint.ResolvedDate = Convert.ToDateTime(ResolvedDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objDB.AddComplaintDetails(objComplaint);
        }

        [WebMethod]
        public static string GetCustomerEmailIDFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("EmailID", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string SendComplaintEmail(string EmailID, string jQueryDataTableContent, string ComplaintId)
        {
            string sMessage = string.Empty;
            //string sFrom = "switch2web2017@gmail.com";
            //string sFromPassword = "switch2web2017@#";

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = EmailID;
            string sSubject = "jobycodirect.com Complaint - " + ComplaintId;

            //Mail Body
            string sBody = "";
            /*sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> " + sSubject + "<br/>";*/
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>&nbsp;jobycodirect.com Complaint</h1>";

            int iAtTheRateIndex = sTo.IndexOf("@");
            string sFirstNameFromTo = sTo.Substring(0, iAtTheRateIndex);

            sBody += "Hi " + sFirstNameFromTo + ", <br/><br/>";
            sBody += "Welcome to <b>jobycodirect.com</b>! <br/><br/>";
            sBody += "We have received your Complaint. Here is the details: -";

            sBody += "<h1>Complaint: - " + ComplaintId + " </h1>";
            sBody += jQueryDataTableContent;

            sBody += "<br/><br/>Hope to resolve your Complaint as early as possible. <br/><br/>";

            sBody += "Kind regards, <br/>";
            sBody += "Mr. Edward Akosah, <br/>";
            sBody += "Account Executive, <br/><br/>";

            sBody += "<b><big>UK Customer Services</big></b> <br/>";
            sBody += "<a href='" + authorityDomain + "'>www.jobycodirect.com</a> <br/>";
            sBody += "194 Camford Way, <br/>";
            sBody += "Luton, <br/>";
            sBody += "Bedfordshire, <br/>";
            sBody += "LU3 3AN <br/>";
            sBody += "Ph:+44 01582574569 <br/>";

            try
            {
                if (objOP.SendMail(sFrom, sTo, sSubject, sBody, sFromPassword))
                {
                    sMessage = "Complaint failed";
                }
                else
                {
                    sMessage = "Complaint successfull";
                }
            }
            catch { }

            return sMessage;
        }

    }
}
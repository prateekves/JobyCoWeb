﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

#region Required Global NameSpaces

using DataAccessLayer;
using EntityLayer;
using SecurityLayer;
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Globalization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class ContactUs : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetLatestContactId()
        {
            return objOP.GetAutoGeneratedValue("ContactId", "ContactUs", "CONT", 9);
        }

        [WebMethod]
        public static void AddContactDetails
            (
                string ContactId,
                string ContactTitle,
                string ContactFirstName,
                string ContactLastName,
                string ContactEmail,
                string ContactComments
            )
        {
            EntityLayer.ContactUs objCU = new EntityLayer.ContactUs();
            objCU.ContactId = ContactId;
            objCU.ContactTitle = ContactTitle;
            objCU.ContactFirstName = ContactFirstName;
            objCU.ContactLastName = ContactLastName;
            objCU.ContactEmail = ContactEmail;
            objCU.ContactComments = ContactComments;

            objDB.AddContactDetails(objCU);
            SendContactusEmail(ContactEmail, ContactFirstName, ContactLastName, ContactComments);
        }

        private static void SendContactusEmail(string EmailID, string ContactFirstName, string ContactLastName, string ContactComments)
        {
            string sMessage = string.Empty;
            string DomainName = HttpContext.Current.Request.Url.Scheme;
            DomainName += "://";
            DomainName += HttpContext.Current.Request.Url.Authority;
            //string sFrom = "switch2web2017@gmail.com";
            //string sFromPassword = "switch2web2017@#";

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = EmailID;
            string sSubject = "jobycodirect.com - ContactUs";

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com - ContactUs" + "<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>&nbsp;jobycodirect.com - ContactUs</h1>";

            int iAtTheRateIndex = sTo.IndexOf("@");
            string sFirstNameFromTo = sTo.Substring(0, iAtTheRateIndex);

            sBody += "Dear " + ContactFirstName + ", <br/><br/>";
            sBody += "<b>Thank you for showing interest with us!!</b> <br/><br/>";
            sBody += "If you want to create your account, ";
            sBody += "<a href = '" + DomainName + "/Signup.aspx' target=\"_blank\"'> click here.</a> <br/><br/>";

            sBody += "Name :    <b>" + ContactFirstName + " " + ContactLastName + "</b>.<br/><br/>";
            sBody += "Email :   <b>" + EmailID + "</b><br/><br/>";
            sBody += "Message :  <b>" + ContactComments + "</b><br/><br/>";
            sBody += "Have a good day! <br/><br/>";

            sBody += "Regards, <br/>";


            sBody += "Jobyco Customer Services Team. <br/>";

            try
            {
                if (objOP.SendMail(sFrom, sTo, sSubject, sBody, sFromPassword))
                {
                    //sMessage = "Signup failed";
                }
                else
                {
                    //sMessage = "Signup successfull";
                }
            }
            catch { }
            return;
        }
    }
}
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
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            /*try
            {
                string sEmailID = Request.QueryString["EmailID"].Trim();
                if (sEmailID != "")
                {
                    txtRegisteredEmailID.Text = sEmailID;
                }
            }
            catch { }*/
        }

        [WebMethod]
        public static bool CheckRegisteredEmailID(string RegisteredEmailID)
        {
            bool bExists = false;

            DataTable dtRegisteredEmailId = objDB.CheckEmailIdFromUsers(RegisteredEmailID);
            if (dtRegisteredEmailId.Rows.Count > 0)
            {
                int iNoOfRecords = Convert.ToInt32(dtRegisteredEmailId.Rows[0][0]);
                if (iNoOfRecords > 0)
                {
                    bExists = true;
                }
                else
                {
                    bExists = false;
                }
            }
            else
            {
                bExists = false;
            }

            return bExists;
        }

        [WebMethod]
        public static string SendResetLinkByEmail(string RegisteredEmailID, string EncryptedEmailID)
        {
            string sMessage = string.Empty;
            string DomainName = HttpContext.Current.Request.Url.Scheme;
            DomainName += "://";
            DomainName += HttpContext.Current.Request.Url.Authority;
            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = RegisteredEmailID;
            string sSubject = "jobycodirect.com Reset Password Link";

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Reset Password Link<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>";
            sBody += "&nbsp;jobycodirect.com Reset Password Link</h1>";
            sBody += "Please click on the following link to Reset your Password: ";
            sBody += "<a href='" + DomainName + "/ChangePassword.aspx?RegisteredEmailID=" + EncryptedEmailID + "'><b><u>Reset your Password</u></b></a>.</p>";
            sBody += "<p>After changing your password you can also sign into the ";
            sBody += "<a href='" + DomainName + "/Login.aspx'><b><u>Customer Portal</u></b></a>";
            sBody += " and place a booking there, or call the customer service team on 01582 574569.</p>";

            sBody += "Regards,<br/>";
            sBody += "Jobyco Customer Services Team.<br/>";
            sBody += "<img src='/images/JobyCoLimited.png' />";
            sBody += "<font size='-2'>Jobyco Limited<br/>";
            sBody += "194 Camford Way, Sundon Park,<br/>";
            sBody += "Luton, Bedfordshire, LU3 3AN<br/>";
            sBody += "<font style='color: yellow;'><a href='" + DomainName + "'>www.jobycodirect.com</a></font><br/>";
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
                    sMessage = "Your Reset Password Link could not be sent into your Registered Email Id";
                }
                else
                {
                    sMessage = "Your Reset Password Link has been sent successfully into your Registered Email Id";
                }
            }
            catch { }

            return sMessage;
        }

        [WebMethod]
        public static string GetEncryptedEmailID(string RegisteredEmailID)
        {
            return objCG.getMd5Hash(RegisteredEmailID);
        }

        [WebMethod]
        public static void AddResetPassword(
            string RegisteredEmailID,
            string EncryptedEmailID
            )
        {
            EntityLayer.ResetPassword objResetPassword = new EntityLayer.ResetPassword();

            objResetPassword.EmailID = RegisteredEmailID;
            objResetPassword.EncryptedEmailID = EncryptedEmailID;

            objDB.AddResetPassword(objResetPassword);
        }
    }
}
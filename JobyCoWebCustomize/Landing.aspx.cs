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

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.IO;
using System.Security.Cryptography;

#endregion

namespace JobyCoWebCustomize
{
    public partial class Landing : System.Web.UI.Page
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
        public static string getLoginResult(string EmailID, string Password)
        {
            string sEmailID = EmailID;
            string sMessage = string.Empty;

            if (!objOP.CheckExistence("EmailID", sEmailID, "Users"))
            {
                sMessage = "Login failed";
            }
            else
            {
                string sLocked = objOP.RetrieveField2FromField1("Locked", "Users", "EmailID", sEmailID);
                bool bLocked = Convert.ToBoolean(sLocked);
                if (!bLocked)
                {
                    string sPassword = objCG.getMd5Hash(Password);

                    DataTable dtLogin = objDB.CheckLogin(sEmailID, sPassword);
                    if (objOP.CheckLogin(dtLogin))
                    {
                        sMessage = "Login successful";
                    }
                    else
                    {
                        sMessage = "Invalid Username / Password";
                    }
                }
                else
                {
                    sMessage = "This User is Deactivated";
                }
            }

            return sMessage;
        }

        [WebMethod]
        public static string CheckEmailIdFromUsers(string EmailID)
        {
            string sFound = string.Empty;

            DataTable dtEmailIds = objDB.CheckEmailIdFromUsers(EmailID);

            if(dtEmailIds.Rows.Count > 0)
            {
                int iNoOfRecords = Convert.ToInt32(dtEmailIds.Rows[0]["NoOfRecords"].ToString());
                if(iNoOfRecords > 0)
                {
                    sFound = "EmailID exists";
                }
                else
                {
                    DataTable dtCustIds = objDB.CheckEmailIdFromCustomers(EmailID);
                    iNoOfRecords = Convert.ToInt32(dtCustIds.Rows[0]["NoOfRecords"].ToString());
                    if (iNoOfRecords > 0)
                    {
                        sFound = "CustomerID exists";
                    }
                    else
                    {
                        sFound = "EmailID doesn't exist";
                    }
                    
                }
            }
            else
            {
                sFound = "EmailID doesn't exist";
            }

            return sFound;
        }
    }
}
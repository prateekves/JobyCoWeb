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
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string sEncryptedEmailID = Request.QueryString["RegisteredEmailID"].Trim();
                if (sEncryptedEmailID != "")
                {
                    hfEncryptedEmailID.Value = sEncryptedEmailID;

                    //Blocking all controls after a Specific Time Span
                    //=============================================================
                    hfPasswordChangeDate.Value = objOP.RetrieveField2FromField1("PasswordChangeDate", "ResetPassword", "EncryptedEmailID", sEncryptedEmailID);
                }
            }
            catch { }
        }

        [WebMethod]
        public static string CheckExpiryDate(string PasswordChangeDate)
        {
            string sBlocked = "Unblocked";

            DateTime dtPasswordChangeDate = Convert.ToDateTime(PasswordChangeDate);
            TimeSpan ts = DateTime.Now - dtPasswordChangeDate;

            if (ts.Hours > 1)
            {
                sBlocked = "Blocked";
            }

            return sBlocked;
        }

        [WebMethod]
        public static string GetRegisteredEmailID(string EncryptedEmailID)
        {
            return objOP.RetrieveField2FromField1("EmailID", "ResetPassword", "EncryptedEmailID", EncryptedEmailID);
        }

        [WebMethod]
        public static void UpdateUserPassword(string RegisteredEmailID, string NewPassword)
        {
            objDB.UpdateUserPassword(RegisteredEmailID, objCG.getMd5Hash(NewPassword));
        }

        [WebMethod]
        public static void UpdateResetPassword(string RegisteredEmailID, string EncryptedEmailID)
        {
            objDB.UpdateResetPassword(RegisteredEmailID, EncryptedEmailID);
        }
    }
}
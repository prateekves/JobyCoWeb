using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

#region Required NameSpaces to modify Web.config

using System.Web.Configuration;
using System.Web.Services;
using System.Configuration;

#endregion

#region Required Global NameSpaces

using DataAccessLayer;
using EntityLayer;
using SecurityLayer;
using JobyCoWeb.Models;
using System.Data;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb
{
    public partial class PayPalEmailAddress : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
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
                }

                #endregion
            }
        }

        [WebMethod]
        public static void UpdatePayPalEmailAddress(string PayPalEmailAddress)
        {
            //Helps to open the Root level web.config file.
            Configuration webConfigApp = WebConfigurationManager.OpenWebConfiguration("~");

            //Modifying the AppKey from AppValue to AppValue1
            webConfigApp.AppSettings.Settings["PaypalEmail"].Value = PayPalEmailAddress;

            //Save the Modified settings of AppSettings.
            webConfigApp.Save();
        }
    }
}
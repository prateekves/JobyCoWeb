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
using JobyCoWeb.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb.Users
{
    public partial class ViewAllUsers : System.Web.UI.Page
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
                    else
                    {
                        Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());
                    }
                }

                #endregion

            }
        }

        [WebMethod]
        public static string GetAllUsers()
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            DataTable dtUsers = objDB.GetAllUsers(ObjLogin.EMAILID);
            List<EntityLayer.clsUsers> lstUsers = new List<EntityLayer.clsUsers>();

            foreach (DataRow drUsers in dtUsers.Rows)
            {
                EntityLayer.clsUsers objUsers = new EntityLayer.clsUsers();

                objUsers.id = drUsers["id"].ToString();
                objUsers.UserId = drUsers["UserId"].ToString();
                objUsers.EmailID = drUsers["EmailID"].ToString();
                objUsers.CustomerName = drUsers["CustomerName"].ToString();
                objUsers.FirstName = drUsers["FirstName"].ToString();
                objUsers.LastName = drUsers["LastName"].ToString();
                objUsers.Title = drUsers["Title"].ToString();
                objUsers.DateOfBirth = Convert.ToDateTime(drUsers["DateOfBirth"].ToString());
                objUsers.Address = drUsers["Address"].ToString();
                objUsers.Town = drUsers["Town"].ToString();
                objUsers.Country = drUsers["Country"].ToString();
                objUsers.PostCode = drUsers["PostCode"].ToString();
                objUsers.Mobile = drUsers["Mobile"].ToString();
                objUsers.Telephone = drUsers["Telephone"].ToString();
                objUsers.UserRole = drUsers["UserRole"].ToString();

                lstUsers.Add(objUsers);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUsers);
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
        public static EntityLayer.ItemValues[] GetAllTitles()
        {
            return GetDropDownValues(1, 1);
        }

        [WebMethod]
        public static EntityLayer.ItemValues[] GetAllCountries()
        {
            return GetDropDownValues(10, 13);
        }

        [WebMethod]
        public static EntityLayer.ItemValues[] GetAllRoles()
        {
            return GetDropDownValues(1, 2);
        }

        [WebMethod]
        public static string GetUserAddress(string EmailID)
        {
            return objOP.RetrieveField2FromField1("Address", "Users", "EmailID", EmailID);
        }

        [WebMethod]
        public static string GetUserTown(string EmailID)
        {
            return objOP.RetrieveField2FromField1("Town", "Users", "EmailID", EmailID);
        }

        [WebMethod]
        public static string GetUserCountry(string EmailID)
        {
            return objOP.RetrieveField2FromField1("Country", "Users", "EmailID", EmailID);
        }

        [WebMethod]
        public static string GetUserPostCode(string EmailID)
        {
            return objOP.RetrieveField2FromField1("PostCode", "Users", "EmailID", EmailID);
        }

        [WebMethod]
        public static string GetUserMobile(string EmailID)
        {
            return objOP.RetrieveField2FromField1("Mobile", "Users", "EmailID", EmailID);
        }

        [WebMethod]
        public static string GetUserTelephone(string EmailID)
        {
            return objOP.RetrieveField2FromField1("Telephone", "Users", "EmailID", EmailID);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            DataTable dtUsers = objDB.GetAllUsers(ObjLogin.EMAILID);
            objCM.DownloadPDF(dtUsers, "User");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            DataTable dtUsers = objDB.GetAllUsers(ObjLogin.EMAILID);
            objCM.DownloadExcel(dtUsers, "User");
        }

        [WebMethod]
        public static void UpdateUserDetails
           (
           string UserId,
           string EmailID,
           string Password,
           string Title,
           string FirstName,
           string LastName,
           string DOB,
           string Address,
           string Town,
           string Country,
           string PostCode,
           string Mobile,
           string Telephone,
           string UserRole
           )
        {
            EntityLayer.User objUser = new EntityLayer.User();

            objUser.UserId = UserId;

            objUser.EmailID = EmailID;
            objUser.Password = objCG.getMd5Hash(Password);

            objUser.Title = Title;
            objUser.FirstName = FirstName;
            objUser.LastName = LastName;

            objUser.DOB = Convert.ToDateTime(DOB,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objUser.Address = Address;
            objUser.Town = Town;

            objUser.Country = Country;
            objUser.PostCode = PostCode;

            objUser.Mobile = Mobile;
            objUser.Telephone = Telephone;

            objUser.UserRole = UserRole;

            objDB.UpdateUserDetails(objUser);
        }

        [WebMethod]
        public static void RemoveUserDetails(string UserId)
        {
            objDB.RemoveUserDetails(UserId);
        }
    }
}
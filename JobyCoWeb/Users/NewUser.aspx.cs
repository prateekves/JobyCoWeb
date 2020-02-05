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

namespace JobyCoWeb.Users
{
    public partial class NewUser : System.Web.UI.Page
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

            }
        }

        public static EntityLayer.ItemValues[] GetDropDownValues(int iTableId, int iFieldId)
        {
            DataTable dtItemValues = objDB.GetDropDownValues(iTableId, iFieldId);
            List<EntityLayer.ItemValues> lstItemValues = new List<EntityLayer.ItemValues>();

            //New Code Added for User Role
            //====================================
            var UserRoles = new List<string> { "SuperAdmin", "CSA", "Driver" };
            //====================================

            foreach (DataRow drCategories in dtItemValues.Rows)
            {
                EntityLayer.ItemValues iv = new EntityLayer.ItemValues();
                iv.ItemId = Convert.ToInt32(drCategories["ItemId"].ToString());
                iv.ItemValue = drCategories["ItemValue"].ToString();

                //New Code Added for Title
                //====================================
                if (iTableId == 1 && iFieldId == 1)
                {
                    lstItemValues.Add(iv);
                }
                //====================================

                //New Code Added for User Role
                //====================================
                if (iTableId == 1 && iFieldId == 2)
                {
                    bool bUserRole = false;

                    foreach (var UserRole in UserRoles)
                    {
                        if (iv.ItemValue != UserRole)
                        {
                            bUserRole = true;
                        }
                        else
                        {
                            bUserRole = false;
                            break;
                        }
                    }

                    if (bUserRole)
                    {
                        lstItemValues.Add(iv);
                    }
                }
                //====================================

                //New Code Added for Countries
                //====================================
                if (iTableId == 10 && iFieldId == 13)
                {
                    lstItemValues.Add(iv);
                }
                //====================================
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
        public static string GetLatestUserId()
        {
            return objOP.GetAutoGeneratedValue("UserId", "Users", "USR", 9);
        }

        [WebMethod]
        public static bool CheckUserId(string EmailID)
        {
            bool bExists = false;

            if (objOP.CheckExistence("EmailID", EmailID, "Users"))
                bExists = true;
            else
                bExists = false;

            return bExists;
        }

        [WebMethod]
        public static List<ListItem> GetAllWarehouse()
        {
            DataTable dtWarehouse = objDB.GetAllWarehouse("");
            List<ListItem> lstWarehouse = new List<ListItem>();

            string sWarehouseId = string.Empty;
            string sWarehouseName = string.Empty;

            foreach (DataRow drLocation in dtWarehouse.Rows)
            {
                sWarehouseId = drLocation["WarehouseId"].ToString();
                sWarehouseName = drLocation["WarehouseName"].ToString();

                lstWarehouse.Add(new ListItem
                {
                    Value = sWarehouseId,
                    Text = sWarehouseName
                });
            }

            return lstWarehouse;
        }

        [WebMethod]
        public static void AddUserDetails
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
           string SecretQuestion,
           string SecretAnswer,
           string UserRole,
           string WarehouseId,
           string Locked
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
            objUser.SecretQuestion = SecretQuestion;
            objUser.SecretAnswer = SecretAnswer;
            objUser.UserRole = UserRole;
            objUser.WarehouseId = WarehouseId;
            objUser.Locked = Convert.ToBoolean(Locked);

            objDB.AddUserDetails(objUser);
        }

        [WebMethod]
        public static string SendRegistrationEmail(string EmailID)
        {
            string sMessage = string.Empty;
            //string sFrom = "switch2web2017@gmail.com";
            //string sFromPassword = "switch2web2017@#";

            //string sFrom = "logman@switch2web.com";
            //string sFromPassword = "Switch@2018#";

            string sFrom = objDB.Email;
            string sFromPassword = objDB.Password;

            string sTo = EmailID;
            string sSubject = "jobycodirect.com User Registration";

            //Mail Body
            string sBody = "";
            sBody += "<b>From: </b> JobyCo Ltd. <br/>";
            sBody += "<b>Sent: </b>" + DateTime.Now.ToLongDateString() + "<br/>";
            sBody += "<b>To: </b>" + sTo + "<br/>";
            sBody += "<b>Subject: </b> jobycodirect.com Registration" + "<br/>";
            sBody += "<h1 style='background-color: navy; color: whitesmoke;padding: 0 0 0 20px;'>&nbsp;jobycodirect.com Registration</h1>";

            int iAtTheRateIndex = sTo.IndexOf("@");
            string sFirstNameFromTo = sTo.Substring(0, iAtTheRateIndex);

            sBody += "Hi " + sFirstNameFromTo + ", <br/><br/>";
            sBody += "Welcome to <b>jobycodirect.com</b>! <br/><br/>";
            sBody += "I hope you are finding the experience easy and helpful. ";
            sBody += "We are only a click away to help set up things and showcase the true potential of <b>jobycodirect.com</b>.<br/><br/>";
            sBody += "Please select the most suitable time via my <b>Calendar</b> for a quick conversation. ";
            sBody += "Looking forward to working with you. <br/><br/>";
            sBody += "Have a good day! <br/><br/>";

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
                    sMessage = "Registration failed";
                }
                else
                {
                    sMessage = "Registration successfull";
                }
            }
            catch { }

            return sMessage;
        }

        [WebMethod]
        public static string GetSpecificRoleDetails(string RoleName)
        {
            DataTable dtSpecificRoleDetails = objDB.GetSpecificRoleDetails(RoleName);
            List<EntityLayer.SpecificUserRole> lstSpecificUserRole = new List<EntityLayer.SpecificUserRole>();

            foreach (DataRow drRoleItem in dtSpecificRoleDetails.Rows)
            {
                EntityLayer.SpecificUserRole objSpecificUserRole = new EntityLayer.SpecificUserRole();

                objSpecificUserRole.Menu_Name = Convert.ToString(drRoleItem["Menu_Name"]);

                objSpecificUserRole.AssignBookingToDriver = Convert.ToBoolean(drRoleItem["AssignBookingToDriver"]);
                objSpecificUserRole.AssignBookingToDriverId = Convert.ToString(drRoleItem["AssignBookingToDriverId"]);

                objSpecificUserRole.AddDriverToAssignBooking = Convert.ToBoolean(drRoleItem["AddDriverToAssignBooking"]);
                objSpecificUserRole.AddDriverToAssignBookingId = Convert.ToString(drRoleItem["AddDriverToAssignBookingId"]);

                objSpecificUserRole.AddBooking = Convert.ToBoolean(drRoleItem["AddBooking"]);
                objSpecificUserRole.AddBookingId = Convert.ToString(drRoleItem["AddBookingId"]);

                objSpecificUserRole.AddShipping = Convert.ToBoolean(drRoleItem["AddShipping"]);
                objSpecificUserRole.AddShippingId = Convert.ToString(drRoleItem["AddShippingId"]);

                objSpecificUserRole.AddCustomer = Convert.ToBoolean(drRoleItem["AddCustomer"]);
                objSpecificUserRole.AddCustomerId = Convert.ToString(drRoleItem["AddCustomerId"]);

                objSpecificUserRole.AddDriver = Convert.ToBoolean(drRoleItem["AddDriver"]);
                objSpecificUserRole.AddDriverId = Convert.ToString(drRoleItem["AddDriverId"]);

                objSpecificUserRole.AddWarehouse = Convert.ToBoolean(drRoleItem["AddWarehouse"]);
                objSpecificUserRole.AddWarehouseId = Convert.ToString(drRoleItem["AddWarehouseId"]);

                objSpecificUserRole.AddLocation = Convert.ToBoolean(drRoleItem["AddLocation"]);
                objSpecificUserRole.AddLocationId = Convert.ToString(drRoleItem["AddLocationId"]);

                objSpecificUserRole.AddZone = Convert.ToBoolean(drRoleItem["AddZone"]);
                objSpecificUserRole.AddZoneId = Convert.ToString(drRoleItem["AddZoneId"]);

                objSpecificUserRole.AddUser = Convert.ToBoolean(drRoleItem["AddUser"]);
                objSpecificUserRole.AddUserId = Convert.ToString(drRoleItem["AddUserId"]);

                objSpecificUserRole.PrintDetails = Convert.ToBoolean(drRoleItem["PrintDetails"]);
                objSpecificUserRole.PrintDetailsId = Convert.ToString(drRoleItem["PrintDetailsId"]);

                objSpecificUserRole.ExportToPDF = Convert.ToBoolean(drRoleItem["ExportToPDF"]);
                objSpecificUserRole.ExportToPDFId = Convert.ToString(drRoleItem["ExportToPDFId"]);

                objSpecificUserRole.ExportToExcel = Convert.ToBoolean(drRoleItem["ExportToExcel"]);
                objSpecificUserRole.ExportToExcelId = Convert.ToString(drRoleItem["ExportToExcelId"]);

                lstSpecificUserRole.Add(objSpecificUserRole);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstSpecificUserRole);
        }

        [WebMethod]
        public static void AddUserSpecificRoles
        (
            string UserId,
            string RoleName,
            string Menu_Name,

            //0
            //=======================================
            string AssignBookingToDriver,
            string AssignBookingToDriverId,

            //1
            //=======================================
            string AddDriverToAssignBooking,
            string AddDriverToAssignBookingId,

            //2
            //=======================================
            string AddBooking,
            string AddBookingId,

            //3
            //=======================================
            string AddShipping,
            string AddShippingId,

            //4
            //=======================================
            string AddCustomer,
            string AddCustomerId,

            //5
            //=======================================
            string AddDriver,
            string AddDriverId,

            //6
            //=======================================
            string AddWarehouse,
            string AddWarehouseId,

            //7
            //=======================================
            string AddLocation,
            string AddLocationId,

            //8
            //=======================================
            string AddZone,
            string AddZoneId,

            //9
            //=======================================
            string AddUser,
            string AddUserId,

            //10
            //=======================================
            string PrintDetails,
            string PrintDetailsId,

            //11
            //=======================================
            string ExportToPDF,
            string ExportToPDFId,

            //12
            //=======================================
            string ExportToExcel,
            string ExportToExcelId
        )
        {
            EntityLayer.UserAccess objUserAccess = new EntityLayer.UserAccess();

            objUserAccess.UserId = UserId;
            objUserAccess.RoleName = RoleName;
            objUserAccess.Menu_Name = Menu_Name;

            switch (Menu_Name)
            {
                case "Request A Quote":
                    objUserAccess.WhetherDefault = false;
                    break;

                case "View All Quotations":
                    objUserAccess.WhetherDefault = false;
                    break;

                default:
                    objUserAccess.WhetherDefault = true;
                    break;
            }


            //0
            //===============================================
            objUserAccess.AssignBookingToDriver = Convert.ToBoolean(AssignBookingToDriver);
            objUserAccess.AssignBookingToDriverId = AssignBookingToDriverId;

            //1
            //===============================================
            objUserAccess.AddDriverToAssignBooking = Convert.ToBoolean(AddDriverToAssignBooking);

            objUserAccess.AddDriverToAssignBookingId = AddDriverToAssignBookingId;

            //2
            //===============================================
            objUserAccess.AddBooking = Convert.ToBoolean(AddBooking);
            objUserAccess.AddBookingId = AddBookingId;

            //3
            //===============================================
            objUserAccess.AddShipping = Convert.ToBoolean(AddShipping);
            objUserAccess.AddShippingId = AddShippingId;

            //4
            //===============================================
            objUserAccess.AddCustomer = Convert.ToBoolean(AddCustomer);
            objUserAccess.AddCustomerId = AddCustomerId;

            //5
            //===============================================
            objUserAccess.AddDriver = Convert.ToBoolean(AddDriver);
            objUserAccess.AddDriverId = AddDriverId;

            //6
            //===============================================
            objUserAccess.AddWarehouse = Convert.ToBoolean(AddWarehouse);
            objUserAccess.AddWarehouseId = AddWarehouseId;

            //7
            //===============================================
            objUserAccess.AddLocation = Convert.ToBoolean(AddLocation);
            objUserAccess.AddLocationId = AddLocationId;

            //8
            //===============================================
            objUserAccess.AddZone = Convert.ToBoolean(AddZone);
            objUserAccess.AddZoneId = AddZoneId;

            //9
            //===============================================
            objUserAccess.AddUser = Convert.ToBoolean(AddUser);
            objUserAccess.AddUserId = AddUserId;

            //10
            //===============================================
            objUserAccess.PrintDetails = Convert.ToBoolean(PrintDetails);
            objUserAccess.PrintDetailsId = PrintDetailsId;

            //11
            //===============================================
            objUserAccess.ExportToPDF = Convert.ToBoolean(ExportToPDF);
            objUserAccess.ExportToPDFId = ExportToPDFId;

            //12
            //===============================================
            objUserAccess.ExportToExcel = Convert.ToBoolean(ExportToExcel);
            objUserAccess.ExportToExcelId = ExportToExcelId;

            objDB.AddUserSpecificRoles(objUserAccess);
        }
    }
}
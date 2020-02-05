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
    public partial class RoleAccess : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("~/Login.aspx");
            objCM.ResetMessageBar(lblErrMsg);
            if (!IsPostBack)
            {
                #region Menu Items & Page Controls

                objCM.PopulateAccessibleMenuItemsOnHiddenField(hfMenusAccessible);

                string sPagePath = objCM.GetCurrentPageName();
                int iMenuId = Convert.ToInt32(objOP.RetrieveField2FromAlikeField1("Menu_ID", "MenuDetails", "PagePath", sPagePath));
                objCM.PopulatePageControlsOnHiddenField(hfControlsAccessible, iMenuId);

                #endregion

                //objCM.FillCheckBoxList(cblMenuNames, "Root", "Menu_Name", "MenuDetails");
                objCM.FillDropDownDistinct(ddlRoleName, "RoleName", "RoleName", "RoleAccess");

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
        public static string GetAllUserRoles()
        {
            DataTable dtUserRoles = objDB.GetAllUserRoles();
            List<EntityLayer.UserRoles> lstUserRoles = new List<EntityLayer.UserRoles>();

            foreach (DataRow drRoleItem in dtUserRoles.Rows)
            {
                EntityLayer.UserRoles objUserRoles = new EntityLayer.UserRoles();

                //objUserRoles.RoleId = Convert.ToString(drRoleItem["RoleId"]);
                //objUserRoles.RoleName = Convert.ToString(drRoleItem["RoleName"]);
                objUserRoles.Menu_Name = Convert.ToString(drRoleItem["Menu_Name"]);

                objUserRoles.AssignBookingToDriver = Convert.ToBoolean(drRoleItem["AssignBookingToDriver"]);
                //objUserRoles.AssignBookingToDriverId = Convert.ToString(drRoleItem["AssignBookingToDriverId"]);

                objUserRoles.AddDriverToAssignBooking = Convert.ToBoolean(drRoleItem["AddDriverToAssignBooking"]);
                //objUserRoles.AddDriverToAssignBookingId = Convert.ToString(drRoleItem["AddDriverToAssignBookingId"]);

                objUserRoles.AddBooking = Convert.ToBoolean(drRoleItem["AddBooking"]);
                //objUserRoles.AddBookingId = Convert.ToString(drRoleItem["AddBookingId"]);

                objUserRoles.AddShipping = Convert.ToBoolean(drRoleItem["AddShipping"]);
                //objUserRoles.AddShippingId = Convert.ToString(drRoleItem["AddShippingId"]);

                objUserRoles.AddCustomer = Convert.ToBoolean(drRoleItem["AddCustomer"]);
                //objUserRoles.AddCustomerId = Convert.ToString(drRoleItem["AddCustomerId"]);

                objUserRoles.AddDriver = Convert.ToBoolean(drRoleItem["AddDriver"]);
                //objUserRoles.AddDriverId = Convert.ToString(drRoleItem["AddDriverId"]);

                objUserRoles.AddWarehouse = Convert.ToBoolean(drRoleItem["AddWarehouse"]);
                //objUserRoles.AddWarehouseId = Convert.ToString(drRoleItem["AddWarehouseId"]);

                objUserRoles.AddLocation = Convert.ToBoolean(drRoleItem["AddLocation"]);
                //objUserRoles.AddLocationId = Convert.ToString(drRoleItem["AddLocationId"]);

                objUserRoles.AddZone = Convert.ToBoolean(drRoleItem["AddZone"]);
                //objUserRoles.AddZoneId = Convert.ToString(drRoleItem["AddZoneId"]);

                objUserRoles.AddUser = Convert.ToBoolean(drRoleItem["AddUser"]);
                //objUserRoles.AddUserId = Convert.ToString(drRoleItem["AddUserId"]);

                objUserRoles.PrintDetails = Convert.ToBoolean(drRoleItem["PrintDetails"]);
                //objUserRoles.PrintDetailsId = Convert.ToString(drRoleItem["PrintDetailsId"]);

                objUserRoles.ExportToPDF = Convert.ToBoolean(drRoleItem["ExportToPDF"]);
                //objUserRoles.ExportToPDFId = Convert.ToString(drRoleItem["ExportToPDFId"]);

                objUserRoles.ExportToExcel = Convert.ToBoolean(drRoleItem["ExportToExcel"]);
                //objUserRoles.ExportToExcelId = Convert.ToString(drRoleItem["ExportToExcelId"]);

                lstUserRoles.Add(objUserRoles);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUserRoles);
        }

        [WebMethod]
        public static string GetSpecificUserRole(string RoleName)
        {
            DataTable dtUserRoles = objDB.GetSpecificUserRole(RoleName);
            List<EntityLayer.UserRoles> lstUserRoles = new List<EntityLayer.UserRoles>();

            foreach (DataRow drRoleItem in dtUserRoles.Rows)
            {
                EntityLayer.UserRoles objUserRoles = new EntityLayer.UserRoles();

                //objUserRoles.RoleId = Convert.ToString(drRoleItem["RoleId"]);
                //objUserRoles.RoleName = Convert.ToString(drRoleItem["RoleName"]);
                objUserRoles.Menu_Name = Convert.ToString(drRoleItem["Menu_Name"]);

                objUserRoles.AssignBookingToDriver = Convert.ToBoolean(drRoleItem["AssignBookingToDriver"]);
                //objUserRoles.AssignBookingToDriverId = Convert.ToString(drRoleItem["AssignBookingToDriverId"]);

                objUserRoles.AddDriverToAssignBooking = Convert.ToBoolean(drRoleItem["AddDriverToAssignBooking"]);
                //objUserRoles.AddDriverToAssignBookingId = Convert.ToString(drRoleItem["AddDriverToAssignBookingId"]);

                objUserRoles.AddBooking = Convert.ToBoolean(drRoleItem["AddBooking"]);
                //objUserRoles.AddBookingId = Convert.ToString(drRoleItem["AddBookingId"]);

                objUserRoles.AddShipping = Convert.ToBoolean(drRoleItem["AddShipping"]);
                //objUserRoles.AddShippingId = Convert.ToString(drRoleItem["AddShippingId"]);

                objUserRoles.AddCustomer = Convert.ToBoolean(drRoleItem["AddCustomer"]);
                //objUserRoles.AddCustomerId = Convert.ToString(drRoleItem["AddCustomerId"]);

                objUserRoles.AddDriver = Convert.ToBoolean(drRoleItem["AddDriver"]);
                //objUserRoles.AddDriverId = Convert.ToString(drRoleItem["AddDriverId"]);

                objUserRoles.AddWarehouse = Convert.ToBoolean(drRoleItem["AddWarehouse"]);
                //objUserRoles.AddWarehouseId = Convert.ToString(drRoleItem["AddWarehouseId"]);

                objUserRoles.AddLocation = Convert.ToBoolean(drRoleItem["AddLocation"]);
                //objUserRoles.AddLocationId = Convert.ToString(drRoleItem["AddLocationId"]);

                objUserRoles.AddZone = Convert.ToBoolean(drRoleItem["AddZone"]);
                //objUserRoles.AddZoneId = Convert.ToString(drRoleItem["AddZoneId"]);

                objUserRoles.AddUser = Convert.ToBoolean(drRoleItem["AddUser"]);
                //objUserRoles.AddUserId = Convert.ToString(drRoleItem["AddUserId"]);

                objUserRoles.PrintDetails = Convert.ToBoolean(drRoleItem["PrintDetails"]);
                //objUserRoles.PrintDetailsId = Convert.ToString(drRoleItem["PrintDetailsId"]);

                objUserRoles.ExportToPDF = Convert.ToBoolean(drRoleItem["ExportToPDF"]);
                //objUserRoles.ExportToPDFId = Convert.ToString(drRoleItem["ExportToPDFId"]);

                objUserRoles.ExportToExcel = Convert.ToBoolean(drRoleItem["ExportToExcel"]);
                //objUserRoles.ExportToExcelId = Convert.ToString(drRoleItem["ExportToExcelId"]);

                lstUserRoles.Add(objUserRoles);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUserRoles);
        }

        [WebMethod]
        public static void UpdateUserRoles
        (
            string RoleId,
            string RoleName,
            string Menu_Name,
            string AssignBookingToDriver,//0
            string AddDriverToAssignBooking,//1
            string AddBooking,//2
            string AddShipping,//3
            string AddCustomer,//4
            string AddDriver,//5
            string AddWarehouse,//6
            string AddLocation,//7
            string AddZone,//8
            string AddUser,//9
            string PrintDetails,//10
            string ExportToPDF,//11
            string ExportToExcel//12
        )
        {
            EntityLayer.UserRoles objUserRoles = new EntityLayer.UserRoles();

            objUserRoles.RoleId = RoleId;
            objUserRoles.RoleName = RoleName;
            objUserRoles.Menu_Name = Menu_Name;

            objUserRoles.AssignBookingToDriver = Convert.ToBoolean(AssignBookingToDriver);//0
            objUserRoles.AddDriverToAssignBooking = Convert.ToBoolean(AddDriverToAssignBooking);//1
            objUserRoles.AddBooking = Convert.ToBoolean(AddBooking);//2
            objUserRoles.AddShipping = Convert.ToBoolean(AddShipping);//3
            objUserRoles.AddCustomer = Convert.ToBoolean(AddCustomer);//4
            objUserRoles.AddDriver = Convert.ToBoolean(AddDriver);//5
            objUserRoles.AddWarehouse = Convert.ToBoolean(AddWarehouse);//6
            objUserRoles.AddLocation = Convert.ToBoolean(AddLocation);//7
            objUserRoles.AddZone = Convert.ToBoolean(AddZone);//8
            objUserRoles.AddUser = Convert.ToBoolean(AddUser);//9
            objUserRoles.PrintDetails = Convert.ToBoolean(PrintDetails);//10
            objUserRoles.ExportToPDF = Convert.ToBoolean(ExportToPDF);//11
            objUserRoles.ExportToExcel = Convert.ToBoolean(ExportToExcel);//12

            objDB.UpdateUserRoles(objUserRoles);
        }
    }
}
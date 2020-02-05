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
    public partial class UserAccess : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            objCM.ResetMessageBar(lblErrMsg);
            if (!IsPostBack)
            {
                #region Menu Items & Page Controls

                objCM.PopulateAccessibleMenuItemsOnHiddenField(hfMenusAccessible);

                string sPagePath = objCM.GetCurrentPageName();
                int iMenuId = Convert.ToInt32(objOP.RetrieveField2FromAlikeField1("Menu_ID", "MenuDetails", "PagePath", sPagePath));
                objCM.PopulatePageControlsOnHiddenField(hfControlsAccessible, iMenuId);

                #endregion

                objCM.FillDropDownDistinct(ddlUserId, "UserId", "UserId", "UserAccess");
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
        public static string GetSpecificUserAccess(string UserId)
        {
            DataTable dtUserAccess = objDB.GetSpecificUserAccess(UserId);
            List<EntityLayer.UserAccess> lstUserAccess = new List<EntityLayer.UserAccess>();

            foreach (DataRow drAccessItem in dtUserAccess.Rows)
            {
                EntityLayer.UserAccess objUserAccess = new EntityLayer.UserAccess();

                //objUserAccess.UserId = Convert.ToString(drAccessItem["UserId"]);
                //objUserAccess.RoleName = Convert.ToString(drAccessItem["RoleName"]);
                objUserAccess.WhetherDefault = Convert.ToBoolean(drAccessItem["WhetherDefault"]);
                objUserAccess.Menu_Name = Convert.ToString(drAccessItem["Menu_Name"]);

                objUserAccess.AssignBookingToDriver = Convert.ToBoolean(drAccessItem["AssignBookingToDriver"]);
                //objUserAccess.AssignBookingToDriverId = Convert.ToString(drAccessItem["AssignBookingToDriverId"]);

                objUserAccess.AddDriverToAssignBooking = Convert.ToBoolean(drAccessItem["AddDriverToAssignBooking"]);
                //objUserAccess.AddDriverToAssignBookingId = Convert.ToString(drAccessItem["AddDriverToAssignBookingId"]);

                objUserAccess.AddBooking = Convert.ToBoolean(drAccessItem["AddBooking"]);
                //objUserAccess.AddBookingId = Convert.ToString(drAccessItem["AddBookingId"]);

                objUserAccess.AddShipping = Convert.ToBoolean(drAccessItem["AddShipping"]);
                //objUserAccess.AddShippingId = Convert.ToString(drAccessItem["AddShippingId"]);

                objUserAccess.AddCustomer = Convert.ToBoolean(drAccessItem["AddCustomer"]);
                //objUserAccess.AddCustomerId = Convert.ToString(drAccessItem["AddCustomerId"]);

                objUserAccess.AddDriver = Convert.ToBoolean(drAccessItem["AddDriver"]);
                //objUserAccess.AddDriverId = Convert.ToString(drAccessItem["AddDriverId"]);

                objUserAccess.AddWarehouse = Convert.ToBoolean(drAccessItem["AddWarehouse"]);
                //objUserAccess.AddWarehouseId = Convert.ToString(drAccessItem["AddWarehouseId"]);

                objUserAccess.AddLocation = Convert.ToBoolean(drAccessItem["AddLocation"]);
                //objUserAccess.AddLocationId = Convert.ToString(drAccessItem["AddLocationId"]);

                objUserAccess.AddZone = Convert.ToBoolean(drAccessItem["AddZone"]);
                //objUserAccess.AddZoneId = Convert.ToString(drAccessItem["AddZoneId"]);

                objUserAccess.AddUser = Convert.ToBoolean(drAccessItem["AddUser"]);
                //objUserAccess.AddUserId = Convert.ToString(drAccessItem["AddUserId"]);

                objUserAccess.PrintDetails = Convert.ToBoolean(drAccessItem["PrintDetails"]);
                //objUserAccess.PrintDetailsId = Convert.ToString(drAccessItem["PrintDetailsId"]);

                objUserAccess.ExportToPDF = Convert.ToBoolean(drAccessItem["ExportToPDF"]);
                //objUserAccess.ExportToPDFId = Convert.ToString(drAccessItem["ExportToPDFId"]);

                objUserAccess.ExportToExcel = Convert.ToBoolean(drAccessItem["ExportToExcel"]);
                //objUserAccess.ExportToExcelId = Convert.ToString(drAccessItem["ExportToExcelId"]);

                lstUserAccess.Add(objUserAccess);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUserAccess);
        }

        [WebMethod]
        public static string GetSpecificRoleAccess(string RoleName)
        {
            DataTable dtUserAccess = objDB.GetSpecificRoleAccess(RoleName);
            List<EntityLayer.UserAccess> lstUserAccess = new List<EntityLayer.UserAccess>();

            foreach (DataRow drAccessItem in dtUserAccess.Rows)
            {
                EntityLayer.UserAccess objUserAccess = new EntityLayer.UserAccess();

                //objUserAccess.UserId = Convert.ToString(drAccessItem["UserId"]);
                //objUserAccess.RoleName = Convert.ToString(drAccessItem["RoleName"]);
                objUserAccess.WhetherDefault = Convert.ToBoolean(drAccessItem["WhetherDefault"]);
                objUserAccess.Menu_Name = Convert.ToString(drAccessItem["Menu_Name"]);

                objUserAccess.AssignBookingToDriver = Convert.ToBoolean(drAccessItem["AssignBookingToDriver"]);
                //objUserAccess.AssignBookingToDriverId = Convert.ToString(drAccessItem["AssignBookingToDriverId"]);

                objUserAccess.AddDriverToAssignBooking = Convert.ToBoolean(drAccessItem["AddDriverToAssignBooking"]);
                //objUserAccess.AddDriverToAssignBookingId = Convert.ToString(drAccessItem["AddDriverToAssignBookingId"]);

                objUserAccess.AddBooking = Convert.ToBoolean(drAccessItem["AddBooking"]);
                //objUserAccess.AddBookingId = Convert.ToString(drAccessItem["AddBookingId"]);

                objUserAccess.AddShipping = Convert.ToBoolean(drAccessItem["AddShipping"]);
                //objUserAccess.AddShippingId = Convert.ToString(drAccessItem["AddShippingId"]);

                objUserAccess.AddCustomer = Convert.ToBoolean(drAccessItem["AddCustomer"]);
                //objUserAccess.AddCustomerId = Convert.ToString(drAccessItem["AddCustomerId"]);

                objUserAccess.AddDriver = Convert.ToBoolean(drAccessItem["AddDriver"]);
                //objUserAccess.AddDriverId = Convert.ToString(drAccessItem["AddDriverId"]);

                objUserAccess.AddWarehouse = Convert.ToBoolean(drAccessItem["AddWarehouse"]);
                //objUserAccess.AddWarehouseId = Convert.ToString(drAccessItem["AddWarehouseId"]);

                objUserAccess.AddLocation = Convert.ToBoolean(drAccessItem["AddLocation"]);
                //objUserAccess.AddLocationId = Convert.ToString(drAccessItem["AddLocationId"]);

                objUserAccess.AddZone = Convert.ToBoolean(drAccessItem["AddZone"]);
                //objUserAccess.AddZoneId = Convert.ToString(drAccessItem["AddZoneId"]);

                objUserAccess.AddUser = Convert.ToBoolean(drAccessItem["AddUser"]);
                //objUserAccess.AddUserId = Convert.ToString(drAccessItem["AddUserId"]);

                objUserAccess.PrintDetails = Convert.ToBoolean(drAccessItem["PrintDetails"]);
                //objUserAccess.PrintDetailsId = Convert.ToString(drAccessItem["PrintDetailsId"]);

                objUserAccess.ExportToPDF = Convert.ToBoolean(drAccessItem["ExportToPDF"]);
                //objUserAccess.ExportToPDFId = Convert.ToString(drAccessItem["ExportToPDFId"]);

                objUserAccess.ExportToExcel = Convert.ToBoolean(drAccessItem["ExportToExcel"]);
                //objUserAccess.ExportToExcelId = Convert.ToString(drAccessItem["ExportToExcelId"]);

                lstUserAccess.Add(objUserAccess);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstUserAccess);
        }

        [WebMethod]
        public static void UpdateUserAccess
        (
            string UserId,
            string RoleName,
            string WhetherDefault,
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
            EntityLayer.UserAccess objUserAccess = new EntityLayer.UserAccess();

            objUserAccess.UserId = UserId;
            objUserAccess.RoleName = RoleName;
            objUserAccess.WhetherDefault = Convert.ToBoolean(WhetherDefault);
            objUserAccess.Menu_Name = Menu_Name;

            objUserAccess.AssignBookingToDriver = Convert.ToBoolean(AssignBookingToDriver);//0
            objUserAccess.AddDriverToAssignBooking = Convert.ToBoolean(AddDriverToAssignBooking);//1
            objUserAccess.AddBooking = Convert.ToBoolean(AddBooking);//2
            objUserAccess.AddShipping = Convert.ToBoolean(AddShipping);//3
            objUserAccess.AddCustomer = Convert.ToBoolean(AddCustomer);//4
            objUserAccess.AddDriver = Convert.ToBoolean(AddDriver);//5
            objUserAccess.AddWarehouse = Convert.ToBoolean(AddWarehouse);//6
            objUserAccess.AddLocation = Convert.ToBoolean(AddLocation);//7
            objUserAccess.AddZone = Convert.ToBoolean(AddZone);//8
            objUserAccess.AddUser = Convert.ToBoolean(AddUser);//9
            objUserAccess.PrintDetails = Convert.ToBoolean(PrintDetails);//10
            objUserAccess.ExportToPDF = Convert.ToBoolean(ExportToPDF);//11
            objUserAccess.ExportToExcel = Convert.ToBoolean(ExportToExcel);//12

            objDB.UpdateUserAccess(objUserAccess);
        }
    }
}
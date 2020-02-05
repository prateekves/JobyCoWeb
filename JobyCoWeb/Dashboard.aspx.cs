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
using System.Globalization;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb
{
    public partial class Dashboard1 : System.Web.UI.Page
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
                objCM.PopulateAccessibleMenuItemsOnHiddenField(hfMenusAccessible);

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
        public static object GetDashboardStatus()
        {
            DataTable dtDashboardStatus = objDB.GetDashboardStatus();
            List<DashboardStatus> listDashboardStatus = new List<DashboardStatus>();

            foreach (DataRow drDashboardStatus in dtDashboardStatus.Rows)
            {
                DashboardStatus dashboardStatus = new DashboardStatus();

                //Booking
                dashboardStatus.WeeklyBooking = Convert.ToInt32(drDashboardStatus["WeeklyBooking"].ToString());
                dashboardStatus.MonthlyBooking = Convert.ToInt32(drDashboardStatus["MonthlyBooking"].ToString());
                dashboardStatus.TotalBooking = Convert.ToInt32(drDashboardStatus["TotalBooking"].ToString());
                //Shipping
                dashboardStatus.WeeklyShipping = Convert.ToInt32(drDashboardStatus["WeeklyShipping"].ToString());
                dashboardStatus.MonthlyShipping = Convert.ToInt32(drDashboardStatus["MonthlyShipping"].ToString());
                dashboardStatus.TotalShipping = Convert.ToInt32(drDashboardStatus["TotalShipping"].ToString());

                //Customer
                dashboardStatus.WeeklyCustomer = Convert.ToInt32(drDashboardStatus["WeeklyCustomer"].ToString());
                dashboardStatus.MonthlyCustomer = Convert.ToInt32(drDashboardStatus["MonthlyCustomer"].ToString());
                dashboardStatus.TotalCustomer = Convert.ToInt32(drDashboardStatus["TotalCustomer"].ToString());

                listDashboardStatus.Add(dashboardStatus);
            }
            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(listDashboardStatus);

        }
    }
}
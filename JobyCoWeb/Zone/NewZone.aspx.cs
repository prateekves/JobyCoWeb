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
using JobyCoWeb.Models;
using System.Data;
using System.Web.Services;

#endregion

namespace JobyCoWeb.Zone
{
    public partial class NewZone : System.Web.UI.Page
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
        public static string GetLatestZoneId()
        {
            return objOP.GetAutoGeneratedValue("ZoneId", "Zone", "ZONE", 9);
        }

        [WebMethod]
        public static List<ListItem> GetAllLocations()
        {
            DataTable dtLocation = objDB.GetAllLocations();
            List<ListItem> lstLocation = new List<ListItem>();

            string sLocationId = string.Empty;
            string sLocationName = string.Empty;
            string sLocationAddress = string.Empty;

            foreach (DataRow drLocation in dtLocation.Rows)
            {
                sLocationId = drLocation["LocationId"].ToString();
                sLocationName = drLocation["LocationName"].ToString();
                sLocationAddress = drLocation["LocationAddress"].ToString();
                lstLocation.Add(new ListItem
                {
                    Value = sLocationId,
                    Text = sLocationAddress
                });
            }

            return lstLocation;
        }

        [WebMethod]
        public static void AddZoneDetails
        (
            string ZoneId,
            string ZoneName,
            string LocationId
        )
        {
            EntityLayer.Zone objZone = new EntityLayer.Zone();

            objZone.ZoneId = ZoneId;
            objZone.ZoneName = ZoneName;
            objZone.LocationId = LocationId;

            objDB.AddZoneDetails(objZone);
        }
    }
}
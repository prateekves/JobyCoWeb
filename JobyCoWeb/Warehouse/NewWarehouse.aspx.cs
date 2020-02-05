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

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Web.Services;

#endregion

namespace JobyCoWeb.Warehouse
{
    public partial class NewWarehouse : System.Web.UI.Page
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
        public static string GetLatestWarehouseId()
        {
            return objOP.GetAutoGeneratedValue("WarehouseId", "Warehouse", "WARE", 9);
        }

        [WebMethod]
        public static List<ListItem> GetAllLocations()
        {
            DataTable dtLocation = objDB.GetAllLocations();
            List<ListItem> lstLocation = new List<ListItem>();

            string sLocationId = string.Empty;
            string sLocationName = string.Empty;

            foreach (DataRow drLocation in dtLocation.Rows)
            {
                sLocationId = drLocation["LocationId"].ToString();
                sLocationName = drLocation["LocationName"].ToString();

                lstLocation.Add(new ListItem
                {
                    Value = sLocationId,
                    Text = sLocationName
                });
            }

            return lstLocation;
        }

        [WebMethod]
        public static List<ListItem> GetAllZones(string WarehouseLocationId)
        {
            DataTable dtZone = objDB.GetAllZones(WarehouseLocationId);
            List<ListItem> lstZone = new List<ListItem>();

            string sZoneId = string.Empty;
            string sZoneName = string.Empty;

            foreach (DataRow drZone in dtZone.Rows)
            {
                sZoneId = drZone["ZoneId"].ToString();
                sZoneName = drZone["ZoneName"].ToString();

                lstZone.Add(new ListItem
                {
                    Value = sZoneId,
                    Text = sZoneName
                });
            }

            return lstZone;
        }

        [WebMethod]
        public static void AddWarehouseDetails
        (
            string WarehouseId,
            string WarehouseName,
            string LocationName,
            string ZoneName
        )
        {
            EntityLayer.Warehouse objWarehouse = new EntityLayer.Warehouse();

            objWarehouse.WarehouseId = WarehouseId;
            objWarehouse.WarehouseName = WarehouseName;
            objWarehouse.LocationName = LocationName;
            objWarehouse.ZoneName = ZoneName;

            objDB.AddWarehouseDetails(objWarehouse);
        }
    }
}
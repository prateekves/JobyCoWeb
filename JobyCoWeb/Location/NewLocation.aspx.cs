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

namespace JobyCoWeb.Location
{
    public partial class NewLocation : System.Web.UI.Page
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
        public static string GetLatestLocationId()
        {
            return objOP.GetAutoGeneratedValue("LocationId", "Location", "LOC", 9);
        }

        [WebMethod]
        public static EntityLayer.ItemValues[] GetAllCountries()
        {
            return GetDropDownValues(10, 13);
        }

        [WebMethod]
        public static string GetCountryIdFromName(string CountryName)
        {
            return objOP.RetrieveField2FromField1("CountryId", "Country", "CountryName", CountryName);
        }

        [WebMethod]
        public static EntityLayer.City[] GetSpecificCities(string CountryId)
        {
            DataTable dtCity = objDB.GetSpecificCities(CountryId);
            List<EntityLayer.City> lstItems = new List<EntityLayer.City>();

            foreach (DataRow drItems in dtCity.Rows)
            {
                EntityLayer.City objCity = new EntityLayer.City();
                objCity.CityId = Convert.ToInt32(drItems["CityId"].ToString());
                objCity.CityName = drItems["CityName"].ToString();

                lstItems.Add(objCity);
            }

            return lstItems.ToArray();
        }

        [WebMethod]
        public static string GetCityIdFromName(string CityName)
        {
            return objOP.RetrieveField2FromField1("CityId", "City", "CityName", CityName);
        }

        [WebMethod]
        public static EntityLayer.SpecificLocation[] GetSpecificLocations(string CityId)
        {
            DataTable dtLocation = objDB.GetSpecificLocations(CityId);
            List<EntityLayer.SpecificLocation> lstItems = new List<EntityLayer.SpecificLocation>();

            foreach (DataRow drItems in dtLocation.Rows)
            {
                EntityLayer.SpecificLocation objLocation = new EntityLayer.SpecificLocation();
                objLocation.LocationId = drItems["LocationId"].ToString();
                objLocation.LocationName = drItems["LocationName"].ToString();

                lstItems.Add(objLocation);
            }

            return lstItems.ToArray();
        }

        [WebMethod]
        public static void AddLocationDetails
        (
            string LocationId,
            string LocationName,
            string LocationAddress,
            decimal LocationLatitude,
            decimal LocationLongitude,
            string Country
        )
        {
            EntityLayer.Location objLocation = new EntityLayer.Location();

            objLocation.LocationId = LocationId;
            objLocation.LocationName = LocationName;
            objLocation.LocationAddress = LocationAddress;
            objLocation.LocationLatitude = Convert.ToDecimal(LocationLatitude);
            objLocation.LocationLongitude = Convert.ToDecimal(LocationLongitude);
            objLocation.Country = Country;

            objDB.AddLocationDetails(objLocation);
        }
    }
}
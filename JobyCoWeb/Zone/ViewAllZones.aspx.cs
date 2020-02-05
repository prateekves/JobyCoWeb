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

namespace JobyCoWeb.Zone
{
    public partial class ViewAllZones : System.Web.UI.Page
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
        public static string GetAllZones()
        {
            DataTable dtZone = objDB.GetAllZones();
            List<EntityLayer.Zone> lstZone = new List<EntityLayer.Zone>();

            foreach (DataRow drZone in dtZone.Rows)
            {
                EntityLayer.Zone objZone = new EntityLayer.Zone();

                objZone.ZoneId = drZone["ZoneId"].ToString();
                objZone.ZoneName = drZone["ZoneName"].ToString();
                objZone.LocationName = drZone["LocationName"].ToString();

                lstZone.Add(objZone);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstZone);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtZone = objDB.GetAllZones();
            objCM.DownloadPDF(dtZone, "Zone");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtZone = objDB.GetAllZones();
            objCM.DownloadExcel(dtZone, "Zone");
        }

        [WebMethod]
        public static void UpdateZoneDetails
        (
           string ZoneId,
           string ZoneName,
           string LocationName
        )
        {
            EntityLayer.Zone objZone = new EntityLayer.Zone();

            objZone.ZoneId = ZoneId;
            objZone.ZoneName = ZoneName;
            objZone.LocationName = LocationName;

            objDB.UpdateZoneDetails(objZone);
        }

        [WebMethod]
        public static void RemoveZoneDetails(string ZoneId)
        {
            objDB.RemoveZoneDetails(ZoneId);
        }
    }
}
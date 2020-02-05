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

namespace JobyCoWeb.Warehouse
{
    public partial class ViewAllWarehouses : System.Web.UI.Page
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
        public static string GetAllWarehouses()
        {
            DataTable dtWarehouse = objDB.GetAllWarehouses();
            List<EntityLayer.Warehouse> lstWarehouse = new List<EntityLayer.Warehouse>();

            foreach (DataRow drWarehouse in dtWarehouse.Rows)
            {
                EntityLayer.Warehouse objWarehouse = new EntityLayer.Warehouse();

                objWarehouse.WarehouseId = drWarehouse["WarehouseId"].ToString();
                objWarehouse.WarehouseName = drWarehouse["WarehouseName"].ToString();
                objWarehouse.LocationName = drWarehouse["LocationName"].ToString();
                objWarehouse.ZoneName = drWarehouse["ZoneName"].ToString();

                lstWarehouse.Add(objWarehouse);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstWarehouse);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtWarehouses = objDB.GetAllWarehouses();
            objCM.DownloadPDF(dtWarehouses, "Warehouse");
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtWarehouses = objDB.GetAllWarehouses();
            objCM.DownloadExcel(dtWarehouses, "Warehouse");
        }

        [WebMethod]
        public static void UpdateWarehouseDetails
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

            objDB.UpdateWarehouseDetails(objWarehouse);
        }

        [WebMethod]
        public static void RemoveWarehouseDetails(string WarehouseId)
        {
            objDB.RemoveWarehouseDetails(WarehouseId);
        }
    }
}
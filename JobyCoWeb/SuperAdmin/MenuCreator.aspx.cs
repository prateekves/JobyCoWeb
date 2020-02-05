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
    public partial class MenuCreator : System.Web.UI.Page
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

                objCM.FillDropDown(ddlParentMenuName, "ParentMenuName", "Menu_Name", "MenuDetails");

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
        public static string getParentMenuId(string MenuName)
        {
            return objOP.RetrieveField2FromField1("Menu_ID", "MenuDetails", "Menu_Name", MenuName);
        }

        [WebMethod]
        public static string GetAllMenuDetails()
        {
            DataTable dtMenuDetails = objDB.GetAllMenuDetails();
            List<EntityLayer.MenuDetails> lstMenuDetails = new List<EntityLayer.MenuDetails>();

            foreach (DataRow drMenuItem in dtMenuDetails.Rows)
            {
                EntityLayer.MenuDetails objMenuDetails = new EntityLayer.MenuDetails();

                objMenuDetails.Menu_ID = Convert.ToInt32(drMenuItem["Menu_ID"]);
                objMenuDetails.Menu_Name = drMenuItem["Menu_Name"].ToString();
                //objMenuDetails.Parent_ID = Convert.ToInt32(drMenuItem["Parent_ID"]);
                objMenuDetails.Parent_Name = Convert.ToString(drMenuItem["Parent_Name"]);
                objMenuDetails.IsActive = Convert.ToBoolean(drMenuItem["IsActive"]);

                lstMenuDetails.Add(objMenuDetails);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstMenuDetails);
        }

        [WebMethod]
        public static string AddMenuDetails
        (
            string Menu_Name,
            string Parent_ID,
            string PagePath,
            string IsActive
        )
        {
            EntityLayer.MenuDetails objMenu = new EntityLayer.MenuDetails();

            objMenu.Menu_Name = Menu_Name;
            objMenu.Parent_ID = Convert.ToInt32(Parent_ID);
            objMenu.PagePath = PagePath;
            objMenu.IsActive = Convert.ToBoolean(IsActive);

            string sMsg = string.Empty;
            int iResult = objDB.AddMenuDetails(objMenu);
            if (iResult == -100) {
                sMsg = "This Menu Item already exists";
            }
            else
            {
                sMsg = "Menu Details saved successfully";
            }

            return sMsg;
        }

        [WebMethod]
        public static void ChangeMenuStatus(string MenuId, string Enabled)
        {
            EntityLayer.MenuDetails objMD = new EntityLayer.MenuDetails();

            objMD.Menu_ID = Convert.ToInt32(MenuId);
            objMD.IsActive = Convert.ToBoolean(Enabled);

            objDB.ChangeMenuStatus(objMD);
        }
    }
}
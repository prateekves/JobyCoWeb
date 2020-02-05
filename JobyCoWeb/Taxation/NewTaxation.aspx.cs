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

namespace JobyCoWeb.Taxation
{
    public partial class NewTaxation : System.Web.UI.Page
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
        public static string AddFlatTaxation
            (
            string TaxationName,
            int TaxAmount,
            bool IsFixPercent,
            string RadioChargesType
            )
        {
            EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

            objTaxation.TaxName = TaxationName;
            objTaxation.TaxAmount = TaxAmount;
            objTaxation.IsRange = false;
            objTaxation.IsPercent = IsFixPercent;
            objTaxation.Active = true;
            objTaxation.RadioChargesType = RadioChargesType;
            return objDB.AddTaxation(objTaxation);
        }

        
        [WebMethod]
        public static string AddTaxation
            (
           string TaxationName,
           int MinVal,
           int MaxVal,
           bool IsPercent,
           decimal TaxAmount,
           string RadioChargesType
            )
        {
            EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

            objTaxation.TaxName = TaxationName;
            objTaxation.TaxAmount = TaxAmount;
            objTaxation.IsRange = true;
            objTaxation.IsPercent = IsPercent;
            objTaxation.Active = true;
            objTaxation.MinVal = MinVal;
            objTaxation.MaxVal = MaxVal;
            objTaxation.RadioChargesType = RadioChargesType;

            return objDB.AddTaxation(objTaxation);
        }
        [WebMethod]
        public static string checkTaxNameExistance(string TaxationName)
        {
            return objDB.checkTaxNameExistance(TaxationName);
        }

        [WebMethod]
        public static string GetAllTaxation()
        {
            DataTable dtTaxation = objDB.GetAllTaxation();
            List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            foreach (DataRow drTaxation in dtTaxation.Rows)
            {
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

                objTaxation.Slno = Convert.ToInt32(drTaxation["Slno"].ToString());
                objTaxation.Id = Convert.ToInt32(drTaxation["Id"].ToString());
                objTaxation.RadioChargesType = drTaxation["ChargesType"].ToString();
                objTaxation.TaxName = drTaxation["TaxName"].ToString();
                if (Convert.ToBoolean(drTaxation["Active"].ToString()))
                {
                    objTaxation.Status = "Active";
                }
                else
                {
                    objTaxation.Status = "Inactive";
                }
                
                lstTaxation.Add(objTaxation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstTaxation);
        }

        
        [WebMethod]
        public static string GetAllTaxationForEdit(string ChargesId)
        {
            DataTable dtTaxation = objDB.GetAllTaxationForEdit(ChargesId);
            List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            foreach (DataRow drTaxation in dtTaxation.Rows)
            {
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

                objTaxation.Id = Convert.ToInt32(drTaxation["Id"].ToString());
                objTaxation.TaxName = drTaxation["TaxName"].ToString();
                objTaxation.RadioChargesType = drTaxation["ChargesType"].ToString();
                objTaxation.IsRange = Convert.ToBoolean(drTaxation["IsRange"].ToString());
                objTaxation.IsPercent = Convert.ToBoolean(drTaxation["IsPercent"].ToString());
                objTaxation.TaxAmount = Convert.ToDecimal(drTaxation["TaxAmount"].ToString());
                objTaxation.Active = Convert.ToBoolean(drTaxation["Active"].ToString());

                lstTaxation.Add(objTaxation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstTaxation);
        }

        [WebMethod]
        public static string GetAllTaxationForEditRange(string ChargesId)
        {
            DataTable dtTaxation = objDB.GetAllTaxationForEditRange(ChargesId);
            List<EntityLayer.Taxation> lstTaxation = new List<EntityLayer.Taxation>();

            foreach (DataRow drTaxation in dtTaxation.Rows)
            {
                EntityLayer.Taxation objTaxation = new EntityLayer.Taxation();

                objTaxation.Id = Convert.ToInt32(drTaxation["Id"].ToString());
                objTaxation.TaxId = drTaxation["TaxId"].ToString();
                objTaxation.MinVal = Convert.ToInt32(drTaxation["MinVal"].ToString());
                objTaxation.MaxVal = Convert.ToInt32(drTaxation["MaxVal"].ToString());
                objTaxation.TaxAmount = Convert.ToDecimal(drTaxation["TaxAmount"].ToString());
                objTaxation.IsPercent = Convert.ToBoolean(drTaxation["IsPercent"].ToString());
                
                lstTaxation.Add(objTaxation);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstTaxation);
        }

        [WebMethod]
        public static bool DeleteTaxation(string ChargesId, string Chargestxt)
        {
            return objDB.DeleteTaxation(ChargesId, Chargestxt);
        }

    }
}
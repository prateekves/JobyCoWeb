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

namespace JobyCoWeb.Customers
{
    public partial class ViewAllCustomers : System.Web.UI.Page
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

                #region Checking SessionID

                BOLogin ObjLogin = new BOLogin();
                ObjLogin = (BOLogin)Session["Login"];

                if (ObjLogin == null)
                {
                    Server.Transfer("/Login.aspx");
                }
                else
                {
                    string sessionid = ObjLogin.SESSIONID;
                    if (sessionid == "")
                    {
                        Server.Transfer("/Login.aspx");
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
        public static EntityLayer.ItemValues[] GetAllOptions()
        {
            return GetDropDownValues(7, 10);
        }

        /// <summary>
        /// This webmethod is for clientside paging for jquery datatable
        /// we need to pass draw , start and length parameter from page to webmethod in order to get the length of data
        /// </summary>
        /// <param name="dtParameters"></param>
        /// <returns></returns>
        [WebMethod]
        public static DataTableResponse GetAllCustomers(DataTableParameter dtParameters)
        {
            string searchValue = string.Empty;
            if (!string.IsNullOrEmpty(dtParameters.columns[0].Search.value))
            {
                foreach (var item in dtParameters.columns.ToList())
                {
                    if (!string.IsNullOrEmpty(item.Search.value))
                    {
                        searchValue = item.Search.value;
                        break;
                    }
                }

            }

            // get the requested data.
            DataTable dtCustomer = objDB.GetAllCustomers();
            DataTableResponse res = objDB.GetAllCustomersServerSide(dtParameters, searchValue);
            // The following values must be set by the data access layer so it knows how to do the paging.
            //if (!string.IsNullOrEmpty(searchValue))
            //{
            //    //res.recordsTotal = dtCustomer.Rows.Count;
            //    res.recordsTotal = res.recordsFiltered;
            //}
            //else
            //{
            //    res.recordsTotal = dtCustomer.Rows.Count;
            //}
            //res.recordsTotal = dtCustomer.Rows.Count;
            //res.recordsFiltered = dtParameters.length;

            //res.data = res.data; //the data returned by the database and put in a List<dtData>

            // Draw is what keeps the requests in sync particularly when another 
            // one is fired off will still waiting for the first response.
            res.draw = dtParameters.draw;
            return res;
        }



        [WebMethod]
        public static void UpdateCustomerDetails
        (
            string CustomerId,
            string EmailID,

            string Title,
            string FirstName,
            string LastName,

            string DOB,
            string Mobile,
            string Landline,

            string Address,
            string LatitudePickup,
            string LongitudePickup,
            string PostCode,

            string HearAboutUs,
            string HavingRegisteredCompany,
            string RegisteredCompanyName,
            string ShippingGoodsInCompanyName
        )
        {
            EntityLayer.clsCustomers2 objCust = new EntityLayer.clsCustomers2();

            objCust.CustomerId = CustomerId;
            objCust.EmailID = EmailID;

            objCust.Title = Title;
            objCust.FirstName = FirstName;
            objCust.LastName = LastName;

            objCust.DOB = Convert.ToDateTime(DOB,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objCust.Mobile = Mobile;
            objCust.Landline = Landline;

            objCust.Address = Address;
            objCust.LatitudePickup = LatitudePickup;
            objCust.LongitudePickup = LongitudePickup;
            objCust.PostCode = PostCode;
            objCust.HearAboutUs = HearAboutUs;

            objCust.HavingRegisteredCompany = Convert.ToBoolean(HavingRegisteredCompany);
            objCust.RegisteredCompanyName = RegisteredCompanyName;
            objCust.ShippingGoodsInCompanyName = Convert.ToBoolean(ShippingGoodsInCompanyName);

            objDB.UpdateCustomerDetails(objCust);
        }

        [WebMethod]
        public static void DeactivateCustomer(string CustomerId)
        {
            objDB.DeactivateCustomer(CustomerId);
        }
        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtCustomers = objDB.GetAllCustomers();
            objCM.DownloadPDF(dtCustomers, "Customer");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtCustomers = objDB.GetAllCustomers();
            objCM.DownloadExcel(dtCustomers, "Customer");
        }

        [WebMethod]
        public static string GetCustomerPostCodeFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("PostCode", "Customers", "CustomerId", CustomerId);
        }
        [WebMethod]
        public static string GetCustomerTitleFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Title", "Customers", "CustomerId", CustomerId);
        }


        [WebMethod]
        public static string GetCustomerLandlineFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("Telephone", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetCustomerHearAboutUsFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("HearAboutUs", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetHavingRegisteredCompanyFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("HavingRegisteredCompany", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetRegisteredCompanyNameFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("RegisteredCompanyName", "Customers", "CustomerId", CustomerId);
        }

        [WebMethod]
        public static string GetShippingGoodsInCompanyNameFromCustomerId(string CustomerId)
        {
            return objOP.RetrieveField2FromField1("ShippingGoodsInCompanyName", "Customers", "CustomerId", CustomerId);
        }
    }
}
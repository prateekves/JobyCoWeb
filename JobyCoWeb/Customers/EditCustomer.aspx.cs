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
    public partial class EditCustomer : System.Web.UI.Page
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
                if (Session["Login"] == null)
                {
                    Response.Redirect("/Login.aspx");
                }
                else
                {
                    Master.LoggedInUser = objOP.GetUserName(Session["Login"].ToString());
                }
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

        [WebMethod]
        public static string GetAllCustomers()
        {
            DataTable dtCustomer = objDB.GetAllCustomers();
            List<EntityLayer.clsCustomers> lstCustomer = new List<EntityLayer.clsCustomers>();

            foreach (DataRow drCustomer in dtCustomer.Rows)
            {
                EntityLayer.clsCustomers objCustomer = new EntityLayer.clsCustomers();

                objCustomer.CustomerId = drCustomer["CustomerId"].ToString();
                objCustomer.EmailID = drCustomer["EmailID"].ToString();
                objCustomer.CustomerName = drCustomer["CustomerName"].ToString();
                objCustomer.DOB = Convert.ToDateTime(drCustomer["DOB"].ToString());
                objCustomer.Address = drCustomer["Address"].ToString();
                objCustomer.Mobile = drCustomer["Mobile"].ToString();

                lstCustomer.Add(objCustomer);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstCustomer);
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
            string Address,
            string Mobile
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

            objCust.Address = Address;
            objCust.Mobile = Mobile;

            objDB.UpdateCustomerDetails(objCust);
        }
    }
}
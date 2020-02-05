using DataAccessLayer;
using EntityLayer;
using JobyCoWeb.Models;
using SecurityLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JobyCoWeb.Shipping
{
    public partial class AddContainer : System.Web.UI.Page
    {

        #region Required Global Classes
        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            //objCM.ResetMessageBar(lblErrMsg);

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

                #region Container Type

                DataTable dtContainerType = objDB.GetAllContainerType();
                //Modified to get the Id field from dropdown
                ddlContainerType.DataSource = dtContainerType;
                ddlContainerType.DataTextField = "ContainerType";
                ddlContainerType.DataValueField = "ContainerTypeId";
                ddlContainerType.DataBind();
                ddlContainerType.Items[0].Text = "Select Freight Type";
                ddlContainerType.Items[0].Value = "Select Freight Type";
                ddlContainerType.Items[0].Selected = true;



                //objCM.FillDropDown(ddlContainerType, "ContainerType", dtContainerType);


                try
                {
                    string sContainerType = Request.QueryString["ContainerType"].Trim().Replace("+", " ");
                    if (sContainerType != "")
                    {
                        ddlContainerType.SelectedItem.Text = sContainerType;
                    }
                }
                catch
                {

                }


                #endregion


                #region ddlContainerDataBind
                DataTable dtContainers = objOP.GetAllContainerNumber("ContainerDetails");
                objCM.FillDropDown(ddlContainers, "Container", dtContainers);

                //try
                //{
                //    string sContainerNo = Request.QueryString["ContainerNumber"].Trim().Replace("+", " ");
                //    if (sContainerNo != "")
                //    {
                //        ddlContainers.SelectedItem.Text = sContainerNo;
                //    }
                //}
                //catch
                //{

                //}
                #endregion
            }
        }

        
        [WebMethod]
        public static List<ListItem> GetAllContainerType()
        {
            DataTable dtContainerType = objDB.GetAllContainerType();
            List<ListItem> lstContainerType = new List<ListItem>();
            string sContainerType = string.Empty;
            string sContainerTypeId = string.Empty;

            foreach (DataRow drBookingIds in dtContainerType.Rows)
            {
                sContainerType = drBookingIds["ContainerType"].ToString();
                sContainerTypeId = drBookingIds["ContainerTypeId"].ToString();
                lstContainerType.Add(new ListItem
                {
                    Value = sContainerTypeId,
                    Text = sContainerType
                });
            }

            return lstContainerType;
        }

        [WebMethod]
        public static List<ListItem> GetAllBookingIds()
        {
            DataTable dtBookingIds = objDB.GetAllBookingIds("add");
            List<ListItem> lstBookingIds = new List<ListItem>();
            string sBookingId = string.Empty;

            foreach (DataRow drBookingIds in dtBookingIds.Rows)
            {
                sBookingId = drBookingIds["BookingId"].ToString();
                lstBookingIds.Add(new ListItem
                {
                    Value = sBookingId,
                    Text = sBookingId
                });
            }

            return lstBookingIds;
        }

        [WebMethod]
        public static string GetAllContainerInfo(string ContainerId)
        {
            List<Container> ListContainerInfo = new List<Container>();
            EntityLayer.Container objContainer = new EntityLayer.Container();
            DataTable dt = objDB.GetContainerByContainerId(ContainerId);
            foreach (DataRow dr in dt.Rows)
            {
                objContainer.ContainerId = dr["ContainerId"].ToString();
                objContainer.ContainerNumber = dr["ContainerNumber"].ToString();
                objContainer.ContainerTypeId = Convert.ToInt32(dr["ContainerTypeId"].ToString());
                objContainer.CompanyName = dr["CompanyName"].ToString();
                objContainer.ContainerAddress = dr["ContainerAddress"].ToString();
                objContainer.ContactPersonNo = dr["ContactPersonNo"].ToString();
                objContainer.FreightName = dr["FreightName"].ToString();
                ListContainerInfo.Add(objContainer);
            }

            var jsonSerialiser = new JavaScriptSerializer();
            return jsonSerialiser.Serialize(ListContainerInfo);
        }


        [WebMethod]
        public static string AddContainerDetails
            (
            string ContainerNumber,
            int ContainerTypeId,
            string CompanyName,
            string ContainerAddress,
            string ContactPersonNo,
            string FreightName,
            string OptionType
            )
        {
            EntityLayer.Container objContainer = new EntityLayer.Container();

            objContainer.ContainerNumber = ContainerNumber;
            objContainer.ContainerTypeId = ContainerTypeId;
            objContainer.CompanyName = CompanyName;
            objContainer.ContainerAddress = ContainerAddress;
            objContainer.ContactPersonNo = ContactPersonNo;
            objContainer.FreightName = FreightName;
            objContainer.OptionType = OptionType;

            return objDB.AddContainer(objContainer);
        }

    }
}
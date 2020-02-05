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

using System.Net;
using System.Net.Mail;
using System.Configuration;
using System.Security.Cryptography;
using System.Web.Services;
using System.Web.Script.Serialization;

#endregion

namespace JobyCoWeb
{
    public partial class ViewAllInteractions : System.Web.UI.Page
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
                        
                        //Retrieve User Full Name from EmailID
                        //=========================================
                        hfUserName.Value = objOP.GetUserFullNameFromEmailId(ObjLogin.EMAILID.ToString());
                        //=========================================
                    }
                }

                #endregion

                try
                {
                    string sComplaintId = Request.QueryString["ComplaintId"].Trim();
                    txtComplaintId.Text = sComplaintId;

                    hfCustomerId.Value = objOP.RetrieveField2FromField1("CustomerId", "Complaints", "ComplaintId", sComplaintId);

                    txtCustomerName.Text = objOP.GetFullNameFromCustomerId(hfCustomerId.Value.Trim());

                    txtBookingId.Text = objOP.RetrieveField2FromField1("BookingId", "Complaints", "ComplaintId", sComplaintId);

                    txtComplaintSource.Text = objOP.RetrieveField2FromField1("ComplaintSource", "Complaints", "ComplaintId", sComplaintId);

                    txtComplaintReason.Text = objOP.RetrieveField2FromField1("ComplaintReason", "Complaints", "ComplaintId", sComplaintId);

                    txtComplaintPriority.Text = objOP.RetrieveField2FromField1("ComplaintPriority", "Complaints", "ComplaintId", sComplaintId);

                    txtLodgingDate.Text = objOP.RetrieveField2FromField1("LodgingDate", "Complaints", "ComplaintId", sComplaintId);

                    ddlComplaintStatus.SelectedItem.Text = objOP.RetrieveField2FromField1("ComplaintStatus", "Complaints", "ComplaintId", sComplaintId);
                }
                catch { }
            }
        }

        [WebMethod]
        public static string GetAllInteractions(string ComplaintId)
        {
            DataTable dtInteractions = objDB.GetAllInteractions(ComplaintId);
            List<EntityLayer.CustomerInteraction> lstInteractions = new List<EntityLayer.CustomerInteraction>();

            foreach (DataRow drInteractions in dtInteractions.Rows)
            {
                EntityLayer.CustomerInteraction objInteractions = new EntityLayer.CustomerInteraction();

                objInteractions.InteractionDate = Convert.ToDateTime(drInteractions["InteractionDate"].ToString());

                objInteractions.Comments = drInteractions["Comments"].ToString();
                objInteractions.PostedBy = drInteractions["PostedBy"].ToString();

                objInteractions.ComplaintStatus = drInteractions["ComplaintStatus"].ToString();

                lstInteractions.Add(objInteractions);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstInteractions);
        }

        [WebMethod]
        public static void AddInteractionDetails
           (
           string ComplaintId,
           string InteractionDate,
           string Comments,
           string PostedBy,
           string ComplaintStatus
           )
        {
            EntityLayer.CustomerInteraction objCustomerInteraction = new EntityLayer.CustomerInteraction();

            objCustomerInteraction.ComplaintId = ComplaintId;

            InteractionDate = DateTime.Now.ToString("dd/MM/yyyy");
            objCustomerInteraction.InteractionDate = Convert.ToDateTime(InteractionDate,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objCustomerInteraction.Comments = Comments;
            objCustomerInteraction.PostedBy = PostedBy;
            objCustomerInteraction.ComplaintStatus = ComplaintStatus;

            objDB.AddInteractionDetails(objCustomerInteraction);
        }

    }
}
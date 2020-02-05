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

namespace JobyCoWeb.CustomerCare
{
    public partial class ViewAllEscalationLevels : System.Web.UI.Page
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
                    }
                }

                #endregion

            }
        }

        [WebMethod]
        public static string GetAllComplaints()
        {
            DataTable dtComplaints = objDB.GetAllComplaints();
            List<EntityLayer.Complaint> lstComplaints = new List<EntityLayer.Complaint>();

            foreach (DataRow drComplaints in dtComplaints.Rows)
            {
                EntityLayer.Complaint objComplaints = new EntityLayer.Complaint();

                objComplaints.ComplaintId = drComplaints["ComplaintId"].ToString();
                objComplaints.CustomerName = drComplaints["CustomerName"].ToString();
                //objComplaints.BookingId = drComplaints["BookingId"].ToString();

                //objComplaints.ComplaintSource = drComplaints["ComplaintSource"].ToString();
                //objComplaints.ComplaintReason = drComplaints["ComplaintReason"].ToString();

                //objComplaints.ComplaintPriority = drComplaints["ComplaintPriority"].ToString();
                objComplaints.ComplaintStatus = drComplaints["ComplaintStatus"].ToString();

                objComplaints.LodgingDate = Convert.ToDateTime(drComplaints["LodgingDate"].ToString());

                objComplaints.ResolvedDate = Convert.ToDateTime(drComplaints["ResolvedDate"].ToString());

                lstComplaints.Add(objComplaints);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstComplaints);
        }

        [WebMethod]
        public static string GetComplaintBookingId(string ComplaintId)
        {
            return objOP.RetrieveField2FromField1("BookingId", "Complaints", "ComplaintId", ComplaintId);
        }

        [WebMethod]
        public static string GetComplaintSource(string ComplaintId)
        {
            return objOP.RetrieveField2FromField1("ComplaintSource", "Complaints", "ComplaintId", ComplaintId);
        }

        [WebMethod]
        public static string GetComplaintReason(string ComplaintId)
        {
            return objOP.RetrieveField2FromField1("ComplaintReason", "Complaints", "ComplaintId", ComplaintId);
        }

        [WebMethod]
        public static string GetComplaintPriority(string ComplaintId)
        {
            return objOP.RetrieveField2FromField1("ComplaintPriority", "Complaints", "ComplaintId", ComplaintId);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtComplaints = objDB.GetAllComplaints();
            objCM.DownloadPDF(dtComplaints, "Complaint");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtComplaints = objDB.GetAllComplaints();
            objCM.DownloadExcel(dtComplaints, "Complaint");
        }

        [WebMethod]
        public static void RemoveComplaintDetails(string ComplaintId)
        {
            objDB.RemoveComplaintDetails(ComplaintId);
        }

        [WebMethod]
        public static void ChangeComplaintStatus(string ComplaintId, string ComplaintStatus)
        {
            objDB.ChangeComplaintStatus(ComplaintId, ComplaintStatus);
        }
    }
}
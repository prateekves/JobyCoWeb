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

namespace JobyCoWeb.Drivers
{
    public partial class ViewAllDrivers : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion
        BOLogin ObjLogin = new BOLogin();
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
        public static string GetAllDrivers()
        {
            BOLogin ObjLogin = new BOLogin();
            ObjLogin = (BOLogin)HttpContext.Current.Session["Login"];

            DataTable dtDriver = objDB.GetAllDrivers("");
            List<EntityLayer.clsDriver> lstDriver = new List<EntityLayer.clsDriver>();

            foreach (DataRow drDriver in dtDriver.Rows)
            {
                EntityLayer.clsDriver objDriver = new EntityLayer.clsDriver();

                objDriver.DriverId = drDriver["DriverId"].ToString();
                objDriver.Name = drDriver["Name"].ToString();
                objDriver.Phone = drDriver["Phone"].ToString();
                objDriver.Email = drDriver["Email"].ToString();
                objDriver.WarehouseName = drDriver["WarehouseName"].ToString();
                objDriver.Status = drDriver["Status"].ToString();
                
                
                lstDriver.Add(objDriver);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstDriver);
        }

        [WebMethod]
        public static string GetDriverDetailsForPrint(string DriverId)
        {
            DataTable dtPrintDriverJob = objDB.GetDriverDetailsForPrint(DriverId);

            List<EntityLayer.PrintDriverJob> lstPrintDriverJob = new List<EntityLayer.PrintDriverJob>();
            int iCount = dtPrintDriverJob.Rows.Count;
            foreach (DataRow drPrintDriverJob in dtPrintDriverJob.Rows)
            {
                EntityLayer.PrintDriverJob objPrintDriverJob = new EntityLayer.PrintDriverJob();

                objPrintDriverJob.BookingId = drPrintDriverJob["BookingId"].ToString();
                objPrintDriverJob.PickupDate = drPrintDriverJob["PickupDate"].ToString();
                objPrintDriverJob.PickupName = drPrintDriverJob["PickupName"].ToString();
                objPrintDriverJob.PickupPhone = drPrintDriverJob["PickupPhone"].ToString();
                objPrintDriverJob.PickupAddress = drPrintDriverJob["PickupAddress"].ToString();
                objPrintDriverJob.PickupZip = drPrintDriverJob["PickupZip"].ToString();
                objPrintDriverJob.PickupItem = drPrintDriverJob["PickupItem"].ToString();
                objPrintDriverJob.ItemCount = iCount;

                objPrintDriverJob.DeliveryName = drPrintDriverJob["DeliveryName"].ToString();
                objPrintDriverJob.DeliveryPhone = drPrintDriverJob["DeliveryPhone"].ToString();
                objPrintDriverJob.DeliveryAddress = drPrintDriverJob["DeliveryAddress"].ToString();
                objPrintDriverJob.DeliveryZip = drPrintDriverJob["DeliveryZip"].ToString();
                objPrintDriverJob.Wage = drPrintDriverJob["Wage"].ToString();

                lstPrintDriverJob.Add(objPrintDriverJob);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstPrintDriverJob);
        }


        
        //[WebMethod]
        //public static string GetPickupItems(string BookingId)
        //{
        //    DataTable dtPrintDriverJob = objDB.GetDriverDetailsForPrint(BookingId);

        //    List<EntityLayer.PrintDriverJob> lstPrintDriverJob = new List<EntityLayer.PrintDriverJob>();
        //    int iCount = dtPrintDriverJob.Rows.Count;
        //    foreach (DataRow drPrintDriverJob in dtPrintDriverJob.Rows)
        //    {
        //        EntityLayer.PrintDriverJob objPrintDriverJob = new EntityLayer.PrintDriverJob();

        //        objPrintDriverJob.BookingId = drPrintDriverJob["BookingId"].ToString();
        //        objPrintDriverJob.PickupDate = drPrintDriverJob["PickupDate"].ToString();
        //        objPrintDriverJob.PickupName = drPrintDriverJob["PickupName"].ToString();
        //        objPrintDriverJob.PickupPhone = drPrintDriverJob["PickupPhone"].ToString();
        //        objPrintDriverJob.PickupAddress = drPrintDriverJob["PickupAddress"].ToString();
        //        objPrintDriverJob.PickupZip = drPrintDriverJob["PickupZip"].ToString();
        //        objPrintDriverJob.PickupItem = drPrintDriverJob["PickupItem"].ToString();
        //        objPrintDriverJob.ItemCount = iCount;

        //        objPrintDriverJob.DeliveryName = drPrintDriverJob["DeliveryName"].ToString();
        //        objPrintDriverJob.DeliveryPhone = drPrintDriverJob["DeliveryPhone"].ToString();
        //        objPrintDriverJob.DeliveryAddress = drPrintDriverJob["DeliveryAddress"].ToString();
        //        objPrintDriverJob.DeliveryZip = drPrintDriverJob["DeliveryZip"].ToString();
        //        objPrintDriverJob.Wage = drPrintDriverJob["Wage"].ToString();

        //        lstPrintDriverJob.Add(objPrintDriverJob);
        //    }

        //    var js = new JavaScriptSerializer();
        //    return js.Serialize(lstPrintDriverJob);
        //}

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            DataTable dtDrivers = objDB.GetAllDrivers("");
            objCM.DownloadPDF(dtDrivers, "Driver");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            DataTable dtDrivers = objDB.GetAllDrivers("");
            objCM.DownloadExcel(dtDrivers, "Driver");
        }

        [WebMethod]
        public static void DeactivateDriver(string DriverId)
        {
            objDB.DeactivateDriver(DriverId);
        }

        [WebMethod]
        public static string GetDriverDOB(string DriverId)
        {
            return objOP.RetrieveField2FromField1("DOB", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetDriverAddress(string DriverId)
        {
            return objOP.RetrieveField2FromField1("Address", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetDriverPostCode(string DriverId)
        {
            return objOP.RetrieveField2FromField1("PostCode", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetDriverLandline(string DriverId)
        {
            return objOP.RetrieveField2FromField1("Landline", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetDriverPayrollType(string DriverId)
        {
            return objOP.RetrieveField2FromField1("DriverType", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static string GetDriverWageType(string DriverId)
        {
            return objOP.RetrieveField2FromField1("WageType", "Drivers", "DriverId", DriverId);
        }

        [WebMethod]
        public static void ChangeDriverStatus(string DriverId, string Enabled)
        {
            EntityLayer.Driver objD = new EntityLayer.Driver();

            objD.DriverId = DriverId;
            objD.Enabled = Convert.ToBoolean(Enabled);

            objDB.ChangeDriverStatus(objD);
        }

        [WebMethod]
        public static void UpdateDriverDetails
        (
            string DriverId,

            string Title,
            string FirstName,
            string LastName,

            string EmailID,
            string DOB,
            string Address,
            string PostCode,

            string Mobile,
            string Landline,

            string DriverType,
            string WageType,
            string Status
       )
        {
            EntityLayer.clsDriver2 objDriver = new EntityLayer.clsDriver2();

            objDriver.DriverId = DriverId;

            objDriver.Title = Title;
            objDriver.FirstName = FirstName;
            objDriver.LastName = LastName;

            objDriver.EmailID = EmailID;
            objDriver.DOB = Convert.ToDateTime(DOB,
            System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);

            objDriver.Address = Address;
            objDriver.PostCode = PostCode;

            objDriver.Mobile = Mobile;
            objDriver.Landline = Landline;

            objDriver.DriverType = DriverType;
            objDriver.WageType = WageType;

            objDriver.Status = Convert.ToBoolean(Status);

            objDB.UpdateDriverDetails(objDriver);
        }
    }
}
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
using System.Globalization;

#endregion

namespace JobyCoWeb
{
    public partial class ViewMyBookings : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        string sBookingId = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    sBookingId = Request.QueryString["BookingId"].Trim();

                    gvMyBookings.DataSource = objDB.GetMyBookings(sBookingId);
                    gvMyBookings.DataBind();
                }
                catch { }
            }
        }

        [WebMethod]
        public static string GetMyBookings(string BookingId)
        {
            DataTable dtBooking = objDB.GetMyBookings(BookingId);
            List<EntityLayer.AllBookings> lstBooking = new List<EntityLayer.AllBookings>();

            foreach (DataRow drBooking in dtBooking.Rows)
            {
                EntityLayer.AllBookings objBooking = new EntityLayer.AllBookings();

                objBooking.BookingId = drBooking["BookingId"].ToString();
                objBooking.CustomerName = drBooking["CustomerName"].ToString();
                objBooking.OrderDate = Convert.ToDateTime(drBooking["OrderDate"].ToString());
                objBooking.PickupDate = Convert.ToDateTime(drBooking["PickupDate"].ToString());
                objBooking.InsurancePremium = Convert.ToDecimal(drBooking["InsurancePremium"].ToString());
                objBooking.TotalValue = Convert.ToDecimal(drBooking["TotalValue"].ToString());
                objBooking.OrderStatus = drBooking["OrderStatus"].ToString();

                lstBooking.Add(objBooking);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstBooking);
        }

        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            //Get the data from database into datatable
            sBookingId = Request.QueryString["BookingId"].Trim();
            DataTable dtBookings = objDB.GetMyBookings(sBookingId);
            objCM.DownloadPDF(dtBookings, "Booking");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            //Get the data from database into datatable
            sBookingId = Request.QueryString["BookingId"].Trim();
            DataTable dtBookings = objDB.GetMyBookings(sBookingId);
            objCM.DownloadExcel(dtBookings, "Booking");
        }
        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            //Reference the GridView Row.
            GridViewRow row = gvMyBookings.Rows[0];

            //Fetch values from GridView
            string sBookingId = row.Cells[1].Text;

            Response.Redirect("/ProceedToPayment.aspx?BookingId=" + sBookingId);
        }

        protected void gvMyBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                //Determine the RowIndex of the Row whose Button was clicked.
                int rowIndex = Convert.ToInt32(e.CommandArgument);

                //Reference the GridView Row.
                GridViewRow row = gvMyBookings.Rows[rowIndex];

                //Fetch values from GridView
                string sBookingId = row.Cells[1].Text;

                spHeaderBookingId.InnerText = "#" + sBookingId;
                spBodyBookingId.InnerText = "#" + sBookingId;

                dvMyBookings.DataSource = objDB.ViewBookingDetails(sBookingId);
                dvMyBookings.DataBind();

                //Filling Customer Details
                #region CustomerDetails

                lblCustomerId.Text = objOP.RetrieveField2FromField1("CustomerId",
                    "OrderBooking", "BookingId", sBookingId);

                string sCustomerId = lblCustomerId.Text.Trim();

                lblCustomerName.Text = objOP.GetFullNameFromCustomerId(sCustomerId);

                lblCustomerMobile.Text = objOP.RetrieveField2FromField1("Mobile",
                    "Customers", "CustomerId", sCustomerId);

                #endregion

                //Filling Pickup Details
                #region PickupDetails

                lblPickupName.Text = objOP.RetrieveField2FromField1("PickupName",
                    "OrderBooking", "BookingId", sBookingId);

                lblPickupAddress.Text = objOP.RetrieveField2FromField1("PickupAddress",
                    "OrderBooking", "BookingId", sBookingId);

                lblPickupMobile.Text = objOP.RetrieveField2FromField1("PickupMobile",
                    "OrderBooking", "BookingId", sBookingId);

                #endregion

                //Filling Delivery Details
                #region DeliveryDetails

                lblDeliveryName.Text = objOP.RetrieveField2FromField1("DeliveryName",
                    "OrderBooking", "BookingId", sBookingId);

                lblDeliveryAddress.Text = objOP.RetrieveField2FromField1("RecipentAddress",
                    "OrderBooking", "BookingId", sBookingId);

                lblDeliveryMobile.Text = objOP.RetrieveField2FromField1("DeliveryMobile",
                    "OrderBooking", "BookingId", sBookingId);

                #endregion

                //Filling Other Details
                #region OtherDetails

                #region CollectionDate

                string sCollectionDate = objOP.RetrieveField2FromField1("PickupDateTime",
                    "OrderBooking", "BookingId", sBookingId);

                //DateTime dtCollection = DateTime.Parse(sCollectionDate, new CultureInfo("en-US"));
                DateTime dtCollection = Convert.ToDateTime(sCollectionDate);
                CultureInfo ci = CultureInfo.InvariantCulture;
                lblPickupDateTime.Text = dtCollection.ToString("dddd")
                    + ", " + dtCollection.ToLongDateString()
                    + ", " + dtCollection.ToString("hh:mm", ci);

                #endregion

                lblVAT.Text = objOP.RetrieveField2FromField1("VAT", "OrderBooking",
                    "BookingId", sBookingId);

                lblOrderTotal.Text = objOP.RetrieveField2FromField1("TotalValue", "OrderBooking",
                    "BookingId", sBookingId);

                #endregion

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "showPopup();", true);
                //dvBooking.Visible = true;
            }
        }
    }
}
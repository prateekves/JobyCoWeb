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
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Globalization;

#endregion

namespace JobyCoWebCustomize
{
    public partial class ViewMyQuotations : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        string sQuoteId = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    sQuoteId = Request.QueryString["QuoteId"].Trim();

                    gvMyQuotations.DataSource = objDB.GetMyQuotations(sQuoteId);
                    gvMyQuotations.DataBind();
                }
                catch { }
            }
        }
        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            //Get the data from database into datatable
            sQuoteId = Request.QueryString["QuoteId"].Trim();
            DataTable dtQuotations = objDB.GetMyQuotations(sQuoteId);
            objCM.DownloadPDF(dtQuotations, "Quotations");
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            //Get the data from database into datatable
            sQuoteId = Request.QueryString["QuoteId"].Trim();
            DataTable dtQuotations = objDB.GetMyQuotations(sQuoteId);
            objCM.DownloadExcel(dtQuotations, "Quotations");
        }
        protected void gvMyQuotations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                //Determine the RowIndex of the Row whose Button was clicked.
                int rowIndex = Convert.ToInt32(e.CommandArgument);

                //Reference the GridView Row.
                GridViewRow row = gvMyQuotations.Rows[rowIndex];

                //Fetch values from GridView
                string sQuotingId = row.Cells[1].Text;

                spHeaderQuotingId.InnerText = "#" + sQuotingId;
                spBodyQuotingId.InnerText = "#" + sQuotingId;

                dvMyQuotations.DataSource = objDB.ViewQuotingDetails(sQuotingId);
                dvMyQuotations.DataBind();

                //Filling Customer Details
                #region CustomerDetails

                lblCustomerId.Text = objOP.RetrieveField2FromField1("CustomerId",
                    "OrderQuoting", "QuotingId", sQuotingId);

                string sCustomerId = lblCustomerId.Text.Trim();

                lblCustomerName.Text = objOP.GetFullNameFromCustomerId(sCustomerId);

                lblCustomerMobile.Text = objOP.RetrieveField2FromField1("Mobile",
                    "Customers", "CustomerId", sCustomerId);

                #endregion

                //Filling Pickup Details
                #region PickupDetails

                lblPickupName.Text = objOP.RetrieveField2FromField1("PickupName",
                    "OrderQuoting", "QuotingId", sQuotingId);

                lblPickupAddress.Text = objOP.RetrieveField2FromField1("PickupAddress",
                    "OrderQuoting", "QuotingId", sQuotingId);

                lblPickupMobile.Text = objOP.RetrieveField2FromField1("PickupMobile",
                    "OrderQuoting", "QuotingId", sQuotingId);

                #endregion

                //Filling Delivery Details
                #region DeliveryDetails

                lblDeliveryName.Text = objOP.RetrieveField2FromField1("DeliveryName",
                    "OrderQuoting", "QuotingId", sQuotingId);

                lblDeliveryAddress.Text = objOP.RetrieveField2FromField1("RecipentAddress",
                    "OrderQuoting", "QuotingId", sQuotingId);

                lblDeliveryMobile.Text = objOP.RetrieveField2FromField1("DeliveryMobile",
                    "OrderQuoting", "QuotingId", sQuotingId);

                #endregion

                //Filling Other Details
                #region OtherDetails

                #region CollectionDate

                string sCollectionDate = objOP.RetrieveField2FromField1("PickupDateTime",
                    "OrderQuoting", "QuotingId", sQuotingId);

                //DateTime dtCollection = DateTime.Parse(sCollectionDate, new CultureInfo("en-US"));
                DateTime dtCollection = Convert.ToDateTime(sCollectionDate);
                CultureInfo ci = CultureInfo.InvariantCulture;
                lblPickupDateTime.Text = dtCollection.ToString("dddd")
                    + ", " + dtCollection.ToLongDateString()
                    + ", " + dtCollection.ToString("hh:mm", ci);

                #endregion

                lblVAT.Text = objOP.RetrieveField2FromField1("VAT", "OrderQuoting",
                    "QuotingId", sQuotingId);

                lblOrderTotal.Text = objOP.RetrieveField2FromField1("TotalValue", "OrderQuoting",
                    "QuotingId", sQuotingId);

                #endregion

                ClientScript.RegisterStartupScript(this.GetType(), "alert", "showPopup();", true);
                //dvQuotation.Visible = true;
            }
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            //Reference the GridView Row.
            GridViewRow row = gvMyQuotations.Rows[0];

            //Fetch values from GridView
            string sQuotingId = row.Cells[1].Text;

            Response.Redirect("/ProceedToPaymentForQuotation.aspx?QuoteId=" + sQuotingId);
        }
    }
}
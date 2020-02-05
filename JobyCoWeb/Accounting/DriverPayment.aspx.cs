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

namespace JobyCoWeb.Accounting
{
    public partial class DriverPayment : System.Web.UI.Page
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

        [WebMethod]
        public static string GetAllDriverPayments()
        {
            DataTable dtDriverPayment = objDB.GetAllDriverPayments();
            List<EntityLayer.DriverPayment> lstDriverPayment = new List<EntityLayer.DriverPayment>();

            foreach (DataRow drDriverPayment in dtDriverPayment.Rows)
            {
                EntityLayer.DriverPayment objDriverPayment = new EntityLayer.DriverPayment();

                objDriverPayment.PaymentId = drDriverPayment["PaymentId"].ToString();
                objDriverPayment.DriverName = drDriverPayment["DriverName"].ToString();

                objDriverPayment.DriverType = drDriverPayment["DriverType"].ToString();
                objDriverPayment.WageType = drDriverPayment["WageType"].ToString();

                objDriverPayment.ExpectedAmount = Convert.ToDecimal(drDriverPayment["ExpectedAmount"].ToString());
                objDriverPayment.AmountReceived = Convert.ToDecimal(drDriverPayment["AmountReceived"].ToString());
                objDriverPayment.Discrepancy = Convert.ToDecimal(drDriverPayment["Discrepancy"].ToString());

                lstDriverPayment.Add(objDriverPayment);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstDriverPayment);
        }

        [WebMethod]
        public static string GetCreditDebitNote(string PaymentId)
        {
            return objOP.RetrieveField2FromField1("CreditDebitNote", "DriverPayment", "PaymentId", PaymentId);
        }

        [WebMethod]
        public static string GetAmountReceived(string PaymentId)
        {
            return objOP.RetrieveField2FromField1("AmountReceived", "DriverPayment", "PaymentId", PaymentId);
        }

        [WebMethod]
        public static void UpdateDriverPaymentDetails
        (
            string PaymentId,
            string AmountReceived,
            string CreditDebitNote
        )
        {
            EntityLayer.DriverPayment2 objDriver = new EntityLayer.DriverPayment2();

            objDriver.PaymentId = PaymentId;
            objDriver.AmountReceived = Convert.ToDecimal(AmountReceived);
            objDriver.CreditDebitNote = CreditDebitNote;

            objDB.UpdateDriverPaymentDetails(objDriver);
        }

        [WebMethod]
        public static void RevertDriverPaymentDetails
        (
            string PaymentId,
            string AmountReceived,
            string CreditDebitNote
        )
        {
            EntityLayer.DriverPayment2 objDriver = new EntityLayer.DriverPayment2();

            objDriver.PaymentId = PaymentId;
            objDriver.AmountReceived = Convert.ToDecimal(AmountReceived);
            objDriver.CreditDebitNote = CreditDebitNote;

            objDB.RevertDriverPaymentDetails(objDriver);
        }

        [WebMethod]
        public static string GetSpecificDriverPayments(string FromDate, string ToDate)
        {
            DataTable dtDriverPayment = objDB.GetSpecificDriverPayments(
                Convert.ToDateTime(FromDate), Convert.ToDateTime(ToDate));

            List<EntityLayer.DriverPayment> lstDriverPayment = new List<EntityLayer.DriverPayment>();

            foreach (DataRow drDriverPayment in dtDriverPayment.Rows)
            {
                EntityLayer.DriverPayment objDriverPayment = new EntityLayer.DriverPayment();

                objDriverPayment.PaymentId = drDriverPayment["PaymentId"].ToString();
                objDriverPayment.DriverName = drDriverPayment["DriverName"].ToString();

                objDriverPayment.DriverType = drDriverPayment["DriverType"].ToString();
                objDriverPayment.WageType = drDriverPayment["WageType"].ToString();

                objDriverPayment.ExpectedAmount = Convert.ToDecimal(drDriverPayment["ExpectedAmount"].ToString());
                objDriverPayment.AmountReceived = Convert.ToDecimal(drDriverPayment["AmountReceived"].ToString());
                objDriverPayment.Discrepancy = Convert.ToDecimal(drDriverPayment["Discrepancy"].ToString());

                lstDriverPayment.Add(objDriverPayment);
            }

            var js = new JavaScriptSerializer();
            return js.Serialize(lstDriverPayment);
        }
        protected void btnExportPdf_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = objDB.GetAllDriverPayments();

                //Create a dummy GridView
                GridView GridView1 = new GridView();
                GridView1.AllowPaging = false;
                GridView1.DataSource = dt;
                GridView1.DataBind();

                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment;filename=DriverPaymentList.pdf");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                GridView1.RenderControl(hw);
                StringReader sr = new StringReader(sw.ToString());
                Document pdfDoc = new Document(PageSize.A2, 10f, 10f, 10f, 0f);
                HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
                pdfDoc.Open();
                htmlparser.Parse(sr);
                pdfDoc.Close();
                Response.Write(pdfDoc);
                Response.End();
            }
            catch
            {
            }
        }
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = objDB.GetAllDriverPayments();

                //Create a dummy GridView
                GridView GridView1 = new GridView();
                GridView1.AllowPaging = false;
                GridView1.DataSource = dt;
                GridView1.DataBind();

                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition",
                 "attachment;filename=DriverPaymentList.xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                for (int i = 0; i < GridView1.Rows.Count; i++)
                {
                    //Apply text style to each Row
                    GridView1.Rows[i].Attributes.Add("class", "textmode");
                }
                GridView1.RenderControl(hw);

                //style to format numbers to string
                string style = @"<style> .textmode { mso-number-format:\@; } </style>";
                Response.Write(style);
                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
            catch
            {
            }
        }
    }
}
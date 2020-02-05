using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

using DataAccessLayer;
using System.Configuration;

#region Required NameSpaces for Download

using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;

#endregion

namespace JobyCoWeb.Models
{
    public class ControlModels
    {
        //Declaring Required SqlClient Objects
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;

        DataSet ds;
        DataTable dt;

        //Declaring Required Variables
        string sConnectionString = string.Empty;
        bool bFailure = false;

        public ControlModels()
        {
            //Initializing Connection
            sConnectionString = ConfigurationManager.ConnectionStrings["dbJobyCoConnection"].ConnectionString;
            con = new SqlConnection(sConnectionString);
        }

        public DataTable Retrieve_Data(string sQuery, string sTableName)
        {
            DataSet dsRetrieve = new DataSet();
            DataTable dtRetrieve = new DataTable();

            SqlConnection conRetrieve = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRetrieve = new SqlCommand(sQuery, conRetrieve);
                SqlDataAdapter daRetrieve = new SqlDataAdapter(cmdRetrieve);

                daRetrieve.Fill(dsRetrieve, sTableName);
                dtRetrieve = dsRetrieve.Tables[sTableName];
                conRetrieve.Close();
            }
            catch
            {
                conRetrieve.Close();
            }
            finally
            {
                conRetrieve.Close();
            }

            return dtRetrieve;
        }

        public void FillCheckBoxList(CheckBoxList cbl, string sOmit, string sField, string sTable)
        {
            string sValue = string.Empty;
            cbl.Items.Clear();

            string sFieldQuery = "select " + sField + " from " + sTable;

            DataTable dtField = Retrieve_Data(sFieldQuery, sTable);

            if (dtField != null)
            {
                if (dtField.Rows.Count > 0)
                {
                    for (int i = 0; i < dtField.Rows.Count; i++)
                    {
                        sValue = dtField.Rows[i][0].ToString();

                        if(sValue != sOmit)
                        {
                            cbl.Items.Add(sValue);
                        }
                    }
                }
            }
        }

        public void FillDropDown(DropDownList ddl, string sField, string sTable)
        {
            string sValue = string.Empty;
            ddl.Items.Clear();
            ddl.Items.Add("Select " + sField);

            string sFieldQuery = "select " + sField + " from " + sTable;

            DataTable dtField = Retrieve_Data(sFieldQuery, sTable);

            if (dtField != null)
            {
                if (dtField.Rows.Count > 0)
                {
                    for (int i = 0; i < dtField.Rows.Count; i++)
                    {
                        sValue = dtField.Rows[i][0].ToString();
                        ddl.Items.Add(sValue);
                    }
                }
            }
        }

        public void FillDropDown(DropDownList ddl, string sCaption, string sField, string sTable)
        {
            string sValue = string.Empty;
            ddl.Items.Clear();
            ddl.Items.Add("Select " + sCaption);

            string sFieldQuery = "select " + sField + " from " + sTable;

            DataTable dtField = Retrieve_Data(sFieldQuery, sTable);

            if (dtField != null)
            {
                if (dtField.Rows.Count > 0)
                {
                    for (int i = 0; i < dtField.Rows.Count; i++)
                    {
                        sValue = dtField.Rows[i][0].ToString();
                        ddl.Items.Add(sValue);
                    }
                }
            }
        }

        public void FillDropDown(DropDownList ddl, string sField1, string sTable, string sField2, string sField2Value)
        {
            string sValue = string.Empty;

            ddl.Items.Clear();
            ddl.Items.Add("Select " + sField1);

            string sFieldQuery = "select " + sField1 + " from " + sTable;
            sFieldQuery += " where " + sField2 + " = '" + sField2Value + "'";

            DataTable dtField = Retrieve_Data(sFieldQuery, sTable);

            if (dtField != null)
            {
                if (dtField.Rows.Count > 0)
                {
                    for (int i = 0; i < dtField.Rows.Count; i++)
                    {
                        sValue = dtField.Rows[i][0].ToString();
                        ddl.Items.Add(sValue);
                    }
                }
            }
        }

        public void FillDropDown(DropDownList ddl, int iValueStart, int iValueEnd)
        {
            string sValue = string.Empty;
            ddl.Items.Clear();

            for (int i = iValueStart; i <= iValueEnd; i++)
            {
                if (i < 10)
                    sValue = "0" + i.ToString();
                else
                    sValue = i.ToString();

                ddl.Items.Add(sValue);
            }
        }

        public void FillDropDown(DropDownList ddl, string sFieldName, DataTable dtRecords)
        {
            string sValue = string.Empty;
            ddl.Items.Clear();
            ddl.Items.Add("Select " + sFieldName);

            if (dtRecords != null)
            {
                if (dtRecords.Rows.Count > 0)
                {
                    for (int i = 0; i < dtRecords.Rows.Count; i++)
                    {
                        sValue = dtRecords.Rows[i][0].ToString();
                        ddl.Items.Add(sValue);
                    }
                }
            }
        }

        public void FillDropDownByFields(DropDownList ddl, string sFieldName, DataTable dtRecords)
        {
            string sValue = string.Empty;
            ddl.Items.Clear();
            ddl.Items.Add("Select " + sFieldName);

            if (dtRecords != null)
            {
                if (dtRecords.Rows.Count > 0)
                {
                    for (int i = 0; i < dtRecords.Rows.Count; i++)
                    {
                        sValue = dtRecords.Rows[i][sFieldName].ToString();
                        ddl.Items.Add(sValue);
                    }
                }
            }
        }

        public void FillDropDownDistinct(DropDownList ddl, string sCaption, string sField, string sTable)
        {
            string sValue = string.Empty;
            ddl.Items.Clear();
            ddl.Items.Add("Select " + sCaption);

            string sFieldQuery = "select distinct " + sField + " from " + sTable;

            DataTable dtField = Retrieve_Data(sFieldQuery, sTable);

            if (dtField != null)
            {
                if (dtField.Rows.Count > 0)
                {
                    for (int i = 0; i < dtField.Rows.Count; i++)
                    {
                        sValue = dtField.Rows[i][0].ToString();
                        ddl.Items.Add(sValue);
                    }
                }
            }
        }

        public void PopulateAccessibleMenuItemsOnHiddenField(HiddenField hfMenusAccessible)
        {
            if (HttpContext.Current.Session["UserId"] != null)
            {
                string sUserId = HttpContext.Current.Session["UserId"].ToString();

                if (HttpContext.Current.Session["RoleId"] != null)
                {
                    string sRoleId = HttpContext.Current.Session["RoleId"].ToString();

                    clsDB objDB = new clsDB();
                    DataTable dtSpecificUserAccess = objDB.GetSpecificUserMenuItemsAccess(sUserId, sRoleId);

                    foreach (DataRow row in dtSpecificUserAccess.Rows)
                    {
                        //foreach (DataColumn column in dtSpecificUserAccess.Columns)
                        //{
                            if (row["Menu_Name"] != null)
                            {
                                hfMenusAccessible.Value += row["Menu_Name"].ToString().Replace(" ", string.Empty) + ",";
                            }
                        //}
                    }
                }
            }
        }

        public string GetCurrentPageName()
        {
            string sPath = HttpContext.Current.Request.Url.AbsolutePath;
            FileInfo oInfo = new FileInfo(sPath);
            return oInfo.Name;
        }

        public void PopulatePageControlsOnHiddenField(HiddenField hfControlsAccessible, int iMenuId)
        {
            if (HttpContext.Current.Session["UserId"] != null)
            {
                string sUserId = HttpContext.Current.Session["UserId"].ToString();

                if (HttpContext.Current.Session["RoleId"] != null)
                {
                    string sRoleId = HttpContext.Current.Session["RoleId"].ToString();
                     
                    clsDB objDB = new clsDB();
                    DataTable dtSpecificUserAccess = objDB.GetSpecificUserPageControlsAccess(sUserId, sRoleId, iMenuId);

                    for (int i = 0; i < dtSpecificUserAccess.Rows.Count; i++)
                    {
                        for(int j = 0; j < dtSpecificUserAccess.Columns.Count; j++)
                        {
                            if (dtSpecificUserAccess.Rows[i][j] != null)
                            {
                                if (dtSpecificUserAccess.Rows[i][j].ToString().Equals("False"))
                                {
                                    if(!dtSpecificUserAccess.Rows[i][j + 1].ToString().Equals("0"))
                                    {
                                        hfControlsAccessible.Value += dtSpecificUserAccess.Rows[i][j + 1].ToString().Replace(" ", string.Empty) + ",";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public void ResetMessageBar(Label lblErrMsg)
        {
            lblErrMsg.Text = "";
            lblErrMsg.Attributes.CssStyle.Add("display", "none");
            lblErrMsg.Attributes.CssStyle.Add("background-color", "#ffd3d9");
            lblErrMsg.Attributes.CssStyle.Add("color", "red");
            lblErrMsg.Attributes.CssStyle.Add("text-align", "center");
        }

        public void ShowSuccessMessage(Label lblErrMsg, string sSuccessMessage)
        {
            lblErrMsg.Text = sSuccessMessage;
            lblErrMsg.Attributes.CssStyle.Add("display", "table");
            lblErrMsg.Attributes.CssStyle.Add("background-color", "#ffd3d9");
            lblErrMsg.Attributes.CssStyle.Add("padding", "10px");
            lblErrMsg.Attributes.CssStyle.Add("color", "green");
            lblErrMsg.Attributes.CssStyle.Add("text-align", "center");
        }

        public void ShowErrorMessage(Label lblErrMsg, string sErrorMessage)
        {
            lblErrMsg.Text = sErrorMessage;
            lblErrMsg.Attributes.CssStyle.Add("display", "table");
            lblErrMsg.Attributes.CssStyle.Add("background-color", "#ffd3d9");
            lblErrMsg.Attributes.CssStyle.Add("padding", "10px");
            lblErrMsg.Attributes.CssStyle.Add("color", "red");
            lblErrMsg.Attributes.CssStyle.Add("text-align", "center");
        }

        public void AutoRedirect(Label lblErrMsg)
        {
            lblErrMsg.Text = "You are not Logged In. Login first, then retry.";
            lblErrMsg.Attributes.CssStyle.Add("display", "block");

            HttpContext.Current.Response.AddHeader("Refresh", "5;url=SignIn.aspx");
        }

        public void ClearLocalSession(string sSessionName)
        {
            try
            {
                HttpContext.Current.Session[sSessionName] = null;
                HttpContext.Current.Session.Remove(sSessionName);

                string sCookieName = HttpContext.Current.Session[sSessionName].ToString();
                if (HttpContext.Current.Request.Cookies[sCookieName] != null)
                {
                    HttpContext.Current.Request.Cookies[sCookieName].Expires = DateTime.Now.AddDays(-1d);
                }
            }
            catch { }
        }
        public void ClearCache()
        {
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            HttpContext.Current.Response.Cache.SetExpires(DateTime.Now);
            HttpContext.Current.Response.Cache.SetNoServerCaching();
            HttpContext.Current.Response.Cache.SetNoStore();
            HttpContext.Current.Response.Cookies.Clear();
            HttpContext.Current.Request.Cookies.Clear();
        }
        public void Logout()
        {
            try
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.RemoveAll();
                HttpContext.Current.Session.Abandon();

                //#region Sessions of AddBooking Page

                //ClearLocalSession("ListBP");
                //ClearLocalSession("ListBPV");
                //ClearLocalSession("ItemCount");
                //ClearLocalSession("TotalValue");
                //ClearLocalSession("VAT");

                //#endregion

                //ClearLocalSession("Login");

                ClearCache();
                HttpContext.Current.Response.Redirect("/Login.aspx");
            }
            catch { }
        }

        public void PopulateGridViewFromDataTable(GridView gv, string sTable)
        {
            string sValue = string.Empty;
            gv.DataSource = null;
            gv.DataBind();

            string sGridQuery = "select * from " + sTable;

            DataTable dtGrid = Retrieve_Data(sGridQuery, sTable);

            if (dtGrid != null)
            {
                if (dtGrid.Rows.Count > 0)
                {
                    gv.DataSource = dtGrid;
                    gv.DataBind();
                    //gv.Attributes.Add("style", "word-break:break-all;word-wrap:break-word");
                }
            }
        }

        public void PopulateGridViewFromDataTable(GridView gv, string sTable, string sCriteria, string sCriteriaValue)
        {
            string sValue = string.Empty;
            gv.DataSource = null;
            gv.DataBind();

            string sGridQuery = "select * from " + sTable;
            sGridQuery += " where " + sCriteria + " != '" + sCriteriaValue + "'";
            sGridQuery += " and Locked = 0";

            DataTable dtGrid = Retrieve_Data(sGridQuery, sTable);

            if (dtGrid != null)
            {
                if (dtGrid.Rows.Count > 0)
                {
                    gv.DataSource = dtGrid;
                    gv.DataBind();
                    //gv.Attributes.Add("style", "word-break:break-all;word-wrap:break-word");
                }
            }
        }

        public void PopulateGridViewFromDataTable(GridView gv, DataTable dtGrid)
        {
            string sValue = string.Empty;
            gv.DataSource = null;
            gv.DataBind();

            if (dtGrid != null)
            {
                if (dtGrid.Rows.Count > 0)
                {
                    gv.DataSource = dtGrid;
                    gv.DataBind();
                    //gv.Attributes.Add("style", "word-break:break-all;word-wrap:break-word");
                }
            }
        }

        public DataTable PopulateDataTableFromGridView(GridView gv)
        {
            DataTable dt = new DataTable();

            // add the columns to the datatable            
            if (gv.HeaderRow != null)
            {

                for (int i = 0; i < gv.HeaderRow.Cells.Count; i++)
                {
                    if (i <= 15)
                        dt.Columns.Add(gv.HeaderRow.Cells[i].Text);
                    else
                        break;
                }
            }

            //  add each of the data rows to the table
            foreach (GridViewRow row in gv.Rows)
            {
                DataRow dr;
                dr = dt.NewRow();

                for (int i = 0; i < row.Cells.Count; i++)
                {
                    if (i <= 15)
                        dr[i] = row.Cells[i].Text.Replace("&nbsp;", "");
                    else
                        break;
                }
                dt.Rows.Add(dr);
            }

            return dt;
        }

        public double CalculateTotal(GridView gv, int iColIndex)
        {
            double dTotal = 0.0;

            for (int i = 0; i < gv.Rows.Count; ++i)
            {
                dTotal += double.Parse(gv.Rows[i].Cells[iColIndex].Text.Trim());
            }

            return dTotal;
        }

        public void DownloadPDF(DataTable dt, string sName)
        {
            try
            {
                //Create a dummy GridView
                GridView gv = new GridView();
                gv.AllowPaging = false;
                gv.DataSource = dt;
                gv.DataBind();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", 
                    "attachment;filename=View" + sName + "List.pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);

                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                gv.RenderControl(hw);

                StringReader sr = new StringReader(sw.ToString());
                Document pdfDoc = new Document(PageSize.A2, 10f, 10f, 10f, 0f);

                HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                PdfWriter.GetInstance(pdfDoc, HttpContext.Current.Response.OutputStream);

                pdfDoc.Open();

                string imagePath = HttpContext.Current.Server.MapPath("~/images/JobyCo_Logo.png");
                iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(imagePath);
                image.Alignment = iTextSharp.text.Image.ALIGN_LEFT;

                pdfDoc.Add(image);
                htmlparser.Parse(sr);

                pdfDoc.Close();
                HttpContext.Current.Response.Write(pdfDoc);
                HttpContext.Current.Response.End();
            }
            catch { }
        }

        public void DownloadExcel(DataTable dt, string sName)
        {
            try
            {
                //Create a dummy GridView
                GridView gv = new GridView();
                gv.AllowPaging = false;
                gv.DataSource = dt;
                gv.DataBind();

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.AddHeader("content-disposition",
                 "attachment;filename=View" + sName + "List.xls");
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    //Apply text style to each Row
                    gv.Rows[i].Attributes.Add("class", "textmode");
                }
                gv.RenderControl(hw);

                //style to format numbers to string
                string style = @"<style> .textmode { mso-number-format:\@; } </style>";
                HttpContext.Current.Response.Write(style);
                HttpContext.Current.Response.Output.Write(sw.ToString());
                HttpContext.Current.Response.Flush();
                HttpContext.Current.Response.End();
            }
            catch { }
        }
    }
}
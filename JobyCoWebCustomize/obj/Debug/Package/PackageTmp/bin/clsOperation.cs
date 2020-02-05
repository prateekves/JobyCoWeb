using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data;
using System.Data.SqlClient;

using System.Net;
using System.Net.Mail;
using System.Net.Cache;
using System.Net.Security;

using System.Collections;
using System.Globalization;
using System.Configuration;
using EntityLayer;

namespace DataAccessLayer
{
    public class clsOperation
    {
        //Declaring Required Variables
        string sConnectionString = string.Empty;
        bool bFailure = false;

        public clsOperation()
        {
            sConnectionString = ConfigurationManager.ConnectionStrings["dbJobyCoConnection"].ConnectionString;
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

        public bool CheckExistence(string sField, string sFieldValue, string sTable)
        {
            bool bExists = false;

            //Building Query
            string sQuery = "select * from " + sTable
                + " where " + sField + " = '" + sFieldValue + "'";

            //Filling DataTable
            DataTable dtCheck = Retrieve_Data(sQuery, sTable);

            //Checking Value
            if (dtCheck != null)
            {
                if (dtCheck.Rows.Count > 0)
                    bExists = true;
                else
                    bExists = false;
            }

            return bExists;
        }

        public bool CheckExistence(string sField1, string sFieldValue1, string sField2, string sFieldValue2, string sTable)
        {
            bool bExists = false;
            //sFieldValue2 = "UK";  // manually it is UK or  Ghana
            string sQuery = @"SELECT * FROM Users U 
                            INNER JOIN Warehouse W ON W.WarehouseId= U.WarehouseId
                            INNER JOIN Location L ON L.LocationName = W.LocationName
                            Where ( " + sField1 + " = '" + sFieldValue1 + "' AND L.Country ='" + sFieldValue2 + "' ) OR ( " + sField1 + " = '" + sFieldValue1 + "' AND UserRole='SuperAdmin' )";

            //Filling DataTable
            DataTable dtCheck = Retrieve_Data(sQuery, sTable);

            //Checking Value
            if (dtCheck != null)
            {
                if (dtCheck.Rows.Count > 0)
                    bExists = true;
                else
                    bExists = false;
            }

            //return bExists;
            return true;
        }

        public DataTable GetDriversForDelivery(string OptionType)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetAllDrivers", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable GetDriversByLoggedInUser(string EmailID)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetAllDrivers", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@EmailID", EmailID);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public bool CheckLogin(DataTable dtLogin)
        {
            bool bSuccess = false;

            //Checking Value
            if (dtLogin != null)
            {
                if (dtLogin.Rows.Count > 0)
                    bSuccess = true;
                else
                    bSuccess = false;
            }

            return bSuccess;
        }

        public DataTable GetAllItemStatus(string EmailID)
        {
            //DataSet dsRetrieve = new DataSet();
            //DataTable dtRetrieve = new DataTable();

            //SqlConnection conRetrieve = new SqlConnection(sConnectionString);

            //try
            //{
            //    string sQuery = "Select Id , Status From [dbo].[ItemStatus]";
            //    SqlCommand cmdRetrieve = new SqlCommand(sQuery, conRetrieve);
            //    SqlDataAdapter daRetrieve = new SqlDataAdapter(cmdRetrieve);

            //    daRetrieve.Fill(dsRetrieve);
            //    dtRetrieve = dsRetrieve.Tables[0];
            //    conRetrieve.Close();
            //}
            //catch
            //{
            //    conRetrieve.Close();
            //}
            //finally
            //{
            //    conRetrieve.Close();
            //}

            //return dtRetrieve;

            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetAllItemStatus", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@EmailID", EmailID);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public int GetNoOfRecords(string sQuery, string sTable)
        {
            DataTable dtRecords = Retrieve_Data(sQuery, sTable);

            return dtRecords.Rows.Count;
        }

        public string GetNextToLastValue(string sField, string sTable)
        {
            string sLastValue = string.Empty;
            string sNextToLastValue = string.Empty;

            string sQuery = "select " + sField + " from " + sTable
                + " order by " + sField + " desc";

            DataTable dtLastValue = Retrieve_Data(sQuery, sTable);

            if (dtLastValue != null)
            {
                if (dtLastValue.Rows.Count > 0)
                    sLastValue = dtLastValue.Rows[0][sField].ToString();
                else
                    sLastValue = "0";
            }
            else
                sLastValue = "0";

            int iLastValue = int.Parse(sLastValue);
            int iNextToLastValue = iLastValue + 1;
            sNextToLastValue = iNextToLastValue.ToString();

            return sNextToLastValue;
        }

        public string GetLastValue(string sField, string sTable, string sCheckField, string sCheckFieldValue)
        {
            string sLastValue = string.Empty;

            string sQuery = "select " + sField + " from " + sTable
                + " where " + sCheckField + " = '" + sCheckFieldValue + "'"
                + " order by " + sField + " desc";

            DataTable dtLastValue = Retrieve_Data(sQuery, sTable);

            if (dtLastValue != null)
            {
                if (dtLastValue.Rows.Count > 0)
                    sLastValue = dtLastValue.Rows[0][sField].ToString();
            }

            return sLastValue;
        }

        //public string GetAutoGeneratedValue(string sField, string sTable, string sInitial, int iNoOfZeros)
        //{
        //    //Picking up the last Value
        //    string sLastValueQuery = "select " + sField + " from " + sTable;
        //    sLastValueQuery += " order by " + sField + " desc";

        //    //Filling DataTable with Value
        //    DataTable dtLastValue = Retrieve_Data(sLastValueQuery, sTable);

        //    string sNoOfZeros = string.Empty;

        //    for (int i = 0; i < iNoOfZeros; i++)
        //        sNoOfZeros += "0";

        //    //Variable to Pickup Last LastValue
        //    string sLastValue = "";

        //    if (dtLastValue != null)
        //    {
        //        //If any PO exits in DB Table
        //        if (dtLastValue.Rows.Count > 0)
        //            sLastValue = dtLastValue.Rows[0][0].ToString();
        //        else
        //            sLastValue = sInitial + sNoOfZeros;
        //    }
        //    else
        //        sLastValue = sInitial + sNoOfZeros;

        //    //Extracting Numeric Part of this Value
        //    string sNumericLastValue = sLastValue.Substring(sInitial.Length, iNoOfZeros);
        //    int iNumericLastValue = int.Parse(sNumericLastValue);

        //    //Adding just one to get the New Value
        //    int iNextLastValue = iNumericLastValue + 1;

        //    //Assignment of Next and New LastValue
        //    string sNextLastValue = iNextLastValue.ToString();
        //    string sNewLastValue = sInitial + sNextLastValue.PadLeft(iNoOfZeros, '0');

        //    return sNewLastValue;
        //}

        public string GetAutoGeneratedValueOld(string sField, string sTable, string sInitial, int iNoOfZeros)
        {
            //Picking up the last Value
            string sLastValueQuery = "select " + sField + " from " + sTable;
            sLastValueQuery += " order by " + sField + " desc";

            //Filling DataTable with Value
            DataTable dtLastValue = Retrieve_Data(sLastValueQuery, sTable);

            string sNoOfZeros = string.Empty;

            for (int i = 0; i < iNoOfZeros; i++)
                sNoOfZeros += "0";

            //Variable to Pickup Last LastValue
            string sLastValue = "";

            if (dtLastValue != null)
            {
                //If any PO exits in DB Table
                if (dtLastValue.Rows.Count > 0)
                    sLastValue = dtLastValue.Rows[0][0].ToString();
                else
                    sLastValue = sInitial + sNoOfZeros;
            }
            else
                sLastValue = sInitial + sNoOfZeros;

            //Extracting Numeric Part of this Value
            string sNumericLastValue = "";
            int Length = sLastValue.Length - 1;
            while (Length >= 0)
            {
                sNumericLastValue = sNumericLastValue + sLastValue[Length];
                Length--;
            }
            sNumericLastValue = sLastValue.Substring(sInitial.Length, iNoOfZeros);

            int iNumericLastValue = int.Parse(sNumericLastValue);

            //Adding just one to get the New Value
            int iNextLastValue = iNumericLastValue + 1;

            //Assignment of Next and New LastValue
            string sNextLastValue = iNextLastValue.ToString();
            string sNewLastValue = sInitial + sNextLastValue.PadLeft(iNoOfZeros, '0');

            return sNewLastValue;
        }

        public DataTable GetDeliveryAddressesFromCustomerId(string CustomerId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetDeliveryAddressesFromCustomerId", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@CustomerId", CustomerId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public string GetAutoGeneratedValue(string sField, string sTable, string sInitial, int iNoOfZeros)
        {
            //Picking up the last Value
            string sLastValueQuery = "select " + sField + " from " + sTable;
            sLastValueQuery += " order by " + sField + " desc";

            //Filling DataTable with Value
            DataTable dtLastValue = Retrieve_Data(sLastValueQuery, sTable);

            DateTime Today = System.DateTime.Now;
            string Day = Today.Day.ToString("00");
            string Month = Today.Month.ToString("00");

            string sLastValue = string.Empty;

            if (dtLastValue != null)
            {
                //If any PO exits in DB Table
                if (dtLastValue.Rows.Count > 0)
                    sLastValue = dtLastValue.Rows[0][0].ToString();
                else
                    sLastValue = sInitial + Day + Month + "1".PadLeft(3, '0');
            }
            else
                sLastValue = sInitial + Day + Month + "1".PadLeft(3, '0');


            //Extracting Numeric Part of this Value
            string sNumericLastValue = sLastValue.Substring(sInitial.Length + 4, sLastValue.Length - sInitial.Length - 4);
            int iNumericLastValue = int.Parse(sNumericLastValue);

            //Adding just one to get the New Value
            int iNextLastValue = iNumericLastValue + 1;

            //Assignment of Next and New LastValue
            string sNextLastValue = iNextLastValue.ToString();
            string sNewLastValue = sInitial + Day + Month + sNextLastValue.PadLeft(3, '0');

            return sNewLastValue;
        }

        public DataTable GetCustomerDeliveryDetailsFromCustomerName(string AddressId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetCustomerDeliveryDetailsFromCustomerName", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@AddressId", AddressId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable GetAddressesFromCustomerId(string CustomerId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetAddressesFromCustomerId", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@CustomerId", CustomerId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public string GetAutoGeneratedValueClientFormat(string sField, string sTable, string sInitial, int iNoOfDigit)
        {
            //Picking up the last Value
            string sLastValueQuery = "select " + sField + " from " + sTable;
            sLastValueQuery += " order by Id desc";

            //Filling DataTable with Value
            DataTable dtLastValue = Retrieve_Data(sLastValueQuery, sTable);

            DateTime Today = System.DateTime.Now;
            string Day = Today.Day.ToString("00");
            string Month = Today.Month.ToString("00");

            string sLastValue = string.Empty;

            if (dtLastValue != null)
            {
                //If any PO exits in DB Table
                if (dtLastValue.Rows.Count > 0)
                    sLastValue = dtLastValue.Rows[0][0].ToString();
                else
                    sLastValue = sInitial + Day + Month + "1".PadLeft(iNoOfDigit, '0');
            }
            else
                sLastValue = sInitial + Day + Month + "1".PadLeft(iNoOfDigit, '0');


            //Extracting Numeric Part of this Value
            string sNumericLastValue = sLastValue.Substring(sInitial.Length+4, sLastValue.Length - sInitial.Length - 4);
            int iNumericLastValue = int.Parse(sNumericLastValue);

            //Adding just one to get the New Value
            int iNextLastValue = iNumericLastValue + 1;

            //Assignment of Next and New LastValue
            string sNextLastValue = iNextLastValue.ToString();
            string sNewLastValue = sInitial + Day + Month + sNextLastValue.PadLeft(iNoOfDigit, '0');

            return sNewLastValue;
        }

        public string GetAutoGeneratedValueClientFormatNew(string sField, string sTable, string sInitial, int iNoOfDigit)
        {
            //Picking up the last Value
            string sLastValueQuery = "select " + sField + " from " + sTable;
            sLastValueQuery += " order by Id desc";

            //Filling DataTable with Value
            DataTable dtLastValue = Retrieve_Data(sLastValueQuery, sTable);

            //DateTime Today = System.DateTime.Now;
            //string Day = Today.Day.ToString("00");
            //string Month = Today.Month.ToString("00");

            string sLastValue = string.Empty;

            if (dtLastValue != null)
            {
                //If any PO exits in DB Table
                if (dtLastValue.Rows.Count > 0)
                    sLastValue = dtLastValue.Rows[0][0].ToString();
                else
                    //sLastValue = sInitial + Day + Month + "1".PadLeft(iNoOfDigit, '0');
                    sLastValue = sInitial + "1".PadLeft(iNoOfDigit, '0');
            }
            else
                sLastValue = sInitial + "1".PadLeft(iNoOfDigit, '0');
            //sLastValue = sInitial + Day + Month + "1".PadLeft(iNoOfDigit, '0');


            //Extracting Numeric Part of this Value
            string sNumericLastValue = "";
            if (sLastValue.Length == 11) // For Booking
            {
                sNumericLastValue = sLastValue.Substring(sInitial.Length + 4, sLastValue.Length - sInitial.Length - 4);
            }
            else if (sLastValue.Length == 10) // For Item
            {
                sNumericLastValue = sLastValue.Substring(sInitial.Length + 3, sLastValue.Length - sInitial.Length - 3);
            }
            else
            {
                sNumericLastValue = sLastValue.Substring(sInitial.Length, sLastValue.Length - sInitial.Length);
            }
             
            int iNumericLastValue = int.Parse(sNumericLastValue);

            //Adding just one to get the New Value
            int iNextLastValue = iNumericLastValue + 1;

            //Assignment of Next and New LastValue
            string sNextLastValue = iNextLastValue.ToString();
            //string sNewLastValue = sInitial + Day + Month + sNextLastValue.PadLeft(iNoOfDigit, '0');
            string sNewLastValue = sInitial + sNextLastValue.PadLeft(iNoOfDigit, '0');

            return sNewLastValue;
        }
        public DataTable GetCustomerDetailsFromCustomerName(string AddressId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetCustomerDetailsFromCustomerName", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@AddressId", AddressId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable RetrieveAllDataFromField(string sField, string sTable)
        {
            //Building Query 
            string sQuery = "select " + sField + " from " + sTable;
            sQuery += " order by " + sField;

            //Filling DataTable
            DataTable dtAllDataFromField = Retrieve_Data(sQuery, sTable);

            return dtAllDataFromField;
        }

        public string RetrieveField2FromField1(string sField2, string sTable,
            string sField1, string sField1Value)
        {
            string sField2Value = "";

            //Building Query 
            string sQuery = "select " + sField2 + " from " + sTable;
            sQuery += " where " + sField1 + " = '" + sField1Value + "'";

            //Filling DataTable
            DataTable dtField2Value = Retrieve_Data(sQuery, sTable);

            //Getting Field2 Value
            if (dtField2Value != null)
                if (dtField2Value.Rows.Count > 0)
                    sField2Value = dtField2Value.Rows[0][0].ToString();

            return sField2Value;
        }

        public string DeleteItemImage(string ImagePickupId, string ImageName)
        {
            SqlConnection conRID = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRID = new SqlCommand("spDeleteItemImage", conRID);
                cmdRID.CommandType = CommandType.StoredProcedure;
                cmdRID.Parameters.AddWithValue("@ImagePickupId", ImagePickupId);
                cmdRID.Parameters.AddWithValue("@ImageName", ImageName);

                conRID.Open();
                cmdRID.ExecuteNonQuery();
                conRID.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                //sErrMsg = ex.Message + Environment.NewLine;
                //File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                conRID.Close();
            }
            finally
            {
                conRID.Close();
            }
            return "Success";
        }

        public string RetrieveDistinctField2FromField1(string sField2, string sTable,
            string sField1, string sField1Value)
        {
            string sField2Value = "";

            //Building Query 
            string sQuery = "select distinct " + sField2 + " from " + sTable;
            sQuery += " where " + sField1 + " = '" + sField1Value + "'";

            //Filling DataTable
            DataTable dtField2Value = Retrieve_Data(sQuery, sTable);

            //Getting Field2 Value
            if (dtField2Value != null)
                if (dtField2Value.Rows.Count > 0)
                    sField2Value = dtField2Value.Rows[0][0].ToString();

            return sField2Value;
        }

        public string RetrieveField2FromAlikeField1(string sField2, string sTable,
            string sField1, string sField1Value)
        {
            string sField2Value = "";

            //Building Query 
            string sQuery = "select " + sField2 + " from " + sTable;
            sQuery += " where " + sField1 + " like '%" + sField1Value + "%'";

            //Filling DataTable
            DataTable dtField2Value = Retrieve_Data(sQuery, sTable);

            //Getting Field2 Value
            if (dtField2Value != null)
                if (dtField2Value.Rows.Count > 0)
                    sField2Value = dtField2Value.Rows[0][0].ToString();

            return sField2Value;
        }

        public string RetrieveField3FromField1AndField2(string sField3, string sTable,
            string sField1, string sField1Value, string sField2, string sField2Value)
        {
            string sField3Value = "";

            //Building Query 
            string sQuery = "select " + sField3 + " from " + sTable;
            sQuery += " where " + sField1 + " = '" + sField1Value + "' and ";
            sQuery += sField2 + " = '" + sField2Value + "'";

            //Filling DataTable
            DataTable dtField3Value = Retrieve_Data(sQuery, sTable);

            //Getting Field3 Value
            if (dtField3Value != null)
                if (dtField3Value.Rows.Count > 0)
                    sField3Value = dtField3Value.Rows[0][0].ToString();

            return sField3Value;
        }

        public bool SendMail(string sFrom, string sTo, string sSubject, string sBody, string sFromPassword)
        {
            try
            {
                MailMessage msg = new MailMessage();
                msg.To.Add(sTo);
                msg.From = new MailAddress(sFrom);
                //msg.Bcc.Add("testing@switch2web.com");

                msg.Subject = sSubject;
                msg.IsBodyHtml = true;
                msg.Body = sBody;
                msg.Priority = MailPriority.High;

                SmtpClient smtpc = new SmtpClient();

                #region Mail Sending Via Web Server
                //smtpc.Host = "mail.weseecloud.net";
                //smtpc.Port = 25;
                //smtpc.EnableSsl = false;
                #endregion

                #region Mail Sending Via Gmail
                smtpc.Host = "mail.jobycodirect.com";
                smtpc.Port = 25;
                smtpc.EnableSsl = false;
                #endregion

                smtpc.UseDefaultCredentials = true;
                smtpc.Credentials = new NetworkCredential(sFrom, sFromPassword);
                smtpc.Send(msg);

                bFailure = false;
            }
            catch (Exception e)
            {
                bFailure = true;
            }

            return bFailure;


            //try
            //{
            //    MailMessage msg = new MailMessage();
            //    msg.To.Add(sTo);
            //    msg.From = new MailAddress(sFrom);
            //    msg.Subject = sSubject;
            //    msg.IsBodyHtml = true;
            //    msg.Body = sBody;
            //    msg.Priority = MailPriority.High;

            //    //SmtpClient smtpc = new SmtpClient();
            //    //smtpc.Host = "smtp.gmail.com";
            //    //smtpc.Port = 587;
            //    //smtpc.EnableSsl = false;
            //    //smtpc.UseDefaultCredentials = false;
            //    //smtpc.Credentials = new NetworkCredential(sFrom, sFromPassword);
            //    //smtpc.Send(msg);
            //    SmtpClient smtp = new SmtpClient();
            //    smtp.Host = "smtp.gmail.com";
            //    smtp.EnableSsl = true;
            //    System.Net.NetworkCredential NetworkCred = new System.Net.NetworkCredential();
            //    NetworkCred.UserName = sFrom;
            //    NetworkCred.Password = sFromPassword;
            //    smtp.UseDefaultCredentials = true;
            //    smtp.Credentials = NetworkCred;
            //    smtp.Port = 587;
            //    smtp.Send(msg);


            //    /*SmtpClient sc = new SmtpClient("172.16.102.67");

            //    sc.Port = 25;
            //    sc.UseDefaultCredentials = true;
            //    sc.Send(msg);*/

            //    bFailure = false;
            //}
            //catch (Exception e)
            //{
            //    bFailure = true;
            //}

            //return bFailure;
        }

        public DataTable RemoveDuplicatesRows(DataTable table, string DistinctColumn)
        {
            try
            {
                ArrayList UniqueRecords = new ArrayList();
                ArrayList DuplicateRecords = new ArrayList();

                // Check if records is already added to UniqueRecords otherwise,
                // Add the records to DuplicateRecords
                foreach (DataRow dRow in table.Rows)
                {
                    if (UniqueRecords.Contains(dRow[DistinctColumn]))
                        DuplicateRecords.Add(dRow);
                    else
                        UniqueRecords.Add(dRow[DistinctColumn]);
                }

                // Remove duplicate rows from DataTable added to DuplicateRecords
                foreach (DataRow dRow in DuplicateRecords)
                {
                    table.Rows.Remove(dRow);
                }

                // Return the clean DataTable which contains unique records.
                return table;
            }
            catch
            {
                return null;
            }
        }

        public string ConvertDateFromUKtoANSI(string sDateUK)
        {
            string sDateANSI = string.Empty;

            if (!sDateUK.Equals(string.Empty))
            {
                string sDay = sDateUK.Substring(0, 2);
                string sMonth = sDateUK.Substring(3, 2);
                string sYear = sDateUK.Substring(6, 4);

                sDateANSI = sYear + "-" + sMonth + "-" + sDay;
            }

            return sDateANSI;
        }

        public string ConvertDateFromANSItoUK(string sDateANSI)
        {
            string sDateUK = string.Empty;

            if (!sDateANSI.Equals(string.Empty))
            {
                string sDay = sDateANSI.Substring(8, 2);
                string sMonth = sDateANSI.Substring(5, 2);
                string sYear = sDateANSI.Substring(0, 4);

                sDateUK = sDay + "-" + sMonth + "-" + sYear;
            }

            return sDateUK;
        }

        public double CalculateTotal(DataTable dt, string sField)
        {
            double dTotal = 0.0;

            for (int i = 0; i < dt.Rows.Count; ++i)
            {
                dTotal += double.Parse(dt.Rows[i][sField].ToString());
            }

            return dTotal;
        }

        public bool CheckEnteredDateIsGreaterThanCurrentDate(string sDateUK)
        {
            CultureInfo ukCulture = new CultureInfo("en-GB");
            DateTime dtDateUK = DateTime.Parse(sDateUK, ukCulture.DateTimeFormat);
            DateTime dtCurrentDate = DateTime.Now;

            TimeSpan ts = dtDateUK - dtCurrentDate;
            if (ts.Milliseconds > 0)
            {
                return true;
            }
            else
                return false;
        }

        public int GetItemIdFromName(string PickupItem)
        {
            DataTable dt = new DataTable();
            string sQuery = "SELECT PickupItemId FROM [dbo].[PickupItems] WHERE PickupItem = '" + PickupItem + "'";
            dt =  Retrieve_Data(sQuery, "PickupCategories");
            if (dt.Rows.Count > 0)
                return Convert.ToInt32(dt.Rows[0][0].ToString());
            return 0;
        }

        public int GetCategoryIdFromName(string PickupCategory)
        {
            DataTable dt = new DataTable();
            string sQuery = "SELECT PickupCategoryId FROM [dbo].[PickupCategories] WHERE PickupCategory = '" + PickupCategory + "'";
            dt = Retrieve_Data(sQuery, "PickupItems");
            if (dt.Rows.Count > 0)
                return Convert.ToInt32(dt.Rows[0][0].ToString());
            return 0;
        }

        public int CalculateAgeFromDateOfBirthInUK(string sDateStringUK)
        {
            int iAge = 0;

            string sFormat = "dd/MM/yyyy";
            CultureInfo Provider = new CultureInfo("fr-FR");

            DateTime dtCustomerDOB = DateTime.ParseExact(sDateStringUK, sFormat, Provider);
            iAge = DateTime.Now.Year - dtCustomerDOB.Year;

            return iAge;
        }

        public string RoundOffNullOrEmptyValue(string sNullOrEmptyValueValue)
        {
            string sRoundedOffValue = string.Empty;

            if (string.IsNullOrEmpty(sNullOrEmptyValueValue))
                sRoundedOffValue = "0";
            else
                sRoundedOffValue = sNullOrEmptyValueValue;

            return sRoundedOffValue;
        }

        public DataTable GetFullNames(string sTable)
        {
            string sQuery = "select distinct [Title] + space(1) + [FirstName] + space(1) + [LastName] [FullName] from " + sTable;

            return Retrieve_Data(sQuery, sTable);
        }

        public DataTable GetCustomerIdNames(string sTable)
        {
            string sQuery = "select distinct [Title] + space(1) + [FirstName] + space(1) + [LastName] [CustomerName], CustomerId from " + sTable;
            //string sQuery = "Select " +
            //                "'<table>" +
            //                "< tr >" +
            //                "< td > '+ CustomerId +' </ td >" +
            //                "< td > '+[Title] + ' ' + [FirstName] + ' ' + [LastName]+' </ td >" +
            //                   "< td > ' + C.Address + ' </ td >" +
            //                   "</ tr >" +
            //                   "< tr >" +
            //                   "< td ></ td >" +
            //                   "< td > '+Mobile+' </ td >" +
            //                   "< td > ' + PostCode + ' </ td >" +
            //                   "</ tr >" +
            //                   "< tr >" +
            //                   "< td ></ td >" +
            //                   "< td > '+Telephone+' </ td >" +
            //                   "< td ></ td >" +
            //                   "</ tr >" +
            //                   "</ table > '[CustomerName]" +
            //                 ", CustomerId from Customers C";
            return Retrieve_Data(sQuery, sTable);
        }

        public DataTable GetAllContainerNumber(string sTable)
        {
            string sQuery = "select distinct [ContainerNumber] from " + sTable;
                //+ " WHERE ContainerNumber NOT IN (SELECT DISTINCT ContainerId FROM Shipping)	";

            return Retrieve_Data(sQuery, sTable);
        }

        public string GetCustomerIdFromFullName(string sCustomerFullName)
        {
            string sCustomerId = string.Empty;

            try
            {
                string[] sCustomerNameParts = sCustomerFullName.Split(' ');

                sCustomerId = RetrieveField3FromField1AndField2("CustomerId", "Customers",
                    "FirstName", sCustomerNameParts[1], "LastName", sCustomerNameParts[2]);
            }
            catch { }

            return sCustomerId;
        }

        public DataTable GetCustomerIdFromFullNameAdminBooking(string CustomerId)
        {
            string sCustomerId = string.Empty;
            DataTable dt = new DataTable();
            try
            {
                string sQuery = "Select CustomerId, EmailID, Title,  FirstName + SPACE(1)+LastName As CustomerName, ISNULL(PostCode, '') As PostCode, ISNULL(Mobile, '') As Mobile  From Customers Where CustomerId='" + CustomerId + "'";
                dt = Retrieve_Data(sQuery, "Customers");
            }
            catch { }

            return dt;
        }

        public string GetDriverIdFromFullName(string sDriverFullName)
        {
            string sDriverId = string.Empty;

            try
            {
                string[] sDriverNameParts = sDriverFullName.Split(' ');

                sDriverId = RetrieveField3FromField1AndField2("DriverId", "Drivers",
                    "FirstName", sDriverNameParts[1], "LastName", sDriverNameParts[2]);
            }
            catch { }

            return sDriverId;
        }

        public string GetFullNameFromCustomerId(string sCustomerId)
        {
            string sFullName = string.Empty;

            string sQuery = "select [Title] + space(1) + [FirstName] + space(1) ";
            sQuery += "+ [LastName] [FullName] from [Customers] ";
            sQuery += "where [CustomerId] = '" + sCustomerId + "'";

            DataTable dtFullName = Retrieve_Data(sQuery, "Customers");

            //Checking Value
            if (dtFullName != null)
            {
                if (dtFullName.Rows.Count > 0)
                    sFullName = dtFullName.Rows[0]["FullName"].ToString();
                else
                    sFullName = string.Empty;
            }

            return sFullName;
        }

        public string GetFullNameFromDriverId(string sDriverId)
        {
            string sFullName = string.Empty;

            string sQuery = "select [Title] + space(1) + [FirstName] + space(1) ";
            sQuery += "+ [LastName] [FullName] from [Drivers] ";
            sQuery += "where [DriverId] = '" + sDriverId + "'";

            DataTable dtFullName = Retrieve_Data(sQuery, "Drivers");

            //Checking Value
            if (dtFullName != null)
            {
                if (dtFullName.Rows.Count > 0)
                    sFullName = dtFullName.Rows[0]["FullName"].ToString();
                else
                    sFullName = string.Empty;
            }

            return sFullName;
        }

        public string GetUserFullNameFromEmailId(string sEmailId)
        {
            string sFullName = string.Empty;

            string sQuery = "select [Title] + space(1) + [FirstName] + space(1) ";
            sQuery += "+ [LastName] [FullName] from [Users] ";
            sQuery += "where [EmailID] = '" + sEmailId + "'";

            DataTable dtFullName = Retrieve_Data(sQuery, "Users");

            //Checking Value
            if (dtFullName != null)
            {
                if (dtFullName.Rows.Count > 0)
                    sFullName = dtFullName.Rows[0]["FullName"].ToString();
                else
                    sFullName = string.Empty;
            }

            return sFullName;
        }
        public string GetUserNameFromEmail(string sEmailID)
        {
            string sFullName = string.Empty;
            string sFirstName = RetrieveField2FromField1("FirstName", "Users", "EmailID", sEmailID);
            string sLastName = RetrieveField2FromField1("LastName", "Users", "EmailID", sEmailID);
            sFullName = sFirstName + " " + sLastName;

            return sFullName;
        }

        public string GetUserName(string SessionValue)
        {
            try
            {
                //string sTo = SessionValue;
                //int iAtTheRateIndex = sTo.IndexOf("@");
                //return sTo.Substring(0, iAtTheRateIndex);

                string sFirstName = RetrieveField2FromField1("FirstName", "Users", "EmailID", SessionValue);

                if (sFirstName.Trim().Equals(string.Empty))
                {
                    sFirstName = "";
                }

                return sFirstName;
            }
            catch
            {
                return "";
            }
        }
    }
}

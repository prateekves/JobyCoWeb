using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using EntityLayer;

#region Required NameSpaces for ExceptionLogTextFile
using System.IO;
using System.Web;
#endregion

namespace DataAccessLayer
{
    public class clsDB
    {
        string sConnectionString = string.Empty;

        #region ExceptionLog Details
        
        //Required variables for an Exception Log Text File
        string sExceptionLogFileName = "ExceptionLog.txt";
        string sCurrentDateTime = DateTime.Now.ToString("yyyyMMdd");
        string sExceptionLogFilePath = string.Empty;
        string sErrMsg = string.Empty;

        StreamWriter swExceptionLogStream = null;

        #endregion

        public string Email = string.Empty;
        public string Password = string.Empty;

        public clsDB()
        {
            sConnectionString = ConfigurationManager.ConnectionStrings["dbJobyCoConnection"].ConnectionString;
            Email = "support@jobycodirect.com";
            Password = "08?T8iir";
            //Creating an Exception Log Text File
            sExceptionLogFilePath = HttpContext.Current.Server.MapPath("~/" + sCurrentDateTime + "_" + sExceptionLogFileName);
            
            if(!File.Exists(sExceptionLogFilePath))
            {
                swExceptionLogStream = File.CreateText(sExceptionLogFilePath);
            }
        }

        #region Get Zone

        public DataTable GetDropDownValue(int iTableId, int iFieldId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetDropDownValue", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@TableId", iTableId);
                cmdDDV.Parameters.AddWithValue("@FieldId", iFieldId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable GetDashboardStatus()
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetDashboardStatus", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public void UnAssignBookingToDriver(AssignBookingToDriver objAssign)
        {
            SqlConnection conABTD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdABTD = new SqlCommand("spUnAssignBookingToDriver", conABTD);
                cmdABTD.CommandType = CommandType.StoredProcedure;
                cmdABTD.Parameters.AddWithValue("@BookingId", objAssign.BookingId);
                cmdABTD.Parameters.AddWithValue("@OptionType", objAssign.OptionType);


                conABTD.Open();
                cmdABTD.ExecuteNonQuery();
                conABTD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conABTD.Close();
            }
            finally
            {
                conABTD.Close();
            }
        }

        public int MarkContainerReceived(string ShippingId, string ContainerId)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();
            int Success = 0;
            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                conAPC.Open();
                SqlCommand cmdAPC = new SqlCommand("spMarkContainerReceived", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;
                cmdAPC.Parameters.AddWithValue("@ShippingId", ShippingId);
                cmdAPC.Parameters.AddWithValue("@ContainerId", ContainerId);

                Success = cmdAPC.ExecuteNonQuery();
                conAPC.Close();

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);

            }
            finally
            {
                //conAPC.Close();
            }

            return Success;
        }

        public DataTable GetContainerByContainerId(string ContainerId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);
            try
            {
                string query = @"SELECT ContainerId, ContainerNumber, ContainerTypeId, CompanyName, ContainerAddress, ContactPersonNo, FreightName FROM [dbo].[ContainerDetails] WHERE ContainerNumber='" + ContainerId + "'";

                SqlCommand cmdGAC = new SqlCommand(query, conGAC);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable SearchByItemNoORBookingNo(string ItemNoORBookingNo)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spSearchByItemNoORBookingNo", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@ItemNoORBookingNo", ItemNoORBookingNo);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                if (dsDDV != null && dsDDV.Tables.Count > 0)
                {
                    dtDDV = dsDDV.Tables[0];
                }


                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public int CancelReceive(string ShippingId, string ContainerId)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();
            int Success = 0;
            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                conAPC.Open();
                SqlCommand cmdAPC = new SqlCommand("spCancelReceive", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                cmdAPC.Parameters.AddWithValue("@ShippingId", ShippingId);
                cmdAPC.Parameters.AddWithValue("@ContainerId", ContainerId);

                Success = cmdAPC.ExecuteNonQuery();
                conAPC.Close();

            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conAPC.Close();
            }
            finally
            {
                //conAPC.Close();
            }

            return Success;
        }

        public DataTable GetAllItemsByBookingId(string BookingId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                string query = @"SELECT PickupId FROM BookPickup WHERE BookingId='" + BookingId + "'";

                SqlCommand cmdGAC = new SqlCommand(query, conGAC);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetContainerDetails(string ContainerNo, string SearchKey, string OptionType)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetContainerDetails", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@ContainerNo", ContainerNo);
                cmdGAC.Parameters.AddWithValue("@SearchKey", SearchKey);
                cmdGAC.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public void PaymentBookingStatusChange(Booking b)
        {
            SqlConnection conBooking = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdBooking = new SqlCommand("spOrderStatusBooking", conBooking);
                cmdBooking.CommandType = CommandType.StoredProcedure;

                cmdBooking.Parameters.AddWithValue("@BookingId", b.BookingId);
                cmdBooking.Parameters.AddWithValue("@OrderStatus", b.OrderStatus);
                cmdBooking.Parameters.AddWithValue("@PaymentNotes", b.PaymentNotes);

                conBooking.Open();
                cmdBooking.ExecuteNonQuery();
                conBooking.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conBooking.Close();
            }
            finally
            {
                conBooking.Close();
            }
        }

        public DataTable GetAddressDetailsByCustomerAddress(string EmailID, string selectedAddressId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                //string sql = @"SELECT DISTINCT ob.BookingId, ob.PickupName, c.[Address], c.PostCode, c.Mobile, ob.LatitudePickup, ob.LongitudePickup
                //              FROM Customers AS c
                //            INNER JOIN OrderBooking AS ob ON ob.CustomerId = c.CustomerId
                //             WHERE c.EmailID = '" + EmailID + "' AND Address='"+ selectedAddress + "' AND ob.LatitudePickup IS NOT NULL AND ob.LongitudePickup IS NOT NULL";

                string query = @"SELECT PDA.PickupTitle, ob.Address_Id, ob.BookingId, ob.CustomerId, PDA.Pickup_Cnt_Name AS PickupName, PDA.Pickup_address As Address, PDA.Pickup_Postcode AS PostCode, PDA.Pickup_Mobile As Mobile, PDA.LatitudePickup, PDA.LongitudePickup
                                From OrderBooking As ob
                                INNER JOIN  PickupDeliveryAddress As PDA ON PDA.Ids = ob.Address_Id
                                INNER JOIN Customers As C ON C.CustomerId = ob.CustomerId
                                Where PDA.Pickup_Email = '" + EmailID + "' AND ob.Address_Id='" + Convert.ToInt32(selectedAddressId) + "'";

                SqlCommand cmdGAC = new SqlCommand(query, conGAC);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetShippingInfo(string ContainerNo)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetShippingInfo", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@ContainerNo", ContainerNo);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetPickupDeliveryByBookingId(string BookingId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetPickupDeliveryByBookingId", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetAllWarehouse(string EmailID)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {

                string query = @"Select W.WarehouseId, W.WarehouseName, W.LocationName, W.ZoneName  From Warehouse W
                                WHERE W.WarehouseId NOT IN (Select WarehouseId FRom Users Where EmailID='" + EmailID + "')";


                SqlCommand cmdGAC = new SqlCommand(query, conGAC);
                //cmdGAC.CommandType = CommandType.StoredProcedure;
                //cmdGAC.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public void ReAssignBookingToDriver(AssignBookingToDriver abtd)
        {
            SqlConnection conABTD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdABTD = new SqlCommand("spReAssignBookingToDriver", conABTD);
                cmdABTD.CommandType = CommandType.StoredProcedure;

                cmdABTD.Parameters.AddWithValue("@AssignId", abtd.AssignId);
                cmdABTD.Parameters.AddWithValue("@BookingId", abtd.BookingId);
                cmdABTD.Parameters.AddWithValue("@DriverId", abtd.DriverId);
                cmdABTD.Parameters.AddWithValue("@Wage", abtd.Wage);
                cmdABTD.Parameters.AddWithValue("@OptionType", abtd.OptionType);

                conABTD.Open();
                cmdABTD.ExecuteNonQuery();
                conABTD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conABTD.Close();
            }
            finally
            {
                conABTD.Close();
            }
        }

        public DataTable GetCustomerAddress(string EmailID)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                //string sql = @"SELECT DISTINCT ob.Address_Id, ob.BookingId, ob.CustomerId, ob.PickupName, c.[Address], c.PostCode, c.Mobile, ob.LatitudePickup, ob.LongitudePickup
                //              FROM Customers AS c
                //            INNER JOIN OrderBooking AS ob ON ob.CustomerId = c.CustomerId
                //             WHERE c.EmailID = '" + EmailID + "'";

                string query = @"SELECT PDA.Ids As Address_Id, C.CustomerId, PDA.Pickup_Cnt_Name AS PickupName, PDA.Pickup_address As Address, PDA.Pickup_Postcode AS PostCode, PDA.Pickup_Mobile As Mobile, PDA.LatitudePickup, PDA.LongitudePickup
                                From PickupDeliveryAddress As PDA
                                INNER JOIN Customers As C ON C.CustomerId = PDA.Customer_id
                                Where PDA.Pickup_Email = '" + EmailID + "'";


                SqlCommand cmdGAC = new SqlCommand(query, conGAC);
                //cmdGAC.CommandType = CommandType.StoredProcedure;
                //cmdGAC.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public string checkTaxNameExistance(string taxationName)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();

            SqlConnection conTaxation = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdTaxation = new SqlCommand("spcheckTaxNameExistance", conTaxation);
                cmdTaxation.CommandType = CommandType.StoredProcedure;
               
                    cmdTaxation.Parameters.AddWithValue("@TaxationName", taxationName);
                    

                conTaxation.Open();
                SqlDataAdapter daAPC = new SqlDataAdapter(cmdTaxation);
                daAPC.Fill(dsAPC);
                dtAPC = dsAPC.Tables[0];
                conTaxation.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conTaxation.Close();
            }
            return dtAPC.Rows[0][0].ToString();
        }

        public DataTable GetAllPickupEmailId(string ContainerNoORBookingNo)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetAllPickupEmailId", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@ContainerNoORBookingNo", ContainerNoORBookingNo);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataSet GetBookingItemsTracking(string PickupId, string BookingId, string ContainerId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetBookingItemsTracking", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@PickupId", PickupId);
                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);
                cmdDDV.Parameters.AddWithValue("@ContainerId", ContainerId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                //dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dsDDV;
        }

        public DataTable ViewBookingChargesDetails(string BookingId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spViewBookingChargesDetails", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataSet PopulateMapFromTo(string EmailID)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spPopulateMapFromTo", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@EmailID", EmailID);


                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                //dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dsDDV;
        }

        public void AddShippingInfo(Shippings s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spAddShippingInfo", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ShippingId", s.ShippingId);
                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@SealId", s.SealId);
                cmdShipping.Parameters.AddWithValue("@ShippingFrom", s.ShippingFrom);
                cmdShipping.Parameters.AddWithValue("@ShippingTo", s.ShippingTo);
                cmdShipping.Parameters.AddWithValue("@ShippingDate", s.ShippingDate);
                cmdShipping.Parameters.AddWithValue("@ArrivalDate", s.ArrivalDate);
                cmdShipping.Parameters.AddWithValue("@ETA", s.ETA);
                cmdShipping.Parameters.AddWithValue("@Consignee", s.Consignee);
                cmdShipping.Parameters.AddWithValue("@WarehouseId", s.WarehouseId);
                cmdShipping.Parameters.AddWithValue("@GhanaPort", s.GhanaPort);
                cmdShipping.Parameters.AddWithValue("@UserId", s.UserId);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        public void RemoveShippingItems(Shippings s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spRemoveShippingItems", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@BookingId", s.BookingId);
                cmdShipping.Parameters.AddWithValue("@PickupId", s.PickupId);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        public decimal GetTransactionTotal(string BookingId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetTransactionTotal", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return Convert.ToDecimal(dtGAC.Rows[0][0].ToString());
        }

        public void ReceiveShippingDetails(Shippings s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spReceiveShippingItems", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@BookingId", s.BookingId);
                cmdShipping.Parameters.AddWithValue("@PickupId", s.PickupId);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }
        
        public DataTable GetAllTaxation()
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetAllTaxation", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetAllTaxationForEdit(string ChargesId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetAllTaxationForEdit", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@ChargesId", ChargesId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetAllTaxationForEditRange(string ChargesId)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetAllTaxationForEditRange", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@ChargesId", ChargesId);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public bool DeleteTaxation(string ChargesId, string Chargestxt)
        {
            SqlConnection conUser = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUser = new SqlCommand("spDeleteTaxation", conUser);
                cmdUser.CommandType = CommandType.StoredProcedure;
                cmdUser.Parameters.AddWithValue("@ChargesId", ChargesId);
                cmdUser.Parameters.AddWithValue("@Chargestxt", Chargestxt);
                conUser.Open();
                int z = cmdUser.ExecuteNonQuery();

                conUser.Close();
                if(z > 0)
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUser.Close();
            }
            finally
            {
                conUser.Close();
            }
            return false;
        }

        public DataTable GetTaxationDetails(string TotalValue)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetTaxationDetails", conGAC);
                cmdGAC.CommandType = CommandType.StoredProcedure;
                cmdGAC.Parameters.AddWithValue("@TotalValue", TotalValue);

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public string AddTaxation(Taxation objTaxation)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();

            SqlConnection conTaxation = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdTaxation = new SqlCommand("spAddTaxation", conTaxation);
                cmdTaxation.CommandType = CommandType.StoredProcedure;
                if (objTaxation.IsRange == false)
                {
                    cmdTaxation.Parameters.AddWithValue("@TaxName", objTaxation.TaxName);
                    cmdTaxation.Parameters.AddWithValue("@TaxAmount", objTaxation.TaxAmount);
                    cmdTaxation.Parameters.AddWithValue("@IsRange", objTaxation.IsRange);
                    cmdTaxation.Parameters.AddWithValue("@IsPercent", objTaxation.IsPercent);
                    cmdTaxation.Parameters.AddWithValue("@Active", objTaxation.Active);
                    cmdTaxation.Parameters.AddWithValue("@ChargesType", objTaxation.RadioChargesType);
                }
                else
                {
                    cmdTaxation.Parameters.AddWithValue("@TaxName", objTaxation.TaxName);
                    cmdTaxation.Parameters.AddWithValue("@TaxAmount", objTaxation.TaxAmount);
                    cmdTaxation.Parameters.AddWithValue("@IsRange", objTaxation.IsRange);
                    cmdTaxation.Parameters.AddWithValue("@IsPercent", objTaxation.IsPercent);
                    cmdTaxation.Parameters.AddWithValue("@Active", objTaxation.Active);
                    cmdTaxation.Parameters.AddWithValue("@MinVal", objTaxation.MinVal);
                    cmdTaxation.Parameters.AddWithValue("@MaxVal", objTaxation.MaxVal);
                    cmdTaxation.Parameters.AddWithValue("@ChargesType", objTaxation.RadioChargesType);
                }

                conTaxation.Open();
                SqlDataAdapter daAPC = new SqlDataAdapter(cmdTaxation);
                daAPC.Fill(dsAPC);
                dtAPC = dsAPC.Tables[0];
                conTaxation.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conTaxation.Close();
            }
            return dtAPC.Rows[0][0].ToString();
        }

        public DataTable SelectRedundentImages(string BookingId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spSelectRedundentImages", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable ItemSearchByBookingNo(string BookingNo)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spItemSearchByBookingNo", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@BookingNo", BookingNo);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable GetBookingInformationByBookingId(string BookingId, string OptionType)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetBookingInformationByBookingId", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);
                cmdDDV.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable GetPickupDetailsForPrint(string BookingId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetPickupDetailsForPrint", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;

                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable GetDriverDetailsForPrint(string DriverId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetDriverDetailsForPrint", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;

                cmdDDV.Parameters.AddWithValue("@DriverId", DriverId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public void AddCharges(Taxation objTaxation)
        {
            if (objTaxation.Id> 0) { 

                SqlConnection conUser = new SqlConnection(sConnectionString);

                try
                {
                    SqlCommand cmdUser = new SqlCommand("spAddCharges", conUser);
                    cmdUser.CommandType = CommandType.StoredProcedure;

                    cmdUser.Parameters.AddWithValue("@Id", objTaxation.Id);
                    cmdUser.Parameters.AddWithValue("@TaxName", objTaxation.TaxName);
                    cmdUser.Parameters.AddWithValue("@TaxAmount", objTaxation.TaxAmount);
                    cmdUser.Parameters.AddWithValue("@BookingId", objTaxation.BookingId);
                    cmdUser.Parameters.AddWithValue("@Status", objTaxation.Status);

                    conUser.Open();
                    cmdUser.ExecuteNonQuery();
                    conUser.Close();
                }
                catch (Exception ex)
                {
                    //throw ex;
                    sErrMsg = ex.Message + Environment.NewLine;
                    File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                    //conUser.Close();
                }
                finally
                {
                    conUser.Close();
                }
            }
        }

        //public DataTable GetPickupItems(string BookingId)
        //{
        //    DataSet dsDDV = new DataSet();
        //    DataTable dtDDV = new DataTable();

        //    SqlConnection conDDV = new SqlConnection(sConnectionString);

        //    try
        //    {
        //        SqlCommand cmdDDV = new SqlCommand("spGetPickupItems", conDDV);
        //        cmdDDV.CommandType = CommandType.StoredProcedure;

        //        cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);

        //        SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
        //        daDDV.Fill(dsDDV);
        //        dtDDV = dsDDV.Tables[0];

        //        //conDDV.Close();
        //    }
        //    catch (Exception ex)
        //    {
        //        //throw ex;
        //        sErrMsg = ex.Message + Environment.NewLine;
        //        File.AppendAllText(sExceptionLogFilePath, sErrMsg);
        //        //conDDV.Close();
        //    }
        //    finally
        //    {
        //        //conDDV.Close();
        //    }

        //    return dtDDV;
        //}
        public DataTable GetBookingItemsHistory(string PickupId, string BookingId, string ContainerId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetBookingItemsHistory", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@PickupId", PickupId);
                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);
                cmdDDV.Parameters.AddWithValue("@ContainerId", ContainerId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataTable SearchByContainerNoORBookingNo(string containerNoORBookingNo)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spSearchByContainerNoORBookingNo", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@containerNoORBookingNo", containerNoORBookingNo);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                if (dsDDV != null && dsDDV.Tables.Count> 0)
                {
                    dtDDV = dsDDV.Tables[0];
                }
                

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public int UpdateItemStatus(StatusDetails statusDetails)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();
            int Success = 0;
            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                conAPC.Open();
                SqlCommand cmdAPC = new SqlCommand("spUpdateItemStatus", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                cmdAPC.Parameters.AddWithValue("@BookingIdOrContainerId", statusDetails.BookingId);
                cmdAPC.Parameters.AddWithValue("@PickupId", statusDetails.PickupId);
                cmdAPC.Parameters.AddWithValue("@Status", statusDetails.Status);
                cmdAPC.Parameters.AddWithValue("@StatusDetail", statusDetails.StatusDetail);
                cmdAPC.Parameters.AddWithValue("@IsOrderBookStatus", statusDetails.IsOrderBookStatus);

                //SqlDataAdapter daAPC = new SqlDataAdapter(cmdAPC);
                //daAPC.Fill(dsAPC);
                //dtAPC = dsAPC.Tables[0];

                Success = cmdAPC.ExecuteNonQuery();
                conAPC.Close();

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);

            }
            finally
            {
                //conAPC.Close();
            }
            return Success;
        }

        public string GetCustomerNameByBooking(string BookingId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetCustomerNameByBooking", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;

                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV.Rows[0]["CustomerName"].ToString();
        }

        public DataTable GetBookingStatusItemsHistory(string PickupId, string BookingId, string ContainerId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetBookingStatusItemsHistory", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@PickupId", PickupId);
                cmdDDV.Parameters.AddWithValue("@BookingId", BookingId);
                cmdDDV.Parameters.AddWithValue("@ContainerId", ContainerId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                dtDDV = dsDDV.Tables[0];

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        
        public DataTable GetDropDownValues(int iTableId, int iFieldId)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetDropDownValues", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@TableId", iTableId);
                cmdDDV.Parameters.AddWithValue("@FieldId", iFieldId);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                if (dsDDV !=null && dsDDV.Tables.Count > 0)
                {
                    dtDDV = dsDDV.Tables[0];
                }
                

                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }
        public DataTable GetCustomerAutoComplete(string SearchParam)
        {
            DataSet dsDDV = new DataSet();
            DataTable dtDDV = new DataTable();

            SqlConnection conDDV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDDV = new SqlCommand("spGetCustomerAutoComplete", conDDV);
                cmdDDV.CommandType = CommandType.StoredProcedure;
                cmdDDV.Parameters.AddWithValue("@SearchParam", SearchParam);

                SqlDataAdapter daDDV = new SqlDataAdapter(cmdDDV);
                daDDV.Fill(dsDDV);
                if (dsDDV != null && dsDDV.Tables.Count > 0)
                {
                    dtDDV = dsDDV.Tables[0];
                }


                //conDDV.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDDV.Close();
            }
            finally
            {
                //conDDV.Close();
            }

            return dtDDV;
        }

        public DataSet GetShippingDetailsFromContainerNo(string containerNo)
        {
            DataSet dsAPC = new DataSet();

            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdAPC = new SqlCommand("spGetShippingByContainerNo", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                cmdAPC.Parameters.AddWithValue("@ContainerNo", containerNo);
                SqlDataAdapter daAPC = new SqlDataAdapter(cmdAPC);
                daAPC.Fill(dsAPC);

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conAPC.Close();
            }
            finally
            {
                //conAPC.Close();
            }

            return dsAPC;
        }

        public DataTable GetAllPickupCategories()
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();

            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdAPC = new SqlCommand("spGetAllPickupCategories", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daAPC = new SqlDataAdapter(cmdAPC);
                daAPC.Fill(dsAPC);
                dtAPC = dsAPC.Tables[0];

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conAPC.Close();
            }
            finally
            {
                //conAPC.Close();
            }

            return dtAPC;
        }

        public DataTable GetShippingitemDetailsByBookingId(string containerId, string bookingId)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();

            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdAPC = new SqlCommand("spGetSelectedShippingitemDetailsByBookingId", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                cmdAPC.Parameters.AddWithValue("@ContainerId", containerId);
                cmdAPC.Parameters.AddWithValue("@BookingId", bookingId);

                SqlDataAdapter daAPC = new SqlDataAdapter(cmdAPC);
                daAPC.Fill(dsAPC);
                dtAPC = dsAPC.Tables[0];

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conAPC.Close();
            }
            finally
            {
                //conAPC.Close();
            }

            return dtAPC;
        }

        public int MarkContainerShipped(string ShippingId, string ContainerId)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();
            int Success = 0;
            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                conAPC.Open();
                SqlCommand cmdAPC = new SqlCommand("spMarkContainerShipped", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;
                cmdAPC.Parameters.AddWithValue("@ShippingId", ShippingId);
                cmdAPC.Parameters.AddWithValue("@ContainerId", ContainerId);
 
                Success = cmdAPC.ExecuteNonQuery();
                conAPC.Close();

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);

            }
            finally
            {
                //conAPC.Close();
            }

            return Success;
        }

        public int CancelShipped(string ShippingId, string ContainerId)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();
            int Success = 0;
            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                conAPC.Open();
                SqlCommand cmdAPC = new SqlCommand("spCancelShipped", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                cmdAPC.Parameters.AddWithValue("@ShippingId", ShippingId);
                cmdAPC.Parameters.AddWithValue("@ContainerId", ContainerId);

                Success = cmdAPC.ExecuteNonQuery();
                conAPC.Close();
 
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conAPC.Close();
            }
            finally
            {
                //conAPC.Close();
            }

            return Success;
        }
       
        public DataTable GetBookingInfoItemsFromBookingId(string BookingId, int IsAdd, string ContainerId, string OptionType)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();

            SqlConnection conAPC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdAPC = new SqlCommand("spGetBookingInfoItemsFromBookingId", conAPC);
                cmdAPC.CommandType = CommandType.StoredProcedure;

                cmdAPC.Parameters.AddWithValue("@BookingId", BookingId);
                cmdAPC.Parameters.AddWithValue("@ContainerId", ContainerId);
                cmdAPC.Parameters.AddWithValue("@IsAdd", IsAdd);
                cmdAPC.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daAPC = new SqlDataAdapter(cmdAPC);
                daAPC.Fill(dsAPC);
                dtAPC = dsAPC.Tables[0];

                //conAPC.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conAPC.Close();
            }
            finally
            {
                //conAPC.Close();
            }

            return dtAPC;
        }

        public DataTable CheckEmailIdFromUsers(string sEmailID)
        {
            DataSet dsCEFU = new DataSet();
            DataTable dtCEFU = new DataTable();

            SqlConnection conCEFU = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCEFU = new SqlCommand("spCheckEmailIdFromUsers", conCEFU);
                cmdCEFU.CommandType = CommandType.StoredProcedure;
                cmdCEFU.Parameters.AddWithValue("@EmailID", sEmailID);

                SqlDataAdapter daCEFU = new SqlDataAdapter(cmdCEFU);
                dsCEFU = new DataSet();
                daCEFU.Fill(dsCEFU);
                dtCEFU = dsCEFU.Tables[0];

                //conCEFU.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCEFU.Close();
            }
            finally
            {
                //conCEFU.Close();
            }

            return dtCEFU;
        }

        public DataTable CheckEmailIdFromCustomers(string sEmailID)
        {
            DataSet dsCEFU = new DataSet();
            DataTable dtCEFU = new DataTable();

            SqlConnection conCEFU = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCEFU = new SqlCommand("spCheckEmailIdFromCustomers", conCEFU);
                cmdCEFU.CommandType = CommandType.StoredProcedure;
                cmdCEFU.Parameters.AddWithValue("@EmailID", sEmailID);

                SqlDataAdapter daCEFU = new SqlDataAdapter(cmdCEFU);
                dsCEFU = new DataSet();
                daCEFU.Fill(dsCEFU);
                dtCEFU = dsCEFU.Tables[0];

                //conCEFU.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCEFU.Close();
            }
            finally
            {
                //conCEFU.Close();
            }

            return dtCEFU;
        }
        public DataTable CheckLogin(string sEmailID, string sPassword)
        {
            DataSet dsCL = new DataSet();
            DataTable dtCL = new DataTable();

            SqlConnection conCL = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCL = new SqlCommand("spCheckLogin", conCL);
                cmdCL.CommandType = CommandType.StoredProcedure;
                cmdCL.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdCL.Parameters.AddWithValue("@Password", sPassword);

                SqlDataAdapter daCL = new SqlDataAdapter(cmdCL);
                dsCL = new DataSet();
                daCL.Fill(dsCL);
                dtCL = dsCL.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCL.Close();
            }
            finally
            {
                //conCL.Close();
            }

            return dtCL;
        }

        public DataTable GetAllShippings()
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetAllShipping", conGAS);
                cmdGAS.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }

        
            public DataTable GetCustomerInfoItemsFromBookingId(string BookingId)
            {
                DataSet dsGAS = new DataSet();
                DataTable dtGAS = new DataTable();

                SqlConnection conGAS = new SqlConnection(sConnectionString);

                try
                {
                    SqlCommand cmdGAS = new SqlCommand("spGetCustomerByBookingId", conGAS);
                    cmdGAS.CommandType = CommandType.StoredProcedure;
                    cmdGAS.Parameters.AddWithValue("@BookingId", BookingId);

                    SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                    dsGAS = new DataSet();
                    daGAS.Fill(dsGAS);
                    dtGAS = dsGAS.Tables[0];
                }
                catch (Exception ex)
                {
                    //throw ex;
                    sErrMsg = ex.Message + Environment.NewLine;
                    File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                    //conGAS.Close();
                }
                finally
                {
                    //conGAS.Close();
                }

                return dtGAS;
            }

        public int CheckContainerAvailability(string ContainerNo)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("SELECT * FROM Shipping Where ContainerId='"+ContainerNo+"'", conGAS);

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS.Rows.Count;
        }

        public DataTable GetPickupItemsByBookingId(string ContainerId, string BookingId)
            {
                DataSet dsGAS = new DataSet();
                DataTable dtGAS = new DataTable();

                SqlConnection conGAS = new SqlConnection(sConnectionString);

                try
                {
                    SqlCommand cmdGAS = new SqlCommand("spGetPickupItemsByBookingId", conGAS);
                    cmdGAS.CommandType = CommandType.StoredProcedure;
                cmdGAS.Parameters.AddWithValue("@ContainerId", ContainerId);
                cmdGAS.Parameters.AddWithValue("@BookingId", BookingId);

                    SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                    dsGAS = new DataSet();
                    daGAS.Fill(dsGAS);
                    dtGAS = dsGAS.Tables[0];
                }
                catch (Exception ex)
                {
                    //throw ex;
                    sErrMsg = ex.Message + Environment.NewLine;
                    File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                    //conGAS.Close();
                }
                finally
                {
                    //conGAS.Close();
                }

                return dtGAS;
            }

        //public DataTable GetDeliveryItemsByBookingId(string BookingId)
        //{
        //    DataSet dsGAS = new DataSet();
        //    DataTable dtGAS = new DataTable();

        //    SqlConnection conGAS = new SqlConnection(sConnectionString);

        //    try
        //    {
        //        SqlCommand cmdGAS = new SqlCommand("spGetDeliveryItemsByBookingId", conGAS);
        //        cmdGAS.CommandType = CommandType.StoredProcedure;
        //        cmdGAS.Parameters.AddWithValue("@BookingId", BookingId);

        //        SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
        //        dsGAS = new DataSet();
        //        daGAS.Fill(dsGAS);
        //        dtGAS = dsGAS.Tables[0];
        //    }
        //    catch (Exception ex)
        //    {
        //        //throw ex;
        //        sErrMsg = ex.Message + Environment.NewLine;
        //        File.AppendAllText(sExceptionLogFilePath, sErrMsg);
        //        //conGAS.Close();
        //    }
        //    finally
        //    {
        //        //conGAS.Close();
        //    }

        //    return dtGAS;
        //}

        
            public DataTable GetBookingByBookingId(string BookingId)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetBookingByBookingId", conGAS);
                cmdGAS.CommandType = CommandType.StoredProcedure;
                cmdGAS.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }


        public DataTable GetItemImagesByBookingId(string BookingId)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetItemImagesByBookingId", conGAS);
                cmdGAS.CommandType = CommandType.StoredProcedure;
                cmdGAS.Parameters.AddWithValue("@BookingId", BookingId);

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }

        public DataTable GetItemImagesByItemId(string BookingId, string PickupCategoryId, string PickupItemId)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetItemImagesByBookingId", conGAS);
                cmdGAS.CommandType = CommandType.StoredProcedure;
                cmdGAS.Parameters.AddWithValue("@BookingId", BookingId);
                cmdGAS.Parameters.AddWithValue("@PickupCategoryId", PickupCategoryId);
                cmdGAS.Parameters.AddWithValue("@PickupItemId", PickupItemId);

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }
        public DataTable GetAllShippings(string ContainerNumber)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetAllShipping", conGAS);
                cmdGAS.CommandType = CommandType.StoredProcedure;
                cmdGAS.Parameters.AddWithValue("@ContainerNumber", ContainerNumber);

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }
        //Debashish
        public DataTable GetAllShippings(DateTime startDate, DateTime endDate)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetAllShippingByDate", conGAS);
                cmdGAS.CommandType = CommandType.StoredProcedure;
                cmdGAS.Parameters.AddWithValue("@startDate", startDate);
                cmdGAS.Parameters.AddWithValue("@endDate", endDate);

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }
        //Debashish
        public DataTable GetAllUsers(string EmailId)
        {
            DataSet dsGAS = new DataSet();
            DataTable dtGAS = new DataTable();

            SqlConnection conGAS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAS = new SqlCommand("spGetAllUsers", conGAS);
                cmdGAS.Parameters.AddWithValue("@EmailId", EmailId);
                cmdGAS.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAS = new SqlDataAdapter(cmdGAS);
                dsGAS = new DataSet();
                daGAS.Fill(dsGAS);
                dtGAS = dsGAS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAS.Close();
            }
            finally
            {
                //conGAS.Close();
            }

            return dtGAS;
        }

        public DataTable GetAllBookings()
        {
            DataSet dsGAB = new DataSet();
            DataTable dtGAB = new DataTable();

            SqlConnection conGAB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAB = new SqlCommand("spGetAllBookings", conGAB);
                cmdGAB.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAB = new SqlDataAdapter(cmdGAB);
                dsGAB = new DataSet();
                daGAB.Fill(dsGAB);
                dtGAB = dsGAB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAB.Close();
            }
            finally
            {
                //conGAB.Close();
            }

            return dtGAB;
        }

        public DataTable GetItemwiseBookings()
        {
            DataSet dsGIB = new DataSet();
            DataTable dtGIB = new DataTable();

            SqlConnection conGIB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGIB = new SqlCommand("spGetItemwiseBookings", conGIB);
                cmdGIB.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGIB = new SqlDataAdapter(cmdGIB);
                dsGIB = new DataSet();
                daGIB.Fill(dsGIB);
                dtGIB = dsGIB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGIB.Close();
            }
            finally
            {
                //conGIB.Close();
            }

            return dtGIB;
        }

        public DataTable GetAllUnassignedBookings(string OptionType)
        {
            DataSet dsGAUB = new DataSet();
            DataTable dtGAUB = new DataTable();

            SqlConnection conGAUB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAUB = new SqlCommand("spGetAllUnassignedBookings", conGAUB);
                cmdGAUB.CommandType = CommandType.StoredProcedure;
                cmdGAUB.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daGAUB = new SqlDataAdapter(cmdGAUB);
                dsGAUB = new DataSet();
                daGAUB.Fill(dsGAUB);
                dtGAUB = dsGAUB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAUB.Close();
            }
            finally
            {
                //conGAUB.Close();
            }

            return dtGAUB;
        }

        public DataTable GetAllMenuDetails()
        {
            DataSet dsGAMD = new DataSet();
            DataTable dtGAMD = new DataTable();

            SqlConnection conGAMD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAMD = new SqlCommand("spGetAllMenuDetails", conGAMD);
                cmdGAMD.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAMD = new SqlDataAdapter(cmdGAMD);
                dsGAMD = new DataSet();
                daGAMD.Fill(dsGAMD);
                dtGAMD = dsGAMD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAMD.Close();
            }
            finally
            {
                //conGAMD.Close();
            }

            return dtGAMD;
        }

        public DataTable GetAllUserRoles()
        {
            DataSet dsGAUR = new DataSet();
            DataTable dtGAUR = new DataTable();

            SqlConnection conGAUR = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAUR = new SqlCommand("spGetAllUserRoles", conGAUR);
                cmdGAUR.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAUR = new SqlDataAdapter(cmdGAUR);
                dsGAUR = new DataSet();
                daGAUR.Fill(dsGAUR);
                dtGAUR = dsGAUR.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAUR.Close();
            }
            finally
            {
                //conGAUR.Close();
            }

            return dtGAUR;
        }

        public DataTable GetSpecificUserRole(string sRoleName)
        {
            DataSet dsGSUR = new DataSet();
            DataTable dtGSUR = new DataTable();

            SqlConnection conGSUR = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSUR = new SqlCommand("spGetSpecificRole", conGSUR);
                cmdGSUR.CommandType = CommandType.StoredProcedure;
                cmdGSUR.Parameters.AddWithValue("@RoleName", sRoleName);

                SqlDataAdapter daGSUR = new SqlDataAdapter(cmdGSUR);
                dsGSUR = new DataSet();
                daGSUR.Fill(dsGSUR);
                dtGSUR = dsGSUR.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSUR.Close();
            }
            finally
            {
                //conGSUR.Close();
            }

            return dtGSUR;
        }

        public DataTable GetSpecificRoleDetails(string sRoleName)
        {
            DataSet dsGSRD = new DataSet();
            DataTable dtGSRD = new DataTable();

            SqlConnection conGSRD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSRD = new SqlCommand("spGetSpecificRoleDetails", conGSRD);
                cmdGSRD.CommandType = CommandType.StoredProcedure;
                cmdGSRD.Parameters.AddWithValue("@RoleName", sRoleName);

                SqlDataAdapter daGSRD = new SqlDataAdapter(cmdGSRD);
                dsGSRD = new DataSet();
                daGSRD.Fill(dsGSRD);
                dtGSRD = dsGSRD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSRD.Close();
            }
            finally
            {
                //conGSRD.Close();
            }

            return dtGSRD;
        }

        public DataTable GetAllUserAccess()
        {
            DataSet dsGAUA = new DataSet();
            DataTable dtGAUA = new DataTable();

            SqlConnection conGAUA = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAUA = new SqlCommand("spGetAllUserAccess", conGAUA);
                cmdGAUA.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAUA = new SqlDataAdapter(cmdGAUA);
                dsGAUA = new DataSet();
                daGAUA.Fill(dsGAUA);
                dtGAUA = dsGAUA.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAUA.Close();
            }
            finally
            {
                //conGAUA.Close();
            }

            return dtGAUA;
        }

        public DataTable GetSpecificUserAccess(string sUserId)
        {
            DataSet dsGSUA = new DataSet();
            DataTable dtGSUA = new DataTable();

            SqlConnection conGSUA = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSUA = new SqlCommand("spGetSpecificUserAccess", conGSUA);
                cmdGSUA.CommandType = CommandType.StoredProcedure;
                cmdGSUA.Parameters.AddWithValue("@UserId", sUserId);

                SqlDataAdapter daGSUA = new SqlDataAdapter(cmdGSUA);
                dsGSUA = new DataSet();
                daGSUA.Fill(dsGSUA);
                dtGSUA = dsGSUA.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSUA.Close();
            }
            finally
            {
                //conGSUA.Close();
            }

            return dtGSUA;
        }

        public DataTable GetSpecificRoleAccess(string sRoleName)
        {
            DataSet dsGSRA = new DataSet();
            DataTable dtGSRA = new DataTable();

            SqlConnection conGSRA = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSRA = new SqlCommand("spGetSpecificRoleAccess", conGSRA);
                cmdGSRA.CommandType = CommandType.StoredProcedure;
                cmdGSRA.Parameters.AddWithValue("@RoleName", sRoleName);

                SqlDataAdapter daGSRA = new SqlDataAdapter(cmdGSRA);
                dsGSRA = new DataSet();
                daGSRA.Fill(dsGSRA);
                dtGSRA = dsGSRA.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSRA.Close();
            }
            finally
            {
                //conGSRA.Close();
            }

            return dtGSRA;
        }

        public DataTable GetSpecificUserMenuItemsAccess(string sUserId, string sRoleId)
        {
            DataSet dsGSUMIA = new DataSet();
            DataTable dtGSUMIA = new DataTable();

            SqlConnection conGSUMIA = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSUMIA = new SqlCommand("spGetSpecificUserMenuItemsAccess", conGSUMIA);
                cmdGSUMIA.CommandType = CommandType.StoredProcedure;
                cmdGSUMIA.Parameters.AddWithValue("@UserId", sUserId);
                cmdGSUMIA.Parameters.AddWithValue("@RoleId", sRoleId);

                SqlDataAdapter daGSUMIA = new SqlDataAdapter(cmdGSUMIA);
                dsGSUMIA = new DataSet();
                daGSUMIA.Fill(dsGSUMIA);
                dtGSUMIA = dsGSUMIA.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSUMIA.Close();
            }
            finally
            {
                //conGSUMIA.Close();
            }

            return dtGSUMIA;
        }

        public DataTable GetSpecificUserPageControlsAccess(string sUserId, string sRoleId, int iMenuId)
        {
            DataSet dsGSUPCA = new DataSet();
            DataTable dtGSUPCA = new DataTable();

            SqlConnection conGSUPCA = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSUPCA = new SqlCommand("spGetSpecificUserPageControlsAccess", conGSUPCA);
                cmdGSUPCA.CommandType = CommandType.StoredProcedure;
                cmdGSUPCA.Parameters.AddWithValue("@UserId", sUserId);
                cmdGSUPCA.Parameters.AddWithValue("@RoleId", sRoleId);
                cmdGSUPCA.Parameters.AddWithValue("@Menu_ID", iMenuId);

                SqlDataAdapter daGSUPCA = new SqlDataAdapter(cmdGSUPCA);
                dsGSUPCA = new DataSet();
                daGSUPCA.Fill(dsGSUPCA);
                dtGSUPCA = dsGSUPCA.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSUPCA.Close();
            }
            finally
            {
                //conGSUPCA.Close();
            }

            return dtGSUPCA;
        }

        public DataTable GetAllAssignedBookings(string DriverId, string OptionType)
        {
            DataSet dsGAAB = new DataSet();
            DataTable dtGAAB = new DataTable();

            SqlConnection conGAAB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAAB = new SqlCommand("spGetAllAssignedBookings", conGAAB);
                cmdGAAB.CommandType = CommandType.StoredProcedure;
                cmdGAAB.Parameters.AddWithValue("@DriverId", DriverId);
                cmdGAAB.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daGAAB = new SqlDataAdapter(cmdGAAB);
                dsGAAB = new DataSet();
                daGAAB.Fill(dsGAAB);
                dtGAAB = dsGAAB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAAB.Close();
            }
            finally
            {
                //conGAAB.Close();
            }

            return dtGAAB;
        }

        public DataTable GetAllUnassignedSpecificBookings(DateTime FromDate, DateTime ToDate, string OptionType)
        {
            DataSet dsGAUSB = new DataSet();
            DataTable dtGAUSB = new DataTable();

            SqlConnection conGAUSB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAUSB = new SqlCommand("spGetAllUnassignedSpecificBookings", conGAUSB);
                cmdGAUSB.CommandType = CommandType.StoredProcedure;
                cmdGAUSB.Parameters.AddWithValue("@FromDate", FromDate);
                cmdGAUSB.Parameters.AddWithValue("@ToDate", ToDate);
                cmdGAUSB.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daGAUSB = new SqlDataAdapter(cmdGAUSB);
                dsGAUSB = new DataSet();
                daGAUSB.Fill(dsGAUSB);
                dtGAUSB = dsGAUSB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAUSB.Close();
            }
            finally
            {
                //conGAUSB.Close();
            }

            return dtGAUSB;
        }

        public DataTable GetItemwiseSpecificBookings(DateTime FromDate, DateTime ToDate)
        {
            DataSet dsGISB = new DataSet();
            DataTable dtGISB = new DataTable();

            SqlConnection conGISB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGISB = new SqlCommand("spGetItemwiseSpecificBookings", conGISB);
                cmdGISB.CommandType = CommandType.StoredProcedure;
                cmdGISB.Parameters.AddWithValue("@FromDate", FromDate);
                cmdGISB.Parameters.AddWithValue("@ToDate", ToDate);

                SqlDataAdapter daGISB = new SqlDataAdapter(cmdGISB);
                dsGISB = new DataSet();
                daGISB.Fill(dsGISB);
                dtGISB = dsGISB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGISB.Close();
            }
            finally
            {
                //conGISB.Close();
            }

            return dtGISB;
        }

        public DataTable GetSpecificDriverPayments(DateTime FromDate, DateTime ToDate)
        {
            DataSet dsGSDP = new DataSet();
            DataTable dtGSDP = new DataTable();

            SqlConnection conGSDP = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSDP = new SqlCommand("spGetSpecificDriverPayments", conGSDP);
                cmdGSDP.CommandType = CommandType.StoredProcedure;
                cmdGSDP.Parameters.AddWithValue("@FromDate", FromDate);
                cmdGSDP.Parameters.AddWithValue("@ToDate", ToDate);

                SqlDataAdapter daGSDP = new SqlDataAdapter(cmdGSDP);
                dsGSDP = new DataSet();
                daGSDP.Fill(dsGSDP);
                dtGSDP = dsGSDP.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSDP.Close();
            }
            finally
            {
                //conGSDP.Close();
            }

            return dtGSDP;
        }

        public DataTable GetAllAssignedDriverJobs(DateTime FromDate, DateTime ToDate, string OptionType)
        {
            DataSet dsGAADJ = new DataSet();
            DataTable dtGAADJ = new DataTable();

            SqlConnection conGAADJ = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAADJ = new SqlCommand("spGetAllAssignedDriverJobs", conGAADJ);
                cmdGAADJ.CommandType = CommandType.StoredProcedure;
                cmdGAADJ.Parameters.AddWithValue("@FromDate", FromDate);
                cmdGAADJ.Parameters.AddWithValue("@ToDate", ToDate);
                cmdGAADJ.Parameters.AddWithValue("@OptionType", OptionType);

                SqlDataAdapter daGAADJ = new SqlDataAdapter(cmdGAADJ);
                dsGAADJ = new DataSet();
                daGAADJ.Fill(dsGAADJ);
                dtGAADJ = dsGAADJ.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAADJ.Close();
            }
            finally
            {
                //conGAADJ.Close();
            }

            return dtGAADJ;
        }

        public DataTable GetAllQuotations()
        {
            DataSet dsGAQ = new DataSet();
            DataTable dtGAQ = new DataTable();

            SqlConnection conGAQ = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAQ = new SqlCommand("spGetAllQuotations", conGAQ);
                cmdGAQ.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAQ = new SqlDataAdapter(cmdGAQ);
                dsGAQ = new DataSet();
                daGAQ.Fill(dsGAQ);
                dtGAQ = dsGAQ.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAQ.Close();
            }
            finally
            {
                //conGAQ.Close();
            }

            return dtGAQ;
        }

        public DataTable GetAllOfMyBookings(string sEmailID)
        {
            DataSet dsGAOMB = new DataSet();
            DataTable dtGAOMB = new DataTable();

            SqlConnection conGAOMB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAOMB = new SqlCommand("spGetAllOfMyBookings", conGAOMB);
                cmdGAOMB.CommandType = CommandType.StoredProcedure;
                cmdGAOMB.Parameters.AddWithValue("@EmailID", sEmailID);

                SqlDataAdapter daGAOMB = new SqlDataAdapter(cmdGAOMB);
                dsGAOMB = new DataSet();
                daGAOMB.Fill(dsGAOMB);
                dtGAOMB = dsGAOMB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAOMB.Close();
            }
            finally
            {
                //conGAOMB.Close();
            }

            return dtGAOMB;
        }

        public DataTable GetMyBookings(string sBookingId)
        {
            DataSet dsGMB = new DataSet();
            DataTable dtGMB = new DataTable();

            SqlConnection conGMB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGMB = new SqlCommand("spGetMyBookings", conGMB);
                cmdGMB.CommandType = CommandType.StoredProcedure;
                cmdGMB.Parameters.AddWithValue("@BookingId", sBookingId);

                SqlDataAdapter daGMB = new SqlDataAdapter(cmdGMB);
                dsGMB = new DataSet();
                daGMB.Fill(dsGMB);
                dtGMB = dsGMB.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGMB.Close();
            }
            finally
            {
                //conGMB.Close();
            }

            return dtGMB;
        }

        public DataTable GetMyBookingDetails(string sBookingId)
        {
            DataSet dsGMBD = new DataSet();
            DataTable dtGMBD = new DataTable();

            SqlConnection conGMBD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGMBD = new SqlCommand("spGetMyBookingDetails", conGMBD);
                cmdGMBD.CommandType = CommandType.StoredProcedure;
                cmdGMBD.Parameters.AddWithValue("@BookingId", sBookingId);

                SqlDataAdapter daGMBD = new SqlDataAdapter(cmdGMBD);
                dsGMBD = new DataSet();
                daGMBD.Fill(dsGMBD);
                dtGMBD = dsGMBD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGMBD.Close();
            }
            finally
            {
                //conGMBD.Close();
            }

            return dtGMBD;
        }

        public DataTable GetAllOfMyQuotations(string sEmailID)
        {
            DataSet dsGAOMQ = new DataSet();
            DataTable dtGAOMQ = new DataTable();

            SqlConnection conGAOMQ = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAOMQ = new SqlCommand("spGetAllOfMyQuotations", conGAOMQ);
                cmdGAOMQ.CommandType = CommandType.StoredProcedure;
                cmdGAOMQ.Parameters.AddWithValue("@EmailID", sEmailID);

                SqlDataAdapter daGAOMQ = new SqlDataAdapter(cmdGAOMQ);
                dsGAOMQ = new DataSet();
                daGAOMQ.Fill(dsGAOMQ);
                dtGAOMQ = dsGAOMQ.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAOMQ.Close();
            }
            finally
            {
                //conGAOMQ.Close();
            }

            return dtGAOMQ;
        }

        public DataTable GetMyQuotations(string sQuoteId)
        {
            DataSet dsGMQ = new DataSet();
            DataTable dtGMQ = new DataTable();

            SqlConnection conGMQ = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGMQ = new SqlCommand("spGetMyQuotations", conGMQ);
                cmdGMQ.CommandType = CommandType.StoredProcedure;
                cmdGMQ.Parameters.AddWithValue("@QuoteId", sQuoteId);

                SqlDataAdapter daGMQ = new SqlDataAdapter(cmdGMQ);
                dsGMQ = new DataSet();
                daGMQ.Fill(dsGMQ);
                dtGMQ = dsGMQ.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGMQ.Close();
            }
            finally
            {
                //conGMQ.Close();
            }

            return dtGMQ;
        }

        public DataTable GetAllBookingIds(string s)
        {
            DataSet dsGABI = new DataSet();
            DataTable dtGABI = new DataTable();

            SqlConnection conGABI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABI = new SqlCommand("spGetAllBookingIds", conGABI);
                cmdGABI.CommandType = CommandType.StoredProcedure;
                cmdGABI.Parameters.AddWithValue("@AddOrEdit", s);
                SqlDataAdapter da = new SqlDataAdapter(cmdGABI);
                dsGABI = new DataSet();
                da.Fill(dsGABI);
                dtGABI = dsGABI.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABI.Close();
            }
            finally
            {
                //conGABI.Close();
            }

            return dtGABI;
        }

        public DataTable GetAllContainerType()
        {
            DataTable dt = new DataTable();
            SqlConnection conGABI = new SqlConnection(sConnectionString);

            try
            {   
                SqlCommand cmdGABI = new SqlCommand("Select Id As ContainerTypeId, ContainerName As ContainerType From ContainerType", conGABI);
                SqlDataAdapter da = new SqlDataAdapter(cmdGABI);
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABI.Close();
            }
            finally
            {
                //conGABI.Close();
            }

            return dt;
        }
        public DataTable GetAllContainerNumber()
        {
            DataSet dsGABI = new DataSet();
            DataTable dtGABI = new DataTable();

            SqlConnection conGABI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABI = new SqlCommand("spGetAllContainerNumbers", conGABI);
                cmdGABI.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmdGABI);
                dsGABI = new DataSet();
                da.Fill(dsGABI);
                dtGABI = dsGABI.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABI.Close();
            }
            finally
            {
                //conGABI.Close();
            }

            return dtGABI;
        }


        public DataTable GetAllBookingById(string sBookingId)
        {
            DataSet dsGABBI = new DataSet();
            DataTable dtGABBI = new DataTable();

            SqlConnection conGABBI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBI = new SqlCommand("spGetAllBookingById", conGABBI);
                cmdGABBI.CommandType = CommandType.StoredProcedure;
                cmdGABBI.Parameters.AddWithValue("@BookingId", sBookingId);

                SqlDataAdapter daGABBI = new SqlDataAdapter(cmdGABBI);
                dsGABBI = new DataSet();
                daGABBI.Fill(dsGABBI);
                dtGABBI = dsGABBI.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBI.Close();
            }
            finally
            {
                //conGABBI.Close();
            }

            return dtGABBI;
        }

        public DataTable GetAllBookingByIdAndDate(string sBookingId,
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGABBIAD = new DataSet();
            DataTable dtGABBIAD = new DataTable();

            SqlConnection conGABBIAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBIAD = new SqlCommand("spGetAllBookingByIdAndDate", conGABBIAD);
                cmdGABBIAD.CommandType = CommandType.StoredProcedure;
                cmdGABBIAD.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdGABBIAD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGABBIAD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGABBIAD = new SqlDataAdapter(cmdGABBIAD);
                dsGABBIAD = new DataSet();
                daGABBIAD.Fill(dsGABBIAD);
                dtGABBIAD = dsGABBIAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBIAD.Close();
            }
            finally
            {
                //conGABBIAD.Close();
            }

            return dtGABBIAD;
        }

        public DataTable GetSelectedBookingById(string sBookingId, string sEmailID)
        {
            DataSet dsGSBBI = new DataSet();
            DataTable dtGSBBI = new DataTable();

            SqlConnection conGSBBI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBI = new SqlCommand("spGetSelectedBookingById", conGSBBI);
                cmdGSBBI.CommandType = CommandType.StoredProcedure;
                cmdGSBBI.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdGSBBI.Parameters.AddWithValue("@EmailID", sEmailID);

                SqlDataAdapter daGSBBI = new SqlDataAdapter(cmdGSBBI);
                dsGSBBI = new DataSet();
                daGSBBI.Fill(dsGSBBI);
                dtGSBBI = dsGSBBI.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBI.Close();
            }
            finally
            {
                //conGSBBI.Close();
            }

            return dtGSBBI;
        }

        public DataTable GetSelectedBookingByIdAndDate(string sBookingId, string sEmailID, 
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGSBBIAD = new DataSet();
            DataTable dtGSBBIAD = new DataTable();

            SqlConnection conGSBBIAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBIAD = new SqlCommand("spGetSelectedBookingByIdAndDate", conGSBBIAD);
                cmdGSBBIAD.CommandType = CommandType.StoredProcedure;
                cmdGSBBIAD.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdGSBBIAD.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdGSBBIAD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGSBBIAD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGSBBIAD = new SqlDataAdapter(cmdGSBBIAD);
                dsGSBBIAD = new DataSet();
                daGSBBIAD.Fill(dsGSBBIAD);
                dtGSBBIAD = dsGSBBIAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBIAD.Close();
            }
            finally
            {
                //conGSBBIAD.Close();
            }

            return dtGSBBIAD;
        }

        public DataTable GetSelectedBookingByIdBasedOnStatus(string sBookingId, string sOrderStatus)
        {
            DataSet dsGSBBIAD = new DataSet();
            DataTable dtGSBBIAD = new DataTable();

            SqlConnection conGSBBIAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBIAD = new SqlCommand("spGetSelectedBookingByIdBasedOnStatus", conGSBBIAD);
                cmdGSBBIAD.CommandType = CommandType.StoredProcedure;
                cmdGSBBIAD.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdGSBBIAD.Parameters.AddWithValue("@OrderStatus", sOrderStatus);

                SqlDataAdapter daGSBBIAD = new SqlDataAdapter(cmdGSBBIAD);
                dsGSBBIAD = new DataSet();
                daGSBBIAD.Fill(dsGSBBIAD);
                dtGSBBIAD = dsGSBBIAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBIAD.Close();
            }
            finally
            {
                //conGSBBIAD.Close();
            }

            return dtGSBBIAD;
        }

        public DataTable GetAllBookingByName(string sCustomerName)
        {
            DataSet dsGABBN = new DataSet();
            DataTable dtGABBN = new DataTable();

            SqlConnection conGABBN = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBN = new SqlCommand("spGetAllBookingByName", conGABBN);
                cmdGABBN.CommandType = CommandType.StoredProcedure;
                cmdGABBN.Parameters.AddWithValue("@CustomerName", sCustomerName);

                SqlDataAdapter daGABBN = new SqlDataAdapter(cmdGABBN);
                dsGABBN = new DataSet();
                daGABBN.Fill(dsGABBN);
                dtGABBN = dsGABBN.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBN.Close();
            }
            finally
            {
                //conGABBN.Close();
            }

            return dtGABBN;
        }

        public DataTable GetAllBookingIdsFromCustomerId(string sCustomerId)
        {
            DataSet dsGABIFCI = new DataSet();
            DataTable dtGABIFCI = new DataTable();

            SqlConnection conGABIFCI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABIFCI = new SqlCommand("spGetAllBookingIdsFromCustomerId", conGABIFCI);
                cmdGABIFCI.CommandType = CommandType.StoredProcedure;
                cmdGABIFCI.Parameters.AddWithValue("@CustomerId", sCustomerId);

                SqlDataAdapter daGABIFCI = new SqlDataAdapter(cmdGABIFCI);
                dsGABIFCI = new DataSet();
                daGABIFCI.Fill(dsGABIFCI);
                dtGABIFCI = dsGABIFCI.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABIFCI.Close();
            }
            finally
            {
                //conGABIFCI.Close();
            }

            return dtGABIFCI;
        }

        public DataTable GetAllBookingByNameAndDate(string sCustomerName,
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGABBNAD = new DataSet();
            DataTable dtGABBNAD = new DataTable();

            SqlConnection conGABBNAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBNAD = new SqlCommand("spGetAllBookingByNameAndDate", conGABBNAD);
                cmdGABBNAD.CommandType = CommandType.StoredProcedure;
                cmdGABBNAD.Parameters.AddWithValue("@CustomerName", sCustomerName);
                cmdGABBNAD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGABBNAD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGABBNAD = new SqlDataAdapter(cmdGABBNAD);
                dsGABBNAD = new DataSet();
                daGABBNAD.Fill(dsGABBNAD);
                dtGABBNAD = dsGABBNAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBNAD.Close();
            }
            finally
            {
                //conGABBNAD.Close();
            }

            return dtGABBNAD;
        }

        public DataTable GetSelectedBookingByName(string sCustomerName, string sEmailID)
        {
            DataSet dsGSBBN = new DataSet();
            DataTable dtGSBBN = new DataTable();

            SqlConnection conGSBBN = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBN = new SqlCommand("spGetSelectedBookingByName", conGSBBN);
                cmdGSBBN.CommandType = CommandType.StoredProcedure;
                cmdGSBBN.Parameters.AddWithValue("@CustomerName", sCustomerName);
                cmdGSBBN.Parameters.AddWithValue("@EmailID", sEmailID);

                SqlDataAdapter daGSBBN = new SqlDataAdapter(cmdGSBBN);
                dsGSBBN = new DataSet();
                daGSBBN.Fill(dsGSBBN);
                dtGSBBN = dsGSBBN.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBN.Close();
            }
            finally
            {
                //conGSBBN.Close();
            }

            return dtGSBBN;
        }

        public DataTable GetSelectedBookingByNameAndDate(string sCustomerName, string sEmailID,
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGSBBNAD = new DataSet();
            DataTable dtGSBBNAD = new DataTable();

            SqlConnection conGSBBNAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBNAD = new SqlCommand("spGetSelectedBookingByNameAndDate", conGSBBNAD);
                cmdGSBBNAD.CommandType = CommandType.StoredProcedure;
                cmdGSBBNAD.Parameters.AddWithValue("@CustomerName", sCustomerName);
                cmdGSBBNAD.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdGSBBNAD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGSBBNAD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGSBBNAD = new SqlDataAdapter(cmdGSBBNAD);
                dsGSBBNAD = new DataSet();
                daGSBBNAD.Fill(dsGSBBNAD);
                dtGSBBNAD = dsGSBBNAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBNAD.Close();
            }
            finally
            {
                //conGSBBNAD.Close();
            }

            return dtGSBBNAD;
        }

        public DataTable GetSelectedBookingByNameBasedOnStatus(string sPickupName, string sOrderStatus)
        {
            DataSet dsGSBBNBOS = new DataSet();
            DataTable dtGSBBNBOS = new DataTable();

            SqlConnection conGSBBNBOS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBNBOS = new SqlCommand("spGetSelectedBookingByNameBasedOnStatus", conGSBBNBOS);
                cmdGSBBNBOS.CommandType = CommandType.StoredProcedure;
                cmdGSBBNBOS.Parameters.AddWithValue("@PickupName", sPickupName);
                cmdGSBBNBOS.Parameters.AddWithValue("@OrderStatus", sOrderStatus);

                SqlDataAdapter daGSBBNBOS = new SqlDataAdapter(cmdGSBBNBOS);
                dsGSBBNBOS = new DataSet();
                daGSBBNBOS.Fill(dsGSBBNBOS);
                dtGSBBNBOS = dsGSBBNBOS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBNBOS.Close();
            }
            finally
            {
                //conGSBBNBOS.Close();
            }

            return dtGSBBNBOS;
        }

        public DataTable GetSelectedBookingByStatus(string sEmailID, string sOrderStatus)
        {
            DataSet dsGSBBS = new DataSet();
            DataTable dtGSBBS = new DataTable();

            SqlConnection conGSBBS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBS = new SqlCommand("spGetSelectedBookingByStatus", conGSBBS);
                cmdGSBBS.CommandType = CommandType.StoredProcedure;
                cmdGSBBS.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdGSBBS.Parameters.AddWithValue("@OrderStatus", sOrderStatus);

                SqlDataAdapter daGSBBS = new SqlDataAdapter(cmdGSBBS);
                dsGSBBS = new DataSet();
                daGSBBS.Fill(dsGSBBS);
                dtGSBBS = dsGSBBS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBS.Close();
            }
            finally
            {
                //conGSBBS.Close();
            }

            return dtGSBBS;
        }

        public DataTable GetSelectedBookingByStatusAndDate(string sOrderStatus, string sEmailID, 
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGSBBSAD = new DataSet();
            DataTable dtGSBBSAD = new DataTable();

            SqlConnection conGSBBSAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBSAD = new SqlCommand("spGetSelectedBookingByStatusAndDate", conGSBBSAD);
                cmdGSBBSAD.CommandType = CommandType.StoredProcedure;
                cmdGSBBSAD.Parameters.AddWithValue("@OrderStatus", sOrderStatus);
                cmdGSBBSAD.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdGSBBSAD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGSBBSAD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGSBBSAD = new SqlDataAdapter(cmdGSBBSAD);
                dsGSBBSAD = new DataSet();
                daGSBBSAD.Fill(dsGSBBSAD);
                dtGSBBSAD = dsGSBBSAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBSAD.Close();
            }
            finally
            {
                //conGSBBSAD.Close();
            }

            return dtGSBBSAD;
        }

        public DataTable GetAllBookingByStatus(string sOrderStatus)
        {
            DataSet dsGABBS = new DataSet();
            DataTable dtGABBS = new DataTable();

            SqlConnection conGABBS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBS = new SqlCommand("spGetAllBookingByStatus", conGABBS);
                cmdGABBS.CommandType = CommandType.StoredProcedure;
                cmdGABBS.Parameters.AddWithValue("@OrderStatus", sOrderStatus);

                SqlDataAdapter daGABBS = new SqlDataAdapter(cmdGABBS);
                dsGABBS = new DataSet();
                daGABBS.Fill(dsGABBS);
                dtGABBS = dsGABBS.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBS.Close();
            }
            finally
            {
                //conGABBS.Close();
            }

            return dtGABBS;
        }

        public DataTable GetAllBookingByStatusAndDate(string sOrderStatus,
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGABBSAD = new DataSet();
            DataTable dtGABBSAD = new DataTable();

            SqlConnection conGABBSAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBSAD = new SqlCommand("spGetAllBookingByStatusAndDate", conGABBSAD);
                cmdGABBSAD.CommandType = CommandType.StoredProcedure;
                cmdGABBSAD.Parameters.AddWithValue("@OrderStatus", sOrderStatus);
                cmdGABBSAD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGABBSAD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGABBSAD = new SqlDataAdapter(cmdGABBSAD);
                dsGABBSAD = new DataSet();
                daGABBSAD.Fill(dsGABBSAD);
                dtGABBSAD = dsGABBSAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBSAD.Close();
            }
            finally
            {
                //conGABBSAD.Close();
            }

            return dtGABBSAD;
        }

        public DataTable GetSelectedBookingByFromAndToDate(string sEmailID, 
            string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGSBBFATD = new DataSet();
            DataTable dtGSBBFATD = new DataTable();

            SqlConnection conGSBBFATD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBBFATD = new SqlCommand("spGetSelectedBookingByFromAndToDate", conGSBBFATD);
                cmdGSBBFATD.CommandType = CommandType.StoredProcedure;
                cmdGSBBFATD.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdGSBBFATD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGSBBFATD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGSBBFATD = new SqlDataAdapter(cmdGSBBFATD);
                dsGSBBFATD = new DataSet();
                daGSBBFATD.Fill(dsGSBBFATD);
                dtGSBBFATD = dsGSBBFATD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBBFATD.Close();
            }
            finally
            {
                //conGSBBFATD.Close();
            }

            return dtGSBBFATD;
        }

        public DataTable GetAllBookingByDate(string sFromDateANSI, string sToDateANSI)
        {
            DataSet dsGABBD = new DataSet();
            DataTable dtGABBD = new DataTable();

            SqlConnection conGABBD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGABBD = new SqlCommand("spGetAllBookingByDate", conGABBD);
                cmdGABBD.CommandType = CommandType.StoredProcedure;
                cmdGABBD.Parameters.AddWithValue("@FromDate", sFromDateANSI);
                cmdGABBD.Parameters.AddWithValue("@ToDate", sToDateANSI);

                SqlDataAdapter daGABBD = new SqlDataAdapter(cmdGABBD);
                dsGABBD = new DataSet();
                daGABBD.Fill(dsGABBD);
                dtGABBD = dsGABBD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGABBD.Close();
            }
            finally
            {
                //conGABBD.Close();
            }

            return dtGABBD;
        }

        public DataTable GetSpecificCities(string CountryId)
        {
            DataSet dsSC = new DataSet();
            DataTable dtSC = new DataTable();

            SqlConnection conSC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdSC = new SqlCommand("spGetSpecificCities", conSC);
                cmdSC.CommandType = CommandType.StoredProcedure;
                cmdSC.Parameters.AddWithValue("@CountryId", CountryId);

                SqlDataAdapter daSC = new SqlDataAdapter(cmdSC);
                daSC.Fill(dsSC);
                dtSC = dsSC.Tables[0];
            }
            catch(Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conSC.Close();
            }
            finally
            {
                //conSC.Close();
            }

            return dtSC;
        }

        public DataTable GetSpecificLocations(string CityId)
        {
            DataSet dsSL = new DataSet();
            DataTable dtSL = new DataTable();

            SqlConnection conSL = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdSL = new SqlCommand("spGetSpecificLocations", conSL);
                cmdSL.CommandType = CommandType.StoredProcedure;
                cmdSL.Parameters.AddWithValue("@CityId", CityId);

                SqlDataAdapter daSL = new SqlDataAdapter(cmdSL);
                daSL.Fill(dsSL);
                dtSL = dsSL.Tables[0];
            }
            catch(Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conSL.Close();
            }
            finally
            {
                //conSL.Close();
            }

            return dtSL;
        }

        public DataTable GetAllLocations()
        {
            DataSet dsGAL = new DataSet();
            DataTable dtGAL = new DataTable();

            SqlConnection conGAL = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAL = new SqlCommand("spGetAllLocations", conGAL);
                cmdGAL.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAL = new SqlDataAdapter(cmdGAL);
                dsGAL = new DataSet();
                daGAL.Fill(dsGAL);
                dtGAL = dsGAL.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAL.Close();
            }
            finally
            {
                //conGAL.Close();
            }

            return dtGAL;
        }

        public DataTable GetAllZones()
        {
            DataSet dsGAZ = new DataSet();
            DataTable dtGAZ = new DataTable();

            SqlConnection conGAZ = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAZ = new SqlCommand("spGetAllZones", conGAZ);
                cmdGAZ.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAZ = new SqlDataAdapter(cmdGAZ);
                dsGAZ = new DataSet();
                daGAZ.Fill(dsGAZ);
                dtGAZ = dsGAZ.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAZ.Close();
            }
            finally
            {
                //conGAZ.Close();
            }

            return dtGAZ;
        }
        public DataTable GetAllZones(string WarehouseLocationId)
        {
            DataSet dsGAZ = new DataSet();
            DataTable dtGAZ = new DataTable();

            SqlConnection conGAZ = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAZ = new SqlCommand("spGetAllZones", conGAZ);
                cmdGAZ.CommandType = CommandType.StoredProcedure;
                cmdGAZ.Parameters.AddWithValue("@WarehouseLocationId", WarehouseLocationId);

                SqlDataAdapter daGAZ = new SqlDataAdapter(cmdGAZ);
                dsGAZ = new DataSet();
                daGAZ.Fill(dsGAZ);
                dtGAZ = dsGAZ.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAZ.Close();
            }
            finally
            {
                //conGAZ.Close();
            }

            return dtGAZ;
        }
        public DataTable GetAllWarehouses()
        {
            DataSet dsGAW = new DataSet();
            DataTable dtGAW = new DataTable();

            SqlConnection conGAW = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAW = new SqlCommand("spGetAllWarehouses", conGAW);
                cmdGAW.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAW = new SqlDataAdapter(cmdGAW);
                dsGAW = new DataSet();
                daGAW.Fill(dsGAW);
                dtGAW = dsGAW.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAW.Close();
            }
            finally
            {
                //conGAW.Close();
            }

            return dtGAW;
        }

        public DataTableResponse GetAllCustomersServerSide(DataTableParameter dtParams, string Search)
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();
            DataTable dtFilterTotal = new DataTable();
            DataTableResponse dtResponse = new DataTableResponse();
            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetAllCustomers", conGAC);
                cmdGAC.Parameters.AddWithValue("@PageIndex", dtParams.start);
                cmdGAC.Parameters.AddWithValue("@PageSize", dtParams.length);
                cmdGAC.Parameters.AddWithValue("@Search", Search);
                cmdGAC.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
                if(dsGAC.Tables[1] != null)
                {
                    dtFilterTotal = dsGAC.Tables[1];
                }
                
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }
            List<dtData> lstData = dtGAC.AsEnumerable()
                                  .Select(x => new dtData()
                                  {
                                      CustomerId = x.Field<string>("CustomerId"),
                                      CustomerName = x.Field<string>("CustomerName"),
                                      EmailID = x.Field<string>("EmailID"),
                                      DOB = x.Field<DateTime>("DOB"),
                                      Address = x.Field<string>("Address"),
                                      Mobile = x.Field<string>("Mobile"),
                                      //PostCode = x.Field<string>("PostCode"),
                                      //LatitudePickup = x.Field<decimal>("LatitudePickup"),
                                      //LongitudePickup = x.Field<decimal>("LongitudePickup"),
                                      //Title = x.Field<string>("Title"),
                                      //sDOB = x.Field<string>("sDOB"),
                                  }).ToList();
            dtResponse.data = lstData;
            dtResponse.recordsFiltered = lstData.Count;
            dtResponse.recordsTotal = Convert.ToInt32(dtFilterTotal.Rows[0][0]);
            dtResponse.draw = dtParams.draw;
            return dtResponse;
        }
        public DataTable GetAllCustomers()
        {
            DataSet dsGAC = new DataSet();
            DataTable dtGAC = new DataTable();

            SqlConnection conGAC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAC = new SqlCommand("spGetAllCustomers", conGAC);
                cmdGAC.Parameters.AddWithValue("@PageIndex", 1);
                cmdGAC.Parameters.AddWithValue("@PageSize", 40000);
                cmdGAC.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAC = new SqlDataAdapter(cmdGAC);
                dsGAC = new DataSet();
                daGAC.Fill(dsGAC);
                dtGAC = dsGAC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAC.Close();
            }
            finally
            {
                //conGAC.Close();
            }

            return dtGAC;
        }

        public DataTable GetAllDrivers(string OptionType)
        {
            DataSet dsGAD = new DataSet();
            DataTable dtGAD = new DataTable();

            SqlConnection conGAD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAD = new SqlCommand("spGetAllDrivers", conGAD);
                cmdGAD.Parameters.AddWithValue("@OptionType", OptionType);
                
                cmdGAD.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAD = new SqlDataAdapter(cmdGAD);
                dsGAD = new DataSet();
                daGAD.Fill(dsGAD);
                dtGAD = dsGAD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAD.Close();
            }
            finally
            {
                //conGAD.Close();
            }

            return dtGAD;
        }

        public DataTable GetAllDriverPayments()
        {
            DataSet dsGADP = new DataSet();
            DataTable dtGADP = new DataTable();

            SqlConnection conGADP = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGADP = new SqlCommand("spGetAllDriverPayments", conGADP);
                cmdGADP.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGADP = new SqlDataAdapter(cmdGADP);
                dsGADP = new DataSet();
                daGADP.Fill(dsGADP);
                dtGADP = dsGADP.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGADP.Close();
            }
            finally
            {
                //conGADP.Close();
            }

            return dtGADP;
        }

        public DataTable GetSelectedBookPickup(string sBookingId, string sCustomerId)
        {
            DataSet dsGSBP = new DataSet();
            DataTable dtGSBP = new DataTable();

            SqlConnection conGSBP = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBP = new SqlCommand("spGetSelectedBookPickup", conGSBP);
                cmdGSBP.CommandType = CommandType.StoredProcedure;
                cmdGSBP.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdGSBP.Parameters.AddWithValue("@CustomerId", sCustomerId);

                SqlDataAdapter daGSBP = new SqlDataAdapter(cmdGSBP);
                dsGSBP = new DataSet();
                daGSBP.Fill(dsGSBP);
                dtGSBP = dsGSBP.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBP.Close();
            }
            finally
            {
                //conGSBP.Close();
            }

            return dtGSBP;
        }

        public DataTable GetSelectedBookPickupByVolume(string sBookingId, string sCustomerId)
        {
            DataSet dsGSBPBV = new DataSet();
            DataTable dtGSBPBV = new DataTable();

            SqlConnection conGSBPBV = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGSBPBV = new SqlCommand("spGetSelectedBookPickupByVolume", conGSBPBV);
                cmdGSBPBV.CommandType = CommandType.StoredProcedure;
                cmdGSBPBV.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdGSBPBV.Parameters.AddWithValue("@CustomerId", sCustomerId);

                SqlDataAdapter daGSBPBV = new SqlDataAdapter(cmdGSBPBV);
                dsGSBPBV = new DataSet();
                daGSBPBV.Fill(dsGSBPBV);
                dtGSBPBV = dsGSBPBV.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGSBPBV.Close();
            }
            finally
            {
                //conGSBPBV.Close();
            }

            return dtGSBPBV;
        }

        public DataTable GetPickupItemsByCategory(string sPickupCategory)
        {
            DataSet dsPIBC = new DataSet();
            DataTable dtPIBC = new DataTable();

            SqlConnection conPIBC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdPIBC = new SqlCommand("spGetPickupItemsByCategory", conPIBC);
                cmdPIBC.CommandType = CommandType.StoredProcedure;
                cmdPIBC.Parameters.AddWithValue("@PickupCategory", sPickupCategory);

                SqlDataAdapter daPIBC = new SqlDataAdapter(cmdPIBC);
                daPIBC.Fill(dsPIBC);
                dtPIBC = dsPIBC.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conPIBC.Close();
            }
            finally
            {
                //conPIBC.Close();
            }

            return dtPIBC;
        }

        public string GetPredefinedEstimatedValueByCategory(string sPickupCategory)
        {
            string sPredefinedEstimatedValue = "0";

            DataSet dsPEVBC = new DataSet();
            DataTable dtPEVBC = new DataTable();

            SqlConnection conPEVBC = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdPEVBC = new SqlCommand("spGetPredefinedEstimatedValueByCategory", conPEVBC);
                cmdPEVBC.CommandType = CommandType.StoredProcedure;
                cmdPEVBC.Parameters.AddWithValue("@PickupCategory", sPickupCategory);

                SqlDataAdapter daPEVBC = new SqlDataAdapter(cmdPEVBC);
                daPEVBC.Fill(dsPEVBC);
                dtPEVBC = dsPEVBC.Tables[0];

                if (dtPEVBC != null)
                {
                    if (dtPEVBC.Rows.Count > 0)
                    {
                        sPredefinedEstimatedValue
                            = dtPEVBC.Rows[0]["PredefinedEstimatedValue"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conPEVBC.Close();
            }
            finally
            {
                //conPEVBC.Close();
            }

            return sPredefinedEstimatedValue;
        }

        public string GetPredefinedEstimatedValueByItem(string sPickupItem)
        {
            string sPredefinedEstimatedValue = "0";
            DataSet dsPEVBI = new DataSet();
            DataTable dtPEVBI = new DataTable();

            SqlConnection conPEVBI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdPEVBI = new SqlCommand("spGetPredefinedEstimatedValueByItem", conPEVBI);
                cmdPEVBI.CommandType = CommandType.StoredProcedure;
                cmdPEVBI.Parameters.AddWithValue("@PickupItem", sPickupItem);

                SqlDataAdapter daPEVBI = new SqlDataAdapter(cmdPEVBI);
                daPEVBI.Fill(dsPEVBI);
                dtPEVBI = dsPEVBI.Tables[0];

                if (dtPEVBI != null)
                {
                    if (dtPEVBI.Rows.Count > 0)
                    {
                        sPredefinedEstimatedValue
                            = dtPEVBI.Rows[0]["PredefinedEstimatedValue"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conPEVBI.Close();
            }
            finally
            {
                //conPEVBI.Close();
            }

            return sPredefinedEstimatedValue;
        }

        public DataTable GetAllComplaints()
        {
            DataSet dsGAE = new DataSet();
            DataTable dtGAE = new DataTable();

            SqlConnection conGAE = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAE = new SqlCommand("spGetAllComplaints", conGAE);
                cmdGAE.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter daGAE = new SqlDataAdapter(cmdGAE);
                dsGAE = new DataSet();
                daGAE.Fill(dsGAE);
                dtGAE = dsGAE.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAE.Close();
            }
            finally
            {
                //conGAE.Close();
            }

            return dtGAE;
        }

        public DataTable GetAllInteractions(string sComplaintId)
        {
            DataSet dsGAI = new DataSet();
            DataTable dtGAI = new DataTable();

            SqlConnection conGAI = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdGAI = new SqlCommand("spGetAllInteractions", conGAI);
                cmdGAI.CommandType = CommandType.StoredProcedure;
                cmdGAI.Parameters.AddWithValue("@ComplaintId", sComplaintId);

                SqlDataAdapter daGAI = new SqlDataAdapter(cmdGAI);
                dsGAI = new DataSet();
                daGAI.Fill(dsGAI);
                dtGAI = dsGAI.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conGAI.Close();
            }
            finally
            {
                //conGAI.Close();
            }

            return dtGAI;
        }

        #endregion

        #region Add Zone

        public void AddUserDetails(User u)
        {
            SqlConnection conUser = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUser = new SqlCommand("spAddUserDetails", conUser);
                cmdUser.CommandType = CommandType.StoredProcedure;

                cmdUser.Parameters.AddWithValue("@UserId", u.UserId);
                cmdUser.Parameters.AddWithValue("@EmailID", u.EmailID);
                cmdUser.Parameters.AddWithValue("@Password", u.Password);
                cmdUser.Parameters.AddWithValue("@Title", u.Title);
                cmdUser.Parameters.AddWithValue("@FirstName", u.FirstName);
                cmdUser.Parameters.AddWithValue("@LastName", u.LastName);
                cmdUser.Parameters.AddWithValue("@DOB", u.DOB);
                cmdUser.Parameters.AddWithValue("@Address", u.Address);
                cmdUser.Parameters.AddWithValue("@Town", u.Town);
                cmdUser.Parameters.AddWithValue("@Country", u.Country);
                cmdUser.Parameters.AddWithValue("@PostCode", u.PostCode);
                cmdUser.Parameters.AddWithValue("@Mobile", u.Mobile);
                cmdUser.Parameters.AddWithValue("@Telephone", u.Telephone);
                cmdUser.Parameters.AddWithValue("@SecretQuestion", u.SecretQuestion);
                cmdUser.Parameters.AddWithValue("@SecretAnswer", u.SecretAnswer);
                cmdUser.Parameters.AddWithValue("@UserRole", u.UserRole);
                cmdUser.Parameters.AddWithValue("@WarehouseId", u.WarehouseId);
                cmdUser.Parameters.AddWithValue("@Locked", u.Locked);

                conUser.Open();
                cmdUser.ExecuteNonQuery();
                conUser.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUser.Close();
            }
            finally
            {
                conUser.Close();
            }
        }

        public void AddCustomer(Customer c)
        {
            SqlConnection conCustomer = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCustomer = new SqlCommand("spAddCustomer", conCustomer);
                cmdCustomer.CommandType = CommandType.StoredProcedure;

                cmdCustomer.Parameters.AddWithValue("@CustomerId", c.CustomerId);
                cmdCustomer.Parameters.AddWithValue("@EmailID", c.EmailID);
                cmdCustomer.Parameters.AddWithValue("@Password", c.Password);
                cmdCustomer.Parameters.AddWithValue("@Title", c.Title);
                cmdCustomer.Parameters.AddWithValue("@FirstName", c.FirstName);
                cmdCustomer.Parameters.AddWithValue("@LastName", c.LastName);
                cmdCustomer.Parameters.AddWithValue("@DOB", c.DOB);
                cmdCustomer.Parameters.AddWithValue("@Address", c.Address);
                cmdCustomer.Parameters.AddWithValue("@LatitudePickup", c.LatitudePickup);
                cmdCustomer.Parameters.AddWithValue("@LongitudePickup", c.LongitudePickup);
                cmdCustomer.Parameters.AddWithValue("@Town", c.Town);
                cmdCustomer.Parameters.AddWithValue("@Country", c.Country);
                cmdCustomer.Parameters.AddWithValue("@PostCode", c.PostCode);
                cmdCustomer.Parameters.AddWithValue("@Mobile", c.Mobile);
                cmdCustomer.Parameters.AddWithValue("@Telephone", c.Telephone);
                cmdCustomer.Parameters.AddWithValue("@HearAboutUs", c.HearAboutUs);
                cmdCustomer.Parameters.AddWithValue("@HavingRegisteredCompany", c.HavingRegisteredCompany);
                cmdCustomer.Parameters.AddWithValue("@Locked", c.Locked);
                cmdCustomer.Parameters.AddWithValue("@ShippingGoodsInCompanyName", c.ShippingGoodsInCompanyName);
                cmdCustomer.Parameters.AddWithValue("@RegisteredCompanyName", c.RegisteredCompanyName);

                conCustomer.Open();
                cmdCustomer.ExecuteNonQuery();
                conCustomer.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCustomer.Close();
            }
            finally
            {
                conCustomer.Close();
            }
        }

        public void AddDriver(Driver d)
        {
            SqlConnection conDriver = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDriver = new SqlCommand("spAddDriver", conDriver);
                cmdDriver.CommandType = CommandType.StoredProcedure;

                cmdDriver.Parameters.AddWithValue("@DriverId", d.DriverId);
                cmdDriver.Parameters.AddWithValue("@EmailID", d.EmailID);
                cmdDriver.Parameters.AddWithValue("@Password", d.Password);
                cmdDriver.Parameters.AddWithValue("@Title", d.Title);
                cmdDriver.Parameters.AddWithValue("@FirstName", d.FirstName);
                cmdDriver.Parameters.AddWithValue("@LastName", d.LastName);
                cmdDriver.Parameters.AddWithValue("@DOB", d.DOB);
                cmdDriver.Parameters.AddWithValue("@Address", d.Address);
                cmdDriver.Parameters.AddWithValue("@Town", d.Town);
                cmdDriver.Parameters.AddWithValue("@Country", d.Country);
                cmdDriver.Parameters.AddWithValue("@PostCode", d.PostCode);
                cmdDriver.Parameters.AddWithValue("@Mobile", d.Mobile);
                cmdDriver.Parameters.AddWithValue("@Landline", d.Landline);

                //Two New Fields Added
                //=================================================================
                cmdDriver.Parameters.AddWithValue("@DriverType", d.DriverType);
                cmdDriver.Parameters.AddWithValue("@WageType", d.WageType);
                cmdDriver.Parameters.AddWithValue("@WarehouseId", d.WarehouseId);
                //=================================================================

                cmdDriver.Parameters.AddWithValue("@Enabled", d.Enabled);

                conDriver.Open();
                cmdDriver.ExecuteNonQuery();
                conDriver.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDriver.Close();
            }
            finally
            {
                conDriver.Close();
            }
        }

        public void AddBooking(Booking b)
        {
            SqlConnection conBooking = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdBooking = new SqlCommand("spAddBooking", conBooking);
                cmdBooking.CommandType = CommandType.StoredProcedure;

                cmdBooking.Parameters.AddWithValue("@BookingId", b.BookingId);
                cmdBooking.Parameters.AddWithValue("@CustomerId", b.CustomerId);
                cmdBooking.Parameters.AddWithValue("@PickupCategory", b.PickupCategory);
                cmdBooking.Parameters.AddWithValue("@PickupDateTime", b.PickupDateTime);
                cmdBooking.Parameters.AddWithValue("@PickupAddress", b.PickupAddress);
                cmdBooking.Parameters.AddWithValue("@Width", b.Width);
                cmdBooking.Parameters.AddWithValue("@Height", b.Height);
                cmdBooking.Parameters.AddWithValue("@Length", b.Length);
                cmdBooking.Parameters.AddWithValue("@IsFragile", b.IsFragile);
                cmdBooking.Parameters.AddWithValue("@EstimatedValue", b.EstimatedValue);
                cmdBooking.Parameters.AddWithValue("@ItemCount", b.ItemCount);
                cmdBooking.Parameters.AddWithValue("@TotalValue", b.TotalValue);
                cmdBooking.Parameters.AddWithValue("@DeliveryCategory", b.DeliveryCategory);
                cmdBooking.Parameters.AddWithValue("@DeliveryDateTime", b.DeliveryDateTime);
                cmdBooking.Parameters.AddWithValue("@RecipientAddress", b.RecipientAddress);
                cmdBooking.Parameters.AddWithValue("@DeliveryQuantity", b.DeliveryQuantity);
                cmdBooking.Parameters.AddWithValue("@DeliveryCharge", b.DeliveryCharge);
                cmdBooking.Parameters.AddWithValue("@TotalCharge", b.TotalCharge);
                cmdBooking.Parameters.AddWithValue("@BookingNotes", b.BookingNotes);
                cmdBooking.Parameters.AddWithValue("@OrderStatus", b.OrderStatus);
                cmdBooking.Parameters.AddWithValue("@PickupItem", b.PickupItem);
                cmdBooking.Parameters.AddWithValue("@VAT", b.VAT);
                cmdBooking.Parameters.AddWithValue("@InsurancePremium", b.InsurancePremium);

                //New Parameters Added for few more Pickup and Delivery Fields
                //======================================================
                cmdBooking.Parameters.AddWithValue("@PickupName", b.PickupName);
                cmdBooking.Parameters.AddWithValue("@PickupMobile", b.PickupMobile);
                cmdBooking.Parameters.AddWithValue("@AltPickupMobile", b.AltPickupMobile);
                cmdBooking.Parameters.AddWithValue("@DeliveryName", b.DeliveryName);
                cmdBooking.Parameters.AddWithValue("@DeliveryMobile", b.DeliveryMobile);
                cmdBooking.Parameters.AddWithValue("@AltDeliveryMobile", b.AltDeliveryMobile);

                cmdBooking.Parameters.AddWithValue("@PickupPostCode", b.PickupPostCode);
                cmdBooking.Parameters.AddWithValue("@DeliveryPostCode", b.DeliveryPostCode);

                cmdBooking.Parameters.AddWithValue("@LatitudePickup", b.LatitudePickup);
                cmdBooking.Parameters.AddWithValue("@LongitudePickup", b.LongitudePickup);
                cmdBooking.Parameters.AddWithValue("@LatitudeDelivery", b.LatitudeDelivery);
                cmdBooking.Parameters.AddWithValue("@LongitudeDelivery", b.LongitudeDelivery);

                //======================================================
                cmdBooking.Parameters.AddWithValue("@Bookingdate", b.Bookingdate);

                //A Couple of New Fields Added for Pickup and Delivery
                //======================================================
                cmdBooking.Parameters.AddWithValue("@PickupEmail", b.PickupEmail);
                cmdBooking.Parameters.AddWithValue("@DeliveryEmail", b.DeliveryEmail);
                //======================================================

                cmdBooking.Parameters.AddWithValue("@IsAssigned", b.IsAssigned);
                cmdBooking.Parameters.AddWithValue("@WhetherOtherExists", b.WhetherOtherExists);
                cmdBooking.Parameters.AddWithValue("@StatusDetails", b.StatusDetails);
                cmdBooking.Parameters.AddWithValue("@PickupCustomerTitle", b.PickupCustomerTitle);
                cmdBooking.Parameters.AddWithValue("@DeliveryCustomerTitle", b.DeliveryCustomerTitle);
                cmdBooking.Parameters.AddWithValue("@CreatedBy", b.CreatedBy);
                cmdBooking.Parameters.AddWithValue("@IsRegisteredUser", b.IsRegisteredUser);

                conBooking.Open();
                cmdBooking.ExecuteNonQuery();
                conBooking.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conBooking.Close();
            }
            finally
            {
                conBooking.Close();
            }
        }

        public void AddAssignBookingToDriver(AssignBookingToDriver abtd)
        {
            SqlConnection conABTD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdABTD = new SqlCommand("spAddAssignBookingToDriver", conABTD);
                cmdABTD.CommandType = CommandType.StoredProcedure;

                cmdABTD.Parameters.AddWithValue("@AssignId", abtd.AssignId);
                cmdABTD.Parameters.AddWithValue("@BookingId", abtd.BookingId);
                cmdABTD.Parameters.AddWithValue("@DriverId", abtd.DriverId);

                cmdABTD.Parameters.AddWithValue("@FromDate", abtd.FromDate);
                cmdABTD.Parameters.AddWithValue("@ToDate", abtd.ToDate);

                cmdABTD.Parameters.AddWithValue("@PickupAddress", abtd.PickupAddress);
                cmdABTD.Parameters.AddWithValue("@PickupPostCode", abtd.PickupPostCode);
                cmdABTD.Parameters.AddWithValue("@PickupMobile", abtd.PickupMobile);

                cmdABTD.Parameters.AddWithValue("@Wage", abtd.Wage);
                cmdABTD.Parameters.AddWithValue("@OptionType", abtd.OptionType);
                
                conABTD.Open();
                cmdABTD.ExecuteNonQuery();
                conABTD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conABTD.Close();
            }
            finally
            {
                conABTD.Close();
            }
        }

        public void AddDriverPayment(clsAddDriverPayment adp)
        {
            SqlConnection conADP = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdADP = new SqlCommand("spAddDriverPayment", conADP);
                cmdADP.CommandType = CommandType.StoredProcedure;

                cmdADP.Parameters.AddWithValue("@PaymentId", adp.PaymentId);
                cmdADP.Parameters.AddWithValue("@DriverId", adp.DriverId);
                cmdADP.Parameters.AddWithValue("@DriverType", adp.DriverType);
                cmdADP.Parameters.AddWithValue("@WageType", adp.WageType);

                cmdADP.Parameters.AddWithValue("@ExpectedAmount", adp.ExpectedAmount);
                cmdADP.Parameters.AddWithValue("@AmountReceived", adp.AmountReceived);
                cmdADP.Parameters.AddWithValue("@Discrepancy", adp.Discrepancy);

                cmdADP.Parameters.AddWithValue("@CreditDebitNote", adp.CreditDebitNote);

                conADP.Open();
                cmdADP.ExecuteNonQuery();
                conADP.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conADP.Close();
            }
            finally
            {
                conADP.Close();
            }
        }

        public void AddQuoting(Quoting q)
        {
            SqlConnection conQuoting = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdQuoting = new SqlCommand("spAddQuoting", conQuoting);
                cmdQuoting.CommandType = CommandType.StoredProcedure;

                cmdQuoting.Parameters.AddWithValue("@QuotingId", q.QuotingId);
                cmdQuoting.Parameters.AddWithValue("@CustomerId", q.CustomerId);
                cmdQuoting.Parameters.AddWithValue("@PickupCategory", q.PickupCategory);
                cmdQuoting.Parameters.AddWithValue("@PickupDateTime", q.PickupDateTime);
                cmdQuoting.Parameters.AddWithValue("@PickupAddress", q.PickupAddress);
                cmdQuoting.Parameters.AddWithValue("@Width", q.Width);
                cmdQuoting.Parameters.AddWithValue("@Height", q.Height);
                cmdQuoting.Parameters.AddWithValue("@Length", q.Length);
                cmdQuoting.Parameters.AddWithValue("@IsFragile", q.IsFragile);
                cmdQuoting.Parameters.AddWithValue("@EstimatedValue", q.EstimatedValue);
                cmdQuoting.Parameters.AddWithValue("@ItemCount", q.ItemCount);
                cmdQuoting.Parameters.AddWithValue("@TotalValue", q.TotalValue);
                cmdQuoting.Parameters.AddWithValue("@DeliveryCategory", q.DeliveryCategory);
                cmdQuoting.Parameters.AddWithValue("@DeliveryDateTime", q.DeliveryDateTime);
                cmdQuoting.Parameters.AddWithValue("@RecipientAddress", q.RecipientAddress);
                cmdQuoting.Parameters.AddWithValue("@DeliveryQuantity", q.DeliveryQuantity);
                cmdQuoting.Parameters.AddWithValue("@DeliveryCharge", q.DeliveryCharge);
                cmdQuoting.Parameters.AddWithValue("@TotalCharge", q.TotalCharge);
                cmdQuoting.Parameters.AddWithValue("@QuotingNotes", q.QuotingNotes);
                cmdQuoting.Parameters.AddWithValue("@OrderStatus", q.OrderStatus);
                cmdQuoting.Parameters.AddWithValue("@PickupItem", q.PickupItem);
                cmdQuoting.Parameters.AddWithValue("@VAT", q.VAT);
                cmdQuoting.Parameters.AddWithValue("@InsurancePremium", q.InsurancePremium);

                //New Parameters Added for few more Pickup and Delivery Fields
                //======================================================
                cmdQuoting.Parameters.AddWithValue("@PickupName", q.PickupName);
                cmdQuoting.Parameters.AddWithValue("@PickupMobile", q.PickupMobile);
                cmdQuoting.Parameters.AddWithValue("@DeliveryName", q.DeliveryName);
                cmdQuoting.Parameters.AddWithValue("@DeliveryMobile", q.DeliveryMobile);

                cmdQuoting.Parameters.AddWithValue("@PickupPostCode", q.PickupPostCode);
                cmdQuoting.Parameters.AddWithValue("@DeliveryPostCode", q.DeliveryPostCode);
                //======================================================
                cmdQuoting.Parameters.AddWithValue("@QuotingDate", q.QuotingDate);

                //A Couple of New Fields Added for Pickup and Delivery
                //======================================================
                cmdQuoting.Parameters.AddWithValue("@PickupEmail", q.PickupEmail);
                cmdQuoting.Parameters.AddWithValue("@DeliveryEmail", q.DeliveryEmail);
                //======================================================

                cmdQuoting.Parameters.AddWithValue("@WhetherOtherExists", q.WhetherOtherExists);

                conQuoting.Open();
                cmdQuoting.ExecuteNonQuery();
                conQuoting.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conQuoting.Close();
            }
            finally
            {
                conQuoting.Close();
            }
        }

        public void AddBookPickup(BookPickup bp)
        {
            SqlConnection conBookPickup = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdBookPickup = new SqlCommand("spAddBookPickup", conBookPickup);
                cmdBookPickup.CommandType = CommandType.StoredProcedure;

                cmdBookPickup.Parameters.AddWithValue("@PickupId", bp.PickupId);
                cmdBookPickup.Parameters.AddWithValue("@BookingId", bp.BookingId);
                cmdBookPickup.Parameters.AddWithValue("@CustomerId", bp.CustomerId);
                cmdBookPickup.Parameters.AddWithValue("@PickupCategory", bp.PickupCategory);
                cmdBookPickup.Parameters.AddWithValue("@PickupItem", bp.PickupItem);
                cmdBookPickup.Parameters.AddWithValue("@IsFragile", bp.IsFragile);
                cmdBookPickup.Parameters.AddWithValue("@EstimatedValue", bp.EstimatedValue);

                //New Field Added for BookPickup
                //=====================================
                cmdBookPickup.Parameters.AddWithValue("@PredefinedEstimatedValue", bp.PredefinedEstimatedValue);
                //=====================================

                conBookPickup.Open();
                cmdBookPickup.ExecuteNonQuery();
                conBookPickup.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conBookPickup.Close();
            }
            finally
            {
                conBookPickup.Close();
            }
        }

        public void AddImagePickup(ImagePickup ip)
        {
            SqlConnection conImagePickup = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdImagePickup = new SqlCommand("spAddImagePickup", conImagePickup);
                cmdImagePickup.CommandType = CommandType.StoredProcedure;

                cmdImagePickup.Parameters.AddWithValue("@ImagePickupId", ip.ImagePickupId);
                cmdImagePickup.Parameters.AddWithValue("@BookingId", ip.BookingId);
                cmdImagePickup.Parameters.AddWithValue("@CustomerId", ip.CustomerId);
                cmdImagePickup.Parameters.AddWithValue("@PickupCategoryId", ip.PickupCategoryId);
                cmdImagePickup.Parameters.AddWithValue("@PickupItemId", ip.PickupItemId);
                cmdImagePickup.Parameters.AddWithValue("@ImageName", ip.ImageName);
                cmdImagePickup.Parameters.AddWithValue("@ImageUrl", ip.ImageUrl);

                conImagePickup.Open();
                cmdImagePickup.ExecuteNonQuery();
                conImagePickup.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conImagePickup.Close();
            }
            finally
            {
                conImagePickup.Close();
            }
        }

        public void AddQuotPickup(QuotPickup qp)
        {
            SqlConnection conQuotPickup = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdQuotPickup = new SqlCommand("spAddQuotPickup", conQuotPickup);
                cmdQuotPickup.CommandType = CommandType.StoredProcedure;

                cmdQuotPickup.Parameters.AddWithValue("@PickupId", qp.PickupId);
                cmdQuotPickup.Parameters.AddWithValue("@QuotingId", qp.QuotingId);
                cmdQuotPickup.Parameters.AddWithValue("@CustomerId", qp.CustomerId);
                cmdQuotPickup.Parameters.AddWithValue("@PickupCategory", qp.PickupCategory);
                cmdQuotPickup.Parameters.AddWithValue("@PickupItem", qp.PickupItem);
                cmdQuotPickup.Parameters.AddWithValue("@IsFragile", qp.IsFragile);
                cmdQuotPickup.Parameters.AddWithValue("@EstimatedValue", qp.EstimatedValue);

                //New Field Added for BookPickup
                //=====================================
                cmdQuotPickup.Parameters.AddWithValue("@PredefinedEstimatedValue", qp.PredefinedEstimatedValue);
                //=====================================

                conQuotPickup.Open();
                cmdQuotPickup.ExecuteNonQuery();
                conQuotPickup.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conQuotPickup.Close();
            }
            finally
            {
                conQuotPickup.Close();
            }
        }

        public void AddQuote(clsQuote q)
        {
            SqlConnection conQuote = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdQuote = new SqlCommand("spAddQuote", conQuote);
                cmdQuote.CommandType = CommandType.StoredProcedure;

                cmdQuote.Parameters.AddWithValue("@QuoteId", q.QuoteId);
                cmdQuote.Parameters.AddWithValue("@CustomerId", q.CustomerId);
                cmdQuote.Parameters.AddWithValue("@BookingId", q.BookingId);

                conQuote.Open();
                cmdQuote.ExecuteNonQuery();
                conQuote.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conQuote.Close();
            }
            finally
            {
                conQuote.Close();
            }
        }

        public void AddPayPal(PayPal pp)
        {
            SqlConnection conPayPal = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdPayPal = new SqlCommand("spAddPayPal", conPayPal);
                cmdPayPal.CommandType = CommandType.StoredProcedure;

                cmdPayPal.Parameters.AddWithValue("@PayPalId", pp.PayPalId);
                cmdPayPal.Parameters.AddWithValue("@PayPalName", pp.PayPalName);
                cmdPayPal.Parameters.AddWithValue("@PayPalEmailId", pp.PayPalEmailId);
                cmdPayPal.Parameters.AddWithValue("@PayPalContactNo", pp.PayPalContactNo);
                cmdPayPal.Parameters.AddWithValue("@PayPalItemInfo", pp.PayPalItemInfo);
                cmdPayPal.Parameters.AddWithValue("@PayPalQuantity", pp.PayPalQuantity);
                cmdPayPal.Parameters.AddWithValue("@PayPalAmount", pp.PayPalAmount);
                cmdPayPal.Parameters.AddWithValue("@PayPalCurrency", pp.PayPalCurrency);
                cmdPayPal.Parameters.AddWithValue("@PayPalDateTime", pp.PayPalDateTime);
                cmdPayPal.Parameters.AddWithValue("@BookingId", pp.BookingId);
                cmdPayPal.Parameters.AddWithValue("@CustomerId", pp.CustomerId);

                conPayPal.Open();
                cmdPayPal.ExecuteNonQuery();
                conPayPal.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conPayPal.Close();
            }
            finally
            {
                conPayPal.Close();
            }
        }

        public void AddBookPickupByVolume(BookPickupByVolume bpv)
        {
            SqlConnection conBookPickupByVolume = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdBookPickupByVolume = new SqlCommand("spAddBookPickupByVolume", conBookPickupByVolume);
                cmdBookPickupByVolume.CommandType = CommandType.StoredProcedure;

                cmdBookPickupByVolume.Parameters.AddWithValue("@PickupByVolumeId", bpv.PickupByVolumeId);
                cmdBookPickupByVolume.Parameters.AddWithValue("@BookingId", bpv.BookingId);
                cmdBookPickupByVolume.Parameters.AddWithValue("@CustomerId", bpv.CustomerId);
                cmdBookPickupByVolume.Parameters.AddWithValue("@Width", bpv.Width);
                cmdBookPickupByVolume.Parameters.AddWithValue("@Height", bpv.Height);
                cmdBookPickupByVolume.Parameters.AddWithValue("@Length", bpv.Length);
                cmdBookPickupByVolume.Parameters.AddWithValue("@IsFragile", bpv.IsFragile);

                conBookPickupByVolume.Open();
                cmdBookPickupByVolume.ExecuteNonQuery();
                conBookPickupByVolume.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conBookPickupByVolume.Close();
            }
            finally
            {
                conBookPickupByVolume.Close();
            }
        }

        public void AddShipping(Shippings s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spAddShipping", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ShippingId", s.ShippingId);
                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@BookingId", s.BookingId);
                cmdShipping.Parameters.AddWithValue("@PickupId", s.PickupId);
                cmdShipping.Parameters.AddWithValue("@SealId", s.SealId);
                cmdShipping.Parameters.AddWithValue("@ShippingFrom", s.ShippingFrom);
                cmdShipping.Parameters.AddWithValue("@ShippingTo", s.ShippingTo);
                cmdShipping.Parameters.AddWithValue("@ShippingDate", s.ShippingDate);
                cmdShipping.Parameters.AddWithValue("@ArrivalDate", s.ArrivalDate);
                cmdShipping.Parameters.AddWithValue("@ETA", s.ETA);
                cmdShipping.Parameters.AddWithValue("@Consignee", s.Consignee);
                cmdShipping.Parameters.AddWithValue("@WarehouseId", s.WarehouseId);
                cmdShipping.Parameters.AddWithValue("@UserId", s.UserId);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        public void AddShippingContainerBookingInfo(ShippingDetails s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spAddShippingContainerBookingInfo", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ShippingId", s.ShippingId);
                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@BookingId", s.BookingId );
                cmdShipping.Parameters.AddWithValue("@Loaded", s.Loaded );
                cmdShipping.Parameters.AddWithValue("@Remaining", s.Remaining);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        public void AddContainerShippingItemInfo(ShippingDetails s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spAddContainerShippingItemInfo", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ShippingId", s.ShippingId);
                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@BookingId", s.BookingId);
                cmdShipping.Parameters.AddWithValue("@PickupId", s.PickupId);
                cmdShipping.Parameters.AddWithValue("@CategoryId", s.CategoryId);
                cmdShipping.Parameters.AddWithValue("@CategoryItemId", s.CategoryItemId);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        
        public string AddContainer(Container s)
        {
            DataSet dsAPC = new DataSet();
            DataTable dtAPC = new DataTable();

            SqlConnection conContainer = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdContainer = new SqlCommand("spAddContainer", conContainer);
                cmdContainer.CommandType = CommandType.StoredProcedure;

                cmdContainer.Parameters.AddWithValue("@ContainerNumber", s.ContainerNumber);
                cmdContainer.Parameters.AddWithValue("@ContainerTypeId", s.ContainerTypeId);
                cmdContainer.Parameters.AddWithValue("@CompanyName", s.CompanyName);
                cmdContainer.Parameters.AddWithValue("@ContainerAddress", s.ContainerAddress);
                cmdContainer.Parameters.AddWithValue("@ContactPersonNo", s.ContactPersonNo);
                cmdContainer.Parameters.AddWithValue("@FreightName", s.FreightName);
                cmdContainer.Parameters.AddWithValue("@OptionType", s.OptionType);

                conContainer.Open();
                //cmdContainer.ExecuteNonQuery();
                SqlDataAdapter daAPC = new SqlDataAdapter(cmdContainer);
                daAPC.Fill(dsAPC);
                dtAPC = dsAPC.Tables[0];
                conContainer.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conContainer.Close();
            }
            return dtAPC.Rows[0][0].ToString();
        }

        public void AddContactDetails(ContactUs cu)
        {
            SqlConnection conContactDetails = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdContactDetails = new SqlCommand("spAddContactDetails", conContactDetails);
                cmdContactDetails.CommandType = CommandType.StoredProcedure;

                cmdContactDetails.Parameters.AddWithValue("@ContactId", cu.ContactId);
                cmdContactDetails.Parameters.AddWithValue("@ContactTitle", cu.ContactTitle);
                cmdContactDetails.Parameters.AddWithValue("@ContactFirstName", cu.ContactFirstName);
                cmdContactDetails.Parameters.AddWithValue("@ContactLastName", cu.ContactLastName);
                cmdContactDetails.Parameters.AddWithValue("@ContactEmail", cu.ContactEmail);
                cmdContactDetails.Parameters.AddWithValue("@ContactComments", cu.ContactComments);

                conContactDetails.Open();
                cmdContactDetails.ExecuteNonQuery();
                conContactDetails.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conContactDetails.Close();
            }
            finally
            {
                conContactDetails.Close();
            }
        }

        public void AddLocationDetails(Location l)
        {
            SqlConnection conLocation = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdLocation = new SqlCommand("spAddLocationDetails", conLocation);
                cmdLocation.CommandType = CommandType.StoredProcedure;

                cmdLocation.Parameters.AddWithValue("@LocationId", l.LocationId);
                cmdLocation.Parameters.AddWithValue("@LocationName", l.LocationName);
                cmdLocation.Parameters.AddWithValue("@LocationAddress", l.LocationAddress);
                cmdLocation.Parameters.AddWithValue("@LocationLatitude", l.LocationLatitude);
                cmdLocation.Parameters.AddWithValue("@LocationLongitude", l.LocationLongitude);
                cmdLocation.Parameters.AddWithValue("@Country", l.Country);

                conLocation.Open();
                cmdLocation.ExecuteNonQuery();
                conLocation.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conLocation.Close();
            }
            finally
            {
                conLocation.Close();
            }
        }

        public void AddWarehouseDetails(Warehouse w)
        {
            SqlConnection conWarehouse = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdWarehouse = new SqlCommand("spAddWarehouseDetails", conWarehouse);
                cmdWarehouse.CommandType = CommandType.StoredProcedure;

                cmdWarehouse.Parameters.AddWithValue("@WarehouseId", w.WarehouseId);
                cmdWarehouse.Parameters.AddWithValue("@WarehouseName", w.WarehouseName);
                cmdWarehouse.Parameters.AddWithValue("@LocationName", w.LocationName);
                cmdWarehouse.Parameters.AddWithValue("@ZoneName", w.ZoneName);

                conWarehouse.Open();
                cmdWarehouse.ExecuteNonQuery();
                conWarehouse.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conWarehouse.Close();
            }
            finally
            {
                conWarehouse.Close();
            }
        }

        public void AddZoneDetails(Zone z)
        {
            SqlConnection conZone = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdZone = new SqlCommand("spAddZoneDetails", conZone);
                cmdZone.CommandType = CommandType.StoredProcedure;

                cmdZone.Parameters.AddWithValue("@ZoneId", z.ZoneId);
                cmdZone.Parameters.AddWithValue("@ZoneName", z.ZoneName);
                cmdZone.Parameters.AddWithValue("@LocationId", z.LocationId);

                conZone.Open();
                cmdZone.ExecuteNonQuery();
                conZone.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conZone.Close();
            }
            finally
            {
                conZone.Close();
            }
        }

        public void AddRoleDetails(Role r)
        {
            SqlConnection conRole = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRole = new SqlCommand("spAddRoleDetails", conRole);
                cmdRole.CommandType = CommandType.StoredProcedure;

                cmdRole.Parameters.AddWithValue("@RoleId", r.RoleId);
                cmdRole.Parameters.AddWithValue("@RoleName", r.RoleName);

                conRole.Open();
                cmdRole.ExecuteNonQuery();
                conRole.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRole.Close();
            }
            finally
            {
                conRole.Close();
            }
        }

        public int AddMenuDetails(MenuDetails md)
        {
            SqlConnection conMenu = new SqlConnection(sConnectionString);
            SqlCommand cmdMenu = new SqlCommand("spAddMenuDetails", conMenu);

            try
            {
                cmdMenu.CommandType = CommandType.StoredProcedure;

                cmdMenu.Parameters.AddWithValue("@Menu_Name", md.Menu_Name);
                cmdMenu.Parameters.AddWithValue("@Parent_ID", md.Parent_ID);
                cmdMenu.Parameters.AddWithValue("@PagePath", md.PagePath);
                cmdMenu.Parameters.AddWithValue("@IsActive", md.IsActive);
                cmdMenu.Parameters.Add("@flag", SqlDbType.Int);
                cmdMenu.Parameters["@flag"].Direction = ParameterDirection.Output;

                conMenu.Open();
                cmdMenu.ExecuteNonQuery();
                conMenu.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conMenu.Close();
            }
            finally
            {
                conMenu.Close();
            }

            return Convert.ToInt32(cmdMenu.Parameters["@flag"].Value.ToString());
        }

        public void AddResetPassword(ResetPassword rp)
        {
            SqlConnection conResetPassword = new SqlConnection(sConnectionString);
            SqlCommand cmdResetPassword = new SqlCommand("spAddResetPassword", conResetPassword);

            try
            {
                cmdResetPassword.CommandType = CommandType.StoredProcedure;

                cmdResetPassword.Parameters.AddWithValue("@EmailID", rp.EmailID);
                cmdResetPassword.Parameters.AddWithValue("@EncryptedEmailID", rp.EncryptedEmailID);

                conResetPassword.Open();
                cmdResetPassword.ExecuteNonQuery();
                conResetPassword.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conResetPassword.Close();
            }
            finally
            {
                conResetPassword.Close();
            }
        }

        public void AddUserSpecificRoles(UserAccess ua)
        {
            SqlConnection conUserAccess = new SqlConnection(sConnectionString);
            SqlCommand cmdUserAccess = new SqlCommand("spAddUserSpecificRoles", conUserAccess);

            try
            {
                cmdUserAccess.CommandType = CommandType.StoredProcedure;

                cmdUserAccess.Parameters.AddWithValue("@UserId", ua.UserId);
                cmdUserAccess.Parameters.AddWithValue("@RoleName", ua.RoleName);
                cmdUserAccess.Parameters.AddWithValue("@WhetherDefault", ua.WhetherDefault);
                cmdUserAccess.Parameters.AddWithValue("@Menu_Name", ua.Menu_Name);

                //0
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AssignBookingToDriver", ua.AssignBookingToDriver);

                cmdUserAccess.Parameters.AddWithValue("@AssignBookingToDriverId", ua.AssignBookingToDriverId);

                //1
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddDriverToAssignBooking", ua.AddDriverToAssignBooking);

                cmdUserAccess.Parameters.AddWithValue("@AddDriverToAssignBookingId", ua.AddDriverToAssignBookingId);

                //2
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddBooking", ua.AddBooking);
                cmdUserAccess.Parameters.AddWithValue("@AddBookingId", ua.AddBookingId);

                //3
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddShipping", ua.AddShipping);
                cmdUserAccess.Parameters.AddWithValue("@AddShippingId", ua.AddShippingId);

                //4
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddCustomer", ua.AddCustomer);
                cmdUserAccess.Parameters.AddWithValue("@AddCustomerId", ua.AddCustomerId);

                //5
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddDriver", ua.AddDriver);
                cmdUserAccess.Parameters.AddWithValue("@AddDriverId", ua.AddDriverId);

                //6
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddWarehouse", ua.AddWarehouse);
                cmdUserAccess.Parameters.AddWithValue("@AddWarehouseId", ua.AddWarehouseId);

                //7
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddLocation", ua.AddLocation);
                cmdUserAccess.Parameters.AddWithValue("@AddLocationId", ua.AddLocationId);

                //8
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddZone", ua.AddZone);
                cmdUserAccess.Parameters.AddWithValue("@AddZoneId", ua.AddZoneId);

                //9
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@AddUser", ua.AddUser);
                cmdUserAccess.Parameters.AddWithValue("@AddUserId", ua.AddUserId);

                //10
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@PrintDetails", ua.PrintDetails);
                cmdUserAccess.Parameters.AddWithValue("@PrintDetailsId", ua.PrintDetailsId);

                //11
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@ExportToPDF", ua.ExportToPDF);
                cmdUserAccess.Parameters.AddWithValue("@ExportToPDFId", ua.ExportToPDFId);

                //12
                //==========================================================
                cmdUserAccess.Parameters.AddWithValue("@ExportToExcel", ua.ExportToExcel);
                cmdUserAccess.Parameters.AddWithValue("@ExportToExcelId", ua.ExportToExcelId);

                conUserAccess.Open();
                cmdUserAccess.ExecuteNonQuery();
                conUserAccess.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUserAccess.Close();
            }
            finally
            {
                conUserAccess.Close();
            }
        }

        public void AddComplaintDetails(Complaint c)
        {
            SqlConnection conComplaint = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdComplaint = new SqlCommand("spAddComplaintDetails", conComplaint);
                cmdComplaint.CommandType = CommandType.StoredProcedure;

                cmdComplaint.Parameters.AddWithValue("@ComplaintId", c.ComplaintId);
                cmdComplaint.Parameters.AddWithValue("@CustomerId", c.CustomerId);
                cmdComplaint.Parameters.AddWithValue("@BookingId", c.BookingId);

                cmdComplaint.Parameters.AddWithValue("@ComplaintSource", c.ComplaintSource);
                cmdComplaint.Parameters.AddWithValue("@ComplaintReason", c.ComplaintReason);

                cmdComplaint.Parameters.AddWithValue("@ComplaintPriority", c.ComplaintPriority);

                cmdComplaint.Parameters.AddWithValue("@ComplaintStatus", c.ComplaintStatus);
                cmdComplaint.Parameters.AddWithValue("@LodgingDate", c.LodgingDate);
                cmdComplaint.Parameters.AddWithValue("@ResolvedDate", c.ResolvedDate);

                conComplaint.Open();
                cmdComplaint.ExecuteNonQuery();
                conComplaint.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conComplaint.Close();
            }
            finally
            {
                conComplaint.Close();
            }
        }

        public void AddInteractionDetails(CustomerInteraction ci)
        {
            SqlConnection conInteraction = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdInteraction = new SqlCommand("spAddInteractionDetails", conInteraction);
                cmdInteraction.CommandType = CommandType.StoredProcedure;

                cmdInteraction.Parameters.AddWithValue("@ComplaintId", ci.ComplaintId);
                cmdInteraction.Parameters.AddWithValue("@InteractionDate", ci.InteractionDate);

                cmdInteraction.Parameters.AddWithValue("@Comments", ci.Comments);
                cmdInteraction.Parameters.AddWithValue("@PostedBy", ci.PostedBy);

                cmdInteraction.Parameters.AddWithValue("@ComplaintStatus", ci.ComplaintStatus);

                conInteraction.Open();
                cmdInteraction.ExecuteNonQuery();
                conInteraction.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conInteraction.Close();
            }
            finally
            {
                conInteraction.Close();
            }
        }

        #endregion

        #region Edit Zone

        public void EditUser(User u)
        {
            SqlConnection conUser = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUser = new SqlCommand("spEditUser", conUser);
                cmdUser.CommandType = CommandType.StoredProcedure;

                cmdUser.Parameters.AddWithValue("@UserId", u.UserId);
                cmdUser.Parameters.AddWithValue("@EmailID", u.EmailID);
                cmdUser.Parameters.AddWithValue("@Title", u.Title);
                cmdUser.Parameters.AddWithValue("@FirstName", u.FirstName);
                cmdUser.Parameters.AddWithValue("@LastName", u.LastName);
                cmdUser.Parameters.AddWithValue("@DOB", u.DOB);
                cmdUser.Parameters.AddWithValue("@Address", u.Address);
                cmdUser.Parameters.AddWithValue("@Town", u.Town);
                cmdUser.Parameters.AddWithValue("@Country", u.Country);
                cmdUser.Parameters.AddWithValue("@PostCode", u.PostCode);
                cmdUser.Parameters.AddWithValue("@Mobile", u.Mobile);
                cmdUser.Parameters.AddWithValue("@Telephone", u.Telephone);
                cmdUser.Parameters.AddWithValue("@SecretQuestion", u.SecretQuestion);
                cmdUser.Parameters.AddWithValue("@SecretAnswer", u.SecretAnswer);
                cmdUser.Parameters.AddWithValue("@UserRole", u.UserRole);
                cmdUser.Parameters.AddWithValue("@Locked", u.Locked);

                conUser.Open();
                cmdUser.ExecuteNonQuery();
                conUser.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUser.Close();
            }
            finally
            {
                conUser.Close();
            }
        }

        public void EditCustomer(Customer c)
        {
            SqlConnection conCustomer = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCustomer = new SqlCommand("spEditCustomer", conCustomer);
                cmdCustomer.CommandType = CommandType.StoredProcedure;

                cmdCustomer.Parameters.AddWithValue("@CustomerId", c.CustomerId);
                cmdCustomer.Parameters.AddWithValue("@EmailID", c.EmailID);
                cmdCustomer.Parameters.AddWithValue("@Title", c.Title);
                cmdCustomer.Parameters.AddWithValue("@FirstName", c.FirstName);
                cmdCustomer.Parameters.AddWithValue("@LastName", c.LastName);
                cmdCustomer.Parameters.AddWithValue("@DOB", c.DOB);
                cmdCustomer.Parameters.AddWithValue("@Address", c.Address);
                cmdCustomer.Parameters.AddWithValue("@Town", c.Town);
                cmdCustomer.Parameters.AddWithValue("@Country", c.Country);
                cmdCustomer.Parameters.AddWithValue("@PostCode", c.PostCode);
                cmdCustomer.Parameters.AddWithValue("@Mobile", c.Mobile);
                cmdCustomer.Parameters.AddWithValue("@Telephone", c.Telephone);
                cmdCustomer.Parameters.AddWithValue("@Locked", c.Locked);

                conCustomer.Open();
                cmdCustomer.ExecuteNonQuery();
                conCustomer.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCustomer.Close();
            }
            finally
            {
                conCustomer.Close();
            }
        }

        public void EditShipping(Shippings s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spEditShipping", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ShippingId", s.ShippingId);
                cmdShipping.Parameters.AddWithValue("@ContainerId", s.ContainerId);
                cmdShipping.Parameters.AddWithValue("@SealId", s.SealId);
                cmdShipping.Parameters.AddWithValue("@BookingId", s.BookingId);
                cmdShipping.Parameters.AddWithValue("@CustomerId", s.CustomerId);
                cmdShipping.Parameters.AddWithValue("@ShippingFrom", s.ShippingFrom);
                cmdShipping.Parameters.AddWithValue("@ShippingTo", s.ShippingTo);
                cmdShipping.Parameters.AddWithValue("@FreightType", s.FreightType);
                cmdShipping.Parameters.AddWithValue("@ShippingPort", s.ShippingPort);
                cmdShipping.Parameters.AddWithValue("@ShippingDate", s.ShippingDate);
                cmdShipping.Parameters.AddWithValue("@ArrivalDate", s.ArrivalDate);
                cmdShipping.Parameters.AddWithValue("@Consignee", s.Consignee);
                cmdShipping.Parameters.AddWithValue("@InvoiceNumber", s.InvoiceNumber);
                cmdShipping.Parameters.AddWithValue("@InvoiceAmount", s.InvoiceAmount);
                cmdShipping.Parameters.AddWithValue("@Paid", s.Paid);
                cmdShipping.Parameters.AddWithValue("@ItemCount", s.ItemCount);
                cmdShipping.Parameters.AddWithValue("@Loaded", s.Loaded);
                cmdShipping.Parameters.AddWithValue("@Remaining", s.Remaining);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        public void EditBooking(Booking b)
        {
            SqlConnection conBooking = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdBooking = new SqlCommand("spEditBooking", conBooking);
                cmdBooking.CommandType = CommandType.StoredProcedure;

                cmdBooking.Parameters.AddWithValue("@BookingId", b.BookingId);
                cmdBooking.Parameters.AddWithValue("@CustomerId", b.CustomerId);
                cmdBooking.Parameters.AddWithValue("@PickupCategory", b.PickupCategory);
                cmdBooking.Parameters.AddWithValue("@PickupItem", b.PickupItem);
                cmdBooking.Parameters.AddWithValue("@PickupDateTime", b.PickupDateTime);
                cmdBooking.Parameters.AddWithValue("@PickupAddress", b.PickupAddress);
                cmdBooking.Parameters.AddWithValue("@Width", b.Width);
                cmdBooking.Parameters.AddWithValue("@Height", b.Height);
                cmdBooking.Parameters.AddWithValue("@Length", b.Length);
                cmdBooking.Parameters.AddWithValue("@IsFragile", b.IsFragile);
                cmdBooking.Parameters.AddWithValue("@EstimatedValue", b.EstimatedValue);
                cmdBooking.Parameters.AddWithValue("@ItemCount", b.ItemCount);
                cmdBooking.Parameters.AddWithValue("@TotalValue", b.TotalValue);
                cmdBooking.Parameters.AddWithValue("@DeliveryCategory", b.DeliveryCategory);
                cmdBooking.Parameters.AddWithValue("@DeliveryDateTime", b.DeliveryDateTime);
                cmdBooking.Parameters.AddWithValue("@RecipientAddress", b.RecipientAddress);
                cmdBooking.Parameters.AddWithValue("@DeliveryQuantity", b.DeliveryQuantity);
                cmdBooking.Parameters.AddWithValue("@DeliveryCharge", b.DeliveryCharge);
                cmdBooking.Parameters.AddWithValue("@TotalCharge", b.TotalCharge);
                cmdBooking.Parameters.AddWithValue("@BookingNotes", b.BookingNotes);
                cmdBooking.Parameters.AddWithValue("@OrderStatus", b.OrderStatus);
                cmdBooking.Parameters.AddWithValue("@VAT", b.VAT);

                conBooking.Open();
                cmdBooking.ExecuteNonQuery();
                conBooking.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conBooking.Close();
            }
            finally
            {
                conBooking.Close();
            }
        }

        public void UpdateBookingDetails(BookingPayment bp)
        {
            SqlConnection conUBD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUBD = new SqlCommand("spUpdateBookingDetails", conUBD);
                cmdUBD.CommandType = CommandType.StoredProcedure;

                cmdUBD.Parameters.AddWithValue("@BookingId", bp.BookingId);
                cmdUBD.Parameters.AddWithValue("@RegisteredCompanyName", bp.RegisteredCompanyName);
                cmdUBD.Parameters.AddWithValue("@InsurancePremium", bp.InsurancePremium);
                cmdUBD.Parameters.AddWithValue("@PickupAddress", bp.PickupAddress);
                cmdUBD.Parameters.AddWithValue("@RecipentAddress", bp.RecipentAddress);
                cmdUBD.Parameters.AddWithValue("@ItemCount", bp.ItemCount);
                cmdUBD.Parameters.AddWithValue("@TotalValue", bp.TotalValue);
                cmdUBD.Parameters.AddWithValue("@PostCode", bp.PostCode);

                //New Fields Added for Order Booking 
                //====================================================
                cmdUBD.Parameters.AddWithValue("@CollectionName", bp.CollectionName);
                cmdUBD.Parameters.AddWithValue("@CollectionMobile", bp.CollectionMobile);
                cmdUBD.Parameters.AddWithValue("@AltPickupMobile", bp.AltPickupMobile);
                cmdUBD.Parameters.AddWithValue("@DeliveryName", bp.DeliveryName);
                cmdUBD.Parameters.AddWithValue("@DeliveryMobile", bp.DeliveryMobile);
                cmdUBD.Parameters.AddWithValue("@AltDeliveryMobile", bp.AltDeliveryMobile);

                cmdUBD.Parameters.AddWithValue("@CollectionPostCode", bp.CollectionPostCode);
                cmdUBD.Parameters.AddWithValue("@DeliveryPostCode", bp.DeliveryPostCode);

                cmdUBD.Parameters.AddWithValue("@LatitudePickup", bp.LatitudePickup);
                cmdUBD.Parameters.AddWithValue("@LongitudePickup", bp.LongitudePickup);
                cmdUBD.Parameters.AddWithValue("@LatitudeDelivery", bp.LatitudeDelivery);
                cmdUBD.Parameters.AddWithValue("@LongitudeDelivery", bp.LongitudeDelivery);

                //====================================================
                cmdUBD.Parameters.AddWithValue("@Bookingdate", bp.Bookingdate);

                //A Couple of New Fields Added for Pickup and Delivery
                //======================================================
                cmdUBD.Parameters.AddWithValue("@PickupEmail", bp.PickupEmail);
                cmdUBD.Parameters.AddWithValue("@DeliveryEmail", bp.DeliveryEmail);
                //======================================================

                cmdUBD.Parameters.AddWithValue("@IsAssigned", bp.IsAssigned);
                cmdUBD.Parameters.AddWithValue("@WhetherOtherExists", bp.WhetherOtherExists);

                cmdUBD.Parameters.AddWithValue("@PickupTitle", bp.PickupTitle);
                cmdUBD.Parameters.AddWithValue("@DeliveryTitle", bp.DeliveryTitle);
                cmdUBD.Parameters.AddWithValue("@StatusDetails", bp.StatusDetails);
                cmdUBD.Parameters.AddWithValue("@PickupDateTime", bp.PickupDateTime);
                

                conUBD.Open();
                cmdUBD.ExecuteNonQuery();
                conUBD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUBD.Close();
            }
            finally
            {
                conUBD.Close();
            }
        }

        public void UpdateIsAssignedInOrderBooking(string sBookingId, string OptionType)
        {
            SqlConnection conUIAIOB = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUIAIOB = new SqlCommand("spUpdateIsAssignedInOrderBooking", conUIAIOB);
                cmdUIAIOB.CommandType = CommandType.StoredProcedure;

                cmdUIAIOB.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdUIAIOB.Parameters.AddWithValue("@OptionType", OptionType);

                conUIAIOB.Open();
                cmdUIAIOB.ExecuteNonQuery();
                conUIAIOB.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUIAIOB.Close();
            }
            finally
            {
                conUIAIOB.Close();
            }
        }

        public void UpdateOrderStatus(string sBookingId, string sOrderStatus, string PaymentId, string PayPalContactNo, string PaypalEmail, string sCustomerId, string sHaveToPay)
        {
            SqlConnection conUOS = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUOS = new SqlCommand("spUpdateOrderStatus", conUOS);
                cmdUOS.CommandType = CommandType.StoredProcedure;

                cmdUOS.Parameters.AddWithValue("@BookingId", sBookingId);
                cmdUOS.Parameters.AddWithValue("@OrderStatus", sOrderStatus);
                cmdUOS.Parameters.AddWithValue("@PaymentId", PaymentId);
                cmdUOS.Parameters.AddWithValue("@PayPalContactNo", PayPalContactNo);
                cmdUOS.Parameters.AddWithValue("@PaypalEmail", PaypalEmail);
                cmdUOS.Parameters.AddWithValue("@sCustomerId", sCustomerId);
                cmdUOS.Parameters.AddWithValue("@sHaveToPay", sHaveToPay);

                conUOS.Open();
                cmdUOS.ExecuteNonQuery();
                conUOS.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUOS.Close();
            }
            finally
            {
                conUOS.Close();
            }
        }

        public void UpdateQuotationFlag(string sQuotingId)
        {
            SqlConnection conUQF = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUQF = new SqlCommand("spUpdateQuotationFlag", conUQF);
                cmdUQF.CommandType = CommandType.StoredProcedure;

                cmdUQF.Parameters.AddWithValue("@QuotingId", sQuotingId);

                conUQF.Open();
                cmdUQF.ExecuteNonQuery();
                conUQF.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUQF.Close();
            }
            finally
            {
                conUQF.Close();
            }
        }

        public void UpdateUserPassword(string sEmailID, string sNewPassword)
        {
            SqlConnection conUUP = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUUP = new SqlCommand("spUpdateUserPassword", conUUP);
                cmdUUP.CommandType = CommandType.StoredProcedure;

                cmdUUP.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdUUP.Parameters.AddWithValue("@NewPassword", sNewPassword);

                conUUP.Open();
                cmdUUP.ExecuteNonQuery();
                conUUP.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUUP.Close();
            }
            finally
            {
                conUUP.Close();
            }
        }

        public void UpdateResetPassword(string sEmailID, string sEncryptedEmailID)
        {
            SqlConnection conURP = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdURP = new SqlCommand("spUpdateResetPassword", conURP);
                cmdURP.CommandType = CommandType.StoredProcedure;

                cmdURP.Parameters.AddWithValue("@EmailID", sEmailID);
                cmdURP.Parameters.AddWithValue("@EncryptedEmailID", sEncryptedEmailID);

                conURP.Open();
                cmdURP.ExecuteNonQuery();
                conURP.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conURP.Close();
            }
            finally
            {
                conURP.Close();
            }
        }

        public void UpdateCustomerDetails(clsCustomers2 cc)
        {
            SqlConnection conUCD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUCD = new SqlCommand("spUpdateCustomerDetails", conUCD);
                cmdUCD.CommandType = CommandType.StoredProcedure;

                cmdUCD.Parameters.AddWithValue("@CustomerId", cc.CustomerId);
                cmdUCD.Parameters.AddWithValue("@EmailID", cc.EmailID);

                cmdUCD.Parameters.AddWithValue("@Title", cc.Title);
                cmdUCD.Parameters.AddWithValue("@FirstName", cc.FirstName);
                cmdUCD.Parameters.AddWithValue("@LastName", cc.LastName);

                cmdUCD.Parameters.AddWithValue("@DOB", cc.DOB);
                cmdUCD.Parameters.AddWithValue("@Mobile", cc.Mobile);
                cmdUCD.Parameters.AddWithValue("@Landline", cc.Landline);

                cmdUCD.Parameters.AddWithValue("@Address", cc.Address);
                cmdUCD.Parameters.AddWithValue("@LatitudePickup", cc.LatitudePickup);
                cmdUCD.Parameters.AddWithValue("@LongitudePickup", cc.LongitudePickup);
                cmdUCD.Parameters.AddWithValue("@PostCode", cc.PostCode);

                cmdUCD.Parameters.AddWithValue("@HearAboutUs", cc.HearAboutUs);
                cmdUCD.Parameters.AddWithValue("@HavingRegisteredCompany", cc.HavingRegisteredCompany);
                cmdUCD.Parameters.AddWithValue("@RegisteredCompanyName", cc.RegisteredCompanyName);
                cmdUCD.Parameters.AddWithValue("@ShippingGoodsInCompanyName", cc.ShippingGoodsInCompanyName);

                conUCD.Open();
                cmdUCD.ExecuteNonQuery();
                conUCD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUCD.Close();
            }
            finally
            {
                conUCD.Close();
            }
        }

        public void UpdateDriverDetails(clsDriver2 dd)
        {
            SqlConnection conUDD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUDD = new SqlCommand("spUpdateDriverDetails", conUDD);
                cmdUDD.CommandType = CommandType.StoredProcedure;

                cmdUDD.Parameters.AddWithValue("@DriverId", dd.DriverId);

                cmdUDD.Parameters.AddWithValue("@Title", dd.Title);
                cmdUDD.Parameters.AddWithValue("@FirstName", dd.FirstName);
                cmdUDD.Parameters.AddWithValue("@LastName", dd.LastName);

                cmdUDD.Parameters.AddWithValue("@EmailID", dd.EmailID);
                cmdUDD.Parameters.AddWithValue("@DOB", dd.DOB);

                cmdUDD.Parameters.AddWithValue("@Address", dd.Address);
                cmdUDD.Parameters.AddWithValue("@PostCode", dd.PostCode);

                cmdUDD.Parameters.AddWithValue("@Mobile", dd.Mobile);
                cmdUDD.Parameters.AddWithValue("@Landline", dd.Landline);

                cmdUDD.Parameters.AddWithValue("@DriverType", dd.DriverType);
                cmdUDD.Parameters.AddWithValue("@WageType", dd.WageType);

                cmdUDD.Parameters.AddWithValue("@Status", dd.Status);

                conUDD.Open();
                cmdUDD.ExecuteNonQuery();
                conUDD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUDD.Close();
            }
            finally
            {
                conUDD.Close();
            }
        }

        public void UpdateDriverPaymentDetails(DriverPayment2 dp)
        {
            SqlConnection conUDPD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUDPD = new SqlCommand("spUpdateDriverPaymentDetails", conUDPD);
                cmdUDPD.CommandType = CommandType.StoredProcedure;

                cmdUDPD.Parameters.AddWithValue("@PaymentId", dp.PaymentId);
                cmdUDPD.Parameters.AddWithValue("@AmountReceived", dp.AmountReceived);
                cmdUDPD.Parameters.AddWithValue("@CreditDebitNote", dp.CreditDebitNote);

                conUDPD.Open();
                cmdUDPD.ExecuteNonQuery();
                conUDPD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUDPD.Close();
            }
            finally
            {
                conUDPD.Close();
            }
        }

        public void RevertDriverPaymentDetails(DriverPayment2 dp)
        {
            SqlConnection conRDPD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRDPD = new SqlCommand("spRevertDriverPaymentDetails", conRDPD);
                cmdRDPD.CommandType = CommandType.StoredProcedure;

                cmdRDPD.Parameters.AddWithValue("@PaymentId", dp.PaymentId);
                cmdRDPD.Parameters.AddWithValue("@AmountReceived", dp.AmountReceived);
                cmdRDPD.Parameters.AddWithValue("@CreditDebitNote", dp.CreditDebitNote);

                conRDPD.Open();
                cmdRDPD.ExecuteNonQuery();
                conRDPD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRDPD.Close();
            }
            finally
            {
                conRDPD.Close();
            }
        }

        public void UpdateLocationDetails(Location l)
        {
            SqlConnection conLocation = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdLocation = new SqlCommand("spUpdateLocationDetails", conLocation);
                cmdLocation.CommandType = CommandType.StoredProcedure;

                cmdLocation.Parameters.AddWithValue("@LocationId", l.LocationId);
                cmdLocation.Parameters.AddWithValue("@LocationName", l.LocationName);
                //cmdLocation.Parameters.AddWithValue("@CountryId", l.CountryId);
                //cmdLocation.Parameters.AddWithValue("@CityId", l.CityId);

                conLocation.Open();
                cmdLocation.ExecuteNonQuery();
                conLocation.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conLocation.Close();
            }
            finally
            {
                conLocation.Close();
            }
        }

        public void UpdateWarehouseDetails(Warehouse w)
        {
            SqlConnection conWarehouse = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdWarehouse = new SqlCommand("spUpdateWarehouseDetails", conWarehouse);
                cmdWarehouse.CommandType = CommandType.StoredProcedure;

                cmdWarehouse.Parameters.AddWithValue("@WarehouseId", w.WarehouseId);
                cmdWarehouse.Parameters.AddWithValue("@WarehouseName", w.WarehouseName);
                cmdWarehouse.Parameters.AddWithValue("@LocationName", w.LocationName);
                cmdWarehouse.Parameters.AddWithValue("@ZoneName", w.ZoneName);

                conWarehouse.Open();
                cmdWarehouse.ExecuteNonQuery();
                conWarehouse.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conWarehouse.Close();
            }
            finally
            {
                conWarehouse.Close();
            }
        }

        public void UpdateZoneDetails(Zone w)
        {
            SqlConnection conZone = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdZone = new SqlCommand("spUpdateZoneDetails", conZone);
                cmdZone.CommandType = CommandType.StoredProcedure;

                cmdZone.Parameters.AddWithValue("@ZoneId", w.ZoneId);
                cmdZone.Parameters.AddWithValue("@ZoneName", w.ZoneName);
                cmdZone.Parameters.AddWithValue("@LocationName", w.LocationName);

                conZone.Open();
                cmdZone.ExecuteNonQuery();
                conZone.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conZone.Close();
            }
            finally
            {
                conZone.Close();
            }
        }

        public void ChangeDriverStatus(Driver d)
        {
            SqlConnection conDriver = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDriver = new SqlCommand("spChangeDriverStatus", conDriver);
                cmdDriver.CommandType = CommandType.StoredProcedure;

                cmdDriver.Parameters.AddWithValue("@DriverId", d.DriverId);
                cmdDriver.Parameters.AddWithValue("@Enabled", d.Enabled);

                conDriver.Open();
                cmdDriver.ExecuteNonQuery();
                conDriver.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDriver.Close();
            }
            finally
            {
                conDriver.Close();
            }
        }

        public void ChangeMenuStatus(MenuDetails d)
        {
            SqlConnection conMenu = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdMenu = new SqlCommand("spChangeMenuStatus", conMenu);
                cmdMenu.CommandType = CommandType.StoredProcedure;

                cmdMenu.Parameters.AddWithValue("@MenuId", d.Menu_ID);
                cmdMenu.Parameters.AddWithValue("@Enabled", d.IsActive);

                conMenu.Open();
                cmdMenu.ExecuteNonQuery();
                conMenu.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conMenu.Close();
            }
            finally
            {
                conMenu.Close();
            }
        }

        public void UpdateUserDetails(User u)
        {
            SqlConnection conUser = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUser = new SqlCommand("spUpdateUserDetails", conUser);
                cmdUser.CommandType = CommandType.StoredProcedure;

                cmdUser.Parameters.AddWithValue("@UserId", u.UserId);

                cmdUser.Parameters.AddWithValue("@EmailID", u.EmailID);
                cmdUser.Parameters.AddWithValue("@Password", u.Password);

                cmdUser.Parameters.AddWithValue("@Title", u.Title);
                cmdUser.Parameters.AddWithValue("@FirstName", u.FirstName);
                cmdUser.Parameters.AddWithValue("@LastName", u.LastName);

                cmdUser.Parameters.AddWithValue("@DOB", u.DOB);

                cmdUser.Parameters.AddWithValue("@Address", u.Address);
                cmdUser.Parameters.AddWithValue("@Town", u.Town);

                cmdUser.Parameters.AddWithValue("@Country", u.Country);
                cmdUser.Parameters.AddWithValue("@PostCode", u.PostCode);

                cmdUser.Parameters.AddWithValue("@Mobile", u.Mobile);
                cmdUser.Parameters.AddWithValue("@Telephone", u.Telephone);

                cmdUser.Parameters.AddWithValue("@UserRole", u.UserRole);

                conUser.Open();
                cmdUser.ExecuteNonQuery();
                conUser.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUser.Close();
            }
            finally
            {
                conUser.Close();
            }
        }

        public void UpdateShippingDetails(clsShipping s)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spUpdateShippingDetails", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;

                cmdShipping.Parameters.AddWithValue("@ShippingReferenceNumber", s.ShippingReferenceNumber);
                cmdShipping.Parameters.AddWithValue("@BookingNumber", s.BookingNumber);

                cmdShipping.Parameters.AddWithValue("@InvoiceNumber", s.InvoiceNumber);
                cmdShipping.Parameters.AddWithValue("@CustomerName", s.CustomerName);

                cmdShipping.Parameters.AddWithValue("@ShippingFrom", s.ShippingFrom);
                cmdShipping.Parameters.AddWithValue("@ShippingTo", s.ShippingTo);

                cmdShipping.Parameters.AddWithValue("@ShippingPort", s.ShippingPort);
                cmdShipping.Parameters.AddWithValue("@FreightType", s.FreightName);

                cmdShipping.Parameters.AddWithValue("@ShippingDate", s.ShippingDate);
                cmdShipping.Parameters.AddWithValue("@ArrivalDate", s.ArrivalDate);

                cmdShipping.Parameters.AddWithValue("@Consignee", s.Consignee);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        public void UpdateUserRoles(UserRoles ur)
        {
            SqlConnection conUserRoles = new SqlConnection(sConnectionString);
            SqlCommand cmdUserRoles = new SqlCommand("spUpdateUserRoles", conUserRoles);

            try
            {
                cmdUserRoles.CommandType = CommandType.StoredProcedure;

                cmdUserRoles.Parameters.AddWithValue("@RoleId", ur.RoleId);
                cmdUserRoles.Parameters.AddWithValue("@RoleName", ur.RoleName);
                cmdUserRoles.Parameters.AddWithValue("@Menu_Name", ur.Menu_Name);
                cmdUserRoles.Parameters.AddWithValue("@AssignBookingToDriver", ur.AssignBookingToDriver);//0
                cmdUserRoles.Parameters.AddWithValue("@AddDriverToAssignBooking", ur.AddDriverToAssignBooking);//1
                cmdUserRoles.Parameters.AddWithValue("@AddBooking", ur.AddBooking);//2
                cmdUserRoles.Parameters.AddWithValue("@AddShipping", ur.AddShipping);//3
                cmdUserRoles.Parameters.AddWithValue("@AddCustomer", ur.AddCustomer);//4
                cmdUserRoles.Parameters.AddWithValue("@AddDriver", ur.AddDriver);//5
                cmdUserRoles.Parameters.AddWithValue("@AddWarehouse", ur.AddWarehouse);//6
                cmdUserRoles.Parameters.AddWithValue("@AddLocation", ur.AddLocation);//7
                cmdUserRoles.Parameters.AddWithValue("@AddZone", ur.AddZone);//8
                cmdUserRoles.Parameters.AddWithValue("@AddUser", ur.AddUser);//9
                cmdUserRoles.Parameters.AddWithValue("@PrintDetails", ur.PrintDetails);//10
                cmdUserRoles.Parameters.AddWithValue("@ExportToPDF", ur.ExportToPDF);//11
                cmdUserRoles.Parameters.AddWithValue("@ExportToExcel", ur.ExportToExcel);//12

                conUserRoles.Open();
                cmdUserRoles.ExecuteNonQuery();
                conUserRoles.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUserRoles.Close();
            }
            finally
            {
                conUserRoles.Close();
            }
        }

        public void UpdateUserAccess(UserAccess ua)
        {
            SqlConnection conUserAccess = new SqlConnection(sConnectionString);
            SqlCommand cmdUserAccess = new SqlCommand("spUpdateUserAccess", conUserAccess);

            try
            {
                cmdUserAccess.CommandType = CommandType.StoredProcedure;

                cmdUserAccess.Parameters.AddWithValue("@UserId", ua.UserId);
                cmdUserAccess.Parameters.AddWithValue("@RoleName", ua.RoleName);
                cmdUserAccess.Parameters.AddWithValue("@WhetherDefault", ua.WhetherDefault);
                cmdUserAccess.Parameters.AddWithValue("@Menu_Name", ua.Menu_Name);
                cmdUserAccess.Parameters.AddWithValue("@AssignBookingToDriver", ua.AssignBookingToDriver);//0
                cmdUserAccess.Parameters.AddWithValue("@AddDriverToAssignBooking", ua.AddDriverToAssignBooking);//1
                cmdUserAccess.Parameters.AddWithValue("@AddBooking", ua.AddBooking);//2
                cmdUserAccess.Parameters.AddWithValue("@AddShipping", ua.AddShipping);//3
                cmdUserAccess.Parameters.AddWithValue("@AddCustomer", ua.AddCustomer);//4
                cmdUserAccess.Parameters.AddWithValue("@AddDriver", ua.AddDriver);//5
                cmdUserAccess.Parameters.AddWithValue("@AddWarehouse", ua.AddWarehouse);//6
                cmdUserAccess.Parameters.AddWithValue("@AddLocation", ua.AddLocation);//7
                cmdUserAccess.Parameters.AddWithValue("@AddZone", ua.AddZone);//8
                cmdUserAccess.Parameters.AddWithValue("@AddUser", ua.AddUser);//9
                cmdUserAccess.Parameters.AddWithValue("@PrintDetails", ua.PrintDetails);//10
                cmdUserAccess.Parameters.AddWithValue("@ExportToPDF", ua.ExportToPDF);//11
                cmdUserAccess.Parameters.AddWithValue("@ExportToExcel", ua.ExportToExcel);//12

                conUserAccess.Open();
                cmdUserAccess.ExecuteNonQuery();
                conUserAccess.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUserAccess.Close();
            }
            finally
            {
                conUserAccess.Close();
            }
        }

        public void ChangeComplaintStatus(string ComplaintId, string ComplaintStatus)
        {
            SqlConnection conComplaint = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdComplaint = new SqlCommand("spChangeComplaintStatus", conComplaint);
                cmdComplaint.CommandType = CommandType.StoredProcedure;

                cmdComplaint.Parameters.AddWithValue("@ComplaintId", ComplaintId);
                cmdComplaint.Parameters.AddWithValue("@ComplaintStatus", ComplaintStatus);

                conComplaint.Open();
                cmdComplaint.ExecuteNonQuery();
                conComplaint.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conComplaint.Close();
            }
            finally
            {
                conComplaint.Close();
            }
        }

        #endregion

        #region Cancel Zone

        public void CancelBooking(Booking b)
        {
            SqlConnection conBooking = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdBooking = new SqlCommand("spCancelBooking", conBooking);
                cmdBooking.CommandType = CommandType.StoredProcedure;

                cmdBooking.Parameters.AddWithValue("@BookingId", b.BookingId);
                cmdBooking.Parameters.AddWithValue("@OrderStatus", b.OrderStatus);
                cmdBooking.Parameters.AddWithValue("@Reason", b.Reason);

                conBooking.Open();
                cmdBooking.ExecuteNonQuery();
                conBooking.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conBooking.Close();
            }
            finally
            {
                conBooking.Close();
            }
        }

        public void CancelShipping(string sShippingId)
        {
            SqlConnection conShipping = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdShipping = new SqlCommand("spCancelShipping", conShipping);
                cmdShipping.CommandType = CommandType.StoredProcedure;
                cmdShipping.Parameters.AddWithValue("@ShippingId", sShippingId);

                conShipping.Open();
                cmdShipping.ExecuteNonQuery();
                conShipping.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conShipping.Close();
            }
            finally
            {
                conShipping.Close();
            }
        }

        #endregion

        #region Delete Zone

        public void DeleteUser(string sUserId)
        {
            SqlConnection conUser = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdUser = new SqlCommand("spDeleteUser", conUser);
                cmdUser.CommandType = CommandType.StoredProcedure;
                cmdUser.Parameters.AddWithValue("@UserId", sUserId);

                conUser.Open();
                cmdUser.ExecuteNonQuery();
                conUser.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conUser.Close();
            }
            finally
            {
                conUser.Close();
            }
        }

        public void DeleteCustomer(string sCustomerId)
        {
            SqlConnection conCustomer = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCustomer = new SqlCommand("spDeleteCustomer", conCustomer);
                cmdCustomer.CommandType = CommandType.StoredProcedure;
                cmdCustomer.Parameters.AddWithValue("@CustomerId", sCustomerId);

                conCustomer.Open();
                cmdCustomer.ExecuteNonQuery();
                conCustomer.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCustomer.Close();
            }
            finally
            {
                conCustomer.Close();
            }
        }

        public void DeactivateCustomer(string sCustomerId)
        {
            SqlConnection conCustomer = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdCustomer = new SqlCommand("spDeactivateCustomer", conCustomer);
                cmdCustomer.CommandType = CommandType.StoredProcedure;
                cmdCustomer.Parameters.AddWithValue("@CustomerId", sCustomerId);

                conCustomer.Open();
                cmdCustomer.ExecuteNonQuery();
                conCustomer.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conCustomer.Close();
            }
            finally
            {
                conCustomer.Close();
            }
        }

        public void DeactivateDriver(string sDriverId)
        {
            SqlConnection conDriver = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDriver = new SqlCommand("spDeactivateDriver", conDriver);
                cmdDriver.CommandType = CommandType.StoredProcedure;
                cmdDriver.Parameters.AddWithValue("@DriverId", sDriverId);

                conDriver.Open();
                cmdDriver.ExecuteNonQuery();
                conDriver.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDriver.Close();
            }
            finally
            {
                conDriver.Close();
            }
        }

        public void RemoveBookingDetails(string sBookingId)
        {
            SqlConnection conRBD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRBD = new SqlCommand("spRemoveBookingDetails", conRBD);
                cmdRBD.CommandType = CommandType.StoredProcedure;
                cmdRBD.Parameters.AddWithValue("@BookingId", sBookingId);

                conRBD.Open();
                cmdRBD.ExecuteNonQuery();
                conRBD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRBD.Close();
            }
            finally
            {
                conRBD.Close();
            }
        }

        public void RemoveImageDetails(string sBookingId)
        {
            SqlConnection conRID = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRID = new SqlCommand("spRemoveImageDetails", conRID);
                cmdRID.CommandType = CommandType.StoredProcedure;
                cmdRID.Parameters.AddWithValue("@BookingId", sBookingId);

                conRID.Open();
                cmdRID.ExecuteNonQuery();
                conRID.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRID.Close();
            }
            finally
            {
                conRID.Close();
            }
        }

        public void RemoveLocationDetails(string sLocationId)
        {
            SqlConnection conRLD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRLD = new SqlCommand("spRemoveLocationDetails", conRLD);
                cmdRLD.CommandType = CommandType.StoredProcedure;
                cmdRLD.Parameters.AddWithValue("@LocationId", sLocationId);

                conRLD.Open();
                cmdRLD.ExecuteNonQuery();
                conRLD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRLD.Close();
            }
            finally
            {
                conRLD.Close();
            }
        }

        public void RemoveWarehouseDetails(string sWarehouseId)
        {
            SqlConnection conRWD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRWD = new SqlCommand("spRemoveWarehouseDetails", conRWD);
                cmdRWD.CommandType = CommandType.StoredProcedure;
                cmdRWD.Parameters.AddWithValue("@WarehouseId", sWarehouseId);

                conRWD.Open();
                cmdRWD.ExecuteNonQuery();
                conRWD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRWD.Close();
            }
            finally
            {
                conRWD.Close();
            }
        }

        public void RemoveZoneDetails(string sZoneId)
        {
            SqlConnection conRZD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRZD = new SqlCommand("spRemoveZoneDetails", conRZD);
                cmdRZD.CommandType = CommandType.StoredProcedure;
                cmdRZD.Parameters.AddWithValue("@ZoneId", sZoneId);

                conRZD.Open();
                cmdRZD.ExecuteNonQuery();
                conRZD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRZD.Close();
            }
            finally
            {
                conRZD.Close();
            }
        }

        public void RemoveUserDetails(string sUserId)
        {
            SqlConnection conRUD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRUD = new SqlCommand("spRemoveUserDetails", conRUD);
                cmdRUD.CommandType = CommandType.StoredProcedure;
                cmdRUD.Parameters.AddWithValue("@UserId", sUserId);

                conRUD.Open();
                cmdRUD.ExecuteNonQuery();
                conRUD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRUD.Close();
            }
            finally
            {
                conRUD.Close();
            }
        }

        public void RemoveShippingDetails(string sShippingId)
        {
            SqlConnection conRSD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRSD = new SqlCommand("spRemoveShippingDetails", conRSD);
                cmdRSD.CommandType = CommandType.StoredProcedure;
                cmdRSD.Parameters.AddWithValue("@ShippingId", sShippingId);

                conRSD.Open();
                cmdRSD.ExecuteNonQuery();
                conRSD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRSD.Close();
            }
            finally
            {
                conRSD.Close();
            }
        }

        public void RemoveComplaintDetails(string sComplaintId)
        {
            SqlConnection conRCD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdRCD = new SqlCommand("spRemoveComplaintDetails", conRCD);
                cmdRCD.CommandType = CommandType.StoredProcedure;
                cmdRCD.Parameters.AddWithValue("@ComplaintId", sComplaintId);

                conRCD.Open();
                cmdRCD.ExecuteNonQuery();
                conRCD.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conRCD.Close();
            }
            finally
            {
                conRCD.Close();
            }
        }

        #endregion

        #region Deactivate Zone

        public void DeactivateUser(string sUserId)
        {
            SqlConnection conDU = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdDU = new SqlCommand("spDeactivateUser", conDU);
                cmdDU.CommandType = CommandType.StoredProcedure;
                cmdDU.Parameters.AddWithValue("@UserId", sUserId);

                conDU.Open();
                cmdDU.ExecuteNonQuery();
                conDU.Close();
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conDU.Close();
            }
            finally
            {
                conDU.Close();
            }
        }

        #endregion

        #region View Zone

        public DataTable ViewBookingDetails(string sBookingId)
        {
            DataSet dsVBD = new DataSet();
            DataTable dtVBD = new DataTable();

            SqlConnection conVBD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdVBD = new SqlCommand("spViewBookingDetails", conVBD);
                cmdVBD.CommandType = CommandType.StoredProcedure;
                cmdVBD.Parameters.AddWithValue("@BookingId", sBookingId);

                SqlDataAdapter daVBD = new SqlDataAdapter(cmdVBD);
                dsVBD = new DataSet();
                daVBD.Fill(dsVBD);
                dtVBD = dsVBD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conVBD.Close();
            }
            finally
            {
                //conVBD.Close();
            }

            return dtVBD;
        }

        public DataTable ViewQuotingDetails(string sQuotingId)
        {
            DataSet dsVQD = new DataSet();
            DataTable dtVQD = new DataTable();

            SqlConnection conVQD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdVQD = new SqlCommand("spViewQuotingDetails", conVQD);
                cmdVQD.CommandType = CommandType.StoredProcedure;
                cmdVQD.Parameters.AddWithValue("@QuotingId", sQuotingId);

                SqlDataAdapter daVQD = new SqlDataAdapter(cmdVQD);
                dsVQD = new DataSet();
                daVQD.Fill(dsVQD);
                dtVQD = dsVQD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conVQD.Close();
            }
            finally
            {
                //conVQD.Close();
            }

            return dtVQD;
        }

        public DataTable ViewQuotationDetails(string sQuotingId)
        {
            DataSet dsVQD = new DataSet();
            DataTable dtVQD = new DataTable();

            SqlConnection conVQD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdVQD = new SqlCommand("spViewQuotationDetails", conVQD);
                cmdVQD.CommandType = CommandType.StoredProcedure;
                cmdVQD.Parameters.AddWithValue("@QuotingId", sQuotingId);

                SqlDataAdapter daVQD = new SqlDataAdapter(cmdVQD);
                dsVQD = new DataSet();
                daVQD.Fill(dsVQD);
                dtVQD = dsVQD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conVQD.Close();
            }
            finally
            {
                //conVQD.Close();
            }

            return dtVQD;
        }

        public DataTable ViewPaymentDetails(string sBookingId)
        {
            DataSet dsVPD = new DataSet();
            DataTable dtVPD = new DataTable();

            SqlConnection conVPD = new SqlConnection(sConnectionString);

            try
            {
                SqlCommand cmdVPD = new SqlCommand("spViewPaymentDetails", conVPD);
                cmdVPD.CommandType = CommandType.StoredProcedure;
                cmdVPD.Parameters.AddWithValue("@BookingId", sBookingId);

                SqlDataAdapter daVPD = new SqlDataAdapter(cmdVPD);
                dsVPD = new DataSet();
                daVPD.Fill(dsVPD);
                dtVPD = dsVPD.Tables[0];
            }
            catch (Exception ex)
            {
                //throw ex;
                sErrMsg = ex.Message + Environment.NewLine;
                File.AppendAllText(sExceptionLogFilePath, sErrMsg);
                //conVPD.Close();
            }
            finally
            {
                //conVPD.Close();
            }

            return dtVPD;
        }

        #endregion
    }
}

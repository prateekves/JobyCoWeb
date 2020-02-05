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
using JobyCoWebCustomize.Models;
using System.Data;
using System.Web.Services;

#endregion

namespace JobyCoWebCustomize
{
    public partial class Login : System.Web.UI.Page
    {
        #region Required Global Classes

        static clsOperation objOP = new clsOperation();
        static clsDB objDB = new clsDB();
        static clsCryptography objCG = new clsCryptography();
        static ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                #region Checking SessionID

                BOLogin ObjLogin = new BOLogin();
                ObjLogin = (BOLogin)Session["Login"];

                if (ObjLogin != null)
                {
                    string sessionid = ObjLogin.SESSIONID;
                    if (sessionid == "")
                    {
                        Response.Redirect("/Login.aspx");
                    }
                    else
                    {
                        //Master.LoggedInUser = objOP.GetUserName(ObjLogin.EMAILID.ToString());
                    }
                }

                #endregion
            }
            if (Request.QueryString["Email"] != null)
            {
                txtEmailID.Text = Request.QueryString["Email"].ToString();
            }
            
        }

        //[WebMethod]
        //public static string getLoginResult(string EmailID, string Password)
        //{
        //    string sEmailID = EmailID;
        //    string sMessage = string.Empty;

        //    if (!objOP.CheckExistence("EmailID", sEmailID, "Users"))
        //    {
        //        sMessage = "Login failed";
        //    }
        //    else
        //    {
        //        string sLocked = objOP.RetrieveField2FromField1("Locked", "Users", "EmailID", sEmailID);
        //        bool bLocked = Convert.ToBoolean(sLocked);
        //        if (!bLocked)
        //        {
        //            string sPassword = objCG.getMd5Hash(Password);

        //            DataTable dtLogin = objDB.CheckLogin(sEmailID, sPassword);
        //            if (objOP.CheckLogin(dtLogin))
        //            {
        //                sMessage = "Login successful";
        //            }
        //            else
        //            {
        //                sMessage = "Invalid Username / Password";
        //            }
        //        }
        //        else
        //        {
        //            sMessage = "This User is Deactivated";
        //        }
        //    }

        //    return sMessage;
        //}

        [WebMethod]
        public static string CheckLogin(string Email, string Password)
        {
            DataTable dt = new DataTable();
            dt = objDB.CheckLogin(Email, Password);
            return dt.Rows.Count.ToString();
        }


        public string GetLoginResult(string EmailID, string Password)
        {
            string sEmailID = EmailID;
            string sMessage = string.Empty;

            if (!objOP.CheckExistence("EmailID", sEmailID, "Users"))
            {
                sMessage = "This User doesn't exist";
            }
            else
            {
                string sLocked = objOP.RetrieveField2FromField1("Locked", "Users", "EmailID", sEmailID);
                bool bLocked = Convert.ToBoolean(sLocked);
                if (!bLocked)
                {
                    //New Code Added for User Role
                    //====================================
                    string sUserRole = objOP.RetrieveField2FromField1("UserRole", "Users", "EmailID", sEmailID);

                    switch(sUserRole)
                    {
                        case "SuperAdmin":
                        case "Administrator":
                        case "Staff":
                        case "Customer":
                            string sPassword = objCG.getMd5Hash(Password);

                            DataTable dtLogin = objDB.CheckLogin(sEmailID, sPassword);
                            if (objOP.CheckLogin(dtLogin))
                            {
                                sMessage = "Login successful";
                            }
                            else
                            {
                                sMessage = "Invalid Username / Password";
                            }

                            break;
                        default:
                            sMessage = "You are not authorized to Login here";
                            break;
                    }
                    //====================================
                }
                else
                {
                    sMessage = "This User is Deactivated";
                }
            }

            return sMessage;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string sEmailID = txtEmailID.Text.Trim().ToLower();
            string sPassword = txtPassword.Text.Trim();
            string sMessage = GetLoginResult(sEmailID, sPassword);

            BOLogin ObjLogin = new BOLogin();
            if (sMessage.Equals("Login successful"))
            {
                ObjLogin.EMAILID = sEmailID;
                ObjLogin.PASSWORD = sPassword;
                ObjLogin.SESSIONID = Session.SessionID;
                Session["Login"] = ObjLogin;

                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                objCM.ShowErrorMessage(lblErrMsg, sMessage);
            }
        }

        protected void btnLogin_Click1(object sender, EventArgs e)
        {
            string sEmailID = txtEmailID.Text.Trim().ToLower();
            string sPassword = txtPassword.Text.Trim();
            string sMessage = GetLoginResult(sEmailID, sPassword);

            BOLogin ObjLogin = new BOLogin();
            if (sMessage.Equals("Login successful"))
            {
                ObjLogin.EMAILID = sEmailID;
                ObjLogin.PASSWORD = sPassword;
                ObjLogin.SESSIONID = Session.SessionID;
                Session["Login"] = ObjLogin;

                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                objCM.ShowErrorMessage(lblErrMsg, sMessage);
            }
        }
    }
}
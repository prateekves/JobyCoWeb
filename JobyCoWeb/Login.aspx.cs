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
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.SessionState;

#endregion

namespace JobyCoWeb
{
    public partial class Login : System.Web.UI.Page
    {
        #region Required Global Classes

        clsOperation objOP = new clsOperation();
        clsDB objDB = new clsDB();
        clsCryptography objCG = new clsCryptography();
        ControlModels objCM = new ControlModels();

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

        }

        public string GetLoginResult(string EmailID, string Password, string sVisitorCountry)
        {
            string sEmailID = EmailID;
            string sMessage = string.Empty;

            if (!objOP.CheckExistence("EmailID", sEmailID, "Users"))
            {
                sMessage = "This User doesn't exist";
            }
            else if (!objOP.CheckExistence("EmailID", sEmailID, "Country", sVisitorCountry, "Users"))
            {
                sMessage = "This User is not authorized to login in " + sVisitorCountry;
            }
            else
            {
                string sLocked = objOP.RetrieveField2FromField1("Locked", "Users", "EmailID", sEmailID);
                bool bLocked = Convert.ToBoolean(sLocked);
                if (!bLocked)
                {
                    //For Restricting Menus: -
                    //1) Taking UserRole into Session 
                    //=====================================================
                    string sUserRole = objOP.RetrieveField2FromField1("UserRole", "Users", "EmailID", sEmailID);

                    Session["UserRole"] = sUserRole;
                    //=====================================================

                    //2) Taking UserId into Session
                    //=====================================================
                    string sUserId = objOP.RetrieveField2FromField1("UserId", "Users", "EmailID", sEmailID);

                    Session["UserId"] = sUserId;
                    //=====================================================

                    //3) Taking RoleId into Session
                    //=====================================================
                    string sRoleId = objOP.RetrieveDistinctField2FromField1("RoleId", "RoleAccess", "RoleName", sUserRole);

                    Session["RoleId"] = sRoleId;
                    //=====================================================

                    switch (sUserRole)
                    {
                        case "SuperAdmin":
                        case "Administrator":
                        case "Staff":
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
            string sVisitorCountry = hfSetLocation.Value;
            string sMessage = GetLoginResult(sEmailID, sPassword, sVisitorCountry);

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
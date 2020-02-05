﻿using System;
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

#endregion

namespace JobyCoWeb
{
    public partial class Register : System.Web.UI.Page
    {
        #region Required Global Classes

        clsOperation objOP = new clsOperation();
        clsDB objDB = new clsDB();
        clsCryptography objCG = new clsCryptography();
        ControlModels objCM = new ControlModels();
        
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            objCM.ResetMessageBar(lblErrMsg);

            if (!IsPostBack)
            {
                #region Binding Dropdowns

                DataTable dtTitle = objDB.GetDropDownValues(1, 1);
                objCM.FillDropDown(ddlTitle, "Title", dtTitle);

                DataTable dtCountry = objDB.GetDropDownValues(10, 13);
                objCM.FillDropDown(ddlCountry, "Country", dtCountry);

                DataTable dtRole = objDB.GetDropDownValues(1, 2);
                objCM.FillDropDown(ddlUserRole, "Role", dtRole);

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
                }

                #endregion

            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (objOP.CheckExistence("EmailID", txtEmailID.Text.Trim(), "Users"))
            {
                objCM.ShowErrorMessage(lblErrMsg, "This User Exists..Try another..");
                return;
            }

            if (fuPhoto.HasFile)
            {
                fuPhoto.SaveAs(Server.MapPath("/images/users/" + fuPhoto.FileName));
            }
            else
            {
                objCM.ShowErrorMessage(lblErrMsg, "Please select your Photo");
                return;
            }

            #region UserDetails

            EntityLayer.User u = new EntityLayer.User();

            u.UserId = objOP.GetAutoGeneratedValue("UserId", "Users", "USR", 9);
            u.EmailID = txtEmailID.Text.Trim();

            //u.Password = objCG.EncodingPassword(txtPassword.Text.Trim()); 
            u.Password = objCG.getMd5Hash(txtPassword.Text.Trim());

            u.Title = ddlTitle.SelectedItem.Text.Trim(); 
            u.FirstName = txtFirstName.Text.Trim(); 
            u.LastName = txtLastName.Text.Trim();
            u.DOB = Convert.ToDateTime(txtDOB.Text.Trim());
            u.Address = txtAddressLine1.Text.Trim() + ", "
                + txtAddressLine2.Text.Trim() + ", "
                + txtAddressLine3.Text.Trim(); 
            u.Town = txtTown.Text.Trim(); 
            u.Country = ddlCountry.SelectedItem.Text.Trim();
            u.PostCode = txtPostCode.Text.Trim();
            u.Mobile = txtMobile.Text.Trim(); 
            u.Telephone = txtTelephone.Text.Trim(); 
            u.SecretQuestion = txtSecretQuestion.Text.Trim();
            u.SecretAnswer = txtSecretAnswer.Text.Trim();
            u.UserRole = ddlUserRole.SelectedItem.Text.Trim(); 
            u.Locked = false;

            #endregion

            try
            {
                objDB.AddUserDetails(u);
                objCM.ShowSuccessMessage(lblErrMsg, "User added successfully");
            }
            catch
            {
                objCM.ShowErrorMessage(lblErrMsg, "Failed to add User");
            }
        }
    }
}
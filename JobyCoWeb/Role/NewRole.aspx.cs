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
using System.Web.Services;

#endregion

namespace JobyCoWeb.Role
{
    public partial class NewRole : System.Web.UI.Page
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
        public static string GetNewRoleId()
        {
            return objOP.GetAutoGeneratedValue("RoleId", "Roles", "ROLE", 9);
        }

        [WebMethod]
        public static void AddRoleDetails
        (
            string RoleId,
            string RoleName
        )
        {
            EntityLayer.Role objRole = new EntityLayer.Role();

            objRole.RoleId = RoleId;
            objRole.RoleName = RoleName;

            objDB.AddRoleDetails(objRole);
        }
    }
}
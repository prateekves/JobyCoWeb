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

namespace JobyCoWeb
{
    public partial class JobyCo : System.Web.UI.MasterPage
    {
        #region Required Global Classes

        clsOperation objOP = new clsOperation();
        clsDB objDB = new clsDB();
        clsCryptography objCG = new clsCryptography();
        ControlModels objCM = new ControlModels();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            objCM.Logout();
        }
    }
}
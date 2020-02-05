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
    public partial class JobyCoWithMenuBar : System.Web.UI.MasterPage
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
        // after sign up works as a logged in user code
        //protected void btnSignUpForFreeAccount_Click(object sender, EventArgs e)
        //{
        //    string sEmailID = txtEmailID.Text.Trim();
        //    Session["Signedup"] = sEmailID;
        //    Session["Login"] = sEmailID;
        //    Response.AppendHeader("Refresh", "3;url=/Dashboard.aspx");
        //    //Response.Redirect("/Dashboard.aspx");
        //}

        /*public string LoggedInUser
        {
            get
            {
                return lblLoggedInUser.Text;
            }
            set
            {
                lblLoggedInUser.Text = value;
            }
        }*/
    }
}
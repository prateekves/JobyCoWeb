using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using JobyCoWeb.Models;

namespace JobyCoWeb
{
    public partial class DashView : System.Web.UI.MasterPage
    {
        ControlModels objCM = new ControlModels();

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            objCM.Logout();
        }

        public string LoggedInUser
        {
            get
            {
                return lblLoggedInUser.Text;
            }
            set
            {
                lblLoggedInUser.Text = value;
            }
        }
    }
}
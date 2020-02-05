using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class BOLogin
    {
        private string emailid;

        public string EMAILID
        {
            get { return emailid; }
            set { emailid = value; }
        }

        private string Password;

        public string PASSWORD
        {
            get { return Password; }
            set { Password = value; }
        }

        private string SessionID;

        public string SESSIONID
        {
            get { return SessionID; }
            set { SessionID = value; }
        }
    }
}

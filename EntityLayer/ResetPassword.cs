using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class ResetPassword
    {
        public string EmailID { get; set; }
        public string EncryptedEmailID { get; set; }
        public bool PasswordChanged { get; set; }
        public DateTime PasswordChangeDate { get; set; }
    }
}

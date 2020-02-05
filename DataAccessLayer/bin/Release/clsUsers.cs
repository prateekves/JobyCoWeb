using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class clsUsers
    {
        public string UserId { get; set; }
        public string EmailID { get; set; }
        public string CustomerName { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Address { get; set; }
        public string Town { get; set; }
        public string Country { get; set; }
        public string PostCode { get; set; }
        public string Mobile { get; set; }
        public string Telephone { get; set; }
        public string UserRole { get; set; }
    }
}

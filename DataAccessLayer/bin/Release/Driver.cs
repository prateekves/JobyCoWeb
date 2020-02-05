using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Driver
    {
        public string DriverId { get; set; }
        public string EmailID { get; set; }
        public string Password { get; set; }
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DOB { get; set; }
        public string Address { get; set; }
        public string Town { get; set; }
        public string Country { get; set; }
        public string PostCode { get; set; }
        public string Mobile { get; set; }
        public string Landline { get; set; }

        //Two New Fields Added
        //===========================
        public string DriverType { get; set; }
        public string WageType { get; set; }
        //===========================

        public bool Enabled { get; set; }
        public string WarehouseId { get; set; }
    }
}

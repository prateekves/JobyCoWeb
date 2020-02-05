using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class clsCustomers
    {
        public string CustomerId { get; set; }
        public string EmailID { get; set; }
        public string CustomerName { get; set; }
        public DateTime DOB { get; set; }
        public string Address { get; set; }
        public string Mobile { get; set; }
        public string PostCode { get; set; }
        public decimal LatitudePickup { get; set; }
        public decimal LongitudePickup { get; set; }
        public string Title { get; set; }
        public string sDOB { get; set; }
    }
}

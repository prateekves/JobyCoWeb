using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AllAssignedBookings
    {
        public string DriverName { get; set; }
        public string BookingId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string Address { get; set; }
        public string PostCode { get; set; }
        public string Mobile { get; set; }
        public decimal Wage { get; set; }
    }
}

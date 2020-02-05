using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AssignBookingToDriver
    {
        public string AssignId { get; set; }
        public string DriverId { get; set; }
        public string BookingId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string PickupAddress { get; set; }
        public string PickupPostCode { get; set; }
        public string PickupMobile { get; set; }
        public decimal Wage { get; set; }
        public string OptionType { get; set; }
    }
}

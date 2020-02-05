using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AllUnassignedBookings
    {
        public string BookingId { get; set; }
        public string CustomerName { get; set; }
        public DateTime PickupDateTime { get; set; }
        public string PickupAddress { get; set; }
        public string OrderStatus { get; set; }
        public string PickupPostCode { get; set; }
        public string PickupMobile { get; set; }
    }
}

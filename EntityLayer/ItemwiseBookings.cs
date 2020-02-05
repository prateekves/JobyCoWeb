using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class ItemwiseBookings
    {
        public string BookingId { get; set; }
        public string PickupCategory { get; set; }
        public string PickupItem { get; set; }
        public int ItemCount { get; set; }
        public decimal TotalValue { get; set; }
        public DateTime BookingDate { get; set; }
    }
}

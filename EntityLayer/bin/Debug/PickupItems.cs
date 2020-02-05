using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class PickupItems
    {
        public int PickupItemId { get; set; }
        public string PickupItem { get; set; }
        //View Shipping Pickup Item
        public string BookingId { get; set; }
        public string Items { get; set; }
        public decimal Cost { get; set; }
        public decimal EstimatedValue { get; set; }
        public string Status { get; set; }
        public int Quantity { get; set; }

    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class DeliveryItem
    {
        public string BookingId { get; set; }
        public string Items { get; set; }
        public decimal Cost { get; set; }
        public decimal EstimatedValue { get; set; }
        public string Status { get; set; }
        public int Quantity { get; set; }
    }
}

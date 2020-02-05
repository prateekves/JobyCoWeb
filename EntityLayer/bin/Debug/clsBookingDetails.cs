using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class clsBookingDetails
    {
        public string Item { get; set; }
        public decimal Cost { get; set; }
        public decimal EstimatedValue { get; set; }
        public string Status { get; set; }
        public string BookingId { get; set; }
        public string PickupCategoryId { get; set; }
        public string PickupItemId { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AddressDetails
    {
        public string BookingId { get; set; }
        public string Address { get; set; }
        public string PickupName { get; set; }
        public string PostCode { get; set; }
        public string Mobile { get; set; }
        public decimal LatitudePickup { get; set; }
        public decimal LongitudePickup { get; set; }
        public string PickupTitle { get; set; }
    }
}

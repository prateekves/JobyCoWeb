using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class CustomerInformation
    {
        public string CustomerId { get; set; }

        public string BookingId { get; set; }
        public string CustomerName { get; set; }
        public string PickupAddress { get; set; }
        public string DeliveryAddress { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
    }
}

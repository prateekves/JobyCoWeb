using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class ShippingDetails
    {
        public string ShippingId { get; set; }
        public string ContainerId { get; set; }
        public string BookingId { get; set; }

        public string PickupId { get; set; }
        public string InvoiceNumber { get; set; }

        public decimal InvoiceAmount { get; set; }

        public decimal Paid { get; set; }
        public int Items { get; set; }
        public string Loaded { get; set; }
        public string Remaining { get; set; }
        public string CategoryId { get; set; }
        public string CategoryItemId { get; set; }

        public List<ShippingItemDetails> listShippingItemDetails = new List<ShippingItemDetails>();
    }

    public class ShippingItemDetails
    {
        public string BookingId { get; set; }

        public string PickupId { get; set; }

        public string CategoryId { get; set; }
        public string CategoryItemId { get; set; }
    }
}

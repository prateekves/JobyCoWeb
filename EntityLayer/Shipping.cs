using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Shippings
    {
        public string ShippingId { get; set; }
        public string ContainerId { get; set; }
        public string SealId { get; set; }
        public string BookingId { get; set; }
        public string CustomerId { get; set; }
        public string ShippingFrom { get; set; }
        public string ShippingTo { get; set; }
        public string ShippingPort { get; set; }
        public string FreightType { get; set; }
        public DateTime? ShippingDate { get; set; }
        public DateTime? ArrivalDate { get; set; }

        public DateTime? ETA { get; set; }
        public string Consignee { get; set; }
        public string InvoiceNumber { get; set; }
        public decimal InvoiceAmount { get; set; }
        public decimal Paid { get; set; }
        public int ItemCount { get; set; }
        public int Loaded { get; set; }
        public int Remaining { get; set; }

        public int Shipped { get; set; }
        public string WarehouseId { get; set; }
        public string UserId { get; set; }
        public string PickupId { get; set; }

        public string GhanaPort { get; set; }
        public string sShippingDate { get; set; }
        public string sETA { get; set; }

        public List<ShippingDetails> listShippingDetails = new List<ShippingDetails>();
        //public List<ShippingDetails> listShippingDetails = 
        //    new List<ShippingDetails>(){
        //        new ShippingDetails {
        //            listShippingItemDetails = 
        //                new List<ShippingItemDetails>()
        //    }
        //};
    }
}

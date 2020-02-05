using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class BookingPayment
    {
        public string BookingId { get; set; }
        public string RegisteredCompanyName { get; set; }
        public string InsurancePremium { get; set; }
        public string PickupAddress { get; set; }
        public string RecipentAddress { get; set; }
        public int ItemCount { get; set; }
        public decimal TotalValue { get; set; }
        public string PostCode { get; set; }

        //New Fields Added for Order Booking 
        //====================================================
        public string CollectionName { get; set; }
        public string CollectionMobile { get; set; }
        public string DeliveryName { get; set; }
        public string DeliveryMobile { get; set; }

        public string CollectionPostCode { get; set; }
        public string DeliveryPostCode { get; set; }

        public decimal LatitudePickup { get; set; }
        public decimal LongitudePickup { get; set; }
        public decimal LatitudeDelivery { get; set; }
        public decimal LongitudeDelivery { get; set; }
        //====================================================
        public DateTime Bookingdate { get; set; }

        //A Couple of New Fields Added for Pickup and Delivery
        //======================================================
        public string PickupEmail { get; set; }
        public string DeliveryEmail { get; set; }
        //======================================================

        public bool IsAssigned { get; set; }
        public bool WhetherOtherExists { get; set; }
        public string PickupTitle { get; set; }
        public string DeliveryTitle { get; set; }
        public string AltPickupMobile { get; set; }
        public string AltDeliveryMobile { get; set; }
        public string BookingNotes { get; set; }
        public string StatusDetails { get; set; }
        public DateTime PickupDateTime { get; set; }
    }
}

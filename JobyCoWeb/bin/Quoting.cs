using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Quoting
    {
        public string QuotingId { get; set; }
        public string CustomerId { get; set; }
        public string PickupCategory { get; set; }
        public DateTime PickupDateTime { get; set; }
        public string PickupAddress { get; set; }
        public decimal Width { get; set; }
        public decimal Height { get; set; }
        public decimal Length { get; set; }
        public bool IsFragile { get; set; }
        public decimal EstimatedValue { get; set; }
        public int ItemCount { get; set; }
        public decimal TotalValue { get; set; }
        public string DeliveryCategory { get; set; }
        public DateTime DeliveryDateTime { get; set; }
        public string RecipientAddress { get; set; }
        public int DeliveryQuantity { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal TotalCharge { get; set; }
        public string QuotingNotes { get; set; }
        public string OrderStatus { get; set; }
        public string PickupItem { get; set; }
        public decimal VAT { get; set; }
        public decimal InsurancePremium { get; set; }

        //New Fields Added for Order Booking 
        //====================================================
        public string PickupName { get; set; }
        public string PickupMobile { get; set; }
        public string DeliveryName { get; set; }
        public string DeliveryMobile { get; set; }

        public string PickupPostCode { get; set; }
        public string DeliveryPostCode { get; set; }
        //====================================================
        public DateTime QuotingDate { get; set; }

        //A Couple of New Fields Added for Pickup and Delivery
        //======================================================
        public string PickupEmail { get; set; }
        public string DeliveryEmail { get; set; }
        //======================================================

        public bool WhetherOtherExists { get; set; }
    }
}

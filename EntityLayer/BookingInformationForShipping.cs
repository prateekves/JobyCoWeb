using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class BookingInformationForShipping
    {
        public string BookingId { get; set; }
        public string  InvoiceNumber { get; set; }
        public string InvoiceAmount { get; set; }
        public string Paid { get; set; }
        public string Items { get; set; }
        public string Loaded { get; set; }
        public string Remaining { get; set; }

        public string PickupId { get; set; }

        public string CustomerId { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }

        public string Mobile { get; set; }

        public string PickupCategoryId { get; set; }
        public string PickupCategory { get; set; }

        public string PickupItemId { get; set; }
        public string PickupItem { get; set; }

        public string PickupName { get; set; }


        public string PickupAddress { get; set; }
        public string PickupPostCode { get; set; }
        public string PickupEmail { get; set; }
        public string PickupMobile { get; set; }


        public string DeliveryName { get; set; }
        public string RecipentAddress { get; set; }
        public string DeliveryMobile { get; set; }
        public string DeliveryPostCode { get; set; }
        public string DeliveryEmail { get; set; }

        public string BookingNotes { get; set; }
        public bool IsFragile { get; set; }
        public decimal EstimatedValue { get; set; }
        public decimal PredefinedEstimatedValue { get; set; }

        public int IsPickedForShipping { get; set; }
        public string Status { get; set; }

        public int StatusId { get; set; }

        public int Shipped { get; set; }
        public int IsContainer { get; set; }
        public string ShippingId { get; set; }
        public string ContainerId { get; set; }
        public string SealId { get; set; }
        public string ShippingFrom { get; set; }
        public string ShippingTo { get; set; }
        public DateTime ShippingDate { get; set; }
        public DateTime ArrivalDate { get; set; }
        public DateTime ETA { get; set; }
        public string Consignee { get; set; }
        public string WarehouseId { get; set; }
        public string UserId { get; set; }
        public int Received { get; set; }

        public string GhanaPort { get; set; }
        public string InWarehouse { get; set; }
        public string QRCode { get; set; }
    }
}

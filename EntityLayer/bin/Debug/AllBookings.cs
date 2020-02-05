using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AllBookings
    {
        public string BookingId { get; set; }
        public string CustomerName { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime PickupDate { get; set; }
        public decimal InsurancePremium { get; set; }
        public decimal TotalValue { get; set; }
        public string OrderStatus { get; set; }
        public string PickupPostCode { get; set; }
        public string DeliveryPostCode { get; set; }
        public string PickupCustomerTitle { get; set; }
        public string DeliveryCustomerTitle { get; set; }
        public int Id { get; set; }
    }
}

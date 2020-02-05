using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AllOfMyBookings
    {
        public string BookingId { get; set; }
        public string CustomerName { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal InsurancePremium { get; set; }
        public decimal TotalValue { get; set; }
        public string OrderStatus { get; set; }
    }
}

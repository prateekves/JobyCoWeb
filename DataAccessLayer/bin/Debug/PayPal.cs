using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class PayPal
    {
        public string PayPalId { get; set; }
        public string PayPalName { get; set; }
        public string PayPalEmailId { get; set; }
        public string PayPalContactNo { get; set; }
        public string PayPalItemInfo { get; set; }
        public int PayPalQuantity { get; set; }
        public decimal PayPalAmount { get; set; }
        public string PayPalCurrency { get; set; }
        public DateTime PayPalDateTime { get; set; }
        public string BookingId { get; set; }
        public string CustomerId { get; set; }
    }
}

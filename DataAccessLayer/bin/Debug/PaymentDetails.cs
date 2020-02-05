using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class PaymentDetails
    {
        public string TransactionID { get; set; }
        public string EmailId { get; set; }
        public string ContactNo { get; set; }
        public int Quantity { get; set; }
        public decimal PaymentAmount { get; set; }
        public string PaymentCurrency { get; set; }
        public DateTime PaymentDateTime { get; set; }
    }
}

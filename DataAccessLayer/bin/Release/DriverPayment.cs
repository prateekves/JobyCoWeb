using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class DriverPayment
    {
        public string PaymentId { get; set; }
        public string DriverName { get; set; }
        public string DriverType { get; set; }
        public string WageType { get; set; }
        public decimal ExpectedAmount { get; set; }
        public decimal AmountReceived { get; set; }
        public decimal Discrepancy { get; set; }
    }
}

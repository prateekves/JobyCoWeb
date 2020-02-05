using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class AllOfMyQuotations
    {
        public string QuotingId { get; set; }
        public string CustomerName { get; set; }
        public DateTime QuotationDate { get; set; }
        public decimal TotalValue { get; set; }
    }
}

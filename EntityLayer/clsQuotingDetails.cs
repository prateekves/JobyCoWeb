using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class clsQuotingDetails
    {
        public string Item { get; set; }
        public string IsFragile { get; set; }
        public decimal Cost { get; set; }
        public decimal EstimatedValue { get; set; }
        public string Status { get; set; }
    }
}

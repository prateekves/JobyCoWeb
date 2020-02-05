using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class QuotPickup
    {
        public string PickupId { get; set; }
        public string QuotingId { get; set; }
        public string CustomerId { get; set; }
        public string PickupCategory { get; set; }
        public string PickupItem { get; set; }
        public bool IsFragile { get; set; }
        public decimal EstimatedValue { get; set; }
        //==============================================
        public decimal PredefinedEstimatedValue { get; set; }
        //==============================================
    }
}

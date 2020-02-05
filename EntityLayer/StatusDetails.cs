using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class StatusDetails
    {
        public string BookingId { get; set; }
        public string PickupId { get; set; }
        public string Status { get; set; }
        public string StatusDetail { get; set; }

        public int IsOrderBookStatus { get; set; }
    }
}

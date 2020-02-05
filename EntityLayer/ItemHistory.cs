using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class ItemHistory
    {
        public int Id { get; set; }

        public string BookingId { get; set; }
        public string BookingStatus { get; set; }

        public string BookingStatusDetails { get; set; }
        public string Bookingdate { get; set; }

        public string Status { get; set; }

        public string StatusDetails { get; set; }
        public string CreatedOn { get; set; }
    }
}

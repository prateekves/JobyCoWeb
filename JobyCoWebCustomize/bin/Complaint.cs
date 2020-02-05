using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Complaint
    {
        public string ComplaintId { get; set; }
        public string CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string BookingId { get; set; }
        public string ComplaintSource { get; set; }
        public string ComplaintReason { get; set; }
        public string ComplaintPriority { get; set; }
        public string ComplaintStatus { get; set; }
        public DateTime LodgingDate { get; set; }
        public DateTime ResolvedDate { get; set; }
    }
}

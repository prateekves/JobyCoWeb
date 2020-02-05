using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class CustomerInteraction
    {
        public string ComplaintId { get; set; }
        public DateTime InteractionDate { get; set; }
        public string Comments { get; set; }
        public string PostedBy { get; set; }
        public string ComplaintStatus { get; set; }
    }
}

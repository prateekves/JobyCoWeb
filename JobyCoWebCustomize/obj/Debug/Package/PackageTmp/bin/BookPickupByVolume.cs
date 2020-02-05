using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class BookPickupByVolume
    {
        public string PickupByVolumeId { get; set; }
        public string BookingId { get; set; }
        public string CustomerId { get; set; }
        public decimal Width { get; set; }
        public decimal Height { get; set; }
        public decimal Length { get; set; }
        public bool IsFragile { get; set; }
    }
}

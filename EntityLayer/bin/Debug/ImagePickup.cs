using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class ImagePickup
    {
        public string ImagePickupId { get; set; }
        public string BookingId { get; set; }
        public string CustomerId { get; set; }
        public int PickupCategoryId { get; set; }
        public string PickupCategory { get; set; }
        public int PickupItemId { get; set; }
        public string PickupItem { get; set; }
        public string ImageName { get; set; }
        public string ImageUrl { get; set; }
        public string Id { get; set; }
    }
}

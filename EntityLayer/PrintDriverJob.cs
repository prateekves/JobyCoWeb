using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class PrintDriverJob
    {
        public int SerialNo { get; set; }
        public string BookingId { get; set; }

        //Pickup    
        public string PickupDate { get; set; }
        public string PickupName { get; set; }
        public string PickupPhone { get; set; }
        public string PickupAddress { get; set; }
        public string PickupZip { get; set; }

        public string PickupItem { get; set; }
        public int ItemCount { get; set; }

        //Delivery
        //public string DeliveryDate { get; set; }
        public string DeliveryName { get; set; }
        public string DeliveryPhone { get; set; }
        public string DeliveryAddress { get; set; }
        public string DeliveryZip { get; set; }

        public string Wage { get; set; }


    }
}

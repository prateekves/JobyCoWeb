using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Location
    {
        public string LocationId { get; set; }
        public string LocationName { get; set; }
        public string LocationAddress { get; set; }
        public decimal LocationLatitude { get; set; }
        public decimal LocationLongitude { get; set; }
        public bool Status { get; set; }
        public string Country { get; set; }
        public string WarehouseId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
    }
}

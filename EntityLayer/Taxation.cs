using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Taxation
    {
        public int Id { get; set; }
        public int Slno { get; set; }
        public string TaxName { get; set; }
        public string ChargesType { get; set; }
        public bool IsRange { get; set; }
        public bool IsPercent { get; set; }
        public decimal TaxAmount { get; set; }
        public bool Active { get; set; }
        public string Status { get; set; }
        public int MinVal { get; set; }
        public int MaxVal { get; set; }
        public string RadioChargesType { get; set; }
        public string TaxId { get; set; }
        public string BookingId { get; set; }
    }
}

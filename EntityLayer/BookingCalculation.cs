using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class BookingCalculation
    {
        public decimal OrderSubTotal { get; set; }
        public decimal Vat { get; set; }
        public decimal OrderTotal { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class DashboardStatus
    {
        //Booking
        public int WeeklyBooking { get; set; }
        public int MonthlyBooking { get; set; }
        public int TotalBooking { get; set; }

        //Shipping
        public int WeeklyShipping { get; set; }
        public int MonthlyShipping { get; set; }
        public int TotalShipping { get; set; }

        //Customer
        public int WeeklyCustomer { get; set; }
        public int MonthlyCustomer { get; set; }
        public int TotalCustomer { get; set; }

    }
}

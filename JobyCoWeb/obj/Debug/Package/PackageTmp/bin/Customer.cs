using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class Customer
    {
        public string CustomerId { get; set; }
        public string EmailID { get; set; }
        public string Password { get; set; }
        public string Title { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? DOB { get; set; }
        public string Address { get; set; }
        public string Town { get; set; }
        public string Country { get; set; }
        public string PostCode { get; set; }
        public string Mobile { get; set; }
        public string Telephone { get; set; }
        public string HearAboutUs { get; set; }
        public bool HavingRegisteredCompany { get; set; }
        public bool Locked { get; set; }
        public bool ShippingGoodsInCompanyName { get; set; }
        public string RegisteredCompanyName { get; set; }
        public decimal LatitudePickup { get; set; }
        public decimal LongitudePickup { get; set; }
        public decimal LatitudeDelivery { get; set; }
        public decimal LongitudeDelivery { get; set; }
        public string AltMobile { get; set; }
    }
}

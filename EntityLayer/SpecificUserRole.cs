using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class SpecificUserRole
    {
        public string Menu_Name { get; set; }
        public bool AssignBookingToDriver { get; set; }
        public string AssignBookingToDriverId { get; set; }
        public bool AddDriverToAssignBooking { get; set; }
        public string AddDriverToAssignBookingId { get; set; }
        public bool AddBooking { get; set; }
        public string AddBookingId { get; set; }
        public bool AddShipping { get; set; }
        public string AddShippingId { get; set; }
        public bool AddCustomer { get; set; }
        public string AddCustomerId { get; set; }
        public bool AddDriver { get; set; }
        public string AddDriverId { get; set; }
        public bool AddWarehouse { get; set; }
        public string AddWarehouseId { get; set; }
        public bool AddLocation { get; set; }
        public string AddLocationId { get; set; }
        public bool AddZone { get; set; }
        public string AddZoneId { get; set; }
        public bool AddUser { get; set; }
        public string AddUserId { get; set; }
        public bool PrintDetails { get; set; }
        public string PrintDetailsId { get; set; }
        public bool ExportToPDF { get; set; }
        public string ExportToPDFId { get; set; }
        public bool ExportToExcel { get; set; }
        public string ExportToExcelId { get; set; }
    }
}

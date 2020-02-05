using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class UserAccess
    {
        public string UserId { get; set; }
        public string RoleName { get; set; }
        public bool WhetherDefault { get; set; }
        public string Menu_Name { get; set; }
        public bool AssignBookingToDriver { get; set; } //0
        public string AssignBookingToDriverId { get; set; } //1
        public bool AddDriverToAssignBooking { get; set; } //2
        public string AddDriverToAssignBookingId { get; set; } //3
        public bool AddBooking { get; set; } //4
        public string AddBookingId { get; set; } //5
        public bool AddShipping { get; set; } //6
        public string AddShippingId { get; set; } //7
        public bool AddCustomer { get; set; } //8
        public string AddCustomerId { get; set; } //9
        public bool AddDriver { get; set; } //10
        public string AddDriverId { get; set; } //11
        public bool AddWarehouse { get; set; } //12
        public string AddWarehouseId { get; set; } //13
        public bool AddLocation { get; set; } //14
        public string AddLocationId { get; set; } //15
        public bool AddZone { get; set; } //16 
        public string AddZoneId { get; set; }//17
        public bool AddUser { get; set; } //18
        public string AddUserId { get; set; } //19
        public bool PrintDetails { get; set; } //20
        public string PrintDetailsId { get; set; } //21
        public bool ExportToPDF { get; set; } //22
        public string ExportToPDFId { get; set; } //23
        public bool ExportToExcel { get; set; } //24
        public string ExportToExcelId { get; set; } //25
    }
}

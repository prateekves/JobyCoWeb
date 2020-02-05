using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class clsShipping
    {
        // {*} Fields are Omitted in Edit Shipping
        public string ShippingReferenceNumber { get; set; }
        public string ContainerNumber { get; set; }     //*
        public string InvoiceNumber { get; set; }
        public string SealReferenceNumber { get; set; } //*
        public string BookingNumber { get; set; }
        public string CustomerName { get; set; }
        public string ShippingFrom { get; set; }
        public string ShippingTo { get; set; }
        public string ShippingPort { get; set; }
        public string FreightName { get; set; }
        public DateTime ShippingDate { get; set; }
        public DateTime ArrivalDate { get; set; }
        public string Consignee { get; set; }
        public decimal InvoiceAmount { get; set; }      //*
        public decimal PaidAmount { get; set; }         //*
        public int NoOfItems { get; set; }              //*
        public int NoOfLoadedItems { get; set; }        //*
        public int NoOfRemainingItems { get; set; }     //*

        public int Shipped { get; set; }
        public int InvoiceCount { get; set; }

        public string Status { get; set; }
        public string WarehouseId { get; set; }
        public string WarehouseName { get; set; }
    }
}

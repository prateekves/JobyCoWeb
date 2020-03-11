using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class clsCustomers
    {
        public string CustomerId { get; set; }
        public string EmailID { get; set; }
        public string CustomerName { get; set; }
        public DateTime DOB { get; set; }
        public string Address { get; set; }
        public string Mobile { get; set; }
        public string PostCode { get; set; }
        public decimal LatitudePickup { get; set; }
        public decimal LongitudePickup { get; set; }
        public string Title { get; set; }
        public string sDOB { get; set; }
    }

    // So my web service returns a serialize version of this
    [Serializable()]
    public class DataTableResponse
    {

        public int draw { get; set; }
        public int recordsTotal { get; set; }
        public int recordsFiltered { get; set; }
        public List<dtData> data { get; set; }
        public DataTableResponse() { }
    }
    [Serializable()]
    public class DataTableParameter
    {
        public int draw { get; set; }
        public int length { get; set; }
        public int start { get; set; }
        public List<columm> columns { get; set; }
    }
    [Serializable()]
    public class columm
    {
        public string data { get; set; }
        public string name { get; set; }
        public Boolean searchable { get; set; }
        public Boolean orderable { get; set; }
        public searchValue Search { get; set; }
    }
    [Serializable()]
    public class searchValue
    {
        public string value { get; set; }
        public Boolean regex { get; set; }
    }

    // Single datatable row  
    [Serializable()]
    public class dtData
    {
        public string CustomerId { get; set; }
        public string EmailID { get; set; }
        public string CustomerName { get; set; }
        public DateTime DOB { get; set; }
        public string Address { get; set; }
        public string Mobile { get; set; }
        
    }



}

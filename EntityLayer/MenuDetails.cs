using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer
{
    public class MenuDetails
    {
        public int Menu_ID { get; set; }
        public string Menu_Name { get; set; }
        public int Parent_ID { get; set; }
        public string Parent_Name { get; set; }
        public string PagePath { get; set; }
        public bool IsActive { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EntityLayer
{
    public class User
    {
        public string Address
        {
            get;
            set;
        }

        public string Country
        {
            get;
            set;
        }

        public DateTime DOB
        {
            get;
            set;
        }

        public string EmailID
        {
            get;
            set;
        }

        public string FirstName
        {
            get;
            set;
        }

        public string LastName
        {
            get;
            set;
        }

        public bool Locked
        {
            get;
            set;
        }

        public string Mobile
        {
            get;
            set;
        }

        public string Password
        {
            get;
            set;
        }

        public string PostCode
        {
            get;
            set;
        }

        public string SecretAnswer
        {
            get;
            set;
        }

        public string SecretQuestion
        {
            get;
            set;
        }

        public string Telephone
        {
            get;
            set;
        }

        public string Title
        {
            get;
            set;
        }

        public string Town
        {
            get;
            set;
        }

        public string UserId
        {
            get;
            set;
        }

        public string UserRole
        {
            get;
            set;
        }

        public string WarehouseId
        {
            get;
            set;
        }

        //adding driver properties

        public string DriverType
        {
            get;
            set;
        }
        public string WageType
        {
            get;
            set;
        }
        public string DriverId
        { get; set; }

    }
}
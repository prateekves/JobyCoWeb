using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace JobyCoWebCustomize
{
    public class PaypalLogger
    {
        public static string LogDictionaryPath = Environment.CurrentDirectory;
        public static void Log(String messages)
        {
            try
            {
                StreamWriter strw = new StreamWriter(LogDictionaryPath + "\\PaypalError.log", true);
                strw.WriteLine("{0}---->{1}", DateTime.Now.ToString("MM/DD/YYYY HH:mm:ss"), messages);
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}
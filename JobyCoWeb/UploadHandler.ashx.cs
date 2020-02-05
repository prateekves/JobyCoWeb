using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JobyCoWeb
{
    /// <summary>
    /// Summary description for UploadHandler
    /// </summary>
    public class UploadHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if (context.Request.Files.Count > 0)
            {
                HttpFileCollection files = context.Request.Files;
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    Guid uniqId = new Guid();
                    uniqId = Guid.NewGuid();
                    string fileName = context.Server.MapPath("~/images/items/" + System.IO.Path.GetFileName(file.FileName));
                    file.SaveAs(fileName);
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
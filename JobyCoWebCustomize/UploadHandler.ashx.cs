using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JobyCoWebCustomize
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
                    //string fileName = context.Server.MapPath("~/images/items/" + System.IO.Path.GetFileName(uniqId.ToString().Split('-')[0] + "_" + file.FileName));
                    string fileName = context.Server.MapPath("~/images/items/" + System.IO.Path.GetFileName(file.FileName));
                    file.SaveAs(fileName);

                    //string fileName = context.Server.MapPath("~/images/items/" + System.IO.Path.GetFileName(file.FileName));
                    //file.SaveAs(fileName);
                    //fileName = fileName.Replace("JobyCoWeb\\JobyCoWeb", "JobyCoWeb\\JobyCoWebCustomize");
                    //file.SaveAs(fileName);


                    //string fileName1 = context.Server.MapPath("D:\\Debashish\\Project\\JobyCoWeb\\JobyCoWeb\\images\\items\\" + System.IO.Path.GetFileName(file.FileName));
                    //file.SaveAs(fileName1);
                    //string fileName2 = context.Server.MapPath("D:\\Debashish\\Project\\JobyCoWeb\\JobyCoWebCustomize\\images\\items\\" + System.IO.Path.GetFileName(file.FileName));
                    //file.SaveAs(fileName2);
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
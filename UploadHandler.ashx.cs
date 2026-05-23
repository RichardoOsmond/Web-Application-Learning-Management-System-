using System;
using System.IO;
using System.Web;

namespace Wapping_time
{
    public class UploadHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            if (context.Request.Files.Count > 0)
            {
                HttpPostedFile file = context.Request.Files[0];
                string fileName = "img_" + Guid.NewGuid().ToString().Substring(0, 8) + Path.GetExtension(file.FileName);
                string folder = context.Request.QueryString["folder"] ?? "General";
                string savePath = context.Server.MapPath("~/Images/" + folder + "/" + fileName);

                file.SaveAs(savePath);

                string relativeUrl = "/Images/" + folder + "/" + fileName;
                context.Response.Write("{\"location\": \"" + relativeUrl + "\"}");
            }
            else
            {
                context.Response.StatusCode = 400;
                context.Response.Write("{\"error\": \"No file uploaded.\"}");
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
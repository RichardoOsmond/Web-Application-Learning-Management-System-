using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace Wapping_time
{
    public partial class DashboardWithAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["UserID"] = 1;
            if (!IsPostBack)
            {
                CourseRepeater.DataBind();
                noCourseMsg.Visible = CourseRepeater.Items.Count == 0;
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {

        }

        protected void SaveCourseBtn_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(courseNameTxt.Text) || string.IsNullOrWhiteSpace(descriptionTxt.Text))
            {
                return;
            }

            if (courseFileUpload.HasFile)
            {
                string folderPath = Server.MapPath("~/Images/");
                string originalFileName = Path.GetFileName(courseFileUpload.FileName);
                string extension = Path.GetExtension(originalFileName);

                string newFileName = Guid.NewGuid().ToString() + extension;
                string savePath = Path.Combine(folderPath, newFileName);


                //save to folder images
                courseFileUpload.SaveAs(savePath);
                String imagePath = "/Images/" + newFileName;

                SqlDataSource1.InsertParameters["CourseImage"].DefaultValue = imagePath;
            }

            //storing to database
            SqlDataSource1.Insert();
            Response.Redirect(Request.RawUrl);
        }

        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }

        protected void viewAllCourseBtn_Click(object sender, EventArgs e)
        {
            //List<Course> courses = DataServices.loadAllCreatedCourse((int)Session["UserID"]);

            //CourseRepeater.DataSource = courses;
            //CourseRepeater.DataBind();
        }
        protected void CancelBtn_Click(object sender, EventArgs e)
        {
            courseNameTxt.Text = "";
            descriptionTxt.Text = "";
        }
        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        protected void CreateCourseButton_Click(object sender, EventArgs e)
        {

        }

        protected void ViewAllCourseBtn_Click(object sender, EventArgs e)
        {

        }
    }
}
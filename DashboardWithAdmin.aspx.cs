using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Configuration;
using System.Data.SqlClient;

namespace Wapping_time
{
    public partial class DashboardWithAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["UserID"] = 2;
            if (!IsPostBack)
            {
                CourseRepeater.DataBind();
                noCourseMsg.Visible = CourseRepeater.Items.Count == 0;
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {

        }

        protected void saveCourseBtn_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Write("<script>alert('Session expired - UserID is null');</script>");
                return;
            }
            Response.Write("<script>alert('Function reached! UserID = " + Session["UserID"] + "');</script>");

            if (string.IsNullOrWhiteSpace(courseNameTxt.Text) ||
                string.IsNullOrWhiteSpace(descriptionTxt.Text) ||
                string.IsNullOrWhiteSpace(CategoryDDL.SelectedValue))
            {
                return;
            }

            string imagePath = null;
            string savePath = "";

            if (courseFileUpload.HasFile)
            {
                string folderPath = Server.MapPath("~/Images/");
                string extension = Path.GetExtension(courseFileUpload.FileName);
                string newFileName = Guid.NewGuid().ToString() + extension;
                savePath = Path.Combine(folderPath, newFileName);
                imagePath = "/Images/" + newFileName;
                courseFileUpload.SaveAs(savePath);
            }

            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    string insertCourseQuery = @"
                    INSERT INTO Course 
                    (UserID, CourseName, Description, CourseCategory, CourseImage, CourseCreatedDate)
                    OUTPUT INSERTED.CourseID
                    VALUES 
                    (@UserID, @CourseName, @Description, @CourseCategory, @CourseImage, @CourseCreatedDate);
                    ";

                    int newCourseID;

                    using (SqlCommand cmd = new SqlCommand(insertCourseQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        cmd.Parameters.AddWithValue("@CourseName", courseNameTxt.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", descriptionTxt.Text.Trim());
                        cmd.Parameters.AddWithValue("@CourseCategory", CategoryDDL.SelectedValue);
                        cmd.Parameters.AddWithValue("@CourseImage", (object)imagePath ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@CourseCreatedDate", DateTime.Now.Date);

                        newCourseID = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    foreach (RepeaterItem item in studentRepeater.Items)
                    {
                        Label hiddenStudentID = (Label)item.FindControl("hiddenStudentID");
                        int studentIDHidden = Convert.ToInt32(hiddenStudentID.Text);
                        CheckBox enrollCheckBox = (CheckBox)item.FindControl("enrollCheckBox");

                        string insertRegisterQuery = @"
                            INSERT INTO Registration
                            (CourseID, UserID, Result, RegistrationDate, Progress)
                            VALUES
                            (@CourseID, @UserID, @Result, @RegistrationDate, @Progress);
                            ";

                        using (SqlCommand registerCmd = new SqlCommand(insertRegisterQuery, conn, transaction))
                        {
                            registerCmd.Parameters.AddWithValue("@CourseID", newCourseID);
                            registerCmd.Parameters.AddWithValue("@UserID", studentIDHidden);
                            registerCmd.Parameters.AddWithValue("@Result", "Pending");
                            registerCmd.Parameters.AddWithValue("@RegistrationDate", DateTime.Now.Date);
                            registerCmd.Parameters.AddWithValue("@Progress", 0);        
                            registerCmd.ExecuteNonQuery();
                        }
                    }
                    transaction.Commit();
                }
                catch 
                {
                    //rollback if error happens
                    transaction.Rollback();
                    throw;
                }
            }
            Response.Redirect(Request.RawUrl);
        }

        protected void viewAllCourseBtn_Click(object sender, EventArgs e)
        {
            //List<Course> courses = DataServices.loadAllCreatedCourse((int)Session["UserID"]);

            //CourseRepeater.DataSource = courses;
            //CourseRepeater.DataBind();
        }
        protected void cancelBtn_Click(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in studentRepeater.Items)
            {
                CheckBox cb = (CheckBox)item.FindControl("enrollCheckBox");

                if (cb != null)
                {
                    cb.Checked = false;
                }
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        protected void CreateCourseButton_Click(object sender, EventArgs e)
        {

        }

        protected void ViewAllCourseBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("Courses.aspx");
        }

        protected void ContinueBtn_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            String courseID = btn.CommandArgument;

            Response.Redirect($"SelectedCoursePage.aspx?CourseID={courseID}");
        }

        protected void RemoveCourseBtn_Click(object sender, EventArgs e)
        {
            int courseID = Convert.ToInt32(hiddenCourseIDs.Value);
            if (courseID == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                try
                {
                    // Delete registrations first due to FK constraint
                    using (SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Registration WHERE CourseID=@CourseID", conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        cmd.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Course WHERE CourseID=@CourseID", conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        cmd.ExecuteNonQuery();
                    }

                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                    //haven't filled
                    //Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }
    }
}
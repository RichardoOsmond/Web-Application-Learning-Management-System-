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
        private int maxEnrollment = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            CalculateMaxEnrollment();
            if (!IsPostBack)
            {
                welcomeMsg.Text = "Welcome, " + Session["Username"];
                CourseRepeater.DataBind();
                noCourseMsg.Visible = CourseRepeater.Items.Count == 0;

                TopExtracurricularRepeater.DataBind();
                noTopCoursesMsg.Visible = TopExtracurricularRepeater.Items.Count == 0;
            }
        }

        private void CalculateMaxEnrollment()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 1 COUNT(r.RegistrationID)
                    FROM Course c
                    LEFT JOIN Registration r ON c.CourseID = r.CourseID
                    GROUP BY c.CourseID
                    ORDER BY COUNT(r.RegistrationID) DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            maxEnrollment = Convert.ToInt32(result);
                            if (maxEnrollment <= 0) maxEnrollment = 1;
                        }
                    }
                    catch
                    {
                        maxEnrollment = 1;
                    }
                }
            }
        }

        protected string GetPercentage(object countObj)
        {
            if (countObj == null || countObj == DBNull.Value) return "0";
            double count = Convert.ToDouble(countObj);
            double percent = (count / maxEnrollment) * 100;
            if (percent > 100) percent = 100;
            if (percent < 0) percent = 0;
            return percent.ToString("0");
        }



        protected void saveCourseBtn_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Write("<script>alert('Session expired - UserID is null');</script>");
                return;
            }

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
                string folderPath = Server.MapPath("~/Images/Course Icon/");
                string newFileName = "img_" + Guid.NewGuid().ToString().Substring(0, 8) + Path.GetExtension(courseFileUpload.FileName);
                savePath = Path.Combine(folderPath, newFileName);
                imagePath = "/Images/Course Icon/" + newFileName;
            }  

            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1. INSERT NEW COURSE
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

                    // 2. INSERT REGISTRATIONS FOR CHECKED STUDENTS
                    foreach (RepeaterItem item in studentRepeater.Items)
                    {
                        Label hiddenStudentID = (Label)item.FindControl("hiddenStudentID");
                        int studentIDHidden = Convert.ToInt32(hiddenStudentID.Text);
                        CheckBox enrollCheckBox = (CheckBox)item.FindControl("enrollCheckBox");

                        if (enrollCheckBox != null && enrollCheckBox.Checked)
                        {
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
                    }

                    transaction.Commit();

                    if (courseFileUpload.HasFile)
                    {
                        courseFileUpload.SaveAs(savePath);
                    }
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
            Response.Redirect(Request.RawUrl);
        }

        protected void updateCourseBtn_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Write("<script>alert('Session expired - UserID is null');</script>");
                return;
            }

            if (string.IsNullOrWhiteSpace(courseNameTxt.Text) ||
                string.IsNullOrWhiteSpace(descriptionTxt.Text) ||
                string.IsNullOrWhiteSpace(CategoryDDL.SelectedValue))
            {
                return;
            }

            int courseID = 0;
            if (hiddenCourseIDs.Value != "")
            {
                courseID = Convert.ToInt32(hiddenCourseIDs.Value);
            }
            if (courseID == 0) return;

            string imagePath = null;
            string savePath = "";
            string oldImgPath = null;

            if (courseFileUpload.HasFile)
            {
                string folderPath = Server.MapPath("~/Images/");
                string extension = Path.GetExtension(courseFileUpload.FileName);
                string newFileName = Guid.NewGuid().ToString() + extension;
                savePath = Path.Combine(folderPath, newFileName);

                imagePath = "/Images/" + newFileName;
            }
            else if (hdnIsImageRemoved.Value == "true")
            {
                imagePath = ""; // Indicates that the image should be deleted
            }

            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

            // Retrieve old image path if we are changing or deleting it
            if (courseFileUpload.HasFile || hdnIsImageRemoved.Value == "true")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string getOldImgQuery = "SELECT CourseImage FROM Course WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(getOldImgQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        try
                        {
                            conn.Open();
                            object res = cmd.ExecuteScalar();
                            if (res != null && res != DBNull.Value)
                            {
                                oldImgPath = res.ToString();
                            }
                        }
                        catch { }
                    }
                }
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1. UPDATE EXISTING COURSE
                    string updateCourseQuery = imagePath != null
                        ? "UPDATE Course SET CourseName=@CourseName, Description=@Description, CourseCategory=@CourseCategory, CourseImage=@CourseImage WHERE CourseID=@CourseID"
                        : "UPDATE Course SET CourseName=@CourseName, Description=@Description, CourseCategory=@CourseCategory WHERE CourseID=@CourseID";

                    using (SqlCommand cmd = new SqlCommand(updateCourseQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@CourseName", courseNameTxt.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", descriptionTxt.Text.Trim());
                        cmd.Parameters.AddWithValue("@CourseCategory", CategoryDDL.SelectedValue);
                        if (imagePath != null)
                            cmd.Parameters.AddWithValue("@CourseImage", string.IsNullOrEmpty(imagePath) ? DBNull.Value : (object)imagePath);
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        cmd.ExecuteNonQuery();
                    }

                    // 2. Synchronize registrations differentially (preserves existing student progress/dates!)
                    foreach (RepeaterItem item in studentRepeater.Items)
                    {
                        Label hiddenStudentID = (Label)item.FindControl("hiddenStudentID");
                        int studentIDHidden = Convert.ToInt32(hiddenStudentID.Text);
                        CheckBox enrollCheckBox = (CheckBox)item.FindControl("enrollCheckBox");

                        bool isChecked = (enrollCheckBox != null && enrollCheckBox.Checked);

                        // Check if student is already registered for this course
                        bool isRegistered = false;
                        using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Registration WHERE CourseID=@CourseID AND UserID=@UserID", conn, transaction))
                        {
                            checkCmd.Parameters.AddWithValue("@CourseID", courseID);
                            checkCmd.Parameters.AddWithValue("@UserID", studentIDHidden);
                            isRegistered = Convert.ToInt32(checkCmd.ExecuteScalar()) > 0;
                        }

                        if (isChecked && !isRegistered)
                        {
                            // Checkbox selected but they aren't in the DB -> INSERT
                            string insertRegisterQuery = @"
                                INSERT INTO Registration (CourseID, UserID, Result, RegistrationDate, Progress)
                                VALUES (@CourseID, @UserID, @Result, @RegistrationDate, @Progress);
                            ";
                            using (SqlCommand registerCmd = new SqlCommand(insertRegisterQuery, conn, transaction))
                            {
                                registerCmd.Parameters.AddWithValue("@CourseID", courseID);
                                registerCmd.Parameters.AddWithValue("@UserID", studentIDHidden);
                                registerCmd.Parameters.AddWithValue("@Result", "Pending");
                                registerCmd.Parameters.AddWithValue("@RegistrationDate", DateTime.Now.Date);
                                registerCmd.Parameters.AddWithValue("@Progress", 0);
                                registerCmd.ExecuteNonQuery();
                            }
                        }
                        else if (!isChecked && isRegistered)
                        {
                            // Checkbox deselected but they are in the DB -> DELETE
                            using (SqlCommand deleteCmd = new SqlCommand("DELETE FROM Registration WHERE CourseID=@CourseID AND UserID=@UserID", conn, transaction))
                            {
                                deleteCmd.Parameters.AddWithValue("@CourseID", courseID);
                                deleteCmd.Parameters.AddWithValue("@UserID", studentIDHidden);
                                deleteCmd.ExecuteNonQuery();
                            }
                        }
                    }

                    transaction.Commit();

                    if (courseFileUpload.HasFile)
                    {
                        courseFileUpload.SaveAs(savePath);
                    }

                    // Delete the old file from the disk safely post-commit
                    if (!string.IsNullOrEmpty(oldImgPath))
                    {
                        string oldPhysicalPath = Server.MapPath(oldImgPath);
                        if (File.Exists(oldPhysicalPath))
                        {
                            try { File.Delete(oldPhysicalPath); } catch { }
                        }
                    }
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
            Response.Redirect(Request.RawUrl);
        }

        protected void viewAllCourseBtn_Click(object sender, EventArgs e)
        {

        }
        protected void cancelBtn_Click(object sender, EventArgs e)
        {
            createCourseModal.Style["visibility"] = "hidden";
            modalTitle.InnerText = "Create New Course:";
            courseNameTxt.Text = "";
            descriptionTxt.Text = "";
            CategoryDDL.SelectedIndex = 0;
            hiddenCourseIDs.Value = "";
            courseImage.ImageUrl = "";
            imagePreviewWrapper.Style["display"] = "none";
            courseFileUpload.Style["display"] = "block";
            hdnIsImageRemoved.Value = "false";

            foreach (RepeaterItem item in studentRepeater.Items)
            {
                CheckBox cb = (CheckBox)item.FindControl("enrollCheckBox");
                if (cb != null)
                {
                    cb.Checked = false;
                }
            }
        }

        protected void CreateCourseButton_Click(object sender, EventArgs e)
        {
            saveBtn.Visible = true;
            updateBtn.Visible = false;
            removeCourseBtn.Visible = false;
            hdnIsImageRemoved.Value = "false";
            createCourseModal.Style["visibility"] = "visible";
        }

        protected void EditCourseButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int courseID = Convert.ToInt32(btn.CommandArgument);

            hdnIsImageRemoved.Value = "false";
            modalTitle.InnerText = "Edit Course:";
            removeCourseBtn.Visible = true;
            saveBtn.Visible = false;
            updateBtn.Visible = true;

            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT CourseName, Description, CourseCategory, CourseImage FROM Course WHERE CourseID=@CourseID", conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            courseNameTxt.Text = reader["CourseName"].ToString();
                            descriptionTxt.Text = reader["Description"].ToString();
                            CategoryDDL.SelectedValue = reader["CourseCategory"].ToString();

                            string imgUrl = reader["CourseImage"] != DBNull.Value ? reader["CourseImage"].ToString() : "";
                            if (!string.IsNullOrEmpty(imgUrl))
                            {
                                courseImage.ImageUrl = imgUrl;
                                imagePreviewWrapper.Style["display"] = "block";
                                courseFileUpload.Style["display"] = "none";
                            }
                            else
                            {
                                courseImage.ImageUrl = "";
                                imagePreviewWrapper.Style["display"] = "none";
                                courseFileUpload.Style["display"] = "block";
                            }
                        }
                    }
                }
            }

            hiddenCourseIDs.Value = courseID.ToString();

            // Bind the student repeater
            studentRepeater.DataBind();

            // Show the modal
            createCourseModal.Style["visibility"] = "visible";
        }

        protected void ViewAllCourseBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect("Courses.aspx");
        }

        protected void ContinueBtn_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            String courseID = btn.CommandArgument;

            Response.Redirect("SelectedCoursePage.aspx?CourseID=" + courseID);
        }

        protected void RemoveCourseBtn_Click(object sender, EventArgs e)
        {
            int courseID = Convert.ToInt32(hiddenCourseIDs.Value);
            if (courseID == 0) return;

            DataServices.DeleteCourse(courseID);

            Response.Redirect(Request.RawUrl);
        }
    }
}
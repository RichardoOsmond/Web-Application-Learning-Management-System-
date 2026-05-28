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
    public partial class courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateFilterButtonSelection();
            if (!IsPostBack)
            {
                int userID = (int)Session["UserID"];
                List<Notifications> notifications = DataServices.getNotifications(userID);
                Master.bindNotifications(notifications);
            }
        }

        protected void SeacrhTB_TextChanged(object sender, EventArgs e)
        {
            courseRepeater.DataBind();
        }

        protected void CategoryBtn_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            if (btn.Text == "All")
            {
                HiddenCategory.Value = "";
            }
            else
            {
                HiddenCategory.Value = btn.Text;
            }
            UpdateFilterButtonSelection();
            courseRepeater.DataBind();
        }

        private void UpdateFilterButtonSelection()
        {
            string selected = HiddenCategory.Value;

            // Reset all styles
            allBtn.Font.Bold = false;
            scienceBtn.Font.Bold = false;
            socialBtn.Font.Bold = false;
            extracurricularBtn.Font.Bold = false;

            if (string.IsNullOrEmpty(selected))
            {
                allBtn.Font.Bold = true;
            }
            else if (selected == "Science")
            {
                scienceBtn.Font.Bold = true;
            }
            else if (selected == "Social")
            {
                socialBtn.Font.Bold = true;
            }
            else if (selected == "Extracurricular")
            {
                extracurricularBtn.Font.Bold = true;
            }
        }

        protected void EditCourseButton_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int courseID = Convert.ToInt32(btn.CommandArgument);

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
                                courseImagePreview.Src = imgUrl;
                                imagePreviewWrapper.Style["display"] = "block";
                                courseFileUpload.Style["display"] = "none";
                            }
                            else
                            {
                                courseImagePreview.Src = "";
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
            updateBtn.Visible = true;
            editCourseModal.Style["visibility"] = "visible";
        }

        protected void UpdateCourseBtn_Click(object sender, EventArgs e)
        {
            int courseID = Convert.ToInt32(hiddenCourseIDs.Value);
            if (courseID == 0) return;

            if (string.IsNullOrWhiteSpace(courseNameTxt.Text) ||
                string.IsNullOrWhiteSpace(descriptionTxt.Text) ||
                string.IsNullOrWhiteSpace(CategoryDDL.SelectedValue))
                return;

            string imagePath = null;
            string savePath = "";

            if (courseFileUpload.HasFile)
            {
                string folderPath = Server.MapPath("~/Images/");
                string extension = Path.GetExtension(courseFileUpload.FileName);
                string newFileName = Guid.NewGuid().ToString() + extension;
                savePath = Path.Combine(folderPath, newFileName);

                imagePath = "/Images/" + newFileName;
            }

            string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // Only update CourseImage column if a new image was uploaded
                    string updateQuery = imagePath != null
                        ? "UPDATE Course SET CourseName=@CourseName, Description=@Description, CourseCategory=@CourseCategory, CourseImage=@CourseImage WHERE CourseID=@CourseID"
                        : "UPDATE Course SET CourseName=@CourseName, Description=@Description, CourseCategory=@CourseCategory WHERE CourseID=@CourseID";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@CourseName", courseNameTxt.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", descriptionTxt.Text.Trim());
                        cmd.Parameters.AddWithValue("@CourseCategory", CategoryDDL.SelectedValue);
                        if (imagePath != null)
                            cmd.Parameters.AddWithValue("@CourseImage", (object)imagePath ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        cmd.ExecuteNonQuery();
                    }
                    // Synchronize registrations differentially (preserves existing student progress/dates!)
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
                            // 1. Checkbox is selected but they aren't in the DB -> INSERT
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
                            // 2. Checkbox is deselected but they are in the DB -> DELETE
                            using (SqlCommand deleteCmd = new SqlCommand("DELETE FROM Registration WHERE CourseID=@CourseID AND UserID=@UserID", conn, transaction))
                            {
                                deleteCmd.Parameters.AddWithValue("@CourseID", courseID);
                                deleteCmd.Parameters.AddWithValue("@UserID", studentIDHidden);
                                deleteCmd.ExecuteNonQuery();
                            }
                        }
                        // 3. Otherwise, state matches (e.g. still enrolled or still unenrolled), so DO NOTHING.
                        // This perfectly preserves all existing student progress, grades, and enrollment dates!
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

        protected void RemoveCourseBtn_Click(object sender, EventArgs e)
        {
            int courseID = Convert.ToInt32(hiddenCourseIDs.Value);
            if (courseID == 0) return;

            try
            {
                DataServices.DeleteCourse(courseID);
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        protected void CancelBtn_Click(object sender, EventArgs e)
        {
            editCourseModal.Style["visibility"] = "hidden";
            courseNameTxt.Text = "";
            descriptionTxt.Text = "";
            CategoryDDL.SelectedIndex = 0;
            hiddenCourseIDs.Value = "";
            courseImagePreview.Src = "";
            imagePreviewWrapper.Style["display"] = "none";
            courseFileUpload.Style["display"] = "block";

            foreach (RepeaterItem item in studentRepeater.Items)
            {
                CheckBox cb = (CheckBox)item.FindControl("enrollCheckBox");
                if (cb != null)
                {
                    cb.Checked = false;
                }
            }
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            courseRepeater.DataBind();  
        }

        protected void ContinueBtn_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string courseID = btn.CommandArgument;

            Response.Redirect($"SelectedCoursePage.aspx?CourseID={courseID}");
        }
    }
}

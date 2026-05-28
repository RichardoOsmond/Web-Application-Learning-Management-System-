using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class CoursePage : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;
        protected int selectedLessonID
        {
            get { return ViewState["selectedLessonID"] != null ? (int)ViewState["selectedLessonID"] : -1; }
            set { ViewState["selectedLessonID"] = value; }
        }
        protected int selectedCourseID
        {
            get { return ViewState["selectedCourseID"] != null ? (int)ViewState["selectedCourseID"] : -1; }
            set { ViewState["selectedCourseID"] = value; }
        }
        protected string courseImage
        {
            get { return ViewState["courseImage"] != null ? (string)ViewState["courseImage"] : ""; }
            set { ViewState["courseImage"] = value; }
        }
        protected string courseDescription
        {
            get { return ViewState["courseDescription"] != null ? (string)ViewState["courseDescription"] : ""; }
            set { ViewState["courseDescription"] = value; }

        }
        protected string courseName
        {
            get { return ViewState["courseName"] != null ? (string)ViewState["courseName"] : ""; }
            set { ViewState["courseName"] = value; }
        }
        private string roleName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("login.aspx");

            int userID = (int)Session["UserID"];
            roleName = Session["RoleName"].ToString();
            selectedCourseID = int.Parse(Request.QueryString["CourseID"]);
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                string courseInfo = @"SELECT CourseName, CourseImage, Description FROM [Course] WHERE CourseID = @CourseID";
                using (SqlCommand cmd = new SqlCommand(courseInfo, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", selectedCourseID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            courseName = reader["CourseName"].ToString();
                            courseImage = reader["CourseImage"].ToString();
                            courseDescription = reader["Description"].ToString();
                        }
                    }
                }
            }
            if (roleName == "Admin" || roleName == "SuperAdmin")
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string checkLesson = "SELECT COUNT(*) FROM Lesson WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(checkLesson, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", selectedCourseID);
                        int lessonCount = (int)cmd.ExecuteScalar();
                        if(lessonCount == 0)
                        {
                            Response.Redirect($"AdminEditCoursePage.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}&type=material");
                        }
                    }
                }
                btnMaterial.Visible = true;
                btnQuiz.Visible = true;
            }
            else
            {
                Student currStudent = DataServices.getStudentByUserID(Convert.ToInt32(Session["UserID"]));
                List<ChatMessages> chatMessages = currStudent.getChatMessages();
                Master.bindChatMessages(chatMessages);
            }

            if (!IsPostBack)
            {
                List<Notifications> notifications = DataServices.getNotifications(userID);
                Master.bindNotifications(notifications);
                if (Request.QueryString["LessonID"] != null) selectedLessonID = int.Parse(Request.QueryString["LessonID"]);
                LoadLessons(selectedCourseID);
                LoadContent(selectedLessonID);
                List<Notifications> notifications = DataServices.getNotifications(Convert.ToInt32(Session["UserID"]));
                Master.bindNotifications(notifications);
            }
        }

        private void LoadLessons(int courseID)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                string lessonQuery = "SELECT LessonID, LessonName, LessonOrder FROM Lesson WHERE CourseID = @CourseID ORDER BY LessonOrder";
                SqlDataAdapter lessonAdapter = new SqlDataAdapter(lessonQuery, conn);
                lessonAdapter.SelectCommand.Parameters.AddWithValue("@CourseID", courseID);
                DataTable lessonTable = new DataTable();
                lessonAdapter.Fill(lessonTable);
                LessonRepeater.DataSource = lessonTable;
                LessonRepeater.DataBind();
            }
        }
        private void LoadContent(int lessonID)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Load materials
                string materialQuery = @"SELECT c.ContentID, m.MaterialID, m.Name FROM Content c 
                                    JOIN MaterialContent m ON c.ContentID = m.ContentID 
                                    WHERE c.LessonID = @LessonID AND c.Type = 'Material'
                                    ORDER BY c.Position";
                SqlDataAdapter materialAdapter = new SqlDataAdapter(materialQuery, conn);
                materialAdapter.SelectCommand.Parameters.AddWithValue("@LessonID", lessonID);
                DataTable materialTable = new DataTable();
                materialAdapter.Fill(materialTable);
                MaterialRepeater.DataSource = materialTable;
                MaterialRepeater.DataBind();

                // Load quizzes
                string quizQuery = @"SELECT c.ContentID, q.QuizID, q.Name FROM Content c 
                JOIN QuizContent q ON c.ContentID = q.ContentID 
                WHERE c.LessonID = @LessonID AND c.Type = 'Quiz'
                ORDER BY c.Position";
                SqlDataAdapter quizAdapter = new SqlDataAdapter(quizQuery, conn);
                quizAdapter.SelectCommand.Parameters.AddWithValue("@LessonID", lessonID);
                DataTable quizTable = new DataTable();
                quizAdapter.Fill(quizTable);
                QuizRepeater.DataSource = quizTable;
                QuizRepeater.DataBind();
            }
        }

        protected void selectLesson(object source, RepeaterCommandEventArgs e)
        {
            selectedLessonID = int.Parse(e.CommandArgument.ToString());
            LoadLessons(selectedCourseID);
            LoadContent(selectedLessonID);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "moveLesson", "moveLessonToLeft();", true);
        }

        protected void btnMaterial_Click(object sender, EventArgs e)
        {
            Response.Redirect($"AdminEditCoursePage.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}&type=material");
        }
        protected void btnQuiz_Click(object sender, EventArgs e)
        {
            Response.Redirect($"AdminEditCoursePage.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}&type=quiz");
        }

        protected void returnBtn_Click(object sender, EventArgs e)
        {
            if (roleName == "Student")
            {
                Response.Redirect("StudentDashboard.aspx");
            }
            else
            {
                Response.Redirect("DashboardWithAdmin.aspx");
            }
        }
    }
}
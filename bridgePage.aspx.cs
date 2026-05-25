using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class bridgePage : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (Request.QueryString["QuizID"] == null)
            {
                Response.Redirect("StudentDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
                int roleID = Convert.ToInt32(Session["RoleID"]);
                LoadTitle(quizID);
                if (roleID == 2)
                {
                    pnlAdmin.Visible = true;
                    LoadAdminView(quizID);
                }
                else
                {
                    pnlStudent.Visible = true;
                    LoadStudentView(quizID);
                }
            }
        }

        // load course + quiz name into title label
        private void LoadTitle(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT qc.[Name], co.CourseName
                    FROM QuizContent qc
                    JOIN Content ct ON qc.ContentID = ct.ContentID
                    JOIN Lesson l   ON ct.LessonID  = l.LessonID
                    JOIN Course co  ON l.CourseID   = co.CourseID
                    WHERE qc.QuizID = @QuizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                    lblCourseQuizTitle.Text = reader["CourseName"].ToString() + " — " + reader["Name"].ToString();
                reader.Close();
            }
        }

        // convert seconds to readable format
        private string FormatTimeLimit(int totalSeconds)
        {
            int hours = totalSeconds / 3600;
            int minutes = (totalSeconds % 3600) / 60;
            if (hours > 0)
                return hours + "h " + minutes + "m";
            return minutes + "m";
        }

        // get courseID from quizID via join chain
        private int GetCourseID(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT co.CourseID
                    FROM QuizContent qc
                    JOIN Content ct ON qc.ContentID = ct.ContentID
                    JOIN Lesson l   ON ct.LessonID  = l.LessonID
                    JOIN Course co  ON l.CourseID   = co.CourseID
                    WHERE qc.QuizID = @QuizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : -1;
            }
        }

        // get registrationID for current user in given course
        private int GetRegistrationID(int courseID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT RegistrationID FROM Registration WHERE UserID = @UserID AND CourseID = @CourseID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                cmd.Parameters.AddWithValue("@CourseID", courseID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : -1;
            }
        }

        // student view — quiz info + attempt button + previous attempts
        private void LoadStudentView(int quizID)
        {
            int courseID = GetCourseID(quizID);
            int registrationID = GetRegistrationID(courseID);

            if (registrationID == -1)
            {
                lblStatusBadge.Text = "You are not enrolled in this course.";
                btnAttempt.Enabled = false;
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT [TimeLimit], [PassingScores], [MaxAttempts], [Status] FROM QuizContent WHERE QuizID = @QuizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string status = reader["Status"].ToString();
                    int totalSeconds = Convert.ToInt32(reader["TimeLimit"]);
                    int passingScore = Convert.ToInt32(reader["PassingScores"]);
                    int maxAttempts = Convert.ToInt32(reader["MaxAttempts"]);
                    lblStatusBadge.Text = "Status: " + status;
                    lblTimeLimitStudent.Text = "Time Limit: " + FormatTimeLimit(totalSeconds);
                    lblPassingStudent.Text = "Passing Score: " + passingScore + "%";
                    reader.Close();

                    SqlCommand countCmd = new SqlCommand(
                        "SELECT COUNT(*) FROM QuizAttempt WHERE RegistrationID = @RegistrationID AND QuizID = @QuizID", conn);
                    countCmd.Parameters.AddWithValue("@RegistrationID", registrationID);
                    countCmd.Parameters.AddWithValue("@QuizID", quizID);
                    int attemptsUsed = Convert.ToInt32(countCmd.ExecuteScalar());

                    lblAttemptsInfo.Text = "Attempts: " + attemptsUsed + " / " + maxAttempts;
                    btnAttempt.Enabled = status == "Open" && attemptsUsed < maxAttempts;
                    ViewState["RegistrationID"] = registrationID;
                    ViewState["AttemptsUsed"] = attemptsUsed;

                    if (attemptsUsed > 0)
                        LoadStudentAttempts(quizID, registrationID, conn);
                }
                else
                {
                    reader.Close();
                }
            }
        }

        // bind student attempts grid
        private void LoadStudentAttempts(int quizID, int registrationID, SqlConnection conn)
        {
            string query = @"
                SELECT QuizAttemptID, AttemptNumber, DateTaken, Score,
                       CASE WHEN IsPassed = 1 THEN 'Pass' ELSE 'Fail' END AS Result
                FROM QuizAttempt
                WHERE RegistrationID = @RegistrationID AND QuizID = @QuizID
                ORDER BY AttemptNumber DESC";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@RegistrationID", registrationID);
            cmd.Parameters.AddWithValue("@QuizID", quizID);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvStudentAttempts.DataSource = dt;
            gvStudentAttempts.DataBind();
            pnlPreviousAttempts.Visible = true;
        }

        protected void btnAttempt_Click(object sender, EventArgs e)
        {
            int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
            int registrationID = Convert.ToInt32(ViewState["RegistrationID"]);
            int attemptsUsed = Convert.ToInt32(ViewState["AttemptsUsed"]);
            int newAttemptNumber = attemptsUsed + 1;
            int newQuizAttemptID;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    INSERT INTO QuizAttempt (RegistrationID, QuizID, Score, AttemptNumber, DateTaken, IsPassed)
                    VALUES (@RegistrationID, @QuizID, 0, @AttemptNumber, GETDATE(), 0);
                    SELECT SCOPE_IDENTITY()";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@RegistrationID", registrationID);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                cmd.Parameters.AddWithValue("@AttemptNumber", newAttemptNumber);
                conn.Open();
                newQuizAttemptID = Convert.ToInt32(cmd.ExecuteScalar());
            }

            Response.Redirect("quiz.aspx?QuizID=" + quizID + "&QuizAttemptID=" + newQuizAttemptID);
        }

        // admin view — quiz info + status toggle + student list
        private void LoadAdminView(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT [TimeLimit], [PassingScores], [MaxAttempts], [Status] FROM QuizContent WHERE QuizID = @QuizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    int totalSeconds = Convert.ToInt32(reader["TimeLimit"]);
                    int passingScore = Convert.ToInt32(reader["PassingScores"]);
                    int maxAttempts = Convert.ToInt32(reader["MaxAttempts"]);
                    string status = reader["Status"].ToString();
                    lblTimeLimitAdmin.Text = "Time Limit: " + FormatTimeLimit(totalSeconds);
                    lblPassingAdmin.Text = "Passing Score: " + passingScore + "%";
                    lblMaxAttemptsAdmin.Text = "Max Attempts: " + maxAttempts;
                    btnToggleStatus.Text = status == "Open" ? "Close Quiz" : "Open Quiz";
                    ViewState["CurrentStatus"] = status;
                }
                reader.Close();
            }
            LoadAdminStudentList(quizID);
        }

        // bind admin student list grid
        private void LoadAdminStudentList(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT r.RegistrationID,
                           u.Username,
                           COUNT(qa.QuizAttemptID) AS AttemptsUsed,
                           MAX(qa.Score)            AS BestScore
                    FROM QuizAttempt qa
                    JOIN Registration r ON qa.RegistrationID = r.RegistrationID
                    JOIN [User] u       ON r.UserID = u.UserID
                    WHERE qa.QuizID = @QuizID
                    GROUP BY r.RegistrationID, u.Username
                    ORDER BY BestScore DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAdminStudents.DataSource = dt;
                gvAdminStudents.DataBind();
            }
        }

        protected void btnToggleStatus_Click(object sender, EventArgs e)
        {
            int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
            string currentStatus = ViewState["CurrentStatus"].ToString();
            string newStatus = currentStatus == "Open" ? "Closed" : "Open";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE QuizContent SET [Status] = @Status WHERE QuizID = @QuizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadTitle(quizID);
            LoadAdminView(quizID);
        }

        protected void btnReturn_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["CourseID"] != null && Request.QueryString["LessonID"] != null)
            {
                string courseID = Request.QueryString["CourseID"];
                string lessonID = Request.QueryString["LessonID"];
                Response.Redirect($"SelectedCoursePage.aspx?CourseID={courseID}&LessonID={lessonID}");
            }
            else
            {
                Response.Redirect("StudentDashboard.aspx");
            }
        }

        protected void gvStudentAttempts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReviewAttempt")
            {
                int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int quizAttemptID = Convert.ToInt32(gvStudentAttempts.DataKeys[rowIndex].Value);
                Response.Redirect("quiz.aspx?QuizID=" + quizID + "&QuizAttemptID=" + quizAttemptID + "&Mode=Review");
            }
        }

        protected void gvAdminStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReviewStudent")
            {
                int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int registrationID = Convert.ToInt32(gvAdminStudents.DataKeys[rowIndex].Value);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        SELECT TOP 1 QuizAttemptID
                        FROM QuizAttempt
                        WHERE RegistrationID = @RegistrationID AND QuizID = @QuizID
                        ORDER BY Score DESC";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@RegistrationID", registrationID);
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    conn.Open();
                    int quizAttemptID = Convert.ToInt32(cmd.ExecuteScalar());
                    Response.Redirect("quiz.aspx?QuizID=" + quizID + "&QuizAttemptID=" + quizAttemptID + "&Mode=Review");
                }
            }
        }
    }
}
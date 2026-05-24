using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Wapping_time
{
    public partial class createQuiz : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["CourseID"] == null || Request.QueryString["LessonID"] == null)
                {
                    lblInstruction.Text = "Invalid access. Missing course or lesson information.";
                    lblInstruction.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                int courseID = Convert.ToInt32(Request.QueryString["CourseID"]);
                int lessonID = Convert.ToInt32(Request.QueryString["LessonID"]);

                LoadCourseName(courseID);

                int contentID = GetContentID(lessonID);
                ViewState["ContentID"] = contentID;

                if (Request.QueryString["QuizID"] != null)
                {
                    int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
                    LoadQuiz(quizID);
                    LoadQuestions(quizID);
                    lblAddingFor.Text = "Adding questions for: " + txtQuizName.Text;
                }
            }
        }

        private void LoadCourseName(int courseID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT CourseName FROM Course WHERE CourseID = @CourseID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@CourseID", courseID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblCourseName.Text = reader["CourseName"].ToString();
                }
                reader.Close();
            }
        }
        private int GetContentID(int lessonID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string insertQuery = "INSERT INTO Content (LessonID, Position, Type) VALUES (@LessonID, 'Quiz', 'Quiz'); SELECT SCOPE_IDENTITY()";
                SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                insertCmd.Parameters.AddWithValue("@LessonID", lessonID);
                object newID = insertCmd.ExecuteScalar();
                return Convert.ToInt32(newID);
            }
        }

        private void LoadQuiz(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT [Name], [TimeLimit], [PassingScores], [MaxAttempts] FROM QuizContent WHERE QuizID = @QuizID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtQuizName.Text = reader["Name"].ToString();

                    int totalSeconds = Convert.ToInt32(reader["TimeLimit"]);
                    int hours = totalSeconds / 3600;
                    int minutes = (totalSeconds % 3600) / 60;
                    txtTimeLimit.Text = hours.ToString("D2") + minutes.ToString("D2");

                    txtPassingScore.Text = reader["PassingScores"].ToString();
                    txtMaxAttempts.Text = reader["MaxAttempts"].ToString();
                }
                reader.Close();
            }
        }

        private void LoadQuestions(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT QuestionOrder, Question, QuestionType, Point FROM Question WHERE QuizID = @QuizID ORDER BY QuestionOrder";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dt.Columns[0].ColumnName = "#";
                dt.Columns[1].ColumnName = "Question";
                dt.Columns[2].ColumnName = "Type";
                dt.Columns[3].ColumnName = "Points";
                gvQuestions.DataSource = dt;
                gvQuestions.DataBind();
            }
        }

        private int ParseTimeLimit(string input)
        {
            input = input.Replace(":", "").Trim();
            input = input.PadLeft(4, '0');

            int hours = Convert.ToInt32(input.Substring(0, 2));
            int minutes = Convert.ToInt32(input.Substring(2, 2));

            if (minutes > 59)
            {
                return -1;
            }

            return (hours * 3600) + (minutes * 60);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtQuizName.Text.Trim()))
            {
                lblInstruction.Text = "Quiz Name is required.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrEmpty(txtTimeLimit.Text.Trim()))
            {
                lblInstruction.Text = "Time Limit is required.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int totalSeconds = ParseTimeLimit(txtTimeLimit.Text.Trim());
            if (totalSeconds == -1)
            {
                lblInstruction.Text = "Invalid Time Limit. Minutes cannot exceed 59.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrEmpty(txtPassingScore.Text.Trim()))
            {
                lblInstruction.Text = "Passing Percentage is required.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrEmpty(txtMaxAttempts.Text.Trim()))
            {
                lblInstruction.Text = "Max Attempts is required.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int passingScore;
            if (!int.TryParse(txtPassingScore.Text.Trim(), out passingScore) || passingScore < 1 || passingScore > 100)
            {
                lblInstruction.Text = "Passing Percentage must be a number between 1 and 100.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int maxAttempts;
            if (!int.TryParse(txtMaxAttempts.Text.Trim(), out maxAttempts) || maxAttempts < 1)
            {
                lblInstruction.Text = "Max Attempts must be a number greater than 0.";
                lblInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }
            int contentID = Convert.ToInt32(ViewState["ContentID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (Request.QueryString["QuizID"] != null)
                {
                    int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
                    string query = "UPDATE QuizContent SET [Name] = @Name, [TimeLimit] = @TimeLimit, [PassingScores] = @PassingScores, [MaxAttempts] = @MaxAttempts WHERE QuizID = @QuizID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Name", txtQuizName.Text.Trim());
                    cmd.Parameters.AddWithValue("@TimeLimit", totalSeconds.ToString());
                    cmd.Parameters.AddWithValue("@PassingScores", passingScore);
                    cmd.Parameters.AddWithValue("@MaxAttempts", maxAttempts);
                    cmd.Parameters.AddWithValue("@QuizID", quizID);
                    cmd.ExecuteNonQuery();
                    lblInstruction.Text = "Quiz updated successfully.";
                    lblInstruction.ForeColor = System.Drawing.Color.Green;
                    lblAddingFor.Text = "Adding questions for: " + txtQuizName.Text.Trim();
                }
                else
                {
                    string query = "INSERT INTO QuizContent ([ContentID], [Name], [TimeLimit], [PassingScores], [MaxAttempts]) VALUES (@ContentID, @Name, @TimeLimit, @PassingScores, @MaxAttempts); SELECT SCOPE_IDENTITY()";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ContentID", contentID);
                    cmd.Parameters.AddWithValue("@Name", txtQuizName.Text.Trim());
                    cmd.Parameters.AddWithValue("@TimeLimit", totalSeconds.ToString());
                    cmd.Parameters.AddWithValue("@PassingScores", passingScore);
                    cmd.Parameters.AddWithValue("@MaxAttempts", maxAttempts);
                    int newQuizID = Convert.ToInt32(cmd.ExecuteScalar());
                    ViewState["QuizID"] = newQuizID;
                    lblInstruction.Text = "Quiz created successfully. You can now add questions.";
                    lblInstruction.ForeColor = System.Drawing.Color.Green;
                    lblAddingFor.Text = "Adding questions for: " + txtQuizName.Text.Trim();
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtQuizName.Text = string.Empty;
            txtTimeLimit.Text = string.Empty;
            txtPassingScore.Text = string.Empty;
            txtMaxAttempts.Text = string.Empty;
            lblInstruction.Text = "Fill in the details below to create a quiz.";
            lblInstruction.ForeColor = System.Drawing.Color.Gray;
            ViewState["QuizID"] = null;
            ViewState["ContentID"] = null;
            gvQuestions.DataSource = null;
            gvQuestions.DataBind();
            txtQuestionText.Text = string.Empty;
            txtAnswer1.Text = string.Empty;
            txtAnswer2.Text = string.Empty;
            txtAnswer3.Text = string.Empty;
            txtPoints.Text = string.Empty;
            rbAnswer1.Checked = false;
            rbAnswer2.Checked = false;
            rbAnswer3.Checked = false;
            lblAddingFor.Text = string.Empty;
            lblQuestionInstruction.Text = "Select a question type and fill in the details below.";
            lblQuestionInstruction.ForeColor = System.Drawing.Color.Gray;
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (ViewState["QuizID"] == null && Request.QueryString["QuizID"] == null)
            {
                lblQuestionInstruction.Text = "Please save the quiz first before adding questions.";
                lblQuestionInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrEmpty(txtQuestionText.Text.Trim()))
            {
                lblQuestionInstruction.Text = "Question Text is required.";
                lblQuestionInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (string.IsNullOrEmpty(txtPoints.Text.Trim()))
            {
                lblQuestionInstruction.Text = "Points is required.";
                lblQuestionInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (ddlQuestionType.SelectedValue == "MCQ")
            {
                if (string.IsNullOrEmpty(txtAnswer1.Text.Trim()) ||
                    string.IsNullOrEmpty(txtAnswer2.Text.Trim()) ||
                    string.IsNullOrEmpty(txtAnswer3.Text.Trim()))
                {
                    lblQuestionInstruction.Text = "All three answers are required for MCQ.";
                    lblQuestionInstruction.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (!rbAnswer1.Checked && !rbAnswer2.Checked && !rbAnswer3.Checked)
                {
                    lblQuestionInstruction.Text = "Please select the correct answer.";
                    lblQuestionInstruction.ForeColor = System.Drawing.Color.Red;
                    return;
                }
            }

            int quizID = Request.QueryString["QuizID"] != null
                ? Convert.ToInt32(Request.QueryString["QuizID"])
                : Convert.ToInt32(ViewState["QuizID"]);

            int points;
            if (!int.TryParse(txtPoints.Text.Trim(), out points) || points < 1)
            {
                lblQuestionInstruction.Text = "Points must be a number greater than 0.";
                lblQuestionInstruction.ForeColor = System.Drawing.Color.Red;
                return;
            }
            string questionType = ddlQuestionType.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand orderCmd = new SqlCommand("SELECT ISNULL(MAX(QuestionOrder), 0) + 1 FROM Question WHERE QuizID = @QuizID", conn);
                orderCmd.Parameters.AddWithValue("@QuizID", quizID);
                int questionOrder = Convert.ToInt32(orderCmd.ExecuteScalar());

                string questionQuery = "INSERT INTO Question ([QuizID], [Question], [Point], [QuestionOrder], [QuestionType]) VALUES (@QuizID, @Question, @Point, @QuestionOrder, @QuestionType); SELECT SCOPE_IDENTITY()";
                SqlCommand questionCmd = new SqlCommand(questionQuery, conn);
                questionCmd.Parameters.AddWithValue("@QuizID", quizID);
                questionCmd.Parameters.AddWithValue("@Question", txtQuestionText.Text.Trim());
                questionCmd.Parameters.AddWithValue("@Point", points);
                questionCmd.Parameters.AddWithValue("@QuestionOrder", questionOrder);
                questionCmd.Parameters.AddWithValue("@QuestionType", questionType);
                int newQuestionID = Convert.ToInt32(questionCmd.ExecuteScalar());

                if (questionType == "MCQ")
                {
                    string[] answers = { txtAnswer1.Text.Trim(), txtAnswer2.Text.Trim(), txtAnswer3.Text.Trim() };
                    bool[] correct = { rbAnswer1.Checked, rbAnswer2.Checked, rbAnswer3.Checked };

                    for (int i = 0; i < answers.Length; i++)
                    {
                        string answerQuery = "INSERT INTO Answer ([QuestionID], [Answers], [CorrectOrNot]) VALUES (@QuestionID, @Answers, @CorrectOrNot)";
                        SqlCommand answerCmd = new SqlCommand(answerQuery, conn);
                        answerCmd.Parameters.AddWithValue("@QuestionID", newQuestionID);
                        answerCmd.Parameters.AddWithValue("@Answers", answers[i]);
                        answerCmd.Parameters.AddWithValue("@CorrectOrNot", correct[i] ? 1 : 0);
                        answerCmd.ExecuteNonQuery();
                    }
                }
            }

            txtQuestionText.Text = string.Empty;
            txtAnswer1.Text = string.Empty;
            txtAnswer2.Text = string.Empty;
            txtAnswer3.Text = string.Empty;
            txtPoints.Text = string.Empty;
            rbAnswer1.Checked = false;
            rbAnswer2.Checked = false;
            rbAnswer3.Checked = false;

            int reloadQuizID = Request.QueryString["QuizID"] != null
                ? Convert.ToInt32(Request.QueryString["QuizID"])
                : Convert.ToInt32(ViewState["QuizID"]);
            LoadQuestions(reloadQuizID);

            lblQuestionInstruction.Text = "Question added successfully.";
            lblQuestionInstruction.ForeColor = System.Drawing.Color.Green;
        }
    }
}
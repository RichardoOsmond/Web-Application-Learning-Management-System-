using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class quiz : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            if (Request.QueryString["QuizID"] == null || Request.QueryString["QuizAttemptID"] == null)
            {
                Response.Redirect("StudentDashboard.aspx");
                return;
            }

            int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);

            if (!IsPostBack)
                LoadTitle(quizID);

            bool isReview = Request.QueryString["Mode"] == "Review";

            if (isReview)
            {
                hfTimeLimit.Value = "0";
                btnSubmit.Visible = false;
                btnBack.Visible = true;
                int quizAttemptID = Convert.ToInt32(Request.QueryString["QuizAttemptID"]);
                LoadQuestionsReview(quizID, quizAttemptID);
            }
            else
            {
                LoadQuestions(quizID);
            }
        }

        // load title + set timer
        private void LoadTitle(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT qc.[Name], co.CourseName, qc.TimeLimit
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
                {
                    lblCourseQuizTitle.Text = reader["CourseName"].ToString() + " — " + reader["Name"].ToString();
                    int totalSeconds = Convert.ToInt32(reader["TimeLimit"]);
                    hfTimeLimit.Value = totalSeconds.ToString();
                    lblInstruction.Text = "Answer all questions and click Submit when done.";
                }
                reader.Close();
            }
        }

        // build question controls for attempt mode
        private void LoadQuestions(int quizID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT QuestionID, Question, QuestionType, Point
                    FROM Question
                    WHERE QuizID = @QuizID
                    ORDER BY QuestionOrder";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                int questionNumber = 1;
                while (reader.Read())
                {
                    int questionID = Convert.ToInt32(reader["QuestionID"]);
                    string questionText = reader["Question"].ToString();
                    string questionType = reader["QuestionType"].ToString();
                    int points = Convert.ToInt32(reader["Point"]);

                    Panel pnlQuestion = new Panel();
                    pnlQuestion.CssClass = "quiz-mcq-panel";
                    pnlQuestion.Style["margin-bottom"] = "16px";

                    Label lblQuestion = new Label();
                    lblQuestion.CssClass = "quiz-field-label";
                    lblQuestion.Text = questionNumber + ". " + questionText + " (" + points + " pt" + (points > 1 ? "s" : "") + ")";
                    pnlQuestion.Controls.Add(lblQuestion);
                    pnlQuestion.Controls.Add(new LiteralControl("<br/>"));

                    if (questionType == "MCQ")
                    {
                        RadioButtonList rbl = new RadioButtonList();
                        rbl.ID = "rbl_" + questionID;
                        rbl.CssClass = "quiz-field-input";
                        rbl.Style["border"] = "none";
                        rbl.Style["width"] = "auto";
                        LoadAnswersIntoRBL(questionID, rbl);
                        pnlQuestion.Controls.Add(rbl);
                    }
                    else
                    {
                        TextBox txtEssay = new TextBox();
                        txtEssay.ID = "txt_" + questionID;
                        txtEssay.CssClass = "quiz-field-input";
                        txtEssay.TextMode = TextBoxMode.MultiLine;
                        txtEssay.Rows = 4;
                        txtEssay.Style["width"] = "100%";
                        txtEssay.Attributes["placeholder"] = "Type your answer here...";
                        pnlQuestion.Controls.Add(txtEssay);
                    }

                    pnlMain.Controls.Add(pnlQuestion);
                    questionNumber++;
                }
                reader.Close();
            }
        }

        // build question controls for review mode, pre-filled + colored
        private void LoadQuestionsReview(int quizID, int quizAttemptID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string questionQuery = @"
                    SELECT q.QuestionID, q.Question, q.QuestionType, q.Point,
                           sa.Answer, sa.Status
                    FROM Question q
                    LEFT JOIN StudentAnswer sa ON q.QuestionID = sa.QuestionID
                        AND sa.QuizAttemptID = @QuizAttemptID
                    WHERE q.QuizID = @QuizID
                    ORDER BY q.QuestionOrder";
                SqlCommand cmd = new SqlCommand(questionQuery, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizID);
                cmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
                SqlDataReader reader = cmd.ExecuteReader();
                DataTable dtQuestions = new DataTable();
                dtQuestions.Load(reader);
                int questionNumber = 1;
                foreach (DataRow row in dtQuestions.Rows)
                {
                    int questionID = Convert.ToInt32(row["QuestionID"]);
                    string questionText = row["Question"].ToString();
                    string questionType = row["QuestionType"].ToString();
                    int points = Convert.ToInt32(row["Point"]);
                    string studentAnswer = row["Answer"] == DBNull.Value ? "" : row["Answer"].ToString();
                    string status = row["Status"] == DBNull.Value ? "" : row["Status"].ToString();

                    Panel pnlQuestion = new Panel();
                    pnlQuestion.CssClass = "quiz-mcq-panel";
                    if (status == "Correct")
                    {
                        pnlQuestion.Style["background-color"] = "#eaffea";
                        pnlQuestion.Style["border-left"] = "4px solid #4caf50";
                    }
                    else if (status == "Incorrect")
                    {
                        pnlQuestion.Style["background-color"] = "#fff0f0";
                        pnlQuestion.Style["border-left"] = "4px solid #f44336";
                    }
                    else
                    {
                        pnlQuestion.Style["background-color"] = "#fffbe6";
                        pnlQuestion.Style["border-left"] = "4px solid #ffc107";
                    }
                    pnlQuestion.Style["margin-bottom"] = "16px";

                    Label lblQuestion = new Label();
                    lblQuestion.CssClass = "quiz-field-label";
                    lblQuestion.Text = questionNumber + ". " + questionText + " (" + points + " pt" + (points > 1 ? "s" : "") + ")";
                    pnlQuestion.Controls.Add(lblQuestion);
                    pnlQuestion.Controls.Add(new LiteralControl("<br/>"));

                    if (questionType == "MCQ")
                    {
                        RadioButtonList rbl = new RadioButtonList();
                        rbl.ID = "rbl_" + questionID;
                        rbl.CssClass = "quiz-field-input";
                        rbl.Style["border"] = "none";
                        rbl.Style["width"] = "auto";
                        rbl.Enabled = false;
                        LoadAnswersIntoRBL(questionID, rbl);
                        ListItem selected = rbl.Items.FindByValue(studentAnswer);
                        if (selected != null)
                            selected.Selected = true;
                        pnlQuestion.Controls.Add(rbl);
                        if (status == "Incorrect" || string.IsNullOrEmpty(studentAnswer))
                        {
                            string correctAnswer = GetCorrectAnswer(questionID);
                            Label lblCorrect = new Label();
                            lblCorrect.CssClass = "quiz-hint-label";
                            lblCorrect.ForeColor = System.Drawing.Color.Green;
                            lblCorrect.Text = "Correct answer: " + correctAnswer;
                            pnlQuestion.Controls.Add(new LiteralControl("<br/>"));
                            pnlQuestion.Controls.Add(lblCorrect);
                        }
                    }
                    else
                    {
                        TextBox txtEssay = new TextBox();
                        txtEssay.ID = "txt_" + questionID;
                        txtEssay.CssClass = "quiz-field-input";
                        txtEssay.TextMode = TextBoxMode.MultiLine;
                        txtEssay.Rows = 4;
                        txtEssay.Style["width"] = "100%";
                        txtEssay.Text = studentAnswer;
                        txtEssay.Enabled = false;
                        pnlQuestion.Controls.Add(txtEssay);

                        txtEssay.Enabled = false;
                        pnlQuestion.Controls.Add(txtEssay);

                        // show admin comment to everyone if exists
                        string existingComment = GetAdminComment(questionID, Convert.ToInt32(Request.QueryString["QuizAttemptID"]));
                        if (!string.IsNullOrEmpty(existingComment))
                        {
                            Label lblAdminComment = new Label();
                            lblAdminComment.CssClass = "quiz-hint-label";
                            lblAdminComment.ForeColor = System.Drawing.Color.DarkBlue;
                            lblAdminComment.Text = "Instructor feedback: " + existingComment;
                            pnlQuestion.Controls.Add(new LiteralControl("<br/>"));
                            pnlQuestion.Controls.Add(lblAdminComment);
                        }

                        // admin grading controls
                        if (Convert.ToInt32(Session["RoleID"]) == 2 || Convert.ToInt32(Session["RoleID"]) == 3)

                            // admin grading controls
                            if (Convert.ToInt32(Session["RoleID"]) == 2 || Convert.ToInt32(Session["RoleID"]) == 3)
                        {
                            // current status label
                            Label lblCurrentStatus = new Label();
                            lblCurrentStatus.CssClass = "quiz-hint-label";
                            lblCurrentStatus.Text = "Current Status: " + (string.IsNullOrEmpty(status) ? "Pending" : status);
                            pnlQuestion.Controls.Add(new LiteralControl("<br/>"));
                            pnlQuestion.Controls.Add(lblCurrentStatus);

                            // admin comment box
                            Label lblComment = new Label();
                            lblComment.CssClass = "quiz-field-label";
                            lblComment.Text = "Admin Comment / Correct Answer:";
                            pnlQuestion.Controls.Add(new LiteralControl("<br/>"));
                            pnlQuestion.Controls.Add(lblComment);

                            TextBox txtComment = new TextBox();
                            txtComment.ID = "comment_" + questionID;
                            txtComment.CssClass = "quiz-field-input";
                            txtComment.TextMode = TextBoxMode.MultiLine;
                            txtComment.Rows = 3;
                            txtComment.Style["width"] = "100%";

                            // load existing comment if any
                            txtComment.Text = GetAdminComment(questionID, Convert.ToInt32(Request.QueryString["QuizAttemptID"]));
                            pnlQuestion.Controls.Add(txtComment);

                            // mark correct button
                            Button btnCorrect = new Button();
                            btnCorrect.ID = "correct_" + questionID;
                            btnCorrect.Text = "Mark Correct";
                            btnCorrect.CssClass = "quiz-btn-save";
                            btnCorrect.Style["margin-right"] = "8px";
                            btnCorrect.CommandArgument = questionID.ToString();
                            btnCorrect.Click += new EventHandler(btnGradeEssay_Correct);
                            pnlQuestion.Controls.Add(new LiteralControl("<br/><br/>"));
                            pnlQuestion.Controls.Add(btnCorrect);

                            // mark incorrect button
                            Button btnIncorrect = new Button();
                            btnIncorrect.ID = "incorrect_" + questionID;
                            btnIncorrect.Text = "Mark Incorrect";
                            btnIncorrect.CssClass = "quiz-btn-clear";
                            btnIncorrect.CommandArgument = questionID.ToString();
                            btnIncorrect.Click += new EventHandler(btnGradeEssay_Incorrect);
                            pnlQuestion.Controls.Add(btnIncorrect);
                        }
                    }

                    pnlMain.Controls.Add(pnlQuestion);
                    questionNumber++;
                }
            }
        }

        protected void btnGradeEssay_Correct(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int questionID = Convert.ToInt32(btn.CommandArgument);
            GradeEssay(questionID, "Correct");
        }

        protected void btnGradeEssay_Incorrect(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int questionID = Convert.ToInt32(btn.CommandArgument);
            GradeEssay(questionID, "Incorrect");
        }

        private void GradeEssay(int questionID, string status)
        {
            int quizAttemptID = Convert.ToInt32(Request.QueryString["QuizAttemptID"]);

            // get comment from dynamic textbox
            TextBox txtComment = (TextBox)pnlMain.FindControl("comment_" + questionID);
            string comment = txtComment != null ? txtComment.Text.Trim() : "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // update status and comment
                string updateAnswer = @"UPDATE StudentAnswer 
                                SET Status = @Status, AdminComment = @AdminComment 
                                WHERE QuestionID = @QuestionID AND QuizAttemptID = @QuizAttemptID";
                SqlCommand cmd = new SqlCommand(updateAnswer, conn);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@AdminComment", comment);
                cmd.Parameters.AddWithValue("@QuestionID", questionID);
                cmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
                cmd.ExecuteNonQuery();

                // recalculate score
                RecalcScore(quizAttemptID, conn);
            }

            // reload review page
            int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
            string courseID = Request.QueryString["CourseID"] ?? "";
            string lessonID = Request.QueryString["LessonID"] ?? "";
            Response.Redirect($"quiz.aspx?QuizID={quizID}&QuizAttemptID={quizAttemptID}&Mode=Review&CourseID={courseID}&LessonID={lessonID}");
        }

        private void RecalcScore(int quizAttemptID, SqlConnection conn)
        {
            // get total points earned (only Correct answers)
            string scoreQuery = @"
        SELECT SUM(q.Point)
        FROM StudentAnswer sa
        JOIN Question q ON sa.QuestionID = q.QuestionID
        WHERE sa.QuizAttemptID = @QuizAttemptID AND sa.Status = 'Correct'";
            SqlCommand scoreCmd = new SqlCommand(scoreQuery, conn);
            scoreCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
            object scoreResult = scoreCmd.ExecuteScalar();
            decimal totalEarned = scoreResult != DBNull.Value && scoreResult != null ? Convert.ToDecimal(scoreResult) : 0;

            // get total possible points
            string totalQuery = @"
        SELECT SUM(q.Point)
        FROM StudentAnswer sa
        JOIN Question q ON sa.QuestionID = q.QuestionID
        WHERE sa.QuizAttemptID = @QuizAttemptID";
            SqlCommand totalCmd = new SqlCommand(totalQuery, conn);
            totalCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
            object totalResult = totalCmd.ExecuteScalar();
            decimal totalPoints = totalResult != DBNull.Value && totalResult != null ? Convert.ToDecimal(totalResult) : 0;

            decimal scorePercent = totalPoints > 0 ? (totalEarned / totalPoints) * 100 : 0;

            // get passing score for this attempt's quiz
            string passingQuery = @"
        SELECT qc.PassingScores 
        FROM QuizAttempt qa
        JOIN QuizContent qc ON qa.QuizID = qc.QuizID
        WHERE qa.QuizAttemptID = @QuizAttemptID";
            SqlCommand passingCmd = new SqlCommand(passingQuery, conn);
            passingCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
            int passingScore = Convert.ToInt32(passingCmd.ExecuteScalar());

            bool isPassed = scorePercent >= passingScore;

            // update QuizAttempt
            string updateQuery = @"UPDATE QuizAttempt 
                           SET Score = @Score, IsPassed = @IsPassed 
                           WHERE QuizAttemptID = @QuizAttemptID";
            SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
            updateCmd.Parameters.AddWithValue("@Score", scorePercent);
            updateCmd.Parameters.AddWithValue("@IsPassed", isPassed ? 1 : 0);
            updateCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
            updateCmd.ExecuteNonQuery();
        }

        // load answers into a RadioButtonList
        private void LoadAnswersIntoRBL(int questionID, RadioButtonList rbl)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT AnswerID, Answers FROM Answer WHERE QuestionID = @QuestionID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionID);
                conn.Open();
                SqlDataReader answerReader = cmd.ExecuteReader();
                while (answerReader.Read())
                {
                    ListItem item = new ListItem();
                    item.Text = answerReader["Answers"].ToString();
                    item.Value = answerReader["Answers"].ToString();
                    rbl.Items.Add(item);
                }
                answerReader.Close();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
            int quizAttemptID = Convert.ToInt32(Request.QueryString["QuizAttemptID"]);

            // guard against resubmission
            using (SqlConnection checkConn = new SqlConnection(connStr))
            {
                string checkQuery = "SELECT COUNT(*) FROM StudentAnswer WHERE QuizAttemptID = @QuizAttemptID";
                SqlCommand checkCmd = new SqlCommand(checkQuery, checkConn);
                checkCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
                checkConn.Open();
                int existing = Convert.ToInt32(checkCmd.ExecuteScalar());
                if (existing > 0)
                {
                    Response.Redirect("bridgePage.aspx?QuizID=" + quizID);
                    return;
                }
            }

            decimal totalScore = 0;
            decimal totalPoints = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string questionQuery = @"
                    SELECT QuestionID, QuestionType, Point
                    FROM Question
                    WHERE QuizID = @QuizID
                    ORDER BY QuestionOrder";
                SqlCommand questionCmd = new SqlCommand(questionQuery, conn);
                questionCmd.Parameters.AddWithValue("@QuizID", quizID);
                SqlDataReader questionReader = questionCmd.ExecuteReader();
                DataTable dtQuestions = new DataTable();
                dtQuestions.Load(questionReader);

                foreach (DataRow row in dtQuestions.Rows)
                {
                    int questionID = Convert.ToInt32(row["QuestionID"]);
                    string questionType = row["QuestionType"].ToString();
                    int points = Convert.ToInt32(row["Point"]);
                    totalPoints += points;
                    string studentAnswer = "";
                    string status = "";

                    if (questionType == "MCQ")
                    {
                        RadioButtonList rbl = (RadioButtonList)pnlMain.FindControl("rbl_" + questionID);
                        studentAnswer = rbl != null && rbl.SelectedItem != null ? rbl.SelectedItem.Value : "";
                        string correctAnswer = GetCorrectAnswer(questionID, conn);
                        if (studentAnswer == correctAnswer)
                        {
                            status = "Correct";
                            totalScore += points;
                        }
                        else
                        {
                            status = "Incorrect";
                        }
                    }
                    else
                    {
                        TextBox txtEssay = (TextBox)pnlMain.FindControl("txt_" + questionID);
                        studentAnswer = txtEssay != null ? txtEssay.Text.Trim() : "";
                        status = "Pending";
                    }

                    string insertAnswer = @"
                        INSERT INTO StudentAnswer (QuizAttemptID, QuestionID, Answer, Status)
                        VALUES (@QuizAttemptID, @QuestionID, @Answer, @Status)";
                    SqlCommand insertCmd = new SqlCommand(insertAnswer, conn);
                    insertCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
                    insertCmd.Parameters.AddWithValue("@QuestionID", questionID);
                    insertCmd.Parameters.AddWithValue("@Answer", studentAnswer);
                    insertCmd.Parameters.AddWithValue("@Status", status);
                    insertCmd.ExecuteNonQuery();
                }

                decimal scorePercent = totalPoints > 0 ? (totalScore / totalPoints) * 100 : 0;
                SqlCommand passingCmd = new SqlCommand("SELECT PassingScores FROM QuizContent WHERE QuizID = @QuizID", conn);
                passingCmd.Parameters.AddWithValue("@QuizID", quizID);
                int passingScore = Convert.ToInt32(passingCmd.ExecuteScalar());
                bool isPassed = scorePercent >= passingScore;

                string updateAttempt = @"
                    UPDATE QuizAttempt
                    SET Score = @Score, IsPassed = @IsPassed
                    WHERE QuizAttemptID = @QuizAttemptID";
                SqlCommand updateCmd = new SqlCommand(updateAttempt, conn);
                updateCmd.Parameters.AddWithValue("@Score", scorePercent);
                updateCmd.Parameters.AddWithValue("@IsPassed", isPassed ? 1 : 0);
                updateCmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
                updateCmd.ExecuteNonQuery();
            }

            Response.Redirect("bridgePage.aspx?QuizID=" + quizID);
        }

        // overload for btnSubmit — reuses open connection
        private string GetCorrectAnswer(int questionID, SqlConnection conn)
        {
            string query = "SELECT Answers FROM Answer WHERE QuestionID = @QuestionID AND CorrectOrNot = 1";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@QuestionID", questionID);
            object result = cmd.ExecuteScalar();
            return result != null ? result.ToString() : "";
        }

        // overload for review — opens its own connection
        private string GetCorrectAnswer(int questionID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Answers FROM Answer WHERE QuestionID = @QuestionID AND CorrectOrNot = 1";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "";
            }
        }
        private string GetAdminComment(int questionID, int quizAttemptID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT AdminComment FROM StudentAnswer WHERE QuestionID = @QuestionID AND QuizAttemptID = @QuizAttemptID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuestionID", questionID);
                cmd.Parameters.AddWithValue("@QuizAttemptID", quizAttemptID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null && result != DBNull.Value ? result.ToString() : "";
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            int quizID = Convert.ToInt32(Request.QueryString["QuizID"]);
            string courseID = Request.QueryString["CourseID"] ?? "";
            string lessonID = Request.QueryString["LessonID"] ?? "";
            Response.Redirect($"bridgePage.aspx?QuizID={quizID}&CourseID={courseID}&LessonID={lessonID}");
        }
    }
} 
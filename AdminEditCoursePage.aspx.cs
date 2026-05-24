using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class EditMaterial : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;
        protected int selectedLessonID
        {
            get { return ViewState["selectedLessonID"] != null ? (int)ViewState["selectedLessonID"] : 0; }
            set { ViewState["selectedLessonID"] = value; }
        }

        protected int selectedMaterialID
        {
            get { return ViewState["selectedMaterialID"] != null ? (int)ViewState["selectedMaterialID"] : 0; }
            set { ViewState["selectedMaterialID"] = value; }
        }
        protected int selectedQuizID
        {
            get { return ViewState["selectedQuizID"] != null ? (int)ViewState["selectedQuizID"] : 0; }
            set { ViewState["selectedQuizID"] = value; }
        }
        protected string selectedType
        {
            get { return ViewState["selectedType"] != null ? (string)ViewState["selectedType"] : ""; }
            set { ViewState["selectedType"] = value; }
        }
        protected int selectedCourseID
        {
            get { return ViewState["selectedCourseID"] != null ? (int)ViewState["selectedCourseID"] : -1; }
            set { ViewState["selectedCourseID"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("login.aspx");

            if (!IsPostBack)
            {
                selectedCourseID = int.Parse(Request.QueryString["CourseID"]);
                selectedLessonID = int.Parse(Request.QueryString["LessonID"]);
                selectedType = Request.QueryString["type"];
                LoadLessons(selectedCourseID);
                if(selectedLessonID > 0)
                {
                    LoadContent(selectedLessonID, selectedType);
                }
            }

            if (selectedType == "material") ScriptManager.RegisterStartupScript(this, this.GetType(), "showSection", "showMaterialOnly();", true);
            else if (selectedType == "quiz") ScriptManager.RegisterStartupScript(this, this.GetType(), "showSection", "showQuizOnly();", true);
        }

        protected void varBtn_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string btnID = btn.ID; // "addBtn", "editBtn", "deleteBtn"

            char section = btnID[0]; // 'm' or 'q'
            string action = btnID.Substring(1).Replace("Btn", "");

            if (action == "Return")
            {
                Response.Redirect($"SelectedCoursePage.aspx?CourseID={selectedCourseID}");
            }

            switch (action)
            {
                case "Add":
                    if (section == 'm')
                    {
                        if (selectedLessonID == 0) return;
                        Response.Redirect($"MaterialPage.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}&Mode=Add");
                    }
                    else if (section == 'q')
                    {
                        if (selectedQuizID == 0) return;
                        Response.Redirect($"createQuiz.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}");
                    }
                    break;
                case "Edit":
                    if (section == 'm')
                    {
                        if (selectedMaterialID == 0) return;
                        Response.Redirect($"MaterialPage.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}&Mode=Edit&MaterialID={selectedMaterialID}");
                    }
                    else if (section == 'q')
                    {
                        if (selectedQuizID == 0) return;
                        Response.Redirect($"createQuiz.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}&QuizID={selectedQuizID}");
                    }
                    break;
                case "EditOrder":
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "enableSort", "enableSort();", true);
                    break;
            }
        }

        private void DeleteMaterial(int materialID, SqlConnection conn)
        {
            int contentID = -1;

            // Get images path and delete them
            string getQuery = "SELECT Description FROM MaterialContent WHERE MaterialID = @MaterialID";
            SqlCommand getCmd = new SqlCommand(getQuery, conn);
            getCmd.Parameters.AddWithValue("@MaterialID", materialID);
            string html = getCmd.ExecuteScalar().ToString();

            var matches = System.Text.RegularExpressions.Regex.Matches(html, @"src=""(/Images/[^""]+)""");
            foreach (System.Text.RegularExpressions.Match match in matches)
            {
                string imagePath = Server.MapPath(match.Groups[1].Value);
                if (File.Exists(imagePath)) File.Delete(imagePath);
            }

            // Delete flashcard images and records
            string getCardsQuery = "SELECT FrontImage FROM Flashcard WHERE MaterialID = @MaterialID";
            using (SqlCommand getCardsCmd = new SqlCommand(getCardsQuery, conn))
            {
                getCardsCmd.Parameters.AddWithValue("@MaterialID", materialID);
                using (SqlDataReader cardReader = getCardsCmd.ExecuteReader())
                {
                    while (cardReader.Read())
                    {
                        string imgFile = cardReader["FrontImage"].ToString();
                        if (!string.IsNullOrEmpty(imgFile))
                        {
                            string fullPath = Server.MapPath(imgFile);
                            if (File.Exists(fullPath)) File.Delete(fullPath);
                        }
                    }
                }
            }

            string deleteCardStr = "DELETE FROM FlashCard WHERE MaterialID = @MaterialID";
            using (SqlCommand delCardCmd = new SqlCommand(deleteCardStr, conn))
            {
                delCardCmd.Parameters.AddWithValue("@MaterialID", materialID);
                delCardCmd.ExecuteNonQuery();
            }

            string join = @"SELECT m.ContentID FROM MaterialContent m 
                    JOIN Content c ON m.ContentID = c.ContentID
                    WHERE m.MaterialID = @MaterialID";
            using (SqlCommand cmd = new SqlCommand(join, conn))
            {
                cmd.Parameters.AddWithValue("@MaterialID", materialID);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read()) contentID = Convert.ToInt32(reader["ContentID"]);
                }
            }

            // Delete from material Content
            if (contentID > -1)
            {
                string deleteStr = @"DELETE FROM MaterialContent WHERE MaterialID = @MaterialID;
                             DELETE FROM Content WHERE ContentID = @ContentID;";
                using (SqlCommand delCmd = new SqlCommand(deleteStr, conn))
                {
                    delCmd.Parameters.AddWithValue("@MaterialID", materialID);
                    delCmd.Parameters.AddWithValue("@ContentID", contentID);
                    delCmd.ExecuteNonQuery();
                }
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
        private void LoadContent(int lessonID, string type)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // Load materials
                if (type == "material")
                {
                    string materialQuery = @"SELECT m.MaterialID, m.Name FROM Content c 
                                            JOIN MaterialContent m ON c.ContentID = m.ContentID 
                                            WHERE c.LessonID = @LessonID AND c.Type = 'Material'
                                            ORDER BY c.Position";
                    SqlDataAdapter materialAdapter = new SqlDataAdapter(materialQuery, conn);
                    materialAdapter.SelectCommand.Parameters.AddWithValue("@LessonID", lessonID);
                    DataTable materialTable = new DataTable();
                    materialAdapter.Fill(materialTable);
                    MaterialRepeater.DataSource = materialTable;
                    MaterialRepeater.DataBind();
                }
                else if (type == "quiz")
                {
                    // Load quizzes
                    string quizQuery = @"SELECT q.QuizID, q.Name FROM Content c 
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
        }
        protected void selectLesson(object source, RepeaterCommandEventArgs e)
        {
            selectedLessonID = int.Parse(e.CommandArgument.ToString());
            selectedMaterialID = 0;
            LoadLessons(selectedCourseID);
            LoadContent(selectedLessonID, selectedType);
        }

        protected void selectMaterial(object source, RepeaterCommandEventArgs e)
        {
            selectedMaterialID = int.Parse(e.CommandArgument.ToString());
            LoadContent(selectedLessonID, selectedType);
        }

        protected void selectQuiz(object source, RepeaterCommandEventArgs e)
        {
            selectedQuizID = int.Parse(e.CommandArgument.ToString());
            LoadContent(selectedLessonID, selectedType);
        }

        protected void saveOrderBtn_Click(object sender, EventArgs e)
        {
            string[] ids = hdnOrder.Value.Split(',');
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                for (int i = 0; i < ids.Length; i++)
                {
                    if (string.IsNullOrEmpty(ids[i])) continue;

                    string query = "UPDATE Content SET Position = @Position WHERE ContentID = (SELECT ContentID FROM MaterialContent WHERE MaterialID = @MaterialID)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Position", i + 1);
                    cmd.Parameters.AddWithValue("@MaterialID", int.Parse(ids[i]));
                    cmd.ExecuteNonQuery();
                }
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideNumbers", "cancelSort();", true);
            LoadContent(selectedLessonID, selectedType);
        }

        protected void confirmLessonBtn_Click(object sender, EventArgs e)
        {
            if (hdnModalMode.Value == "Add")
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    string insert = @"INSERT INTO [Lesson] (CourseID, LessonOrder, LessonName) 
                                   VALUES (@CourseID, (SELECT ISNULL(MAX(LessonOrder), 0) + 1 
                                   FROM Lesson WHERE CourseID = @CourseID), @LessonName)";
                    using (SqlCommand cmd = new SqlCommand(insert, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", selectedCourseID);
                        cmd.Parameters.AddWithValue("LessonName", lessonNameTxt.Text.Trim());
                        cmd.ExecuteNonQuery();
                    }
                }
                lessonNameTxt.Text = "";
                LoadLessons(selectedCourseID);
            }
            else if (hdnModalMode.Value == "DeleteL")
            {
                if (selectedLessonID == 0) return;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    string getAllMaterial = @"SELECT m.MaterialID FROM MaterialContent m 
                                             JOIN Content c ON m.ContentID = c.ContentID 
                                             WHERE c.LessonID = @LessonID";
                    List<int> materialIDs = new List<int>();
                    using (SqlCommand cmd = new SqlCommand(getAllMaterial, conn))
                    {
                        cmd.Parameters.AddWithValue("@LessonID", selectedLessonID);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                                materialIDs.Add(Convert.ToInt32(reader["MaterialID"]));
                        }
                    }
                    foreach (int materialID in materialIDs)
                        DeleteMaterial(materialID, conn);

                    string query = "DELETE FROM Lesson WHERE LessonID = @LessonID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@LessonID", selectedLessonID);
                        cmd.ExecuteNonQuery();
                    }
                }
                selectedLessonID = 0;
            }
            else if (hdnModalMode.Value == "DeleteM")
            {
                if (selectedLessonID == 0) return;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    DeleteMaterial(selectedMaterialID, conn);
                }
                LoadContent(selectedLessonID, selectedType);
                selectedMaterialID = 0;
            }
            else if (hdnModalMode.Value == "DeleteQ")
            {
                if (selectedQuizID == 0) return;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    //Should run DeleteQuiz
                    //DeleteMaterial(selectedMaterialID, conn);
                }
                LoadContent(selectedLessonID, selectedType);
                selectedQuizID = 0;
            }
            LoadLessons(selectedCourseID);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
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
        protected string selectedType
        {
            get { return ViewState["selectedType"] != null ? (string)ViewState["selectedType"] : ""; }
            set { ViewState["selectedType"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                selectedLessonID = int.Parse(Request.QueryString["LessonID"]);
                selectedType = Request.QueryString["type"];
                LoadLessons(1);
                LoadContent(selectedLessonID, selectedType);
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
                Response.Redirect("CoursePage.aspx");
            }

            switch (action)
            {
                case "Add":
                    if (section == 'm')
                    {
                        Response.Redirect("AddMaterialPage.aspx?LessonID=" + selectedLessonID);
                    }
                    else if (section == 'q')
                    {

                    }
                    break;
                case "Edit":
                    if (section == 'm')
                    {
                        Response.Redirect("EditMaterialPage.aspx?LessonID=" + selectedLessonID);
                    }
                    else if (section == 'q')
                    {

                    }
                    break;
                case "Delete":
                    int materialID = -1;
                    int contentID = -1;

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        conn.Open();

                        string join = @"SELECT m.MaterialID, m.ContentID
                                        FROM MaterialContent m 
                                        JOIN Content c ON m.ContentID = c.ContentID
                                        WHERE m.MaterialID = @MaterialID";
                        using (SqlCommand cmd = new SqlCommand(join, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaterialID", selectedMaterialID);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    materialID = Convert.ToInt32(reader["MaterialID"]);
                                    contentID = Convert.ToInt32(reader["ContentID"]);
                                }
                            }
                        }

                        if (materialID > -1 && contentID > -1)
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

                LoadContent(selectedLessonID, selectedType);
                break;
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
                    string quizQuery = @"SELECT q.Name FROM Content c 
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
            LoadLessons(1); // placeholder
            LoadContent(selectedLessonID, selectedType);
        }

        protected void selectMaterial(object source, RepeaterCommandEventArgs e)
        {
            selectedMaterialID = int.Parse(e.CommandArgument.ToString());
            LoadContent(selectedLessonID, selectedType);
        }
    }
}
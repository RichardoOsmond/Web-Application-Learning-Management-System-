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
    public partial class ViewMaterial : System.Web.UI.Page
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
        protected int selectedCourseID
        {
            get { return ViewState["selectedCourseID"] != null ? (int)ViewState["selectedCourseID"] : -1; }
            set { ViewState["selectedCourseID"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                selectedMaterialID = int.Parse(Request.QueryString["MaterialID"]);
                selectedLessonID = int.Parse(Request.QueryString["LessonID"]);
                selectedCourseID = int.Parse(Request.QueryString["CourseID"]);

                List<Notifications> notifications = DataServices.getNotifications(Convert.ToInt32(Session["UserID"]));
                Master.bindNotifications(notifications);

                if (Session["RoleName"].ToString() == "Student")
                {
                    Student currStudent = DataServices.getStudentByUserID(Convert.ToInt32(Session["UserID"]));
                    List<ChatMessages> chatMessages = currStudent.getChatMessages();
                    Master.bindChatMessages(chatMessages);
                }

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string query = "SELECT Name, Description FROM MaterialContent WHERE MaterialID = @MaterialID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaterialID", selectedMaterialID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblName.Text = reader["Name"].ToString();
                            backText.Text = reader["Description"].ToString();
                        }
                    }
                    string flashQuery = "SELECT FrontImage, BackText FROM Flashcard WHERE MaterialID = @MaterialID ORDER BY CardOrder";
                    using (SqlDataAdapter flashAdapter = new SqlDataAdapter(flashQuery, conn))
                    {
                        flashAdapter.SelectCommand.Parameters.AddWithValue("@MaterialID", selectedMaterialID);
                        DataTable flashTable = new DataTable();
                        flashAdapter.Fill(flashTable);
                        FlashcardRepeater.DataSource = flashTable;
                        FlashcardRepeater.DataBind();
                    }
                }
            }
        }

        protected void returnBtn_Click(object sender, EventArgs e)
        {
            Response.Redirect($"SelectedCoursePage.aspx?CourseID={selectedCourseID}&LessonID={selectedLessonID}");
        }
    }
}
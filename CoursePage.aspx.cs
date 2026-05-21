using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class CoursePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        private void LoadLessons()
        {
            string connString = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT l.LessonName, m.Name, m.Description FROM Lesson l JOIN Content c ON l.LessonID = c.LessonID JOIN MaterialContent m ON c.ContentID = m.ContentID WHERE l.CourseID = 1";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    // we'll bind this to the panel next
                }
            }
        }
    }
}
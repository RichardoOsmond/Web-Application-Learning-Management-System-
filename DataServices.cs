using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace Wapping_time
{
    public class DataServices
    {
        private static readonly string conString = System.Configuration.ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        public static User getUserByID(int userID)
        {
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT * FROM User WHERE UserID = @userID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@userID", userID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new User
                            {
                                UserID = (int)reader["UserID"],
                                RoleID = (int)reader["RoleID"],
                                Username = reader["Username"].ToString(),
                                Email = reader["Email"].ToString(),
                                LastLogin = (DateTime)reader["Last Login"],
                                LastLogout = (DateTime)reader["Last Logout"]
                            };
                        }
                    }
                }
            }
            return null;
        }
        public static Student getStudentByUserID(int userID)
        {
            User user = getUserByID(userID);
            if (user == null) { return null; }
            Student student = new Student(getEnrolledCourses(userID), getNotifications(userID), getChatMessages(userID));
            return student;
        }
        public static List<Registration> getEnrolledCourses(int userID)
        {
            List<Registration> registeredCourses = new List<Registration>();
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT c.CourseID, c.UserID as CourseCreatorID, c.CourseName, c.Description, c.CourseCreatedDate, r.RegistrationID, r.UserID, r.Result, r.Progress, r.RegistrationDate " +
                    "FROM Registration r INNER JOIN Course c on c.CourseID = r.CourseID WHERE r.UserID = @UserID ORDER BY c.CourseName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int registrationID = (int)reader["RegistrationID"];
                            int registrationUseriD = (int)reader["UserID"];
                            string result = reader["Result"].ToString();
                            DateTime registrationDate = (DateTime)reader["RegistrationDate"];
                            int progress = (int)reader["Progress"];
                            int courseID = (int)reader["CourseID"];
                            int courseUserID = (int)reader["CourseCreatorID"];
                            string courseName = reader["CourseName"].ToString();
                            string description = reader["Description"].ToString();
                            DateTime courseCreationDate = (DateTime)reader["CourseCreatedDate"];

                            Course course = new Course(courseID, courseUserID, courseName, description, courseCreationDate);
                            Registration registration = new Registration(registrationID, registrationUseriD, result, progress, course, registrationDate);
                            registeredCourses.Add(registration);
                        }
                    }
                }
            }
            return registeredCourses;
        }
        public static List<Notifications> getNotifications(int userID)
        {
            List<Notifications> notifications = new List<Notifications>();
            return notifications;
        }
        public static List<ChatMessages> getChatMessages(int userID)
        {
            List<ChatMessages> chatMessages = new List<ChatMessages>();
            return chatMessages;
        }
    }
}
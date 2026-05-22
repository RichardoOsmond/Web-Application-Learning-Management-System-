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

        public static User getUserByID(int UserID)
        {
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT * FROM [User] WHERE [UserID] = @userID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@userID", UserID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int userID = (int)reader["UserID"];
                            int roleID = (int)reader["RoleID"];
                            string username = reader["Username"].ToString();
                            string email = reader["Email"].ToString();
                            DateTime lastLogin = (DateTime)reader["Last Login"];
                            DateTime lastLogout = (DateTime)reader["Last Logout"];
                            string aboutMe = reader["AboutMe"] == DBNull.Value ? null : reader["AboutMe"].ToString();
                            return new User(userID, roleID, username, email, lastLogin, lastLogout, aboutMe);
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
            Student student = new Student(user.UserID, user.RoleID, user.Username, user.Email, user.LastLogin, user.LastLogout, user.AboutMe, getEnrolledCourses(userID), getNotifications(userID), getChatMessages(userID));
            return student;
        }
        public static List<Registration> getEnrolledCourses(int userID)
        {
            List<Registration> registeredCourses = new List<Registration>();
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT c.CourseID, c.UserID as CourseCreatorID, c.CourseName, c.Description, c.CourseCreatedDate, r.RegistrationID, r.UserID, r.Result, r.Progress, r.RegistrationDate " +
                    "FROM [Registration] r INNER JOIN [Course] c on c.CourseID = r.CourseID WHERE r.UserID = @UserID ORDER BY c.CourseName";
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
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT * FROM [Notifications] WHERE [UserID] = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int notificationID = (int)reader["NotificationID"];
                            int notifyUserID = (int)reader["UserID"];
                            string title = reader["Title"].ToString();
                            string content = reader["Content"].ToString();
                            DateTime createdTime = (DateTime)reader["CreatedTime"];
                            bool isRead = (bool)reader["IsRead"];
                            Notifications notification = new Notifications(notificationID, notifyUserID, title, content, isRead, createdTime);
                            notifications.Add(notification);
                        }
                    }
                }
            }
            return notifications;
        }
        public static List<ChatMessages> getChatMessages(int userID)
        {
            List<ChatMessages> chatMessages = new List<ChatMessages>();
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT * FROM [ChatMessages] WHERE [ToUserID] = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int chatMessageID = (int)reader["ChatMessageID"];
                            int fromUserID = (int)reader["FromUserID"];
                            int toUserID = (int)reader["ToUserID"];
                            string content = reader["Content"].ToString();
                            DateTime sentTime = (DateTime)reader["SentTime"];
                            bool isRead = (bool)reader["IsRead"];
                            ChatMessages chatMessage = new ChatMessages(chatMessageID, fromUserID, toUserID, content, isRead, sentTime);
                            chatMessages.Add(chatMessage);
                        }
                    }
                }
            }
            return chatMessages;
        }
    }
}
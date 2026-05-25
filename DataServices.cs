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
                            string aboutMe = reader["About Me"] == DBNull.Value ? null : reader["About Me"].ToString();
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
                string query = "SELECT c.CourseID, c.UserID as CourseCreatorID, c.CourseImage, c.CourseName, c.Description, c.CourseCategory, c.CourseCreatedDate, r.RegistrationID, r.UserID, r.Result, r.Progress, r.RegistrationDate, u.Username " +
                    "FROM [Registration] r INNER JOIN [Course] c on c.CourseID = r.CourseID INNER JOIN [User] u on c.UserID = u.UserID WHERE r.UserID = @UserID ORDER BY c.CourseName";
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
                            string imageName = reader["CourseImage"].ToString();
                            string description = reader["Description"].ToString();
                            string courseCategory = reader["CourseCategory"].ToString();
                            string courseCreatorName = reader["Username"].ToString();
                            DateTime courseCreationDate = (DateTime)reader["CourseCreatedDate"];

                            Course course = new Course(courseID, courseUserID, courseName, description, courseCategory, imageName, courseCreationDate);
                            course.setCreatorName(courseCreatorName);
                            Registration registration = new Registration(registrationID, registrationUseriD, result, progress, course, registrationDate);
                            registeredCourses.Add(registration);
                        }
                    }
                }
            }
            return registeredCourses;
        }

        public static void createNewChatMessage(int fromUserID, int toUserID, string content, DateTime sentTime, string senderName)
        {
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "INSERT INTO [ChatMessages] " +
                    "([FromUserID], [ToUserID], [Content], [SentTime], [IsRead]) " +
                    "values " +
                    "(@FromUserID,@ToUserID,@Content,@SentTime,0);";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                    cmd.Parameters.AddWithValue("@ToUserID", toUserID);
                    cmd.Parameters.AddWithValue("@Content", content);
                    cmd.Parameters.AddWithValue("@SentTime", sentTime);
                    cmd.ExecuteNonQuery();
                }
            }
            string notificationTitle = "A new chat message!";
            string notificationContent = "You have a new message from " + senderName;
            createNewNotifications(toUserID, notificationTitle, notificationContent, sentTime);
        }
        public static void createNewNotifications(int userID, string title, string content, DateTime createdTime)
        {
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "INSERT INTO [Notifications] " +
                    "([UserID], [Title], [Content], [CreatedTime], [IsRead]) " +
                    "values " +
                    "(@UserID, @Title, @Content, @CreatedTime, 0);";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Content", content);
                    cmd.Parameters.AddWithValue("@CreatedTime", createdTime);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        public static List<Course> loadAllCreatedCourse(int loggedInUser)
        {
            List<Course> listOfCourses = new List<Course>();
            String query = "Select * FROM [Course] where [UserID] = @UserID";

            //establish connection
            using (SqlConnection conn = new SqlConnection(conString)) 
            {
                conn.Open();
                //using command
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", loggedInUser);
                    //read the result
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int courseID = (int)reader["CourseID"];
                            int userID = (int)reader["UserID"];
                            String courseName = reader["CourseName"].ToString();
                            String description = reader["Description"].ToString();
                            string courseCategory = reader["CourseCategory"].ToString();
                            String imageUrl = reader["CourseImage"].ToString();
                            DateTime courseCreatedDate = (DateTime)reader["CourseCreatedDate"];

                            Course course = new Course(courseID, loggedInUser, courseName, description, courseCategory, imageUrl, courseCreatedDate);
                            listOfCourses.Add(course);
                        }
                    }
                }
            }

            return listOfCourses;
        }
        public static List<User> getAllStudents()
        {
            List<User> users = new List<User>();
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "Select [UserID], [RoleID], [Username], [Email], [LastLogin], [LastLogout], [AboutMe] FROM [User] WHERE [RoleID] = 1;";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int userID = (int)reader["UserID"];
                            int roleID = (int)reader["RoleID"];
                            string username = reader["Username"].ToString();
                            string email = reader["Email"].ToString();
                            DateTime lastLogin = (DateTime)reader["LastLogin"];
                            DateTime lastLogout = (DateTime)reader["LastLogout"];
                            string aboutMe = reader["AboutMe"].ToString();
                            User user = new User(userID, roleID, username, email, lastLogin, lastLogout, aboutMe);
                            users.Add(user);
                        }
                    }
                }
            }
            return users;
        }
        public static List<ChatMessages> getConversations(int fromUserID, int toUserID)
        {
            List<ChatMessages> conversations = new List<ChatMessages>();
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string query = "SELECT c.ChatMessageID, c.FromUserID, c.ToUserID, c.Content, c.IsRead, c.SentTime, u.Username " +
                    "FROM [ChatMessages] c INNER JOIN [User] u ON m.FromUserID = u.UserID WHERE m.FromUserID = @FromUserID AND m.ToUserID = @ToUserID;";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                    cmd.Parameters.AddWithValue("@ToUserID", toUserID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int chatMessageID = (int)reader["ChatMessageID"];
                            fromUserID = (int)reader["FromUserID"];
                            toUserID = (int)reader["ToUserID"];
                            string content = reader["Content"].ToString();
                            bool isRead = (bool)reader["IsRead"];
                            DateTime sentTime = (DateTime)reader["SentTime"];
                            string username = reader["Username"].ToString();
                            ChatMessages chatmessage = new ChatMessages(chatMessageID, fromUserID, toUserID, content, isRead, username, sentTime);
                            conversations.Add(chatmessage);
                        }
                    }
                }
            }
            return conversations;
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
                string query = "SELECT c.ChatMessageID, c.FromUserID, c.ToUserID, c.Content, c.SentTime, c.IsRead, u.Username FROM [ChatMessages] c INNER JOIN [User] u on c.FromUserID = u.UserID WHERE c.ToUserID = @UserID";
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
                            string username = reader["Username"].ToString();
                            ChatMessages chatMessage = new ChatMessages(chatMessageID, fromUserID, toUserID, content, isRead, username, sentTime);
                            chatMessages.Add(chatMessage);
                        }
                    }
                }
            }
            return chatMessages;
        }
    }
}
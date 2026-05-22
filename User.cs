using System;

namespace Wapping_time
{
    public class User
    {
        public int UserID { get; protected set; }
        public int RoleID { get; protected set; }
        public string Username { get; protected set; }
        public string Email { get; protected set; }
        public DateTime LastLogin { get; protected set; }
        public DateTime LastLogout { get; protected set; }
        public string AboutMe { get; protected set; }

        public User(int userID, int roleID, string username, string email, DateTime lastLogin, DateTime lastLogout, string aboutMe)
        {
            UserID = userID;
            RoleID = roleID;
            Username = username;
            Email = email;
            LastLogin = lastLogin;
            LastLogout = lastLogout;
            AboutMe = aboutMe;
        }
    }
}
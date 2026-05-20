using System;

namespace Wapping_time
{
    public class User
    {
        public int UserID { get; set; }
        public int RoleID { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public DateTime? LastLogin { get; set; }
        public DateTime? LastLogout { get; set; }
        public string AboutMe { get; set; }
    }
}
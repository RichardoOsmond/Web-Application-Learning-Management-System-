using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Student : User
    {
        public int totalCourseCompletion { get; set; }
        public string profileImage { get; set; } // Will probably remove this later, assuming user class have profileImage from the database table
        public List<Course> enrolledCourses { get; set; }
        public List<Notifications> notifications { get; set; }
        public List<ChatMessages> chatMessages { get; set; }

        public Student()
        {
            enrolledCourses = new List<Course>();
            notifications = new List<Notifications>();
            chatMessages = new List<ChatMessages>();

            profileImage = "profileImage.png";
        }
    }
}
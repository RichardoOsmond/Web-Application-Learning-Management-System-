using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Student : User
    {
        private int TotalCourseCompletion { get; set; }
        private string ProfileImage { get; set; } // Will probably remove this later, assuming user class have profileImage from the database table
        private List<Registration> EnrolledCourses { get; set; }
        private List<Notifications> Notifications { get; set; }
        private List<ChatMessages> ChatMessages { get; set; }

        public Student(int userID, int roleID, string username, string email, DateTime lastLogin, DateTime lastLogout, string aboutMe,
            List<Registration> registrations, List<Notifications> notifications, List<ChatMessages> chatMessages)
            : base(userID, roleID, username, email, lastLogin, lastLogout, aboutMe)
        {
            EnrolledCourses = registrations;
            Notifications = notifications;
            ChatMessages = chatMessages;

            ProfileImage = "profileImage.png";
            TotalCourseCompletion = calculateTotalCourseCompletion(EnrolledCourses);
        }
        private int calculateTotalCourseCompletion(List<Registration> registrations)
        {
            int sumProgress = 0;
            foreach (Registration registration in registrations)
            {
                sumProgress += registration.getProgress();
            }
            return (sumProgress / registrations.Count);
        }
        public int getTotalCourseCompletion()
        {
            return TotalCourseCompletion;
        }
    }
}
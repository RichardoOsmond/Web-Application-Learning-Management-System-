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

        public Student(List<Registration> registrations, List<Notifications> notifications, List<ChatMessages> chatMessages)
        {
            EnrolledCourses = registrations;
            Notifications = notifications;
            ChatMessages = chatMessages;

            ProfileImage = "profileImage.png";
        }
        private int calculateTotalCourseCompletion(List<Registration> registrations)
        {
            int sumProgress = 0;
            foreach (Registration registration in registrations)
            {
                sumProgress += registration.getProgress();
            }
            return sumProgress;
        }
    }
}
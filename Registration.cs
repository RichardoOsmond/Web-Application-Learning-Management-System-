using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Registration
    {
        private int RegistrationID;
        private int UserID;
        private string Result;
        private DateTime RegistrationDate;
        private int Progress = 0;
        private Course Course;

        // Constructor for new registrations
        public Registration(int registrationID, int userID, string result, Course course)
        {
            RegistrationID = registrationID;
            UserID = userID;
            Result = result;
            Course = course;
        }

        // Constructor for old registrations
        public Registration(int registrationID, int userID, string result, int progress, Course course, DateTime registrationDate)
        {
            RegistrationID = registrationID;
            UserID = userID;
            Result = result;
            RegistrationDate = registrationDate;
            Progress = progress;
            Course = course;
        }
        public int getProgress()
        {
            return Progress;
        }
    }
}
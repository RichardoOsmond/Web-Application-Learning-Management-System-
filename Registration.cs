using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Registration
    {
        public int RegistrationID { get; private set; }
        public int UserID { get; private set; }
        public string Result { get; private set; }
        public DateTime RegistrationDate { get; private set; }
        public int Progress {get; private set; }
        public Course Course { get; private set; }

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
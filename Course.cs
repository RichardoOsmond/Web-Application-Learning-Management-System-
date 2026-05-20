using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Course
    {
        private int CourseID { get; set; }
        private int UserID { get; set; }
        private string CourseName { get; set; }
        private string Description { get; set; }
        private DateTime CourseCreatedDate { get; set; }

        public Course(int courseID, int userID, string courseName, string description)
        {
            CourseID = courseID;
            UserID = userID;
            CourseName = courseName;
            Description = description;
        }
        public Course(int courseID, int userID, string courseName, string description, DateTime courseCreatedDate)
        {
            CourseID = courseID;
            UserID = userID;
            CourseName = courseName;
            Description = description;
            CourseCreatedDate = courseCreatedDate;
        }
    }
}
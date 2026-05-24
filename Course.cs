using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Course
    {
        public int CourseID { get; private set; }
        public int UserID { get; private set; }
        public string CourseName { get; private set; }
        public string ImageName { get; private set; }
        public string Description { get; private set; }
        public DateTime CourseCreatedDate { get; private set; }
        public string CreatorName { get; private set; }
        public string CourseCategory { get; private set; }

        public Course(int courseID, int userID, string courseName, string description, string courseCategory, string imageName)
        {
            CourseID = courseID;
            UserID = userID;
            CourseName = courseName;
            ImageName = imageName;
            Description = description;
            CourseCategory = courseCategory;
        }
        public Course(int courseID, int userID, string courseName, string description, string courseCategory, string imageName, DateTime courseCreatedDate)
        {
            CourseID = courseID;
            UserID = userID;
            CourseName = courseName;
            ImageName = imageName;
            Description = description;
            CourseCreatedDate = courseCreatedDate;
            CourseCategory = courseCategory;
        }
        public void setCreatorName(string username)
        {
            CreatorName = username;
        }
    }
}
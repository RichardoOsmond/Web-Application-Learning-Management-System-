using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class StudentCourse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userID = (int)Session["UserID"];
                List<Registration> registrations = DataServices.getEnrolledCourses(userID);
                rptEnrolledCourses.DataSource = registrations;
                rptEnrolledCourses.DataBind();

                Student currStudent = DataServices.getStudentByUserID(userID);
                Master.bindNotifications(currStudent.getNotifications());
                Master.bindChatMessages(currStudent.getChatMessages());
            }
        }
    }
}
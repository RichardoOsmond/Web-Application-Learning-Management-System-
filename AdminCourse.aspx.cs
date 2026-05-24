using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class AdminCourse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int userID = (int)Session["UserID"];
            List<Course> listCreatedCourses = DataServices.loadAllCreatedCourse(userID);
            rptCreatedCourses.DataSource = listCreatedCourses;
            rptCreatedCourses.DataBind();
        }
    }
}
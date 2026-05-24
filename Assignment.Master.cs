using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class Assignment : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            if (Session["RoleName"].ToString() == "Student")
            {
                Response.Redirect("StudentDashboard.aspx");
            } else
            {
                Response.Redirect("DashboardWithAdmin.aspx");
            }
        }
        protected void btnCourse_Click(object sender, EventArgs e)
        {
            if (Session["RoleName"].ToString() == "Student")
            {
                Response.Redirect("StudentCourse.aspx");
            } else
            {
                Response.Redirect("AdminCourse.aspx");
            }
        }
    }
}
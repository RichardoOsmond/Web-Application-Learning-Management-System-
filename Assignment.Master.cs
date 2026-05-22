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
            if ((int)Session["RoleID"] == 1)
            {
                Response.Redirect("StudentDashboard.aspx");
                Console.WriteLine("Hello");
            } else
            {
                Response.Redirect("StudentDashboard.aspx");
                Console.WriteLine("Hi");
            }
        }
        protected void btnCourse_Click(object sender, EventArgs e)
        {
            if ((int)Session["RoleID"] == 1)
            {
                Response.Redirect("StudentCourse.aspx");
                Console.WriteLine("Hello");
            } else
            {
                Response.Redirect("StudentCourse.aspx");
                Console.WriteLine("Hi");
            }
        }
    }
}
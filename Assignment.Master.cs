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
            string roleName = Session["RoleName"].ToString();
            chatPanel.Visible = (roleName == "Student");
        }
        public void bindNotifications(List<Notifications> notifications)
        {
            rptNotifications.DataSource = notifications;
            rptNotifications.DataBind();
            lblNoNotifications.Visible = (notifications == null || notifications.Count == 0);
        }
        public void bindChatMessages(List<ChatMessages> chatMessages)
        {
            rptStudentChatMessages.DataSource = chatMessages;
            rptStudentChatMessages.DataBind();
            lblNoChatMessages.Visible = (chatMessages == null || chatMessages.Count == 0);
        }
        protected void btnDashboard_Click(object sender, EventArgs e)
        {
            if (Session["RoleName"].ToString() == "Student")
            {
                Response.Redirect("StudentDashboard.aspx");
            } else
            {
                Response.Redirect("DashboardWithAdmin.aspx");
                Console.WriteLine("Hi");
            }
        }
        protected void btnCourse_Click(object sender, EventArgs e)
        {
            if (Session["RoleName"].ToString() == "Student")
            {
                Response.Redirect("StudentCourse.aspx");
            } else
            {
                Response.Redirect("Courses.aspx");
                Console.WriteLine("Hi");
            }
        }
        protected string getUserRole()
        {
            return Session["RoleName"] != null ? Session["RoleName"].ToString() : "";
        }
    }
}
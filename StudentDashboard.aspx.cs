using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        private Student currStudent;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userID = (int)Session["UserID"];
                currStudent = DataServices.getStudentByUserID(userID);
                List<Notifications> notifications = currStudent.getNotifications();
                rptNotifications.DataSource = notifications;
                rptNotifications.DataBind();
                lblNoNotifications.Visible = (notifications.Count == 0);
                List<ChatMessages> chatMessages = currStudent.getChatMessages();
                rptStudentChatMessages.DataSource = chatMessages;
                rptStudentChatMessages.DataBind();
                lblNoChatMessages.Visible = (chatMessages.Count == 0);
                List<Registration> enrolledCourses = currStudent.getEnrolledCourses();
                rptCourses.DataSource = enrolledCourses;
                rptCourses.DataBind();
                renderDashboard();
            }
        }
        private void renderDashboard()
        {
            if (currStudent == null) { return; }

            // Assuming the inherited user class named the name field as name
            //lblName.Text = "Welcome, " + currStudent.name + "!";
            loadProgressBar();
        }
        private void loadProgressBar()
        {
            if (currStudent == null) { return; }
            int totalCourseCompRate = currStudent.getTotalCourseCompletion();

            // Don't mind me, generated these encouragement messages using ChatGPT
            // Shows different messages based on student's total course progression
            if (totalCourseCompRate >= 0 && totalCourseCompRate < 10)
            {
                lblProgress.Text = "Every expert starts somewhere. Your journey has just begun!";
            }
            else if (totalCourseCompRate > 10 && totalCourseCompRate <= 20)
            {
                lblProgress.Text = "Great start! The first step is always the hardest.";
            }
            else if (totalCourseCompRate > 20 && totalCourseCompRate <= 30)
            {
                lblProgress.Text = "You're building momentum. Keep going!";
            }
            else if (totalCourseCompRate > 30 && totalCourseCompRate <= 40)
            {
                lblProgress.Text = "Nice progress! Consistency beats speed.";
            }
            else if (totalCourseCompRate > 40 && totalCourseCompRate <= 50)
            {
                lblProgress.Text = "You're getting closer than you think. Stay focused!";
            }
            else if (totalCourseCompRate > 50 && totalCourseCompRate <= 60)
            {
                lblProgress.Text = "Halfway there! Your efforts is paying off.";
            }
            else if (totalCourseCompRate > 60 && totalCourseCompRate <= 70)
            {
                lblProgress.Text = "Amazing work! You've crossed the toughest part.";
            }
            else if (totalCourseCompRate > 70 && totalCourseCompRate <= 80)
            {
                lblProgress.Text = "You're in the final stretch. Keep pushing forward!";
            }
            else if (totalCourseCompRate > 80 && totalCourseCompRate <= 90)
            {
                lblProgress.Text = "So close to the finish line. Don't slow down now!";
            }
            else if (totalCourseCompRate > 90 && totalCourseCompRate <= 99)
            {
                lblProgress.Text = "Outstanding dedication! One final push remains.";
            }
            else if (totalCourseCompRate == 100)
            {
                lblProgress.Text = "Congratulations! You've successfully completed all your courses!";
            }

            // Filling the inner progress bar against the outer progress bar
            pnlProgressInner.Style["width"] = totalCourseCompRate + "%";
            lblCompletionRate.Text = totalCourseCompRate + "% Complete";
        }
    }
}
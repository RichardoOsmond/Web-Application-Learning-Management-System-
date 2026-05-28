using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class AdminChat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadStudents();
                lblNoMessages.Visible = true;
            }
        }
        protected void loadStudents()
        {
            rptStudents.DataSource = DataServices.getAllStudents();
            rptStudents.DataBind();
        }
        protected void SelectedStudent_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            hdnSelectedStudent.Value = btn.CommandArgument;
            loadConversation();
        }
        protected void loadConversation()
        {
            if (string.IsNullOrEmpty(hdnSelectedStudent.Value))
            {
                lblNoMessages.Visible = true;
                return;
            }
            int adminID = (int)Session["UserID"];
            int studentID = int.Parse(hdnSelectedStudent.Value);
            List<ChatMessages> conversation = DataServices.getConversations(adminID, studentID);
            rptConversation.DataSource = conversation;
            rptConversation.DataBind();
            lblNoMessages.Visible = (conversation.Count == 0);
        }
        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMessage.Text)) { return; }
            if (string.IsNullOrEmpty(hdnSelectedStudent.Value)) { return; }

            int adminID = (int)Session["UserID"];
            int studentID = int.Parse(hdnSelectedStudent.Value);
            string content = txtMessage.Text.Trim();
            string senderName = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
            DataServices.createNewChatMessage(adminID, studentID, content, DateTime.Now, senderName);

            txtMessage.Text = "";
            loadConversation();
        }
        protected bool IsFromAdmin(object fromUserID)
        {
            int adminID = (int)Session["UserID"];
            return (int)fromUserID == adminID;
        }
    }
}
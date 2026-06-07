using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace Wapping_time
{
    public partial class profile : Page
    {
        private readonly string connStr =
            System.Configuration.ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        private int CurrentUserID => Convert.ToInt32(Session["UserID"]);


        protected void Page_Load(object sender, EventArgs e)
        {
            //not logged
            if (Session["UserID"] == null)
                Response.Redirect("login.aspx");

            if (!IsPostBack)
            {
                if (Session["RoleName"].ToString() == "Student")
                {
                    Student currStudent = DataServices.getStudentByUserID((int)Session["UserID"]);
                    List<ChatMessages> chatMessages = currStudent.getChatMessages();
                    Master.bindChatMessages(chatMessages);
                }
                List<Notifications> notifications = DataServices.getNotifications(Convert.ToInt32(Session["UserID"]));
                Master.bindNotifications(notifications);

                LoadProfile();
                getGrades();
            }
        }

        //load current profile data
        private void LoadProfile()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT Username, Email, [About Me] FROM [User] WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string username = reader["Username"].ToString();
                                string email = reader["Email"].ToString();
                                string about = reader["About Me"] == DBNull.Value ? "" : reader["About Me"].ToString();


                                litName.Text = username;
                                litEmail.Text = email;

 
                                txtUsername.Text = username;
                                txtEmail.Text = email;
                                txtAbout.Text = about;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, false);
            }
        }

        //save btn
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            bool ok = true;

            ok &= updateUsername(txtUsername.Text.Trim());
            ok &= updateEmail(txtEmail.Text.Trim());

            //only update pswrd if user type
            if (!string.IsNullOrWhiteSpace(txtPassword.Text))
                ok &= updatePassword(txtPassword.Text.Trim());

            updateAbout(txtAbout.Text.Trim());

            if (ok)
            {
                //refresh after save
                litName.Text = txtUsername.Text.Trim();
                litEmail.Text = txtEmail.Text.Trim();
                Session["Username"] = txtUsername.Text.Trim();
                ShowMessage("✓ Profile updated successfully!", true);
            }
        }

        //update username
        private bool updateUsername(string newUsername)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE [User] SET Username = @Username WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", newUsername);
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating username: " + ex.Message, false);
                return false;
            }
        }

        //update email
        private bool updateEmail(string newEmail)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    //check similar email
                    string checkSql = "SELECT COUNT(*) FROM [User] WHERE Email = @Email AND UserID <> @UserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", newEmail);
                        checkCmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        int taken = (int)checkCmd.ExecuteScalar();
                        if (taken > 0)
                        {
                            ShowMessage("That email is already used by another account.", false);
                            return false;
                        }
                    }

                    string updateSql = "UPDATE [User] SET Email = @Email WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", newEmail);
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        if (conn.State != ConnectionState.Open) conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                Session["Email"] = newEmail;
                return true;
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating email: " + ex.Message, false);
                return false;
            }
        }

        //update pswd
        private bool updatePassword(string newPassword)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE [User] SET Password = @Password WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", newPassword);
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating password: " + ex.Message, false);
                return false;
            }
        }

        //update about
        private void updateAbout(string about)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE [User] SET [About Me] = @About WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@About", about);
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch {}
        }

        //get grades
        private void getGrades()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                 
                    string sql = @"
                        SELECT c.CourseName, e.Grade
                        FROM   Enrollment e
                        INNER JOIN Course c ON e.CourseID = c.CourseID
                        WHERE  e.UserID = @UserID
                        ORDER  BY c.CourseName";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                        conn.Open();

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            //build html table for popup
                            StringBuilder sb = new StringBuilder();
                            sb.Append("<table>");
                            foreach (DataRow row in dt.Rows)
                            {
                                sb.Append("<tr>");
                                sb.AppendFormat("<td>{0}</td>", row["CourseName"]);
                                sb.AppendFormat("<td>{0}%</td>", row["Grade"]);
                                sb.Append("</tr>");
                            }
                            sb.Append("</table>");
                            litGrades.Text = sb.ToString();
                        }
                        else
                        {
                            litGrades.Text = "<div class='no-grades-msg'>No grades yet.</div>";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                litGrades.Text = "<div class='no-grades-msg'>Could not load grades: " + ex.Message + "</div>";
            }
        }

        // helper
        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = success ? "msg msg-success" : "msg msg-error";
            lblMessage.Visible = true;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
    }
}

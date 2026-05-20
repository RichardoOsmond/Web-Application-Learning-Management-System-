using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Wapping_time
{
    public partial class forgotPassword : Page
    {
        private readonly string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            bool found = CheckEmailExists(email);

            if (found)
            {
                Session["ResetEmail"] = email;
                pnlStep1.Visible = false;
                pnlStep2.Visible = true;
            }
            else
            {
                lblStep1Msg.Text = "No account found with that email address.";
                lblStep1Msg.Visible = true;
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (Session["ResetEmail"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            string email = Session["ResetEmail"].ToString();
            string newPassword = txtNewPassword.Text.Trim();

            bool success = ExecutePasswordReset(email, newPassword);

            if (success)
            {
                Session.Remove("ResetEmail");
                lblStep2Msg.Text = "✓ Password reset successful! Redirecting to login...";
                lblStep2Msg.CssClass = "msg-area msg-success";
                lblStep2Msg.Visible = true;
                btnReset.Enabled = false;

                Response.AddHeader("Refresh", "2;url=login.aspx");
            }
        }

        private bool CheckEmailExists(string email)
        {
            bool exists = false;
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT COUNT(*) FROM [User] WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        conn.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        if (count > 0) exists = true;
                    }
                }
            }
            catch (Exception ex)
            {
                lblStep1Msg.Text = "Database error: " + ex.Message;
                lblStep1Msg.Visible = true;
            }
            return exists;
        }

        private bool ExecutePasswordReset(string email, string newPassword)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE [User] SET Password = @Password WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", newPassword);
                        cmd.Parameters.AddWithValue("@Email", email);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                lblStep2Msg.Text = "Database error: " + ex.Message;
                lblStep2Msg.CssClass = "msg-area msg-error";
                lblStep2Msg.Visible = true;
                return false;
            }
        }
    }
}
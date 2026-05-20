using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Wapping_time
{
    public partial class setUsername : Page
    {
        private readonly string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("register.aspx");
        }

        protected void btnEnter_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            int userId = Convert.ToInt32(Session["UserID"]);

            bool success = ExecuteUpdateUsername(userId, username);

            if (success)
            {
                Session["Username"] = username;
                Response.Redirect("StudentDashboard.aspx");
            }
        }

        private bool ExecuteUpdateUsername(int userId, string username)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string checkSql = "SELECT COUNT(*) FROM [User] WHERE Username = @Username";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Username", username);
                        conn.Open();
                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (exists > 0)
                        {
                            lblMessage.Text = "Username already taken. Please choose another.";
                            lblMessage.Visible = true;
                            return false;
                        }
                    }

                    string sql = "UPDATE [User] SET Username = @Username WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Database error: " + ex.Message;
                lblMessage.Visible = true;
                return false;
            }
        }
    }
}
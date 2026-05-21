using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Wapping_time
{
    public partial class login : Page
    {
        private readonly string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserID"] != null)
                Response.Redirect("StudentDashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            int userId = ExecuteLoginCheck(email, password);

            if (userId > 0)
            {
                Session["UserID"] = userId;
                Session["Email"]  = email;
                GetRoleName();
                Response.Redirect("StudentDashboard.aspx");
            }
            else
            {
                ShowError("Invalid email or password.");
            }
        }

        private void GetRoleName()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string nameQuery = "SELECT r.RoleName FROM Role r JOIN [User] u ON r.RoleID = u.RoleID WHERE u.UserID = @UserID";
                SqlCommand cmd = new SqlCommand(nameQuery, conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataReader userIDReader = cmd.ExecuteReader();
                if (userIDReader.Read())
                {
                    string roleName = userIDReader["RoleName"].ToString();
                    Session["RoleName"] = roleName;
                }
            }
        }

        private int ExecuteLoginCheck(string email, string password)
        {
            int userId = -1;
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT UserID, Username FROM [User] WHERE Email = @Email AND Password = @Password";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);
                        conn.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                userId = Convert.ToInt32(reader["UserID"]);
                                Session["Username"] = reader["Username"].ToString();
                            }
                        }
                    }
                }
                
                if (userId > 0)
                {
                    UpdateLastLogin(userId);
                }
            }
            catch (Exception ex)
            {
                ShowError("Database error: " + ex.Message);
            }
            return userId;
        }

        private void UpdateLastLogin(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE [User] SET [Last Login] = GETDATE() WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch { }
        }

        private void ShowError(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}
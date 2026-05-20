using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Wapping_time
{
    public partial class register : Page
    {
        private readonly string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserID"] != null)
                Response.Redirect("StudentDashboard.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            bool success = ExecuteUserRegistration(email, password);

            if (success)
            {
                Response.Redirect("setUsername.aspx");
            }
        }

        private bool ExecuteUserRegistration(string email, string password)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string checkSql = "SELECT COUNT(*) FROM [User] WHERE Email = @Email";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (exists > 0)
                        {
                            ShowError("Email address is already registered.");
                            return false;
                        }
                    }

                    //enter getdate
                    string insertSql = @"
                        INSERT INTO [User] (RoleID, Username, Password, Email, [Last Login], [Last Logout])
                        VALUES (@RoleID, @Username, @Password, @Email, GETDATE(), GETDATE());
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@RoleID", 2); // 2 = Student berdasarkan urutan ERD
                        cmd.Parameters.AddWithValue("@Username", "");
                        cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@Email", email);

                        object newId = cmd.ExecuteScalar();
                        Session["UserID"] = Convert.ToInt32(newId);
                        Session["Email"] = email;
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                ShowError("Database error: " + ex.Message);
                return false;
            }
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}
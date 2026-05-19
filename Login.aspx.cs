using System;
using System.Web.UI;

namespace Wapping_time
{
    public partial class login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Menghindari eror database saat kamu sedang fokus mendesain UI
            if (!IsPostBack && Session["UserID"] != null)
            {
                Response.Redirect("dashboard.aspx");
            }
        }

        // Fungsi tombol login yang terhubung langsung dengan tombol 'Enter' di halaman aspx
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Simulasi pengecekan sederhana untuk testing UI halaman dashboard kamu
            if (!string.IsNullOrEmpty(email) && !string.IsNullOrEmpty(password))
            {
                Session["UserID"] = 123;
                Session["Email"] = email;
                Session["Username"] = "Robin"; // Nama otomatis tersimpan di session

                Response.Redirect("dashboard.aspx");
            }
            else
            {
                ShowError("Invalid email or password. Please try again.");
            }
        }

        private void ShowError(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}
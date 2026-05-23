using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class ViewMaterial : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int materialID = int.Parse(Request.QueryString["MaterialID"] ?? "0");

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string query = "SELECT Name, Description FROM MaterialContent WHERE MaterialID = @MaterialID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaterialID", materialID);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblName.Text = reader["Name"].ToString();
                            backText.Text = reader["Description"].ToString();
                        }
                    }
                    string flashQuery = "SELECT FrontImage, BackText FROM Flashcard WHERE MaterialID = @MaterialID ORDER BY CardOrder";
                    using (SqlDataAdapter flashAdapter = new SqlDataAdapter(flashQuery, conn))
                    {
                        flashAdapter.SelectCommand.Parameters.AddWithValue("@MaterialID", materialID);
                        DataTable flashTable = new DataTable();
                        flashAdapter.Fill(flashTable);
                        FlashcardRepeater.DataSource = flashTable;
                        FlashcardRepeater.DataBind();
                    }
                }
            }
        }
    }
}
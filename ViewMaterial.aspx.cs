using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class ViewMaterial : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int materialID = int.Parse(Request.QueryString["MaterialID"] ?? "0");
                string connString = ConfigurationManager.ConnectionStrings["ReadCardDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string query = "SELECT Name, Description FROM MaterialContent WHERE MaterialID = @MaterialID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaterialID", materialID);
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        lblName.Text = reader["Name"].ToString();
                        litContent.Text = reader["Description"].ToString();
                    }
                }
            }
        }
    }
}
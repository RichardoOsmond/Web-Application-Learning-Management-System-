using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Wapping_time
{
    public partial class createQuiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                System.Data.DataTable dt = new System.Data.DataTable();
                dt.Columns.Add("Question");
                dt.Columns.Add("Type");
                dt.Columns.Add("Points");

                dt.Rows.Add("What is 2 + 3?", "MCQ", "5");
                dt.Rows.Add("What is 7 + 11?", "MCQ", "5");
                dt.Rows.Add("Explain addition.", "Essay", "10");

                gvQuestions.DataSource = dt;
                gvQuestions.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
        }
    }

}
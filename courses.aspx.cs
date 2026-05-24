using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ContinueBtn_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string courseID = btn.CommandArgument;

            Response.Redirect("CourseDetails.aspx?CourseID=" + courseID);
        }
    }
}
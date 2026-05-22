using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Wapping_time
{
    public partial class Assignment : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadNotifications();
            }
        }
        private void loadNotifications()
        {
            if (Session["UserID"] == null) { return; }
            int userID = (int)Session["UserID"];
            List<Notifications> notifications = DataServices.getNotifications(userID);

            rptNotifications.DataSource = notifications;
            rptNotifications.DataBind();
            lblNoNotifications.Visible = (notifications.Count == 0);
        }
    }
}
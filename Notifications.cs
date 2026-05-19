using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Notifications
    {
        public int notificationID { get; set; }
        public int userID { get; set; }
        public string title { get; set; }
        public string content { get; set; }
        public DateTime createdTime { get; set; }
        public bool isRead { get; set; }
    }
}
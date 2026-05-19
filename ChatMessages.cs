using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class ChatMessages
    {
        public int messageID { get; set; }
        public int fromUserID { get; set; }
        public int toUserID { get; set; }
        public string content { get; set; }
        public DateTime sentTime { get; set; }
        public bool isRead { get; set; }

        // Function to set dateTime here
    }
}
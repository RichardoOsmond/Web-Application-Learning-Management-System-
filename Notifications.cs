using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Notifications
    {
        private int NotificationID { get; set; }
        private int UserID { get; set; }
        private string Title { get; set; }
        private string Content { get; set; }
        private DateTime CreatedTime { get; set; }
        private bool IsRead { get; set; }

        public Notifications(int notifiactionID, int userID, string title, string content, bool isRead)
        {
            NotificationID = notifiactionID;
            UserID = userID;
            Title = title;
            Content = content;
            IsRead = isRead;
            CreatedTime = setDateTime();
        }
        public Notifications(int notificationID, int userID, string title, string content, bool isRead, DateTime createdTime)
        {
            NotificationID = notificationID;
            UserID = userID;
            Title = title;
            Content = content;
            CreatedTime = createdTime;
            IsRead = isRead;
        }
        private DateTime setDateTime()
        {
            return DateTime.Now;
        }
    }
}
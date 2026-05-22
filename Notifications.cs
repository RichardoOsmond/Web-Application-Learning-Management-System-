using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class Notifications
    {
        public int NotificationID { get; private set; }
        public int UserID { get; private set; }
        public string Title { get; private set; }
        public string Content { get; private set; }
        public DateTime CreatedTime { get; private set; }
        public bool IsRead { get; private set; }

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
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class ChatMessages
    {
        private int ChatMessageID { get; set; }
        private int FromUserID { get; set; }
        private int ToUserID { get; set; }
        private string Content { get; set; }
        private DateTime SentTime { get; set; }
        private bool IsRead { get; set; }

        // Function to set dateTime here
        public ChatMessages(int chatMessageID, int fromUserID, int toUserID, string content, bool isRead)
        {
            ChatMessageID = chatMessageID;
            FromUserID = fromUserID;
            ToUserID = toUserID;
            Content = content;
            IsRead = isRead;
            SentTime = setDateTime(); // Must Format To String Before Use
        }
        public ChatMessages(int chatMessageID, int fromUserID, int toUserID, string content, bool isRead, DateTime sentTime)
        {
            ChatMessageID = chatMessageID;
            FromUserID = fromUserID;
            ToUserID = toUserID;
            Content = content;
            SentTime = sentTime;
            IsRead = isRead;
        }
        private DateTime setDateTime()
        {
            return DateTime.Now;
        }
    }
}
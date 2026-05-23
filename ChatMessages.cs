using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Wapping_time
{
    public class ChatMessages
    {
        public int ChatMessageID { get; private set; }
        public int FromUserID { get; private set; }
        public int ToUserID { get; private set; }
        public string Content { get; private set; }
        public DateTime SentTime { get; private set; }
        public bool IsRead { get; private set; }
        public string SenderName { get; private set; }

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
        public void setSenderName(string username)
        {
            SenderName = username;
        }
    }
}
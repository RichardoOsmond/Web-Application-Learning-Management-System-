<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="AdminChat.aspx.cs" Inherits="Wapping_time.AdminChat" %>
<%@ MasterType VirtualPath="~/Assignment.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/AdminChat.css") %>" />
    <script src='<%= ResolveUrl ("~/Scripts/AdminChat.js") %>'></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=search" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="chat_container">
        <div class="student_panel">
            <div class="search_container">
                <span class="material-symbols-outlined">search</span>
                <input class="search_text" type="search" placeholder="Search Students..." id="studentSearchBar" />
            </div>
            <div class="student_list" id="studentList">
                <asp:Repeater ID="rptStudents" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CssClass="student_item" CommandArgument='<%# Eval("UserID") %>' OnClick="SelectedStudent_Click">
                            <span class="student_name"><%# Eval("Username") %></span>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <div class="chat_panel">
            <div class="message_container" id="messageContainer">
                <asp:Repeater ID="rptConversation" runat="server">
                    <ItemTemplate>
                        <div class='<%# IsFromAdmin(Eval("FromUserID")) ? "chat_bubble sent" : "chat_bubble received" %>'>
                            <span class="chat_bubble_sender"><%# Eval("SenderName") %></span>
                            <p class="chat_content"><%# Eval("Content") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoMessages" runat="server" Text="Select a student to start chatting..." CssClass="chat_empty"></asp:Label>
            </div>
            <div class="create_chat">
                <asp:TextBox ID="txtMessage" runat="server" CssClass="chat_input" placeholder="Type a message..." TextMode="MultiLine" Rows="2"></asp:TextBox>
                <asp:Button ID="btnSendMessage" runat="server" Text="Send" CssClass="send_chat_button" OnClick="btnSend_Click" />
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdnSelectedStudent" runat="server" Value="" />
</asp:Content>
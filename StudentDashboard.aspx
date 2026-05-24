<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="Wapping_time.StudentDashboard" %>
<%@ MasterType VirtualPath="~/Assignment.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/StudentDashboard.css") %>" />
    <script src='<%= ResolveUrl ("~/Scripts/StudentDashboard.js") %>'></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="notificationPanel" class="notification_panel">
        <div class="notification_header">Notifications</div>
        <asp:Repeater ID="rptNotifications" runat="server">
            <ItemTemplate>
                <div class="notification_box">
                    <strong><%# Eval("Title") %></strong>
                    <p><%# Eval("Content") %></p>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Label ID="lblNoNotifications" runat="server" Text="No Notifications" Visible="false" CssClass="notification_empty" />
    </div>
    <div id="chatPanel" class="student_chat_panel">
        <div class="chat_header">Chat Messages</div>
        <asp:Repeater ID="rptStudentChatMessages" runat="server">
            <ItemTemplate>
                <div class="chat_message_box">
                    <strong class="chat_sender"><%# Eval("SenderName") %></strong>
                    <p class="chat_content"><%# Eval("Content") %></p>
                </div> 
            </ItemTemplate>
        </asp:Repeater>
        <asp:Label ID="lblNoChatMessages" runat="server" Text="No Chat Messages Yet" Visible="false" CssClass="chat_empty" />
    </div>
    <asp:Label class="welcome_message" ID="lblName" runat="server" Text="Welcome, username!"></asp:Label>
    <div class="course_panel">
        <button type="button" class ="carousel_button" id="prevCourse" onclick="slideCourse(-1)"><</button>
        <div class="carousel">
            <div class="list_courses" id="listCourses">
                <asp:Repeater ID="rptCourses" runat="server">
                    <ItemTemplate>
                        <a href='<%# "SelectedCoursePage.aspx?CourseID=" + Eval("Course.CourseID") %>' class="item_link">
                            <div class="item">
                                <asp:Image runat="server" ImageUrl='<%# "~" + Eval("Course.ImageName") %>' CssClass="course_image" />
                                <div class="course_name"><%# Eval("Course.CourseName") %></div>
                                <div class="course_desc"><%# Eval("Course.Description") %></div>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <button type="button" class="carousel_button" id="nextCourse" onclick="slideCourse(1)">></button>
    </div>
    <div class="progress_container">
        <asp:Label Cssclass="progress_message" ID="lblProgress" runat="server" Text="You are doing great!"></asp:Label>
        <div class="progress_bar">
            <asp:Panel ID="pnlProgressOuter" runat="server" Height="40px" Width="1000px" style="box-sizing: border-box; overflow: hidden; border: 3px outset #663399; border-radius: 20px">
                <asp:Panel ID="pnlProgressInner" runat="server" Height="40px" BackColor="#9933FF"></asp:Panel>
            </asp:Panel>
        </div>
        <asp:Label Cssclass="progress_message" ID="lblCompletionRate" runat="server" Text="num% Complete"></asp:Label>
    </div>
</asp:Content>

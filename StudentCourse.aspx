<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="StudentCourse.aspx.cs" Inherits="Wapping_time.StudentCourse" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/StudentCourse.css") %>" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=search" />
    <script src='<%= ResolveUrl ("~/Scripts/StudentCourse.js") %>'></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="search_container">
        <span class="material-symbols-outlined">search</span>
        <input class="search_text" type="search" placeholder="Search..." id="courseSearchBar" />
    </div>
    <div class="courses_container">
        <asp:Repeater ID="rptEnrolledCourses" runat="server">
            <ItemTemplate>
                <a href='<%# "SelectedCoursePage.aspx?CourseID=" + Eval("Course.CourseID") %>' class="item_link">
                    <div class="course_container" id="listCourses">
                        <asp:Image runat="server" ImageUrl='<%# "~" + Eval("Course.ImageName") %>' CssClass="course_image" />
                        <div class="course_information">
                            <asp:Label ID="lblCourseName" CssClass="course_name" runat="server"><%# Eval("Course.CourseName") %></asp:Label>
                            <asp:Label ID="lblCourseCreator" CssClass="course_creator" runat="server"><%# "Created by: " + Eval("Course.CreatorName") %></asp:Label>
                            <p class="course_description"><%# Eval("Course.Description") %></p>
                            <div class="progress_container">
                                <div class="progress_outer">
                                    <div class="progress_inner" style='<%# "width:" + Eval("Progress") + "%" %>'></div>
                                </div>
                                <asp:Label ID="lblProgressMessage" CssClass="progress_message" runat="server"><%# "Total Completion Rate: " + Eval("Progress") + "%" %></asp:Label>
                            </div>
                        </div>
                    </div>
                </a>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

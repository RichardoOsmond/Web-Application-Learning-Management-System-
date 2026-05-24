<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="AdminCourse.aspx.cs" Inherits="Wapping_time.AdminCourse" %>
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
        <asp:Repeater ID="rptCreatedCourses" runat="server">
            <ItemTemplate>
                <a href='<%# "SelectedCoursePage.aspx?CourseID=" + Eval("CourseID") %>' class="item_link">
                    <div class="course_container">
                        <asp:Image runat="server" ImageUrl='<%# "~" + Eval("ImageName") %>' CssClass="course_image" />
                        <div class="course_information">
                            <asp:Label ID="lblCourseName" CssClass="course_name" runat="server"><%# Eval("CourseName") %></asp:Label>
                            <p class="course_description"><%# Eval("Description") %></p>
                        </div>
                    </div>
                </a>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

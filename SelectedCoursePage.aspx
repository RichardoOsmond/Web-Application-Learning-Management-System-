<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="SelectedCoursePage.aspx.cs" Inherits="Wapping_time.CoursePage" %>
<%@ MasterType VirtualPath="~/Assignment.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/SelectedCoursePage.css") %>" />
    <script src='<%= ResolveUrl ("~/Scripts/SelectedCoursePage.js") %>'></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="returnBtn" runat="server" Text="Return" CssClass="return-btn" OnClick="returnBtn_Click" />
    <div class="course-container" id="courseContainer">
        <div class="left-column left-column-center">
            <div class="lesson-list-big">
                <h1>Lessons</h1>
                <asp:Repeater ID="LessonRepeater" runat="server" OnItemCommand="selectLesson">
                    <ItemTemplate>
                        <asp:LinkButton ID="LessonLink" runat="server"
                            CommandArgument='<%# Eval("LessonID") %>'
                            CssClass='<%# (int)Eval("LessonID") == selectedLessonID ? "lesson-link active" : "lesson-link" %>'>
                            <%# Eval("LessonName") %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="middle-column hidden">
            <div class="section">
                <h2 class="section-title">
                    <img src="Images/arrow.png" class="arrow-icon" onclick="toggleSection('materialPanel', this.parentElement)"/> Material
                    <asp:Button ID="btnMaterial" runat="server" Text="Edit" CssClass="section-btn" Visible="false" OnClick="btnMaterial_Click"/>
                </h2>
                <asp:Panel ID="materialPanel" runat="server" CssClass="section-panel open">
                    <asp:Repeater ID="MaterialRepeater" runat="server">
                        <ItemTemplate>
                            <a href='ViewMaterial.aspx?MaterialID=<%# Eval("MaterialID") %>&CourseID=<%# selectedCourseID %>&LessonID=<%# selectedLessonID %>'><%# Eval("Name") %></a>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>
            <div class="section">
                <h2 class="section-title">
                    <img src="Images/arrow.png" class="arrow-icon" onclick="toggleSection('quizPanel', this.parentElement)"/> Quiz
                    <asp:Button ID="btnQuiz" runat="server" Text="Edit" CssClass="section-btn" Visible="false" OnClick="btnQuiz_Click"/>
                </h2>
                <asp:Panel ID="quizPanel" runat="server" CssClass="section-panel open">
                    <asp:Repeater ID="QuizRepeater" runat="server">
                        <ItemTemplate>
                            <a href='bridgePage.aspx?QuizID=<%# Eval("QuizID") %>&CourseID=<%# selectedCourseID %>&LessonID=<%# selectedLessonID %>&QuizName=<%# Eval("Name") %>'><%# Eval("Name") %></a>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>
        </div>

        <div class="right-column">
            <div class="course-image">
                <img src='<%=courseImage%>' alt="Course Image" />
                <h1><%=courseName%></h1>
                <p><%=courseDescription %></p>
            </div>
        </div>
    </div>
</asp:Content>

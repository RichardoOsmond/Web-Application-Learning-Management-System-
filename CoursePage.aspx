<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="CoursePage.aspx.cs" Inherits="Wapping_time.CoursePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .course-container {
            display: flex;
            gap: 20px;
            padding: 30px;
        }

        .left-column {
            width: 350px;
            flex-shrink: 0;
        }

        .left-column-center {
            width: 100%;
            justify-content: center;
            display: flex;
        }

        .lesson-list-big {
            width: 600px;
            background-color: #d6c8f5;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
        }

        .lesson-list-small {
            background-color: #d6c8f5;
            border-radius: 15px;
            padding: 15px;
            width: 100%;
        }

        .middle-column {
            flex: 1;
        }

        .middle-column h2 {
            font-size: 32px;
        }

        .hidden {
            display: none;
        }

        .right-column {
            width: 350px;
            flex-shrink: 0;
            text-align: center;
        }

        .course-image img {
            width: 100%;
            border-radius: 10px;
        }

        .section-title {
            padding: 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-panel {
            background-color: #d6c8f5;
            border-radius: 10px;
            overflow: hidden;
            max-height: 0;
            padding: 0 15px;
            transition: max-height 0.5s ease, padding 0.5s ease;
        }

        .section-panel.open {
            max-height: 200px;
            height: 200px;
            padding: 15px;
            overflow-y: scroll;
        }

        .section-panel a {
            display: block !important;
            padding: 8px;
            text-decoration: none;
            color: #5a2d9c;
        }

        .lesson-link {
            display: block;
            padding: 8px;
            text-decoration: none;
            color: #5a2d9c;
            background: none;
            border: none;
            cursor: pointer;
            width: 100%;
            text-align: left;
        }

        .lesson-link-big {
            font-size: 36px;
            text-align: center;
        }

        .lesson-link.active {
            font-weight: bold;
            color: #7842f5;
        }

        .arrow-icon {
            cursor: pointer;
            width: 32px;
            height: 32px;
            transition: transform 0.3s;
        }

        .arrow-rotate {
            transform: rotate(90deg);
        }

        .section-panel::-webkit-scrollbar {
            width: 8px;
        }

        .section-panel::-webkit-scrollbar-track {
            background: #c4b5f0;
            border-radius: 10px;
        }

        .section-panel::-webkit-scrollbar-thumb {
            background: #7842f5;
            border-radius: 10px;
        }

        .section-panel::-webkit-scrollbar-thumb:hover {
            background: #5a2d9c;
        }

        .section-btn {
            background-color: #7842f5;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            margin-left: auto;
        }

        .section-btn:hover {
            background-color: #5a2d9c;
        }

    </style>
    <script>
        function toggleSection(panelId, title) {
            var panel = document.querySelector('[id$="' + panelId + '"]');
            var arrow = title.querySelector('.arrow-icon');
            panel.classList.toggle('open');
            arrow.classList.toggle('arrow-rotate');
        }
            
        function moveLessonToLeft() {
            var leftCol = document.querySelector('.left-column');
            var middleCol = document.querySelector('.middle-column');
            var rightCol = document.querySelector('.right-column');
            var lessonList = document.querySelector('.lesson-list-big');

            leftCol.classList.remove('left-column-center');
            lessonList.classList.remove('lesson-list-big');
            lessonList.classList.add('lesson-list-small');

            var links = document.querySelectorAll('.lesson-link');
            links.forEach(function (link) {
                link.classList.remove('lesson-link-big');
            });

            middleCol.classList.remove('hidden');
            rightCol.classList.remove('hidden');
        }

        window.addEventListener('DOMContentLoaded', function () {
            // check if active (highlighting) is not null
            var hasActive = document.querySelector('.lesson-link.active') !== null;
            if (hasActive) {
                moveLessonToLeft();
            } else {
                // nothing is active
                var links = document.querySelectorAll('.lesson-link');
                links.forEach(function (link) {
                    link.classList.add('lesson-link-big');
                });
            }
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="course-container" id="courseContainer">
        <div class="left-column left-column-center">
            <div class="lesson-list-big">
                <h3>Lessons</h3>
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
                            <a href='ViewMaterial.aspx?MaterialID=<%# Eval("MaterialID") %>'><%# Eval("Name") %></a>
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
                            <a href="#"><%# Eval("Name") %></a>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>
        </div>

        <div class="right-column hidden">
            <div class="course-image">
                <img src="Images/Math icon.png" alt="Course Image" />
            </div>
            <h3>Math</h3>
            <p>(042026-MT)</p>
        </div>
    </div>
</asp:Content>

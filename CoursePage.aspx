<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="CoursePage.aspx.cs" Inherits="Wapping_time.CoursePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .course-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            padding: 30px;
        }

        .course-image img {
            width: 100%;
            border-radius: 10px;
        }

        .section-title {
            cursor: pointer;
            padding: 10px 0;
        }

        .section-panel {
            background-color: #d6c8f5;
            border-radius: 10px;
            overflow: hidden;
            max-height: 0;
            padding: 0 15px;
            transition: max-height 0.4s ease, padding 0.4s ease;
        }

        .section-panel.open {
            max-height: 200px;
            padding: 15px;
            overflow-y: scroll;
        }

        .section-panel a {
            display: block;
            padding: 8px;
            text-decoration: none;
            color: #5a2d9c;
        }
        .arrow-icon {
            width: 24px;
            transition: transform 0.3s;
        }
        .arrow-rotate {
            transform: rotate(90deg);
        }
        .section-panel.open {
            max-height: 500px;
        }
    </style>
    <script>
        function toggleSection(panelId, title) {
            var panel = document.querySelector('[id$="' + panelId + '"]');
            var arrow = title.querySelector('.arrow-icon');
            panel.classList.toggle('open');
            arrow.classList.toggle('arrow-rotate');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="course-container">
        
        <div class="course-image">
            <img src="Images/math.png" alt="Course Image" />
        </div>

        <div class="homework-section">
            <h2 class="section-title" onclick="toggleSection('homeworkPanel', this)">
            <img src="Images/arrow.png" class="arrow-icon" /> Homework
            </h2>
            <asp:Panel ID="homeworkPanel" runat="server" CssClass="section-panel">
                <!-- homework items go here -->
            </asp:Panel>
        </div>

        <div class="general-section">
            <h2 class="section-title" onclick="toggleSection('generalPanel', this)">
            <img src="Images/arrow.png" class="arrow-icon" /> General
            </h2>
            <asp:Panel ID="generalPanel" runat="server" CssClass="section-panel">
                <!-- general items go here -->
            </asp:Panel>
        </div>

        <div class="tests-section">
            <h2 class="section-title" onclick="toggleSection('testsPanel', this)">
            <img src="Images/arrow.png" class="arrow-icon" /> Tests
            </h2>
            <asp:Panel ID="testsPanel" runat="server" CssClass="section-panel">
                <!-- test items go here -->
            </asp:Panel>
        </div>

        <div class="lessons-section">
            <h2 class="section-title" onclick="toggleSection('lessonsPanel', this)">
            <img src="Images/arrow.png" class="arrow-icon" /> Lessons
            </h2>
            <asp:Panel ID="lessonsPanel" runat="server" CssClass="section-panel">
                <a href="#">Introduction to Math.ppt</a>
                <a href="#">Addition.ppt</a>
                <a href="#">Subtraction.ppt</a>
            </asp:Panel>
        </div>

    </div>
</asp:Content>

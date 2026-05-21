<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="CoursePage.aspx.cs" Inherits="Wapping_time.CoursePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .course-container {
            display: flex;
            gap: 20px;
            padding: 30px;
            align-items: start;

        }

        .left-column {
            gap: 20px;
        }

        .middle-column{
            flex: 1
        }

        .right-column{
            width: 250px;
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
            transition: max-height 0.5s ease, padding 0.5s ease;
        }

        .section-panel.open {
            max-height: 200px;
            height: 200px;
            padding: 15px;
            overflow-y: scroll;
        }

        .section-panel a {
            display: block;
            padding: 8px;
            text-decoration: none;
            color: #5a2d9c;
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
        .arrow-icon {
            width: 24px;
            transition: transform 0.3s;
        }
        .arrow-rotate {
            transform: rotate(90deg);
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
        
        <div class="left-column">
            <h3>Lessons</h3>
            <div class="section-panel open">
                <a href="#">Introduction to Math.ppt</a>
                <a href="#">Addition.ppt</a>
                <a href="#">Subtraction.ppt</a>
                <a href="#">Multiplication.ppt</a>
            </div>
        </div>

        <div class="middle-column">
            <div class="section">
                <h2 class="section-title" onclick="toggleSection('materialPanel', this)">
                    <img src="Images/arrow.png" class="arrow-icon" /> Material
                </h2>
                <asp:Panel ID="materialPanel" runat="server" CssClass="section-panel open">
                    <a href="#">Addition Questions 1-2.docx</a>
                    <a href="#">Subtraction Question 3.docx</a>
                    <a href="#">Practical Question 2.pdf</a>
                </asp:Panel>
            </div>
            <div class="section">
                <h2 class="section-title" onclick="toggleSection('quizPanel', this)">
                    <img src="Images/arrow.png" class="arrow-icon" /> Quiz
                </h2>
                <asp:Panel ID="quizPanel" runat="server" CssClass="section-panel open">
                    <a href="#">Addition Test</a>
                    <a href="#">Subtraction Test</a>
                    <a href="#">Final Test</a>
                </asp:Panel>
            </div>
        </div>

        <div class="right-column">
            <div class="course-image">
                <img src="Images/math.png" alt="Course Image" />
            </div>
            <h3>Math</h3>
            <p>(042026-MT)</p>
        </div>

    </div>
</asp:Content>

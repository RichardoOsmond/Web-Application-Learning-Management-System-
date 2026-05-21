<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="AdminEditCoursePage.aspx.cs" Inherits="Wapping_time.EditMaterial" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .lesson-list {
            background-color: #d6c8f5;
            border-radius: 15px;
            padding: 15px;
            width: 100%;
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

        .lesson-link.active {
            font-weight: bold;
            color: #7842f5;
        }

        .course-container {
            display: flex;
            gap: 20px;
            padding: 30px;
        }

        .left-column {
            width: 350px;
            flex-shrink: 0;
        }

        .middle-column {
            flex: 1;
        }

        .middle-column h2 {
            font-size: 32px;
        }

        .section-title {
            padding: 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-panel a {
            display: block;
            padding: 8px;
            text-decoration: none;
            color: #5a2d9c;
        }

        .section-panel a.active {
            font-weight: bold;
            color: #7842f5;
        }

        .arrow-icon {
            cursor: pointer;
            width: 32px;
            height: 32px;
            transition: transform 0.3s;
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

        .arrow-rotate {
            transform: rotate(90deg);
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

        .hidden {
            display: none;
        }

    </style>

    <script>
        function toggleSection(panelId, title) {
            var panel = document.querySelector('[id$="' + panelId + '"]');
            var arrow = title.querySelector('.arrow-icon');
            panel.classList.toggle('open');
            arrow.classList.toggle('arrow-rotate');
        }

        function showMaterialOnly() {
            document.getElementById('materialSection').classList.remove('hidden');
            document.getElementById('quizSection').classList.add('hidden');
        }

        function showQuizOnly() {
            document.getElementById('quizSection').classList.remove('hidden');
            document.getElementById('materialSection').classList.add('hidden');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="course-container" id="courseContainer">
        <div class="left-column">
            <div class="lesson-list">
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

        <div class="middle-column">
            <div class="section hidden" id="materialSection">
                <h2 class="section-title">
                    <img src="Images/arrow.png" class="arrow-icon" onclick="toggleSection('materialPanel', this.parentElement)"/> Material
                    <asp:Button ID="mAddBtn" runat="server" Text="Add Material" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="mEditBtn" runat="server" Text="Edit Selected Material" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="mDeleteBtn" runat="server" Text="Delete Selected Material" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="mReturnBtn" runat="server" Text="Return" CssClass="section-btn" OnClick="varBtn_Click"/>
                </h2>
                <asp:Panel ID="materialPanel" runat="server" CssClass="section-panel open">
                    <asp:Repeater ID="MaterialRepeater" runat="server" OnItemCommand="selectMaterial">
                        <ItemTemplate>
                            <asp:LinkButton ID="MaterialLink" runat="server"
                                CommandArgument='<%# Eval("MaterialID") %>'
                                CssClass='<%# (int)Eval("MaterialID") == selectedMaterialID ? "active" : "" %>'>
                                <%# Eval("Name") %>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
            </div>
            <div class="section hidden" id="quizSection">
                <h2 class="section-title">
                    <img src="Images/arrow.png" class="arrow-icon" onclick="toggleSection('quizPanel', this.parentElement)"/> Quiz
                    <asp:Button ID="qAddBtn" runat="server" Text="Add Quiz" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="qEditBtn" runat="server" Text="Edit Selected Quiz" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="qDeleteBtn" runat="server" Text="Delete Selected Quiz" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="qReturnBtn" runat="server" Text="Return" CssClass="section-btn" OnClick="varBtn_Click"/>
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

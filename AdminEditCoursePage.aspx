<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="AdminEditCoursePage.aspx.cs" Inherits="Wapping_time.EditMaterial" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/AdminEditCoursePage.css") %>" />
    <script src='<%= ResolveUrl ("~/Scripts/AdminEditCoursePage.js") %>'></script>

    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
    <script type="text/javascript">
        var selectedLessonID = <%=selectedLessonID%>;
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hdnOrder" runat="server" />
    <asp:HiddenField ID="hdnModalMode" runat="server" />

        <div class="course-container" id="courseContainer">
        <div class="left-column">
            <div class="lesson-list">
                <div class="lesson-list-header">
                    <h3>Lessons</h3>
                    <asp:Button ID="aLessonBtn" runat="server" Text="Add Lesson" CssClass="section-btn" OnClientClick="openAddModal(); return false; " />
                    <asp:Button ID="aDeleteBtn" runat="server" Text="Delete Selected Lesson" CssClass="section-btn" OnClientClick="openLessonDeleteModal(); return false; " />
                    <div id="addLessonModal" style="display:none;" class="modal-overlay">
                        <div class="modal-box">
                            <h2 id="modalTitle">Add Lesson</h2>
                            <div id="addLessonContent">
                                <label>Lesson Name:</label>
                                <asp:TextBox ID="lessonNameTxt" runat="server" CssClass="name-input" />
                            </div>
                            <div id="deleteLessonContent" style="display:none;">
                                <p>Are you sure you want to delete this lesson?</p>
                            </div>
                            <div id="deleteMaterialContent" style="display:none;">
                                <p>Are you sure you want to delete this Material?</p>
                            </div>
                            <div id="deleteQuizContent" style="display:none;">
                                <p>Are you sure you want to delete this Quiz?</p>
                            </div>
                            <div class="modal-buttons">
                                <asp:Button ID="confirmLessonBtn" runat="server" Text="Add" OnClick="confirmLessonBtn_Click" />
                                <button type="button" onclick="closeModal()">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>
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
                    <asp:Button ID="mDeleteBtn" runat="server" Text="Delete Selected Material" CssClass="section-btn" OnClientClick="openMaterialDeleteModal(); return false; " />
                    <asp:Button ID="mEditOrderBtn" runat="server" Text="Edit Order" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="mReturnBtn" runat="server" Text="Return" CssClass="section-btn" OnClick="varBtn_Click"/>
                </h2>
                <asp:Panel ID="materialPanel" runat="server" CssClass="section-panel open">
                    <asp:Repeater ID="MaterialRepeater" runat="server" OnItemCommand="selectMaterial">
                        <ItemTemplate>
                            <div class="material-item" data-id='<%# Eval("MaterialID") %>'>
                                <span class="item-number hidden"><%# Container.ItemIndex + 1 %>.</span>
                                <asp:LinkButton ID="MaterialLink" runat="server"
                                    CommandArgument='<%# Eval("MaterialID") %>'
                                    CssClass='<%# (int)Eval("MaterialID") == selectedMaterialID ? "active" : "" %>'>
                                    <%# Eval("Name") %>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
                <asp:Button ID="saveOrderBtn" runat="server" Text= "Save Order" CssClass="section-btn save-order-btn" OnClick="saveOrderBtn_Click" style="display:none" />
            </div>
            <div class="section hidden" id="quizSection">
                <h2 class="section-title">
                    <img src="Images/arrow.png" class="arrow-icon" onclick="toggleSection('quizPanel', this.parentElement)"/> Quiz
                    <asp:Button ID="qAddBtn" runat="server" Text="Add Quiz" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="qEditBtn" runat="server" Text="Edit Selected Quiz" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="qDeleteBtn" runat="server" Text="Delete Selected Quiz" CssClass="section-btn" OnClientClick="openQuizDeleteModal(); return false;"/>
                    <asp:Button ID="qEditOrderBtn" runat="server" Text="Edit Order" CssClass="section-btn" OnClick="varBtn_Click"/>
                    <asp:Button ID="qReturnBtn" runat="server" Text="Return" CssClass="section-btn" OnClick="varBtn_Click" />
                </h2>
                <asp:Panel ID="quizPanel" runat="server" CssClass="section-panel open">
                    <asp:Repeater ID="QuizRepeater" runat="server" OnItemCommand="selectQuiz">                     
                        <ItemTemplate>
                            <div class="quiz-item" data-id='<%# Eval("QuizID") %>'>
                                <span class="item-number hidden"><%# Container.ItemIndex + 1 %>.</span>
                                <asp:LinkButton ID="QuizLink" runat="server"
                                    CommandArgument='<%# Eval("QuizID") %>'
                                    CssClass='<%# (int)Eval("QuizID") == selectedQuizID ? "active" : "" %>'>
                                    <%# Eval("Name") %>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
                <asp:Button ID="qSaveOrderBtn" runat="server" Text= "Save Order" CssClass="section-btn save-order-btn" OnClick="qSaveOrderBtn_Click" style="display:none" />
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

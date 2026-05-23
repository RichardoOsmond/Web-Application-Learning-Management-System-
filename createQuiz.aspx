<%@ Page Title="" Language="C#" MasterPageFile="~/quiz.Master" AutoEventWireup="true" CodeBehind="createQuiz.aspx.cs" Inherits="Wapping_time.createQuiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="QuizContent" runat="server">
    <asp:Panel ID="pnlCreateQuiz" runat="server" CssClass="quiz-form-panel">
    <asp:Label ID="lblCreateQuiz" runat="server" CssClass="quiz-page-title" Text="Create Quiz"></asp:Label>
    <asp:Label ID="lblInstruction" runat="server" Text="Fill in the details below to create a quiz." CssClass="quiz-instruction"></asp:Label>
    <asp:Label ID="lblCourse" runat="server" Text="Course:" CssClass="quiz-field-label"></asp:Label>
    <asp:Label ID="lblCourseName" runat="server" CssClass="quiz-field-label" Text="-"></asp:Label>
    <asp:Label ID="lblQuizName" runat="server" Text="Quiz Name:" CssClass="quiz-field-label"></asp:Label>
    <asp:TextBox ID="txtQuizName" runat="server" CssClass="quiz-field-input"></asp:TextBox>
    <asp:Label ID="lblTimeLimit" runat="server" Text="Time Limit:" CssClass="quiz-field-label"></asp:Label>
    <asp:TextBox ID="txtTimeLimit" runat="server" CssClass="quiz-field-input" placeholder="hh:mm"></asp:TextBox>
    <asp:Label ID="lblTimeLimitHint" runat="server" Text="Format: hh:mm (e.g. 0105 = 1 hour 5 mins)" CssClass="quiz-hint-label"></asp:Label>
    <asp:Label ID="lblPassingScore0" runat="server" CssClass="quiz-field-label" Text="Passing Percentage:"></asp:Label>
    <asp:TextBox ID="txtPassingScore" runat="server" CssClass="quiz-field-input" placeholder="60"></asp:TextBox>
    <asp:Label ID="lblTimeLimitHint2" runat="server" CssClass="quiz-hint-label" Text="Format: int% (eg: 50, 60, 70)"></asp:Label>
    <asp:Label ID="lblMaxAttempts" runat="server" CssClass="quiz-field-label" Text="Max Attempts:"></asp:Label>
    <asp:TextBox ID="txtMaxAttempts" runat="server" CssClass="quiz-field-input"></asp:TextBox>
    <asp:Label ID="lblTimeLimitHint0" runat="server" CssClass="quiz-hint-label" Text="Format: Int value (eg: 1, 3, 10)"></asp:Label>
    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="quiz-btn-save" onclick="btnSave_Click" />
    &nbsp;&nbsp;&nbsp;
    <asp:Button ID="btnClear" runat="server" CssClass="quiz-btn-clear" Text="Clear" onclick="btnClear_Click" />
</asp:Panel>
    <asp:Panel ID="pnlAddQuestion" runat="server" CssClass="quiz-form-panel">
        <asp:Label ID="lblAddQuestion" runat="server" Text="Add Questions" CssClass="quiz-page-title"></asp:Label>
        <asp:Label ID="lblQuestionInstruction" runat="server" Text="Select a question type and fill in the details below." CssClass="quiz-instruction"></asp:Label>
        <asp:Label ID="lblQuestionType" runat="server" Text="Question Type:" CssClass="quiz-field-label"></asp:Label>
        <asp:DropDownList ID="ddlQuestionType" runat="server" CssClass="quiz-field-input">
            <asp:ListItem Text="Multiple Choice" Value="MCQ"></asp:ListItem>
            <asp:ListItem Text="Essay" Value="Essay"></asp:ListItem>
        </asp:DropDownList>
        <asp:Label ID="lblQuestionText" runat="server" Text="Question Text:" CssClass="quiz-field-label"></asp:Label>
        <asp:TextBox ID="txtQuestionText" runat="server" CssClass="quiz-field-input"></asp:TextBox>
        <asp:Panel ID="pnlMCQ" runat="server" CssClass="quiz-mcq-panel">
            <asp:Label ID="lblAnswer1" runat="server" Text="Answer 1:" CssClass="quiz-field-label"></asp:Label>
            <asp:TextBox ID="txtAnswer1" runat="server" CssClass="quiz-field-input"></asp:TextBox>
            <asp:RadioButton ID="rbAnswer1" runat="server" Text=" Correct" GroupName="CorrectAnswer" />
            <asp:Label ID="lblAnswer2" runat="server" Text="Answer 2:" CssClass="quiz-field-label"></asp:Label>
            <asp:TextBox ID="txtAnswer2" runat="server" CssClass="quiz-field-input"></asp:TextBox>
            <asp:RadioButton ID="rbAnswer2" runat="server" Text=" Correct" GroupName="CorrectAnswer" />
            <asp:Label ID="lblAnswer3" runat="server" Text="Answer 3:" CssClass="quiz-field-label"></asp:Label>
            <asp:TextBox ID="txtAnswer3" runat="server" CssClass="quiz-field-input"></asp:TextBox>
            <asp:RadioButton ID="rbAnswer3" runat="server" Text=" Correct" GroupName="CorrectAnswer" />
        </asp:Panel>
        <asp:Label ID="lblPoints" runat="server" Text="Points:" CssClass="quiz-field-label"></asp:Label>
        <asp:TextBox ID="txtPoints" runat="server" CssClass="quiz-field-input"></asp:TextBox>
        <asp:Label ID="lblTimeLimitHint1" runat="server" CssClass="quiz-hint-label" Text="Format: Int value (eg: 1, 3, 10)"></asp:Label>
        <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="quiz-btn-save" />
    </asp:Panel>

    <asp:Panel ID="pnlQuestionList" runat="server" CssClass="quiz-form-panel quiz-grid-panel">
        <asp:Label ID="lblQuestionList" runat="server" Text="Questions Added" CssClass="quiz-page-title"></asp:Label>
        <asp:GridView ID="gvQuestions" runat="server" CssClass="quiz-grid">
        </asp:GridView>
    </asp:Panel>
</asp:Content>
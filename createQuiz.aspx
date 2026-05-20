<%@ Page Title="" Language="C#" MasterPageFile="~/quiz.Master" AutoEventWireup="true" CodeBehind="createQuiz.aspx.cs" Inherits="Wapping_time.createQuiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="QuizContent" runat="server">
    <asp:Label ID="lblCreateQuiz" runat="server" Text="Create Quiz" CssClass="quiz-page-title"></asp:Label>
    <asp:Panel ID="pnlCreateQuiz" runat="server" CssClass="quiz-form-panel">
        <asp:Label ID="lblInstruction" runat="server" Text="Fill in the details below to create a quiz." CssClass="quiz-instruction"></asp:Label>
        <br />
        <asp:Label ID="lblCourse" runat="server" Text="Course:" CssClass="quiz-field-label"></asp:Label>
        &nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="ddlCourse" runat="server" CssClass="quiz-field-input"></asp:DropDownList>
        <br />
        <asp:Label ID="lblQuizName" runat="server" Text="Quiz Name:" CssClass="quiz-field-label"></asp:Label>
        &nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtQuizName" runat="server" CssClass="quiz-field-input"></asp:TextBox>
        <br />
        <asp:Label ID="lblTimeLimit" runat="server" Text="Time Limit:" CssClass="quiz-field-label"></asp:Label>
        &nbsp;
        <asp:TextBox ID="txtTimeLimit" runat="server" CssClass="quiz-field-input" placeholder="hh:mm"></asp:TextBox>
        <br />
        <asp:Label ID="lblTimeLimitHint" runat="server" Text="Format: hh:mm (e.g. 0105 = 1 hour 5 mins)" CssClass="quiz-hint-label"></asp:Label>
        <br />
        <asp:Label ID="lblPassingScore" runat="server" CssClass="quiz-field-label" Text="Passing Score:"></asp:Label>
        <asp:TextBox ID="txtPassingScore" runat="server" CssClass="quiz-field-input"></asp:TextBox>
        <br />
        <asp:Label ID="lblMaxAttempts" runat="server" CssClass="quiz-field-label" Text="Max Attempts:"></asp:Label>
        &nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtMaxAttempts" runat="server" CssClass="quiz-field-input"></asp:TextBox>
        <br />
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="quiz-btn-save" onclick="btnSave_Click" />
        &nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnClear" runat="server" CssClass="quiz-btn-clear" Text="Clear" onclick="btnClear_Click" />
    </asp:Panel>

    <asp:Panel ID="pnlAddQuestion" runat="server" CssClass="quiz-form-panel">
        <asp:Label ID="lblAddQuestion" runat="server" Text="Add Questions" CssClass="quiz-page-title"></asp:Label>
        <br />
        <asp:Label ID="lblQuestionInstruction" runat="server" Text="Select a question type and fill in the details below." CssClass="quiz-instruction"></asp:Label>
        <br />
        <asp:Label ID="lblQuestionType" runat="server" Text="Question Type:" CssClass="quiz-field-label"></asp:Label>
        &nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="ddlQuestionType" runat="server" CssClass="quiz-field-input">
            <asp:ListItem Text="Multiple Choice" Value="MCQ"></asp:ListItem>
            <asp:ListItem Text="Essay" Value="Essay"></asp:ListItem>
        </asp:DropDownList>
        <br />
        <asp:Label ID="lblQuestionText" runat="server" Text="Question Text:" CssClass="quiz-field-label"></asp:Label>
        &nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtQuestionText" runat="server" CssClass="quiz-field-input"></asp:TextBox>
        <br />
        <asp:Panel ID="pnlMCQ" runat="server" CssClass="quiz-mcq-panel">
            <asp:Label ID="lblAnswer1" runat="server" Text="Answer 1:" CssClass="quiz-field-label"></asp:Label>
            &nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtAnswer1" runat="server" CssClass="quiz-field-input"></asp:TextBox>
            &nbsp;
            <asp:RadioButton ID="rbAnswer1" runat="server" Text="Correct" GroupName="CorrectAnswer" />
            <br />
            <asp:Label ID="lblAnswer2" runat="server" Text="Answer 2:" CssClass="quiz-field-label"></asp:Label>
            &nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtAnswer2" runat="server" CssClass="quiz-field-input"></asp:TextBox>
            &nbsp;
            <asp:RadioButton ID="rbAnswer2" runat="server" Text="Correct" GroupName="CorrectAnswer" />
            <br />
            <asp:Label ID="lblAnswer3" runat="server" Text="Answer 3:" CssClass="quiz-field-label"></asp:Label>
            &nbsp;&nbsp;&nbsp;
            <asp:TextBox ID="txtAnswer3" runat="server" CssClass="quiz-field-input"></asp:TextBox>
            &nbsp;
            <asp:RadioButton ID="rbAnswer3" runat="server" Text="Correct" GroupName="CorrectAnswer" />
        </asp:Panel>
        <br />
        <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="quiz-btn-save" />
        <br />
        <asp:GridView ID="gvQuestions" runat="server" CssClass="quiz-grid">
        </asp:GridView>
    </asp:Panel>
</asp:Content>
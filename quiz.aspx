<%@ Page Title="" Language="C#" MasterPageFile="~/quiz.Master" AutoEventWireup="true" CodeBehind="quiz.aspx.cs" Inherits="Wapping_time.quiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="QuizContent" runat="server">
    <asp:Label ID="lblCourseQuizTitle" runat="server" Text="Course - Quiz Title" CssClass="quiz-page-title"></asp:Label>
    <br />
    <asp:Panel ID="pnlMain" runat="server" CssClass="quiz-form-panel">
        <asp:Label ID="lblQuizType" runat="server" Text="Multiple Choice" CssClass="quiz-type-label"></asp:Label>
        <br />
        <asp:Label ID="lblInstruction" runat="server" Text="Select the correct answer from the options given." CssClass="quiz-instruction"></asp:Label>
        <br />
    </asp:Panel>
    <br />
    <asp:Panel ID="pnlRightSide" runat="server" CssClass="quiz-right-panel">
        <asp:Panel ID="pnlNavGrid" runat="server" CssClass="quiz-nav-grid">
        </asp:Panel>
        <br />
        <asp:Label ID="lblFinished" runat="server" Text="Finished?" CssClass="quiz-finished-label"></asp:Label>
        <br />
        <asp:Button ID="btnYes" runat="server" Text="Yes" CssClass="quiz-btn-save" />
        &nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnNo" runat="server" Text="No" CssClass="quiz-btn-clear" />
    </asp:Panel>
    <br />
</asp:Content>
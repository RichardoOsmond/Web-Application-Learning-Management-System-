<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="bridgePage.aspx.cs" Inherits="Wapping_time.bridgePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl("~/quiz.css") %>" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="quiz-body">
        <asp:Label ID="lblCourseQuizTitle" runat="server" CssClass="quiz-page-title" Text="Course - Quiz Title"></asp:Label>
        <asp:Label ID="Label1" runat="server" CssClass="quiz-page-title" Text="Course - Quiz Title"></asp:Label>
        <asp:Panel ID="pnlStudent" runat="server" Visible="false">
            <asp:Panel ID="pnlStudentInfo" runat="server" CssClass="quiz-form-panel">
                <asp:Label ID="lblStatusBadge" runat="server" CssClass="quiz-instruction" Text=""></asp:Label>
                <asp:Label ID="lblTimeLimitStudent" runat="server" CssClass="quiz-field-label" Text=""></asp:Label>
                <asp:Label ID="lblPassingStudent" runat="server" CssClass="quiz-field-label" Text=""></asp:Label>
                <asp:Label ID="lblAttemptsInfo" runat="server" CssClass="quiz-field-label" Text=""></asp:Label>
                <br />
                <asp:Button ID="btnAttempt" runat="server" Text="Attempt Quiz" CssClass="quiz-btn-save" OnClick="btnAttempt_Click" />
                <asp:Button ID="btnReturnStudent" runat="server" Text="Return" CssClass="quiz-btn-clear" OnClick="btnReturn_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlPreviousAttempts" runat="server" CssClass="quiz-form-panel quiz-grid-panel" Visible="false">
                <asp:Label ID="lblPrevAttempts" runat="server" CssClass="quiz-page-title" Text="Your Attempts"></asp:Label>
                <asp:GridView ID="gvStudentAttempts" runat="server" CssClass="quiz-grid" AutoGenerateColumns="false" OnRowCommand="gvStudentAttempts_RowCommand" DataKeyNames="QuizAttemptID">
                    <Columns>
                        <asp:BoundField DataField="QuizAttemptID" HeaderText="" Visible="false" />
                        <asp:BoundField DataField="AttemptNumber" HeaderText="#" />
                        <asp:BoundField DataField="DateTaken" HeaderText="Date Taken" DataFormatString="{0:dd MMM yyyy, hh:mm tt}" />
                        <asp:BoundField DataField="Score" HeaderText="Score %" DataFormatString="{0:F1}" />
                        <asp:BoundField DataField="Result" HeaderText="Result" />
                        <asp:ButtonField ButtonType="Button" Text="Review" HeaderText="" CommandName="ReviewAttempt" ControlStyle-CssClass="quiz-btn-clear" />
                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </asp:Panel>
        <asp:Panel ID="pnlAdmin" runat="server" Visible="false">
            <asp:Panel ID="pnlAdminInfo" runat="server" CssClass="quiz-form-panel">
                <asp:Label ID="lblTimeLimitAdmin" runat="server" CssClass="quiz-field-label" Text=""></asp:Label>
                <asp:Label ID="lblPassingAdmin" runat="server" CssClass="quiz-field-label" Text=""></asp:Label>
                <asp:Label ID="lblMaxAttemptsAdmin" runat="server" CssClass="quiz-field-label" Text=""></asp:Label>
                <br />
                <asp:Button ID="btnToggleStatus" runat="server" Text="Open Quiz" CssClass="quiz-btn-save" OnClick="btnToggleStatus_Click" />
                <asp:Button ID="btnReturnAdmin" runat="server" Text="Return" CssClass="quiz-btn-clear" OnClick="btnReturn_Click" />
                </asp:Panel>
            <asp:Panel ID="pnlStudentList" runat="server" CssClass="quiz-form-panel quiz-grid-panel">
                <asp:Label ID="lblStudentList" runat="server" CssClass="quiz-page-title" Text="Student Attempts"></asp:Label>
                <asp:GridView ID="gvAdminStudents" runat="server" CssClass="quiz-grid" AutoGenerateColumns="false" OnRowCommand="gvAdminStudents_RowCommand" DataKeyNames="RegistrationID">
                    <Columns>
                        <asp:BoundField DataField="RegistrationID" HeaderText="" Visible="false" />
                        <asp:BoundField DataField="Username" HeaderText="Student" />
                        <asp:BoundField DataField="AttemptsUsed" HeaderText="Attempts Used" />
                        <asp:BoundField DataField="BestScore" HeaderText="Best Score %" DataFormatString="{0:F1}" />
                        <asp:ButtonField ButtonType="Button" Text="Review" HeaderText="" CommandName="ReviewStudent" ControlStyle-CssClass="quiz-btn-clear" />
                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </asp:Panel>
    </div>
</asp:Content>
<%@ Page Title="" Language="C#" MasterPageFile="~/quiz.Master" AutoEventWireup="true" CodeBehind="quiz.aspx.cs" Inherits="Wapping_time.quiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="QuizContent" runat="server">
    <asp:Label ID="lblCourseQuizTitle" runat="server" Text="Course - Quiz Title" CssClass="quiz-page-title"></asp:Label>
    <br />
    <div id="timerBox" style="display:inline-block; background-color:#7842f5; color:#ffffff; font-family:'Segoe UI',sans-serif; font-weight:600; font-size:14px; padding:8px 20px; border-radius:6px; margin-bottom:12px;">
    <span id="timerDisplay">Loading...</span>
</div>
    <asp:HiddenField ID="hfTimeLimit" runat="server" />
    <br />
    <asp:Panel ID="pnlMain" runat="server" CssClass="quiz-form-panel">
        <asp:Label ID="lblQuizType" runat="server" Text="Multiple Choice" CssClass="quiz-type-label"></asp:Label>
        <br />
        <asp:Label ID="lblInstruction" runat="server" Text="Select the correct answer from the options given." CssClass="quiz-instruction"></asp:Label>
        <br />
    </asp:Panel>
    <br />
    <asp:Button ID="btnSubmit" runat="server" Text="Submit Quiz" CssClass="quiz-btn-save" OnClick="btnSubmit_Click" />
    <asp:Button ID="btnBack" runat="server" Text="Back to Quiz Page" CssClass="quiz-btn-clear" OnClick="btnBack_Click" Visible="false" />
    <br />

    <script>
        window.onload = function () {
            var hiddenField = document.getElementById('<%= hfTimeLimit.ClientID %>');
        var seconds = parseInt(hiddenField.value);

        if (!seconds || seconds <= 0) {
            document.getElementById('timerBox').style.display = 'none';
            return;
        }

        var display = document.getElementById('timerDisplay');
        var submitBtn = document.getElementById('<%= btnSubmit.ClientID %>');

            var timer = setInterval(function () {
                if (seconds <= 0) {
                    clearInterval(timer);
                    submitBtn.click();
                } else {
                    var h = Math.floor(seconds / 3600);
                    var m = Math.floor((seconds % 3600) / 60);
                    var s = seconds % 60;
                    display.innerText = "⏱ Time remaining: " +
                        (h > 0 ? h + "h " : "") +
                        (m < 10 ? "0" + m : m) + "m " +
                        (s < 10 ? "0" + s : s) + "s";
                    seconds--;
                }
            }, 1000);
        };
    </script>
</asp:Content>
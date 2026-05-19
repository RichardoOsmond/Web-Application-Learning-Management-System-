<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="Wapping_time.StudentDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblName" runat="server" Text="Welcome, username!"></asp:Label>
    <asp:Panel ID="pnlCourse" runat="server" Height="300px" Width="1000px">
        <asp:ImageButton ID="btnPrevCourse" runat="server" Height="100px" ImageUrl="Images/CoursePrevButton.png" Width="100px" />
        <asp:ImageButton ID="btnNextCourse" runat="server" Height="100px" ImageUrl="Images/CourseNextButton.png" Width="100px" />
    </asp:Panel>
    <asp:Label ID="lblProgress" runat="server" Text="You are doing great!"></asp:Label>
    <asp:Panel ID="pnlProgressOuter" runat="server" Height="40px" Width="1000px">
        <asp:Panel ID="pnlProgressInner" runat="server" Height="40px">
        </asp:Panel>
    </asp:Panel>
    <asp:Label ID="lblCompletionRate" runat="server" Text="num% Complete"></asp:Label>
</asp:Content>

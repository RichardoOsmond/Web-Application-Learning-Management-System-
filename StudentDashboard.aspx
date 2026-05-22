<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="Wapping_time.StudentDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/StudentDashboard.css") %>" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblName" runat="server" Text="Welcome, username!"></asp:Label>
    <asp:Panel ID="pnlCourse" runat="server" Height="300px" Width="1000px">
        <asp:ImageButton ID="btnPrevCourse" runat="server" Height="100px" ImageUrl="Images/CoursePrevButton.png" Width="100px" />
        <asp:ImageButton ID="btnNextCourse" runat="server" Height="100px" ImageUrl="Images/CourseNextButton.png" Width="100px" />
    </asp:Panel>
    <asp:Label ID="lblProgress" runat="server" Text="You are doing great!"></asp:Label>
    <asp:Panel ID="pnlProgressOuter" runat="server" Height="40px" Width="1000px" style="box-sizing: border-box; overflow: hidden; border: 3px outset #663399; border-radius: 20px">
        <asp:Panel ID="pnlProgressInner" runat="server" Height="40px" BackColor="#9933FF">
        </asp:Panel>
    </asp:Panel>
    <asp:Label ID="lblCompletionRate" runat="server" Text="num% Complete"></asp:Label>
</asp:Content>

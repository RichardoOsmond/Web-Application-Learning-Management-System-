<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="Wapping_time.courses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=add_circle,draw,edit" />
    <style type="text/css">
        #globalDiv{
            display:flex;
            flex-direction:column;
            gap:20px;
            padding:10px 150px 0px 150px;
            background-color:#FDF9FF;
            height:100%
        }
        #searchDiv{
            margin:40px 20px 0px 20px;
            display:flex;
            justify-content:space-between
        }
        #courseDiv-grid{
            display:grid;
            grid-template-columns: repeat(3,1fr);
            gap:25px;
            padding:10px 0px;
        }
        .courseBox{
            display:flex;
            flex-direction:column;
            height:300px;
            border-radius: 20px;
            overflow: hidden;
        }
        .contentInCourseBox {
            flex-basis: 50%;
            min-height: 0;
            position:relative;
            width:100%;
            height:100%
        }
        .enterButton{
            background-color:#7842F5;
            color:white;
            padding: 12px 20px;
            border-radius: 100px;
            text-decoration:none;
        }
        .editCourse{
            position:absolute;
            top:12px;
            right:12px;
            border-radius:50%;
            background: #333333;
            color: white;
            width: 40px;
            height: 40px;
            display:flex;
            align-items: center;
            justify-content: center;
            text-decoration:none;
        }
        .text-description{
            padding:20px 20px 10px 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="globalDiv">
        <div id="searchDiv">
            <asp:TextBox ID="SeacrhTB" runat="server"></asp:TextBox>
            <div id="filterDiv" style="display:grid; grid-template-columns:100px 80px 80px 1fr; column-gap:25px;">
                <label>Filtered By:</label>
                <asp:Button ID="scienceBtn" runat="server" Text="Science" />
                <asp:Button ID="socialBtn" runat="server" Text="Social" />
                <asp:Button ID="extracurricularBtn" runat="server" Text="Extracurricular" />
            </div>
        </div>
        <div id="courseDiv-grid">    
            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
                <ItemTemplate>
                    <div class="courseBox">
                        <div class="contentInCourseBox">
                            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="editCourse">
                                <span class="material-symbols-outlined ">edit</span>
                            </asp:LinkButton>
                            <img 
                                src='<%# string.IsNullOrEmpty(Convert.ToString(Eval("courseImage"))) ? "/Images/penguin.png" : Eval("courseImage") %>'
                                style="object-fit:cover; height:100%; width:100%" draggable="false"
                            />
                                
                        </div>

                        <div class="contentInCourseBox text-description" style="background-color:rgb(255 255 255 / var(--tw-bg-opacity, 1)); display:flex; flex-direction:column; justify-content:space-between">
                            <div>
                                <h3>
                                    <%# Eval("CourseName") %>
                                </h3>
                                <p >
                                    <%# Eval("Description") %>
                                </p>
                                </div>
                            <div style="width:100%; display:flex; justify-content:flex-end ">
                                <asp:Button ID="continueBtn" runat="server" Text="Enter" CssClass="enterButton" OnClick="ContinueBtn_Click" CommandArgument='<%# Eval("CourseID") %>'/>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ReadCardDB %>" DeleteCommand="DELETE FROM [Course] WHERE [CourseID] = @CourseID" InsertCommand="INSERT INTO [Course] ([UserID], [CourseName], [Description], [CourseCreatedDate], [CourseImage], [CourseCategory]) VALUES (@UserID, @CourseName, @Description, @CourseCreatedDate, @CourseImage, @CourseCategory)" SelectCommand="SELECT * FROM [Course]" UpdateCommand="UPDATE [Course] SET [UserID] = @UserID, [CourseName] = @CourseName, [Description] = @Description, [CourseCreatedDate] = @CourseCreatedDate, [CourseImage] = @CourseImage, [CourseCategory] = @CourseCategory WHERE [CourseID] = @CourseID">
                <DeleteParameters>
                    <asp:Parameter Name="CourseID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="UserID" Type="Int32" />
                    <asp:Parameter Name="CourseName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter DbType="Date" Name="CourseCreatedDate" />
                    <asp:Parameter Name="CourseImage" Type="String" />
                    <asp:Parameter Name="CourseCategory" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="UserID" Type="Int32" />
                    <asp:Parameter Name="CourseName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter DbType="Date" Name="CourseCreatedDate" />
                    <asp:Parameter Name="CourseImage" Type="String" />
                    <asp:Parameter Name="CourseCategory" Type="String" />
                    <asp:Parameter Name="CourseID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>

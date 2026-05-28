<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="DashboardWithAdmin.aspx.cs" Inherits="Wapping_time.DashboardWithAdmin" MaintainScrollPositionOnPostBack="true" %>
<%@ MasterType VirtualPath="~/Assignment.Master" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=add_circle,draw,edit" />
    <style type="text/css">
        #globalDiv {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 10px 125px 0px 125px;
            background-color: #FDF9FF;
            height: 100%
        }

        #topDiv {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-top: 20px;
        }

        #topTopDiv {
            display: flex;
            flex-direction: row;
            justify-content: space-between
        }

        .createCourseButton {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            padding: 12px 20px;
            border-radius: 100px;
            text-decoration: none;
            background-color: #7842F5;
        }

        #topBottomDiv {
            display: flex;
            flex-direction: row;
            justify-content: space-between
        }

        #middleDiv {
            display: flex;
            gap: 25px;
            width: 100%;
            margin-top: 20px;
            margin-bottom: 20px;
            align-items: stretch;
        }

        #bottomBottomDiv {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            padding: 10px 0px;
        }

        .welcomeMsg {
            font-size: 40px;
            font-weight: bold;
        }

        .courseBox {
            display: flex;
            flex-direction: column;
            border-radius: 20px;
            overflow: hidden;
            background-color: white;
            height: 350px;
        }

        .contentInCourseBox {
            flex-basis: 50%;
            position: relative;
            width: 100%;
            overflow: hidden;
        }

        .editCourse {
            position: absolute;
            top: 12px;
            right: 12px;
            border-radius: 50%;
            background: #333333;
            color: white;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 9999;

            display: flex;
            visibility: hidden;

            display: flex;
            visibility: hidden;
        }

        .modal-box {
            background: white;
            padding: 25px;
            border-radius: 20px;
            width: 70%;
            max-height: 85vh;
            overflow-y: auto;
            max-height: 85vh;
            overflow-y: auto;
        }

        .modal-box label {
            font-size: 25px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 180px 20px 1fr;
            gap: 30px 8px;
            align-items: center;
            margin-top: 30px;
            margin-left: 10px;
        }

        .h-createCourseBox {
            min-height: 60%;
        }

        .input-box {
            width: 100%;
            padding: 10px 12px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }

        .textarea-box {
            height: 100px;
            resize: none;
        }

        .button-row {
            margin-top: 40px;
            margin-top: 40px;
            display: flex;
            gap: 25px;
            gap: 25px;
            justify-content: flex-end;
        }

        .image-preview-wrapper {
            position: relative;
            width: 150px;
            height: 100px;
            margin-top: 10px;
        }

        .remove-image-btn {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #333333;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            cursor: pointer;
            
            text-align:center
        }

        .image-preview {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 10px;
            border: 1px solid #dddddd;
            border: 1px solid #dddddd;
        }

        .text-description {
            padding: 20px 20px 10px 20px;
        }

        #studentTable {
            display: grid;
            grid-template-columns: 1fr 100px;
            gap: 30px;
            margin-top: 20px;
            margin-left: 10px;
        }
    </style>
    <script>
        function removeCourseImage() {
            var fileUpload = document.getElementById("<%= courseFileUpload.ClientID %>");
            var imagePreview = document.getElementById("<%= courseImage.ClientID %>");
            var wrapper = document.getElementById("<%= imagePreviewWrapper.ClientID %>");
            var isRemovedField = document.getElementById("<%= hdnIsImageRemoved.ClientID %>");

            imagePreview.src = "";
            wrapper.style.display = "none";

            fileUpload.value = "";
            fileUpload.style.display = "block";
            isRemovedField.value = "true";
        }
        function renderImagePreview(input) {
            var imagePreview = document.getElementById("<%= courseImage.ClientID %>");
            var wrapper = document.getElementById("<%= imagePreviewWrapper.ClientID %>");
            var isRemovedField = document.getElementById("<%= hdnIsImageRemoved.ClientID %>");

            if (input.files && input.files[0]) {
                isRemovedField.value = "false";
                var file = input.files[0];

                if (!file.type.startsWith("image/")) {
                    alert("Please choose an image file.");
                    input.value = "";
                    imagePreview.src = "";
                    imagePreview.style.display = "none";
                    return;
                }

                var reader = new FileReader();

                reader.onload = function (e) {
                    imagePreview.src = e.target.result;
                    wrapper.style.display = "block";
                    input.style.display = "none";
                };


                reader.readAsDataURL(file);
            }
        }
        function filterStudents() {
            var searchInput = document.getElementById('searchStudent');
            if (searchInput) {
                var filter = searchInput.value.toLowerCase().trim();
                var rows = document.querySelectorAll('.student-row');

                rows.forEach(function (row) {
                    var nameEl = row.querySelector('.student-name');
                    if (nameEl) {
                        var nameText = nameEl.textContent.toLowerCase();

                        // If student name includes the search filter, show them, otherwise hide them.
                        if (nameText.includes(filter)) {
                            row.style.display = 'contents';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="ContentPlaceHolder1">
    <div id="globalDiv">

        <div id="topDiv">
            <p>Academic Dashboard</p>
            <div id="topTopDiv">
                <asp:Label ID="welcomeMsg" runat="server" Text="Label" CssClass="welcomeMsg">Welcome Back, User
                </asp:Label>
                <asp:LinkButton ID="createCourseButton" runat="server" CssClass="createCourseButton"
                    OnClick="CreateCourseButton_Click">
                    <span class="material-symbols-outlined">add_circle</span>
                    Create Course
                </asp:LinkButton>
            </div>
        </div>

        <div id="middleDiv">
            <div style=" flex: 6; background-color: white; border-radius: 20px; padding: 20px; display: flex; flex-direction: column; align-items: center;">
                <h3 style="align-self: flex-start; margin-bottom: 10px;">Course Creation Trend</h3>
                <asp:Chart ID="Chart1" runat="server" DataSourceID="courseCreationTrend" Width="600px"
                    Height="250px">
                    <Series>
                        <asp:Series ChartType="Line" Name="Series1" XValueMember="CourseCreatedDate"
                            YValueMembers="NumCourse">
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
            </div>

            <div style="flex: 4; background-color: white; border-radius: 20px; padding: 20px;">
                <h3 style="margin-bottom: 20px;">Top Courses by Enrollment</h3>

                <div style="display: flex; flex-direction: column; gap: 15px;">
                    <asp:Repeater ID="TopExtracurricularRepeater" runat="server" DataSourceID="topExtracurricular">
                        <ItemTemplate>
                            <div style="display: flex; align-items: center; justify-content: space-between; gap: 12px; height: 30px;">
                                <span
                                    style="width: 120px; font-size: 14px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    <%# Eval("CourseName") %>
                                </span>
                                <div style="flex-grow: 1; height: 12px; background-color: #F1EDF7; border-radius: 6px; overflow: hidden; position: relative;">
                                    <div
                                        style='<%# "width: " + GetPercentage(Eval("EnrollmentCount")) + "%; background-color: #7842F5; height: 100%; border-radius: 6px;" %>'>
                                    </div>
                                </div>
                                <span style="width: 25px; text-align: right; font-weight: bold; color: #3e2548;">
                                    <%# Eval("EnrollmentCount") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Label ID="noTopCoursesMsg" runat="server" Text="No extracurricular courses found."
                        Visible="false"
                        style="color: #666; font-style: italic; text-align: center; margin-top: 10px;">
                    </asp:Label>
                </div>
            </div>

        </div>

    <div id="bottomDiv">
        <div id="topBottomDiv">
            <asp:Label ID="courseLbl" runat="server" Text="Courses You Teach"
                style="font-size: large; font-weight: 700"></asp:Label>
            <asp:Button ID="viewAllCourseBtn" runat="server" Text="View All Courses"
                OnClick="ViewAllCourseBtn_Click" />
        </div>
        <br />

        <div id="bottomBottomDiv">
            <h4 id="noCourseMsg" style="text-align: center; width:100%; grid-column: 1 / -1;" runat="server"
                visible="false">You haven't created any courses!</h4>

            <asp:Repeater ID="CourseRepeater" runat="server" DataSourceID="SqlDataSource1">
                <ItemTemplate>
                    <div class="courseBox">
                        <div class="contentInCourseBox">
                            <asp:LinkButton ID="editCourseButton" runat="server" CssClass="editCourse"
                                CommandArgument='<%# Eval("CourseID") %>' OnClick="EditCourseButton_Click">
                                <span class="material-symbols-outlined">edit</span>
                            </asp:LinkButton>
                            <img src='<%# string.IsNullOrEmpty(Convert.ToString(Eval("courseImage"))) ? "/Images/Course Icon/default course icon.png" : Eval("courseImage") %>'
                                style="object-fit:cover; height:100%; width:100%" draggable="false" />
                        </div>

                        <div class="contentInCourseBox text-description"
                            style="background-color:white; display:flex; flex-direction:column; justify-content:space-between">
                            <div>
                                <h3>
                                    <%# Eval("CourseName") %>
                                </h3>
                                <p>
                                    <%# Eval("Description") %>
                                </p>
                            </div>
                            <div style="width:100%; display:flex; justify-content:flex-end ">
                                <asp:Button ID="continueBtn" runat="server" Text="Enter"
                                    CssClass="createCourseButton" OnClick="ContinueBtn_Click"
                                    CommandArgument='<%# Eval("CourseID") %>' />
                            </div>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
    </div>
    <br />
    </div>







    <div id="courseModal" runat="server" class="modal-overlay" style="visibility: hidden;">
        <div class="modal-box">
            <asp:HiddenField ID="hiddenCourseIDs" runat="server" />
            <asp:HiddenField ID="hdnIsImageRemoved" runat="server" Value="false" />

            <h1 id="modalTitle" runat="server" style="font-size:25px">Create New Course:</h1>

            <div class="form-grid">
                <label>Course Image</label>
                <span>:</span>

                <asp:FileUpload ID="courseFileUpload" accept="image/*" runat="server"
                    CssClass="h-createCourseBox" onchange="renderImagePreview(this)" />

                <div id="imagePreviewWrapper" runat="server" class="image-preview-wrapper"
                    style="display:none;">
                    <asp:Image ID="courseImage" runat="server" draggable="false" CssClass="image-preview" />
                    <button class="remove-image-btn" type="button" onclick="removeCourseImage()">x</button>
                </div>

                <label>Course Name</label>
                <span>:</span>

                <asp:TextBox ID="courseNameTxt" runat="server" CssClass="input-box h-createCourseBox" />

                <label>Course Category</label>
                <span>:</span>

                <asp:DropDownList ID="CategoryDDL" runat="server" CssClass="h-createCourseBox">

                    <asp:ListItem></asp:ListItem>
                    <asp:ListItem>Science</asp:ListItem>
                    <asp:ListItem>Social</asp:ListItem>
                    <asp:ListItem>Extracurricular</asp:ListItem>
                </asp:DropDownList>

                <label>Description</label>
                <span>:</span>

                <asp:TextBox ID="descriptionTxt" runat="server" TextMode="MultiLine"
                    CssClass="input-box textarea-box" />
            </div>

            <div style="display: flex; justify-content: space-between; margin-top:20px">
                <h1 style="font-size:25px; margin-top:20px">Student Enrollment:</h1>
                <input type="text" id="searchStudent" placeholder="Search students by name..."
                        oninput="filterStudents()" style="height:40px; " />
            </div>

            <div id="studentTable">
                <asp:Repeater ID="studentRepeater" runat="server" DataSourceID="SqlDataSource2">
                    <ItemTemplate>
                        <div class="student-row" style="display:contents;">
                             <asp:Label ID="hiddenStudentID" runat="server" Text='<%# Eval("UserID") %>'
                                Visible="False">
                            </asp:Label>

                            <h1 class="student-name">
                                <%# Eval("Username") %>
                            </h1>
                        
                        <asp:CheckBox ID="enrollCheckBox" runat="server"
                            Checked='<%# Convert.ToBoolean(Eval("IsEnrolled")) %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="button-row">
                <asp:Button ID="removeCourseBtn" runat="server" Text="Remove Course"
                    OnClick="RemoveCourseBtn_Click" />

                <asp:Button ID="saveBtn" runat="server" Text="Save Course" OnClick="saveCourseBtn_Click" />

                <asp:Button ID="updateBtn" runat="server" Text="Update Course"
                    OnClick="updateCourseBtn_Click" />

                <asp:Button ID="cancelBtn" runat="server" Text="Cancel" OnClick="cancelBtn_Click" />
            </div>
        </div>
    </div>







    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ReadCardDB %>"
        SelectCommand="SELECT TOP 3 c.*
FROM Course c
INNER JOIN [User] creator ON c.UserID = creator.UserID
INNER JOIN [Role] currentRole ON currentRole.RoleID = (
SELECT RoleID FROM [User] WHERE UserID = @UserID
)
WHERE (currentRole.RoleName = 'SuperAdmin' OR c.UserID = @UserID)
ORDER BY c.CourseCreatedDate DESC;">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ReadCardDB %>"
        DeleteCommand="DELETE FROM [User] WHERE [UserID] = @UserID"
        InsertCommand="INSERT INTO [User] ([RoleID], [Username], [Password], [Email], [Last Login], [Last Logout]) VALUES (@RoleID, @Username, @Password, @Email, @Last_Login, @Last_Logout)"
        SelectCommand="SELECT u.Username, u.UserID,
CASE 
WHEN r.UserID IS NULL THEN 0 
ELSE 1 
END AS IsEnrolled
FROM [User] u
INNER JOIN [Role] role ON role.RoleID = u.RoleID
LEFT JOIN [Registration] r ON u.UserID = r.UserID AND r.CourseID = @CourseID
WHERE role.RoleName = 'Student'
ORDER BY u.Username ASC
" UpdateCommand="UPDATE [User] SET [RoleID] = @RoleID, [Username] = @Username, [Password] = @Password, [Email] = @Email, [Last Login] = @Last_Login, [Last Logout] = @Last_Logout WHERE [UserID] = @UserID">
        <DeleteParameters>
            <asp:Parameter Name="UserID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Last_Login" Type="DateTime" />
            <asp:Parameter Name="Last_Logout" Type="DateTime" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="hiddenCourseIDs" DefaultValue="0" Name="CourseID"
                PropertyName="Value" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Last_Login" Type="DateTime" />
            <asp:Parameter Name="Last_Logout" Type="DateTime" />
            <asp:Parameter Name="UserID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="topExtracurricular" runat="server"
        ConnectionString="<%$ ConnectionStrings:ReadCardDB %>" SelectCommand="SELECT TOP 5 
c.CourseName, 
COUNT(r.RegistrationID) AS EnrollmentCount
FROM Course c
LEFT JOIN Registration r 
ON c.CourseID = r.CourseID
INNER JOIN [User] currentUser 
ON currentUser.UserID = @UserID
INNER JOIN [Role] currentRole 
ON currentRole.RoleID = currentUser.RoleID
WHERE (currentRole.RoleName = 'SuperAdmin' OR c.UserID = @UserID)
GROUP BY c.CourseID, c.CourseName
ORDER BY EnrollmentCount DESC;">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" />
        </SelectParameters>
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="courseCreationTrend" runat="server"
        ConnectionString="<%$ ConnectionStrings:ReadCardDB %>" SelectCommand="SELECT 
c.CourseCreatedDate, 
COUNT(*) AS NumCourse
FROM Course c
INNER JOIN [User] currentUser 
ON currentUser.UserID = @UserID
INNER JOIN [Role] currentRole 
ON currentRole.RoleID = currentUser.RoleID
WHERE 
(
currentRole.RoleName = 'SuperAdmin'
OR c.UserID = @UserID
)
GROUP BY c.CourseCreatedDate
ORDER BY c.CourseCreatedDate DESC;">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" />
        </SelectParameters>
    </asp:SqlDataSource>


</asp:Content>
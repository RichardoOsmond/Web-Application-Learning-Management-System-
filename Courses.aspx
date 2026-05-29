<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="Wapping_time.courses" %> 
<%@ MasterType VirtualPath="~/Assignment.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=add_circle,draw,edit" />
    <style type="text/css">
        #globalDiv {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 10px 150px 0px 150px;
            background-color: #FDF9FF;
            height: 100%
        }

        #searchDiv {
            margin: 40px 20px 0px 20px;
            display: flex;
            justify-content: space-between
        }

        #courseDiv-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            padding: 10px 0px;
            margin-top: 10px;
            margin-bottom: 40px;
        }

        .courseBox {
            display: flex;
            flex-direction: column;
            height: 350px;
            border-radius: 20px;
            overflow: hidden;
        }

        .contentInCourseBox {
            flex-basis: 50%;
            min-height: 0;
            position: relative;
            width: 100%;
            height: 100%
        }

        .enterButton {
            background-color: #7842F5;
            color: white;
            padding: 12px 20px;
            border-radius: 100px;
            text-decoration: none;
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

        .text-description {
            padding: 20px 20px 10px 20px;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;

            display: flex;
            justify-content: center;
            align-items: center;

            visibility: hidden;
        }

        .modal-box {
            background: white;
            padding: 25px;
            border-radius: 20px;
            width: 70%;
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
            display: flex;
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
        }

        .image-preview {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 10px;
            border: 1px solid #dddddd;
        }

        #studentTable {
            display: grid;
            grid-template-columns: 1fr 100px;
            gap: 30px;
            margin-top: 20px;
            margin-left: 10px;
        }
    </style>
    <script type="text/javascript">
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="globalDiv">
        <div id="searchDiv">
            <div style="display:inline-flex; gap:10px">
                <asp:TextBox ID="SeacrhTB" runat="server" AutoPostBack="true"></asp:TextBox>
                <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" />
            </div>
            <div id="filterDiv"
                style="display:grid; grid-template-columns:100px 80px 80px 80px 1fr; column-gap:10px;">
                <label>Filtered By:</label>
                <asp:Button ID="allBtn" runat="server" Text="All" OnClick="CategoryBtn_Click" />
                <asp:Button ID="scienceBtn" runat="server" Text="Science" OnClick="CategoryBtn_Click" />
                <asp:Button ID="socialBtn" runat="server" Text="Social" OnClick="CategoryBtn_Click" />
                <asp:Button ID="extracurricularBtn" runat="server" Text="Extracurricular"
                    OnClick="CategoryBtn_Click" />
            </div>
            <asp:HiddenField ID="HiddenCategory" runat="server" Value="" />
        </div>
        <div id="courseDiv-grid">
            <asp:Repeater ID="courseRepeater" runat="server" DataSourceID="SqlDataSource1">
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
                            style="background-color:rgb(255 255 255 / var(--tw-bg-opacity, 1)); display:flex; flex-direction:column; justify-content:space-between">
                            <div>
                                <h3>
                                    <%# Eval("CourseName") %>
                                </h3>
                                <p>
                                    <%# Eval("Description") %>
                                </p>
                            </div>
                            <div style="width:100%; display:flex; justify-content:flex-end ">
                                <asp:Button ID="continueBtn" runat="server" Text="Enter" CssClass="enterButton"
                                    OnClick="ContinueBtn_Click" CommandArgument='<%# Eval("CourseID") %>' />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                ConnectionString="<%$ ConnectionStrings:ReadCardDB %>"
                DeleteCommand="DELETE FROM [Course] WHERE [CourseID] = @CourseID"
                InsertCommand="INSERT INTO [Course] ([UserID], [CourseName], [Description], [CourseCreatedDate], [CourseImage], [CourseCategory]) VALUES (@UserID, @CourseName, @Description, @CourseCreatedDate, @CourseImage, @CourseCategory)"
                SelectCommand="SELECT c.*
FROM [Course] c
INNER JOIN [User] currentUser 
ON currentUser.UserID = @UserID
INNER JOIN [Role] currentRole 
ON currentRole.RoleID = currentUser.RoleID
WHERE (currentRole.RoleName = 'SuperAdmin' OR c.UserID = @UserID)
AND c.CourseName LIKE '%' + @SearchText + '%' 
AND (@Category = '' OR c.CourseCategory = @Category) 
ORDER BY c.CourseCreatedDate DESC;"
                UpdateCommand="UPDATE [Course] SET [UserID] = @UserID, [CourseName] = @CourseName, [Description] = @Description, [CourseCreatedDate] = @CourseCreatedDate, [CourseImage] = @CourseImage, [CourseCategory] = @CourseCategory WHERE [CourseID] = @CourseID">
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
                <SelectParameters>
                    <asp:ControlParameter ControlID="SeacrhTB" Name="SearchText" PropertyName="Text" Type="String"
                        ConvertEmptyStringToNull="false" DefaultValue="" />
                    <asp:ControlParameter ControlID="HiddenCategory" Name="Category" PropertyName="Value"
                        Type="String" ConvertEmptyStringToNull="false" DefaultValue="" />
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                </SelectParameters>
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







    <div id="editCourseModal" runat="server" class="modal-overlay" style="visibility: hidden;">
        <div class="modal-box">
            <asp:HiddenField ID="hiddenCourseIDs" runat="server" />
            <asp:HiddenField ID="hdnIsImageRemoved" runat="server" Value="false" />

            <h1 style="font-size:25px">Edit Course:</h1>

            <div class="form-grid">
                <label>Course Image</label>
                <span>:</span>
                <asp:FileUpload ID="courseFileUpload" accept="image/*" runat="server"
                    CssClass="h-createCourseBox" />

                <div id="imagePreviewWrapper" runat="server" class="image-preview-wrapper" style="display:none;">
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
                <h1 style="font-size:25px;">Student Enrollment:</h1>
                <input type="text" id="searchStudent" placeholder="Search students by name..."
                    oninput="filterStudents()" style="height:40px; " />
            </div>

            <div id="studentTable">
                <asp:Repeater ID="studentRepeater" runat="server" DataSourceID="SqlDataSource2">
                    <ItemTemplate>
                        <div class="student-row" style="display:contents">
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

                <asp:Button ID="updateBtn" runat="server" Text="Update Course" OnClick="UpdateCourseBtn_Click" />

                <asp:Button ID="cancelBtn" runat="server" Text="Cancel" OnClick="CancelBtn_Click" />
            </div>
        </div>
    </div>

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
</asp:Content>
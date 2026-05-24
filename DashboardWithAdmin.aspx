<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="DashboardWithAdmin.aspx.cs" Inherits="Wapping_time.DashboardWithAdmin" MaintainScrollPositionOnPostBack="true" %>
<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=add_circle,draw,edit" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=groups" />
    <style type="text/css">
        #globalDiv{
            display:flex;
            flex-direction:column;
            gap:20px;
            padding:10px 125px 0px 125px;
            background-color:#FDF9FF;
            height:100%
        }
        #topDiv{
            display:flex;
            flex-direction:column;
            gap:5px;
            margin-top:10px;
            margin-bottom:20px;
        }
        #topTopDiv {
            display: flex;
            flex-direction: row;
            justify-content: space-between
        }
        .createCourseButton{
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            padding: 12px 20px;
            border-radius: 100px;
            text-decoration:none;
            background-color:#7842F5;
        }
        #middleDiv {
            display:flex;
            flex-direction: row;
            height:200px;
            gap:25px
        }
        .smallMiddleBox{
            border-radius:30px; 
            background-color:rgb(255 255 255 / var(--tw-bg-opacity, 1));  
            justify-items:center;
            padding:20px 30px;
            gap:10px;
            flex:1;
        }
        #leftMiddleDiv{
            background-color: #7842f5;
            flex:7;
        }
        #rightMiddleDiv{
            flex:3;
            display: flex;
            flex-direction:column;
            align-items:flex-end;
            gap:20px
        }
        #topBottomDiv{
            display:flex;
            flex-direction: row;
            justify-content: space-between
        }
        #bottomBottomDiv {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            padding: 10px 0px;
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
        .bg-primary {
            --tw-bg-opacity: 1;
            background-color: rgb(138 43 226 / var(--tw-bg-opacity, 1)); 
        }
        .w-\[85\%\] {
            width: 85%;
        }
        #totalStudents{
            display:flex;
            flex-direction:column;
            width:100%
        }
        .h-full {
            height: 100%;
            min-height:5px;
        }
        #group-icon{
            color: #5b20a8;
            background-color: #e6c2ff;
            border-radius: 50%;
            height: 50px;
            width: 52px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .bg-surface-variant {
            --tw-bg-opacity: 1;
            background-color: rgb(245 209 255 / var(--tw-bg-opacity, 1));
        }
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 9999;

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
        }
        .modal-box label{
            font-size:25px;
        }
        .form-grid {
            display: grid;  
            grid-template-columns: 180px 20px 1fr;  
            gap: 30px 8px;  
            align-items: center;  
            margin-top:30px;
            margin-left:10px;
        }
        .h-createCourseBox{
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

        .image-preview {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 10px;
            border: 1px solid #dddddd;
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
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .text-description{
            padding:20px 20px 10px 20px;
        }
        #studentTable{
            display:grid;
            grid-template-columns: 1fr 100px;
            gap: 30px;
            margin-top:20px;
            margin-left:10px;
        }
    </style>
    <script>
        function openCreateCoursePopup() {
            document.getElementById("createCourseModal").style.visibility = "visible";
            document.getElementById("removeCourseBtn").style.display = "none";
            document.body.style.overflow = "hidden";
        }

        function openEditCoursePopup(courseID, courseName, description, category) {
            document.getElementById("hiddenCourseIDs").value = courseID;
            document.getElementById("courseNameTxt").value = courseName;
            document.getElementById("descriptionTxt").value = description;
            document.getElementById("CategoryDDL").value = category;

            document.getElementById("createCourseModal").style.visibility = "visible";
            document.body.style.overflow = "hidden";
        }


        function closeCreateCoursePopup() {
            document.getElementById("createCourseModal").style.visibility = "hidden";
            document.body.style.overflow = "";

            document.getElementById("courseNameTxt").value = "";
            document.getElementById("descriptionTxt").value = "";
            document.getElementById("CategoryDDL").selectedIndex = 0;
            document.getElementById("hiddenCourseIDs").value = "";

            removeCourseImage();
        }

        function removeCourseImage() {
            var fileUpload = document.getElementById("courseFileUpload");
            var preview = document.getElementById("courseImagePreview");
            var wrapper = document.getElementById("imagePreviewWrapper");

            fileUpload.value = "";
            preview.src = "";
            wrapper.style.display = "none";
            fileUpload.style.display = "block";
        }

        function previewCourseImage(input) {
            var preview = document.getElementById("courseImagePreview");

            if (input.files && input.files[0]) {
                var file = input.files[0];

                if (!file.type.startsWith("image/")) {
                    alert("Please choose an image file.");
                    input.value = "";
                    preview.style.display = "none";
                    return;
                }

                var reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    document.getElementById("imagePreviewWrapper").style.display = "block";
                    document.getElementById("courseFileUpload").style.display = "none";
                };


                reader.readAsDataURL(input.files[0]);
            }
        }

        function removeCourseImage() {
            var fileUpload = document.getElementById("courseFileUpload");
            var preview = document.getElementById("courseImagePreview");
            var wrapper = document.getElementById("imagePreviewWrapper");

            fileUpload.value = "";
            preview.src = "";
            wrapper.style.display = "none";
            fileUpload.style.display = "block";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="ContentPlaceHolder1">

    <div id="globalDiv">
        
        <div id="topDiv">
            <p>Academic Dashboard</p>
            <div id="topTopDiv">
                <h1 style="font-size:40px">Welcome Back, Julian</h1>
                <asp:LinkButton ID="createCourseButton" runat="server" CssClass="createCourseButton"  OnClientClick="openCreateCoursePopup(); return false;" OnClick="CreateCourseButton_Click">
                    <span class="material-symbols-outlined">add_circle</span>
                    Create Course
                </asp:LinkButton>         
            </div>
        </div>
 
        <div id="middleDiv">
            <div id="leftMiddleDiv">
                <p>loren lkjljll</p>
            </div>

            <div  id="rightMiddleDiv">
                <div id="totalStudents" class="smallMiddleBox">
                    <div style="display:inline-flex; align-items:center; gap:20px;">
                        <span id="group-icon" class="material-symbols-rounded">groups</span>
                        <div style="flex:7; padding-right:100px">
                            <p style="font-size: small; color: #3e2548; margin-bottom:5px">Total Enrolled Students</p>
                            <h3>2098</h3>
                        </div>
                    </div>
                    <div class="h-2 bg-surface-variant">
                        <div class="h-full bg-primary w-[85%] rounded-full"></div>
                    </div>
                </div>
                
                <div style="display:flex; width:100%; gap:20px">
                    <div class="smallMiddleBox">
                        <p>Graduate Rate</p>
                        <h3 style="color:#3e2548">92.4%</h3>
                    </div>
                    <div class="smallMiddleBox">
                        <p>Avg. Rate</p>
                        <h3 style="color:#3e2548">4.85</h3>
                    </div>
                </div>
            </div>
        </div>
        <div style="display: flex; gap: 25px; width: 100%; margin-top: 20px; margin-bottom: 20px; align-items: stretch;">
            
            <div style="flex: 6; background-color: rgb(255 255 255 / var(--tw-bg-opacity, 1)); border-radius: 20px; padding: 20px; display: flex; flex-direction: column; align-items: center;">
                <h3 style="align-self: flex-start; margin-bottom: 10px;">Course Creation Trend</h3>
                
                <asp:Chart ID="Chart1" runat="server" DataSourceID="SqlDataSource1" Width="600px" Height="250px">
                    <series>
                        <asp:Series ChartType="Line" Name="Series1" XValueMember="CourseCreatedDate" YValueMembers="CourseID">
                        </asp:Series>
                    </series>
                    <chartareas>
                        <asp:ChartArea Name="ChartArea1"></asp:ChartArea>
                    </chartareas>
                </asp:Chart>
            </div>

            <div style="flex: 4; background-color: rgb(255 255 255 / var(--tw-bg-opacity, 1)); border-radius: 20px; padding: 20px;">
                <h3 style="margin-bottom: 20px;">Top Courses by Enrollment</h3>
                
                <div style="display: flex; flex-direction: column; gap: 15px;">
                    <div style="display: flex; align-items: center;">
                        <span style="width: 130px; font-size: 14px; font-weight: bold;">Advanced Java</span>
                        <div style="flex-grow: 1; background-color: #F5D1FF; border-radius: 5px; margin: 0 10px; height: 12px;">
                            <div style="width: 90%; background-color: #7842F5; height: 100%; border-radius: 5px;"></div>
                        </div>
                        <span style="font-weight: bold; color: #3e2548;">120</span>
                    </div>

                    <div style="display: flex; align-items: center;">
                        <span style="width: 130px; font-size: 14px; font-weight: bold;">React Native</span>
                        <div style="flex-grow: 1; background-color: #F5D1FF; border-radius: 5px; margin: 0 10px; height: 12px;">
                            <div style="width: 75%; background-color: #7842F5; height: 100%; border-radius: 5px; opacity: 0.8;"></div>
                        </div>
                        <span style="font-weight: bold; color: #3e2548;">95</span>
                    </div>

                    <div style="display: flex; align-items: center;">
                        <span style="width: 130px; font-size: 14px; font-weight: bold;">Agentic AI</span>
                        <div style="flex-grow: 1; background-color: #F5D1FF; border-radius: 5px; margin: 0 10px; height: 12px;">
                            <div style="width: 60%; background-color: #7842F5; height: 100%; border-radius: 5px; opacity: 0.6;"></div>
                        </div>
                        <span style="font-weight: bold; color: #3e2548;">80</span>
                    </div>
                </div>
            </div>
            
        </div>


        <div id="bottomDiv">
            <div id="topBottomDiv">
                <asp:Label ID="courseLbl" runat="server" Text="Courses You Teach" style="font-size: large; font-weight: 700"></asp:Label>
                <asp:Button ID="viewAllCourseBtn" runat="server" Text="View All Courses" OnClick="ViewAllCourseBtn_Click" />
                
            </div>
            <br />
            <div id="bottomBottomDiv">
                <h4 id="noCourseMsg" style="text-align: center; width:100%; grid-column: 1 / -1;" runat="server" visible="false">You haven't created any courses!</h4>

                <asp:Repeater ID="CourseRepeater" runat="server" DataSourceID="SqlDataSource1">
                    <ItemTemplate>
                        <div class="courseBox">
                            <div class="contentInCourseBox">
                                <asp:LinkButton ID="editCourseButton" runat="server" CssClass="editCourse"
                                    OnClientClick='<%# "openEditCoursePopup(" + Eval("CourseID") + ", " + "\"" + Eval("CourseName") + "\", \"" + Eval("Description") + "\", \"" + Eval("CourseCategory") + "\"); return false;" %>'>
                                    <span class="material-symbols-outlined">edit</span>
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
                                    <asp:Button ID="continueBtn" runat="server" Text="Enter" CssClass="createCourseButton" OnClick="ContinueBtn_Click" CommandArgument='<%# Eval("CourseID") %>'/>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        
        <br />
    </div>







   <div id="createCourseModal" class="modal-overlay">
        <div class="modal-box">
            <asp:HiddenField ID="hiddenCourseIDs" runat="server" ClientIDMode="Static"/>

            <h1 style="font-size:25px">Create New Course:</h1>

            <div class="form-grid">
                <label>Course Image</label>
                <span>:</span>

                <asp:FileUpload 
                    ID="courseFileUpload" 
                    ClientIDMode="Static" 
                    accept="image/*" 
                    runat="server" 
                    onchange="previewCourseImage(this)" 
                    CssClass="h-createCourseBox" />

                <div id="imagePreviewWrapper" class="image-preview-wrapper" style="display:none;">
                    <button type="button" class="remove-image-btn" onclick="removeCourseImage()">x</button>
                    <img 
                        id="courseImagePreview" 
                        src="" 
                        draggable="false" 
                        ondragstart="return false;" 
                        class="image-preview" />
                </div>

                <label>Course Name</label>
                <span>:</span>

                <asp:TextBox 
                    ID="courseNameTxt" 
                    runat="server" 
                    ClientIDMode="Static" 
                    CssClass="input-box h-createCourseBox" />

                <label>Course Category</label>
                <span>:</span>

                <asp:DropDownList 
                    ID="CategoryDDL" 
                    runat="server" 
                    ClientIDMode="Static" 
                    CssClass="h-createCourseBox">

                    <asp:ListItem></asp:ListItem>
                    <asp:ListItem>Science</asp:ListItem>
                    <asp:ListItem>Social</asp:ListItem>
                    <asp:ListItem>Extracurricular</asp:ListItem>
                </asp:DropDownList>

                <label>Description</label>
                <span>:</span>

                <asp:TextBox 
                    ID="descriptionTxt" 
                    runat="server" 
                    ClientIDMode="Static" 
                    TextMode="MultiLine" 
                    CssClass="input-box textarea-box" />
            </div>

            <h1 style="font-size:25px; margin-top:20px">Student Enrollment:</h1>

            <div id="studentTable">
                <asp:Repeater ID="studentRepeater" runat="server" DataSourceID="SqlDataSource2">
                    <ItemTemplate>
                        <asp:Label 
                            ID="hiddenStudentID" 
                            runat="server" 
                            Text='<%# Eval("UserID") %>' 
                            Visible="False">
                        </asp:Label>

                        <h1><%# Eval("Username") %></h1>

                        <asp:CheckBox 
                            ID="enrollCheckBox" 
                            runat="server" 
                            Checked='<%# Convert.ToBoolean(Eval("IsEnrolled")) %>' />
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="button-row">
                <asp:Button 
                    ID="removeCourseBtn" 
                    runat="server" 
                    ClientIDMode="Static" 
                    Text="Remove Course" 
                    OnClick="RemoveCourseBtn_Click" />

                <asp:Button 
                    ID="saveBtn" 
                    runat="server" 
                    ClientIDMode="Static" 
                    Text="Save Course" 
                    OnClick="saveCourseBtn_Click" />

                <asp:Button 
                    ID="cancelBtn" 
                    runat="server" 
                    ClientIDMode="Static" 
                    Text="Cancel" 
                    OnClick="cancelBtn_Click" 
                    OnClientClick="closeCreateCoursePopup();" />
            </div>
        </div>
    </div>







    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ReadCardDB %>" SelectCommand="SELECT TOP 3 * FROM [Course]" DeleteCommand="DELETE FROM [Course] WHERE [CourseID] = @CourseID" InsertCommand="INSERT INTO [Course] ([UserID], [CourseName], [Description], [CourseCreatedDate], [CourseImage], [CourseCategory]) VALUES (@UserID, @CourseName, @Description, GETDATE(), @CourseImage, @CourseCategory)" UpdateCommand="UPDATE [Course] SET [UserID] = @UserID, [CourseName] = @CourseName, [Description] = @Description, [CourseCreatedDate] = @CourseCreatedDate, [CourseImage] = @CourseImage WHERE [CourseID] = @CourseID">
        <DeleteParameters>
            <asp:Parameter Name="CourseID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
            <asp:ControlParameter ControlID="courseNameTxt" Name="CourseName" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="descriptionTxt" Name="Description" PropertyName="Text" Type="String" />
            <asp:Parameter Name="CourseImage" Type="String" />
            <asp:ControlParameter ControlID="CategoryDDL" Name="CourseCategory" PropertyName="SelectedValue" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="UserID" Type="Int32" />
            <asp:Parameter Name="CourseName" Type="String" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter DbType="Date" Name="CourseCreatedDate" />
            <asp:Parameter Name="CourseImage" Type="String" />
            <asp:Parameter Name="CourseID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ReadCardDB %>" DeleteCommand="DELETE FROM [User] WHERE [UserID] = @UserID" InsertCommand="INSERT INTO [User] ([RoleID], [Username], [Password], [Email], [Last Login], [Last Logout]) VALUES (@RoleID, @Username, @Password, @Email, @Last_Login, @Last_Logout)" SelectCommand="SELECT u.Username, u.UserID,
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
            <asp:ControlParameter ControlID="hiddenCourseIDs" DefaultValue="0" Name="CourseID" PropertyName="Value" />
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



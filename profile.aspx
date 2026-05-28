<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="Wapping_time.profile" %>
<%@ MasterType VirtualPath="~/Assignment.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /*page Background*/
        .profile-bg {
            min-height: calc(100vh - 70px);
            background: linear-gradient(135deg, #4a1aad 0%, #7248C8 40%, #9b6be0 70%, #5c2d91 100%);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            overflow: hidden;
        }

        /*subtle classroom texture overlay*/
        .profile-bg::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60"><rect width="60" height="60" fill="none"/><circle cx="30" cy="30" r="1" fill="rgba(255,255,255,0.06)"/></svg>') repeat;
            pointer-events: none;
        }

        /*main card*/
        .profile-card {
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(8px);
            border-radius: 16px;
            box-shadow: 0 8px 40px rgba(0,0,0,0.25);
            width: 100%;
            max-width: 620px;
            padding: 30px 36px 36px;
            position: relative;
        }

        /*back arrow*/
        .btn-back {
            position: absolute;
            top: -18px;
            left: -18px;
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #f0a500;
            color: white;
            font-size: 20px;
            display: flex; align-items: center; justify-content: center;
            text-decoration: none;
            box-shadow: 0 3px 10px rgba(0,0,0,0.25);
            transition: background 0.2s;
            z-index: 10;
        }
        .btn-back:hover { background: #d4900a; }

        /*avatar+info*/
        .profile-top {
            display: flex;
            align-items: flex-start;
            gap: 18px;
            margin-bottom: 24px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0d6f5;
        }

        .avatar-circle {
            width: 70px; height: 70px;
            border-radius: 50%;
            background: #c8c0d8;
            border: 3px solid #7248C8;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            font-size: 30px;
            color: #6a5a8a;
        }

        .user-info { flex: 1; }

        .user-info .fullname {
            font-size: 18px;
            font-weight: bold;
            color: #321075;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 3px;
        }

        .badge-student {
            font-size: 11px;
            background: #7248C8;
            color: white;
            padding: 2px 10px;
            border-radius: 20px;
            font-weight: normal;
        }

        .user-info .user-email {
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
        }

        /*view grades*/
        .grades-wrapper {
            position: relative;
            display: inline-block;
        }

        .btn-view-grades {
            font-size: 13px;
            color: #7248C8;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            text-decoration: underline;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .btn-view-grades:hover { color: #321075; }

        /*show grade*/
        .grades-popup {
            display: none;
            position: absolute;
            top: 28px;
            left: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 6px 24px rgba(50,16,117,0.25);
            border: 1px solid #e0d6f5;
            min-width: 220px;
            z-index: 100;
            padding: 6px 0;
        }
        .grades-popup.show { display: block; }

        .grades-popup table { width: 100%; border-collapse: collapse; }
        .grades-popup td {
            padding: 9px 18px;
            font-size: 14px;
            color: #333;
            border-bottom: 1px solid #f0edf8;
        }
        .grades-popup tr:last-child td { border-bottom: none; }
        .grades-popup td:last-child {
            text-align: right;
            font-weight: bold;
            color: #321075;
        }
        .grades-popup .no-grades-msg {
            padding: 14px 18px;
            font-size: 13px;
            color: #999;
            text-align: center;
        }

        /*form*/
        .form-group {
            display: flex;
            align-items: flex-start;
            margin-bottom: 14px;
            gap: 10px;
        }
        .form-group label {
            width: 100px;
            font-size: 14px;
            color: #333;
            font-weight: 600;
            flex-shrink: 0;
            padding-top: 8px;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group textarea {
            flex: 1;
            padding: 8px 12px;
            border: 1.5px solid #c8b8f0;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            transition: border 0.2s;
            font-family: Arial, sans-serif;
        }
        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #7248C8;
            outline: none;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 70px;
        }

        /*save btn*/
        .btn-save {
            display: block;
            width: 100%;
            padding: 11px;
            margin-top: 18px;
            background-color: #7248C8;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.25s;
            letter-spacing: 0.3px;
        }
        .btn-save:hover { background-color: #321075; }

        /*msg*/
        .msg { font-size: 13px; margin-top: 10px; text-align: center; display: block; }
        .msg-success { color: #27ae60; }
        .msg-error   { color: #c0392b; }

        /*validator*/
        .val-text { font-size: 12px; margin-left: 110px; margin-top: -8px; margin-bottom: 4px; }

        /*logout*/
        .btn-logout {
            margin-left: auto;
            background: none;
            border: none;
            cursor: pointer;
            padding: 6px;
            border-radius: 8px;
            transition: transform 0.2s, background 0.2s;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            align-self: flex-start;
        }
        .btn-logout img {
            width: 36px;
            height: 36px;
            object-fit: contain;
        }
        .btn-logout:hover {
            transform: scale(1.12);
            background: rgba(192, 57, 43, 0.08);
            border-radius: 8px;
        } 
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="profile-bg">
    <div class="profile-card">

        <a href='<%= Session["RoleName"].ToString() == "Admin" ? "DashboardWithAdmin.aspx" : "StudentDashboard.aspx" %>' class="btn-back">&#8592;</a>


        <div class="profile-top">
            <div class="avatar-circle">
                &#128100;
            </div>
            <div class="user-info">
                <div class="fullname">
                    <asp:Literal ID="litName" runat="server" Text="User" />
                    <span class="badge-student">Student</span>
                </div>
                <div class="user-email">
                    <asp:Literal ID="litEmail" runat="server" Text="" />
                </div>


                <div class="grades-wrapper">
                    <button type="button" class="btn-view-grades" onclick="toggleGrades()">
                        &#128065; View Grades
                    </button>
                    <div class="grades-popup" id="gradesPopup">
                        <asp:Literal ID="litGrades" runat="server" />
                    </div>
                </div>
            </div>
             <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="btn-logout" ToolTip="Logout">
                    <img src="Images/door.png" alt="Logout" />
            </asp:LinkButton>
        </div>


        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="msg"></asp:Label>

        <div class="form-group">
            <label>Username:</label>
            <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter username" />
        </div>
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
            ErrorMessage="Username is required." ForeColor="Red" Display="Dynamic"
            CssClass="val-text" ValidationGroup="vgProfile" />

        <div class="form-group">
            <label>Password:</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="New password (leave blank to keep)" />
        </div>
        <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
            ValidationExpression="^$|.{6,}" ErrorMessage="Password must be at least 6 characters."
            ForeColor="Red" Display="Dynamic" CssClass="val-text" ValidationGroup="vgProfile" />


        <div class="form-group">
            <label>Email:</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter email" />
        </div>
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
            ErrorMessage="Email is required." ForeColor="Red" Display="Dynamic"
            CssClass="val-text" ValidationGroup="vgProfile" />
        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
            ErrorMessage="Enter a valid email." ForeColor="Red" Display="Dynamic"
            CssClass="val-text" ValidationGroup="vgProfile" />


        <div class="form-group">
            <label>About You:</label>
            <asp:TextBox ID="txtAbout" runat="server" TextMode="MultiLine"
                placeholder="Tell us something about yourself..." />
        </div>


        <asp:Button ID="btnSave" runat="server" Text="Save Changes"
            CssClass="btn-save" OnClick="btnSave_Click" ValidationGroup="vgProfile" />

    </div>
</div>

<script>
    function toggleGrades() {
        var popup = document.getElementById('gradesPopup');
        popup.classList.toggle('show');
    }

    //close popup
    document.addEventListener('click', function (e) {
        var wrapper = document.querySelector('.grades-wrapper');
        if (wrapper && !wrapper.contains(e.target)) {
            document.getElementById('gradesPopup').classList.remove('show');
        }
    });
</script>
</asp:Content>

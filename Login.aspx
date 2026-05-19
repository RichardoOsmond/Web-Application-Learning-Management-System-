<%@ Page Title="Login" Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Wapping_time.login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Read Card Do Learn</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            display: flex;
            height: 100vh;
        }
        .container {
            display: flex;
            width: 100%;
            height: 100%;
        }
        .sidebar {
            background-color: #7b4fe3;
            color: white;
            width: 35%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 20px;
        }
        .sidebar h1 {
            font-size: 26px;
            margin-top: 20px;
            letter-spacing: 2px;
            line-height: 1.4;
        }
        .logo-circle {
            width: 140px;
            height: 140px;
            background: #b29de0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            font-weight: bold;
        }
        .login-section {
            width: 65%;
            background-color: #fcfaff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
        }
        .back-btn {
            position: absolute;
            top: 40px;
            left: 40px;
            font-size: 28px;
            color: #7b4fe3;
            text-decoration: none;
            font-weight: bold;
        }
        .login-box {
            width: 420px;
        }
        .login-box h2 {
            color: #3f1d82;
            font-size: 42px;
            text-align: center;
            margin-bottom: 5px;
            margin-top: 0;
        }
        .error-label {
            color: red;
            display: block;
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            color: #7b4fe3;
            font-size: 20px;
            margin-bottom: 8px;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #dcd0f7;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
            background-color: #eae1fc;
        }
        .validator-error {
            color: red;
            font-size: 13px;
            display: block;
            margin-top: 5px;
        }
        .links-group {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            margin-top: -10px;
            margin-bottom: 30px;
        }
        .links-group a {
            color: #b862bc;
            text-decoration: none;
        }
        .links-group a:hover {
            text-decoration: underline;
        }
        .btn-submit {
            width: 100%;
            background-color: #c3b1e9;
            color: #3f1d82;
            border: 2px solid #9c84cb;
            padding: 14px;
            font-size: 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.2s;
        }
        .btn-submit:hover {
            background-color: #b29de0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="sidebar">
                <div class="logo-circle">R</div>
                <h1>READ CARD<br />DO LEARN</h1>
            </div>

            <div class="login-section">
                <a href="home.aspx" class="back-btn">&larr;</a>
                
                <div class="login-box">
                    <h2>Login</h2>
                    
                    <asp:Label ID="lblMessage" runat="server" CssClass="error-label" Visible="false"></asp:Label>

                    <div class="form-group">
                        <label>Email:</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                            ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Password:</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                            ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="links-group">
                        <a href="register.aspx">Don't have an account? Register One</a>
                        <a href="forgotPassword.aspx">Forgot password?</a>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Enter" CssClass="btn-submit" OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
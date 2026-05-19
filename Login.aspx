<%@ Page Title="Login" Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Wapping_time.login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login – Read Card Do Learn</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        html, body { height: 100%; }

        .page-wrapper { display: flex; height: 100vh; }

        /* ── LEFT PURPLE PANEL ─────────────────────────── */
        .left-panel {
            width: 32%;
            background-color: #7248C8;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 30px 20px;
        }
        .logo-circle {
            width: 130px; height: 130px;
            background-color: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 18px; overflow: hidden;
        }
        .logo-circle img { width: 100px; height: auto; }
        .brand-text {
            color: white; font-size: 22px; font-weight: bold;
            text-align: center; line-height: 1.3;
            text-transform: uppercase; letter-spacing: 1px;
        }

        /* ── RIGHT PANEL ───────────────────────────────── */
        .right-panel {
            width: 68%;
            background-color: #f7f4ff;
            display: flex;
            flex-direction: column;
            padding: 30px 50px;
        }
        .back-arrow {
            font-size: 22px; color: #7248C8;
            text-decoration: none; display: inline-block;
            margin-bottom: 10px; width: fit-content;
        }
        .back-arrow:hover { color: #321075; }

        .form-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            max-width: 420px;
            margin: 0 auto;
            width: 100%;
        }
        .form-container h2 {
            color: #321075; font-size: 28px;
            margin-bottom: 30px; text-align: center;
        }

        .form-row {
            display: flex; align-items: center;
            margin-bottom: 14px; gap: 12px;
        }
        .form-row label {
            width: 90px; font-size: 14px; color: #333;
            flex-shrink: 0; text-align: right;
        }
        .form-row input[type="email"],
        .form-row input[type="password"] {
            flex: 1; padding: 8px 12px;
            border: 1.5px solid #b39ddb;
            border-radius: 6px; font-size: 14px;
            background: white; transition: border 0.3s;
        }
        .form-row input:focus { border-color: #7248C8; outline: none; }

        .validator-row { margin-left: 102px; margin-top: -8px; margin-bottom: 6px; }

        /* small helper links below fields (Forgot password / Register) */
        .helper-links {
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            margin-top: 4px;
            margin-bottom: 6px;
        }
        .helper-links a { font-size: 12px; color: #7248C8; text-decoration: none; }
        .helper-links a:hover { text-decoration: underline; }

        .btn-enter {
            display: block;
            margin: 18px auto 0;
            padding: 10px 44px;
            background-color: #c8b8f0;
            color: #321075;
            border: none; border-radius: 20px;
            font-size: 15px; font-weight: bold;
            cursor: pointer; transition: background 0.3s;
        }
        .btn-enter:hover { background-color: #b39ddb; }

        .msg-area { text-align: center; font-size: 13px; margin-top: 14px; display: block; min-height: 18px; }
        .msg-error { color: #c0392b; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="page-wrapper">

        <!-- LEFT: purple logo panel -->
        <div class="left-panel">
            <div class="logo-circle">
                <img src="Images/logo.png" alt="Read Card Do Learn Logo" />
            </div>
            <p class="brand-text">Read Card<br />Do Learn</p>
        </div>

        <!-- RIGHT: login form -->
        <div class="right-panel">
            <a href="#" class="back-arrow">&#8592;</a>

            <div class="form-container">
                <h2>Login</h2>

                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="msg-area msg-error"></asp:Label>

                <!-- Email -->
                <div class="form-row">
                    <label>Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email" />
                </div>
                <div class="validator-row">
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required." ForeColor="Red" Display="Dynamic" Font-Size="12px" />
                </div>

                <!-- Password -->
                <div class="form-row">
                    <label>Password:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" />
                </div>
                <div class="validator-row">
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required." ForeColor="Red" Display="Dynamic" Font-Size="12px" />
                </div>

                <!-- Helper links: Forgot Password + Register -->
                <div class="helper-links">
                    <a href="forgotPassword.aspx">Forgot Password?</a>
                    <a href="register.aspx">Register</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Enter"
                    CssClass="btn-enter" OnClick="btnLogin_Click" />
            </div>
        </div>

    </div>
</form>
</body>
</html>

<%@ Page Title="Login" Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Wapping_time.login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login – Read Card Do Learn</title>
    <meta charset="utf-8" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        html, body { height: 100%; background-color: #f7f4ff; overflow-x: hidden; }

        .page-wrapper { display: flex; height: 100vh; width: 100vw; }

        .left-panel { width: 35%; background-color: #7248C8; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 30px 20px; }
        .logo-circle { width: 130px; height: 130px; background-color: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 18px; overflow: hidden; }
        .logo-circle img { width: 100%; height: 100%; object-fit: cover; }
        .brand-text { color: white; font-size: 24px; font-weight: bold; text-align: center; line-height: 1.3; text-transform: uppercase; letter-spacing: 1px; }

        .right-panel { width: 65%; background-color: #f7f4ff; display: flex; flex-direction: column; padding: 40px 50px; position: relative; }
        .back-arrow { font-size: 26px; color: #7248C8; text-decoration: none; display: inline-block; position: absolute; top: 30px; left: 40px; font-weight: bold; }
        .back-arrow:hover { color: #321075; }

        .form-container { flex: 1; display: flex; flex-direction: column; justify-content: center; max-width: 440px; margin: 0 auto; width: 100%; }
        .form-container h2 { color: #321075; font-size: 36px; margin-bottom: 25px; text-align: center; font-weight: bold; }

        .form-row { display: flex; align-items: center; margin-bottom: 14px; gap: 12px; }
        .form-row label { width: 90px; font-size: 16px; color: #321075; flex-shrink: 0; text-align: right; font-weight: bold; }
        .form-row input[type="email"],
        .form-row input[type="password"],
        .form-row input[type="text"] { flex: 1; padding: 12px 15px; border: 2px solid #b39ddb; border-radius: 8px; font-size: 14px; background: white; transition: border 0.3s; }
        .form-row input:focus { border-color: #7248C8; outline: none; }

        /* Password wrapper with eye icon */
        .password-wrapper { flex: 1; position: relative; display: flex; align-items: center; }
        .password-wrapper input { width: 100%; padding: 12px 42px 12px 15px; border: 2px solid #b39ddb; border-radius: 8px; font-size: 14px; background: white; transition: border 0.3s; }
        .password-wrapper input:focus { border-color: #7248C8; outline: none; }
        .toggle-eye {
            position: absolute;
            right: 12px;
            cursor: pointer;
            user-select: none;
            font-size: 18px;
            color: #7248C8;
            line-height: 1;
        }
        .toggle-eye:hover { color: #321075; }

        .validator-row { margin-left: 102px; margin-top: -8px; margin-bottom: 6px; }

        .helper-links { display: flex; justify-content: space-between; margin-left: 102px; margin-top: 4px; margin-bottom: 20px; }
        .helper-links a { font-size: 13px; color: #7248C8; text-decoration: none; font-weight: bold; }
        .helper-links a:hover { text-decoration: underline; }

        .btn-enter { display: block; width: 100%; margin-top: 10px; padding: 14px; background-color: #c8b8f0; color: #321075; border: 2px solid #9c84cb; border-radius: 25px; font-size: 18px; font-weight: bold; cursor: pointer; transition: background 0.3s; text-align: center; }
        .btn-enter:hover { background-color: #b39ddb; }

        .msg-area { text-align: center; font-size: 14px; margin-bottom: 15px; display: block; font-weight: bold; }
        .msg-error { color: #c0392b; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="page-wrapper">
        <div class="left-panel">
            <div class="logo-circle"><img src="Images/logo.png" alt="Logo" /></div>
            <p class="brand-text">Read Card<br />Do Learn</p>
        </div>
        <div class="right-panel">
            <div class="form-container">
                <h2>Login</h2>
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="msg-area msg-error"></asp:Label>

                <div class="form-row">
                    <label>Email:</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email" />
                </div>
                <div class="validator-row">
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." ForeColor="Red" Display="Dynamic" Font-Size="12px" />
                </div>

                <div class="form-row">
                    <label>Password:</label>
                    <div class="password-wrapper">
                        <asp:TextBox ID="txtPassword" runat="server" placeholder="Enter your password" />
                        <span class="toggle-eye" id="eyeIcon" onclick="togglePassword()">&#128065;</span>
                    </div>
                </div>
                <div class="validator-row">
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." ForeColor="Red" Display="Dynamic" Font-Size="12px" />
                </div>

                <div class="helper-links">
                    <a href="register.aspx">Register An Account</a>
                    <a href="forgotPassword.aspx">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Enter" CssClass="btn-enter" OnClick="btnLogin_Click" />
            </div>
        </div>
    </div>
</form>

<script type="text/javascript">
    //set type="password" when page is load
    window.onload = function () {
        var pwdInput = document.getElementById('<%= txtPassword.ClientID %>');
        if (pwdInput) {
            pwdInput.setAttribute('type', 'password');
        }
    };

    function togglePassword() {
        var pwdInput = document.getElementById('<%= txtPassword.ClientID %>');
        var eyeIcon  = document.getElementById('eyeIcon');
        if (!pwdInput) return;

        if (pwdInput.getAttribute('type') === 'password') {
            pwdInput.setAttribute('type', 'text');
            eyeIcon.innerHTML = '&#128064;'; //eye open
        } else {
            pwdInput.setAttribute('type', 'password');
            eyeIcon.innerHTML = '&#128065;'; //eye close
        }
    }
</script>
</body>
</html>

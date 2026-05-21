<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="AddMaterialPage.aspx.cs" Inherits="Wapping_time.AddMaterialPage" ValidateRequest="false" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        .editor-container {
            width: 80%;
            margin: 30px auto; /* Centers the whole block horizontally */
            font-family: Arial, sans-serif;
            height: auto;
            min-height: 700px;
        }
        .editor-title {
            font-size: 24px;
            margin-bottom: 15px;
            color: #333;
        }
        .save-btn{
            background-color: #7842f5;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            margin-left: auto; 
            margin-right: 0;
            display: block;
        }
        .save-btn:hover {
            background-color: #5a2d9c;
        }

        .material-container{

        }

        .material-container h1{
            font-size: 36px;
            text-align: center;
            padding: 8px;
        }

        .textbox{
            text-align: center;
            display: block;
            padding: 5px;
            font-size: 24px;
        }

        .textbox label{
            color: #5a2d9c;
            display: inline-block;
            width: 240px;
            text-align: left;
            font-size: 24px;
        }

    </style>


    <script src="https://cdn.jsdelivr.net/npm/tinymce@6/tinymce.min.js" referrerpolicy="origin"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            tinymce.init({
                selector: '.tinymce-editor',
                height: 900,
                plugins: 'lists link image media table code wordcount',
                toolbar: 'undo redo | fontfamily fontsize | styles | bold italic | alignleft aligncenter alignright | image media | code',
                font_size_formats: '8pt 10pt 12pt 14pt 16pt 18pt 24pt 36pt 48pt',

                // --- IMAGE EMBEDDING CONFIGURATION ---
                relative_urls: false,
                remove_script_host: true,

                automatic_uploads: true,
                images_upload_url: 'UploadHandler.ashx',

                content_style: 'body { font-family: Helvetica,Arial,sans-serif; font-size: 16px; }'
            });
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="material-container">
        <h1>New material</h1>
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="msg-area msg-error"></asp:Label>

        <div class="textbox">
            <label>Enter Material Name:</label>
            <asp:TextBox ID="materialLbl" runat="server" placeholder="Enter name" />
        </div>
    </div>

    <div class="editor-container">
        <h2 class="editor-title">Material Content:</h2>
        <asp:TextBox ID="txtMaterialContent" runat="server" TextMode="MultiLine" CssClass="tinymce-editor" Rows="15" Width="100%"></asp:TextBox>
        <br /><br />
        <asp:Button ID="btnSave" runat="server" Text="Save Material" CssClass="save-btn" OnClick="btnSave_Click" />
    </div>
</asp:Content>

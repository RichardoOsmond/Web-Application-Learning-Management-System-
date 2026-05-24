<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="MaterialPage.aspx.cs" Inherits="Wapping_time.AddMaterialPage" ValidateRequest="false" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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

        .save-btn-container {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .save-btn{
            background-color: #7842f5;
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 24px;
            margin-left: auto;
            margin-right: 0;
            display: block;
            margin-right: 20px;
            margin-top: 20px;
            transition: background-color 0.3s, color 0.3s;
        }

        .add-btn {
            background-color: #7842f5;
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 24px;
            margin-bottom: 30px;
        }

        .save-btn:disabled,
        .add-btn:disabled {
            background-color: #cccccc !important;
            color: #666666 !important;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .save-btn:hover {
            background-color: #5a2d9c;
        }

        .form-row {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            width: 100%;
        }

        .form-row input[type="file"] {
            width: 250px;
        }

        .form-row label {
            width: auto;
            text-align: center;
            padding-top: 5px;
            font-weight: bold;
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

        .flashcard-zone-wrapper {
            position: relative;
            width: 100%;
            transition: filter 0.3s ease;
        }

        .flashcard-zone-wrapper .flashcard-overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(240, 238, 245, 0.92);
            z-index: 99;
            border-radius: 12px;
        }

        .flashcard-zone-wrapper.locked .flashcard-overlay {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .flashcard-zone-wrapper.locked #<%= flashcardSection.ClientID %> {
            filter: blur(4px);
            pointer-events: none;
        }

        .overlay-msg-box {
            background: white;
            padding: 30px 50px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
            border-top: 5px solid #7842f5;
            max-width: 500px;
        }

        .overlay-msg-box h2 {
            color: #5a2d9c;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .overlay-msg-box p {
            font-size: 18px;
            color: #555;
            line-height: 1.5;
        }

        .flashcard-header {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            align-items: center;
            width: 80%;
            margin: 30px auto;
        }

        .flashcard-header h1{
            grid-column: 2;
            font-size: 36px;
            text-align: center;
            padding: 8px;
            margin: 10px;
        }

        .header-buttons {
            grid-column: 3;       
            display: flex;
            justify-content: flex-end;
}

        .flashcard-form{
            text-align: center;
            padding: 8px;
        }

        .flashcard-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 30px;
            justify-content: center;
            width: 100%;
        }
        .flashcard {
            width: 400px;
            height: 450px;
            perspective: 1000px;
            cursor: pointer;
            padding: 8px;
            margin-bottom: 25px;
        }
        .flashcard-inner {
            width: 100%;
            height: 100%;
            transition: transform 0.6s;
            transform-style: preserve-3d;
            position: relative;
        }
        .flashcard.flipped .flashcard-inner {
            transform: rotateY(180deg);
        }

        .flashcard-front, .flashcard-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
        }
        .flashcard-front {
            background-color: #7842f5;
        }
        .flashcard-front img {
            max-width: 100%;
            max-height: 100%;
            width: auto;
            height: auto;
            object-fit: contain;
            border-radius: 10px;
        }
        .flashcard-back {
            background-color: #5a2d9c;
            color: white;
            transform: rotateY(180deg);
            text-align: center;
        }

        .flashcard-back p {
            font-size: 36px;
            margin: 0;
            color: white;
        }

        .flashcard-preview {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .card-actions {
            display: none;
            gap: 10px;
        }

        .card-actions.visible {
            display: flex;
        }

        .selected-card .flashcard-front {
            border: 15px solid #f400ff;
            border-radius: 10px;
            box-sizing: border-box;
        }

        .no-flip {
            pointer-events: none;
        }

        body {
            opacity: 0;
            transition: opacity 0.5s ease;
        }

       

    </style>

    <script type="text/javascript">
        var cardEditMode = <%=cardEditMode.ToString().ToLower()%>;;
    </script>
    <script src="https://cdn.jsdelivr.net/npm/tinymce@6/tinymce.min.js" referrerpolicy="origin"></script>

    <script>
        window.onload = function () {
            var scrollPos = sessionStorage.getItem('scrollPos');
            if (scrollPos) {
                document.documentElement.scrollTop = parseInt(scrollPos);
                sessionStorage.removeItem('scrollPos');
            }
            document.body.style.opacity = '1';
        }
        /*
        window.addEventListener('beforeunload', function (e) {
            e.preventDefault();
            e.returnValue = '';
        });
        */
        document.addEventListener("DOMContentLoaded", function () {
            var uploadPath = document.querySelector('[id$="hdnUploadPath"]').value;
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
                images_upload_url: 'UploadHandler.ashx?folder=' + uploadPath,

                content_style: 'body { font-family: Helvetica,Arial,sans-serif; font-size: 16px; } img { max-width: 100%; height: auto; }'
            });

            // Grab the HTML elements using their class names
            var nameInput = document.querySelector('.name-input');
            var saveButton = document.querySelector('[id$="btnSave"], [id$="btnExitNSave"]');
            var cardTextInput = document.querySelector('.card-text-input')
            var addCardButton = document.querySelector('[id$="btnAddCard"]')
            var cardImageUpload = document.querySelector('[id$="cardImageUpload"]');


            function toggleButtonState() {
                console.log("text:", cardTextInput.value, "files:", cardImageUpload.files.length, "cardEditMode:", cardEditMode);
                if (nameInput.value.trim() === "") {
                    saveButton.disabled = true;  // Gray out if empty
                } else {
                    saveButton.disabled = false; // Light it up if there is text
                }
                if (cardTextInput.value.trim() === "" || (cardImageUpload.files.length === 0 && cardEditMode !== true)) {
                    addCardButton.disabled = true;
                } else {
                    addCardButton.disabled = false;
                }
            }

            // Run it immediately on page load
            toggleButtonState();

            // Listen for typing events on the input field dynamically
            nameInput.addEventListener('input', toggleButtonState);
            cardTextInput.addEventListener('input', toggleButtonState);
            cardImageUpload.addEventListener('change', toggleButtonState);
        });



        function enableCardEdit() {
            document.querySelectorAll('.card-actions').forEach(function (a) {
                a.classList.add('visible');
            });
        }

        function disableCardEdit() {
            document.querySelectorAll('.card-actions').forEach(function (a) {
                a.classList.remove('visible');
            });
        }

        function saveScrollPosition() {
            sessionStorage.setItem('scrollPos', window.scrollY);
        }

        function highlightEditCard(flashcardID) {
            // hide all card actions first
            document.querySelectorAll('.card-actions').forEach(function (a) {
                a.style.display = 'none';
            });

            // find the selected card's actions and show only delete
            document.querySelectorAll('.flashcard-wrapper').forEach(function (wrapper) {
                var editBtn = wrapper.querySelector('[data-id="' + flashcardID + '"]');
                if (editBtn) {
                    var actions = wrapper.querySelector('.card-actions');
                    actions.style.display = 'flex';
                    actions.querySelector('.edit-link').style.display = 'none';
                }
            });
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hdnUploadPath" runat="server" />

    <div class="material-container">
        <h1>New material</h1>
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="msg-area msg-error"></asp:Label>

        <div class="textbox">
            <label>Enter Material Name:</label>
            <asp:TextBox ID="materialLbl" runat="server" CssClass="name-input" placeholder="Enter name" />
        </div>
    </div>

    <div class="editor-container">
        <h2 class="editor-title">Material Content:</h2>
        <asp:TextBox ID="txtMaterialContent" runat="server" TextMode="MultiLine" CssClass="tinymce-editor" Rows="15" Width="100%"></asp:TextBox>
    </div>

    <div class="flashcard-zone-wrapper <%= LockCardMode == "Add" ? "locked" : "" %>">
    
        <div class="flashcard-overlay">
            <div class="overlay-msg-box">
                <h2>Flashcards Locked</h2>
                <p>Please click <strong>"Save Material"</strong> first to start creating flashcard.</p>
            </div>
        </div>
        <asp:Panel ID="flashcardSection" runat="server">
            <div class="flashcard-container">
                <div class="flashcard-header">
                    <div></div> 
                    <h1>Flashcards</h1> 
                    <div class="header-buttons">
                        <asp:Button ID="btnEditCards" runat="server" Text="Edit Mode: Off" CssClass="add-btn" OnClick="btnEditCard_Click" OnClientClick="saveScrollPosition()" />
                        <asp:Button ID="btnDoneCards" runat="server" Text="Edit Mode: On" CssClass="add-btn" Visible="false" OnClick="btnDoneCard_Click" OnClientClick="saveScrollPosition()" />
                    </div>
                </div>
                <div class="flashcard-section">
                    <asp:Repeater ID="FlashcardRepeater" runat="server" OnItemCommand="selectFlashCard">
                        <ItemTemplate>
                            <div class="flashcard-preview <%# selectedFlashcardID > 0 && (int)Eval("FlashcardID") == selectedFlashcardID ? "selected-card" : "" %>">
                                <div class="flashcard <%# cardEditMode ? "no-flip" : "" %>" onclick="this.classList.toggle('flipped')">
                                    <div class="flashcard-inner">
                                        <div class="flashcard-front">
                                            <img src='<%# Eval("FrontImage") %>' alt="Card Image" />
                                        </div>
                                        <div class="flashcard-back">
                                            <p><%# Eval("BackText") %></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-actions">
                                    <asp:LinkButton runat="server" CommandName="EditCard" 
                                        CommandArgument='<%# Eval("FlashcardID") %>'
                                        CssClass="add-btn edit-link"
                                        Visible='<%# (int)Eval("FlashcardID") != selectedFlashcardID %>'
                                        OnClientClick="saveScrollPosition()">Edit</asp:LinkButton>
                                    <asp:LinkButton runat="server" CommandName="DeleteCard" 
                                        CommandArgument='<%# Eval("FlashcardID") %>' 
                                        CssClass="add-btn delete-link"
                                        OnClientClick="saveScrollPosition()">Delete</asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="flashcard-form" id="flashcardForm">
                    <div class="form-row">
                        <label>Front Image:</label>
                        <asp:FileUpload ID="cardImageUpload" runat="server" />
                    </div>
                    <div class="form-row">
                        <label>Back Text:</label>
                        <asp:TextBox ID="cardBackText" runat="server" TextMode="MultiLine" Rows="3" CssClass="card-text-input" />
                    </div>
                    <div class="button-row">
                        <asp:Button ID="btnAddCard" runat="server" Text="Add Card" CssClass="add-btn" OnClick="btnAddCard_Click" OnClientClick="saveScrollPosition()" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>
    <asp:Button ID="btnSave" runat="server" Text="Save Material" CssClass="save-btn" OnClick="btnSave_Click" />
    <asp:Button ID="btnExitNSave" runat="server" Text="Exit and Save Material" CssClass="save-btn" Visible="false" OnClick="btnSave_Click" />

</asp:Content>

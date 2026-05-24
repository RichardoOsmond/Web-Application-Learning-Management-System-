<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="MaterialPage.aspx.cs" Inherits="Wapping_time.AddMaterialPage" ValidateRequest="false" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/MaterialPage.css") %>" />
    <script src='<%= ResolveUrl ("~/Scripts/MaterialPage.js") %>'></script>
    <script type="text/javascript">
        var cardEditMode = <%=cardEditMode.ToString().ToLower()%>;;
    </script>
    <script src="https://cdn.jsdelivr.net/npm/tinymce@6/tinymce.min.js" referrerpolicy="origin"></script>
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

<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="ViewMaterial.aspx.cs" Inherits="Wapping_time.ViewMaterial" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="<%= ResolveUrl ("~/CSS/ViewMaterial.css") %>" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="returnBtn" runat="server" Text="Return" CssClass="return-btn" OnClick="returnBtn_Click" />
    <div class="material-container">
        <h1><asp:Label ID="lblName" runat="server" /></h1>
        <asp:Literal ID="backText" runat="server" />

        <div class="flashcard-section">
            <asp:Repeater ID="FlashcardRepeater" runat="server">
                <ItemTemplate>
                    <div class="flashcard" onclick="this.classList.toggle('flipped')">
                        <div class="flashcard-inner">
                            <div class="flashcard-front">
                                <img src='<%# Eval("FrontImage") %>' alt="Card Image" />
                            </div>
                            <div class="flashcard-back">
                                <p><%# Eval("BackText") %></p>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>

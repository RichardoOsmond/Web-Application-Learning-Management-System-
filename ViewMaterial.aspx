<%@ Page Title="" Language="C#" MasterPageFile="~/Assignment.Master" AutoEventWireup="true" CodeBehind="ViewMaterial.aspx.cs" Inherits="Wapping_time.ViewMaterial" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .material-container {
            width: 70%;
            margin: 30px auto;
            background-color: #d6c8f5;
            border-radius: 15px;
            padding: 30px;
        }
        .material-container img {
            max-width: 100%;
            height: auto;
        }
        .material-container h1 span  {
            font-size: 36px;
            color: #5a2d9c;
        }

        .material-container h1{
            text-align: center;
        }

        .flashcard-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 30px;
        }
        .flashcard {
            width: 400px;
            height: 450px;
            perspective: 1000px;
            cursor: pointer;
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
        .return-btn{
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
    </style>
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

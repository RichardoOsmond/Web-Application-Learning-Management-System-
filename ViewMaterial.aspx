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

        .material-container h1 span  {
            font-size: 36px;
            color: #5a2d9c;
        }

        .material-container h1{
            text-align: center;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="material-container">
        <h1><asp:Label ID="lblName" runat="server" /></h1>
        <asp:Literal ID="litContent" runat="server" />
    </div>
</asp:Content>

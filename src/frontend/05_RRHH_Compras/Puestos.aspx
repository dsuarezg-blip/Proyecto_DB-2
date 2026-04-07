<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Puestos.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Puestos"
         MasterPageFile="~/05_RRHH_Compras/RRHH.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Puestos</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-briefcase me-2 text-danger"></i>Puestos de Trabajo
        </h4>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Puestos Registrados
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvPuestos" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay puestos registrados."/>
        </div>
    </div>

</asp:Content>
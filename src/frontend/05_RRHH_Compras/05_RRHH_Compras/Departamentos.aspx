<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Departamentos.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Departamentos"
         MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Departamentos</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-diagram-3 me-2 text-danger"></i>Departamentos
        </h4>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Departamentos Registrados
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvDepartamentos" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay departamentos registrados."/>
        </div>
    </div>

</asp:Content>

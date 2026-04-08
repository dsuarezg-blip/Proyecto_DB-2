<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Aerolineas.aspx.vb"
         Inherits="ProyectoAeroGT.Aerolineas"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<script runat="server">



</script>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Aerolíneas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-building me-2 text-primary"></i>Gestión de Aerolíneas
        </h4>
    </div>

    <%-- FORMULARIO --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Nueva Aerolínea
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Código IATA *</label>
                    <asp:TextBox ID="txtIATA" runat="server"
                                 CssClass="form-control"
                                 MaxLength="2" placeholder="GX"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Código ICAO *</label>
                    <asp:TextBox ID="txtICAO" runat="server"
                                 CssClass="form-control"
                                 MaxLength="3" placeholder="GXG"/>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Nombre de la Aerolínea *</label>
                    <asp:TextBox ID="txtNombre" runat="server"
                                 CssClass="form-control"
                                 placeholder="Ej: Aerolínea Guatemala S.A."/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID País</label>
                    <asp:TextBox ID="txtIdPais" runat="server"
                                 CssClass="form-control" Text="1"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Sitio Web</label>
                    <asp:TextBox ID="txtWeb" runat="server"
                                 CssClass="form-control"
                                 placeholder="www.ejemplo.com"/>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <asp:Button ID="btnGuardar" runat="server"
                            Text="💾 Guardar Aerolínea"
                            CssClass="btn btn-primary"
                            OnClick="btnGuardar_Click"/>
                <asp:Button ID="btnLimpiar" runat="server"
                            Text="🔄 Limpiar"
                            CssClass="btn btn-secondary"
                            OnClick="btnLimpiar_Click"/>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <%-- TABLA --%>
    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Aerolíneas Registradas
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvAerolineas" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay aerolíneas registradas."/>
        </div>
    </div>

</asp:Content>
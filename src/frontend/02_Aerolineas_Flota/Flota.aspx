<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Flota.aspx.vb"
         Inherits="ProyectoAeroGT.Flota"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Flota
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-airplane me-2 text-primary"></i>Gestión de Flota
        </h4>
    </div>

    <%-- REGISTRAR AVION --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Nuevo Avión
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Modelo *</label>
                    <asp:TextBox ID="txtIdModelo" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Aerolínea *</label>
                    <asp:TextBox ID="txtIdAerolinea" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Matrícula *</label>
                    <asp:TextBox ID="txtMatricula" runat="server"
                                 CssClass="form-control" placeholder="TG-XXX"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Número de Serie *</label>
                    <asp:TextBox ID="txtNumSerie" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Año Fabricación *</label>
                    <asp:TextBox ID="txtAnnoFab" runat="server"
                                 CssClass="form-control" placeholder="2020"/>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <asp:Button ID="btnRegistrarAvion" runat="server"
                            Text="✈ Registrar Avión"
                            CssClass="btn btn-primary"
                            OnClick="btnRegistrarAvion_Click"/>
                <asp:Button ID="btnLimpiarFlota" runat="server"
                            Text="🔄 Limpiar"
                            CssClass="btn btn-secondary"
                            OnClick="btnLimpiarFlota_Click"/>
            </div>
            <asp:Label ID="lblMensajeFlota" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <%-- CAMBIAR ESTADO --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-arrow-repeat me-2"></i>Cambiar Estado de Avión
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Avión *</label>
                    <asp:TextBox ID="txtIdAvionEstado" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Nuevo Estado *</label>
                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                        <asp:ListItem Value="OPERATIVO">OPERATIVO</asp:ListItem>
                        <asp:ListItem Value="EN_MANTENIMIENTO">EN MANTENIMIENTO</asp:ListItem>
                        <asp:ListItem Value="EN_REPARACION">EN REPARACIÓN</asp:ListItem>
                        <asp:ListItem Value="EN_INSPECCION">EN INSPECCIÓN</asp:ListItem>
                        <asp:ListItem Value="RETIRADO">RETIRADO</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Motivo</label>
                    <asp:TextBox ID="txtMotivo" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnCambiarEstado" runat="server"
                                Text="🔄 Cambiar Estado"
                                CssClass="btn btn-warning"
                                OnClick="btnCambiarEstado_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensajeEstado" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <%-- TABLA FLOTA --%>
    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Flota Registrada
        </div>
        <div class="card-body">
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Filtrar por ID Aerolínea</label>
                    <asp:TextBox ID="txtFiltroAerolinea" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnFiltrar" runat="server"
                                Text="🔍 Filtrar"
                                CssClass="btn btn-primary"
                                OnClick="btnFiltrar_Click"/>
                    <asp:Button ID="btnVerTodos" runat="server"
                                Text="Ver Todos"
                                CssClass="btn btn-secondary ms-2"
                                OnClick="btnVerTodos_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvFlota" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay aviones registrados."/>
        </div>
    </div>

</asp:Content>
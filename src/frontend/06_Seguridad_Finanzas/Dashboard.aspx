<%@ Page Title="Dashboard" Language="VB" MasterPageFile="~/06_Seguridad_Finanzas/Site.Master" AutoEventWireup="false" CodeFile="Dashboard.aspx.vb" Inherits="Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Dashboard</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="container-fluid px-4 py-3">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-0" style="color:#0d2040;">
                <i class="bi bi-speedometer2 me-2" style="color:#c5a059;"></i>Dashboard
            </h2>
            <p class="text-muted mb-0">
                Bienvenido, <asp:Label ID="lblBienvenida" runat="server" CssClass="fw-semibold"></asp:Label>
                &nbsp;|&nbsp; Rol: <asp:Label ID="lblRolBadge" runat="server"></asp:Label>
            </p>
        </div>
        <span class="text-muted small"><i class="bi bi-calendar3 me-1"></i><asp:Label ID="lblFecha" runat="server"></asp:Label></span>
    </div>

    <asp:Panel ID="pnlAdmin" runat="server" Visible="false">
        <div class="row g-3 mb-4">
            <div class="col-12">
                <h5 class="text-secondary fw-bold"><i class="bi bi-grid-3x3-gap me-2"></i>Módulos del Sistema</h5>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100" style="border-left: 4px solid #c5a059 !important;">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center me-3" style="width:48px;height:48px;background:#fff8ee;">
                                <i class="bi bi-building fs-4" style="color:#c5a059;"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Infraestructura</h6>
                                <small class="text-muted">Aeropuertos y zonas</small>
                            </div>
                        </div>
                        <div class="list-group list-group-flush">
                            <a href="/01_Infraestructura/frmAeropuertos.aspx" class="list-group-item list-group-item-action border-0 px-0 py-1 small"><i class="bi bi-geo-alt me-2 text-primary"></i>Aeropuertos</a>
                            <a href="/01_Infraestructura/frmPistas.aspx" class="list-group-item list-group-item-action border-0 px-0 py-1 small"><i class="bi bi-arrows-expand me-2 text-primary"></i>Pistas</a>
                            <a href="/01_Infraestructura/frmHangares.aspx" class="list-group-item list-group-item-action border-0 px-0 py-1 small"><i class="bi bi-house-gear me-2 text-primary"></i>Hangares</a>
                            <a href="/01_Infraestructura/frmPlataformas.aspx" class="list-group-item list-group-item-action border-0 px-0 py-1 small"><i class="bi bi-square me-2 text-primary"></i>Plataformas</a>
                            <a href="/01_Infraestructura/frmCallesRodaje.aspx" class="list-group-item list-group-item-action border-0 px-0 py-1 small"><i class="bi bi-signpost-split me-2 text-primary"></i>Calles de Rodaje</a>
                            <a href="/01_Infraestructura/frmTerminales.aspx" class="list-group-item list-group-item-action border-0 px-0 py-1 small"><i class="bi bi-building-fill me-2 text-primary"></i>Terminales</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100 opacity-50">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center me-3" style="width:48px;height:48px;background:#eef3ff;">
                                <i class="bi bi-airplane fs-4 text-primary"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Aerolíneas y Flota</h6>
                                <small class="text-muted">En desarrollo</small>
                            </div>
                        </div>
                        <span class="badge bg-secondary">Próximamente</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100 opacity-50">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center me-3" style="width:48px;height:48px;background:#eeffee;">
                                <i class="bi bi-people fs-4 text-success"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Pasajeros</h6>
                                <small class="text-muted">En desarrollo</small>
                            </div>
                        </div>
                        <span class="badge bg-secondary">Próximamente</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm h-100 opacity-50">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center me-3" style="width:48px;height:48px;background:#ffeeee;">
                                <i class="bi bi-calendar-event fs-4 text-danger"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-0">Operaciones</h6>
                                <small class="text-muted">En desarrollo</small>
                            </div>
                        </div>
                        <span class="badge bg-secondary">Próximamente</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-12">
                <h5 class="text-secondary fw-bold"><i class="bi bi-bar-chart me-2"></i>Resumen del Sistema</h5>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center py-3">
                    <i class="bi bi-geo-alt-fill fs-1 mb-2" style="color:#c5a059;"></i>
                    <h3 class="fw-bold mb-0"><asp:Label ID="lblTotalAeropuertos" runat="server" Text="--"></asp:Label></h3>
                    <small class="text-muted">Aeropuertos registrados</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center py-3">
                    <i class="bi bi-arrows-expand fs-1 mb-2 text-primary"></i>
                    <h3 class="fw-bold mb-0"><asp:Label ID="lblTotalPistas" runat="server" Text="--"></asp:Label></h3>
                    <small class="text-muted">Pistas registradas</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center py-3">
                    <i class="bi bi-people-fill fs-1 mb-2 text-success"></i>
                    <h3 class="fw-bold mb-0"><asp:Label ID="lblTotalUsuarios" runat="server" Text="--"></asp:Label></h3>
                    <small class="text-muted">Usuarios activos</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm text-center py-3">
                    <i class="bi bi-shield-check-fill fs-1 mb-2 text-danger"></i>
                    <h3 class="fw-bold mb-0">OK</h3>
                    <small class="text-muted">Estado del sistema</small>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlUsuario" runat="server" Visible="false">
        <div class="row g-3">
            <div class="col-12">
                <h5 class="text-secondary fw-bold"><i class="bi bi-grid me-2"></i>Accesos disponibles</h5>
            </div>
            <div class="col-md-4">
                <a href="/01_Infraestructura/frmAeropuertos.aspx" class="text-decoration-none">
                    <div class="card border-0 shadow-sm h-100 text-center py-4">
                        <i class="bi bi-geo-alt-fill fs-1 mb-3" style="color:#c5a059;"></i>
                        <h6 class="fw-bold">Consultar Aeropuertos</h6>
                        <small class="text-muted">Ver directorio de aeropuertos</small>
                    </div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="/01_Infraestructura/frmPistas.aspx" class="text-decoration-none">
                    <div class="card border-0 shadow-sm h-100 text-center py-4">
                        <i class="bi bi-arrows-expand fs-1 mb-3 text-primary"></i>
                        <h6 class="fw-bold">Consultar Pistas</h6>
                        <small class="text-muted">Ver pistas por aeropuerto</small>
                    </div>
                </a>
            </div>
        </div>
    </asp:Panel>

</div>
</asp:Content>

<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Dashboard.aspx.vb"
         Inherits="ProyectoAeroGT.Dashboard"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Dashboard</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-speedometer2 me-2 text-primary"></i>
            Dashboard — Módulo 2: Aerolíneas & Flota
        </h4>
    </div>

    <%-- STATS --%>
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100"
                 style="border-left: 4px solid #1e88e5 !important;">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small text-uppercase fw-semibold">
                                Aerolíneas Activas
                            </div>
                            <div class="fs-2 fw-bold text-dark">
                                <asp:Label ID="lblTotalAerolineas" runat="server" Text="—"/>
                            </div>
                        </div>
                        <i class="bi bi-building fs-1 text-primary opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100"
                 style="border-left: 4px solid #2e7d32 !important;">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small text-uppercase fw-semibold">
                                Aviones Operativos
                            </div>
                            <div class="fs-2 fw-bold text-dark">
                                <asp:Label ID="lblAvionesOperativos" runat="server" Text="—"/>
                            </div>
                        </div>
                        <i class="bi bi-airplane fs-1 text-success opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100"
                 style="border-left: 4px solid #f57f17 !important;">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small text-uppercase fw-semibold">
                                En Mantenimiento
                            </div>
                            <div class="fs-2 fw-bold text-dark">
                                <asp:Label ID="lblEnMantenimiento" runat="server" Text="—"/>
                            </div>
                        </div>
                        <i class="bi bi-tools fs-1 text-warning opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm h-100"
                 style="border-left: 4px solid #c62828 !important;">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small text-uppercase fw-semibold">
                                Certs. por Vencer
                            </div>
                            <div class="fs-2 fw-bold text-dark">
                                <asp:Label ID="lblCertsVencer" runat="server" Text="—"/>
                            </div>
                        </div>
                        <i class="bi bi-patch-exclamation fs-1 text-danger opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- ACCESOS RAPIDOS --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-lightning me-2"></i>Accesos Rápidos
        </div>
        <div class="card-body d-flex gap-2 flex-wrap">
            <a href="Aerolineas.aspx" class="btn btn-outline-primary">
                <i class="bi bi-building me-1"></i>Aerolíneas
            </a>
            <a href="Flota.aspx" class="btn btn-outline-primary">
                <i class="bi bi-airplane me-1"></i>Registrar Avión
            </a>
            <a href="Mantenimiento.aspx" class="btn btn-outline-warning">
                <i class="bi bi-tools me-1"></i>Mantenimiento
            </a>
            <a href="Certificados.aspx" class="btn btn-outline-danger">
                <i class="bi bi-patch-check me-1"></i>Certificados
            </a>
            <a href="Proveedores.aspx" class="btn btn-outline-secondary">
                <i class="bi bi-truck me-1"></i>Proveedores
            </a>
            <a href="Reportes.aspx" class="btn btn-outline-info">
                <i class="bi bi-bar-chart me-1"></i>Reportes
            </a>
        </div>
    </div>

    <%-- RESUMEN FLOTA --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Resumen de Flota por Aerolínea
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvResumen" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true" GridLines="None"
                          EmptyDataText="Sin datos — enciende la VM de Oracle."/>
        </div>
    </div>

    <%-- ALERTAS --%>
    <div class="card card-mod">
        <div class="card-header card-header-mod" style="background:#b71c1c;">
            <i class="bi bi-exclamation-triangle me-2"></i>
            Certificados por Vencer en los próximos 30 días
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvAlertas" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true" GridLines="None"
                          EmptyDataText="✅ No hay certificados por vencer."/>
        </div>
    </div>

</asp:Content>
<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Reportes.aspx.vb"
         Inherits="ProyectoAeroGT.Reportes"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Reportes</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-bar-chart me-2 text-primary"></i>Reportes del Módulo 2
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-funnel me-2"></i>Seleccionar Reporte
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Tipo de Reporte</label>
                    <asp:DropDownList ID="ddlReporte" runat="server" CssClass="form-select">
                        <asp:ListItem Value="FLOTA_GENERAL">Flota General por Aerolínea</asp:ListItem>
                        <asp:ListItem Value="AVIONES_ESTADO">Aviones por Estado</asp:ListItem>
                        <asp:ListItem Value="MANTENIMIENTOS">Mantenimientos por Período</asp:ListItem>
                        <asp:ListItem Value="ESTADISTICAS">Estadísticas de Flota</asp:ListItem>
                        <asp:ListItem Value="CERTS_VENCER">Certificados por Vencer</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Estado (filtro)</label>
                    <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select">
                        <asp:ListItem Value="">TODOS</asp:ListItem>
                        <asp:ListItem Value="OPERATIVO">OPERATIVO</asp:ListItem>
                        <asp:ListItem Value="EN_MANTENIMIENTO">EN MANTENIMIENTO</asp:ListItem>
                        <asp:ListItem Value="EN_REPARACION">EN REPARACIÓN</asp:ListItem>
                        <asp:ListItem Value="RETIRADO">RETIRADO</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fecha Inicio</label>
                    <asp:TextBox ID="txtFechaIni" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fecha Fin</label>
                    <asp:TextBox ID="txtFechaFin" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
                <div class="col-md-1">
                    <label class="form-label fw-semibold">Días alerta</label>
                    <asp:TextBox ID="txtDiasRep" runat="server"
                                 CssClass="form-control" Text="30"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnGenerarReporte" runat="server"
                                Text="📊 Generar"
                                CssClass="btn btn-primary"
                                OnClick="btnGenerarReporte_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensajeRep" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>
            <asp:Label ID="lblTituloReporte" runat="server" Text="Resultado"/>
            <span class="badge bg-light text-dark ms-2">
                <asp:Label ID="lblTotalRegistros" runat="server" Text="0"/> registros
            </span>
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvReporte" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true" GridLines="None"
                          EmptyDataText="No hay datos para mostrar."/>
        </div>
    </div>

</asp:Content>
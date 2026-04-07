<%@ Page Title="Reportes RRHH" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="Reportes.aspx.vb" Inherits="Reportes" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .report-card { background:#1a1a2e;border:1px solid #2a2a4a;border-radius:8px;padding:1.2rem;cursor:pointer;transition:border-color .2s; }
        .report-card:hover { border-color:#e94560; }
        .report-card .icon { font-size:2rem;margin-bottom:.5rem; }
        .report-card h6 { color:#fff;margin-bottom:.25rem; }
        .report-card p  { color:#9ca3af;font-size:.82rem;margin:0; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="mb-4">
    <h2 class="mb-1"><i class="bi bi-bar-chart-line me-2" style="color:#e94560;"></i>Reportes RRHH</h2>
    <p class="text-muted">Los reportes se ejecutan contra la base de datos réplica (172.16.10.20)</p>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<%-- SELECTOR --%>
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="report-card" onclick="seleccionarReporte('plantilla')">
            <div class="icon text-danger"><i class="bi bi-people-fill"></i></div>
            <h6>Plantilla Completa</h6>
            <p>Todos los empleados con contrato activo</p>
        </div>
    </div>
    <div class="col-md-3">
        <div class="report-card" onclick="seleccionarReporte('asistencia')">
            <div class="icon text-warning"><i class="bi bi-calendar-check"></i></div>
            <h6>Asistencia Mensual</h6>
            <p>Presentes, ausentes y permisos</p>
        </div>
    </div>
    <div class="col-md-3">
        <div class="report-card" onclick="seleccionarReporte('licencias')">
            <div class="icon" style="color:#e94560;"><i class="bi bi-card-checklist"></i></div>
            <h6>Licencias por vencer</h6>
            <p>Pilotos con licencia próxima a vencer</p>
        </div>
    </div>
    <div class="col-md-3">
        <div class="report-card" onclick="seleccionarReporte('viaticos')">
            <div class="icon text-info"><i class="bi bi-cash-stack"></i></div>
            <h6>Viáticos pendientes</h6>
            <p>Solicitudes sin liquidar</p>
        </div>
    </div>
</div>

<%-- PARÁMETROS --%>
<div class="card mb-4" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-header" style="background:#12122a;color:#e0e0e0;">
        <i class="bi bi-sliders me-2" style="color:#e94560;"></i>Parámetros del reporte
    </div>
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <asp:Panel ID="pnlParamEmpleado" runat="server" CssClass="col-md-4" Visible="false">
                <label class="form-label text-light">Empleado</label>
                <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
            </asp:Panel>
            <asp:Panel ID="pnlParamDepto" runat="server" CssClass="col-md-4" Visible="false">
                <label class="form-label text-light">Departamento</label>
                <asp:DropDownList ID="ddlDepto" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
            </asp:Panel>
            <asp:Panel ID="pnlParamFecha" runat="server" CssClass="col-md-4" Visible="false">
                <label class="form-label text-light">Mes / Año</label>
                <div class="row g-2">
                    <div class="col-6">
                        <asp:DropDownList ID="ddlMes" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="1">Enero</asp:ListItem><asp:ListItem Value="2">Febrero</asp:ListItem>
                            <asp:ListItem Value="3">Marzo</asp:ListItem><asp:ListItem Value="4">Abril</asp:ListItem>
                            <asp:ListItem Value="5">Mayo</asp:ListItem><asp:ListItem Value="6">Junio</asp:ListItem>
                            <asp:ListItem Value="7">Julio</asp:ListItem><asp:ListItem Value="8">Agosto</asp:ListItem>
                            <asp:ListItem Value="9">Septiembre</asp:ListItem><asp:ListItem Value="10">Octubre</asp:ListItem>
                            <asp:ListItem Value="11">Noviembre</asp:ListItem><asp:ListItem Value="12">Diciembre</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-6">
                        <asp:TextBox ID="txtAnio" runat="server" CssClass="form-control bg-dark text-light border-secondary" TextMode="Number" placeholder="Año" />
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlParamDias" runat="server" CssClass="col-md-3" Visible="false">
                <label class="form-label text-light">Umbral días</label>
                <asp:TextBox ID="txtDias" runat="server" CssClass="form-control bg-dark text-light border-secondary" TextMode="Number" Text="90" />
            </asp:Panel>
            <div class="col-md-2">
                <asp:HiddenField ID="hfReporte" runat="server" />
                <asp:Button ID="btnEjecutar" runat="server" Text="Ejecutar" CssClass="btn btn-danger w-100" OnClick="btnEjecutar_Click" />
            </div>
        </div>
    </div>
</div>

<%-- RESULTADO --%>
<asp:Panel ID="pnlResultado" runat="server" Visible="false">
    <div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
        <div class="card-header d-flex justify-content-between align-items-center" style="background:#12122a;color:#e0e0e0;">
            <span><i class="bi bi-table me-2"></i><asp:Label ID="lblTituloResultado" runat="server" /></span>
            <span class="badge bg-secondary"><asp:Label ID="lblTotalRegistros" runat="server" /> registros</span>
        </div>
        <div class="card-body p-0" style="overflow-x:auto;">
            <asp:GridView ID="gvResultado" runat="server" AutoGenerateColumns="true"
                CssClass="table table-dark table-sm table-hover mb-0" GridLines="None"
                EmptyDataText="El reporte no devolvió resultados.">
                <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
                <HeaderStyle Style="background:#0f0f1e;color:#e94560;" />
            </asp:GridView>
        </div>
    </div>
</asp:Panel>

<script>
    function seleccionarReporte(tipo) {
        document.getElementById('<%= hfReporte.ClientID %>').value = tipo;
        document.querySelectorAll('.report-card').forEach(c => c.style.borderColor = '');
        event.currentTarget.style.borderColor = '#e94560';
        __doPostBack('<%= btnEjecutar.UniqueID %>', 'select:' + tipo);
    }
</script>

</asp:Content>

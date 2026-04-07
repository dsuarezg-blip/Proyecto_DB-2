<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Dashboard.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.DashboardRRHH"
         MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Dashboard RRHH</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-speedometer2 me-2 text-danger"></i>
            Dashboard — Módulo 3: Recursos Humanos
        </h4>
    </div>

    <%-- ACCESOS RAPIDOS --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-lightning me-2"></i>Accesos Rápidos
        </div>
        <div class="card-body d-flex gap-2 flex-wrap">
            <a href="Empleados.aspx" class="btn btn-outline-danger">
                <i class="bi bi-people me-1"></i>Empleados
            </a>
            <a href="Contratos.aspx" class="btn btn-outline-danger">
                <i class="bi bi-file-earmark-text me-1"></i>Contratos
            </a>
            <a href="Departamentos.aspx" class="btn btn-outline-secondary">
                <i class="bi bi-diagram-3 me-1"></i>Departamentos
            </a>
            <a href="Puestos.aspx" class="btn btn-outline-secondary">
                <i class="bi bi-briefcase me-1"></i>Puestos
            </a>
            <a href="Turnos.aspx" class="btn btn-outline-warning">
                <i class="bi bi-clock me-1"></i>Turnos
            </a>
            <a href="Asistencia.aspx" class="btn btn-outline-success">
                <i class="bi bi-calendar-check me-1"></i>Asistencia
            </a>
            <a href="Tripulacion.aspx" class="btn btn-outline-primary">
                <i class="bi bi-airplane me-1"></i>Tripulación
            </a>
        </div>
    </div>

    <%-- EMPLEADOS --%>
    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-people me-2"></i>Empleados Registrados
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvEmpleados" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="Sin datos — enciende la VM de Oracle."/>
        </div>
    </div>

</asp:Content>

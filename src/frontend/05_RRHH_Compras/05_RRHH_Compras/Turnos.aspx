<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Turnos.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Turnos"
         MasterPageFile="~/05_RRHH_Compras/RRHH.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Turnos</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-clock me-2 text-danger"></i>Gestión de Turnos
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-link-45deg me-2"></i>Asignar Turno a Empleado
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Empleado *</label>
                    <asp:TextBox ID="txtIdEmpleado" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Turno *</label>
                    <asp:TextBox ID="txtIdTurno" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Fecha Desde *</label>
                    <asp:TextBox ID="txtFechaDesde" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnAsignar" runat="server"
                                Text="🔗 Asignar Turno"
                                CssClass="btn btn-danger"
                                OnClick="btnAsignar_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Turnos Disponibles
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvTurnos" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay turnos registrados."/>
        </div>
    </div>

</asp:Content>
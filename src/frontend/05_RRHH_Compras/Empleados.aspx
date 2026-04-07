<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Empleados.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Empleados"
         MasterPageFile="~/05_RRHH_Compras/RRHH.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Empleados
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-people me-2 text-danger"></i>Gestión de Empleados
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Nuevo Empleado
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Puesto *</label>
                    <asp:TextBox ID="txtIdPuesto" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Depto *</label>
                    <asp:TextBox ID="txtIdDepto" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Código *</label>
                    <asp:TextBox ID="txtCodigo" runat="server"
                                 CssClass="form-control" placeholder="EMP001"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Nombres *</label>
                    <asp:TextBox ID="txtNombres" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Apellidos *</label>
                    <asp:TextBox ID="txtApellidos" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">DPI *</label>
                    <asp:TextBox ID="txtDPI" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Email Corporativo *</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                                 CssClass="form-control" TextMode="Email"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fecha Ingreso *</label>
                    <asp:TextBox ID="txtFechaIngreso" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <asp:Button ID="btnGuardar" runat="server"
                            Text="💾 Guardar Empleado"
                            CssClass="btn btn-danger"
                            OnClick="btnGuardar_Click"/>
                <asp:Button ID="btnLimpiar" runat="server"
                            Text="🔄 Limpiar"
                            CssClass="btn btn-secondary"
                            OnClick="btnLimpiar_Click"/>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-arrow-repeat me-2"></i>Cambiar Estado de Empleado
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Empleado *</label>
                    <asp:TextBox ID="txtIdEmpEstado" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Nuevo Estado *</label>
                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                        <asp:ListItem Value="S">ACTIVO</asp:ListItem>
                        <asp:ListItem Value="N">INACTIVO</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnCambiarEstado" runat="server"
                                Text="🔄 Cambiar Estado"
                                CssClass="btn btn-warning"
                                OnClick="btnCambiarEstado_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensajeEstado" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Empleados Registrados
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvEmpleados" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay empleados registrados."/>
        </div>
    </div>

</asp:Content>
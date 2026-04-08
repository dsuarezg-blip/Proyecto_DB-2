<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Proveedores.aspx.vb"
         Inherits="ProyectoAeroGT.Proveedores"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Proveedores</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-truck me-2 text-primary"></i>Gestión de Proveedores
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Proveedor
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Nombre *</label>
                    <asp:TextBox ID="txtNombreProv" runat="server"
                                 CssClass="form-control" placeholder="MRO Guatemala S.A."/>
                </div>
                <div class="col-md-1">
                    <label class="form-label fw-semibold">ID País</label>
                    <asp:TextBox ID="txtPaisProv" runat="server"
                                 CssClass="form-control" Text="1"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Contacto</label>
                    <asp:TextBox ID="txtContactoProv" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Email</label>
                    <asp:TextBox ID="txtEmailProv" runat="server"
                                 CssClass="form-control" TextMode="Email"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Teléfono</label>
                    <asp:TextBox ID="txtTelProv" runat="server" CssClass="form-control"/>
                </div>
            </div>
            <div class="mt-3">
                <asp:Button ID="btnGuardarProv" runat="server"
                            Text="💾 Guardar Proveedor"
                            CssClass="btn btn-primary"
                            OnClick="btnGuardarProv_Click"/>
            </div>
            <asp:Label ID="lblMensajeProv" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-link-45deg me-2"></i>Asignar Proveedor a Avión
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Avión *</label>
                    <asp:TextBox ID="txtIdAvionProv" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Proveedor *</label>
                    <asp:TextBox ID="txtIdProvAsign" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Tipo de Servicio</label>
                    <asp:DropDownList ID="ddlTipoServicio" runat="server" CssClass="form-select">
                        <asp:ListItem Value="MANTENIMIENTO">MANTENIMIENTO</asp:ListItem>
                        <asp:ListItem Value="REPUESTOS">REPUESTOS</asp:ListItem>
                        <asp:ListItem Value="INSPECCION">INSPECCION</asp:ListItem>
                        <asp:ListItem Value="LIMPIEZA">LIMPIEZA</asp:ListItem>
                        <asp:ListItem Value="CATERING">CATERING</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnAsignarProv" runat="server"
                                Text="🔗 Asignar"
                                CssClass="btn btn-success"
                                OnClick="btnAsignarProv_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensajeAsign" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-table me-2"></i>Proveedores Registrados
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvProveedores" runat="server"
                          CssClass="table table-hover table-striped mb-0"
                          AutoGenerateColumns="true" GridLines="None"
                          EmptyDataText="No hay proveedores registrados."/>
        </div>
    </div>

</asp:Content>
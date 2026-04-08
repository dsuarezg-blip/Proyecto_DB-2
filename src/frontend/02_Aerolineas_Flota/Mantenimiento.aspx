<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Mantenimiento.aspx.vb"
         Inherits="ProyectoAeroGT.Mantenimiento"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Mantenimiento
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-tools me-2 text-primary"></i>Mantenimiento de Flota
        </h4>
    </div>

    <%-- REGISTRAR MANTENIMIENTO --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-wrench-adjustable me-2"></i>Registrar Mantenimiento
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Avión *</label>
                    <asp:TextBox ID="txtIdAvion" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Tipo</label>
                    <asp:DropDownList ID="ddlTipoManten" runat="server" CssClass="form-select">
                        <asp:ListItem Value="CHECK-A">CHECK-A</asp:ListItem>
                        <asp:ListItem Value="CHECK-B">CHECK-B</asp:ListItem>
                        <asp:ListItem Value="CHECK-C">CHECK-C</asp:ListItem>
                        <asp:ListItem Value="CHECK-D">CHECK-D</asp:ListItem>
                        <asp:ListItem Value="REPARACION">REPARACION</asp:ListItem>
                        <asp:ListItem Value="INSPECCION">INSPECCION</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Proveedor</label>
                    <asp:TextBox ID="txtProveedor" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Costo USD</label>
                    <asp:TextBox ID="txtCosto" runat="server"
                                 CssClass="form-control" placeholder="0.00"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Descripción</label>
                    <asp:TextBox ID="txtDescripcion" runat="server"
                                 CssClass="form-control" TextMode="MultiLine" Rows="1"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Fecha Inicio</label>
                    <asp:TextBox ID="txtFechaInicio" runat="server"
                                 CssClass="form-control" TextMode="DateTimeLocal"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Fecha Fin</label>
                    <asp:TextBox ID="txtFechaFin" runat="server"
                                 CssClass="form-control" TextMode="DateTimeLocal"/>
                </div>
            </div>
            <div class="mt-3">
                <asp:Button ID="btnRegistrarManten" runat="server"
                            Text="🔧 Registrar Mantenimiento"
                            CssClass="btn btn-primary"
                            OnClick="btnRegistrarManten_Click"/>
            </div>
            <asp:Label ID="lblMensajeManten" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <%-- REGISTRAR AVERIA --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod" style="background:#7b1fa2;">
            <i class="bi bi-exclamation-triangle me-2"></i>Registrar Avería
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Avión *</label>
                    <asp:TextBox ID="txtIdAvionAveria" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Severidad</label>
                    <asp:DropDownList ID="ddlSeveridad" runat="server" CssClass="form-select">
                        <asp:ListItem Value="BAJA">BAJA</asp:ListItem>
                        <asp:ListItem Value="MEDIA">MEDIA</asp:ListItem>
                        <asp:ListItem Value="ALTA">ALTA</asp:ListItem>
                        <asp:ListItem Value="CRITICA">CRITICA</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-5">
                    <label class="form-label fw-semibold">Descripción</label>
                    <asp:TextBox ID="txtDescAveria" runat="server"
                                 CssClass="form-control" TextMode="MultiLine" Rows="1"/>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnRegistrarAveria" runat="server"
                                Text="⚠️ Registrar"
                                CssClass="btn btn-danger"
                                OnClick="btnRegistrarAveria_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensajeAveria" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <%-- HISTORIAL --%>
    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-clock-history me-2"></i>Historial de Mantenimiento
        </div>
        <div class="card-body">
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">ID Avión</label>
                    <asp:TextBox ID="txtIdAvionHist" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnVerHistorial" runat="server"
                                Text="🔍 Ver Historial"
                                CssClass="btn btn-primary"
                                OnClick="btnVerHistorial_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvHistorial" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay registros."/>
        </div>
    </div>

    <%-- CERTIFICADOS POR VENCER --%>
    <div class="card card-mod">
        <div class="card-header card-header-mod" style="background:#b71c1c;">
            <i class="bi bi-exclamation-circle me-2"></i>Certificados por Vencer (30 días)
        </div>
        <div class="card-body">
            <div class="mb-3">
                <asp:Button ID="btnVerCerts" runat="server"
                            Text="⚠️ Ver Certificados por Vencer"
                            CssClass="btn btn-warning"
                            OnClick="btnVerCerts_Click"/>
            </div>
            <asp:GridView ID="gvCertificados" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="✅ No hay certificados por vencer."/>
        </div>
    </div>

</asp:Content>
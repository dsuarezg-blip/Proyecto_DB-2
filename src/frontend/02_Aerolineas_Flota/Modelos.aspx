<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Modelos.aspx.vb"
         Inherits="ProyectoAeroGT.Modelos"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Modelos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-grid me-2 text-primary"></i>Modelos de Avión
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Nuevo Modelo
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Aerolínea *</label>
                    <asp:TextBox ID="txtIdAerolinea" runat="server"
                                 CssClass="form-control" placeholder="1"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fabricante *</label>
                    <asp:DropDownList ID="ddlFabricante" runat="server" CssClass="form-select">
                        <asp:ListItem Value="Boeing">Boeing</asp:ListItem>
                        <asp:ListItem Value="Airbus">Airbus</asp:ListItem>
                        <asp:ListItem Value="Embraer">Embraer</asp:ListItem>
                        <asp:ListItem Value="Bombardier">Bombardier</asp:ListItem>
                        <asp:ListItem Value="ATR">ATR</asp:ListItem>
                        <asp:ListItem Value="Cessna">Cessna</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Modelo *</label>
                    <asp:TextBox ID="txtModelo" runat="server"
                                 CssClass="form-control" placeholder="737-800"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Cap. Pasajeros *</label>
                    <asp:TextBox ID="txtCapPax" runat="server"
                                 CssClass="form-control" placeholder="162"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Alcance (km)</label>
                    <asp:TextBox ID="txtAlcance" runat="server"
                                 CssClass="form-control" placeholder="5765"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Autonomía (h)</label>
                    <asp:TextBox ID="txtAutonomia" runat="server"
                                 CssClass="form-control" placeholder="7.5"/>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <asp:Button ID="btnGuardarModelo" runat="server"
                            Text="💾 Guardar Modelo"
                            CssClass="btn btn-primary"
                            OnClick="btnGuardarModelo_Click"/>
                <asp:Button ID="btnLimpiar" runat="server"
                            Text="🔄 Limpiar"
                            CssClass="btn btn-secondary"
                            OnClick="btnLimpiar_Click"/>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-search me-2"></i>Consultar Modelos
        </div>
        <div class="card-body">
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">ID Aerolínea</label>
                    <asp:TextBox ID="txtBuscarAerolinea" runat="server"
                                 CssClass="form-control" placeholder="ID de la aerolínea"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnBuscarModelos" runat="server"
                                Text="🔍 Buscar"
                                CssClass="btn btn-primary"
                                OnClick="btnBuscarModelos_Click"/>
                    <asp:Button ID="btnVerTodos" runat="server"
                                Text="📋 Ver Todos"
                                CssClass="btn btn-secondary ms-2"
                                OnClick="btnVerTodos_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvModelos" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay modelos registrados."/>
        </div>
    </div>

</asp:Content>
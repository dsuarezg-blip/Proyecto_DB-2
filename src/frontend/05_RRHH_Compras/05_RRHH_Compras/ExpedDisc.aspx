<%@ Page Title="Expedientes Disciplinarios" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="ExpedDisc.aspx.vb" Inherits="ExpedDisc" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .badge-abierto   { background:#dc2626;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-cerrado   { background:#16a34a;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-apelacion { background:#d97706;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-exclamation-triangle me-2" style="color:#e94560;"></i>Expedientes Disciplinarios</h2>
        <p class="text-muted mb-0">Registro de faltas y sanciones del personal</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo">
        <i class="bi bi-plus-lg me-1"></i> Nuevo expediente
    </button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<div class="card mb-4" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-md-4"><label class="form-label text-light">Empleado</label>
                <asp:DropDownList ID="ddlEmpleadoFiltro" runat="server" CssClass="form-select bg-dark text-light border-secondary" /></div>
            <div class="col-md-2"><asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-outline-light w-100 mt-4" OnClick="btnFiltrar_Click" /></div>
        </div>
    </div>
</div>

<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvExpedDisc" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None" EmptyDataText="No hay expedientes.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado" HeaderText="Empleado"   />
                <asp:BoundField DataField="tipo_falta"      HeaderText="Tipo falta" />
                <asp:BoundField DataField="descripcion"     HeaderText="Descripción"/>
                <asp:BoundField DataField="sancion"         HeaderText="Sanción"    />
                <asp:BoundField DataField="fecha_falta"     HeaderText="Fecha"      DataFormatString="{0:dd/MM/yyyy}" />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate><span class='<%# GetBadgeClass(Eval("estado")) %>'><%# Eval("estado") %></span></ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title">Registrar Expediente Disciplinario</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6"><label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" /></div>
                    <div class="col-md-6"><label class="form-label">Tipo de falta *</label>
                        <asp:DropDownList ID="ddlTipoFalta" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">— Seleccionar —</asp:ListItem>
                            <asp:ListItem Value="LEVE">Leve</asp:ListItem>
                            <asp:ListItem Value="GRAVE">Grave</asp:ListItem>
                            <asp:ListItem Value="MUY_GRAVE">Muy grave</asp:ListItem>
                        </asp:DropDownList></div>
                    <div class="col-md-6"><label class="form-label">Fecha falta *</label>
                        <asp:TextBox ID="txtFechaFalta" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" /></div>
                    <div class="col-md-6"><label class="form-label">Sanción aplicada</label>
                        <asp:DropDownList ID="ddlSancion" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">— Seleccionar —</asp:ListItem>
                            <asp:ListItem Value="AMONESTACION_VERBAL">Amonestación verbal</asp:ListItem>
                            <asp:ListItem Value="AMONESTACION_ESCRITA">Amonestación escrita</asp:ListItem>
                            <asp:ListItem Value="SUSPENSION">Suspensión</asp:ListItem>
                            <asp:ListItem Value="DESPIDO">Despido</asp:ListItem>
                        </asp:DropDownList></div>
                    <div class="col-12"><label class="form-label">Descripción *</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control bg-dark text-light border-secondary" /></div>
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-danger" OnClick="btnGuardar_Click" />
            </div>
        </div>
    </div>
</div>
</asp:Content>

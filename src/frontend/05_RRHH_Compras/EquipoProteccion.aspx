<%@ Page Title="Equipo de ProtecciÃ³n" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="EquipoProteccion.aspx.vb" Inherits="EquipoProteccion" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .badge-entregado  { background:#16a34a;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-devuelto   { background:#6b7280;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-perdido    { background:#dc2626;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-shield-check me-2" style="color:#e94560;"></i>Equipo de ProtecciÃ³n Personal</h2>
        <p class="text-muted mb-0">Control de entrega y devoluciÃ³n de EPP</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo">
        <i class="bi bi-plus-lg me-1"></i> Registrar entrega
    </button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<div class="card mb-4" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label text-light">Empleado</label>
                <asp:DropDownList ID="ddlEmpleadoFiltro" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
            </div>
            <div class="col-md-2">
                <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-outline-light w-100" OnClick="btnFiltrar_Click" />
            </div>
        </div>
    </div>
</div>

<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvEPP" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None"
            EmptyDataText="No hay registros de EPP.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado" HeaderText="Empleado"       />
                <asp:BoundField DataField="tipo_equipo"     HeaderText="Equipo"         />
                <asp:BoundField DataField="descripcion"     HeaderText="DescripciÃ³n"    />
                <asp:BoundField DataField="talla"           HeaderText="Talla"          />
                <asp:BoundField DataField="fecha_entrega"   HeaderText="Entrega"        DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="fecha_devolucion" HeaderText="DevoluciÃ³n"    DataFormatString="{0:dd/MM/yyyy}" />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='<%# GetBadgeClass(Eval("estado")) %>'><%# Eval("estado") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="AcciÃ³n">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-secondary"
                            CommandName="Devolver" CommandArgument='<%# Eval("id_epp") %>'
                            OnCommand="gvEPP_Command" CausesValidation="false"
                            Visible='<%# Eval("estado").ToString() = "ENTREGADO" %>'>Devolver</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-shield-check me-2" style="color:#e94560;"></i>Registrar Entrega EPP</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tipo de equipo *</label>
                        <asp:DropDownList ID="ddlTipoEquipo" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">â€” Seleccionar â€”</asp:ListItem>
                            <asp:ListItem Value="UNIFORME">Uniforme</asp:ListItem>
                            <asp:ListItem Value="CASCO">Casco</asp:ListItem>
                            <asp:ListItem Value="CHALECO">Chaleco reflectivo</asp:ListItem>
                            <asp:ListItem Value="BOTAS">Botas de seguridad</asp:ListItem>
                            <asp:ListItem Value="GUANTES">Guantes</asp:ListItem>
                            <asp:ListItem Value="LENTES">Lentes de protecciÃ³n</asp:ListItem>
                            <asp:ListItem Value="AURICULARES">ProtecciÃ³n auditiva</asp:ListItem>
                            <asp:ListItem Value="OTRO">Otro</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Talla</label>
                        <asp:TextBox ID="txtTalla" runat="server" CssClass="form-control bg-dark text-light border-secondary" placeholder="Ej: M, L, 42" />
                    </div>
                    <div class="col-12">
                        <label class="form-label">DescripciÃ³n</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Fecha entrega *</label>
                        <asp:TextBox ID="txtFechaEntrega" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
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

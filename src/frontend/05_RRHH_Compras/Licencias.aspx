<%@ Page Title="Licencias de Piloto" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="Licencias.aspx.vb" Inherits="Licencias" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .badge-vigente    { background:#16a34a;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-por-vencer { background:#d97706;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-vencida    { background:#dc2626;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .dias-badge { font-weight:700; font-size:1.1rem; }
        .dias-ok  { color:#16a34a; }
        .dias-warn{ color:#d97706; }
        .dias-bad { color:#dc2626; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-card-checklist me-2" style="color:#e94560;"></i>Licencias de Piloto</h2>
        <p class="text-muted mb-0">Gestión de licencias aeronáuticas del personal de vuelo</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevaLicencia">
        <i class="bi bi-plus-lg me-1"></i> Nueva Licencia
    </button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<%-- FILTROS --%>
<div class="card mb-4" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label text-light">Empleado</label>
                <asp:DropDownList ID="ddlEmpleadoFiltro" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
            </div>
            <div class="col-md-3">
                <label class="form-label text-light">Estado vigencia</label>
                <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                    <asp:ListItem Value="">— Todos —</asp:ListItem>
                    <asp:ListItem Value="VIGENTE">Vigente</asp:ListItem>
                    <asp:ListItem Value="POR_VENCER">Por vencer (90 días)</asp:ListItem>
                    <asp:ListItem Value="VENCIDA">Vencida</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2">
                <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-outline-light w-100" OnClick="btnFiltrar_Click" />
            </div>
        </div>
    </div>
</div>

<%-- GRID LICENCIAS --%>
<div class="card mb-4" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvLicencias" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None"
            EmptyDataText="No hay licencias registradas.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado"   HeaderText="Empleado"    />
                <asp:BoundField DataField="tipo"              HeaderText="Tipo"        />
                <asp:BoundField DataField="numero"            HeaderText="N° Licencia" />
                <asp:BoundField DataField="organismo_emisor"  HeaderText="Organismo"   />
                <asp:BoundField DataField="fecha_emision"     HeaderText="Emisión"     DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="fecha_vencimiento" HeaderText="Vencimiento" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:TemplateField HeaderText="Días restantes">
                    <ItemTemplate>
                        <span class='dias-badge <%# GetDiasClass(Eval("dias_restantes")) %>'>
                            <%# Eval("dias_restantes") %> días
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='<%# GetBadgeClass(Eval("estado_vigencia")) %>'>
                            <%# Eval("estado_vigencia") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <asp:LinkButton ID="lbRenovar" runat="server" CssClass="btn btn-sm btn-outline-warning"
                            CommandName="Renovar" CommandArgument='<%# Eval("id_licencia") %>'
                            OnCommand="gvLicencias_Command" CausesValidation="false">
                            <i class="bi bi-arrow-clockwise"></i> Renovar
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<%-- PANEL POR VENCER --%>
<div class="card" style="border:1px solid #d97706;background:#1a1a2e;">
    <div class="card-header" style="background:#7c2d12;color:#fde68a;">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <strong>Licencias próximas a vencer (90 días)</strong>
        <asp:Label ID="lblContPorVencer" runat="server" CssClass="badge bg-warning text-dark ms-2" />
    </div>
    <div class="card-body p-0">
        <asp:GridView ID="gvPorVencer" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark mb-0" GridLines="None"
            EmptyDataText="No hay licencias próximas a vencer. ✅">
            <EmptyDataRowStyle CssClass="text-center text-success p-3" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado"   HeaderText="Piloto"      />
                <asp:BoundField DataField="puesto"            HeaderText="Puesto"      />
                <asp:BoundField DataField="tipo"              HeaderText="Tipo"        />
                <asp:BoundField DataField="numero"            HeaderText="N° Licencia" />
                <asp:BoundField DataField="fecha_vencimiento" HeaderText="Vencimiento" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="dias_restantes"    HeaderText="Días rest."  />
            </Columns>
        </asp:GridView>
    </div>
</div>

<%-- MODAL NUEVA LICENCIA --%>
<div class="modal fade" id="modalNuevaLicencia" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-card-checklist me-2" style="color:#e94560;"></i>Registrar Licencia</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tipo *</label>
                        <asp:DropDownList ID="ddlTipoLic" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">— Seleccionar —</asp:ListItem>
                            <asp:ListItem Value="ATP">ATP</asp:ListItem>
                            <asp:ListItem Value="CPL">CPL</asp:ListItem>
                            <asp:ListItem Value="PPL">PPL</asp:ListItem>
                            <asp:ListItem Value="MPL">MPL</asp:ListItem>
                            <asp:ListItem Value="ATPL">ATPL</asp:ListItem>
                            <asp:ListItem Value="OTRO">Otro</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">N° Licencia *</label>
                        <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Organismo emisor</label>
                        <asp:TextBox ID="txtOrganismo" runat="server" CssClass="form-control bg-dark text-light border-secondary" placeholder="Ej: DGAC Guatemala" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Fecha emisión *</label>
                        <asp:TextBox ID="txtFechaEmision" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Fecha vencimiento *</label>
                        <asp:TextBox ID="txtFechaVenc" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-12">
                        <label class="form-label">Habilitaciones</label>
                        <asp:TextBox ID="txtHabilitaciones" runat="server" TextMode="MultiLine" Rows="2"
                            CssClass="form-control bg-dark text-light border-secondary" placeholder="Ej: B737, A320..." />
                    </div>
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnGuardarLicencia" runat="server" Text="Guardar" CssClass="btn btn-danger" OnClick="btnGuardarLicencia_Click" />
            </div>
        </div>
    </div>
</div>

<%-- MODAL RENOVAR --%>
<div class="modal fade" id="modalRenovar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #d97706;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-arrow-clockwise me-2" style="color:#d97706;"></i>Renovar Licencia</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfIdLicencia" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Nueva fecha de vencimiento *</label>
                    <asp:TextBox ID="txtNuevaFechaVenc" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Habilitaciones actualizadas</label>
                    <asp:TextBox ID="txtHabRenovar" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-dark text-light border-secondary" />
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnConfirmarRenovar" runat="server" Text="Confirmar renovación" CssClass="btn btn-warning text-dark" OnClick="btnConfirmarRenovar_Click" />
            </div>
        </div>
    </div>
</div>

</asp:Content>

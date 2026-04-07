<%@ Page Title="Roles del Sistema" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="Roles.aspx.vb" Inherits="Roles" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-shield-lock me-2" style="color:#e94560;"></i>Roles del Sistema</h2>
        <p class="text-muted mb-0">AdministraciÃ³n de roles y permisos de acceso RRHH</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo">
        <i class="bi bi-plus-lg me-1"></i> Nuevo rol
    </button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None"
            EmptyDataText="No hay roles configurados.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="id_rol"      HeaderText="ID"          />
                <asp:BoundField DataField="nombre_rol"  HeaderText="Nombre"      />
                <asp:BoundField DataField="descripcion" HeaderText="DescripciÃ³n" />
                <asp:BoundField DataField="nivel"       HeaderText="Nivel"       />
                <asp:BoundField DataField="activo"      HeaderText="Activo"      />
                <asp:TemplateField HeaderText="Permisos">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-info"
                            CommandName="VerPermisos" CommandArgument='<%# Eval("id_rol") %>'
                            OnCommand="gvRoles_Command" CausesValidation="false">
                            <i class="bi bi-key"></i> Ver
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<%-- PANEL PERMISOS DEL ROL --%>
<asp:Panel ID="pnlPermisos" runat="server" Visible="false" CssClass="mt-4">
    <div class="card" style="border:1px solid #3b82f6;background:#1a1a2e;">
        <div class="card-header" style="background:#1e3a5f;color:#93c5fd;">
            <i class="bi bi-key me-2"></i>
            Permisos del rol: <asp:Label ID="lblRolNombre" runat="server" style="font-weight:700;" />
        </div>
        <div class="card-body p-0">
            <asp:GridView ID="gvPermisos" runat="server" AutoGenerateColumns="false"
                CssClass="table table-dark mb-0" GridLines="None"
                EmptyDataText="Este rol no tiene permisos asignados.">
                <EmptyDataRowStyle CssClass="text-center text-muted p-3" />
                <Columns>
                    <asp:BoundField DataField="modulo"    HeaderText="MÃ³dulo"    />
                    <asp:BoundField DataField="permiso"   HeaderText="Permiso"   />
                    <asp:BoundField DataField="descripcion" HeaderText="DescripciÃ³n" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Panel>

<%-- MODAL NUEVO ROL --%>
<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-shield-lock me-2" style="color:#e94560;"></i>Crear Rol</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-8">
                        <label class="form-label">Nombre del rol *</label>
                        <asp:TextBox ID="txtNombreRol" runat="server" CssClass="form-control bg-dark text-light border-secondary" placeholder="Ej: ADMIN_RRHH" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Nivel *</label>
                        <asp:DropDownList ID="ddlNivel" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="1">1 - BÃ¡sico</asp:ListItem>
                            <asp:ListItem Value="2">2 - Operativo</asp:ListItem>
                            <asp:ListItem Value="3">3 - Supervisor</asp:ListItem>
                            <asp:ListItem Value="4">4 - Administrador</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-12">
                        <label class="form-label">DescripciÃ³n</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnGuardar" runat="server" Text="Crear rol" CssClass="btn btn-danger" OnClick="btnGuardar_Click" />
            </div>
        </div>
    </div>
</div>

</asp:Content>

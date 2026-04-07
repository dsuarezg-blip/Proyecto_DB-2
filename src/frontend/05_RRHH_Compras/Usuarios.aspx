<%@ Page Title="Usuarios del Sistema" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="Usuarios.aspx.vb" Inherits="Usuarios" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h2 class="mb-1"><i class="bi bi-person-badge me-2" style="color:#e94560;"></i>Usuarios del Sistema</h2>
        <p class="text-muted mb-0">Gestión de accesos al módulo RRHH</p></div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo"><i class="bi bi-plus-lg me-1"></i> Nuevo usuario</button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvUsuarios" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None" EmptyDataText="No hay usuarios.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado" HeaderText="Empleado"   />
                <asp:BoundField DataField="username"        HeaderText="Usuario"    />
                <asp:BoundField DataField="nombre_rol"      HeaderText="Rol"        />
                <asp:BoundField DataField="estado"          HeaderText="Estado"     />
                <asp:BoundField DataField="ultimo_acceso"   HeaderText="Último acceso" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:TemplateField HeaderText="Acción">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-warning"
                            CommandName="Toggle" CommandArgument='<%# Eval("id_usuario") & "|" & Eval("estado") %>'
                            OnCommand="gvUsuarios_Command" CausesValidation="false">
                            <%# If(Eval("estado").ToString() = "ACTIVO", "Desactivar", "Activar") %>
                        </asp:LinkButton>
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
                <h5 class="modal-title">Crear Usuario</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-12"><label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" /></div>
                    <div class="col-md-6"><label class="form-label">Nombre de usuario *</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control bg-dark text-light border-secondary" /></div>
                    <div class="col-md-6"><label class="form-label">Contraseña inicial *</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control bg-dark text-light border-secondary" /></div>
                    <div class="col-12"><label class="form-label">Rol *</label>
                        <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-select bg-dark text-light border-secondary" /></div>
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnGuardar" runat="server" Text="Crear usuario" CssClass="btn btn-danger" OnClick="btnGuardar_Click" />
            </div>
        </div>
    </div>
</div>
</asp:Content>

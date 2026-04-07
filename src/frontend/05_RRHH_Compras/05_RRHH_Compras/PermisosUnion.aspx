<%@ Page Title="Permisos Sindicales" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="PermisosUnion.aspx.vb" Inherits="PermisosUnion" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div><h2 class="mb-1"><i class="bi bi-people me-2" style="color:#e94560;"></i>Permisos Sindicales</h2>
        <p class="text-muted mb-0">Control de permisos de la uniÃ³n / sindicato</p></div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo"><i class="bi bi-plus-lg me-1"></i> Nuevo permiso</button>
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
        <asp:GridView ID="gvPermisos" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None" EmptyDataText="No hay permisos.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado" HeaderText="Empleado"     />
                <asp:BoundField DataField="tipo_permiso"    HeaderText="Tipo"         />
                <asp:BoundField DataField="motivo"          HeaderText="Motivo"       />
                <asp:BoundField DataField="fecha_inicio"    HeaderText="Inicio"       DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="fecha_fin"       HeaderText="Fin"          DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="dias"            HeaderText="DÃ­as"         />
                <asp:BoundField DataField="estado"          HeaderText="Estado"       />
            </Columns>
        </asp:GridView>
    </div>
</div>

<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title">Registrar Permiso Sindical</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-12"><label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" /></div>
                    <div class="col-md-6"><label class="form-label">Tipo de permiso *</label>
                        <asp:DropDownList ID="ddlTipoPermiso" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">â€” Seleccionar â€”</asp:ListItem>
                            <asp:ListItem Value="REUNION">ReuniÃ³n sindical</asp:ListItem>
                            <asp:ListItem Value="NEGOCIACION">NegociaciÃ³n colectiva</asp:ListItem>
                            <asp:ListItem Value="CAPACITACION">CapacitaciÃ³n sindical</asp:ListItem>
                            <asp:ListItem Value="OTRO">Otro</asp:ListItem>
                        </asp:DropDownList></div>
                    <div class="col-md-3"><label class="form-label">Fecha inicio *</label>
                        <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" /></div>
                    <div class="col-md-3"><label class="form-label">Fecha fin *</label>
                        <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" /></div>
                    <div class="col-12"><label class="form-label">Motivo</label>
                        <asp:TextBox ID="txtMotivo" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-dark text-light border-secondary" /></div>
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

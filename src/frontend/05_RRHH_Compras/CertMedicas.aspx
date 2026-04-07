<%@ Page Title="Certificados MÃ©dicos" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="CertMedicas.aspx.vb" Inherits="CertMedicas" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .badge-vigente    { background:#16a34a;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-vencido    { background:#dc2626;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-pendiente  { background:#d97706;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-heart-pulse me-2" style="color:#e94560;"></i>Certificados MÃ©dicos</h2>
        <p class="text-muted mb-0">Control de aptitud mÃ©dica del personal</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo">
        <i class="bi bi-plus-lg me-1"></i> Nuevo Certificado
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
                <label class="form-label text-light">Estado</label>
                <asp:DropDownList ID="ddlEstadoFiltro" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                    <asp:ListItem Value="">â€” Todos â€”</asp:ListItem>
                    <asp:ListItem Value="VIGENTE">Vigente</asp:ListItem>
                    <asp:ListItem Value="VENCIDO">Vencido</asp:ListItem>
                    <asp:ListItem Value="PENDIENTE">Pendiente</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2">
                <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-outline-light w-100" OnClick="btnFiltrar_Click" />
            </div>
        </div>
    </div>
</div>

<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvCertMedicas" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None"
            EmptyDataText="No hay certificados registrados.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado"   HeaderText="Empleado"    />
                <asp:BoundField DataField="tipo_examen"       HeaderText="Tipo examen" />
                <asp:BoundField DataField="medico"            HeaderText="MÃ©dico"      />
                <asp:BoundField DataField="fecha_examen"      HeaderText="Fecha"       DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="fecha_vencimiento" HeaderText="Vencimiento" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="resultado"         HeaderText="Resultado"   />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='<%# GetBadgeClass(Eval("estado")) %>'><%# Eval("estado") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<%-- MODAL NUEVO --%>
<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-heart-pulse me-2" style="color:#e94560;"></i>Registrar Certificado MÃ©dico</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tipo de examen *</label>
                        <asp:DropDownList ID="ddlTipoExamen" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">â€” Seleccionar â€”</asp:ListItem>
                            <asp:ListItem Value="CLASE_1">Clase 1 (Pilotos comerciales)</asp:ListItem>
                            <asp:ListItem Value="CLASE_2">Clase 2 (Pilotos privados)</asp:ListItem>
                            <asp:ListItem Value="CLASE_3">Clase 3 (Controladores)</asp:ListItem>
                            <asp:ListItem Value="GENERAL">General</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">MÃ©dico responsable</label>
                        <asp:TextBox ID="txtMedico" runat="server" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Centro mÃ©dico</label>
                        <asp:TextBox ID="txtCentroMedico" runat="server" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fecha examen *</label>
                        <asp:TextBox ID="txtFechaExamen" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fecha vencimiento *</label>
                        <asp:TextBox ID="txtFechaVenc" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Resultado *</label>
                        <asp:DropDownList ID="ddlResultado" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">â€” Seleccionar â€”</asp:ListItem>
                            <asp:ListItem Value="APTO">Apto</asp:ListItem>
                            <asp:ListItem Value="APTO_CON_RESTRICCIONES">Apto con restricciones</asp:ListItem>
                            <asp:ListItem Value="NO_APTO">No apto</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Observaciones</label>
                        <asp:TextBox ID="txtObservaciones" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control bg-dark text-light border-secondary" />
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

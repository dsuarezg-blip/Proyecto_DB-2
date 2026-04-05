<%@ Page Title="Pistas" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeFile="frmPistas.aspx.vb" Inherits="frmPistas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Pistas</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .modal-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; }
    .modal-box { background:#fff; border-radius:12px; padding:2rem; max-width:580px; margin:5% auto; position:relative; }
    .modal-overlay.active { display:block; }
    .btn-xs { padding: 0.2rem 0.5rem; font-size: 0.75rem; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server"><div class="container-fluid px-4 py-3">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-0" style="color:#0d2040;">
                <i class="bi bi-arrows-expand me-2" style="color:#c5a059;"></i>Gestión de Pistas
            </h2>
            <nav aria-label="breadcrumb"><ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item"><a href="/06_Seguridad_Finanzas/Dashboard.aspx">Inicio</a></li>
                <li class="breadcrumb-item active">Pistas</li>
            </ol></nav>
        </div>
        <asp:Panel ID="pnlBtnNuevo" runat="server">
            <button type="button" class="btn btn-sm text-white" style="background:#c5a059;" onclick="abrirModal('nuevo')">
                <i class="bi bi-plus-lg me-1"></i> Nueva Pista
            </button>
        </asp:Panel>
    </div>

    <!-- Filtro por aeropuerto -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-6">
                    <label class="form-label fw-semibold small">Aeropuerto</label>
                    <asp:DropDownList ID="ddlAeropuertos" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-primary btn-sm w-100" OnClick="btnBuscar_Click">
                        <i class="bi bi-search me-1"></i> Buscar
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <!-- Grid -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
            <h6 class="fw-bold mb-0 text-secondary">
                <i class="bi bi-list-ul me-2"></i>
                <asp:Label ID="lblTituloGrid" runat="server" Text="Listado de Pistas"></asp:Label>
            </h6>
            <div class="d-flex align-items-center gap-2">
                <asp:Label ID="lblConteo" runat="server" CssClass="badge bg-light text-dark border"></asp:Label>
                <asp:Panel ID="pnlBotonesVista" runat="server">
                    <asp:LinkButton ID="btnVerInactivos" runat="server"
                        CssClass="btn btn-sm btn-outline-warning"
                        OnClick="btnVerInactivos_Click">
                        <i class="bi bi-eye-slash me-1"></i> Ver Inactivas
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnVerActivos" runat="server"
                        CssClass="btn btn-sm btn-outline-success"
                        OnClick="btnVerActivos_Click" Visible="false">
                        <i class="bi bi-eye me-1"></i> Ver Activas
                    </asp:LinkButton>
                </asp:Panel>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="gvPistas" runat="server" CssClass="table table-hover align-middle mb-0"
                    AutoGenerateColumns="false" EmptyDataText="No hay pistas para mostrar."
                    DataKeyNames="ID_PISTA" OnRowCommand="gvPistas_RowCommand">
                    <HeaderStyle CssClass="table-light text-secondary small" />
                    <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
                    <Columns>
                        <asp:BoundField DataField="DESIGNACION" HeaderText="Designación" ItemStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="LONGITUD_M" HeaderText="Longitud (m)" />
                        <asp:BoundField DataField="ANCHO_M" HeaderText="Ancho (m)" />
                        <asp:BoundField DataField="TIPO_SUPERFICIE" HeaderText="Superficie" />
                        <asp:BoundField DataField="RESISTENCIA_PCN" HeaderText="PCN" />
                        <asp:BoundField DataField="ILUMINADA" HeaderText="Iluminada" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# If(Eval("ACTIVA").ToString() = "S", "<span class='badge bg-success'>Activa</span>", "<span class='badge bg-warning text-dark'>Inactiva</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones" ItemStyle-CssClass="tbl-action">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="Editar" CommandArgument='<%# Eval("ID_PISTA") %>'
                                    CssClass="btn btn-xs btn-outline-primary me-1" ToolTip="Editar" Text="✏️">
                                </asp:LinkButton>
                                <asp:Panel ID="pnlDesactivar" runat="server" style="display:inline-block;"
                                    Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVA").ToString() = "S" %>'>
                                    <asp:LinkButton runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("ID_PISTA") %>'
                                        CssClass="btn btn-xs btn-outline-danger me-1" ToolTip="Desactivar" Text="⊘"
                                        OnClientClick="return confirm('¿Desactivar esta pista?');">
                                    </asp:LinkButton>
                                </asp:Panel>
                                <asp:Panel ID="pnlReactivar" runat="server" style="display:inline-block;"
                                    Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVA").ToString() = "N" %>'>
                                    <asp:LinkButton runat="server" CommandName="Reactivar" CommandArgument='<%# Eval("ID_PISTA") %>'
                                        CssClass="btn btn-xs btn-outline-success me-1" ToolTip="Reactivar" Text="✔"
                                        OnClientClick="return confirm('¿Reactivar esta pista?');">
                                    </asp:LinkButton>
                                </asp:Panel>
                                <asp:Panel ID="pnlEliminarDef" runat="server" style="display:inline-block;"
                                    Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVA").ToString() = "N" %>'>
                                    <asp:LinkButton runat="server" CommandName="EliminarDef" CommandArgument='<%# Eval("ID_PISTA") %>'
                                        CssClass="btn btn-xs btn-danger" ToolTip="Eliminar definitivamente" Text="🗑"
                                        OnClientClick="return confirm('ATENCION: Eliminacion permanente. ¿Está seguro?');">
                                    </asp:LinkButton>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div id="modalPista" class="modal-overlay">
    <div class="modal-box">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0" style="color:#0d2040;" id="modalTitulo">Nueva Pista</h5>
            <button type="button" class="btn-close" onclick="cerrarModal()"></button>
        </div>

        <asp:HiddenField ID="hfIdPista" runat="server" Value="0" />

        <div class="row g-3">
            <div class="col-md-12">
                <label class="form-label small fw-semibold">Aeropuerto *</label>
                <asp:DropDownList ID="ddlAeropuertoModal" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Designación *</label>
                <asp:TextBox ID="txtDesignacion" runat="server" CssClass="form-control form-control-sm" placeholder="Ej: 01L"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Tipo de superficie *</label>
                <asp:DropDownList ID="ddlSuperficie" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="Asfalto" Value="ASFALTO"></asp:ListItem>
                    <asp:ListItem Text="Concreto" Value="CONCRETO"></asp:ListItem>
                    <asp:ListItem Text="Grava" Value="GRAVA"></asp:ListItem>
                    <asp:ListItem Text="Césped" Value="CESPED"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-semibold">Longitud (m) *</label>
                <asp:TextBox ID="txtLongitud" runat="server" CssClass="form-control form-control-sm" placeholder="3000"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-semibold">Ancho (m) *</label>
                <asp:TextBox ID="txtAncho" runat="server" CssClass="form-control form-control-sm" placeholder="45"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-semibold">Resistencia PCN</label>
                <asp:TextBox ID="txtCargaMax" runat="server" CssClass="form-control form-control-sm" placeholder="80"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">¿Iluminada?</label>
                <asp:DropDownList ID="ddlIluminada" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="Sí" Value="S"></asp:ListItem>
                    <asp:ListItem Text="No" Value="N"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Activa</label>
                <asp:DropDownList ID="ddlActivo" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="Sí" Value="S"></asp:ListItem>
                    <asp:ListItem Text="No" Value="N"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-4">
            <button type="button" class="btn btn-secondary btn-sm" onclick="cerrarModal()">Cancelar</button>
            <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-sm text-white" style="background:#c5a059;" OnClick="btnGuardar_Click">
                <i class="bi bi-save me-1"></i> Guardar
            </asp:LinkButton>
        </div>
    </div>
</div>

<script>
    function abrirModal(modo) {
        document.getElementById('modalPista').classList.add('active');
        document.getElementById('modalTitulo').innerText = modo === 'nuevo' ? 'Nueva Pista' : 'Editar Pista';
    }
    function cerrarModal() { document.getElementById('modalPista').classList.remove('active'); }
    function abrirModalEditar() { abrirModal('editar'); }
</script>
</asp:Content>

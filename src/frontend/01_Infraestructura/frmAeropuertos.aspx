<%@ Page Title="Aeropuertos" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeFile="frmAeropuertos.aspx.vb" Inherits="frmAeropuertos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Aeropuertos</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .modal-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; }
    .modal-box { background:#fff; border-radius:12px; padding:2rem; max-width:600px; margin:5% auto; position:relative; }
    .modal-overlay.active { display:block; }
    .tbl-action { white-space:nowrap; }
    .btn-xs { padding: 0.2rem 0.5rem; font-size: 0.75rem; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server"><div class="container-fluid px-4 py-3">

    <!-- Encabezado -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-0" style="color:#0d2040;">
                <i class="bi bi-geo-alt-fill me-2" style="color:#c5a059;"></i>Gestión de Aeropuertos
            </h2>
            <nav aria-label="breadcrumb"><ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item"><a href="/06_Seguridad_Finanzas/Dashboard.aspx">Inicio</a></li>
                <li class="breadcrumb-item active">Aeropuertos</li>
            </ol></nav>
        </div>
        <asp:Panel ID="pnlBtnNuevo" runat="server">
            <button type="button" class="btn btn-sm text-white" style="background:#c5a059;" onclick="abrirModal('nuevo')">
                <i class="bi bi-plus-lg me-1"></i> Nuevo Aeropuerto
            </button>
        </asp:Panel>
    </div>



    <!-- Filtros -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">Continente</label>
                    <asp:DropDownList ID="ddlContinentes" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlContinentes_SelectedIndexChanged"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">País</label>
                    <asp:DropDownList ID="ddlPaises" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlPaises_SelectedIndexChanged"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold small">Ciudad</label>
                    <asp:DropDownList ID="ddlCiudades" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
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
                <asp:Label ID="lblTituloGrid" runat="server" Text="Directorio de Aeropuertos"></asp:Label>
            </h6>
            <div class="d-flex align-items-center gap-2">
                <asp:Label ID="lblConteo" runat="server" CssClass="badge bg-light text-dark border"></asp:Label>
                <asp:Panel ID="pnlBotonesVista" runat="server">
                    <asp:LinkButton ID="btnVerInactivos" runat="server"
                        CssClass="btn btn-sm btn-outline-warning"
                        OnClick="btnVerInactivos_Click">
                        <i class="bi bi-eye-slash me-1"></i> Ver Inactivos
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnVerActivos" runat="server"
                        CssClass="btn btn-sm btn-outline-success"
                        OnClick="btnVerActivos_Click" Visible="false">
                        <i class="bi bi-eye me-1"></i> Ver Activos
                    </asp:LinkButton>
                </asp:Panel>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="gvAeropuertos" runat="server" CssClass="table table-hover align-middle mb-0"
                    AutoGenerateColumns="false" EmptyDataText="No hay aeropuertos para mostrar."
                    DataKeyNames="ID_AEROPUERTO" OnRowCommand="gvAeropuertos_RowCommand">
                    <HeaderStyle CssClass="table-light text-secondary small" />
                    <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
                    <Columns>
                        <asp:BoundField DataField="CODIGO_IATA" HeaderText="IATA" ItemStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="CODIGO_ICAO" HeaderText="ICAO" />
                        <asp:BoundField DataField="NOMBRE" HeaderText="Nombre" />
                        <asp:BoundField DataField="TIPO" HeaderText="Tipo" />
                        <asp:BoundField DataField="ES_HUB" HeaderText="Hub" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# If(Eval("ACTIVO").ToString() = "S", "<span class='badge bg-success'>Activo</span>", "<span class='badge bg-warning text-dark'>Inactivo</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones" ItemStyle-CssClass="tbl-action">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="Editar"
                                    CommandArgument='<%# Eval("ID_AEROPUERTO") %>'
                                    CssClass="btn btn-xs btn-outline-primary me-1" ToolTip="Editar"
                                    Text="✏️">
                                </asp:LinkButton>
                                <asp:Panel ID="pnlDesactivar" runat="server" style="display:inline-block;"
                                    Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVO").ToString() = "S" %>'>
                                    <asp:LinkButton runat="server" CommandName="Eliminar"
                                        CommandArgument='<%# Eval("ID_AEROPUERTO") %>'
                                        CssClass="btn btn-xs btn-outline-danger me-1" ToolTip="Desactivar"
                                        Text="⊘"
                                        OnClientClick="return confirm('¿Desactivar este aeropuerto?');">
                                    </asp:LinkButton>
                                </asp:Panel>
                                <asp:Panel ID="pnlReactivar" runat="server" style="display:inline-block;"
                                    Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVO").ToString() = "N" %>'>
                                    <asp:LinkButton runat="server" CommandName="Reactivar"
                                        CommandArgument='<%# Eval("ID_AEROPUERTO") %>'
                                        CssClass="btn btn-xs btn-outline-success me-1" ToolTip="Reactivar"
                                        Text="✔"
                                        OnClientClick="return confirm('¿Reactivar este aeropuerto?');">
                                    </asp:LinkButton>
                                </asp:Panel>
                                <asp:Panel ID="pnlEliminarDef" runat="server" style="display:inline-block;"
                                    Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVO").ToString() = "N" %>'>
                                    <asp:LinkButton runat="server" CommandName="EliminarDef"
                                        CommandArgument='<%# Eval("ID_AEROPUERTO") %>'
                                        CssClass="btn btn-xs btn-danger" ToolTip="Eliminar definitivamente"
                                        Text="🗑"
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

<!-- Modal Insertar/Editar -->
<div id="modalAeropuerto" class="modal-overlay">
    <div class="modal-box">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0" style="color:#0d2040;" id="modalTitulo">Nuevo Aeropuerto</h5>
            <button type="button" class="btn-close" onclick="cerrarModal()"></button>
        </div>

        <asp:HiddenField ID="hfIdAeropuerto" runat="server" Value="0" />

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Código IATA *</label>
                <asp:TextBox ID="txtIata" runat="server" CssClass="form-control form-control-sm" MaxLength="3" placeholder="Ej: GUA"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Código ICAO *</label>
                <asp:TextBox ID="txtIcao" runat="server" CssClass="form-control form-control-sm" MaxLength="4" placeholder="Ej: MGGT"></asp:TextBox>
            </div>
            <div class="col-md-12">
                <label class="form-label small fw-semibold">Nombre completo *</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control form-control-sm" placeholder="Ej: Aeropuerto Internacional La Aurora"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Nombre corto</label>
                <asp:TextBox ID="txtNombreCorto" runat="server" CssClass="form-control form-control-sm" placeholder="Ej: La Aurora"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Tipo *</label>
                <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="Internacional" Value="Internacional"></asp:ListItem>
                    <asp:ListItem Text="Nacional" Value="Nacional"></asp:ListItem>
                    <asp:ListItem Text="Regional" Value="Regional"></asp:ListItem>
                    <asp:ListItem Text="Privado" Value="Privado"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-semibold">Latitud</label>
                <asp:TextBox ID="txtLatitud" runat="server" CssClass="form-control form-control-sm" placeholder="14.5833"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-semibold">Longitud</label>
                <asp:TextBox ID="txtLongitud" runat="server" CssClass="form-control form-control-sm" placeholder="-90.5275"></asp:TextBox>
            </div>
            <div class="col-md-4">
                <label class="form-label small fw-semibold">Altitud (ft)</label>
                <asp:TextBox ID="txtAltitud" runat="server" CssClass="form-control form-control-sm" placeholder="4952"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Ciudad *</label>
                <asp:DropDownList ID="ddlCiudadModal" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
            </div>
            <div class="col-md-3">
                <label class="form-label small fw-semibold">¿Es Hub?</label>
                <asp:DropDownList ID="ddlEsHub" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="No" Value="N"></asp:ListItem>
                    <asp:ListItem Text="Sí" Value="S"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <label class="form-label small fw-semibold">Activo</label>
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
        document.getElementById('modalAeropuerto').classList.add('active');
        if (modo === 'nuevo') {
            document.getElementById('modalTitulo').innerText = 'Nuevo Aeropuerto';
        }
    }
    function cerrarModal() {
        document.getElementById('modalAeropuerto').classList.remove('active');
    }
    function abrirModalEditar() {
        document.getElementById('modalTitulo').innerText = 'Editar Aeropuerto';
        document.getElementById('modalAeropuerto').classList.add('active');
    }
</script>
</asp:Content>

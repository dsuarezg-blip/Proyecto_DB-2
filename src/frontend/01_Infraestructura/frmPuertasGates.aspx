<%@ Page Title="Puertas / Gates" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeFile="frmPuertasGates.aspx.vb" Inherits="frmPuertasGates" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Puertas / Gates</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .modal-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; }
    .modal-box { background:#fff; border-radius:12px; padding:2rem; max-width:560px; margin:5% auto; }
    .modal-overlay.active { display:block; }
    .btn-xs { padding:0.2rem 0.5rem; font-size:0.75rem; }
</style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="container-fluid px-4 py-3">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-0" style="color:#0d2040;"><i class="bi bi-door-open-fill me-2" style="color:#c5a059;"></i>Puertas / Gates</h2>
            <nav aria-label="breadcrumb"><ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item"><a href="/06_Seguridad_Finanzas/Dashboard.aspx">Inicio</a></li>
                <li class="breadcrumb-item active">Puertas / Gates</li>
            </ol></nav>
        </div>
        <asp:Panel ID="pnlBtnNuevo" runat="server">
            <button type="button" class="btn btn-sm text-white" style="background:#c5a059;" onclick="abrirModal()">
                <i class="bi bi-plus-lg me-1"></i> Nueva Puerta
            </button>
        </asp:Panel>
    </div>
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label fw-semibold small">Terminal</label>
                    <asp:DropDownList ID="ddlTerminales" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                </div>
                <div class="col-md-5">
                    <label class="form-label fw-semibold small">Sección</label>
                    <asp:DropDownList ID="ddlSecciones" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-primary btn-sm w-100" OnClick="btnBuscar_Click">
                        <i class="bi bi-search me-1"></i> Buscar
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
            <h6 class="fw-bold mb-0 text-secondary"><i class="bi bi-list-ul me-2"></i>Listado de Puertas</h6>
            <asp:Label ID="lblConteo" runat="server" CssClass="badge bg-light text-dark border"></asp:Label>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <asp:GridView ID="gvGates" runat="server" CssClass="table table-hover align-middle mb-0"
                    AutoGenerateColumns="false" EmptyDataText="No hay puertas para mostrar."
                    DataKeyNames="ID_GATE" OnRowCommand="gvGates_RowCommand">
                    <HeaderStyle CssClass="table-light text-secondary small" />
                    <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
                    <Columns>
                        <asp:BoundField DataField="CODIGO" HeaderText="Código" ItemStyle-CssClass="fw-bold" />
                        <asp:BoundField DataField="TIPO" HeaderText="Tipo" />
                        <asp:BoundField DataField="CAPACIDAD_PAX" HeaderText="Capacidad" />
                        <asp:TemplateField HeaderText="Jetway">
                            <ItemTemplate><%# If(Eval("TIENE_JETWAY").ToString() = "S", "<span class='badge bg-success'>Sí</span>", "<span class='badge bg-secondary'>No</span>") %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ESTADO" HeaderText="Estado Op." />
                        <asp:TemplateField HeaderText="Activo">
                            <ItemTemplate><%# If(Eval("ACTIVO").ToString() = "S", "<span class='badge bg-success'>Activo</span>", "<span class='badge bg-warning text-dark'>Inactivo</span>") %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="Editar" CommandArgument='<%# Eval("ID_GATE") %>' CssClass="btn btn-xs btn-outline-primary me-1" Text="✏️"></asp:LinkButton>
                                <asp:Panel ID="pnlDes" runat="server" style="display:inline-block;" Visible='<%# Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN" AndAlso Eval("ACTIVO").ToString() = "S" %>'>
                                    <asp:LinkButton runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("ID_GATE") %>' CssClass="btn btn-xs btn-outline-danger" Text="⊘" OnClientClick="return confirm('¿Desactivar esta puerta?');"></asp:LinkButton>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</div>
<div id="modalGate" class="modal-overlay">
    <div class="modal-box">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0" style="color:#0d2040;" id="modalTitulo">Nueva Puerta</h5>
            <button type="button" class="btn-close" onclick="cerrarModal()"></button>
        </div>
        <asp:HiddenField ID="hfIdGate" runat="server" Value="0" />
        <div class="row g-3">
            <div class="col-md-12">
                <label class="form-label small fw-semibold">Sección *</label>
                <asp:DropDownList ID="ddlSeccionModal" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Código *</label>
                <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control form-control-sm" placeholder="Ej: A1"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Tipo</label>
                <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="Internacional" Value="INTERNACIONAL"></asp:ListItem>
                    <asp:ListItem Text="Nacional" Value="NACIONAL"></asp:ListItem>
                    <asp:ListItem Text="Mixta" Value="MIXTA"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">Capacidad PAX</label>
                <asp:TextBox ID="txtCapacidad" runat="server" CssClass="form-control form-control-sm" placeholder="200"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-semibold">¿Tiene Jetway?</label>
                <asp:DropDownList ID="ddlJetway" runat="server" CssClass="form-select form-select-sm">
                    <asp:ListItem Text="Sí" Value="S"></asp:ListItem>
                    <asp:ListItem Text="No" Value="N"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-6" id="divActivo" runat="server" visible="false">
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
    function abrirModal() { document.getElementById('modalGate').classList.add('active'); document.getElementById('modalTitulo').innerText = 'Nueva Puerta'; }
    function cerrarModal() { document.getElementById('modalGate').classList.remove('active'); }
    function abrirModalEditar() { document.getElementById('modalTitulo').innerText = 'Editar Puerta'; document.getElementById('modalGate').classList.add('active'); }
</script>
</asp:Content>

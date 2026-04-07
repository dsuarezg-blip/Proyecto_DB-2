<%@ Page Title="Viáticos" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="Viaticos.aspx.vb" Inherits="Viaticos" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .badge-pendiente { background:#3b82f6;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-aprobado  { background:#16a34a;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-liquidado { background:#6b7280;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .badge-rechazado { background:#dc2626;color:#fff;padding:3px 10px;border-radius:20px;font-size:.78rem; }
        .saldo-pos { color:#16a34a;font-weight:700; }
        .saldo-neg { color:#dc2626;font-weight:700; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-cash-stack me-2" style="color:#e94560;"></i>Viáticos</h2>
        <p class="text-muted mb-0">Solicitudes y liquidaciones de viáticos del personal</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevoViatico">
        <i class="bi bi-plus-lg me-1"></i> Nueva solicitud
    </button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<%-- RESUMEN CARDS --%>
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card text-center" style="background:#1a1a2e;border:1px solid #3b82f6;">
            <div class="card-body py-3">
                <div style="font-size:2rem;color:#3b82f6;"><i class="bi bi-hourglass-split"></i></div>
                <asp:Label ID="lblPendientes" runat="server" Text="0" style="font-size:1.8rem;font-weight:700;color:#fff;" />
                <div class="text-muted small">Pendientes</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-center" style="background:#1a1a2e;border:1px solid #16a34a;">
            <div class="card-body py-3">
                <div style="font-size:2rem;color:#16a34a;"><i class="bi bi-check-circle"></i></div>
                <asp:Label ID="lblAprobados" runat="server" Text="0" style="font-size:1.8rem;font-weight:700;color:#fff;" />
                <div class="text-muted small">Aprobados</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-center" style="background:#1a1a2e;border:1px solid #6b7280;">
            <div class="card-body py-3">
                <div style="font-size:2rem;color:#9ca3af;"><i class="bi bi-archive"></i></div>
                <asp:Label ID="lblLiquidados" runat="server" Text="0" style="font-size:1.8rem;font-weight:700;color:#fff;" />
                <div class="text-muted small">Liquidados</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card text-center" style="background:#1a1a2e;border:1px solid #e94560;">
            <div class="card-body py-3">
                <div style="font-size:2rem;color:#e94560;"><i class="bi bi-x-circle"></i></div>
                <asp:Label ID="lblRechazados" runat="server" Text="0" style="font-size:1.8rem;font-weight:700;color:#fff;" />
                <div class="text-muted small">Rechazados</div>
            </div>
        </div>
    </div>
</div>

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
                    <asp:ListItem Value="">— Todos —</asp:ListItem>
                    <asp:ListItem Value="PENDIENTE">Pendiente</asp:ListItem>
                    <asp:ListItem Value="APROBADO">Aprobado</asp:ListItem>
                    <asp:ListItem Value="LIQUIDADO">Liquidado</asp:ListItem>
                    <asp:ListItem Value="RECHAZADO">Rechazado</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2">
                <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-outline-light w-100" OnClick="btnFiltrar_Click" />
            </div>
        </div>
    </div>
</div>

<%-- GRID --%>
<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvViaticos" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None"
            EmptyDataText="No hay viáticos registrados.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado"    HeaderText="Empleado"   />
                <asp:BoundField DataField="destino"            HeaderText="Destino"    />
                <asp:BoundField DataField="fecha_salida"       HeaderText="Salida"     DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="fecha_retorno"      HeaderText="Retorno"    DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="monto_aprobado_gtq" HeaderText="Aprobado Q" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="monto_gastado_gtq"  HeaderText="Gastado Q"  DataFormatString="{0:N2}" />
                <asp:TemplateField HeaderText="Saldo Q">
                    <ItemTemplate>
                        <span class='<%# GetSaldoClass(Eval("saldo")) %>'>
                            Q <%# String.Format("{0:N2}", Eval("saldo")) %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='<%# GetBadgeClass(Eval("estado")) %>'><%# Eval("estado") %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <asp:LinkButton CssClass="btn btn-sm btn-outline-success me-1" runat="server"
                            CommandName="Aprobar" CommandArgument='<%# Eval("id_viatico") %>'
                            OnCommand="gvViaticos_Command" CausesValidation="false"
                            Visible='<%# Eval("estado").ToString() = "PENDIENTE" %>'>✓</asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-sm btn-outline-info me-1" runat="server"
                            CommandName="Liquidar" CommandArgument='<%# Eval("id_viatico") %>'
                            OnCommand="gvViaticos_Command" CausesValidation="false"
                            Visible='<%# Eval("estado").ToString() = "APROBADO" %>'>Liquidar</asp:LinkButton>
                        <asp:LinkButton CssClass="btn btn-sm btn-outline-danger" runat="server"
                            CommandName="Rechazar" CommandArgument='<%# Eval("id_viatico") %>'
                            OnCommand="gvViaticos_Command" CausesValidation="false"
                            Visible='<%# Eval("estado").ToString() = "PENDIENTE" %>'>✗</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<%-- MODAL NUEVA SOLICITUD --%>
<div class="modal fade" id="modalNuevoViatico" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-cash-stack me-2" style="color:#e94560;"></i>Nueva Solicitud de Viático</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Destino *</label>
                        <asp:TextBox ID="txtDestino" runat="server" CssClass="form-control bg-dark text-light border-secondary" placeholder="Ciudad, País" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fecha de salida *</label>
                        <asp:TextBox ID="txtFechaSalida" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fecha de retorno</label>
                        <asp:TextBox ID="txtFechaRetorno" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Monto aprobado (Q) *</label>
                        <asp:TextBox ID="txtMonto" runat="server" TextMode="Number" CssClass="form-control bg-dark text-light border-secondary" placeholder="0.00" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Aprobado por</label>
                        <asp:DropDownList ID="ddlAprobadoPor" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
                    </div>
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnGuardarViatico" runat="server" Text="Guardar" CssClass="btn btn-danger" OnClick="btnGuardarViatico_Click" />
            </div>
        </div>
    </div>
</div>

<%-- MODAL LIQUIDAR --%>
<div class="modal fade" id="modalLiquidar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #0ea5e9;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title">Liquidar Viático</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hfIdViatico" runat="server" />
                <div class="mb-3">
                    <label class="form-label">Monto gastado (Q) *</label>
                    <asp:TextBox ID="txtMontoGastado" runat="server" TextMode="Number" CssClass="form-control bg-dark text-light border-secondary" placeholder="0.00" />
                </div>
            </div>
            <div class="modal-footer" style="border-top:1px solid #2a2a4a;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <asp:Button ID="btnConfirmarLiquidar" runat="server" Text="Confirmar" CssClass="btn btn-info" OnClick="btnConfirmarLiquidar_Click" />
            </div>
        </div>
    </div>
</div>

</asp:Content>

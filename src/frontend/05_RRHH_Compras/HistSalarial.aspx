<%@ Page Title="Historial Salarial" Language="VB" MasterPageFile="~/RRHH.Master" AutoEventWireup="false" CodeFile="HistSalarial.aspx.vb" Inherits="HistSalarial" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="mb-1"><i class="bi bi-currency-dollar me-2" style="color:#e94560;"></i>Historial Salarial</h2>
        <p class="text-muted mb-0">Registro de cambios salariales del personal</p>
    </div>
    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalNuevo">
        <i class="bi bi-plus-lg me-1"></i> Nuevo ajuste
    </button>
</div>

<asp:Panel ID="pnlAlerta" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-4" role="alert">
    <asp:Label ID="lblAlerta" runat="server" />
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</asp:Panel>

<div class="card mb-4" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body">
        <div class="row g-3 align-items-end">
            <div class="col-md-5">
                <label class="form-label text-light">Empleado</label>
                <asp:DropDownList ID="ddlEmpleadoFiltro" runat="server" CssClass="form-select bg-dark text-light border-secondary" AutoPostBack="true" OnSelectedIndexChanged="ddlEmpleadoFiltro_Changed" />
            </div>
        </div>
    </div>
</div>

<div class="card" style="border:1px solid #2a2a4a;background:#1a1a2e;">
    <div class="card-body p-0">
        <asp:GridView ID="gvHistSalarial" runat="server" AutoGenerateColumns="false"
            CssClass="table table-dark table-hover mb-0" GridLines="None"
            EmptyDataText="Seleccione un empleado para ver su historial.">
            <EmptyDataRowStyle CssClass="text-center text-muted p-4" />
            <Columns>
                <asp:BoundField DataField="nombre_empleado"  HeaderText="Empleado"       />
                <asp:BoundField DataField="salario_anterior" HeaderText="Salario anterior" DataFormatString="Q {0:N2}" />
                <asp:BoundField DataField="salario_nuevo"    HeaderText="Salario nuevo"    DataFormatString="Q {0:N2}" />
                <asp:BoundField DataField="motivo"           HeaderText="Motivo"           />
                <asp:BoundField DataField="fecha_cambio"     HeaderText="Fecha"            DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="autorizado_por"   HeaderText="Autorizado por"   />
            </Columns>
        </asp:GridView>
    </div>
</div>

<%-- MODAL --%>
<div class="modal fade" id="modalNuevo" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="background:#1a1a2e;color:#e0e0e0;border:1px solid #e94560;">
            <div class="modal-header" style="border-bottom:1px solid #2a2a4a;">
                <h5 class="modal-title"><i class="bi bi-currency-dollar me-2" style="color:#e94560;"></i>Registrar Ajuste Salarial</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Empleado *</label>
                        <asp:DropDownList ID="ddlEmpleado" runat="server" CssClass="form-select bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Nuevo salario (Q) *</label>
                        <asp:TextBox ID="txtSalarioNuevo" runat="server" TextMode="Number" CssClass="form-control bg-dark text-light border-secondary" placeholder="0.00" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Fecha efectiva *</label>
                        <asp:TextBox ID="txtFecha" runat="server" TextMode="Date" CssClass="form-control bg-dark text-light border-secondary" />
                    </div>
                    <div class="col-12">
                        <label class="form-label">Motivo *</label>
                        <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="form-select bg-dark text-light border-secondary">
                            <asp:ListItem Value="">â€” Seleccionar â€”</asp:ListItem>
                            <asp:ListItem Value="AUMENTO_ANUAL">Aumento anual</asp:ListItem>
                            <asp:ListItem Value="PROMOCION">PromociÃ³n</asp:ListItem>
                            <asp:ListItem Value="MERITO">MÃ©rito</asp:ListItem>
                            <asp:ListItem Value="AJUSTE_MERCADO">Ajuste de mercado</asp:ListItem>
                            <asp:ListItem Value="OTRO">Otro</asp:ListItem>
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

<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Contratos.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Contratos"
         MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Contratos</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-file-earmark-text me-2 text-danger"></i>Gestión de Contratos
        </h4>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Contrato
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Empleado *</label>
                    <asp:TextBox ID="txtIdEmpleado" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Tipo *</label>
                    <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select">
                        <asp:ListItem Value="TIEMPO_INDEFINIDO">TIEMPO INDEFINIDO</asp:ListItem>
                        <asp:ListItem Value="TIEMPO_DEFINIDO">TIEMPO DEFINIDO</asp:ListItem>
                        <asp:ListItem Value="TEMPORAL">TEMPORAL</asp:ListItem>
                        <asp:ListItem Value="PRACTICANTE">PRACTICANTE</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fecha Inicio *</label>
                    <asp:TextBox ID="txtFechaInicio" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Salario Base (GTQ) *</label>
                    <asp:TextBox ID="txtSalario" runat="server"
                                 CssClass="form-control" placeholder="3500.00"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Jornada</label>
                    <asp:DropDownList ID="ddlJornada" runat="server" CssClass="form-select">
                        <asp:ListItem Value="DIURNA">DIURNA</asp:ListItem>
                        <asp:ListItem Value="NOCTURNA">NOCTURNA</asp:ListItem>
                        <asp:ListItem Value="MIXTA">MIXTA</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="mt-3">
                <asp:Button ID="btnGuardar" runat="server"
                            Text="💾 Registrar Contrato"
                            CssClass="btn btn-danger"
                            OnClick="btnGuardar_Click"/>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

</asp:Content>

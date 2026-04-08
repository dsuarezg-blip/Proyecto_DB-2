<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Certificados.aspx.vb"
         Inherits="ProyectoAeroGT.Certificados"
         MasterPageFile="~/02_Aerolineas_Flota/Modulo2.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Certificados</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-patch-check me-2 text-primary"></i>Certificados e Inspecciones
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Registrar Certificado
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-1">
                    <label class="form-label fw-semibold">ID Avión *</label>
                    <asp:TextBox ID="txtIdAvionCert" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Tipo *</label>
                    <asp:DropDownList ID="ddlTipoCert" runat="server" CssClass="form-select">
                        <asp:ListItem Value="AERONAVEGABILIDAD">AERONAVEGABILIDAD</asp:ListItem>
                        <asp:ListItem Value="RUIDO">RUIDO</asp:ListItem>
                        <asp:ListItem Value="RADIO">RADIO</asp:ListItem>
                        <asp:ListItem Value="OPERACION">OPERACION</asp:ListItem>
                        <asp:ListItem Value="SEGURO">SEGURO</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Número *</label>
                    <asp:TextBox ID="txtNumeroCert" runat="server"
                                 CssClass="form-control" placeholder="DGAC-2026-00001"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Autoridad Emisora</label>
                    <asp:TextBox ID="txtAutoridad" runat="server"
                                 CssClass="form-control" placeholder="DGAC Guatemala"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fecha Emisión *</label>
                    <asp:TextBox ID="txtFechaEmision" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Fecha Vencimiento *</label>
                    <asp:TextBox ID="txtFechaVence" runat="server"
                                 CssClass="form-control" TextMode="Date"/>
                </div>
            </div>
            <div class="mt-3">
                <asp:Button ID="btnGuardarCert" runat="server"
                            Text="💾 Guardar Certificado"
                            CssClass="btn btn-primary"
                            OnClick="btnGuardarCert_Click"/>
            </div>
            <asp:Label ID="lblMensajeCert" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-search me-2"></i>Consultar Certificados de un Avión
        </div>
        <div class="card-body">
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">ID Avión</label>
                    <asp:TextBox ID="txtBuscarAvion" runat="server"
                                 CssClass="form-control" placeholder="ID del avión"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnBuscar" runat="server"
                                Text="🔍 Buscar"
                                CssClass="btn btn-primary"
                                OnClick="btnBuscar_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvCertificados" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true" GridLines="None"
                          EmptyDataText="No se encontraron certificados."/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod" style="background:#b71c1c;">
            <i class="bi bi-exclamation-triangle me-2"></i>Alertas de Vencimiento
        </div>
        <div class="card-body">
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Alertar con (días)</label>
                    <asp:TextBox ID="txtDiasAlerta" runat="server"
                                 CssClass="form-control" Text="30"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnVerAlertas" runat="server"
                                Text="⚠️ Ver por Vencer"
                                CssClass="btn btn-warning"
                                OnClick="btnVerAlertas_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvAlertas" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true" GridLines="None"
                          EmptyDataText="✅ No hay certificados por vencer."/>
        </div>
    </div>

</asp:Content>
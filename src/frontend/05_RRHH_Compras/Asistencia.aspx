<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Asistencia.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Asistencia"
         MasterPageFile="~/05_RRHH_Compras/RRHH.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Asistencia</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-calendar-check me-2 text-danger"></i>Control de Asistencia
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-box-arrow-in-right me-2"></i>Registrar Entrada
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">ID Empleado *</label>
                    <asp:TextBox ID="txtIdEmp" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnEntrada" runat="server"
                                Text="✅ Registrar Entrada"
                                CssClass="btn btn-success"
                                OnClick="btnEntrada_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-search me-2"></i>Reporte de Asistencia por Mes
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end mb-3">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Empleado</label>
                    <asp:TextBox ID="txtIdEmpReporte" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Año</label>
                    <asp:TextBox ID="txtAnio" runat="server"
                                 CssClass="form-control"
                                 Text="2026"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">Mes</label>
                    <asp:DropDownList ID="ddlMes" runat="server" CssClass="form-select">
                        <asp:ListItem Value="1">Enero</asp:ListItem>
                        <asp:ListItem Value="2">Febrero</asp:ListItem>
                        <asp:ListItem Value="3">Marzo</asp:ListItem>
                        <asp:ListItem Value="4">Abril</asp:ListItem>
                        <asp:ListItem Value="5">Mayo</asp:ListItem>
                        <asp:ListItem Value="6">Junio</asp:ListItem>
                        <asp:ListItem Value="7">Julio</asp:ListItem>
                        <asp:ListItem Value="8">Agosto</asp:ListItem>
                        <asp:ListItem Value="9">Septiembre</asp:ListItem>
                        <asp:ListItem Value="10">Octubre</asp:ListItem>
                        <asp:ListItem Value="11">Noviembre</asp:ListItem>
                        <asp:ListItem Value="12">Diciembre</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnVerReporte" runat="server"
                                Text="📊 Ver Reporte"
                                CssClass="btn btn-danger"
                                OnClick="btnVerReporte_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvAsistencia" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay registros de asistencia."/>
        </div>
    </div>

</asp:Content>
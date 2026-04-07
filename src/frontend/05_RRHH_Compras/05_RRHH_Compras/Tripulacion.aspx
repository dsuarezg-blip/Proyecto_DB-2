<%@ Page Language="vb" AutoEventWireup="false"
         CodeBehind="Tripulacion.aspx.vb"
         Inherits="ProyectoAeroGT_Modulo3y4.Tripulacion"
         MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">Tripulación</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server"/>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0 fw-bold">
            <i class="bi bi-airplane me-2 text-danger"></i>Asignación de Tripulación
        </h4>
    </div>

    <div class="card card-mod mb-4">
        <div class="card-header card-header-mod">
            <i class="bi bi-plus-circle me-2"></i>Asignar Tripulante a Vuelo
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Empleado *</label>
                    <asp:TextBox ID="txtIdEmpleado" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">ID Vuelo *</label>
                    <asp:TextBox ID="txtIdVuelo" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-semibold">Rol *</label>
                    <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-select">
                        <asp:ListItem Value="CAPITAN">CAPITAN</asp:ListItem>
                        <asp:ListItem Value="COPILOTO">COPILOTO</asp:ListItem>
                        <asp:ListItem Value="SOBRECARGO">SOBRECARGO</asp:ListItem>
                        <asp:ListItem Value="AUXILIAR">AUXILIAR DE VUELO</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-semibold">¿Es Comandante?</label>
                    <asp:DropDownList ID="ddlComandante" runat="server" CssClass="form-select">
                        <asp:ListItem Value="N">NO</asp:ListItem>
                        <asp:ListItem Value="S">SÍ</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnAsignar" runat="server"
                                Text="✈ Asignar"
                                CssClass="btn btn-danger"
                                OnClick="btnAsignar_Click"/>
                </div>
            </div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="alerta"/>
        </div>
    </div>

    <div class="card card-mod">
        <div class="card-header card-header-mod">
            <i class="bi bi-search me-2"></i>Ver Tripulación de un Vuelo
        </div>
        <div class="card-body">
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-3">
                    <label class="form-label fw-semibold">ID Vuelo</label>
                    <asp:TextBox ID="txtIdVueloBuscar" runat="server" CssClass="form-control"/>
                </div>
                <div class="col-auto">
                    <asp:Button ID="btnBuscar" runat="server"
                                Text="🔍 Buscar"
                                CssClass="btn btn-danger"
                                OnClick="btnBuscar_Click"/>
                </div>
            </div>
            <asp:GridView ID="gvTripulacion" runat="server"
                          CssClass="table table-hover table-striped"
                          AutoGenerateColumns="true"
                          GridLines="None"
                          EmptyDataText="No hay tripulación asignada."/>
        </div>
    </div>

</asp:Content>

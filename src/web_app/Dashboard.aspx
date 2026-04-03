<%@ Page Title="Dashboard" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="false" CodeBehind="Dashboard.aspx.vb" Inherits="AeroGT_Web.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .role-card {
            border-left: 5px solid #0d2040;
            transition: all 0.3s;
        }
        .role-card:hover {
            transform: scale(1.02);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="card card-premium p-4 bg-white border-0">
                    <h2 class="display-6"><i class="bi bi-person-badge-fill me-3 gold-accent" style="color: #c5a059;"></i>Bienvenido, <span class="fw-bold text-dark"><%: Session("UserName") %></span></h2>
                    <p class="text-muted">Sistema de Gestión Aeroportuaria AeroGT | Aeropuerto Internacional La Aurora</p>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Widgets according to Role -->
            <% If Session("UserRole") = "Administrador" Then %>
                <div class="col-md-4">
                    <div class="card card-premium p-4 role-card">
                        <h5><i class="bi bi-shield-lock-fill text-gold" style="color: #c5a059;"></i> Panel Administrativo</h5>
                        <p class="small text-muted">Acesso total a la infraestructura y seguridad del sistema.</p>
                        <a href="/Configuracion.aspx" class="btn btn-gold btn-sm">Gestionar</a>
                    </div>
                </div>
            <% End If %>

            <% If Session("UserRole") = "Cliente" Then %>
                <div class="col-md-4">
                    <div class="card card-premium p-4 role-card" style="border-left-color: #28a745;">
                        <h5><i class="bi bi-receipt-cutoff text-success"></i> Servicios al Cliente</h5>
                        <p class="small text-muted">Consulta de vuelos, reservaciones y servicios premium.</p>
                        <a href="/Consultas.aspx" class="btn btn-success btn-sm">Consultar</a>
                    </div>
                </div>
            <% End If %>

            <% If Session("UserRole") = "Usuario Standard" Then %>
                <div class="col-md-4">
                    <div class="card card-premium p-4 role-card" style="border-left-color: #17a2b8;">
                        <h5><i class="bi bi-tools text-info"></i> Operaciones</h5>
                        <p class="small text-muted">Gestión de recursos y monitoreo de infraestructura.</p>
                        <a href="/Operaciones.aspx" class="btn btn-info btn-sm">Monitorear</a>
                    </div>
                </div>
            <% End If %>

            <div class="col-md-8">
                <div class="card card-premium p-4 bg-white">
                    <h5><i class="bi bi-activity text-danger"></i> Actividad Reciente</h5>
                    <hr />
                    <ul class="list-unstyled small">
                        <li class="mb-2"><i class="bi bi-check-circle-fill text-success"></i> Acceso exitoso al sistema - Hace un momento</li>
                        <li class="mb-2"><i class="bi bi-clock-history"></i> Última sincronización con Oracle 21c (172.16.10.10) - Correcta</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

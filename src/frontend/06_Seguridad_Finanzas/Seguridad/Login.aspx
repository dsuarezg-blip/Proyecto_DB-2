<%@ Page Title="Login" Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %><!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Login - AeroGT Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Inter', sans-serif;
            overflow: hidden;
        }
        .bg-login {
            background-image: url('../Content/img/login_bg.png');
            height: 100%;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .bg-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(13, 32, 64, 0.8) 0%, rgba(0, 0, 0, 0.4) 100%);
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            z-index: 10;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            border-top: 5px solid #c5a059;
        }
        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo-text {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 2rem;
            color: #0d2040;
        }
        .gold-accent {
            color: #c5a059;
        }
        .btn-premium {
            background-color: #0d2040;
            color: white;
            padding: 12px;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s;
        }
        .btn-premium:hover {
            background-color: #1a3a6a;
            color: #c5a059;
            transform: translateY(-2px);
        }
        .form-control {
            border-radius: 10px;
            padding: 12px;
            border: 1px solid #dee2e6;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(197, 160, 89, 0.25);
            border-color: #c5a059;
        }
    </style>
</head>
<body>
    <div class="bg-login">
        <div class="bg-overlay"></div>
        <div class="login-card">
            <div class="logo-container">
                <i class="bi bi-airplane-engines-fill" style="color: #c5a059; font-size: 3rem;"></i>
                <div class="logo-text">AeroGT <span class="gold-accent">System</span></div>
                <p class="text-muted">Portón al Cielo de Guatemala</p>
            </div>
            
            <form id="form1" runat="server">
                <asp:Panel ID="pnlAlert" runat="server" Visible="False" CssClass="alert alert-danger" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
                </asp:Panel>

                <div class="mb-4">
                    <label for="txtUser" class="form-label fw-bold">Usuario</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-person"></i></span>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control border-start-0" placeholder="Ingrese su usuario"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="txtPass" class="form-label fw-bold">Contraseña</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock"></i></span>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control border-start-0" TextMode="Password" placeholder="Ingrese su contraseña"></asp:TextBox>
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-premium" Text="Ingresar al Sistema" OnClick="btnLogin_Click" />
                </div>

                <div class="mt-4 text-center">
                    <a href="#" class="text-decoration-none text-muted small">¿Olvidó su contraseña?</a>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

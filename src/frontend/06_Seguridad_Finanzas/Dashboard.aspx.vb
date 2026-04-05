Imports AeroGT.App_Code

Partial Public Class Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.IsAuthenticated Then
            Response.Redirect("~/06_Seguridad_Finanzas/Seguridad/Login.aspx")
            Return
        End If

        If Not IsPostBack Then
            Dim userName As String = If(Session("UserName") IsNot Nothing, Session("UserName").ToString(), "Usuario")
            Dim userRole As String = If(Session("UserRole") IsNot Nothing, Session("UserRole").ToString(), "")

            lblBienvenida.Text = userName
            lblFecha.Text = DateTime.Now.ToString("dddd, dd 'de' MMMM 'de' yyyy", New System.Globalization.CultureInfo("es-GT"))

            Select Case userRole.ToUpper()
                Case "ADMIN"
                    lblRolBadge.Text = "<span class='badge' style='background-color:#c5a059;'>Administrador</span>"
                    pnlAdmin.Visible = True
                    CargarEstadisticas()
                Case Else
                    lblRolBadge.Text = "<span class='badge bg-secondary'>Usuario</span>"
                    pnlUsuario.Visible = True
            End Select
        End If
    End Sub

    Private Sub CargarEstadisticas()
        Try
            Dim dtAeropuertos = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_listar", New List(Of Oracle.ManagedDataAccess.Client.OracleParameter))
            lblTotalAeropuertos.Text = dtAeropuertos.Rows.Count.ToString()
        Catch
            lblTotalAeropuertos.Text = "N/A"
        End Try

        Try
            Dim dtPistas = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PISTAS", "pr_listar", New List(Of Oracle.ManagedDataAccess.Client.OracleParameter))
            lblTotalPistas.Text = dtPistas.Rows.Count.ToString()
        Catch
            lblTotalPistas.Text = "N/A"
        End Try

        lblTotalUsuarios.Text = "N/A"
    End Sub

End Class

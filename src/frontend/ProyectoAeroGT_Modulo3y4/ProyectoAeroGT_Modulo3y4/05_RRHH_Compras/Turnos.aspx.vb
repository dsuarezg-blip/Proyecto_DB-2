Public Class Turnos
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarTurnos()
    End Sub

    Private Sub CargarTurnos()
        Try
            gvTurnos.DataSource = _dao.ObtenerTurnos()
            gvTurnos.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub btnAsignar_Click(sender As Object, e As EventArgs)
        Try
            If txtIdEmpleado.Text.Trim() = "" OrElse
               txtIdTurno.Text.Trim() = "" OrElse
               txtFechaDesde.Text = "" Then
                MostrarMensaje(lblMensaje, "Todos los campos son obligatorios.", False)
                Return
            End If
            Dim res As Integer = 0
            Dim msg As String = ""
            _dao.AsignarTurno(
                CInt(txtIdEmpleado.Text),
                CInt(txtIdTurno.Text),
                DateTime.Parse(txtFechaDesde.Text),
                res, msg)
            MostrarMensaje(lblMensaje, msg, res = 1)
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta " & If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
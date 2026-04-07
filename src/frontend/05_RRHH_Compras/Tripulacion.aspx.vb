Public Class Tripulacion
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnAsignar_Click(sender As Object, e As EventArgs)
        Try
            If txtIdEmpleado.Text.Trim() = "" OrElse
               txtIdVuelo.Text.Trim() = "" Then
                MostrarMensaje(lblMensaje, "ID Empleado e ID Vuelo son obligatorios.", False)
                Return
            End If
            Dim res As Integer = 0
            Dim msg As String = ""
            _dao.AsignarTripulacion(
                CInt(txtIdEmpleado.Text),
                CInt(txtIdVuelo.Text),
                ddlRol.SelectedValue,
                ddlComandante.SelectedValue,
                res, msg)
            MostrarMensaje(lblMensaje, msg, res = 1)
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        Try
            If txtIdVueloBuscar.Text.Trim() = "" Then Return
            gvTripulacion.DataSource = _dao.ObtenerTripulacionVuelo(
                CInt(txtIdVueloBuscar.Text))
            gvTripulacion.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta " & If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
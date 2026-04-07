Public Class Contratos
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            If txtIdEmpleado.Text.Trim() = "" OrElse
               txtFechaInicio.Text = "" OrElse
               txtSalario.Text.Trim() = "" Then
                MostrarMensaje(lblMensaje,
                    "ID Empleado, Fecha Inicio y Salario son obligatorios.", False)
                Return
            End If
            Dim res As Integer = 0
            Dim msg As String = ""
            _dao.RegistrarContrato(
                CInt(txtIdEmpleado.Text),
                ddlTipo.SelectedValue,
                DateTime.Parse(txtFechaInicio.Text),
                CDec(txtSalario.Text),
                ddlJornada.SelectedValue,
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
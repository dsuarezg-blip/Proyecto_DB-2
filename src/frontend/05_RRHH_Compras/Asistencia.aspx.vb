Public Class Asistencia
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnEntrada_Click(sender As Object, e As EventArgs)
        Try
            If txtIdEmp.Text.Trim() = "" Then
                MostrarMensaje(lblMensaje, "Ingresa el ID del empleado.", False)
                Return
            End If
            Dim res As Integer = 0
            Dim msg As String = ""
            _dao.RegistrarEntrada(CInt(txtIdEmp.Text), res, msg)
            MostrarMensaje(lblMensaje, msg, res = 1)
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnVerReporte_Click(sender As Object, e As EventArgs)
        Try
            If txtIdEmpReporte.Text.Trim() = "" Then Return
            gvAsistencia.DataSource = _dao.ObtenerAsistenciaMes(
                CInt(txtIdEmpReporte.Text),
                CInt(txtAnio.Text),
                CInt(ddlMes.SelectedValue))
            gvAsistencia.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta " & If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
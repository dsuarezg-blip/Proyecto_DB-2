Public Class Empleados
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarEmpleados()
    End Sub

    Private Sub CargarEmpleados()
        Try
            gvEmpleados.DataSource = _dao.ObtenerEmpleados()
            gvEmpleados.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error al cargar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            If txtNombres.Text.Trim() = "" OrElse
               txtApellidos.Text.Trim() = "" OrElse
               txtCodigo.Text.Trim() = "" Then
                MostrarMensaje(lblMensaje,
                    "Código, Nombres y Apellidos son obligatorios.", False)
                Return
            End If
            Dim res As Integer = 0
            Dim msg As String = ""
            _dao.InsertarEmpleado(
                CInt(txtIdPuesto.Text),
                CInt(txtIdDepto.Text),
                txtCodigo.Text.Trim().ToUpper(),
                txtNombres.Text.Trim(),
                txtApellidos.Text.Trim(),
                txtDPI.Text.Trim(),
                txtEmail.Text.Trim(),
                DateTime.Parse(txtFechaIngreso.Text),
                res, msg)
            MostrarMensaje(lblMensaje, msg, res = 1)
            If res = 1 Then CargarEmpleados()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnCambiarEstado_Click(sender As Object, e As EventArgs)
        Try
            If txtIdEmpEstado.Text.Trim() = "" Then
                MostrarMensaje(lblMensajeEstado, "Ingresa el ID del empleado.", False)
                Return
            End If
            Dim res As Integer = 0
            Dim msg As String = ""
            _dao.ActualizarEstadoEmpleado(
                CInt(txtIdEmpEstado.Text),
                ddlEstado.SelectedValue,
                res, msg)
            MostrarMensaje(lblMensajeEstado, msg, res = 1)
            CargarEmpleados()
        Catch ex As Exception
            MostrarMensaje(lblMensajeEstado, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
        txtIdPuesto.Text = ""
        txtIdDepto.Text = ""
        txtCodigo.Text = ""
        txtNombres.Text = ""
        txtApellidos.Text = ""
        txtDPI.Text = ""
        txtEmail.Text = ""
        txtFechaIngreso.Text = ""
        lblMensaje.Text = ""
        lblMensaje.CssClass = "alerta"
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta " &
                       If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
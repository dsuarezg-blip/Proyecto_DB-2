Public Class Aerolineas
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarAerolineas()
    End Sub

    Private Sub CargarAerolineas()
        Try
            gvAerolineas.DataSource = _dao.ObtenerAerolineas()
            gvAerolineas.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error al cargar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            If txtIATA.Text.Trim() = "" OrElse txtNombre.Text.Trim() = "" Then
                MostrarMensaje(lblMensaje, "Código IATA y Nombre son obligatorios.", False)
                Return
            End If
            Dim msg As String = _dao.InsertarAerolinea(
                txtIATA.Text.Trim().ToUpper(),
                txtICAO.Text.Trim().ToUpper(),
                txtNombre.Text.Trim(),
                CInt(txtIdPais.Text),
                txtWeb.Text.Trim())
            MostrarMensaje(lblMensaje, msg, True)
            CargarAerolineas()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
        txtIATA.Text = ""
        txtICAO.Text = ""
        txtNombre.Text = ""
        txtWeb.Text = ""
        txtIdPais.Text = "1"
        lblMensaje.Text = ""
        lblMensaje.CssClass = "alerta"
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta alerta-visible " &
                       If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class

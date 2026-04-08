Public Class Modelos
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarTodos()
    End Sub

    Private Sub CargarTodos()
        Try
            gvModelos.DataSource = _dao.ObtenerTodosModelos()
            gvModelos.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error al cargar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnGuardarModelo_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAerolinea.Text.Trim() = "" OrElse txtModelo.Text.Trim() = "" OrElse
               txtCapPax.Text.Trim() = "" Then
                MostrarMensaje(lblMensaje,
                    "ID Aerolínea, Modelo y Capacidad son obligatorios.", False)
                Return
            End If

            Dim msg As String = _dao.InsertarModelo(
                CInt(txtIdAerolinea.Text),
                ddlFabricante.SelectedValue,
                txtModelo.Text.Trim(),
                CInt(txtCapPax.Text),
                If(txtAlcance.Text.Trim() = "", 0, CDbl(txtAlcance.Text)),
                If(txtAutonomia.Text.Trim() = "", 0, CDbl(txtAutonomia.Text))
            )

            MostrarMensaje(lblMensaje, msg, True)
            CargarTodos()

        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnBuscarModelos_Click(sender As Object, e As EventArgs)
        Try
            If txtBuscarAerolinea.Text.Trim() = "" Then Return
            gvModelos.DataSource = _dao.ObtenerModelosAerolinea(
                CInt(txtBuscarAerolinea.Text))
            gvModelos.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnVerTodos_Click(sender As Object, e As EventArgs)
        CargarTodos()
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs)
        txtIdAerolinea.Text = ""
        txtModelo.Text = ""
        txtCapPax.Text = ""
        txtAlcance.Text = ""
        txtAutonomia.Text = ""
        lblMensaje.Text = ""
        lblMensaje.CssClass = "alerta"
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta alerta-visible " &
                       If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
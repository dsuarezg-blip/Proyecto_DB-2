Public Class Flota
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarFlota()
        End If
    End Sub

    Private Sub CargarFlota()
        Try
            gvFlota.DataSource = _dao.ObtenerFlotaAerolinea(0)
            gvFlota.DataBind()
        Catch ex As Exception
            lblMensajeFlota.ForeColor = Drawing.Color.Red
            lblMensajeFlota.Text = "Error al cargar: " & ex.Message
        End Try
    End Sub

    Protected Sub btnRegistrarAvion_Click(sender As Object, e As EventArgs)
        Try
            If txtMatricula.Text.Trim() = "" OrElse
               txtIdModelo.Text.Trim() = "" OrElse
               txtIdAerolinea.Text.Trim() = "" Then
                lblMensajeFlota.ForeColor = Drawing.Color.Red
                lblMensajeFlota.Text = "Matrícula, ID Modelo e ID Aerolínea son obligatorios."
                Return
            End If

            Dim msg As String = _dao.RegistrarAvion(
                CInt(txtIdModelo.Text),
                CInt(txtIdAerolinea.Text),
                txtMatricula.Text.Trim().ToUpper(),
                txtNumSerie.Text.Trim(),
                CInt(txtAnnoFab.Text)
            )

            lblMensajeFlota.ForeColor = Drawing.Color.Green
            lblMensajeFlota.Text = msg
            CargarFlota()

        Catch ex As Exception
            lblMensajeFlota.ForeColor = Drawing.Color.Red
            lblMensajeFlota.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnCambiarEstado_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAvionEstado.Text.Trim() = "" Then
                lblMensajeEstado.ForeColor = Drawing.Color.Red
                lblMensajeEstado.Text = "Ingresa el ID del avión."
                Return
            End If

            Dim msg As String = _dao.CambiarEstadoAvion(
                CInt(txtIdAvionEstado.Text),
                ddlEstado.SelectedValue,
                txtMotivo.Text.Trim()
            )

            lblMensajeEstado.ForeColor = Drawing.Color.Green
            lblMensajeEstado.Text = msg
            CargarFlota()

        Catch ex As Exception
            lblMensajeEstado.ForeColor = Drawing.Color.Red
            lblMensajeEstado.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
        Try
            If txtFiltroAerolinea.Text.Trim() = "" Then Return
            gvFlota.DataSource = _dao.ObtenerFlotaAerolinea(CInt(txtFiltroAerolinea.Text))
            gvFlota.DataBind()
        Catch ex As Exception
            lblMensajeFlota.ForeColor = Drawing.Color.Red
            lblMensajeFlota.Text = "Error al filtrar: " & ex.Message
        End Try
    End Sub

    Protected Sub btnVerTodos_Click(sender As Object, e As EventArgs)
        CargarFlota()
    End Sub

    Protected Sub btnLimpiarFlota_Click(sender As Object, e As EventArgs)
        txtIdModelo.Text = ""
        txtIdAerolinea.Text = ""
        txtMatricula.Text = ""
        txtNumSerie.Text = ""
        txtAnnoFab.Text = ""
        lblMensajeFlota.Text = ""
    End Sub

End Class
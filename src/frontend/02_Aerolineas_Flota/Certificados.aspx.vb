Public Class Certificados
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarAlertas(30)
        End If
    End Sub

    Private Sub CargarAlertas(dias As Integer)
        Try
            gvAlertas.DataSource = _dao.CertificadosPorVencer(dias)
            gvAlertas.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensajeCert, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnGuardarCert_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAvionCert.Text.Trim() = "" OrElse
               txtNumeroCert.Text.Trim() = "" OrElse
               txtFechaEmision.Text = "" OrElse
               txtFechaVence.Text = "" Then
                MostrarMensaje(lblMensajeCert,
                    "ID Avión, Número, Fecha Emisión y Vencimiento son obligatorios.", False)
                Return
            End If

            Dim msg As String = _dao.RegistrarCertificado(
                CInt(txtIdAvionCert.Text),
                ddlTipoCert.SelectedValue,
                txtNumeroCert.Text.Trim(),
                txtAutoridad.Text.Trim(),
                DateTime.Parse(txtFechaEmision.Text),
                DateTime.Parse(txtFechaVence.Text)
            )
            MostrarMensaje(lblMensajeCert, msg, True)
            CargarAlertas(30)

        Catch ex As Exception
            MostrarMensaje(lblMensajeCert, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        Try
            If txtBuscarAvion.Text.Trim() = "" Then Return
            gvCertificados.DataSource = _dao.ObtenerCertificados(CInt(txtBuscarAvion.Text))
            gvCertificados.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensajeCert, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnVerAlertas_Click(sender As Object, e As EventArgs)
        Try
            CargarAlertas(CInt(txtDiasAlerta.Text))
        Catch ex As Exception
            MostrarMensaje(lblMensajeCert, "Error: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta alerta-visible " &
                       If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
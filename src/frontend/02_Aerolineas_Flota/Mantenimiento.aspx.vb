Public Class Mantenimiento
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnRegistrarManten_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAvion.Text.Trim() = "" OrElse txtProveedor.Text.Trim() = "" Then
                lblMensajeManten.ForeColor = Drawing.Color.Red
                lblMensajeManten.Text = "ID Avión y Proveedor son obligatorios."
                Return
            End If

            Dim msg As String = _dao.RegistrarMantenimiento(
                CInt(txtIdAvion.Text),
                ddlTipoManten.SelectedValue,
                txtDescripcion.Text.Trim(),
                txtFechaInicio.Text,
                txtFechaFin.Text,
                txtProveedor.Text.Trim(),
                CDec(If(txtCosto.Text.Trim() = "", "0", txtCosto.Text))
            )

            lblMensajeManten.ForeColor = Drawing.Color.Green
            lblMensajeManten.Text = msg

        Catch ex As Exception
            lblMensajeManten.ForeColor = Drawing.Color.Red
            lblMensajeManten.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnRegistrarAveria_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAvionAveria.Text.Trim() = "" Then
                lblMensajeAveria.ForeColor = Drawing.Color.Red
                lblMensajeAveria.Text = "Ingresa el ID del avión."
                Return
            End If

            Dim msg As String = _dao.RegistrarAveria(
                CInt(txtIdAvionAveria.Text),
                txtDescAveria.Text.Trim(),
                ddlSeveridad.SelectedValue
            )

            lblMensajeAveria.ForeColor = Drawing.Color.Green
            lblMensajeAveria.Text = msg

        Catch ex As Exception
            lblMensajeAveria.ForeColor = Drawing.Color.Red
            lblMensajeAveria.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnVerHistorial_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAvionHist.Text.Trim() = "" Then Return
            gvHistorial.DataSource = _dao.ObtenerHistorialManten(CInt(txtIdAvionHist.Text))
            gvHistorial.DataBind()
        Catch ex As Exception
            lblMensajeManten.ForeColor = Drawing.Color.Red
            lblMensajeManten.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnVerCerts_Click(sender As Object, e As EventArgs)
        Try
            gvCertificados.DataSource = _dao.CertificadosPorVencer(30)
            gvCertificados.DataBind()
        Catch ex As Exception
            lblMensajeManten.ForeColor = Drawing.Color.Red
            lblMensajeManten.Text = "Error: " & ex.Message
        End Try
    End Sub

End Class
Public Class Reportes
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtFechaIni.Text = Date.Today.AddMonths(-1).ToString("yyyy-MM-dd")
            txtFechaFin.Text = Date.Today.ToString("yyyy-MM-dd")
        End If
    End Sub

    Protected Sub btnGenerarReporte_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As System.Data.DataTable = Nothing

            Select Case ddlReporte.SelectedValue
                Case "FLOTA_GENERAL"
                    lblTituloReporte.Text = "Flota General por Aerolínea"
                    dt = _dao.ReporteFlotaGeneral()

                Case "AVIONES_ESTADO"
                    lblTituloReporte.Text = "Aviones por Estado"
                    dt = _dao.ReporteAvionesPorEstado(ddlEstadoFiltro.SelectedValue)

                Case "MANTENIMIENTOS"
                    lblTituloReporte.Text = "Mantenimientos por Período"
                    If txtFechaIni.Text = "" OrElse txtFechaFin.Text = "" Then
                        MostrarMensaje(lblMensajeRep,
                            "Selecciona rango de fechas para este reporte.", False)
                        Return
                    End If
                    dt = _dao.ReporteMantenimientosPeriodo(
                        DateTime.Parse(txtFechaIni.Text),
                        DateTime.Parse(txtFechaFin.Text))

                Case "ESTADISTICAS"
                    lblTituloReporte.Text = "Estadísticas de Flota"
                    dt = _dao.EstadisticasFlota()

                Case "CERTS_VENCER"
                    lblTituloReporte.Text = "Certificados por Vencer"
                    dt = _dao.CertificadosPorVencer(CInt(txtDiasRep.Text))
            End Select

            If dt IsNot Nothing Then
                gvReporte.DataSource = dt
                gvReporte.DataBind()
                lblTotalRegistros.Text = dt.Rows.Count.ToString()
            End If

        Catch ex As Exception
            MostrarMensaje(lblMensajeRep, "Error: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta alerta-visible " &
                       If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
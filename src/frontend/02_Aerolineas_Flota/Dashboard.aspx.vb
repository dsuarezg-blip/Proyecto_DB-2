Public Class Dashboard
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarDashboard()
    End Sub

    Private Sub CargarDashboard()
        Try
            ' Resumen de flota
            Dim dtResumen = _dao.ReporteFlotaGeneral()
            gvResumen.DataSource = dtResumen
            gvResumen.DataBind()

            ' Contadores
            Dim totalAero As Integer = 0
            Dim totalOper As Integer = 0
            Dim totalMant As Integer = 0
            For Each row As System.Data.DataRow In dtResumen.Rows
                totalAero += 1
                totalOper += CInt(If(row("OPERATIVOS") Is DBNull.Value, 0, row("OPERATIVOS")))
                totalMant += CInt(If(row("EN_MANTEN") Is DBNull.Value, 0, row("EN_MANTEN")))
            Next
            lblTotalAerolineas.Text = totalAero.ToString()
            lblAvionesOperativos.Text = totalOper.ToString()
            lblEnMantenimiento.Text = totalMant.ToString()

            ' Certificados por vencer
            Dim dtCerts = _dao.CertificadosPorVencer(30)
            gvAlertas.DataSource = dtCerts
            gvAlertas.DataBind()
            lblCertsVencer.Text = dtCerts.Rows.Count.ToString()

        Catch ex As Exception
            lblTotalAerolineas.Text = "Error"
        End Try
    End Sub

End Class
Public Class DashboardRRHH
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                gvEmpleados.DataSource = _dao.ObtenerEmpleados()
                gvEmpleados.DataBind()
            Catch ex As Exception
            End Try
        End If
    End Sub

End Class
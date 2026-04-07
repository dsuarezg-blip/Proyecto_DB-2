Public Class Puestos
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                gvPuestos.DataSource = _dao.ObtenerPuestos()
                gvPuestos.DataBind()
            Catch ex As Exception
            End Try
        End If
    End Sub

End Class
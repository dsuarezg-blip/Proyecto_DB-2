Public Class Departamentos
    Inherits System.Web.UI.Page

    Private _dao As New RrhhDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                gvDepartamentos.DataSource = _dao.ObtenerDepartamentos()
                gvDepartamentos.DataBind()
            Catch ex As Exception
                ' Error de conexion esperado si Oracle esta apagado
            End Try
        End If
    End Sub

End Class
Public Class SiteMaster
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.IsAuthenticated Then
            Response.Redirect("~/06_Seguridad_Finanzas/Seguridad/Login.aspx")
            Return
        End If

        If Session("UserName") IsNot Nothing Then
            lblUsuario.Text = Session("UserName").ToString()
        End If
        If Session("UserRole") IsNot Nothing Then
            lblRol.Text = Session("UserRole").ToString()
        End If

        ' Marcar link activo en el sidebar
        Dim path = Request.Url.AbsolutePath.ToLower()
        If path.Contains("frmaeropuertos") Then
            lblModulo.Text = "Aeropuertos"
        ElseIf path.Contains("frmpistas") Then
            lblModulo.Text = "Pistas"
        Else
            lblModulo.Text = "Módulo Infraestructura"
        End If
    End Sub

    Protected Sub btnLogout_Click(sender As Object, e As EventArgs)
        AeroGT.App_Code.AuthService.Logout()
    End Sub

End Class

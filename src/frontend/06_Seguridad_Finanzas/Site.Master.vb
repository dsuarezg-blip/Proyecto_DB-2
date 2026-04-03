Partial Public Class Site
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Automatic check for authentication and data loading if needed
    End Sub

    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Logic to log out using our AuthService
        AeroGT.App_Code.AuthService.Logout()
    End Sub
End Class

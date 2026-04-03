Namespace AeroGT_Web
    Partial Public Class Dashboard
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            ' Security check: If not authenticated, redirect to login
            If Not HttpContext.Current.Request.IsAuthenticated Then
                Response.Redirect("~/Seguridad/Login.aspx")
            End If

            ' Initialize dashboard data if needed
            ' Session variables like UserRole and UserName are already set in AuthService
        End Sub
    End Class
End Namespace

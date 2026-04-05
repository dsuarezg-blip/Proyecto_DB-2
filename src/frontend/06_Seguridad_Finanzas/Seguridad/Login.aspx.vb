Imports AeroGT.App_Code


    Partial Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Clear any previous alerts
        pnlAlert.Visible = False

    End Sub

        Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
            Try
                Dim user = txtUsername.Text.Trim()
                Dim pass = txtPassword.Text.Trim()

                If String.IsNullOrEmpty(user) OrElse String.IsNullOrEmpty(pass) Then
                    ShowError("Por favor, complete todos los campos.")
                    Return
                End If

                ' Authentication Call
                Dim success = AuthService.AuthenticateUser(user, pass)

                If success Then
                Response.Redirect("~/06_Seguridad_Finanzas/Dashboard.aspx")
            Else
                    ShowError("Credenciales inválidas. Intente de nuevo.")
                End If

            Catch ex As Exception
                ' Implementing proper error handling for DB connection as requested
                ShowError(ex.Message)
            End Try
        End Sub

        Private Sub ShowError(message As String)
            pnlAlert.Visible = True
            lblError.Text = message
        End Sub
    End Class

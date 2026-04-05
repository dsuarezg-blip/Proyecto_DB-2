Imports System.Web
Imports System.Web.Security
Imports Oracle.ManagedDataAccess.Client
Imports System.Security.Cryptography
Imports System.Text

Namespace AeroGT.App_Code
    Public Class AuthService

        Private Shared Function HashPassword(password As String) As String
            Using sha256 As SHA256 = SHA256.Create()
                Dim bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password))
                Return BitConverter.ToString(bytes).Replace("-", "").ToLower()
            End Using
        End Function

        Public Shared Function AuthenticateUser(username As String, password As String) As Boolean
            Dim passwordHash As String = HashPassword(password)

            Dim parameters As New List(Of OracleParameter)
            parameters.Add(New OracleParameter("p_username", OracleDbType.Varchar2) With {.Value = username})
            parameters.Add(New OracleParameter("p_password", OracleDbType.Varchar2) With {.Value = passwordHash})

            Try
                Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_SIST_SEGURIDAD", "pr_autenticar", parameters)

                If dt.Rows.Count > 0 Then
                    Dim row = dt.Rows(0)
                    HttpContext.Current.Session("UserID") = row("id_usuario").ToString()
                    HttpContext.Current.Session("UserRole") = row("rol_nombre").ToString()
                    HttpContext.Current.Session("UserName") = username
                    FormsAuthentication.SetAuthCookie(username, False)
                    Return True
                End If
            Catch ex As Exception
                Throw New Exception("La conexión con el sistema de seguridad falló. Contacte al administrador.", ex)
            End Try
            Return False
        End Function

        Public Shared Sub Logout()
            FormsAuthentication.SignOut()
            HttpContext.Current.Session.Clear()
            HttpContext.Current.Session.Abandon()
            HttpContext.Current.Response.Redirect("~/06_Seguridad_Finanzas/Seguridad/Login.aspx")
        End Sub

        Public Shared Function IsUserInRole(requiredRole As String) As Boolean
            If HttpContext.Current.Session("UserRole") IsNot Nothing Then
                Return HttpContext.Current.Session("UserRole").ToString().Equals(requiredRole, StringComparison.OrdinalIgnoreCase)
            End If
            Return False
        End Function

        Public Shared ReadOnly Property IsAuthenticated As Boolean
            Get
                Return HttpContext.Current.Request.IsAuthenticated
            End Get
        End Property

    End Class
End Namespace

Imports System.Web
Imports System.Web.Security
Imports Oracle.ManagedDataAccess.Client

Namespace AeroGT.App_Code
    Public Class AuthService
        ''' <summary>
        ''' Authenticates the user against the PKG_SIST_SEGURIDAD in Oracle.
        ''' </summary>
        ''' <param name="username">Provided username</param>
        ''' <param name="passwordHash">Pass-hash (pre-processed by app or during call)</param>
        ''' <returns>True if access granted, False otherwise</returns>
        Public Shared Function AuthenticateUser(username As String, passwordHash As String) As Boolean
            Dim parameters As New List(Of OracleParameter)
            parameters.Add(New OracleParameter("p_username", OracleDbType.Varchar2) With {.Value = username})
            parameters.Add(New OracleParameter("p_password", OracleDbType.Varchar2) With {.Value = passwordHash})

            Try
                Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_SIST_SEGURIDAD", "pr_autenticar", parameters)

                If dt.Rows.Count > 0 Then
                    Dim row = dt.Rows(0)
                    Dim userId = row("id_usuario").ToString()
                    Dim userEmail = row("email").ToString()
                    Dim roleName = row("rol_nombre").ToString() ' Administrador, Cliente, Usuario Standard

                    ' Set User Session
                    HttpContext.Current.Session("UserID") = userId
                    HttpContext.Current.Session("UserRole") = roleName
                    HttpContext.Current.Session("UserName") = username

                    ' Forms Authentication Ticket
                    FormsAuthentication.SetAuthCookie(username, False)
                    Return True
                End If
            Catch ex As Exception
                ' Error will be handled by the UI to show an alert
                Throw New Exception("La conexión con el sistema de seguridad falló. Contacte al administrador.", ex)
            End Try
            Return False
        End Function

        ''' <summary>
        ''' Logs out the current user and clears session data.
        ''' </summary>
        Public Shared Sub Logout()
            FormsAuthentication.SignOut()
            HttpContext.Current.Session.Clear()
            HttpContext.Current.Session.Abandon()
            HttpContext.Current.Response.Redirect("~/Seguridad/Login.aspx")
        End Sub

        ''' <summary>
        ''' Verification of role for specific page access or UI visibility.
        ''' </summary>
        Public Shared Function IsUserInRole(requiredRole As String) As Boolean
            If HttpContext.Current.Session("UserRole") IsNot Nothing Then
                Return HttpContext.Current.Session("UserRole").ToString().Equals(requiredRole, StringComparison.OrdinalIgnoreCase)
            End If
            Return False
        End Function

        ''' <summary>
        ''' Global check for any authenticated user.
        ''' </summary>
        Public Shared ReadOnly Property IsAuthenticated As Boolean
            Get
                Return HttpContext.Current.Request.IsAuthenticated
            End Get
        End Property
    End Class
End Namespace

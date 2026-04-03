Imports System.Data
Imports Oracle.ManagedDataAccess.Client
Imports System.Web.Configuration

Namespace AeroGT.App_Code
    Public Class DatabaseHelper
        Private Shared ReadOnly Property ConnectionString As String
            Get
                Return WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
            End Get
        End Property

        ''' <summary>
        ''' Executes a stored procedure that returns a RefCursor.
        ''' </summary>
        ''' <param name="packageName">Name of the PL/SQL Package</param>
        ''' <param name="procedureName">Name of the Procedure</param>
        ''' <param name="parameters">List of OracleParameters</param>
        ''' <returns>DataTable with the results</returns>
        Public Shared Function ExecuteCursorReader(packageName As String, procedureName As String, parameters As List(Of OracleParameter)) As DataTable
            Dim dt As New DataTable()
            Try
                Using conn As New OracleConnection(ConnectionString)
                    Using cmd As New OracleCommand($"{packageName}.{procedureName}", conn)
                        cmd.CommandType = CommandType.StoredProcedure

                        ' Add parameters
                        For Each param In parameters
                            cmd.Parameters.Add(param)
                        Next

                        ' Add the Out Cursor parameter (Standard for AeroGT packages)
                        Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                        pCursor.Direction = ParameterDirection.Output
                        cmd.Parameters.Add(pCursor)

                        conn.Open()
                        Using da As New OracleDataAdapter(cmd)
                            da.Fill(dt)
                        End Using
                    End Using
                End Using
            Catch ex As Exception
                ' Error handling as requested: Log or propagate with clear message
                Throw New Exception($"Error en la base de datos (Package: {packageName}): {ex.Message}", ex)
            End Try
            Return dt
        End Function

        ''' <summary>
        ''' Executes a stored procedure for Non-Query operations (Insert, Update, Delete).
        ''' </summary>
        Public Shared Sub ExecuteNonQuery(packageName As String, procedureName As String, parameters As List(Of OracleParameter))
            Try
                Using conn As New OracleConnection(ConnectionString)
                    Using cmd As New OracleCommand($"{packageName}.{procedureName}", conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        For Each param In parameters
                            cmd.Parameters.Add(param)
                        Next
                        conn.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Catch ex As Exception
                Throw New Exception($"Error al ejecutar operación {packageName}.{procedureName}: {ex.Message}", ex)
            End Try
        End Sub
    End Class
End Namespace

Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Web.Configuration
Imports System.Web.UI.WebControls.WebParts
Imports Oracle.ManagedDataAccess.Client

Namespace AeroGT.App_Code
    Public Class DatabaseHelper

        ''' Conexión al PRIMARY — para INSERT, UPDATE, DELETE
        Private Shared ReadOnly Property ConnectionStringPrimary As String
            Get
                Return WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
            End Get
        End Property

        ''' Conexión al STANDBY — para SELECT (lectura)
        Private Shared ReadOnly Property ConnectionStringReplica As String
            Get
                Return WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString
            End Get
        End Property

        ''' Ejecuta un stored procedure que retorna un RefCursor.
        ''' SIEMPRE usa la replica (standby) — solo lectura.
        Public Shared Function ExecuteCursorReader(packageName As String, procedureName As String, parameters As List(Of OracleParameter)) As DataTable
            Dim dt As New DataTable()
            Try
                Using conn As New OracleConnection(ConnectionStringReplica)
                    Using cmd As New OracleCommand(String.Format("{0}.{1}", packageName, procedureName), conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        For Each param In parameters
                            cmd.Parameters.Add(param)
                        Next
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
                Throw New Exception(String.Format("Error en la base de datos (Package: {0}): {1}", packageName, ex.Message), ex)
            End Try
            Return dt
        End Function

        ''' Ejecuta un stored procedure para DML (INSERT, UPDATE, DELETE).
        ''' SIEMPRE usa el primary.
        Public Shared Sub ExecuteNonQuery(packageName As String, procedureName As String, parameters As List(Of OracleParameter))
            Try
                Using conn As New OracleConnection(ConnectionStringPrimary)
                    Using cmd As New OracleCommand(String.Format("{0}.{1}", packageName, procedureName), conn)
                        cmd.CommandType = CommandType.StoredProcedure
                        For Each param In parameters
                            cmd.Parameters.Add(param)
                        Next
                        conn.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            Catch ex As Exception
                Throw New Exception(String.Format("Error al ejecutar operación {0}.{1}: {2}", packageName, procedureName, ex.Message), ex)
            End Try
        End Sub

    End Class
End Namespace

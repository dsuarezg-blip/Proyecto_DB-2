Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class FlotaDAO

    ' ─────────────────────────────────────────────
    ' OBTENER TODAS LAS AEROLINEAS
    ' ─────────────────────────────────────────────
    Public Function ObtenerAerolineas() As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_AEROLINEAS"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerAerolineas: " & ex.Message)
        End Try
        Return dt
    End Function

    ' ─────────────────────────────────────────────
    ' INSERTAR AEROLINEA
    ' ─────────────────────────────────────────────
    Public Function InsertarAerolinea(iata As String,
                                      icao As String,
                                      nombre As String,
                                      idPais As Integer,
                                      web As String) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_INSERTAR_AEROLINEA"

                    cmd.Parameters.Add(New OracleParameter(
                        "p_codigo_iata", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = iata})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_codigo_icao", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = icao})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_nombre", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = nombre})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_pais_origen", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = idPais})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_sitio_web", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = web})

                    Dim pRes As New OracleParameter(
                        "p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)

                    Dim pMsg As New OracleParameter(
                        "p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)

                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error InsertarAerolinea: " & ex.Message)
        End Try
        Return mensaje
    End Function

    ' ─────────────────────────────────────────────
    ' OBTENER FLOTA DE UNA AEROLINEA
    ' ─────────────────────────────────────────────
    Public Function ObtenerFlotaAerolinea(idAerolinea As Integer) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_FLOTA_AEROLINEA"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_aerolinea", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = idAerolinea})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerFlotaAerolinea: " & ex.Message)
        End Try
        Return dt
    End Function

    ' ─────────────────────────────────────────────
    ' CAMBIAR ESTADO DE UN AVION
    ' ─────────────────────────────────────────────
    Public Function CambiarEstadoAvion(idAvion As Integer,
                                       nuevoEstado As String,
                                       motivo As String) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_CAMBIAR_ESTADO_AVION"

                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_nuevo_estado", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = nuevoEstado})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_motivo", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = motivo})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_empleado", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = DBNull.Value})

                    Dim pRes As New OracleParameter(
                        "p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)

                    Dim pMsg As New OracleParameter(
                        "p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)

                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error CambiarEstadoAvion: " & ex.Message)
        End Try
        Return mensaje
    End Function

    ' ─────────────────────────────────────────────
    ' CERTIFICADOS POR VENCER
    ' ─────────────────────────────────────────────
    Public Function CertificadosPorVencer(diasAlerta As Integer) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_CERTIFICADOS_POR_VENCER"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_dias_alerta", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = diasAlerta})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error CertificadosPorVencer: " & ex.Message)
        End Try
        Return dt
    End Function

    ' ─────────────────────────────────────────────
    ' REPORTE FLOTA GENERAL
    ' ─────────────────────────────────────────────
    Public Function ReporteFlotaGeneral() As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REPORTE_FLOTA_GENERAL"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ReporteFlotaGeneral: " & ex.Message)
        End Try
        Return dt
    End Function
    Public Function RegistrarAvion(idModelo As Integer,
                                idAerolinea As Integer,
                                matricula As String,
                                numSerie As String,
                                annoFab As Integer) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_AVION"

                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_modelo", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = idModelo})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_aerolinea", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = idAerolinea})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_config", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = DBNull.Value})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_matricula", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = matricula})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_numero_serie", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = numSerie})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_anno_fab", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = annoFab})

                    Dim pIdAvion As New OracleParameter(
                        "p_id_avion", OracleDbType.Int32)
                    pIdAvion.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pIdAvion)

                    Dim pRes As New OracleParameter(
                        "p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)

                    Dim pMsg As New OracleParameter(
                        "p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)

                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error RegistrarAvion: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function RegistrarMantenimiento(idAvion As Integer,
                                        tipo As String,
                                        descripcion As String,
                                        fechaInicio As String,
                                        fechaFin As String,
                                        proveedor As String,
                                        costo As Decimal) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_MANTENIMIENTO"

                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_tipo", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = tipo})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_descripcion", OracleDbType.Clob) With {
                        .Direction = ParameterDirection.Input, .Value = descripcion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fecha_inicio", OracleDbType.TimeStampTZ) With {
                        .Direction = ParameterDirection.Input,
                        .Value = DateTime.Parse(fechaInicio)})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fecha_fin", OracleDbType.TimeStampTZ) With {
                        .Direction = ParameterDirection.Input,
                        .Value = DateTime.Parse(fechaFin)})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_proveedor", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = proveedor})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_costo_usd", OracleDbType.Decimal) With {
                        .Direction = ParameterDirection.Input, .Value = costo})

                    Dim pRes As New OracleParameter("p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)

                    Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)

                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error RegistrarMantenimiento: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function RegistrarAveria(idAvion As Integer,
                                     descripcion As String,
                                     severidad As String) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_AVERIA"

                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_descripcion", OracleDbType.Clob) With {
                        .Direction = ParameterDirection.Input, .Value = descripcion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_severidad", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = severidad})

                    Dim pRes As New OracleParameter("p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)

                    Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)

                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error RegistrarAveria: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function ObtenerHistorialManten(idAvion As Integer) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_HISTORIAL_MANTEN"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerHistorialManten: " & ex.Message)
        End Try
        Return dt
    End Function


    Public Function RegistrarCertificado(idAvion As Integer,
                                      tipo As String,
                                      numero As String,
                                      autoridad As String,
                                      fechaEmision As DateTime,
                                      fechaVence As DateTime) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_CERTIFICADO"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_tipo", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = tipo})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_numero", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = numero})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_autoridad", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = autoridad})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fecha_emision", OracleDbType.Date) With {
                        .Direction = ParameterDirection.Input, .Value = fechaEmision})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fecha_vence", OracleDbType.Date) With {
                        .Direction = ParameterDirection.Input, .Value = fechaVence})
                    Dim pRes As New OracleParameter("p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)
                    Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)
                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error RegistrarCertificado: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function ObtenerCertificados(idAvion As Integer) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_CERTIFICADOS"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerCertificados: " & ex.Message)
        End Try
        Return dt
    End Function

    Public Function ReporteAvionesPorEstado(estado As String) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REPORTE_AVIONES_POR_ESTADO"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_estado", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input,
                        .Value = If(estado = "", DBNull.Value, CObj(estado))})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ReporteAvionesPorEstado: " & ex.Message)
        End Try
        Return dt
    End Function

    Public Function ReporteMantenimientosPeriodo(fechaIni As DateTime,
                                                  fechaFin As DateTime) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REPORTE_MANTENIMIENTOS_PERIODO"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fecha_ini", OracleDbType.Date) With {
                        .Direction = ParameterDirection.Input, .Value = fechaIni})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fecha_fin", OracleDbType.Date) With {
                        .Direction = ParameterDirection.Input, .Value = fechaFin})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ReporteMantenimientosPeriodo: " & ex.Message)
        End Try
        Return dt
    End Function

    Public Function EstadisticasFlota() As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_ESTADISTICAS_FLOTA"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_aerolinea", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input,
                        .Value = DBNull.Value})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error EstadisticasFlota: " & ex.Message)
        End Try
        Return dt
    End Function

    Public Function RegistrarProveedor(nombre As String,
                                        pais As Integer,
                                        contacto As String,
                                        email As String,
                                        telefono As String) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_PROVEEDOR"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_nombre", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = nombre})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_pais", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = pais})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_contacto", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = contacto})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_email", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = email})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_telefono", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = telefono})
                    Dim pRes As New OracleParameter("p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)
                    Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)
                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error RegistrarProveedor: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function AsignarProveedorAvion(idAvion As Integer,
                                           idProveedor As Integer,
                                           tipoServicio As String) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_ASIGNAR_PROVEEDOR_AVION"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_avion", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAvion})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_proveedor", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idProveedor})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_tipo_servicio", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = tipoServicio})
                    Dim pRes As New OracleParameter("p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)
                    Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)
                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error AsignarProveedorAvion: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function ObtenerProveedores() As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_PROVEEDORES"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerProveedores: " & ex.Message)
        End Try
        Return dt
    End Function


    Public Function InsertarModelo(idAerolinea As Integer,
                                    fabricante As String,
                                    modelo As String,
                                    capPax As Integer,
                                    alcance As Double,
                                    autonomia As Double) As String
        Dim mensaje As String = ""
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_INSERTAR_MODELO"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_aerolinea", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAerolinea})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_fabricante", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = fabricante})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_modelo", OracleDbType.Varchar2) With {
                        .Direction = ParameterDirection.Input, .Value = modelo})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cap_pax_max", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = capPax})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_alcance_km", OracleDbType.Double) With {
                        .Direction = ParameterDirection.Input, .Value = alcance})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_autonomia_horas", OracleDbType.Double) With {
                        .Direction = ParameterDirection.Input, .Value = autonomia})
                    Dim pRes As New OracleParameter("p_resultado", OracleDbType.Int32)
                    pRes.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pRes)
                    Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500)
                    pMsg.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(pMsg)
                    cmd.ExecuteNonQuery()
                    mensaje = pMsg.Value.ToString()
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error InsertarModelo: " & ex.Message)
        End Try
        Return mensaje
    End Function

    Public Function ObtenerTodosModelos() As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_TODOS_MODELOS"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerTodosModelos: " & ex.Message)
        End Try
        Return dt
    End Function

    Public Function ObtenerModelosAerolinea(idAerolinea As Integer) As DataTable
        Dim dt As New DataTable()
        Try
            Using conn As OracleConnection = ConexionDB.Conectar()
                Using cmd As New OracleCommand()
                    cmd.Connection = conn
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.CommandText = "PKG_AEROLINEAS_FLOTA.SP_OBTENER_MODELOS_AEROLINEA"
                    cmd.Parameters.Add(New OracleParameter(
                        "p_id_aerolinea", OracleDbType.Int32) With {
                        .Direction = ParameterDirection.Input, .Value = idAerolinea})
                    cmd.Parameters.Add(New OracleParameter(
                        "p_cursor", OracleDbType.RefCursor) With {
                        .Direction = ParameterDirection.Output})
                    Using da As New OracleDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                End Using
            End Using
        Catch ex As Exception
            Throw New Exception("Error ObtenerModelosAerolinea: " & ex.Message)
        End Try
        Return dt
    End Function
End Class
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Public Class RrhhDAO

    Private Shared ReadOnly PKG As String = "PKG_RRHH"

    Private Shared Function NuevoParam(nombre As String,
                                       tipo As OracleDbType,
                                       valor As Object) As OracleParameter
        Dim op As New OracleParameter(nombre, tipo)
        op.Direction = ParameterDirection.Input
        op.Value = If(valor Is Nothing, DBNull.Value, valor)
        Return op
    End Function

    Private Shared Function NuevoParamOut(nombre As String,
                                          tipo As OracleDbType,
                                          Optional size As Integer = 0) As OracleParameter
        Dim op As New OracleParameter(nombre, tipo)
        If size > 0 Then op.Size = size
        op.Direction = ParameterDirection.Output
        Return op
    End Function

    Private Shared Function Consultar(sp As String,
                                      lista As List(Of OracleParameter)) As DataTable
        Dim dt As New DataTable()
        Dim connStr As String = System.Web.Configuration.WebConfigurationManager _
            .ConnectionStrings("AeroGTReadOnly").ConnectionString
        Using conn As New OracleConnection(connStr)
            Using cmd As New OracleCommand(PKG & "." & sp, conn)
                cmd.CommandType = CommandType.StoredProcedure
                For Each item In lista
                    cmd.Parameters.Add(item)
                Next
                Dim cur As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                cur.Direction = ParameterDirection.Output
                cmd.Parameters.Add(cur)
                conn.Open()
                Using da As New OracleDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Shared Sub Modificar(sp As String,
                                  lista As List(Of OracleParameter))
        Dim connStr As String = System.Web.Configuration.WebConfigurationManager _
            .ConnectionStrings("AeroGTConnection").ConnectionString
        Using conn As New OracleConnection(connStr)
            Using cmd As New OracleCommand(PKG & "." & sp, conn)
                cmd.CommandType = CommandType.StoredProcedure
                For Each item In lista
                    cmd.Parameters.Add(item)
                Next
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ' ═══════════════════════════════════════════
    ' DEPARTAMENTOS
    ' ═══════════════════════════════════════════
    Public Function ObtenerDepartamentos() As DataTable
        Return Consultar("SP_OBTENER_DEPARTAMENTOS",
                         New List(Of OracleParameter))
    End Function

    ' ═══════════════════════════════════════════
    ' PUESTOS
    ' ═══════════════════════════════════════════
    Public Function ObtenerPuestos() As DataTable
        Return Consultar("SP_OBTENER_PUESTOS",
                         New List(Of OracleParameter))
    End Function

    ' ═══════════════════════════════════════════
    ' EMPLEADOS
    ' ═══════════════════════════════════════════
    Public Function ObtenerEmpleados() As DataTable
        Return Consultar("SP_OBTENER_EMPLEADOS",
                         New List(Of OracleParameter))
    End Function

    Public Function ObtenerEmpleadoPorId(idEmpleado As Integer) As DataTable
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        Return Consultar("SP_OBTENER_EMPLEADO_POR_ID", lista)
    End Function

    Public Sub InsertarEmpleado(idPuesto As Integer,
                                idDepto As Integer,
                                codigo As String,
                                nombres As String,
                                apellidos As String,
                                dpi As String,
                                email As String,
                                fechaIngreso As Date,
                                ByRef resultado As Integer,
                                ByRef mensaje As String)
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_puesto", OracleDbType.Int32, idPuesto))
        lista.Add(NuevoParam("p_id_depto", OracleDbType.Int32, idDepto))
        lista.Add(NuevoParam("p_codigo", OracleDbType.Varchar2, codigo))
        lista.Add(NuevoParam("p_nombres", OracleDbType.Varchar2, nombres))
        lista.Add(NuevoParam("p_apellidos", OracleDbType.Varchar2, apellidos))
        lista.Add(NuevoParam("p_dpi", OracleDbType.Varchar2, dpi))
        lista.Add(NuevoParam("p_email", OracleDbType.Varchar2, email))
        lista.Add(NuevoParam("p_fecha_ingreso", OracleDbType.Date, fechaIngreso))
        Dim opRes = NuevoParamOut("p_resultado", OracleDbType.Int32)
        Dim opMsg = NuevoParamOut("p_mensaje", OracleDbType.Varchar2, 500)
        lista.Add(opRes)
        lista.Add(opMsg)
        Modificar("SP_INSERTAR_EMPLEADO", lista)
        resultado = CInt(opRes.Value)
        mensaje = opMsg.Value.ToString()
    End Sub

    Public Sub ActualizarEstadoEmpleado(idEmpleado As Integer,
                                        estado As String,
                                        ByRef resultado As Integer,
                                        ByRef mensaje As String)
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        lista.Add(NuevoParam("p_estado", OracleDbType.Varchar2, estado))
        Dim opRes = NuevoParamOut("p_resultado", OracleDbType.Int32)
        Dim opMsg = NuevoParamOut("p_mensaje", OracleDbType.Varchar2, 500)
        lista.Add(opRes)
        lista.Add(opMsg)
        Modificar("SP_ACTUALIZAR_ESTADO_EMPLEADO", lista)
        resultado = CInt(opRes.Value)
        mensaje = opMsg.Value.ToString()
    End Sub

    ' ═══════════════════════════════════════════
    ' CONTRATOS
    ' ═══════════════════════════════════════════
    Public Sub RegistrarContrato(idEmpleado As Integer,
                                  tipo As String,
                                  fechaInicio As Date,
                                  salario As Decimal,
                                  jornada As String,
                                  ByRef resultado As Integer,
                                  ByRef mensaje As String)
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        lista.Add(NuevoParam("p_tipo", OracleDbType.Varchar2, tipo))
        lista.Add(NuevoParam("p_fecha_inicio", OracleDbType.Date, fechaInicio))
        lista.Add(NuevoParam("p_salario", OracleDbType.Decimal, salario))
        lista.Add(NuevoParam("p_jornada", OracleDbType.Varchar2, jornada))
        Dim opRes = NuevoParamOut("p_resultado", OracleDbType.Int32)
        Dim opMsg = NuevoParamOut("p_mensaje", OracleDbType.Varchar2, 500)
        lista.Add(opRes)
        lista.Add(opMsg)
        Modificar("SP_REGISTRAR_CONTRATO", lista)
        resultado = CInt(opRes.Value)
        mensaje = opMsg.Value.ToString()
    End Sub

    ' ═══════════════════════════════════════════
    ' TURNOS
    ' ═══════════════════════════════════════════
    Public Function ObtenerTurnos() As DataTable
        Return Consultar("SP_OBTENER_TURNOS",
                         New List(Of OracleParameter))
    End Function

    Public Sub AsignarTurno(idEmpleado As Integer,
                             idTurno As Integer,
                             fechaDesde As Date,
                             ByRef resultado As Integer,
                             ByRef mensaje As String)
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        lista.Add(NuevoParam("p_id_turno", OracleDbType.Int32, idTurno))
        lista.Add(NuevoParam("p_fecha_desde", OracleDbType.Date, fechaDesde))
        Dim opRes = NuevoParamOut("p_resultado", OracleDbType.Int32)
        Dim opMsg = NuevoParamOut("p_mensaje", OracleDbType.Varchar2, 500)
        lista.Add(opRes)
        lista.Add(opMsg)
        Modificar("SP_ASIGNAR_TURNO", lista)
        resultado = CInt(opRes.Value)
        mensaje = opMsg.Value.ToString()
    End Sub

    ' ═══════════════════════════════════════════
    ' ASISTENCIA
    ' ═══════════════════════════════════════════
    Public Sub RegistrarEntrada(idEmpleado As Integer,
                                 ByRef resultado As Integer,
                                 ByRef mensaje As String)
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        Dim opRes = NuevoParamOut("p_resultado", OracleDbType.Int32)
        Dim opMsg = NuevoParamOut("p_mensaje", OracleDbType.Varchar2, 500)
        lista.Add(opRes)
        lista.Add(opMsg)
        Modificar("SP_REGISTRAR_ENTRADA", lista)
        resultado = CInt(opRes.Value)
        mensaje = opMsg.Value.ToString()
    End Sub

    Public Function ObtenerAsistenciaMes(idEmpleado As Integer,
                                          anio As Integer,
                                          mes As Integer) As DataTable
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        lista.Add(NuevoParam("p_anio", OracleDbType.Int32, anio))
        lista.Add(NuevoParam("p_mes", OracleDbType.Int32, mes))
        Return Consultar("SP_REPORTE_ASISTENCIA_MES", lista)
    End Function

    ' ═══════════════════════════════════════════
    ' TRIPULACION
    ' ═══════════════════════════════════════════
    Public Sub AsignarTripulacion(idEmpleado As Integer,
                                   idInstancia As Integer,
                                   rol As String,
                                   esComandante As String,
                                   ByRef resultado As Integer,
                                   ByRef mensaje As String)
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_empleado", OracleDbType.Int32, idEmpleado))
        lista.Add(NuevoParam("p_id_instancia", OracleDbType.Int32, idInstancia))
        lista.Add(NuevoParam("p_rol", OracleDbType.Varchar2, rol))
        lista.Add(NuevoParam("p_comandante", OracleDbType.Char, esComandante))
        Dim opRes = NuevoParamOut("p_resultado", OracleDbType.Int32)
        Dim opMsg = NuevoParamOut("p_mensaje", OracleDbType.Varchar2, 500)
        lista.Add(opRes)
        lista.Add(opMsg)
        Modificar("SP_ASIGNAR_TRIPULACION", lista)
        resultado = CInt(opRes.Value)
        mensaje = opMsg.Value.ToString()
    End Sub

    Public Function ObtenerTripulacionVuelo(idInstancia As Integer) As DataTable
        Dim lista As New List(Of OracleParameter)
        lista.Add(NuevoParam("p_id_instancia", OracleDbType.Int32, idInstancia))
        Return Consultar("SP_OBTENER_TRIPULACION_VUELO", lista)
    End Function

End Class
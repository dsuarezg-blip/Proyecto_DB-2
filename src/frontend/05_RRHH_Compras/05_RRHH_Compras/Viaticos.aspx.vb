Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration
Imports System.Web.UI.WebControls

Partial Class Viaticos
    Inherits System.Web.UI.Page

    Private ReadOnly ConnWrite As String = WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
    Private ReadOnly ConnRead  As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarEmpleados()
            CargarViaticos()
            CargarResumen()
        End If
    End Sub

    Private Sub CargarEmpleados()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_EMPLEADOS", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_estado",   OracleDbType.Varchar2).Value = "ACTIVO"
            cmd.Parameters.Add("p_id_depto", OracleDbType.Decimal).Value  = DBNull.Value
            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
            pCursor.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCursor)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)

            ddlEmpleado.Items.Clear()
            ddlEmpleado.Items.Add(New ListItem("— Seleccionar —", ""))
            ddlEmpleadoFiltro.Items.Clear()
            ddlEmpleadoFiltro.Items.Add(New ListItem("— Todos —", ""))
            ddlAprobadoPor.Items.Clear()
            ddlAprobadoPor.Items.Add(New ListItem("— Sin especificar —", ""))
            For Each row As DataRow In dt.Rows
                ddlEmpleado.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
                ddlEmpleadoFiltro.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
                ddlAprobadoPor.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
            Next
        End Using
    End Sub

    Private Sub CargarViaticos(Optional idEmp As Object = Nothing, Optional estado As String = "")
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_VIATICOS", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value =
                If(idEmp Is Nothing OrElse idEmp.ToString() = "", DBNull.Value, CInt(idEmp))
            cmd.Parameters.Add("p_estado", OracleDbType.Varchar2).Value =
                If(estado = "", DBNull.Value, estado)
            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
            pCursor.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCursor)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            gvViaticos.DataSource = dt : gvViaticos.DataBind()
        End Using
    End Sub

    Private Sub CargarResumen()
        Dim estados()  As String = {"PENDIENTE", "APROBADO", "LIQUIDADO", "RECHAZADO"}
        Dim labels()   As Label  = {lblPendientes, lblAprobados, lblLiquidados, lblRechazados}
        Using con As New OracleConnection(ConnRead)
            con.Open()
            For i As Integer = 0 To 3
                Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_VIATICOS", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value  = DBNull.Value
                cmd.Parameters.Add("p_estado",      OracleDbType.Varchar2).Value = estados(i)
                Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
                pCursor.Direction = ParameterDirection.Output
                cmd.Parameters.Add(pCursor)
                Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
                labels(i).Text = dt.Rows.Count.ToString()
                cmd.Parameters.Clear()
            Next
        End Using
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
        Dim idEmp As Object = If(ddlEmpleadoFiltro.SelectedValue = "", Nothing, ddlEmpleadoFiltro.SelectedValue)
        CargarViaticos(idEmp, ddlEstadoFiltro.SelectedValue)
    End Sub

    Protected Sub btnGuardarViatico_Click(sender As Object, e As EventArgs)
        If ddlEmpleado.SelectedValue = "" OrElse txtDestino.Text.Trim() = "" OrElse txtFechaSalida.Text = "" OrElse txtMonto.Text = "" Then
            MostrarAlerta("Complete todos los campos requeridos.", "warning") : Return
        End If
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_SOLICITAR_VIATICO", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado",    OracleDbType.Decimal).Value  = CInt(ddlEmpleado.SelectedValue)
            cmd.Parameters.Add("p_destino",        OracleDbType.Varchar2).Value = txtDestino.Text.Trim()
            cmd.Parameters.Add("p_fecha_salida",   OracleDbType.Date).Value     = Date.Parse(txtFechaSalida.Text)
            cmd.Parameters.Add("p_fecha_retorno",  OracleDbType.Date).Value     = If(txtFechaRetorno.Text = "", DBNull.Value, Date.Parse(txtFechaRetorno.Text))
            cmd.Parameters.Add("p_monto_aprobado", OracleDbType.Decimal).Value  = CDec(txtMonto.Text)
            cmd.Parameters.Add("p_aprobado_por",   OracleDbType.Decimal).Value  = If(ddlAprobadoPor.SelectedValue = "", DBNull.Value, CInt(ddlAprobadoPor.SelectedValue))
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pRes) : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Solicitud registrada correctamente.", "success")
                LimpiarForm() : CargarViaticos() : CargarResumen()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Protected Sub gvViaticos_Command(sender As Object, e As CommandEventArgs)
        Dim idViatico As Integer = CInt(e.CommandArgument)
        Select Case e.CommandName
            Case "Aprobar"  : CambiarEstado(idViatico, "APROBADO")
            Case "Rechazar" : CambiarEstado(idViatico, "RECHAZADO")
            Case "Liquidar"
                hfIdViatico.Value = idViatico.ToString()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "openLiquidar",
                    "var m = new bootstrap.Modal(document.getElementById('modalLiquidar')); m.show();", True)
        End Select
    End Sub

    Private Sub CambiarEstado(idViatico As Integer, estado As String)
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_CAMBIAR_ESTADO_VIATICO", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_viatico", OracleDbType.Decimal).Value  = idViatico
            cmd.Parameters.Add("p_estado",     OracleDbType.Varchar2).Value = estado
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pRes) : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Estado actualizado a " & estado & ".", "success")
                CargarViaticos() : CargarResumen()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Protected Sub btnConfirmarLiquidar_Click(sender As Object, e As EventArgs)
        If hfIdViatico.Value = "" OrElse txtMontoGastado.Text = "" Then Return
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_LIQUIDAR_VIATICO", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_viatico",    OracleDbType.Decimal).Value = CInt(hfIdViatico.Value)
            cmd.Parameters.Add("p_monto_gastado", OracleDbType.Decimal).Value = CDec(txtMontoGastado.Text)
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pRes) : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Viático liquidado correctamente.", "success")
                txtMontoGastado.Text = "" : CargarViaticos() : CargarResumen()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Public Function GetBadgeClass(estado As Object) As String
        Select Case estado?.ToString()
            Case "PENDIENTE" : Return "badge-pendiente"
            Case "APROBADO"  : Return "badge-aprobado"
            Case "LIQUIDADO" : Return "badge-liquidado"
            Case "RECHAZADO" : Return "badge-rechazado"
            Case Else        : Return "badge bg-secondary"
        End Select
    End Function

    Public Function GetSaldoClass(saldo As Object) As String
        If saldo Is Nothing OrElse saldo Is DBNull.Value Then Return "saldo-pos"
        Return If(CDec(saldo) >= 0, "saldo-pos", "saldo-neg")
    End Function

    Private Sub LimpiarForm()
        ddlEmpleado.SelectedIndex = 0 : txtDestino.Text = ""
        txtFechaSalida.Text = "" : txtFechaRetorno.Text = ""
        txtMonto.Text = "" : ddlAprobadoPor.SelectedIndex = 0
    End Sub

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible  = True
        pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4"
        lblAlerta.Text     = msg
    End Sub

End Class

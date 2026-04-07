Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration

Partial Class EquipoProteccion
    Inherits System.Web.UI.Page

    Private ReadOnly ConnWrite As String = WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
    Private ReadOnly ConnRead  As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then : CargarEmpleados() : CargarGrid() : End If
    End Sub

    Private Sub CargarEmpleados()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_EMPLEADOS", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_estado",   OracleDbType.Varchar2).Value = "ACTIVO"
            cmd.Parameters.Add("p_id_depto", OracleDbType.Decimal).Value  = DBNull.Value
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            ddlEmpleado.Items.Clear() : ddlEmpleado.Items.Add(New ListItem("— Seleccionar —", ""))
            ddlEmpleadoFiltro.Items.Clear() : ddlEmpleadoFiltro.Items.Add(New ListItem("— Todos —", ""))
            For Each row As DataRow In dt.Rows
                ddlEmpleado.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
                ddlEmpleadoFiltro.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
            Next
        End Using
    End Sub

    Private Sub CargarGrid(Optional idEmp As Object = Nothing)
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_EPP_EMPLEADO", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value = If(idEmp Is Nothing OrElse idEmp.ToString() = "", DBNull.Value, CInt(idEmp))
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            gvEPP.DataSource = dt : gvEPP.DataBind()
        End Using
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
        CargarGrid(If(ddlEmpleadoFiltro.SelectedValue = "", Nothing, ddlEmpleadoFiltro.SelectedValue))
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        If ddlEmpleado.SelectedValue = "" OrElse ddlTipoEquipo.SelectedValue = "" OrElse txtFechaEntrega.Text = "" Then
            MostrarAlerta("Complete los campos requeridos.", "warning") : Return
        End If
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_ENTREGAR_EPP", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado",  OracleDbType.Decimal).Value  = CInt(ddlEmpleado.SelectedValue)
            cmd.Parameters.Add("p_tipo_equipo",  OracleDbType.Varchar2).Value = ddlTipoEquipo.SelectedValue
            cmd.Parameters.Add("p_descripcion",  OracleDbType.Varchar2).Value = If(txtDescripcion.Text.Trim() = "", DBNull.Value, txtDescripcion.Text.Trim())
            cmd.Parameters.Add("p_talla",        OracleDbType.Varchar2).Value = If(txtTalla.Text.Trim() = "", DBNull.Value, txtTalla.Text.Trim())
            cmd.Parameters.Add("p_fecha_entrega", OracleDbType.Date).Value    = Date.Parse(txtFechaEntrega.Text)
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("EPP registrado correctamente.", "success") : CargarGrid()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Protected Sub gvEPP_Command(sender As Object, e As CommandEventArgs)
        If e.CommandName = "Devolver" Then
            Using con As New OracleConnection(ConnWrite)
                Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_DEVOLVER_EPP", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_id_epp",          OracleDbType.Decimal).Value = CInt(e.CommandArgument)
                cmd.Parameters.Add("p_fecha_devolucion", OracleDbType.Date).Value   = Date.Today
                Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
                Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
                con.Open() : cmd.ExecuteNonQuery()
                If CInt(pRes.Value) = 1 Then
                    MostrarAlerta("EPP marcado como devuelto.", "success") : CargarGrid()
                Else
                    MostrarAlerta(pMsg.Value.ToString(), "danger")
                End If
            End Using
        End If
    End Sub

    Public Function GetBadgeClass(estado As Object) As String
        Select Case estado?.ToString()
            Case "ENTREGADO" : Return "badge-entregado"
            Case "DEVUELTO"  : Return "badge-devuelto"
            Case "PERDIDO"   : Return "badge-perdido"
            Case Else        : Return "badge bg-secondary"
        End Select
    End Function

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible = True : pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4" : lblAlerta.Text = msg
    End Sub
End Class

Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration

Partial Class PermisosUnion
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
            cmd.Parameters.Add("p_estado",   OracleDbType.Varchar2).Value = DBNull.Value
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
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_PERMISOS_UNION", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value = If(idEmp Is Nothing OrElse idEmp.ToString() = "", DBNull.Value, CInt(idEmp))
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            gvPermisos.DataSource = dt : gvPermisos.DataBind()
        End Using
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
        CargarGrid(If(ddlEmpleadoFiltro.SelectedValue = "", Nothing, ddlEmpleadoFiltro.SelectedValue))
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        If ddlEmpleado.SelectedValue = "" OrElse ddlTipoPermiso.SelectedValue = "" OrElse txtFechaInicio.Text = "" OrElse txtFechaFin.Text = "" Then
            MostrarAlerta("Complete los campos requeridos.", "warning") : Return
        End If
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_REGISTRAR_PERMISO_UNION", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado",  OracleDbType.Decimal).Value  = CInt(ddlEmpleado.SelectedValue)
            cmd.Parameters.Add("p_tipo_permiso", OracleDbType.Varchar2).Value = ddlTipoPermiso.SelectedValue
            cmd.Parameters.Add("p_fecha_inicio", OracleDbType.Date).Value     = Date.Parse(txtFechaInicio.Text)
            cmd.Parameters.Add("p_fecha_fin",    OracleDbType.Date).Value     = Date.Parse(txtFechaFin.Text)
            cmd.Parameters.Add("p_motivo",       OracleDbType.Varchar2).Value = If(txtMotivo.Text.Trim() = "", DBNull.Value, txtMotivo.Text.Trim())
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Permiso registrado.", "success") : CargarGrid()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible = True : pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4" : lblAlerta.Text = msg
    End Sub
End Class

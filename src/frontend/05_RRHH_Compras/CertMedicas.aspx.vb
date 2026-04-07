Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration

Partial Class CertMedicas
    Inherits System.Web.UI.Page

    Private ReadOnly ConnWrite As String = WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
    Private ReadOnly ConnRead  As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarEmpleados()
            CargarGrid()
        End If
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

    Private Sub CargarGrid(Optional idEmp As Object = Nothing, Optional estado As String = "")
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_CERT_MEDICAS", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value = If(idEmp Is Nothing OrElse idEmp.ToString() = "", DBNull.Value, CInt(idEmp))
            cmd.Parameters.Add("p_estado",      OracleDbType.Varchar2).Value = If(estado = "", DBNull.Value, estado)
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            gvCertMedicas.DataSource = dt : gvCertMedicas.DataBind()
        End Using
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
        Dim idEmp As Object = If(ddlEmpleadoFiltro.SelectedValue = "", Nothing, ddlEmpleadoFiltro.SelectedValue)
        CargarGrid(idEmp, ddlEstadoFiltro.SelectedValue)
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        If ddlEmpleado.SelectedValue = "" OrElse ddlTipoExamen.SelectedValue = "" OrElse txtFechaExamen.Text = "" OrElse txtFechaVenc.Text = "" OrElse ddlResultado.SelectedValue = "" Then
            MostrarAlerta("Complete todos los campos requeridos.", "warning") : Return
        End If
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_REGISTRAR_CERT_MEDICA", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado",   OracleDbType.Decimal).Value  = CInt(ddlEmpleado.SelectedValue)
            cmd.Parameters.Add("p_tipo_examen",   OracleDbType.Varchar2).Value = ddlTipoExamen.SelectedValue
            cmd.Parameters.Add("p_medico",        OracleDbType.Varchar2).Value = If(txtMedico.Text.Trim() = "", DBNull.Value, txtMedico.Text.Trim())
            cmd.Parameters.Add("p_centro_medico", OracleDbType.Varchar2).Value = If(txtCentroMedico.Text.Trim() = "", DBNull.Value, txtCentroMedico.Text.Trim())
            cmd.Parameters.Add("p_fecha_examen",  OracleDbType.Date).Value     = Date.Parse(txtFechaExamen.Text)
            cmd.Parameters.Add("p_fecha_venc",    OracleDbType.Date).Value     = Date.Parse(txtFechaVenc.Text)
            cmd.Parameters.Add("p_resultado",     OracleDbType.Varchar2).Value = ddlResultado.SelectedValue
            cmd.Parameters.Add("p_observaciones", OracleDbType.Varchar2).Value = If(txtObservaciones.Text.Trim() = "", DBNull.Value, txtObservaciones.Text.Trim())
            Dim pRes As New OracleParameter("p_resultado_op", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Certificado registrado correctamente.", "success") : CargarGrid()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Public Function GetBadgeClass(estado As Object) As String
        Select Case estado?.ToString()
            Case "VIGENTE"   : Return "badge-vigente"
            Case "VENCIDO"   : Return "badge-vencido"
            Case "PENDIENTE" : Return "badge-pendiente"
            Case Else        : Return "badge bg-secondary"
        End Select
    End Function

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible = True : pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4" : lblAlerta.Text = msg
    End Sub
End Class

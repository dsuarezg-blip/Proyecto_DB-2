Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration

Partial Class Licencias
    Inherits System.Web.UI.Page

    Private ReadOnly ConnWrite As String = WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
    Private ReadOnly ConnRead  As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarEmpleados()
            CargarLicencias()
            CargarPorVencer()
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
            Dim da As New OracleDataAdapter(cmd)
            Dim dt As New DataTable
            da.Fill(dt)

            ddlEmpleado.Items.Clear()
            ddlEmpleado.Items.Add(New ListItem("— Seleccionar empleado —", ""))
            ddlEmpleadoFiltro.Items.Clear()
            ddlEmpleadoFiltro.Items.Add(New ListItem("— Todos —", ""))
            For Each row As DataRow In dt.Rows
                ddlEmpleado.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
                ddlEmpleadoFiltro.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
            Next
        End Using
    End Sub

    Private Sub CargarLicencias(Optional idEmpleado As Object = Nothing, Optional estadoVig As String = "")
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_LICENCIAS_EMPLEADO", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value =
                If(idEmpleado Is Nothing OrElse idEmpleado.ToString() = "", DBNull.Value, CInt(idEmpleado))
            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
            pCursor.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCursor)
            con.Open()
            Dim da As New OracleDataAdapter(cmd)
            Dim dt As New DataTable
            da.Fill(dt)

            If estadoVig <> "" Then
                Dim dtF As DataTable = dt.Clone()
                For Each r As DataRow In dt.Select("estado_vigencia = '" & estadoVig & "'")
                    dtF.ImportRow(r)
                Next
                gvLicencias.DataSource = dtF
            Else
                gvLicencias.DataSource = dt
            End If
            gvLicencias.DataBind()
        End Using
    End Sub

    Private Sub CargarPorVencer()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_LICENCIAS_POR_VENCER", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_dias_umbral", OracleDbType.Decimal).Value = 90
            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
            pCursor.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCursor)
            con.Open()
            Dim da As New OracleDataAdapter(cmd)
            Dim dt As New DataTable
            da.Fill(dt)
            gvPorVencer.DataSource = dt
            gvPorVencer.DataBind()
            lblContPorVencer.Text = dt.Rows.Count.ToString()
        End Using
    End Sub

    Protected Sub btnFiltrar_Click(sender As Object, e As EventArgs)
        Dim idEmp As Object = If(ddlEmpleadoFiltro.SelectedValue = "", Nothing, ddlEmpleadoFiltro.SelectedValue)
        CargarLicencias(idEmp, ddlEstadoFiltro.SelectedValue)
    End Sub

    Protected Sub btnGuardarLicencia_Click(sender As Object, e As EventArgs)
        If ddlEmpleado.SelectedValue = "" OrElse txtNumero.Text.Trim() = "" OrElse txtFechaEmision.Text = "" OrElse txtFechaVenc.Text = "" Then
            MostrarAlerta("Complete todos los campos requeridos.", "warning")
            Return
        End If
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_REGISTRAR_LICENCIA", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado",       OracleDbType.Decimal).Value  = CInt(ddlEmpleado.SelectedValue)
            cmd.Parameters.Add("p_tipo",              OracleDbType.Varchar2).Value = ddlTipoLic.SelectedValue
            cmd.Parameters.Add("p_numero",            OracleDbType.Varchar2).Value = txtNumero.Text.Trim()
            cmd.Parameters.Add("p_organismo_emisor",  OracleDbType.Varchar2).Value = If(txtOrganismo.Text.Trim() = "", DBNull.Value, txtOrganismo.Text.Trim())
            cmd.Parameters.Add("p_pais_emisor",       OracleDbType.Decimal).Value  = DBNull.Value
            cmd.Parameters.Add("p_fecha_emision",     OracleDbType.Date).Value     = Date.Parse(txtFechaEmision.Text)
            cmd.Parameters.Add("p_fecha_vencimiento", OracleDbType.Date).Value     = Date.Parse(txtFechaVenc.Text)
            cmd.Parameters.Add("p_habilitaciones",    OracleDbType.Varchar2).Value = If(txtHabilitaciones.Text.Trim() = "", DBNull.Value, txtHabilitaciones.Text.Trim())
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pRes) : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Licencia registrada correctamente.", "success")
                LimpiarForm() : CargarLicencias() : CargarPorVencer()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Protected Sub gvLicencias_Command(sender As Object, e As CommandEventArgs)
        If e.CommandName = "Renovar" Then
            hfIdLicencia.Value = e.CommandArgument.ToString()
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "openRenovar",
                "var m = new bootstrap.Modal(document.getElementById('modalRenovar')); m.show();", True)
        End If
    End Sub

    Protected Sub btnConfirmarRenovar_Click(sender As Object, e As EventArgs)
        If hfIdLicencia.Value = "" OrElse txtNuevaFechaVenc.Text = "" Then Return
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_ACTUALIZAR_LICENCIA", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_licencia",       OracleDbType.Decimal).Value  = CInt(hfIdLicencia.Value)
            cmd.Parameters.Add("p_fecha_vencimiento", OracleDbType.Date).Value     = Date.Parse(txtNuevaFechaVenc.Text)
            cmd.Parameters.Add("p_habilitaciones",    OracleDbType.Varchar2).Value = If(txtHabRenovar.Text.Trim() = "", DBNull.Value, txtHabRenovar.Text.Trim())
            cmd.Parameters.Add("p_activa",            OracleDbType.Char).Value     = "S"
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pRes) : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Licencia renovada correctamente.", "success")
                CargarLicencias() : CargarPorVencer()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Public Function GetBadgeClass(estado As Object) As String
        Select Case estado?.ToString()
            Case "VIGENTE"    : Return "badge-vigente"
            Case "POR_VENCER" : Return "badge-por-vencer"
            Case "VENCIDA"    : Return "badge-vencida"
            Case Else         : Return "badge bg-secondary"
        End Select
    End Function

    Public Function GetDiasClass(dias As Object) As String
        Dim d As Integer = If(dias Is Nothing OrElse dias Is DBNull.Value, -999, CInt(dias))
        If d < 0  Then Return "dias-bad"
        If d < 90 Then Return "dias-warn"
        Return "dias-ok"
    End Function

    Private Sub LimpiarForm()
        ddlEmpleado.SelectedIndex = 0 : ddlTipoLic.SelectedIndex = 0
        txtNumero.Text = "" : txtOrganismo.Text = ""
        txtFechaEmision.Text = "" : txtFechaVenc.Text = "" : txtHabilitaciones.Text = ""
    End Sub

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible  = True
        pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4"
        lblAlerta.Text     = msg
    End Sub

End Class

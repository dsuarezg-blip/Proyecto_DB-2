Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration

Partial Class Reportes
    Inherits System.Web.UI.Page

    ' Reportes van contra la RÉPLICA (.20)
    Private ReadOnly ConnRead As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtAnio.Text = Date.Today.Year.ToString()
            ddlMes.SelectedValue = Date.Today.Month.ToString()
            CargarEmpleados()
            CargarDeptos()
        End If
    End Sub

    Private Sub CargarEmpleados()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_EMPLEADOS", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_estado",   OracleDbType.Varchar2).Value = DBNull.Value
            cmd.Parameters.Add("p_id_depto", OracleDbType.Decimal).Value  = DBNull.Value
            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
            pCursor.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCursor)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            ddlEmpleado.Items.Clear()
            ddlEmpleado.Items.Add(New ListItem("— Todos —", ""))
            For Each row As DataRow In dt.Rows
                ddlEmpleado.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
            Next
        End Using
    End Sub

    Private Sub CargarDeptos()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_DEPARTAMENTOS", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim pCursor As New OracleParameter("p_cursor", OracleDbType.RefCursor)
            pCursor.Direction = ParameterDirection.Output
            cmd.Parameters.Add(pCursor)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            ddlDepto.Items.Clear()
            ddlDepto.Items.Add(New ListItem("— Todos —", ""))
            For Each row As DataRow In dt.Rows
                ddlDepto.Items.Add(New ListItem(row("nombre").ToString(), row("id_depto").ToString()))
            Next
        End Using
    End Sub

    Protected Sub btnEjecutar_Click(sender As Object, e As EventArgs)
        Dim ea As String = Request("__EVENTARGUMENT")
        If ea IsNot Nothing AndAlso ea.StartsWith("select:") Then
            ActivarPaneles(ea.Replace("select:", ""))
            Return
        End If
        If hfReporte.Value = "" Then
            MostrarAlerta("Seleccione un tipo de reporte haciendo clic en una tarjeta.", "warning")
            Return
        End If
        EjecutarReporte(hfReporte.Value)
    End Sub

    Private Sub ActivarPaneles(tipo As String)
        pnlParamEmpleado.Visible = False
        pnlParamDepto.Visible    = False
        pnlParamFecha.Visible    = False
        pnlParamDias.Visible     = False
        hfReporte.Value          = tipo
        Select Case tipo
            Case "plantilla"  : pnlParamDepto.Visible = True
            Case "asistencia" : pnlParamEmpleado.Visible = True : pnlParamDepto.Visible = True : pnlParamFecha.Visible = True
            Case "licencias"  : pnlParamDias.Visible = True
            Case "viaticos"   : pnlParamEmpleado.Visible = True
        End Select
    End Sub

    Private Sub EjecutarReporte(tipo As String)
        Try
            Using con As New OracleConnection(ConnRead)
                Dim cmd As New OracleCommand()
                cmd.Connection  = con
                cmd.CommandType = CommandType.StoredProcedure
                Dim titulo As String = ""

                Select Case tipo
                    Case "plantilla"
                        cmd.CommandText = "PKG_RRHH_QRY.SP_REPORTE_PLANTILLA_COMPLETA"
                        Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
                        titulo = "Plantilla Completa de Empleados"

                    Case "asistencia"
                        If ddlDepto.SelectedValue <> "" Then
                            cmd.CommandText = "PKG_RRHH_QRY.SP_RESUMEN_ASISTENCIA_DEPTO"
                            cmd.Parameters.Add("p_id_depto", OracleDbType.Decimal).Value = CInt(ddlDepto.SelectedValue)
                            cmd.Parameters.Add("p_anio",     OracleDbType.Decimal).Value = CInt(txtAnio.Text)
                            cmd.Parameters.Add("p_mes",      OracleDbType.Decimal).Value = CInt(ddlMes.SelectedValue)
                        Else
                            cmd.CommandText = "PKG_RRHH_QRY.SP_REPORTE_ASISTENCIA_MES"
                            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value = If(ddlEmpleado.SelectedValue = "", DBNull.Value, CInt(ddlEmpleado.SelectedValue))
                            cmd.Parameters.Add("p_anio",        OracleDbType.Decimal).Value = CInt(txtAnio.Text)
                            cmd.Parameters.Add("p_mes",         OracleDbType.Decimal).Value = CInt(ddlMes.SelectedValue)
                        End If
                        Dim pC2 As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC2.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC2)
                        titulo = "Reporte de Asistencia"

                    Case "licencias"
                        cmd.CommandText = "PKG_RRHH_QRY.SP_LISTAR_LICENCIAS_POR_VENCER"
                        cmd.Parameters.Add("p_dias_umbral", OracleDbType.Decimal).Value = If(txtDias.Text = "", 90, CInt(txtDias.Text))
                        Dim pC3 As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC3.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC3)
                        titulo = "Licencias por Vencer"

                    Case "viaticos"
                        cmd.CommandText = "PKG_RRHH_QRY.SP_LISTAR_VIATICOS"
                        cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value  = If(ddlEmpleado.SelectedValue = "", DBNull.Value, CInt(ddlEmpleado.SelectedValue))
                        cmd.Parameters.Add("p_estado",      OracleDbType.Varchar2).Value = "PENDIENTE"
                        Dim pC4 As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC4.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC4)
                        titulo = "Viáticos Pendientes"

                    Case Else
                        MostrarAlerta("Tipo de reporte no reconocido.", "warning") : Return
                End Select

                con.Open()
                Dim da As New OracleDataAdapter(cmd)
                Dim dt As New DataTable
                da.Fill(dt)
                gvResultado.DataSource = dt : gvResultado.DataBind()
                lblTituloResultado.Text = titulo
                lblTotalRegistros.Text  = dt.Rows.Count.ToString()
                pnlResultado.Visible    = True
            End Using
        Catch ex As Exception
            MostrarAlerta("Error al ejecutar el reporte: " & ex.Message, "danger")
        End Try
    End Sub

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible  = True
        pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4"
        lblAlerta.Text     = msg
    End Sub

End Class

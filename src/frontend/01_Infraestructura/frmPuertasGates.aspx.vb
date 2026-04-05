Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmPuertasGates
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.IsAuthenticated Then Response.Redirect("~/06_Seguridad_Finanzas/Seguridad/Login.aspx") : Return
        pnlBtnNuevo.Visible = Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN"
        If Not IsPostBack Then
            CargarTerminales()
            CargarGrid(Nothing)
        End If
    End Sub

    Private Sub CargarTerminales()
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_TERMINALES", "pr_listar", New List(Of OracleParameter))
            ddlTerminales.Items.Clear()
            ddlTerminales.Items.Add(New ListItem("-- Todas --", ""))
            For Each row As DataRow In dt.Rows
                ddlTerminales.Items.Add(New ListItem(row("NOMBRE").ToString(), row("ID_TERMINAL").ToString()))
            Next
            CargarSecciones("")
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar terminales: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarSecciones(idTerminal As String)
        Try
            ddlSecciones.Items.Clear()
            ddlSecciones.Items.Add(New ListItem("-- Todas --", ""))
            ddlSeccionModal.Items.Clear()
            ddlSeccionModal.Items.Add(New ListItem("-- Seleccione --", ""))
            If idTerminal <> "" Then
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(idTerminal)})
                Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_SECCIONES_TERMINAL", "pr_listar", params)
                For Each row As DataRow In dt.Rows
                    Dim txt = row("NOMBRE").ToString()
                    Dim val = row("ID_SECCION").ToString()
                    ddlSecciones.Items.Add(New ListItem(txt, val))
                    ddlSeccionModal.Items.Add(New ListItem(txt, val))
                Next
            Else
                Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_SECCIONES_TERMINAL", "pr_listar", New List(Of OracleParameter))
                For Each row As DataRow In dt.Rows
                    Dim txt = row("NOMBRE").ToString()
                    Dim val = row("ID_SECCION").ToString()
                    ddlSecciones.Items.Add(New ListItem(txt, val))
                    ddlSeccionModal.Items.Add(New ListItem(txt, val))
                Next
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar secciones: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarGrid(idSeccion As Object)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PUERTAS_GATES", "pr_listar", New List(Of OracleParameter))
            If idSeccion IsNot Nothing AndAlso idSeccion.ToString() <> "" Then
                Dim filtered = dt.Select(String.Format("ID_SECCION = {0}", idSeccion))
                Dim dtF As DataTable = dt.Clone()
                For Each r As DataRow In filtered : dtF.ImportRow(r) : Next
                gvGates.DataSource = dtF
                lblConteo.Text = String.Format("{0} registro(s)", dtF.Rows.Count)
            Else
                gvGates.DataSource = dt
                lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
            End If
            gvGates.DataBind()
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar puertas: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        CargarSecciones(ddlTerminales.SelectedValue)
        CargarGrid(If(ddlSecciones.SelectedValue <> "", ddlSecciones.SelectedValue, Nothing))
    End Sub

    Protected Sub gvGates_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Editar" Then
            CargarParaEditar(Convert.ToInt32(e.CommandArgument))
        ElseIf e.CommandName = "Eliminar" Then
            Desactivar(Convert.ToInt32(e.CommandArgument))
        End If
    End Sub

    Private Sub CargarParaEditar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PUERTAS_GATES", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_GATE = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                hfIdGate.Value = id.ToString()
                txtCodigo.Text = row("CODIGO").ToString()
                txtCapacidad.Text = row("CAPACIDAD_PAX").ToString()
                ddlTipo.SelectedValue = row("TIPO").ToString()
                ddlJetway.SelectedValue = row("TIENE_JETWAY").ToString()
                ddlActivo.SelectedValue = row("ACTIVO").ToString()
                divActivo.Visible = True
                If ddlSeccionModal.Items.FindByValue(row("ID_SECCION").ToString()) IsNot Nothing Then
                    ddlSeccionModal.SelectedValue = row("ID_SECCION").ToString()
                End If
                Session("ModalTerminalId") = ddlTerminalModal.SelectedValue
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar datos: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            Dim id As Integer = Convert.ToInt32(hfIdGate.Value)
            Dim params As New List(Of OracleParameter)
            If id = 0 Then
                params.Add(New OracleParameter("p_id_seccion", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlSeccionModal.SelectedValue)})
                params.Add(New OracleParameter("p_codigo", OracleDbType.Varchar2) With {.Value = txtCodigo.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_capacidad_pax", OracleDbType.Int32) With {.Value = If(txtCapacidad.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtCapacidad.Text.Trim()))})
                params.Add(New OracleParameter("p_tiene_jetway", OracleDbType.Char) With {.Value = ddlJetway.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_PUERTAS_GATES", "pr_insertar", params)
                MostrarToast("success", "Puerta registrada correctamente.")
            Else
                params.Add(New OracleParameter("p_id_gate", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_seccion", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlSeccionModal.SelectedValue)})
                params.Add(New OracleParameter("p_codigo", OracleDbType.Varchar2) With {.Value = txtCodigo.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_capacidad_pax", OracleDbType.Int32) With {.Value = If(txtCapacidad.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtCapacidad.Text.Trim()))})
                params.Add(New OracleParameter("p_tiene_jetway", OracleDbType.Char) With {.Value = ddlJetway.SelectedValue})
                params.Add(New OracleParameter("p_activo", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_PUERTAS_GATES", "pr_actualizar", params)
                MostrarToast("success", "Puerta actualizada correctamente.")
            End If
            hfIdGate.Value = "0" : divActivo.Visible = False : LimpiarFormulario() : CargarGrid(Nothing)
        Catch ex As Exception
            MostrarToast("danger", "Error al guardar: " & ex.Message)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
        End Try
    End Sub

    Private Sub Desactivar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PUERTAS_GATES", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_GATE = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_gate", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_seccion", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_SECCION"))})
                params.Add(New OracleParameter("p_codigo", OracleDbType.Varchar2) With {.Value = row("CODIGO").ToString()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = row("TIPO").ToString()})
                params.Add(New OracleParameter("p_capacidad_pax", OracleDbType.Int32) With {.Value = If(row.IsNull("CAPACIDAD_PAX"), DBNull.Value, row("CAPACIDAD_PAX"))})
                params.Add(New OracleParameter("p_tiene_jetway", OracleDbType.Char) With {.Value = row("TIENE_JETWAY").ToString()})
                params.Add(New OracleParameter("p_activo", OracleDbType.Char) With {.Value = "N"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_PUERTAS_GATES", "pr_actualizar", params)
                MostrarToast("success", "Puerta desactivada correctamente.")
                CargarGrid(Nothing)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtCodigo.Text = "" : txtCapacidad.Text = ""
        ddlTipo.SelectedIndex = 0 : ddlJetway.SelectedValue = "S" : ddlActivo.SelectedValue = "S" : hfIdGate.Value = "0"
    End Sub

    Private Sub MostrarToast(tipo As String, mensaje As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks, String.Format("showToast('{0}','','{1}');", tipo, mensaje.Replace("'", "\'")), True)
    End Sub

End Class

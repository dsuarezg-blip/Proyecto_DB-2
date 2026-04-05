Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmSeccionesTerminal
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
            ddlTerminalModal.Items.Clear()
            ddlTerminalModal.Items.Add(New ListItem("-- Seleccione --", ""))
            For Each row As DataRow In dt.Rows
                Dim txt = row("NOMBRE").ToString()
                Dim val = row("ID_TERMINAL").ToString()
                ddlTerminales.Items.Add(New ListItem(txt, val))
                ddlTerminalModal.Items.Add(New ListItem(txt, val))
            Next
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar terminales: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarGrid(idTerminal As Object)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_SECCIONES_TERMINAL", "pr_listar", New List(Of OracleParameter))
            If idTerminal IsNot Nothing AndAlso idTerminal.ToString() <> "" Then
                Dim filtered = dt.Select(String.Format("ID_TERMINAL = {0}", idTerminal))
                Dim dtF As DataTable = dt.Clone()
                For Each r As DataRow In filtered : dtF.ImportRow(r) : Next
                gvSecciones.DataSource = dtF
                lblConteo.Text = String.Format("{0} registro(s)", dtF.Rows.Count)
            Else
                gvSecciones.DataSource = dt
                lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
            End If
            gvSecciones.DataBind()
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar secciones: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        CargarGrid(If(ddlTerminales.SelectedValue <> "", ddlTerminales.SelectedValue, Nothing))
    End Sub

    Protected Sub gvSecciones_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Editar" Then
            CargarParaEditar(Convert.ToInt32(e.CommandArgument))
        ElseIf e.CommandName = "Eliminar" Then
            Desactivar(Convert.ToInt32(e.CommandArgument))
        End If
    End Sub

    Private Sub CargarParaEditar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_SECCIONES_TERMINAL", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_SECCION = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                hfIdSeccion.Value = id.ToString()
                txtNombre.Text = row("NOMBRE").ToString()
                txtNivel.Text = row("NIVEL").ToString()
                txtArea.Text = row("AREA_M2").ToString()
                ddlTipo.SelectedValue = row("TIPO").ToString()
                ddlActivo.SelectedValue = row("ACTIVA").ToString()
                divActivo.Visible = True
                If ddlTerminalModal.Items.FindByValue(row("ID_TERMINAL").ToString()) IsNot Nothing Then
                    ddlTerminalModal.SelectedValue = row("ID_TERMINAL").ToString()
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
            Dim id As Integer = Convert.ToInt32(hfIdSeccion.Value)
            Dim params As New List(Of OracleParameter)
            If id = 0 Then
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(If(ddlTerminalModal.SelectedValue <> "", ddlTerminalModal.SelectedValue, If(Session("ModalTerminalId") IsNot Nothing, Session("ModalTerminalId").ToString(), "0")))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_nivel", OracleDbType.Int32) With {.Value = If(txtNivel.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtNivel.Text.Trim()))})
                params.Add(New OracleParameter("p_area_m2", OracleDbType.Decimal) With {.Value = If(txtArea.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtArea.Text.Trim()))})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_SECCIONES_TERMINAL", "pr_insertar", params)
                MostrarToast("success", "Sección registrada correctamente.")
            Else
                params.Add(New OracleParameter("p_id_seccion", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(If(ddlTerminalModal.SelectedValue <> "", ddlTerminalModal.SelectedValue, If(Session("ModalTerminalId") IsNot Nothing, Session("ModalTerminalId").ToString(), "0")))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_nivel", OracleDbType.Int32) With {.Value = If(txtNivel.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtNivel.Text.Trim()))})
                params.Add(New OracleParameter("p_area_m2", OracleDbType.Decimal) With {.Value = If(txtArea.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtArea.Text.Trim()))})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_SECCIONES_TERMINAL", "pr_actualizar", params)
                MostrarToast("success", "Sección actualizada correctamente.")
            End If
            hfIdSeccion.Value = "0" : divActivo.Visible = False : LimpiarFormulario() : CargarGrid(Nothing)
        Catch ex As Exception
            MostrarToast("danger", "Error al guardar: " & ex.Message)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
        End Try
    End Sub

    Private Sub Desactivar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_SECCIONES_TERMINAL", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_SECCION = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_seccion", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_TERMINAL"))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = row("NOMBRE").ToString()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = row("TIPO").ToString()})
                params.Add(New OracleParameter("p_nivel", OracleDbType.Int32) With {.Value = If(row.IsNull("NIVEL"), DBNull.Value, row("NIVEL"))})
                params.Add(New OracleParameter("p_area_m2", OracleDbType.Decimal) With {.Value = If(row.IsNull("AREA_M2"), DBNull.Value, row("AREA_M2"))})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = "N"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_SECCIONES_TERMINAL", "pr_actualizar", params)
                MostrarToast("success", "Sección desactivada correctamente.")
                CargarGrid(Nothing)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNombre.Text = "" : txtNivel.Text = "" : txtArea.Text = ""
        ddlTipo.SelectedIndex = 0 : ddlActivo.SelectedValue = "S" : hfIdSeccion.Value = "0"
    End Sub

    Private Sub MostrarToast(tipo As String, mensaje As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks, String.Format("showToast('{0}','','{1}');", tipo, mensaje.Replace("'", "\'")), True)
    End Sub

End Class

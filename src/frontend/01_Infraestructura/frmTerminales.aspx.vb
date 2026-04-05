Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmTerminales
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.IsAuthenticated Then
            Response.Redirect("~/06_Seguridad_Finanzas/Seguridad/Login.aspx") : Return
        End If
        Dim esAdmin As Boolean = Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN"
        pnlBtnNuevo.Visible = esAdmin
        If Not IsPostBack Then
            CargarAeropuertos()
            CargarGrid(Nothing)
        End If
    End Sub

    Private Sub CargarAeropuertos()
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_listar", New List(Of OracleParameter))
            ddlAeropuertos.Items.Clear()
            ddlAeropuertos.Items.Add(New ListItem("-- Todos --", ""))
            ddlAeropuertoModal.Items.Clear()
            ddlAeropuertoModal.Items.Add(New ListItem("-- Seleccione --", ""))
            For Each row As DataRow In dt.Rows
                Dim txt = String.Format("{0} - {1}", row("CODIGO_IATA"), row("NOMBRE"))
                Dim val = row("ID_AEROPUERTO").ToString()
                ddlAeropuertos.Items.Add(New ListItem(txt, val))
                ddlAeropuertoModal.Items.Add(New ListItem(txt, val))
            Next
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar aeropuertos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarGrid(idAeropuerto As Object)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_TERMINALES", "pr_listar", New List(Of OracleParameter))
            If idAeropuerto IsNot Nothing AndAlso idAeropuerto.ToString() <> "" Then
                Dim filtered = dt.Select(String.Format("ID_AEROPUERTO = {0}", idAeropuerto))
                Dim dtF As DataTable = dt.Clone()
                For Each r As DataRow In filtered
                    dtF.ImportRow(r)
                Next
                gvTerminales.DataSource = dtF
                lblConteo.Text = String.Format("{0} registro(s)", dtF.Rows.Count)
            Else
                gvTerminales.DataSource = dt
                lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
            End If
            gvTerminales.DataBind()
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar terminales: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        CargarGrid(If(ddlAeropuertos.SelectedValue <> "", ddlAeropuertos.SelectedValue, Nothing))
    End Sub

    Protected Sub gvTerminales_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Editar" Then
            CargarParaEditar(Convert.ToInt32(e.CommandArgument))
        ElseIf e.CommandName = "Eliminar" Then
            Desactivar(Convert.ToInt32(e.CommandArgument))
        End If
    End Sub

    Private Sub CargarParaEditar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_TERMINALES", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_TERMINAL = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                hfIdTerminal.Value = id.ToString()
                txtNombre.Text = row("NOMBRE").ToString()
                txtCodigo.Text = row("CODIGO").ToString()
                txtArea.Text = row("AREA_M2").ToString()
                txtPisos.Text = row("NIVEL_PISOS").ToString()
                txtCapacidad.Text = row("CAPACIDAD_PAX_HORA").ToString()
                ddlTipo.SelectedValue = row("TIPO").ToString()
                ddlActivo.SelectedValue = row("ACTIVA").ToString()
                divActivo.Visible = True
                If ddlAeropuertoModal.Items.FindByValue(row("ID_AEROPUERTO").ToString()) IsNot Nothing Then
                    ddlAeropuertoModal.SelectedValue = row("ID_AEROPUERTO").ToString()
                End If
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar datos: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            Dim id As Integer = Convert.ToInt32(hfIdTerminal.Value)
            Dim params As New List(Of OracleParameter)
            If id = 0 Then
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlAeropuertoModal.SelectedValue)})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_codigo", OracleDbType.Varchar2) With {.Value = txtCodigo.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_area_m2", OracleDbType.Decimal) With {.Value = If(txtArea.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtArea.Text.Trim()))})
                params.Add(New OracleParameter("p_nivel_pisos", OracleDbType.Int32) With {.Value = If(txtPisos.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtPisos.Text.Trim()))})
                params.Add(New OracleParameter("p_capacidad_hr", OracleDbType.Int32) With {.Value = If(txtCapacidad.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtCapacidad.Text.Trim()))})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_TERMINALES", "pr_insertar", params)
                MostrarToast("success", "Terminal registrada correctamente.")
            Else
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlAeropuertoModal.SelectedValue)})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_codigo", OracleDbType.Varchar2) With {.Value = txtCodigo.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_area_m2", OracleDbType.Decimal) With {.Value = If(txtArea.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtArea.Text.Trim()))})
                params.Add(New OracleParameter("p_nivel_pisos", OracleDbType.Int32) With {.Value = If(txtPisos.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtPisos.Text.Trim()))})
                params.Add(New OracleParameter("p_capacidad_hr", OracleDbType.Int32) With {.Value = If(txtCapacidad.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtCapacidad.Text.Trim()))})
                params.Add(New OracleParameter("p_estado", OracleDbType.Varchar2) With {.Value = "OPERATIVA"})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_TERMINALES", "pr_actualizar", params)
                MostrarToast("success", "Terminal actualizada correctamente.")
            End If
            hfIdTerminal.Value = "0"
            divActivo.Visible = False
            LimpiarFormulario()
            CargarGrid(Nothing)
        Catch ex As Exception
            MostrarToast("danger", "Error al guardar: " & ex.Message)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
        End Try
    End Sub

    Private Sub Desactivar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_TERMINALES", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_TERMINAL = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_AEROPUERTO"))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = row("NOMBRE").ToString()})
                params.Add(New OracleParameter("p_codigo", OracleDbType.Varchar2) With {.Value = row("CODIGO").ToString()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = row("TIPO").ToString()})
                params.Add(New OracleParameter("p_area_m2", OracleDbType.Decimal) With {.Value = If(row.IsNull("AREA_M2"), DBNull.Value, row("AREA_M2"))})
                params.Add(New OracleParameter("p_nivel_pisos", OracleDbType.Int32) With {.Value = If(row.IsNull("NIVEL_PISOS"), DBNull.Value, row("NIVEL_PISOS"))})
                params.Add(New OracleParameter("p_capacidad_hr", OracleDbType.Int32) With {.Value = If(row.IsNull("CAPACIDAD_PAX_HORA"), DBNull.Value, row("CAPACIDAD_PAX_HORA"))})
                params.Add(New OracleParameter("p_estado", OracleDbType.Varchar2) With {.Value = If(row.IsNull("ESTADO"), "OPERATIVA", row("ESTADO").ToString())})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = "N"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_TERMINALES", "pr_actualizar", params)
                MostrarToast("success", "Terminal desactivada correctamente.")
                CargarGrid(Nothing)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNombre.Text = "" : txtCodigo.Text = "" : txtArea.Text = "" : txtPisos.Text = "" : txtCapacidad.Text = ""
        ddlTipo.SelectedIndex = 0 : ddlActivo.SelectedValue = "S" : hfIdTerminal.Value = "0"
    End Sub

    Private Sub MostrarToast(tipo As String, mensaje As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks, String.Format("showToast('{0}','','{1}');", tipo, mensaje.Replace("'", "\'")), True)
    End Sub

End Class

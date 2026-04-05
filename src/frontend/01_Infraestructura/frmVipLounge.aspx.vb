Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmVipLounge
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
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_VIP_LOUNGE", "pr_listar", New List(Of OracleParameter))
            If idTerminal IsNot Nothing AndAlso idTerminal.ToString() <> "" Then
                Dim filtered = dt.Select(String.Format("ID_TERMINAL = {0}", idTerminal))
                Dim dtF As DataTable = dt.Clone()
                For Each r As DataRow In filtered : dtF.ImportRow(r) : Next
                gvVip.DataSource = dtF
                lblConteo.Text = String.Format("{0} registro(s)", dtF.Rows.Count)
            Else
                gvVip.DataSource = dt
                lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
            End If
            gvVip.DataBind()
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar lounges: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        CargarGrid(If(ddlTerminales.SelectedValue <> "", ddlTerminales.SelectedValue, Nothing))
    End Sub

    Protected Sub gvVip_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Editar" Then
            CargarParaEditar(Convert.ToInt32(e.CommandArgument))
        ElseIf e.CommandName = "Eliminar" Then
            Desactivar(Convert.ToInt32(e.CommandArgument))
        End If
    End Sub

    Private Sub CargarParaEditar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_VIP_LOUNGE", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_VIP = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                hfIdVip.Value = id.ToString()
                txtNombre.Text = row("NOMBRE").ToString()
                txtOperador.Text = row("OPERADOR").ToString()
                txtCapacidad.Text = row("CAPACIDAD").ToString()
                txtPrecio.Text = row("PRECIO_USD").ToString()
                ddlActivo.SelectedValue = row("ACTIVO").ToString()
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
            Dim id As Integer = Convert.ToInt32(hfIdVip.Value)
            Dim params As New List(Of OracleParameter)
            If id = 0 Then
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(If(ddlTerminalModal.SelectedValue <> "", ddlTerminalModal.SelectedValue, If(Session("ModalTerminalId") IsNot Nothing, Session("ModalTerminalId").ToString(), "0")))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_operador", OracleDbType.Varchar2) With {.Value = txtOperador.Text.Trim()})
                params.Add(New OracleParameter("p_capacidad", OracleDbType.Int32) With {.Value = If(txtCapacidad.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtCapacidad.Text.Trim()))})
                params.Add(New OracleParameter("p_precio_usd", OracleDbType.Decimal) With {.Value = If(txtPrecio.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtPrecio.Text.Trim()))})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_VIP_LOUNGE", "pr_insertar", params)
                MostrarToast("success", "VIP Lounge registrado correctamente.")
            Else
                params.Add(New OracleParameter("p_id_vip", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(If(ddlTerminalModal.SelectedValue <> "", ddlTerminalModal.SelectedValue, If(Session("ModalTerminalId") IsNot Nothing, Session("ModalTerminalId").ToString(), "0")))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_operador", OracleDbType.Varchar2) With {.Value = txtOperador.Text.Trim()})
                params.Add(New OracleParameter("p_capacidad", OracleDbType.Int32) With {.Value = If(txtCapacidad.Text.Trim() = "", DBNull.Value, Convert.ToInt32(txtCapacidad.Text.Trim()))})
                params.Add(New OracleParameter("p_precio_usd", OracleDbType.Decimal) With {.Value = If(txtPrecio.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtPrecio.Text.Trim()))})
                params.Add(New OracleParameter("p_activo", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_VIP_LOUNGE", "pr_actualizar", params)
                MostrarToast("success", "VIP Lounge actualizado correctamente.")
            End If
            hfIdVip.Value = "0" : divActivo.Visible = False : LimpiarFormulario() : CargarGrid(Nothing)
        Catch ex As Exception
            MostrarToast("danger", "Error al guardar: " & ex.Message)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
        End Try
    End Sub

    Private Sub Desactivar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_VIP_LOUNGE", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_VIP = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_vip", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_terminal", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_TERMINAL"))})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = row("NOMBRE").ToString()})
                params.Add(New OracleParameter("p_operador", OracleDbType.Varchar2) With {.Value = row("OPERADOR").ToString()})
                params.Add(New OracleParameter("p_capacidad", OracleDbType.Int32) With {.Value = If(row.IsNull("CAPACIDAD"), DBNull.Value, row("CAPACIDAD"))})
                params.Add(New OracleParameter("p_precio_usd", OracleDbType.Decimal) With {.Value = If(row.IsNull("PRECIO_USD"), DBNull.Value, row("PRECIO_USD"))})
                params.Add(New OracleParameter("p_activo", OracleDbType.Char) With {.Value = "N"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_VIP_LOUNGE", "pr_actualizar", params)
                MostrarToast("success", "VIP Lounge desactivado correctamente.")
                CargarGrid(Nothing)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtNombre.Text = "" : txtOperador.Text = "" : txtCapacidad.Text = "" : txtPrecio.Text = ""
        ddlActivo.SelectedValue = "S" : hfIdVip.Value = "0"
    End Sub

    Private Sub MostrarToast(tipo As String, mensaje As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks, String.Format("showToast('{0}','','{1}');", tipo, mensaje.Replace("'", "\'")), True)
    End Sub

End Class

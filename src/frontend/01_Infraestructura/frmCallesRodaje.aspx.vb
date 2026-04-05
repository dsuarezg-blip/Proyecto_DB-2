Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmCallesRodaje
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
            Dim dt As DataTable
            If idAeropuerto IsNot Nothing AndAlso idAeropuerto.ToString() <> "" Then
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(idAeropuerto)})
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_CALLES_RODAJE", "pr_listar_por_aeropuerto", params)
            Else
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_CALLES_RODAJE", "pr_listar", New List(Of OracleParameter))
            End If
            gvCalles.DataSource = dt
            gvCalles.DataBind()
            lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar calles: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        CargarGrid(If(ddlAeropuertos.SelectedValue <> "", ddlAeropuertos.SelectedValue, Nothing))
    End Sub

    Protected Sub gvCalles_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "Editar" Then
            CargarParaEditar(Convert.ToInt32(e.CommandArgument))
        ElseIf e.CommandName = "Eliminar" Then
            Desactivar(Convert.ToInt32(e.CommandArgument))
        End If
    End Sub

    Private Sub CargarParaEditar(id As Integer)
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_CALLES_RODAJE", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_TAXIWAY = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                hfIdCalle.Value = id.ToString()
                txtDesignacion.Text = row("DESIGNACION").ToString()
                txtLongitud.Text = row("LONGITUD_M").ToString()
                txtAncho.Text = row("ANCHO_M").ToString()
                ddlTipo.SelectedValue = row("TIPO").ToString()
                ddlActivo.SelectedValue = row("ACTIVA").ToString()
                divActivo.Visible = True
                If ddlAeropuertoModal.Items.FindByValue(row("ID_AEROPUERTO").ToString()) IsNot Nothing Then
                    ddlAeropuertoModal.SelectedValue = row("ID_AEROPUERTO").ToString()
                End If
                Session("ModalAeropuertoId") = ddlAeropuertoModal.SelectedValue
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "modal", "abrirModalEditar();", True)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar datos: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            Dim id As Integer = Convert.ToInt32(hfIdCalle.Value)
            Dim params As New List(Of OracleParameter)
            If id = 0 Then
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(If(ddlAeropuertoModal.SelectedValue <> "", ddlAeropuertoModal.SelectedValue, If(Session("ModalAeropuertoId") IsNot Nothing, Session("ModalAeropuertoId").ToString(), "0")))})
                params.Add(New OracleParameter("p_designacion", OracleDbType.Varchar2) With {.Value = txtDesignacion.Text.Trim()})
                params.Add(New OracleParameter("p_longitud_m", OracleDbType.Decimal) With {.Value = If(txtLongitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtLongitud.Text.Trim()))})
                params.Add(New OracleParameter("p_ancho_m", OracleDbType.Decimal) With {.Value = If(txtAncho.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtAncho.Text.Trim()))})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_CALLES_RODAJE", "pr_insertar", params)
                MostrarToast("success", "Calle de rodaje registrada correctamente.")
            Else
                params.Add(New OracleParameter("p_id_taxiway", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(If(ddlAeropuertoModal.SelectedValue <> "", ddlAeropuertoModal.SelectedValue, If(Session("ModalAeropuertoId") IsNot Nothing, Session("ModalAeropuertoId").ToString(), "0")))})
                params.Add(New OracleParameter("p_designacion", OracleDbType.Varchar2) With {.Value = txtDesignacion.Text.Trim()})
                params.Add(New OracleParameter("p_longitud_m", OracleDbType.Decimal) With {.Value = If(txtLongitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtLongitud.Text.Trim()))})
                params.Add(New OracleParameter("p_ancho_m", OracleDbType.Decimal) With {.Value = If(txtAncho.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtAncho.Text.Trim()))})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_estado", OracleDbType.Varchar2) With {.Value = "OPERATIVA"})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_CALLES_RODAJE", "pr_actualizar", params)
                MostrarToast("success", "Calle de rodaje actualizada correctamente.")
            End If
            hfIdCalle.Value = "0"
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
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_CALLES_RODAJE", "pr_listar", New List(Of OracleParameter))
            Dim rows = dt.Select(String.Format("ID_TAXIWAY = {0}", id))
            If rows.Length > 0 Then
                Dim row = rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_taxiway", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_AEROPUERTO"))})
                params.Add(New OracleParameter("p_designacion", OracleDbType.Varchar2) With {.Value = row("DESIGNACION").ToString()})
                params.Add(New OracleParameter("p_longitud_m", OracleDbType.Decimal) With {.Value = If(row.IsNull("LONGITUD_M"), DBNull.Value, row("LONGITUD_M"))})
                params.Add(New OracleParameter("p_ancho_m", OracleDbType.Decimal) With {.Value = If(row.IsNull("ANCHO_M"), DBNull.Value, row("ANCHO_M"))})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = row("TIPO").ToString()})
                params.Add(New OracleParameter("p_estado", OracleDbType.Varchar2) With {.Value = If(row.IsNull("ESTADO"), "OPERATIVA", row("ESTADO").ToString())})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = "N"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_CALLES_RODAJE", "pr_actualizar", params)
                MostrarToast("success", "Calle desactivada correctamente.")
                CargarGrid(Nothing)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtDesignacion.Text = "" : txtLongitud.Text = "" : txtAncho.Text = ""
        ddlTipo.SelectedIndex = 0 : ddlActivo.SelectedValue = "S" : hfIdCalle.Value = "0"
    End Sub

    Private Sub MostrarToast(tipo As String, mensaje As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks, String.Format("showToast('{0}','','{1}');", tipo, mensaje.Replace("'", "\'")), True)
    End Sub

End Class

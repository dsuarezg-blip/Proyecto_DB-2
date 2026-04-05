Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmPistas
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.IsAuthenticated Then
            Response.Redirect("~/06_Seguridad_Finanzas/Seguridad/Login.aspx")
            Return
        End If

        Dim esAdmin As Boolean = (Session("UserRole") IsNot Nothing AndAlso Session("UserRole").ToString().ToUpper() = "ADMIN")
        pnlBtnNuevo.Visible = esAdmin
        pnlBotonesVista.Visible = esAdmin

        If Not IsPostBack Then
            CargarAeropuertos()
            CargarGrid(Nothing, False)
        End If
    End Sub

    Private Sub CargarAeropuertos()
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_listar", New List(Of OracleParameter))
            ddlAeropuertos.Items.Clear()
            ddlAeropuertos.Items.Add(New ListItem("-- Todos los aeropuertos --", ""))
            ddlAeropuertoModal.Items.Clear()
            ddlAeropuertoModal.Items.Add(New ListItem("-- Seleccione aeropuerto --", ""))
            For Each row As DataRow In dt.Rows
                Dim texto = String.Format("{0} - {1}", row("CODIGO_IATA").ToString(), row("NOMBRE").ToString())
                Dim valor = row("ID_AEROPUERTO").ToString()
                ddlAeropuertos.Items.Add(New ListItem(texto, valor))
                ddlAeropuertoModal.Items.Add(New ListItem(texto, valor))
            Next
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar aeropuertos: " & ex.Message)
        End Try
    End Sub

    Private Sub CargarGrid(idAeropuerto As Object, mostrarInactivas As Boolean)
        Try
            Dim dt As DataTable

            If mostrarInactivas Then
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PISTAS", "pr_listar_inactivas", New List(Of OracleParameter))
                lblTituloGrid.Text = "Pistas Inactivas"
                btnVerInactivos.Visible = False
                btnVerActivos.Visible = True
            ElseIf idAeropuerto IsNot Nothing AndAlso idAeropuerto.ToString() <> "" Then
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(idAeropuerto)})
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PISTAS", "pr_listar_por_aeropuerto", params)
                lblTituloGrid.Text = "Listado de Pistas"
                btnVerInactivos.Visible = True
                btnVerActivos.Visible = False
            Else
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PISTAS", "pr_listar", New List(Of OracleParameter))
                lblTituloGrid.Text = "Listado de Pistas"
                btnVerInactivos.Visible = True
                btnVerActivos.Visible = False
            End If

            gvPistas.DataSource = dt
            gvPistas.DataBind()
            lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar pistas: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        If ddlAeropuertos.SelectedValue <> "" Then
            CargarGrid(ddlAeropuertos.SelectedValue, False)
        Else
            CargarGrid(Nothing, False)
        End If
    End Sub

    Protected Sub btnVerInactivos_Click(sender As Object, e As EventArgs)
        CargarGrid(Nothing, True)
        MostrarToast("warning", "Mostrando pistas inactivas.")
    End Sub

    Protected Sub btnVerActivos_Click(sender As Object, e As EventArgs)
        CargarGrid(Nothing, False)
    End Sub

    Protected Sub gvPistas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Select Case e.CommandName
            Case "Editar"
                CargarParaEditar(Convert.ToInt32(e.CommandArgument))
            Case "Eliminar"
                Desactivar(Convert.ToInt32(e.CommandArgument))
            Case "Reactivar"
                Reactivar(Convert.ToInt32(e.CommandArgument))
            Case "EliminarDef"
                EliminarDefinitivo(Convert.ToInt32(e.CommandArgument))
        End Select
    End Sub

    Private Sub CargarParaEditar(idPista As Integer)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_pista", OracleDbType.Int32) With {.Value = idPista})
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PISTAS", "pr_obtener_por_id", params)

            If dt.Rows.Count > 0 Then
                Dim row = dt.Rows(0)
                hfIdPista.Value = idPista.ToString()
                txtDesignacion.Text = row("DESIGNACION").ToString()
                txtLongitud.Text = row("LONGITUD_M").ToString()
                txtAncho.Text = row("ANCHO_M").ToString()
                txtCargaMax.Text = row("RESISTENCIA_PCN").ToString()
                ddlSuperficie.SelectedValue = row("TIPO_SUPERFICIE").ToString()
                ddlIluminada.SelectedValue = row("ILUMINADA").ToString()
                ddlActivo.SelectedValue = row("ACTIVA").ToString()
                If ddlAeropuertoModal.Items.FindByValue(row("ID_AEROPUERTO").ToString()) IsNot Nothing Then
                    ddlAeropuertoModal.SelectedValue = row("ID_AEROPUERTO").ToString()
                End If
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirEditar", "abrirModalEditar();", True)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al cargar datos: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            Dim id As Integer = Convert.ToInt32(hfIdPista.Value)
            Dim params As New List(Of OracleParameter)

            If id = 0 Then
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlAeropuertoModal.SelectedValue)})
                params.Add(New OracleParameter("p_designacion", OracleDbType.Varchar2) With {.Value = txtDesignacion.Text.Trim()})
                params.Add(New OracleParameter("p_longitud_m", OracleDbType.Decimal) With {.Value = Convert.ToDecimal(txtLongitud.Text.Trim())})
                params.Add(New OracleParameter("p_ancho_m", OracleDbType.Decimal) With {.Value = Convert.ToDecimal(txtAncho.Text.Trim())})
                params.Add(New OracleParameter("p_tipo_superficie", OracleDbType.Varchar2) With {.Value = ddlSuperficie.SelectedValue})
                params.Add(New OracleParameter("p_resistencia_pcn", OracleDbType.Decimal) With {.Value = If(txtCargaMax.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtCargaMax.Text.Trim()))})
                params.Add(New OracleParameter("p_iluminada", OracleDbType.Char) With {.Value = ddlIluminada.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_PISTAS", "pr_insertar", params)
                MostrarToast("success", "Pista registrada correctamente.")
            Else
                params.Add(New OracleParameter("p_id_pista", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlAeropuertoModal.SelectedValue)})
                params.Add(New OracleParameter("p_designacion", OracleDbType.Varchar2) With {.Value = txtDesignacion.Text.Trim()})
                params.Add(New OracleParameter("p_longitud_m", OracleDbType.Decimal) With {.Value = Convert.ToDecimal(txtLongitud.Text.Trim())})
                params.Add(New OracleParameter("p_ancho_m", OracleDbType.Decimal) With {.Value = Convert.ToDecimal(txtAncho.Text.Trim())})
                params.Add(New OracleParameter("p_tipo_superficie", OracleDbType.Varchar2) With {.Value = ddlSuperficie.SelectedValue})
                params.Add(New OracleParameter("p_resistencia_pcn", OracleDbType.Decimal) With {.Value = If(txtCargaMax.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtCargaMax.Text.Trim()))})
                params.Add(New OracleParameter("p_iluminada", OracleDbType.Char) With {.Value = ddlIluminada.SelectedValue})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_PISTAS", "pr_actualizar", params)
                MostrarToast("success", "Pista actualizada correctamente.")
            End If

            hfIdPista.Value = "0"
            LimpiarFormulario()
            CargarGrid(Nothing, False)

        Catch ex As Exception
            MostrarToast("danger", "Error al guardar: " & ex.Message)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "reabrirModal", "abrirModalEditar();", True)
        End Try
    End Sub

    Private Sub Desactivar(idPista As Integer)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_pista", OracleDbType.Int32) With {.Value = idPista})
            DatabaseHelper.ExecuteNonQuery("PKG_AERO_PISTAS", "pr_eliminar", params)
            MostrarToast("success", "Pista desactivada correctamente.")
            CargarGrid(Nothing, False)
        Catch ex As Exception
            MostrarToast("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub Reactivar(idPista As Integer)
        Try
            Dim paramsGet As New List(Of OracleParameter)
            paramsGet.Add(New OracleParameter("p_id_pista", OracleDbType.Int32) With {.Value = idPista})
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_PISTAS", "pr_obtener_por_id", paramsGet)

            If dt.Rows.Count > 0 Then
                Dim row = dt.Rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_pista", OracleDbType.Int32) With {.Value = idPista})
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_AEROPUERTO"))})
                params.Add(New OracleParameter("p_designacion", OracleDbType.Varchar2) With {.Value = row("DESIGNACION").ToString()})
                params.Add(New OracleParameter("p_longitud_m", OracleDbType.Decimal) With {.Value = If(row.IsNull("LONGITUD_M"), DBNull.Value, row("LONGITUD_M"))})
                params.Add(New OracleParameter("p_ancho_m", OracleDbType.Decimal) With {.Value = If(row.IsNull("ANCHO_M"), DBNull.Value, row("ANCHO_M"))})
                params.Add(New OracleParameter("p_tipo_superficie", OracleDbType.Varchar2) With {.Value = row("TIPO_SUPERFICIE").ToString()})
                params.Add(New OracleParameter("p_resistencia_pcn", OracleDbType.Decimal) With {.Value = If(row.IsNull("RESISTENCIA_PCN"), DBNull.Value, row("RESISTENCIA_PCN"))})
                params.Add(New OracleParameter("p_iluminada", OracleDbType.Char) With {.Value = row("ILUMINADA").ToString()})
                params.Add(New OracleParameter("p_activa", OracleDbType.Char) With {.Value = "S"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_PISTAS", "pr_actualizar", params)
                MostrarToast("success", "Pista reactivada correctamente.")
                CargarGrid(Nothing, False)
            End If
        Catch ex As Exception
            MostrarToast("danger", "Error al reactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarDefinitivo(idPista As Integer)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_pista", OracleDbType.Int32) With {.Value = idPista})
            DatabaseHelper.ExecuteNonQuery("PKG_AERO_PISTAS", "pr_eliminar_definitivo", params)
            MostrarToast("success", "Pista eliminada definitivamente.")
            CargarGrid(Nothing, True)
        Catch ex As Exception
            MostrarToast("danger", "Error al eliminar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtDesignacion.Text = ""
        txtLongitud.Text = ""
        txtAncho.Text = ""
        txtCargaMax.Text = ""
        ddlSuperficie.SelectedIndex = 0
        ddlIluminada.SelectedValue = "S"
        ddlActivo.SelectedValue = "S"
        hfIdPista.Value = "0"
    End Sub

    Private Sub MostrarToast(tipo As String, mensaje As String)
        Dim script = String.Format("showToast('{0}', '', '{1}');", tipo, mensaje.Replace("'", "\'"))
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks.ToString(), script, True)
    End Sub

End Class

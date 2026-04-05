Imports AeroGT.App_Code
Imports Oracle.ManagedDataAccess.Client
Imports System.Data

Partial Public Class frmAeropuertos
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
            CargarContinentes()
            CargarTodasLasCiudades()
            CargarGrid(Nothing, False)
        End If
    End Sub

    ' ===================== CARGA DE COMBOS =====================

    Private Sub CargarContinentes()
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_GEOG_CONTINENTES", "pr_listar", New List(Of OracleParameter))
            ddlContinentes.Items.Clear()
            ddlContinentes.Items.Add(New ListItem("-- Todos los continentes --", ""))
            For Each row As DataRow In dt.Rows
                ddlContinentes.Items.Add(New ListItem(row("NOMBRE").ToString(), row("ID_CONTINENTE").ToString()))
            Next
        Catch ex As Exception
            MostrarAlerta("danger", "Error al cargar continentes: " & ex.Message)
        End Try
    End Sub

    Protected Sub ddlContinentes_SelectedIndexChanged(sender As Object, e As EventArgs)
        ddlPaises.Items.Clear()
        ddlCiudades.Items.Clear()
        ddlPaises.Items.Add(New ListItem("-- Todos los países --", ""))
        ddlCiudades.Items.Add(New ListItem("-- Todas las ciudades --", ""))

        If ddlContinentes.SelectedValue <> "" Then
            Try
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_continente", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlContinentes.SelectedValue)})
                Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_GEOG_PAISES", "pr_listar_por_continente", params)
                For Each row As DataRow In dt.Rows
                    ddlPaises.Items.Add(New ListItem(row("NOMBRE").ToString(), row("ID_PAIS").ToString()))
                Next
            Catch ex As Exception
                MostrarAlerta("danger", "Error al cargar países: " & ex.Message)
            End Try
        End If
    End Sub

    Protected Sub ddlPaises_SelectedIndexChanged(sender As Object, e As EventArgs)
        ddlCiudades.Items.Clear()
        ddlCiudades.Items.Add(New ListItem("-- Todas las ciudades --", ""))
        If ddlPaises.SelectedValue <> "" Then
            CargarCiudadesPorPais(ddlPaises.SelectedValue)
        End If
    End Sub

    Private Sub CargarCiudadesPorPais(idPais As String)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_pais", OracleDbType.Int32) With {.Value = Convert.ToInt32(idPais)})
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_GEOG_CIUDADES", "pr_listar", params)
            ddlCiudades.Items.Clear()
            ddlCiudades.Items.Add(New ListItem("-- Todas las ciudades --", ""))
            For Each row As DataRow In dt.Rows
                ddlCiudades.Items.Add(New ListItem(row("NOMBRE").ToString(), row("ID_CIUDAD").ToString()))
            Next
        Catch
            CargarTodasLasCiudades()
        End Try
    End Sub

    Private Sub CargarTodasLasCiudades()
        Try
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_GEOG_CIUDADES", "pr_listar", New List(Of OracleParameter))
            ddlCiudadModal.Items.Clear()
            ddlCiudadModal.Items.Add(New ListItem("-- Seleccione ciudad --", ""))
            For Each row As DataRow In dt.Rows
                ddlCiudadModal.Items.Add(New ListItem(row("NOMBRE").ToString(), row("ID_CIUDAD").ToString()))
            Next
        Catch ex As Exception
            ddlCiudadModal.Items.Add(New ListItem("Error al cargar", ""))
        End Try
    End Sub

    ' ===================== GRID =====================

    Private Sub CargarGrid(idCiudad As Object, mostrarInactivos As Boolean)
        Try
            Dim dt As DataTable

            If mostrarInactivos Then
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_listar_inactivos", New List(Of OracleParameter))
                lblTituloGrid.Text = "Aeropuertos Inactivos"
                btnVerInactivos.Visible = False
                btnVerActivos.Visible = True
            ElseIf idCiudad IsNot Nothing AndAlso idCiudad.ToString() <> "" Then
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_ciudad", OracleDbType.Int32) With {.Value = Convert.ToInt32(idCiudad)})
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_listar_por_ciudad", params)
                lblTituloGrid.Text = "Directorio de Aeropuertos"
                btnVerInactivos.Visible = True
                btnVerActivos.Visible = False
            Else
                dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_listar", New List(Of OracleParameter))
                lblTituloGrid.Text = "Directorio de Aeropuertos"
                btnVerInactivos.Visible = True
                btnVerActivos.Visible = False
            End If

            gvAeropuertos.DataSource = dt
            gvAeropuertos.DataBind()
            lblConteo.Text = String.Format("{0} registro(s)", dt.Rows.Count)
        Catch ex As Exception
            MostrarAlerta("danger", "Error al cargar aeropuertos: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs)
        If ddlCiudades.SelectedValue <> "" Then
            CargarGrid(ddlCiudades.SelectedValue, False)
        Else
            CargarGrid(Nothing, False)
        End If
    End Sub

    Protected Sub btnVerInactivos_Click(sender As Object, e As EventArgs)
        CargarGrid(Nothing, True)
        MostrarAlerta("warning", "Mostrando aeropuertos inactivos. Puedes reactivarlos o eliminarlos definitivamente.")
    End Sub

    Protected Sub btnVerActivos_Click(sender As Object, e As EventArgs)
        CargarGrid(Nothing, False)
    End Sub

    ' ===================== CRUD =====================

    Protected Sub gvAeropuertos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
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

    Private Sub CargarParaEditar(idAeropuerto As Integer)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = idAeropuerto})
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_obtener_por_id", params)

            If dt.Rows.Count > 0 Then
                Dim row = dt.Rows(0)
                hfIdAeropuerto.Value = idAeropuerto.ToString()
                txtIata.Text = row("CODIGO_IATA").ToString()
                txtIcao.Text = row("CODIGO_ICAO").ToString()
                txtNombre.Text = row("NOMBRE").ToString()
                txtNombreCorto.Text = row("NOMBRE_CORTO").ToString()
                txtLatitud.Text = row("LATITUD").ToString()
                txtLongitud.Text = row("LONGITUD").ToString()
                txtAltitud.Text = row("ALTITUD_FT").ToString()
                ddlTipo.SelectedValue = row("TIPO").ToString()
                ddlEsHub.SelectedValue = row("ES_HUB").ToString()
                ddlActivo.SelectedValue = row("ACTIVO").ToString()
                If ddlCiudadModal.Items.FindByValue(row("ID_CIUDAD").ToString()) IsNot Nothing Then
                    ddlCiudadModal.SelectedValue = row("ID_CIUDAD").ToString()
                End If
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "abrirEditar", "abrirModalEditar();", True)
            End If
        Catch ex As Exception
            MostrarAlerta("danger", "Error al cargar datos: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            Dim id As Integer = Convert.ToInt32(hfIdAeropuerto.Value)
            Dim params As New List(Of OracleParameter)

            If id = 0 Then
                params.Add(New OracleParameter("p_id_ciudad", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlCiudadModal.SelectedValue)})
                params.Add(New OracleParameter("p_id_zona", OracleDbType.Int32) With {.Value = 1})
                params.Add(New OracleParameter("p_codigo_iata", OracleDbType.Varchar2) With {.Value = txtIata.Text.Trim().ToUpper()})
                params.Add(New OracleParameter("p_codigo_icao", OracleDbType.Varchar2) With {.Value = txtIcao.Text.Trim().ToUpper()})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_nombre_corto", OracleDbType.Varchar2) With {.Value = txtNombreCorto.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_latitud", OracleDbType.Decimal) With {.Value = If(txtLatitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtLatitud.Text.Trim()))})
                params.Add(New OracleParameter("p_longitud", OracleDbType.Decimal) With {.Value = If(txtLongitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtLongitud.Text.Trim()))})
                params.Add(New OracleParameter("p_altitud_ft", OracleDbType.Decimal) With {.Value = If(txtAltitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtAltitud.Text.Trim()))})
                params.Add(New OracleParameter("p_es_hub", OracleDbType.Char) With {.Value = ddlEsHub.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_AEROPUERTOS", "pr_insertar", params)
                MostrarAlerta("success", "Aeropuerto registrado correctamente.")
            Else
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = id})
                params.Add(New OracleParameter("p_id_ciudad", OracleDbType.Int32) With {.Value = Convert.ToInt32(ddlCiudadModal.SelectedValue)})
                params.Add(New OracleParameter("p_id_zona", OracleDbType.Int32) With {.Value = 1})
                params.Add(New OracleParameter("p_codigo_iata", OracleDbType.Varchar2) With {.Value = txtIata.Text.Trim().ToUpper()})
                params.Add(New OracleParameter("p_codigo_icao", OracleDbType.Varchar2) With {.Value = txtIcao.Text.Trim().ToUpper()})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = txtNombre.Text.Trim()})
                params.Add(New OracleParameter("p_nombre_corto", OracleDbType.Varchar2) With {.Value = txtNombreCorto.Text.Trim()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = ddlTipo.SelectedValue})
                params.Add(New OracleParameter("p_latitud", OracleDbType.Decimal) With {.Value = If(txtLatitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtLatitud.Text.Trim()))})
                params.Add(New OracleParameter("p_longitud", OracleDbType.Decimal) With {.Value = If(txtLongitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtLongitud.Text.Trim()))})
                params.Add(New OracleParameter("p_altitud_ft", OracleDbType.Decimal) With {.Value = If(txtAltitud.Text.Trim() = "", DBNull.Value, Convert.ToDecimal(txtAltitud.Text.Trim()))})
                params.Add(New OracleParameter("p_es_hub", OracleDbType.Char) With {.Value = ddlEsHub.SelectedValue})
                params.Add(New OracleParameter("p_activo", OracleDbType.Char) With {.Value = ddlActivo.SelectedValue})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_AEROPUERTOS", "pr_actualizar", params)
                MostrarAlerta("success", "Aeropuerto actualizado correctamente.")
            End If

            hfIdAeropuerto.Value = "0"
            LimpiarFormulario()
            CargarGrid(Nothing, False)

        Catch ex As Exception
            Dim mensaje = ex.Message
            If mensaje.Contains("AEROPUERTO_INACTIVO") Then
                MostrarAlerta("warning", "Ya existe un aeropuerto con ese código IATA/ICAO pero está <strong>desactivado</strong>. " &
                    "Presiona <strong>'Ver Inactivos'</strong> para encontrarlo y reactivarlo.")
            Else
                MostrarAlerta("danger", "Error al guardar: " & mensaje)
            End If
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "reabrirModal", "abrirModalEditar();", True)
        End Try
    End Sub

    Private Sub Desactivar(idAeropuerto As Integer)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = idAeropuerto})
            DatabaseHelper.ExecuteNonQuery("PKG_AERO_AEROPUERTOS", "pr_eliminar", params)
            MostrarAlerta("success", "Aeropuerto desactivado correctamente.")
            CargarGrid(Nothing, False)
        Catch ex As Exception
            MostrarAlerta("danger", "Error al desactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub Reactivar(idAeropuerto As Integer)
        Try
            Dim paramsGet As New List(Of OracleParameter)
            paramsGet.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = idAeropuerto})
            Dim dt = DatabaseHelper.ExecuteCursorReader("PKG_AERO_AEROPUERTOS", "pr_obtener_por_id", paramsGet)

            If dt.Rows.Count > 0 Then
                Dim row = dt.Rows(0)
                Dim params As New List(Of OracleParameter)
                params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = idAeropuerto})
                params.Add(New OracleParameter("p_id_ciudad", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_CIUDAD"))})
                params.Add(New OracleParameter("p_id_zona", OracleDbType.Int32) With {.Value = Convert.ToInt32(row("ID_ZONA"))})
                params.Add(New OracleParameter("p_codigo_iata", OracleDbType.Varchar2) With {.Value = row("CODIGO_IATA").ToString()})
                params.Add(New OracleParameter("p_codigo_icao", OracleDbType.Varchar2) With {.Value = row("CODIGO_ICAO").ToString()})
                params.Add(New OracleParameter("p_nombre", OracleDbType.Varchar2) With {.Value = row("NOMBRE").ToString()})
                params.Add(New OracleParameter("p_nombre_corto", OracleDbType.Varchar2) With {.Value = row("NOMBRE_CORTO").ToString()})
                params.Add(New OracleParameter("p_tipo", OracleDbType.Varchar2) With {.Value = row("TIPO").ToString()})
                params.Add(New OracleParameter("p_latitud", OracleDbType.Decimal) With {.Value = If(row.IsNull("LATITUD"), DBNull.Value, row("LATITUD"))})
                params.Add(New OracleParameter("p_longitud", OracleDbType.Decimal) With {.Value = If(row.IsNull("LONGITUD"), DBNull.Value, row("LONGITUD"))})
                params.Add(New OracleParameter("p_altitud_ft", OracleDbType.Decimal) With {.Value = If(row.IsNull("ALTITUD_FT"), DBNull.Value, row("ALTITUD_FT"))})
                params.Add(New OracleParameter("p_es_hub", OracleDbType.Char) With {.Value = row("ES_HUB").ToString()})
                params.Add(New OracleParameter("p_activo", OracleDbType.Char) With {.Value = "S"})
                DatabaseHelper.ExecuteNonQuery("PKG_AERO_AEROPUERTOS", "pr_actualizar", params)
                MostrarAlerta("success", "Aeropuerto reactivado correctamente.")
                CargarGrid(Nothing, False)
            End If
        Catch ex As Exception
            MostrarAlerta("danger", "Error al reactivar: " & ex.Message)
        End Try
    End Sub

    Private Sub EliminarDefinitivo(idAeropuerto As Integer)
        Try
            Dim params As New List(Of OracleParameter)
            params.Add(New OracleParameter("p_id_aeropuerto", OracleDbType.Int32) With {.Value = idAeropuerto})
            DatabaseHelper.ExecuteNonQuery("PKG_AERO_AEROPUERTOS", "pr_eliminar_definitivo", params)
            MostrarAlerta("success", "Aeropuerto eliminado definitivamente.")
            CargarGrid(Nothing, True)
        Catch ex As Exception
            MostrarAlerta("danger", "Error al eliminar: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        txtIata.Text = ""
        txtIcao.Text = ""
        txtNombre.Text = ""
        txtNombreCorto.Text = ""
        txtLatitud.Text = ""
        txtLongitud.Text = ""
        txtAltitud.Text = ""
        ddlTipo.SelectedIndex = 0
        ddlEsHub.SelectedValue = "N"
        ddlActivo.SelectedValue = "S"
        hfIdAeropuerto.Value = "0"
    End Sub

    Private Sub MostrarAlerta(tipo As String, mensaje As String)
        Dim titulo As String = ""
        Select Case tipo
            Case "success" : titulo = "Éxito"
            Case "danger"  : titulo = "Error"
            Case "warning" : titulo = "Advertencia"
            Case "info"    : titulo = "Información"
        End Select
        Dim script = String.Format("showToast('{0}', '{1}', '{2}');", tipo, titulo, mensaje.Replace("'", "\'"))
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "toast_" & DateTime.Now.Ticks.ToString(), script, True)
    End Sub

End Class

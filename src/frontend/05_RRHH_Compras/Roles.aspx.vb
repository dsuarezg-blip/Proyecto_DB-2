Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration

Partial Class Roles
    Inherits System.Web.UI.Page

    Private ReadOnly ConnWrite As String = WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
    Private ReadOnly ConnRead  As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarGrid()
    End Sub

    Private Sub CargarGrid()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_ROLES_SIST", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            gvRoles.DataSource = dt : gvRoles.DataBind()
        End Using
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        If txtNombreRol.Text.Trim() = "" Then
            MostrarAlerta("Ingrese el nombre del rol.", "warning") : Return
        End If
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_CREAR_ROL_SIST", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_nombre_rol",  OracleDbType.Varchar2).Value = txtNombreRol.Text.Trim().ToUpper()
            cmd.Parameters.Add("p_descripcion", OracleDbType.Varchar2).Value = If(txtDescripcion.Text.Trim() = "", DBNull.Value, txtDescripcion.Text.Trim())
            cmd.Parameters.Add("p_nivel",       OracleDbType.Decimal).Value  = CInt(ddlNivel.SelectedValue)
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Rol creado correctamente.", "success")
                txtNombreRol.Text = "" : txtDescripcion.Text = ""
                CargarGrid()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Protected Sub gvRoles_Command(sender As Object, e As CommandEventArgs)
        If e.CommandName = "VerPermisos" Then
            Dim idRol As Integer = CInt(e.CommandArgument)
            Using con As New OracleConnection(ConnRead)
                Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_PERMISOS_ROL", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_id_rol", OracleDbType.Decimal).Value = idRol
                Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
                con.Open()
                Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
                gvPermisos.DataSource = dt : gvPermisos.DataBind()

                ' Buscar nombre del rol en el grid
                For Each row As GridViewRow In gvRoles.Rows
                    If gvRoles.DataKeys IsNot Nothing Then
                        Dim cellId As String = row.Cells(0).Text
                        If cellId = idRol.ToString() Then
                            lblRolNombre.Text = row.Cells(1).Text
                            Exit For
                        End If
                    End If
                Next
                lblRolNombre.Text = "ID " & idRol.ToString()
                pnlPermisos.Visible = True
            End Using
        End If
    End Sub

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible = True : pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4" : lblAlerta.Text = msg
    End Sub
End Class

Imports Oracle.ManagedDataAccess.Client
Imports System.Data
Imports System.Web.Configuration
Imports System.Security.Cryptography
Imports System.Text

Partial Class Usuarios
    Inherits System.Web.UI.Page

    Private ReadOnly ConnWrite As String = WebConfigurationManager.ConnectionStrings("AeroGTConnection").ConnectionString
    Private ReadOnly ConnRead  As String = WebConfigurationManager.ConnectionStrings("AeroGTReadOnly").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then : CargarEmpleados() : CargarRoles() : CargarGrid() : End If
    End Sub

    Private Sub CargarEmpleados()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_EMPLEADOS", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_estado",   OracleDbType.Varchar2).Value = "ACTIVO"
            cmd.Parameters.Add("p_id_depto", OracleDbType.Decimal).Value  = DBNull.Value
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            ddlEmpleado.Items.Clear() : ddlEmpleado.Items.Add(New ListItem("— Seleccionar —", ""))
            For Each row As DataRow In dt.Rows
                ddlEmpleado.Items.Add(New ListItem(row("nombre_completo").ToString(), row("id_empleado").ToString()))
            Next
        End Using
    End Sub

    Private Sub CargarRoles()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_ROLES_SIST", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            ddlRol.Items.Clear() : ddlRol.Items.Add(New ListItem("— Seleccionar —", ""))
            For Each row As DataRow In dt.Rows
                ddlRol.Items.Add(New ListItem(row("nombre_rol").ToString(), row("id_rol").ToString()))
            Next
        End Using
    End Sub

    Private Sub CargarGrid()
        Using con As New OracleConnection(ConnRead)
            Dim cmd As New OracleCommand("PKG_RRHH_QRY.SP_LISTAR_USUARIOS_SIST", con)
            cmd.CommandType = CommandType.StoredProcedure
            Dim pC As New OracleParameter("p_cursor", OracleDbType.RefCursor) : pC.Direction = ParameterDirection.Output : cmd.Parameters.Add(pC)
            con.Open()
            Dim da As New OracleDataAdapter(cmd) : Dim dt As New DataTable : da.Fill(dt)
            gvUsuarios.DataSource = dt : gvUsuarios.DataBind()
        End Using
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        If ddlEmpleado.SelectedValue = "" OrElse txtUsername.Text.Trim() = "" OrElse txtPassword.Text = "" OrElse ddlRol.SelectedValue = "" Then
            MostrarAlerta("Complete todos los campos.", "warning") : Return
        End If
        Dim hashPwd As String = BitConverter.ToString(SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(txtPassword.Text))).Replace("-", "").ToLower()
        Using con As New OracleConnection(ConnWrite)
            Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_CREAR_USUARIO", con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("p_id_empleado", OracleDbType.Decimal).Value  = CInt(ddlEmpleado.SelectedValue)
            cmd.Parameters.Add("p_username",    OracleDbType.Varchar2).Value = txtUsername.Text.Trim()
            cmd.Parameters.Add("p_password",    OracleDbType.Varchar2).Value = hashPwd
            cmd.Parameters.Add("p_id_rol",      OracleDbType.Decimal).Value  = CInt(ddlRol.SelectedValue)
            Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
            Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
            con.Open() : cmd.ExecuteNonQuery()
            If CInt(pRes.Value) = 1 Then
                MostrarAlerta("Usuario creado correctamente.", "success") : CargarGrid()
            Else
                MostrarAlerta(pMsg.Value.ToString(), "danger")
            End If
        End Using
    End Sub

    Protected Sub gvUsuarios_Command(sender As Object, e As CommandEventArgs)
        If e.CommandName = "Toggle" Then
            Dim partes() As String = e.CommandArgument.ToString().Split("|")
            Dim idUsuario As Integer = CInt(partes(0))
            Dim nuevoEstado As String = If(partes(1) = "ACTIVO", "INACTIVO", "ACTIVO")
            Using con As New OracleConnection(ConnWrite)
                Dim cmd As New OracleCommand("PKG_RRHH_TRX.SP_CAMBIAR_ESTADO_USUARIO", con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("p_id_usuario", OracleDbType.Decimal).Value  = idUsuario
                cmd.Parameters.Add("p_estado",     OracleDbType.Varchar2).Value = nuevoEstado
                Dim pRes As New OracleParameter("p_resultado", OracleDbType.Decimal) : pRes.Direction = ParameterDirection.Output : cmd.Parameters.Add(pRes)
                Dim pMsg As New OracleParameter("p_mensaje", OracleDbType.Varchar2, 500) : pMsg.Direction = ParameterDirection.Output : cmd.Parameters.Add(pMsg)
                con.Open() : cmd.ExecuteNonQuery()
                MostrarAlerta(If(CInt(pRes.Value) = 1, "Estado actualizado.", pMsg.Value.ToString()), If(CInt(pRes.Value) = 1, "success", "danger"))
                CargarGrid()
            End Using
        End If
    End Sub

    Private Sub MostrarAlerta(msg As String, tipo As String)
        pnlAlerta.Visible = True : pnlAlerta.CssClass = "alert alert-" & tipo & " alert-dismissible fade show mb-4" : lblAlerta.Text = msg
    End Sub
End Class

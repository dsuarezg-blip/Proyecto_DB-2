Public Class Proveedores
    Inherits System.Web.UI.Page

    Private _dao As New FlotaDAO()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then CargarProveedores()
    End Sub

    Private Sub CargarProveedores()
        Try
            gvProveedores.DataSource = _dao.ObtenerProveedores()
            gvProveedores.DataBind()
        Catch ex As Exception
            MostrarMensaje(lblMensajeProv, "Error al cargar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnGuardarProv_Click(sender As Object, e As EventArgs)
        Try
            If txtNombreProv.Text.Trim() = "" Then
                MostrarMensaje(lblMensajeProv, "El nombre del proveedor es obligatorio.", False)
                Return
            End If
            Dim msg As String = _dao.RegistrarProveedor(
                txtNombreProv.Text.Trim(),
                CInt(txtPaisProv.Text),
                txtContactoProv.Text.Trim(),
                txtEmailProv.Text.Trim(),
                txtTelProv.Text.Trim())
            MostrarMensaje(lblMensajeProv, msg, True)
            CargarProveedores()
        Catch ex As Exception
            MostrarMensaje(lblMensajeProv, "Error: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnAsignarProv_Click(sender As Object, e As EventArgs)
        Try
            If txtIdAvionProv.Text.Trim() = "" OrElse
               txtIdProvAsign.Text.Trim() = "" Then
                MostrarMensaje(lblMensajeAsign,
                    "ID Avión e ID Proveedor son obligatorios.", False)
                Return
            End If
            Dim msg As String = _dao.AsignarProveedorAvion(
                CInt(txtIdAvionProv.Text),
                CInt(txtIdProvAsign.Text),
                ddlTipoServicio.SelectedValue)
            MostrarMensaje(lblMensajeAsign, msg, True)
        Catch ex As Exception
            MostrarMensaje(lblMensajeAsign, "Error: " & ex.Message, False)
        End Try
    End Sub

    Private Sub MostrarMensaje(lbl As Label, msg As String, exito As Boolean)
        lbl.Text = msg
        lbl.CssClass = "alerta alerta-visible " &
                       If(exito, "alerta-exito", "alerta-error")
    End Sub

End Class
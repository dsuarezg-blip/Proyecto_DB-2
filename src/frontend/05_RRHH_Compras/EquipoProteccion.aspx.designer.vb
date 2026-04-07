Option Strict On
Option Explicit On

Partial Class EquipoProteccion
    Protected WithEvents pnlAlerta         As Global.System.Web.UI.WebControls.Panel
    Protected WithEvents lblAlerta         As Global.System.Web.UI.WebControls.Label
    Protected WithEvents ddlEmpleadoFiltro As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents btnFiltrar        As Global.System.Web.UI.WebControls.Button
    Protected WithEvents gvEPP             As Global.System.Web.UI.WebControls.GridView
    Protected WithEvents ddlEmpleado       As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents ddlTipoEquipo     As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents txtTalla          As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents txtDescripcion    As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents txtFechaEntrega   As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents btnGuardar        As Global.System.Web.UI.WebControls.Button
End Class

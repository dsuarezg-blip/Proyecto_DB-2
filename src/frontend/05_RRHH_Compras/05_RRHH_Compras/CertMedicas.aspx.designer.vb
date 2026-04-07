Option Strict On
Option Explicit On

Partial Class CertMedicas
    Protected WithEvents pnlAlerta          As Global.System.Web.UI.WebControls.Panel
    Protected WithEvents lblAlerta          As Global.System.Web.UI.WebControls.Label
    Protected WithEvents ddlEmpleadoFiltro  As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents ddlEstadoFiltro    As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents btnFiltrar         As Global.System.Web.UI.WebControls.Button
    Protected WithEvents gvCertMedicas      As Global.System.Web.UI.WebControls.GridView
    Protected WithEvents ddlEmpleado        As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents ddlTipoExamen      As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents txtMedico          As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents txtCentroMedico    As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents txtFechaExamen     As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents txtFechaVenc       As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents ddlResultado       As Global.System.Web.UI.WebControls.DropDownList
    Protected WithEvents txtObservaciones   As Global.System.Web.UI.WebControls.TextBox
    Protected WithEvents btnGuardar         As Global.System.Web.UI.WebControls.Button
End Class

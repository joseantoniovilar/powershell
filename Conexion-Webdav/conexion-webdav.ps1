 <#
.SYNOPSIS
    Permite mapear una unidad por Webdav

.DESCRIPTION
    Permite mapear una unidad por Webdav

.EXAMPLE
    conexion-webdav.ps1

.EXAMPLE
    conexion-webdav.ps1 -webdav "recurso webdav"

 .NOTES
    Requiere Windows PowerShell 6.1 or later. 
    Ultima actualización: 08/05/2023 (joseantonio.vilar@upm.es)
#>

param(
	#Valor por defecto de la unidad para mapear y recurso webdav
	[string]$webdav = '\\URI@ssl\remote.php\webdav'
)


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear la ventana
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Conexión recurso por Webdav"
$Form.Size = New-Object System.Drawing.Size(300,255)
$Form.StartPosition = "CenterScreen"
$Form.Topmost = $true

# Crear los elementos de la ventana
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(10,20)
$Label1.Size = New-Object System.Drawing.Size(280,20)
$Label1.Text = "Usuario:"
$Form.Controls.Add($Label1)

$TextBox1 = New-Object System.Windows.Forms.TextBox
$TextBox1.Location = New-Object System.Drawing.Point(10,40)
$TextBox1.Size = New-Object System.Drawing.Size(280,20)
$Form.Controls.Add($TextBox1)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Location = New-Object System.Drawing.Point(10,70)
$Label2.Size = New-Object System.Drawing.Size(280,20)
$Label2.Text = "Contraseña:"
$Form.Controls.Add($Label2)

$TextBox2 = New-Object System.Windows.Forms.TextBox
$TextBox2.Location = New-Object System.Drawing.Point(10,90)
$TextBox2.Size = New-Object System.Drawing.Size(280,20)
$TextBox2.PasswordChar = '*'
$Form.Controls.Add($TextBox2)

$Button1 = New-Object System.Windows.Forms.Button
$Button1.Location = New-Object System.Drawing.Point(10,180)
$Button1.Size = New-Object System.Drawing.Size(130,30)
$Button1.Text = "Conectar"
$Button1.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form.Controls.Add($Button1)

$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Point(160,180)
$Button2.Size = New-Object System.Drawing.Size(130,30)
$Button2.Text = "Cancelar"
$Button2.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form.Controls.Add($Button2)

# Mostrar la ventana
$Form.AcceptButton = $Button1
$Form.CancelButton = $Button2
$Form.ShowDialog() | Out-Null

# Obtener los datos introducidos
if ($Form.DialogResult -eq [System.Windows.Forms.DialogResult]::OK)
{
    $username = $TextBox1.Text
    $password = $TextBox2.Text
    # Realizar la conexión WebDAV con los datos introducidos
    # New-PSDrive -Name "u" -Root "\\URI@ssl\remote.php\webdav" -PSProvider "FileSystem" -Credential $cred 
    & cmd.exe /c net use * ${webdav} /user:${username} ${password} /persist:yes
}



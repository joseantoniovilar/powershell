

<#
.SYNOPSIS
    Muestra informacion de ls usarios locales

.DESCRIPTION
    Muestra los usarios de un equipo, el último logon y a los grupos locales que pertenece 

.EXAMPLE
	 winusers.ps1

.NOTES
   Requiere Windows PowerShell 6.1 or later
   Ultima actualización: 14/12/2021 (joseantonio.vilar@upm.es)
#>

$Grupos_locales = Get-LocalGroup
$grupos = @()

$usuarios_locales = Get-LocalUser | where-object { $_.Enabled -eq "True"} | Select Name,LastLogon
foreach ($usuario in $usuarios_locales) {
    foreach ($lgrupo in $Grupos_locales){
        $user_grupo = (Get-LocalGroupMember -Name $lgrupo | Select Name) -match $usuario.Name
            if ($user_grupo){
                $grupos += $lgrupo.Name + " " 
            }
        }
    write-host  $usuario.Name $usuario.LastLogon $grupos
}




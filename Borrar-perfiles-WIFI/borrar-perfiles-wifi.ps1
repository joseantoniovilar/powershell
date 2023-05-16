<#
.SYNOPSIS
  Borra todo los perfiles del interfaz Wifi de usuario

.NOTES
  Version:        1.0
  Author:         joseantonio.vilar@upm.es
  Creation Date:  20/07/2021
   
#>

$net = netsh wlan show profiles | select-string 'Perfil de todos los usuarios'

if($net.Count -gt 0) {
 	$(foreach ($n in $net) {
    		$n.Line.Split(':')[1].Trim() | netsh wlan delete profile name = "$_"
  	}
} else {
	write-host "No se ha dectectado perfiles de interfaz Wifi de usuario" -ForegroundColor Green
}
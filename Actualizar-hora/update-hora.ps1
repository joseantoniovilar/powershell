<#
.SYNOPSIS
	Actualiza la hora del equipo utilizando el servidor de la hora hora.noa.es o otro sever

.DESCRIPTION
	

.EXAMPLE
	

.NOTES
   Requiere Windows PowerShell 6.1 or later
   Autor: joseantonio.vilar@upm.es
   Fecha: 08/ABR/2024
#>



# Detener el servicio
Stop-Service w32time

#Configurar el servidor de la hora.
if (Test-Connection -ComputerName "hora.roa.es" -Quiet) 
{ 
    $ServidorTiempo = "hora.roa.es" 
} else {
    $ServidorTiempo = "otro.server.ntp" 
}

# Sincronizar el reloj 
w32tm /config /manualpeerlist:$TimeServer /syncfromflags:manual /reliable:yes /update

# Reiniciar el servicio
Restart-Service w32time

#Actualizamos los datos
w32tm /config /update
w32tm /resync /rediscover:1 



<#
.SYNOPSIS
	Detecta si hay que actualizar la hora del equipo. Servidores hora.noa.es y tic.upm.es

.DESCRIPTION
	

.EXAMPLE
	

.NOTES
   Requiere Windows PowerShell 6.1 or later
   Autor: joseantonio.vilar@upm.es
   Fecha: 08/ABR/2024
#>


Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$(get-date -Format "yyyyMMdd-HHmmss")_detectar_update-hora.log" -Force

#Configurar el servidor de la hora.
if (Test-Connection -ComputerName "hora.roa.es" -Quiet) 
{ 
    $ServidorTiempo = "hora.roa.es" 
} else {
    $ServidorTiempo = "otro.server.ntp" 
}

# Obtiene la hora actual del servidor de tiempo
try {
    $datatimeServidor = w32tm /stripchart /computer:$ServidorTiempo /samples:1 /dataonly
    $horaServidor = ($datatimeServidor[2]).Trim('La hora actual es ').trim('.') | Get-Date
}
catch {
    Write-Host "Error al obtener la hora del servidor de tiempo. Verifica la conexión de red y el servidor especificado."
    exit
}

$HoraSistema = Get-Date 
$Diferencia = $HoraSistema - $HoraServidor
#Margen de error permitido en segundos
$MargenError = 60

# Verifica si la diferencia de tiempo está dentro del margen de error permitido
if ($Diferencia.TotalSeconds -le $MargenError -and $Diferencia.TotalSeconds -ge (-$MargenError)) {
    Write-Host "La hora del sistema está sincronizada correctamente con el servidor de tiempo $ServidorTiempo."
    Stop-Transcript
    Exit 0
} else {
    Write-Host "La hora del sistema no está sincronizada correctamente con el servidor de tiempo $ServidorTiempo."
    Write-Host "Diferencia de tiempo: $($Diferencia.TotalSeconds) segundos."
    Stop-Transcript
    Exit 1
}




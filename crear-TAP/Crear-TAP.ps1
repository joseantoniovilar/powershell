<#
.SYNOPSIS
	Genera pases temporales para AzureAD - TAP AzureAD

.DESCRIPTION
	Permite generar pases temporales para que un usuario pueda autenticarse en AzureAD.
	También, permite recuperar su cuenta si ha perdido 2FA. 
	Lee un ficehro csv como argumento con el siguiente formato: email usuario,"01/01/2023 12:00:00" para generar TAP masivos.
	El email principal del usuario y la fecha con hora que el TAP empezará a estar activo.

.EXAMPLE
	.\Crea-TAP.ps1 -infilecsv "nombre csv con los datos" -outfilecsv "nombre del csv para los tap" 

.NOTES
   Requiere Windows PowerShell 6.1 or later
   Autor: joseantonio.vilar@upm.es
   Fecha: 20/10/2023
#>

param
(
    [Parameter(Mandatory=$true, HelpMessage="Falta fichero csv que contiene los upn y fecha para generar los pases.")]
    [string]$infilecsv, 
	[Parameter(Mandatory=$true, HelpMessage="Falta fichero csv para almacenar los TAP generados.")]
	[string]$outfilecsv,
	[Parameter(Mandatory=$true, HelpMessage="Falta la clave para acceder a la aplicación.")]
	[string]$pass 
)

#Instala MS Graph si no esta instalado 
if (Get-InstalledModule Microsoft.Graph) {
    Write-Host "Microsoft Graph esta instalado"
} 
else {
    try {
        Install-Module Microsoft.Graph -Scope AllUsers
    }
    catch [Exception] {
        $_.message 
        exit
    }
}


#Uninstall-Module Microsoft.Graph -AllVersions
Import-Module Microsoft.Graph.Identity.SignIns


#Datos de la app registrada an azuread
$clientId = ""
$tenantId = ""


#Conectando con la aplicación
try
{
	$ClientSecretCredential = Get-Credential $clientId
	# Introduce el secreto de la aplicación cliente	
	Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $ClientSecretCredential
}
catch
{
	Write-Host $_.Exception.Message
}
finally 
{
	# Crear un pase temporal para el usuario (UPN)
	Write-Host "Generando los pases de acceso temporal..."
	Import-CSV -Path $infilecsv -Header 'UPN','FECHA' | ForEach {
		$parametros = @{
			startDateTime = [System.DateTime]::Parse($_.FECHA)
			lifetimeInMinutes = 60 #Timepo de vida
			isUsableOnce = $true # De un solo uso
		}

		#TAP por cada usuario
		$email = $_.UPN
		$tap = New-MgUserAuthenticationTemporaryAccessPassMethod -UserId $_.UPN -BodyParameter $parametros| Select-Object  TemporaryAccessPass,StartDateTime,LifetimeInMinutes 

		New-Object -TypeName PSObject -Property @{
			Email = $email
			TemporaryAccessPass =$tap.TemporaryAccessPass
			StartDateTime = $tap.StartDateTime
			LifetimeInMinutes = $tap.LifetimeInMinutes
		} | Export-Csv -Path $outfilecsv -Append -Force -UseQuotes Never
	}

	$contTAP=(Get-Content $outfilecsv).Length
	Write-Host  -NoNewline "Pases de acceso temporal generados: "
	Write-Host -ForegroundColor Green $contTAP
}

Disconnect-MgGraph


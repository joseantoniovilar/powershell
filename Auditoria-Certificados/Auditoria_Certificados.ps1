<#
.SYNOPSIS
Audita los ceritficados del equipo

.DESCRIPTION

Audita los certfiicados del equipo y lo almacena en una unidad de red

.NOTES
Autor joseantonio.vilar@upm.es 10-09-2018

#>

$LetraUnidadDisco = "Unidad"
$RutaFichero = "\\Ruta compartida"
$CredencialesDisco = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "138.4.241.43\auditoria",(ConvertTo-SecureString "*Aud123-" -AsPlainText -Force))

New-PSDrive -Name $LetraUnidadDisco -PSProvider FileSystem -Root $RutaFichero -Persist -Credential $CredencialesDisco

$CSVContenido = @()
$CertCurrentUser = ChildItem -Recurse Cert:\CurrentUser\My -Verbose
$CertLocalMachine = ChildItem -Recurse Cert:\LocalMachine\My -Verbose
$Certificados = $CertCurrentUser + $CertLocalMachine

$Usuario = $env:USERNAME
$Grupo = (GWMI WIN32_ComputerSystem).Domain
$Equipo = $env:COMPUTERNAME
$IP =  (Invoke-WebRequest http://whatismyip.akamai.com/ -UseBasicParsing).Content

$i = 0
ForEach ($Object in $Certificados) {
    $ObjectCert = New-Object -TypeName PSObject
    $ObjectCert | Add-Member -Type NoteProperty -Name Usuario -Value $Usuario
    $ObjectCert | Add-Member -Type NoteProperty -Name Grupo -Value $Grupo
    $ObjectCert | Add-Member -Type NoteProperty -Name Equipo -Value $Equipo
    $ObjectCert | Add-Member -Type NoteProperty -Name IP -Value $IP

    $ObjectCert | Add-Member -Type NoteProperty -Name SubjectEquipo -Value $Certificados[$i].Subject
    $ObjectCert | Add-Member -Type NoteProperty -Name ThumbprintEquipo  -Value $Certificados[$i].Thumbprint
    
    $i++
    
    $CSVContenido += $ObjectCert
}

$CSVContenido | Export-CSV -Path ($RutalFichero + $env:USERNAME + "-" + $env:COMPUTERNAME + ".csv") -NoTypeInformation -Delimiter ";" -Force

Remove-PSDrive -Name $LetraUnidadDisco

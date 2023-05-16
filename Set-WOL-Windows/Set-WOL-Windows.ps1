<#

.SYNOPSIS
Activa Wake On LAN en la tarjeta de Red Windows

.DESCRIPTION

Configura la administración de energía de las tarjeta(s) de red para permitir el uso de WOL

El script
1. Permitir que este dispositivo reactive el equipo
2. Permitir que un paquete mágico "Magic Packet" reactive el equipo
3. "Activar inicio rápido" desactivado

.NOTES
Autor joseantonio.vilar@upm.es 23-10-2020

#>

#Activando WakePME y Magic Packet en la tarjetas Intel
Get-NetAdapter -Physical -Name Ethe* | % { if ($_.InterfaceDescription -like '*Intel*') {
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "EnablePME" -RegistryValue "1"
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "*WakeOnMagicPacket" -RegistryValue "1"
    Set-NetAdapterPowerManagement  -Name "Ethe*" -DeviceSleepOnDisconnect Disabled -WakeOnMagicPacket Enabled -WakeOnPattern Enabled
}}

#Activando S5Wakeonlan y Magic Packet en la tarjetas Realtek
Get-NetAdapter -Physical -Name Ethe* | % { if ($_.InterfaceDescription -like '*Realtek*') {
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "S5WakeOnLan" -RegistryValue "1"
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "*WakeOnMagicPacket" -RegistryValue "1"  
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "WolShutdownLinkSpeed" -RegistryValue "0"
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "EEE" -RegistryValue "1"
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "EnableGreenEthernet" -RegistryValue "1"
    Set-NetAdapterAdvancedProperty -Name "Ethe*" -RegistryKeyword "*SpeedDuplex" -RegistryValue "0"
    Set-NetAdapterPowerManagement  -Name "Ethe*" -DeviceSleepOnDisconnect Disabled -WakeOnMagicPacket Enabled  -WakeOnPattern Enabled
}}




#Activando la gestión de energia en la tarjetas de Red
#Get-CimInstance -ClassName "MSPower_DeviceWakeEnable" -Namespace "root/wmi" |  Set-CimInstance  -Property @{Enable = $true }
#Get-CimInstance -ClassName "MSNdis_DeviceWakeOnMagicPacketOnly" -Namespace "root/wmi" |  Set-CimInstance  -Property @{Active = $false }

# Desactiva inicio rapido
If ((Get-CimInstance -ClassName Win32_OperatingSystem).Caption -match "Windows 8")
{
    powercfg -h off
}
ElseIf ((Get-CimInstance -ClassName Win32_OperatingSystem).Caption -match "Windows 10")
{
 
    $GetHiberbootEnabled = Get-ItemProperty "hklm:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -ErrorAction SilentlyContinue
    If ($GetHiberbootEnabled.HiberbootEnabled -eq 1)
    {
        Set-ItemProperty -Path $GetHiberbootEnabled.PSPath -Name "HiberbootEnabled" -Value 0 -Type DWORD -Force | Out-Null
    }
    Else
    {
    }
}


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



# SIG # Begin signature block
# MIIdQgYJKoZIhvcNAQcCoIIdMzCCHS8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNGL92MnML+XnwsxqyK+PHP9q
# joWgghidMIIDtzCCAp+gAwIBAgIQDOfg5RfYRv6P5WD8G/AwOTANBgkqhkiG9w0B
# AQUFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMDYxMTEwMDAwMDAwWhcNMzExMTEwMDAwMDAwWjBlMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3Qg
# Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCtDhXO5EOAXLGH87dg
# +XESpa7cJpSIqvTO9SA5KFhgDPiA2qkVlTJhPLWxKISKityfCgyDF3qPkKyK53lT
# XDGEKvYPmDI2dsze3Tyoou9q+yHyUmHfnyDXH+Kx2f4YZNISW1/5WBg1vEfNoTb5
# a3/UsDg+wRvDjDPZ2C8Y/igPs6eD1sNuRMBhNZYW/lmci3Zt1/GiSw0r/wty2p5g
# 0I6QNcZ4VYcgoc/lbQrISXwxmDNsIumH0DJaoroTghHtORedmTpyoeb6pNnVFzF1
# roV9Iq4/AUaG9ih5yLHa5FcXxH4cDrC0kqZWs72yl+2qp/C3xag/lRbQ/6GW6whf
# GHdPAgMBAAGjYzBhMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0G
# A1UdDgQWBBRF66Kv9JLLgjEtUYunpyGd823IDzAfBgNVHSMEGDAWgBRF66Kv9JLL
# gjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEAog683+Lt8ONyc3pklL/3
# cmbYMuRCdWKuh+vy1dneVrOfzM4UKLkNl2BcEkxY5NM9g0lFWJc1aRqoR+pWxnmr
# EthngYTffwk8lOa4JiwgvT2zKIn3X/8i4peEH+ll74fg38FnSbNd67IJKusm7Xi+
# fT8r87cmNW1fiQG2SVufAQWbqz0lwcy2f8Lxb4bG+mRo64EtlOtCt/qMHt1i8b5Q
# Z7dsvfPxH2sMNgcWfzd8qVttevESRmCD1ycEvkvOl77DZypoEd+A5wwzZr8TDRRu
# 838fYxAe+o0bJW1sj6W3YQGx0qMmoRBxna3iw/nDmVG3KwcIzi7mULKn+gpFL6Lw
# 8jCCBP4wggPmoAMCAQICEA1CSuC+Ooj/YEAhzhQA8N0wDQYJKoZIhvcNAQELBQAw
# cjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
# d3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVk
# IElEIFRpbWVzdGFtcGluZyBDQTAeFw0yMTAxMDEwMDAwMDBaFw0zMTAxMDYwMDAw
# MDBaMEgxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjEgMB4G
# A1UEAxMXRGlnaUNlcnQgVGltZXN0YW1wIDIwMjEwggEiMA0GCSqGSIb3DQEBAQUA
# A4IBDwAwggEKAoIBAQDC5mGEZ8WK9Q0IpEXKY2tR1zoRQr0KdXVNlLQMULUmEP4d
# yG+RawyW5xpcSO9E5b+bYc0VkWJauP9nC5xj/TZqgfop+N0rcIXeAhjzeG28ffnH
# bQk9vmp2h+mKvfiEXR52yeTGdnY6U9HR01o2j8aj4S8bOrdh1nPsTm0zinxdRS1L
# sVDmQTo3VobckyON91Al6GTm3dOPL1e1hyDrDo4s1SPa9E14RuMDgzEpSlwMMYpK
# jIjF9zBa+RSvFV9sQ0kJ/SYjU/aNY+gaq1uxHTDCm2mCtNv8VlS8H6GHq756Wwog
# L0sJyZWnjbL61mOLTqVyHO6fegFz+BnW/g1JhL0BAgMBAAGjggG4MIIBtDAOBgNV
# HQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDBBBgNVHSAEOjA4MDYGCWCGSAGG/WwHATApMCcGCCsGAQUFBwIBFhtodHRwOi8v
# d3d3LmRpZ2ljZXJ0LmNvbS9DUFMwHwYDVR0jBBgwFoAU9LbhIB3+Ka7S5GGlsqIl
# ssgXNW4wHQYDVR0OBBYEFDZEho6kurBmvrwoLR1ENt3janq8MHEGA1UdHwRqMGgw
# MqAwoC6GLGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtdHMu
# Y3JsMDKgMKAuhixodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVk
# LXRzLmNybDCBhQYIKwYBBQUHAQEEeTB3MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
# cC5kaWdpY2VydC5jb20wTwYIKwYBBQUHMAKGQ2h0dHA6Ly9jYWNlcnRzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydFNIQTJBc3N1cmVkSURUaW1lc3RhbXBpbmdDQS5jcnQw
# DQYJKoZIhvcNAQELBQADggEBAEgc3LXpmiO85xrnIA6OZ0b9QnJRdAojR6OrktIl
# xHBZvhSg5SeBpU0UFRkHefDRBMOG2Tu9/kQCZk3taaQP9rhwz2Lo9VFKeHk2eie3
# 8+dSn5On7UOee+e03UEiifuHokYDTvz0/rdkd2NfI1Jpg4L6GlPtkMyNoRdzDfTz
# ZTlwS/Oc1np72gy8PTLQG8v1Yfx1CAB2vIEO+MDhXM/EEXLnG2RJ2CKadRVC9S0y
# OIHa9GCiurRS+1zgYSQlT7LfySmoc0NR2r1j1h9bm/cuG08THfdKDXF+l7f0P4Tr
# weOjSaH6zqe/Vs+6WXZhiV9+p7SOZ3j5NpjhyyjaW4emii8wggUZMIIEAaADAgEC
# AhANucYRs6r/dGB7AgZevKrFMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0xNDEx
# MTgxMjAwMDBaFw0yNDExMTgxMjAwMDBaMG0xCzAJBgNVBAYTAk5MMRYwFAYDVQQI
# Ew1Ob29yZC1Ib2xsYW5kMRIwEAYDVQQHEwlBbXN0ZXJkYW0xDzANBgNVBAoTBlRF
# UkVOQTEhMB8GA1UEAxMYVEVSRU5BIENvZGUgU2lnbmluZyBDQSAzMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAquLnIC+sEJX6zSTl+KDf9aKtn7yzyeH4
# H8Q+5JZBbbvnA/AMFHG9pjhRt1A5pzn2Qm3iXMSe/6t41b1nAyHpbgTMRt/FhySU
# n/3WLAVhg5Oy9eF3ZCq61VDzttpv0Iu8fz5rAO5cszS/UMD4yPB9V350CkivbUhM
# i2+KXiO+dstdhHhWO4hnm9GIYKIIRAeIiabD8twq4HNswpuEJvcUPotKqGkI9JOJ
# 6B9p67QqdTILGY98swy4WuRGtGRrx9BQm/CAtE81cZ8gf1nIVGbszTMT3wkyhRAC
# YWg8tJIkYLqg0ry1xwe9/FDqNGAIHwKhjx+3LP1apkmAuTn6WUn5GQIDAQABo4IB
# uzCCAbcwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1Ud
# HwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwPQYDVR0gBDYwNDAyBgRVHSAA
# MCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwHQYD
# VR0OBBYEFDIKwQzBaD5XqC35eSLljpzpRI4yMB8GA1UdIwQYMBaAFEXroq/0ksuC
# MS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQBErVAKGa8D4fOknsozyzRE
# lbTq3fi5SLXlapnDtwGOrtXEcx59Wgj9Gb8gTMUBu8iy2xDJ2SsN3c5xPNxbrrln
# S++9sESYuGEp3Kh6c7IUvXQ/MFzDecAM9Fbcs/7hiXhFpYfoWSiPRIttBj+xNsQw
# 7nRsVMvEA9dveBrjbEN2FUaeIklZl0043htM0nyWG/y61+l6GDAXLNWGiS7Qmhk+
# NfLGK75RSWdJHWUhr0IiTg1NDxoC6ZuCduf8irB7dVZN6j+QD4onBFUwE3pTof72
# XqL2STlUXwPJi2o1zjCoAuBAFe0VlRAdBmPv742jmuHBWmCaMYSXufCLkCpqy8ci
# MIIFMTCCBBmgAwIBAgIQCqEl1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBl
# MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
# d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJv
# b3QgQ0EwHhcNMTYwMTA3MTIwMDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0
# YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvN
# j3/dqbqCmcU5VChXtiNKxA4HRTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfT
# w+F+CNZqFAA49y4eO+7MpvYyWf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V
# +/OjuiI+GKwR5PCZA207hXwJ0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR
# 4aF5FMZNJCMwXbzsPGBqrC8HzP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfk
# dT66mA+Ef58xFNat1fJky3seBdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/a
# rBD13ays6Vb/kwIDAQABo4IBzjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKi
# JbLIFzVuMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
# cnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRo
# dHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3JsMDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3JsMFAGA1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsG
# AQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwH
# ATANBgkqhkiG9w0BAQsFAAOCAQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/
# ys8DAv3Fp8MOIEIsr3fzKx8MIVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZ
# YuhegiUexLoceywh4tZbLBQ1QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OM
# kVIsrymJ5Xgf1gsUpYDXEkdws3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1
# t5ljhSKMYcp5lH5Z/IwP42+1ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJ
# rhO24XxCQijGGFbPQTS2Zl22dHv1VjMiLyI2skuiSpXY9aaOUjCCBYowggRyoAMC
# AQICEA38NuGjA+zB/6SFtfxdkXgwDQYJKoZIhvcNAQELBQAwbTELMAkGA1UEBhMC
# TkwxFjAUBgNVBAgTDU5vb3JkLUhvbGxhbmQxEjAQBgNVBAcTCUFtc3RlcmRhbTEP
# MA0GA1UEChMGVEVSRU5BMSEwHwYDVQQDExhURVJFTkEgQ29kZSBTaWduaW5nIENB
# IDMwHhcNMTgwNjA1MDAwMDAwWhcNMjEwNjA5MTIwMDAwWjCB1jELMAkGA1UEBhMC
# RVMxDzANBgNVBAgTBk1hZHJpZDEPMA0GA1UEBxMGTWFkcmlkMSswKQYDVQQKDCJV
# bml2ZXJzaWRhZCBQb2xpdMOpY25pY2EgZGUgTWFkcmlkMR4wHAYDVQQLExVJbmZv
# cm1hdGljYSBSZWN0b3JhZG8xKzApBgNVBAMMIlVuaXZlcnNpZGFkIFBvbGl0w6lj
# bmljYSBkZSBNYWRyaWQxKzApBgkqhkiG9w0BCQEWHGluZm9ybWF0aWNhLnJlY3Rv
# cmFkb0B1cG0uZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDADe2t
# aFseVdtCcekwc8zK8p3CBj+xv1QaPloau9lSmL+30hjaycaA2tNlUU7rQlIfJhwf
# FwAbvQDHE7q4pv6Ab1DtoXp1uqnH8zKtpGqNh8234JRuev2IHF55bZglXC+R2lJP
# xn1wU9wr62r2xYqXdWhBgp0laimKu7eeHj6XBdhWSEFAjVuviNfWGC2L2gJ5LqJ3
# hjyKcN0AtPrqJZMeCtt05W/e3PFxdwxm6GcP8/6hbby7ebNd1G9b5JSPkMOpZCkP
# AlP3KJBUZAuscIdRDE8Jhfs1m8doMl8ocfWNl1TBSCwpnQ8d6h8lckQTWqBPqiNS
# C922l+ZfBgazL/rpAgMBAAGjggG6MIIBtjAfBgNVHSMEGDAWgBQyCsEMwWg+V6gt
# +Xki5Y6c6USOMjAdBgNVHQ4EFgQUL76wCjXXulDvMYpUmkUzq4psukwwDgYDVR0P
# AQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHsGA1UdHwR0MHIwN6A1oDOG
# MWh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9URVJFTkFDb2RlU2lnbmluZ0NBMy5j
# cmwwN6A1oDOGMWh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9URVJFTkFDb2RlU2ln
# bmluZ0NBMy5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAwEwKjAoBggrBgEFBQcC
# ARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBBAEwdgYIKwYB
# BQUHAQEEajBoMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w
# QAYIKwYBBQUHMAKGNGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9URVJFTkFD
# b2RlU2lnbmluZ0NBMy5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOC
# AQEASxtEHNC410iqn5myyHBNxRfxY5bJhZAIRFE0PIJ2BUOgGRr5fDn4Zokc14eB
# gHwZ7FURCv9t5lGWCCVKCR4zXSx4siwNT2LdSRtp0HVUXbtaCIfjYS1lJdPD1+Xp
# jQRobr92MpuO9ndtC0RBwQ6uWlr7nE4BsbHHOeyzuO2ZiJbYRLHprHMiYOEvPhpn
# qtj+MB/bA2nAHX/iblRMjvl6VF3PRKu2iG6otGkPpnC3Ekhe10bBpNyqVxJIKZpk
# 4KNr7nwgmUQpm6V5u4wj6Tjd0RiopN0xtJt3NsAFSwJLs2W8EGlx66cCT4MxcnqT
# bPgSuyGQfoANFfKO+QWYXyRQwzGCBA8wggQLAgEBMIGBMG0xCzAJBgNVBAYTAk5M
# MRYwFAYDVQQIEw1Ob29yZC1Ib2xsYW5kMRIwEAYDVQQHEwlBbXN0ZXJkYW0xDzAN
# BgNVBAoTBlRFUkVOQTEhMB8GA1UEAxMYVEVSRU5BIENvZGUgU2lnbmluZyBDQSAz
# AhAN/DbhowPswf+khbX8XZF4MAkGBSsOAwIaBQCgQDAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAjBgkqhkiG9w0BCQQxFgQUzMSgASSqfreqYWUOkkdxt+M37wIw
# DQYJKoZIhvcNAQEBBQAEggEAWYeL2WJNJJ/21FPkl6ahRgEM1pad6CkpAcpuyLM8
# e0Hg+u4Mtw35Yw1Ul17n9cS5jXHud4zBK11AjfpzFufzhJJE7CZaDuH01+JMaAkI
# aGhaQtIoMVcPeTJ+VfHmrplM4vPward2dYCCWy1ktDUPSlQJ2um1TWIApXXluHuy
# cK6MBzI3tF4KBFe3HM+P+XvuR1wf72S7OKXjatdScJ7zGA2yJt0SdwvWfdq1PuzQ
# Mn+3ZededXXCd4ntVqdyPY3+eK9jSX5smieHbmIJn05yMUSRUhS0iPOGuD35G7UV
# S6/vJjj1AZnxQGEecppOA2K4JVSc+51ssPhoA+n8FJdpH6GCAiAwggIcBgkqhkiG
# 9w0BCQYxggINMIICCQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhE
# aWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhANQkrgvjqI
# /2BAIc4UAPDdMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0yMTAyMTEwODA1NTdaMCMGCSqGSIb3DQEJBDEWBBQH
# wNIxAistP7wHQ872EiXUikwCYjANBgkqhkiG9w0BAQEFAASCAQBlXgo4v49DDajT
# oNIzpUDjuILrCPhJdAIBiJMhaKEsMuByyvUazwL4gkOKvxiw9ndrnawcEJH+I2c6
# xZsL4AFqu6R2UnVA3WgDdfLZn28i55pVrAcFzKfESau19qY+aDw/NmNL85/DL1Ei
# +H6mCeTmY+Z9c20LGbx55s7Z00PxojksN6CcfvJ0d64OzG6k4qKeSdNRige93AYi
# MDPe/XfTHnGaZHs6O9e3NbzXKTEkyPrIA0FXY4uSBsqzXtgcSEby0brMr++n5Si3
# Rlb+U6m1w2d6sjmGyf+aKpAKA49IvFmyB67EcR1B0qvasdEjgnPRQkcSGL+BcuNE
# SYX2WMhS
# SIG # End signature block

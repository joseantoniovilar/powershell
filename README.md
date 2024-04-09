# Recursos powershell

### Estructura del repositorio

```
powershell
|   LICENSE
|   readme.md			              <- Fichero que describe los recusrsos.
|
+---Actualiza-hora
|       detectar-update-hora.ps1            <- Detecta si el equipo no tiene configurado la hora
|       update-hora.ps1                     <- Configura la hora con un servidor ntp
|    
+---Auditoria-Certificados
|       Auditoria_Certificados.ps1            <- Audita los cerificados instalados en un equipo
|    
+---Borrar-perfiles-WIFI                      <- Borra los perfiles WIFI
|       borrar-perfiles-wifi.ps1
|
+---Conexion-Webdav                           <- Permite a un usuario conectrse a recurso webdav
|       conexion-webdav.ps1      
|
+---Configurador_Impresoras                    <- Permite instalar el driver y configurar la impresora desde un csv
|       innstalar-impresora.ps1
|
+---Set-NombrePC                              <- Pone nombre al computador utilizando el numero de serie del equipo
|       set-nombrepc.ps1
|       
+---Set-WOL-Windows                           <- Configura WOL
|       Set-WOL-Windows.ps1
|      
+---Crear-TAP                                 <- Genera Pases de Acceso Temporal (TAP) desde un csv para AzureAD
|       Set-WOL-Windows.ps1
| 
\---winusers                                  <- Muestra los usuarios locales y grupos a los que pertenece
        winusers.ps1
```

## Authors

[Jose Antonio Vilar](joseantonio.vilar@upm.es)

## License

[MIT](https://choosealicense.com/licenses/mit/)

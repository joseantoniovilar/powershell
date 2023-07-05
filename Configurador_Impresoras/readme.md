## El script instalar-impresora.ps1

Este PowerShell script lee desde un fichero csv los datos necesarios para descarga, instalar y configurar la impresora. 
Instala el driver y configura la impresora con la direccion IP y Puerto de impresion en el equipos. Permite hacer seleccion multiples de impresoras

La estructura del csv
"Modelo_Impresora","url_DriverImpresora" (formato zip),"Nombre_Impresora","Direccion_IP","Puerto_Impresora","Ubicacion","Descripcion"

## Example
PS> ./instalar-impresora.ps1 (ruta decto del csv)

## Example
PS> ./instalar-impresora.ps1 -filecsv "ruta del csv con los datos de las impresoras"

## Notes
Author: Jose Antonio Vilar | License: MIT

## Related Links
[https://github.com/fleschutz/PowerShell](https://github.com/joseantoniovilar/powershell/edit/main/Configurador_Impresoras)https://github.com/joseantoniovilar/powershell/edit/main/Configurador_Impresoras

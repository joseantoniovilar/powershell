
<#
.SYNOPSIS
	Instala y configurar un impresora en el equipo 

.DESCRIPTION
	Permite instalar impresoras en el equipo leyendo los datos desde un fichero csv

.EXAMPLE
	instalar-impresora

.EXAMPLE
	instalar-impresora -filecsv "ruta del csv con los datos de las impresoras"


.NOTES
   Requiere Windows PowerShell 6.1 or later
   Autor: joseantonio.vilar@upm.es
   Fecha: 05/07/2023
#>

#[CmdletBinding()]
param(
    #Valor por defecto
    #[Parameter(Mandatory)]
    [string]$filecsv = ".\csv\impresoras.csv" #valor por defecto
)

Function instalaImpresora {
param (
        [string]$url = ""
)
    $RutaLocal = "$env:USERPROFILE\Downloads\"
    $zipFile = $RutaLocal + "impresora.zip"
    $zipTemp = "$env:temp\impresosa.zip"

    try {
        Invoke-WebRequest -Uri $url -OutFile $zipFile 
    }
    catch {
       write-host $_.Exception.Massage -BackgroundColor DarkRed
    }
    finally {
        $zipFile | Expand-Archive -DestinationPath $zipTemp -Force 
    }

    # Añadir a la lista de impresoras disponibles
    try {
        # Añade el driver al almacen. 
        pnputil.exe /add-driver "$zipTemp\*.inf" /subdirs
        #Add-PrinterDriver -Name $modeloImpresora -ErrorAction Stop
    }
    catch {
        write-host $_.Exception.Massage -BackgroundColor DarkRed
    }
    finally {
        $zipFile | Remove-Item -ErrorAction SilentlyContinue -Force
        $zipTemp | Remove-Item -ErrorAction SilentlyContinue -Force -Recurse 
    } 
}


#utiliza los datos almacenados en el csv
Function Set-Impresora {
Param (
        [string]$modeloImpresora,
        [string]$nombreImpresora,
        [string]$ipImpresora, 
        [string]$puertoImpresora = 9100
)

        if ($null -eq (Get-Printer -name $nombreImpresora -ErrorAction SilentlyContinue)) {
            if ($null -eq (Get-PrinterPort -name $puertoImpresora -ErrorAction SilentlyContinue )) {
                
                try {
                    # Add-PrinterPort -Name "LocalPort:" -ErrorAction SilentlyContinue -Verbose
                    Add-PrinterPort -Name $nombreImpresora -PrinterHostAddress $ipImpresora -PortNumber $puertoImpresora -ErrorAction SilentlyContinue
                }
                catch{
                    write-host $_.Exception.Massage -BackgroundColor DarkRed
                }
            }
            try{
                #Añade la impresora en el equipo
                Add-Printer -DriverName $modeloImpresora -Name $nombreImpresora -PortName $nombreImpresora -ErrorAction stop
            }
            catch{
                write-host $_.Exception.Massage -BackgroundColor DarkRed
            }
        } else {
            Write-host "La impresora $modeloImpresora y $nombreImpresora ya está instalada" -BackgroundColor DarkGreen 
        }
}


$Header="Modelo_Impresora","url_DriverImpresora","Nombre_Impresora","Direccion_IP","Puerto_Impresora","Ubicacion","Descripcion"
$impresorasDetalles = import-csv -Path $filecsv -Delimiter ";" -Header $Header 

$impresoras = $impresorasDetalles | Out-GridView -Title "Selecciona impresora (selección multiple utiliza la tecla ctrl) para instalar y configurar en el equipo" -OutputMode Multiple

Foreach ($impresora in $impresoras) {

    if ($null -eq (Get-PrinterDriver -Name $impresora.'Modelo_Impresora' -ErrorAction SilentlyContinue)) {
        instalaImpresora -url $impresora.'url_DriverImpresora'
    }
    Set-Impresora -modeloImpresora  $impresora.'Modelo_Impresora' -nombreImpresora $impresora.'Nombre_Impresora' -ipImpresora $impresora.'Direccion_IP' -puertoImpresora $impresora.'Puerto_Impresora' 
}

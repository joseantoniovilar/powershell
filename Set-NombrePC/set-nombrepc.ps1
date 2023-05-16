<#
.SYNOPSIS
Establece el nombre de la computadora

.DESCRIPTION

Establece el nombre de la computardoara utilizando el numnero de serie y añade una D si es un desktop ó una P es un portátil

.NOTES
Autor joseantonio.vilar@upm.es 01-10-2021
#>

$nserie = Get-WmiObject win32_bios | Select-Object -ExpandProperty SerialNumber
$nserie_tam = $nserie.Length
$serie5 = $nserie.Substring($nserie_tam-5)
$nombreportatil = 'P' + $serie5
$nombredesktop = 'D' + $serie5


if(Get-WmiObject -Class win32_systemenclosure |  Where-Object {$_.chassistypes -eq 8 -or $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14}) {
   $esPortatil = $true 
 }

if($esPortatil){
    
    rename-computer -NewName $nombreportatil -ErrorAction Ignore -WarningAction SilentlyContinue

}else{
    
   rename-computer -NewName $nombredesktop -ErrorAction Ignore -WarningAction SilentlyContinue
}


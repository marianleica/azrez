$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "azgroup-delete"
Write-Output "Deleting deployment resource group.."
az group delete -n azrez --yes --no-wait
Start-Sleep 5

# Logging
Write-Output "${timestamp}; {${scenario}; RG: azrez; Operation: Deleting resource group}" >> C:\azrez\azrez.log

$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "azgroup-delete"
Write-Output "Deleting deployment resource group.."
az group delete -n azrez --yes --no-wait
Start-Sleep 5

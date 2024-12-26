Write-Output "Creating an Azure Container Registry (ACR)"
Start-Sleep -Seconds 1

# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario="azacr-public"
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
#suffix=$((10000 + RANDOM % 99999))
$rg="azrez"
$location="uksouth"
$acr="azacr-public-${suffix}"
$acrpath=${acr}.azurecr.io

# Create the ACR resource
az acr create -n $acr -g $rg --sku Premium

# Add a basic image to the repository
az acr import -n $acr --source docker.io/library/hello-world:latest -t $acrpath:test1

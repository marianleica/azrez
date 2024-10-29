# Setting variables
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-kubenetlb-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster ${AKS} in resource group ${RG}"
# Create new Resource Group
# az group create -g $RG -l $location
Write-Output "The Resource Group:"
az group create -g $RG -l $location

Write-Output ""
Write-Output "The AKS cluster:"
# Create AKS cluster
# az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 1
az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 1

Start-Sleep -Seconds 5
Write-Output ""

# Get the AKS infrastructure resource group name
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
Write-Output "The infrastructure resource group is ${infra_rg}"

# Start-Sleep 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
Write-Output "You should be able to run kubectl commands to your cluster now"

Write-Output ""
Read-Host "Press any key to continue..."

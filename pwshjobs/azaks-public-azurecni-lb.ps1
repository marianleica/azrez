# Setting variables
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-azurecni-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster "{$AKS}" in resource group "{$RG}""
# Create new Resource Group
Write-Output "The resource group: "
# az group create -g $RG -l $location
az group create -n $RG -l $location
Write-Output ""

# Create virtual network and subnets
Write-Output "The BYO VNET: "
# az network vnet create --resource-group $RG --name aksVnet --address-prefixes 10.0.0.0/8 --subnet-name aks_subnet --subnet-prefix 10.240.0.0/16

az network vnet create --resource-group $RG --name aksVnet --address-prefixes 10.0.0.0/8 --subnet-name aks_subnet --subnet-prefix 10.240.0.0/16

Write-Output ""
Write-Output "The BYO VNET subnet: "

az network vnet subnet create --resource-group $RG --vnet-name aksVnet --name vnode_subnet --address-prefixes 10.241.0.0/16

# Create AKS cluster
$subnetId=$(az network vnet subnet show --resource-group $RG --vnet-name aksVnet --name aks_subnet --query id -o tsv)

Write-Output ""
Start-Sleep 2

Write-Output "The AKS cluster: "
# az aks create --resource-group $RG --name $AKS --node-count 1 --network-plugin azure --vnet-subnet-id $subnetId --enable-aad --generate-ssh-keys
az aks create --resource-group $RG --name $AKS --node-count 1 --network-plugin azure --vnet-subnet-id $subnetId --enable-aad --generate-ssh-keys

Start-Sleep -Seconds 5
# Wait for the AKS cluster creation to be in Running state
# aksextension=$(az aks show --resource-group $aksClusterGroupName --name $aksName --query id --output tsv)
# az resource wait --ids $aksextension --custom "properties.provisioningState!='Creating'"

# Get the AKS infrastructure resource group name
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
Write-Output "The infrastructure resource group is {$infra_rg}"

# sleep 1
# echo "Let's see if you have 'kubectl' installed locally. Please ignore any errors."
# Install kubectl locally:
# az aks install-cli

Write-Output ""
Start-Sleep -Seconds 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
# az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
# Setting variables
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-azurecni-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster {$AKS} in resource group {$RG}"
# Create new Resource Group
Write-Output "The resource group: "
# az group create -g $RG -l $location
New-AzResourceGroup -Name $RG -Location $location
Write-Output ""

# Create virtual network and subnets
Write-Output "The BYO VNET: "
# az network vnet create --resource-group $RG --name aksVnet --address-prefixes 10.0.0.0/8 --subnet-name aks_subnet --subnet-prefix 10.240.0.0/16

$vnet = @{
    Name = "aks_VNET"
    ResourceGroupName = $RG
    Location = $location
    AddressPrefix = '10.0.0.0/8'
}
$virtualNetwork = New-AzVirtualNetwork @vnet

Write-Output ""
Write-Output "The BYO VNET subnet: "

$subnet = @{
    Name = "aks_subnet"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.240.0.0/16'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet

# az network vnet subnet create --resource-group $RG --vnet-name aksVnet --name vnode_subnet --address-prefixes 10.241.0.0/16

# Associate the subnet and VNET
$virtualNetwork | Set-AzVirtualNetwork

# Create AKS cluster
$subnetId=$(az network vnet subnet show --resource-group $RG --vnet-name aksVnet --name aks_subnet --query id -o tsv)

Write-Output ""
Start-Sleep 2

Write-Output "The AKS cluster: "
# az aks create --resource-group $RG --name $AKS --node-count 1 --network-plugin azure --vnet-subnet-id $subnetId --enable-aad --generate-ssh-keys
New-AzAksCluster -ResourceGroupName $RG -Name $AKS -NodeCount 1 -EnableManagedIdentity -GenerateSshKey -NetworkPlugin azure

Start-Sleep -Seconds 5
# Wait for the AKS cluster creation to be in Running state
# aksextension=$(az aks show --resource-group $aksClusterGroupName --name $aksName --query id --output tsv)
# az resource wait --ids $aksextension --custom "properties.provisioningState!='Creating'"

# Get the AKS infrastructure resource group name
# $infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
# echo "The infrastructure resource group is $infra_rg"

# sleep 1
# echo "Let's see if you have 'kubectl' installed locally. Please ignore any errors."
# Install kubectl locally:
# az aks install-cli

Write-Output ""
Start-Sleep -Seconds 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
# az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
Import-AzAksCredential -ResourceGroupName $RG -Name $AKS -Admin
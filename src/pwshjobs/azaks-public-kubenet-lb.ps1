# Setting variables
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-kubenetlb-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster $AKS in resource group $RG"
# Create new Resource Group
# az group create -g $RG -l $location
Write-Output "The Resource Group:"
New-AzResourceGroup -Name $RG -Location $location
Write-Output ""
Write-Output "The AKS cluster:"
# Create AKS cluster
# az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 1
New-AzAksCluster -ResourceGroupName $RG -Name $AKS -NodeCount 1 -EnableManagedIdentity -GenerateSshKey

Start-Sleep -Seconds 5
# Wait for the AKS cluster creation to be in Running state
# aksextension=$(az aks show --resource-group $aksClusterGroupName --name $aksName --query id --output tsv)
# az resource wait --ids $aksextension --custom "properties.provisioningState!='Creating'"
Write-Output ""
# Get the AKS infrastructure resource group name
# $infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
# Write-Output "The infrastructure resource group is $infra_rg"

# sleep 1
# echo "Let's see if you have 'kubectl' installed locally. Please ignore any errors."
# Install kubectl locally:
# az aks install-cli

# Start-Sleep 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
# az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
Import-AzAksCredential -ResourceGroupName $RG -Name $AKS -Admin
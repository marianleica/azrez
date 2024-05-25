# Setting variables
namesuffix=$((10000 + RANDOM % 99999))
RG="azresourcelauncher" # Name of resource group for the AKS cluster
location="uksouth" # Name of the location 
AKS="aks-kubenetlb-${namesuffix}" # Name of the AKS cluster

echo "Creating AKS cluster $AKS in resource group $RG"
# Create new Resource Group
az group create -g $RG -l $location

# Create AKS cluster
az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 1

sleep 5
# Wait for the AKS cluster creation to be in Running state
# aksextension=$(az aks show --resource-group $aksClusterGroupName --name $aksName --query id --output tsv)
# az resource wait --ids $aksextension --custom "properties.provisioningState!='Creating'"

# Get the AKS infrastructure resource group name
infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
echo "The infrastructure resource group is $infra_rg"

# sleep 1
# echo "Let's see if you have 'kubectl' installed locally. Please ignore any errors."
# Install kubectl locally:
# az aks install-cli

sleep 1
echo "Configuring "kubectl" to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
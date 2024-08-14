# Setting variables
namesuffix=$((10000 + RANDOM % 99999))
RG="azrez" # Name of resource group for the AKS cluster
location="uksouth" # Name of the location 
AKS="aks-azurecni-${namesuffix}" # Name of the AKS cluster

echo "Creating AKS cluster $AKS in resource group $RG"
# Create new Resource Group
echo "The resource group: "
az group create -g $RG -l $location

echo ""

# Create virtual network and subnets
echo "The BYO VNET: "
az network vnet create --resource-group $RG --name aksVnet --address-prefixes 10.0.0.0/8 --subnet-name aks_subnet --subnet-prefix 10.240.0.0/16
echo ""

echo "the BYO VNET subnet: "
az network vnet subnet create --resource-group $RG --vnet-name aksVnet --name vnode_subnet --address-prefixes 10.241.0.0/16

# Create AKS cluster
subnetId=$(az network vnet subnet show --resource-group $RG --vnet-name aksVnet --name aks_subnet --query id -o tsv)

echo ""
sleep 2

echo "The AKS cluster: "
az aks create --resource-group $RG --name $AKS --node-count 1 --network-plugin azure --vnet-subnet-id $subnetId --enable-aad --generate-ssh-keys

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

echo ""
sleep 1
echo "Configuring kubectl to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
echo "You can start running kubectl commands on the created cluster"
sleep 10
# Setting variables
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-azurecni-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster ${AKS} in resource group ${RG}"
# Create new Resource Group
Write-Output "The resource group: "
# az group create -g $RG -l $location
az group create -n $RG -l $location
Write-Output ""

# Create virtual network and subnets
Write-Output "The BYO VNET: "
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
az aks create --resource-group $RG --name $AKS --node-count 1 --network-plugin azure --vnet-subnet-id $subnetId --enable-aad --generate-ssh-keys --enable-private-cluster 

Start-Sleep -Seconds 5

# Get the AKS infrastructure resource group name
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
Write-Output "The infrastructure resource group is ${infra_rg}"

Write-Output ""
Start-Sleep -Seconds 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing

# Creating a new subnet for the Jumpbox VM
az network vnet subnet create --resource-group $RG --vnet-name aksVnet --name vm_subnet --address-prefixes 10.250.0.0/24
Start-Sleep -Seconds 3

# Setting variables for Jumpbox VM
$VM="azvm-ubuntu-${suffix}"
$image="Ubuntu2204"
$userName = "azrez"
$subnetIdVM=$(az network vnet subnet show --resource-group $RG --vnet-name aksVnet --name vm_subnet --query id -o tsv)
Start-Sleep -Seconds 2

# Creating Ubuntu VM in the respective subnet
Write-Output "Creating virtual machine ${VM} in resource group ${RG} in location ${location}"
Start-Sleep -Seconds 1
Write-Output ""
az vm create -n $VM -g $RG --image $image --generate-ssh-keys --admin-username $userName --size Standard_D2s_v3 --nsg-rule ssh --public-ip-sku Standard --vnet-name aksVnet --subnet vm_subnet

Start-Sleep -Seconds 2
# This is the public IP address
$vmip=$(az vm list-ip-addresses -g $RG -n $VM --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The public IP address allocated to VM ${VM} is ${vmip}"
Write-Output "Save aside your credentials"
Write-Output "The admin user name is: ${userName}"
Write-Output ""
Write-Output "To install Azure CLI on the Ubuntu JumpBox VM:"
Write-Output "apt-get update && apt-get install curl"
Write-Output "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
Write-Output "Install kubectl on the Ubuntu JumpBox VM:"
Write-Output "curl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'"
Write-Output ""
Write-Output "Then to connect to the AKS cluster, run:"
Write-Output "az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing"
Start-Sleep -Seconds 1

# Look for user input to perform ssh connection right now
$userinput = Read-Host -Prompt "Do you want to connect to ${VM} via ssh now? (y/n)"
if ($userinput -eq "y"){az ssh vm -g $RG -n $VM --local-user $userName}
else {Write-Output "Save the command for later: az ssh vm -g ${RG} -n ${VM} --local-user ${userName}""}

Start-Sleep -Seconds 1
Write-Output ""

Read-Host "Press any key to exit..."
#####################################

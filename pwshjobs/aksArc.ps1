# Progress bar variables
$progress = 0
$progressIncrement = 100 / 8

# Setting variables
Write-Output "Setting variables"
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "aksarc"
$suffix=$(Get-Random -Minimum 1000 -Maximum 9999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-kubenetlb-${suffix}" # Name of the AKS cluster

$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Setting variables" -PercentComplete $progress

Write-Output "Creating AKS cluster ${AKS} in resource group ${RG}"

# Create new Resource Group
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Creating Resource Group" -PercentComplete $progress

az group create -g $RG -l $location -o none

# Create AKS cluster
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Creating AKS Cluster" -PercentComplete $progress
az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 2 -o none
Start-Sleep -Seconds 2

# Get the AKS infrastructure resource group name
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Getting Infrastructure Resource Group" -PercentComplete $progress
Write-Output "The infrastructure resource group is ${infra_rg}"

Start-Sleep -Seconds 1
Write-Output "Getting kubeconfigs for the AKS cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing -o none

$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Getting Kubeconfigs" -PercentComplete $progress

Start-Sleep -Seconds 1
Write-Output "Onboarding cluster ${AKS} to Azure Arc-enabled Kubernetes"
# Onboarding the cluster to Azure Arc-enabled Kubernetes
$ARC="arc-aks-${suffix}" # Name of the ARC cluster
az extension add --name connectedk8s
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Onboarding to Azure Arc" -PercentComplete $progress

az connectedk8s connect --resource-group $RG --name $ARC -l westeurope -o yamlc
Write-Output ""
Write-Output "AKS cluster ${AKS} has been created and onboarded to Azure Arc-enabled Kubernetes as ${ARC}"

# Logging
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Logging" -PercentComplete $progress

if (Test-Path -Path "C:\" -ErrorAction SilentlyContinue) {
    Write-Output "${timestamp}; {${scenario}; ARC: ${RG}; Location: ${location}; ResType: AKS; ResName: ${AKS}; ConnectedCluster: ${ARC}}" >> C:\azrez\azrez.log
} else {
    Write-Output "C drive not found, skipping logging."
}

$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Completed" -PercentComplete $progress
Read-Host "Press any key to continue..."
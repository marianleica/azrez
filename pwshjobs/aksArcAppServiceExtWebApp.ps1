# Progress bar
$progress = 0
$progressIncrement = 100 / 15

# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "aksArcAppServiceExtWebApp"
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
az group create -g $RG -l $location

# Create AKS cluster
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Creating AKS Cluster" -PercentComplete $progress
az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 2

Start-Sleep -Seconds 1

# Get the AKS infrastructure resource group name
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Getting Infrastructure Resource Group" -PercentComplete $progress
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
Write-Output "The infrastructure resource group is ${infra_rg}"

Start-Sleep -Seconds 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Configuring kubectl" -PercentComplete $progress
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "Onboarding cluster ${AKS} to Azure Arc-enabled Kubernetes"
# Onboarding the cluster to Azure Arc-enabled Kubernetes
$ARC="arc-aks-${suffix}" # Name of the ARC cluster
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Onboarding to Azure Arc" -PercentComplete $progress
az extension add --upgrade --name connectedk8s
az connectedk8s connect --resource-group $RG --name $ARC -l westeurope
az provider register --namespace Microsoft.Web --wait

Start-Sleep -Seconds 1
Write-Output ""

# Install the appservice extension:
$extensionName="appservice-ext" # Name of the App Service extension
$namespace="appservice-ns" # Namespace in your cluster to install the extension and provision resources
$kubeEnvironmentName="kube-environment" # Name of the App Service Kubernetes environment resource

Write-Progress -Activity "Script Progress" -Status "Installing App Service Extension" -PercentComplete $progress
$progress += $progressIncrement
az k8s-extension create --resource-group $RG --name $extensionName --cluster-type connectedClusters --cluster-name $ARC --extension-type 'Microsoft.Web.Appservice' --release-train stable --auto-upgrade-minor-version true --scope cluster --release-namespace $namespace --configuration-settings "Microsoft.CustomLocation.ServiceAccount=default" --configuration-settings "appsNamespace=${namespace}" --configuration-settings "clusterName=${kubeEnvironmentName}" --configuration-settings "keda.enabled=true" --configuration-settings "buildService.storageClassName=default" --configuration-settings "buildService.storageAccessMode=ReadWriteOnce" --configuration-settings "customConfigMap=${namespace}/kube-environment-config" --configuration-settings "envoy.annotations.service.beta.kubernetes.io/azure-load-balancer-resource-group=${aksClusterGroupName}"

Start-Sleep -Seconds 5
Write-Output ""
# Save the id of the appservice extension for the next step:
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Waiting for Extension Installation" -PercentComplete $progress
$extensionId=$(az k8s-extension show --cluster-type connectedClusters --cluster-name $ARC --resource-group $RG --name $extensionName --query id --output tsv)
# Wait for the fully install before proceeding:
az resource wait --ids $extensionId --custom "properties.installState!='Pending'" --api-version "2020-07-01-preview"

Start-Sleep -Seconds 5
Write-Output ""

# Create a custom location
# Set the required variables:
$customLocationName="arc-location" # Name of the custom location
$connectedClusterId=$(az connectedk8s show --resource-group $RG --name $ARC --query id --output tsv)

# Create the custom location:
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Creating Custom Location" -PercentComplete $progress
az customlocation create --resource-group $RG --name $customLocationName --host-resource-id $connectedClusterId --namespace $namespace --cluster-extension-ids $extensionId --location westeurope

Start-Sleep -Seconds 5
Write-Output ""
# Validate the custom location creation:
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Validating Custom Location" -PercentComplete $progress
az customlocation show --resource-group $RG --name $customLocationName
# Save the custom location ID for the next step:
$customLocationId=$(az customlocation show --resource-group $RG --name $customLocationName --query id --output tsv)

# Create the App Service Kubernetes Environment
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Creating App Service Kubernetes Environment" -PercentComplete $progress
az appservice kube create --resource-group $RG --name $kubeEnvironmentName --custom-location $customLocationId

Start-Sleep -Seconds 5
Write-Output ""
# Validate that the App Service Kubernetes Environment has been successfully created:
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Validating App Service Kubernetes Environment" -PercentComplete $progress
az appservice kube show --resource-group $RG --name $kubeEnvironmentName

Start-Sleep -Seconds 1
Write-Output ""
# Generating web app name - it has to be unique
$appname="webapp-${suffix}"

# Creating webapp in the custom location
$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Creating Web App" -PercentComplete $progress
az webapp create --resource-group $RG --name $appname --custom-location $customLocationId --runtime 'NODE:20-lts'

Start-Sleep -Seconds 5
Write-Output ""
Write-Output "The webapp ${appname} is now created."
Write-Output "To provide code to the webapp, you may use the example below:"
Write-Output ""
Write-Output "git clone https://github.com/Azure-Samples/nodejs-docs-hello-world"
Write-Output "cd nodejs-docs-hello-world"
Write-Output "zip -r package.zip ."
Write-Output "az webapp deployment source config-zip --resource-group ${RG} --name ${appname} --src package.zip"

$progress += $progressIncrement
Write-Progress -Activity "Script Progress" -Status "Completed" -PercentComplete $progress

Write-Output ""
Write-Output "You should be able to run kubectl commands to your cluster now"
Read-Host "Press any key to continue..."

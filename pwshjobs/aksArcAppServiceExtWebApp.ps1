# Setting variables
$suffix=$(Get-Random -Minimum 1000 -Maximum 9999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-kubenetlb-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster ${AKS} in resource group ${RG}"
# Create new Resource Group
az group create -g $RG -l $location

# Create AKS cluster
az aks create --resource-group $RG --name $AKS --enable-aad --enable-azure-rbac --generate-ssh-keys --enable-addons monitoring --node-count 1

Start-Sleep -Seconds 5
# Wait for the AKS cluster creation to be in Running state
# aksextension=$(az aks show --resource-group $aksClusterGroupName --name $aksName --query id --output tsv)
# az resource wait --ids $aksextension --custom "properties.provisioningState!='Creating'"

# Get the AKS infrastructure resource group name
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
Write-Output "The infrastructure resource group is ${infra_rg}"

# sleep 1
# echo "Let's see if you have 'kubectl' installed locally. Please ignore any errors."
# Install kubectl locally:
# az aks install-cli

Start-Sleep -Seconds 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "Onboarding cluster ${AKS} to Azure Arc-enabled Kubernetes"
# Onboarding the cluster to Azure Arc-enabled Kubernetes
$ARC="arc-aks-${suffix}" # Name of the ARC cluster
az extension add --upgrade --name connectedk8s
az connectedk8s connect --resource-group $RG --name $ARC
az provider register --namespace Microsoft.Web --wait

Start-Sleep -Seconds 5
Write-Output ""
Write-Output "The azure-arc namespace status:"
# Showcase the azure-arc namespace
az aks command invoke --resource-group $RG --name $AKS --command "kubectl get all -n azure-arc"
Write-Output ""

# Setting variables:
$extensionName="appservice-ext" # Name of the App Service extension
$namespace="appservice-ns" # Namespace in your cluster to install the extension and provision resources
$kubeEnvironmentName="kube-environment" # Name of the App Service Kubernetes environment resource

# Install the appservice extension:
az k8s-extension create --resource-group $RG --name $extensionName --cluster-type connectedClusters --cluster-name $ARC --extension-type 'Microsoft.Web.Appservice' --release-train stable --auto-upgrade-minor-version true --scope cluster --release-namespace $namespace --configuration-settings "Microsoft.CustomLocation.ServiceAccount=default" --configuration-settings "appsNamespace=${namespace}" --configuration-settings "clusterName=${kubeEnvironmentName}" --configuration-settings "keda.enabled=true" --configuration-settings "buildService.storageClassName=default" --configuration-settings "buildService.storageAccessMode=ReadWriteOnce" --configuration-settings "customConfigMap=${namespace}/kube-environment-config" --configuration-settings "envoy.annotations.service.beta.kubernetes.io/azure-load-balancer-resource-group=${aksClusterGroupName}"

Start-Sleep -Seconds 5
Write-Output ""
# Save the id of the appservice extension for the next step:
$extensionId=$(az k8s-extension show --cluster-type connectedClusters --cluster-name $clusterName --resource-group $groupName --name $extensionName --query id --output tsv)

# Wait for the fully install before proceeding:
az resource wait --ids $extensionId --custom "properties.installState!='Pending'" --api-version "2020-07-01-preview"
Start-Sleep -Seconds 5
Write-Output ""

# Step 1.3 - Create a custom location
# Set the required variables:
$customLocationName="arc-location" # Name of the custom location
$connectedClusterId=$(az connectedk8s show --resource-group $RG --name $clusterName --query id --output tsv)

# Create the custom location:
az customlocation create --resource-group $RG --name $customLocationName --host-resource-id $connectedClusterId --namespace $namespace --cluster-extension-ids $extensionId

Start-Sleep -Seconds 5
Write-Output ""
# Validate the custom location creation:
az customlocation show --resource-group $RG --name $customLocationName

# Save the custom location ID for the next step:
$customLocationId=$(az customlocation show --resource-group $RG --name $customLocationName --query id --output tsv)

# Step 1.4 - Create the App Service Kubernetes Environment
az appservice kube create --resource-group $RG --name $kubeEnvironmentName --custom-location $customLocationId

Start-Sleep -Seconds 5
Write-Output ""
# Validate that the App Service Kubernetes Environment has been successfully created:
az appservice kube show --resource-group $RG --name $kubeEnvironmentName

Start-Sleep -Seconds 1
Write-Output ""
# Generating web app name - it has to be unique
$appname="webapp-${suffix}"

# Creating webapp in the custom location
az webapp create --resource-group $RG --name $appname --custom-location $customLocationId --runtime 'NODE|12-lts'`

Start-Sleep -Seconds 5
Write-Output ""
Write-Output "The webapp ${appname} is now created."
Write-Output "To provide code to the webapp, you may use the example below:"
Write-Output ""
Write-Output "git clone https://github.com/Azure-Samples/nodejs-docs-hello-world"
Write-Output "cd nodejs-docs-hello-world"
Write-Output "zip -r package.zip ."
Write-Output "az webapp deployment source config-zip --resource-group ${RG} --name ${appname} --src package.zip"

Write-Output ""
Read-Host "Press any key to continue..."

# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "azaks-public-lb-ilb"
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
$RG="azrez" # Name of resource group for the AKS cluster
$location="uksouth" # Name of the location 
$AKS="aks-azurecni-${suffix}" # Name of the AKS cluster

Write-Output "Creating AKS cluster ${AKS} in resource group ${RG}"
# Create new Resource Group
Write-Output "The resource group: "
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
az aks create --resource-group $RG --name $AKS --node-count 1 --network-plugin azure --vnet-subnet-id $subnetId --enable-aad --generate-ssh-keys
Start-Sleep -Seconds 5

# Get the AKS infrastructure resource group name
$infra_rg=$(az aks show --resource-group $RG --name $AKS --output tsv --query nodeResourceGroup)
Write-Output "The infrastructure resource group is ${infra_rg}"

Write-Output ""
Start-Sleep -Seconds 1
Write-Output "Configuring kubectl to connect to the Kubernetes cluster"
# echo "If you want to connect to the cluster to run commands, run the following:"
# az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
az aks get-credentials --resource-group $RG --name $AKS --admin --overwrite-existing
Write-Output "You should be able to run kubectl commands to your cluster now"
Write-Output ""
Write-Output "Install kubectl locally, if needed: az aks install-cli"
Write-Output ""

# Deploy application and NodePort services

kubectl create deploy tstapp1 --image=nginx:alpine --replicas 2 --port 80
kubectl create deploy tstapp2 --image=nginx --replicas 2 --port 80

kubectl expose deploy tstapp1 --type NodePort --port 80
kubectl expose deploy tstapp2 --type NodePort --port 80

# Deploy ILB for the NodePort services
# kubectl apply -f - <<EOF
# apiVersion: v1
# kind: Service
# metadata:
#   name: tstapp1-ilb
#   annotations:
#     service.beta.kubernetes.io/azure-load-balancer-ipv4: 10.240.0.50
#     service.beta.kubernetes.io/azure-load-balancer-internal: "true"
# spec:
#   type: LoadBalancer
#   ports:
#   - port: 80
#     targetPort: 80
#     nodePort: 30557
#   selector:
#     app: tstapp1
# ---
# apiVersion: v1
# kind: Service
# metadata:
#   name: tstapp2-ilb
#   annotations:
#     service.beta.kubernetes.io/azure-load-balancer-ipv4: 10.240.0.51
#     service.beta.kubernetes.io/azure-load-balancer-internal: "true"
# spec:
#   type: LoadBalancer
#   ports:
#   - port: 80
#     targetPort: 80
#     nodePort: 30558
#   selector:
#     app: tstapp2
# EOF

$ilbservice = @"
apiVersion: v1
kind: Service
metadata:
  name: tstapp1-ilb
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-ipv4: 10.240.0.50
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30557
  selector:
    app: tstapp1
---
apiVersion: v1
kind: Service
metadata:
  name: tstapp2-ilb
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-ipv4: 10.240.0.51
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30558
  selector:
    app: tstapp2
"@

$ilbservice | kubectl apply -f -

Read-Host "Press any key to continue..."




#################################

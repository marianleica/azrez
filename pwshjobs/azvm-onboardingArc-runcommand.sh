# Get the arguments from the runtime
clientId=$1
clientSecret=$2
tenantId=$3

# Installing Helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo sh ./get_helm.sh
sleep 1

# Installing Azure CLI
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sleep 1

# Login to Azure with the pre-created service principal
az login --service-principal --username $clientId --password $clientSecret --tenant $tenantId

sleep 1
# Run the onboarding command
az connectedk8s connect -g azrez -n kubeadm-connected

sleep 2
# Check the status
# kubectl get all -n azure-arc

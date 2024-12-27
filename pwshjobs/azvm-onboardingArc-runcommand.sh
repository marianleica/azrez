# Installing Helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo sh ./get_helm.sh

# Installing Azure CLI
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to Azure
az login

# Run the onboarding command
az connectedk8s connect -g azrez -n kubeadm-connected

# Check the status
kubectl get all -n azure-arc

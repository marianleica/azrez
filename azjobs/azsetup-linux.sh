echo "Performing initial setup"
sleep 2
echo "Installing AZCLI latest version"
curl -L https://aka.ms/InstallAzureCli | bash

sleep 2
echo "Confirming AZCLI is installed"
az version

sleep 1
echo "Please login to Azure:"
az login

sleep 4
# (*) Commenting the following lines since the new az login functionality
# makes you choose the subscription in a better way
############################################
# echo "These are the subscriptions associated with your account:"
# az account list -o table
# sleep 1
# read -p "Please choose your subscription from the list above and paste it here: " subscriptionid
# echo "Setting the subscription $subscriptionid for use"
# az account set --subscription $subscriptionid

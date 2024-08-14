# Setting variables
namesuffix=$((10000 + RANDOM % 99999))
RG="azrez"
VM="VM-${namesuffix}"
location="uksouth"

echo "Creating $VM in resource group $RG"
echo "Showing below the operation JSON output:"
# Create resource group
echo "The resource group:"
az group create -n $RG -l $location
sleep 5 # this is just to have the time for the resource group to create

# Create VM
echo "The virtual machine:"
az vm create -n $VM -g $RG --image Ubuntu2204 --generate-ssh-keys --admin-username bestuser --size Standard_D2s_v3 --nsg-rule ssh --public-ip-sku Standard

sleep 5

# Grab public IP address into variable
vmpip=$(az vm list-ip-addresses -g $RG -n $VM --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)

sleep 5
echo "The VM's public IP address is $vmpip"
sleep 1
echo "Do you want to connect to $VM via ssh now? (y/n)"
#!/bin/bash
read userinput

if [ $userinput = "y" ]; then
    ssh bestuser@$vmpip -o StrictHostKeyChecking=no
else
    echo "Save the command for later: ssh bestuser@$vmpip"
fi
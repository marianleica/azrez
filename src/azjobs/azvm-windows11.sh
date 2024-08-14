# Setting variables
suffix=$((100 + RANDOM % 999))
rg="azrez"
location="uksouth"
vmName=$"azvm-win11-${suffix}"
image="MicrosoftWindowsDesktop:windows-11:win11-21h2-avd:22000.1100.221015"

# To update the image version when it is being deprecated, see available images with
# az vm image list -f windows-11 -o table --all 

# Generating a random string to use as password
#!/bin/bash
array=()
for i in {a..z} {A..Z} {0..9}; 
   do
   array[$RANDOM]=$i
done
password=$(printf %s ${array[@]::30} $'\n')

echo "Creating virtual machine $vmName in resource group $rg in location $location"
sleep 1
echo ""
echo "The resource group:"
# Create RG
az group create -n $rg -l $location

# Create NSG
#az network nsg create --name NSG4VM --resource-group $rg
#az network nsg rule create \
#--name inboundrule4vm \
#--nsg-name NSG4VM \
#--priority 200 \
#--resource-group $rg \
#--access Allow \
#--destination-port-ranges 3383 \
#--direction Inbound \
#--protocol Tcp

sleep 1
echo ""
echo "The virtual machine $vmName:"
# Create Windows 11
az vm create -g $rg -n $vmName --image $image --admin-user "azrez" --admin-password $password --public-ip-sku Standard --nsg NSG4VM --nsg-rule RDP

sleep 2
# This is the public IP address
vmip=$(az vm list-ip-addresses -g $rg -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)

sleep 1
echo ""
echo "The public IP address allocated to VM $vmName is $vmip"
echo "The admin user name is: azrez"
echo "The unique password is: $password"
echo "Waiting for 15 seconds, save aside your credentials"

# Giving time to 
sleep 15

#Saved aside
############
#pwsh
#$rg='myVM'
#$location='northeurope'
#$vmName='winclient1'
#Get-AzRemoteDesktopFile -ResourceGroupName $rg -Name $vmName -Launch
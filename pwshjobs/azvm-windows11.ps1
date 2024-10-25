Write-Output "Creating Windows 11 Azure Virtual Machine"
Start-Sleep -Seconds 1

# Setting variables
$suffix=$(Get-Random -Minimum 1000 -Maximum 9999)
#suffix=$((10000 + RANDOM % 99999))
$RG="azrez"
$location="uksouth"
$VM="azvm-win11-${suffix}"
$image="MicrosoftWindowsDesktop:windows-11:win11-21h2-avd:22000.1100.221015"

# To update the image version when it is being deprecated, see available images with
# az vm image list -f windows-11 -o table --all

# Generating a random string to use as password
$userName = "azrez"
$randompass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_})
#Read more: https://www.sharepointdiary.com/2020/04/powershell-generate-random-password.html#ixzz8XiwccFos
# $password = ConvertTo-SecureString $randompass -AsPlainText -Force
# $psCred = New-Object System.Management.Automation.PSCredential($UserName, $password)

Write-Output "Creating virtual machine ${VM} in resource group ${RG} in location ${location}"
Start-Sleep -Seconds 1

Write-Output ""
Write-Output "The Resource Group:"
az group create -n $RG -l $location

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The virtual machine ${VM}:"

# Create Windows 11
# New-AzVm -ResourceGroupName $rg -Name $vmName -Location $location -Image $image -VirtualNetworkName "myVnet-${suffix}" -SubnetName "vmsubnet" -SecurityGroupName "vmNSG" -PublicIpAddressName $publicIp -OpenPorts 80,3389
az vm create -g $RG -n $VM --image $image --admin-user $userName --admin-password $randompass --public-ip-sku Standard --nsg NSG4VM --nsg-rule RDP

Start-Sleep -Seconds 2
# This is the public IP address
# $vmip=$(az vm list-ip-addresses -g $rg -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
# $vmip=$(Get-AzPublicIpAddress -Name $publicIp -ResourceGroupName $rg)
$vmip=$(az vm list-ip-addresses -g $RG -n $VM --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The public IP address allocated to VM ${VM} is ${vmip}"
Write-Output "The admin user name is: azrez"
Write-Output "The unique password is: ${randompass}"
Write-Output ""
Start-Sleep -Seconds 20
#pwsh
#$rg='myVM'
#$location='northeurope'
#$vmName='winclient1'
#Get-AzRemoteDesktopFile -ResourceGroupName $rg -Name $vmName -Launch

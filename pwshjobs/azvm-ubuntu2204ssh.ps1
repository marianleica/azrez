Write-Output "We are now creating an Azure VM running Ubuntu2204"

Write-Output "Creating Ubuntu2204 Azure Virtual Machine"
Start-Sleep -Seconds 1

# Setting variables
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
#suffix=$((10000 + RANDOM % 99999))
$RG="azrez"
$location="uksouth"
$VM="azvm-windows11-${suffix}"
$image="Ubuntu2204"
$publicIp="win11IP-${suffix}"

# Generating a random string to use as password
$UserName = "azrez"
$randompass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_})
#Read more: https://www.sharepointdiary.com/2020/04/powershell-generate-random-password.html#ixzz8XiwccFos
$Password = ConvertTo-SecureString $randompass -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($UserName, $Password)

Write-Output $"Creating virtual machine ${vmName} in resource group ${RG} in location ${location}"
Start-Sleep -Seconds 1
Write-Output ""

Write-Output "The Resource Group:"
# Create RG
az group create -n $RG -l $location
Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The virtual machine {$VM}:"

# Create Ubuntu VM
# New-AzVm -ResourceGroupName $RG -Name $vmName -Location $location -Image $image -VirtualNetworkName "myVnet-${suffix}" -SubnetName "vmsubnet" -SecurityGroupName "vmNSG" -PublicIpAddressName $publicIp -OpenPorts 80,22 -GenerateSshKey
az vm create -n $VM -g $RG --image Ubuntu2204 --generate-ssh-keys --admin-username bestuser --size Standard_D2s_v3 --nsg-rule ssh --public-ip-sku Standard

Start-Sleep -Seconds 2
# This is the public IP address
# $vmip=$(az vm list-ip-addresses -g $rg -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
$vmip=$(az vm list-ip-addresses -g $RG -n $VM --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The public IP address allocated to VM {$VM} is {$vmip}"
Write-Output "Save aside your credentials"
Write-Output "The admin user name is: {$UserName}"
Write-Output "The unique password is: {$password}"

Start-Sleep -Seconds 20
#pwsh
#$rg='myVM'
#$location='northeurope'
#$vmName='winclient1'
#Get-AzRemoteDesktopFile -ResourceGroupName $rg -Name $vmName -Launch

# Write-Output ""
# $userinput = Read-Host "Do you want to connect to $VM via ssh now? (y/n)"

#if ($userinput -eq "y") {
#   Write-Host "The value $a is greater than 2."
#}
#else {
#   Write-Host ("The value $a is less than or equal to 2," +
#       " is not created or is not initialized.")
#}

#if [ $userinput = "y" ]; then
#    ssh bestuser@$vmpip -o StrictHostKeyChecking=no
#else
#    echo "Save the command for later: ssh bestuser@$vmpip"
#fi
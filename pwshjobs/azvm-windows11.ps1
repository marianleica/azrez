Write-Output "Creating Windows 11 Azure Virtual Machine"
Start-Sleep -Seconds 1

# Setting variables
$suffix=$(Get-Random -Minimum 1000 -Maximum 9999)
#suffix=$((10000 + RANDOM % 99999))
$rg="azrez"
$location="uksouth"
$vmName="azvm-win11-${suffix}"
$image="MicrosoftWindowsDesktop:windows-11:win11-21h2-avd:22000.1100.221015"
$publicIp="win11IP-${suffix}"

# To update the image version when it is being deprecated, see available images with
# az vm image list -f windows-11 -o table --all

# Generating a random string to use as password
$UserName = "admin"
$randompass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_})
#Read more: https://www.sharepointdiary.com/2020/04/powershell-generate-random-password.html#ixzz8XiwccFos
$Password = ConvertTo-SecureString $randompass -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($UserName, $Password)

Write-Output "Creating virtual machine {$vmName} in resource group {$rg} in location {$location}"
Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The Resource Group:"
# Create RG
New-AzResourceGroup -Name $rg -Location $location
Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The virtual machine {$vmName}:"

# Create Windows 11
New-AzVm -ResourceGroupName $rg -Name $vmName -Location $location -Image $image -VirtualNetworkName "myVnet-${suffix}" -SubnetName "vmsubnet" -SecurityGroupName "vmNSG" -PublicIpAddressName $publicIp -OpenPorts 80,3389

Start-Sleep -Seconds 2
# This is the public IP address
# $vmip=$(az vm list-ip-addresses -g $rg -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
$vmip=$(Get-AzPublicIpAddress -Name $publicIp -ResourceGroupName $rg)
Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The public IP address allocated to VM {$vmName} is {$vmip}"
Write-Output "The admin user name is: azrez"
Write-Output "The unique password is: {$password}"

#pwsh
#$rg='myVM'
#$location='northeurope'
#$vmName='winclient1'
#Get-AzRemoteDesktopFile -ResourceGroupName $rg -Name $vmName -Launch